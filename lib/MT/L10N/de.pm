# Copyright 2003-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package MT::L10N::de;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type Systemüberprüfung',
	'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Auf dieser Seite finden Sie Informationen zu Ihrer Systemkonfiguration, damit festgestellt werden kann, ob Ihr Webserver über alle notwendigen Komponenten zur Ausführung von Movable Type verfügt.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). While Movable Type may run, it is an <strong>untested and unsupported</strong> environment.  We <strong>strongly recommend</strong> upgrading to at least Perl [_2].' => 'Auf Ihrem Server ist eine ältere Perl-Version installiert ([_1]) als minimal erforderlich ([_2]). Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>. Wir empfehlen daher <strong>dringend</strong>, Perl mindestens auf Version [_2] zu aktualisieren.', # Translate - New # OK
	'System Information' => 'Systeminformation',
	'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
	'MT home directory:' => 'MT-Wurzelverzeichnis:',
	'Operating system:' => 'Betriebssystem:',
	'Perl version:' => 'Perl-Version:',
	'Perl include path:' => 'Perl-Include-Pfad:',
	'Web server:' => 'Webserver:',
	'[_1] [_2] Modules:' => '[_1] [_2] Module:',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Die folgenden Pakete sind <strong>optional</strong> und müssen nur installiert werden, wenn sie die Funktionen, die das jeweilige Paket bietet, nutzen möchten.',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Zum Ausführen von Movable Type benötigt Ihr Server bestimmte Datenbankmodule. Abhängig vom verwendeten Datenbanksystem ist DBI sowie mindestens eine weiteres spezifisches Modul erforderlich.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => '[_1] ist auf Ihrem Webserver nicht installiert oder die installierte Version ist zu alt oder [_1] benötigt ein weiteres Modul, das nicht installiert ist.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] ist entweder nicht auf Ihrem Webserver installiert oder [_1] benötigt ein weiteres Modul, das nicht installiert ist.',
	'Please consult the installation instructions for help in installing [_1].' => 'Hinweise zur Installation von [_1] finden Sie in der Dokumentation.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Ihre DBD::mysql Version ist mit Movable Type nicht kompatibel. Bitte installieren Sie die aktuelle Version aus CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod ist korrekt installiert, erfordert aber ein aktuelleres DBI-Modul. Bitte beachten Sie oben stehende Versionshinweise.',
	'Your server has [_1] installed (version [_2]).' => '[_1] ist auf Ihrem Server installiert (Version [_2]).',
	'Movable Type System Check Successful' => 'Movable Type Systemüberprüfung erfolgreich',
	'You\'re ready to go!' => 'Ihr System ist jetzt bereit.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Pakete sind auf Ihrem Server installiert. Sie brauchen keine weiteren Module zu installieren und können mit der Installation fortfahren.',
	'CGI is required for all Movable Type application functionality.' => 'CGI ist für Movable Type zwingend erforderlich.',
	'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template ist für alle Anwendungsfunktionen von Movable Type erforderlich.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size ist für Datei-Uploads erforderlich (um die Größe der hochgeladenen Bilder in verschiedenen Formaten zu bestimmen).',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec ist für Dateipfadänderungen unter allen Betriebssystemen erforderlich.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie ist für die Cookie-Authentifizierung erforderlich.',
	'DBI is required to store data in database.' => 'DBI ist zur Nutzung von Datenbanken erforderlich.', # Translate - New # OK
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI und DBD::mysql sind erforderlich, wenn Sie eine MySQL-Datenbank einsetzen möchten.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind erforderlich, wenn Sie eine PostgreSQL-Datenbank einsetzen möchten.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI and DBD::SQLite sind erforderlich, wenn Sie eine SQLite-Datenbank einsetzen wollen.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI and DBD::SQLite2 sind erforderlich, wenn Sie eine SQLite 2.x-Datenbank einsetzen wollen.',
	'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI und DBD::Oracle sind erforderlich, wenn Sie eine Oracle-Datenbank einsetzen möchten.',
	'DBI and DBD::ODBC are required if you want to use the Microsoft SQL Server database backend.' => 'DBI and DBD::ODBC sind erforderlich, wenn Sie eine Microsoft SQL Server-Datenbank einsetzen möchten..',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entitites ist für Sonderzeichenkodierung erforderlich. Diese Funktion kann mit der NoHTMLEntities-Option in der Konfigurationsdatei abgeschaltet werden.', # Translate - New # OK
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent ist optional und nur erforderlich, wenn Sie das TrackBack-System, den weblogs.com-Ping oder den "Kürzlich aktualisiert"-Ping von MT einsetzen möchten.',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite ist optional und nur erforderlich, wenn Sie die XML-RPC Server-Implementierung von MT einsetzen möchten',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp ist optional und nur erforderlich, wenn Sie vorhandene Dateien beim Hochladen überschreiben können möchten.',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick ist optional und nur erforderlich, wenn Sie automatisch Miniaturansichten von hochgeladenen Bildern erzeugen möchten.',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable ist optional und nur für einige MT-Plugins von Drittanbietern erforderlich.',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA ist optional. Durch die Installation wird der Anmeldevorgang für die Kommentarregistrierung beschleunigt.',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 ist für die Aktivierung der Kommentarregistrierung erforderlich.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist für den Einsatz der Atom-API erforderlich.',
	'Net::LDAP is required in order to use the LDAP Authentication.' => 'Net::LDAP ist für den Einsatz der LDAP-Authentifizierung erforderlich.',
	'IO::Socket::SSL is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Um zur LDAP-Authentifizierung SSL/TLS-Verbindungen nutzen zu können, ist IO:Socket:SSL erforderlich',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached und memcached-Server/Daemon sind erforderlich, um den memcached-Caching-Mechanismus nutzen zu können.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar ist erforderlich, um Dateien bei Backup/Restore-Vorgängen archivieren zu können.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip ist erforderlich, um Dateien bei Backup/Restore-Vorgängen packen zu können.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip ist erforderlich, um Dateien bei Backup/Restore-Vorgängen entpacken zu können.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip ist erforderlich, um Dateien bei Backup/Restore-Vorgängen archivieren zu können.',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX und/oder Abhängigkeiten davon sind zur Wiederherstellung erforderlich.',
	'Checking for' => 'Überprüfe',
	'Installed' => 'Installiert',
	'Data Storage' => 'Datenbank-',
	'Required' => 'erforderlichen ',
	'Optional' => 'optionalen ',

## default_templates/entry_metadata.mtml
	'Posted by [_1] on [_2]' => 'Geschrieben von [_1] am [_2]',
	'Posted on [_1]' => 'Geschrieben am [_1]',
	'Permalink' => 'Permalink',
	'Comments ([_1])' => 'Kommentare ([_1])',
	'TrackBacks ([_1])' => 'TrackBacks ([_1])',

## default_templates/comment_preview.mtml
	'Comment on [_1]' => 'Kommentar zu [_1]', # Translate - New # OK
	'Header' => 'Kopf', # Translate - New # OK
	'Previewing your Comment' => 'Vorschau Ihres Kommentars',
	'Comment Detail' => 'Kommentardetail',
	'Comments' => 'Kommentare',

## default_templates/header.mtml
	'[_1]: Search Results' => '[_1]: Suchergebnisse', # Translate - New # OK
	'[_1] - [_2]' => '[_1] - [_2]', # Translate - New # OK
	'[_1]: [_2]' => '[_1]: [_2]', # Translate - New # OK

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Seite nicht gefunden',

## default_templates/entry.mtml
	'Entry Detail' => 'Eintragsdetails', # Translate - New # OK
	'TrackBacks' => 'TrackBacks',

## default_templates/search_results.mtml
	'Search Results' => 'Suchergebnisse',
	'Search this site' => 'Diese Site durchsuchen',
	'Search' => 'Suchen',
	'Match case' => 'Groß-/Kleinschreibung',
	'Regex search' => 'Regex-Suche',
	'Matching entries matching &ldquo;[_1]&rdquo; from [_2]' => 'Einträge mit &ldquo;[_1]&rdquo; von [_2]', # Translate - New # OK
	'Entries tagged with &ldquo;[_1]&rdquo; from [_2]' => 'Mit &ldquo;[_1]&rdquo; getaggte Einträge von [_2]', # Translate - New # OK
	'Entry Summary' => 'Eintrags-Zusammenfassung', # Translate - New # OK
	'Entries matching &ldquo;[_1]&rdquo;' => 'Einträge mit &ldquo;[_1]&rdquo', # Translate - New # OK
	'Entries tagged with &ldquo;[_1]&rdquo;' => 'Mit &ldquo;[_1]&rdquo getaggte Einträge', # Translate - New # OK
	'No pages were found containing &ldquo;[_1]&rdquo;.' => 'Keine Seiten mit &ldquo;[_1]&rdquo gefunden', # Translate - New # OK
	'Instructions' => 'Anleitung',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Die Suchfunktion sucht standardmäßig nach allen angebenen Begriffen in beliebiger Reihenfolge. Um nach einem exakten Ausdruck zu suchen, setzen Sie diesen bitte in Anführungszeichen:',
	'movable type' => 'Movable Type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt:', # Translate - New # OK
	'personal OR publishing' => 'Schrank OR Schublade',
	'publishing NOT personal' => 'Regal NOT Schrank',

## default_templates/archive_index.mtml
	'Archives' => 'Archive',
	'Monthly Archives' => 'Monatsarchive', # Translate - New # OK
	'Categories' => 'Kategorien',
	'Author Archives' => 'Autorenarchive', # Translate - New # OK
	'Category Monthly Archives' => 'Monatliche Kategoriearchive', # Translate - New # OK
	'Author Monthly Archives' => 'Monatliche Autorenarchive', # Translate - New # OK

## default_templates/sidebar.mtml
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged &ldquo;<$MTSearchString$>&ldquo;.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &ldquo;<$MTSearchString$>&ldquo; getaggten Einträge abonnieren.', # Translate - New # OK
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching &ldquo;<$MTSearchString$>&ldquo;.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit &ldquo;<$MTSearchString$>&ldquo;  abonnieren.', # Translate - New # OK
	'Feed Subscription' => 'Feed abonnieren',
	'(<a href="[_1]">What is this?</a>)' => '(<a href="[_1]">Was ist das?</a>)', # Translate - New # OK
	'Subscribe to feed' => 'Feed abonnieren',
	'Tags' => 'Tags',
	'Other tags used on this blog:' => 'Weitere Tags in diesem Blog:', # Translate - New # OK
	'[_1] ([_2])' => '[_1] ([_2])', # Translate - New # OK
	'Search this blog:' => 'Dieses Weblog durchsuchen:',
	'About This Post' => 'Über diesen Eintrag', # Translate - New # OK
	'About This Archive' => 'Über dieses Archiv', # Translate - New # OK
	'About Archives' => 'Über die Archive', # Translate - New # OK
	'This page contains links to all the archived content.' => 'Diese Seite enthält Links zu allen archivierten Einträgen.', # Translate - New # OK
	'This page contains a single entry by [_1] posted on <em>[_2]</em>.' => 'Diese Seite enthält einen einzelnen Weblogeintrag vom [_1] über <em>[_2]</em>.', # Translate - New # OK
	'<a href="[_1]">[_2]</a> was the previous post in this blog.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag in diesem Blog.', # Translate - New # OK
	'<a href="[_1]">[_2]</a> is the next post in this blog.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag in diesem Blog.', # Translate - New # OK
	'This page is a archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Diese Seite enthält alle Einträge der Kategorie <strong>[_1]</strong> aus <strong>[_2]</strong>.', # Translate - New # OK
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> ist das vorherige Archiv.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> ist das nächste Archiv.',
	'This page is a archive of recent entries in the <strong>[_1]</strong> category.' => 'Diese Seite enthält aktuelle Einträge der Kategorie <strong>[_1]</strong>.', # Translate - New # OK
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> ist die vorherige Kategorie.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> ist die nächste Kategorie.',
	'This page is a archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</srong> über <strong>[_2]</strong>.', # Translate - New # OK
	'This page is a archive of recent entries written by <strong>[_1]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</strong> ', # Translate - New # OK
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Diese Seite enthält alle Einträge von <strong>[_1]</strong> von neu nach alt.', # Translate - New # OK
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>.', # Translate - New # OK
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>, alle Einträge in den <a href="[_2]">Archiven</a>.', # Translate - New # OK
	'[_1]: Monthly Archives' => '[_1]: Monatsarchive', # Translate - New # OK
	'Recent Posts' => 'Aktuelle Einträge',
	'[_1] <a href="[_2]">Archives</a>' => '[_1]-<a href="[_2]">Archive</a>', # Translate - New # OK
	'Subscribe to this blog\'s feed' => 'Feed dieses Weblogs abonnieren',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a href="[_1]">Creative Commons-Lizenz</a>.', # Translate - New # OK
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]', # Translate - New # OK

## default_templates/comment_form.mtml
	'Post a comment' => 'Kommentar schreiben',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Wenn Sie auf dieser Site bisher noch nicht kommentiert haben, wird Ihr Kommentar eventuell erst zeitverzögert freigeschaltet werden. Vielen Dank für Ihre Geduld.)',
	'Name' => 'Name',
	'Email Address' => 'E-Mail-Adresse',
	'URL' => 'URL',
	'Remember personal info?' => 'Persönliche Angaben speichern?',
	'(You may use HTML tags for style)' => '(HTML-Tags erlaubt)',
	'Preview' => 'Vorschau',
	'Post' => 'Absenden',
	'Cancel' => 'Abbrechen',

## default_templates/tags.mtml

## default_templates/main_index.mtml

## default_templates/comment_error.mtml
	'Comment Submission Error' => 'Kommentar-Fehler',
	'Your comment submission failed for the following reasons:' => 'Folgender Fehler ist beim Kommentieren aufgetreten:',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">Zurück zum Eintrag</a>.', # Translate - New # OK

## default_templates/entry_listing.mtml
	'[_1] Archives' => '[_1]-Archive', # Translate - New # OK
	'Recently in <em>[_1]</em> Category' => 'Neues in der Kategorie <em>[_1]</em>', # Translate - New # OK
	'Recently by <em>[_1]</em>' => 'Neues von <em>[_1]</em>', # Translate - New # OK

## default_templates/rss.mtml
	'Copyright [_1]' => 'Copyright [_1]', # Translate - New # OK

## default_templates/javascript.mtml
	'Thanks for signing in,' => 'Danke für Ihre Anmeldung, # Translate - Improved (4) # OK',
	'. Now you can comment.' => '. Sie können jetzt Ihren Kommentar verfassen.',
	'sign out' => 'abmelden',
	'You do not have permission to comment on this blog.' => 'Sie dürfen nicht kommentieren.', # Translate - New # OK
	'Sign in</a> to comment on this post.' => 'Anmelden</a> um diesen Eintrag zu kommentieren.', # Translate - New # OK
	'Sign in</a> to comment on this post,' => 'Anmelden</a> um diesen Eintrag zu kommentieren,', # Translate - New # OK
	'or ' => 'oder', # Translate - New # OK
	'comment anonymously' => 'anonym kommentieren', # Translate - New # OK

## default_templates/entry_detail.mtml
	'Entry Metadata' => 'Eintrags-Metadaten', # Translate - New # OK

## default_templates/categories.mtml

## default_templates/comment_pending.mtml
	'Comment Pending' => 'Kommentar noch nicht freigegeben',
	'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar',
	'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar wurde gespeichert und muß nun vom Weblog-Betreiber freigegeben werden.',

## default_templates/trackbacks.mtml
	'[_1] TrackBacks' => '[_1]-TrackBacks', # Translate - New # OK
	'Listed below are links to blogs that reference this post: <a href="[_1]">[_2]</a>.' => 'Folgende Einträge anderer Blogs beziehen sich auf diesen Eintrag: <a href="[_1]">[_2]</a>.', # Translate - New # OK
	'TrackBack URL for this entry: <span id="trackbacks-link">[_1]</span>' => 'TrackBack-URL dieses Eintrags: <span id="trackbacks-link">[_1]</span>', # Translate - New # OK
	'&raquo; <a rel="nofollow" href="[_1]">[_2]</a> from [_3]' => '&raquo; <a rel="nofollow" href="[_1]">[_2]</a> von [_3]', # Translate - New # OK
	'[_1] <a rel="nofollow" href="[_2]">Read More</a>' => '[_1] <a rel="nofollow" href="[_2]">Mehr</a>', # Translate - New # OK
	'Tracked on <a href="[_1]">[_2]</a>' => 'Gesehen auf <a href="[_1]">[_2]</a>', # Translate - New # OK

## default_templates/footer.mtml
	'Sidebar' => 'Seitenleiste', # Translate - New # OK

## default_templates/comment_detail.mtml
	'[_1] [_2] said:' => '[_1] [_2] schrieb:', # Translate - New # OK
	'<a href="[_1]" title="Permanenter Link zu diesem Kommentar">[_2]</a>' => '<a href="[_1]" title="Permalink to this comment">[_2]</a>', # Translate - New # OK

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]">[_2]</a>.' => 'Weiterlesen aus  <a href="[_1]">[_2]</a>.', # Translate - New # OK

## default_templates/page.mtml

## default_templates/comments.mtml
	'Comment Form' => 'Kommentarformular', # Translate - New # OK
	'[_1] Comments' => '[_1] Kommentare', # Translate - New # OK

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Laden des Templates \'[_1]\' fehlgeschlagen: [_2]',
	'Rebuild' => 'Neu aufbauen',
	'Uppercase text' => 'In Großschreibung', # Translate - New # OK
	'Lowercase text' => 'In Kleinschreibung', # Translate - New # OK
	'My Text Format' => 'Mein Textformat', # Translate - New # OK

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
	'No web services password assigned.  Please see your user profile to set it.' => 'Kein Web Services-Passwort vorhanden. Bitte legen Sie auf Ihrer Profilseite eines fest.',
	'Failed login attempt by disabled user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von deaktiviertem Benutzer \'[_1]\'',
	'No blog_id' => 'blog_id fehlt',
	'Invalid blog ID \'[_1]\'' => 'Ungültige blog_id \'[_1]\'',
	'Invalid login' => 'Login ungültig',
	'No publishing privileges' => 'Keine Veröffentlichungsrechte',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '\'mt_[_1]\' kann nur 0 oder 1 sein (war \'[_2]\')',
	'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
	'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Benutzer \'[_1]\' (#[_2]) hat Eintrag #[_3] hinzugefügt',
	'No entry_id' => 'entry_id fehlt',
	'Invalid entry ID \'[_1]\'' => 'Ungültige Eintrags-ID \'[_1]\'',
	'Not privileged to edit entry' => 'Keine Bearbeitungsrechte',
	'User \'[_1]\' (user #[_2]) edited entry #[_3]' => 'Benutzer \'[_1]\' (#[_2]) hat Eintrag #[_3] bearbeitet',
	'Not privileged to delete entry' => 'Keine Löschrechte',
	'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Eintrag \'[_1]\' (Eintrag #[_2]) von \'[_3]\' (Benutzer #[_4]) via XML-RPC gelöscht',
	'Not privileged to get entry' => 'Keine Leserechte',
	'User does not have privileges' => 'Benutzer hat keine Rechte',
	'Not privileged to set entry categories' => 'Keine Rechte, Kategorien zu vergeben',
	'Saving placement failed: [_1]' => 'Speichern von Platzierung fehlgeschlagen: [_1]',
	'Publish failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Not privileged to upload files' => 'Keine Upload-Rechte',
	'No filename provided' => 'Kein Dateiname angegeben',
	'Invalid filename \'[_1]\'' => 'Ungültiger Dateiname \'[_1]\'',
	'Error making path \'[_1]\': [_2]' => 'Fehler beim Anlegen des Ordners \'[_1]\': [_2]',
	'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Template-Methoden sind aufgrund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'Kann \'[_1]\' nicht öffnen: [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Kein Blog',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Sollen für die Benutzer Ihres Blogs neue Benutzerkonten angelegt werden, müssen Sie ein Passwort angeben.', # Translate - New # OK
	'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
	'Importing entries from file \'[_1]\'' => 'Importieren der Einträge aus Datei \'[_1]\'',
	'Creating new user (\'[_1]\')...' => 'Lege neuen Benutzer an (\'[_1]\')...',
	'ok' => 'OK', # Translate - New # OK
	'failed' => 'Fehlgeschlagen', # Translate - New # OK
	'Saving user failed: [_1]' => 'Speichern von Benutzer fehlgeschlagen: [_1]',
	'Assigning permissions for new user...' => 'Weise neuem Benutzer Rechte zu...',
	'Saving permission failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
	'Creating new category (\'[_1]\')...' => 'Lege neue Kategorie an (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Speichern von Kategorie fehlgeschlagen: [_1]',
	'Invalid status value \'[_1]\'' => 'Ungültiger Status-Wert \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Ungültiger Ping-Status \'[_1]\'',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Kann vorhandenen Eintrag mit Zeitstempel \'[_1]\' nicht finden, überspringe Kommentare und fahre mit nächstem Eintrag fort...', # Translate - New # OK
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importiere in vorhandenen Eintrag [_1] (\'[_2]\')', # Translate - New # OK
	'Saving entry (\'[_1]\')...' => 'Speichere Eintrag (\'[_1]\')...',
	'ok (ID [_1])' => 'OK', # Translate - New # OK
	'Saving entry failed: [_1]' => 'Speichern von Eintrag fehlgeschlagen: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar an (von \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Speichern von Kommentar fehlgeschlagen: [_1]',
	'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
	'Creating new ping (\'[_1]\')...' => 'Lege neuen Ping an (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Speichern von Ping fehlgeschlagen: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Export von \'[_1]\' fehlgeschlagen bei: [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ungültiges Datumsformat \'[_1]\';  muss \'MM/TT/JJJJ HH:MM:SS AM|PM\' sein (AM|PM optional)',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Geben Sie die Buchstaben ein, die Sie in obigem Bild sehen.',
	'You need to configure CaptchaSourceImagebase.' => 'Bitte konfigurieren Sie CaptchaSourceImagebase',
	'Image creation failed.' => 'Bilderzeugung fehlgeschlagen.',
	'Image error: [_1]' => 'Bildfehler: [_1]',

## lib/MT/Import.pm
	'Can\'t rewind' => 'Kann nicht zurückspulen',
	'Can\'t open directory \'[_1]\': [_2]' => 'Kann Verzeichnis \'[_1]\' nicht öffnen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Im Import-Verzeichnis [_1] konnten keine lesbaren Dateien gefunden werden.',
	'Couldn\'t resolve import format [_1]' => 'Kann Importformat [_1] nicht auflösen',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Anderes System (Movable Type-Format)', # Translate - New # OK

## lib/MT/Comment.pm
	'Comment' => 'Kommentar',
	'Load of entry \'[_1]\' failed: [_2]' => 'Laden des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'Weblog \'[_1]\' konnte nicht geladen werden: [_2]',

## lib/MT/App.pm
	'First Weblog' => 'Erstes Weblog',
	'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fehler beim Laden von Weblog #[_1] zur Bereitstellung von Benutzerkonten. Bitte überprüfen Sie die NewUserTemplateBlogId-Einstellung.',
	'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Fehler beim Bereitstellen des Weblogs für neuen Benutzer \'[_1]\'. Verwendete Vorlage: Weblog #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Fehler beim Anlegen des Ordners [_1] für Blog #[_2])',
	'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Fehler bei der Bereitstellung des persönlichen Blogs für Benutzer \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' für Benutzer \'[_3] (ID: [_4])\' erfolgreich angelegt.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Fehler bei der Vergabe von Administrationsrechten an Benutzer \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\': keine geeignete Administratorenrolle gefunden',
	'The login could not be confirmed because of a database error ([_1])' => 'Anmeldung konnte aufgrund eines Datenbankfehlers nicht durchgeführt werden ([_1])',
	'Invalid login.' => 'Login ungültig',
	'Failed login attempt by unknown user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer \'[_1]\'',
	'This account has been disabled. Please see your system administrator for access.' => 'Dieses Benutzerkonto wurde gesperrt. Bitte wenden Sie sich an den Administrator.',
	'This account has been deleted. Please see your system administrator for access.' => 'Dieses Benutzerkonto wurde gelöscht. Bitte wenden Sie sich an den Administrator.',
	'User cannot be created: [_1].' => 'Kann Benutzer nicht anlegen: [_1].',
	'User \'[_1]\' has been created.' => 'Benutzerkonto \'[_1]\' angelegt.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Benutzer \'[_1]\' (ID:[_2]) erfolgreich angemeldet',
	'Invalid login attempt from user \'[_1]\'' => 'Ungültiger Anmeldeversuch von Benutzer \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Benutzer \'[_1]\' (ID:[_2]) abgemeldet',
	'Close' => 'Schließen',
	'Go Back' => 'Zurück',
	'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu gross',
	'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
	'Permission denied.' => 'Keine Berechtigung.',
	'Warnings and Log Messages' => 'Warnungen und Logmeldungen',
	'http://www.movabletype.com/' => 'http://www.movabletype.com/',

## lib/MT/Page.pm
	'Page' => 'Seite',
	'Pages' => 'Seiten',
	'Folder' => 'Ordner',
	'Load of blog failed: [_1]' => 'Laden des Weblogs fehlgeschlagen: [_1]',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Keine WeblogsPingURL in der Konfigurationsdatei definiert', # Translate - New # OK
	'No MTPingURL defined in the configuration file' => 'Keine MTPingURL in der Konfigurationsdatei definiert', # Translate - New # OK
	'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
	'Ping error: [_1]' => 'Ping-Fehler: [_1]',

## lib/MT/Core.pm
	'System Administrator' => 'Systemadministrator',
	'Create Blogs' => 'Blogs anlegen', # Translate - New # OK
	'Manage Plugins' => 'Plugins verwalten', # Translate - New # OK
	'View System Activity Log' => 'Systemaktivitätsprotokoll einsehen', # Translate - New # OK
	'Blog Administrator' => 'Blog-Administrator',
	'Configure Blog' => 'Blog konfigurieren', # Translate - New # OK
	'Set Publishing Paths' => 'Veröffentlichungspfade setzen', # Translate - New # OK
	'Manage Categories' => 'Kategorien verwalten',
	'Manage Tags' => 'Tags verwalten',
	'Manage Notification List' => 'Benachrichtigungen verwalten',
	'View Activity Log' => 'Aktivitätsprotokoll anzeigen',
	'Create Entries' => 'Neuer Eintrag',
	'Publish Post' => 'Eintrag veröffentlichen', # Translate - New # OK
	'Send Notifications' => 'Benachrichtigungen versenden',
	'Edit All Entries' => 'Alle Einträge bearbeiten',
	'Manage Pages' => 'Seiten verwalten', # Translate - New # OK
	'Rebuild Files' => 'Dateien neu veröffentlichen',
	'Manage Templates' => 'Templates verwalten',
	'Upload File' => 'Dateiupload',
	'Save Image Defaults' => 'Bild-Voreinstellungen speichern', # Translate - New # OK
	'Manage Assets' => 'Assets verwalten', # Translate - New # OK
	'Post Comments' => 'Kommentare schreiben', # Translate - New # OK
	'Manage Feedback' => 'Feedback verwalten', # Translate - New # OK
	'MySQL Database' => 'MySQL-Datenbank',
	'PostgreSQL Database' => 'PostgreSQL-Datenbank',
	'SQLite Database' => 'SQLite-Datenbank', # Translate - New # OK
	'SQLite Database (v2)' => 'SQLite-Datenbank (v2)', # Translate - New # OK
	'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
	'Rich Text' => 'Rich Text', # Translate - New # OK
	'weblogs.com' => 'weblogs.com', # Translate - New # OK
	'technorati.com' => 'technorati.com', # Translate - New # OK
	'google.com' => 'google.com', # Translate - New # OK
	'<MTEntries>' => '<MTEntries>', # Translate - New # OK
	'Publish Future Posts' => 'Zukünftige Einträge veröffentlichen', # Translate - New # OK
	'Junk Folder Expiration' => 'Junk-Ordner-Einstellungen', # Translate - New # OK
	'Remove Temporary Files' => 'Temporäre Dateien löschen', # Translate - New # OK

## lib/MT/Asset/Image.pm
	'Image' => 'Bild',
	'Images' => 'Bilder',
	'Actual Dimensions' => 'Tatsächliche Größe',
	'[_1] wide, [_2] high' => '[_1] breit, [_2] hoch',
	'Error scaling image: [_1]' => 'Fehler bei der Skalierung: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fehler beim Erzeugen des Vorschaubilds: [_1]',
	'Can\'t load image #[_1]' => 'Kann Bild #[_1] nicht laden',
	'View image' => 'Bild ansehen',
	'Permission denied setting image defaults for blog #[_1]' => 'Keine Benutzerrechte zur Einstellung der Bild-Voreinstellungen für Weblog #[_1]',
	'Thumbnail failed: [_1]' => 'Thumbnail fehlgeschlagen: [_1]',
	'Invalid basename \'[_1]\'' => 'Ungültiger Basename \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Fehler beim Schreiben auf \'[_1]\': [_2]',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Sichere [_1]-Einträge:',
	'[_1] records backed up...' => '[_1]-Einträge gesichert...',
	'[_1] records backed up.' => '[_1]-Einträge gesichert.',
	'There were no [_1] records to be backed up.' => 'Keine [_1]-Einträge zu speichern.',
	'No manifest file could be found in your import directory [_1].' => 'Keine Manifest-Datei im Importverzeichnis [_1] gefunden.',
	'Can\'t open [_1].' => 'Kann [_1] nicht öffnen.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-Datei [_1] ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Manifest file: [_1]' => 'Manifest-Datei: [_1]', # Translate - New # OK
	'Path was not found for the file ([_1]).' => 'Pfad zu Datei ([_1]) nicht gefunden.', # Translate - New # OK
	'[_1] is not writable.' => 'Kein Schreibzugriff auf [_1]',
	'Copying [_1] to [_2]...' => 'Kopiere [_1] nach [_2]...',
	'Failed: ' => 'Fehler: ',
	'Done.' => 'Fertig.',
	'ID for the file was not set.' => 'ID für Datei nicht gesetzt.', # Translate - New # OK
	'The file ([_1]) was not restored.' => 'Datei ([_1]) nicht wiederhergestellt.', # Translate - New # OK
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Datei \'[_1]\' (ID:[_2])....', # Translate - New # OK

## lib/MT/BackupRestore/ManifestFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Die hochgeladene Datei ist keine gültige Movable Type Backup-Manifest-Datei.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Die hochgeladene Datei wurde aus einer Movable Type-Installation mit einer neueren Schema-Version ([_1]) als der hier vorhandenen ([_2]) gesichert. Es wird daher nicht empfohlen, die Datei mit dieser Movable Type-Version zu verwenden.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] ist keine Eigenschaft, die von Movable Type wiederhergestellt wird.',
	'[_1] records restored.' => '[_1]-Einträge wiederhergestellt.',
	'Restoring [_1] records:' => 'Stelle [_1]-Einträge wieder her:',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Benutzer mit gleichem Namen \'[_1]\' gefunden (ID:[_2]).  Die Benutzerdaten wurden entsprechend ersetzt.',
	'Tag \'[_1]\' exists in the system.' => 'Tag \'[_1]\' bereits im System vorhanden.', # Translate - New # OK
	'Trackback for entry (ID: [_1]) already exists in the system.' => 'TrackBack für Eintrag (ID: [_1]) bereits im System vorhanden.', # Translate - New # OK
	'Trackback for category (ID: [_1]) already exists in the system.' => 'TrackBack für Kategorie (ID: [_1]) bereits im System vorhanden.', # Translate - New # OK
	'[_1] records restored...' => '[_1] Einträge wiederhergstellt...',

## lib/MT/Folder.pm
	'Folders' => 'Ordner',

## lib/MT/DefaultTemplates.pm
	'Main Index' => 'Hauptindex',
	'Archive Index' => 'Archivindex', # Translate - New # OK
	'Base Stylesheet' => 'Basis-Stylesheet', # Translate - New # OK
	'Theme Stylesheet' => 'Themen-Stylesheet', # Translate - New # OK
	'JavaScript' => 'JavaScript', # Translate - New # OK
	'RSD' => 'RSD',
	'Atom' => 'ATOM', # Translate - New # OK
	'RSS' => 'RSS', # Translate - New # OK
	'Entry' => 'Eintrag',
	'Entry Listing' => 'Eintragsverzeichnis', # Translate - New # OK
	'Comment Error' => 'Kommentarfehler', # Translate - New # OK
	'Shown when a comment submission cannot be validated.' => 'Wird angezeigt, wenn ein neuer Kommentar nicht validiert werden kann', # Translate - New # OK
	'Shown when a comment is moderated or reported as spam.' => 'Wird angezeigt, wenn ein Kommentar zur Moderation zurückgehalten oder als Spam eingestuft wurde.', # Translate - New # OK
	'Comment Preview' => 'Kommentarvorschau', # Translate - New # OK
	'Shown when a commenter previews their comment.' => 'Wird angezeigt, wenn ein Kommentarautor eine Vorschau auf seinen Kommentar anzeigen lässt.', # Translate - New # OK
	'Dynamic Error' => 'Dynamischer Fehler', # Translate - New # OK
	'Shown when an error is encountered on a dynamic blog page.' => 'Wird angezeigt, wenn ein Fehler auf einer dynamischen Seite angezeigt wird.', # Translate - New # OK
	'Popup Image' => 'Popup-Bild',
	'Shown when a visitor clicks a popup-linked image.' => 'Wird angezeigt, wenn ein Leser auf ein mit einem Popup-Fenster verlinktes Bild klickt.', # Translate - New # OK
	'Shown when a visitor searches the weblog.' => 'Wird bei Suchvorgängen angezeigt.', # Translate - New # OK
	'Footer' => 'Fußzeile', # Translate - New # OK

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] aus Regel [_4][_5]', # Translate - New # OK
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] aus Test [_4]', # Translate - New # OK

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Konnte Lock für Systemtask nicht setzen. Stellen Sie sicher, daß Schreibrechte für das TempDir ([_1]) vorhanden sind.',
	'Error during task \'[_1]\': [_2]' => 'Fehler während Task \'[_1]\': [_2]',
	'Scheduled Tasks Update' => 'Aktualisierung geplanter Aufgaben',
	'The following tasks were run:' => 'Folgende Tasks wurden ausgeführt:',

