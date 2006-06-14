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
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod ist korrekt istalliert, erfordert aber ein aktuelleres DBI-Modul. Bitte beachten Sie oben stehende Versionshinweise.', # Translate - New (20) #k
    'Your server has [_1] installed (version [_2]).' => 'Auf Ihrem Server ist [_1] installiert (Version [_2]).',
    'Movable Type System Check Successful' => 'Movable Type Systemüberprüfung erfolgreich',
    'You\'re ready to go!' => 'Ihr System ist jetzt bereit.',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Module sind auf Ihrem Server installiert. Sie müssen keine weiteren Modulinstallationen vornehmen. Fahren Sie mit den Installationsanweisungen fort.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Suchergebnisse',
    'Subscribe to a feed of these results' => 'Ergebnis-Feed für diese Suche', # Translate - New (7) #k
    'Search this site:' => 'Site durchsuchen:',
    'Search' => 'Suchen',
    'Match case' => 'Groß-/Kleinschreibung',
    'Regex search' => 'Regex-Suche',
    'Search Results from' => 'Suchergebnisse von',
    'Posted in [_1] on [_2] by [_3]' => 'In [_1] am [_2] von [_3] veröffentlicht', # Translate - New (7) #k
    'Searched for' => 'Suche nach',
    'No pages were found containing "[_1]".' => 'Keine Seiten die "[_1]" enthalten gefunden.', # Translate - New (6) #k
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
    'on' => 'am',
    'No results found' => 'Keine Suchergebnisse',
    'No new comments were found in the specified interval.' => 'Keine neuen Kommentare im Zeitraum.',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Gewünschten Zeitraum auswählen, dann  \'Neue Kommentare finden\' wählen', # Translate - New (16) #k

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Suchergebnisse für [_1]', # Translate - New (4) #k

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./tools/exportmt.pl

    ## ./tools/l10n/trans.pl

    ## ./tools/l10n/diff.pl

    ## ./tools/l10n/wrap.pl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Kommentar-Fehler',
    'Your comment submission failed for the following reasons:' => 'Folgender Fehler ist beim Kommentieren aufgetreten:',
    'Return to the original entry' => 'Zurück zum Eintrag',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Seite nicht gefunden',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Dikussion bei [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate - Previous (2) #k
    'TrackBack' => 'TrackBack', # Translate - Previous (1) #k
    'TrackBack URL for this entry:' => 'TrackBack-URL zu diesem Eintrag:',
    'Listed below are links to weblogs that reference' => 'Die folgenden Weblogs beziehen sich auf diesen Eintrag',
    'from' => 'von',
    'Read More' => 'Weiter lesen',
    'Tracked on [_1]' => 'Verlinkt am [_1]',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Hauptseite',
    'Posted by [_1] on [_2]' => 'Geschrieben von [_1] am [_2]',
    'Permalink' => 'Permalink', # Translate - Previous (1) #k
    'Tracked on' => 'Verlinkt am',
    'Comments' => 'Kommentare',
    'Posted by:' => 'Verfasst von:',
    'Anonymous' => 'Anonym',
    'Posted on' => 'Geschrieben am', # Translate - New (2) #k
    'Permalink to this comment' => 'Permalink dieses Kommentars', # Translate - New (4) #k
    'Post a comment' => 'Kommentar schreiben',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Wenn Sie auf dieser Site noch nie kommentiert haben, wird Ihr Kommentar eventuell erst zeitverzögert freigeschaltet werden. Vielen Dank für Ihre Geduld.)',
    'Name:' => 'Name:', # Translate - Previous (1) #k
    'Email Address:' => 'Email-Adresse:',
    'URL:' => 'URL:', # Translate - Previous (1) #k
    'Remember personal info?' => 'Persönliche Angaben speichern?',
    'Comments:' => 'Kommentare:',
    '(you may use HTML tags for style)' => '(HTML erlaubt)',
    'Preview' => 'Vorschau',
    'Post' => 'Absenden',
    'Search this blog:' => 'Dieses Weblog durchsuchen:',
    'About' => 'Über', # Translate - New (1) #k
    'The previous post in this blog was <a href=' => 'Der vorherige Eintrag dieses Blog ist <a href=', # Translate - New (9) #k
    'The next post in this blog is <a href=' => 'Der nächste Eintrag dieses Blogs ist <a href=', # Translate - New (9) #k
    'Many more can be found on the <a href=' => 'Viel mehr in <a href=', # Translate - New (9) #k
    'Subscribe to this blog\'s feed' => 'Feed zu diesem Weblog abonnieren',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - New (6) #k
    'What is this?' => 'Was ist das?',
    'This weblog is licensed under a' => 'Zu diesem Weblog besteht folgende Lizenz:',
    'Creative Commons License' => 'Creative Commons Lizenz',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Weiter lesen',
    'Tags' => 'Tags', # Translate - Previous (1) #k
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1) #k
    'Recent Posts' => 'Aktuelle Einträge',
    'Categories' => 'Kategorien',
    'Archives' => 'Archive',

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Verfasst von',
    'About [_1]' => 'Über [_1]', # Translate - New (2) #k
    '<a href=' => '<a href=', # Translate - New (3) #k

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl
    'Posted on [_1]' => 'Geschrieben am [_1]', # Translate - New (3) #k

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archive',

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
    'Comment on' => 'Kommentar zu',
    'Previewing your Comment' => 'Vorschau Ihres Kommentars',
    'Cancel' => 'Abbrechen',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Kommentar noch nicht freigegeben',
    'Thank you for commenting.' => 'Vielen Dank für den Kommentar.',
    'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar wurde gespeichert und muß nun vom Weblog-Betreiber freigegeben werden.',

    ## ./default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'SEARCH FEED AUTODISCOVERY NUR ANGEZEIGT WEN SUCHE AUSGEFÜHRT', # Translate - New (12) #k
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'EINFACHE SUCHEN - EINFACHES FORMULAR', # Translate - New (7) #k
    'Search this site' => 'Diese Site durchsuchen', # Translate - New (3) #k
    'SEARCH RESULTS DISPLAY' => 'SUCHERGEBNISSANZEIGE', # Translate - New (3) #k
    'Matching entries from [_1]' => 'Treffer in [_1]', # Translate - New (4) #k
    'Entries from [_1] tagged with \'[_2]\'' => 'Einträge aus [_1], die getaggt sind mit \'[_2]\'', # Translate - New (6) #k
    'Posted <MTIfNonEmpty tag=' => 'Veröffentliche <MTIfNonEmpty tag=', # Translate - New (3) #k
    'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT', # Translate - New (4) #k
    'Entries matching \'[_1]\'' => 'Einträge mit \'[_1]\'', # Translate - New (3) #k
    'Entries tagged with \'[_1]\'' => 'Einträge getaggt mit \'[_1]\'', # Translate - New (4) #k
    'No pages were found containing \'[_1]\'.' => 'Es wurden keine Seiten gefunden, die \'[_1]\' beinhalten.', # Translate - New (6) #k
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Die Suchfunktion sucht standardmäßig nach allen angebenen Begriffen in beliebiger Reihenfolge. Um nach einem exakten Ausdruck zu suchen, setzen Sie diesen bitte in Anführungszeichen.', # Translate - New (23) #k
    'movable type' => 'Movable Type', # Translate - New (2) #k
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Die Suchmaschine unterstützt auch die boolschen Operatoren UND, ODER und NICHT.', # Translate - New (14) #k
    'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE', # Translate - New (6) #k
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG', # Translate - New (9) #k
    'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE vs TAG-Information', # Translate - New (7) #k
    'Subscribe to feed' => 'Feed abonnieren', # Translate - New (3) #k
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller künftigen mit \'[_1]\' getaggten Einträge abonnieren.', # Translate - New (18) #k
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller künftigen Einträge mit \'[_1]\' abonnieren.', # Translate - New (18) #k
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO', # Translate - New (5) #k
    'Feed Subscription' => 'Feed abonnieren', # Translate - New (2) #k
    'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE', # Translate - New (6) #k
    'Other Tags' => 'Andere Tags', # Translate - New (2) #k
    'Other tags used on this blog' => 'Andere in diesem Blog verwendete Tags', # Translate - New (6) #k
    'END OF PAGE BODY' => 'PAGE BODY ENDE', # Translate - New (4) #k
    'END OF CONTAINER' => 'CONTAINER ENDE', # Translate - New (3) #k

    ## ./lib/MT/default-templates.pl

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nsample', # Translate - New (2) #k
    'This description can be localized if there is l10n_class set.' => 'Diese Beschreibung kann durch Setzen von l10n_class lokalisiert werden.', # Translate - New (12) #k
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - New (2) #k

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Dieser Ausdruck wird im Template verarbeitet.', # Translate - New (6) #k

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Fügt Hyperlinks in TrackBacks und Kommentaren das \'nofollow\'-Attribut hinzu und hilft so, Spam zu reduzieren', # Translate - New (12) #k
    'Restrict:' => 'Einschränken:', # Translate - New (1) #k
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Nofollow nicht hinzufügen, wenn die Links von authentifizierten Kommentatoren stammen', # Translate - New (11) #k

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Vorhandene Templates speichern und zu den Movable Type-Standardtemplates zurückkehren', # Translate - New (11) #k

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Templates sichern und erneuern', # Translate - New (4) #k
    'No templates were selected to process.' => 'Keine Templates gewählt.', # Translate - New (6) #k
    'Return' => 'Zurück', # Translate - New (1) #k

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup-Modul zur Moderation und Junk-Kennzeichung von Feedback mittels Schlüsselwörter', # Translate - New (10) #k

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup-Modul zur Filterung von Feedback mittels Blacklists.', # Translate - New (10) #k

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup-Link', # Translate - New (2) #k
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup-Modul zur Moderation und Junk-Kennzeichnung von Feedback mittels Linkfilter.', # Translate - New (11) #k

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Der Linkfilter prüft automatisch die Anzahl der in neuem Feedback enthaltenen Links. Sind sehr viele Links enthalten, kann das Feedback zur Moderation zurückgehalten oder automatisch als Junk eingestuft werden. Sind hingegen keine Links oder nur Links zu bekannten Adressen enthalten, fällt die Bewertung positiv aus. (Verwenden Sie diese Funktion nur, wenn Ihr Blog bereits spam-frei ist.)' , # Translate - New (54) #k
    'Link Limits:' => 'Link-Limits:', # Translate - New (2) #k
    'Credit feedback rating when no hyperlinks are present' => 'Credit für Feedback ohne Hyperlinks', # Translate - New (8) #k
    'Adjust scoring' => 'Scoring anpassen', # Translate - New (2) #k
    'Score weight:' => 'Gewichtung:', # Translate - New (2) #k
    'Decrease' => 'Abschwächen',
    'Increase' => 'Verstärken',
    'Moderate when more than' => 'Moderieren falls mehr als', # Translate - New (4) #k	
    'link(s) are given' => 'Link(s) enthalten', # Translate - New (4) #k
    'Junk when more than' => 'Als Junk einstufen falls mehr als', # Translate - New (4) #k
    'Link Memory:' => 'Link-Memory:', # Translate - New (2) #k
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Credit für Feedback, dessen &quot;URL&quot;-Element bereits veröffentlicht wurde', # Translate - New (14) #k
    'Only applied when no other links are present in message of feedback.' => 'Wird nur angewendet wenn keine zusätzlichen Links enthalten sind.', # Translate - New (12) #k
    'Exclude URLs from comments published within last [_1] days.' => 'URLs aus Kommentaren entfernen, die in den letzten [_1] Tagen veröffentlicht wurden.', # Translate - New (9) #k
    'Email Memory:' => 'Email-Memory:', # Translate - New (2) #k
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Credit für Feedback, das von der gleichen &quot;Email&quot;-Adresse stammt wie bereits zuvor freigeschaltetes Feedback', # Translate - New (16) #k
    'Exclude Email addresses from comments published within last [_1] days.' => 'Email-Adressen aus Kommentaren entfernen, die in den letzten [_1] Tagen veröffentlich wurden.', # Translate - New (10) #k

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Von jedem Feedback werden Herkunfts-IP-Adresse und enthaltene Hyperlinks automatisch kontrolliert. Stammt der Kommentar oder TrackBack von einer gesperrten IP-Adresse oder einer schwarzgelisteten Domain, kann er automatisch zur Moderation zurückgehalten oder als Junk markiert und in den Junk-Ordner des Blogs verschoben werden. Für TrackBacks stehen zusätzliche Kontrollen bereit.', # Translate - New (56) #k
    'IP Address Lookups:' => 'Kontrolle der IP-Addressen:', # Translate - New (3) #k
    'Off' => 'Aus',
    'Moderate feedback from blacklisted IP addresses' => 'Feedback von gesperrten IP-Adressen moderieren', # Translate - New (6) #k
    'Junk feedback from blacklisted IP addresses' => 'Feedback von gesperrten IP-Adressen als Junk einstufen', # Translate - New (6) #k
    'Less' => 'Schwächer',
    'More' => 'Stärker',
    'block' => 'sperren', # Translate - New (1) #k
    'none' => 'keine', # Translate - New (1) #k
    'IP Blacklist Services:' => 'IP-Schwarzlistendienste:', # Translate - New (3) #k
    'Domain Name Lookups:' => 'Kontrolle der Domainnamen:', # Translate - New (3) #k
    'Moderate feedback containing blacklisted domains' => 'Feedback von gesperrten Domains moderieren', # Translate - New (5) #k
    'Junk feedback containing blacklisted domains' => 'Feedback von gesperrten Domains als Junk einstufen', # Translate - New (5) #k
    'Domain Blacklist Services:' => 'Domain-Schwarzlistendienste:', # Translate - New (3) #k
    'Advanced TrackBack Lookups:' => 'Zusätzliche TrackBack-Kontrollen:', # Translate - New (3) #k
    'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus verdächtigen Quellen moderieren', # Translate - New (5) #k
    'Junk TrackBacks from suspicious sources' => 'TrackBacks aus verdächtigen Quellen als Junk einstufen', # Translate - New (5) #k
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Domains und IP-Adressen, die nicht nachgeschlagen werden sollen, können hier aufgeführt werden. Verwenden Sie für jeden Eintag eine neue Zeile.', # Translate - New (20) #k
    'Lookup Whitelist:' => 'Weißliste:', # Translate - New (2) #k

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Eingehendes Feedback kann automatisch auf frei definierbare Schlüsselwörter und Muster kontrolliert und bei Treffern zur Moderation zurückgehalten oder automatisch als Junk eingestuft werden. ', # Translate - New (31) #k
    'Keywords to Moderate:' => 'Schlüsselwörter für Moderation:', # Translate - New (3) #k
    'Keywords to Junk:' => 'Schlüsselwörter für automatische Junk-Einstufung:', # Translate - New (3) #k

    ## ./plugins/feeds-app-lite/mt-feeds.pl

    ## ./plugins/feeds-app-lite/tmpl/weblog_config.tmpl

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Continue' => 'Weiter', # Translate - New (1) #k

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl

    ## ./plugins/statwatch/statwatch.pl

    ## ./plugins/statwatch/tmpl/swfooter.tmpl

    ## ./plugins/statwatch/tmpl/view.tmpl

    ## ./plugins/statwatch/tmpl/list.tmpl

    ## ./plugins/statwatch/tmpl/swheader.tmpl

    ## ./plugins/StyleCatcher/stylecatcher.pl
    'You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog.' => 'Sie müssen einen globalen Theme-Speicher anlegen, um Themes lokal speichern zu können. Hat ein Blog kein eigenes Theme-Verzeichnis, wird es auf diesen Speicher zurückgreifen. Hat es eines, wird das jeweilge Theme aus dem Speicher dorthin kopiert.', # Translate - New (55) #k
    'Your theme URL and path can be customized for this weblog.' => 'Sie können das Theme-Verzeichnis dieses Weblogs anpassen.', # Translate - New (11) #k
    'The paths defined here must physically exist and be writable by the webserver.' => 'Der angegebene Ordner muss bereits existieren und der Webserver muss Schreibrechte für ihn besitzen.', # Translate - New (13) #k
    'Theme Root URL:' => 'Wurzeladresse für Themes:', # Translate - New (3) #k 
    'Theme Root Path:' => 'Wurzelverzeichnis für Themes:', # Translate - New (3) #k
    'Style Library URL:' => 'Adresse der Style Library:', # Translate - New (3) #k

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'Main Menu' => 'Hauptmenü',
    'System Overview' => 'Systemübersicht',
    'Help' => 'Hilfe',
    'Welcome' => 'Willkommen',
    'Logout' => 'Abmelden',
    'View Site' => 'Ansehen',

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
    'Please select a weblog to apply this theme.' => 'Weblog, auf den das Theme angewendet werden soll, wählen', # Translate - New (8) #k
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Um ein Design anzuwenden, klicken Sie bitte zuerst auf ein Theme.', # Translate - New (15) #k
    'Applying...' => 'Wende an...', # Translate - New (1)
    'Choose this Design' => 'Dieses Design wählen', # Translate - New (3) #k
    'Find Style' => 'Style finden', # Translate - New (2) #k
    'Loading...' => 'Lade...', # Translate - New (1) #k
    ' To change the location of your local theme repository, ' => ' Um Ihren lokalen Themes-Speicher zu verschieben, ', # Translate - New (10) #k
    'click here.' => 'klicken Sie hier.', # Translate - New (2) #k
    'StyleCatcher user script.' => 'StyleCatcher-User Script.', # Translate - New (3) #k
    'Theme or Repository URL:' => 'Theme oder Speicher-Adresse:', # Translate - New (4) #k
    'Current theme for your weblog' => 'Aktuelles Theme Ihres Weblogs', # Translate - New (5) #k
    'Current Theme' => 'Aktuelles Theme', # Translate - New (2) #k
    'Current themes for your weblogs' => 'Aktuelle Themes Ihrer Weblogs', # Translate - New (5) #k
    'Current Themes' => 'Aktuelle Themes', # Translate - New (2) #k
    'Locally saved themes' => 'Lokal gespeicherte Tthemes', # Translate - New (3) #k
    'Saved Themes' => 'Gespeicherte Themes', # Translate - New (2) #k
    'Single themes from the web' => 'Einzelne Themes aus dem Web', # Translate - New (5) #k
    'More Themes' => 'Weitere Themes', # Translate - New (2) #k
    'Templates' => 'Templates', # Translate - Previous (1) #k
    'Details' => 'Details', # Translate - New (1) #k
    'Show Details' => 'Details anzeigen', # Translate - New (2) #k
    'Hide Details' => 'Details ausblenden', # Translate - New (2) #k
    'Select a Weblog...' => 'Weblog wählen...', # Translate - New (3) #k
    'You don\'t appear to have any weblogs with a ' => 'Sie haben kein Weblog mit', # Translate - New (10) #k

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Verwalten Sie Ihre Widgets ganz einfach per Drag-and-Drop', # Translate - New (13) #k

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'Widget Manager' => 'Widget Manager', # Translate - New (2) #k
    'Rearrange Items' => 'Elemente anordnen', # Translate - New (2) #k
    'Your changes to the Widget Manager have been saved.' => 'Änderungen übernommen', # Translate - New (9) #k
    'Widget Manager Name:' => 'Name des Widget Managers:', # Translate - New (3) #k
    'Build WidgetManager:' => 'WidgetManager anlegen:', # Translate - New (2) #k
    'Installed Widgets' => 'Installierte Widgets', # Translate - New (2) #k
    'Available Widgets' => 'Erhältliche Widgets', # Translate - New (2) #k
    'Save Changes' => 'Änderungen speichern',

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type Publishing Platform', # Translate - Previous (4) #k
    'Weblogs:' => 'Weblogs:', # Translate - Previous (1) #k
    'Go' => 'Wechseln',
    'Entries' => 'Einträge',

    ## ./plugins/WidgetManager/tmpl/list.tmpl
    'Widget Managers' => 'Widget Managers', # Translate - New (2) #k
    'Add Widget Manager' => 'Widget Manager hinzufügen', # Translate - New (3) #k
    'Create Widget Manager' => 'Widget Manager anlegen', # Translate - New (3) #k
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'Widget Manager(s) erfolgreich gelöscht.', # Translate - New (12) #k
    'WidgetManager Name' => 'Name des WidgetManagers', # Translate - New (2) #k
    'Edit' => 'Bearbeiten', # Translate - New (1) #k
    'Delete Selected' => 'Ausgewählte Elemente löschen', # Translate - New (2) #k
    'Are you sure you wish to delete the selected Widget Manager(s)?' => 'Diese Widget Manager(s) wirklich löschen?', # Translate - New (12) #k

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl
    'Google API Key:' => 'Google API-Key:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Um eine der API-Funktionen von Google nutzen zu können, benötigen Sie einen API-Schlüssel von Google. Fügen Sie diesen hier ein.',

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
    'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
    'CGI Path Configuration Required' => 'CGI-Pfad muß konfiguriert werden',
    'An error occurred' => 'Es ist ein Fehler aufgetreten',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Kommentar bearbeiten',
    'Your changes have been saved.' => 'Die Änderungen wurden gespeichert.',
    'The comment has been approved.' => 'Der Kommentar wurde freigegeben.',
    'Previous' => 'Vorheriger',
    'List &amp; Edit Comments' => 'Kommentare auflisten &amp; bearbeiten',
    'Next' => 'Nchster',
    '_external_link_target' => '_top', # Translate - New (4) #k
    'View Entry' => 'Eintrag ansehen',
    'Pending Approval' => 'Freischaltung erwartet',
    'Junked Comment' => 'Junk-Kommentar',
    'Status:' => 'Status:', # Translate - Previous (1) #k
    'Published' => 'Veröffentlicht',
    'Unpublished' => 'Nicht veröffentlicht',
    'Junk' => 'Junk', # Translate - Previous (1) #k
    'View all comments with this status' => 'Alle Kommentare mit diesem Status ansehen',
    'Commenter:' => 'Kommentator:',
    'Trusted' => 'vertraut',
    '(Trusted)' => '(vertraut)',
    'Ban&nbsp;Commenter' => 'Kommentator&nbsp;sperren',
    'Untrust&nbsp;Commenter' => 'Kommentator&nbsp;nicht&nbsp;vertrauen',
    'Banned' => 'Gesperrt',
    '(Banned)' => '(gesperrt)',
    'Trust&nbsp;Commenter' => 'Kommentator&nbsp;vertrauen',
    'Unban&nbsp;Commenter' => 'Sperre&nbsp;aufheben',
    'Pending' => 'Nicht veröffentlicht',
    'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentator anzeigen',
    'Email:' => 'Email:', # Translate - Previous (1) #k
    'None given' => 'leer',
    'Email' => 'Email', # Translate - Previous (1) #k
    'View all comments with this email address' => 'Alle Kommentare von dieser Email-Adresse anzeigen',
    'Link' => 'Link', # Translate - Previous (1) #k
    'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
    'Entry:' => 'Eintrag:',
    'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
    'No title' => 'Keine Überschrift',
    'View all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',
    'Date:' => 'Datum:',
    'View all comments posted on this day' => 'Alle Kommentare von diesem Tag anzeigen',
    'IP:' => 'IP:', # Translate - Previous (1) #k
    'View all comments from this IP address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
    'Save this comment (s)' => 'Kommentar(e) speichern',
    'comment' => 'Kommentar',
    'comments' => 'Kommentare',
    'Delete' => 'Löschen',
    'Delete this comment (x)' => 'Diesen Kommentar löschen (x)', # Translate - New (4) #k
    'Ban This IP' => 'Diese IP-Adresse sperren',
    'Final Feedback Rating' => 'Finales Feedback-Rating',
    'Test' => 'Test', # Translate - Previous (1) #k
    'Score' => 'Score', # Translate - Previous (1) #k
    'Results' => 'Ergebnis',
    'Plugin Actions' => 'Plugin-Aktionen',

    ## ./tmpl/cms/notification_actions.tmpl
    'notification address' => 'Adresse für Benachrichtigung',
    'notification addresses' => 'Adressen für Benachrichtigung',
    'Delete selected notification addresses (x)' => 'Ausgewählte Benachrichtigungsadressen löschen(x)', # Translate - New (5) #k

    ## ./tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => 'Web Services-Passwort noch nicht gesetzt', # Translate - New (6) #k
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
    'Username (*):' => 'Benutzername (*):', # Translate - New (1) #k
    'The name used by this author to login.' => 'Der Name, um sich am System anzumelden.',
    'Display Name:' => 'Angezeigter Name:',
    'The author\'s published name.' => 'Der Name, der bei Einträgen angezeigt wird.',
    'Email Address (*):' => 'Email-Adresse (*):', # Translate - New (2) #k
    'The author\'s email address.' => 'Die Email-Adresse des Autors.',
    'Website URL:' => 'Website-URL:',
    'The URL of this author\'s website. (Optional)' => 'Die URL des Autors (optional).',
    'Language:' => 'Sprache:',
    'The author\'s preferred language.' => 'Die bevorzugte Sprache des Autors.',
    'Tag Delimiter:' => 'Tags-Trennzeichen:', # Translate - New (2) #k
    'Comma' => 'Komma', # Translate - New (1) #k
    'Space' => 'Leerzeichen', # Translate - New (1) #k
    'Other...' => 'Anderes...', # Translate - New (1) #k
    'The author\'s preferred delimiter for entering tags.' => 'Das bevorzugte Trennzeichen für die Eingabe von Tags.', # Translate - New (8) #k
    'Password' => 'Passwort',
    'Current Password:' => 'Aktuelles Passwort:',
    'Enter the existing password to change it.' => 'Geben Sie das aktuelle Passwort ein, um es dann zu ändern.',
    'New Password:' => 'Neues Passwort:',
    'Initial Password (*):' => 'Bisherige Passwort (*):', # Translate - New (2) #k
    'Select a password for the author.' => 'Geben Sie ein Passwort für den Autor an.',
    'Password Confirm:' => 'Passwort wiederholen:',
    'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen.',
    'Password recovery word/phrase' => 'Erinnerungssatz', # Translate - New (4) #k
    'This word or phrase will be required to recover your password if you forget it.' => 'Dieser Satz wird abgefragt, wenn Sie Ihr vergessenes Passwort anfordern möchten.', # Translate - New (15) #k
    'Web Services Password:' => 'Web Services-Passwort:', # Translate - New (3) #k
    'Reveal' => 'Anzeigen',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Erforderlich für Aktivitäts-Feeds und externe Software, die über XML-RPC oder ATOM-API auf das Weblog zugreift', # Translate - New (11) #k
    'Save this author (s)' => 'Autor speichern',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Authentifizierte Kommentatoren',
    'The selected commenter(s) has been given trusted status.' => 'Diese Kommentatoren haben den Status vertrauenswürdig.',
    'Trusted status has been removed from the selected commenter(s).' => 'Der Vertraut-Status wurde für die ausgewählten Kommentatoren aufgehoben.',
    'The selected commenter(s) have been blocked from commenting.' => 'Die ausgewählten Kommentatoren wurden für Kommentare gesperrt.',
    'The selected commenter(s) have been unbanned.' => 'Die Kommentarsperre wurde für die ausgewählten Kommentatoren aufgehoben.',
    'Reset' => 'Zurücksetzen',
    'Filter:' => 'Filter:', # Translate - Previous (1) #k
    'None.' => 'Keine.', # Translate - New (1) #k
    '(Showing all commenters.)' => '(Zeige alle Kommentatoren.)', # Translate - New (4) #k
    'Showing only commenters whose [_1] is [_2].' => 'Zeige nur Kommentatoren bei denen [_1] [_2] ist.', # Translate - New (7) #k
    'Commenter Feed' => 'Kommentatoren-Feed', # Translate - New (2) #k
    'Commenter Feed (Disabled)' => 'Kommentatoren-Feed (deaktiviert)', # Translate - New (3) #k
    'Disabled' => 'Ausgeschaltet',
    'Set Web Services Password' => 'Web Services-Passwort setzen', # Translate - New (4) #k
    'Show' => 'Zeigen',
    'all' => 'alle',
    'only' => 'nur',
    'commenters.' => 'Kommentatoren.',
    'commenters where' => 'Kommentare die',
    'status' => 'Status',
    'commenter' => 'Kommentator',
    'is' => 'ist',
    'trusted' => 'vertraut',
    'untrusted' => 'nicht vertraut',
    'banned' => 'gesperrt',
    'unauthenticated' => 'nicht authentifiziert',
    'authenticated' => 'authentifiziert',
    '.' => '.', # Translate - New (0) #k
    'Filter' => 'Filter', # Translate - Previous (1) #k
    'No commenters could be found.' => 'Keine Kommentatoren gefunden.',

    ## ./tmpl/cms/comment_actions.tmpl
    'to publish' => 'zum Veröffentlichen',
    'Publish' => 'Veröffentlichen',
    'Publish selected comments (p)' => 'Kommentare veröffentlichen (p)',
    'Delete selected comments (x)' => 'Markierte Kommentare löschen (x)', # Translate - New (4) #k
    'Junk selected comments (j)' => 'Kommentare sind Junk (j)',
    'Not Junk' => 'Kein Junk',
    'Recover selected comments (j)' => 'Kommentare wiederherstellen (j)',
    'Are you sure you want to remove all junk comments?' => 'Wirklich alle Junk-Kommentare entfernen?', # Translate - New (10) #k
    'Empty Junk Folder' => 'Junk-Ordner leeren', # Translate - New (3) #k
    'Deletes all junk comments' => 'Alle Junk-Kommentare löschen', # Translate - New (4) #k

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Status', # Translate - Previous (1) #k
    'Comment' => 'Kommentar',
    'Commenter' => 'Kommentar-Autor',
    'Weblog' => 'Weblog', # Translate - Previous (1) #k
    'Entry' => 'Eintrag',
    'Date' => 'Datum',
    'IP' => 'IP', # Translate - Previous (1) #k
    'Only show published comments' => 'Nur veröffentlichte Kommentare anzeigen',
    'Only show pending comments' => 'Nur nicht veröffentlichte Kommentare anzeigen',
    'Edit this comment' => 'Kommentar bearbeiten',
    'Edit this commenter' => 'Kommentator bearbeiten',
    'Blocked' => 'Blockiert',
    'Authenticated' => 'Authentifiziert',
    'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentator suchen',
    'Show all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',
    'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',

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

    ## ./tmpl/cms/list_tags.tmpl
    'System-wide' => 'Gesamtsystem',
    'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen.', # Translate - New (8) #k
    'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht.', # Translate - New (7) #k
    'Tag Name' => 'Tag-Name', # Translate - New (2) #k
    'Click to edit tag name' => 'Klicken, um Tagname zu bearbeiten', # Translate - New (5) #k
    'Rename' => 'Umbenennen', # Translate - New (1) #k
    'Show all entries with this tag' => 'Alle Einträge mit diesem Tag anzeigen', # Translate - New (6) #k
    '[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
    'No tags could be found.' => 'Keine Tags gefunden', # Translate - New (5) #k

    ## ./tmpl/cms/ping_actions.tmpl
    'Publish selected TrackBacks (p)' => 'Ausgewählte TrackBacks veröffentlichen (p)',
    'Delete selected TrackBacks (x)' => 'Ausgewählte TrackBacks löschen (x)', # Translate - New (4) #k
    'Junk selected TrackBacks (j)' => 'Ausgewählte TrackBacks sind Junk (j)',
    'Recover selected TrackBacks (j)' => 'Ausgewählte TrackBacks wiederherstellen (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Alle Jung-TrackBacks wirklich entfernen?', # Translate - New (10) #k
    'Deletes all junk TrackBacks' => 'Alle Junk-Trackbacks löschen', # Translate - New (4) #k

    ## ./tmpl/cms/list_author.tmpl
    'Authors' => 'Autoren',
    'You have successfully deleted the authors from the Movable Type system.' => 'Die Autoren wurden erfolgreich aus Movable Type entfernt.',
    'Username' => 'Benutzername',
    'Name' => 'Name', # Translate - Previous (1) #k
    'URL' => 'URL', # Translate - Previous (1) #k
    'Created By' => 'Erstellt von',
    'Last Entry' => 'Letzter Eintrag',
    'System' => 'System', # Translate - Previous (1) #k

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'News von Movable Type',
    'System Shortcuts' => 'System-Shortcuts',
    'Weblogs' => 'Weblogs', # Translate - Previous (1) #k
    'Concise listing of weblogs.' => 'Übersicht über alle Weblogs.',
    'Create, manage, set permissions.' => 'Berechtigungen verwalten.',
    'Plugins' => 'Plugins', # Translate - Previous (1) #k
    'What\'s installed, access to more.' => 'Was ist installiert, Übersicht, etc.',
    'Multi-weblog entry listing.' => 'Multi-Weblog Eintragsliste.',
    'Multi-weblog tag listing.' => 'Multi-weblog Tagliste.', # Translate - New (3) #k
    'Multi-weblog comment listing.' => 'Multi-Weblog Kommentarliste.',
    'Multi-weblog TrackBack listing.' => 'Multi-Weblog TrackBackliste.',
    'Settings' => 'Einstellungen',
    'System-wide configuration.' => 'Globale Systemkonfiguration.',
    'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
    'Find everything. Replace anything.' => 'Volles Suchen und Ersetzen.',
    'Activity Log' => 'Protokoll',
    'What\'s been happening.' => 'Was ist wann passiert.',
    'Status &amp; Info' => 'Status &amp; Info', # Translate - Previous (3) #k
    'Server status and information.' => 'Serverstatus und Information.',
    'QuickPost' => 'QuickPost', # Translate - Previous (1) #k
    'Set Up A QuickPost Bookmarklet' => 'QuickPost-Bookmarklet einrichten',
    'Enable one-click publishing.' => 'One-click-Publishing einrichten.',
    'My Weblogs' => 'Meine Weblogs',
    'Warning' => 'Warnung',
    'Important:' => 'Wichtig:',
    'Configure this weblog.' => 'Dieses Weblog konfigurieren.',
    'Create New Entry' => 'Neuen Eintrag schreiben',
    'Create a new entry' => 'Eintrag schreiben',
    'Create a new entry on this weblog' => 'Eintrag in diesem Blog schreiben', # Translate - New (7) #k
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
    'You currently have no blogs.  Please see your system administrator for access.' => 'Sie haben derzeit keine Blogs. Bitte wenden Sie sich an Ihren Administrator.', # Translate - New (12) #k

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Import/Export', # Translate - Previous (2) #k
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Einträge aus einem anderen Weblog-System importieren oder für ein Backup exportieren.',
    'Import Entries' => 'Importieren von Einträgen',
    'Export Entries' => 'Einträge exportieren',
    'Import entries as me' => 'Einträge unter meinem Benutzernamen importieren',
    'Password (required if creating new authors):' => 'Passwort (erforderlich beim Erstellen neuer Autoren):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'Alle Import-Kommentare werden dem jetzt am System angemeldeteten Autoren zugeordnet.  Wenn andere/weitere Autoren benötigt werden, kontaktieren Sie bitte Ihren Movable Type-Systemadministrator.',
    'Default category for entries (optional):' => 'Standardkategorie für Einträge (optional):',
    'Select a category' => 'Kategorie auswählen',
    'Default post status for entries (optional):' => 'Standard-Eintragsstatus (optional):',
    'Select a post status' => 'Wählen Sie einen Eintragsstatus.',
    'Start title HTML (optional):' => 'Anfang HTML (optional):',
    'End title HTML (optional):' => 'Ende HTML (optional):',
    'File From Your Computer (optional):' => 'Lokale Datei (optional):', # Translate - New (5) #k
    'Encoding (optional):' => 'Encoding (optional):', # Translate - New (2) #k
    'Export Entries From [_1]' => 'Einträge exportieren von [_1]',
    'Export Entries to Tangent' => 'Einträge nach Tangent exportieren',

    ## ./tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => 'Noch nicht gespeicherte Änderungen gehen verloren', # Translate - New (11) #k
    'Edit Template' => 'Templates bearbeiten',
    'Your template changes have been saved.' => 'Die Änderungen an dem Template wurden gespeichert.',
    'Rebuild this template' => 'Templates neu aufbauen',
    'View Published Template' => 'Veröffentlichtes Template ansehen', # Translate - New (3) #k
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
    'Insert...' => 'Einfügen...', # Translate - New (1) #k
    'Bigger' => 'Größer', # Translate - New (1) #k
    'Smaller' => 'Kleiner', # Translate - New (1) #k
    'Save this template (s)' => 'Template speichern (s)',
    'Save and Rebuild' => 'Speichern und neu veröffentlichen',
    'Save and rebuild this template (r)' => 'Template speichern und neu veröffentlichen (r)',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Zeit für Ihr Upgrade!',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).', # Translate - New (17) #k
    'Do you want to proceed with the upgrade anyway?' => 'Upgrade dennoch fortsetzen?', # Translate - New (9) #k
    'Yes' => 'Ja',
    'No' => 'Nein',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.',
    'Begin Upgrade' => 'Upgrade durchführen',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Einträge speichern (s)',
    'Save this entry (s)' => 'Eintrag speichern (s)',
    'Preview this entry (v)' => 'Vorschau (v)', # Translate - New (4) #k
    'entry' => 'Eintrag',
    'entries' => 'Einträge',
    'Delete this entry (x)' => 'Eintrag löschen (x)', # Translate - New (4) #k
    'to rebuild' => 'zum erneuten Veröffentlichen',
    'Rebuild' => 'Neu aufbauen',
    'Rebuild selected entries (r)' => 'Einträge neu veröffentlichen (r)',
    'Delete selected entries (x)' => 'Markierte Einträge löschen (x)', # Translate - New (4) #k

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Junk finden',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Diese Einträge könnten Junk sein. Einträge, die nicht Junk sind, bitte abwählen.', # Translate - New (21) #k
    'To return to the comment list without junking any items, click CANCEL.' => 'Abbruch führt zurück Kommentarliste, ohne daß Einträge als Junk eingestuft werden', # Translate - New (12) #k
    'Approved' => 'Freigeschaltet',
    'Registered Commenter' => 'Registrierter Kommentator',
    'Return to comment list' => 'Zurück zur Kommentarliste', # Translate - New (4) #k

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'Autor',
    'authors' => 'Autoren',
    'Delete selected authors (x)' => 'Markierte Beutzer löschen (x)', # Translate - New (4) #k

    ## ./tmpl/cms/bookmarklets.tmpl
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
    'Basename' => 'Basename', # Translate - Previous (1) #k
    'Create' => 'Neu',

    ## ./tmpl/cms/tag_table.tmpl
    'IP Address' => 'IP-Adresse',
    'Log Message' => 'Protokollnachricht',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Einträge',
    'New Entry' => 'Neuer Eintrag',
    'List Entries' => 'Einträge auflisten',
    'Upload File' => 'Dateiupload',
    'Community' => 'Community', # Translate - Previous (1) #k
    'List Comments' => 'Kommentare auflisten',
    'List Commenters' => 'Kommentatoren auflisten',
    'Commenters' => 'Kommentar Autoren',
    'List TrackBacks' => 'TrackBacks auflisten',
    'Edit Notification List' => 'Mitteilungsliste bearbeiten',
    'Notifications' => 'Mitteilungen',
    'Configure' => 'Konfigurieren',
    'List &amp; Edit Templates' => 'Templates auflisten &amp; bearbeiten',
    'Edit Categories' => 'Kategorien bearbeiten',
    'Edit Tags' => 'Tags bearbeiten', # Translate - New (2) #k
    'Edit Weblog Configuration' => 'Weblog-Konfiguration bearbeiten',
    'Utilities' => 'Hilfsmittel',
    'Import &amp; Export Entries' => 'Einträge importieren &amp; exportieren',
    'Rebuild Site' => 'Neu aufbauen',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importieren...',
    'Importing entries into blog' => 'Importiere Einrtäge ins Weblog',
    'Importing entries as author \'[_1]\'' => 'Importiere als Autor \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Neue Autoren anlegen für jeden Autor, der gefunden wird',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus.',
    'Search Again' => 'Erneut suchen',
    'Search:' => 'Suchen:',
    'Replace:' => 'Ersetzen:',
    'Replace Checked' => 'Markierung ersetzen',
    'Case Sensitive' => 'Groß/Kleinschreibung',
    'Regex Match' => 'Regex-Match', # Translate - Previous (2) #k
    'Limited Fields' => 'Felder eingrenzen',
    'Date Range' => 'Zeitspanne',
    'Is Junk?' => 'Ist Junk?',
    'Search Fields:' => 'Felder durchsuchen:',
    'Title' => 'Überschrift',
    'Entry Body' => 'Eintragstext',
    'Comment Text' => 'Kommentartext',
    'E-mail Address' => 'Email-Addresse',
    'Email Address' => 'E-Mail-Adresse',
    'Source URL' => 'Quellen-URL',
    'Blog Name' => 'Weblog-Name',
    'Text' => 'Text', # Translate - Previous (1) #k
    'Output Filename' => 'Output-Dateiname',
    'Linked Filename' => 'Verlinkter Dateiname',
    'Display Name' => 'Anzeigename', # Translate - New (2) #k
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
    'No authors were found that match the given criteria.' => 'Keine Benutzer gefunden, auf die der Suchfilter zutrifft', # Translate - New (9) #k
    'Showing first [_1] results.' => 'Zeige die ersten [_1] Ergebnisse.',
    'Show all matches' => 'Zeige alle Ergebnisse',
    '[_1] result(s) found.' => '[_1] Ergebnisse gefunden.',

    ## ./tmpl/cms/log_table.tmpl
    'IP: [_1]' => 'IP: [_1]', # Translate - New (2) #k

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Aktivitätsprotokoll zurücksetzen',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Standardeinstellung für neue Einträge',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Hier legen Sie die Einstellungen fest, die bei neuen Einträgen standardmässig übernommen werden. Zudem konfigurieren Sie die Einstellungen zur Öffentlichkeit und zum Remote Interface.',
    'General' => 'Allgemein',
    'New Entry Defaults' => 'Standardwerte',
    'Feedback' => 'Feedback', # Translate - Previous (1) #k
    'Publishing' => 'Veröffentlichen',
    'IP Banning' => 'IP-Adressen sperren',
    'Switch to Basic Settings' => 'Zurück zu Grundeinstellungen', # Translate - New (4) #k
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
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Wenn Sie einen "Kürzlich aktualisiert"-Code erhalten haben, tragen Sie ihn hier ein.', # Translate - New (16) #k
    'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery', # Translate - Previous (2) #k
    'Enable External TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (external) aktivieren',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
    'Enable Internal TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (internal) aktivieren',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Wenn Sie diese Option aktivieren, werden Einträge auf Links untersucht und den jeweiligen Sites automatisch ein TrackBack gesendet.',
    'Save changes (s)' => 'Änderungen speichern',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Weblog Name.' => 'Sie müssen den Name Ihres Weblogs festlegen.', # Translate - New (6) #k
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
    'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universal Time Coordinated)', # Translate - Previous (4) #k
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

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'Template',
    'templates' => 'Templates',

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
    'Delete this TrackBack (x)' => 'Dieses TrackBack löschen (x)', # Translate - New (4) #k

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Ihr Eintrag wurde aus der Datenbank gelöscht.',
    'Entry Feed' => 'Einträge-Feed', # Translate - New (2) #k
    'Entry Feed (Disabled)' => 'Einträge-Feed (deaktiviert)', # Translate - New (3) #k
    'Quickfilter:' => 'Schnellfilter:', # Translate - Previous (1) #k
    'Show unpublished entries.' => 'Nicht veröffentlichte Einträge anzeigen.',
    '(Showing all entries.)' => '(Zeige alle Einträge.)', # Translate - New (4) #k
    'Showing only entries where [_1] is [_2].' => 'Zeige nur Einträge, bei denen [_1] [_2] ist.', # Translate - New (7) #k
    'entries.' => 'Einträge.',
    'entries where' => 'Einträge bei denen',
    'tag' => 'Tag', # Translate - New (1) #k
    'category' => 'Kategorie',
    'published' => 'veröffentlicht',
    'unpublished' => 'nicht veröffentlicht',
    'scheduled' => 'geplant',
    'No entries could be found.' => 'Keine Einträge gefunden.',

    ## ./tmpl/cms/header-popup.tmpl

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/edit_profile.tmpl
    'Author Permissions' => 'Benutzerrechte',
    'Your changes to [_1]\'s permissions have been saved.' => 'Die Änderungen am Benutzer [_1] wurden gespeichert',
    '[_1] has been successfully added to [_2].' => '[_1] wurde erfolgreich zu [_2] hinzugefgt.',
    'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an die Adresse  [_1] verschickt.', # Translate - New (13) #k
    'Username:' => 'Beutzername:',
    'Save permissions for this author (s)' => 'Änderungen speichern',
    'Password Recovery' => 'Passwort wird wiederhergestellt',

    ## ./tmpl/cms/footer.tmpl

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
    'Move' => 'Verschiebe', # Translate - Previous (1) #k
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate - Previous (4) #k
    'categories' => 'Kategorien', # Translate - New (1) #k
    'Delete selected categories (x)' => 'Markierte Kategorien löschen (x)', # Translate - New (4) #k

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

    ## ./tmpl/cms/author_table.tmpl

    ## ./tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'Anzeigeoptionen', # Translate - New (4) #k
    'Your entry screen preferences have been saved.' => 'Die Einstellungen für die Eintragseingabe wurden gespeichert.',
    'Editor Fields' => 'Eingabefelder', # Translate - New (2) #k
    'Basic' => 'Einfach',
    'All' => 'Alle', # Translate - New (1) #k
    'Custom' => 'Ausgewählte', # Translate - New (1) #k
    'Editable Authored On Date' => 'Änderbares Erstellungsdatum',
    'Accept TrackBacks' => 'TrackBacks zulassen',
    'Outbound TrackBack URLs' => 'TrackBack-URLs',
    'Action Bar' => 'Menüleiste', # Translate - New (2) #k
    'Select the location of the entry editor\'s action bar.' => 'Gewünschte Position der Menüleiste', # Translate - New (10) #k
    'Below' => 'Unter',
    'Above' => 'Über',
    'Both' => 'Beides',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Pings zu Sites senden...',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'ID',
    'Most Recent Comment' => 'Aktuellster Kommentar',
    'Only show trusted commenters' => 'Nur vertrauenswürdige Kommentatoren anzeigen',
    'Only show banned commenters' => 'Nur gesperrte Kommentatoren anzeigen',
    'Only show neutral commenters' => 'Nur neutrale Kommentatoren anzeigen',
    'View this commenter\'s profile' => 'Kommentatorprofil anzeigen',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Hinzugefügt am',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Die sekundären Kategorien für diesen Eintrag wurden aktualisiert. Sie müssen den Eintrag für diese Änderungen SPEICHERN, damit sie auf der öffentlichen Site wirksam werden.',
    'Categories in your weblog:' => 'Kategorien in Ihrem Weblog:',
    'Secondary categories:' => 'Sekundäre Kategorien:',
    'Assign &gt;&gt;' => 'Zuweisen &gt;&gt;', # Translate - New (3) #k
    '&lt;&lt; Remove' => '&lt;&lt; Entfernen', # Translate - New (4) #k
    'Close' => 'Schließen',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed' => 'Aktivitäts-Feed', # Translate - New (2) #k
    'Activity Feed (Disabled)' => 'Aktivitäts-Feed (deaktiviert)', # Translate - New (3) #k

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
    '([_1])' => '([_1])', # Translate - Previous (2) #k
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

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Wählen Sie die Art der erneuten Veröffentlichung aus.',
    'Rebuild All Files' => 'Alle Dateien neu veröffentlichen',
    'Index Template: [_1]' => 'Index-Template: [_1]',
    'Rebuild Indexes Only' => 'Nur Index-Dateien neu veröffentlichen',
    'Rebuild [_1] Archives Only' => 'Nur [_1] Archive neu veröffentlichen',
    'Rebuild (r)' => 'Veröffentlichen (r)',

    ## ./tmpl/cms/tag_actions.tmpl
    'Delete selected tags (x)' => 'Markierte Tags löschen (x)', # Translate - New (4) #k

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Von',
    'Target' => 'Auf',
    'Only show published TrackBacks' => 'Nur veröffentlichte TrackBacks anzeigen',
    'Only show pending TrackBacks' => 'Nur nicht veröffentlichte TrackBacks anzeigen',
    'Edit this TrackBack' => 'TrackBack bearbeiten',
    'Go to the source entry of this TrackBack' => 'Zum Eintrag wechseln, auf den sich das TrackBack bezieht',
    'View the [_1] for this TrackBack' => '[_1] zu dem TrackBack ansehen',

    ## ./tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => 'Nicht gespeicherte Änderungen gehen verloren', # Translate - New (11) #k
    'Add new category...' => 'Neue Kategorie hinzufügen...',
    'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.', # Translate - New (7) #k
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
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate - Previous (2) #k
    'Notification' => 'Benachrichtigung',
    'Scheduled' => 'Geplant',
    'Assign Multiple Categories' => 'Mehreren Kategorien zuweisen',
    'Bold' => 'Fett',
    'Italic' => 'Kursiv',
    'Underline' => 'Unterstrichen',
    'Insert Link' => 'Link einfügen',
    'Insert Email Link' => 'Email-Link einfügen',
    'Quote' => 'Zitat',
    '(comma-delimited list)' => '(Liste mit Kommatrennung)', # Translate - New (3) #k
    '(space-delimited list)' => '(Liste mit Leerzeichentrennung)', # Translate - New (3) #k
    '(delimited by \'[_1]\')' => '(Trennung durch \'[_1]\')', # Translate - New (4) #k
    'Authored On' => 'Erstellt am',
    'Unlock this entry\'s output filename for editing' => 'Dateiname zur Bearbeitung entsperren',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basenamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits besteht.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Warnung: Wenn Sie den Basename nachträglich ändern, können Links von Außen den Eintrag falsch verlinken.',
    'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
    'Customize the display of this page.' => 'Anzeige der Seite anpassen.',
    'Manage Comments' => 'Kommentare verwalten',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Klicken Sie auf den Namen des Autors, um den Kommentar zu bearbeiten. Wenn Sie einen Kommentar löschen möchten, aktivieren Sie das Kontrollkästchen rechts daneben und klicken auf die Schaltfläche "löschen".',
    'No comments exist for this entry.' => 'Zu diesem Eintrag gibt es keine Kommentare.',
    'Manage TrackBacks' => 'TrackBacks verwalten',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => 'Klicken Sie auf die Übersschrift des TrackBacks, um den TrackBack zu bearbeiten. Um den TrackBack zu löschen, markieren Sie den TrackBack und wählen Sie Löschen.',
    'No TrackBacks exist for this entry.' => 'Zu diesem Eintrag gibt es keine TrackBacks.',
    'Send a Notification' => 'Benachrichtigung senden',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'Sie können Benachrichtungen über diesen Eintrag an Mitglieder Ihrer Benachrichtungsliste oder an beliebige Adressen verschicken', # Translate - New (20) #k
    'Recipients' => 'Empfänger', # Translate - New (1) #k
    'Send notification to' => 'Benachrichtigung senden an', # Translate - New (3) #k
    'Notification list subscribers, and/or' => 'Mitglieder der Benachrichtigungsliste und/oder', # Translate - New (5) #k
    'Other email addresses' => 'Andere Email-Adresse', # Translate - New (3) #k
    'Note: Enter email addresses on separate lines or separated by commas.' => 'Hinweis: eine Email-Adresse pro Zeile oder durch Kommata getrennt eingeben', # Translate - New (11) #k
    'Notification content' => 'Benachrichtungstext', # Translate - New (2) #k
    'Your blog\'s name, this entry\'s title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry.' => 'Die Benachrichtung enthält automatisch den Namen des Blogs und des Eintrags sowie einen Link zum Eintrag. Zusätzlich können Sie einen Eintragsauszug oder den gesamten Eintrag sowie einen individuellen Hinweistext mitschicken.', # Translate - New (38) #k
    'Message to recipients (optional)' => 'Hinweistext (optional)', # Translate - New (4) #k
    'Additional content to include (optional)' => 'Eintrag (optional)', # Translate - New (5) #k
    'Entry excerpt' => 'Eintragsauszug', # Translate - New (2) #k
    'Entire entry body' => 'Gesamter Eintrag', # Translate - New (3) #k
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => 'Hinweis: Der Eintragstext wird ohne Textformatierung verschickt', # Translate - New (24) #k
    'Send entry notification' => 'Benachrichtigung versenden', # Translate - New (3) #k
    'Send notification (n)' => 'Abschicken (n)', # Translate - New (3) #k

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Autor',
    'Only show unpublished entries' => 'Nur unveröffentlichte Einträge anzeigen',
    'Only show published entries' => 'Nur veröffentlichte Einträge anzeigen',
    'Only show scheduled entries' => 'Nur terminierte Einträge anzeigen', # Translate - New (4) #k
    'None' => 'Kein(e)',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Liste aller bereits erfolgreich gesendeten TrackBacks:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Liste aller bisher fehlgeschlagenen TrackBacks. Für einen erneuten Sendeversuch bitte in die Liste der zu sendenden TrackBacks kopieren.', # Translate - New (24) #k

    ## ./tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?', # Translate - New (9) #k
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Das Movable Type Aktivitätsprotokoll zeichnet alle Systemvorgänge auf.',
    'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1].', # Translate - New (7) #k
    'All times are displayed in GMT.' => 'Alle Zeiten  in GMT.',
    'The activity log has been reset.' => 'Das Aktivitätsprotokoll wurde zurückgesetzt.',
    'Download CSV' => 'Als CSV herunterladen', # Translate - New (2) #k
    'Show only errors.' => 'Nur Fehler anzeigen.', # Translate - New (3) #k
    '(Showing all log records.)' => '(Zeige alle Einträge.)', # Translate - New (5) #k
    'Showing only log records where' => 'Zeige nur Einträge mit', # Translate - New (5) #k
    'Filtered CSV' => 'Gefiltertes CSV', # Translate - New (2) #k
    'Filtered' => 'Gefilterte', # Translate - New (1) #k
    'log records.' => 'Log-Einträge.', # Translate - New (2) #k
    'log records where' => 'Log-Einträge bei denen', # Translate - New (3) #k
    'level' => 'Level', # Translate - New (1)  #k
    'classification' => 'Klassifikation', # Translate - New (1) #k
    'Security' => 'Sicherheit', # Translate - New (1) #k
    'Error' => 'Fehler',
    'Information' => 'Information', # Translate - New (1) #k
    'Debug' => 'Debug', # Translate - New (1) #k
    'Security or error' => 'Sicherheit oder Fehler', # Translate - New (3) #k
    'Security/error/warning' => 'Security/Fehler/Warnung', # Translate - New (3) #k
    'Not debug' => 'Kein Debug', # Translate - New (2) #k
    'Debug/error' => 'Debug/Fehler', # Translate - New (2) #k
    'No log records could be found.' => 'Keine Log-Einträge gefunden.', # Translate - New (6) #k

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'Diese Domainnamen wurden in den Kommentaren gefunden. Markieren Sie eine URL, um Kommentare und TrackBacks mit dieser URL in Zukunft zu sperren.',
    'Block' => 'Sperren',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Zeigen:',
    '[quant,_1,row]' => '[quant,_1,Reihe,Reihen]',
    'all rows' => 'Alle Reihen',
    'Another amount...' => 'Andere Anzahl...',
    'Actions:' => 'Aktionen:',
    'Date Display:' => 'Datumanzeige:',
    'Relative' => 'Relativ',
    'Full' => 'Voll',
    'Open Batch Editor' => 'Batch-Editor öffnen', # Translate - New (3) #k
    'Newer' => 'Neuer',
    'Showing:' => 'Anzeige:',
    'of' => 'von',
    'Older' => 'Älter',

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

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Eintrag neu bearbeiten',
    'Save this entry' => 'Eintrag speichern',

    ## ./tmpl/cms/edit_permissions.tmpl
    'User can create weblogs' => 'Darf Weblogs anlegen',
    'User can view activity log' => 'Darf Protokoll einsehen',
    'Check All' => 'Alle markieren',
    'Uncheck All' => 'Alle deaktivieren',
    'Weblog:' => 'Weblog:', # Translate - Previous (1) #k
    'Unheck All' => 'Markierungen aufheben',
    'Add user to an additional weblog:' => 'Benutzer zu weiterem Weblog hinzufügen:',
    'Select a weblog' => 'Weblog auswählen',
    'Add' => 'Hinzufügen',

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
    'Specify when Movable Type should notify you of new comments if at all.' => 'Legt fest, ob und wann Movable Type Emails bei neuen Kommentaren versendet.',
    'Allow HTML' => 'HTML zulassen',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Wenn Sie HTML zulassen, dürfen Kommentatoren HTML verwenden. Wenn Sie HTML nicht zulassen, wird HTML in Kommentaren entfernt.',
    'Auto-Link URLs' => 'Automatisch Links für URLs erstellen',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Legt fest, ob alle URLs in einen aktiven Link umgewandelt werden.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Legt fest, ob TrackBacks von allen Quellen zugelassen sind.',
    'Moderation' => 'Moderation', # Translate - Previous (1) #k
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

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'Weblog',
    'weblogs' => 'Weblogs',
    'Delete selected weblogs (x)' => 'Ausgewählte Weblogs löschen (x)', # Translate - New (4) #k

    ## ./tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'Geben Sie ein Label für die Kategorie an.', # Translate - New (8) #k
    'Edit Category' => 'Kategorie bearbeiten', # Translate - New (2) #k
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Verwenden Sie diese Seite, um die Attribute der Kategorie [_1] zu bearbeiten. Sie können eine Beschreibung für die Kategorie festlegen, die auf den öffentlichen Seiten verwendet werden soll, und Sie können die TrackBack-Optionen für die Kategorie konfigurieren.',
    'Your category changes have been made.' => 'Die Einstellungen wurden übernommen.',
    'Label' => 'Label', # Translate - New (1) #k
    'Unlock this category\'s output filename for editing' => 'Dateiname zum Bearbeiten freigeben', # Translate - New (8) #k
    'Warning: Changing this category\'s basename may break inbound links.' => 'Achtung: Änderungen des Basenames können bestehende externe Links auf diese Kategorieseite ungültig mächen', # Translate - New (10) #k
    'Description' => 'Beschreibung',
    'Save this category (s)' => 'Kategorie speichern (s)', # Translate - New (4) #k
    'Inbound TrackBacks' => 'TrackBacks (inbound)',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Wenn die Option aktiv ist, sind Kategorie-TrackBacks aus allen Quellen zugelassen', # Translate - New (12) #k
    'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Das ist die Adresse für TrackBacks für diese Kategorie. Wenn Sie sie öffentlich machen, kann jeder, der in seinem Blog einen für diese Kategorie relevanten Eintrag geschrieben hat, einen TrackBack-Ping senden. Mittels TrackBack-Tags können Sie diese TrackBacks auf Ihrer Seite anzeigen. Näheres dazu finden Sie in der Dokumentation.', # Translate - New (78) #k
    'Passphrase Protection' => 'Passphrasenschutz', # Translate - New (2) #k
    'Optional.' => 'Optional.', # Translate - New (1) #k
    'Outbound TrackBacks' => 'TrackBacks (outbound)',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'URL(s) der Websites, denen Sie ein TrackBack senden möchten, wenn Sie in dieser Kategorie einen Eintrag veröffentlichen. (Trennen Sie mehrere URLs durch einem Zeilenumbruch.)',

    ## ./tmpl/cms/menu.tmpl
    'Recent Entries' => 'Neueste Einträge', # Translate - New (2) #k
    'Recent Comments' => 'Neueste Kommentare', # Translate - New (2) #k
    'Recent TrackBacks' => 'Neueste TrackBacks', # Translate - New (2) #k
    'Here is an overview of [_1].' => '[_1] in der Übersicht.', # Translate - New (6) #k
    'Welcome to [_1].' => 'Willkommen bei [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'Sie können Einträge veröffentlichen oder Ihr Weblog verwalten, indem Sie eine der links aufgeführten Optionen wählen.',
    'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
    'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - New (6) #k
    'Movable Type Technical Support' => 'Movable Type Technischer Support',
    'Movable Type Community Forums' => 'Movable Type Community Forums', # Translate - New (4) #k
    'Change this message.' => 'Diese Nachricht ändern.',
    'Edit this message.' => 'Diese Nachricht ändern.', # Translate - New (3) #k

    ## ./tmpl/cms/template_table.tmpl
    'Dynamic' => 'Dynamisch',
    'Linked' => 'Verlinkt',
    'Built w/Indexes' => 'mit Index-Dateien',

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Sie können sich nachfolgend erneut anmelden.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Ihre Movable Type-Session ist abgelaufen. Bitte melden Sie sich erneut an.',
    'Remember me?' => 'Benutzername speichern?',
    'Log In' => 'Anmelden',
    'Forgot your password?' => 'Passwort vergessen?',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Kategorie hinzufügen',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Um eine neue Kategorie zu erstellen, geben Sie einen Titel in untenstehendes Feld ein, wählen Sie eine übergeordnete Kategorie und klicken Sie auf die Schaltfläche "Hinzufügen".',
    'Category Title:' => 'Kategorietitel:',
    'Parent Category:' => 'Übergeordnete Kategorie:',
    'Save category (s)' => 'Kategorie speichern (s)', # Translate - New (3) #k

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
    'IP address' => 'IP-Adresse', # Translate - New (2) #k
    'IP addresses' => 'IP-Adressen',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'TrackBack(s) jetzt veröffentlicht.',
    'All junked TrackBacks have been removed.' => 'Alle Junk-TrackBacks entfernt.', # Translate - New (6) #k
    'The selected TrackBack(s) has been unpublished.' => 'TrackBack(s) zurückgezogen.',
    'The selected TrackBack(s) has been junked.' => 'TrackBack(s) jetzt Junk.',
    'The selected TrackBack(s) has been unjunked.' => 'TrackBack(s) nicht mehr Junk.',
    'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
    'No TrackBacks appeared to be junk.' => 'Keine TrackBacks sind Junk.',
    'Junk TrackBacks' => 'Junk-TrackBacks', # Translate - Previous (2) #k
    'Trackback Feed' => 'Trackback-Feed', # Translate - New (2) #k
    'Trackback Feed (Disabled)' => 'Trackback-Feed (deaktiviert)', # Translate - New (3) #k
    'Show unpublished TrackBacks.' => 'Nicht veröffentlichte TrackBacks anzeigen.',
    '(Showing all TrackBacks.)' => '(Zeige alle TrackBacks.)', # Translate - New (4) #k
    'Showing only TrackBacks where [_1] is [_2].' => 'Zeige nur TrackBacks bei denen [_1] [_2] ist.', # Translate - New (7) #k
    'TrackBacks.' => 'TrackBacks.', # Translate - Previous (1) #k
    'TrackBacks where' => 'TrackBacks die',
    'No TrackBacks could be found.' => 'Keine TrackBacks gefunden.',
    'No junk TrackBacks could be found.' => 'Keine Junk-TrackBacks gefunden.',

    ## ./tmpl/cms/header.tmpl
    'Go to:' => 'Gehe zu:', # Translate - New (2) #k
    'System-wide listing' => 'Gesamtsystem Auflistung',
    'Search (q)' => 'Suche (q)', # Translate - New (2) #k

    ## ./tmpl/cms/admin.tmpl
    'System Stats' => 'System-Stats',
    'Active Authors' => 'Aktive Autoren',
    'Version' => 'Version', # Translate - Previous (1) #k
    'Essential Links' => 'Wichtige Links',
    'System Information' => 'Systeminformation',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account', # Translate - New (6) #k
    'Your Account' => 'Ihr Account',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit', # Translate - New (8) #k
    'http://www.sixapart.com/movabletype/kb/' => 'http://www.sixapart.com/movabletype/kb/', # Translate - New (6) #k
    'Knowledge Base' => 'Knowledge Base', # Translate - Previous (2) #k
    'Support and Documentation' => 'Support und Dokumentation',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate - New (5) #k
    'Movable Type Home' => 'Movable Type Home', # Translate - Previous (3) #k
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate - New (6) #k
    'Plugin Directory' => 'Plugin-Verzeichnis',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate - New (5) #k
    'Professional Network' => 'Professional Network', # Translate - Previous (2) #k
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Hier können Sie Ihr Gesamtsystem verwalten und Einstellungen für alle Weblogs vornehmen.',

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
    'Switch to Detailed Settings' => 'Zu Detaileinstellungen wechseln', # Translate - New (4) #k
    'Registered Plugins' => 'Registrierte Plugins',
    'Disable Plugins' => 'Plugins ausschalten',
    'Enable Plugins' => 'Plugins einschalten',
    'Failed to Load' => 'Fehler beim Laden',
    'Disable' => 'Ausschalten',
    'Enabled' => 'Eingeschaltet',
    'Enable' => 'Einschalten',
    'Documentation for [_1]' => 'Dokumentation zu [_1]',
    'Documentation' => 'Dokumentation',
    'Author of [_1]' => 'Autor von [_1]',
    'More about [_1]' => 'Mehr über [_1]',
    'Support' => 'Support', # Translate - Previous (1) #k
    'Plugin Home' => 'Plugin Home', # Translate - Previous (2) #k
    'Resources' => 'Resourcen',
    'Show Resources' => 'Resourcen anzeigen',
    'More Settings' => 'Mehr Einstellungen',
    'Show Settings' => 'Einstellungen zeigen',
    'Settings for [_1]' => 'Einstellungen von [_1]',
    'Resources Provided by [_1]' => 'Resourcen von [_1]',
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
    'All junked comments have been removed.' => 'Alle Junk-Kommentare wurden entfernt.', # Translate - New (6) #k
    'The selected comment(s) has been unpublished.' => 'Kommentar(e) zurückgezogen.',
    'The selected comment(s) has been junked.' => 'Kommentar(e) jetzt Junk.',
    'The selected comment(s) has been unjunked.' => 'Kommentar(e) jetzt nicht mehr Junk.',
    'The selected comment(s) has been deleted from the database.' => 'Kommentar(e) aus der Datenbank gelöscht.',
    'One or more comments you selected were submitted by an unauthenticated visitor. These commenters cannot be assigned trust (or marked as untrusted) without proper authentication.' => 'Einer oder mehrere der ausgewählten Kommentare stammen von nicht registrierten Lesen. Um ihnen das Vertrauen auszusprechen (oder zu entziehen) sind entsprechende Rechte erforderlich.', # Translate - New (25)  #k
    'No comments appeared to be junk.' => 'Keine Kommentare sind Junk.',
    'Comment Feed' => 'Kommentar-Feed', # Translate - New (2) #k
    'Comment Feed (Disabled)' => 'Kommentar-Feed (deaktiviert)', # Translate - New (3) #k
    'Show unpublished comments.' => 'Zeige noch nicht veröffentlichte Kommentare.',
    '(Showing all comments.)' => '(Zeige alle Kommentare.)', # Translate - New (4) #k
    'Showing only comments where [_1] is [_2].' => 'Zeige nur Kommentare bei denen [_1] [_2] ist.', # Translate - New (7) #k
    'comments.' => 'Kommentare.',
    'comments where' => 'Kommentare die',
    'No comments could be found.' => 'Keine Kommentare gefunden.',
    'No junk comments could be found.' => 'Keine Junk-Kommentare gefunden.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Systemstatus und -informationen',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Hier werden Sie künftig technische Informationen finden, die bei der Fehlersuche hilfreich sein und technische Support-Anfragen beschleunigen können.', # Translate - New (28) #k

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully!' => 'Alle Daten erfolgreich importiert!', # Translate - New (4) #k
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Vergessen Sie nicht, die Dateien aus dem \'import\'-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden. ', # Translate - New (30) #k
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',

    ## ./tmpl/cms/cfg_simple.tmpl
    'This screen allows you to control all settings specific to this weblog.' => 'Hier können alle Weblog-spezifischen Einstellungen vorgenommen werden.', # Translate - New (12) #k
    'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
    'Publishing Paths' => 'System-Pfade',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Geben Sie die URL Ihrer Website an - keinen Dateinamen (z.B. nicht index.html).',
    'Site Root:' => 'Site-Root:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Der Pfad zu dem Verzeichnis, in dem Ihre Index-Datei veröffentlicht wird. Ein absoluter Pfad (beginnened mit \'/\') wird bevorzugt. Sie können aber auch einen relativen Pfad zu Ihrem Movable Type-Verzeichnis eingeben.',
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'Wählen Sie, ob eine bestimmte Anzahl von Einträgen oder die Einträge aus einer bestimmten Anzahl von Tagen angezeigt werden sollen.', # Translate - New (16) #k
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => 'Legen Sie fest, wer Kommentare schreiben darf', # Translate - New (14) #k
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'Wenn Sie möchen, daß sich Kommentatoren registrieren müssen, verwenden sie den kostenlosen TypeKey-Service.', # Translate - New (21) #k
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => 'Bestimmen Sie, was mit neuen Kommentaren geschehen sollen. Noch nicht veröffentlichte Kommentare werden zur Moderation zurückgehalten und Junk-Kommentare ausgefiltert.', # Translate - New (20) #k
    'Accept TrackBacks from people who link to your weblog.' => 'TrackBacks von Autoren akzeptieren, die Ihr Weblog verlinkt haben.', # Translate - New (9) #k
    'License' => 'Lizens', # Translate - New (1) #k

    ## ./tmpl/cms/upload_confirm.tmpl
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Eine Datei namens \'[_1]\' ist bereits vorhanden. Möchten Sie die Datei berschreiben?',

    ## ./tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Ihr Passwort wurde geändert, und das neue Passwort wurde an Ihre E-Mail-Adresse gesendet ([_1]).',
    'Enter your Movable Type username:' => 'Geben Sie Ihren Benutzernamen für Movable Type ein:',
    'Enter your password hint:' => 'Geben Sie Ihre Passwort-Frage ein:',
    'Recover' => 'Wiederherstellen',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Kopieren Sie den HTML-Code, und fügen Sie ihn in den Eintrag ein.',
    'Upload Another' => 'Weitere hochladen',

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
    'No template modules could be found.' => 'Keine Template-Module gefunden.',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Willkommen bei Movable Type!',
    'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?', # Translate - New (9) #k
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Als Abschluss des Installationsvorgangs muss nun die Datenbank initialisiert werden. Dann können Sie mit dem Bloggen beginnen.',
    'You will need to select a username and password for the administrator account.' => 'Wählen Sie einen Benutzernamen und ein Passwort für den Administrator-Account aus.', # Translate - New (13) #k
    'Password:' => 'Passwort:', # Translate - New (1) #k
    'Select a password for your account.' => 'Wählen Sie ein Passwort für Ihren Account aus.', # Translate - New (6) #k
    'Finish Install' => 'Installation beenden',

    ## ./tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'Es wurden alle Dateien neu veröffentlicht.',
    'Your [_1] has been rebuilt.' => '[_1] wurde neu veröffentlicht.',
    'Your [_1] pages have been rebuilt.' => '[_1] Seiten wurden neu veröffentlicht.',
    'View your site' => 'Site anzeigen',
    'View this page' => 'Diese Seite anzeigen',
    'Rebuild Again' => 'Neuaufbau erneut durchführen',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Weitere Aktionen...',
    'No actions' => 'Keine Aktionen',

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

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Ihr Eintrag wurde gespeichert unter [_1]',
    ', and it has been posted to your site' => ', und er wurde auf Ihrer Site gepostet.',
    '. ' => '. ', # Translate - New (0) #k
    'Edit this entry' => 'Eintrag bearbeiten',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Weblogs anzeigen',
    'List Authors' => 'Autoren anzeigen',
    'List Plugins' => 'Plugins anzeigen',
    'Aggregate' => 'Übersicht',
    'List Tags' => 'Tags anzeigen', # Translate - New (2) #k
    'Edit System Settings' => 'Systemeinstellungen bearbeiten',
    'Show Activity Log' => 'Aktivitätsprotokoll anzeigen',

    ## ./tmpl/cms/upload_complete.tmpl
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'Die Datei \'[_1]\' wurde hochgeladen. Größe: [quant,_2,byte].', # Translate - New (11) #k
    'Create a new entry using this uploaded file' => 'Einen neuen Eintrag mit dieser Datei erzeugen.',
    'Show me the HTML' => 'HTML anzeigen',
    'Image Thumbnail' => 'Miniaturansicht',
    'Create a thumbnail for this image' => 'Eine Miniaturansicht dieses Bilds erzeugen.',
    'Width:' => 'Breite:',
    'Pixels' => 'Pixel',
    'Percent' => 'Prozent',
    'Height:' => 'Hhe:',
    'Constrain proportions' => 'Proportionen beibehalten',
    'Would you like this file to be a:' => 'Wie soll die Datei angezeigt werden?',
    'Popup Image' => 'Popup-Bild',
    'Embedded Image' => 'Eingebettetes Bild',

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

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Auswählen',
    'You must choose a weblog in which to post the new entry.' => 'Sie müssen ein Weblog auswählen, in dem der neue Eintrag gepostet wird.',
    'Select a weblog for this post:' => 'Wählen Sie ein Weblog für diesen Eintrag:',
    'Send an outbound TrackBack:' => 'TrackBack (outbound) senden:',
    'Select an entry to send an outbound TrackBack:' => 'Eintrag wählen, zu dem Sie TrackBack senden möchten:',
    'Accept' => 'Annehmen', # Translate - New (1) #k
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Sie haben derzeit keine Rechte, Weblogs zu bearbeiten. Bitte kontaktieren Sie Ihren Administrator',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Möchten Sie diesen Weblog wirklich löschen?', # Translate - New (9) #k
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Unten finden Sie eine Liste mit allen Weblogs im Gesamtsystem mit Links zu der Weblog-Hauptseite und zu den Einstellungen für jedes Weblog. Sie können hier auch Weblogs anlegen oder löschen.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'Die Weblogs wurden erfolgreich aus dem System gelöscht.',
    'Create New Weblog' => 'Neues Weblog anlegen',
    'No weblogs could be found.' => 'Keine Weblogs gefunden.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Diese Template-Map wirklich löschen?', # Translate - New (10) #k
    'Publishing Settings' => 'Grundeinstellungen',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Hier können Sie alle Pfade und Archiveinstellungen vornehmen.',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fehler: Movable Type konnte das Weblog-Verzeichnis nicht automatisch anlegen. Wenn Sie die Rechte an dem Verzeichnis ändern können, konfigurieren Sie die Rechte bitte so, daß Movable Type das Verzeichnis anlegen darf.',
    'Your weblog\'s archive configuration has been saved.' => 'Die Archivkonfiguration Ihres Weblog wurde gespeichert.',
    'You may need to update your templates to account for your new archive configuration.' => 'Eventuell müssen Sie auch Ihre Templates anpassen, um die neue Archivkonfiguration entsprechend darzustellen.',
    'You have successfully added a new archive-template association.' => 'Sie haben erfolgreich eine neue Verknüpfung zwischen Archiv und Template hinzugefgt.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Eventuell müssen Sie Ihr \'Master Archive Index\'-Template aktualisieren, um die neue Archiv-Konfiguration zu übernehmen.',
    'The selected archive-template associations have been deleted.' => 'Die ausgewählten Verknüpfungen zwischen Archiv und Template wurden gelöscht.',
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
    'Individual' => 'Einzelne',
    'Daily' => 'Täglich',
    'Weekly' => 'Wöchentlich',
    'Monthly' => 'Monatliche',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Wenn Sie eine Verknüpfung zu einem archivierten Eintrag herstellen&#8212; wie einen Permalink&#8212; müssen Sie mit einem bestimmten Archivierungstyp verknüpfen, auch dann, wenn Sie mehrere Archivierungstypen ausgewählt haben.',
    'File Extension for Archive Files:' => 'Dateierweiterung für Archivierungsdateien:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Geben Sie die Erweiterung für die Archivierungsdatei an. Möglich sind \'html\', \'shtml\', \'php\' usw. Hinweis: Geben Sie nicht den führenden Punkt (\'.\') ein.',
    'Dynamic Publishing:' => 'Dynamisches Veröffentlichen:',
    'Build all templates statically' => 'Alle Templates statisch aufbauen',
    'Build only Archive Templates dynamically' => 'Nur Archiv-Templates dynamisch aufbauen',
    'Set each template\'s Build Options separately' => 'Optionen für jedes Template einzeln setzen',
    'Archive Mapping' => 'Archiv-Mapping',
    'Create New Archive Mapping' => 'Neues Archiv-Mapping einrichten',
    'Archive Type:' => 'Archivierungstyp:',
    'INDIVIDUAL_ADV' => 'Einzeln',
    'DAILY_ADV' => 'Täglich',
    'WEEKLY_ADV' => 'Wöchentlich',
    'MONTHLY_ADV' => 'Monatlich',
    'CATEGORY_ADV' => 'Kategorie',
    'Template:' => 'Template:', # Translate - Previous (1) #k
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
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Wählen Sie die lokale aus, die Sie hochladen möchten',
    'File:' => 'Datei:',
    'Set Upload Path' => 'Ziel wählen', # Translate - New (3) #k
    '(Optional)' => '(optional)',
    'Path:' => 'Ordner:', # Translate - New (1) #k
    'Site Root' => 'Site-Hauptverzeichnis', # Translate - New (2) #k
    'Archive Root' => 'Archiv-Hauptverzeichnis', # Translate - New (2) #k
    'Upload' => 'Hochladen',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'Standard-Anzeigeoptionen für Editor', # Translate - New (5) #k

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'Passwörter wiederherstellen', # Translate - New (2) #k
    'No authors were selected to process.' => 'Es wurden keine Benutzer ausgewählt.', # Translate - New (6) #k

    ## ./tmpl/cms/edit_admin_permissions.tmpl

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ein nicht freigeschaltes TrackBack wurde bei Ihrem Weblog [_1] registriert - zu Eintrag #[_2] ([_3]). Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ein nicht freigeschaltes TrackBack wurde bei Ihrem Weblog [_1] registriert - zu Kategorie #[_2], ([_3]). Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
    'Approve this TrackBack:' => 'TrackBack freischalten:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert - zu Eintrag #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert - zu Kategorie #[_2] ([_3]).',
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
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Vielen Dank, daß Sie die Aktualisierungsbenachrichtungen von [_1] abonnieren möchten. Bitte folgen Sie zur Bestätigung diesem Link:', # Translate - New (17) #k
    'If the link is not clickable, just copy and paste it into your browser.' => 'Wenn der Link nicht anklickbar ist, kopieren Sie ihn einfach und fügen ihn in der Adresszeile Ihres Browers ein.',

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] Update: [_2]', # Translate - Previous (4) #k

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type', # Translate - New (4) #k
    'Version [_1]' => 'Version [_1]', # Translate - New (2) #k

    ## ./tmpl/feeds/feed_entry.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'Movable Type Activity Log' => 'Movable Type Aktivitätsprotokoll', # Translate - New (4) #k
    'Movable Type System Activity' => 'Movable Type Systemaktivität', # Translate - New (4) #k
    'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.', # Translate - New (10) #k

    ## ./tmpl/feeds/error.tmpl

    ## ./tmpl/feeds/feed_ping.tmpl

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'Wöchentlich',
    'Unpublish Comment(s)' => 'Kommentare nicht mehr veröffentlichen',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Wird verwendet, wenn ein Kommentar nicht sofort veröffentlicht wird.',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Eine Liste aller Einträge in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    '_BLOG_CONFIG_MODE_DETAIL' => 'Detailmodus', # Translate - New (5) #k
    'RSS 1.0 Index' => 'RSS 1.0 Index', # Translate - Previous (3) #k
    'Manage Categories' => 'Kategorien verwalten',
    '_USAGE_BOOKMARKLET_4' => 'Nachdem Sie das QuickPost-Lesezeichen installiert haben, können Sie jederzeit einen Eintrag veröffentlichen. Klicken Sie auf den QuickPost-Link und verwenden Sie das Popup-Fenster, um einen Eintrag zu schreiben und zu veröffentlichen.',
    '_USAGE_ARCHIVING_2' => 'Sie können jedes Archivtemplate in Ihren Template-Einstellungen konfigurieren.',
    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
    '_BLOG_CONFIG_MODE_BASIC' => 'Vereinfachter Modus', # Translate - New (5) #k
    'View Activity Log For This Weblog' => 'Protokoll ansehen',
    'DAILY_ADV' => 'Täglich',
    '_USAGE_PERMISSIONS_3' => 'Sie können entweder einen Autoren aus dem Menü auswählen oder die komplette Liste aller Autoren ansehen und dann Autoren auswählen.',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Bitte klicken Sie auf den Bestätigungslink in der Mail, die an [_1] verschickt wurde. So wird sichergestellt, daß die angegebene Email-Adresse wirklich Ihnen gehört.', # Translate - New (4) #k
    '_USAGE_NOTIFICATIONS' => 'Eine Liste der Personen, die benachrichtigt werden, wenn Sie einen neuen Eintrag veröffentlichen. Um eine neue Person hinzuzufügen, geben Sie einfach die Email-Adresse ein. Das URL-Feld ist optional.',
    'Manage Notification List' => 'Benachrichtigungen verwalten',
    'Individual' => 'Einzelne',
    '_USAGE_COMMENTERS_LIST' => 'Eine Liste der authentifizierten Kommentatoren bei [_1]. Die Kommentatoren können Sie unten bearbeiten.',
    'RSS 2.0 Index' => 'RSS 2.0 Index', # Translate - Previous (3) #k
    '_USAGE_BANLIST' => 'Hier können Sie IP-Adressen dafür sperren, daß Kommentare abgegeben oder TrackBack-Pings an Ihr Weblog gesendet werden. Sie können der Sperrliste sowohl neue IP-Adressen hinzufügen oder gesperret IP-Adressen wieder löschen.',
    '_ERROR_DATABASE_CONNECTION' => 'Ihre Datenbankkonfiguration ist fehlerhaft. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    'Configure Weblog' => 'Weblog einrichten',
    '_INDEX_INTRO' => '<p>Die <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">Movable Type Installationsanleitung</a> enthält alle Hinweise zur Installation. Der <a rel="nofollow" href="mt-check.cgi">Movable Type System Check</a> untersucht Ihr System und sagt Ihnen, ob alle erforderlichen Pakete vorhanden sind.</p>', # Translate - New (3) #k
    '_USAGE_AUTHORS' => 'Eine Liste aller Benutzer im Movable Type-System. Sie können die Berechtigungen eines Autors bearbeiten, indem Sie auf dessen Namen klicken. Wenn Sie das Kontrollkästchen <b>löschen</b> aktivieren und anschließend auf LöSCHEN klicken, werden Autoren dauerhaft gelöscht. HINWEIS: Wenn Sie einen Autor lediglich aus einem bestimmmten Blog entfernen möchten, bearbeiten Sie die Berechtigungen des Autors, um ihn zu entfernen. Beim löschen von Autoren unter Verwendung von LöSCHEN werden Autoren komplett aus dem System entfernt.',
    '_USAGE_FEEDBACK_PREFS' => 'Hier können Sie festlegen, ob und wie Feedback von Kommentatoren und TrackBacks auf Ihrem Weblog angezeigt wird.',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Eine Liste aller Kommentare in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    '_USAGE_NEW_AUTHOR' => 'Hier können Sie einen neuen Autoren anlegen und einem oder mehreren Weblogs zuordnen.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Mit diesem Passwort können Sie sich nun am System anmelden. Danach können Sie das Passwort ändern.',
    '_USAGE_COMMENT' => 'Bearbeiten Sie den Kommentar. Speichern Sie die Änderungen, wenn Sie fertig sind. Um die Änderungen zu sehen, müssen Sie den Eintrag neu veröffentlichen.',
    '_USAGE_FORGOT_PASSWORD_1' => 'Sie haben ein neues Movable Type Passwort angefordert. Ihr Passwort wurde automatisch geändert; das neue Passwort lautet:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Eine Liste aller Kommentare in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    '_USAGE_EXPORT_2' => 'Um Ihre Einträge zu exportieren, klicken Sie auf den folgenden Link ("Einträge exportieren von [_1]"). Um die exportierten Daten in einer Datei zu speichern, klicken Sie auf den Link, whrend Sie <code>Option</code> auf dem Macintosh bzw. <code>Umschalt</code> auf dem PC gedrückt halten. Sie können auch sämtliche Daten auswählen und sie in ein anderes Dokument kopieren. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exportieren aus dem Internet Explorer?</a>)',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Wird verwendet, wenn auf ein Popup Bild geklickt wird.',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Eine Liste aller TrackBack-Pings in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Wird verwendet, wenn es beim dynamischen Aufbau einer Seite zu einem Fehler kommt.',
    'Publish Entries' => 'Einträge veröffentlichen',
    'Date-Based Archive' => 'Datumsbasiertes Archiv',
    'Unban Commenter(s)' => 'Kommentatorsperre aufheben',
    'Individual Entry Archive' => 'Einzelne Einträge Archiv',
    'Daily' => 'Täglich',
    '_USAGE_PING_LIST_OVERVIEW' => 'Eine Liste aller TrackBack-Pings in allen Weblogs, die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
    '_USAGE_UPLOAD' => 'Laden Sie diese Datei in Ihren lokalen Site-Pfad <a href="javascript:alert(\'[_1]\')">(?)</a>. Optional können Sie die Datei in ein beliebiges Unterverzeichnis laden und den Pfad dann in der Textbox eintragen. Wenn das Verzeichnis nicht besteht, wird es angelegt.',
    'AUTO DETECT' => 'Auto-detect', # Translate - New (2) #k
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">NEU VERÖFFENTLICHEN</a>, damit die Änderungen sichtbar werden.',
    'Blog Administrator' => 'Blog-Administrator',
    'CATEGORY_ADV' => 'Kategorie',
    '_WARNING_PASSWORD_RESET_MULTI' => 'Sie möchten die Passwörter der gewählten Benutzer zurücksetzen. Den Benutzern werden zufällig erzeugte neue Passwörter per Email zugeschickt werden.\n\n\Forsetzen?', # Translate - New (5)
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper', # Translate - Previous (3) #k
    '_USAGE_PLUGINS' => 'Eine Liste aller Plugins, die derzeit im System registriert sind.',
    '_USAGE_COMMENTS_LIST_BLOG' => 'Eine Liste aller Kommentare zu [_1], die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    'Category Archive' => 'Kategorie-Archiv',
    '_USAGE_PERMISSIONS_2' => 'Um einen anderen Autoren zu bearbeiten, wählen Sie den entsprechenden Autoren aus dem Menü aus.',
    '_USAGE_EXPORT_1' => 'Indem Sie Einträge aus Movable Type exportieren, erhalten Sie <b>persönliche Sicherungen</b> Ihrer Weblog-Einträge. Die Daten werden in einem Format exportiert, in dem sie jederzeit zurück in das System importiert werden können. Das Exportieren von Einträgen dient nicht nur der Sicherung, Sie können damit auch <b>Inhalte zwischen Weblogs verschieben</b>.',
    'Untrust Commenter(s)' => 'Kommentatoren nicht mehr vertrauen',
    '_SYSTEM_TEMPLATE_PINGS' => 'Wird verwendet, wenn TrackBack-Popups eingesetzt werden (auslaufend).',
    'Entry Creation' => 'Neuer Eintrag',
    '_USAGE_PROFILE' => 'Hier bearbeiten Sie Ihr Autorenprofil. Wenn Sie Ihren Benutzernamen und Ihr Passwort ändern, werden die Login-Informationen sofort aktualisiert, und Sie müssen sich nicht erneut anmelden.',
    'Category' => 'Kategorie',
    'Atom Index' => 'Atom Index', # Translate - Previous (2) #k
    '_USAGE_PLACEMENTS' => 'Verwenden Sie die untenstehenden Optionen, um die sekundären Kategorien zu bearbeiten, denen dieser Eintrag zugeordnet ist. Die linke Liste zeigt alle Kategorien an, denen der Eintrag noch nicht zugeordnet ist. Die rechte Liste zeigt die Kategorien an, denen der Eintrag bereits zugordnet ist.',
    '_USAGE_ENTRYPREFS' => 'Die Feldkonfiguration legt fest, welche Felder in Ihrer Eingabemaske für neue Einträge erscheinen. Sie könnnen die vordefinierten Einstellungen verwenden (Einfach oder Erweitert) oder die Felder frei auswählen.',
    '_THROTTLED_COMMENT_EMAIL' => 'Ein Kommentator Ihres Weblogs [_1] wurde automatisch gesperrt. Der Kommentator hat mehr als die erlaubte Anzahl an Kommentaren in den letzten [_2] Sekunden veröffentlicht. Diese Sperre schützt Sie vor Spam-Skripts. Die gesperrte IP-Adresse ist [_3]. Wenn diese Sperrung ein Fehler war, können Sie die IP-Adresse wieder entsperren. Wählen Sie die IP-Adresse [_4] aus der IP-Sperrliste und löschen Sie die Adresse aus der Liste.',
    'Stylesheet' => 'Stylesheet', # Translate - Previous (1) #k #k
    'RSD' => 'RSD', # Translate - Previous (1) #k #k
    'MONTHLY_ADV' => 'Monatlich',
    '_USAGE_ARCHIVE_MAPS' => 'Diese fortgeschrittene Funktion erlaubt es Ihnen, ein Archiv-Template auf verschiedene Archivtypen zu mappen. So können Sie z.B. zwei unterschiedliche Views Ihrer monatlichen Archive erzeugen; einen als Liste und einen als Kalenderansicht.',
    'Trust Commenter(s)' => 'Kommentatoren vertrauen',
    'Manage Tags' => 'Tags verwalten', # Translate - New (2) #k
    '_THROTTLED_COMMENT' => 'Um mein Weblog vor Spam-Skripten zu schützen, müssen Sie einen Moment warten, um erneut einen Kommentar zu hinterlassen. Bitte haben Sie ein wenig Geduld. Danke für Ihr Verständnis.',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Wird verwendet, wenn ein Kommentator eine Kommentarvorschau anzeigt.',
    'Manage Templates' => 'Templates verwalten',
    '_USAGE_BOOKMARKLET_3' => 'Um das QuickPost-Lesezeichen zu installieren, ziehen Sie den folgenden Link in Ihr Browsermenü oder auf die Symbolleiste der Favoriten:',
    '_USAGE_PASSWORD_RESET' => 'Unten können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufällig erzeugtes neues Passwort an seine Adresse verschickt werden: [_1].', # Translate - New (4) #k	
    '_USAGE_SEARCH' => 'Sie können Suchen &amp; Ersetzen einsetzenm, um Daten in Weblogs zu finden und optional zu ersetzen. WICHTIG:  Verwenden Sie Suchen &amp; Ersetzen mit Vorsicht. Der Vorgang kann <b>nicht</b> rückgängig gemacht werden.',
    '_AUTO' => '1',
    '_external_link_target' => '_top', # Translate - New (4) #k
    '_USAGE_BOOKMARKLET_2' => 'Sie können die Bestandteile von QuickPost frei konfigurieren. Sie können die Schaltflächen aktivieren, die Sie häufig verwenden.',
    '_USAGE_PERMISSIONS_1' => 'Sie bearbeiten die Autorenrechte von <b>[_1]</b>. Unten sehen Sie eine Liste der Weblogs, für die Sie Autorenrechte vergeben dürfen. Wählen Sie ein Weblog aus und vergeben Sie die entsprechenden Rechte für <b>[_1]</b>.',
    'Add/Manage Categories' => 'Kategorien hinzufügen/verwalten', # Translate - New (3) #k
    '_USAGE_LIST_POWER' => 'Eine Liste der Einträge in [_1] im Stapelverarbeitungsmodus. Im nachfolgenden Formular können Sie alle Werte für jeden angezeigten Eintrag ändern. Klicken Sie auf die Schaltfläche SPEICHERN, nachdem Sie die gewünschten Änderungen vorgenommen haben. Die standardmäßigen Steuerelemente für "Einträge auflisten &amp; bearbeiten" (Filter, Paging) arbeiten im Stapelverarbeitungsmodus, wie Sie es gewöhnt sind.',
    '_ERROR_CONFIG_FILE' => 'Ihre Movable Type Konfigurationsdatei fehlt oder kann nicht gelesen werden. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitede/">Movable Type <$MTVersion$></a>',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Ein zufällig erzeugtes neues Passwort wird an seine Adresse [_2] verschickt werden.\n\nForsetzen?', # Translate - New (5) #k
    '_USAGE_PING_LIST_BLOG' => 'Eine Liste aller TrackBack-Pings in [_1], die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    'Monthly' => 'Monatliche',
    '_USAGE_ARCHIVING_1' => 'Wählen Sie die Archivtypen aus, die Sie für Ihr Weblog verwenden möchten. Sie können für jeden Archivtypen optional mehrere Archivtemplates verwenden.',
    'Ban Commenter(s)' => 'Kommentatorsperre einrichten',
    '_USAGE_VIEW_LOG' => 'Überprüfen Sie das <a href="[_1]">Aktivitätsprotokoll</a>, um den Fehler zu finden.',
    '_USAGE_PERMISSIONS_4' => 'Jedes Weblog kann mehrere Autoren haben. So können jedem Weblog Autoren hinzufügen. Legen Sie einen neuen Autoren an und vergeben Sie dann die benötigten Rechte.',
    '_USAGE_BOOKMARKLET_1' => 'Wenn Sie QuickPost einrichten, können Sie einfach neue Einträge veröffentlichen, ohne direkt in Movable Type zu arbeiten.',
    '_USAGE_ARCHIVING_3' => 'Wählen Sie den Archivtypen und ordnen Sie dann ein Archivtemplate zu.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Wird bei der Suche im Blog angezeigt', # Translate - New (5) #k
    'UTC+10' => 'UTC+10 (East Australian Standard Time)',
    '_USAGE_TAGS' => 'Mit Tags können Sie Einträge schnell und einfach verschlagworten und gruppieren', # Translate - New (3) #k
    'INDIVIDUAL_ADV' => 'Einzeln',
    '_USAGE_BOOKMARKLET_5' => 'Falls Sie unter Windows mit dem Internet Explorer arbeiten, können Sie die Option "QuickPost" zum Kontextmenü von Windows hinzufügen. Klicken Sie auf den nachfolgenden Link, um die Eingabeaufforderung des Browsers zum öffnen der Datei zu akzeptieren. Beenden Sie das Programm, und starten Sie den Browser erneut, um den Link zum Kontextmenü hinzuzufügen.',
    '_ERROR_CGI_PATH' => 'Ihre CGIPath-Konfiguration fehlt oder ist fehlerhaft. Bitte lesen Sie die Movable Type Dokumention: <a href="#">Installation and Configuration</a>.',
    '_USAGE_IMPORT' => 'Mit dem Mechanismus zum Importieren von Einträgen können Sie Einträge aus einem anderen Weblog-System importieren. Dass Handbuch enthält ausführliche Anweisungen zum Importieren.',
    'Main Index' => 'Hauptindex', # Translate - Previous (2) #k
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Wird verwendet, wenn Kommentar-Popups eingesetzt werden (auslaufend).',
    '_USAGE_CATEGORIES' => 'Verwenden Sie Kategorien, um Einträge bestimmten Themen zuzuordnen oder Ihr Weblog zu ordnen. Sie können einen Eintrag einer Kategorie zuordnen, wenn Sie den Eintrag schreiben oder wenn Sie nachträglich bearbeiten. Sie können auch Unterkategorien verwenden und Kategorien verschieben.',
    '_USAGE_ENTRY_LIST_BLOG' => 'Eine Liste aller Einträge in [_1], die Sie filtern, verwalten und bearbeiten können.', # Translate - New (5) #k
    'Master Archive Index' => 'Master Archiv Index',
    'Weekly' => 'Wöchentlich',
    'Unpublish TrackBack(s)' => 'TrackBacks nicht mehr veröffentlichen',
    '_USAGE_EXPORT_3' => 'Durch Klicken auf den nachfolgenden Link werden alle aktuellen Weblog-Einträge exportiert. In der Regel ist das übertragen der Einträge ein einmaliger Vorgang. Sie können den Vorgang aber jederzeit wiederholen.',
    'Send Notifications' => 'Benachrichtigungen versenden',
    'Edit All Entries' => 'Alle Einträge bearbeiten',
    '_USAGE_PREFS' => 'Hier können Sie eine Anzahl von optionalen Einstellungen für Ihr Weblog, Ihre Archive und Kommentare, Ihre Feeds und für Benachrichtigungen vornehmen. Wenn Sie ein neues Weblog anlegen, werden diese Werte auf gängige Standardwerte gesetzt.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Wird verwendet, wenn ein Kommentar nicht sofort validiert werden kan.',
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
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind erforderlich, wenn Sie das PostgreSQL-Datenbank-Backend einsetzen möchten.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind erforderlich, wenn Sie eine SQLite-Datenbank einsetzen möchten.',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI and DBD::SQLite2 sind erforderlich, wenn Sie eine SQLite 2.x-Datenbank einsetzen möchten.', # Translate - New (17) #k
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities ist zur Codierung einiger Sonderzeichen erforderlich. Diese Funktion kann jedoch mit der Option NoHTMLEntities in mt.cfg deaktiviert werden.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent ist optional und nur erforderlich, wenn Sie das TrackBack-System, den weblogs.com-Ping oder den "Kürzlich aktualisiert"-Ping von MT einsetzen möchten.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite ist optional und nur erforderlich, wenn Sie die XML-RPC Server-Implementierung von MT einsetzen möchten',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp ist optional, und nur erforderlich, wenn Sie vorhandene Dateien beim Hochladen überschreiben können möchten.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick ist optional, und nur erforderlich, wenn Sie automatisch Miniaturansichten von hochgeladenen Bildern erzeugen möchten.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable ist optional und nur für einige MT-Plugins von Drittanbietern erforderlich.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA ist optional. Durch die Installation wird der Anmeldevorgang für die Kommentarregistrierung beschleunigt.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 ist für die Aktivierung der Kommentarregistrierung erforderlich.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist für den Einsatz der Atom-API erforderlich.',
    'Data Storage' => 'Datenbank',
    'Required' => 'erforderlichen',
    'Optional' => 'optionalen',

    ## ./extlib/DateTime.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/CGI.pm

    ## ./extlib/JSON.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/URI.pm

    ## ./extlib/LWP.pm

    ## ./extlib/Jcode.pm

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Listing.pm

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

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/UDDI/Lite.pm

    ## ./extlib/Net/HTTP.pm

    ## ./extlib/Net/HTTPS.pm

    ## ./extlib/Net/HTTP/NB.pm

    ## ./extlib/Net/HTTP/Methods.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/SAX.pm

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

    ## ./extlib/HTML/Template.pm

    ## ./extlib/HTML/Form.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/Class/Accessor.pm

    ## ./extlib/Class/Accessor/Fast.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

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

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/_segment.pm

    ## ./extlib/URI/Fetch.pm

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

    ## ./extlib/Locale/Maketext.pm

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

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Switch.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/Jcode/Tr.pm

    ## ./extlib/Jcode/Constants.pm

    ## ./extlib/Jcode/H2Z.pm

    ## ./extlib/Jcode/Unicode/NoXS.pm

    ## ./extlib/Jcode/Unicode/Constants.pm

    ## ./extlib/MIME/Words.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./tools/Html.pm

    ## ./tools/Backup.pm

    ## ./tools/sample.pm

    ## ./tools/cwapi.pm

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/TaskMgr.pm
    'Error during task \'[_1]\': [_2]' => 'Fehler während Task \'[_1]\': [_2]', # Translate - New (5) #k
    'Task Update' => 'Task Update', # Translate - New (2) #k

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein', # Translate - New (7) #k
    'Category loop detected' => 'Kategorieschleife festgestellt', # Translate - New (3) #k

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]', # Translate - Previous (4) #k

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Datei \'[_1]\' kann nicht gelesen werden: [_2]',
    'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'Skalieren auf [_1]x[_2] fehlgeschlagen: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad auf die NetPBM-Tools auf Ihrem Computer.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Upgrade.pm
    'Invalid upgrade function: [_1].' => 'Ungültige Upgrade-Funktion: [_1].', # Translate - Previous (4) #k
    'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1].', # Translate - Previous (4) #k
    'Creating initial weblog and author records...' => 'Lege erstes Weblog und Benutzer an...',
    'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].', # Translate - Previous (4) #k
    'First Weblog' => 'Erstes Weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Kann Liste der Standardvorlagen nicht finden - wo befindet sich \'default-templates.pl\'? Fehler: [_1]', # Translate - Previous (12) #k
    'Creating new template: \'[_1]\'.' => 'Lege neues Template an: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Verknüpfung von Template mit Weblog-Archivierungstypen...',
    'Upgrading table for [_1]' => 'Upgrade Tabelle [_1]',
    'Upgrading database from version [_1].' => 'Upgrade der Datenbank auf Version [_1].',
    'Database has been upgraded to version [_1].' => 'Datenbank ist nun Version [_1].',
    'Setting your permissions to administrator.' => 'Rechte auf Administrator gesetzt.',
    'Creating configuration record.' => 'Lege Configuration-Eintrag an.',
    'Creating template maps...' => 'Lege Template-Maps an...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Template-ID [_1] mit [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Verknüpfe Template-ID [_1] mit [_2].',

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Freischalten/Sperren nicht möglich', # Translate - New (6) #k
    'The approval could not be committed: [_1]' => 'Konnte nicht übernommen werden: [_1]', # Translate - New (7) #k

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Keine WeblogsPingURL definiert in mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Keine MTPingURL definiert in mt.cfg',
    'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
    'Ping error: [_1]' => 'Ping-Fehler: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/TBPing.pm
    'Load of blog \'[_1]\' failed: [_2]' => 'Weblog \'[_1]\' konnte nicht geladen werden: [_2]',

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> ohne &lt;/MT[_1]>', # Translate - New (9) #k
    'Error in &lt;MT[_1]> tag: [_2]' => 'Fehler im &lt;MT[_1]>-Tag: [_2]', # Translate - New (7) #k

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'Das vierte Argument von add_callback muss eine Perl-CODE-Referenz sein', # Translate - New (11) #k

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Tag muss einen gültigen Namen haben', # Translate - New (6) #k
    'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.', # Translate - New (6) #k

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]', # Translate - New (4) #k
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Benutzer \'[_1]\' (Benutzer #[_2]) angemeldet',
    'Invalid login attempt from user \'[_1]\'' => 'Ungültiger Login-Versuch von Benutzer \'[_1]\'',
    'Invalid login.' => 'Login ungültig.',
    'User \'[_1]\' (user #[_2]) logged out' => 'Benutzer \'[_1]\' (Benutzer #[_2]) abgemeldet',
    'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu gross.',
    'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Laden des Templates \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.', # Translate - New (4) #k
    'Junk Log (Score: [_1])' => 'Junk-Log (Score: [_1])', # Translate - New (4) #k
    'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.', # Translate - New (4) #k
    'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.', # Translate - New (4) #k

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/AtomServer.pm
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Benutzer \'[_1]\' (Benutzer #[_2]) hat Eintrag #[_3] hinzugefügt', # Translate - New (7) #k

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Laden des Weblogs fehlgeschlagen: [_1]',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Parsing-Fehler im Template \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Build-Fehler im Template \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Öffenen der verlinkten Datei \'[_1]\' fehlgeschlagen: [_2]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'Kein Stream', # Translate - New (2) #k
    'No Blog' => 'Kein Blog', # Translate - New (2) #k
    'Can\'t rewind' => 'Kann nicht zurückspulen', # Translate - New (3)
    'Can\'t open \'[_1]\': [_2]' => 'Kann \'[_1]\' nicht öffnen: [_2]', # Translate - Previous (5) #k
    'Can\'t open directory \'[_1]\': [_2]' => 'Kann Verzeichnis \'[_1]\' nicht öffnen: [_2]',
    'No readable files could be found in your import directory [_1].' => 'Im Import-Verzeichnis [_1] konnten keine lesbaren Dateien gefunden werden.', # Translate - Previous (11) #k
    'Importing entries from file \'[_1]\'' => 'Importieren der Einträge aus Datei \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'Passwort erforderlich, um\n',
    'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
    'Creating new author (\'[_1]\')...' => 'Lege neuen Autoren an (\'[_1]\')...', # Translate - New (4) #k
    'ok\n' => 'ok\n', # Translate - Previous (2) #k
    'failed\n' => 'fehlgeschlagen\n',
    'Saving author failed: [_1]' => 'Speichern von Autor fehlgeschlagen: [_1]',
    'Assigning permissions for new author...' => 'Weise neuem Benutzer Rechte zu...', # Translate - New (5) #k
    'Saving permission failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Creating new category (\'[_1]\')...' => 'Lege neue Kategorie an (\'[_1]\')...', # Translate - New (4) #k
    'Saving category failed: [_1]' => 'Speichern von Kategorie fehlgeschlagen: [_1]',
    'Invalid status value \'[_1]\'' => 'Ungültiger Status-Wert \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Ungültiger Ping-Status \'[_1]\'', # Translate - New (5) #k
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Kann Eintrag mit Zeitstempel \'[_1]\' nicht finden... überspringe Kommentare und gehe zu nächstem Eintrag.\n', # Translate - New (17) #k
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Importiere in vorhandenen Eintrag [_1] (\'[_2]\')\n', # Translate - New (7) #k
    'Saving entry (\'[_1]\')...' => 'Speichere Eintrag (\'[_1]\')...', # Translate - New (3) #k
    'ok (ID [_1])\n' => 'OK (ID [_1])\n', # Translate - New (4) #k
    'Saving entry failed: [_1]' => 'Speichern von Eintrag fehlgeschlagen: [_1]',
    'Saving placement failed: [_1]' => 'Speichern von Platzierung fehlgeschlagen: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar an (von \'[_1]\')...', # Translate - New (5) #k
    'Saving comment failed: [_1]' => 'Speichern von Kommentar fehlgeschlagen: [_1]',
    'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
    'Creating new ping (\'[_1]\')...' => 'Lege neuen Ping an (\'[_1]\')...', # Translate - New (4) #k
    'Saving ping failed: [_1]' => 'Speichern von Ping fehlgeschlagen: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Export von \'[_1]\' fehlgeschlagen bei: [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Ungültiges Datumsformat \'[_1]\'; muss sein', # Translate - New (6) #k

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

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Aktion: Junked (Score unterschreitet Grenzwert)',
    'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
    'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] abgebrochen: [_2]',
    'Unnamed Junk Filter' => 'Namenloser Junk Filter',
    'Composite score: [_1]' => 'Gesamt-Score: [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Unbekannte MailTransfer-Methode \'[_1]\'', # Translate - Previous (4) #k
    'Sending mail via SMTP requires that your server ' => 'Das Verschicken von Mails via SMTP erfordert, daß Ihr Server', # Translate - Previous (8) #k
    'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'Kein gültiger Pfad zu sendmail auf dem Computer. ',
    'Exec of sendmail failed: [_1]' => 'Ausführung von sendmail fehlgeschlagen: [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format', # Translate - New (3) #k
    'No web services password assigned.  Please see your author profile to set it.' => 'Kein Web Services-Passwort vorhanden. Bitte legen Sie auf Ihrer Profilseite eines fest.', # Translate - New (13) #k
    'No blog_id' => 'blog_id fehlt', # Translate - New (3) #k
    'Invalid blog ID \'[_1]\'' => 'Ungültige blog_id \'[_1]\'', # Translate - New (4) #k
    'Invalid login' => 'Login ungültig', # Translate - New (2) #k
    'No posting privileges' => 'Keine Schreibrechte', # Translate - New (3) #k
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '\'mt_[_1]\' kann nur 0 oder 1 sein (war \'[_2]\')', # Translate - New (11) #k
    'No entry_id' => 'entry_id fehlt', # Translate - New (3) #k
    'Invalid entry ID \'[_1]\'' => 'Ungültige Eintrags-ID \'[_1]\'',
    'Not privileged to edit entry' => 'Keine Bearbeitungsrechte', # Translate - New (5) #k
    'Not privileged to delete entry' => 'Keine Löschrechte', # Translate - New (5) #k
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Eintrag \'[_1]\' (Eintrag #[_2]) von \'[_3]\' (Benutzer #[_4]) via XML-RPC gelöscht', # Translate - New (11) #k
    'Not privileged to get entry' => 'Keine Leserechte', # Translate - New (5) #k
    'Author does not have privileges' => 'Autor hat keine Rechte', # Translate - New (5) #k
    'Not privileged to set entry categories' => 'Keine Rechte, Kategorien zu vergeben', # Translate - New (6) #k
    'Publish failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]', # Translate - New (3) #k
    'Not privileged to upload files' => 'Keine Upload-Rechte', # Translate - New (5) #k
    'No filename provided' => 'Kein Dateiname angegeben', # Translate - New (3) #k
    'Invalid filename \'[_1]\'' => 'Ungültiger Dateiname \'[_1]\'', # Translate - Previous (3) #k
    'Error making path \'[_1]\': [_2]' => 'Fehler beim Anlegen des Ordners \'[_1]\': [_2]', # Translate - New (5) #k
    'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]', # Translate - New (5) #k
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Template-Methoden sind aufgrund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert, due to differences between the Blogger API and the Movable Type API.', # Translate - New (17) #k

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Archivtyp \'[_1]\' wurde vorher nicht ausgewählt', # Translate - Previous (9) #k
    'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' erforderlich', # Translate - Previous (4) #k
    'Building category archives, but no category provided.' => 'Keine Kategorien angegeben.', # Translate - Previous (7) #k
    'You did not set your Local Archive Path' => 'Kein Local Archive Path angegeben', # Translate - Previous (8) #k
    'Building category \'[_1]\' failed: [_2]' => 'Kategorie \'[_1]\' erzeugen fehlgeschlagen: [_2]', # Translate - Previous (5) #k
    'Building entry \'[_1]\' failed: [_2]' => 'Eintrag \'[_1]\' erzeugen fehlgeschlagen: [_2]', # Translate - Previous (5) #k
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Datumsbasiertes Archiv \'[_1]\' erzeugen fehlgeschlagen: [_2]', # Translate - Previous (6) #k
    'You did not set your Local Site Path' => 'Kein Local Site Path angegeben', # Translate - Previous (8) #k
    'Template \'[_1]\' does not have an Output File.' => 'Template \'[_1]\' hat keine Output-Datei.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Bei der Veröffentlichung terminierter Einträge ist ein Fehler aufgetreten: [_1]', # Translate - New (10) #k

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Laden des Eintrags \'[_1]\' fehlgeschlagen: [_2]', # Translate - Previous (6) #k

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'aus Regel',
    'from test' => 'aus Test',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Lesen fehlgeschlagen mit SQL-Fehler [_1]', # Translate - New (7) #k
    'Count [_1] failed on SQL error [_2]' => 'Zählung[_1] fehlgeschlagen wegen SQL-Fehler [_2]', # Translate - New (7) #k
    'Prepare failed' => 'Prepare fehlgeschlagen', # Translate - New (2) #k
    'Execute failed' => 'Execute fehlgeschlagen', # Translate - New (2) #k
    'existence test failed on SQL error [_1]' => 'Existence-Test fehlgeschlagen wegen SQL-Fehler [_1]', # Translate - New (7) #k
    'Insertion test failed on SQL error [_1]' => 'Insertion-Test fehlgeschlagen wegen SQL-Fehler [_1]', # Translate - New (7) #k
    'Update failed on SQL error [_1]' => 'Update fehlgeschlagen wegen SQL-Fehler [_1]', # Translate - New (6) #k
    'No such object.' => 'Kein solches Objekt.', # Translate - New (3) #k
    'Remove failed on SQL error [_1]' => 'Entfernen fehlgeschlagen wegen SQL-Fehler [_1]', # Translate - New (6) #k
    'Remove-all failed on SQL error [_1]' => 'Alle Entfernen fehlgeschlagen wegen SQL-Fehler [_1]', # Translate - New (6) #k

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Das DataSource-Verzeichnis (\'[_1]\') existiert nicht.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Das DataSource-Verzeichnis (\'[_1]\') ist nicht beschreibbar.', # Translate - Previous (7) #k
    'Tie \'[_1]\' failed: [_2]' => 'Verknüpfung \'[_1]\' failed: [_2]', # Translate - Previous (4) #k
    'Failed to generate unique ID: [_1]' => 'Anlegen der individuellen Kennung fehlgeschlagen: [_1]', # Translate - Previous (6) #k
    'Unlink of \'[_1]\' failed: [_2]' => 'Entknüpfung von \'[_1]\' fehlgeschlagen: [_2]', # Translate - Previous (5) #k

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Verbindungsfehler: [_1]', # Translate - Previous (3) #k
    'undefined type: [_1]' => 'Nicht definierter Typ: [_1]', # Translate - New (3) #k

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'Die Datenbankdatei (\'[_1]\') ist nicht beschreibbar.', # Translate - Previous (7) #k
    'Your database directory (\'[_1]\') is not writable.' => 'Das Datenbankverzeichnis (\'[_1]\') ist nicht beschreibbar.', # Translate - Previous (7) #k

    ## ./lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => 'Anlegen des Ordners \'[_1]\' fehlgeschlagen: [_2]', # Translate - New (5) #k
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Umbenennen von \'[_1]\' in \'[_2]\' fehlgeschlagen: [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Löschen von \'[_1]\' fehlgeschlagen: [_2]', # Translate - New (4) #k

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'DAV-Verbindung fehlgeschlagen: [_1]', # Translate - New (4) #k
    'DAV open failed: [_1]' => 'DAV-"open" fehlgeschlagen: [_1]', # Translate - New (4) #k
    'DAV get failed: [_1]' => 'DAV-"get" fehlgeschlagen: [_1]', # Translate - New (4) #k
    'DAV put failed: [_1]' => 'DAV-"put" fehlgeschlagen: [_1]', # Translate - New (4) #k

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'Öffnen der lokalen Datei \'[_1]\' fehlgeschlagen: [_2]', # Translate - Previous (6) #k

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'SFTP-Verbindung fehlgeschlagen: [_1]', # Translate - New (4) #k
    'SFTP get failed: [_1]' => 'SFTP-"get" fehlgeschlagen: [_1]', # Translate - New (4) #k
    'SFTP put failed: [_1]' => 'SFTP-"put" fehlgeschlagen: [_1]', # Translate - New (4) #k

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'Kann verwendetes Template-Modul \'[_1]\' nicht finden', # Translate - Previous (7) #k
    'Can\'t find included file \'[_1]\'' => 'Kann verwendete Datei \'[_1]\' nicht finden', # Translate - Previous (6) #k
    'Error opening included file \'[_1]\': [_2]' => 'Fehler beim Öffnen der verwendeten Datei \'[_1]\': [_2]', # Translate - Previous (6) #k
    'Unspecified archive template' => 'Nicht spezifiziertes Archiv-Template', # Translate - New (3) #k
    'Error in file template: [_1]' => 'Fehler in Datei-Template: [_1]', # Translate - New (5) #k
    'Can\'t find template \'[_1]\'' => 'Kann Vorlage \'[_1]\' nicht finden', # Translate - Previous (5) #k
    'Can\'t find entry \'[_1]\'' => 'Kann Eintrag \'[_1]\' nicht finden', # Translate - Previous (5) #k
    'You used a [_1] tag without any arguments.' => 'Sie haben einen [_1]-Tag ohne Argument verwendet.', # Translate - Previous (8) #k
    'You have an error in your \'category\' attribute: [_1]' => 'Fehler im \'category\'-Attribut: [_1]', # Translate - New (9) #k
    'You have an error in your \'tag\' attribute: [_1]' => 'Fehler im \'tag\'-Attribut: [_1]', # Translate - New (9) #k
    'No such author \'[_1]\'' => 'Kein Autor \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'Sie haben ein \'[_1]\' Tag ausserhalb eines Eintragskontexts verwendet; ',
    'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.', # Translate - Previous (6) #k
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Sie haben mit einem [_1]-Tag \'[_2]\'-Archive verlinkt, ohne diese vorher zu veröffentlichen.', # Translate - Previous (17) #k
    'Could not create atom id for entry [_1]' => 'Konnte keine ATOM-ID für Eintrag [_1] erzeugen', # Translate - New (8) #k
    'To enable comment registration, you ' => 'Um Kommetar-Registrierung zu aktivieren, müssen Sie ',
    '(You may use HTML tags for style)' => '(HTML-Tags erlaubt)',
    'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Tag ohne Datumskontext verwendet.', # Translate - Previous (11) #k
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'Sie haben einen \'[_1]\'-Tag außerhalb eines Kommentarkontexts verwendet; ', # Translate - Previous (12) #k
    'You used an [_1] without a date context set up.' => 'Sie haben [_1] ohne Datumskontext verwendet.', # Translate - Previous (10) #k
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit Tages-, Wochen- oder Monatsarchiven verwendet werden.',
    'Couldn\'t get daily archive list' => 'Konnte Tagesarchive nicht lesen', # Translate - New (6) #k
    'Couldn\'t get monthly archive list' => 'Konnte Monatsarchive nicht lesen', # Translate - New (6) #k
    'Couldn\'t get weekly archive list' => 'Konnte Wochenarchive nicht lesen', # Translate - New (6) #k
    'Unknown archive type [_1] in <MTArchiveList>' => 'Unbekannter Archivtyp [_1] in <MTArchiveList>', # Translate - New (6) #k
    'Group iterator failed.' => 'Gruppeniterator fehlgeschlagen.', # Translate - New (3) #k
    'You used an [_1] tag outside of the proper context.' => 'Sie haben ein [_1]-Tag außerhalb seines Kontexts verwendet.', #k
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'Sie haben ein [_1]-Tag außerhalb eines Tages-, Wochen-, oder Monats-', # Translate - Previous (12) #k
    'Could not determine entry' => 'Konnte Eintrag nicht bestimmen', # Translate - New (4) #k
    'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: richtig ist JJJJMM',
    'No such category \'[_1]\'' => 'Keine Kategorie \'[_1]\'',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'Sie haben <$MTCategoryDescription$> außerhalb seines Kontexts verwendet.', # Translate - New (8) #k
    '[_1] can be used only if you have enabled Category archives.' => '[_1] kann nur bei aktiven Kategorie-Archiven verwendet werden.',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \\' => '<$MTCategoryTrackbackLink$> muss im Kategoriekontext verwendet werden, oder mit einem \\', # Translate - New (14) #k
    'You failed to specify the label attribute for the [_1] tag.' => 'Kein Label-Attribut des [_1]-Tags angegeben.', # Translate - New (11) #k
    'You used an \'[_1]\' tag outside of the context of ' => 'Sie verwenden ein \'[_1]\'-Tag außerhalb des Kontexts von ', # Translate - New (10) #k
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse außerhalb von MTSubCategories verwendet', # Translate - New (5) #k
    'MT[_1] must be used in a category context' => 'MT[_1] muss im Kategoriekontext verwendet werden', # Translate - New (9) #k
    'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]', # Translate - New (5) #k
    'Error sorting categories: [_1]' => 'Fehler beim Sortieren der Kategorien: [_1]', # Translate - New (4) #k

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Bitte geben Sie eine gültige Email-Adresse an.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Erforderliches Parameter blog_id fehlt. Bitte konfigurieren Sie die Benachrichtungsfunktion entsprechend.', # Translate - Previous (13) #k
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'Email-Benachrichtungen wurden nicht konfiguriert! Sie müssen EmailVerificationSecret in mt.cfg konfigurieren.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Ungültiges Redirect-Parameter. Sie müssen einen zur verwendeten Domain gehörenden Pfad angeben.', # Translate - Previous (22) #k
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Die Email-Adresse \'[_1]\' ist bereits in der Benachrichtigunsliste für dieses Weblog.',
    'Please verify your email to subscribe' => 'Bitte bestätigen Sie Ihre Email-Adresse', # Translate - New (6) #k
    'The address [_1] was not subscribed.' => 'Die Adresse [_1] wurde hinzugefügt.', # Translate - New (6) #k
    'The address [_1] has been unsubscribed.' => 'Die Adresse [_1] wurde entfernt.', # Translate - New (6) #k

    ## ./lib/MT/App/Comments.pm
    'No id' => 'Keine ID', # Translate - New (2) #k
    'No such comment' => 'Kein entsprechender Kommentar', # Translate - New (3) #k
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.', # Translate - New (12) #k
    'IP Banned Due to Excessive Comments' => 'IP gesperrt - zu viele Kommentare',
    'No such entry \'[_1]\'.' => 'Kein Eintrag \'[_1]\'.',
    'You are not allowed to post comments.' => 'Kommentare sind nicht erlaubt.',
    'Comments are not allowed on this entry.' => 'Bei diesem Eintrag sind Kommentare nicht erlaubt.',
    'Comment text is required.' => 'Kommentartext ist Pflichtfeld.',
    'Registration is required.' => 'Registrierung ist erforderlich.',
    'Name and email address are required.' => 'Name und Email sind Pflichtfelder.',
    'Invalid email address \'[_1]\'' => 'Ungültige Email-Adresse \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'Ungültige URL \'[_1]\'',
    'Comment save failed with [_1]' => 'Speichern des Kommentars fehlgeschlagen: [_1]', # Translate - New (5) #k
    'New comment for entry #[_1] \'[_2]\'.' => 'Neuer Kommentar für Eintrag #[_1] \'[_2]\'.', # Translate - New (6) #k
    'Commenter save failed with [_1]' => 'Speichern des Kommentators fehlgeschlagen: [_1]', # Translate - New (5) #k
    'Rebuild failed: [_1]' => 'Rebuild fehlgeschlagen: [_1]',
    'New Comment Posted to \'[_1]\'' => 'Neuer Kommentar bei \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'Anmeldung konnte aufgrund eines Datenbankfehlers nicht durchgeführt werden ([_1])', # Translate - New (12) #k
    'Couldn\'t get public key from url provided' => 'Public Key konnte von der angegebenen Adresse nicht gelesen werden', # Translate - New (8) #k
    'No public key could be found to validate registration.' => 'Kein Public Key zur Validierung gefunden.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey-Signaturbestätigung gab [_1] zurück (nach [_2] Sekunden) und bestätigte [_3] mit [_4]', # Translate - New (13) #k
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'Die TypeKey-Signatur ist veraltet ([_1] seconds old). Stellen Sie sicher, daß die Uhr Ihres Servers richtig geht.', # Translate - New (18) #k
    'The sign-in validation failed.' => 'Anmeldung fehlgeschlagen.', # Translate - New (4) #k
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Kommentatoren müssen eine Email-Adresse angeben. Wenn Sie das tun möchten, melden Sie sich an und erlauben Sie dem Authentifizierungsdienst, Ihre Email-Adresse weiterzuleiten.', # Translate - New (32) #k
    'Couldn\'t save the session' => 'Session konnte nicht gespeichert werden', # Translate - New (5) #k
    'This weblog requires commenters to pass an email address' => 'Kommentatoren müssen eine Email-Adresse angeben', # Translate - New (9) #k
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'Anmelden erfordert eine sichere Signatur, Abmelden erfordert logout=1 als Paramater', # Translate - Previous (12) #k
    'The sign-in attempt was not successful; please try again.' => 'Sign-in war nicht erfolgreich; bitte erneut versuchen.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'Validierung des Sign-ins war nicht erfolgreich. Bitte Konfiguration überprüfen und erneut versuchen.',
    'No such entry ID \'[_1]\'' => 'Keine Eintrags-ID \'[_1]\'',
    'You must define an Individual template in order to ' => 'Sie müssen ein individuales Template festlegen um', # Translate - Previous (9) #k
    'You must define a Comment Listing template in order to ' => 'Sie müssen ein Kommentarlisten-Template festlegen um', # Translate - Previous (10)
    'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag spezifiziert. Vielleicht gibt es ein Problem mit dem Template?',
    'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
    'You must define a Comment Pending template.' => 'Sie müssen ein Template definieren für Kommentarmoderation.',
    'You must define a Comment Error template.' => 'Sie müssen ein Template definieren für Kommentarfehler.',
    'You must define a Comment Preview template.' => 'Sie müssen ein Template definieren für Kommentarvorschau.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Eine Suche ist bereits aktiv. Bitte warten ',
    'Search failed. Invalid pattern given: [_1]' => 'Suche fehlgeschlagen - ungültiges Suchmuster angegeben: [_1]', # Translate - New (6) #k
    'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Kein alternatives Template für das Template \'[_1]\' angegeben', # Translate - New (9) #k
    'Building results failed: [_1]' => 'Ergebnisausgabe fehlgeschlagen: [_1]', # Translate - Previous (4) #k
    'Search: query for \'[_1]\'' => 'Suche nach \'[_1]\'', # Translate - Previous (4) #k
    'Search: new comment search' => 'Suche nach neuen Kommentaren', # Translate - New (4) #k

    ## ./lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'Sie müssen ein Ping-Template definieren, um Pings anzeigen zu können.',
    'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden', # Translate - Previous (6) #k
    'Need a TrackBack ID (tb_id).' => 'Benötige TrackBack ID (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'Sie dürfen keine TrackBack-Pings senden.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'Sie senden zu viele TrackBacks zu schnell hintereinander.',
    'Need a Source URL (url).' => 'Quelladresse erforderlich (url).', # Translate - Previous (5) #k
    'This TrackBack item is disabled.' => 'TrackBack hier nicht aktiv.',
    'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Neuer TrackBack für Eintrag #[_1] \'[_2]\'.', # Translate - New (6) #k
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Neuer TrackBack für Kategorie [_1] \'[_2]\'.', # Translate - New (6) #k
    'Can\'t create RSS feed \'[_1]\': ' => 'RSS-Feed kann nicht angelegt werden \'[_1]\': ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Neuer TrackBack-Ping bei Eintrag [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Neuer TrackBack-Ping bei Kategorie [_1] ([_2])',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'Ursprünglicher Benutzername ist erforderlich.', # Translate - New (6) #k
    'You failed to validate your password.' => 'Passwort konnte nicht verifiziert werden.', # Translate - New (6) #k
    'You failed to supply a password.' => 'Kein Passwort angegeben.', # Translate - New (6) #k
    'The e-mail address is required.' => 'Email-Adresse ist erforderlich.', # Translate - New (5) #k
    'User [_1] upgraded database to version [_2]' => 'Benutzer [_1] hat Upgrade der Datenbank auf Version [_2] durchgeführt', # Translate - New (7) #k
    'Invalid session.' => 'Ungültige Session.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Bitte kontaktieren Sie Ihren Administrator, um das Upgrade von Movable Type durchzuführen. Sie haben nicht die erforderlichen Rechte.',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'Diese Funktion ist experimentell. Deaktivieren Sie in mt.cfg den SafeMode, um sie benutzen zu können.', # Translate - New (16) #k
    'Not allowed to view blog [_1]' => 'Keine Rechte zum Anzeigen von Blog [_1]', # Translate - New (6) #k
    'Loading blog with ID [_1] failed' => 'Einlesen des Blogs mit der ID [_1] fehlgeschlagen', # Translate - New (6) #k
    'Can\'t load \'[_1]\' template.' => 'Kann Vorlage \'[_1]\' nicht laden.', # Translate - New (5) #k
    'Building template failed: [_1]' => 'Anlegen der Vorlage fehlgeschlagen: [_1]', # Translate - New (4) #k
    'Invalid date spec' => 'Ungültiges Datumsformat', # Translate - New (3) #k
    'Can\'t load template [_1]' => 'Kann Vorlage [_1] nicht lesen', # Translate - New (5) #k
    'Building archive failed: [_1]' => 'Anlegen des Archivs fehlgeschlagen: [_1]', # Translate - New (4) #k
    'Invalid entry ID [_1]' => 'Ungültige Eintrags-ID [_1]', # Translate - New (4) #k
    'Entry [_1] is not published' => 'Eintrag [_1] nicht veröffentlicht', # Translate - New (5) #k
    'Invalid category ID \'[_1]\'' => 'Ungültige Kategorie-ID \'[_1]\'', # Translate - New (4) #k

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'Keine Berechtigung',
    'Invalid blog' => 'Ungültiges Blog', # Translate - New (2) #k
    'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
    'No birthplace, cannot recover password' => 'Geburtsort nicht genannt; Passwort kann nicht versendet werden', # Translate - New (5) #k
    'Invalid author_id' => 'Ungültige Autoren-ID', # Translate - New (3) #k
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Benutzername \'[_1]\' ungültig', # Translate - Previous (8) #k
    'Author name or birthplace is incorrect.' => 'Der Benutzername oder der Geburtsort ist nicht korrekt.',
    'Author has not set birthplace; cannot recover password' => 'Geburtsort nicht angegeben; Passwort kann nicht versendet werden',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Ungültiger Versuch, das Passwort anzufordern (Geburtsort \'[_1]\')',
    'Author does not have email address' => 'Autor hat keine Email-Adressse',
    'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Passwort des Benutzers \'[_1]\' (Benutzer #[_2]) wurde zurückgesetzt und an folgende Adresse verschickt: [_3]', # Translate - New (16) #k
    'Error sending mail ([_1]); please fix the problem, then ' => 'Mailversand fehlgeschlagen([_1]); bitte beheben Sie das Problem, dann', # Translate - Previous (9) #k
    'Invalid type' => 'Ungültiger Typ', # Translate - New (2) #k
    'tags' => 'Tags', # Translate - New (1) #k
    'No such tag' => 'Kein solcher Tag', # Translate - New (3) #k
    'You are not authorized to log in to this blog.' => 'Kein Zugang zu diesem Weblog.',
    'No such blog [_1]' => 'Kein Weblog [_1]',
    'Weblog Activity Feed' => 'Weblog-Aktivitätsprotokoll', # Translate - New (3) #k
    '(author deleted)' => '(Autor gelöscht)', # Translate - New (3) #k
    'Permission denied.' => 'Keine Berechtigung.',
    'All Feedback' => 'Jedes Feedback', # Translate - New (2) #k
    'log records' => 'Log-Einträge', # Translate - Previous (2) #k
    'System Activity Feed' => 'System-Aktivitätsfeed', # Translate - New (3) #k
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Protokoll von Weblog \'[_1]\' zurückgesetzt von \'[_2]\' (Benutzer #[_3])',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Protokoll zurückgesetzt von \'[_1]\' (Benutzer #[_2])',
    'Import/Export' => 'Import/Export', # Translate - Previous (2) #k
    'Invalid blog id [_1].' => 'Ungültige Blog-ID [_1].', # Translate - New (4) #k
    'Load failed: [_1]' => 'Laden fehlgeschlagen: [_1]',
    '(no reason given)' => '(unbekannte Ursache)', # Translate - New (4) #k
    '(untitled)' => '(ohne Überschrift)',
    'Create template requires type' => 'Typangabe zum Anlegen von Templates erforderlich', # Translate - Previous (4) #k
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
    'The name \'[_1]\' is too long!' => 'Der Name \'[_1]\' ist zu lang!',
    'No categories with the same name can have the same parent' => 'Kategorien mit dem selben Namen können nicht parallel bestehen',
    'Saving permissions failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
    'Can\'t find default template list; where is ' => 'Kann Standardtemplates nicht finden, wo ist', # Translate - Previous (8) #k	
    'Populating blog with default templates failed: [_1]' => 'Standard-Templates konnten nicht geladen werden: [_1]',
    'Setting up mappings failed: [_1]' => 'Mappings anlegen fehlgeschlagen: [_1]', # Translate - Previous (5) #k
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' angeleget von \'[_2]\' (Benutzer #[_3])',
    'You cannot delete your own author record.' => 'Sie können nicht Ihr eigenes Benutzerkonto löschen.', # Translate - New (7) #k
    'You have no permission to delete the author [_1].' => 'Keine Rechte zum Löschen von Autor [_1].', # Translate - New (9) #k
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' gelöscht von \'[_2]\' (Benutzer #[_3])',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Benachrichtigung \'[_1]\' (#[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (8) #k
    'Author \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Benutzer \'[_1]\' (#[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (8) #k
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Kategorie \'[_1]\' (Kategorie #[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (9) #k
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Kommentar \'[_1]\' (#[_2]) von \'[_3]\' (Benutzer #[_4]) aus Eintrag \'[_5]\' (Eintrag #[_6]) gelöscht', # Translate - New (13) #k
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Eintrag \'[_1]\' (Eintrag #[_2]) von\'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (9) #k
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (Ping #[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (9) #k
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Template \'[_1]\' (#[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (8) #k
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Tags \'[_1]\' (Tags #[_2]) von \'[_3]\' (Benutzer #[_4]) gelöscht', # Translate - New (9) #k
    'Passwords do not match.' => 'Passwörter stimmen nicht überein.',
    'Failed to verify current password.' => 'Kann Passwort nicht überprüfen.',
    'Password hint is required.' => 'Passwort-Erinnerung ist erforderlich.',
    'An author by that name already exists.' => 'Ein Autor mit diesem Benutzernamen besteht bereits.',
    'Save failed: [_1]' => 'Speichern fehlgeschlagen: [_1]', # Translate - New (3) #k
    'Saving object failed: [_1]' => 'Speichern des Objekts fehlgeschlagen: [_1]',
    'No Name' => 'Kein Name',
    'Notification List' => 'Mitteilungssliste',
    'email addresses' => 'Email-Adressen',
    'Can\'t delete that way' => 'Kann so nicht gelöscht werden', # Translate - Previous (5) #k
    'Your login session has expired.' => 'Ihre Login-Session ist abgelaufen.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Solange die Kategorie Unterkategorien hat, können Sie die Kategorie nicht löschen.',
    'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]', # Translate - Previous (4) #k
    'Loading object driver [_1] failed: [_2]' => 'Laden des Objekttreibers [_1] fehlgeschlagen: [_2]', # Translate - Previous (6) #k
    'Reading \'[_1]\' failed: [_2]' => 'Einlesen von \'[_1]\' fehlgeschlagen: [_2]', # Translate - Previous (4) #k
    'Thumbnail failed: [_1]' => 'Thumbnail fehlgeschlagen: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Fehler beim Schreiben auf \'[_1]\': [_2]', # Translate - Previous (5) #k
    'Invalid basename \'[_1]\'' => 'Ungültiger Basename \'[_1]\'',
    'No such commenter [_1].' => 'Kein Kommentator [_1].',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'Benutzer \'[_1]\' (#[_2]) hat Kommentator \'[_3]\' (#[_4]) das Vertrauen ausgesprochen.', # Translate - New (7) #k
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'Benutzer \'[_1]\' (#[_2]) hat Kommentator \'[_3]\' (#[_4]) gesperrt.', # Translate - New (7) #k
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'Benutzer \'[_1]\' (#[_2]) hat Kommentator \'[_3]\' (#[_4]) entsperrt.', # Translate - New (7) #k
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'Benutzer \'[_1]\' (#[_2]) hat Kommentator \'[_3]\' (#[_4]) das Vertrauen entzogen.', # Translate - New (7) #k
    'Need a status to update entries' => 'Statusangabe erforderlich', # Translate - Previous (6) #k
    'Need entries to update status' => 'Einträge erforderlich', # Translate - Previous (5) #k
    'One of the entries ([_1]) did not actually exist' => 'Einer der Einträge ([_1]) ist nicht vorhanden', # Translate - Previous (9) #k
    'Some entries failed to save' => 'Speichern der Einträge teilweise fehlgeschlagen', # Translate - Previous (5) #k
    'You don\'t have permission to approve this TrackBack.' => 'Sie dürfen dieses TrackBack nicht freischalten.',
    'Comment on missing entry!' => 'Kommentar gehört zu fehlendem Eintrag!', # Translate - New (4) #k
    'You don\'t have permission to approve this comment.' => 'Sie dürfen diesen Kommentar nicht freischalten.',
    'Comment Activity Feed' => 'Kommentar-Aktivitätsfeeds', # Translate - New (3) #k
    'Orphaned comment' => 'Verwaister Kommentar',
    'Plugin Set: [_1]' => 'Plugin-Set: [_1]', # Translate - Previous (3) #k
    'TrackBack Activity Feed' => 'TrackBack-Aktivitätsfeed', # Translate - New (3) #k
    'No Excerpt' => 'Kein Auzzug',
    'No Title' => 'Keine Überschrift',
    'Orphaned TrackBack' => 'Verwaistes TrackBack',
    'Tag' => 'Tag', # Translate - New (1) #k
    'Entry Activity Feed' => 'Eintrags-Aktivitätsfeed', # Translate - New (3) #k
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum \'[_1]\' ungültig; erforderliches Formst ist JJJJ-MM-TT SS:MM:SS.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ungültiges Datum \'[_1]\'; das Datum muss existieren.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Speichern des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
    'Removing placement failed: [_1]' => 'Entfernen der Platzierung fehlgeschlagen: [_1]', # Translate - Previous (4) #k
    'No such entry.' => 'Kein Eintrag.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Sie haben noch keinen Site-Path und Site-URL konfiguriert. Sie können Einträge erst veröffentlichen, wenn Sie diese Einstellungen vorgenommen haben.',
    'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]', # Translate - New (3) #k
    'The category must be given a name!' => 'Die Kategorie muss einen Namen haben!',
    'yyyy/mm/entry_basename' => 'jjjj/mm/eintrag_basename',
    'yyyy/mm/entry-basename' => 'yyyy/mm/eintrag_basename', # Translate - New (3) #k
    'yyyy/mm/entry_basename/' => 'jjjj/mm/eintrag_basename/',
    'yyyy/mm/entry-basename/' => 'yyyy/mm/eintrag_basename/', # Translate - New (3) #k
    'yyyy/mm/dd/entry_basename' => 'jjjj/mm/tt/eintrag_basename',
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/eintrag_basename', # Translate - New (4) #k
    'yyyy/mm/dd/entry_basename/' => 'jjjj/mm/tt/eintrag_basename/',
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/eintrag_basename/', # Translate - New (4) #k
    'category/sub_category/entry_basename' => 'kategorie/unterkategorie/eintrag_basename',
    'category/sub_category/entry_basename/' => 'kategorie/unterkategorie/eintrag_basename/',
    'category/sub-category/entry_basename' => 'kategorie/unterkategorie/eintrag_basename',
    'category/sub-category/entry-basename' => 'category/sub-category/eintrag_basename', # Translate - New (3) #k
    'category/sub-category/entry_basename/' => 'kategorie/unterkategorie/eintrag_basename/',
    'category/sub-category/entry-basename/' => 'category/sub-category/eintrag_basename/', # Translate - New (3) #k
    'primary_category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary_category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'primary-category/entry_basename' => 'hauptkategorie/eintrag_basename',
    'primary-category/entry-basename' => 'primary-category/eintrag_basename', # Translate - New (2) #k
    'primary-category/entry_basename/' => 'hauptkategorie/eintrag_basename/',
    'primary-category/entry-basename/' => 'primary-category/eintrag_basename/', # Translate - New (2) #k
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
    'Saving map failed: [_1]' => 'Speichern der Map fehlgeschlagen: [_1]', # Translate - Previous (4) #k
    'Parse error: [_1]' => 'Parsing-Fehler: [_1]', # Translate - Previous (3) #k
    'Build error: [_1]' => 'Build-Fehler: [_1]', # Translate - Previous (3) #k
    'Rebuild-option name must not contain special characters' => 'Name der Rebuild-Option darf keine Sonderzeichen enthalten', # Translate - New (7)
    'index template \'[_1]\'' => 'Indextemplate \'[_1]\'', # Translate - New (3) #k
    'entry \'[_1]\'' => 'Eintrag \'[_1]\'', # Translate - New (2) #k
    'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' fehlgeschlagen: [_2]',
    'You cannot modify your own permissions.' => 'Sie können nicht Ihre eigenen Rechte verändern.', # Translate - New (6) #k
    'You are not allowed to edit the permissions of this author.' => 'Keine Berechtigung zur Änderung der Rechte dieses Benutzers.', # Translate - New (11) #k
    'Edit Permissions' => 'Rechte bearbeiten',
    'Edit Profile' => 'Profil bearbeiten', # Translate - New (2) #k
    'No entry ID provided' => 'Keine Eintrags-ID angegeben',
    'No such entry \'[_1]\'' => 'Kein Eintrag \'[_1]\'',
    'No email address for author \'[_1]\'' => 'Keine Email-Addresse für Autor \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'Keine gültigen Empfänger für Benachrichtigungen gefunden.', # Translate - New (8) #k
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen([_1]). Überprüfen Sie die MailTransfer-Einstellungen.', # Translate - Previous (8) #k	
    'You did not choose a file to upload.' => 'Bitte wählen Sie eine Datei aus.',
    'Invalid extra path \'[_1]\'' => 'Ungültiger Zusatzpfad \'[_1]\'', # Translate - Previous (4) #k
    'Can\'t make path \'[_1]\': [_2]' => 'Kann Pfad \'[_1]\' nicht anlegen: [_2]', # Translate - Previous (6) #k
    'Invalid temp file name \'[_1]\'' => 'Ungültiger temporärer Dateiname \'[_1]\'', # Translate - Previous (5) #k
    'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Datei mit dem Namen \'[_1]\' bereits vorhanden. (Installiern SIe ',
    'Error creating temporary file; please check your TempDir ' => 'Anlegen der temporären Datei fehlgeschlagen. Bitte überprüfen Sie Ihr TempDir ', # Translate - Previous (8) #k
    'unassigned' => 'nicht vergeben',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Dateiname \'[_1]\' bereits vorhanden; versucht zu schreiben', # Translate - Previous (9) #k
    'Error writing upload to \'[_1]\': [_2]' => 'Upload in \'[_1]\' speichern fehlgeschlagen: [_2]', # Translate - Previous (6) #k
    'Perl module Image::Size is required to determine ' => 'Perl-Module Image::Size erforderlich zur Bestimmung', # Translate - Previous (8) #k
    'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe', # Translate - New (7) #k
    'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]', # Translate - New (5) #k
    'Saving object failed: [_2]' => 'Speichern des Objekts fehlgeschlagen: [_2]', # Translate - Previous (4) #k
    'Search & Replace' => 'Suchen & Ersetzen',
    'No blog ID' => 'Keine Weblog-ID',
    'You do not have export permissions' => 'Du hast keine Export-Rechte',
    'You do not have import permissions' => 'Du hast keine Import-Rechte',
    'You do not have permission to create authors' => 'Sie haben nicht das Recht, neue Autoren anzulegen',
    'Preferences' => 'Einstellungen',
    'Add a Category' => 'Kategorie hinzufügen',
    'No label' => 'Kein Label', # Translate - New (2) #k
    'Category name cannot be blank.' => 'Der Name einer Kategorie darf nicht leer sein.',
    'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) nicht implementiert', # Translate - Previous (7) #k
    'Permission denied' => 'Zugriff verweigert', # Translate - New (2) #k

    ## ./lib/MT/App/ActivityFeeds.pm
    'TrackBacks for [_1]' => 'TrackBacks für [_1]', # Translate - New (3) #k
    'All TrackBacks' => 'Alle TrackBacks', # Translate - New (2) #k
    '[_1] Weblog TrackBacks' => 'TrackBacks für Weblog [_1]', # Translate - New (4) #k
    'All Weblog TrackBacks' => 'Alle TrackBacks', # Translate - New (3) #k
    'Comments for [_1]' => 'Kommentare zu [_1]', # Translate - New (3) #k
    'All Comments' => 'Alle Kommentare ', # Translate - New (2) #k
    '[_1] Weblog Comments' => 'Kommentare zu Weblog [_1]', # Translate - New (4) #k
    'All Weblog Comments' => 'Alle Kommentare', # Translate - New (3) #k
    'Entries for [_1]' => 'Einträge für [_1]', # Translate - New (3) #k
    'All Entries' => 'Alle Einträge', # Translate - New (2) #k
    '[_1] Weblog Entries' => 'Einträge des Blogs [_1]', # Translate - New (4) #k
    'All Weblog Entries' => 'Alle Einträge', # Translate - New (3) #k
    '[_1] Weblog' => 'Weblog [_1] ', # Translate - New (3) #k
    'All Weblogs' => 'Alle Weblogs', # Translate - New (2) #k
    '[_1] Weblog Activity' => 'Weblogaktivität von [_1]', # Translate - New (4) #k
    'All Weblog Activity' => 'Weblogaktivität gesamt', # Translate - New (3) #k

    ## ./lib/MT/Module/Build.pm

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Das ist ein lokalisiertes Perl-Modul', # Translate - New (6) #k

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Konnte IP-Adresse der Ursprungsadresse [_1] nicht auflösen', # Translate - New (9) #k
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation: Domain-IP stimmt nicht mit Ping-IP der Quell-URL [_1] überein - Domain-IP: [_2], Ping-IP: [_3]', # Translate - New (18) #k
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domain-IP stimmt nicht mit Ping-IP der Quell-URL [_1] überein - Domain: IP [_2], Ping-IP: [_3]', # Translate - New (17) #k
    'No links are present in feedback' => 'Feedback enthält keine Links', # Translate - New (6) #k
    'Number of links exceed junk limit ([_1])' => 'Anzahl der Links übersteigt Junk-Grenze ([_1])', # Translate - New (7) #k
    'Number of links exceed moderation limit ([_1])' => 'Anzahl der Links übersteigt Moderations-Grenze ([_1])', # Translate - New (7) #k
    'Link was previously published (comment id [_1]).' => 'Link wurde bereits zuvor veröffentlicht (Kommentar-ID [_1]).', # Translate - New (7) #k
    'Link was previously published (TrackBack id [_1]).' => 'Link wurde bereits zuvor veröffentlicht (TrackBack-ID [_1]).', # Translate - New (7) #k
    'E-mail was previously published (comment id [_1]).' => 'Email-Adresse wurde bereits zuvor veröffentlicht (Kommentar-ID [_1]).', # Translate - New (7) #k
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Wortfilter-Treffer in \'[_1]\': \'[_2]\'.', # Translate - New (6) 
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderation: Wortfilter-Treffer für \'[_1]\': \'[_2]\'.', # Translate - New (8) #k
    'domain \'[_1]\' found on service [_2]' => 'Domain \'[_1]\' gefunden bei [_2]', # Translate - New (6) #k
    '[_1] found on service [_2]' => '[_1] gefunden bei [_2]', # Translate - New (6) #k

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Bei der Verarbeitung von [_1] ist ein Fehler aufgetreten. ', # Translate - New  (5) #k

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/statwatch/lib/StatWatchConfig.pm

    ## ./plugins/statwatch/lib/Stats.pm

    ## ./plugins/statwatch/lib/StatWatch.pm

    ## ./plugins/statwatch/lib/StatWatch/Visit.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'Please configure the settings for this plugin before using it.' => 'Sie müssen dieses Plugin zuerst konfigurieren', # Translate - New (10) #k
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.', # Translate - New (12) #k
    'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.', # Translate - New (5) #k

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/App.pm
    'Moving $mid to list of installed modules' => '$mid auf Liste der installierten Module verschoben', # Translate - New (7) #k
    'WidgetManager' => 'WidgetManager', # Translate - New (1) #k
    'First Widget Manager' => 'Erster Widget Manager', # Translate - New (3) #k

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

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
);


1;

## New words: 3523
