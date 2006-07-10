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

    ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Movable Type Systemüberprüfung',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Auf dieser Seite finden Sie Informationen zu Ihrer Systemkonfiguration, damit festgestellt werden kann, ob Ihr Webserver über alle notwendigen Komponenten zur Ausführung von Movable Type verfügt.',
    'System Information' => 'Systeminformation',
    'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
    'MT home directory:' => 'MT Home-Verzeichnis:',
    'Operating system:' => 'Betriebssystem:',
    'Perl version:' => 'Perl-Version:',
    'Perl include path:' => 'Perl-Include-Pfad:',
    'Web server:' => 'Webserver:',
    '(Probably) Running under cgiwrap or suexec' => '(Wahrscheinlich) ausgeführt unter cgiwrap oder suexec',
    'Checking for [_1] Modules:' => 'Überprüfung der [_1]Pakete:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Zum Ausführen von Movable Type benötigt Ihr Server bestimmte Datenbankmodule. Abhängig von der gewünschten Datenbankkonfiguration sind DB_File oder DBI gemeinsam mit mindestens einem weiteren spezifischen Modul erforderlich.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => '[_1] ist Ihrem Webserver nicht installiert oder die installierte Version ist zu alt oder [_1] benötigt ein weiteres Modul, das nicht installiert ist.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] ist entweder nicht auf Ihrem Webserver installiert oder [_1] benötigt ein weiteres Modul, das nicht installiert ist.',
    'Please consult the installation instructions for help in installing [_1].' => 'Hinweise zur Installation von [_1] finden Sie in der Dokumentation.',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Ihre DBD::mysql Version ist mit Movable Type nicht kompatibel. Bitte installieren Sie die aktuelle Version aus CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod ist korrekt installiert, erfordert aber ein aktuelleres DBI-Modul. Bitte beachten Sie oben stehende Versionshinweise.',
    'Your server has [_1] installed (version [_2]).' => '[_1] ist auf Ihrem Server installiert (Version [_2]).',
    'Movable Type System Check Successful' => 'Movable Type Systemüberprüfung erfolgreich',
    'You\'re ready to go!' => 'Ihr System ist jetzt bereit.',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Pakete sind auf Ihrem Server installiert. Sie brauchen keine weiteren Module zu installieren und können mit der Installation fortfahren.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - Previous (2)
    'This description can be localized if there is l10n_class set.' => 'Diese Beschreibung kann durch Setzen von l10n_class lokalisiert werden.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Dieser Ausdruck wird im Template verarbeitet.',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Hauptseite',
    'Tags' => 'Tags', # Translate - Previous (1)
    'Posted by [_1] on [_2]' => 'Geschrieben von [_1] am [_2]',
    'Permalink' => 'Permalink', # Translate - Previous (1)
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack URL for this entry:' => 'TrackBack-URL zu diesem Eintrag:',
    'Listed below are links to weblogs that reference' => 'Die folgenden Weblogs beziehen sich auf diesen Eintrag',
    'from' => 'von',
    'Read More' => 'Weiter lesen',
    'Tracked on' => 'Verlinkt am',
    'Comments' => 'Kommentare',
    'Posted by' => 'Von',
    'Anonymous' => 'Anonym',
    'Posted on' => 'Geschrieben am',
    'Permalink to this comment' => 'Permalink dieses Kommentars',
    'Post a comment' => 'Kommentar schreiben',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Wenn Sie auf dieser Site bisher noch nicht kommentiert haben, wird Ihr Kommentar eventuell erst zeitverzögert freigeschaltet werden. Vielen Dank für Ihre Geduld.)',
    'Name' => 'Name', # Translate - Previous (1)
    'Email Address' => 'E-Mail-Adresse',
    'URL' => 'URL', # Translate - Previous (1)
    'Remember personal info?' => 'Persönliche Angaben speichern?',
    '(you may use HTML tags for style)' => '(HTML erlaubt)',
    'Preview' => 'Vorschau',
    'Post' => 'Absenden',
    'Search' => 'Suchen',
    'Search this blog:' => 'Dieses Weblog durchsuchen:',
    'About' => 'Über diese Seite',
    'The previous post in this blog was <a href=' => 'Zuvor erschien in diesem Blog <a href=',
    'The next post in this blog is <a href=' => 'Danach erschien <a href=',
    'Many more can be found on the <a href=' => 'Viel mehr in <a href=',
    'Subscribe to this blog\'s feed' => 'Feed dieses Weblogs abonnieren',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => 'Was ist das?',
    'This weblog is licensed under a' => 'Dieser Weblog steht unter einer',
    'Creative Commons License' => 'Creative Commons-Lizenz',

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Kommentar-Fehler',
    'Your comment submission failed for the following reasons:' => 'Folgender Fehler ist beim Kommentieren aufgetreten:',
    'Return to the original entry' => 'Zurück zum Eintrag',

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Weiter lesen',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Recent Posts' => 'Aktuelle Einträge',
    'Categories' => 'Kategorien',
    'Archives' => 'Archive',

    ## ./default_templates/comment_preview_template.tmpl
    'Comment on' => 'Kommentar zu',
    'Previewing your Comment' => 'Vorschau Ihres Kommentars',
    'Cancel' => 'Abbrechen',

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Hallo ',
    '. Now you can comment. ' => '. Sie können jetzt kommentieren. ',
    'sign out' => 'abmelden',
    'You are not signed in. You need to be registered to comment on this site.' => 'Sie sind nicht angemeldet. Sie müssen sich registrieren, um hier zu kommentieren.',
    'Sign in' => 'Anmelden',
    'If you have a TypeKey identity, you can' => 'Wenn Sie TypeKey nutzen, können Sie sich',
    'sign in' => 'anmelden',
    'to use it here.' => ', um es hier zu verwenden.',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Seite nicht gefunden',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Dikussion bei [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate - Previous (2)
    'Tracked on [_1]' => 'Verlinkt am [_1]',

    ## ./default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'SEARCH FEED AUTODISCOVERY NUR ANGEZEIGT WENN SUCHE AUSGEFÜHRT',
    'Search Results' => 'Suchergebnisse',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'EINFACHE SUCHEN - EINFACHES FORMULAR',
    'Search this site' => 'Diese Site durchsuchen',
    'Match case' => 'Groß-/Kleinschreibung',
    'Regex search' => 'Regex-Suche',
    'SEARCH RESULTS DISPLAY' => 'SUCHERGEBNISSANZEIGE',
    'Matching entries from [_1]' => 'Treffer in [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Einträge aus [_1], die getaggt sind mit \'[_2]\'',
    'Posted <MTIfNonEmpty tag=' => 'Veröffentliche <MTIfNonEmpty tag=',
    'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
    'Entries matching \'[_1]\'' => 'Einträge mit \'[_1]\'',
    'Entries tagged with \'[_1]\'' => 'Einträge getaggt mit \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'Es wurden keine Seiten gefunden, die \'[_1]\' beinhalten.',
    'Instructions' => 'Anleitung',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Die Suchfunktion sucht standardmäßig nach allen angebenen Begriffen in beliebiger Reihenfolge. Um nach einem exakten Ausdruck zu suchen, setzen Sie diesen bitte in Anführungszeichen.',
    'movable type' => 'Movable Type',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt.',
    'personal OR publishing' => 'Schrank OR Schublade',
    'publishing NOT personal' => 'Regal NOT Schrank',
    'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
    'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE vs TAG-Information',
    'Subscribe to feed' => 'Feed abonnieren',
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit \'[_1]\' getaggten Einträge abonnieren.',
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit \'[_1]\' abonnieren.',
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
    'Feed Subscription' => 'Feed abonnieren',
    'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
    'Other Tags' => 'Andere Tags',
    'Other tags used on this blog' => 'Andere in diesem Blog verwendete Tags',
    'END OF PAGE BODY' => 'PAGE BODY ENDE',
    'END OF CONTAINER' => 'CONTAINER ENDE',

    ## ./default_templates/datebased_archive.tmpl
    'About [_1]' => 'Über [_1]',
    '<a href=' => '<a href=', # Translate - Previous (3)

    ## ./default_templates/category_archive.tmpl
    'Posted on [_1]' => 'Geschrieben am [_1]',

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Kommentar noch nicht freigegeben',
    'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar',
    'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar wurde gespeichert und muß nun vom Weblog-Betreiber freigegeben werden.',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archive',

    ## ./default_templates/atom_index.tmpl

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
    'Posted in [_1] on [_2]' => 'Veröffentlicht in [_1] am [_2]',
    'No results found' => 'Keine Treffer',
    'No new comments were found in the specified interval.' => 'Keine neuen Kommentare im Zeitraum.',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Gewünschten Zeitraum auswählen, dann  \'Neue Kommentare finden\' wählen',

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Suchergebnisse für [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./search_templates/default.tmpl
    'Blog Search Results' => 'Blogsuche - Ergebnisse',
    'Blog search' => 'Blogsuche',

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Fügt Hyperlinks in TrackBacks und Kommentaren das \'nofollow\'-Attribut hinzu und hilft so, Spam zu reduzieren',
    'Restrict:' => 'Einschränken:',
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Nofollow nicht hinzufügen, wenn die Links von authentifizierten Kommentarautoren stammen',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Legt Backups  vorhandener Templates an und hilft, die Einstellungen vorhandener Templates auf neue Templates zu übernehmen',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Templates sichern und erneuern',
    'No templates were selected to process.' => 'Keine Templates gewählt.',
    'Return' => 'Zurück',

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Mit Feeds.App Lite können Sie Feeds in Ihre Blogs integrieren. Noch mehr Möglichkeiten erhalten Sie durch ein',
    'Upgrade to Feeds.App' => 'Upgrade auf Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widget Creator', # Translate - Previous (5)
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Es wurden mehrere Feeds gefunden. Wählen Sie den Feed aus, den Sie verwenden wollen. Feeds.App Lite unterstützt Textfeeds in den Formaten RSS 1.0, RSS 2.0 und ATOM.',
    'Type' => 'Typ',
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Weiter',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'Keine Feeds mit [_1] gefunden.',
    'An error occurred processing [_1]. Check <a href=' => 'Beim Einlesen von [_1] trat ein Fehler auf. Beachten Sie <a href=',
    'It can be included onto your published blog using <a href=' => 'Sie können es in Ihr Blog integrieren mit <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Sie können es mit diesem MTInclude-Tag in Ihr Blog integrieren',
    'Go Back' => 'Zurück',
    'Create Another' => 'Weiteres Widget anlegen',

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Hauptmenü',
    'System Overview' => 'Systemeinstellungen',
    'Help' => 'Hilfe',
    'Welcome' => 'Willkommen',
    'Logout' => 'Abmelden',
    'Entries' => 'Einträge',
    'Search (q)' => 'Suche (q)',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite erzeugt Template-Module, die externe Feed-Daten in Ihren Blogs anzeigen. Legen Sie zuerst die Module an und binden Sie sie dann in Ihre Blog-Templates ein.',
    'You must enter an address to proceed' => 'Geben Sie eine Adresse (URL) ein',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Geben Sie die URL eines Feeds oder einer Website, die Feeds anbietet, ein:',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feed Configuration' => 'Feed-Konfiguration',
    'Feed URL' => 'Feed-URL',
    'Title' => 'Titel',
    'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Vergeben Sie einen Namen für das Widget. Dieser Name wird auch als Name des Feeds in Ihrem Blog angezeigt werden.',
    'Display' => 'Zeige',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Alle',
    'Select the maximum number of entries to display.' => 'Anzahl der Einträge, die höchstens angezeigt werden sollen.',
    'Save' => 'Speichern',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup-Modul zur Moderation und Junk-Kennzeichung von Feedback mittels Schlüsselwörter',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Link', # Translate - Previous (2)
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup-Modul zur Moderation und Junk-Kennzeichnung von Feedback mittels Linkfilter',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup-Modul zur Filterung von Feedback mittels Schwarzlisten',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Der Linkfilter prüft automatisch die Anzahl der in neuem Feedback enthaltenen Links. Sind sehr viele Links enthalten, kann das Feedback zur Moderation zurückgehalten oder automatisch als Junk eingestuft werden. Sind hingegen keine Links oder nur Links zu bekannten Adressen enthalten, fällt die Bewertung positiv aus. (Verwenden Sie diese Funktion nur, wenn Ihr Blog bereits spam-frei ist.)',
    'Link Limits:' => 'Link-Limits:',
    'Credit feedback rating when no hyperlinks are present' => 'Credit für Feedback ohne Hyperlinks',
    'Adjust scoring' => 'Scoring anpassen',
    'Score weight:' => 'Gewichtung:',
    'Decrease' => 'Abschwächen',
    'Increase' => 'Verstärken',
    'Moderate when more than' => 'Moderieren falls mehr als',
    'link(s) are given' => 'Link(s) enthalten',
    'Junk when more than' => 'Als Junk einstufen falls mehr als',
    'Link Memory:' => 'Link-Memory:',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Credit für Feedback, dessen &quot;URL&quot;-Element bereits veröffentlicht wurde',
    'Only applied when no other links are present in message of feedback.' => 'Wird nur angewendet wenn keine zusätzlichen Links enthalten sind.',
    'Exclude URLs from comments published within last [_1] days.' => 'URLs aus Kommentaren entfernen, die in den letzten [_1] Tagen veröffentlicht wurden.',
    'Email Memory:' => 'Email-Memory:',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Credit für Feedback, das von der gleichen &quot;Email&quot;-Adresse stammt wie bereits zuvor freigeschaltetes Feedback',
    'Exclude Email addresses from comments published within last [_1] days.' => 'Email-Adressen aus Kommentaren entfernen, die in den letzten [_1] Tagen veröffentlich wurden.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Von jedem Feedback werden Herkunfts-IP-Adresse und enthaltene Hyperlinks automatisch kontrolliert. Stammt der Kommentar oder TrackBack von einer gesperrten IP-Adresse oder einer schwarzgelisteten Domain, kann er automatisch zur Moderation zurückgehalten oder als Junk markiert und in den Junk-Ordner des Blogs verschoben werden. Für TrackBacks stehen zusätzliche Kontrollen bereit.',
    'IP Address Lookups:' => 'Kontrolle der IP-Addressen:',
    'Off' => 'Aus',
    'Moderate feedback from blacklisted IP addresses' => 'Feedback von gesperrten IP-Adressen moderieren',
    'Junk feedback from blacklisted IP addresses' => 'Feedback von gesperrten IP-Adressen als Junk einstufen',
    'Less' => 'Schwächer',
    'More' => 'Stärker',
    'block' => 'sperren',
    'none' => 'keine',
    'IP Blacklist Services:' => 'IP-Schwarz- listendienste:',
    'Domain Name Lookups:' => 'Kontrolle der Domainnamen:',
    'Moderate feedback containing blacklisted domains' => 'Feedback von gesperrten Domains moderieren',
    'Junk feedback containing blacklisted domains' => 'Feedback von gesperrten Domains als Junk einstufen',
    'Domain Blacklist Services:' => 'Domain-Schwarz- listendienste:',
    'Advanced TrackBack Lookups:' => 'Zusätzliche TrackBack- Kontrollen:',
    'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus verdächtigen Quellen moderieren',
    'Junk TrackBacks from suspicious sources' => 'TrackBacks aus verdächtigen Quellen als Junk einstufen',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Domains und IP-Adressen, die nicht nachgeschlagen werden sollen, können hier aufgeführt werden. Verwenden Sie für jeden Eintag eine neue Zeile.',
    'Lookup Whitelist:' => 'Weißliste:',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Eingehendes Feedback kann automatisch auf frei definierbare Schlüsselwörter und Muster kontrolliert und bei Treffern zur Moderation zurückgehalten oder automatisch als Junk eingestuft werden. ',
    'Keywords to Moderate:' => 'Schlüsselwörter für Moderation:',
    'Keywords to Junk:' => 'Schlüsselwörter für automatische Junk-Einstufung:',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Google API-Key:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Um eine der API-Funktionen von Google nutzen zu können, benötigen Sie einen API-Schlüssel von Google. Fügen Sie diesen hier ein.',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'Wurzeladresse für Themes:',
    'Theme Root Path:' => 'Wurzelverzeichnis für Themes:',
    'Style Library URL:' => 'Adresse der Style Library:',

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'View Site' => 'Ansehen',

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
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

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Verwalten Sie Ihre Widgets ganz einfach per Drag-and-Drop',

    ## ./plugins/WidgetManager/tmpl/list.tmpl
    'Widget Manager' => 'Widget Manager', # Translate - Previous (2)
    'Your changes to the Widget Manager have been saved.' => 'Änderungen übernommen',
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'Widgetgruppe erfolgreich gelöscht.',
    'To add a Widget Manager to your templates, use the following syntax:' => 'Um eine Widgetgruppe in ein Template einzufügen, verwenden Sie folgende Syntax:',
    'Widget Managers' => 'Widgetgruppen',
    'Add Widget Manager' => 'Widgetgruppe hinzufügen',
    'Create Widget Manager' => 'Widgetgruppe anlegen',
    'Delete Selected' => 'Ausgewählte Elemente löschen',
    'Are you sure you wish to delete the selected Widget Manager(s)?' => 'Diese Widgetgruppe(n) wirklich löschen?',
    'WidgetManager Name' => 'Name der Widgetgruppe',
    'Installed Widgets' => 'Installierte Widgets',

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate - Previous (4)
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'Go' => 'Ausführen',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Es existiert bereits eine Widgetgruppe namens [_1]. Bitte wählen Sie einen anderen Namen.',
    'Rearrange Items' => 'Elemente anordnen',
    'Widget Manager Name:' => 'Name der Widgetgruppe:',
    'Build WidgetManager:' => 'Widgetgruppe anlegen:',
    'Available Widgets' => 'Verfügbare Widgets',
    'Save Changes' => 'Änderungen speichern',
    'Save changes (s)' => 'Änderungen speichern',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/default_widgets/search.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'in diesem Blog',
    'all blogs' => 'in allen Blogs',
    'Blogs that link here' => 'Blogs, die Links auf diese Seite enthalte',

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Neueste Kommentare',

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Select a Month...' => 'Monat auswählen...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/calendar.tmpl
    'Monthly calendar with links to each day\'s posts' => 'Monatskalender mit Links zu allen Einträgen',
    'Sunday' => 'Sonntag',
    'Sun' => 'So',
    'Monday' => 'Montag',
    'Mon' => 'Mo',
    'Tuesday' => 'Dienstag',
    'Tue' => 'Di',
    'Wednesday' => 'Mittwoch',
    'Wed' => 'Mi',
    'Thursday' => 'Donnerstag',
    'Thu' => 'Do',
    'Friday' => 'Freitag',
    'Fri' => 'Fr',
    'Saturday' => 'Samstag',
    'Sat' => 'Sa',

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Tag Cloud',

    ## ./lib/MT/default-templates.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/exportmt.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/wrap.pl

    ## ./build/l10n/trans.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
    'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
    'CGI Path Configuration Required' => 'CGI-Pfad muß eingestellt sein',
    'An error occurred' => 'Es ist ein Fehler aufgetreten',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'Nicht gespeicherte Änderungen gehen verloren',
    'Add new category...' => 'Neue Kategorie hinzufügen...',
    'Publish On' => 'Veröffentlichen um',
    'Entry Date' => 'Datum',
    'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.',
    'Create New Entry' => 'Neuen Eintrag schreiben',
    'Edit Entry' => 'Eintrag bearbeiten',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.' => 'Eintrag gespeichert. Falls erforderlich können Sie Eintrag und Zeitstempel jetzt bearbeiten.',
    'Your changes have been saved.' => 'Die Änderungen wurden gespeichert.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Ihre Anpassungseinstellungen wurden gespeichert und werden im nachfolgenden Formular angezeigt.',
    'Your changes to the comment have been saved.' => 'Ihre am Kommentar vorgenommenen Änderungen wurden gespeichert.',
    'Your notification has been sent.' => 'Ihre Benachrichtigung wurde gesendet.',
    'You have successfully deleted the checked comment(s).' => 'Der bzw. die markierten Kommentare wurden erfolgreich gelöscht.',
    'You have successfully deleted the checked TrackBack(s).' => 'TrackBack(s) gelöscht.',
    'Previous' => 'Zurück',
    'List &amp; Edit Entries' => 'Einträge auflisten &amp; bearbeiten',
    'Next' => 'Vor',
    '_external_link_target' => '_top',
    'View Entry' => 'Eintrag ansehen',
    'Entry' => 'Eintrag',
    'Comments ([_1])' => 'Kommentare ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate - Previous (2)
    'Notification' => 'Benachrichtigung',
    'Status' => 'Status', # Translate - Previous (1)
    'Unpublished' => 'Nicht veröffentlichen',
    'Published' => 'Veröffentlichen',
    'Scheduled' => 'Zeitgeplant',
    'Category' => 'Kategorie',
    'Assign Multiple Categories' => 'Mehrere Kategorien zuweisen',
    'Entry Body' => 'Text',
    'Bold' => 'Fett',
    'Italic' => 'Kursiv',
    'Underline' => 'Unterstrichen',
    'Insert Link' => 'Link einfügen',
    'Insert Email Link' => 'Email-Link einfügen',
    'Quote' => 'Zitat',
    'Bigger' => 'Größer',
    'Smaller' => 'Kleiner',
    'Extended Entry' => 'Erweiterter Eintrag',
    'Excerpt' => 'Zusammenfassung',
    'Keywords' => 'Schlüsselwörter',
    '(comma-delimited list)' => '(Liste mit Kommatrennung)',
    '(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
    '(delimited by \'[_1]\')' => '(Trennung durch \'[_1]\')',
    'Text Formatting' => 'Textformatierung',
    'Basename' => 'Basename', # Translate - Previous (1)
    'Unlock this entry\'s output filename for editing' => 'Dateiname zur Bearbeitung entsperren',
    'Warning' => 'Warnung',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basenamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Warnung: Wenn Sie den Basename nachträglich ändern, können Links von Außen den Eintrag falsch verlinken.',
    'Accept Comments' => 'Kommentare zulassen',
    'Accept TrackBacks' => 'TrackBacks zulassen',
    'Outbound TrackBack URLs' => 'TrackBack-URLs',
    'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
    'Customize the display of this page.' => 'Anzeigeoptionen',
    'Manage Comments' => 'Kommentare verwalten',
    'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.' => 'Um einen [_1] zu bearbeiten, klicken Sie ihn an. Für alle weiteren Aufgaben markieren Sie die jeweiligen [_2] und klicken auf die entsprechende Schaltfläche oder wählen die gewünschte Aktion aus dem Drop-Down-Menü aus.',
    'No comments exist for this entry.' => 'Zu diesem Eintrag gibt es keine Kommentare.',
    'Manage TrackBacks' => 'TrackBacks verwalten',
    'No TrackBacks exist for this entry.' => 'Zu diesem Eintrag gibt es keine TrackBacks.',
    'Send a Notification' => 'Benachrichtigung senden',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'Sie können eine Benachrichtung über diesen Eintrag an Mitglieder Ihrer Benachrichtungsliste oder an beliebige Adressen verschicken',
    'Recipients' => 'Empfänger',
    'Send notification to' => 'Benachrichtigung senden an',
    'Notification list subscribers, and/or' => 'Mitglieder der Benachrichtigungsliste und/oder',
    'Other email addresses' => 'Andere Email-Adresse',
    'Note: Enter email addresses on separate lines or separated by commas.' => 'Hinweis: geben Sie Email-Adresse zeilenweise oder durch Kommata getrennt ein',
    'Notification content' => 'Benachrichtungstext',
    'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Die Benachrichtung enthält automatisch den Namen des Blogs und des Eintrags sowie einen Link zum Eintrag. Zusätzlich können Sie einen Eintragsauszug oder den gesamten Eintrag sowie einen individuellen Hinweistext mitschicken.',
    'Message to recipients (optional)' => 'Hinweistext (optional)',
    'Additional content to include (optional)' => 'Eintrag (optional)',
    'Entry excerpt' => 'Eintragsauszug',
    'Entire entry body' => 'Gesamter Eintrag',
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => 'Hinweis: Der Eintragstext wird ohne Textformatierung verschickt',
    'Send entry notification' => 'Benachrichtigung versenden',
    'Send notification (n)' => 'Abschicken (n)',
    'Plugin Actions' => 'Plugin-Aktionen',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'Anzeigeoptionen',
    'Your entry screen preferences have been saved.' => 'Die Einstellungen für die Eintragseingabe wurden gespeichert.',
    'Editor Fields' => 'Eingabefelder',
    'Basic' => 'Einfach',
    'Custom' => 'Eigene',
    'Editable Authored On Date' => 'Erstellungsdatum',
    'Action Bar' => 'Menüleiste',
    'Select the location of the entry editor\'s action bar.' => 'Gewünschte Position der Menüleiste',
    'Below' => 'Oben',
    'Above' => 'Unten',
    'Both' => 'Sowohl als auch',

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Weiter bearbeiten',
    'Save this entry' => 'Speichern',

    ## ./tmpl/cms/menu.tmpl
    'Welcome to [_1].' => 'Willkommen bei [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Sie können Einträge veröffentlichen oder Ihr Weblog verwalten, indem Sie eine der links aufgeführten Optionen wählen.',
    'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
    'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - Previous (6)
    'Movable Type Technical Support' => 'Movable Type Technischer Support',
    'Movable Type Community Forums' => 'Movable Type Community-Foren',
    'Change this message.' => 'Diese Nachricht ändern.',
    'Edit this message.' => 'Diese Nachricht ändern.',
    'Here is an overview of [_1].' => '[_1] in der Übersicht.',
    'List Entries' => 'Einträge auflisten',
    'Recent Entries' => 'Neueste Einträge',
    'List Comments' => 'Kommentare auflisten',
    'Pending' => 'Nicht veröffentlicht',
    'List TrackBacks' => 'TrackBacks auflisten',
    'Recent TrackBacks' => 'Neueste TrackBacks',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Authentifizierte Kommentarautoren',
    'The selected commenter(s) has been given trusted status.' => 'Diese Kommentarautoren haben den Status vertrauenswürdig.',
    'Trusted status has been removed from the selected commenter(s).' => 'Der Vertraut-Status wurde für die ausgewählten Kommentarautoren aufgehoben.',
    'The selected commenter(s) have been blocked from commenting.' => 'Die ausgewählten Kommentarautoren wurden für Kommentare gesperrt.',
    'The selected commenter(s) have been unbanned.' => 'Die Kommentarsperre wurde für die ausgewählten Kommentarautoren aufgehoben.',
    'Reset' => 'Zurücksetzen',
    'Filter' => 'Filter', # Translate - Previous (1)
    'None.' => 'Keine',
    '(Showing all commenters.)' => '(Zeige alle Kommentarautoren)',
    'Showing only commenters whose [_1] is [_2].' => 'Zeige nur Kommentarautoren bei denen [_1] [_2] ist',
    'Commenter Feed' => 'Kommentarautoren-Feed',
    'Show' => 'Zeige',
    'all' => 'alle',
    'only' => 'nur',
    'commenters.' => 'Kommentarautoren',
    'commenters where' => 'Kommentare deren',
    'status' => 'Status',
    'commenter' => 'Kommentator',
    'is' => 'ist',
    'trusted' => 'vertraut',
    'untrusted' => 'nicht vertraut',
    'banned' => 'gesperrt',
    'unauthenticated' => 'nicht authentifiziert',
    'authenticated' => 'authentifiziert',
    '.' => '.', # Translate - Previous (0)
    'No commenters could be found.' => 'Keine Kommentarautoren gefunden.',

    ## ./tmpl/cms/list_comment.tmpl
    'System-wide' => 'Gesamtsystem',
    'The selected comment(s) has been published.' => 'Kommentar(e) veröffentlicht.',
    'All junked comments have been removed.' => 'Alle Junk-Kommentare wurden entfernt.',
    'The selected comment(s) has been unpublished.' => 'Kommentar(e) zurückgezogen.',
    'The selected comment(s) has been junked.' => 'Kommentar(e) jetzt Junk.',
    'The selected comment(s) has been unjunked.' => 'Kommentar(e) jetzt nicht mehr Junk.',
    'The selected comment(s) has been deleted from the database.' => 'Kommentar(e) aus der Datenbank gelöscht.',
    'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
    'No comments appeared to be junk.' => 'Keine Kommentare sind Junk.',
    'Junk Comments' => 'Junk-Kommentare',
    'Comment Feed' => 'Kommentar-Feed',
    'Comment Feed (Disabled)' => 'Kommentar-Feed (deaktiviert)',
    'Disabled' => 'Ausgeschaltet',
    'Set Web Services Password' => 'Web Services-Passwort setzen',
    'Quickfilter:' => 'Schnellfilter:',
    'Show unpublished comments.' => 'Zeige noch nicht veröffentlichte Kommentare',
    '(Showing all comments.)' => '(Zeige alle Kommentare)',
    'Showing only comments where [_1] is [_2].' => 'Zeige nur Kommentare bei denen [_1] [_2] ist',
    'comments.' => 'Kommentare',
    'comments where' => 'Kommentare die',
    'published' => 'veröffentlicht',
    'unpublished' => 'nicht veröffentlicht',
    'No comments could be found.' => 'Keine Kommentare gefunden.',
    'No junk comments could be found.' => 'Keine Junk-Kommentare gefunden.',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Kopieren Sie den HTML-Code, und fügen Sie ihn in den Eintrag ein.',
    'Close' => 'Schließen',
    'Upload Another' => 'Weitere hochladen',

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
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Ihre Plugins wurden neu konfiguriert. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.',
    'Settings' => 'Einstellungen',
    'Plugins' => 'Plugins', # Translate - Previous (1)
    'Switch to Detailed Settings' => 'Erweitere Einstellungen',
    'General' => 'Allgemein',
    'New Entry Defaults' => 'Standardwerte',
    'Feedback' => 'Feedback', # Translate - Previous (1)
    'Publishing' => 'Veröffentlichen',
    'IP Banning' => 'IP-Adressen sperren',
    'Switch to Basic Settings' => 'Vereinfachte Einstellungen',
    'Registered Plugins' => 'Registrierte Plugins',
    'Disable Plugins' => 'Plugins ausschalten',
    'Enable Plugins' => 'Plugins einschalten',
    'Error' => 'Fehler',
    'Failed to Load' => 'Fehler beim Laden',
    'Disable' => 'Ausschalten',
    'Enabled' => 'Eingeschaltet',
    'Enable' => 'Einschalten',
    'Documentation for [_1]' => 'Dokumentation zu [_1]',
    'Documentation' => 'Dokumentation',
    'Author of [_1]' => 'Autor von [_1]',
    'Author' => 'Autor',
    'More about [_1]' => 'Mehr über [_1]',
    'Support' => 'Support', # Translate - Previous (1)
    'Plugin Home' => 'Plugin Home', # Translate - Previous (2)
    'Resources' => 'Funktionen',
    'Show Resources' => 'Funktionen anzeigen',
    'Run' => 'Ausführen',
    'Run [_1]' => '[_1] ausführen',
    'Show Settings' => 'Einstellungen anzeigen',
    'Settings for [_1]' => 'Einstellungen von [_1]',
    'Version' => 'Version', # Translate - Previous (1)
    'Resources Provided by [_1]' => 'Resourcen von [_1]',
    'Tag Attributes' => 'Tag-Attribute',
    'Text Filters' => 'Text-Filter',
    'Junk Filters' => 'Junk-Filter',
    '[_1] Settings' => '[_1]-Einstellungen',
    'Reset to Defaults' => 'Standardwerte setzen',
    'Plugin error:' => 'Plugin-Fehler:',
    'No plugins with weblog-level configuration settings are installed.' => 'Es sind keine Plugins installiert, die am Gesamtsystem konfiguriert werden können.',

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Import/Export',
    'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Mit der Import/Export-Funktionen können Einträge aus anderen Movable Type-Installationen oder aus anderen Weblog-Systemen übernommen und bestehende Einträge in einem Austauschformat gesichert werden.',
    'Import Entries' => 'Einträge importieren',
    'Export Entries' => 'Einträge exportieren',
    'Authorship of imported entries:' => 'Autorenangabe:',
    'Import as me' => 'Einträge unter meinem Namen importieren',
    'Preserve original author' => 'Einträge unter ursprünglichen Namen importieren',
    'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Autorennamen importieren und einer oder mehrere der Autoren in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
    'Default password for new authors:' => 'Standardpasswort für neue Konten:',
    'Upload import file: (optional)' => 'Importdatei : (optional)',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Alle Einträge werden unter Ihrem Namen importiert. Sollen die Einträge unter den ursprünglichen Autorennamen importiert werden, lassen Sie Ihren Administrator den Import durchführen, damit Movable Type etwaige erforderliche zusätzliche Benutzerkonten automatisch anlegen kann.',
    'Import File Encoding (optional):' => 'Encoding der Importdatei (optional):',
    'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Type versucht automatisch das korrekte Encoding auszuwählen. Sollte das fehlschlagen, können Sie es auch explizit angeben.',
    'Default category for entries (optional):' => 'Standardkategorie (optional):',
    'Select a category' => 'Kategorie auswählen...',
    'You can specify a default category for imported entries which have none assigned.' => 'Standardkdategorie für importierte Einträge ohne Kategorie',
    'Importing from another system?' => 'Import aus einem anderen System als Movable Type',
    'Start title HTML (optional):' => 'Anfang Überschrift (optional):',
    'End title HTML (optional):' => 'Ende Überschrift (optional):',
    'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Wenn Sie aus einem Weblog-System importieren, das kein eigenes Feld für Überschriften hat, können Sie hier angeben, welche HTML-Ausdrücke den Anfang und das Ende von Überschriften markieren.',
    'Default post status for entries (optional):' => 'Standard-Eintragsstatus (optional):',
    'Select a post status' => 'Eintragsstatus wählen',
    'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.' => 'Enthält die Importdatei keine Angaben zum Eintragsstatus, können Sie hier einen Standardstatus für importierte Einträge bestimmen.',
    'Import Entries (i)' => 'Einträge importieren (i)',
    'Export Entries From [_1]' => 'Einträge aus [_1] exportieren',
    'Export Entries (e)' => 'Einträge exportieren (e)',
    'Export Entries to Tangent' => 'Einträge nach Tangent exportieren',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Vertrauen',
    'commenters' => 'Kommentarautoren',
    'to act upon' => 'Bearbeiten',
    'Trust commenter' => 'Kommentator vertrauen',
    'Untrust' => 'Nicht vertrauen',
    'Untrust commenter' => 'Kommentator nicht vertrauen',
    'Ban' => 'Sperren',
    'Ban commenter' => 'Kommentator sperren',
    'Unban' => 'Entsperren',
    'Unban commenter' => 'Sperre aufheben',
    'Trust selected commenters' => 'Ausgewählten Kommentarautoren vertrauen',
    'Ban selected commenters' => 'Ausgewählte Kommentarautoren sperren',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'You must set your Weblog Name.' => 'Sie müssen den Namen Ihres Weblogs festlegen.',
    'You did not select a timezone.' => 'Sie haben keine Zeitzone ausgewählt.',
    'General Settings' => 'Allgemeine Einstellungen',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Hier können Sie allgemeine Weblog-Einstellungen vornehmen, Anzeigeoptionen bearbeiten und Dienste von Drittanbietern konfigurieren.',
    'Your blog preferences have been saved.' => 'Ihre Blog-Einstellungen wurden gespeichert.',
    'Weblog Settings' => 'Weblog-Grundeinstellungen',
    'Weblog Name' => 'Weblog-Name',
    'Name your weblog. The weblog name can be changed at any time.' => 'Name des Weblog (kann jederzeit geändert werden)',
    'Description' => 'Beschreibung',
    'Enter a description for your weblog.' => 'Beschreibung des Weblogs',
    'Timezone:' => 'Zeitzone:',
    'Time zone not selected' => 'Es wurde keine Zeitzone ausgewählt',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Neuseeland Sommerzeit)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale Datumslinie Ost)',
    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
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
    'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universal Time Coordinated)', # Translate - Previous (4)
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
    'Select your timezone from the pulldown menu.' => 'Zeitzone des Blogs',
    'Default Weblog Display Settings' => 'Weblog-Standardeinstellungen',
    'Entries to Display:' => 'Anzeige der Einträge:',
    'Days' => 'Tage',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Die Anzahl der Einträge auf der Startseite bzw. Anzahl der angezeigten Tage.',
    'Entry Order:' => 'Eintragssortierung:',
    'Ascending' => 'Aufsteigend',
    'Descending' => 'Absteigend',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie aus, ob Ihre Einträge in aufsteigender (ältester zuerst) oder absteigender (neuester zuerst) Reihenfolge angezeigt werden sollen.',
    'Comment Order:' => 'Kommentarsortierung:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie aus, ob Kommentare von Besuchern in aufsteigender (ältester zuerst) oder absteigender (neuester zuerst) Reihenfolge angezeigt werden sollen.',
    'Excerpt Length:' => 'Auszugslänge:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Anzahl der Wörter im automatisch generierten Textauszug.',
    'Date Language:' => 'Datumssprache:',
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
    'Select the language in which you would like dates on your blog displayed.' => 'Sprache für Datumsanzeigen',
    'Limit HTML Tags:' => 'HTML-Tags limitieren:',
    'Use defaults' => 'Standardwerte verwenden',
    '([_1])' => '([_1])', # Translate - Previous (2)
    'Use my settings' => 'Eigene Einstellungen',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Liste der HTML-Tags, die aus HTML-Kommentaren nicht ausgefiltert werden sollen.',
    'License' => 'Lizenz',
    'Your weblog is currently licensed under:' => 'Ihr Weblog ist derzeit lizenziert unter:',
    'Change your license' => 'Lizenz ändern',
    'Remove this license' => 'Lizenz entfernen',
    'Your weblog does not have an explicit Creative Commons license.' => 'Keine Creative Commons-Lizenz gewählt',
    'Create a license now' => 'Jetzt eine Lizenz erstellen',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Optional kann eine Creative Commons-Lizenz gewählt werden',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Sie sollten die Lizenzen verstehen, bevor Sie sie auf Ihre Arbeit anwenden.',
    'Read more.' => 'Weitere Informationen',

    ## ./tmpl/cms/tag_table.tmpl
    'Date' => 'Datum',
    'IP Address' => 'IP-Adresse',
    'Log Message' => 'Protokollnachricht',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'Standard-Anzeigeoptionen für Editor',

    ## ./tmpl/cms/upload_complete.tmpl
    'Upload File' => 'Dateiupload',
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'Die Datei \'[_1]\' wurde hochgeladen. Größe: [quant,_2,byte].',
    'Create a new entry using this uploaded file' => 'Einen neuen Eintrag mit dieser Datei anlegen.',
    'Show me the HTML' => 'HTML anzeigen',
    'Image Thumbnail' => 'Miniaturansicht',
    'Create a thumbnail for this image' => 'Eine Miniaturansicht dieses Bilds erzeugen.',
    'Width:' => 'Breite:',
    'Pixels' => 'Pixel',
    'Percent' => 'Prozent',
    'Height:' => 'Höhe:',
    'Constrain proportions' => 'Proportionen erhalten',
    'Would you like this file to be a:' => 'Wie soll die Datei angezeigt werden?',
    'Popup Image' => 'Popup-Bild',
    'Embedded Image' => 'Eingebettetes Bild',
    'Link' => 'Link', # Translate - Previous (1)

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Ihr Eintrag wurde gespeichert unter [_1]',
    ', and it has been posted to your site' => 'und auf Ihrer Site veröffentlicht.',
    '. ' => '. ', # Translate - Previous (0)
    'View your site' => 'Site ansehen',
    'Edit this entry' => 'Eintrag bearbeiten',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Sind Sie sicher, dass Sie den [quant,_1,Autor] dauerhaft aus dem System löschen möchten?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Sind Sie sicher, dass Sie den [quant,_1,Kommentar] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Sind Sie sicher, dass Sie [quant,_1,TrackBack] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Sind Sie sicher, dass Sie diese [quant,_1,Eintrag,Einträge] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Sind Sie sicher, dass Sie dieses [quant,_1,Template] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Sind Sie sicher, dass Sie diese [quant,_1,Kategorie,Kategorien] löschen möchten? Wenn Sie eine Kategorie löschen, werden alle dieser Kategorie zugewiesenen Einträge von der Kategorie getrennt (die Einträge werden aber nicht gelöscht).',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Sind Sie sicher, dass Sie dieses [quant,_1,Template] aus dem/den bestimmten Archivierungstyp(en) löschen möchten?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Sind Sie sicher, dass Sie diese [quant,_1,IP-Adresse,IP-Adressen] aus Ihrer Liste der gesperrten IP-Adressen löschen möchten?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Sind Sie sicher, dass Sie diese [quant,_1,Benachrichtigungsadresse,Benachrichtigungsadressen] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Sind Sie sicher, dass Sie [quant,_1,blockiertes Element,blockierte Elemente] löschen möchten?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Sind Sie sicher, dass Sie das [quant,_1,Weblog] löschen möchten? Wenn Sie ein Weblog löschen, werden gleichzeitig alle Einträge, Kommentare, Templates, Benachrichtigungen und Autorenberechtigungen gelöscht. Überlegen Sie sich also gut, ob Sie das möchten, denn diese Aktion kann nicht rückgängig gemacht werden.',
    'Delete' => 'Löschen',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Hier konfigurieren Sie die Kommentar- und TrackBack-Einstellungen für das Gesamtsystem. Diese Einstellungen sind höherrangig als die entsprechenden Einstellungen der einzelnen Weblogs, d.h. sie setzen diese außer Kraft.',
    'Your feedback preferences have been saved.' => 'Ihre Feedback-Einstellungen wurden gespeichert.',
    'Feedback Master Switch' => 'Feedback-Hauptschalter',
    'Disable Comments' => 'Kommentare ausschalten',
    'Stop accepting comments on all weblogs' => 'Bei allen Weblogs Kommentare ausschalten',
    'This will override all individual weblog comment settings.' => 'Diese Einstellung setzt die entsprechenden Einstellungen der Einzelweblogs außer Kraft',
    'Disable TrackBacks' => 'TrackBacks ausschalten',
    'Stop accepting TrackBacks on all weblogs' => 'Bei allen Weblogs TrackBack ausschalten',
    'This will override all individual weblog TrackBack settings.' => 'Diese Einstellung setzt die entsprechenden Einstellungen der Einzelweblogs außer Kraft',
    'Outbound TrackBack Control' => 'TrackBack-Kontrolle (für ausgehende Pings)',
    'Allow outbound TrackBacks to:' => 'Ausgehende TrackBacks zulassen:',
    'Any site' => 'zu beliebigen Sites',
    'No site' => 'zu keinen Sites',
    '(Disable all outbound TrackBacks.)' => '(Alle ausgehenden TrackBacks ausschalten)',
    'Only the weblogs on this installation' => 'nur zu Sites in dieser Installation',
    'Only the sites on the following domains:' => 'nur zu Sites mit den folgenden Domains:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Um Ihre Installation nichtöffentlich zu machen, können Sie hier begrenzen, zu welchen Sites TrackBacks verschickt werden dürfen.',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Standardeinstellung für neue Einträge',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Hier legen Sie fest, welche Einstellungen für neue Einträge standardmässig übernommen werden. Zudem konfigurieren Sie die Öffentlichkeits- und Remote Interface-Funktionen.',
    'Default Settings for New Entries' => 'Standardeinstellung für neue Einträge',
    'Post Status' => 'Eintragsstatus',
    'Specifies the default Post Status when creating a new entry.' => 'Gibt an, welcher Standard-Eintragsstatus beim Erstellen eines neuen Eintrags verwendet werden soll',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen Kommentare standardmässig aktiv sind',
    'Setting Ignored' => 'Einstellung ignoriert',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Hinweis: Diese Einstellung wird derzeit ignoriert, da Kommentare für das Weblog bzw. global deaktiviert wurden.',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen TrackBack standardmässig aktiv ist',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Hinweis: Diese Einstellung wird derzeit ignoriert, da TrackBacks für das Weblog bzw. global deaktiviert wurden.',
    'Basename Length:' => 'Basename-Länge:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Setzt den Wert für den automatisch generierten Basename des Eintrags. Mögliche Länge: 15 bis 250.',
    'Publicity/Remote Interfaces' => 'Einstellungen für Öffentlichkeits-Funktionen',
    'Notify the following sites upon weblog updates:' => 'Die folgenden Dienste bei Updates benachrichtigen:',
    'Others:' => 'Andere:',
    '(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Wenn ein neuer Eintrag veröffentlicht wird, werden diese Dienste automatisch benachrichtigt.',
    'Setting Notice' => 'Hinweis zu der Einstellung',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Die Option ist eventuell betroffen, da Einstellungen zu Pings (outbound) für das Gesamtsystem konfiguriert werden.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird derzeit ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
    'Recently Updated Key:' => '"Kürzlich aktualisiert"-Code:',
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Wenn Sie einen "Kürzlich aktualisiert"-Code erhalten haben, tragen Sie ihn hier ein.',
    'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery', # Translate - Previous (2)
    'Enable External TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (external) aktivieren',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
    'Enable Internal TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (internal) aktivieren',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Wenn Sie diese Option aktivieren, werden Einträge auf Links untersucht und den jeweiligen Sites automatisch ein TrackBack gesendet.',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'Template',
    'templates' => 'Templates',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Ihr Passwort wurde geändert, und das neue Passwort wurde an Ihre E-Mail-Adresse gesendet ([_1]).',
    'Enter your Movable Type username:' => 'Geben Sie Ihren Benutzernamen ein:',
    'Enter your password recovery word/phrase:' => 'Geben Sie Ihren Erinnerungssatz ein:',
    'Recover' => 'Passwort anfordern',

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Ihr Eintrag wurde aus der Datenbank gelöscht.',
    'Entry Feed' => 'Einträge-Feed',
    'Entry Feed (Disabled)' => 'Einträge-Feed (deaktiviert)',
    'Show unpublished entries.' => 'Nicht veröffentlichte Einträge anzeigen',
    '(Showing all entries.)' => '(Zeige alle Einträge)',
    'Showing only entries where [_1] is [_2].' => 'Zeige nur Einträge, bei denen [_1] [_2] ist',
    'entries.' => 'Einträge',
    'entries where' => 'Einträge bei denen',
    'author' => 'Autor',
    'tag (exact match)' => 'Tag (exakt)',
    'tag (fuzzy match)' => 'tag (fuzzy)',
    'category' => 'Kategorie',
    'scheduled' => 'zeitgeplant',
    'No entries could be found.' => 'Keine Einträge gefunden',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Index-Templates',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Index-Templates erzeugen Einzelseiten, die Movable Type-Inhalte anzeigen können. Normalerweise werden Index-Templates beim Veröffentlichen von Einträgen, Kommentaren und TrackBacks automatisch aktualisiert.',
    'Archive Templates' => 'Archiv-Templates',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Archiv-Templates erzeugen Archivdateien vom jeweiligen Archivtypen. In den Einstellungen können Sie weitere Archivtemplates anlegen und mit den verschiedenen Archivarten verknüpfen.',
    'System Templates' => 'System-Templates',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'System-Templates legen das Layout und den Stil von einigen dynamischen Seiten wie der Kommentarvorschau, Bild-Popups und Suchergebnisseiten fest.',
    'Template Modules' => 'Template-Module',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Template-Module sind Mini-Templates, die Sie als Includes in Ihren anderen Templates einsetzen können. So können Sie z.B. gleichbleibende Elemente wie Header oder Footer erzeugen.',
    'You have successfully deleted the checked template(s).' => 'Template(s) erfolgreich gelöscht.',
    'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
    'Indexes' => 'Index-Dateien',
    'System' => 'System', # Translate - Previous (1)
    'Modules' => 'Module',
    'Go to Publishing Settings' => 'Optionen bearbeiten',
    'Create new index template' => 'Neues Index-Template',
    'Create New Index Template' => 'Neues Index-Template',
    'Create new archive template' => 'Neues Archiv-Template',
    'Create New Archive Template' => 'Neues Archiv-Template',
    'Create new template module' => 'Neues Template-Modul',
    'Create New Template Module' => 'Neues Template-Modul',
    'Template Name' => 'Name des Templates',
    'Output File' => 'Ausgabedatei',
    'Dynamic' => 'Dynamisch',
    'Linked' => 'Verlinkt',
    'Built w/Indexes' => 'mit Index',
    'Yes' => 'Ja',
    'No' => 'Nein',
    'View Published Template' => 'Veröffentlichtes Template ansehen',
    'No index templates could be found.' => 'Keine Index-Templates gefunden.',
    'No archive templates could be found.' => 'Keine Archiv-Templates geunden.',
    'No template modules could be found.' => 'Keine Template-Module gefunden.',

    ## ./tmpl/cms/list_tags.tmpl
    'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen.',
    'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht.',
    'Tag Name' => 'Tag-Name',
    'Click to edit tag name' => 'Klicken, um Tagname zu bearbeiten',
    'Rename' => 'Umbenennen',
    'Show all entries with this tag' => 'Alle Einträge mit diesem Tag anzeigen',
    '[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
    'No tags could be found.' => 'Keine Tags gefunden',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Es ist ein Fehler aufgetreten:',

    ## ./tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => 'Web Services-Passwort noch nicht gesetzt',
    'Author Profile' => 'Autorenprofil',
    'Create New Author' => 'Neuen Autor einrichten',
    'Profile' => 'Profil',
    'Permissions' => 'Berechtigungen',
    'Your profile has been updated.' => 'Ihr Profil wurde aktualisiert.',
    'Weblog Associations' => 'Weblog-Berechtigungen',
    'General Permissions' => 'Allgemeine Berechtigungen',
    'System Administrator' => 'Systemadministrator',
    'Create Weblogs' => 'Weblogs einrichten',
    'View Activity Log' => 'Aktivitätsprotokoll anzeigen',
    'Username' => 'Benutzername',
    'The name used by this author to login.' => 'Anmeldename dieses Benutzerkontos',
    'Display Name' => 'Anzeigename',
    'The author\'s published name.' => 'Der Name, der bei Einträgen angezeigt wird',
    'The author\'s email address.' => 'Email-Adresse des Benutzers',
    'Website URL:' => 'Website-URL:',
    'The URL of this author\'s website. (Optional)' => 'Die URL des Autors (optional)',
    'Language:' => 'Sprache:',
    'The author\'s preferred language.' => 'Gewünschte Spracheinstellung',
    'Tag Delimiter:' => 'Tags-Trennzeichen:',
    'Comma' => 'Komma',
    'Space' => 'Leerzeichen',
    'Other...' => 'Anderes...',
    'The author\'s preferred delimiter for entering tags.' => 'Das gewünschte Trennzeichen für die Eingabe von Tags',
    'Password' => 'Passwort',
    'Current Password:' => 'Aktuelles Passwort:',
    'Enter the existing password to change it.' => 'Geben Sie das aktuelle Passwort ein, um es zu ändern.',
    'New Password:' => 'Neues Passwort:',
    'Initial Password' => 'Passwort',
    'Select a password for the author.' => 'Passwort für dieses Benutzerkonto',
    'Password Confirm:' => 'Passwort wiederholen:',
    'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen',
    'Password recovery word/phrase' => 'Erinnerungssatz',
    'This word or phrase will be required to recover your password if you forget it.' => 'Dieser Satz wird abgefragt, wenn ein vergessenes Passwort angefordert wird',
    'Web Services Password:' => 'Web Services-Passwort:',
    'Reveal' => 'Anzeigen',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Erforderlich für Aktivitäts-Feeds und externe Software, die über XML-RPC oder ATOM-API auf das Weblog zugreift',
    'Save this author (s)' => 'Autor speichern',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Hinzugefügt am',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Weblogs anzeigen',
    'List Authors' => 'Autoren anzeigen',
    'Authors' => 'Autoren',
    'List Plugins' => 'Plugins anzeigen',
    'Aggregate' => 'Übersicht',
    'List Tags' => 'Tags anzeigen',
    'Configure' => 'Konfigurieren',
    'Edit System Settings' => 'Systemeinstellungen bearbeiten',
    'Utilities' => 'Werkzeuge',
    'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
    'Show Activity Log' => 'Aktivitätsprotokoll anzeigen',
    'Activity Log' => 'Aktivitäten',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Das Movable Type Aktivitätsprotokoll zeichnet alle Systemvorgänge auf.',
    'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',
    'All times are displayed in GMT.' => 'Alle Zeiten in GMT',
    'The activity log has been reset.' => 'Das Aktivitätsprotokoll wurde zurückgesetzt.',
    'Download CSV' => 'Als CSV herunterladen',
    'Show only errors.' => 'Nur Fehler anzeigen',
    '(Showing all log records.)' => '(Zeige alle Einträge)',
    'Showing only log records where' => 'Zeige nur Einträge mit',
    'Filtered CSV' => 'Gefiltertes CSV',
    'Filtered' => 'Gefilterte',
    'Activity Feed' => 'Aktivitäts-Feed',
    'log records.' => 'Log-Einträge',
    'log records where' => 'Log-Einträge bei denen',
    'level' => 'Level',
    'classification' => 'Klassifikation',
    'Security' => 'Sicherheit',
    'Information' => 'Information', # Translate - Previous (1)
    'Debug' => 'Debug', # Translate - Previous (1)
    'Security or error' => 'Sicherheit oder Fehler',
    'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
    'Not debug' => 'Kein Debug',
    'Debug/error' => 'Debug/Fehler',
    'No log records could be found.' => 'Keine Log-Einträge gefunden.',

    ## ./tmpl/cms/tag_actions.tmpl
    'tag' => 'Tag',
    'tags' => 'Tags',
    'Delete selected tags (x)' => 'Markierte Tags löschen (x)',

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuild' => 'Neu aufbauen',
    'Rebuilding [_1]' => 'Veröffentliche [_1]',
    'Rebuilding [_1] pages [_2]' => 'Baue [_1] Seiten neu auf [_2]',
    'Rebuilding [_1] dynamic links' => 'Baue [_1] dynamische Links neu auf',
    'Rebuilding [_1] pages' => 'Baue [_1] Seiten neu auf',

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Eine Datei namens \'[_1]\' ist bereits vorhanden. Möchten Sie sie überschreiben?',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Junk finden',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Diese Einträge könnten Junk sein. Einträge, die nicht Junk sind, bitte abwählen.',
    'To return to the comment list without junking any items, click CANCEL.' => 'Abbruch führt zurück Kommentarliste, ohne daß Einträge als Junk eingestuft werden',
    'Commenter' => 'Kommentator',
    'Comment' => 'Kommentar',
    'IP' => 'IP', # Translate - Previous (1)
    'Junk' => 'Junk', # Translate - Previous (1)
    'Approved' => 'Freigeschaltet',
    'Banned' => 'Gesperrt',
    'Registered Commenter' => 'Registrierter Kommentator',
    'comment' => 'Kommentar',
    'comments' => 'Kommentare',
    'Return to comment list' => 'Zurück zur Kommentarliste',

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully!' => 'Import erfolgreich abgeschlossen!',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem \'import\'-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden. ',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'Systemstatistik',
    'Active Authors' => 'Aktive Autoren',
    'Essential Links' => 'Wichtige Weblinks',
    'Movable Type Home' => 'Movable Type-Website',
    'Plugin Directory' => 'Plugin-Verzeichnis',
    'Support and Documentation' => 'Support und Dokumentation',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account?portal=de',
    'Your Account' => 'Ihr Movable Type-Account',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit&portal=de',
    'Open a Help Ticket' => 'Hilfe-Ticket öffnen',
    'Paid License Required' => 'Bezahlte MT-Version erforderlich',
    'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.org/sitede',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - Previous (6)
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb&portal=de',
    'Knowledge Base' => 'Wissensdatenbank',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - Previous (5)
    'Professional Network' => 'Professional Network', # Translate - Previous (2)
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Hier können Sie Ihr Gesamtsystem verwalten und Einstellungen für alle Weblogs vornehmen.',
    'Movable Type News' => 'News von Movable Type',

    ## ./tmpl/cms/entry_table.tmpl
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Only show unpublished entries' => 'Nur unveröffentlichte Einträge anzeigen',
    'Only show published entries' => 'Nur veröffentlichte Einträge anzeigen',
    'Only show scheduled entries' => 'Nur zeitgeplante Einträge anzeigen',
    'None' => 'Kein(e)',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Liste aller bereits erfolgreich gesendeten TrackBacks:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Liste aller bisher fehlgeschlagenen TrackBacks. Für einen erneuten Sendeversuch bitte in die Liste der zu sendenden TrackBacks kopieren.',

    ## ./tmpl/cms/edit_admin_permissions.tmpl
    'Your changes to [_1]\'s permissions have been saved.' => 'Änderungen der Benutzerrechte von [_1] wurden übernommen.',
    '[_1] has been successfully added to [_2].' => '[_1] wurde erfolgreich zu [_2] hinzugefügt.',
    'User can create weblogs' => 'Weblogs anlegen',
    'User can view activity log' => 'Protokoll einsehen',
    'Check All' => 'Alle markieren',
    'Uncheck All' => 'Alle deaktivieren',
    'Unheck All' => 'Markierungen aufheben',
    'Add user to an additional weblog:' => 'Benutzer zu einem weiteren Weblog hinzufügen:',
    'Select a weblog' => 'Weblog auswählen...',
    'Add' => 'Hinzufügen',
    'Save permissions for this author (s)' => 'Änderungen speichern',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Aktivitätsprotokoll zurücksetzen',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Wählen Sie aus, welche Dateien neu aufgebaut werden sollen.',
    'Rebuild All Files' => 'Alle Dateien neu aufbauen',
    'Index Template: [_1]' => 'Index-Template: [_1]',
    'Rebuild Indexes Only' => 'Nur Index-Dateien neu aufbauen',
    'Rebuild [_1] Archives Only' => 'Nur [_1] Archive neu aufbauen',
    'Rebuild (r)' => 'Neu aufbauen (r)',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Zeit für Ihr Upgrade!',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
    'Do you want to proceed with the upgrade anyway?' => 'Upgrade dennoch fortsetzen?',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.',
    'In addition, the following Movable Type plugins require upgrading or installation:' => 'Zusätzlich müssen folgende Movable Type-Plugins installiert oder aktualisiert werden:',
    'The following Movable Type plugins require upgrading or installation:' => 'Folgende Movable Type-Plugins müssen installiert oder aktualisiert werden:',
    'Version [_1]' => 'Version [_1]', # Translate - Previous (2)
    'Begin Upgrade' => 'Upgrade durchführen',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'Adresse für Benachrichtigung',
    'notification addresses' => 'Adressen für Benachrichtigung',
    'Delete selected notification addresses (x)' => 'Ausgewählte Benachrichtigungsadressen löschen(x)',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Sie können sich nachfolgend erneut anmelden.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Ihre Movable Type-Session ist abgelaufen. Bitte melden Sie sich erneut an.',
    'Remember me?' => 'Benutzername speichern?',
    'Log In' => 'Anmelden',
    'Forgot your password?' => 'Passwort vergessen?',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'TrackBack(s) jetzt veröffentlicht.',
    'All junked TrackBacks have been removed.' => 'Alle Junk-TrackBacks entfernt.',
    'The selected TrackBack(s) has been unpublished.' => 'TrackBack(s) zurückgezogen.',
    'The selected TrackBack(s) has been junked.' => 'TrackBack(s) jetzt Junk.',
    'The selected TrackBack(s) has been unjunked.' => 'TrackBack(s) nicht mehr Junk.',
    'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
    'No TrackBacks appeared to be junk.' => 'Keine TrackBacks sind Junk.',
    'Junk TrackBacks' => 'Junk-TrackBacks',
    'Trackback Feed' => 'Trackback-Feed',
    'Trackback Feed (Disabled)' => 'Trackback-Feed (deaktiviert)',
    'Show unpublished TrackBacks.' => 'Nicht veröffentlichte TrackBacks anzeigen',
    '(Showing all TrackBacks.)' => '(Zeige alle TrackBacks)',
    'Showing only TrackBacks where [_1] is [_2].' => 'Zeige nur TrackBacks bei denen [_1] [_2] ist',
    'TrackBacks.' => 'TrackBacks.', # Translate - Previous (1)
    'TrackBacks where' => 'TrackBacks die',
    'No TrackBacks could be found.' => 'Keine TrackBacks gefunden.',
    'No junk TrackBacks could be found.' => 'Keine Junk-TrackBacks gefunden.',

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'Passwörter wiederherstellen',
    'No authors were selected to process.' => 'Es wurden keine Benutzer ausgewählt.',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed (Disabled)' => 'Aktivitäts-Feed (deaktiviert)',

    ## ./tmpl/cms/ping_actions.tmpl
    'to publish' => 'zu Veröffentlichen',
    'Publish' => 'Veröffentlichen',
    'Publish selected TrackBacks (p)' => 'Ausgewählte TrackBacks veröffentlichen (p)',
    'Delete selected TrackBacks (x)' => 'Ausgewählte TrackBacks löschen (x)',
    'Junk selected TrackBacks (j)' => 'Ausgewählte TrackBacks als Junk markieren (j)',
    'Not Junk' => 'Kein Junk',
    'Recover selected TrackBacks (j)' => 'Ausgewählte TrackBacks wiederherstellen (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Alle Jung-TrackBacks wirklich entfernen?',
    'Empty Junk Folder' => 'Junk-Ordner leeren',
    'Deletes all junk TrackBacks' => 'Löscht alle Junk-Trackbacks',
    'Ban This IP' => 'Diese IP-Adresse sperren',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Von',
    'Target' => 'Auf',
    'Only show published TrackBacks' => 'Nur veröffentlichte TrackBacks anzeigen',
    'Only show pending TrackBacks' => 'Nur nicht veröffentlichte TrackBacks anzeigen',
    'Edit this TrackBack' => 'TrackBack bearbeiten',
    'Edit TrackBack' => 'TrackBack bearbeiten',
    'Go to the source entry of this TrackBack' => 'Zum Eintrag wechseln, auf den sich das TrackBack bezieht',
    'View the [_1] for this TrackBack' => '[_1] zu dem TrackBack ansehen',
    'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP: [_1]', # Translate - Previous (2)

    ## ./tmpl/cms/edit_profile.tmpl
    'Author Permissions' => 'Benutzerrechte',
    'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an die Adresse  [_1] verschickt.',
    'Password Recovery' => 'Passwort wird wiederhergestellt',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Details zu Kommentator',
    'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentator.',
    'The commenter has been banned.' => 'Dieser Kommentator wurde gesperrt.',
    'View all comments with this name' => 'Alle Kommentare mit diesem Namen anzeigen',
    'Identity' => 'ID',
    'Email' => 'Email', # Translate - Previous (1)
    'Withheld' => 'Underdrückt',
    'View all comments with this email address' => 'Alle Kommentare von dieser Email-Adresse anzeigen',
    'View all comments with this URL address' => 'Alle Kommentare mit dieser URL anzeigen',
    'Trusted' => 'vertraut',
    'Blocked' => 'Gesperrt',
    'Authenticated' => 'Authentifiziert',
    'View all commenters with this status' => 'Alle Kommentarautoren mit diesem Status ansehen',

    ## ./tmpl/cms/edit_permissions.tmpl

    ## ./tmpl/cms/author_actions.tmpl
    'authors' => 'Autoren',
    'Delete selected authors (x)' => 'Markierte Beutzer löschen (x)',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Willkommen bei Movable Type!',
    'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Abschließend wird nun die Datenbank eingerichtet werden. Dann können Sie mit dem Bloggen beginnen.',
    'You will need to select a username and password for the administrator account.' => 'Legen Sie den Benutzernamen und das Passwort des Administrator-Accounts fest:',
    'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
    'Password recovery word/phrase:' => 'Erinnerungssatz:',
    'Finish Install' => 'Installation abschließen',

    ## ./tmpl/cms/comment_table.tmpl
    'Only show published comments' => 'Nur veröffentlichte Kommentare anzeigen',
    'Only show pending comments' => 'Nur nicht veröffentlichte Kommentare anzeigen',
    'Edit this comment' => 'Kommentar bearbeiten',
    'Edit Comment' => 'Kommentar bearbeiten',
    'Edit this commenter' => 'Kommentator bearbeiten',
    'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentator suchen',
    'View this entry' => 'Eintrag ansehen',
    'Show all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'IP-Sperren-Einstellungen',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Hier legen Sie fest, welche IP-Adressen für Kommentare und TrackBacks gesperrt werden sollen.',
    'You have banned [quant,_1,address,addresses].' => 'Sie haben [quant,_1,Adresse,Adressen] gesperrt.',
    'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefgt.',
    'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die ausgewählten IP-Adressen erfolgreich aus der Liste entfernt.',
    'Ban New IP Address' => 'Neue IP-Adresse sperren',
    'Ban IP Address' => 'IP-Adresse sperren',
    'Date Banned' => 'gesperrt am',
    'IP address' => 'IP-Adresse',
    'IP addresses' => 'IP-Adressen',

    ## ./tmpl/cms/bookmarklets.tmpl
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'Add QuickPost to Windows right-click menu' => 'QuickPost zum Kontextmenü von Windows hinzufügen',
    'Configure QuickPost' => 'QuickPost einrichten',
    'Include:' => 'Anzeigen:',
    'TrackBack Items' => 'TrackBack',
    'Allow Comments' => 'Kommentare zulassen',
    'Allow TrackBacks' => 'TrackBacks zulassen',
    'Create' => 'Neu',

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Kategorie hinzufügen',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Um eine neue Kategorie zu erstellen, geben Sie einen Titel in untenstehendes Feld ein, wählen Sie eine übergeordnete Kategorie und klicken Sie auf die Schaltfläche "Hinzufügen".',
    'Category Title:' => 'Kategorietitel:',
    'Parent Category:' => 'Übergeordnete Kategorie:',
    'Top Level' => 'Oberste Ebene',
    'Save category (s)' => 'Kategorie speichern (s)',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importieren...',
    'Importing entries into blog' => 'Importiere Einträge...',
    'Importing entries as author \'[_1]\'' => 'Importiere als Autor \'[_1]\'...',
    'Creating new authors for each author found in the blog' => 'Lege Benutzerkonten an...',

    ## ./tmpl/cms/list_notification.tmpl
    'Notifications' => 'Mitteilungen',
    'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Eine Liste aller registrierten Benachrichtigungsempfänger. Sie können aus dieser Liste auswählen, wenn Sie manuell Benachrichtigungen über einen neuen Blogeintrag verschicken.',
    'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'Sie haben [quant,_1,Empfänger,Empfänger,keine Empfänger] auf Ihrer Benachrichtigungsliste. Um einen Empfänger zu löschen, markieren Sie den entsprechenden Eintrag und klicken dann auf \'Löschen\'.',
    'You have added [_1] to your notification list.' => 'Sie haben [_1] zu Ihrer Benachrichtigungsliste hinzugefügt.',
    'You have successfully deleted the selected notifications from your notification list.' => 'Sie haben die ausgewählten Benachrichtigungen erfolgreich aus der Benachrichtigungsliste gelöscht.',
    'Create New Notification' => 'Neue Benachrichtigung einrichten',
    'URL (Optional):' => 'URL (optional):',
    'Add Recipient' => 'Empfänger hinzufügen',
    'No notifications could be found.' => 'Keine Benachrichtigung gefunden.',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Weitere Aktionen...',
    'No actions' => 'Keine Aktionen',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'Sie müssen den Pfad Ihres lokalen Verzeichnis festlegen.',
    'You must set your Site URL.' => 'Sie müssen Ihre Webadresse (URL) festlegen.',
    'Your Site URL is not valid.' => 'Die gewählte Webadresse (URL) ist ungültig.',
    'You can not have spaces in your Site URL.' => 'Die Adresse (URL) darf keine Leerzeichen enthalten.',
    'You can not have spaces in your Local Site Path.' => 'Der lokale Pfad darf keine Leerzeichen enthalten.',
    'Your Local Site Path is not valid.' => 'Das gewählte lokale Verzeichnis ist ungültig.',
    'New Weblog Settings' => 'Einstellungen für neue Weblogs',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'In diesem Menü legen Sie die Grundkonfiguration für ein neues Weblog fest. Sobald Sie die Einstellungen speichern, wird das Weblog angelegt. Sie können dann weitere Einstellungen vornehmen oder aber direkt einen Eintrag schreiben und veröffentlichen.',
    'Your weblog configuration has been saved.' => 'Ihre Weblog-Konfiguration wurde gespeichert.',
    'Site URL:' => 'Adresse (URL):',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Adresse (URL) des Blogs (Ohne Dateinamen wie z.B. "index.html").',
    'Example:' => 'Beispiel:',
    'Site Root' => 'Site-Root',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Wurzelverzeichnis des Blogs (Verwenden Sie möglichst einen mit \'/\' beginnenden absoluten Pfad. Sie können aber auch einen Pfad relativ zum Movable Type-Verzeichnis angeben.)',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Einträge',
    'New Entry' => 'Neuer Eintrag',
    'Community' => 'Feedback',
    'List Commenters' => 'Kommentarautoren auflisten',
    'Commenters' => 'Kommentar- autoren',
    'Edit Notification List' => 'Benachrichtigungsliste bearbeiten',
    'List &amp; Edit Templates' => 'Templates auflisten &amp; bearbeiten',
    'Edit Categories' => 'Kategorien bearbeiten',
    'Edit Tags' => 'Tags bearbeiten',
    'Edit Weblog Configuration' => 'Weblog-Konfiguration bearbeiten',
    'Import &amp; Export Entries' => 'Einträge importieren &amp; exportieren',
    'Rebuild Site' => 'Neu aufbauen',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Diese Domainnamen wurden in den Kommentaren gefunden. Markieren Sie eine URL, um Kommentare und TrackBacks mit dieser URL in Zukunft zu sperren.',
    'Block' => 'Sperren',

    ## ./tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
    'Edit Category' => 'Kategorie bearbeiten',
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Auf dieser Seite legen Sie die Eigenschaften der Kategorie [_1] fest. Sie können eine Beschreibung für die Kategorie festlegen, die auf den öffentlichen Seiten verwendet werden soll, und Sie können die TrackBack-Optionen für die Kategorie konfigurieren.',
    'Your category changes have been made.' => 'Die Einstellungen wurden übernommen.',
    'Label' => 'Name',
    'Unlock this category\'s output filename for editing' => 'Dateiname zum Bearbeiten freigeben',
    'Warning: Changing this category\'s basename may break inbound links.' => 'Achtung: Änderungen des Basenames können bestehende externe Links auf diese Kategorieseite ungültig mächen',
    'Save this category (s)' => 'Kategorie speichern (s)',
    'Inbound TrackBacks' => 'TrackBacks (inbound)',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Wenn die Option aktiv ist, sind Kategorie-TrackBacks aus allen Quellen zugelassen',
    'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Das ist die Adresse für TrackBacks für diese Kategorie. Wenn Sie sie öffentlich machen, kann jeder, der in seinem Blog einen für diese Kategorie relevanten Eintrag geschrieben hat, einen TrackBack-Ping senden. Mittels TrackBack-Tags können Sie diese TrackBacks auf Ihrer Seite anzeigen. Näheres dazu finden Sie in der Dokumentation.',
    'Passphrase Protection' => 'Passphrasenschutz',
    'Optional.' => 'Optional.', # Translate - Previous (1)
    'Outbound TrackBacks' => 'TrackBacks (outbound)',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'URL(s) der Websites, denen Sie ein TrackBack senden möchten, wenn Sie in dieser Kategorie einen Eintrag veröffentlichen. (Verwenden Sie für jede URL eine neue Zeile)',

    ## ./tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => 'Noch nicht gespeicherte Änderungen gehen verloren.',
    'Edit Template' => 'Templates bearbeiten',
    'Your template changes have been saved.' => 'Die Änderungen an dem Template wurden gespeichert.',
    'Rebuild this template' => 'Templates neu aufbauen',
    'Build Options' => 'Aufbauoptionen',
    'Enable dynamic building for this template' => 'Dynamisches Veröffentlichen für dieses Template aktivieren',
    'Rebuild this template automatically when rebuilding index templates' => 'Dieses Template sofort neu veröffentlichen, wenn Index-Templates neu aufgebaut werden',
    'Comment Listing Template' => 'Template für Kommentar-Liste',
    'Comment Preview Template' => 'Template für Kommentar-Vorschau',
    'Search Results Template' => 'Template für Suchergebnisse',
    'Comment Error Template' => 'Template für Kommentar-Fehler',
    'Comment Pending Template' => 'Template für ausstehende Kommentare',
    'Commenter Registration Template' => 'Template für Registrierung von Kommentarautoren',
    'TrackBack Listing Template' => 'Template für TrackBack-Liste',
    'Uploaded Image Popup Template' => 'Popuptemplate für hochgeladenes Bilder',
    'Dynamic Pages Error Template' => 'Fehlertemplate für dynamische Seiten',
    'Link this template to a file' => 'Dieses Template mit einer Datei verknüpfen',
    'Module Body' => 'Modulcode',
    'Template Body' => 'Templatecode',
    'Insert...' => 'Einfügen...',
    'Save this template (s)' => 'Template speichern (s)',
    'Save and Rebuild' => 'Speichern und neu veröffentlichen',
    'Save and rebuild this template (r)' => 'Template speichern und neu veröffentlichen (r)',

    ## ./tmpl/cms/pager.tmpl
    'Show Display Options' => 'Anzeigeoptionen',
    'Display Options' => 'Anzeigeoptionen',
    'Show:' => 'Zeige:',
    '[quant,_1,row]' => '[quant,_1,Zeile,Zeilen]',
    'all rows' => 'Alle Zeilen',
    'Another amount...' => 'Andere Anzahl...',
    'View:' => 'Ansicht:',
    'Compact' => 'Kompakt',
    'Expanded' => 'Erweitert',
    'Actions' => 'Aktionen',
    'Date Display:' => 'Datumsanzeige:',
    'Relative' => 'Relativ (z.B. "Vor 20 Minuten")',
    'Full' => 'Voll',
    'Open Batch Editor' => 'Batch-Editor öffnen',
    'Newer' => 'Neuer',
    'Showing:' => 'Anzeige:',
    'of' => 'von',
    'Older' => 'Älter',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Es wurden alle Dateien neu veröffentlicht.',
    'Your [_1] has been rebuilt.' => '[_1] wurde neu veröffentlicht.',
    'Your [_1] pages have been rebuilt.' => '[_1]-Seiten wurden neu veröffentlicht.',
    'View this page' => 'Diese Seite anzeigen',
    'Rebuild Again' => 'Erneut neu aufbauen',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Feedback-Einstellungen',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'Hier nehmen Sie alle Feedback-Einstellungen einschließlich der Kommentar- und TrackBack-Einstellungen vor.',
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Damit die Änderungen sichtbar werden, sollten Sie die Site jetzt neu veröffentlichen.',
    'Rebuild my site' => 'Site neu aufbauen',
    'Rebuild indexes' => 'Index-Dateien neu veröffentlichen',
    'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'Kommentarauthentifizierung ist derzeit nicht möglich. Ein erforderliches Modul, MIME::Base64 oder LWP::UserAgent, ist nicht installiert. Ihr Administrator kann Ihnen vielleicht weiterhelfen.',
    'Accept comments from' => 'Kommentare akzeptieren von',
    'Anyone' => 'Jedermann',
    'Authenticated commenters only' => 'Nur von authentifizierten Kommentarautoren',
    'No one' => 'Niemandem',
    'Specify from whom Movable Type shall accept comments on this weblog.' => 'Legt fest, von wem Sie Kommentare zu Ihren Einträgen zulassen möchten.',
    'Authentication Status' => 'Authentifizierung',
    'Authentication Enabled' => 'Authentifizierung aktiviert',
    'Authentication is enabled.' => 'Authentifizierung ist aktiviert.',
    'Clear Authentication Token' => 'Authentifizierungs-Token zurücksetzen',
    'Authentication Token:' => 'Authentifizierungs-Token:',
    'Authentication Token Removed' => 'Authentifizierungs-Token entfernt',
    'Please click the Save Changes button below to disable authentication.' => 'Bitte speichern Sie die Änderungen, um die Authentifizierung abzuschalten.',
    'Authentication Not Enabled' => 'Authentifizierung nicht aktiviert',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Hinweis: Sie möchten Kommentare nur von authentifizierten Kommentarautoren zulassen. Allerdings haben Sie die Authentifizierung nicht aktiviert.',
    'Authentication is not enabled.' => 'Authentifizierung nicht aktiviert',
    'Setup Authentication' => 'Authentifizierungs-Setup',
    'Or, manually enter token:' => 'Oder Token manuell eintragen:',
    'Authentication Token Inserted' => 'Authentifizierungs-Token eingefügt',
    'Please click the Save Changes button below to enable authentication.' => 'Bitte speichern Sie die Einstellungen, um die Authentifizierung zu aktivieren.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Einen Link zwischen Ihrem Weblog und einem Authentifizierungs-Dienst einrichten. Sie können TypeKey verwenden (Standard-Dienst von Six Apart, kostenlos) oder einen anderen Dienst.',
    'Require E-mail Address' => 'Email-Adresse Pflichtfeld',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn diese Option aktiv ist, müssen Kommentarautoren eine gültige Email-Adresse angeben.',
    'Immediately publish comments from' => 'Kommentare sofort veröffentlichen von',
    'Trusted commenters only' => 'Nur von vertrauten Kommentarautoren',
    'Any authenticated commenters' => 'Von allen authentifizierten Kommentarautoren',
    'Specify what should happen to non-junk comments after submission.' => 'Legt fest, wie Kommentare, die nicht Junk sind, behandelt werden.',
    'Unpublished comments are held for moderation.' => 'Nicht sofort veröffentlichte Kommentare werden zur Moderation zurückgehalten.',
    'E-mail Notification' => 'Benachrichtigungen',
    'On' => 'Ein',
    'Only when attention is required' => 'Nur wenn ich etwas machen muss',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Legt fest, ob und wann Movable Type Email-Benachrichtigungen über neue Kommentare versendet.',
    'Allow HTML' => 'HTML zulassen',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Wenn die Option aktiv ist, darf HTML in Kommentaren verwendet werden. Andernfalls wird HTML aus Kommentaren automatisch herausgefiltert.',
    'Auto-Link URLs' => 'URLs automatisch verlinken',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Wenn die Option aktiv ist, werden alle URLs automatisch in HTML-Links umgewandelt.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Legt fest, ob TrackBacks von allen Quellen zugelassen sind',
    'Moderation' => 'Moderation', # Translate - Previous (1)
    'Hold all TrackBacks for approval before they\'re published.' => 'Alle TrackBacks moderieren',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Legt fest, ob und wann Sie bei neuen TrackBacks benachrichtigt werden',
    'Junk Score Threshold' => 'Junk-Score Grenzwert',
    'Less Aggressive' => 'konservativ',
    'More Aggressive' => 'aggressiv',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => 'Kommentare und TrackBack erhalten einen Junk-Score zwischen -10 (totaler Junk) und +10 (kein Junk). Feedback, dessen Score kleiner ist als Ihr Grenzwert, wird als Junk eingestuft.',
    'Auto-Delete Junk' => 'Junk automatisch löschen',
    'If enabled, junk feedback will be automatically erased after a number of days.' => 'Wenn die Option aktiv ist, wird zurückgehaltenes Junk-Feedback nach einigen Tagen automatisch gelöscht',
    'Delete Junk After' => 'Junk löschen nach',
    'days' => 'Tagen',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => 'Wenn ein Element als Junk eingestuft wurde, wird es nach dieser Anzahl von Tagen gelöscht.',

    ## ./tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => 'Kommentare veröffentlichen (p)',
    'Delete selected comments (x)' => 'Markierte Kommentare löschen (x)',
    'Junk selected comments (j)' => 'Kommentare sind Junk (j)',
    'Recover selected comments (j)' => 'Kommentare wiederherstellen (j)',
    'Are you sure you want to remove all junk comments?' => 'Wirklich alle Junk-Kommentare entfernen?',
    'Deletes all junk comments' => 'Alle Junk-Kommentare löschen',

    ## ./tmpl/cms/author_table.tmpl

    ## ./tmpl/cms/header.tmpl
    'Go to:' => 'Gehe zu:',
    'Select a blog' => 'Blog auswählen...',
    'System-wide listing' => 'Systemweite Auflistung',

    ## ./tmpl/cms/edit_comment.tmpl
    'The comment has been approved.' => 'Der Kommentar wurde freigegeben.',
    'List &amp; Edit Comments' => 'Kommentare auflisten &amp; bearbeiten',
    'Pending Approval' => 'Freischaltung offen',
    'Junked Comment' => 'Junk-Kommentar',
    'View all comments with this status' => 'Alle Kommentare mit diesem Status ansehen',
    '(Trusted)' => '(vertraut)',
    'Ban&nbsp;Commenter' => 'Kommentator&nbsp;sperren',
    'Untrust&nbsp;Commenter' => 'Kommentator&nbsp;nicht&nbsp;vertrauen',
    '(Banned)' => '(gesperrt)',
    'Trust&nbsp;Commenter' => 'Kommentator&nbsp;vertrauen',
    'Unban&nbsp;Commenter' => 'Sperre&nbsp;aufheben',
    'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentator anzeigen',
    'None given' => 'leer',
    'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
    'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
    'No title' => 'Keine Überschrift',
    'View all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',
    'View all comments posted on this day' => 'Alle Kommentare von diesem Tag anzeigen',
    'View all comments from this IP address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
    'Save this comment (s)' => 'Kommentar(e) speichern',
    'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
    'Final Feedback Rating' => 'Finales Feedback-Rating',
    'Test' => 'Test', # Translate - Previous (1)
    'Score' => 'Score', # Translate - Previous (1)
    'Results' => 'Ergebnis',

    ## ./tmpl/cms/list_author.tmpl
    'You have successfully deleted the authors from the Movable Type system.' => 'Die Autoren wurden erfolgreich aus Movable Type entfernt.',
    'Created By' => 'Erstellt von',
    'Last Entry' => 'Letzter Eintrag',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
    'List &amp; Edit TrackBacks' => 'TrackBacks anzeigen &amp; bearbeiten',
    'Junked TrackBack' => 'Junk-TrackBacks',
    'Status:' => 'Status:', # Translate - Previous (1)
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
    'Delete this TrackBack (x)' => 'Dieses TrackBack löschen (x)',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Pings zu Sites senden...',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installation abgeschlossen.',
    'Upgrade complete.' => 'Upgrade abgeschlossen.',
    'Initializing database...' => 'Initialisiere Datenbank...',
    'Upgrading database...' => 'Upgrade der Datenbank...',
    'Starting installation...' => 'Starte Installation...',
    'Starting upgrade...' => 'Starte Upgrade...',
    'Error during installation:' => 'Fehler während Installation:',
    'Error during upgrade:' => 'Fehler während Upgrade:',
    'Installation complete!' => 'Installation abgeschlossen!',
    'Upgrade complete!' => 'Upgrade abgeschlossen!',
    'Login to Movable Type' => 'Bei Movable Type anmelden',
    'Return to Movable Type' => 'Zurück zu Movable Type',
    'Your database is already current.' => 'Ihre Datenbank ist bereits auf dem aktuellen Stand.',

    ## ./tmpl/cms/cfg_simple.tmpl
    'This screen allows you to control all settings specific to this weblog.' => 'Hier können alle Weblog-spezifischen Einstellungen vorgenommen werden.',
    'Publishing Paths' => 'System-Pfade',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'URL dieses Weblogs (ohne Dateinamen wie z.B. index.html)',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Wurzelverzeichnis dieses Blogs (Verwenden Sie möglichst einen mit \'/\' beginnenden absoluten Pfad. Sie können aber auch einen Pfad relativ zum Movable Type-Verzeichnis angeben.)',
    'You can configure the publishing model for this blog (static vs dynamic) on the ' => 'Ob dieses Blog dynamisch oder statisch publiziert werden soll, legen Sie in den ',
    'Detailed Settings' => 'erweiterten Einstellungen',
    ' page.' => ' fest.',
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'Anzahl der Einträge oder Anzahl der Tage, aus denen Einträge auf der Startseite angezeigt werden sollen',
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => 'Legen Sie fest, wer Kommentare schreiben darf',
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'Wenn Sie möchen, daß sich Kommentarautoren registrieren müssen, verwenden sie den kostenlosen TypeKey-Service.',
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => 'Bestimmen Sie, was mit neuen Kommentaren geschehen sollen. Noch nicht veröffentlichte Kommentare werden zur Moderation zurückgehalten. Junk-Kommentare werden ausgefiltert.',
    'Accept TrackBacks from people who link to your weblog.' => 'TrackBacks von Autoren akzeptieren, die Ihr Weblog verlinkt haben',

    ## ./tmpl/cms/list_blog.tmpl
    'System Shortcuts' => 'Schnellzugriff',
    'Concise listing of weblogs.' => 'Übersicht über alle Weblogs',
    'Create, manage, set permissions.' => 'Berechtigungen verwalten',
    'What\'s installed, access to more.' => 'Plugins verwalten',
    'Multi-weblog entry listing.' => 'Einträge aller Weblog',
    'Multi-weblog tag listing.' => 'Tags aller Weblogs',
    'Multi-weblog comment listing.' => 'Kommentare aller Weblogs',
    'Multi-weblog TrackBack listing.' => 'TrackBacks aller Weblogs',
    'System-wide configuration.' => 'Globale Systemkonfiguration',
    'Find everything. Replace anything.' => 'Über alle Weblogs',
    'What\'s been happening.' => 'Was wann passiert ist',
    'Status &amp; Info' => 'Status &amp; Info', # Translate - Previous (3)
    'Server status and information.' => 'Serverstatus und Information.',
    'Set Up A QuickPost Bookmarklet' => 'QuickPost-Bookmarklet einrichten',
    'Enable one-click publishing.' => 'One-Click-Publishing einrichten',
    'My Weblogs' => 'Meine Weblogs',
    'Important:' => 'Wichtig:',
    'Configure this weblog.' => 'Dieses Weblog konfigurieren',
    'Create a new entry' => 'Eintrag schreiben',
    'Create a new entry on this weblog' => 'Einen Eintrag schreiben',
    'Sort By:' => 'Sortieren nach:',
    'Creation Order' => 'Anlagedatum',
    'Last Updated' => 'Zuletzt aktualisiert',
    'Order:' => 'Reihen- folge:',
    'You currently have no blogs.' => 'Keine Blogs vorhanden',
    'Please see your system administrator for access.' => 'Bitte wenden Sie sich an Ihren Administrator.',

    ## ./tmpl/cms/commenter_table.tmpl
    'Most Recent Comment' => 'Neuester Kommentar',
    'Only show trusted commenters' => 'Nur vertrauenswürdige Kommentarautoren anzeigen',
    'Only show banned commenters' => 'Nur gesperrte Kommentarautoren anzeigen',
    'Only show neutral commenters' => 'Nur neutrale Kommentarautoren anzeigen',
    'View this commenter\'s profile' => 'Kommentatorprofil anzeigen',

    ## ./tmpl/cms/template_table.tmpl

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'Weblog',
    'weblogs' => 'Weblogs',
    'Delete selected weblogs (x)' => 'Ausgewählte Weblogs löschen (x)',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Möchten Sie dieses Weblog wirklich löschen?',
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Eine Liste aller Weblogs im Gesamtsystem. Sie können zu bestehenden Weblogs wechseln, Weblogs löschen und neue Weblogs anlegen.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Die Weblogs wurden erfolgreich aus dem System gelöscht.',
    'Create New Weblog' => 'Neues Weblog anlegen',
    'No weblogs could be found.' => 'Keine Weblogs gefunden.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus.',
    'Search Again' => 'Suchen',
    'Search:' => 'Suchen:',
    'Replace:' => 'Ersetzen:',
    'Replace Checked' => 'Markierung ersetzen',
    'Case Sensitive' => 'Groß/Kleinschreibung',
    'Regex Match' => 'Regex-Match',
    'Limited Fields' => 'Felder eingrenzen',
    'Date Range' => 'Zeitspanne',
    'Is Junk?' => 'Ist Junk?',
    'Search Fields:' => 'Felder durchsuchen:',
    'Comment Text' => 'Kommentartext',
    'E-mail Address' => 'Email-Addresse',
    'Source URL' => 'Quell-URL',
    'Blog Name' => 'Weblog-Name',
    'Text' => 'Text', # Translate - Previous (1)
    'Output Filename' => 'Ausgabe-Dateiname',
    'Linked Filename' => 'Verlinkter Dateiname',
    'From:' => 'Von:',
    'To:' => 'Bis:',
    'Replaced [_1] records successfully.' => '[_1] Wörter ersetzt.',
    'No entries were found that match the given criteria.' => 'Keine Einträge gefunden, auf die der Suchfilter zutrifft.',
    'No comments were found that match the given criteria.' => 'Keine Kommentare gefunden, auf die der Suchfilter zutrifft.',
    'No TrackBacks were found that match the given criteria.' => 'Keine TrackBacks gefunden, auf die der Suchfilter zutrifft.',
    'No commenters were found that match the given criteria.' => 'Keine Kommentarautoren gefunden, auf die der Suchfilter zutrifft.',
    'No templates were found that match the given criteria.' => 'Keine Templates gefunden, auf die der Suchfilter zutrifft.',
    'No log messages were found that match the given criteria.' => 'Keine Logeinträge gefunden, auf die der Suchfilter zutrifft.',
    'No authors were found that match the given criteria.' => 'Keine Benutzer gefunden, auf die der Suchfilter zutrifft',
    'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
    'Show all matches' => 'Zeige alle Treffer',
    '[_1] result(s) found.' => '[_1] Treffer gefunden',

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Systemstatus und -informationen',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Hier werden Sie künftig technische Informationen finden, die bei der Fehlersuche hilfreich sein und technische Support-Anfragen beschleunigen können.',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Einträge speichern (s)',
    'Save this entry (s)' => 'Eintrag speichern (s)',
    'Preview this entry (v)' => 'Vorschau (v)',
    'entry' => 'Eintrag',
    'entries' => 'Einträge',
    'Delete this entry (x)' => 'Eintrag löschen (x)',
    'to rebuild' => 'zum erneuten Veröffentlichen',
    'Rebuild selected entries (r)' => 'Einträge neu veröffentlichen (r)',
    'Delete selected entries (x)' => 'Markierte Einträge löschen (x)',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Auswählen...',
    'You must choose a weblog in which to post the new entry.' => 'Sie müssen einen Weblog auswählen, in dem der neue Eintrag veröffentlicht werden soll.',
    'Select a weblog for this post:' => 'Wählen Sie einen Weblog für diesen Eintrag:',
    'Send an outbound TrackBack:' => 'TrackBack (outbound) senden:',
    'Select an entry to send an outbound TrackBack:' => 'Eintrag wählen, zu dem Sie TrackBack senden möchten:',
    'Accept' => 'Annehmen',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Sie haben derzeit keine Rechte, Weblogs zu bearbeiten. Bitte kontaktieren Sie Ihren Administrator',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Diese Template-Verknüpfung wirklich löschen?',
    'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an.',
    'You must set a valid Local Site Path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an.',
    'Publishing Settings' => 'Grundeinstellungen',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Hier können Sie alle Pfade einstellen und Archiveinstellungen vornehmen.',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fehler: Movable Type konnte das Verzeichnis, in dem das Weblog veröffentlicht werden soll, nicht erzeugen. Legen Sie es manuell an und stellen Sie die Zugriffsrechte so ein, daß Movable Type darin Dateien anlegen kann.',
    'Your weblog\'s archive configuration has been saved.' => 'Die Archivkonfiguration Ihres Weblog wurde gespeichert.',
    'You may need to update your templates to account for your new archive configuration.' => 'Eventuell müssen Sie auch Ihre Templates anpassen, um die neue Archivkonfiguration entsprechend darzustellen.',
    'You have successfully added a new archive-template association.' => 'Sie haben erfolgreich eine neue Verknüpfung zwischen Archiv und Template hinzugefügt.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Eventuell müssen Sie Ihr \'Master Archive Index\'-Template aktualisieren, um die neue Archiv-Konfiguration zu übernehmen.',
    'The selected archive-template associations have been deleted.' => 'Die ausgewählten Verknüpfungen zwischen Archiv und Template wurden gelöscht.',
    'Advanced Archive Publishing:' => 'Erweiterte Archiveinstellungen:',
    'Publish archives to alternate root path' => 'Archive im alternativen Root-Pfad veröffentlichen',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Wählen Sie diese Option nur, wenn Sie Ihre Archive außerhalb des Site-Root-Verzeichnisses veröffentlichen müssen.',
    'Archive URL:' => 'Archiv-URL:',
    'Enter the URL of the archives section of your website.' => 'Geben Sie die URL der Archive Ihres Weblogs an.',
    'Archive Root' => 'Archiv-Root',
    'Enter the path where your archive files will be published.' => 'Geben Sie den Pfad zu Ihren Archivdateien an.',
    'Publishing Preferences' => 'Weitere Einstellungen',
    'Preferred Archive Type:' => 'Bevorzugter Archivierungstyp:',
    'No Archives' => 'Keine Archive',
    'Individual' => 'Einzelne',
    'Daily' => 'Täglich',
    'Weekly' => 'Wöchentlich',
    'Monthly' => 'Monatliche',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Wenn Sie Einzeleinträge verlinken möchten, z.B. über den Permalink, und mehrere Archivarten zur Verfügung stehen, müssen Sie sich entscheiden, auf welchen Archivtyp Sie den Link setzen möchten.',
    'File Extension for Archive Files:' => 'Dateierweiterung für Archivdateien:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Geben Sie die gewünschte Erweiterung der Archivdateien an. Möglich sind \'html\', \'shtml\', \'php\' usw. Hinweis: Geben Sie nicht den führenden Punkt (\'.\') ein.',
    'Dynamic Publishing:' => 'Dynamisches Veröffentlichen:',
    'Build all templates statically' => 'Alle Templates statisch aufbauen',
    'Build only Archive Templates dynamically' => 'Nur Archiv-Templates dynamisch aufbauen',
    'Set each template\'s Build Options separately' => 'Optionen für jedes Template einzeln setzen',
    'Archive Mapping' => 'Archiv-Verknüpfung',
    'Create New Archive Mapping' => 'Neue Archiv-Verknüpfung einrichten',
    'Archive Type:' => 'Archivierungstyp:',
    'INDIVIDUAL_ADV' => 'Einzeln',
    'DAILY_ADV' => 'Täglich',
    'WEEKLY_ADV' => 'Wöchentlich',
    'MONTHLY_ADV' => 'Monatlich',
    'CATEGORY_ADV' => 'Kategorie',
    'Template' => 'Templates',
    'Archive Types' => 'Archivierungstypen',
    'Archive File Path' => 'Archivdatei-Pfad',
    'Preferred' => 'Bevorzugt',
    'Custom...' => 'Angepasst...',
    'archive map' => 'Archiv-Verknüpfung',
    'archive maps' => 'Archiv-Verknüpfungen',

    ## ./tmpl/cms/upload.tmpl
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Klicken Sie auf "Durchsuchen..." um die Datei auszuwählen, die Sie hochladen möchten',
    'File:' => 'Datei:',
    'Set Upload Path' => 'Ziel wählen',
    '(Optional)' => '(optional)',
    'Path:' => 'Ordner:',
    'Upload' => 'Hochladen',

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'Kategorien geändert bzw. hinzugefügt.',
    'You have successfully deleted the selected categories.' => 'Ausgewählten Kategorien erfolgreich gelöscht.',
    'Create new top level category' => 'Neue Kategorie der obersten Ebene erstellen',
    'Create Category' => 'Kategorie erstellen',
    'Collapse' => 'Reduzieren',
    'Expand' => 'Erweitern',
    'Create Subcategory' => 'Unterkategorie erstellen',
    'Move Category' => 'Kategorie verschieben',
    'Move' => 'Verschieben',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate - Previous (4)
    'categories' => 'Kategorien',
    'Delete selected categories (x)' => 'Markierte Kategorien löschen (x)',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Die sekundären Kategorien für diesen Eintrag wurden aktualisiert. Sie müssen den Eintrag für diese Änderungen SPEICHERN, damit sie auf der öffentlichen Site wirksam werden.',
    'Categories in your weblog:' => 'Kategorien Ihres Weblogs:',
    'Secondary categories:' => 'Sekundäre Kategorien:',
    'Assign &gt;&gt;' => 'Zuweisen &gt;&gt;',
    '&lt;&lt; Remove' => '&lt;&lt; Entfernen',

    ## ./tmpl/cms/rebuild-stub.tmpl

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./tmpl/wizard/packages.tmpl
    'Step 1 of 3' => 'Schritt 1 von 3',
    'Requirements Check' => 'Überprüfung der Systemvoraussetzungen',
    'One of the following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Damit Movable Type eine Verbindung zur benötigten Datenbank aufbauen kann, ist eines der folgenden Perl-Pakete erforderlich. Bitte installieren Sie das für Ihre Datenbank benötigte Paket und klicken Sie dann auf \'Erneut versuchen\'.',
    'Missing Database Packages' => 'Nicht vorhandene Datenbank-Pakete',
    'The following optional, feature-enhancing Perl modules could not be found. You may install them now and click \'Retry\' or simply continue without them.  They can be installed at any time if needed.' => 'Die folgenden  optionalen Pakete sind nicht installiert, ermöglichen aber die Nutzung zusätzlicher Funktionen. Wenn Sie möchten, installieren Sie die Pakete jetzt und klicken danach auf \'Erneut versuchen\', oder setzen Sie die Installation einfach fort. Sie können die Pakete auch zu jedem beliebigen Zeitpunkt nachinstallieren.',
    'Missing Optional Packages' => 'Nicht vorhandene optionale Pakete',
    'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber zwingend erforderlich. Bitte installieren Sie sie und klicken dann auf \'Erneut versuchen\'.',
    'Missing Required Packages' => 'Nicht vorhandene erforderliche Pakete',
    'Minimal version requirement:' => 'Mindestens erforderliche Version:',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Alle erforderlichen Pakete vorhanden. Sie brauchen keine weiteren Pakete zu installieren.',
    'Back' => 'Zurück',
    'Retry' => 'Erneut versuchen',

    ## ./tmpl/wizard/optional.tmpl
    'Step 3 of 3' => 'Schritt 3 von 3',
    'Mail Configuration' => 'Mailkonfiguration',
    'Your mail configuration is complete. To finish with the configuration wizard, press \'Continue\' below.' => 'Mailkonfiguration abgeschlossen. \'Weiter\' startet die Installation.',
    'You can configure you mail settings from here, or you can complete the configuration wizard by clicking \'Continue\'.' => 'Hier können Sie Ihre Einstellungen zum Versand von Email vornehmen und testen. \'Weiter\' schließt den Konfigurationshelfer ab.',
    'An error occurred while attempting to send mail: ' => 'Mailversand fehlgeschlagen',
    'MailTransfer' => 'MailTransfer', # Translate - Previous (1)
    'Select One...' => 'Auswählen...',
    'SendMailPath' => 'SendMailPath', # Translate - Previous (1)
    'The physical file path for your sendmail.' => 'Pfad zu sendmail',
    'SMTP Server' => 'SMTP-Server',
    'Address of your SMTP Server' => 'Adresse des SMTP-Servers',
    'Mail address for test sending' => 'Empfängeradresse für Testmails',
    'Send Test Email' => 'Test-Email verschicken',

    ## ./tmpl/wizard/complete.tmpl
    'Congratulations! You\'ve successfully configured [_1] [_2].' => 'Herzlichen Glückwunsch! Sie haben die Konfiguration der [_1] [_2] erfolgreich abgeschlossen',
    'This is a copy of your configuration settings.' => 'Ihre Konfigurationsdatei enthält folgende Einträge:',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Die Konfigurationsdatei konnte nicht angelegt werden. Bitte überprüfen Sie, ob Schreibrechte für das Verzeichnis vorhanden sind und versuchen es erneut.',
    'Install' => 'Movable Type Installieren',

    ## ./tmpl/wizard/header.tmpl
    'Movable Type' => 'Movable Type', # Translate - Previous (2)
    'Movable Type Configuration Wizard' => 'Movable Type-Konfigurationshelfer',

    ## ./tmpl/wizard/start.tmpl
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type erfordert JavaScript. Bitte aktivieren Sie es in Ihren Browsereinstellungen und laden diese Seite dann neu.',
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Es ist bereits eine Konfigurationsdatei vorhanden. Wenn Sie den Konfigurationshelfer erneut ausführen möchten, entfernen Sie die Datei zuerst aus Ihrem Movable Type-Verzeichnis.',
    'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Der Movable Type-Konfigurationshelfer hilft Ihnen, die zur Installation von Movable Type erforderlichen Einstellungen vorzunehmen.',
    'Static Web Path' => 'Statischer Pfad',
    'Due to your server\'s configuration it is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory).' => 'Bitte wählen Sie einen vom Internet aus erreichenbaren Ort wie z.B. das Web-Rootverzeichnis Ihres Servers.',
    'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Das Verzeichnis wurde entweder umbenannt oder an einen Ort außerhalb des Movable Type-Verzeichnisses verschoben.',
    'Please specify the web-accessible URL to this directory below.' => 'Bitte geben Sie die Webadresse (URL) des Verzeichnisses an.',
    'Static web path URL' => 'Statische Webadresse (URL)',
    'This can be in the form of http://example.com/mt-static/ or simply /mt-static' => 'Das kann in absoluter (http://beispiel.de/mt-static/) oder relativer (/mt-static) Form geschehen.',
    'Begin' => 'Anfangen',

    ## ./tmpl/wizard/configure.tmpl
    'You must set your Database Path.' => 'Geben Sie einen Datenbankpfad an.',
    'You must set your Database Name.' => 'Geben Sie einen Datenbanknamen an.',
    'You must set your Username.' => 'Geben Sie einen Benutzernamen an.',
    'You must set your Database Server.' => 'Geben Sie einen Datenbankserver an.',
    'Step 2 of 3' => 'Schritt 2 von 3',
    'Database Configuration' => 'Datenbankkonfiguration',
    'Your database configuration is complete. Click \'Continue\' below to configure your mail settings.' => 'Datenbankkonfiguration abgeschlossen. "Weiter" führt zur Mailkonfiguration.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href=' => 'Bitte geben Sie die Verbindungsdaten Ihrer Datenbank ein. Wenn Ihre Datenbank nicht im Dropdown-Menü erscheint, ist möglicherweise das zur Verwendung der Datenbank erforderliche Perl-Modul nicht installiert. In diesem Fall überprüfen Sie bitte Ihre Installation und klicken dann auf <a href=',
    'An error occurred while attempting to connect to the database: ' => 'Es konnte keine Verbindung zur Datenbank hergestellt werden: ',
    'Database' => 'Datenbank',
    'Database Path' => 'Datenbankpfad',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Pfad zu Ihrer BerkeleyDB- oder SQLite-Datenbank ',
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'Die Standardangabe \'./db\' legt Ihre Datenbank in einem Unterverzeichnis des Movable Type-Ordners an.',
    'Database Name' => 'Datenbankname',
    'The name of your SQL database (this database must already exist).' => 'Name Ihrer SQL-Datenbank (die Datenbank muss bereits existieren)',
    'The username to login to your SQL database.' => 'Benutzername Ihrer SQL-Datenbank',
    'The password to login to your SQL database.' => 'Passwort Ihrer SQL-Datenbank',
    'Database Server' => 'Serveradresse',
    'This is usually \'localhost\'.' => 'Meistens \'localhost\'',
    'Database Port' => 'Port',
    'This can usually be left blank.' => 'Braucht normalerweise nicht angegeben zu werden',
    'Database Socket' => 'Socket',
    'Test Connection' => 'Verbindung testen',

    ## ./tmpl/wizard/footer.tmpl

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'System',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Untitled' => 'Ohne Name',
    'Edit' => 'Bearbeiten',
    'Unpublish' => 'Nicht mehr veröffentlichen',
    'More like this' => 'Ähnliche Einträge',
    'From this blog' => 'Aus diesem Blog',
    'On this entry' => 'Zu diesem Eintrag',
    'By commenter identity' => 'Nach Kommentarautoren-Identität',
    'By commenter name' => 'Nach Kommentarautoren-Name',
    'By commenter email' => 'Nach Kommentarautoren-Email',
    'By commenter URL' => 'Nach Kommentarautoren-URL',
    'On this day' => 'An diesem Tag',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Movable Type Aktivitätsprotokoll',
    'Movable Type System Activity' => 'Movable Type Systemaktivität',

    ## ./tmpl/feeds/feed_entry.tmpl
    'From this author' => 'Von diesem Autoren',

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Quelle',
    'By source blog' => 'Nach Quelle',
    'By source title' => 'Nach Name der Quelle',
    'By source URL' => 'By URL der Quelle',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Eintrag #[_2] ("[_3]") einen noch nicht freigeschalteten Kommentar erhalten. Sie müssen diesen Kommentar freischalten, damit er auf Ihrem Weblog erscheint.',
    'Approve this comment:' => 'Kommentar freischalten:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Auf Ihrem Blog [_1] wurde zu Eintag #[_2] ("[_3]") ein neuer Kommentar veröffentlicht.',
    'View this comment:' => 'Kommentar anzeigen:',
    'Comments:' => 'Kommentar:',

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Update: [_2]', # Translate - Previous (4)

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Vielen Dank, daß Sie die Aktualisierungsbenachrichtungen von [_1] abonnieren möchten. Bitte folgen Sie zur Bestätigung diesem Link:',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Wenn der Link nicht anklickbar ist, kopieren Sie ihn einfach und fügen ihn in der Adresszeile Ihres Browers ein.',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Eintrag #[_2] ("[_3]") ein noch nicht freigeschaltetes TrackBack erhalten. Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Kategorie #[_2] ("[_3]") ein noch nicht freigeschaltetes TrackBack erhalten. Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'Approve this TrackBack:' => 'TrackBack freischalten:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert, zu Eintrag #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert, zu Kategorie #[_2] ([_3]).',
    'View this TrackBack:' => 'TrackBack ansehen:',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - Previous (4)

    ## ./t/driver-tests.pl

    ## ./t/blog-common.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## Other phrases, with English translations.
    'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen', # Translate - New (3) OK
    'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins', # Translate - New (5) OK
    '_BLOG_CONFIG_MODE_DETAIL' => 'Detailmodus',
    'Updating category placements...' => 'Aktualisiere Kategorieanordnung...', # Translate - New (3) OK
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'Zuvor erschien in diesem Blog <a href="[_1]">[_2]</a>.',
    'RSS 1.0 Index' => 'RSS 1.0 Index', # Translate - Previous (3)
    '_USAGE_BOOKMARKLET_4' => 'Nachdem Sie das QuickPost-Lesezeichen installiert haben, können Sie jederzeit einen Eintrag veröffentlichen. Klicken Sie auf den QuickPost-Link und verwenden Sie das Popup-Fenster, um einen Eintrag zu schreiben und zu veröffentlichen.',
    'Remove Tags...' => 'Tags entfernen...',
    '_BLOG_CONFIG_MODE_BASIC' => 'Vereinfachter Modus',
    'DAILY_ADV' => 'Täglich',
    '_USAGE_PERMISSIONS_3' => 'Sie können entweder einen Autoren aus dem Menü auswählen oder die komplette Liste aller Autoren ansehen und dann Autoren auswählen.',
    'Tags to remove from selected entries' => 'Von den gewählten Einträgen zu entfernende Tags',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Bitte klicken Sie auf den Bestätigungslink in der Mail, die an [_1] verschickt wurde. So wird sichergestellt, daß die angegebene Email-Adresse wirklich Ihnen gehört.',
    'Manage Notification List' => 'Benachrichtigungen verwalten',
    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Diese Archivseite enthält alle "[_1]"-Einträge der Kategorie <strong>[_2]</strong>. Die Einträge sind in chronologischer Reihenfolge angeordnet.',
    'Individual' => 'Einzelne',
    'An error occurred while testing for the new tag name.' => 'Fehler beim Überprüfen des neuen Tag-Namens aufgetreten.', # Translate - New (10) OK
    'Updating blog old archive link status...' => 'Aktualisiere Linkstatus der Alteinträge...', # Translate - New (6) OK
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Eine Liste aller Kommentare in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Mit diesem Passwort können Sie sich nun am System anmelden. Danach können Sie das Passwort ändern.',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or author profile.' => 'Um Registierung von Kommentarautoren zu ermöglichen geben Sie ein TypeKey-Token in den Weblogeinstellungen oder dem Autorenprofil an.', # Translate - New (18) OK
    '_USAGE_COMMENT' => 'Bearbeiten Sie den Kommentar. Speichern Sie die Änderungen, wenn Sie fertig sind. Um die Änderungen zu sehen, müssen Sie den Eintrag neu veröffentlichen.',
    '_SEARCH_SIDEBAR' => 'Suchen',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Wird verwendet, wenn es beim dynamischen Aufbau einer Seite zu einem Fehler kommt.',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Fehler beim Einlesen von [_1]. Beachten Sie die <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">Hinweise des Feed Validators</a> und versuchen Sie es ggf. erneut.',
    'View image' => 'Bild ansehen', # Translate - New (2) OK
    'Date-Based Archive' => 'Datumsbasiertes Archiv',
    'Unban Commenter(s)' => 'Kommentatorsperre aufheben',
    'Individual Entry Archive' => 'Einzelarchive',
    'Daily' => 'Täglich',
    'Setting blog basename limits...' => 'Setze Basename-Limits...', # Translate - New (4) OK
    'Assigning visible status for comments...' => 'Setzte Sichtbarkeitsstatus für Kommentare...', # Translate - New (5) OK
    'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
    'Powered by [_1]' => 'Powered by [_1]', # Translate - New (3) OK
    'Create a feed widget' => 'Feed Widget anlegen',
    '_USAGE_UPLOAD' => 'Laden Sie diese Datei in Ihren lokalen Site-Pfad <a href="javascript:alert(\'[_1]\')">(?)</a>. Optional können Sie die Datei in ein beliebiges Unterverzeichnis laden. Tragen Sie dazu den Pfad in das Formularfeld ein. Besteht das Verzeichnis noch nicht, wird es automatisch angelegt.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> ist das nächste Archiv.',
    'Updating commenter records...' => 'Aktualisiere Kommentarautoren-Datensätze...', # Translate - New (3) OK
    'Assigning junk status for comments...' => 'Setze Junk-Status der Kommentare...', # Translate - New (5) OK
    'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft', # Translate - New (3) OK
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Baue (mit <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) Vorlage \'[_3]\' neu auf',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">NEU VERÖFFENTLICHEN</a>, damit die Änderungen sichtbar werden.',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Keine Konfigurationsdatei gefunden. Möglicherweise haben Sie vergessen, mt-config.cgi-original in mt-config.cgi umzubennen.', # Translate - New (13) OK
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Falls verwendet, muss das dritte Argument von add_callback ein Objekt des Types MT::Plugin sein.', # Translate - New (15) OK
    'Blog Administrator' => 'Blog-Administrator',
    'CATEGORY_ADV' => 'Kategorie',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Sie möchten die Passwörter der gewählten Benutzer zurücksetzen. Den Benutzern werden zufällig erzeugte neue Passwörter per Email zugeschickt werden.\n\n\Forsetzen?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'Um dynamische Kommentare anzeigen zu können, ist ein Comment Listing-Template erforderlich.', # Translate - New (13) OK
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper', # Translate - Previous (3)
    'Assigning entry basenames for old entries...' => 'Weise Alteinträgen Basenames zu...', # Translate - New (6) OK
    'Assigning blog administration permissions...' => 'Weise Administrationsrechte zu...', # Translate - New (4) OK
    '_USAGE_COMMENTS_LIST_BLOG' => 'Eine Liste aller Kommentare zu [_1], die Sie filtern, verwalten und bearbeiten können.',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Mailversand fehlgeschlagen ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, das Passwort anzufordern.', # Translate - New (15) OK
    'Error saving entry: [_1]' => 'Speichern des Eintrags fehlgeschlagen: [_1]', # Translate - New (4) OK
    'Category Archive' => 'Kategorie-Archiv',
    'index' => 'Index', # Translate - New (1) OK
    'Updating user permissions for editing tags...' => 'Weise Nutzerrechte für Tag-Verwaltung zu...', # Translate - New (6) OK
    'Assigning author types...' => 'Weise Benutzerkontenarten zu...', # Translate - New (3) OK
    '_USAGE_EXPORT_1' => 'Indem Sie Einträge aus Movable Type exportieren, erhalten Sie <b>persönliche Sicherungen</b> Ihrer Weblog-Einträge. Die Daten werden in einem Format exportiert, in dem sie jederzeit zurück in das System importiert werden können. Das Exportieren von Einträgen dient nicht nur der Sicherung, Sie können damit auch <b>Inhalte zwischen Weblogs verschieben</b>.',
    '_SYSTEM_TEMPLATE_PINGS' => 'Wird verwendet, wenn TrackBack-Popups eingesetzt werden (auslaufend).',
    'Setting default blog file extension...' => 'Setze Standard-Dateierweitung...', # Translate - New (5) OK
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> ist die vorherige Kategorie.',
    'Entry Creation' => 'Neuer Eintrag',
    'Assigning visible status for TrackBacks...' => 'Setzte Sichtbarkeitsstatus für TrackBacks...', # Translate - New (5) OK
    'Atom Index' => 'ATOM Index',
    '_USAGE_PLACEMENTS' => 'Verwenden Sie die untenstehenden Optionen, um die sekundären Kategorien zu bearbeiten, denen dieser Eintrag zugeordnet ist. Die linke Liste zeigt alle Kategorien an, denen der Eintrag noch nicht zugeordnet ist. Die rechte Liste zeigt die Kategorien an, denen der Eintrag bereits zugordnet ist.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Stellt für Google-basierte Blogsuchen erforderliche Tags zur Verfügung. Kostenloser <a href=\'http://www.google.com/apis/\'>API-Schlüssel</a> erforderlich.',
    'Invalid priority level [_1] at add_callback' => 'Ungültiger Prioritätslevel [_1] von add_callback', # Translate - New (7) OK
    'Add Tags...' => 'Tags hinzufügen...',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => 'Diese Seite enthält einen einzelnen am <strong>[_1]</strong> erschienenen Blogeintrag.',
    '_THROTTLED_COMMENT_EMAIL' => 'Ein Kommentator Ihres Weblogs [_1] wurde automatisch gesperrt. Der Kommentator hat mehr als die erlaubte Anzahl an Kommentaren in den letzten [_2] Sekunden veröffentlicht. Diese Sperre schützt Sie vor Spam-Skripts. Die gesperrte IP-Adresse ist [_3]. Wenn diese Sperrung ein Fehler war, können Sie die IP-Adresse wieder entsperren. Wählen Sie die IP-Adresse [_4] aus der IP-Sperrliste und löschen Sie die Adresse aus der Liste.',
    'Search Template' => 'Template suchen', # Translate - New (2) OK
    'MONTHLY_ADV' => 'Monatlich',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Für das Versenden von Email mittels SMTP ist Mail::Sendmail erforderlich: [_1]', # Translate - New (13) OK
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Um das Widget in Ihren Blog einzufügen, benutzen Sie bitte den <a href="[_1]">Widget Manager</a> oder diesen MTInclude-Tag:',
    'Manage Tags' => 'Tags verwalten',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Wird verwendet, wenn einem Kommentator eine Kommentarvorschau anzeigt wird.',
    'Download file' => 'Datei herunterladen', # Translate - New (2) OK
    '_USAGE_BOOKMARKLET_3' => 'Um das QuickPost-Lesezeichen zu installieren, ziehen Sie den folgenden Link in die Lesezeichenleiste oder in das Lesezeichenmenü Ihres Browsers:',
    '_USAGE_PASSWORD_RESET' => 'Unten können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufällig erzeugtes neues Passwort an seine Adresse verschickt werden: [_1].',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Es ist bereits eine Datei namens \'[_1]\' vorhanden. (Um bereits vorhandene hochgeladene Dateien überschreiben zu können, installieren Sie File::Temp.)', # Translate - New (21) OK
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI und DBD::SQLite2 sind erforderlich, wenn Sie eine SQLite2-Datenbank einsetzen möchten.', # Translate - New (15)
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Kein gültiger sendmail-Pfad gefunden. Versuchen Sie stattdessen SMTP zu verwenden.', # Translate - New (18) OK
    'Error loading default templates.' => 'Laden der Standard-Templates fehlgeschlagen.', # Translate - New (4) OK
    '4th argument to add_callback must be a CODE reference.' => 'Viertes Argument von add_callback muss eine CODE-Referenz sein.', # Translate - New (10) OK
    '_USAGE_LIST_POWER' => 'Eine Liste der Einträge in [_1] im Stapelverarbeitungsmodus. Im nachfolgenden Formular können Sie alle Werte für jeden angezeigten Eintrag ändern. Klicken Sie auf die Schaltfläche SPEICHERN, nachdem Sie die gewünschten Änderungen vorgenommen haben. Die standardmäßigen Steuerelemente für "Einträge auflisten &amp; bearbeiten" (Filter, Paging) arbeiten im Stapelverarbeitungsmodus, wie Sie es gewöhnt sind.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Oder zur <a href="[_1]">Hauptseite</a> oder den <a href="[_2]">Systemeinstellungen</a> zurückkehren',
    '_ERROR_CONFIG_FILE' => 'Ihre Movable Type Konfigurationsdatei fehlt oder kann nicht gelesen werden. Bitte lesen Sie die Movable Type-Dokumention: <a href="#">Installation and Configuration</a>.',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Ein zufällig erzeugtes neues Passwort wird an seine Adresse [_2] verschickt werden.\n\nForsetzen?',
    '_USAGE_PING_LIST_BLOG' => 'Eine Liste aller TrackBack-Pings in [_1], die Sie filtern, verwalten und bearbeiten können.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt aus dem Internet installieren. Mehr dazu auf der <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type Styles</a>-Seite.',
    'Monthly' => 'Monatliche',
    'Refreshing template \'[_1]\'.' => 'Baue Template \'[_1]\' neu auf',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Wählen Sie die zu verwendende Importdatei. Alternativ verwendet Movable Type automatisch die Importdatei, die es im <code>import</code>-Unterordner Ihrer Installation findet.',
    'Tags to add to selected entries' => 'Zu gewählten Einträgen hinzuzufügende Tags',
    'Ban Commenter(s)' => 'Kommentarautoren sperren',
    '_USAGE_VIEW_LOG' => 'Überprüfen Sie das <a href="[_1]">Aktivitätsprotokoll</a>, um den Fehler zu finden.',
    'You must define an Individual template in order to display dynamic comments.' => 'Um dynamische Kommentare anzeigen zu können, ist ein Invidual-Template erforderlich.', # Translate - New (12) OK
    '_USAGE_BOOKMARKLET_1' => 'Wenn Sie QuickPost einrichten, können Sie einfach neue Einträge veröffentlichen, ohne direkt in Movable Type zu arbeiten.',
    '_USAGE_ARCHIVING_3' => 'Wählen Sie den Archivtypen und ordnen Sie dann ein Archivtemplate zu.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Wird bei der Suche im Blog angezeigt.',
    'UTC+10' => 'UTC+10 (East Australian Standard Time)',
    'INDIVIDUAL_ADV' => 'Einzeln',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Überspringe Template \'[_1]\', da es ein Custom Template zu sein scheint.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Die Einstellungen wurden in der Datei <tt>[_1]</tt> gespeichert. Möchten Sie Änderungen vornehmen, klicken Sie auf \'Zurück\' um zur entsprechenden Seite zu gelangen.',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => '\'[_1]\'-Tag außerhalb eines Kommentar-Kontexts verwendet - \'MTComments\'-Container erforderlich.', # Translate - New (22) OK
    '_ERROR_CGI_PATH' => 'Ihre CGIPath-Konfiguration fehlt oder ist fehlerhaft. Bitte lesen Sie die Movable Type-Dokumention: <a href="#">Installation and Configuration</a>.',
    'Assigning template build dynamic settings...' => 'Weise dynamische Einstellungen für Template-Aufbau zu...', # Translate - New (5) OK
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Wird verwendet, wenn Kommentar-Popups eingesetzt werden (auslaufend).',
    '_USAGE_CATEGORIES' => 'Verwenden Sie Kategorien, um Einträge bestimmten Themen zuzuordnen oder Ihr Weblog zu ordnen. Sie können einen Eintrag einer Kategorie gleich beim Schreiben oder auch später zuordnen. Unterkategorien stehen zur Verfügung.',
    'Updating author web services passwords...' => 'Aktualisierte Passwörter für Web Services...', # Translate - New (5) OK
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => '[_1]-Tag außerhalb eines Zeitintervall-Kontexts (täglich, wöchentlich, monatlich).', # Translate - New (13) OK
    'Master Archive Index' => 'Master Archiv Index',
    'Weekly' => 'Wöchentlich',
    'Unpublish TrackBack(s)' => 'TrackBacks nicht mehr veröffentlichen',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Viele weitere Einträge finden Sie auf der <a href="[_1]">Hauptseite</a> und im <a href="[_2]">Archiv</a>.',
    '_USAGE_PREFS' => 'Hier können Sie eine Anzahl von optionalen Einstellungen für Ihr Weblog, Ihre Archive und Kommentare, Ihre Feeds und für Benachrichtigungen vornehmen. Wenn Sie ein neues Weblog anlegen, werden diese Werte auf gängige Standardwerte gesetzt.',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => '\'[_1]\'-Tag außerhalb eines Eintrags-Kontexts verwendet - \'MTEntries\'-Container erforderlich.', # Translate - New (22) OK
    'WEEKLY_ADV' => 'Wöchentlich',
    'Processing templates for weblog \'[_1]\'' => 'Verarbeite Templates von \'[_1]\'', # Translate - New (5) OK
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Wird verwendet, wenn ein Kommentar nicht sofort veröffentlicht wird.',
    'Unpublish Comment(s)' => 'Kommentare nicht mehr veröffentlichen',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => 'Danach erschien <a href="[_1]">[_2]</a>.',
    'If you have a TypeKey identity, you can ' => 'Wenn Sie eine TypeKey-Identität besitzen, können Sie ', # Translate - New (8) OK
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Eine Liste aller Einträge in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ungültiges Datumsformat \'[_1]\';  muss \'MM/TT/JJJJ HH:MM:SS AM|PM\' sein (AM|PM optional)', # Translate - New (16) OK
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Bitte geben Sie die Verbindungsdaten Ihrer Datenbank ein. Wenn Ihre Datenbank nicht im Dropdown-Menü erscheint, ist möglicherweise das zur Verwendung der Datenbank erforderliche Perl-Modul nicht installiert. In diesem Fall überprüfen Sie bitte Ihre Installation und klicken dann auf <a href="?__mode=configure">Installation neu starten</a> ',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Ziehen Sie die Widgets, die Sie verwenden möchten, in die Spalte <strong>Installierte Widgets</strong>.',
    'Manage Categories' => 'Kategorien verwalten',
    '_USAGE_ARCHIVING_2' => 'Sie können jedes Archivtemplate in Ihren Template-Einstellungen konfigurieren.',
    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
    'View Activity Log For This Weblog' => 'Protokoll ansehen',
    'Migrating any "tag" categories to new tags...' => 'Migriere "Tag"-Kategorien zu neuen Tags...', # Translate - New (7) OK
    'Refresh Template(s)' => 'Template(s) neu aufbauen',
    'Assigning basename for categories...' => 'Weise Kategorien Basenames zu...', # Translate - New (4) OK
    '_USAGE_NOTIFICATIONS' => 'Eine Liste der Personen, die benachrichtigt werden, wenn Sie einen neuen Eintrag veröffentlichen. Um eine neue Person hinzuzufügen, geben Sie einfach die Email-Adresse ein. Das URL-Feld ist optional.',
    'Updating [_1] records...' => 'Aktualisier [_1]-Einträge...', # Translate - New (3) OK
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Es ist bereits eine Datei namens \'[_1]\' vorhanden. Öffnen der angelegten temporären Datei fehlgeschlagen: [_2]', # Translate - New (15) OK
    '_USAGE_COMMENTERS_LIST' => 'Eine Liste der authentifizierten Kommentarautoren bei [_1]. Die Kommentarautoren können Sie unten bearbeiten.',
    '_ERROR_DATABASE_CONNECTION' => 'Ihre Datenbankkonfiguration ist fehlerhaft. Bitte lesen Sie die Movable Type-Dokumention: <a href="#">Installation and Configuration</a>.',
    '_USAGE_BANLIST' => 'Hier können Sie IP-Adressen sperren, Kommentare abzugeben oder TrackBack-Pings an Ihr Weblog zu senden. Sie können der Sperrliste sowohl neue IP-Adressen hinzufügen oder gesperrte IP-Adressen wieder löschen.',
    'RSS 2.0 Index' => 'RSS 2.0 Index', # Translate - Previous (3)
    '_USAGE_FEEDBACK_PREFS' => 'Hier können Sie festlegen, ob und wie Feedback und TrackBacks auf Ihrem Weblog angezeigt werden.',
    '_USAGE_AUTHORS' => 'Eine Liste aller Benutzer im Movable Type-System. Sie können die Berechtigungen eines Autors bearbeiten, indem Sie auf dessen Namen klicken. Wenn Sie das Kontrollkästchen "Löschen" aktivieren und anschließend auf LöSCHEN klicken, werden Autoren dauerhaft gelöscht. HINWEIS: Wenn Sie einen Autor lediglich aus einem bestimmmten Blog entfernen möchten, bearbeiten Sie die Berechtigungen des Autors, um ihn zu entfernen. Beim Löschen von Autoren unter Verwendung von LöSCHEN werden Autoren komplett aus dem System entfernt.',
    '_INDEX_INTRO' => '<p>Die <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">Movable Type Installationsanleitung</a> enthält alle Hinweise zur Installation. Der <a rel="nofollow" href="mt-check.cgi">Movable Type System Check</a> untersucht Ihr System und sagt Ihnen, ob alle erforderlichen Pakete vorhanden sind.</p>',
    'Configure Weblog' => 'Weblog einrichten',
    'Select a Design using StyleCatcher' => 'Design per StyleCatcher aussuchen',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> ist das vorherige Archiv.',
    '_USAGE_NEW_AUTHOR' => 'Hier können Sie einen neuen Autoren anlegen und einem oder mehreren Weblogs zuordnen.',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Die folgenden Pakete sind <strong>optional</strong> und müssen nur installiert werden, wenn sie die Funktionen, die das jeweilige Paket bietet, nutzen möchten.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Sie haben ein neues Movable Type-Passwort angefordert. Es wurde automatisch ein neues Passwort erzeugt. Es lautet:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Eine Liste aller Kommentare in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    'You need to provide a password if you are going to\ncreate new authors for each author listed in your blog.\n' => 'Um neue Benutzerkonten für alle Autoren anlegen zu können,\ngeben Site bitte ein Passwort an.\n', # Translate - New (22) OK
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Wird verwendet, wenn auf ein Popup-Bild geklickt wird.',
    '_USAGE_EXPORT_2' => 'Um Ihre Einträge zu exportieren, klicken Sie auf den folgenden Link ("Einträge exportieren von [_1]"). Um die exportierten Daten in einer Datei zu speichern, klicken Sie auf den Link, whrend Sie <code>Option</code> auf dem Macintosh bzw. <code>Umschalt</code> auf dem PC gedrückt halten. Sie können auch alle angezeigten Daten markieren und in ein anderes Dokument kopieren. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exportieren aus dem Internet Explorer?</a>)',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Eine Liste aller TrackBack-Pings in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    'Manage my Widgets' => 'Widgets verwalten',
    'Updating blog comment email requirements...' => 'Aktualisere Email-Einstellungen der Kommentarfunktion...', # Translate - New (5) OK
    'Assigning junk status for TrackBacks...' => 'Setze Junk-Status der TrackBacks...', # Translate - New (5) OK
    'Publish Entries' => 'Einträge veröffentlichen',
    'No executable code' => 'Kein ausführbarer Code', # Translate - New (3) OK
    '_USAGE_PING_LIST_OVERVIEW' => 'Eine Liste aller TrackBack-Pings in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    'AUTO DETECT' => 'Auto-detect',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Hinweis:</strong> Movable Type-Exportdateien enthalten nur die Blogeinträge selbst und ersetzen kein vollständiges Backup. Das Handbuch enthält weitere Informationen zu diesem Thema.</em>',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => '<a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a> und',
    '_USAGE_PLUGINS' => 'Eine Liste aller Plugins, die derzeit im System registriert sind.',
    '_USAGE_PERMISSIONS_2' => 'Um einen anderen Autoren zu bearbeiten, wählen Sie den entsprechenden Autoren aus dem Menü aus.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Unzureichende Benutzerrechte für die Bearbeitung von Templates', # Translate - New (8) OK
    'Bad ObjectDriver config: [_1] ' => 'ObjectDriver-Einstellungen fehlerhaft: [_1] ', # Translate - New (4) OK
    'Untrust Commenter(s)' => 'Kommentarautoren nicht mehr vertrauen',
    '_USAGE_PROFILE' => 'Hier bearbeiten Sie Ihr Autorenprofil. Wenn Sie Ihren Benutzernamen und Ihr Passwort ändern, werden die Login-Informationen sofort aktualisiert und Sie müssen sich nicht erneut anmelden.',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Herzlichen Glückwunsch! Das Widget <strong>[_1]</strong> wurde erfolgreich angelegt. Sie können seine Anzeigeoptionen weiter <a href="[_2]">anpassen</a>.',
    'Category' => 'Kategorie',
    '_USAGE_ENTRYPREFS' => 'Die Feldkonfiguration legt fest, welche Felder in Ihrer Eingabemaske für neue Einträge erscheinen. Sie könnnen die vordefinierten Einstellungen verwenden (einfach oder erweitert) oder die Felder frei auswählen.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Weitere Plugins finden Sie im <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Assigning custom dynamic template settings...' => 'Weise benutzerspezifische Einstellungen für dynamische Templates zu...', # Translate - New (5) OK
    'Updating comment status flags...' => 'Aktualisiere Kommentarstatus...', # Translate - New (4) OK
    'Stylesheet' => 'Stylesheet', # Translate - Previous (1)
    'RSD' => 'RSD', # Translate - Previous (1)
    '_USAGE_ARCHIVE_MAPS' => 'Diese Funktion erlaubt es Ihnen, Archiv-Templates mit den verschiedene Archivtypen zu verknüpfen. So können Sie z.B. zwei unterschiedliche Ansichten Ihrer monatlichen Archive erzeugen, einen Listen- und eine Kalenderansicht.',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => '\'[_1]\'-Tag außerhalb eines Ping-Kontextes verwendet - \'MTPings\'-Container erforderlich.', # Translate - New (22) OK
    '_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in kurzer Folge abgegeben. Zum Schutz vor Spam steht Ihnen Kommentarfunktion daher erst wieder in einigen Augenblicken zur Verfügung. Vielen Dank für Ihr Verständnis.',
    'Trust Commenter(s)' => 'Kommentarautoren vertrauen',
    '_USAGE_SEARCH' => 'Sie können Suchen &amp; Ersetzen einsetzen, um Daten in Weblogs zu finden und optional zu ersetzen. WICHTIG: Verwenden Sie die Funktion "Ersetzen" mit Vorsicht. Der Vorgang kann <b>nicht</b> rückgängig gemacht werden.',
    'Manage Templates' => 'Templates verwalten',
    '_USAGE_PERMISSIONS_1' => 'Sie bearbeiten die Benutzerrechte von <b>[_1]</b>. Unter den allgemeinen Einstellungen finden Sie eine Liste aller Blogs, zu denen Sie <b>[_1]</b> als Benutzer hinzufügen können.',
    '_USAGE_BOOKMARKLET_2' => 'Sie können die Bestandteile von QuickPost frei konfigurieren und die Schaltflächen aktivieren, die Sie häufig verwenden.',
    '_external_link_target' => '_top',
    '_AUTO' => '1',
    'Creating entry category placements...' => 'Lege Kategoriezuweisungen an...', # Translate - New (4) OK
    'Add/Manage Categories' => 'Kategorien hinzufügen/verwalten',
    'Setting new entry defaults for weblogs...' => 'Setze Standardeinstellungen für neue Einträge...', # Translate - New (6) OK
    'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Geschrieben <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]', # Translate - New (9) OK
    'Updating entry week numbers...' => 'Aktualisiere Wochendaten...', # Translate - New (4) OK
    'Recover Password(s)' => 'Passwort anfordern',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitede/">Movable Type <$MTVersion$></a>',
    'Assigning comment/moderation settings...' => 'Weise Kommentierungseinstellungen zu...', # Translate - New (4) OK
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Diese Seite enthält alle "[_1]"-Einträge in <strong>[_2]</strong>. Sie sind in chronologischer Reihenfolge angeordnet.',
    '_USAGE_ARCHIVING_1' => 'Wählen Sie die Archivtypen aus, die Sie für Ihr Weblog verwenden möchten. Sie können für jeden Archivtypen optional mehrere Archivtemplates verwenden.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> ist die nächste Kategorie.',
    '_USAGE_PERMISSIONS_4' => 'Jedes Weblog kann mehrere Autoren haben. So können jedem Weblog Autoren hinzufügen. Legen Sie einen neuen Autoren an und vergeben Sie dann die benötigten Rechte.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Anlegen der temporären Datei fehlgeschlagen. Bitte überprüfen Sie die TempDir-Einstellung in mt.cfg (derzeit \'[_1]\') und stellen Sie sicher, daß für diesen Ordner Schreibrechte vorhanden sind.', # Translate - New (19) OK
    '_USAGE_TAGS' => 'Mit Tags können Sie Einträge schnell und einfach verschlagworten und gruppieren.',
    '_USAGE_BOOKMARKLET_5' => 'Falls Sie unter Windows mit dem Internet Explorer arbeiten, können Sie die Option "QuickPost" zum Kontextmenü von Windows hinzufügen. Klicken Sie auf den nachfolgenden Link, um die Eingabeaufforderung des Browsers zum öffnen der Datei zu akzeptieren. Beenden Sie das Programm, und starten Sie den Browser erneut, um den Link zum Kontextmenü hinzuzufügen.',
    '_USAGE_IMPORT' => 'Mit dem Mechanismus zum Importieren von Einträgen können Sie Einträge aus einem anderen Weblog-System importieren. Das Handbuch enthält ausführliche Anweisungen zum Importieren.',
    'Main Index' => 'Hauptindex',
    'Assigning category parent fields...' => 'Weise Elternkategorien zu...', # Translate - New (4) OK
    '_USAGE_ENTRY_LIST_BLOG' => 'Eine Liste aller Einträge in [_1], die Sie filtern, verwalten und bearbeiten können.',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Das Verzeichnis <strong>mt-static</strong>, das Teil jeder Movable Type-Installation ist, enthält eine Reihe wichtiger Systemdateien wie Bilder, JavaScript-Code und Stylesheets.', # Translate - New (23) OK
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>StyleCatcher erfordert ein globales Theme Repository, in dem die Designvorlagen gespeichert werden. Wird bei einem Blog kein Theme-Pfad angegeben, wird auf den hier angegebenen Pfad zurückgegriffen. Andernfalls werden verwendete Designvorlagen in den entsprechenden Ordner kopiert. Die hier angegebenen Ordner müssen bereits vorhanden und mit Schreibrechten ausgestattet sein.</p>',
    '_USAGE_EXPORT_3' => 'Durch Klicken auf den nachfolgenden Link werden alle aktuellen Weblog-Einträge exportiert. In der Regel ist das Übertragen der Einträge ein einmaliger Vorgang. Sie können den Vorgang aber jederzeit wiederholen.',
    'Setting blog allow pings status...' => 'Weise Ping-Status zu...', # Translate - New (5) OK
    'Send Notifications' => 'Benachrichtigungen versenden',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Wird bei der Kommentarvalidierung verwendet.',
    'Edit All Entries' => 'Alle Einträge bearbeiten',
    'Rebuild Files' => 'Dateien neu veröffentlichen',

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
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind erforderlich, wenn Sie eine PostgreSQL-Datenbank einsetzen möchten.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind erforderlich, wenn Sie eine SQLite-Datenbank einsetzen möchten.',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI und DBD::SQLite2 sind erforderlich, wenn Sie eine SQLite 2.x-Datenbank einsetzen möchten.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities ist zur Codierung einiger Sonderzeichen erforderlich. Diese Funktion kann jedoch mit der Option NoHTMLEntities in mt.cfg deaktiviert werden.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent ist optional und nur erforderlich, wenn Sie das TrackBack-System, den weblogs.com-Ping oder den "Kürzlich aktualisiert"-Ping von MT einsetzen möchten.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite ist optional und nur erforderlich, wenn Sie die XML-RPC Server-Implementierung von MT einsetzen möchten',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp ist optional und nur erforderlich, wenn Sie vorhandene Dateien beim Hochladen überschreiben können möchten.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick ist optional und nur erforderlich, wenn Sie automatisch Miniaturansichten von hochgeladenen Bildern erzeugen möchten.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable ist optional und nur für einige MT-Plugins von Drittanbietern erforderlich.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA ist optional. Durch die Installation wird der Anmeldevorgang für die Kommentarregistrierung beschleunigt.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 ist für die Aktivierung der Kommentarregistrierung erforderlich.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist für den Einsatz der Atom-API erforderlich.',
    'Data Storage' => 'Datenbank-',
    'Required' => 'erforderlichen ',
    'Optional' => 'optionalen ',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Das ist ein lokalisiertes Perl-Modul',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Bei der Verarbeitung von [_1] ist ein Fehler aufgetreten. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Konnte IP-Adresse der Ursprungsadresse [_1] nicht auflösen',
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation: Domain-IP stimmt nicht mit Ping-IP der Quell-URL [_1] überein - Domain-IP: [_2], Ping-IP: [_3]',
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domain-IP stimmt nicht mit Ping-IP der Quell-URL [_1] überein - Domain: IP [_2], Ping-IP: [_3]',
    'No links are present in feedback' => 'Feedback enthält keine Links',
    'Number of links exceed junk limit ([_1])' => 'Anzahl der Links übersteigt Junk-Grenze ([_1])',
    'Number of links exceed moderation limit ([_1])' => 'Anzahl der Links übersteigt Moderations-Grenze ([_1])',
    'Link was previously published (comment id [_1]).' => 'Link wurde bereits zuvor veröffentlicht (Kommentar-ID [_1]).',
    'Link was previously published (TrackBack id [_1]).' => 'Link wurde bereits zuvor veröffentlicht (TrackBack-ID [_1]).',
    'E-mail was previously published (comment id [_1]).' => 'Email-Adresse wurde bereits zuvor veröffentlicht (Kommentar-ID [_1]).',
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Wortfilter-Treffer in \'[_1]\': \'[_2]\'.',
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderation: Wortfilter-Treffer für \'[_1]\': \'[_2]\'.',
    'domain \'[_1]\' found on service [_2]' => 'Domain \'[_1]\' gefunden bei [_2]',
    '[_1] found on service [_2]' => '[_1] gefunden bei [_2]',

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/es.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/nl.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/de.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher muss erst global konfiguriert werden, bevor es benutzt werden kann:',
    'Configure plugin' => 'Plugin konfigurieren',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.',
    'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'Can\'t find included template module \'[_1]\'' => 'Kann verwendetes Template-Modul \'[_1]\' nicht finden',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Loading template \'[_1]\' failed: [_2]' => 'Laden des Templates \'[_1]\' fehlgeschlagen: [_2]',
    'Permission denied.' => 'Keine Berechtigung.',
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Die Widgetgruppe \'[_1]\' kann nicht dupliziert werden. Bitte wählen Sie einen bisher noch nicht verwendeten Namen.',
    'Moving [_1] to list of installed modules' => '[_1] auf die Liste der installierten Module verschoben',
    'Error opening file \'[_1]\': [_2]' => 'Fehler beim Öffnen der Datei \'[_1]\': [_2]',
    'First Widget Manager' => 'Erste Widgetgruppe',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/es.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/nl.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/de.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/fr.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'Sie haben keine(n) [_1] zum Löschen gewählt.',
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'Löschen eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Es wird daher empfohlen, das Benutzerkonto zu belassen und stattdessen dem Benutzer alle Zugriffsrechte zu entziehen. Möchten Sie das Konto dennoch löschen?',
    'Deleting an author is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?' => 'Löschen von Benutzerkonten kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Es wird daher empfohlen, die Konten zu belassen und stattdessen den Benutzern alle Zugriffsrechte zu entziehen. Möchten Sie die [_1] markierten Konten dennoch löschen?',
    'Are you sure you want to delete this [_1]?' => 'Diese [_1] wirklich löschen?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Die [_1] ausgewählten [_2] wirklich löschen?',
    'to delete' => 'zu Löschen',
    'You did not select any [_1] [_2].' => 'Sie haben keine [_1] zu [_2] gewählt',
    'You must select an action.' => 'Sie müssen eine Aktion wählen',
    'to mark as junk' => 'zum Junk markieren',
    'to remove "junk" status' => 'zum "Junk"-Status zurücksetzen',
    'Enter email address:' => 'Email-Adresse eingeben:',
    'Enter URL:' => 'URL eingeben:',

    ## ./lib/MT.pm
    'Message: [_1]' => 'Nachricht: [_1]',
    'Unnamed plugin' => 'Plugin hat keinen Namen',
    '[_1] died with: [_2]' => '[_1] wurde abgebrochen mit der Meldung: [_2]',
    'Plugin error: [_1] [_2]' => 'Plugin-Fehler: [_1] [_2]',

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Laden des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Weblog \'[_1]\' konnte nicht geladen werden: [_2]',

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Freischalten/Sperren nicht möglich',
    'The approval could not be committed: [_1]' => 'Konnte nicht übernommen werden: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Archivtyp \'[_1]\' wurde vorher nicht ausgewählt',
    'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' erforderlich',
    'Building category archives, but no category provided.' => 'Keine Kategorien angegeben.',
    'You did not set your Local Archive Path' => 'Kein Local Archive Path angegeben',
    'Building category \'[_1]\' failed: [_2]' => 'Kategorie \'[_1]\' erzeugen fehlgeschlagen: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Eintrag \'[_1]\' erzeugen fehlgeschlagen: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Datumsbasiertes Archiv \'[_1]\' erzeugen fehlgeschlagen: [_2]',
    'You did not set your Local Site Path' => 'Kein Local Site Path angegeben',
    'Template \'[_1]\' does not have an Output File.' => 'Template \'[_1]\' hat keine Output-Datei.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Bei der Veröffentlichung zeitgeplanter Einträge ist ein Fehler aufgetreten: [_1]',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Konnte Lock für Systemtask nicht setzen. Stellen Sie sicher, daß Schreibrechte für das TempDir ([_1]) vorhanden sind.',
    'Error during task \'[_1]\': [_2]' => 'Fehler während Task \'[_1]\': [_2]',
    'Scheduled Tasks Update' => 'Scheduled Tasks Update', # Translate - Previous (3)
    'The following tasks were run:' => 'Folgende Tasks wurden ausgeführt:',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
    'Category loop detected' => 'Kategorieschleife festgestellt',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'Das vierte Argument von add_callback muss eine Perl-CODE-Referenz sein',

    ## ./lib/MT/Upgrade.pm
    'Invalid upgrade function: [_1].' => 'Ungültige Upgrade-Funktion: [_1].',
    'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1].',
    'Creating initial weblog and author records...' => 'Lege erstes Weblog und Benutzer an...',
    'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
    'First Weblog' => 'Erstes Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Kann Liste der Standardvorlagen nicht finden - wo befindet sich \'default-templates.pl\'? Fehler: [_1]',
    'Creating new template: \'[_1]\'.' => 'Lege neues Template an: \'[_1]\'',
    'Mapping templates to blog archive types...' => 'Verknüpfe Templates mit Archiven...',
    'Upgrading table for [_1]' => 'Upgrade Tabelle [_1]',
    'Upgrading database from version [_1].' => 'Upgrade der Datenbank auf Version [_1]',
    'Database has been upgraded to version [_1].' => 'Datenbank auf Movable Type-Version [_1] aktualisiert',
    'Plugin \'[_1]\' upgraded successfully.' => 'Plugin \'[_1]\' erfolgreich aktualisiert.',
    'Plugin \'[_1]\' installed successfully.' => 'Plugin \'[_1]\' erfolgreich installiert.',
    'Setting your permissions to administrator.' => 'Setze Benutzerrechte auf \'Administrator\'...',
    'Creating configuration record.' => 'Lege Konfiguration ab...',
    'Creating template maps...' => 'Verknüpfe Templates...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Template-ID [_1] mit [_2] ([_3])',
    'Mapping template ID [_1] to [_2].' => 'Verknüpfe Template-ID [_1] mit [_2]',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Parsing-Fehler im Template \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Build-Fehler im Template \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Öffenen der verlinkten Datei \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Datei \'[_1]\' kann nicht gelesen werden: [_2]',
    'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'Skalieren auf [_1]x[_2] fehlgeschlagen: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad auf NetPBM-Tools eingestellt.',

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
    'Action: Junked (score below threshold)' => 'Aktion: Junked (Score unterschreitet Grenzwert)',
    'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
    'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] abgebrochen: [_2]',
    'Unnamed Junk Filter' => 'Namenloser Junk Filter',
    'Composite score: [_1]' => 'Gesamt-Score: [_1]',

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> ohne &lt;/MT[_1]>',
    'Error in &lt;MT[_1]> tag: [_2]' => 'Fehler im &lt;MT[_1]>-Tag: [_2]',

    ## ./lib/MT/Request.pm

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/DefaultTemplates.pm

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
    'Invalid Archive Type setting \'[_1]\'' => 'Ungültige Konfiguration des Archiv-Typs \'[_1]\'',

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Tag muss einen gültigen Namen haben',
    'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.',

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Keine WeblogsPingURL definiert in mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Keine MTPingURL definiert in mt.cfg',
    'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
    'Ping error: [_1]' => 'Ping-Fehler: [_1]',

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Benutzer \'[_1]\' (ID: #[_2]) hat Eintrag #[_3] hinzugefügt',

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Laden des Weblogs fehlgeschlagen: [_1]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'Kein Stream',
    'No Blog' => 'Kein Blog',
    'Can\'t rewind' => 'Kann nicht zurückspulen',
    'Can\'t open \'[_1]\': [_2]' => 'Kann \'[_1]\' nicht öffnen: [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'Kann Verzeichnis \'[_1]\' nicht öffnen: [_2]',
    'No readable files could be found in your import directory [_1].' => 'Im Import-Verzeichnis [_1] konnten keine lesbaren Dateien gefunden werden.',
    'Importing entries from file \'[_1]\'' => 'Importieren der Einträge aus Datei \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Passwort erforderlich, um\n',
    'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
    'Creating new author (\'[_1]\')...' => 'Lege neuen Autoren an (\'[_1]\')...',
    'ok\n' => 'OK\n',
    'failed\n' => 'fehlgeschlagen\n',
    'Saving author failed: [_1]' => 'Speichern von Autor fehlgeschlagen: [_1]',
    'Assigning permissions for new author...' => 'Weise neuem Benutzer Rechte zu...',
    'Saving permission failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Creating new category (\'[_1]\')...' => 'Lege neue Kategorie an (\'[_1]\')...',
    'Saving category failed: [_1]' => 'Speichern von Kategorie fehlgeschlagen: [_1]',
    'Invalid status value \'[_1]\'' => 'Ungültiger Status-Wert \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Ungültiger Ping-Status \'[_1]\'',
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Kann Eintrag mit Zeitstempel \'[_1]\' nicht finden... überspringe Kommentare und gehe zu nächstem Eintrag.\n',
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importiere in vorhandenen Eintrag [_1] (\'[_2]\')\n',
    'Saving entry (\'[_1]\')...' => 'Speichere Eintrag (\'[_1]\')...',
    'ok (ID [_1])\n' => 'OK (ID [_1])\n',
    'Saving entry failed: [_1]' => 'Speichern von Eintrag fehlgeschlagen: [_1]',
    'Saving placement failed: [_1]' => 'Speichern von Platzierung fehlgeschlagen: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar an (von \'[_1]\')...',
    'Saving comment failed: [_1]' => 'Speichern von Kommentar fehlgeschlagen: [_1]',
    'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
    'Creating new ping (\'[_1]\')...' => 'Lege neuen Ping an (\'[_1]\')...',
    'Saving ping failed: [_1]' => 'Speichern von Ping fehlgeschlagen: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Export von \'[_1]\' fehlgeschlagen bei: [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Ungültiges Datumsformat \'[_1]\'; muss sein',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
    'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
    'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Unbekannte MailTransfer-Methode \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'Das Verschicken von Mails via SMTP erfordert, daß Ihr Server',
    'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Kein gültiger Pfad zu sendmail auf dem Computer. ',
    'Exec of sendmail failed: [_1]' => 'Ausführung von sendmail fehlgeschlagen: [_1]',

    ## ./lib/MT/ConfigMgr.pm
    'Config directive [_1] without value at [_2] line [_3]' => 'Direktive [_1] ohne Parameter bei [_2] Zeile [_3]',
    'No such config variable \'[_1]\'' => 'Keine Konfigurationsvariable \'[_1]\' vorhanden',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
    'No web services password assigned.  Please see your author profile to set it.' => 'Kein Web Services-Passwort vorhanden. Bitte legen Sie auf Ihrer Profilseite eines fest.',
    'No blog_id' => 'blog_id fehlt',
    'Invalid blog ID \'[_1]\'' => 'Ungültige blog_id \'[_1]\'',
    'Invalid login' => 'Login ungültig',
    'No posting privileges' => 'Keine Schreibrechte',
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '\'mt_[_1]\' kann nur 0 oder 1 sein (war \'[_2]\')',
    'No entry_id' => 'entry_id fehlt',
    'Invalid entry ID \'[_1]\'' => 'Ungültige Eintrags-ID \'[_1]\'',
    'Not privileged to edit entry' => 'Keine Bearbeitungsrechte',
    'Not privileged to delete entry' => 'Keine Löschrechte',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Eintrag \'[_1]\' (Eintrag #[_2]) von \'[_3]\' (Benutzer #[_4]) via XML-RPC gelöscht',
    'Not privileged to get entry' => 'Keine Leserechte',
    'Author does not have privileges' => 'Autor hat keine Rechte',
    'Not privileged to set entry categories' => 'Keine Rechte, Kategorien zu vergeben',
    'Publish failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
    'Not privileged to upload files' => 'Keine Upload-Rechte',
    'No filename provided' => 'Kein Dateiname angegeben',
    'Invalid filename \'[_1]\'' => 'Ungültiger Dateiname \'[_1]\'',
    'Error making path \'[_1]\': [_2]' => 'Fehler beim Anlegen des Ordners \'[_1]\': [_2]',
    'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Template-Methoden sind aufgrund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
    'Failed login attempt by unknown user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer \'[_1]\'',
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'Fehlgeschlagener Anmeldeversuch mit falschem Passwort durch Benutzer \'[_1]\' (ID: [_2])',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Benutzer \'[_1]\' (ID:[_2]) erfolgreich angemeldet',
    'Invalid login.' => 'Login ungültig',
    'User \'[_1]\' (ID:[_2]) logged out' => 'Benutzer \'[_1]\' (ID:[_2]) abgemeldet',
    'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu gross',
    'Unknown action [_1]' => 'Unbekannte Aktion [_1]',

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
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Das Datenbankverzeichnis (\'[_1]\') existiert nicht.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Das Datenbankverzeichnis (\'[_1]\') ist nicht beschreibbar.',
    'Tie \'[_1]\' failed: [_2]' => 'Verknüpfung \'[_1]\' failed: [_2]',
    'Failed to generate unique ID: [_1]' => 'Anlegen der individuellen Kennung fehlgeschlagen: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'Aufheben der Verknüpfung von \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Lesen fehlgeschlagen mit SQL-Fehler [_1]',
    'Count [_1] failed on SQL error [_2]' => 'Zählung[_1] fehlgeschlagen wegen SQL-Fehler [_2]',
    'Prepare failed' => 'Prepare fehlgeschlagen',
    'Execute failed' => 'Execute fehlgeschlagen',
    'existence test failed on SQL error [_1]' => 'Existence-Test fehlgeschlagen wegen SQL-Fehler [_1]',
    'Insertion test failed on SQL error [_1]' => 'Insertion-Test fehlgeschlagen wegen SQL-Fehler [_1]',
    'Update failed on SQL error [_1]' => 'Update fehlgeschlagen wegen SQL-Fehler [_1]',
    'No such object.' => 'Kein solches Objekt.',
    'Remove failed on SQL error [_1]' => 'Entfernen fehlgeschlagen wegen SQL-Fehler [_1]',
    'Remove-all failed on SQL error [_1]' => 'Alle Entfernen fehlgeschlagen wegen SQL-Fehler [_1]',

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'Die Datenbankdatei (\'[_1]\') ist nicht beschreibbar.',
    'Your database directory (\'[_1]\') is not writable.' => 'Das Datenbankverzeichnis (\'[_1]\') ist nicht beschreibbar.',
    'Connection error: [_1]' => 'Verbindungsfehler: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'undefined type: [_1]' => 'Nicht definierter Typ: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included file \'[_1]\'' => 'Kann verwendete Datei \'[_1]\' nicht finden',
    'Error opening included file \'[_1]\': [_2]' => 'Fehler beim Öffnen der verwendeten Datei \'[_1]\': [_2]',
    'Unspecified archive template' => 'Nicht spezifiziertes Archiv-Template',
    'Error in file template: [_1]' => 'Fehler in Datei-Template: [_1]',
    'Can\'t find template \'[_1]\'' => 'Kann Vorlage \'[_1]\' nicht finden',
    'Can\'t find entry \'[_1]\'' => 'Kann Eintrag \'[_1]\' nicht finden',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'Sie haben einen [_1]-Tag ohne Argument verwendet.',
    'You have an error in your \'category\' attribute: [_1]' => 'Fehler im \'category\'-Attribut: [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'Fehler im \'tag\'-Attribut: [_1]',
    'No such author \'[_1]\'' => 'Kein Autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Sie haben ein \'[_1]\' Tag ausserhalb eines Eintragskontexts verwendet; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Sie haben mit einem [_1]-Tag \'[_2]\'-Archive verlinkt, ohne diese vorher zu veröffentlichen.',
    'Could not create atom id for entry [_1]' => 'Konnte keine ATOM-ID für Eintrag [_1] erzeugen',
    'To enable comment registration, you ' => 'Um Kommetar-Registrierung zu aktivieren, müssen Sie ',
    '(You may use HTML tags for style)' => '(HTML-Tags erlaubt)',
    'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Tag ohne Datumskontext verwendet.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Sie haben einen \'[_1]\'-Tag außerhalb eines Kommentarkontexts verwendet; ',
    'You used an [_1] without a date context set up.' => 'Sie haben [_1] ohne Datumskontext verwendet.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit Tages-, Wochen- oder Monatsarchiven verwendet werden.',
    'Couldn\'t get daily archive list' => 'Konnte Tagesarchive nicht lesen',
    'Couldn\'t get monthly archive list' => 'Konnte Monatsarchive nicht lesen',
    'Couldn\'t get weekly archive list' => 'Konnte Wochenarchive nicht lesen',
    'Unknown archive type [_1] in <MTArchiveList>' => 'Unbekannter Archivtyp [_1] in <MTArchiveList>',
    'Group iterator failed.' => 'Gruppeniterator fehlgeschlagen.',
    'You used an [_1] tag outside of the proper context.' => 'Sie haben ein [_1]-Tag außerhalb seines Kontexts verwendet.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Sie haben ein [_1]-Tag außerhalb eines Tages-, Wochen-, oder Monats-',
    'Could not determine entry' => 'Konnte Eintrag nicht bestimmen',
    'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: richtig ist JJJJMM',
    'No such category \'[_1]\'' => 'Keine Kategorie \'[_1]\'',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'Sie haben <$MTCategoryDescription$> außerhalb seines Kontexts verwendet.',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] kann nur bei aktiven Kategorie-Archiven verwendet werden.',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem \'category\'-Attribut des Tags.',
    'You failed to specify the label attribute for the [_1] tag.' => 'Kein Label-Attribut des [_1]-Tags angegeben.',
    'You used an \'[_1]\' tag outside of the context of ' => 'Sie verwenden ein \'[_1]\'-Tag außerhalb des Kontexts von ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse außerhalb von MTSubCategories verwendet',
    'MT[_1] must be used in a category context' => 'MT[_1] muss im Kategoriekontext verwendet werden',
    'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
    'Error sorting categories: [_1]' => 'Fehler beim Sortieren der Kategorien: [_1]',

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'aus Regel',
    'from test' => 'aus Test',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'Diese Funktion ist experimentell. Deaktivieren Sie in mt.cfg den SafeMode, um sie benutzen zu können.',
    'Not allowed to view blog [_1]' => 'Keine Rechte zum Anzeigen von Blog [_1]',
    'Loading blog with ID [_1] failed' => 'Einlesen des Blogs mit der ID [_1] fehlgeschlagen',
    'Can\'t load \'[_1]\' template.' => 'Kann Vorlage \'[_1]\' nicht laden.',
    'Building template failed: [_1]' => 'Anlegen der Vorlage fehlgeschlagen: [_1]',
    'Invalid date spec' => 'Ungültiges Datumsformat',
    'Can\'t load template [_1]' => 'Kann Vorlage [_1] nicht lesen',
    'Building archive failed: [_1]' => 'Anlegen des Archivs fehlgeschlagen: [_1]',
    'Invalid entry ID [_1]' => 'Ungültige Eintrags-ID [_1]',
    'Entry [_1] is not published' => 'Eintrag [_1] nicht veröffentlicht',
    'Invalid category ID \'[_1]\'' => 'Ungültige Kategorie-ID \'[_1]\'',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Bitte geben Sie eine gültige Email-Adresse an.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Erforderliches Parameter blog_id fehlt. Bitte konfigurieren Sie die Benachrichtungsfunktion entsprechend.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'Email-Benachrichtungen wurden nicht konfiguriert! Sie müssen EmailVerificationSecret in mt.cfg konfigurieren.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Ungültiges Redirect-Parameter. Sie müssen einen zur verwendeten Domain gehörenden Pfad angeben.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Die Email-Adresse \'[_1]\' ist bereits in der Benachrichtigunsliste für dieses Weblog.',
    'Please verify your email to subscribe' => 'Bitte bestätigen Sie Ihre Email-Adresse',
    'The address [_1] was not subscribed.' => 'Die Adresse [_1] wurde hinzugefügt.',
    'The address [_1] has been unsubscribed.' => 'Die Adresse [_1] wurde entfernt.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Eine Suche ist bereits aktiv. Bitte warten ',
    'Search failed. Invalid pattern given: [_1]' => 'Suche fehlgeschlagen - ungültiges Suchmuster angegeben: [_1]',
    'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Kein alternatives Template für das Template \'[_1]\' angegeben',
    'Opening local file \'[_1]\' failed: [_2]' => 'Öffnen der lokalen Datei \'[_1]\' fehlgeschlagen: [_2]',
    'Building results failed: [_1]' => 'Ergebnisausgabe fehlgeschlagen: [_1]',
    'Search: query for \'[_1]\'' => 'Suche nach \'[_1]\'',
    'Search: new comment search' => 'Suche nach neuen Kommentaren',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Benutzername erforderlich',
    'You failed to validate your password.' => 'Passwort und Wiederholung des Passworts stimmen nicht überein',
    'You failed to supply a password.' => 'Passwort erforderlich',
    'The value you entered was not a valid email address' => 'Email-Adresse ungültig',
    'Password recovery word/phrase is required.' => 'Passwort-Erinnerungsfrage erforderlich',
    'User \'[_1]\' upgraded database to version [_2]' => 'Benutzer \'[_1]\' hat ein Upgrade auf Version [_2] durchgeführt',
    'Invalid session.' => 'Ungültige Session',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Bitte kontaktieren Sie Ihren Administrator, um das Upgrade von Movable Type durchzuführen. Sie haben nicht die erforderlichen Rechte.',

    ## ./lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'Sie müssen ein Ping-Template definieren, um Pings anzeigen zu können.',
    'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
    'Need a TrackBack ID (tb_id).' => 'Benötige TrackBack ID (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'Sie dürfen keine TrackBack-Pings senden.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Sie senden zu viele TrackBacks zu schnell hintereinander.',
    'Need a Source URL (url).' => 'Quelladresse erforderlich (url).',
    'Invalid URL \'[_1]\'' => 'Ungültige URL \'[_1]\'',
    'This TrackBack item is disabled.' => 'TrackBack hier nicht aktiv.',
    'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
    'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
    'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack für Kategorie \'[_1]\' (ID:[_2])',
    'Rebuild failed: [_1]' => 'Neuaufbau fehlgeschlagen: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'RSS-Feed kann nicht angelegt werden \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Neuer TrackBack-Ping bei Eintrag [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Neuer TrackBack-Ping bei Kategorie [_1] ([_2])',

    ## ./lib/MT/App/Comments.pm
    'No id' => 'Keine ID',
    'No such comment' => 'Kein entsprechender Kommentar',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
    'IP Banned Due to Excessive Comments' => 'IP gesperrt - zu viele Kommentare',
    'Invalid request' => 'Ungültige Anfrage',
    'No such entry \'[_1]\'.' => 'Kein Eintrag \'[_1]\'.',
    'You are not allowed to post comments.' => 'Kommentare sind nicht erlaubt.',
    'Comments are not allowed on this entry.' => 'Bei diesem Eintrag sind Kommentare nicht erlaubt.',
    'Comment text is required.' => 'Kommentartext ist Pflichtfeld.',
    'Registration is required.' => 'Registrierung ist erforderlich.',
    'Name and email address are required.' => 'Name und Email sind Pflichtfelder.',
    'Invalid email address \'[_1]\'' => 'Ungültige Email-Adresse \'[_1]\'',
    'Comment save failed with [_1]' => 'Speichern des Kommentars fehlgeschlagen: [_1]',
    'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
    'Commenter save failed with [_1]' => 'Speichern des Kommentarautorens fehlgeschlagen: [_1]',
    'New Comment Posted to \'[_1]\'' => 'Neuer Kommentar bei \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'Anmeldung konnte aufgrund eines Datenbankfehlers nicht durchgeführt werden ([_1])',
    'Couldn\'t get public key from url provided' => 'Public Key konnte von der angegebenen Adresse nicht gelesen werden',
    'No public key could be found to validate registration.' => 'Kein Public Key zur Validierung gefunden.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey-Signaturbestätigung gab [_1] zurück (nach [_2] Sekunden) und bestätigte [_3] mit [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'Die TypeKey-Signatur ist veraltet ([_1] seconds old). Stellen Sie sicher, daß die Uhr Ihres Servers richtig geht.',
    'The sign-in validation failed.' => 'Anmeldung fehlgeschlagen.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Kommentarautoren müssen eine Email-Adresse angeben. Wenn Sie das tun möchten, melden Sie sich an und erlauben Sie dem Authentifizierungsdienst, Ihre Email-Adresse weiterzuleiten.',
    'Couldn\'t save the session' => 'Session konnte nicht gespeichert werden',
    'This weblog requires commenters to pass an email address' => 'Kommentarautoren müssen eine Email-Adresse angeben',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'Anmelden erfordert eine sichere Signatur, Abmelden erfordert logout=1 als Paramater',
    'The sign-in attempt was not successful; please try again.' => 'Sign-in war nicht erfolgreich; bitte erneut versuchen.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'Validierung des Sign-ins war nicht erfolgreich. Bitte Konfiguration überprüfen und erneut versuchen.',
    'No such entry ID \'[_1]\'' => 'Keine Eintrags-ID \'[_1]\'',
    'You must define an Individual template in order to ' => 'Sie müssen ein individuales Template festlegen um',
    'You must define a Comment Listing template in order to ' => 'Sie müssen ein Kommentarlisten-Template festlegen um',
    'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag spezifiziert. Vielleicht gibt es ein Problem mit dem Template?',
    'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
    'You must define a Comment Pending template.' => 'Sie müssen ein Template definieren für Kommentarmoderation.',
    'You must define a Comment Error template.' => 'Sie müssen ein Template definieren für Kommentarfehler.',
    'You must define a Comment Preview template.' => 'Sie müssen ein Template definieren für Kommentarvorschau.',

    ## ./lib/MT/App/Wizard.pm
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Testmail vom Movable Type-Konfigurationshelfer',
    'This is the test email sent by your new installation of Movable Type.' => 'Diese Testmail wurde von Ihrer neuer Movable Type-Installation verschickt.',

    ## ./lib/MT/App/ActivityFeeds.pm
    'An error occurred while generating the activity feed: [_1].' => 'Fehler beim Erzeugen des Aktivitäts-Feeds aufgetreten: [_1].',
    'No permissions.' => 'Keine Rechte.',
    '[_1] Weblog TrackBacks' => 'TrackBacks für Weblog [_1]',
    'All Weblog TrackBacks' => 'Alle TrackBacks',
    '[_1] Weblog Comments' => 'Kommentare zu Weblog [_1]',
    'All Weblog Comments' => 'Alle Kommentare',
    '[_1] Weblog Entries' => 'Einträge des Blogs [_1]',
    'All Weblog Entries' => 'Alle Einträge',
    '[_1] Weblog Activity' => 'Weblogaktivität von [_1]',
    'All Weblog Activity' => 'Weblogaktivität gesamt',
    'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'Keine Berechtigung',
    'Invalid blog' => 'Ungültiges Blog',
    'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
    'Invalid author_id' => 'Ungültige Autoren-ID',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Ungültiger Benutzername \'[_1]\' beim Versuch verwendet, ein Passwort anzufordern',
    'Username or password recovery phrase is incorrect.' => 'Benutzername oder Passwort-Erinnerungssatz falsch',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'Passwortanforderung für Benutzer \'[_1]\' fehlgeschlagen, da kein Erinnerungssatz angegeben wurde.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'Kein Erinnerungssatz hinterlegt. Bitte wenden Sie sich an Ihren Administrator.',
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Ungültige Passwortanforderung (verwendeter Erinnerungssatz: \'[_1]\' )',
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'Passwortanforderung für Benutzer \'[_1]\' fehlgeschlagen, da keine Email-Adresse angegeben.',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'Keine Email-Adresse hinterlegt. Bitte wenden Sie sich an Ihren Administrator.',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Passwort von Benutzer \'[_1]\' (ID:[_2]) zurückgesetzt und an [_3] verschickt',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Mailversand fehlgeschlagen([_1]); bitte beheben Sie das Problem, dann',
    'Invalid type' => 'Ungültiger Typ',
    'No such tag' => 'Kein solcher Tag',
    'You are not authorized to log in to this blog.' => 'Kein Zugang zu diesem Weblog.',
    'No such blog [_1]' => 'Kein Weblog [_1]',
    'Weblog Activity Feed' => 'Weblog-Aktivitätsprotokoll',
    '(author deleted)' => '(Autor gelöscht)',
    'All Feedback' => 'Jedes Feedback',
    'log records' => 'Log-Einträge',
    'System Activity Feed' => 'System-Aktivitätsfeed',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Aktivitätsprotokoll von \'[_1]\' (ID:[_2]) on \'[_3]\' zurückgesetzt',
    'Activity log reset by \'[_1]\'' => 'Aktivitätsprotokoll zurückgesetzt von \'[_1]\'',
    'Import/Export' => 'Import/Export', # Translate - Previous (2)
    'Invalid blog id [_1].' => 'Ungültige Blog-ID [_1].',
    'Invalid parameter' => 'Ungültiges Parameter',
    'Load failed: [_1]' => 'Laden fehlgeschlagen: [_1]',
    '(no reason given)' => '(unbekannte Ursache)',
    '(untitled)' => '(ohne Überschrift)',
    'Create template requires type' => 'Typangabe zum Anlegen von Templates erforderlich',
    'New Template' => 'Neues Template',
    'New Weblog' => 'Neues Weblog',
    'Author requires username' => 'Autor erfordert Benutzername',
    'Author requires password' => 'Autor erfodert Benutzername',
    'Author requires password recovery word/phrase' => 'Author erfordert Passwort-Erinnerungssatz',
    'Email Address is required for password recovery' => 'Email-Adresse bei Passwort-Anfrage erforderlich',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'Diese Email-Adresse ist bereits in der Benachrichtigungsliste für dieses Weblog.',
    'You did not enter an IP address to ban.' => 'Keine IP-Adresse angegeben.',
    'The IP you entered is already banned for this weblog.' => 'Die IP-Adresse wird bereits gesperrt.',
    'You did not specify a weblog name.' => 'Kein Weblog-Name angegeben.',
    'Site URL must be an absolute URL.' => 'Site-URL muß absolute URL sein.',
    'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
    'The name \'[_1]\' is too long!' => 'Der Name \'[_1]\' ist zu lang!',
    'Category \'[_1]\' created by \'[_2]\'' => 'Kategorie \'[_1]\' angelegt von \'[_2]\'',
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Konflikt um Kategoriename \'[_1]\': Kategorien und Unterkategorien mit der gleichen Wurzel müssen unterschiedliche Namen haben.',
    'Saving permissions failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Can\'t find default template list; where is ' => 'Kann Standardtemplates nicht finden, wo ist',
    'Populating blog with default templates failed: [_1]' => 'Standard-Templates konnten nicht geladen werden: [_1]',
    'Setting up mappings failed: [_1]' => 'Anlegen der Verknüpfung fehlgeschlagen: [_1]',
    'Weblog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Benutzer \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
    'You cannot delete your own author record.' => 'Sie können nicht Ihr eigenes Benutzerkonto löschen.',
    'You have no permission to delete the author [_1].' => 'Keine Rechte zum Löschen von Autor [_1].',
    'Weblog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Abonnent \'[_1]\' (ID:[_2]) von \'[_3]\' von Benachrichtigungsliste entfernt',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Benutzer \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Kategorie \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Kommentar (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Eintrag \'[_4]\' gelöscht',
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Eintrag \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    '(Unlabeled category)' => '(Namenlose Kategorie)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Kategorie \'[_4]\' gelöscht',
    '(Untitled entry)' => '(Namenloser Eintrag)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Eintrag \'[_4]\' gelöscht',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
    'Passwords do not match.' => 'Passwörter stimmen nicht überein.',
    'Failed to verify current password.' => 'Kann Passwort nicht überprüfen.',
    'An author by that name already exists.' => 'Ein Autor mit diesem Benutzernamen besteht bereits.',
    'Save failed: [_1]' => 'Speichern fehlgeschlagen: [_1]',
    'Saving object failed: [_1]' => 'Speichern des Objekts fehlgeschlagen: [_1]',
    'No Name' => 'Kein Name',
    'Notification List' => 'Mitteilungssliste',
    'email addresses' => 'Email-Adressen',
    'Can\'t delete that way' => 'Kann so nicht gelöscht werden',
    'Your login session has expired.' => 'Ihre Login-Session ist abgelaufen.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Solange die Kategorie Unterkategorien hat, können Sie die Kategorie nicht löschen.',
    'System templates can not be deleted.' => 'System-Templates können nicht gelöscht werden',
    'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Laden des Objekttreibers [_1] fehlgeschlagen: [_2]',
    'Reading \'[_1]\' failed: [_2]' => 'Einlesen von \'[_1]\' fehlgeschlagen: [_2]',
    'Thumbnail failed: [_1]' => 'Thumbnail fehlgeschlagen: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Fehler beim Schreiben auf \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Ungültiger Basename \'[_1]\'',
    'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' das Vertrauen ausgesprochen',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' gesperrt',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat die Sperre von Kommentarautor \'[_2]\' aufgehoben',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' das Vertrauen entzogen',
    'Need a status to update entries' => 'Statusangabe erforderlich',
    'Need entries to update status' => 'Einträge erforderlich',
    'One of the entries ([_1]) did not actually exist' => 'Einer der Einträge ([_1]) ist nicht vorhanden',
    'Some entries failed to save' => 'Speichern der Einträge teilweise fehlgeschlagen',
    'You don\'t have permission to approve this TrackBack.' => 'Sie dürfen dieses TrackBack nicht freischalten.',
    'Comment on missing entry!' => 'Kommentar gehört zu fehlendem Eintrag',
    'You don\'t have permission to approve this comment.' => 'Sie dürfen diesen Kommentar nicht freischalten.',
    'Comment Activity Feed' => 'Kommentar-Aktivitätsfeeds',
    'Orphaned comment' => 'Verwaister Kommentar',
    'Plugin Set: [_1]' => 'Plugin-Set: [_1]',
    'TrackBack Activity Feed' => 'TrackBack-Aktivitätsfeed',
    'No Excerpt' => 'Kein Auzzug',
    'No Title' => 'Keine Überschrift',
    'Orphaned TrackBack' => 'Verwaistes TrackBack',
    'Tag' => 'Tag', # Translate - Previous (1)
    'Entry Activity Feed' => 'Eintrags-Aktivitätsfeed',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum \'[_1]\' ungültig; erforderliches Formst ist JJJJ-MM-TT SS:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ungültiges Datum \'[_1]\'; das Datum muss existieren.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Speichern des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
    'Removing placement failed: [_1]' => 'Entfernen der Platzierung fehlgeschlagen: [_1]',
    'No such entry.' => 'Kein Eintrag.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Sie haben noch keinen Site-Path und Site-URL konfiguriert. Sie können Einträge erst veröffentlichen, wenn Sie diese Einstellungen vorgenommen haben.',
    'Entry \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Eintrag \'[_1]\' (ID:[_2]) von Benutzer \'[_3]\' hinzugefügt',
    'The category must be given a name!' => 'Die Kategorie muss einen Namen haben!',
    'yyyy/mm/entry_basename' => 'jjjj/mm/eintrag_basename',
    'yyyy/mm/entry-basename' => 'yyyy/mm/eintrag-basename',
    'yyyy/mm/entry_basename/' => 'jjjj/mm/eintrag_basename/',
    'yyyy/mm/entry-basename/' => 'yyyy/mm/eintrag-basename/',
    'yyyy/mm/dd/entry_basename' => 'jjjj/mm/tt/eintrag_basename',
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/eintrag-basename',
    'yyyy/mm/dd/entry_basename/' => 'jjjj/mm/tt/eintrag_basename/',
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/eintrag-basename/',
    'category/sub_category/entry_basename' => 'kategorie/unterkategorie/eintrag_basename',
    'category/sub_category/entry_basename/' => 'kategorie/unterkategorie/eintrag_basename/',
    'category/sub-category/entry_basename' => 'kategorie/unterkategorie/eintrag_basename',
    'category/sub-category/entry-basename' => 'kategorie/unterkategorie/eintrag-basename',
    'category/sub-category/entry_basename/' => 'kategorie/unterkategorie/eintrag_basename/',
    'category/sub-category/entry-basename/' => 'kategorie/unterkategorie/eintrag-basename/',
    'primary_category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary_category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'primary-category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary-category/entry-basename' => 'hauptkategorie/eintrag-basename',
    'primary-category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'primary-category/entry-basename/' => 'hauptkategorie/eintrag-basename/',
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
    'Saving map failed: [_1]' => 'Speichern der Verknüpfung fehlgeschlagen: [_1]',
    'Parse error: [_1]' => 'Parsing-Fehler: [_1]',
    'Build error: [_1]' => 'Build-Fehler: [_1]',
    'Rebuild-option name must not contain special characters' => 'Name der Rebuild-Option darf keine Sonderzeichen enthalten',
    'index template \'[_1]\'' => 'Indextemplate \'[_1]\'',
    'entry \'[_1]\'' => 'Eintrag \'[_1]\'',
    'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' fehlgeschlagen: [_2]',
    'You cannot modify your own permissions.' => 'Sie können nicht Ihre eigenen Rechte verändern.',
    'You are not allowed to edit the permissions of this author.' => 'Keine Berechtigung zur Änderung der Rechte dieses Benutzers.',
    'Edit Permissions' => 'Rechte bearbeiten',
    'Edit Profile' => 'Profil bearbeiten',
    'No entry ID provided' => 'Keine Eintrags-ID angegeben',
    'No such entry \'[_1]\'' => 'Kein Eintrag \'[_1]\'',
    'No email address for author \'[_1]\'' => 'Keine Email-Addresse für Autor \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'Keine gültigen Empfänger für Benachrichtigungen gefunden.',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen([_1]). Überprüfen Sie die MailTransfer-Einstellungen.',
    'You did not choose a file to upload.' => 'Bitte wählen Sie eine Datei aus.',
    'Invalid extra path \'[_1]\'' => 'Ungültiger Zusatzpfad \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Kann Pfad \'[_1]\' nicht anlegen: [_2]',
    'Invalid temp file name \'[_1]\'' => 'Ungültiger temporärer Dateiname \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Datei mit dem Namen \'[_1]\' bereits vorhanden. (Installiern SIe ',
    'Error creating temporary file; please check your TempDir ' => 'Anlegen der temporären Datei fehlgeschlagen. Bitte überprüfen Sie Ihr TempDir ',
    'unassigned' => 'nicht vergeben',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Dateiname \'[_1]\' bereits vorhanden; versucht zu schreiben',
    'Error writing upload to \'[_1]\': [_2]' => 'Upload in \'[_1]\' speichern fehlgeschlagen: [_2]',
    'Perl module Image::Size is required to determine ' => 'Perl-Module Image::Size erforderlich zur Bestimmung',
    'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe',
    'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
    'Saving object failed: [_2]' => 'Speichern des Objekts fehlgeschlagen: [_2]',
    'Search & Replace' => 'Suchen & Ersetzen',
    'No blog ID' => 'Keine Weblog-ID',
    'You do not have export permissions' => 'Du hast keine Export-Rechte',
    'You do not have import permissions' => 'Du hast keine Import-Rechte',
    'You do not have permission to create authors' => 'Sie haben nicht das Recht, neue Autoren anzulegen',
    'Preferences' => 'Einstellungen',
    'Add a Category' => 'Kategorie hinzufügen',
    'No label' => 'Kein Label',
    'Category name cannot be blank.' => 'Der Name einer Kategorie darf nicht leer sein.',
    'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) nicht implementiert',
    'Permission denied' => 'Zugriff verweigert',

    ## ./lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => 'Anlegen des Ordners \'[_1]\' fehlgeschlagen: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Umbenennen von \'[_1]\' in \'[_2]\' fehlgeschlagen: [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Löschen von \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'SFTP-Verbindung fehlgeschlagen: [_1]',
    'SFTP get failed: [_1]' => 'SFTP-"get" fehlgeschlagen: [_1]',
    'SFTP put failed: [_1]' => 'SFTP-"put" fehlgeschlagen: [_1]',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'DAV-Verbindung fehlgeschlagen: [_1]',
    'DAV open failed: [_1]' => 'DAV-"open" fehlgeschlagen: [_1]',
    'DAV get failed: [_1]' => 'DAV-"get" fehlgeschlagen: [_1]',
    'DAV put failed: [_1]' => 'DAV-"put" fehlgeschlagen: [_1]',

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
    
    'You are currently performing a search. Please wait until your search is completed.' => 'Suche wird ausgeführt. Bitte warten Sie, bis Ihre Anfrage abgeschlossen ist.',
    'We were unable to create your configuration file.' => 'Die Konfigurationsdatei konnte nicht angelegt werden.',
    'If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Bitte überprüfen Sie, ob Schreibrechte für das Verzeichnis vorliegen und klicken dann auf "Erneut versuchen"',
    'The settings below have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Die folgenden Einstellungen wurden in die Datei <tt>[_1]</tt> geschrieben. Sollten die Einstellungen noch nicht korrekt sein, klicken Sie bitte auf "Zurück" um auf die entsprechende Seite des Assistenten zurückzukehren und die Einstellungen zu ändern.',
);


1;

## New words: 545