## lib/MT/AtomServer.pm

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Bewertung für dieses Objekt bereits abgegeben.',
	'Can not set score to the object \'[_1]\'(ID: [_2])' => 'Kann \'[_1]\'(ID: [_2]) keine Bewertung zuweisen', # Translate - New # OK

## lib/MT/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Formatfehler in Zeile [_1]: [_2]',
	'Invalid command: [_1]' => 'Ungültiger Befehl: [_1]',
	'Invalid number of columns for [_1]' => 'Ungültige Spaltenzahl für [_1]',
	'Invalid user name: [_1]' => 'Ungültiger Benutzername: [_1]',
	'Invalid display name: [_1]' => 'Ungültiger Anzeigename: [_1]',
	'Invalid email address: [_1]' => 'Ungültige Email-Adresse: [_1]',
	'Invalid language: [_1]' => 'Ungültige Sprache: [_1]',
	'Invalid password: [_1]' => 'Ungültiges Passwort: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Ungültiger Passwort-Erinnerungssatz: [_1]',
	'Invalid weblog name: [_1]' => 'Ungültiger Weblogname: [_1]',
	'Invalid weblog description: [_1]' => 'Ungültige Weblogbeschreibung: [_1]',
	'Invalid site url: [_1]' => 'Ungültige Adresse (URL): [_1]',
	'Invalid site root: [_1]' => 'Ungültiges Wurzelverzeichnis: [_1]',
	'Invalid timezone: [_1]' => 'Ungültige Zeitzone: [_1]',
	'Invalid new user name: [_1]' => 'Ungültiger neuer Benutzername: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Es ist bereits ein Benutzer gleichen Namens vorhanden; Konto nicht angelegt: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Blog für Benutzer \'[_1]\' konnte nicht angelegt werden.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Blog \'[_1]\' für Benutzer \'[_2]\' erfolgreich angelegt.',
	'Permission granted to user \'[_1]\'' => 'Benutzerrechte für Benutzer \'[_1]\' vergeben',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'Benutzer \'[_1]\' bereits vorhanden. Aktualisierung nicht durchgeführt: [_2]',
	'User cannot be updated: [_1].' => 'Benutzer kann nicht aktualisiert werden: [_1].',
	'User \'[_1]\' not found.  Update was not processed.' => 'Benutzer \'[_1]\' nicht gefunden. Aktualisierung nicht durchgeführt.',
	'User \'[_1]\' has been updated.' => 'Benutzer \'[_1]\' aktualisiert.',
	'User \'[_1]\' was found, but delete was not processed' => 'Benutzer \'[_1]\' gefunden, aber Löschung nicht durchgeführt',
	'User \'[_1]\' not found.  Delete was not processed.' => 'Benutzer \'[_1]\' nicht gefunden. Löschung nicht durchgeführt..',
	'User \'[_1]\' has been deleted.' => 'Benutzer \'[_1]\' gelöscht.',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'verwendet [_1], sollte [_2] verwenden',
	'uses [_1]' => 'verwendet [_1]',
	'No executable code' => 'Kein ausführbarer Code',
	'Rebuild-option name must not contain special characters' => 'Name der Rebuild-Option darf keine Sonderzeichen enthalten',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'Konnte nicht übernommen werden: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => '\'all\' ist kein gültiges exclude_blogs-Parameter.',

## lib/MT/Template/ContextHandlers.pm
	'[_1]Erneut veröffentlichen[_2] um Änderungen wirksam werden zu lassen.' => '', # Translate - New # OK
	'Plugin Actions' => 'Plugin-Aktionen',
	'Warning' => 'Warnung',
	'Now you can comment.' => 'Sie können jetzt Ihren Kommentar verfassen.',
	'Yes' => 'Ja',
	'No' => 'Nein',
	'You are not signed in. You need to be registered to comment on this site.' => 'Sie sind nicht angemeldet. Sie müssen sich registrieren, um hier zu kommentieren.',
	'Sign in' => 'Anmelden',
	'If you have a TypeKey identity, you can ' => 'Wenn Sie eine TypeKey-Identität besitzen, können Sie ',
	'sign in' => 'anmelden',
	'to use it here.' => ', um es hier zu verwenden.',
	'Remember me?' => 'Benutzername speichern?',
	'No [_1] could be found.' => 'Kein [_1] gefunden.', # Translate - New # OK
	'Recursion attempt on [_1]: [_2]' => 'Rekursionsversuch bei [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Kann verwendetes Template [_1] \'[_2]\' nicht finden',
	'Can\'t find blog for id \'[_1]' => 'Kann Blog für ID \'[_1]\' nicht finden',
	'Can\'t find included file \'[_1]\'' => 'Kann verwendete Datei \'[_1]\' nicht finden',
	'Error opening included file \'[_1]\': [_2]' => 'Fehler beim Öffnen der verwendeten Datei \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Rekursionsversuch bei Datei [_1]',
	'Unspecified archive template' => 'Nicht spezifiziertes Archiv-Template',
	'Error in file template: [_1]' => 'Fehler in Datei-Template: [_1]',
	'Can\'t load template' => 'Kann Vorlage nicht laden',
	'Can\'t find template \'[_1]\'' => 'Kann Vorlage \'[_1]\' nicht finden',
	'Can\'t find entry \'[_1]\'' => 'Kann Eintrag \'[_1]\' nicht finden',
	'[_1] [_2]' => '[_1] [_2]',
	'You used a [_1] tag without any arguments.' => 'Sie haben einen [_1]-Tag ohne Argument verwendet.',
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" erfordert einen Namespace.',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Fehler im \'[_2]\'-Attribut: [_1]',
	'You have an error in your \'tag\' attribute: [_1]' => 'Fehler im \'tag\'-Attribut: [_1]',
	'No such user \'[_1]\'' => 'Kein Benutzer \'[_1]\'',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => '\'[_1]\'-Tag außerhalb eines Eintrags-Kontexts verwendet - \'MTEntries\'-Container erforderlich.',
	'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Sie haben mit einem [_1]-Tag \'[_2]\'-Archive verlinkt, ohne diese vorher zu veröffentlichen.',
	'Could not create atom id for entry [_1]' => 'Konnte keine ATOM-ID für Eintrag [_1] erzeugen',
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey-Authentifizierung in diesem Weblog nicht aktiviert -  MTRemoteSignInLink kann nicht verwendet werden.',
	'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Um Registierung von Kommentarautoren zu ermöglichen geben Sie ein TypeKey-Token in den Weblogeinstellungen oder dem Benutzerenprofil an.',
	'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Tag ohne Datumskontext verwendet.',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => '\'[_1]\'-Tag außerhalb eines Kommentar-Kontexts verwendet - \'MTComments\'-Container erforderlich.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit Tages-, Wochen- oder Monatsarchiven verwendet werden.',
	'Group iterator failed.' => 'Gruppeniterator fehlgeschlagen.',
	'You used an [_1] tag outside of the proper context.' => 'Sie haben ein [_1]-Tag außerhalb seines Kontexts verwendet.',
	'Could not determine entry' => 'Konnte Eintrag nicht bestimmen',
	'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: richtig ist JJJJMM',
	'No such category \'[_1]\'' => 'Keine Kategorie \'[_1]\'',
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem \'category\'-Attribut des Tags.',
	'You failed to specify the label attribute for the [_1] tag.' => 'Kein Label-Attribut des [_1]-Tags angegeben.',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => '\'[_1]\'-Tag außerhalb eines Ping-Kontextes verwendet - \'MTPings\'-Container erforderlich.',
	'[_1] used outside of [_2]' => '[_1] außerhalb [_2] verwendet', # Translate - New # OK
	'MT[_1] must be used in a [_2] context' => 'MT[_1] muss in einem [_2]-Kontext stehen',
	'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fehler beim Sortieren von [_2]: [_1]',
	'Edit' => 'Bearbeiten',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => '\'[_1]\'-Tag außerhalb eines Asset-Kontexts verwendet - möglicherweise außerhalb eines \'MTAssets\'-Containers?', # Translate - New # OK
	'You used an \'[_1]\' tag outside of the context of an page; perhaps you mistakenly placed it outside of an \'MTPages\' container?' => '\'[_1]\'-Tag außerhalb eines Seiten-Kontexts verwendet - möglicherweise außerhalb eines \'MTPages\'-Containers?', # Translate - New # OK
	'You used an [_1] without a author context set up.' => '[_1] ohne vorhandenen Autorenkontext verwendet.',
	'Can\'t load blog.' => 'Kann Weblog nicht lande # OK.',
	'Can\'t load user.' => 'Kann Benutzer nicht landen.',

## lib/MT/Image.pm
	'Can\'t load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Datei \'[_1]\' kann nicht gelesen werden: [_2]',
	'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Skalieren auf [_1]x[_2] fehlgeschlagen: [_3]',
	'Can\'t load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad auf NetPBM-Tools eingestellt.',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias für [_1] bildet eine Schleife.',
	'Error opening file \'[_1]\': [_2]' => 'Fehler beim Öffnen der Datei \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Konfigurationsanweisung [_1] ohne Wert [_2] in Zeile [_3]',
	'No such config variable \'[_1]\'' => 'Konfigurationsvariable \'[_1]\' nicht vorhanden oder nicht existent',

## lib/MT/Log.pm
	'System' => 'System',
	'Page # [_1] not found.' => 'Seite # [_1] nicht gefunden.',
	'Entries' => 'Einträge',
	'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
	'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',

## lib/MT/Auth/OpenID.pm
	'Could not discover claimed identity: [_1]' => 'Konnte angegebene Identität nicht finden: [_1]',
	'Couldn\'t save the session' => 'Session konnte nicht gespeichert werden',

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Passwörter stimmen nicht überein.',
	'Failed to verify current password.' => 'Kann Passwort nicht überprüfen.',
	'Password hint is required.' => 'Passwort-Erinnerungssatz erforderlich.',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'Die Anmeldung erfordert eine sichere Signatur.',
	'The sign-in validation failed.' => 'Anmeldung fehlgeschlagen.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Kommentarautoren müssen eine Email-Adresse angeben. Wenn Sie das tun möchten, melden Sie sich an und erlauben Sie dem Authentifizierungsdienst, Ihre Email-Adresse weiterzuleiten.',
	'This weblog requires commenters to pass an email address' => 'Kommentarautoren müssen eine Email-Adresse angeben',
	'Couldn\'t get public key from url provided' => 'Public Key konnte von der angegebenen Adresse nicht gelesen werden',
	'No public key could be found to validate registration.' => 'Kein Public Key zur Validierung gefunden.',
	'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey-Signaturbestätigung gab [_1] zurück (nach [_2] Sekunden) und bestätigte [_3] mit [_4]',
	'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'Die TypeKey-Signatur ist veraltet ([_1] seconds old). Stellen Sie sicher, daß die Uhr Ihres Servers richtig geht.',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Unbekannte MailTransfer-Methode \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Für das Versenden von Email mittels SMTP ist Mail::Sendmail erforderlich: [_1]',
	'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Kein gültiger sendmail-Pfad gefunden. Versuchen Sie stattdessen SMTP zu verwenden.',
	'Exec of sendmail failed: [_1]' => 'Ausführung von sendmail fehlgeschlagen: [_1]',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Aktion: Junked (Score unterschreitet Grenzwert)',
	'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
	'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] abgebrochen: [_2]',
	'Unnamed Junk Filter' => 'Namenloser Junk Filter',
	'Composite score: [_1]' => 'Gesamt-Score: [_1]',

## lib/MT/TBPing.pm
	'TrackBack' => 'TrackBack',

## lib/MT/Util.pm
	'moments from now' => 'In einem Augenblick', # Translate - New # OK
	'moments ago' => 'Vor einem Augenblick', # Translate - New # OK
	'[quant,_1,hour] from now' => 'In [quant,_1,Stunde,Stunden]',
	'[quant,_1,hour] ago' => 'Vor [quant,_1,Stunde,Stunden]',
	'[quant,_1,minute] from now' => 'In [quant,_1,Minute,Minuten]',
	'[quant,_1,minute] ago' => 'Vor [quant,_1,Minute,Minuten]',
	'[quant,_1,day] from now' => 'In [quant,_1,Tag,Tagen]',
	'[quant,_1,day] ago' => 'Vor [quant,_1,Tag]',
	'less than 1 minute from now' => 'In weniger als 1 Minute', # Translate - Case # OK
	'less than 1 minute ago' => 'Vor weniger als 1 Minute', # Translate - Case # OK
	'[quant,_1,hour], [quant,_2,minute] from now' => 'In [quant,_1,Stunde,Stunden], [quant,_2,Minute,Minuten]',
	'[quant,_1,hour], [quant,_2,minute] ago' => 'Vor [quant,_1,Stunde,Stunden], [quant,_2,Minute,Minuten]',
	'[quant,_1,day], [quant,_2,hour] from now' => 'In [quant,_1,Tag,Tagen], [quant,_2,Stunde,Stunden]',
	'[quant,_1,day], [quant,_2,hour] ago' => 'Vor [quant,_1,Tag,Tagen], [quant,_2,Stunde,Stunden] ',

## lib/MT/WeblogPublisher.pm
	'yyyy/index.html' => 'jjjj/index.html',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/Tag-Woche/index.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/Eintrags_Name.html',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/Eintrags-Name.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/Eintrags_Name/index.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/Eintrags-Name/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/tt/Eintrags_Name.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/tt/Eintrags-Name.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/tt/Eintrags_Name/index.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/tt/Eintrags-Name/index.html',
	'category/sub_category/entry_basename.html' => 'Kategorie/Unter_Kategorie/Eintrags_Name.html',
	'category/sub_category/entry_basename/index.html' => 'Kategorie/Unter_Kategorie/Eintrags_Name/index.html',
	'category/sub-category/entry-basename.html' => 'Kategorie/Unter-Kategorie/Eintrags-Name.html',
	'category/sub-category/entry-basename/index.html' => 'Kategorie/Unter-Kategorie/Eintrags-Name/index.html',
	'folder_path/page_basename.html' => 'Ordner_Pfad/Seiten_Name.html',
	'folder_path/page_basename/index.html' => 'Ordner_Pfad/Seiten_Name/index.html',
	'folder-path/page-basename.html' => 'Ordner-Pfad/Seiten-Name.html',
	'folder-path/page-basename/index.html' => 'Ordner-Pfad/Seiten-Name/index.html',
	'folder/sub_folder/index.html' => 'Ordner/Unter_Ordner/index.html',
	'folder/sub-folder/index.html' => 'Ordner/Unter_Ordner/index.html',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/tt/index.html',
	'category/sub_category/index.html' => 'Kategorie/Unter_Kategorie/index.html',
	'category/sub-category/index.html' => 'Kategorie/Unter-Kategorie/index.html',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archivtyp \'[_1]\' wurde vorher nicht ausgewählt',
	'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' erforderlich',
	'You did not set your weblog Archive Path' => 'Archive Path für dieses Weblog nicht gesetzt.',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Diese Archivdatei existiert bereits. Ändern Sie entweder den Basename oder den Archivpfad. ([_1])',
	'Building category \'[_1]\' failed: [_2]' => 'Kategorie \'[_1]\' erzeugen fehlgeschlagen: [_2]',
	'Building entry \'[_1]\' failed: [_2]' => 'Eintrag \'[_1]\' erzeugen fehlgeschlagen: [_2]',
	'Building date-based archive \'[_1]\' failed: [_2]' => 'Datumsbasiertes Archiv \'[_1]\' erzeugen fehlgeschlagen: [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Schreien auf \'[_1]\' fehlgeschlagen: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Umbenennung der temporären Datei \'[_1]\' fehlgeschlagen: [_2]',
	'You did not set your weblog Site Root' => 'Site Root für dieses Weblog nicht gesetzt',
	'Template \'[_1]\' does not have an Output File.' => 'Template \'[_1]\' hat keine Output-Datei.',
	'An error occurred while rebuilding to publish scheduled entries: [_1]' => 'Bei der Veröffentlichung zeitgeplanter Einträge ist ein Fehler aufgetreten: [_1]',
	'YEARLY_ADV' => 'YEARLY_ADV',
	'MONTHLY_ADV' => 'Monatlich',
	'CATEGORY_ADV' => 'Kategorie',
	'PAGE_ADV' => 'PAGE_ADV',
	'INDIVIDUAL_ADV' => 'Einzeln',
	'DAILY_ADV' => 'Täglich',
	'WEEKLY_ADV' => 'Wöchentlich',

## lib/MT/Asset.pm
	'File' => 'Datei',
	'Files' => 'Dateien',
	'Description' => 'Beschreibung',
	'Location' => 'Ort',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fehler bei der Zuweisung von Kommentierungsrechten an Benutzer \'[_1] (ID: [_2])\' für Weblog \'[_3] (ID: [_4])\'. Keine geeignete Kommentierungsrolle gefunden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ungültiger Anmeldeversuch von Kommetarautor [_1] an Weblog [_2](ID: [_3]) - native Movable Type-Authentifizierung nicht in diesem Weblog nicht zulässig.',
	'Login failed: permission denied for user \'[_1]\'' => 'Login fehlgeschlagen: Zugriff verweigert für Benutzer \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Login fehlgeschlagen: falsches Passwort für Benutzer \'[_1]\'',
	'Signing up is not allowed.' => 'Anmelden nicht erlaubt.',
	'User requires username.' => 'Benutzername für Benutzer erforderlich.',
	'User requires display name.' => 'Anzeigename für Benutzer erforderlich.',
	'A user with the same name already exists.' => 'Ein Benutzer mit diesem Namen existiert bereits.',
	'User requires password.' => 'Passwort für Benutzer erforderlich.',
	'User requires password recovery word/phrase.' => 'Passwort-Erinnerungsfrage für Benutzer erforderlich.',
	'Email Address is invalid.' => 'E-Mail-Adresse ungültig.',
	'Email Address is required for password recovery.' => 'E-Mail-Addresse zur Erzeugung eines neuen Passworts erforderlich .',
	'URL is invalid.' => 'URL ist ungültig.',
	'Text entered was wrong.  Try again.' => 'Der eingegebene Text ist falsch. Bitte versuchen Sie es erneut.',
	'Something wrong happened when trying to process signup: [_1]' => 'Bei der Bearbeitung der Registrierung ist ein Fehler aufgetreten: [_1]',
	'Movable Type Account Confirmation' => 'Movable Type-Anmeldungsbestätigung',
	'System Email Address is not configured.' => 'System-E-Mail-Adresse nicht konfiguriert.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Kommentarautor \'[_1]\' (ID:[_2]) erfolgreich registriert.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Vielen Dank für Ihre Bestätigung. Sie können sich jetzt anmelden und kommentieren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] registiert für Weblog \'[_2]\'',
	'No id' => 'Keine ID',
	'No such comment' => 'Kein entsprechender Kommentar',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
	'IP Banned Due to Excessive Comments' => 'IP gesperrt - zu viele Kommentare',
	'_THROTTLED_COMMENT_EMAIL' => 'Ein Kommentator Ihres Weblogs [_1] wurde automatisch gesperrt. Der Kommentator hat mehr als die erlaubte Anzahl an Kommentaren in den letzten [_2] Sekunden veröffentlicht. Diese Sperre schützt Sie vor Spam-Skripts. Die gesperrte IP-Adresse ist [_3]. Wenn diese Sperrung ein Fehler war, können Sie die IP-Adresse wieder entsperren. Wählen Sie die IP-Adresse [_4] aus der IP-Sperrliste und löschen Sie die Adresse aus der Liste.',
	'Invalid request' => 'Ungültige Anfrage',
	'No such entry \'[_1]\'.' => 'Kein Eintrag \'[_1]\'.',
	'You are not allowed to add comments.' => 'Sie sind nicht berechtigt, Kommentare hinzuzufügen.',
	'_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in kurzer Folge abgegeben. Zum Schutz vor Spam steht Ihnen Kommentarfunktion daher erst wieder in einigen Augenblicken zur Verfügung. Vielen Dank für Ihr Verständnis.',
	'Comments are not allowed on this entry.' => 'Bei diesem Eintrag sind Kommentare nicht erlaubt.',
	'Comment text is required.' => 'Kommentartext ist Pflichtfeld.',
	'An error occurred: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
	'Registration is required.' => 'Registrierung ist erforderlich.',
	'Name and email address are required.' => 'Name und Email sind Pflichtfelder.',
	'Invalid email address \'[_1]\'' => 'Ungültige Email-Adresse \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'Ungültige URL \'[_1]\'',
	'Comment save failed with [_1]' => 'Speichern des Kommentars fehlgeschlagen: [_1]',
	'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
	'Commenter save failed with [_1]' => 'Speichern des Kommentarautorens fehlgeschlagen: [_1]',
	'Rebuild failed: [_1]' => 'Neuaufbau fehlgeschlagen: [_1]',
	'You must define a Comment Pending template.' => 'Sie müssen ein Template definieren für Kommentarmoderation.',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Fehlgeschlagener Kommentierungsversuch durch schwebenden Kommentarautoren \'[_1]\'',
	'Registered User' => 'Registrierter Benutzer',
	'New Comment Added to \'[_1]\'' => 'Neuer Kommentar zu \'[_1]\' hinzugefügt',
	'The sign-in attempt was not successful; please try again.' => 'Sign-in war nicht erfolgreich; bitte erneut versuchen.',
	'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'Validierung des Sign-ins war nicht erfolgreich. Bitte Konfiguration überprüfen und erneut versuchen.',
	'No such entry ID \'[_1]\'' => 'Keine Eintrags-ID \'[_1]\'',
	'You must define an Individual template in order to display dynamic comments.' => 'Um dynamische Kommentare anzeigen zu können, ist ein Invidual-Template erforderlich.',
	'You must define a Comment Listing template in order to display dynamic comments.' => 'Um dynamische Kommentare anzeigen zu können, ist ein Comment Listing-Template erforderlich.',
	'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag spezifiziert. Vielleicht gibt es ein Problem mit dem Template?',
	'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
	'You must define a Comment Error template.' => 'Sie müssen ein Template definieren für Kommentarfehler.',
	'You must define a Comment Preview template.' => 'Sie müssen ein Template definieren für Kommentarvorschau.',
	'Invalid commenter ID' => 'Ungültige Kommentarautoren-ID',
	'No entry ID provided' => 'Keine Eintrags-ID angegeben',
	'Permission denied' => 'Zugriff verweigert',
	'All required fields must have valid values.' => 'Alle erforderlichen Felder müssen gültige Werte aufweisen.',
	'Commenter profile has successfully been updated.' => 'Kommentarautoren-Profil erfolgreich aktualisiert.',
	'Commenter profile could not be updated: [_1]' => 'Kommentarautoren-Profil konnte nicht aktualisiert werden: [_1]',
	'You can\'t reply to unpublished comment.' => 'Sie können nicht auf Kommentare antworten, die noch nicht veröffentlicht wurden.',
	'Your session has been ended.  Cancel the dialog and login again.' => 'Ihre Sitzung wurde beendet. Bitte wählen Sie Abbruch und melden Sie sich erneut an.',
	'Invalid request.' => 'Ungültige Anfrage.',

## lib/MT/App/Wizard.pm
	'The [_1] database driver is required to use [_2].' => 'Ein [_1]-Datenbanktreiber ist erforderlich, um [_2] zu nutzen.',
	'The [_1] driver is required to use [_2].' => 'Ein [_1]-Treiber ist erforderlich, um [_2] zu nutzen.',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Bei dem Versuch, eine Verbindung zur Datenbank aufzubauen, ist ein Fehler aufgetreten. Bitte überprüfen Sie Einstellungen und versuchen es erneut.',
	'SMTP Server' => 'SMTP-Server',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Testmail vom Movable Type-Konfigurationshelfer',
	'This is the test email sent by your new installation of Movable Type.' => 'Diese Testmail wurde von Ihrer neuen Movable Type-Installation verschickt.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Dieses Modul ist zur Sonderzeichenkodierung erforderlich. Sonderzeichenkodierung kann über den Schalter NoHTMLEntities in mt-config.cgi abgeschaltet werden.', # Translate - New
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Dieses Modul ist zur Nutzung von TrackBacks, weblogs.com-Pings und dem MT-Kürzlich-Aktualisiert-Ping erforderlich.', # Translate - New
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Dieses Modul ist zur Verwendung des XML-RPC-Servers notwendig.', # Translate - New # OK
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Dieses Modul ist zum Überschreiben bereits vorhandener Dateien beim Hochladen erforderlich.', # Translate - New # OK
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Dieses Modul ist zur Erzeugung von Vorschaubildern von hochgeladenen Dateien erforderlich.', # Translate - New # OK
	'This module is required by certain MT plugins available from third parties.' => 'Dieses Modul ist für einige MT-Plugins von Drittanbietern erforderlich.', # Translate - New # OK
	'This module accelerates comment registration sign-ins.' => 'Dieses Modul beschleunigt die Anmeldung als Kommentarautor.', # Translate - New # OK
	'This module is needed to enable comment registration.' => 'Dieses Modul ermöglicht die Registrierung von Kommentarautoren.', # Translate - New # OK
	'This module enables the use of the Atom API.' => 'Dieses Modul ermöglicht die Verwendung der ATOM-API.', # Translate - New # OK
	'This module is required in order to archive files in backup/restore operation.' => 'Dieses Modul ist zur Archivierung von Dateien bei der Erstellung und Wiederherstellung von Sicherheitskopien erforderlich.', # Translate - New # OK
	'This module is required in order to compress files in backup/restore operation.' => 'Dieses Modul ist zur Komprimierung von Dateien bei der Erstellung und Wiederherstellung von Sicherheitskopien erforderlich.', # Translate - New # OK
	'This module is required in order to decompress files in backup/restore operation.' => 'Dieses Modul ist zum Entpacken von Dateien bei der Erstellung und Wiederherstellung von Sicherheitskopien erforderlich.', # Translate - New # OK
	'This module and its dependencies are required in order to restore from a backup.' => 'Dieses Modul und seine Abhängigkeiten sind zur Wiederherstellung von Sicherheitskopien erforderlich.', # Translate - New # OK
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Dieses Modul ist zur Bestimmung der Größe hochgeladener Dateien erforderlich.', # Translate - New # OK
	'This module is required for cookie authentication.' => 'Dieses Modul ist zur Cookie-Authentifizierung erforderlich.', # Translate - New # OK

## lib/MT/App/Upgrader.pm
	'Failed to authenticate using given credentials: [_1].' => 'Authentifizierung fehlgeschlagen: [_1].',
	'You failed to validate your password.' => 'Passwort und Wiederholung des Passworts stimmen nicht überein',
	'You failed to supply a password.' => 'Passwort erforderlich',
	'The e-mail address is required.' => 'Email-Adresse erforderlich',
	'Invalid session.' => 'Ungültige Session',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Bitte kontaktieren Sie Ihren Administrator, um das Upgrade von Movable Type durchzuführen. Sie haben nicht die erforderlichen Rechte.',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Bitte geben Sie eine gültige Email-Adresse an.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Erforderliches Parameter blog_id fehlt. Bitte konfigurieren Sie die Benachrichtungsfunktion entsprechend.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Ungültiges Redirect-Parameter. Sie müssen einen zur verwendeten Domain gehörenden Pfad angeben.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Die Email-Adresse \'[_1]\' ist bereits in der Benachrichtigunsliste für dieses Weblog.',
	'Please verify your email to subscribe' => 'Bitte bestätigen Sie Ihre Email-Adresse',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Bitte klicken Sie auf den Bestätigungslink in der Mail, die an [_1] verschickt wurde. So wird sichergestellt, daß die angegebene Email-Adresse wirklich Ihnen gehört.',
	'The address [_1] was not subscribed.' => 'Die Adresse [_1] wurde hinzugefügt.',
	'The address [_1] has been unsubscribed.' => 'Die Adresse [_1] wurde entfernt.',

## lib/MT/App/CMS.pm
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,Eintrag,Einträge] getaggt mit &ldquo;[_2]&rdquo;', # Translate - New # OK
	'Posted by [_1] [_2] in [_3]' => 'Von [_1] [_2] in [_3]', # Translate - New # OK
	'Posted by [_1] [_2]' => 'Von [_1] [_2]', # Translate - New # OK
	'Tagged: [_1]' => 'Getaggt: [_1]', # Translate - New # OK
	'View all entries tagged &ldquo;[_1]&rdquo;' => 'Zeige alle mit &ldquo;[_1]&rdquo getaggten Einträge', # Translate - New # OK
	'No entries available.' => 'Keine Einträge vorhanden.', # Translate - New # OK
	'_WARNING_PASSWORD_RESET_MULTI' => 'Sie möchten die Passwörter der gewählten Benutzer zurücksetzen. Den Benutzern werden dazu zufällig erzeugte neue Passwörter per Email zugeschickt.\n\n\Forsetzen?',
	'_WARNING_DELETE_USER_EUM' => 'Löschen eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Es wird daher empfohlen, das Benutzerkonto zu belassen und stattdessen dem Benutzer alle Zugriffsrechte zu entziehen. Möchten Sie das Konto dennoch löschen?\nGelöschte Benutzer können ihre Benutzerkonten selbst solange wiederherstellen, wie sie noch im externen Verzeichnis aufgeführt sind.',
	'_WARNING_DELETE_USER' => 'Löschen eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Es wird daher empfohlen, das Benutzerkonto zu belassen und stattdessen dem Benutzer alle Zugriffsrechte zu entziehen. Möchten Sie das Konto dennoch löschen?\nGelöschte Benutzer können ihre Benutzerkonten selbst solange wiederherstellen, wie sie noch im externen Verzeichnis aufgeführt sind.',
	'Entries posted between [_1] and [_2]' => 'Zwischen [_1] und [_2] veröffentlichte Einträge', # Translate - New # OK
	'Entries posted since [_1]' => 'Seit [_1] veröffentlichte Einträge', # Translate - New # OK
	'Entries posted on or before [_1]' => 'Bis [_1] veröffentlichte Einträge', # Translate - New # OK
	'All comments by [_1] \'[_2]\'' => 'Alle Kommentare von [_1] \'[_2]\'',
	'Commenter' => 'Kommentator',
	'Author' => 'Autor',
	'All comments for [_1] \'[_2]\'' => 'Alle Kommentare für  [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Zwischen [_1] und [_2] veröffentlichte Kommentare', # Translate - New # OK
	'Comments posted since [_1]' => 'Seit [_1] veröffentlichte Kommentare', # Translate - New # OK
	'Comments posted on or before [_1]' => 'Bis [_1] veröffentlichte Kommentare', # Translate - New # OK
	'Invalid blog' => 'Ungültiges Blog',
	'Password Recovery' => 'Passwort verschicken',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Ungültiger Versuch der Passwortanforderung. Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid author_id' => 'Ungültige Autoren-ID',
	'Can\'t recover password in this configuration' => 'Passwörter können in dieser Konfiguration nicht angefordert werden',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Ungültiger Benutzername \'[_1]\' zur Passwortanforderung verwendet',
	'User name or birthplace is incorrect.' => 'Benutzername oder Geburtsort ungültig.',
	'User has not set birthplace; cannot recover password' => 'Geburtsort nicht angegeben; Passwort kann nicht angefordert werden',
	'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Ungültiger Versuch der Passwortanforderung (angegebener Geburtsort: \'[_1]\')',
	'User does not have email address' => 'Benutzer hat keine Email-Adresse',
	'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Passwort von Benutzer \'[_1]\' (#[_2]) zurückgesetzt und an [_3] verschickt',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Mailversand fehlgeschlagen ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, das Passwort anzufordern.',
	'(newly created user)' => '(neu angelegter Benutzer)',
	'Search Files' => 'Dateien suchen',
	'Invalid group id' => 'Ungültige Gruppen-ID',
	'Users & Groups' => 'Benutzer und Gruppen',
	'Group Roles' => 'Gruppenrollen',
	'Invalid user id' => 'Ungültige Benutzer-ID',
	'User Roles' => 'Benutzerrollen',
	'Roles' => 'Rollen',
	'Group Associations' => 'Gruppenverknüpfungen',
	'User Associations' => 'Benutzerverknüpfungen',
	'Role Users & Groups' => 'Rollen-Benutzer und -Gruppen',
	'Associations' => 'Verknüpfungen',
	'(Custom)' => '(Individuell)',
	'(user deleted)' => '(Benutzer gelöscht)',
	'Invalid type' => 'Ungültiger Typ',
	'No such tag' => 'Kein solcher Tag',
	'None' => 'Kein(e)',
	'You are not authorized to log in to this blog.' => 'Kein Zugang zu diesem Weblog.',
	'No such blog [_1]' => 'Kein Weblog [_1]',
	'Blogs' => 'Blogs',
	'Blog Activity Feed' => 'Aktivitätsprotokoll-Feed',
	'Users' => 'Benutzer',
	'Group Members' => 'Gruppenmitglieder',
	'QuickPost' => 'QuickPost',
	'All Feedback' => 'Jedes Feedback',
	'Activity Log' => 'Aktivitäten',
	'System Activity Feed' => 'System-Aktivitätsfeed',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Aktivitätsprotokoll von \'[_1]\' (ID:[_2]) on \'[_3]\' zurückgesetzt',
	'Activity log reset by \'[_1]\'' => 'Aktivitätsprotokoll zurückgesetzt von \'[_1]\'',
	'No blog ID' => 'Keine Weblog-ID',
	'You do not have import permissions' => 'Keine Import-Rechte',
	'Default' => 'Standard',
	'Import/Export' => 'Import/Export',
	'Invalid parameter' => 'Ungültiges Parameter',
	'Permission denied: [_1]' => 'Zugriff verweigert: [_1]',
	'Load failed: [_1]' => 'Laden fehlgeschlagen: [_1]',
	'(no reason given)' => '(unbekannte Ursache)',
	'(untitled)' => '(ohne Überschrift)',
	'Templates' => 'Vorlagen',
	'An error was found in this template: [_1]' => 'Diese Vorlage enthält einen Fehler: [_1]', # Translate - New # OK
	'General Settings' => 'Allgemeine Einstellungen',
	'Publishing Settings' => 'Grundeinstellungen',
	'Plugin Settings' => 'Plugin-Einstellungen',
	'Settings' => 'Einstellungen',
	'Edit TrackBack' => 'TrackBack bearbeiten',
	'Edit Comment' => 'Kommentar bearbeiten',
	'Authenticated Commenters' => 'Authentifizierte Kommentarautoren',
	'Commenter Details' => 'Details zu Kommentator',
	'New Entry' => 'Neuer Eintrag',
	'New Page' => 'Neue Seite',
	'Create template requires type' => 'Typangabe zum Anlegen von Templates erforderlich',
	'Archive' => 'Archiv', # Translate - New # OK
	'Entry or Page' => 'Eintrag oder Seite', # Translate - New # OK
	'New Template' => 'Neues Template',
	'New Blog' => 'Neues Blog',
	'Create New User' => 'Neues Benutzerkonto anlegen',
	'User requires username' => 'Benutzer erfordert Benutzername',
	'User requires password' => 'Benutzer erfodert Benutzername',
	'User requires password recovery word/phrase' => 'Author erfordert Passwort-Erinnerungssatz',
	'Email Address is required for password recovery' => 'Email-Adresse bei Passwort-Anfrage erforderlich',
	'The value you entered was not a valid email address' => 'Email-Adresse ungültig',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Die angegebene E-Mail-Adresse befindet sich bereits auf der Benachrichtigungsliste für dieses Weblog.',
	'You did not enter an IP address to ban.' => 'Keine IP-Adresse angegeben.',
	'The IP you entered is already banned for this blog.' => 'Die angegebene IP-Adresse ist für dieses Weblog bereits gesperrt.',
	'You did not specify a blog name.' => 'Kein Blog-Name angegeben.',
	'Site URL must be an absolute URL.' => 'Site-URL muß absolute URL sein.',
	'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
	'The name \'[_1]\' is too long!' => 'Der Name \'[_1]\' ist zu lang!',
	'A user can\'t change his/her own username in this environment.' => 'Benutzer kann eigenen Benutzernamen in diesem Kontext nicht ändern.',
	'An errror occurred when enabling this user.' => 'Bei der Aktivierung dieses Benutzerkontos ist ein Fehler aufgetreten',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Ordner \'[_1]\' angelegt von \'[_2]\'',
	'Category \'[_1]\' created by \'[_2]\'' => 'Kategorie \'[_1]\' angelegt von \'[_2]\'',
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Der Ordner \'[_1]\' steht im Konflikt mit einem anderen Ordner. Ordner im gleichen Unterordner müssen unterschiedliche Basenames haben.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Der Kategoriename \'[_1]\' steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien der gleichen Ebene müssen unterschiedliche Namen haben.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Der Kategorie-Basename \'[_1]\' steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien der gleichen Ebene müssen unterschiedliche Basenames haben.',
	'Saving permissions failed: [_1]' => 'Speichern von Rechten fehlgeschlagen: [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Benutzer \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) angelegt von \'[_3]\'',
	'You cannot delete your own association.' => 'Sie können nicht Ihre eigene Verknüpfung löschen.',
	'You cannot delete your own user record.' => 'Sie können nicht Ihr eigenes Benutzerkonto löschen.',
	'You have no permission to delete the user [_1].' => 'Keine Rechte zum Löschen von Benutzer [_1].',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Abonnent \'[_1]\' (ID:[_2]) von \'[_3]\' von Benachrichtigungsliste entfernt',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Benutzer \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Ordner \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Kategorie \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Kommentar (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Eintrag \'[_4]\' gelöscht',
	'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Seite \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Eintrag \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'(Unlabeled category)' => '(Namenlose Kategorie)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Kategorie \'[_4]\' gelöscht',
	'(Untitled entry)' => '(Namenloser Eintrag)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) von \'[_2]\' von \'[_3]\' aus Eintrag \'[_4]\' gelöscht',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Template \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) gelöscht von \'[_3]\'',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Datei \'[_1]\' hochgeladen von \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Datei \'[_1]\' (ID:[_2]) gelöschen von \'[_3]\'',
	'Permisison denied.' => 'Zugriff verweigert.',
	'The Template Name and Output File fields are required.' => 'Die Felder Vorlagennamen und Dateiname sind erforderlich.',
	'Invalid type [_1]' => 'Ungültiger Typ [_1]',
	'Save failed: [_1]' => 'Speichern fehlgeschlagen: [_1]',
	'Saving object failed: [_1]' => 'Speichern des Objekts fehlgeschlagen: [_1]',
	'No Name' => 'Kein Name',
	'Notification List' => 'Mitteilungssliste',
	'IP Banning' => 'IP-Adressen sperren',
	'Can\'t delete that way' => 'Kann so nicht gelöscht werden',
	'Removing tag failed: [_1]' => 'Tag entfernen fehlgeschlagen: [_1]',
	'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'Solange die Kategorie Unterkategorien hat, können Sie die Kategorie nicht löschen.',
	'Loading MT::LDAP failed: [_1].' => 'Laden von MT::LDAP fehlgeschlagen: [_1]',
	'Removing [_1] failed: [_2]' => '[_1] entfernen fehlgeschlagen: [_2]',
	'System templates can not be deleted.' => 'System-Templates können nicht gelöscht werden',
	'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
	'Can\'t load file #[_1].' => 'Kann Datei #[_1] nicht laden.',
	'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' das Vertrauen ausgesprochen',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' gesperrt',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat die Sperre von Kommentarautor \'[_2]\' aufgehoben',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Benutzer \'[_1]\' hat Kommentarautor \'[_2]\' das Vertrauen entzogen',
	'Need a status to update entries' => 'Statusangabe erforderlich',
	'Need entries to update status' => 'Einträge erforderlich',
	'One of the entries ([_1]) did not actually exist' => 'Einer der Einträge ([_1]) ist nicht vorhanden',
	'Entry \'[_1]\' (ID:[_2]) status changed from [_3] to [_4]' => 'Status des Eintrags \'[_1]\' (ID:[_2]) geändert von [_3] in [_4]',
	'You don\'t have permission to approve this comment.' => 'Sie dürfen diesen Kommentar nicht freischalten.',
	'Comment on missing entry!' => 'Kommentar gehört zu fehlendem Eintrag',
	'Commenters' => 'Kommentar- autoren',
	'Orphaned comment' => 'Verwaister Kommentar',
	'Comments Activity Feed' => 'Kommentar-Aktivitätsfeed', # Translate - New # OK
	'Orphaned' => 'Verwaist',
	'Plugin Set: [_1]' => 'Plugin-Set: [_1]',
	'Plugins' => 'Plugins',
	'<strong>[_1]</strong> is &quot;[_2]&quot;' => '<strong>[_1]</strong> ist &quot;[_2]&quot;',
	'TrackBack Activity Feed' => 'TrackBack-Aktivitätsfeed',
	'No Excerpt' => 'Kein Auzzug',
	'No Title' => 'Keine Überschrift',
	'Orphaned TrackBack' => 'Verwaistes TrackBack',
	'category' => 'Kategorie',
	'Category' => 'Kategorie',
	'Tag' => 'Tag',
	'User' => 'Benutzer',
	'Entry Status' => 'Eintragsstatus',
	'[_1] Feed' => '[_1]-Feed',
	'(user deleted - ID:[_1])' => '(Benutzer gelöscht - ID:[_1])',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum \'[_1]\' ungültig; erforderliches Formst ist JJJJ-MM-TT SS:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ungültiges Datum \'[_1]\'; das Datum muss existieren.',
	'Saving entry \'[_1]\' failed: [_2]' => 'Speichern des Eintrags \'[_1]\' fehlgeschlagen: [_2]',
	'Removing placement failed: [_1]' => 'Entfernen der Platzierung fehlgeschlagen: [_1]',
	'Entry \'[_1]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => 'Eintrag \'[_1]\' (ID:[_2]) bearbeitet und Status geändert von [_3] in [_4] von Benutzer \'[_5]\'',
	'Entry \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Eintrag \'[_1]\' (ID:[_2]) bearbeitet von Benutzer \'[_3]\'',
	'No such [_1].' => 'Kein [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Diese Basename wird bereits verwendet. Bitte verwenden Sie einen eindeutigen Basename.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Site Path und URL dieses Weblogs wurden noch nicht konfiguriert. Sie können keine Einträge veröffentlichen, solange das nicht geschehen ist.',
	'Saving [_1] failed: [_2]' => 'Speichern von  [_1] fehlgeschlagen: [_2]',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) hinzugefügt von Benutzer \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) bearbeitet und Status geändert von [_4] in [_5] von Benutzer \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) bearbeitet von Benutzer \'[_4]\'',
	'The [_1] must be given a name!' => '[_1] muss einen Namen erhalten!',
	'Saving blog failed: [_1]' => 'Speichern des Weblogs fehlgeschlagen: [_1]',
	'Invalid ID given for personal blog clone source ID.' => 'Ungültige ID für Klonvorlage für persönliche Weblogs',
	'If personal blog is set, the default site URL and root are required.' => 'Standard-Site URL und Site Root für persönliche Weblogs erforderlich.',
	'Feedback Settings' => 'Feedback-Einstellungen',
	'Build error: [_1]' => 'Build-Fehler: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Kann Vorschaudatei in [_1] nicht erzeugen.', # Translate - New # OK
	'New [_1]' => 'Neuer [_1]',
	'Rebuild Site' => 'Neu aufbauen',
	'index template \'[_1]\'' => 'Indextemplate \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'No permissions' => 'Keine Berechtigung',
	'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' fehlgeschlagen: [_2]',
	'Create New Role' => 'Neue Rolle anlegen',
	'Role name cannot be blank.' => 'Rollenname erforderlich',
	'Another role already exists by that name.' => 'Rolle mit diesem Namen bereits vorhanden',
	'You cannot define a role without permissions.' => 'Rollen ohne Zugriffsrechte nicht möglich',
	'No such entry \'[_1]\'' => 'Kein Eintrag \'[_1]\'',
	'No email address for user \'[_1]\'' => 'Keine Email-Addresse für Benutzer \'[_1]\'',
	'No valid recipients found for the entry notification.' => 'Keine gültigen Empfänger für Benachrichtigungen gefunden.',
	'[_1] Update: [_2]' => '[_1] Update: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen([_1]). Überprüfen Sie die MailTransfer-Einstellungen.',
	'Archive Root' => 'Archiv-Root',
	'Site Root' => 'Site-Root',
	'Can\'t load blog #[_1].' => 'Kann Blog #[_1] nicht laden.',
	'You did not choose a file to upload.' => 'Bitte wählen Sie eine Datei aus.',
	'Before you can upload a file, you need to publish your blog.' => 'Bevor Sie eine Datei hochladen können, müssen Sie das Blog zuerst veröffentlichen.',
	'Invalid extra path \'[_1]\'' => 'Ungültiger Zusatzpfad \'[_1]\'',
	'Can\'t make path \'[_1]\': [_2]' => 'Kann Pfad \'[_1]\' nicht anlegen: [_2]',
	'Invalid temp file name \'[_1]\'' => 'Ungültiger temporärer Dateiname \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von \'[_1]\': [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von \'[_1]\': [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Es ist bereits eine Datei namens \'[_1]\' vorhanden. (Um bereits vorhandene hochgeladene Dateien überschreiben zu können, installieren Sie File::Temp.)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Fehler beim Anlegen der temporären Datei. Bitte überprüfen Sie, ob das in der Konfigurationsdatei eingestellte TempDir (derzeit \'[_1]\') beschreibbar ist.', # Translate - New # OK
	'unassigned' => 'nicht vergeben',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Es ist bereits eine Datei namens \'[_1]\' vorhanden. Öffnen der angelegten temporären Datei fehlgeschlagen: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Upload in \'[_1]\' speichern fehlgeschlagen: [_2]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Das Perl-Modul Image::Size ist zur Bestimmung von Höhe und Breite hochgeladener Bilddateien erforderlich.',
	'Search & Replace' => 'Suchen & Ersetzen',
	'Assets' => 'Assets',
	'Logs' => 'Logs',
	'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe',
	'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
	'Saving object failed: [_2]' => 'Speichern des Objekts fehlgeschlagen: [_2]',
	'You do not have export permissions' => 'Keine Export-Rechte',
	'You do not have permission to create users' => 'Keine Rechte zum Anlegen neuer Benutzer',
	'Importer type [_1] was not found.' => 'Import-Typ [_1] nicht gefunden.',
	'Saving map failed: [_1]' => 'Speichern der Verknüpfung fehlgeschlagen: [_1]',
	'Add a [_1]' => '[_1] hinzufügen',
	'No label' => 'Kein Label',
	'Category name cannot be blank.' => 'Der Name einer Kategorie darf nicht leer sein.',
	'Populating blog with default templates failed: [_1]' => 'Standard-Templates konnten nicht geladen werden: [_1]',
	'Setting up mappings failed: [_1]' => 'Anlegen der Verknüpfung fehlgeschlagen: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache-Ordner schreiben. Bitte überprüfen Sie die Rechte für den Ordner <code>[_1]</code> in Ihrem Weblog-Verzeichnis.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type konnte kein Verzeichnis zur Zwischenspeicherung Ihrer dynamischen Vorlagen anlegen. Legen Sie daher manuell einen Ordner namens <code>[_1]</code> in Ihrem Weblog-Verzeichnis an.',
	'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) offenbar nicht implementiert!',
	'entry' => 'Eintrag',
	'Error saving entry: [_1]' => 'Speichern des Eintrags fehlgeschlagen: [_1]',
	'Select Blog' => 'Weblog wählen',
	'Selected Blog' => 'Gewähltes Weblog',
	'Type a blog name to filter the choices below.' => 'Geben Sie einen Blognamen ein, um die Auswahl einzuschränken.',
	'Blog Name' => 'Weblog-Name',
	'Select a System Administrator' => 'Systemadministrator wählen',
	'Selected System Administrator' => 'Gewählter Systemadministrator',
	'Type a username to filter the choices below.' => 'Benutzernamen eingeben um Auswahl einzuschränken',
	'Error saving file: [_1]' => 'Fehler beim Speichern der Datei: [_1]',
	'represents a user who will be created afterwards' => 'steht für ein Benutzerkonto, das später angelegt werden wird',
	'Select Blogs' => 'Weblogs auswählen',
	'Blogs Selected' => 'Ausgewählte Weblogs',
	'Select Users' => 'Gewählte Benutzer',
	'Username' => 'Benutzername',
	'Users Selected' => 'Gewählte Benutzer',
	'Select Groups' => 'Gruppen auswählen',
	'Group Name' => 'Gruppenname',
	'Groups Selected' => 'Gewählte Gruppen',
	'Type a group name to filter the choices below.' => 'Gruppennamen eingeben um Auswahl einzuschränken',
	'Select Roles' => 'Rollen auswählen',
	'Role Name' => 'Rollenname',
	'Roles Selected' => 'Gewählte Rollen',
	'' => '', # Translate - New # OK
	'Create an Association' => 'Verknüpfung anlegen',
	'Backup' => 'Backup',
	'Backup & Restore' => 'Sichern & Wiederherstellen',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Durchführung der Sicherung beschreibbar sein. Bitte überprüfen Sie Ihre TempDir-Einstellung.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Durchführung der Wiederherstellung beschreibbar sein. Bitte überprüfen Sie Ihre TempDir-Einstellung.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Weblog(s) (ID:[_1]) erfolgreich gesichert von Benutzer \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type-System erfolgreich gesichert von Benutzer \'[_1]\'',
	'You must select what you want to backup.' => 'Sie müssen auswählen, was gesichert werden soll.',
	'[_1] is not a number.' => '[_1] ist keine Zahl.',
	'Choose blogs to backup.' => 'Zu sichernde Blogs wählen',
	'Archive::Tar is required to archive in tar.gz format.' => 'Archive::Tar ist für Sicherungen im tar.gz-Format erforderlich.',
	'IO::Compress::Gzip is required to archive in tar.gz format.' => 'IO::Compress::Gzip ist für Sicherungen im tar.gz-Format erforderlich.',
	'Archive::Zip is required to archive in zip format.' => 'Archive::Zip ist für Sicherungen im ZIP-Format erfoderlich.',
	'Specified file was not found.' => 'Angegebene Datei nicht gefunden.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] hat Sicherungsdatei erfolgreich heruntergeladen ([_2])',
	'Restore' => 'Wiederherstellen',
	'Required modules (Archive::Tar and/or IO::Uncompress::Gunzip) are missing.' => 'Erforderliche Module (Archive::Tar und/oder IO::Uncompress::Gunzip) nicht vorhanden.',
	'Uploaded file was invalid: [_1]' => 'Die hochgeladene Datei ist ungültig: [_1]',
	'Required module (Archive::Zip) is missing.' => 'Erforderliches Modul Archive::Zip fehlt.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Bitte verwenden Sie xml, tar.gz, zip, oder manifest als Dateierweiterung.',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Einige [_1] wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">activity log</a>.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden. Details finden Sie im <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Aktivitätsprotokoll</a>.', # Translate - New # OK
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Objekte erfolgreich wiederhergestellt von Benutzer \'[_1]\'',
	'[_1] is not a directory.' => '[_1] ist kein Verzeichnis.',
	'Error occured during restore process.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten.',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of files could not be restored.' => 'Einige Dateien konnten nicht wiederhergestellt werden.',
	'Please upload [_1] in this page.' => 'Bitte laden Sie [_1] in diese Seite hoch.',
	'File was not uploaded.' => 'Datei wurde nicht hochgeladen.',
	'Restoring a file failed: ' => 'Wiederherstellung einer Datei fehlgeschlagen: ',
	'Some objects were not restored because their parent objects were not restored.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',
	'Some of the files were not restored correctly.' => 'Einige Daten wurden nicht korrekt wiederhergestellt.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Details finden Sie im <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Aktivitätsprotokoll</a>.', # Translate - New # OK
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] hat die Vorgang zur Wiederherstellung mehrerer Dateien vorzeitig abgebrochen.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Ändere Site Path für Weblog\'[_1]\' (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Entferne Site Path für Weblog \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Ändere Archive Path für Weblog \'[_1]\' (ID:[_2])...', # Translate - New # OK
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Entferne Archive Path für Weblog \'[_1]\' (ID:[_2])...', # Translate - New # OK
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Asset \'[_1]\' (ID:[_2])...',
	'Some of the actual files for assets could not be restored.' => 'Einige Assetdateien konnten nicht wiederhergestellt werden.',
	'Parent comment id was not specified.' => 'ID des Elternkommentars nicht angegeben.',
	'Parent comment was not found.' => 'Elternkommentar nicht gefunden.',
	'You can\'t reply to unapproved comment.' => 'Sie können auf nicht freigegebene Kommentare nicht antworten.',
	'entries' => 'Einträge',
	'Publish Entries' => 'Einträge veröffentlichen',
	'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
	'Add Tags...' => 'Tags hinzufügen...',
	'Tags to add to selected entries' => 'Zu gewählten Einträgen hinzuzufügende Tags',
	'Remove Tags...' => 'Tags entfernen...',
	'Tags to remove from selected entries' => 'Von den gewählten Einträgen zu entfernende Tags',
	'Batch Edit Entries' => 'Mehrere Einträge bearbeiten', # Translate - New # OK
	'Publish Pages' => 'Seiten veröffentlichen', # Translate - New # OK
	'Unpublish Pages' => 'Seiten nicht mehr veröffentlichen', # Translate - New # OK
	'Tags to add to selected pages' => 'Zu gewählten Seiten hinzuzufügende Tags', # Translate - New # OK
	'Tags to remove from selected pages' => 'Von gewählten Seiten zu entfernende Tags', # Translate - New # OK
	'Batch Edit Pages' => 'Mehrere Seiten bearbeiten', # Translate - New # OK
	'Tags to add to selected assets' => 'Zu gewählten Assets hinzuzufügende Tags', # Translate - New # OK
	'Tags to remove from selected assets' => 'Von gewählten Assets zu entfernende Tags', # Translate - New # OK
	'Unpublish TrackBack(s)' => 'TrackBacks nicht mehr veröffentlichen',
	'Unpublish Comment(s)' => 'Kommentare nicht mehr veröffentlichen',
	'Trust Commenter(s)' => 'Kommentarautoren vertrauen',
	'Untrust Commenter(s)' => 'Kommentarautoren nicht mehr vertrauen',
	'Ban Commenter(s)' => 'Kommentarautoren sperren',
	'Unban Commenter(s)' => 'Kommentatorsperre aufheben',
	'Recover Password(s)' => 'Passwort anfordern',
	'Delete' => 'Löschen',
	'Published entries' => 'Veröffentlichte Einträge', # Translate - New # OK
	'Unpublished entries' => 'Nicht veröffentlichte Einträge', # Translate - New # OK
	'Scheduled entries' => 'Zeitgeplante Einträge', # Translate - New # OK
	'My entries' => 'Meine Einträge', # Translate - New # OK
	'Entries with comments in the last 7 days' => 'Einträge mit Kommentare in den letzten 7 Tagen', # Translate - New # OK
	'All Non-Spam Comments' => 'Alle Kommentare, die nicht Spam sind', # Translate - New # OK
	'Comments on my posts' => 'Kommentare zu meinen Einträgen', # Translate - New # OK
	'Comments marked as spam' => 'Als Spam markierte Kommentare', # Translate - New # OK
	'Unpublished comments' => 'Nicht veröffentlichte Kommentare', # Translate - New # OK
	'Published comments' => 'Veröffentlichte Kommentare', # Translate - New # OK
	'My comments' => 'Meine Kommentare', # Translate - New # OK
	'All comments in the last 7 days' => 'Alle Kommentare der letzten 7 Tage', # Translate - New # OK
	'All comments in the last 24 hours' => 'Alle Kommentare der letzten 24 Stunden', # Translate - New # OK
	'Create' => 'Neu',
	'Manage' => 'Verwalten', # Translate - New # OK
	'Design' => 'Gestalten', # Translate - New # OK
	'Preferences' => 'Einstellungen',
	'Admin' => 'Administrieren', # Translate - New # OK
	'Styles' => 'Styles', # Translate - New # OK
	'Blog Settings' => 'Blog-Einstellungen', # Translate - New # OK
	'Members' => 'Mitglieder',
	'Notifications' => 'Mitteilungen',
	'Tools' => 'Tools', # Translate - New # OK
	'/' => '/', # Translate - New # OK
	'<' => '<', # Translate - New # OK

## lib/MT/App/Viewer.pm
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

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
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
	'Movable Type System Activity' => 'Movable Type Systemaktivität',
	'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',

## lib/MT/App/Search.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'Suche wird ausgeführt. Bitte warten Sie, bis Ihre Anfrage abgeschlossen ist.',
	'Search failed. Invalid pattern given: [_1]' => 'Suche fehlgeschlagen - ungültiges Suchmuster angegeben: [_1]',
	'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'Kein alternatives Template für das Template \'[_1]\' angegeben',
	'Opening local file \'[_1]\' failed: [_2]' => 'Öffnen der lokalen Datei \'[_1]\' fehlgeschlagen: [_2]',
	'Building results failed: [_1]' => 'Ergebnisausgabe fehlgeschlagen: [_1]',
	'Search: query for \'[_1]\'' => 'Suche nach \'[_1]\'',
	'Search: new comment search' => 'Suche nach neuen Kommentaren',

## lib/MT/App/Trackback.pm
	'You must define a Ping template in order to display pings.' => 'Sie müssen ein Ping-Template definieren, um Pings anzeigen zu können.',
	'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
	'Need a TrackBack ID (tb_id).' => 'Benötige TrackBack ID (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'Sie dürfen keine TrackBack-Pings senden.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Sie senden zu viele TrackBacks zu schnell hintereinander.',
	'Need a Source URL (url).' => 'Quelladresse erforderlich (url).',
	'This TrackBack item is disabled.' => 'TrackBack hier nicht aktiv.',
	'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack für Kategorie \'[_1]\' (ID:[_2])',
	'Can\'t create RSS feed \'[_1]\': ' => 'RSS-Feed kann nicht angelegt werden \'[_1]\': ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Neuer TrackBack-Ping bei Eintrag [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Neuer TrackBack-Ping bei Kategorie [_1] ([_2])',

## lib/MT/FileMgr/Local.pm
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Umbenennen von \'[_1]\' in \'[_2]\' fehlgeschlagen: [_3]',
	'Deleting \'[_1]\' failed: [_2]' => 'Löschen von \'[_1]\' fehlgeschlagen: [_2]',

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP-Verbindung fehlgeschlagen: [_1]',
	'SFTP get failed: [_1]' => 'SFTP-"get" fehlgeschlagen: [_1]',
	'SFTP put failed: [_1]' => 'SFTP-"put" fehlgeschlagen: [_1]',
	'Creating path \'[_1]\' failed: [_2]' => 'Anlegen des Ordners \'[_1]\' fehlgeschlagen: [_2]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV-Verbindung fehlgeschlagen: [_1]',
	'DAV open failed: [_1]' => 'DAV-"open" fehlgeschlagen: [_1]',
	'DAV get failed: [_1]' => 'DAV-"get" fehlgeschlagen: [_1]',
	'DAV put failed: [_1]' => 'DAV-"put" fehlgeschlagen: [_1]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',

## lib/MT/Blog.pm
	'First Blog' => 'Erstes Blog',
	'No default templates were found.' => 'Keine Standardtemplates gefunden.',
	'Cloned blog... new id is [_1].' => 'Blog geklont... Die neue ID lautet: [_1]',
	'Cloning permissions for blog:' => 'Klone Berechtigungen für Webblog:',
	'[_1] records processed...' => '[_1] Einträge bearbeitet...',
	'[_1] records processed.' => '[_1] Einträge bearbeitet.',
	'Cloning associations for blog:' => 'Klone Verknüpfungen für Weblog:',
	'Cloning entries for blog...' => 'Klone Einträge für Weblog...',
	'Cloning categories for blog...' => 'Klone Kategorien für Weblog...',
	'Cloning entry placements for blog...' => 'Klone Eintragsplatzierung für Weblog...',
	'Cloning comments for blog...' => 'Klone Kommentare für Weblog...',
	'Cloning entry tags for blog...' => 'Klone Tags für Weblog...',
	'Cloning TrackBacks for blog...' => 'Klone TrackBacks für Weblog...',
	'Cloning TrackBack pings for blog...' => 'Klone TrackBack-Pings für Weblog...',
	'Cloning templates for blog...' => 'Klone Vorlagen für Weblog...',
	'Cloning template maps for blog...' => 'Klone Template Maps für Weblog...',

## lib/MT/Upgrade.pm
	'Migrating Nofollow plugin settings...' => 'Migriere Nofollow-Einstellunge...', # Translate - New # OK
	'Updating system search template records...' => 'Aktualisiere Suchvorlagen...', # Translate - New # OK
	'Custom ([_1])' => 'Individuelle ([_1])', # Translate - Improved (1) # OK
	'This role was generated by Movable Type upon upgrade.' => 'Diese Rolle wurde von Movable Type während eines Upgrades angelegt.', # Translate - Improved (1) # OK
	'Migrating permission records to new structure...' => 'Migriere Benutzerrechte in neue Struktur...', # Translate - New # OK
	'Migrating role records to new structure...' => 'Migriere Rollen in neue Struktur...', # Translate - New # OK
	'Migrating system level permissions to new structure...' => 'Migriere Systemberechtigigungen in neue Struktur...', # Translate - New # OK
	'Invalid upgrade function: [_1].' => 'Ungültige Upgrade-Funktion: [_1].',
	'Error loading class [_1].' => 'Fehler beim Laden der Klasse [_1].', # Translate - New # OK
	'Creating initial blog and user records...' => 'Erzeuge erstes Blog und Benutzerkonten...', # Translate - New # OK
	'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
	'Removing Dynamic Site Bootstrapper index template...' => 'Entferne Indexvorlage des Dynamic Site Bootstrappers...', # Translate - New # OK
	'Fixing binary data for Microsoft SQL Server storage...' => 'Bereite Binärdaten für Speicherung in Microsoft SQL Server vor...', # Translate - New # OK
	'Creating new template: \'[_1]\'.' => 'Erzeuge neue Vorlage: \'[_1]\'', # Translate - Improved (3) # OK
	'Mapping templates to blog archive types...' => 'Verknüpfe Vorlagen mit Archiven...', # Translate - Improved (1) # OK
	'Renaming php plugin file names...' => 'Ändere PHP-Plugin-Dateinamen...', # Translate - New # OK
	'Error opening directory: [_1].' => 'Fehler beim Öffnen eines Ordners: [_1]', # Translate - New # OK
	'Error rename php files. Please check the Activity Log' => 'Fehler beim Umbennnen von PHP-Dateien. Bitte überprüfen Sie das Aktivitätsprotokoll.', # Translate - New # OK
	'Cannot rename in [_1]: [_2].' => 'Kann [_1] nicht in [_2] umbennen.', # Translate - New # OK
	'Upgrading table for [_1]' => 'Initialisiere Tabelle [_1]',
	'Upgrading database from version [_1].' => 'Upgrade Datenbank von Version [_1]',
	'Database has been upgraded to version [_1].' => 'Datenbank auf Movable Type-Version [_1] aktualisiert',
	'User \'[_1]\' upgraded database to version [_2]' => 'Benutzer \'[_1]\' hat ein Upgrade auf Version [_2] durchgeführt',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' erfolgreich auf Version [_2] (Schemaversion [_3]) aktualisiert.', # Translate - New # OK
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Benutzer \'[_1]\' hat für Plugin \'[_2]\' ein Upgrade auf Version [_3] (Schemaversion [_4]) durchgeführt.',
	'Plugin \'[_1]\' installed successfully.' => 'Plugin \'[_1]\' erfolgreich installiert.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Benutzer \'[_1]\' hat Plugin \'[_2]\' mit Version [_3] (Schema version [_4]) installiert.',
	'Setting your permissions to administrator.' => 'Setze Benutzerrechte auf \'Administrator\'...',
	'Creating configuration record.' => 'Lege Konfiguration ab...',
	'Creating template maps...' => 'Verknüpfe Templates...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Template-ID [_1] mit [_2] ([_3])',
	'Mapping template ID [_1] to [_2].' => 'Verknüpfe Template-ID [_1] mit [_2]',
	'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1].',
	'Creating entry category placements...' => 'Lege Kategoriezuweisungen an...',
	'Updating category placements...' => 'Aktualisiere Kategorieanordnung...',
	'Assigning comment/moderation settings...' => 'Weise Kommentierungseinstellungen zu...',
	'Setting blog basename limits...' => 'Setze Basename-Limits...',
	'Setting default blog file extension...' => 'Setze Standard-Dateierweitung...',
	'Updating comment status flags...' => 'Aktualisiere Kommentarstatus...',
	'Updating commenter records...' => 'Aktualisiere Kommentarautoren-Datensätze...',
	'Assigning blog administration permissions...' => 'Weise Administrationsrechte zu...',
	'Setting blog allow pings status...' => 'Weise Ping-Status zu...',
	'Updating blog comment email requirements...' => 'Aktualisere Email-Einstellungen der Kommentarfunktion...',
	'Assigning entry basenames for old entries...' => 'Weise Alteinträgen Basenames zu...',
	'Updating user web services passwords...' => 'Aktualisierte Passwörter für Web Services...',
	'Updating blog old archive link status...' => 'Aktualisiere Linkstatus der Alteinträge...',
	'Updating entry week numbers...' => 'Aktualisiere Wochendaten...',
	'Updating user permissions for editing tags...' => 'Weise Nutzerrechte für Tag-Verwaltung zu...',
	'Setting new entry defaults for blogs...' => 'Setze Standardwerte für neue Einträge...', # Translate - New # OK
	'Migrating any "tag" categories to new tags...' => 'Migriere "Tag"-Kategorien zu neuen Tags...',
	'Assigning custom dynamic template settings...' => 'Weise benutzerspezifische Einstellungen für dynamische Templates zu...',
	'Assigning user types...' => 'Weise Benutzerkontenarten zu...',
	'Assigning category parent fields...' => 'Weise Elternkategorien zu...',
	'Assigning template build dynamic settings...' => 'Weise dynamische Einstellungen für Template-Aufbau zu...',
	'Assigning visible status for comments...' => 'Setzte Sichtbarkeitsstatus für Kommentare...',
	'Assigning junk status for comments...' => 'Setze Junk-Status der Kommentare...',
	'Assigning visible status for TrackBacks...' => 'Setzte Sichtbarkeitsstatus für TrackBacks...',
	'Assigning junk status for TrackBacks...' => 'Setze Junk-Status der TrackBacks...',
	'Assigning basename for categories...' => 'Weise Kategorien Basenames zu...',
	'Assigning user status...' => 'Weise Benuzerstatus zu...',
	'Migrating permissions to roles...' => 'Migriere Zugriffsrechte auf Rollen...',
	'Populating authored and published dates for entries...' => 'Übernehme Zeitstempel für Einträge...', # Translate - New # OK

## lib/MT/Plugin.pm

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Fehlerhafe AuthenticationModule-Konfiguration \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Fehlerhafe AuthenticationModule-Konfiguration',

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'Tag muss einen gültigen Namen haben',
	'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.',

## lib/MT/Builder.pm
	'<[_1]> at line # is unrecognized.' => '<[_1]> in Zeile # nicht erkannt.', # Translate - New # OK
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> in Zeile [_2] nicht erkannt.', # Translate - New # OK
	'<[_1]> with no </[_1]> on line #' => '<[_1]> ohne </[_1]> in Zeile #', # Translate - New # OK
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> ohne  </[_1]> in Zeile[_2]', # Translate - New # OK
	'Error in <mt:[_1]> tag: [_2]' => 'Fehler in <mt:[_1]>-Tag: [_2]',
	'No handler exists for tag [_1]' => 'Kein Handler für Tag [_1] verfügbar',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
	'Category loop detected' => 'Kategorieschleife festgestellt',

## lib/MT/Template.pm
	'File not found: [_1]' => 'Datei nicht gefunden: [_1]',
	'Parse error in template \'[_1]\': [_2]' => 'Parsing-Fehler im Template \'[_1]\': [_2]',
	'Build error in template \'[_1]\': [_2]' => 'Build-Fehler im Template \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Es ist bereits eine Vorlage mit gleichem Namen in diesem Weblog vorhanden.',
	'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Öffenen der verlinkten Datei \'[_1]\' fehlgeschlagen: [_2]',

## lib/MT/Entry.pm

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.movabletype.org/sitede',
	'OpenID URL' => 'OpenID-URL', # Translate - New # OK
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID ist ein offenes und dezentrales Single Sign On-System', # Translate - New # OK
	'Sign In' => 'Anmelden', # Translate - Case # OK
	'Learn more about OpenID.' => 'Mehr über OpenID erfahren', # Translate - New # OK
	'Your LiveJournal Username' => 'Ihr LiveJournal-Benutzername', # Translate - New # OK
	'Sign in using your LiveJournal username.' => 'Mit LiveJournal-Benutzername anmeldem', # Translate - New # OK
	'Learn more about LiveJournal.' => 'Mehr über LiveJournal erfahren', # Translate - New # OK
	'Your Vox Blog URL' => 'Ihre Vox-Blog-URL', # Translate - New # OK
	'Sign in using your Vox blog URL' => 'Mit Vox-Blog-URL anmelden', # Translate - New # OK
	'Learn more about Vox.' => 'Mehr über Vox erfahren', # Translate - New # OK
	'TypeKey is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypeKey ist ein offenes, kostenloses Identitätssystem zum Verfassen von Kommentaren in Weblogs und zur Anmeldung an anderen Websites. Melden Sie sich kostenlos an.', # Translate - New # OK
	'Sign in or register with TypeKey.' => 'Mit TypeKey anmelden oder Konto anlegen', # Translate - New # OK
	'Hello, world' => 'Hallo, Welt',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Message: [_1]' => 'Nachricht: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Falls vorhanden, muss das drite Argument von add_callback ein MT::Component-Objekt oder ein MT::Plugin sein', # Translate - New # OK
	'4th argument to add_callback must be a CODE reference.' => 'Viertes Argument von add_callback muss eine CODE-Referenz sein.',
	'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins',
	'Invalid priority level [_1] at add_callback' => 'Ungültiger Prioritätslevel [_1] von add_callback',
	'Unnamed plugin' => 'Plugin ohne Namen',
	'[_1] died with: [_2]' => '[_1] abgebrochen mit [_2]',
	'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen',
	'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Keine Konfigurationsdatei gefunden. Möglicherweise haben Sie vergessen, mt-config.cgi-original in mt-config.cgi umzubennen.',
	'Plugin error: [_1] [_2]' => 'Plugin-Fehler: [_1] [_2]',
	'OpenID' => 'OpenID', # Translate - New # OK
	'LiveJournal' => 'LiveJournal', # Translate - New # OK
	'Vox' => 'Vox', # Translate - New # OK
	'TypeKey' => 'TypeKey', # Translate - New # OK
	'Movable Type default' => 'Movable Type-Standard', # Translate - New # OK
	'Wiki' => 'Wiki', # Translate - New # OK

## lib/MT.pm.pre

## mt-static/js/edit.js
	'Enter email address:' => 'Email-Adresse eingeben:',

## mt-static/js/dialog.js
	'(None)' => '(Keine)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Vorschau nicht verfügbar', # Translate - New # OK
	'Click to see uploaded file.' => 'Hochgeladene Datei ansehen', # Translate - New # OK

## mt-static/mt.js
	'to delete' => 'zu löschen',
	'to remove' => 'zu entfernen',
	'to enable' => 'zu aktivieren',
	'to disable' => 'zu deaktivieren',
	'delete' => 'löschen',
	'remove' => 'entfernen',
	'You did not select any [_1] to [_2].' => 'Keine [_1] ausgewählt für [_2].',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Rolle wirklich entfernen? Entfernen der Rolle enzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Zugriffsrechte.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '[_1] Rolle(n) wirklich entfernen? Entfernen der Rollen enzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Zugriffsrechte.',
	'Are you sure you want to [_2] this [_1]?' => '[_1] wirklich [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Die [_1] ausgewählten [_2] wirklich [_3]?',
	'You did not select any [_1] to remove.' => 'Keine [_1] zum Entfernen ausgewählt.',
	'Are you sure you want to remove this [_1] from this group?' => 'Diese [_1] wirklich aus der Gruppe löschen?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => 'Die [_1] ausgewählten [_2] wirklich aus der Gruppe löschen?',
	'Are you sure you want to remove this [_1]?' => '[_1] wirklich entfernen?',
	'Are you sure you want to remove the [_1] selected [_2]?' => 'Die [_1] ausgewählten [_2] wirklich entfernen?',
	'enable' => 'aktivieren',
	'disable' => 'deaktivieren',
	'You did not select any [_1] [_2].' => 'Sie haben keine [_1] zu [_2] gewählt',
	'You can only act upon a minimum of [_1] [_2].' => 'Nur möglich für mindestens [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Nur möglich für höchstens [_1] [_2].',
	'You must select an action.' => 'Bitte wählen Sie zunächst eine Aktion.',
	'to mark as junk' => 'zum Junk markieren',
	'to remove "junk" status' => 'zum "Junk"-Status zurücksetzen',
	'Enter URL:' => 'URL eingeben:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Der Tag \'[_2]\' ist bereits vorhanden. Soll \'[_1]\' wirklich mit \'[_2]\' zusammengeführt werden?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Der Tag \'[_2]\' ist bereits vorhanden. Soll \'[_1]\' wirklich in allen Weblogs mit \'[_2]\' zusammengeführt werden?',
	'Loading...' => 'Lade...',
	'Showing: [_1] &ndash; [_2] of [_3]' => 'Zeige: [_1] &ndash; [_2] von [_3]',
	'Showing: [_1] &ndash; [_2]' => 'Zeige: [_1] &ndash; [_2]',
	' [_1]Erneut veröffentlichen[_2] um Änderungen wirksam werden zu lassen.' => '', # Translate - New # OK

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]', # Translate - New # OK

## php/lib/function.mtcommentfields.php

## php/lib/block.mtentries.php

## php/lib/function.mtremotesigninlink.php

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php

## plugins/GoogleSearch/tmpl/config.tmpl
	'Google API Key' => 'Google API-Schlüssel', # Translate - New # OK
	'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Um eine der API-Funktionen von Google nutzen zu können, benötigen Sie einen Google API-Schlüssel. Geben Sie diesen hier ein.',

## plugins/GoogleSearch/GoogleSearch.pl
	'You used [_1] without a query.' => '[_1] ohne Suchanfrage verwendet.',
	'You need a Google API key to use [_1]' => 'Für [_1] wird ein Google API-Schlüssel benötigt',
	'You used a non-existent property from the result structure.' => 'Nicht vorhandene Eigenschaft der Ergebnisstruktur verwendet.',

## plugins/feeds-app-lite/tmpl/header.tmpl
	'Main Menu' => 'Hauptmenü',
	'System Overview' => 'Systemeinstellungen',
	'Help' => 'Hilfe',
	'Welcome' => 'Willkommen',
	'Logout' => 'Abmelden',
	'Search (q)' => 'Suche (q)',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widget Creator',
	'Feed Configuration' => 'Feed-Konfiguration',
	'Feed URL' => 'Feed-URL',
	'Title' => 'Titel',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Vergeben Sie einen Namen für das Widget. Dieser Name wird auch als Name des Feeds in Ihrem Blog angezeigt werden.',
	'Display' => 'Zeige',
	'Select the maximum number of entries to display.' => 'Anzahl der Einträge, die höchstens angezeigt werden sollen.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Alle',
	'Save' => 'Speichern',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Es wurden mehrere Feeds gefunden. Wählen Sie den Feed aus, den Sie verwenden wollen. Feeds.App Lite unterstützt Textfeeds in den Formaten RSS 1.0, RSS 2.0 und ATOM.',
	'Type' => 'Typ',
	'URI' => 'URI',
	'Continue' => 'Weiter',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite erzeugt Template-Module, die externe Feed-Daten in Ihren Blogs anzeigen. Legen Sie zuerst die Module an und binden Sie sie dann in Ihre Blog-Templates ein.',
	'You must enter an address to proceed' => 'Geben Sie eine Adresse (URL) ein',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Geben Sie die URL eines Feeds oder einer Website, die Feeds anbietet, ein:',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1].' => 'Keine Feeds mit [_1] gefunden.',
	'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Fehler beim Einlesen von [_1]. Beachten Sie die <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">Hinweise des Feed Validators</a> und versuchen Sie es ggf. erneut.',
	'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Herzlichen Glückwunsch! Das Widget <strong>[_1]</strong> wurde erfolgreich angelegt. Sie können seine Anzeigeoptionen weiter <a href="[_2]">anpassen</a>.',
	'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Um das Widget in Ihren Blog einzufügen, benutzen Sie bitte den <a href="[_1]">Widget Manager</a> oder diesen MTInclude-Tag:',
	'It can be included onto your published blog using this MTInclude tag' => 'Sie können es mit diesem MTInclude-Tag in Ihr Blog integrieren',
	'Create Another' => 'Weiteres Widget anlegen',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Mit Feeds.App Lite können Sie Feeds in Ihre Blogs integrieren. Noch mehr Möglichkeiten erhalten Sie durch ein',
	'Upgrade to Feeds.App' => 'Upgrade auf Feeds.App',
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' ist ein erforderliches Argument von [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] außerhalb seines Kontexts verwendet.',

## plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Beim Einlesen von [_1] ist ein Fehler aufgetreten (zurückgegebener HTTP-Status: [_2]). Es wird die zuletzt erfolgreich eingelesene Version des Feeds verwendet. ', # Translate - New # OK
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'eim Einlesen von [_1] ist ein Fehler aufgetreten (zurückgegebener HTTP-Status: [_2]). Es liegt keine vorherige Version des Feeds vor.', # Translate - New # OK

## plugins/Textile/textile2.pl
	'Textile 2' => 'Textile 2', # Translate - New # OK

## plugins/Markdown/SmartyPants.pl
	'Markdown With SmartyPants' => 'Markdown mit SmartyPants', # Translate - New # OK

## plugins/Markdown/Markdown.pl
	'Markdown' => 'Markdown', # Translate - New # OK

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend you to <a href=\'[_1]\'>configure your weblog\'s publishing paths</a> first.' => 'Bevor Sie WordPress-Einträge in Movable Type importieren, sollten Sie zuerst die <a href=\'[_1]\'>Veröffentlichungspfade Ihres Weblogs einstellen</a>.', # Translate - New # OK
	'Upload path for this WordPress blog' => 'Uploadpfad für dieses WordPress-Blog', # Translate - New # OK
	'Replace with' => 'Ersetzen durch', # Translate - New # OK

## plugins/WXRImporter/WXRImporter.pl
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)', # Translate - New # OK

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Datei ist nicht im WXR-Format.',
	'Saving asset (\'[_1]\')...' => 'Speichere Asset (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' und Asset wird mit (\'[_1]\') getaggt werden...',
	'Saving page (\'[_1]\')...' => 'Speichere Seite (\'[_1]\')...',

## plugins/TemplateRefresh/tmpl/results.tmpl
	'Backup and Refresh Templates' => 'Templates sichern und erneuern',
	'No templates were selected to process.' => 'Keine Templates gewählt.',
	'Return' => 'Zurück',

## plugins/TemplateRefresh/TemplateRefresh.pl
	'Error loading default templates.' => 'Laden der Standard-Templates fehlgeschlagen.',
	'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Keine Rechte zur Bearbeitung der Vorlagen von Weblog \'[_1]\'',
	'Processing templates for weblog \'[_1]\'' => 'Verarbeite Templates von \'[_1]\'',
	'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Baue Vorlage \'[_3]\' neu auf (mit <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">Backup</a>)',
	'Refreshing template \'[_1]\'.' => 'Baue Template \'[_1]\' neu auf',
	'Error creating new template: ' => 'Fehler beim Anlegen der neuen Vorlage ',
	'Created template \'[_1]\'.' => 'Vorlage \'[_1]\' angelegt.',
	'Insufficient permissions for modifying templates for this weblog.' => 'Unzureichende Benutzerrechte für die Bearbeitung von Templates',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Überspringe Template \'[_1]\', da es ein Custom Template zu sein scheint.',
	'Refresh Template(s)' => 'Template(s) neu aufbauen',

## plugins/ExtensibleArchives/DatebasedCategories.pl
	'CATEGORY-YEARLY_ADV' => 'CATEGORY-YEARLY_ADV',
	'CATEGORY-MONTHLY_ADV' => 'CATEGORY-MONTHLY_ADV',
	'CATEGORY-DAILY_ADV' => 'CATEGORY-DAILY_ADV',
	'CATEGORY-WEEKLY_ADV' => 'CATEGORY-WEEKLY_ADV',
	'category/sub_category/yyyy/index.html' => 'kategorie/unter_kategorie/jjjj/index.html', # Translate - New # OK
	'category/sub-category/yyyy/index.html' => 'kategorie/unter-kategorie/jjjj/index.html', # Translate - New # OK
	'category/sub_category/yyyy/mm/index.html' => 'kategorie/unter_kategorie/jjjj/mm/index.html', # Translate - New # OK
	'category/sub-category/yyyy/mm/index.html' => 'kategorie/unter-kategorie/jjjj/mm/index.html', # Translate - New # OK
	'category/sub_category/yyyy/mm/dd/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tt/index.html', # Translate - New # OK
	'category/sub-category/yyyy/mm/dd/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tt/index.html', # Translate - New # OK
	'category/sub_category/yyyy/mm/day-week/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tag-woche/index.html', # Translate - New # OK
	'category/sub-category/yyyy/mm/day-week/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tag-woche/index.html', # Translate - New # OK

## plugins/ExtensibleArchives/AuthorArchive.pl
	'Author #[_1]' => 'Author #[_1]',
	'AUTHOR_ADV' => 'AUTHOR_ADV',
	'Author #[_1]: ' => 'Author #[_1]: ',
	'AUTHOR-YEARLY_ADV' => 'AUTHOR-YEARLY_ADV',
	'AUTHOR-MONTHLY_ADV' => 'AUTHOR-MONTHLY_ADV',
	'AUTHOR-WEEKLY_ADV' => 'AUTHOR-WEEKLY_ADV',
	'AUTHOR-DAILY_ADV' => 'AUTHOR-DAILY_ADV',
	'author_display_name/index.html' => 'benutzer_name/index.html', # Translate - New # OK
	'author-display-name/index.html' => 'benutzer-name/index.html', # Translate - New # OK
	'author_display_name/yyyy/index.html' => 'benutzer_name/jjjj/index.html', # Translate - New # OK
	'author-display-name/yyyy/index.html' => 'benutzer-name/jjjj/index.html', # Translate - New # OK
	'author_display_name/yyyy/mm/index.html' => 'benutzer_name/jjjj/mm/index.html', # Translate - New # OK
	'author-display-name/yyyy/mm/index.html' => 'benutzer-name/jjjj/mm/index.html', # Translate - New # OK
	'author_display_name/yyyy/mm/day-week/index.html' => 'benutzer_name/jjjj/mm/tag-woche/index.html', # Translate - New # OK
	'author-display-name/yyyy/mm/day-week/index.html' => 'benutzer-name/jjjj/mm/tag-woche/index.html', # Translate - New # OK
	'author_display_name/yyyy/mm/dd/index.html' => 'benutzer_name/jjjj/mm/tt/index.html', # Translate - New # OK
	'author-display-name/yyyy/mm/dd/index.html' => 'benutzer-name/jjjj/mm/tt/index.html', # Translate - New # OK

## plugins/Cloner/cloner.pl
	'Cloning Weblog' => 'Klone Weblog',
	'Error' => 'Fehler',
	'Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Fertig! Kehren Sie zur <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Liste aller Weblogs</a> zurück oder <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">konfigurieren Sie das neue Blog</a>.', # Translate - New # OK
	'No weblog was selected to clone.' => 'Keine Klonvorlage gewählt.',
	'This action can only be run for a single weblog at a time.' => 'Diese Aktion kann nur für jeweils ein einziges Weblog ausgeführt werden.',
	'Invalid blog_id' => 'Ungültige blog_id',
	'Clone Weblog' => 'Weblog klonen',

## plugins/WidgetManager/tmpl/header.tmpl
	'Movable Type Publishing Platform' => 'Movable Type Publishing Platform',
	'Go to:' => 'Gehe zu:',
	'Select a blog' => 'Blog auswählen...',
	'Weblogs' => 'Weblogs',
	'System-wide listing' => 'Globale Auflistung',

## plugins/WidgetManager/tmpl/edit.tmpl
	'Please use a unique name for this widget manager.' => 'Bite verwenden Sie einen eindeutigen Namen für die Widgetgruppe.',
	'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'Es existiert bereits eine Widgetgruppe namens [_1]. Bitte wählen Sie einen anderen Namen.',
	'Your changes to the Widget Manager have been saved.' => 'Änderungen übernommen',
	'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Ziehen Sie die Widgets, die Sie verwenden möchten, in die Spalte <strong>Installierte Widgets</strong>.',
	'Installed Widgets' => 'Installierte Widgets',
	'Available Widgets' => 'Verfügbare Widgets',
	'Save Changes' => 'Änderungen speichern',
	'Save changes (s)' => 'Änderungen speichern',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widgets' => 'Widgets', # Translate - New # OK
	'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'Widgetgruppe erfolgreich gelöscht.',
	'To add a Widget Manager to your templates, use the following syntax:' => 'Um eine Widgetgruppe in ein Template einzufügen, verwenden Sie folgende Syntax:',
	'<strong>&lt;$MTWidgetManager name=&quot;Name of the Widget Manager&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetManager name=&quot;Name der Widget-Gruppe&quot;$&gt;</strong>', # Translate - New # OK
	'Add Widget Manager' => 'Widgetgruppe hinzufügen',
	'Create Widget Manager' => 'Widgetgruppe anlegen',
	'Widget Manager' => 'Widgetgruppen',
	'Widget Managers' => 'Widgetgruppen',
	'Delete selected Widget Managers (x)' => 'Gewählte Widgetgruppen (x) löschen',

## plugins/WidgetManager/WidgetManager.pl
	'Failed to find WidgetManager::Plugin::[_1]' => 'WidgetManager::Plugin::[_1] nicht gefunden',

## plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

## plugins/WidgetManager/default_widgets/technorati_search.tmpl
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a>-Suche', # Translate - New # OK
	'this blog' => 'in diesem Blog',
	'all blogs' => 'in allen Blogs',
	'Blogs that link here' => 'Blogs, die Links auf diese Seite enthalte',

## plugins/WidgetManager/default_widgets/calendar.tmpl
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

## plugins/WidgetManager/default_widgets/signin.tmpl
	'You are signed in as ' => 'Sie sind angemeldet als', # Translate - New # OK
	'You do not have permission to sign in to this blog.' => 'Sie haben keine Anmelderechte für dieses Blog.', # Translate - New # OK

## plugins/WidgetManager/default_widgets/category_archive_list.tmpl

## plugins/WidgetManager/default_widgets/recent_comments.tmpl
	'Recent Comments' => 'Neueste Kommentare',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
	'Select a Month...' => 'Monat auswählen...',

## plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
	'Tag cloud' => 'Tag Cloud',

## plugins/WidgetManager/default_widgets/powered_by.tmpl
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitede/"><$MTProductName$></a>',

## plugins/WidgetManager/default_widgets/creative_commons.tmpl
	'This weblog is licensed under a' => 'Dieser Weblog steht unter einer',
	'Creative Commons License' => 'Creative Commons-Lizenz',

## plugins/WidgetManager/default_widgets/search.tmpl

## plugins/WidgetManager/default_widgets/recent_posts.tmpl

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Suchergebnisse für [_1]',

## search_templates/comments.tmpl
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

## search_templates/results_feed_rss2.tmpl

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'SEARCH FEED AUTODISCOVERY NUR ANGEZEIGT WENN SUCHE AUSGEFÜHRT',
	'Blog Search Results' => 'Blogsuche - Ergebnisse',
	'Blog search' => 'Blogsuche',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'EINFACHE SUCHEN - EINFACHES FORMULAR',
	'SEARCH RESULTS DISPLAY' => 'SUCHERGEBNISSANZEIGE',
	'Matching entries from [_1]' => 'Treffer in [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Einträge aus [_1], die getaggt sind mit \'[_2]\'',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Geschrieben <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'Showing the first [_1] results.' => 'Ersten [_1] Treffer',
	'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
	'Entries matching \'[_1]\'' => 'Einträge mit \'[_1]\'',
	'Entries tagged with \'[_1]\'' => 'Einträge getaggt mit \'[_1]\'',
	'No pages were found containing \'[_1]\'.' => 'Es wurden keine Seiten gefunden, die \'[_1]\' beinhalten.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Die Suchfunktion sucht standardmäßig nach allen angebenen Begriffen in beliebiger Reihenfolge. Um nach einem exakten Ausdruck zu suchen, setzen Sie diesen bitte in Anführungszeichen.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt.',
	'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE vs TAG-Information',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit \'[_1]\' getaggten Einträge abonnieren.',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit \'[_1]\' abonnieren.',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Was ist das?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
	'Other Tags' => 'Andere Tags',
	'END OF PAGE BODY' => 'PAGE BODY ENDE',
	'END OF CONTAINER' => 'CONTAINER ENDE',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Konto anlegen', # Translate - New # OK
	'Your login name.' => 'Ihr Anmeldename',
	'Display Name' => 'Anzeigename',
	'The name appears on your comment.' => 'Dieser Name wird unter Ihren Kommentaren angezeigt.', # Translate - New # OK
	'Your email address.' => 'Ihre Email-Adresse',
	'Initial Password' => 'Passwort',
	'Select a password for yourself.' => 'Eigenes Passwort',
	'Password Confirm' => 'Passowrtbestätigung', # Translate - New # OK
	'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen',
	'Password recovery word/phrase' => 'Erinnerungssatz',
	'This word or phrase will be required to recover the password if you forget it.' => 'Dieser Begriff oder Satz wird abgefragt, wenn ein vergessenes Passwort angefordert wird.',
	'Website URL' => 'Website',
	'The URL of your website. (Optional)' => 'URL Ihrer Website (optional)',
	'Enter your login name.' => 'Geben Sie Ihren Anmeldenamen ein.', # Translate - New # OK
	'Password' => 'Passwort',
	'Enter your password.' => 'Geben Sie Ihr Passwort ein.', # Translate - New # OK
	'Register' => 'Registrieren',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Anmelden zum Kommentieren', # Translate - New # OK
	'Forgot your password?' => 'Passwort vergessen?',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Ihr Profil', # Translate - New # OK
	'New Password' => 'Neues Passwort', # Translate - New # OK
	'Confirm Password' => 'Passwort bestätigen', # Translate - New # OK
	'Password recovery' => 'Passwort anfordern', # Translate - Case # OK

## tmpl/comment/error.tmpl
	'An error occurred' => 'Es ist ein Fehler aufgetreten',

## tmpl/comment/include/footer.tmpl
	'Sign in using' => 'Anmelden mit', # Translate - New # OK
	'<a href="[_1]">Movable Type</a>' => '<a href="[_1]">Movable Type</a>', # Translate - New # OK

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Vielen Dank für Ihre Anmeldung', # Translate - New # OK
	'Confirmation email has been sent to' => 'Eine Bestätigungsmail wurde verschickt an', # Translate - New # OK
	'Please check your email and click on the link in the confirmation email to activate your account.' => 'Um Ihr Konto zu aktivieren, überprüfen Sie bitte Ihren Posteingang klicken Sie bitte auf den Link in der Bestätigungsmail.', # Translate - New # OK
	'Return to the original entry' => 'Zurück zum Eintrag',
	'Return to the original page' => 'Zurück zur Seite', # Translate - New # OK

## tmpl/comment/register.tmpl

## tmpl/cms/restore_end.tmpl
	'All data restored successfully!' => 'Sämtliche Daten erfolgreich wiederhergestellt!', # Translate - New # OK
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem \'import\'-Ordner zu entfernen, damit sie bei künftigen Wiederherstellungen nicht erneut wiederhergestellt werden.', # Translate - New # OK
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie das Aktivitätsprotokoll.', # Translate - New # OK

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'Überschriftenanfang markierender HTML-Code (optional)', # Translate - New # OK
	'End title HTML (optional)' => 'Überschriftenende markierender HTML-Code (optional)', # Translate - New # OK
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Wenn Sie aus einem Weblog-System importieren, das kein eigenes Feld für Überschriften hat, können Sie hier angeben, welche HTML-Ausdrücke den Anfang und das Ende von Überschriften markieren.',
	'Default entry status (optional)' => 'Standard-Eintragsstatus (optional)', # Translate - New # OK
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Wenn Sie aus einem Weblog-System importieren, das in seiner Exportdatei den Eintragsstatus nicht vermerkt, können Sie hier angeben, welcher Status den importierten Einträgen zugewiesen werden soll.', # Translate - New # OK
	'Select an entry status' => 'Eintragsstatus wählen', # Translate - New # OK
	'Unpublished' => 'Nicht veröffentlichen',
	'Published' => 'Veröffentlichen',

## tmpl/cms/list_role.tmpl
	'Roles for [_1] in' => 'Rollen für [_1] in', # Translate - New # OK
	'Roles: System-wide' => 'Systemweite Rollen', # Translate - New # OK
	'_USAGE_ROLES' => 'Ihre Rollen für dieses Weblog',
	'You have successfully deleted the role(s).' => 'Rolle(n) erfolgreich gelöscht',
	'Delete selected roles (x)' => 'Gewählte Rollen löschen (x)',
	'role' => 'Rolle',
	'roles' => 'Rollen',
	'Grant another role to [_1]' => '[_1] weitere Rolle zuweisen',
	'_USER_STATUS_CAPTION' => 'Status',
	'Role' => 'Rolle',
	'In Weblog' => 'In Weblog',
	'Via Group' => 'Über Gruppe',
	'Created By' => 'Erstellt von',
	'Role Is Active' => 'Rolle ist aktiv',
	'Role Not Being Used' => 'Rolle wird derzeit nicht verwendet',
	'Permissions' => 'Berechtigungen',
	'No roles could be found.' => 'Keine Rollen gefunden.',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Spam-Konfiguration', # Translate - New # OK
	'Your spam preferences have been saved.' => 'Spam-Einstellungen gespeichert.', # Translate - New # OK
	'Auto-Delete Spam' => 'Spam automatisch löschen', # Translate - New # OK
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Falls aktiviert, wird als Spam markiertes Feedback nach einer Anzahl von Tagen automatisch gelöscht.', # Translate - New # OK
	'Spam Score Threshold' => 'Spam-Schwellenwert', # Translate - New # OK
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Kommentare und TrackBacks bekommen eine Spam-Bewertung zwischen -10 (sicher Spam) und +10 (kein Spam) zugewiesen. Feedback mit einer geringeren Bewertung als eingestellt werden automatisch als Spam markiert.', # Translate - New # OK
	'Less Aggressive' => 'konservativ',
	'Decrease' => 'Abschwächen',
	'Increase' => 'Verstärken',
	'More Aggressive' => 'aggressiv',
	'Delete Spam After' => 'Spam löschen nach', # Translate - New # OK
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Wenn ein Feedback für länger als angegeben als Spam markiert war, wird es automatisch gelöscht.', # Translate - New # OK
	'days' => 'Tagen',

## tmpl/cms/menu.tmpl
	'Overview of' => 'Übersicht über', # Translate - New # OK
	'Recent updates to [_1].' => 'Kürzliche Aktualisierungen von [_1]', # Translate - New # OK
	'Creating' => 'Anlegen',
	'Create New Entry' => 'Neuen Eintrag schreiben',
	'List Entries' => 'Einträge auflisten',
	'List uploaded files' => 'Hochgeladene Dateien auflisten',
	'Community' => 'Feedback',
	'List Comments' => 'Kommentare auflisten',
	'List Commenters' => 'Kommentarautoren auflisten',
	'List TrackBacks' => 'TrackBacks auflisten',
	'Edit Notification List' => 'Benachrichtigungsliste bearbeiten',
	'Configure' => 'Konfigurieren',
	'List Users &amp; Groups' => 'Benutzer und Gruppen auflisten',
	'Users &amp; Groups' => 'Benutzer und Gruppen',
	'List &amp; Edit Templates' => 'Templates auflisten &amp; bearbeiten',
	'Edit Categories' => 'Kategorien bearbeiten',
	'Edit Tags' => 'Tags bearbeiten',
	'Edit Weblog Configuration' => 'Weblog-Konfiguration bearbeiten',
	'Utilities' => 'Werkzeuge',
	'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
	'_SEARCH_SIDEBAR' => 'Suchen',
	'Backup this blog' => 'Dieses Blog sichern', # Translate - New # OK
	'Import &amp; Export Entries' => 'Einträge importieren &amp; exportieren',
	'Import / Export' => 'Import/Export',
	'_external_link_target' => '_top',
	'View Site' => 'Ansehen',
	'Welcome to [_1].' => 'Willkommen bei [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Sie können Ihr Blog von dem Menü, das Sie links von dieser Nachricht finden, aus verwalten.', # Translate - New # OK
	'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
	'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Movable Type Technischer Support',
	'Movable Type Community Forums' => 'Movable Type Community-Foren',
	'Change this message.' => 'Diese Nachricht ändern.',
	'Edit this message.' => 'Diese Nachricht ändern.',
	'Recent Entries' => 'Neueste Einträge',
	'Scheduled' => 'Zeitgeplant',
	'Pending' => 'Nicht veröffentlicht',
	'Anonymous' => 'Anonym',
	'Recent TrackBacks' => 'Neueste TrackBacks',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Vorschau auf [_1]', # Translate - New # OK
	'Re-Edit this [_1]' => '[_1] erneut bearbeiten', # Translate - New # OK
	'Re-Edit this [_1] (e)' => '[_1] erneut bearbeiten (e)', # Translate - New # OK
	'Save this [_1]' => '[_1] speichern', # Translate - New # OK
	'Save this [_1] (s)' => '[_1] speichern (s)', # Translate - New # OK
	'Cancel (c)' => 'Abbrechen (c)', # Translate - New # OK

## tmpl/cms/edit_entry.tmpl
	'Filename' => 'Dateiname',
	'Basename' => 'Basename',
	'Create [_1]' => '[_1] anlegen', # Translate - New # OK
	'Edit [_1]' => '[_1] bearbeiten', # Translate - New # OK
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Eine gespeicherte Version dieses [_1] wurde automatisch gespeichert [3]. <a href="[_2]">Automatisch gespeicherten Inhalt wiederherstellen</a>.', # Translate - New # OK
	'Your [_1] has been saved. You can now make any changes to the [_1] itself, edit the authored-on date, or edit comments.' => '[_1] gespeichert. Sie können nun den Eintrag oder die Seite selbst, das Veröffentlichtungdatum oder die zugehörigen Kommntare bearbeiten.', # Translate - New # OK
	'Your changes have been saved.' => 'Die Änderungen wurden gespeichert.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
	'_USAGE_VIEW_LOG' => 'Überprüfen Sie das <a href="[_1]">Aktivitätsprotokoll</a>, um den Fehler zu finden.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Ihre Anpassungseinstellungen wurden gespeichert und werden im nachfolgenden Formular angezeigt.',
	'Your changes to the comment have been saved.' => 'Ihre am Kommentar vorgenommenen Änderungen wurden gespeichert.',
	'Your notification has been sent.' => 'Ihre Benachrichtigung wurde gesendet.',
	'You have successfully recovered your saved [_1].' => 'Gespeicherte Fassung erfolgreich wiederhergestellt.', # Translate - New # OK
	'An error occurred while trying to recover your saved [_1].' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.', # Translate - New # OK
	'You have successfully deleted the checked comment(s).' => 'Der bzw. die markierten Kommentare wurden erfolgreich gelöscht.',
	'You have successfully deleted the checked TrackBack(s).' => 'TrackBack(s) gelöscht.',
	'Summary' => 'Zusammenfassung', # Translate - New # OK
	'Created [_1] by [_2].' => '[_1] von [_2] angelegt.', # Translate - New # OK
	'Last edited [_1] by [_2].' => 'Von [_2] zuletzt bearbeiteter [_1].', # Translate - New # OK
	'Published [_1].' => '[_1] veröffentlicht.', # Translate - New # OK
	'This [_1] has received <a href="[_4]">[quant,_2,comment]</a> and [quant,_3,trackback].' => 'Dieser [_1] hat <a href="[_4]">[quant,_2,Kommentar]</a> and [quant,_3,TrackBack] erhalten.', # Translate - New # OK
	'Display Options' => 'Anzeigeoptionen',
	'Fields' => 'Felder', # Translate - New # OK
	'Body' => 'Textkörper',
	'Excerpt' => 'Zusammenfassung',
	'Keywords' => 'Schlüsselwörter',
	'Publishing' => 'Veröffentlichen',
	'Feedback' => 'Feedback',
	'Actions' => 'Aktionen',
	'Top' => 'Anfang', # Translate - New # OK
	'Both' => 'Sowohl als auch',
	'Bottom' => 'Ende', # Translate - New # OK
	'OK' => 'OK', # Translate - New # OK
	'Reset' => 'Zurücksetzen',
	'Your entry screen preferences have been saved.' => 'Die Einstellungen für die Eintragseingabe wurden gespeichert.',
	'Are you sure you want to use the Rich Text editor?' => 'Grafischen Editor wirklich verwenden?', # Translate - New # OK
	'You have unsaved changes to your [_1] that will be lost.' => 'Es liegen nicht gespeicherte Änderungen vor, die verloren gehen werden.', # Translate - New # OK
	'Publish On' => 'Veröffentlichen um',
	'Publish Date' => 'Zeitpunkt der Veröffentlichung',
	'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.',
	'Remove' => 'Entfernen',
	'Make primary' => 'Primär setzen', # Translate - New # OK
	'Add sub category' => 'Unterkategorie hinzufügen', # Translate - New # OK
	'Add [_1] name' => '[_1]-Name hinzufügen', # Translate - New # OK
	'Add new parent [_1]' => 'Neue Eltern-[_1] hinzufügen', # Translate - New # OK
	'Add new' => 'Neue', # Translate - New # OK
	'Preview this [_1] (v)' => 'Vorschau auf [_1]', # Translate - New # OK
	'Delete this [_1] (v)' => '[_1] löschen (v)', # Translate - New # OK
	'Delete this [_1] (x)' => '[_1] löschen (x)', # Translate - New # OK
	'Share this [_1]' => '[_1] teilen', # Translate - New # OK
	'View published [_1]' => 'Veröffentlichten [_1] ansehen', # Translate - New # OK
	'&laquo; Previous' => '&laquo; Vorheriger', # Translate - New # OK
	'Manage [_1]' => '[_1] verwalten', # Translate - New # OK
	'Next &raquo;' => 'Nächster &raquo;', # Translate - New # OK
	'Extended' => 'Erweitert', # Translate - New # OK
	'Format' => 'Format', # Translate - New # OK
	'Decrease Text Size' => 'Textgröße verkleinern', # Translate - New # OK
	'Increase Text Size' => 'Textgröße vergrößern', # Translate - New # OK
	'Bold' => 'Fett',
	'Italic' => 'Kursiv',
	'Underline' => 'Unterstrichen',
	'Strikethrough' => 'Durchstreichen', # Translate - New # OK
	'Text Color' => 'textfarbe', # Translate - New # OK
	'Link' => 'Link',
	'Email Link' => 'E-Mail-Link', # Translate - New # OK
	'Begin Blockquote' => 'Zitat Anfang', # Translate - New # OK
	'End Blockquote' => 'Zitat Ende', # Translate - New # OK
	'Bulleted List' => 'Aufzählung', # Translate - New # OK
	'Numbered List' => 'Nummerierte Liste', # Translate - New
	'Left Align Item' => 'Linksbündig', # Translate - New # OK
	'Center Item' => 'Zentieren', # Translate - New # OK
	'Right Align Item' => 'Rechtsbündig', # Translate - New # OK
	'Center Text' => 'Zentrierter Text', # Translate - New # OK
	'Left Align Text' => 'Linksbündiger Texts', # Translate - New # OK
	'Right Align Text' => 'Rechtsbündiger Text', # Translate - New # OK
	'Insert Image' => 'Bild einfügen', # Translate - New # OK
	'Insert File' => 'Datei einfügen', # Translate - New # OK
	'WYSIWYG Mode' => 'Grafischer Editor', # Translate - New # OK
	'HTML Mode' => 'HTML-Modus', # Translate - New # OK
	'Metadata' => 'Metadaten', # Translate - New # OK
	'(comma-delimited list)' => '(Liste mit Kommatrennung)',
	'(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
	'(delimited by \'[_1]\')' => '(Trennung durch \'[_1]\')',
	'Change [_1]' => '[_1] ändern', # Translate - New # OK
	'Add [_1]' => '[_1] einfügen', # Translate - New # OK
	'Status' => 'Status',
	'You must configure blog before you can publish this [_1].' => 'Vor dem Veröffentlichen müssen Sie das Blog konfigurieren.', # Translate - New # OK
	'Select entry date' => 'Eintragsdatum wählen', # Translate - New # OK
	'Unlock this entry&rsquo;s output filename for editing' => 'Dateinamen manuell bearbeiten', # Translate - New # OK
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basenamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Warnung: Wenn Sie den Basename nachträglich ändern, können Links von Außen den Eintrag falsch verlinken.',
	'Accept' => 'Annehmen',
	'Comments Accepted' => 'Kommentare angenommen', # Translate - New # OK
	'TrackBacks Accepted' => 'TrackBacks angenommen', # Translate - New # OK
	'Outbound TrackBack URLs' => 'TrackBack-URLs',
	'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
	'Auto-saving...' => 'Autospeicherung...', # Translate - New # OK
	'Last auto-save at [_1]:[_2]:[_3]' => 'Zuletzt automatisch gespeichert um [_1]:[_2]:[_3]', # Translate - New # OK

## tmpl/cms/system_check.tmpl
	'This screen provides you with information on your system\'s configuration, and shows you which components you are running with Movable Type.' => 'Auf dieser Seite finden Sie Informationen zu Ihrer Systemkonfiguration. Hier können Sie sehen, welche Komponenten von Movable Type verwendet werden.', # Translate - New # OK

## tmpl/cms/import.tmpl
	'Import' => 'Import', # Translate - New # OK
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Mit der Import/Export-Funktionen können Einträge aus anderen Movable Type-Installationen oder aus anderen Weblog-Systemen übernommen und bestehende Einträge in einem Austauschformat gesichert werden.',
	'Importing from' => 'Importieren aus', # Translate - New # OK
	'Ownership of imported entries' => 'Besitzer importierter Einträge', # Translate - New # OK
	'Import as me' => 'Einträge unter meinem Namen importieren',
	'Preserve original user' => 'Einträge unter ursprünglichen Namen importieren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Benutzernamen importieren und einer oder mehrere der Benutzer in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
	'Default password for new users:' => 'Standard-Passwort für neue Benutzer:',
	'Upload import file (optional)' => 'Import-Datei hochladen (optional)', # Translate - New # OK
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Wenn Sie eine auf Ihrem Computer gespeicherte Importdatei verwenden wollen, laden Sie diese hier hoch. Alternativ verwendet Movable Type automatisch die Importdatei, die es im \'import\'-Unterordner Ihres Movable Type-Verzeichnis findet.', # Translate - New # OK
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Alle importierten Einträge werden Ihnen zugewiesen werden. Wenn Sie möchten, daß die Einträge ihren ursprünglichen Benutzern zugewiesen bleiben, lassen Sie den Import von Ihren Administrator durchführen. Dann werden etwaige erforderliche, aber noch fehlende Benutzerkonten automatisch angelegt.',
	'More options' => 'Weitere Optionen', # Translate - New # OK
	'Text Formatting' => 'Textformatierung',
	'Import File Encoding' => 'Kodierung der Importdatei', # Translate - New # OK
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Type versucht automatisch das korrekte Encoding auszuwählen. Sollte das fehlschlagen, können Sie es auch explizit angeben.',
	'<mt:var name="display_name">' => '<mt:var name="display_name">', # Translate - New # OK
	'Default category for entries (optional)' => 'Standard-Kategorie für Einträge (optional)', # Translate - New # OK
	'You can specify a default category for imported entries which have none assigned.' => 'Standardkdategorie für importierte Einträge ohne Kategorie',
	'Select a category' => 'Kategorie auswählen...',
	'Import Entries' => 'Einträge importieren',
	'Import Entries (i)' => 'Einträge importieren (i)',

## tmpl/cms/cfg_system_feedback.tmpl
	'Feedback Settings: System-wide' => 'Systemweite Feedback-Einstellungen', # Translate - New # OK
	'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Hier konfigurieren Sie die Kommentar- und TrackBack-Einstellungen für das Gesamtsystem. Diese Einstellungen sind höherrangig als die entsprechenden Einstellungen der einzelnen Weblogs, d.h. sie setzen diese außer Kraft.',
	'Your feedback preferences have been saved.' => 'Ihre Feedback-Einstellungen wurden gespeichert.',
	'None selected.' => 'Auswahl leer.',
	'Feedback Master Switch' => 'Feedback-Hauptschalter',
	'Disable Comments' => 'Kommentare ausschalten',
	'This will override all individual weblog comment settings.' => 'Diese Einstellung setzt die entsprechenden Einstellungen der Einzelweblogs außer Kraft',
	'Stop accepting comments on all weblogs' => 'Bei allen Weblogs Kommentare ausschalten',
	'Allow Registration' => 'Registrierung erlauben', # Translate - New # OK
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Bestimmen Sie, welcher Systemadministrator benachrichtigt werden soll, wenn ein Kommentarautor sich erfolgreich selbst registriert hat.', # Translate - New # OK
	'Allow commenters to register to Movable Type' => 'Kommentarautoren bei Movable Type registrieren lassen', # Translate - New # OK
	'Notify administrators' => 'Administratoren verständigen', # Translate - New # OK
	'Select...' => 'Auswählen...',
	'Clear' => 'Zurücksetzen',
	'System Email Address Not Set' => 'System-E-Mail-Adresse nicht gesetzt', # Translate - New # OK
	'Note: System Email Address is not set.  Emails will not be sent.' => 'Hinweis: Die System-E-Mail-Adresse ist nicht gesetzt. Die E-Mail kann daher nicht verschickt werden.', # Translate - New # OK
	'Use Comment Confirmation' => 'Kommentarbestätigung', # Translate - New # OK
	'Use comment confirmation page' => 'Kommentarbestätigungsseite', # Translate - New # OK
	'CAPTCHA Provider' => 'CAPTCHA-Quelle', # Translate - New # OK
	'Disable TrackBacks' => 'TrackBacks ausschalten',
	'This will override all individual weblog TrackBack settings.' => 'Diese Einstellung setzt die entsprechenden Einstellungen der Einzelweblogs außer Kraft',
	'Stop accepting TrackBacks on all weblogs' => 'Bei allen Weblogs TrackBack ausschalten',
	'Outbound TrackBack Control' => 'TrackBack-Kontrolle (für ausgehende Pings)',
	'Allow outbound Trackbacks to' => 'Alle ausgehenden TrackBacks an', # Translate - New # OK
	'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Um Ihre Installation nichtöffentlich zu machen, können Sie hier begrenzen, zu welchen Sites TrackBacks verschickt werden dürfen.',
	'Any site' => 'zu beliebigen Sites',
	'No site' => 'zu keinen Sites',
	'(Disable all outbound TrackBacks.)' => '(Alle ausgehenden TrackBacks ausschalten)',
	'Only the weblogs on this installation' => 'nur zu Sites in dieser Installation',
	'Only the sites on the following domains:' => 'nur zu Sites mit den folgenden Domains:',

## tmpl/cms/edit_template.tmpl
	'Edit Template' => 'Vorlage bearbeiten', # Translate - Improved (1) # OK
	'Create Template' => 'Vorlage anlegen', # Translate - New # OK
	'Your template changes have been saved.' => 'Vorlagenänderungen gespeichert.', # Translate - Improved (6) # OK
	'Your [_1] has been rebuilt.' => '[_1] wurde neu veröffentlicht.',
	'Useful Links' => 'Nützliche Links', # Translate - New # OK
	'View Published Template' => 'Veröffentlichte Vorlage ansehen', # Translate - Improved (1) # OK
	'List [_1] templates' => 'Zeige [_1]-Vorlagen', # Translate - New # OK
	'Template tag reference' => 'Vorlagen-Tags-Referenz', # Translate - New # OK
	'Includes and Widgets' => 'Includes und Widgets', # Translate - New # OK
	'Unknown' => 'Unbekannt', # Translate - New # OK
	'Save (s)' => 'Sichern (s)', # Translate - New # OK
	'Save this template (s)' => 'Vorlage speichern (s)', # Translate - Improved (1) # OK
	'Save and Rebuild this template (r)' => 'Vorlage speichern und neu veröffentlichen (r)', # Translate - Improved (1) # OK
	'Save and Rebuild' => 'Speichern und neu veröffentlichen',
	'Save and rebuild this template (r)' => 'Vorlage speichern und neu veröffentlichen (r)', # Translate - Improved (1) # OK
	'You must set the Template Name.' => 'Sie müssen einen Vorlagennamen vergeben', # Translate - New # OK
	'You must set the template Output File.' => 'Sie müssen einen Dateinamen angeben', # Translate - New # OK
	'Please wait...' => 'Bitte warten...', # Translate - New # OK
	'Error occurred while updating archive maps.' => 'Bei der Aktualisierung der Archivverknüpfungen ist ein Fehler aufgetreten.', # Translate - New # OK
	'Archive map has been successfully updated.' => 'Archivverknüpfung erfolgreich aktualisiert.', # Translate - New # OK
	'Template Name' => 'Vorlagenname', # Translate - Improved (2) # OK
	'Module Body' => 'Modul-Code',
	'Template Body' => 'Vorlagen-Code', # Translate - Improved (2) # OK
	'Insert...' => 'Einfügen...',
	'Custom Index Template' => 'Individuelle Indexvorlage', # Translate - New # OK
	'Output File' => 'Ausgabedatei',
	'Build Options' => 'Aufbauoptionen',
	'Enable dynamic building for this template' => 'Dynamisches Veröffentlichen für dieses Template aktivieren',
	'Rebuild this template automatically when rebuilding index templates' => 'Dieses Template sofort neu veröffentlichen, wenn Index-Templates neu aufgebaut werden',
	'Link to File' => 'Mit Datei verlinken', # Translate - New # OK
	'Archive Mapping' => 'Archiv-Verknüpfung',
	'Create New Archive Mapping' => 'Neue Archiv-Verknüpfung einrichten',
	'Archive Type:' => 'Archivierungstyp:',
	'Add' => 'Hinzufügen',

## tmpl/cms/edit_comment.tmpl
	'Save this comment (s)' => 'Kommentar(e) speichern',
	'comment' => 'Kommentar',
	'comments' => 'Kommentare',
	'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
	'Ban This IP' => 'Diese IP-Adresse sperren',
	'Useful links' => 'Nützliche Links', # Translate - New # OK
	'Previous Comment' => 'Vorheriger Kommentar', # Translate - New # OK
	'Edit Comments' => 'Kommentare bearbeiten', # Translate - New # OK
	'Next Comment' => 'Nächster Kommentar', # Translate - New # OK
	'View the entry this comment was left on' => 'Eintrag, auf den sich dieser Kommentar bezieht, anzeigen', # Translate - New # OK
	'Pending Approval' => 'Freischaltung offen',
	'Comment Reported as Spam' => 'Kommentar als Spam gemeldet', # Translate - New # OK
	'Update the status of this comment' => 'Kommentarstatus aktualisieren', # Translate - New # OK
	'Approved' => 'Freigeschaltet',
	'Unapproved' => 'Noch nicht freigeschaltet', # Translate - New # OK
	'Reported as Spam' => 'Als Spam gemeldet', # Translate - New # OK
	'View all comments with this status' => 'Alle Kommentare mit diesem Status ansehen',
	'The name of the person who posted the comment' => 'Name der Person, die den Kommentar abgegeben hat', # Translate - New # OK
	'Trusted' => 'vertraut',
	'(Trusted)' => '(vertraut)',
	'Ban&nbsp;Commenter' => 'Kommentarautor&nbsp;sperren', # Translate - Improved (1) # OK
	'Untrust&nbsp;Commenter' => 'Kommentarautor&nbsp;nicht&nbsp;vertrauen', # Translate - Improved (1) # OK
	'Banned' => 'Gesperrt',
	'(Banned)' => '(gesperrt)',
	'Trust&nbsp;Commenter' => 'Kommentarautor&nbsp;vertrauen', # Translate - Improved (1) # OK
	'Unban&nbsp;Commenter' => 'Sperre&nbsp;aufheben',
	'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentarautor anzeigen', # Translate - Improved (1) # OK
	'Email' => 'Email',
	'Email address of commenter' => 'E-Mail-Adresse des Kommentarautors', # Translate - New # OK
	'None given' => 'Nicht angegeben', # Translate - Improved (2) # OK
	'View all comments with this email address' => 'Alle Kommentare von dieser Email-Adresse anzeigen',
	'URL of commenter' => 'URL des Kommentarautors', # Translate - New # OK
	'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
	'Entry this comment was made on' => 'Eintrag, auf den sich der Kommentar bezieht', # Translate - New # OK
	'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
	'View all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',
	'Date' => 'Datum',
	'Date this comment was made' => 'Datum, an dem dieser Kommentar abgegeben wurde', # Translate - New # OK
	'View all comments created on this day' => 'Alle Kommentare dieses Tages anzeigen', # Translate - New # OK
	'IP' => 'IP',
	'IP Address of the commenter' => 'IP-Adresse des Kommentarautors', # Translate - New # OK
	'View all comments from this IP address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
	'Comment Text' => 'Kommentartext',
	'Fulltext of the comment entry' => 'Vollständiger Kommentartext', # Translate - New # OK
	'Responses to this comment' => 'Reaktionen auf diesen Kommentar', # Translate - New # OK
	'Final Feedback Rating' => 'Finales Feedback-Rating',
	'Test' => 'Test',
	'Score' => 'Score',
	'Results' => 'Ergebnis',

## tmpl/cms/edit_role.tmpl
	'Role Details' => 'Rolleneigenschaften',
	'You have changed the permissions for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Sie haben die Nutzerrechte für diese Rolle geändert. Das beeinflusst alle mit dieser Rolle verknüpften Benutzer. Sie können daher die Rolle unter neuem Namen speichern.',
	'_USAGE_ROLE_PROFILE' => 'Rollen und Berechtigungen definieren',
	'There are [_1] User(s) with this role.' => '[_1] Benutzer mit dieser Rolle vorhanden.', # Translate - New # OK
	'Created by' => 'Angelegt von',
	'Check All' => 'Alle markieren',
	'Uncheck All' => 'Alle deaktivieren',
	'Administration' => 'Verwalten', # Translate - New # OK
	'Authoring and Publishing' => 'Schreiben und veröffentlichen', # Translate - New # OK
	'Designing' => 'Gestalten', # Translate - New # OK
	'File Upload' => 'Dateien hochladen', # Translate - New # OK
	'Commenting' => 'Kommentieren', # Translate - New # OK
	'Roles with the same permissions' => 'Rollen mit den gleichen Nutzerrechten',
	'Save this role' => 'Rolle speichern',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie die Sicherungsdatei.', # Translate - New # OK
	'All of the data have been restored successfully!' => 'Alle Daten wurden erfolgreich wiederhergestellt!', # Translate - New # OK
	'Next Page' => 'Nächste Seite', # Translate - New # OK
	'The page will redirect to a new page in 3 seconds.  Click <a href=\'javascript:void(0)\' onclick=\'return stopTimer()\'>here</a> to stop the timer.' => 'Diese Seite leitet in drei Sekunden auf eine neue Seite weiter. Klicken Sie <a href=\'javascript:void(0)\' onclick=\'return stopTimer()\'>hier </a> um den Timer anzuhalten.', # Translate - New # OK

## tmpl/cms/dialog/grant_role.tmpl
	'You need to create some roles.' => 'Legen Sie zuerst Rollen an.',
	'Before you can do this, you need to create some roles. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Legen Sie zuerst Rollen an. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Rollen anlegen</a>.', # Translate - New # OK
	'You need to create some groups.' => 'Legen Sie zuerst Gruppen an',
	'Before you can do this, you need to create some groups. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a group.' => 'Legen Sie zuerst Gruppen an. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Gruppen anlegen</a>', # Translate - New # OK
	'You need to create some users.' => 'Legen Sie zuerst Benutzerkonten an',
	'Before you can do this, you need to create some users. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a user.' => 'Legen Sie zuerst Benutzerkonten an. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Benutzerkonten anlegen</a>', # Translate - New # OK
	'You need to create some weblogs.' => 'Legen Sie zuerst Weblogs an',
	'Before you can do this, you need to create some weblogs. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a weblog.' => 'Legen Sie zuerst Weblogs an. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Weblogs anlegen</a>', # Translate - New # OK

## tmpl/cms/dialog/asset_image_options.tmpl
	'Display Image in Entry' => 'Bild in Eintrag anzeigen', # Translate - New # OK
	'Alignment' => 'Ausrichtung', # Translate - New # OK
	'Align Image Left' => 'Bild links ausrichten', # Translate - New # OK
	'Left' => 'Links', # Translate - New # OK
	'Align Image Center' => 'Bild mittig ausrichten', # Translate - New # OK
	'Center' => 'Zentriert', # Translate - New # OK
	'Align Image Right' => 'Bild rechts ausrichten', # Translate - New # OK
	'Right' => 'Rechts', # Translate - New
	'Create Thumbnail' => 'Vorschaubild erzeugen', # Translate - New # OK
	'Width' => 'Breite', # Translate - New # OK
	'Pixels' => 'Pixel',
	'Link image to full-size version in a popup window.' => 'Vorschau mit Großansicht in Popup-Fenster verlinken', # Translate - New # OK
	'Remember these settings' => 'Einstellungen speichern', # Translate - New # OK

## tmpl/cms/dialog/upload_complete.tmpl
	'Upload Image' => 'Bild hochladen', # Translate - New # OK
	'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'Die Datei \'[_1]\' wurde hochgeladen. Größe: [quant,_2,Byte].', # Translate - Improved (1) # OK
	'File Options' => 'Dateioptionen', # Translate - New # OK
	'Create a new entry using this uploaded file.' => 'Neuen Eintrag mit hochgeladener Datei anlegen', # Translate - New # OK
	'Finish' => 'Fertigstellen', # Translate - New # OK

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Abbrechen führt zu verwaisten Objekten. Wiederherstellung wirklich abbrechen?', # Translate - New # OK
	'Restore Multiple Files' => 'Mehrere Dateien wiederherstellen', # Translate - New # OK
	'Restoring' => 'Wiederherstellen', # Translate - New # OK
	'Please upload the following file' => 'Bitte laden Sie die folgende Datei hoch', # Translate - New # OK
	'Upload' => 'Hochladen',

## tmpl/cms/dialog/post_comment_end.tmpl
	'Note: Your reply to this comment will be automatically published.' => 'Hinweis: Ihre Kommentarantwort wird automatisch veröffentlicht.', # Translate - New # OK

## tmpl/cms/dialog/post_comment.tmpl
	'Reply to comment' => 'Auf Kommentar antworten', # Translate - New # OK
	'<strong>[_2]</strong> wrote:' => '<strong>[_2]</strong> schrieb:', # Translate - New # OK
	'Posted to &ldquo;[_1]&rdquo; on [_2]' => 'Kommentar zu &ldquo;[_1]&rdquo; vom [_2]', # Translate - New # OK
	'Your reply:' => 'Ihre Antwort:', # Translate - New # OK
	'Note: Your reply will be automatically published.' => 'Hinweis: Ihre Antwort wird automatisch veröffentlicht.', # Translate - New # OK

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Restoring [_1]...' => 'Stelle [_1] wieder her...', # Translate - New # OK
	'URL is not valid.' => 'URL ungültig', # Translate - New # OK
	'You can not have spaces in the URL.' => 'Die URL darf keine Leerzeichen enthalten', # Translate - New # OK
	'You can not have spaces in the path.' => 'Der Pfad darf keine Leerzeichen enthalten', # Translate - New # OK
	'Path is not valid.' => 'Pfad ungültig', # Translate - New # OK
	'New Site Path' => 'Neuer Site-Pfad', # Translate - New # OK
	'New Site URL' => 'Neue Site-URL', # Translate - New # OK
	'New Archive Path' => 'Neuer Archiv-Pfad', # Translate - New # OK
	'New Archive URL' => 'Neue Archiv-URL', # Translate - New # OK

## tmpl/cms/dialog/list_assets.tmpl
	'System-wide' => 'Gesamtsystem',
	'Select the image you would like to insert, or upload a new one.' => 'Wählen Sie ein Bild aus oder laden Sie ein neues hoch.', # Translate - New # OK
	'Select the file you would like to insert, or upload a new one.' => 'Wählen Sie eine Datei aus oder laden Sie eine neue hoch.', # Translate - New # OK
	'Upload New File' => 'Neue Datei hochladen', # Translate - New # OK
	'Upload New Image' => 'Neues Bild hochladen', # Translate - New # OK
	'View All' => 'Alle',
	'Weblog' => 'Weblog',
	'Size' => 'Größe', # Translate - New # OK
	'View File' => 'Datei ansehen', # Translate - New # OK
	'Next' => 'Nächstes', # Translate - Improved (1) # OK
	'Insert' => 'Einfügen', # Translate - New # OK
	'No assets could be found.' => 'Keine Assets gefunden.', # Translate - New # OK

## tmpl/cms/dialog/restore_start.tmpl

## tmpl/cms/dialog/upload_confirm.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Eine Datei namens \'[_1]\' ist bereits vorhanden. Möchten Sie sie überschreiben?',

## tmpl/cms/dialog/upload.tmpl
	'You need to configure your weblog.' => 'Sie müssen Ihr Weblog konfigurieren', # Translate - New # OK
	'Before you can upload a file, you need to publish your weblog. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to configure your weblog\'s publishing paths and rebuild your weblog.' => 'Sie müssen Ihr Weblog veröffentlicht haben, bevor Sie eine Datei hochladen können. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Pfade einstellen und Weblog erneut veröffentlichen</a>.', # Translate - New # OK
	'Choose a file from your computer to upload' => 'Wählen Sie eine lokale Datei zum Hochladen', # Translate - New # OK
	'File to Upload' => 'Hochzuladende Datei', # Translate - New # OK
	'Click the button below and select a file on your computer to upload.' => 'Klicken Sie auf den Knopf und wählen dann die Datei auf Ihrem Computer aus, die hochgeladen werden soll.', # Translate - New # OK
	'Set Upload Path' => 'Ziel wählen',
	'_USAGE_UPLOAD' => 'Laden Sie diese Datei in Ihren lokalen Site-Pfad <a href="javascript:alert(\'[_1]\')">(?)</a>. Optional können Sie die Datei in ein beliebiges Unterverzeichnis laden. Tragen Sie dazu den Pfad in das Formularfeld ein. Besteht das Verzeichnis noch nicht, wird es automatisch angelegt.',
	'Path' => 'Pfad', # Translate - New # OK

## tmpl/cms/install.tmpl
	'Create Your First User' => 'Ersten Benutzer anlegen', # Translate - New # OK
	'The initial account name is required.' => 'Benutzername erforderlich',
	'Password recovery word/phrase is required.' => 'Passwort-Erinnerungsfrage erforderlich',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Wir empfehlen dringend, die Perl-Installation mindestens auf Version [_1] zu aktualisieren. Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>.',
	'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Bevor Sie bloggen können, müssen Sie einen Systemadministrator bestimmen. Movable Type wird daraufhin Ihre Datenbank einrichten.', # Translate - New # OK
	'You will need to select a username and password for the administrator account.' => 'Legen Sie den Benutzernamen und das Passwort des Administrator-Accounts fest:',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Um fortfahren zu können müssen Sie sich gegenüber Ihrem LDAP-Server authentifizieren',
	'The name used by this user to login.' => 'Anmeldename dieses Benutzerkontos',
	'The user\'s email address.' => 'Email-Adresse des Benutzers',
	'Language' => 'Sprache',
	'The user\'s preferred language.' => 'Gewünschte Spracheinstellung',
	'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
	'This word or phrase will be required to recover your password if you forget it.' => 'Dieser Satz wird abgefragt, wenn ein vergessenes Passwort angefordert wird',
	'Your LDAP username.' => 'Ihr LDAP-Benutzername.',
	'Enter your LDAP password.' => 'Geben Sie Ihr LDAP-Passwort ein.',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack', # Translate - Case # OK
	'Pinging sites...' => 'Pings zu Sites senden...',

## tmpl/cms/edit_author.tmpl
	'User Profile for [_1]' => 'Benutzerprofil von [_1]', # Translate - New # OK
	'Your Web services password is currently' => 'Web Services-Passwort noch nicht gesetzt',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Ein zufällig erzeugtes neues Passwort wird an seine Adresse [_2] verschickt werden.\n\nForsetzen?',
	'_USAGE_NEW_AUTHOR' => 'Hier können Sie ein neues Benutzerkonto anlegen und einem oder mehreren Weblogs zuordnen.',
	'_USAGE_PROFILE' => 'Hier bearbeiten Sie Ihr Autorenprofil. Wenn Sie Ihren Benutzernamen und Ihr Passwort ändern, werden die Login-Informationen sofort aktualisiert und Sie müssen sich nicht erneut anmelden.',
	'_GENL_USAGE_PROFILE' => 'Benutzerprofil bearbeiten. Der Benutzer braucht sich auch dann nicht neu anzumelden, wenn sein Benutzername oder Passwort geändert wird.',
	'User Pending' => 'Benutzerkonto schwebend', # Translate - New # OK
	'User Disabled' => 'Benutzerkonto deaktiviert',
	'This profile has been updated.' => 'Profil aktualisiert.',
	'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an die Adresse  [_1] verschickt.',
	'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise hat während der Synchronisation versucht, Ihr Benutzerkonto zu deaktivieren. Das deutet auf einen Fehler in der externen Benutzerverwaltung hin. Überprüfen Sie daher die dortigen Einstellungen, bevor Sie Ihre Arbeit in Movable Type forsetzen.',
	'Profile' => 'Profil',
	'Personal Weblog' => 'Persönliches Weblog',
	'Create personal weblog for user' => 'Persönliches Weblog für neuen Benutzer anlegen',
	'System Permissions' => 'Zugriffsrechte',
	'Create Weblogs' => 'Weblogs einrichten',
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Globaler Benutzerstatus. Deaktivierung eines Benutzerkontos führt zum Ausschluß des Benutzers, von ihm erstellte Inhalte und sein Nutzungsverlauf bleiben jedoch erhalten.',
	'_USER_ENABLED' => 'Aktiviert',
	'_USER_PENDING' => '_USER_PENDING',
	'_USER_DISABLED' => 'Deaktiviert',
	'The username used to login.' => 'Benutzername (für Anmeldung)', # Translate - New # OK
	'User\'s external user ID is <em>[_1]</em>.' => 'Externe ID des Benutzers: <em>[_1]</em>.', # Translate - New # OK
	'The name used when published.' => 'Anzeigename (für Veröffentlichung)', # Translate - New # OK
	'The email address associated with this user.' => 'Mit diesem Benutzer verknüpfte E-Mail-Adresse', # Translate - New # OK
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'Mit diesem Benutzer verknüpfte Web-Adresse (z.B. http://movabletype.de/)', # Translate - New # OK
	'Preferred language of this user.' => 'Bevorzugte Sprache des Benutzers', # Translate - New # OK
	'Text Format' => 'Textformat', # Translate - New # OK
	'Preferred text format option.' => 'Bevorzugte Formatierungsoption', # Translate - New # OK
	'(Use Blog Default)' => '(Standard verwenden)', # Translate - New # OK
	'Tag Delimiter' => 'Tag-Trennzeichen', # Translate - New # OK
	'Preferred method of separating tags.' => 'Bevorzugtes Trennzeichen für Tags', # Translate - New # OK
	'Comma' => 'Komma',
	'Space' => 'Leerzeichen',
	'Web Services Password' => 'Webdienste-Passwort', # Translate - New # OK
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Erforderlich für Aktivitäts-Feeds und externe Software, die über XML-RPC oder ATOM-API auf das Weblog zugreift',
	'Reveal' => 'Anzeigen',
	'Current Password' => 'Derzeitiges Passwort', # Translate - New # OK
	'Existing password required to create a new password.' => 'Derzeitiges Passwort zur Passwortänderung erforderlich', # Translate - New # OK
	'Enter preferred password.' => 'Bevorzugtes Passwort eingeben', # Translate - New # OK
	'Enter the new password.' => 'Neues Passwort eingeben', # Translate - New # OK
	'This word or phrase will be required to recover a forgotten password.' => 'Dieser Ausdruck wird abgefragt, wenn das Passwort vergessen und ein neues Passwort angefordert wurde.', # Translate - New # OK
	'Save this user (s)' => 'Benutzer speichern',
	'_USAGE_PASSWORD_RESET' => 'Hier können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufälliges neues Passwort erzeugt und an folgende Adresse verschickt: [_1].',
	'Initiate Password Recovery' => 'Passwort wiederherstellen', # Translate - New # OK

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'TrackBacks verwalten', # Translate - Case # OK
	'The selected TrackBack(s) has been approved.' => 'Gewählte TrackBacks freigeschaltet.', # Translate - New # OK
	'All TrackBacks reported as spam have been removed.' => 'Alle als Spam gemeldeten TrackBacks entfernt.', # Translate - New # OK
	'The selected TrackBack(s) has been unapproved.' => 'Gewählte TrackBacks nicht mehr freigeschaltet.', # Translate - New # OK
	'The selected TrackBack(s) has been reported as spam.' => 'Gewählte TrackBack(s) als Spam gemeldet.', # Translate - New # OK
	'The selected TrackBack(s) has been recovered from spam.' => 'Gewählte TrackBacks(s) aus Spam wiederhergestellt', # Translate - New # OK
	'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
	'No TrackBacks appeared to be spam.' => 'Kein TrackBack scheint Spam zu sein.', # Translate - New # OK
	'Quickfilters' => 'Schnellfilter', # Translate - New # OK
	'Show unapproved [_1]' => 'Zeige nicht geprüfte [_1]', # Translate - New # OK
	'[_1] Reported as Spam' => '[_1] als Spam gemeldet', # Translate - New # OK
	'[_1] (Disabled)' => '[_1] (deaktiviert)', # Translate - New # OK
	'Set Web Services Password' => 'Webdienste-Passwort wählen', # Translate - Improved (2) # OK
	'All [_1]' => 'Alle [_1]', # Translate - New # OK
	'change' => 'ändern', # Translate - New # OK
	'[_1] where [_2].' => '[1] bei denen [_2].', # Translate - New # OK
	'[_1] where [_2] is [_3]' => '[_1] bei denen [_2] [_3] ist.', # Translate - New # OK
	'Remove filter' => 'Filter löschen', # Translate - New # OK
	'Show only [_1] where' => 'Zeige nur [_1] bei denen', # Translate - New # OK
	'status' => 'Status',
	'is' => 'ist',
	'approved' => 'Freigeschaltet', # Translate - Case # OK
	'unapproved' => 'Nicht freigeschaltet', # Translate - New # OK
	'Filter' => 'Filter',
	'to publish' => 'zu Veröffentlichen',
	'Publish' => 'Veröffentlichen',
	'Publish selected TrackBacks (p)' => 'Ausgewählte TrackBacks veröffentlichen (p)',
	'Delete selected TrackBacks (x)' => 'Ausgewählte TrackBacks löschen (x)',
	'Report as Spam' => 'Als Spam melden', # Translate - New # OK
	'Report selected TrackBacks as spam (j)' => 'Gewählte TrackBacks als Spam melden (j)', # Translate - New # OK
	'Not Junk' => 'Kein Spam', # Translate - Improved (1) # OK
	'Recover selected TrackBacks (j)' => 'Ausgewählte TrackBacks wiederherstellen (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'Wirklich alle als Spam gemeldeten TrackBacks löschen?', # Translate - New # OK
	'Empty Spam Folder' => 'Spam-Ordner leeren', # Translate - New # OK
	'Deletes all TrackBacks reported as spam' => 'Löscht alle als Spam gemeldeten TrackBacks', # Translate - New # OK

## tmpl/cms/login.tmpl
	'Signed out' => 'Abgemeldet', # Translate - New # OK
	'Your Movable Type session has ended.' => 'Ihre Movable Type-Sitzung ist abgelaufen.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Unten können Sie sich erneut anmelden.', # Translate - New # OK
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an um den Vorgang fortzusetzen.', # Translate - New # OK

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fehler: Movable Type konnte kein Verzeichnis zur Veröffentlichung Ihres Blogs anlegen. Wenn Sie das Verzeichnis manuell angelegt haben, stellen Sie bitte sicher, daß der Webserver Schreibrechte für das Verzeichnis hat.', # Translate - New # OK
	'Your blog\'s archive configuration has been saved.' => 'Archivkonfiguration gespeichert.', # Translate - New # OK
	'You have successfully added a new archive-template association.' => 'Sie haben erfolgreich eine neue Verknüpfung zwischen Archiv und Template hinzugefügt.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Eventuell müssen Sie Ihr \'Master Archive Index\'-Template aktualisieren, um die neue Archiv-Konfiguration zu übernehmen.',
	'The selected archive-template associations have been deleted.' => 'Die ausgewählten Verknüpfungen zwischen Archiv und Template wurden gelöscht.',
	'You must set your Local Site Path.' => 'Sie müssen den Pfad Ihres lokalen Verzeichnis festlegen.',
	'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an.',
	'You must set a valid Local Site Path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an.',
	'Publishing Paths' => 'System-Pfade',
	'Site URL' => 'Webadresse (URL)',
	'The URL of your website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/blog/' => 'Die URL Ihrer Website. Bitte geben Sie die Adresse ohne Dateinamen ein, beispielsweise so: http://www.beispiel.de/blog/', # Translate - New # OK
	'Unlock this blog&rsquo;s site URL for editing' => 'Blog-URL manuell bearbeiten', # Translate - New # OK
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Hinweis: Eine Änderung der Webadresse kann alle Link zu Ihrem Blog ungültig machen.', # Translate - New # OK
	'The path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/blog' => 'Der Pfad, in dem die Indexdateien abgelegt werden. Eine absolute (mit \'/\' beginnende) Pfadangabe wird bevorzugt, Sie können den Pfad aber auch relativ Sie zu Ihrem Movable Type-Verzeichnis angeben. Beispiel: /home/melanie/public_html/blog', # Translate - New # OK
	'Unlock this blog&rsquo;s site path for editing' => 'Pfad manuell bearbeiten', # Translate - New # OK
	'Note: Changing your site root requires a complete rebuild of your site.' => 'Hinweis: Wird das Wurzelverzeichnis geändert, muss im Anchluss die gesamte Site neu veröffentlicht werden.', # Translate - New # OK
	'Advanced Archive Publishing' => 'Erweiterte Archivoptionen', # Translate - New # OK
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Wählen Sie diese Option nur, wenn Sie Ihre Archive außerhalb des Site-Root-Verzeichnisses veröffentlichen müssen.',
	'Publish archives to alternate root path' => 'Archive im alternativen Root-Pfad veröffentlichen',
	'Archive URL' => 'Archivadresse', # Translate - New # OK
	'Enter the URL of the archives section of your website. Example: http://archives.example.com/' => 'Geben Sie die Adresse der Archivsektion Ihrer Website ein, beispielsweise http://archiv.beispiel.de/', # Translate - New # OK
	'Unlock this blog&rsquo;s archive url for editing' => 'Archivadresse manuell bearbeiten', # Translate - New # OK
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Hinweis: Eine Änderung der Archivadresse kann alle Links zu Ihrem Blog ungültig machen.', # Translate - New # OK
	'Enter the path where your archive files will be published. Example: /home/melody/public_html/archives' => 'Geben Sie den lokalen Pfad zu Ihrem Archiv ein, beispielsweise /home/melanie/public_html/archiv', # Translate - New # OK
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Warnung: Eine Änderung des Archivpfads kann sämtliche Links zu Ihrem Blog ungültig machen.', # Translate - New # OK
	'Publishing Options' => 'Veröffentlichungsoptionen', # Translate - New # OK
	'Preferred Archive Type' => 'Bevorzugter Archivtyp', # Translate - New # OK
	'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Wenn Sie Einzeleinträge verlinken möchten, z.B. über den Permalink, und mehrere Archivarten zur Verfügung stehen, müssen Sie sich entscheiden, auf welchen Archivtyp Sie den Link setzen möchten.',
	'No archives are active' => 'Archive nicht aktiviert', # Translate - New # OK
	'Dynamic Publishing' => 'Dynamisches Veröffentlichen', # Translate - New # OK
	'Build all templates statically' => 'Alle Templates statisch aufbauen',
	'Build only Archive Templates dynamically' => 'Nur Archiv-Templates dynamisch aufbauen',
	'Set each template\'s Build Options separately' => 'Optionen für jedes Template einzeln setzen',
	'Build all templates dynamically' => 'Alle Vorlagen dynamisch aufbauen', # Translate - New # OK
	'Enable Dynamic Cache' => 'Dynamischen Cache aktivieren', # Translate - New # OK
	'Turn on caching.' => 'Cache verwenden', # Translate - New # OK
	'Enable caching' => 'Cache aktivieren', # Translate - New # OK
	'Enable Conditional Retrieval' => 'Conditional Retrieval aktivieren', # Translate - New # OK
	'Turn on conditional retrieval of cached content.' => 'Conditional Retrieval von Cache-Inhalten aktivieren', # Translate - New # OK
	'Enable conditional retrieval' => 'Conditional Retrieval aktivieren', # Translate - New # OK
	'File Extension for Archive Files' => 'Dateierweiterung für Archivdateien', # Translate - New # OK
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Geben Sie die gewünschte Erweiterung der Archivdateien an. Möglich sind \'html\', \'shtml\', \'php\' usw. Hinweis: Geben Sie nicht den führenden Punkt (\'.\') ein.',
	'Archive Types' => 'Archivarten', # Translate - Improved (2) # OK
	'Archive types to publish.' => 'Zu veröffentlichende Archivarten', # Translate - New # OK
	'(TemplateMap Not Found)' => '(TemplateMap nicht gefunden)', # Translate - New # OK

## tmpl/cms/cfg_prefs.tmpl
	'Your blog preferences have been saved.' => 'Ihre Blog-Einstellungen wurden gespeichert.',
	'You must set your Blog Name.' => 'Sie haben keinen Blognamen gewählt', # Translate - New # OK
	'You did not select a timezone.' => 'Sie haben keine Zeitzone ausgewählt.',
	'Name your blog. The blog name can be changed at any time.' => 'Geben Sie Ihrem Blog einen Namen. Der Name kann jederzeit geändert werden.', # Translate - New # OK
	'Enter a description for your blog.' => 'Geben Sie eine Beschreibung Ihres Blogs ein.', # Translate - New # OK
	'Timezone' => 'Zeitzone', # Translate - New # OK
	'Select your timezone from the pulldown menu.' => 'Zeitzone des Weblogs',
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
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Osteuropäische Zeit)', # Translate - Improved (1) # OK
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
	'User Registration' => 'Benutzerregistrierung', # Translate - New # OK
	'Allow registration for Movable Type.' => 'Registrierung bei Movable Type freischalten', # Translate - New # OK
	'Registration Not Enabled' => 'Registierung nicht freischalten', # Translate - New # OK
	'Note: Registration is currently disabled at the system level.' => 'Hinweis: Registrierung derzeit systemweit deaktiviert.', # Translate - New # OK
	'Your blog is currently licensed under:' => 'Ihr Blog ist derzeit lizenziert unter:', # Translate - New # OK
	'Change your license' => 'Lizenz ändern',
	'Remove this license' => 'Lizenz entfernen',
	'Your blog does not have an explicit Creative Commons license.' => 'Für dieses Blog liegt keine Creative Commons-Lizenz vor.', # Translate - New # OK
	'Create a license now' => 'Jetzt eine Lizenz erstellen',
	'Select a Creative Commons license for the entries on your blog (optional).' => 'Wählen Sie eine Creative Commons-Lizenz für Ihre Blogeinträge (optional)', # Translate - New # OK
	'Be sure that you understand these licenses before applying them to your own work.' => 'Sie sollten die Lizenzen verstehen, bevor Sie sie auf Ihre Arbeit anwenden.',
	'Read more.' => 'Weitere Informationen',
	'Replace Word Chars' => 'Word-Zeichen ersetzen', # Translate - New # OK
	'Replace Fields' => 'Felder ersetzen', # Translate - New # OK
	'Extended entry' => 'Erweiterter Eintrag', # Translate - Case # OK
	'Smart Replace' => 'Smart Replace', # Translate - New # OK
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entitäten (&amp#8221;, &amp#8220; usw.)', # Translate - New # OK
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'ASCII-Äquivalente (&quot;, \', ..., -, --)', # Translate - New # OK

## tmpl/cms/error.tmpl

## tmpl/cms/list_association.tmpl
	'User Associations for [_1]' => 'Benutzerverknüpfungen für [_1]', # Translate - New # OK
	'Group Associations for [1]' => 'Gruppenverknüpfungen für [_1]', # Translate - New # OK
	'Users &amp; Groups for [_1]' => 'Benutzer und Gruppen für [_1]', # Translate - New # OK
	'Users for [_1]' => 'Benutzer für  [_1]', # Translate - New # OK
	'Remove selected assocations (x)' => 'Gewählte Verknüpfungen entfernen (x)',
	'association' => 'Verknüpfung',
	'associations' => 'Verknüpfungen',
	'Group Disabled' => 'Gruppe deaktiviert',
	'_USAGE_ASSOCIATIONS' => 'Verknüpfungen ansehen und anlegen',
	'You have successfully removed the association(s).' => 'Verknüpfung(en) erfolgreich entfernt',
	'You have successfully created the association(s).' => 'Verknüpfung(en) erfolgreich angelegt',
	'Add user to a weblog' => 'Benutzer zu Weblog hinzufügen',
	'You can not create associations for disabled users.' => 'Für deaktivierte Benutzerkonten können keine Verknüpfungen angelegt werden',
	'Add [_1] to a weblog' => '[_1]  zu Weblog hinzufügen',
	'Add group to a weblog' => 'Gruppe zu Weblog hinzufügen',
	'You can not create associations for disabled groups.' => 'Für deaktivierte Gruppen können keine Verknüpfungen angelegt werden',
	'Assign role to a new group' => 'Rolle einer neuer Gruppe zuweisen',
	'Assign Role to Group' => 'Rolle an Gruppe zuweisen',
	'Assign role to a new user' => 'Rolle einem neuen Benutzer zuweisen',
	'Assign Role to User' => 'Rolle an Benutzer zuweisen',
	'Add a group to this weblog' => 'Gruppe zu diesem Weblog hinzufügen',
	'Add a user to this weblog' => 'Benutzer zu diesem Weblog hinzufügen',
	'Create a Group Association' => 'Gruppenverknüpfung anlegen',
	'Create a User Association' => 'Benutzerverknüpfung anlegen',
	'User/Group' => 'Benutzer/Gruppe',
	'Created On' => 'Angelegt am/um',
	'No associations could be found.' => 'Keine Verknüpfungen gefunden.',

## tmpl/cms/list_comment.tmpl
	'The selected comment(s) has been approved.' => 'Die gewählten Kommentare wurden freigegeben.', # Translate - New # OK
	'All comments reported as spam have been removed.' => 'Alle als Spam markierten Kommentare wurden entfernt.', # Translate - New # OK
	'The selected comment(s) has been unapproved.' => 'Die gewählten Kommentare sind nicht mehr freigegeben', # Translate - New # OK
	'The selected comment(s) has been reported as spam.' => 'Die gewählten Kommentare wurden als Spam gemeldet', # Translate - New # OK
	'The selected comment(s) has been recovered from spam.' => 'Die gewählten Kommentare wurden aus dem Spam wiederhergestellt', # Translate - New # OK
	'The selected comment(s) has been deleted from the database.' => 'Kommentar(e) aus der Datenbank gelöscht.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
	'No comments appeared to be spam.' => 'Kein Kommentar scheint Spam zu sein.', # Translate - New # OK
	'Showing only: [_1]' => 'Zeige nur: [_1]', # Translate - New # OK
	'[_1] on entries created within the last [_2] days' => '[1] zu Einträgen, die in den letzten [_2] Tagen angelegt wurden', # Translate - New # OK
	'[_1] on entries created more than [_2] days ago' => '[_1] zu Einträgen, die vor mehr als [_2] Tagen angelegt wurden', # Translate - New # OK
	'[_1] where [_2] [_3]' => '[_1] bei denen [_2] [_3]', # Translate - New # OK
	'Show' => 'Zeige',
	'all' => 'alle',
	'only' => 'nur',
	'[_1] where' => '[_1] bei denen', # Translate - New # OK
	'entry was created in last' => 'Eintrag angelegt wurde in den letzten', # Translate - New # OK
	'entry was created more than' => 'Eintrag angelegt wurde länger als vor', # Translate - New # OK
	'commenter' => 'Kommentarautor', # Translate - Improved (1) # OK
	' days.' => 'Tagen.', # Translate - New # OK
	' days ago.' => 'Tagen.', # Translate - New # OK
	' is approved' => 'ist freigegeben', # Translate - New # OK
	' is unapproved' => 'ist nicht freigegeben', # Translate - New # OK
	' is unauthenticated' => 'ist nicht authenifiziert', # Translate - New # OK
	' is authenticated' => 'ist authentifiziert', # Translate - New # OK
	' is trusted' => 'ist vertraut', # Translate - New # OK
	'Approve' => 'Freigeben', # Translate - New # OK
	'Approve selected comments (p)' => 'Markierte Kommentare freigeben (p)', # Translate - New # OK
	'Delete selected comments (x)' => 'Markierte Kommentare löschen (x)',
	'Report the selected comments as spam (j)' => 'Markierte Kommentare als Spam melden (j)', # Translate - New # OK
	'Recover from Spam' => 'Aus Spam wiederherstellen', # Translate - New # OK
	'Recover selected comments (j)' => 'Kommentare wiederherstellen (j)',
	'Are you sure you want to remove all comments reported as spam?' => 'Wirklich alle als Spam gemeldeten Kommentare löschen?', # Translate - New # OK
	'Deletes all comments reported as spam' => 'Alle als Spam gemeldeten Kommentare löschen', # Translate - New # OK

## tmpl/cms/admin.tmpl
	'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'Hier können Sie Ihr Gesamtsystem verwalten und Einstellungen für alle Weblogs vornehmen.',
	'List Weblogs' => 'Weblogs anzeigen',
	'List Users and Groups' => 'Benutzer und Gruppen anzeigen',
	'List Associations and Roles' => 'Verknüpfungen und Rollen',
	'Privileges' => 'Berechtigungen',
	'List Plugins' => 'Plugins anzeigen',
	'Aggregate' => 'Übersicht',
	'List Tags' => 'Tags anzeigen',
	'Edit System Settings' => 'Systemeinstellungen bearbeiten',
	'Show Activity Log' => 'Aktivitätsprotokoll anzeigen',
	'System Stats' => 'Systemstatistik',
	'Active Users' => 'Aktive Benutzeren',
	'Version' => 'Version',
	'Essential Links' => 'Wichtige Weblinks',
	'Movable Type Home' => 'Movable Type-Website',
	'Plugin Directory' => 'Plugin-Verzeichnis',
	'Support and Documentation' => 'Support und Dokumentation',
	'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account?portal=de',
	'Your Account' => 'Ihr Movable Type-Account',
	'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit&portal=de',
	'Open a Help Ticket' => 'Hilfe-Ticket öffnen',
	'Paid License Required' => 'Bezahlte MT-Version erforderlich',
	'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/',
	'http://www.sixapart.com/movabletype/kb/' => 'http://www.sixapart.com/movabletype/kb/',
	'Knowledge Base' => 'Wissensdatenbank',
	'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/',
	'Professional Network' => 'Professional Network',
	'Movable Type News' => 'News von Movable Type',
	'Add blog_id to see additional settings links.' => 'Geben Sie die blog_id an, um einen Link zu den erweiterten Einstellungen angezeigt zu bekommen.', # Translate - New # OK

## tmpl/cms/rebuilding.tmpl
	'Rebuilding' => 'Neu veröffentlichen', # Translate - New # OK
	'Rebuilding [_1]' => 'Veröffentliche [_1]',
	'Rebuilding [_1] pages [_2]' => 'Baue [_1] Seiten neu auf [_2]',
	'Rebuilding [_1] dynamic links' => 'Baue [_1] dynamische Links neu auf',
	'Rebuilding [_1] pages' => 'Baue [_1] Seiten neu auf',

## tmpl/cms/include/template_table.tmpl
	'Dynamic' => 'Dynamisch',
	'Linked' => 'Verlinkt',
	'Built w/Indexes' => 'mit Index',
	'Dymanic Template' => 'Dynamische Vorlage', # Translate - New # OK
	'Linked Template' => 'Verlinkte Vorlage', # Translate - New # OK
	'Built Template w/Indexes' => 'Vorlagen mit Indizes aufbauen', # Translate - New # OK

## tmpl/cms/include/typekey.tmpl
	'Your TypeKey API Key is used to access Six Apart services like its free Authentication service.' => 'Ihr TypeKey API-Schlüssel wird zur Nutzung von Six Apart-Diensten wie unserem kostenlosen Authentifizierungdienst verwendet.', # Translate - New # OK
	'TypeKey Enabled' => 'TypeKey aktiviert', # Translate - New # OK
	'TypeKey is enabled.' => 'TypeKey wird verwendet.', # Translate - New # OK
	'Clear TypeKey Token' => 'TypeKey-Token löschen', # Translate - New # OK
	'TypeKey Setup:' => 'TypeKey-Einstellungen:', # Translate - New # OK
	'TypeKey API Key Removed' => 'TypeKey API-Schlüssel entfernt', # Translate - New # OK
	'Please click the Save Changes button below to disable authentication.' => 'Bitte klicken Sie auf Änderungen speichern, um die Authentifizierung abzuschalten.',
	'TypeKey Not Enabled' => 'TypeKey nicht aktiviert', # Translate - New # OK
	'TypeKey is not enabled.' => 'TypeKey wird nicht verwendet', # Translate - New # OK
	'Enter API Key:' => 'API-Schlüssel eingeben:', # Translate - New # OK
	'Obtain TypeKey API Key' => 'TypeKey API-Schlüssel beziehen', # Translate - New # OK
	'TypeKey API Key Acquired' => 'TypeKey API-Schlüssel bezogen', # Translate - New # OK
	'Please click the Save Changes button below to enable TypeKey.' => 'Bitte klicken Sie auf Änderungen speichern, um TypeKey zu aktivieren.', # Translate - New # OK

## tmpl/cms/include/cfg_entries_edit_page.tmpl
	'Editor Fields' => 'Eingabefelder',
	'_USAGE_ENTRYPREFS' => 'Die Feldkonfiguration legt fest, welche Felder in Ihrer Eingabemaske für neue Einträge erscheinen. Sie könnnen die vordefinierten Einstellungen verwenden (einfach oder erweitert) oder die Felder frei auswählen.',
	'Custom' => 'Eigene',
	'Action Bar' => 'Menüleiste',
	'Select the location of the entry editor\'s action bar.' => 'Gewünschte Position der Menüleiste',
	'Below' => 'Oben',
	'Above' => 'Unten',

## tmpl/cms/include/archive_maps.tmpl
	'Preferred' => 'Bevorzugt',
	'Custom...' => 'Angepasst...',

## tmpl/cms/include/pagination.tmpl
	'Previous' => 'Zurück',
	'Newer' => 'Neuer',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] von [_3]', # Translate - New # OK
	'Older' => 'Älter',

## tmpl/cms/include/footer.tmpl
	'Widget Title' => 'Widget-Name', # Translate - New # OK
	'Dashboard' => 'Dashboard', # Translate - New # OK
	'Compose Entry' => 'Eintrag schreiben', # Translate - New # OK
	'Manage Entries' => 'Einträge verwalten', # Translate - New # OK
	'System Settings' => 'Systemkonfiguration', # Translate - New # OK
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> Version [_2]', # Translate - New # OK
	'with' => 'mit', # Translate - New # OK

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Weitere Aktionen...',
	'to act upon' => 'bearbeiten',
	'Go' => 'Ausführen',

## tmpl/cms/include/ping_table.tmpl
	'From' => 'Von',
	'Target' => 'Auf',
	'Only show published TrackBacks' => 'Nur veröffentlichte TrackBacks anzeigen',
	'Only show pending TrackBacks' => 'Nur nicht veröffentlichte TrackBacks anzeigen',
	'Edit this TrackBack' => 'TrackBack bearbeiten',
	'Go to the source entry of this TrackBack' => 'Zum Eintrag wechseln, auf den sich das TrackBack bezieht',
	'View the [_1] for this TrackBack' => '[_1] zu dem TrackBack ansehen',
	'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',

## tmpl/cms/include/anonymous_comment.tmpl
	'Require E-mail Address for Anonymous Comments' => 'E-Mail-Adresse von anonymen Kommentarautoren verlangen', # Translate - New # OK
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn diese Option aktiv ist, müssen Kommentarautoren eine gültige Email-Adresse angeben.',

## tmpl/cms/include/header.tmpl
	'Send us your feedback on Movable Type' => 'Senden Sie uns Ihr Feedback zu Movable Type', # Translate - New # OK
	'Feedback?' => 'Feedback?', # Translate - New # OK
	'Hi [_1]' => 'Hallo [_1]', # Translate - New # OK
	'All blogs' => 'in allen Blogs', # Translate - Case # OK
	'Select another blog...' => 'Anderes Bog wählen', # Translate - New # OK
	'Create a new blog' => 'Neues Blog anlegen', # Translate - New # OK
	'Write Entry' => 'Eintrag schreiben', # Translate - New # OK
	'Blog Dashboard' => 'Blog-Dashboard', # Translate - New # OK
	'View' => 'Ansehen', # Translate - New # OK

## tmpl/cms/include/cfg_system_content_nav.tmpl
	'General' => 'Allgemein',

## tmpl/cms/include/tools_content_nav.tmpl
	'Export' => 'Exportieren', # Translate - New # OK

## tmpl/cms/include/blog-left-nav.tmpl
	'Backup this weblog' => 'Dieses Weblog sichern',

## tmpl/cms/include/entry_table.tmpl
	'Blog' => 'Blog',
	'Only show unpublished [_1]' => 'Nur nicht veröffentlichte [_1] zeigen', # Translate - New # OK
	'Only show published [_1]' => 'Nur veröffentlichte [_1] zeigen', # Translate - New # OK
	'Only show scheduled [_1]' => 'Nur zeitgeplante [_1] zeigen', # Translate - New # OK
	'View [_1]' => 'Zeige [_1]', # Translate - New # OK

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Hinzugefügt am',
	'Click to edit notification list item' => 'Klicken, um Benachrichtigungsliste zu bearbeiten', # Translate - New # OK
	'No notifications could be found.' => 'Keine Benachrichtigung gefunden.',

## tmpl/cms/include/display_options.tmpl
	'[quant,_1,row]' => '[quant,_1,Zeile,Zeilen]',
	'Compact' => 'Kompakt',
	'Expanded' => 'Erweitert',
	'Date Format' => 'Datumsformat', # Translate - New # OK
	'Relative' => 'Relativ (z.B. "Vor 20 Minuten")',
	'Full' => 'Voll',

## tmpl/cms/include/cfg_content_nav.tmpl
	'Spam' => 'Spam', # Translate - New # OK
	'Web Services' => 'Web-Dienste', # Translate - New # OK

## tmpl/cms/include/blog_table.tmpl
	'Weblog Name' => 'Weblog-Name',
	'No weblogs could be found.' => 'Keine Weblogs gefunden.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Alle Daten wurden erfolgreich gesichert!',
	'Download This File' => 'Diese Datei herunterladen',
	'_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING',
	'_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE',
	'An error occurred during the backup process: [_1]' => 'Beim Backup ist ein Fehler aufgetreten: [_1]',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importieren...',
	'Importing entries into blog' => 'Importiere Einträge...',
	'Importing entries as user \'[_1]\'' => 'Importiere als Benutzer \'[_1]\'...',
	'Creating new users for each user found in the blog' => 'Lege Benutzerkonten an...',

## tmpl/cms/include/users_content_nav.tmpl
	'User Profile' => 'Benutzerprofil',
	'Groups' => 'Gruppen',
	'Group Profile' => 'Gruppenprofile',
	'Details' => 'Details',
	'List Roles' => 'Rollen zeigen', # Translate - New # OK

## tmpl/cms/include/calendar.tmpl

## tmpl/cms/include/overview-left-nav.tmpl

## tmpl/cms/include/comment_table.tmpl
	'Reply' => 'Antworten', # Translate - New # OK
	'Only show published comments' => 'Nur veröffentlichte Kommentare anzeigen',
	'Only show pending comments' => 'Nur nicht veröffentlichte Kommentare anzeigen',
	'Edit this comment' => 'Kommentar bearbeiten',
	'(1 reply)' => '(1 Antwort)', # Translate - New # OK
	'([_1] replies)' => '([_1] Antworten)', # Translate - New # OK
	'Edit this [_1] commenter' => '[_1] Kommentarautor bearbeiten', # Translate - New # OK
	'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentator suchen',
	'View this entry' => 'Eintrag ansehen',
	'Show all comments on this entry' => 'Alle Kommentare zu diesem Eintrag anzeigen',

## tmpl/cms/include/rebuild_stub.tmpl
	'To see the changes reflected on your public site, you should rebuild your site now.' => 'Damit die Änderungen sichtbar werden, sollten Sie das Blog jetzt neu veröffentlichen.',
	'Rebuild my site' => 'Weblog neu veröffentlichen',

## tmpl/cms/include/chromeless_footer.tmpl

## tmpl/cms/include/backup_start.tmpl
	'Tools: Backup' => 'Tools: Sicherung', # Translate - New # OK
	'Backing up Movable Type' => 'Movable Type-Sicherungskopie erstellen', # Translate - New # OK

## tmpl/cms/include/commenter_table.tmpl
	'Identity' => 'ID',
	'Last Commented' => 'Zuletzt kommentiert', # Translate - New # OK
	'Only show trusted commenters' => 'Nur vertrauenswürdige Kommentarautoren anzeigen',
	'Only show banned commenters' => 'Nur gesperrte Kommentarautoren anzeigen',
	'Only show neutral commenters' => 'Nur neutrale Kommentarautoren anzeigen',
	'Authenticated' => 'Authentifiziert',
	'Edit this commenter' => 'Kommentarautor bearbeiten',
	'View this commenter&rsquo;s profile' => 'Profil des Kommentarautors ansehen', # Translate - New # OK
	'No commenters could be found.' => 'Keine Kommentarautoren gefunden.',

## tmpl/cms/include/author_table.tmpl
	'Only show enabled users' => 'Nur aktive Benutzerkonten anzeigen',
	'Only show pending users' => 'Nur schwebenden Benutzerkonten anzeigen',
	'Only show disabled users' => 'Nur deaktivierte Benutzerkoten anzeigen',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Aktivitäts-Feed',
	'Disabled' => 'Ausgeschaltet',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Import erfolgreich abgeschlossen!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem \'import\'-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden. ',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. Alle Rechte vorbehalten.', # Translate - New # OK

## tmpl/cms/include/log_table.tmpl
	'Log Message' => 'Protokollnachricht',
	'_LOG_TABLE_BY' => '_LOG_TABLE_BY',
	'IP: [_1]' => 'IP: [_1]',
	'[_1]' => '[_1]', # Translate - New # OK
	'No log records could be found.' => 'Keine Log-Einträge gefunden.',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Schritt [_1] von [_2]',
	'Go to [_1]' => 'Gehe zu [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Keine Treffer. Bitte suchen Sie erneut.',
	'Sorry, there is no data for this object set.' => 'Keine Daten für diese Objekte vorhanden.',
	'Back' => 'Zurück',
	'Confirm' => 'Bestätigen',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'Die Weblogs wurden erfolgreich aus dem System gelöscht.',
	'weblog' => 'Weblog',
	'weblogs' => 'Weblogs',
	'Delete selected weblogs (x)' => 'Ausgewählte Weblogs löschen (x)',
	'Are you sure you want to delete this weblog?' => 'Möchten Sie dieses Weblog wirklich löschen?',
	'Create New Weblog' => 'Neues Weblog anlegen',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Zeit für Ihr Upgrade!',
	'Upgrade Check' => 'Upgrade-Überprüfung',
	'Do you want to proceed with the upgrade anyway?' => 'Upgrade dennoch fortsetzen?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Zusätzlich müssen folgende Movable Type-Komponenten installiert oder aktualisiert werden:', # Translate - New # OK
	'The following Movable Type components require upgrading or installation:' => 'Die folgenden Movable Type-Komponenten müssen installiert oder aktualisiert werden:', # Translate - New # OK
	'Begin Upgrade' => 'Upgrade durchführen',
	'Your Movable Type installation is already up to date.' => 'Ihre Movable Type-Installation ist bereits auf dem neuesten Stand.',
	'Return to Movable Type' => 'Zurück zu Movable Type',

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Systemweite Benutzerkonten', # Translate - New # OK
	'_USAGE_AUTHORS_LDAP' => 'Eine Liste aller Benutzerkonten dieser Movable Type-Installation. Durch Anklicken eines Namens können Sie die Rechte des jeweiligen Benutzers festlegen. Um einen Benutzerkonto zu sperren, wählen Sie das Kontrollkästchen neben dem entsprechenden Namen an und klicken auf DEAKTIVIEREN. Der jeweilige Benutzer kann sich dann nicht mehr anmelden.',
	'_USAGE_AUTHORS_1' => 'Eine Liste aller Benutzerkonten dieser Movable Type-Installation. Sie können die Zugriffsrechte eines Benutzers bearbeiten, indem Sie dessen Namen anklicken. Nutzen Sie die Kontrollkästchen neben den Benutzernamen, um Aktionen aus dem Drop-Down-Menü auszuführen. HINWEIS: "Löschen" entfernt Benutzerkonten dauerhaft und unwiderruflich. Wenn Sie einen Benutzer lediglich aus einem bestimmten Blog entfernen möchten, löschen Sie nicht sein Konto, sondern ändern Sie dessen Zugriffsrechte entsprechend. Sie können Benutzerkonten auch über CSV-Steuerungsdateien anlegen, bearbeiten und löschen.',
	'You have successfully disabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich enaktiviert',
	'You have successfully enabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich aktiviert',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Gewählte Benutzerkonten erfolgreich aus Movable Type gelöscht',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'Die gelöschten Benutzerkonten sind im externen Verzeichnis weiterhin vorhanden. Die Benutzer können sich daher weiterhin an Movable Type Enterprise anmelden.',
	'You have successfully synchronized users\' information with the external directory.' => 'Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie im externen Verzeichnis nicht mehr vorhanden sind.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Bei der Synchronisation ist ein Fehler aufgetreten. Sichten Sie das <a href=\'[_1]\'>Aktivitätsprotokoll</a> für nähere Informationen.',
	'Show Enabled Users' => 'Zeige aktivierte Benutzerkonten', # Translate - New # OK
	'Show Disabled Users' => 'Zeige deaktivierte Benutzerkoten', # Translate - New # OK
	'Show All Users' => 'Zeige alle Benutzerkonten', # Translate - New # OK
	'user' => 'Benutzer',
	'users' => 'Benutzer', # Translate - Improved (1) # OK
	'_USER_ENABLE' => 'Aktivieren',
	'Enable selected users (e)' => 'Gewählte Benutzerkonten aktivieren (e)',
	'_NO_SUPERUSER_DISABLE' => 'Sie sind Administrator dieser Movable Type-Installation. Daher können Sie nicht Ihr eigenes Benutzerkonto deaktivieren.',
	'_USER_DISABLE' => 'Deaktivieren',
	'Disable selected users (d)' => 'Gewählte Benutzerkonten deaktivieren (d)',
	'None.' => 'Keine',
	'(Showing all users.)' => '(Alle Benutzer)',
	'Showing only users whose [_1] is [_2].' => 'Nur Benutzer bei denen [_1] [_2] ist',
	'users.' => 'Benutzer',
	'users where' => 'Benutzer mit: ',
	'enabled' => 'aktiviert',
	'disabled' => 'deaktiviert',
	'.' => '.',
	'No users could be found.' => 'Keine Benutzer gefunden.',

## tmpl/cms/author_bulk.tmpl
	'Manage Users in bulk' => 'Bulk-Benutzerverwaltung', # Translate - New # OK
	'_USAGE_AUTHORS_2' => 'Sie können mittels CSV-Steuerungsdateien Benutzerkonten anlegen, bearbeiten und löschen.',
	'Upload source file' => 'Quelldatei hochladen',
	'Specify the CSV-formatted source file for upload' => 'Hochzuladende CSV-Datei angeben', # Translate - New # OK
	'Source File Encoding' => 'Codierung der Quelldatei', # Translate - New # OK
	'Upload (u)' => 'Hochladen (u)',

## tmpl/cms/popup/recover.tmpl
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Ihr Passwort wurde geändert, und das neue Passwort wurde an Ihre E-Mail-Adresse gesendet ([_1]).',
	'Return to sign in to Movabale Type' => 'Zur Movable Type-Anmeldeseite zurückkehren', # Translate - New # OK
	'Enter your Movable Type username:' => 'Geben Sie Ihren Benutzernamen ein:',
	'Enter your password recovery word/phrase:' => 'Geben Sie Ihren Erinnerungssatz ein:',
	'Recover' => 'Passwort anfordern',

## tmpl/cms/popup/bm_entry.tmpl
	'Select' => 'Auswählen...',
	'Add new category...' => 'Neue Kategorie hinzufügen...',
	'You must choose a weblog in which to create the new entry.' => 'Bitte wählen Sie, in welchem Weblog der neue Eintrag erscheinen soll.', # Translate - New # OK
	'Select a weblog for this entry:' => 'Weblog für diesen Eintrag ausäwhlen:', # Translate - New # OK
	'Select a weblog' => 'Weblog auswählen',
	'Assign Multiple Categories' => 'Mehrere Kategorien zuweisen',
	'Entry Body' => 'Text',
	'Insert Link' => 'Link einfügen',
	'Insert Email Link' => 'Email-Link einfügen',
	'Quote' => 'Zitat',
	'Extended Entry' => 'Erweiterter Eintrag',
	'Send an outbound TrackBack:' => 'TrackBack (outbound) senden:',
	'Select an entry to send an outbound TrackBack:' => 'Eintrag wählen, zu dem Sie TrackBack senden möchten:',
	'Unlock this entry\'s output filename for editing' => 'Dateiname zur Bearbeitung entsperren',
	'Save this entry (s)' => 'Eintrag speichern (s)',
	'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'Sie haben derzeit keine Rechte, Weblogs zu bearbeiten. Bitte kontaktieren Sie Ihren Administrator',

## tmpl/cms/popup/show_upload_html.tmpl
	'Copy and paste this HTML into your entry.' => 'Kopieren Sie den HTML-Code, und fügen Sie ihn in den Eintrag ein.',
	'Upload Another' => 'Weitere hochladen',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Erfolg', # Translate - New # OK
	'All of your files have been rebuilt.' => 'Alle Dateien wurden neu veröffentlicht.', # Translate - Improved (3) # OK
	'Your [_1] pages have been rebuilt.' => '[_1]-Seiten wurden neu veröffentlicht.',
	'View your site' => 'Weblog ansehen',
	'View this page' => 'Diese Seite anzeigen',
	'Rebuild Again' => 'Erneut neu veröffentlichen', # Translate - Improved (1) # OK

## tmpl/cms/popup/bm_posted.tmpl
	'Your new entry has been saved to [_1]' => 'Ihr Eintrag wurde in [_1] gespeichert',
	', and it has been published to your site' => ' unbd auf Ihrer Site veröffentlicht.', # Translate - New # OK
	'. ' => '. ',
	'Edit this entry' => 'Eintrag bearbeiten',

## tmpl/cms/popup/category_add.tmpl
	'Add A [_1]' => '[_1] hinzufügen', # Translate - Case # OK
	'To create a new [_1], enter a title in the field below, select a parent [_1], and click the Add button.' => 'Um eine neue [_1] anzulegen, geben Sie unten einen Titel ein, wählen eine Elternkategorie und klicken auf Hinzufügen.', # Translate - New # OK
	'[_1] Title:' => '[_1]-Name', # Translate - New # OK
	'Parent [_1]:' => 'Eltern-[_1]', # Translate - New # OK
	'Top Level' => 'Oberste Ebene',
	'Save [_1] (s)' => '[_1] speichern (s)', # Translate - New # OK

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Alle Dateien', # Translate - New # OK
	'Index Template: [_1]' => 'Index-Vorlagen: [_1]', # Translate - Improved (1) # OK
	'Indexes Only' => 'Nur Indizes', # Translate - New # OK
	'[_1] Archives Only' => 'Nur [_1]-Archive', # Translate - New # OK
	'Rebuild (r)' => 'Neu aufbauen (r)',
	'Select the type of rebuild you would like to perform. Note: This will not rebuild any templates you have chosen to not automatically rebuild with index templates.' => 'Wählen Sie die gewünschte Art der Neuveröffentlichung. Hinweis: Vorlagen, bei denen automatische Neuveröffentlichung nicht aktiviert ist, sind hiervon nicht betroffen.',

## tmpl/cms/popup/pinged_urls.tmpl
	'Here is a list of the previous TrackBacks that were successfully sent:' => 'Liste aller bereits erfolgreich gesendeten TrackBacks:',
	'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Liste aller bisher fehlgeschlagenen TrackBacks. Für einen erneuten Sendeversuch bitte in die Liste der zu sendenden TrackBacks kopieren.',

## tmpl/cms/list_entry.tmpl
	'Your [_1] has been deleted from the database.' => '[_1] aus Datenbank gelöscht.', # Translate - New # OK
	'Go back' => 'Zurück', # Translate - Case # OK
	'tag (exact match)' => 'Tag (exakt)',
	'tag (fuzzy match)' => 'Tag (fuzzy)',
	'published' => 'veröffentlicht',
	'unpublished' => 'nicht veröffentlicht',
	'scheduled' => 'zeitgeplant',
	'Select A User:' => 'Benutzerkonto auswählen: ',
	'User Search...' => 'Benutzer suchen...',
	'Recent Users...' => 'Letzten Benutzer...',
	'Save these [_1] (s)' => '[_1] speichern (s)', # Translate - New # OK
	'to rebuild' => 'zum erneuten Veröffentlichen',
	'Rebuild selected [_1] (r)' => 'Gewählte [_1] neu veröffentlichen', # Translate - New # OK
	'Delete selected [_1] (x)' => 'Gewählte [_1] löschen', # Translate - New # OK
	'page' => 'Seite', # Translate - Case # OK
	'pages' => 'Seiten', # Translate - Case # OK
	'Rebuild selected pages (r)' => 'Gewählte Seiten neu veröffentlichen (r)', # Translate - New # OK
	'Delete selected pages (x)' => 'Gewählte Seiten löschen (x)', # Translate - New # OK

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Passwörter wiederherstellen',
	'No users were selected to process.' => 'Es wurden keine Benutzer ausgewählt.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Das Aktivitätsprotokoll wurde zurückgesetzt.',
	'The Movable Type activity log contains a record of notable actions in the system.' => 'Das Movable Type-Aktivitätsprotokoll zeichnet alle Systemvorgänge auf.',
	'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',
	'All times are displayed in GMT.' => 'Alle Zeiten in GMT',
	'Filtered' => 'Gefilterte',
	'Filtered Activity Feed' => 'Gefilterter Aktivitätsfeed', # Translate - New # OK
	'Download Filtered Log (CSV)' => 'Gefiltertes Protokoll herunterladen (CSV)', # Translate - New # OK
	'Download Log (CSV)' => 'Protokoll herunterladen (CSV)', # Translate - New # OK
	'Clear Activity Log' => 'Aktivitätsprotokoll zurücksetzen',
	'Are you sure you want to reset activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
	'Showing all log records' => 'TZeige alle Protokolleinträge', # Translate - New # OK
	'Quickfilter:' => 'Schnellfilter:',
	'Show only errors.' => 'Nur Fehler anzeigen',
	'Showing only log records where' => 'Zeige nur Einträge mit',
	'log records.' => 'Log-Einträge',
	'log records where' => 'Log-Einträge bei denen',
	'level' => 'Level',
	'classification' => 'Thema',
	'Security' => 'Sicherheit',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sicherheit oder Fehler',
	'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
	'Not debug' => 'Kein Debug',
	'Debug/error' => 'Debug/Fehler',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen.',
	'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht.',
	'tag' => 'Tag',
	'tags' => 'Tags',
	'Delete selected tags (x)' => 'Markierte Tags löschen (x)',
	'Tag Name' => 'Tag-Name',
	'Click to edit tag name' => 'Klicken, um Tagname zu bearbeiten',
	'Rename' => 'Umbenennen',
	'Show all entries with this tag' => 'Alle Einträge mit diesem Tag anzeigen',
	'[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
	'No tags could be found.' => 'Keine Tags gefunden',
	'An error occurred while testing for the new tag name.' => 'Fehler beim Überprüfen des neuen Tag-Namens aufgetreten.',

## tmpl/cms/restore.tmpl
	'Perl module XML::SAX and/or its dependencies are missing - Movable Type can not restore the system without it.' => 'Das Per-Modul XML::SAX und/oder seine Abhängigkeiten fehlen. Ohne kann Movable Type das System nicht wiederherstellen.', # Translate - New # OK
	'Upload backup file' => 'Sicherungsdatei hochladen', # Translate - New # OK
	'If your backup file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Wenn Sie eine auf Ihrem Computer gespeicherte Sicherungsdatei verwenden wollen, laden Sie diese hier hoch. Alternativ verwendet Movable Type automatisch die Sicherungsdatei, die es im \'import\'-Unterordner Ihres Movable Type-Verzeichnis findet.', # Translate - New # OK
	'Version verification' => 'Versionsprüfung', # Translate - New # OK
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Anwählen, um auch Dateien mit einer neueren Schemaversionen wiederherstellen zu können. HINWEIS: Nichtbeachtung der Schemaverion kann Ihre Movable Type-Installation dauerhaft beschädigen.', # Translate - New # OK
	'Ignore schema version conflict' => 'Versionskonflikt ignorieren', # Translate - New # OK
	'Restore (r)' => 'Wiederherstellen (r)', # Translate - New # OK

## tmpl/cms/create_author_bulk_start.tmpl
	'Updating...' => 'Aktualisiere...',
	'Updating users by reading the uploaded CSV file' => 'Aktualisiere Benutzerkonten mittels der hochgeladenen CSV-Datei',

## tmpl/cms/list_category.tmpl
	'Your [_1] changes and additions have been made.' => '[_1]-Änderungen erfolgreich durchgeführt.', # Translate - New # OK
	'You have successfully deleted the selected [_1].' => 'Gewählte [_1] erfolgreich gelöscht.', # Translate - New # OK
	'Create new top level [_1]' => 'Neue Haupt-[_1] anlegen', # Translate - New # OK
	'Collapse' => 'Reduzieren',
	'Expand' => 'Erweitern',
	'Move [_1]' => '[_1] verschieben', # Translate - New # OK
	'Move' => 'Verschieben',
	'[quant,_1,<mt:var name="entry_label" lower_case="1">,<mt:var name="entry_label_plural" lower_case="1">]' => '[quant,_1,<mt:var name="entry_label" lower_case="1">,<mt:var name="entry_label_plural" lower_case="1">]', # Translate - New # OK
	'[quant,_1,TrackBack]' => '[quant,_1,TrackBack]',

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Legen Sie Ihr erstes Blog an', # Translate - New # OK
	'The blog name is required.' => 'Blog-Name erforderlich.', # Translate - New # OK
	'The blog url is required.' => 'Blog-URL erforderlich.', # Translate - New # OK
	'The publishing path is required.' => 'Pfadangabe erforderlich.', # Translate - New # OK
	'The timezone is required.' => 'Zeitzone erforderlich.', # Translate - New # OK
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Damit Ihr Blog ordnungsgemäßg veröffentlicht werden kann, geben Sie bitte die Webadresse (URL) und den Dateisystempfad an, in denen Movable Type die erforderlich Dateien ablegen soll.', # Translate - New # OK
	'My First Blog' => 'Mein erstes Blog', # Translate - New # OK
	'Blog URL' => 'Blog-URL', # Translate - New # OK
	'Publishing Path' => 'Veröffentlichungspfad', # Translate - New # OK
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Der Veröffentlichungspfad ist der Pfad auf Ihrem Webserver, in dem Movable Type die für Ihren Blog erforderlichen Dateien ablegt.', # Translate - New # OK
	'Finish install' => 'Installation abschließen', # Translate - Case # OK

## tmpl/cms/create_author_bulk_end.tmpl
	'All users updated successfully!' => 'Alle Benutzerkonten erfolgreich aktualisiert!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Während der Aktualisierung ist ein Fehler aufgetreten. Bitte überprüfen Sie Ihre CVS-Datei.',

## tmpl/cms/list_asset.tmpl
	'Manage Files' => 'Dateien verwalten', # Translate - New # OK
	'You have successfully deleted the file(s).' => 'Die Datei(en) wurden erfolgreich gelöscht.', # Translate - New # OK
	'Show Images' => 'Zeige Bilder', # Translate - New # OK
	'Show Files' => 'Zeige Dateien', # Translate - New # OK
	'type' => 'Typ', # Translate - Case # OK
	'asset' => 'Asset', # Translate - New # OK
	'assets' => 'Assets', # Translate - Case # OK
	'Delete selected assets (x)' => 'Gewählte Assets löschen (x)', # Translate - New # OK

## tmpl/cms/preview_strip.tmpl
	'You are previewing the [_1] titled &ldquo;[_2]&rdquo;' => 'Sie sehen eine Vorschau auf den [_1] namens &ldquo;[_2]&rdquo;', # Translate - New # OK

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'IP-Sperren-Einstellungen',
	'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefgt.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die ausgewählten IP-Adressen erfolgreich aus der Liste entfernt.',
	'Ban New IP Address' => 'Neue IP-Adresse sperren',
	'IP Address' => 'IP-Adresse',
	'Ban IP Address' => 'IP-Adresse sperren',
	'Date Banned' => 'gesperrt am',
	'IP address' => 'IP-Adresse',
	'IP addresses' => 'IP-Adressen',
	'No banned IPs have been added.' => 'Keine gesperrten IP-Adressen hinzugefügt.', # Translate - New # OK

## tmpl/cms/cfg_trackbacks.tmpl
	'TrackBack Settings' => 'TrackBack-Einstellungen', # Translate - New # OK
	'Your TrackBack preferences have been saved.' => 'TrackBack-Einstellungen gespeichert.', # Translate - New # OK
	'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
	'Accept TrackBacks' => 'TrackBacks zulassen',
	'If enabled, TrackBacks will be accepted from any source.' => 'Legt fest, ob TrackBacks von allen Quellen zugelassen sind',
	'TrackBack Policy' => 'TrackBack-Regeln', # Translate - New # OK
	'Moderation' => 'Moderation',
	'Hold all TrackBacks for approval before they\'re published.' => 'Alle TrackBacks moderieren',
	'Apply \'nofollow\' to URLs' => '\'nofollow\' an URLs anhängen', # Translate - New # OK
	'This preference affects both comments and TrackBacks.' => 'Diese Voreinstellung bezieht sich sowohl auf Kommentare als auch auf TrackBacks.', # Translate - New # OK
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'Falls aktiviert, wird für alle Links in Kommentaren und TrackBacks das \'nofollow\'-Attribut gesetzt.', # Translate - New # OK
	'E-mail Notification' => 'Benachrichtigungen',
	'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Legt fest, ob und wann Sie bei neuen TrackBacks benachrichtigt werden',
	'On' => 'Ein',
	'Only when attention is required' => 'Nur wenn ich etwas machen muss',
	'Off' => 'Aus',
	'Ping Options' => 'Ping-Optionen', # Translate - New # OK
	'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
	'If you turn on auto-discovery, when you write a new entry, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Auto-Discovery verschickt an alle verlinkten externen Seiten, die TrackBack unterstützen, automatisch TrackBack-Pings.', # Translate - New # OK
	'Enable External TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (external) aktivieren',
	'Setting Notice' => 'Hinweis zu der Einstellung',
	'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Die Option ist eventuell betroffen, da Einstellungen zu Pings (outbound) für das Gesamtsystem konfiguriert werden.',
	'Setting Ignored' => 'Einstellung ignoriert',
	'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
	'Enable Internal TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery (internal) aktivieren',

## tmpl/cms/edit_ping.tmpl
	'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
	'List &amp; Edit TrackBacks' => 'TrackBacks anzeigen &amp; bearbeiten',
	'View Entry' => 'Eintrag ansehen',
	'TrackBack Marked as Spam' => 'TrackBack als Spam markiert', # Translate - New # OK
	'Junk' => 'Junk',
	'View all TrackBacks with this status' => 'Alle TrackBacks mit diesem Status ansehen',
	'Source Site:' => 'Quelle:',
	'Search for other TrackBacks from this site' => 'Weitere TrackBacks von dieser Site suchen',
	'Source Title:' => 'Titel:',
	'Search for other TrackBacks with this title' => 'Weitere TrackBacks mit dieser Überschrift suchen',
	'Search for other TrackBacks with this status' => 'Weitere TrackBacks mit diesem Status suchen',
	'Target Entry:' => 'Bei Eintrag:',
	'No title' => 'Keine Überschrift',
	'View all TrackBacks on this entry' => 'Alle TrackBacks bei diesem Eintrag anzeigen',
	'Target Category:' => 'Zielkategorie:',
	'Category no longer exists' => 'Kategorie wurde gelöscht',
	'View all TrackBacks on this category' => 'Alle TrackBacks in dieser Kategorie anzeigen',
	'View all TrackBacks created on this day' => 'Alle TrackBacks dieses Tages anzeigen', # Translate - New # OK
	'View all TrackBacks from this IP address' => 'Alle TrackBacks von dieser IP-Adrese anzeigen',
	'Save this TrackBack (s)' => 'TrackBack speichern (s)',
	'Delete this TrackBack (x)' => 'Dieses TrackBack löschen (x)',

## tmpl/cms/cfg_plugin.tmpl
	'Plugin Settings: System-wide' => 'Systemweite Plugin-Einstellungen', # Translate - New # OK
	'Six Apart Plugin Directory' => 'Six Apart Plugin-Directory', # Translate - New # OK
	'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Hier können Sie die Weblog-spezifischen Einstellungen aller konfigurierbaren Plugins vornehmen.',
	'Your plugin settings have been saved.' => 'Ihre Plugins-Einstellungen wurden gespeichert.',
	'Your plugin settings have been reset.' => 'Ihre Plugin-Einstellungen wurden zurückgesetzt.',
	'Your plugins have been reconfigured.' => 'Ihre Plugins wurden neu konfiguriert.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Ihre Plugins wurden neu konfiguriert. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.',
	'_USAGE_PLUGINS' => 'Eine Liste aller Plugins, die derzeit im System registriert sind.',
	'Are you sure you want to reset the settings for this plugin?' => 'Wollen Sie die Plugin-Einstellungen wirklich zurücksezten?',
	'Disable plugin system?' => 'Plugin-System ausschalten?',
	'Disable this plugin?' => 'Dieses Plugin ausschalten?',
	'Enable plugin system?' => 'Plugin-System einschalten?',
	'Enable this plugin?' => 'Dieses Plugin einschalten?',
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
	'Plugin Home' => 'Plugin Home',
	'Show Resources' => 'Funktionen anzeigen',
	'Run [_1]' => '[_1] ausführen',
	'Show Settings' => 'Einstellungen anzeigen',
	'Settings for [_1]' => 'Einstellungen von [_1]',
	'Resources Provided by [_1]' => 'Resourcen von [_1]',
	'Tag Attributes' => 'Tag-Attribute',
	'Text Filters' => 'Text-Filter',
	'Junk Filters' => 'Junk-Filter',
	'[_1] Settings' => '[_1]-Einstellungen',
	'Reset to Defaults' => 'Standardwerte setzen',
	'Plugin error:' => 'Plugin-Fehler:',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be 100% functional. Furthermore, it will require an upgrade once you have upgraded to the next Movable Type major release (when available).' => 'Dieses Plugin wurde noch nicht für Movable Type [_1] portiert. Daher funktioniert es möglicherweise nicht fehlerfrei. Außerdem erfordert es nach Installation der nächsten Movable Type-Version eine zusätzliche Aktualisierung.', # Translate - New # OK
	'No plugins with weblog-level configuration settings are installed.' => 'Es sind keine Plugins installiert, die am Gesamtsystem konfiguriert werden können.',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Ordner bearbeiten', # Translate - New # OK
	'Use this page to edit the attributes of the folder [_1]. You can set a description for your folder to be used in your public pages, as well as configuring the TrackBack options for this folder.' => 'Hier können Sie die Attribute des [_1]-Ordners wählen, seine TrackBack-Optionen einstellen und eine Beschreibung eingeben, die auf Ihrer Site angezeigt werden soll.', # Translate - New # OK
	'Your folder changes have been made.' => 'Die Ordneränderungen wurden gespeichert.', # Translate - New # OK
	'You must specify a label for the folder.' => 'Sie müssen diesem Ordner eine Bezeichnung geben', # Translate - New # OK
	'Label' => 'Bezeichnung', # Translate - Improved (1) # OK
	'Save this folder (s)' => 'Ordner speichern', # Translate - New # OK

## tmpl/cms/bookmarklets.tmpl
	'Configure QuickPost' => 'QuickPost einrichten',
	'_USAGE_BOOKMARKLET_1' => 'Wenn Sie QuickPost einrichten, können Sie einfach neue Einträge veröffentlichen, ohne direkt in Movable Type zu arbeiten.',
	'_USAGE_BOOKMARKLET_2' => 'Sie können die Bestandteile von QuickPost frei konfigurieren und die Schaltflächen aktivieren, die Sie häufig verwenden.',
	'Include:' => 'Anzeigen:',
	'TrackBack Items' => 'TrackBack',
	'Allow Comments' => 'Kommentare zulassen',
	'Allow TrackBacks' => 'TrackBacks zulassen',
	'Create QuickPost' => 'QuickPost einrichten', # Translate - New # OK
	'_USAGE_BOOKMARKLET_3' => 'Um das QuickPost-Lesezeichen zu installieren, ziehen Sie den folgenden Link in die Lesezeichenleiste oder in das Lesezeichenmenü Ihres Browsers:',
	'_USAGE_BOOKMARKLET_5' => 'Falls Sie unter Windows mit dem Internet Explorer arbeiten, können Sie die Option "QuickPost" zum Kontextmenü von Windows hinzufügen. Klicken Sie auf den nachfolgenden Link, um die Eingabeaufforderung des Browsers zum öffnen der Datei zu akzeptieren. Beenden Sie das Programm, und starten Sie den Browser erneut, um den Link zum Kontextmenü hinzuzufügen.',
	'Add QuickPost to Windows right-click menu' => 'QuickPost zum Kontextmenü von Windows hinzufügen',
	'_USAGE_BOOKMARKLET_4' => 'Nachdem Sie das QuickPost-Lesezeichen installiert haben, können Sie jederzeit einen Eintrag veröffentlichen. Klicken Sie auf den QuickPost-Link und verwenden Sie das Popup-Fenster, um einen Eintrag zu schreiben und zu veröffentlichen.',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Was sichern?', # Translate - New # OK
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Hier können Sie eine Sicherheitskopie Ihrer Blogs erstellen. Sicherungen umfassen Benutzerkonten, Rollen, Verknüpfungen, Blogs, Einträge, Kategoriedefinitionen, Vorlagen und Tags.', # Translate - New # OK
	'Everything' => 'Alles', # Translate - New # OK
	'Choose blogs to backup' => 'Einzelne Blogs auswählen', # Translate - New # OK
	'Type of archive format' => 'Archivformat', # Translate - New # OK
	'The type of archive format to use.' => 'Das zu verwendende Archivformat', # Translate - New  # OK
	'tar.gz' => 'tar.gz', # Translate - New # OK
	'zip' => 'ZIP', # Translate - New # OK
	'Don\'t compress' => 'Nicht komprimieren', # Translate - New # OK
	'Number of megabytes per file' => 'Aufteilung', # Translate - New # OK
	'Approximate file size per backup file.' => 'Ungefähre Größe pro Backupdatei (MB)', # Translate - New # OK
	'Don\'t Divide' => 'Nicht aufteilen', # Translate - New # OK
	'Make Backup' => 'Sicherung erstellen', # Translate - New # OK
	'Make Backup (b)' => 'Sicherung erstellen (b)', # Translate - New

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Webdienste-Einstellungen', # Translate - New # OK
	'Services' => 'Dienste', # Translate - New # OK
	'TypeKey Setup' => 'TypeKey-Setup', # Translate - New # OK
	'Recently Updated Key' => '"Kürzlich aktualisiert"-Schlüssel', # Translate - New # OK
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Wenn Sie einen "Kürzlich aktualisiert"-Schlüssel erhalten haben, tragen Sie ihn hier ein.', # Translate - Improved (1) # OK
	'External Notifications' => 'Externe Benachrichtigungen', # Translate - New # OK
	'Notify the following sites upon blog updates' => 'Die folgenden Websites bei Aktualisierungen benachrichtigen', # Translate - New # OK
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Movable Type benachrichtigt die gewählten Sites automatisch, wenn dieses Blog aktualisiert wurde.', # Translate - New # OK
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Diese Option wird derzeit ignoriert, da Pings (outbound) für das Gesamtsystem derzeit ausgeschaltet sind.',
	'Others:' => 'Andere:',
	'(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Movable Type wiederherstellen', # Translate - New # OK

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Kategorie bearbeiten',
	'Use this page to edit the attributes of the category <strong>[_1]</strong>. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Hier können Sie die Attribute der Kategorie [_1] wählen und eine Beschreibung eingeben, die auf Ihrer Site angezeigt werden soll.', # Translate - New # OK
	'Your category changes have been made.' => 'Die Einstellungen wurden übernommen.',
	'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
	'This is the basename assigned to your category.' => 'Der dieser Kategorie zugewiesene Basename', # Translate - New # OK
	'Unlock this category&rsquo;s output filename for editing' => 'Dateinamen manuell bearbeiten', # Translate - New # OK
	'Warning: Changing this category\'s basename may break inbound links.' => 'Achtung: Änderungen des Basenames können bestehende externe Links auf diese Kategorieseite ungültig mächen',
	'Inbound TrackBacks' => 'TrackBacks (inbound)',
	'Accept Trackbacks' => 'TrackBacks zulassen', # Translate - Case # OK
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Wenn die Option aktiv ist, sind Kategorie-TrackBacks aus allen Quellen zugelassen',
	'View TrackBacks' => 'TrackBacks ansehen', # Translate - New # OK
	'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
	'_USAGE_CATEGORY_PING_URL' => 'Das ist die Adresse für TrackBacks für diese Kategorie. Wenn Sie sie öffentlich machen, kann jeder, der in seinem Blog einen für diese Kategorie relevanten Eintrag geschrieben hat, einen TrackBack-Ping senden. Mittels TrackBack-Tags können Sie diese TrackBacks auf Ihrer Seite anzeigen. Näheres dazu finden Sie in der Dokumentation.',
	'Passphrase Protection' => 'Passphrasenschutz',
	'Outbound TrackBacks' => 'TrackBacks (outbound)',
	'Trackback URLs' => 'TrackBack-URLs', # Translate - New # OK
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Geben Sie die Adressen der Websites ein, an die Sie automatisch einen TrackBack-Ping schicken möchten, wenn ein neuer Eintrag in dieser Kategorie veröffentlicht wurde. Verwenden Sie für jede Adresse eine neue Zeile.', # Translate - New # OK
	'View Category Details' => 'Kategoriedetails anzeigen', # Translate - New # OK

## tmpl/cms/list_notification.tmpl
	'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Eine Liste aller registrierten Benachrichtigungsempfänger. Sie können aus dieser Liste auswählen, wenn Sie manuell Benachrichtigungen über einen neuen Blogeintrag verschicken.',
	'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'Sie haben [quant,_1,Empfänger,Empfänger,keine Empfänger] auf Ihrer Benachrichtigungsliste. Um einen Empfänger zu löschen, markieren Sie den entsprechenden Eintrag und klicken dann auf \'Löschen\'.',
	'You have added [_1] to your notification list.' => 'Sie haben [_1] zu Ihrer Benachrichtigungsliste hinzugefügt.',
	'You have successfully deleted the selected notifications from your notification list.' => 'Sie haben die ausgewählten Benachrichtigungen erfolgreich aus der Benachrichtigungsliste gelöscht.',
	'Download Notifications (CSV)' => 'Benachrichtigungen herunterladen (CSV)', # Translate - New # OK
	'notification address' => 'Adresse für Benachrichtigung',
	'notification addresses' => 'Adressen für Benachrichtigung',
	'Delete selected notification addresses (x)' => 'Ausgewählte Benachrichtigungsadressen löschen(x)',
	'Create New Notification' => 'Neue Benachrichtigung einrichten',
	'URL (Optional):' => 'URL (optional):',
	'Add Recipient' => 'Hinzufügen',

## tmpl/cms/cfg_system_general.tmpl
	'General Settings: System-wide' => 'Systemweite Grundeinstellungen', # Translate - New # OK
	'This screen allows you to set system-wide new user defaults.' => 'Hier können Sie global gültige Voreinstellungen für neue Benutzerkonten vornehmen.',
	'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'You must set a valid Default Site URL.' => 'Standard-Site URL erforderlich.',
	'You must set a valid Default Site Root.' => 'Standard-Site Root erforderlich.',
	'System Email Settings' => 'System-E-Mail-Einstellungen', # Translate - New # OK
	'System Email Address' => 'System-E-Mail-Adresse', # Translate - New # OK
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification, entry notification and a few other minor events.' => 'Die E-Mail-Adresse, die als Absenderadresse der vom System verschickten E-Mails verwendet wird. E-Mails werden vom System verschickt bei Passwortanforderungen, Registrierungen von Kommentarautoren, für Benachrichtigungen über neue Kommentare, TrackBacks und Einträge und in einigen weiteren Fällen.', # Translate - New # OK
	'New User Defaults' => 'Voreinstellungen für neue Benutzer',
	'Personal weblog' => 'Persönliches Weblog',
	'Check to have the system automatically create a new personal weblog when a user is created in the system. The user will be granted a blog administrator role on the weblog.' => 'Wenn diese Option aktiv ist, wird für jeden neu angelegten Benutzer automatisch ein pesönliches Weblog angelegt. Der Benutzer wird für dieses Blog als Blog-Administrator eingetragen.',
	'Automatically create a new weblog for each new user' => 'Für jeden neuen Benutzer automatisch ein neues Weblog anlegen',
	'Personal weblog clone source' => 'Klonvorlage für persönliche Weblogs',
	'Select a weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Wählen Sie ein Weblog, das als Vorlage für persönliche Weblogs dienen soll. Neue persönliche Blogs sind mit der Vorlage bis auf Name, Pfade und Berechtigungen identisch.',
	'Default Site URL' => 'Standard-Site URL',
	'Define the default site URL for new weblogs. This URL will be appended with a unique identifier for the weblog.' => 'Wählen Sie die Standard-URL für neue Weblogs. Dieser URL wird ein individueller Bezeichner für jedes Weblog angehängt.',
	'Default Site Root' => 'Standard-Site Root',
	'Define the default site root for new weblogs. This path will be appended with a unique identifier for the weblog.' => 'Wählen Sie das Standard-Wurzelverzeichnis für neue Weblogs. Dem Pfad wird ein individueller Bezeichner für jedes Weblog angehängt.',
	'Default User Language' => 'Standard-Sprache',
	'Define the default language to apply to all new users.' => 'Wählen Sie die Standard-Sprache aller neuer Benutzerkonten ',
	'Default Timezone' => 'Standard-Zeitzone', # Translate - New # OK
	'Default Tag Delimiter' => 'Standard-Tag-Trennzeichen', # Translate - New # OK
	'Define the default delimiter for entering tags.' => 'Wählen Sie das Standard-Trennzeichen für die Eingabe von Tags', # Translate - Improved (1) # OK

## tmpl/cms/dashboard.tmpl
	'Loading recent entries...' => 'Lade aktuelle Einträge...', # Translate - New # OK
	'This is you' => 'Das sind Sie', # Translate - New # OK
	'Your <a href="[_1]">last post</a> was [_2].' => 'Ihr <a href="[_1]">letzter Eintrag</a> ist [_2].', # Translate - New # OK
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Sie haben <a href="[_1]>[quant,_2,Entwurf,Entwürfe]</a>.', # Translate - New # OK
	'You\'ve written <a href=\"[_1]\">[quant,_2,post,posts]</a> with <a href=\"[_3]\">[quant,_4,comment,comments]</a>' => 'Sie haben <a href=\"[_1]\">[quant,_2,Eintrag,Einträge]</a> mit <a href=\"[_3]\">[quant,_4,Kommentar,Kommentaren]</a> geschrieben.', # Translate - New
	'You\'ve written <a href=\"[_1]\">[quant,_2,post,posts]</a>.' => 'Sie haben <a href=\"[_1]\>[quant,_2,Eintrag,Einträge]</a> geschrieben.', # Translate - New # OK
	'Nützliche Abkürzungen' => '', # Translate - New # OK
	'Trackbacks' => 'TrackBacks', # Translate - Case # OK
	'News' => 'Neuigkeiten', # Translate - New # OK
	'MT News' => 'Neues von MT', # Translate - New # OK
	'Learning MT' => 'MT lernen', # Translate - New # OK
	'Hacking MT' => 'MT hacken', # Translate - New # OK
	'Pronet' => 'Pronet', # Translate - New # OK
	'No Movable Type news available.' => 'Es liegen keine Movable Type-Nachrichten vor.', # Translate - New # OK
	'No Learning Movable Type news available.' => 'Es liegen keine Movable Type lernen-Nachrichten vor', # Translate - New # OK
	'You have attempted to access a page that does not exist. Please navigate to the page you are looking for starting from the dashboard.' => 'Die angeforderte Seite existiert nicht. Bitte wählen Sie die gewünschte Seite über das Dashboard an.', # Translate - New # OK
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Sie haben für die gewünschte Funktion keine Zugriffsrechte. Bei Fragen wenden Sie sich bitte an Ihren Systemadministrator.', # Translate - New # OK
	'Movable Type was unable to locate your \'mt-static\' directory. Please configure the \'StaticFilePath\' configuration setting in your mt-config.cgi file, and create a writable \'support\' directory underneath your \'mt-static\' directory.' => 'Movable Type konnte Ihr \'mt-static\'-Verzeichnis nicht finden. Bitte überprüfen Sie die \'StaticFilePath\'-Direktive in der Konfigurationsdatei mt-config.cgi und legen Sie ein vom Webserver beschreibbares Verzeichnis \'support\' im \'mt-static\'-Verzeichnis an.', # Translate - New # OK
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type kann auf den Ordner \'support\' nicht schreibend zugreifen. Legen Sie hier: [_1] ein solches Verzeichnis an und stellen Sie sicher, daß der Webserver Schreibrechte für diesen Ordner besitzt.', # Translate - New # OK
	'Blog Stats' => 'Blog-Statistik', # Translate - New # OK
	'Most Recent Comments' => 'Aktuelle Kommentare', # Translate - New # OK
	'[_1][_2], [_3] on [_4]' => '[_1][_2], [_3] zu [_4]', # Translate - New # OK
	'View all comments' => 'Alle Kommentare', # Translate - New # OK
	'No comments available.' => 'Keine Kommentare vorhanden.', # Translate - New # OK
	'Most Recent Entries' => 'Aktuelle Einträge', # Translate - New # OK
	'...' => '...', # Translate - New # OK
	'View all entries' => 'Alle Einträge', # Translate - New # OK
	'You have <a href=\'[_3]\'>[quant,_1,comment] from [_2]</a>' => 'Sie haben <a href=\'[_3]\'>[quant,_1,Kommentar]von [_2]</a>', # Translate - New # OK
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Sie haben <a href=\'[_3]\'>[quant,_1,Eintrag,Einträge] von [_2]</a>', # Translate - New # OK

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Kommentar-Einstellungen', # Translate - New # OK
	'Your preferences have been saved.' => 'Die Einstellungen wurden gespeichert.', # Translate - New # OK
	'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'Kommentarauthentifizierung ist derzeit nicht möglich. Ein erforderliches Modul, MIME::Base64 oder LWP::UserAgent, ist nicht installiert. Ihr Administrator kann Ihnen vielleicht weiterhelfen.',
	'Accept Comments' => 'Kommentare zulassen',
	'Commenting Policy' => 'Kommentierungs-Regeln', # Translate - New # OK
	'Allowed Authentication Methods' => 'Zuässige Authentifizierung-Methoden', # Translate - New # OK
	'Authentication Not Enabled' => 'Authentifizierung nicht aktiviert',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Hinweis: Sie möchten Kommentare nur von authentifizierten Kommentarautoren zulassen. Allerdings haben Sie die Authentifizierung nicht aktiviert.',
	'Native' => 'Nativ', # Translate - New # OK
	'Require E-mail Address for Comments via TypeKey' => 'E-Mail-Adresse für Kommentare via TypeKey erfordern', # Translate - New # OK
	'If enabled, visitors must allow their TypeKey account to share e-mail address when commenting.' => 'Falls aktiviert, müssen Leser, die sich zum Kommentieren mit TypeKey anmelden, von TypeKey ihre E-Mail-Adresse übermitteln lassen. ', # Translate - New # OK
	'Setup other authentication services' => 'Andere Authentifizierungs-Dienste einrichten', # Translate - New # OK
	'Immediately approve comments from' => 'Automatisch Kommentare freischalten von', # Translate - New # OK
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Geben Sie an, was mit neuen Kommentaren geschehen soll. Ungeprüfte Kommentare werden zur Moderierung zurückgehalten.', # Translate - New # OK
	'No one' => 'Niemandem',
	'Trusted commenters only' => 'Nur von vertrauten Kommentarautoren',
	'Any authenticated commenters' => 'Von allen authentifizierten Kommentarautoren',
	'Anyone' => 'Jedermann',
	'Allow HTML' => 'HTML zulassen',
	'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Wenn die Option aktiv ist, darf HTML in Kommentaren verwendet werden. Andernfalls wird HTML aus Kommentaren automatisch herausgefiltert.',
	'Limit HTML Tags' => 'HTML einschränken ', # Translate - New # OK
	'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Liste der HTML-Tags, die aus HTML-Kommentaren nicht ausgefiltert werden sollen.',
	'Use defaults' => 'Standardwerte verwenden',
	'([_1])' => '([_1])',
	'Use my settings' => 'Eigene Einstellungen',
	'Disable \'nofollow\' for trusted commenters' => '\'nofollow\' für Kommentare von vertrauten Kommentarautoren nicht verwenden', # Translate - New # OK
	'If enabled, the \'nofollow\' link relation will not be applied to any comments left by trusted commenters.' => 'Falls aktiviert, wird für Links in Kommentaren von vertrauten Kommentarautoren das \'nofollow\'-Attribut nicht gesetzt.', # Translate - New # OK
	'Specify when Movable Type should notify you of new comments if at all.' => 'Legt fest, ob und wann Movable Type Email-Benachrichtigungen über neue Kommentare versendet.',
	'Comment Order' => 'Kommentar-Reihenfolge', # Translate - New # OK
	'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie aus, ob Kommentare von Besuchern in aufsteigender (ältester zuerst) oder absteigender (neuester zuerst) Reihenfolge angezeigt werden sollen.',
	'Ascending' => 'Aufsteigend',
	'Descending' => 'Absteigend',
	'Auto-Link URLs' => 'URLs automatisch verlinken',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Wenn die Option aktiv ist, werden alle URLs automatisch in HTML-Links umgewandelt.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
	'Use Comment Confirmation Page' => 'Kommentarbestätigungs-Seite verwenden', # Translate - New # OK

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Blog anlegen', # Translate - New # OK
	'From this screen you can specify the basic information needed to create a blog.  Once you click the save button, your blog will be created and you can continue to customize its settings and templates, or just simply start creating entries.' => 'Hier können Sie die Grundeinstellungen für ein neues Blog vornehmen. Nach dem Speichern wird das neue Blog erzeugt. Sie können es dann entweder detaillierter konfigurieren oder einfach sofort Einträge schreiben.', # Translate - New # OK
	'Your blog configuration has been saved.' => 'Ihre Blog-Konfiguration wurde gespeichert.', # Translate - New # OK
	'You must set your Weblog Name.' => 'Sie müssen den Namen Ihres Weblogs festlegen.',
	'You must set your Site URL.' => 'Sie müssen Ihre Webadresse (URL) festlegen.',
	'Your Site URL is not valid.' => 'Die gewählte Webadresse (URL) ist ungültig.',
	'You can not have spaces in your Site URL.' => 'Die Adresse (URL) darf keine Leerzeichen enthalten.',
	'You can not have spaces in your Local Site Path.' => 'Der lokale Pfad darf keine Leerzeichen enthalten.',
	'Your Local Site Path is not valid.' => 'Das gewählte lokale Verzeichnis ist ungültig.',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Geben Sie die Webadresse Ihrer Site ein. Geben Sie die Adresse ohne Dateinamen ein beispielsweise so: http://www.beispiel.de/weblog/', # Translate - New # OK
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Der Pfad, in dem Startseite Ihres Blog abgelegt werden soll. Eine absolute (mit \'/\' beginnende) Pfadangabe wird bevorzugt, Sie können den Pfad aber auch relativ Sie zu Ihrem Movable Type-Verzeichnis angeben. Beispiel: /home/melanie/public_html/blog', # Translate - New # OK

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisiere Datenbank...',
	'Upgrading database...' => 'Upgrade der Datenbank...',
	'Installation complete.' => 'Installation abgeschlossen.',
	'Upgrade complete.' => 'Upgrade abgeschlossen.',
	'Starting installation...' => 'Starte Installation...',
	'Starting upgrade...' => 'Starte Upgrade...',
	'Error during installation:' => 'Fehler während Installation:',
	'Error during upgrade:' => 'Fehler während Upgrade:',
	'Installation complete!' => 'Installation abgeschlossen!',
	'Upgrade complete!' => 'Upgrade abgeschlossen!',
	'Login to Movable Type' => 'Bei Movable Type anmelden',
	'Your database is already current.' => 'Ihre Datenbank ist bereits auf dem aktuellen Stand.',

## tmpl/cms/edit_commenter.tmpl
	'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentator.',
	'The commenter has been banned.' => 'Dieser Kommentator wurde gesperrt.',
	'Comments from [_1]' => 'Kommentaren von [_1]', # Translate - New # OK
	'Trust' => 'Vertrauen',
	'commenters' => 'Kommentarautoren',
	'Trust commenter' => 'Kommentator vertrauen',
	'Untrust' => 'Nicht vertrauen',
	'Untrust commenter' => 'Kommentator nicht vertrauen',
	'Ban' => 'Sperren',
	'Ban commenter' => 'Kommentator sperren',
	'Unban' => 'Entsperren',
	'Unban commenter' => 'Sperre aufheben',
	'Trust selected commenters' => 'Ausgewählten Kommentarautoren vertrauen',
	'Ban selected commenters' => 'Ausgewählte Kommentarautoren sperren',
	'The Name of the commenter' => 'Name des Kommentarautors', # Translate - New # OK
	'View all comments with this name' => 'Alle Kommentare mit diesem Namen anzeigen',
	'The Identity of the commenter' => 'Identität des Kommentarautors', # Translate - New # OK
	'The Email of the commenter' => 'E-Mail-Adresse des Kommentarautors', # Translate - New # OK
	'Withheld' => 'Zurückgehalten', # Translate - Improved (1) # OK
	'The URL of the commenter' => 'URL des Kommentarautors', # Translate - New # OK
	'View all comments with this URL address' => 'Alle Kommentare mit dieser URL anzeigen',
	'The trusted status of the commenter' => 'Vertrauensstatus des Kommentarautors', # Translate - New # OK
	'View all commenters with this status' => 'Alle Kommentarautoren mit diesem Status ansehen',

## tmpl/cms/cfg_entry.tmpl
	'Entry Settings' => 'Eintrags-Einstellungen', # Translate - New # OK
	'Display Settings' => 'Anzeige-Einstellungen', # Translate - New # OK
	'Entries to Display' => 'Anzuzeigende Einträge', # Translate - New # OK
	'Select the number of days\' entries or the exact number of entries you would like displayed on your blog.' => 'Geben Sie entweder die maximale Anzahl von Einträgen oder die maximale Anzahl von Tagen an, die auf der StartseiteIhres Weblogs angezeigt werden sollen.', # Translate - New # OK
	'Days' => 'Tage',
	'Entry Order' => 'Eintragsreihenfolge', # Translate - New # OK
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Geben Sie an, ob Einträge in chronologischer (älteste zuerst) oder umgekehrt chronologischer Reihenfolge (neueste zuerst) angezeigt werden sollen.', # Translate - New # OK
	'Excerpt Length' => 'Auszugslänge', # Translate - New # OK
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Anzahl der Wörter im automatisch generierten Textauszug.',
	'Date Language' => 'Datumsanzeige', # Translate - New
	'Select the language in which you would like dates on your blog displayed.' => 'Sprache für Datumsanzeigen',
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
	'Basename Length' => 'Basename-Länge', # Translate - New # OK
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Setzt den Wert für den automatisch generierten Basename des Eintrags. Mögliche Länge: 15 bis 250.',
	'New Entry Defaults' => 'Standardwerte',
	'Specifies the default Entry Status when creating a new entry.' => 'Gibt an, welcher Eintragsstatus neue Einträge standardmäßig zugewiesen werden soll.', # Translate - New # OK
	'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen Kommentare standardmässig zugelassen werden.', # Translate - Improved (2) # OK
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellungen zeigen momentan keine Wirkung, da Kommentare blog- oder systemweit deaktiviert sind.', # Translate - New # OK
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen TrackBack standardmässig zugelassen werden.', # Translate - Improved (2) # OK
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellungen zeigen momentan keine Wirkung, da TrackBacks blog- oder systemweit deaktiviert sind.', # Translate - New # OK
	'Default Editor Fields' => 'Standard-Editorfelder', # Translate - New # OK

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus.',
	'_USAGE_SEARCH' => 'Sie können Suchen &amp; Ersetzen einsetzen, um Daten in Weblogs zu finden und optional zu ersetzen. WICHTIG: Verwenden Sie die Funktion "Ersetzen" mit Vorsicht. Der Vorgang kann <b>nicht</b> rückgängig gemacht werden.',
	'Search Again' => 'Suchen',
	'Replace' => 'Ersetzen', # Translate - New # OK
	'Replace Checked' => 'Markierung ersetzen',
	'Case Sensitive' => 'Groß/Kleinschreibung',
	'Regex Match' => 'Regex-Match',
	'Limited Fields' => 'Felder eingrenzen',
	'Date Range' => 'Zeitspanne',
	'Reported as Spam?' => 'Als Spam melden?', # Translate - New # OK
	'Search Fields:' => 'Felder durchsuchen:',
	'E-mail Address' => 'Email-Addresse',
	'Source URL' => 'Quell-URL',
	'Page Body' => 'Seitenkörper', # Translate - New # OK
	'Extended Page' => 'Erweiterte Seite', # Translate - New # OK
	'Text' => 'Text',
	'Output Filename' => 'Ausgabe-Dateiname',
	'Linked Filename' => 'Verlinkter Dateiname',
	'To' => 'An', # Translate - New # OK
	'Replaced [_1] records successfully.' => '[_1] Wörter ersetzt.',
	'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
	'Show all matches' => 'Zeige alle Treffer',
	'[quant,_1,result,results] found' => '[quant,_1,Ergebnis,Ergebnisse] gefunden', # Translate - New # OK
	'No entries were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Einträge gefunden.',
	'No comments were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Kommentare gefunden.',
	'No TrackBacks were found that match the given criteria.' => 'Keine den Kritierien entsprechenden TrackBacks gefunden.',
	'No commenters were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Kommentarautoren gefunden.',
	'No pages were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Seiten gefunden.', # Translate - New # OK
	'No templates were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Vorlagen gefunden.',
	'No log messages were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Logeinträge gefunden.',
	'No users were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Benutzer gefunden.',
	'No weblogs were found that match the given criteria.' => 'Keine den Kritierien entsprechenden Weblogs gefunden.',

## tmpl/cms/export.tmpl
	'_USAGE_EXPORT_1' => 'Indem Sie Einträge aus Movable Type exportieren, erhalten Sie <b>persönliche Sicherungen</b> Ihrer Weblog-Einträge. Die Daten werden in einem Format exportiert, in dem sie jederzeit zurück in das System importiert werden können. Das Exportieren von Einträgen dient nicht nur der Sicherung, Sie können damit auch <b>Inhalte zwischen Weblogs verschieben</b>.',
	'Export Entries From [_1]' => 'Einträge aus [_1] exportieren',
	'Export Entries (e)' => 'Einträge exportieren (e)',
	'<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Hinweis:</strong> Movable Type-Exportdateien enthalten nur die Blogeinträge selbst und ersetzen kein vollständiges Backup. Das Handbuch enthält weitere Informationen zu diesem Thema.</em>',
	'Export Entries to Tangent' => 'Einträge nach Tangent exportieren',
	'_USAGE_EXPORT_3' => 'Durch Klicken auf den nachfolgenden Link werden alle aktuellen Weblog-Einträge exportiert. In der Regel ist das Übertragen der Einträge ein einmaliger Vorgang. Sie können den Vorgang aber jederzeit wiederholen.',

## tmpl/cms/list_commenter.tmpl
	'_USAGE_COMMENTERS_LIST' => 'Eine Liste der authentifizierten Kommentarautoren bei [_1]. Die Kommentarautoren können Sie unten bearbeiten.',
	'The selected commenter(s) has been given trusted status.' => 'Diese Kommentarautoren haben den Status vertrauenswürdig.',
	'Trusted status has been removed from the selected commenter(s).' => 'Der Vertraut-Status wurde für die ausgewählten Kommentarautoren aufgehoben.',
	'The selected commenter(s) have been blocked from commenting.' => 'Die ausgewählten Kommentarautoren wurden für Kommentare gesperrt.',
	'The selected commenter(s) have been unbanned.' => 'Die Kommentarsperre wurde für die ausgewählten Kommentarautoren aufgehoben.',
	'(Showing all commenters.)' => '(Zeige alle Kommentarautoren)',
	'Showing only commenters whose [_1] is [_2].' => 'Zeige nur Kommentarautoren bei denen [_1] [_2] ist',
	'Commenter Feed' => 'Kommentarautoren-Feed',
	'commenters.' => 'Kommentarautoren',
	'commenters where' => 'Kommentare deren',
	'trusted' => 'vertraut',
	'untrusted' => 'nicht vertraut',
	'banned' => 'gesperrt',
	'unauthenticated' => 'nicht authentifiziert',
	'authenticated' => 'authentifiziert',

## tmpl/cms/list_folder.tmpl

## tmpl/cms/list_template.tmpl
	'Edit Templates' => 'Vorlagen bearbeiten', # Translate - New # OK
	'Index Templates' => 'Index-Vorlagen', # Translate - Improved (1) # OK
	'Archive Templates' => 'Archiv-Vorlagen', # Translate - Improved (1) # OK
	'System Templates' => 'System-Vorlagen', # Translate - Improved (1) # OK
	'Template Modules' => 'Vorlagenmodule', # Translate - Improved (1) # OK
	'Template Widgets' => 'Vorlagen-Widgets', # Translate - New # OK
	'Indexes' => 'Index-Dateien',
	'Modules' => 'Module',
	'Blog Publishing Settings' => 'Veröffentlichtungs-Einstellungen', # Translate - New # OK
	'template' => 'Template',
	'templates' => 'Templates',
	'You have successfully deleted the checked template(s).' => 'Vorlage(n) erfolgreich gelöscht.', # Translate - Improved (1) # OK
	'New Index Template' => 'Neue Index-Vorlage', # Translate - New # OK
	'New Archive Template' => 'Neue Archiv-Vorlage', # Translate - New # OK
	'New Template Module' => 'Neues Vorlagenmodul', # Translate - New # OK
	'New Template Widget' => 'Neues Vorlagen-Widget', # Translate - New # OK
	'No index templates could be found.' => 'Keine Index-Templates gefunden.',
	'No archive templates could be found.' => 'Keine Archiv-Templates geunden.',
	'No template modules could be found.' => 'Keine Template-Module gefunden.',
	'No widgets could be found.' => 'Keine Widgets gefunden.', # Translate - New # OK

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Konfiguration des temporären Verzeichnisses',
	'You should configure you temporary directory settings.' => 'Hier legen Sie fest, in welchem Verzeichnis temporäre Dateien gespeichert werden.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to configure your mail settings.' => 'Konfiguration des temporären Verzeichnisses abgeschlossen. \'Weiter\' führt zu den Mail-Einstellungen.',
	'[_1] could not be found.' => '[_1] nicht gefunden',
	'TempDir is required.' => 'TempDir ist erforderlich',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Pfad Ihres temporären Verzeichnisses',

## tmpl/wizard/include/footer.tmpl

## tmpl/wizard/include/header.tmpl
	'Configuration Wizard' => 'Konfigurationshelfer', # Translate - New # OK

## tmpl/wizard/include/copyright.tmpl

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Richten Sie Ihr erstes Blog ein', # Translate - New # OK

## tmpl/wizard/start.tmpl
	'Welcome to Movable Type' => 'Willkommen zu Movable Type', # Translate - New # OK
	'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Es ist bereits eine Konfigurationsdatei vorhanden. Wenn Sie den Konfigurationshelfer erneut ausführen möchten, entfernen Sie die Datei zuerst aus Ihrem Movable Type-Verzeichnis.',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type erfordert JavaScript. Bitte aktivieren Sie es in Ihren Browsereinstellungen und laden diese Seite dann neu.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Dieser Konfigurationshelfer hilft Ihnen, die zur Installation von Movable Type Enterprise erforderlichen Einstellungen vorzunehmen.',
	'Error: \'[_1]\' could not be found.  Please move your static files to the directory first or correct the setting if it is incorrect.' => 'Fehler: \'[_1]\' nicht gefunden. Bitte kopieren Sie erst die statischen Dateien in den Ordner oder überprüfen Sie Einstellungen, falls das bereits geschehen ist.', # Translate - New # OK
	'Configure Static Web Path' => 'Statischen Web-Pfad konfigurieren', # Translate - New # OK
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets. (The elements that make this page look so pretty!)' => 'Movable Type wird mit einem Ordner namens [_1] ausgeliefert, der einige wichtige Bild-, Javascript- und Stylesheet-Dateien enthält.', # Translate - New # OK
	'The [_1] directory is in the main Movable Type directory which this wizard script is also in, but due to the curent server\'s configuration the [_1] directory is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory, where your published website exists).' => 'Der [_1]-Ordner befindet sich im Hauptverzeichnis von Movable Type und enthält auch den Konfigurationshelfer. Momentan ist der Ordner vom Webserver jedoch nicht erreichbar. Verschieben Sie ihn daher an einen Ort, auf den der Webserver zugreifen kann (z.B. Document Root).', # Translate - New # OK
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Das Verzeichnis wurde entweder umbenannt oder an einen Ort außerhalb des Movable Type-Verzeichnisses verschoben.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Wenn Sie den [_1]-Ordner an einen vom Webserver erreichbaren Ort verschoben haben, geben Sie die Adresse unten an.', # Translate - New # OK
	'This URL path can be in the form of [_1] or simply [_2]' => 'Die Adresse kann in dieser Form: [_1] oder einfach als [_2] angegeben werden. ', # Translate - New # OK
	'Static web path' => 'Statischer Pfad', # Translate - Case # OK
	'Begin' => 'Anfangen', # Translate - Improved (1) # OK

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Datenbankkonfiguration',
	'You must set your Database Path.' => 'Pfad zur Datenbank erforderlich',
	'You must set your Database Name.' => 'Geben Sie Ihren Datenbanknamen an.',
	'You must set your Username.' => 'Geben Sie Ihren Benutzernamen an.',
	'You must set your Database Server.' => 'Geben Sie Ihren Datenbankserver an.',
	'Your database configuration is complete.' => 'Ihre Datenbank-Konfiguration ist abgeschlossen.', # Translate - New # OK
	'You may proceed to the next step.' => 'Sie können mit dem nächsten Schritt fortfahren.', # Translate - New # OK
	'Please enter the parameters necessary for connecting to your database.' => 'Bitte geben Sie die Paramter für Ihre Datenbankverbindung ein.', # Translate - New # OK
	'Show Current Settings' => 'Derzeitige Einstellugen anzeigen', # Translate - New # OK
	'Database Type' => 'Datenbanktyp', # Translate - New # OK
	'Select One...' => 'Auswählen...',
	'If your database type is not listed in the menu above, then you need to <a target="help" href="[_1]">install the Perl module necessary to connect to your database</a>.  If this is the case, please check your installation and <a href="#" onclick="[_2]">re-test your installation</a>.' => 'Erscheint Ihr Datenbanktyp nicht in obigem Menü, <a target="help" href="[_1]">installieren Sie bitte die für Ihren Datenbanktyp notwendigen Perl-Module</a>. Sollte das bereits geschehen sein, überprüfen Sie die Installation und <a href="#" onclick="[_2]">führen den Systemtest erneut aus</a>.', # Translate - New # OK
	'Database Path' => 'Datenbankpfad',
	'The physical file path for your SQLite database. ' => 'Physischer Pfad zur SQLite-Datenbank', # Translate - New # OK
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Mit der  Voreinstellung \'./db/mt.db\' wird die Datenbankdatei unterhalb Ihres Movable Type-Verzeichnisses angelegt.', # Translate - New # OK
	'Database Server' => 'Hostname',
	'This is usually \'localhost\'.' => 'Meistens \'localhost\'',
	'Database Name' => 'Datenbankname',
	'The name of your SQL database (this database must already exist).' => 'Name Ihrer SQL-Datenbank (die Datenbank muss bereits vorhanden sein)',
	'The username to login to your SQL database.' => 'Benutzername für Ihre SQL-Datenbank',
	'The password to login to your SQL database.' => 'Passwort für Ihre SQL-Datenbank',
	'Show Advanced Configuration Options' => 'Erweiterte Optionen anzeigen', # Translate - New # OK
	'Database Port' => 'Port',
	'This can usually be left blank.' => 'Braucht normalerweise nicht angegeben zu werden',
	'Database Socket' => 'Socket',
	'Publish Charset' => 'Zeichenkodierung',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Der Microsoft SQL Server-Treiber unterstützt ausschließlich die Zeichenkodierungen Shift_JIS und ISO-8859-1.  UTF-8 oder andere Kodierungen können nicht verwendet werden.',
	'Test Connection' => 'Verbindung testen',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Mailkonfiguration',
	'Your mail configuration is complete.' => 'Ihre Mail-Konfiguration ist abgeschlossen.', # Translate - New # OK
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Überprüfen Sie den Eingang der Testmail in Ihrem Postfach und fahren dann mit dem nächsten Schritt fort.', # Translate - New # OK
	'Show current mail settings' => 'Derzeitige Mail-Einstellungen anzeigen', # Translate - New # OK
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Movable Type verschickt beispielsweise zur Benachrichtigung bei neuen Kommentaren E-Mails. Geben Sie daher bitte hier an, wie diese Mails verschickt werden sollen.', # Translate - New # OK
	'An error occurred while attempting to send mail: ' => 'Mailversand fehlgeschlagen: ',
	'Send email via:' => 'E-Mails schicken mit:', # Translate - New # OK
	'sendmail Path' => 'sendmail-Pfad', # Translate - New # OK
	'The physical file path for your sendmail binary.' => 'Pfad zu sendmail', # Translate - New # OK
	'Outbound Mail Server (SMTP)' => 'SMTP-Server', # Translate - New # OK
	'Address of your SMTP Server.' => 'Adresse Ihres SMTP-Servers', # Translate - New # OK
	'Mail address for test sending' => 'Empfängeradresse für Testmail',
	'Send Test Email' => 'Test-Email verschicken',

## tmpl/wizard/complete.tmpl
	'Config File Created' => 'Konfigurationsdatei angelegt', # Translate - New # OK
	'You selected to create the mt-config.cgi file manually, however it could not be found. Please cut and paste the following text into a file called \'mt-config.cgi\' into the root directory of Movable Type (the same directory in which mt.cgi is found).' => 'Sie wollten die Konfigurationsdatei mt-config.cgi manuell anlegen. Sie kann jedoch nicht gefunden werden. Kopieren Sie daher folgenden Text in eine Datei namens \'mt-config.cgi\' und legen diese dann im Movable Type-Hauptverzeichnis ab (das Verzeichnis, in dem Sie auch die Datei mt.cgi finden).', # Translate - New # OK
	'If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Bitte überprüfen Sie, ob Schreibrechte für das Verzeichnis vorliegen und klicken dann auf "Erneut versuchen"',
	'We were unable to create your Movable Type configuration file. This is most likely the result of a permissions problem. To resolve this problem you will need to make sure that your Movable Type home directory (the directory that contains mt.cgi) is writable by your web server.' => 'Die Movable Type-Konfigurationsdatei kann nicht angelegt werden. Das liegt fast immer an mangelnden Zugriffsrechten. Stellen Sie daher sicher, daß der Webserver Schreibrechte für das Movable Type-Hauptverzeichnis hat (das Verzeichnis, in dem Sie auch die Datei mt.cgi finden).', # Translate - New # OK
	'Congratulations! You\'ve successfully configured [_1].' => 'Herzlichen Glückwunsch! Sie haben [_1] erfolgreich konfiguriert.', # Translate - New # OK
	'Your configuration settings have been written to the file <tt>[_1]</tt>. To reconfigure them, click the \'Back\' button below.' => 'Ihre Einstellungen wurden in der Datei <tt>[_1]</tt> gespeichert. Um die Einstellungen erneut zu ändern, klicken Sie bitte auf \'Zurück\'.', # Translate - New # OK
	'I will create the mt-config.cgi file manually.' => 'Ich werde mt-config.cgi manuell anlegen.', # Translate - New # OK
	'Retry' => 'Erneut versuchen',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Überprüfung der Systemvoraussetzungen',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Die folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung notwendig. Movable Type speichert Ihre Blogdaten in einer Datenbank. Bitte installieren Sie die hier genannten Pakete und klicken danach auf \'Erneut versuchen\'.', # Translate - New # OK
	'All required Perl modules were found.' => 'Alle notwendigen Perl-Module sind vorhanden.', # Translate - New # OK
	'You are ready to proceed with the installation of Movable Type.' => 'Sie können die Installation von Movable Type fortsetzen.', # Translate - New # OK
	'Note: One or more optional Perl modules could not be found. You may install them now and click \'Retry\' or continue without them. They can be installed at any time if needed.' => 'Hinweis: Mindestens ein optional erforderliches Perl-Modul wurde nicht gefunden. Sie können die Module entweder jetzt installieren und dann auf \'Erneut versuchen\' klicken oder die Installation ohne die optionalen Module fortsetzen. Sie können diese Module auch jederzeit nachträglich installieren.', # Translate - New # OK
	'<a href="#" onclick="[_1]">Optionale Module anzeigen</a>' => '', # Translate - New # OK
	'One or more Perl modules required by Movable Type could not be found.' => 'Mindestens ein von Movable Type erforderliche Perl-Modul wurde nicht gefunden.', # Translate - New # OK
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber zwingend erforderlich. Bitte installieren Sie sie und klicken dann auf \'Erneut versuchen\'.',
	'Missing Database Modules' => 'Fehlende Datenbank-Module', # Translate - New # OK
	'Missing Optional Modules' => 'Fehlende optionale Module', # Translate - New # OK
	'Missing Required Modules' => 'Fehlende erforderliche Module', # Translate - New # OK
	'Minimal version requirement: [_1]' => 'Mindestens erforderliche Version: [_1]', # Translate - New # OK
	'Learn more about installing Perl modules.' => 'Mehr über die Installation von Perl-Modulen erfahren', # Translate - New # OK
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Alle erforderlichen Pakete vorhanden. Sie brauchen keine weiteren Pakete zu installieren.',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
	'_ERROR_CONFIG_FILE' => 'Ihre Movable Type Konfigurationsdatei fehlt oder kann nicht gelesen werden. Bitte lesen Sie die Movable Type-Dokumentation: <a href="#">Installation and Configuration</a>.',
	'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
	'_ERROR_DATABASE_CONNECTION' => 'Ihre Datenbankkonfiguration ist fehlerhaft. Bitte lesen Sie die Movable Type-Dokumention: <a href="#">Installation and Configuration</a>.',
	'CGI Path Configuration Required' => 'CGI-Pfad muß eingestellt sein',
	'_ERROR_CGI_PATH' => 'Ihre CGIPath-Konfiguration fehlt oder ist fehlerhaft. Bitte lesen Sie die Movable Type-Dokumention: <a href="#">Installation and Configuration</a>.',

## tmpl/email/footer-email.tmpl
	'Powered by Movable Type' => 'Powered by Movable Type',

## tmpl/email/commenter_confirm.tmpl
	'Thank you registering for an account to comment on [_1].' => 'Danke, daß Sie ein Benutzerkonto angelegt haben, um [_1] zu kommentieren.',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Zu Ihrer eigenen Sicherheit und zur Vermeidung von Mißbrauch bitten wie Sie, daß Sie zuerst Ihre E-Mail-Adresse und Ihre Anmeldung bestätigen.',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Um Ihre Anmeldung zu bestätigen, klicken Sie bitte auf folgende Adresse (oder kopieren Sie sie und fügen Sie sie in Adresszeile Ihres Web-Browsers ein):',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Sollten Sie sich nicht selbst angemeldet haben oder sollten Sie doch kein Konto anlegen wollen, um [_1] kommentieren zu können, brauchen Sie nichts zu tun.',
	'Thank you very much for your understanding.' => 'Vielen Dank für Ihr Verständnis.',
	'Sincerely,' => 'Ihr',

## tmpl/email/verify-subscribe.tmpl
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Vielen Dank, daß Sie die Aktualisierungsbenachrichtungen von [_1] abonnieren möchten. Bitte folgen Sie zur Bestätigung diesem Link:',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Wenn der Link nicht anklickbar ist, kopieren Sie ihn einfach und fügen ihn in der Adresszeile Ihres Browers ein.',

## tmpl/email/recover-password.tmpl
	'_USAGE_FORGOT_PASSWORD_1' => 'Sie haben ein neues Movable Type-Passwort angefordert. Es wurde automatisch ein neues Passwort erzeugt. Es lautet:',
	'_USAGE_FORGOT_PASSWORD_2' => 'Mit diesem Passwort können Sie sich nun am System anmelden. Danach können Sie das Passwort ändern.',

## tmpl/email/new-ping.tmpl
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Eintrag #[_2] ("[_3]") ein noch nicht freigeschaltetes TrackBack erhalten. Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Kategorie #[_2] ("[_3]") ein noch nicht freigeschaltetes TrackBack erhalten. Sie müssen dieses TrackBack freischalten, damit es auf Ihrem Weblog erscheint.',
	'Approve this TrackBack' => 'TrackBack freigeben',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert, zu Eintrag #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Ein neues TrackBack wurde bei Ihrem Weblog [_1] registriert, zu Kategorie #[_2] ([_3]).',
	'View this TrackBack' => 'TrackBack ansehen',
	'Report this TrackBack as spam' => 'TrackBack als Spam melden',

## tmpl/email/new-comment.tmpl
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Ihr Weblog [_1] hat auf Eintrag #[_2] ("[_3]") einen noch nicht freigeschalteten Kommentar erhalten. Sie müssen diesen Kommentar freischalten, damit er auf Ihrem Weblog erscheint.',
	'Approve this comment:' => 'Kommentar freischalten:',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Auf Ihrem Blog [_1] wurde zu Eintag #[_2] ("[_3]") ein neuer Kommentar veröffentlicht.',
	'View this comment' => 'Kommentar ansehen',
	'Report this comment as spam' => 'Kommentar als Spam melden',

## tmpl/email/notify-entry.tmpl
	'A new post entitled \'[_1]\' has been published to [_2].' => 'In [_2] wurde ein neuer Eintrag namens \'[_1]\'.',
	'View post' => 'Eintrag ansehen',
	'Post Title' => 'Name des Eintrags',
	'Message from Sender' => 'Mitteilung des Absenders',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Sie erhalten diese E-Mail, da Sie entweder Nachrichten über Aktualisierungen von [_1] bestellt haben oder da der Autor dachte, daß dieser Eintrag für Sie von Interesse sein könnte. Wenn Sie solche Mitteilungen nicht länger erhalten wollen, wenden Sie sich bitte an ',

## tmpl/email/commenter_notify.tmpl
	'This email is to notify you that a new user has successfully registered on the blog \'[_1].\' Listed below you will find some useful information about this new user.' => 'Ein neuer Benutzer hat sich erfolgreich für \'[_1]\' registriert. Hier einige Details zum neuen Benutzer:',
	'Full Name' => 'Ganzer Name', # Translate - New # OK
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Um alle Benutzerdaten zu sehen oder zu bearbeiten, klicken Sie bitte auf folgende Adresse (oder kopieren Sie sie und fügen Sie sie in Adresszeile Ihres Web-Browsers ein):',

## tmpl/feeds/login.tmpl
	'Movable Type Activity Log' => 'Movable Type Aktivitätsprotokoll',
	'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

## tmpl/feeds/error.tmpl

## tmpl/feeds/feed_entry.tmpl
	'system' => 'System',
	'Untitled' => 'Ohne Name',
	'Unpublish' => 'Nicht mehr veröffentlichen',
	'More like this' => 'Ähnliche Einträge',
	'From this blog' => 'Aus diesem Blog',
	'From this author' => 'Von diesem Autoren',
	'On this day' => 'An diesem Tag',

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Quelle',
	'On this entry' => 'Zu diesem Eintrag',
	'By source blog' => 'Nach Quelle',
	'By source title' => 'Nach Name der Quelle',
	'By source URL' => 'By URL der Quelle',

## tmpl/feeds/feed_comment.tmpl
	'By commenter identity' => 'Nach Kommentarautoren-Identität',
	'By commenter name' => 'Nach Kommentarautoren-Name',
	'By commenter email' => 'Nach Kommentarautoren-Email',
	'By commenter URL' => 'Nach Kommentarautoren-URL',

);

## New words: 6090

1;
