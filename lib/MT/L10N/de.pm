# Movable Type (r) Open Source (C) 2005-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id$

package MT::L10N::de;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/archive_lib.php
	'Individual' => 'Individuell',
	'Page' => 'Seite',
	'Yearly' => 'Jährlich',
	'Monthly' => 'Monatlich',
	'Daily' => 'Täglich',
	'Weekly' => 'Wöchentlich',
	'Author' => 'Autor',
	'(Display Name not set)' => '(Kein Anzeigename gewählt)',
	'Author Yearly' => 'Autor jährlich',
	'Author Monthly' => 'Autor monatlich',
	'Author Daily' => 'Autor täglich',
	'Author Weekly' => 'Autor wöchentlich',
	'Category Yearly' => 'Kategorie jährlich',
	'Category Monthly' => 'Kategorie monatlich',
	'Category Daily' => 'Kategorie täglich',
	'Category Weekly' => 'Kategorie wöchentlich',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Sie haben einen &#8222;[_1]&#8220;-Befehl ohne gültiges Namensattribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '&#8222;[_1]&#8220; ist kein Hash.',
	'Invalid index.' => 'Index ungültig.',
	'\'[_1]\' is not an array.' => '&#8222;[_1]&#8220; ist kein Array.',
	'\'[_1]\' is not a valid function.' => '&#8222;[_1]&#8220; ist keine gültige Funktion.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Geben Sie die Zeichen ein, die Sie im obigen Bild sehen.',

## php/lib/function.mtassettype.php
	'image' => 'Bild',
	'Image' => 'Bild',
	'file' => 'Datei',
	'File' => 'Datei',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Video',
	'Video' => 'Video',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonym',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antworten',

## php/lib/function.mtentryclasslabel.php
	'page' => 'Seite',
	'entry' => 'Eintrag',
	'Entry' => 'Eintrag',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypePad-Authentifizierung ist für dieses Blog nicht aktiviert. MTremoteSignInLink kann daher nicht verwendet werden.',

## php/lib/function.mtsetvar.php

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '&#8222;[_1]&#8220; ist keine gültige Hash-Funktion.',
	'\'[_1]\' is not a valid function for an array.' => '&#8222;[_1]&#8220; ist keine gültige Array-Funktion.',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Fehler: Die Widgetgruppe &#8222;[_1]&#8220; ist leer.',
	'Error compiling widgetset [_1]' => 'Fehler bei Kompilierung der Widgetgruppe &#8222;[_1]&#8220;',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Seite nicht gefunden - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type Systemüberprüfung',
	'The mt-check.cgi script provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Das Skript mt-check.cgi führt eine Überprüfung Ihrer Systemkonfiguration durch  und stellt fest, ob alle zum Betrieb von Movable Type erforderlichen Komponenten vorhanden sind.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'Die  auf Ihrem Server installierte Perl-Version [_1] ist älter als die mindestens erforderliche Version [_2]. Bitte aktualisieren Sie Ihre Installation daher auf Perl [_2] oder neuer.',
	'Movable Type configuration file was not found.' => 'Keine Movable Type-Konfigurationsdatei vorhanden',
	'System Information' => 'Systeminformation',
	'Movable Type version:' => 'Movable Type-Version:',
	'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
	'MT home directory:' => 'MT-Wurzelverzeichnis:',
	'Operating system:' => 'Betriebssystem;',
	'Perl version:' => 'Perl-Version:',
	'Perl include path:' => 'Perl-Include-Pfad:',
	'Web server:' => 'Webserver:',
	'(Probably) Running under cgiwrap or suexec' => '(Wahrscheinlich) ausgeführt unter cgiwrap oder suexec',
	'[_1] [_2] Modules' => '[_1] [_2]-Modue',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Die folgenden Modue sind <strong>optional</strong>. Sind sie auf Ihrem Server nicht vorhanden, brauchen Sie sie nur dann zu installieren, wenn Sie eine davon abhängige Funktion nutzen möchten.',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Einige der  folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung mit Movable Type erforderlich. Zum Betrieb des Systems sind mindestens DBI und ein weiteres Modul erforderlich.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert oder die installierte [_1]-Version ist zu alt.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist  [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert.',
	'Please consult the installation instructions for help in installing [_1].' => 'Bitte beachten Sie bei der Installation von [_1] die Installationshinweise.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Die auf Ihrem Server installierte DBD::mysql-Version gilt als nicht kompatibel mit Movable Type. Bitte installieren Sie die aktuelle Version über CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod ist korrekt installiert, erfordert aber ein aktuelleres DBI-Modul. Bitte beachten Sie daher obige Hinweise  zu DBI-Mdulen.',
	'Your server has [_1] installed (version [_2]).' => 'Auf Ihrem Server ist [_1] in der Version [_2] installiert.',
	'Movable Type System Check Successful' => 'Der Movable Type-Systemcheck war erfolgreich!',
	'You\'re ready to go!' => 'Sie können sofort anfangen!',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Module sind auf Ihrem Server installiert. Beginnen Sie jetzt mit der Installation von Movable Type.',
	'CGI is required for all Movable Type application functionality.' => 'CGI ist für sämtliche Movable Type-Funktionen erforderlich.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size ist zum Hochladen von Dateien erforderlich (um die Größe hochgeladener Bilder bestimmen zu können)',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec ist zur Vereinheitlichung von Pfadangaben über Betriebssystemgrenzen hinweg erforerlich. ',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie ist zur Nutzung der  Cookie-Authentifizierung erforderlich.',
	'DBI is required to store data in database.' => 'DBI ist zur Nutzung von Datenbanken erforderlich.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI und DBD::mysql sind zur Nutzung von Movable Type mit einer MySQL-Datenbank erforderlich.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind zur Nutzung von Movable Type mit einer PostgreSQL-Datenbank erforderlich.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind zur Nutzung von Movable Type mit einer SQLite-Datenbank erforderlich.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI und DBD::SQLite2 sind zur Nutzung von Movable Type mit einer SQLite 2.x-Datenbank erforderlich.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities ist zur Kodierung bestimmter Zeichen erforderlich. Diese Funktion kann mittels der NoHTMLEntities-Direktive in der Konfigurationsdatei deaktiviert werden.',
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Die Installation von LWP::UserAgent ist optional. Dieses Modul ist erforderlich,  wenn Sie das TrackBack-System, weblogs.com-Pings und andere Aktualisierungs-Benachrichtigungen verwenden wollen.',
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Die Installation von HTML::Parser ist optional . Dieses Modul ist erforderlich, wenn Sie das TrackBack-System, weblogs.com-Pings und andere Aktualisierungs-Benachrichtigungen verwenden wollen.',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'Die Installation  von SOAP::Lite ist optional.  Dieses Modul ist zur Nutzung des XML-RPC-Servers von Movable Type erforderlich.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'Die Installation von File::Temp ist optional. Dieses Modul ist erforderlich, wenn Sie beim Hochladen von Dateien vorhandene Dateien überschreiben können möchten.',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Die Installation von Scalar::Util ist optional. Dieses Modul ist zur Nutzung der Veröffentlichungs-Warteschlange erforderlich.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Die Installation von List::Util ist optional.  Dieses Modul ist zur Nutzung der Veröffentlichungs-Warteschlange erforderlich.',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Die Installation von Image::Magick ist optional. Dieses Modul ist zur Erzeugung von Vorschaubildern von hochgeladenen Fotos erforderlich.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Dieses Modul ist zur Erzeugung von Vorschaubildern von hochgeladenen Dateien erforderlich.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Dieses Modul ist erforderlich, wenn Sie NetPBM als Bildquelle verwenden möchten.',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Die Installation von Storable ist optional.  Dieses Modul ist für einige Movable Type-Plugins von Drittanbietern erforderlich.',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Die Installation von Crypt::DSA ist optional. Dieses Modul beschleunigt den Anmeldevorgang für Kommentarautoren.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Dieses Modul und seine Abhängigkeiten sind zur OpenID-Authentifizierung von Kommentarautoren über SSL erforderlich (z.B. für die Authentifizierung durch AOL oder Yahoo!).',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 ist für die Kommentarregistrierung erforderlich.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist zur Nutzung der Atom-API erforderlich.',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached und der  memcached-Server/Daemon sind für den Nutzung des memcached-Cache von Movable Type erforderlich.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar ist zur Nutzung von Archiven bei Sicherungs-und Wiederherstellungs-Vorgängen erforderlich.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::GZip ist zum Packen von Dateien bei Sicherungs- und Wiederherstellungs-Vorgängen erforderlich.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Compress::Gunzip ist zum Entpacken von Dateien bei Sicherungs- und Wiederherstellungs-Vorgängen erforderlich.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip ist zur Nutzung von Archiven bei Sicherungs-und Wiederherstellungs-Vorgängen erforderlich.',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX und/oder seine Abhhängigkeiten sind für Wiederherstellungs-Vorgänge erforderlich.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Digest::SHA1 und seine Abhängigkeiten sind zur Authentifizierung von Kommentarautoren per OpenID (einschließlich Vox und LiveJournal) erforderlich.',
	'Mail::Sendmail is required for sending mail via SMTP Server.' => 'Mail::Sendmail ist zum Versand von E-Mail über SMTP-Server erforderlich.',
	'This module is used in test attribute of MTIf conditional tag.' => 'Dieses Modul ist für das test-Attribut des MTif conditional-Befehls erforderlich.',
	'This module is used by the Markdown text filter.' => 'Dieses Modul ist für den Markdown-Textfilter erforderlich.',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'Dieses Modul ist für mt-search.cgi erforderlich, wenn Sie Movable Type unter Perl älter als Version 5.8 ausführen.',
	'This module required for action streams.' => 'Dieses Modul ist für Action Streams erforderlich.',
	'The [_1] database driver is required to use [_2].' => 'Ein [_1]-Datenbanktreiber ist erforderlich, um eine [_2] zu nutzen.',
	'Checking for' => 'Überprüfe',
	'Installed' => 'Installiert',
	'Data Storage' => 'Datenbank',
	'Required' => 'Erforderlich',
	'Optional' => 'Optional',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Über diese Seite',
	'About this Archive' => 'Über dieses Archiv',
	'About Archives' => 'Über die Archive',
	'This page contains links to all the archived content.' => 'Diese Seite enthält Links zu allen archivierten Einträgen.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Diese Seite enthält einen einen einzelnen Eintrag von [_1] vom <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag in diesem Blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag in diesem Blog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Diese Archivseite enthält alle Einträge der Kategorie <strong>[_1]</strong> aus <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> ist das vorherige Archiv.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> ist das nächste Archiv.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Diese Seite enthält aktuelle Einträge der Kategorie <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> ist die vorherige Kategorie.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> ist die nächste Kategorie.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</strong> aus <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Diese Seite enthält alle Einträge von <strong>[_1]</strong> von neu nach alt.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>, alle Einträge in den <a href="[_2]">Archiven</a>.',

## default_templates/archive_index.mtml
	'HTML Head' => 'HTML-Kopf',
	'Archives' => 'Archiv',
	'Banner Header' => 'Banner-Kopf',
	'Monthly Archives' => 'Monatsarchive',
	'Categories' => 'Kategorien',
	'Author Archives' => 'Autorenarchive',
	'Category Monthly Archives' => 'Monatliche Kategoriearchive',
	'Author Monthly Archives' => 'Monatliche Autorenarchive',
	'Sidebar' => 'Seitenleiste',
	'Banner Footer' => 'Banner-Fuß',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Dies ist eine spezielle Widgetgruppe, die vom jeweiligen Archivtyp abhängige Inhalte ausgibt.',
	'Current Category Monthly Archives' => 'Monatsarchive der aktuellen Kategorie',
	'Category Archives' => 'Kategoriearchive',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autoren',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.com/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a href="[_1]">Creative Commons-Lizenz</a>.',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Monatskalender mit Link zu Tagesarchiven',
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

## default_templates/category_archive_list.mtml

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => '[_1] Archive',
	'Recently in <em>[_1]</em> Category' => 'Neues in der Kategorie <em>[_1]</em>',
	'Entry Summary' => 'Zusammenfassung',
	'Main Index' => 'Übersicht',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] hat auf den <a href="[_2]">Kommentar von [_3]</a> geantwortet</a>',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Danke, daß Sie sich zum Kommentieren bei [_1] registriert haben.',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Zur Vermeidung von Mißbrauch bestätigen Sie bitte Ihre Anmeldung und Ihre E-Mail-Adresse. Im Anschluss können Sie sofort auf [_1] kommentieren.',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Klicken Sie dazu auf folgenden Link (oder kopieren Sie Adresse und fügen Sie sie in Adresszeile Ihres Browsers ein):',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Sollten Sie sich nicht registriert haben oder Sie sich doch nicht auf  [_1] kommentierenwollen, brauchen Sie nichts weiter zu tun.',
	'Thank you very much for your understanding.' => 'Vielen Dank',
	'Sincerely,' => ' Ihr',
	'Mail Footer' => 'Mail-Signatur',

## default_templates/commenter_notify.mtml
	'This email is to notify you that a new user has successfully registered on the blog \'[_1]\'. Listed below you will find some useful information about this new user.' => 'Ein neuer Benutzer hat sich erfolgreich für &#8222;[_1]&#8220; registriert. Unten finden Sie nähere Informationen über diesen Benutzer.',
	'New User Information:' => 'Informationen über den neuen Benutzer:',
	'Username: [_1]' => 'Benutzername: [_1]',
	'Full Name: [_1]' => 'Vollständiger  Name: [_1]',
	'Email: [_1]' => 'E-Mail-Adresse:',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Um das zugehörige Benutzerkonto aufzurufen oder zu bearbeiten, klicken Sie bitte auf folgende Adresse (oder kopieren Sie sie und fügen Sie sie in Adresszeile Ihres Browsers ein):',

## default_templates/comment_listing.mtml
	'Comment Detail' => 'Kommentardetails',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Vorschau Ihres Kommentars',
	'Leave a comment' => 'Jetzt kommentieren',
	'Name' => 'Name',
	'Email Address' => 'E-Mail-Adresse',
	'URL' => 'URL',
	'Replying to comment from [_1]' => 'Antwort auf den Kommentar von [_1]',
	'Comments' => 'Kommentare',
	'(You may use HTML tags for style)' => '(HTML-Tags zur Textformatierung erlaubt)',
	'Preview' => 'Vorschau',
	'Submit' => 'Abschicken',
	'Cancel' => 'Abbrechen',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Bestätigung',
	'Your comment has been submitted!' => 'Ihr Kommentar ist eingegangen!',
	'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar.',
	'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar wurde abgeschickt. Er erscheint, sobald der Blogbetreiber ihn freigeschaltet hat.',
	'Comment Submission Error' => 'Fehler beim Kommentieren',
	'Your comment submission failed for the following reasons: [_1]' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden: [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">Zurück zum Eintrag</a>',

## default_templates/comments.mtml
	'1 Comment' => '1 Kommentar',
	'# Comments' => '# Kommentare',
	'No Comments' => 'Keine Kommentare',
	'Older Comments' => 'Ältere Kommentare',
	'Newer Comments' => 'Neuere Kommentare',
	'The data is modified by the paginate script' => 'Die Daten werden vom Paginierungsskript modifiziert.',
	'Remember personal info?' => 'Persönliche Angaben speichern?',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Sie können die Sperrung dieser Adresse wieder aufheben, indem Sie den Eintrag [_1] aus der Sperrliste unter Konfigurieren > Blog > IP-Sperren entfernen.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Die IP-Adresse eines Besuchers Ihres Weblogs [_1] wurde automatisch gesperrt, da er versucht hat, mehr Kommentare als in [_2] Sekunden zulässig zu veröffentlichen.',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Dadurch wird verhindert, daß bosärtige Skripte Ihr Blog mit Spam fluten können. Die gesperrte IP-Adresse lautet',

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Monatsarchive',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Jährliche Autorenarchive',
	'Author Weekly Archives' => 'Wöchentliche Autorenarchive',
	'Author Daily Archives' => 'Tägliche Autorenarchive',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Jährliche Kategoriearchive',
	'Category Weekly Archives' => 'Wöchentliche Kategoriearchive',
	'Category Daily Archives' => 'Tägliche Kategoriearchive',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Seite nicht gefunden',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Von [_1] zu [_2]',
	'1 TrackBack' => '1 TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Keine TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '<a rel="bookmark" href="[_1]">[_2]</a> weiterlesen',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/javascript.mtml
	'moments ago' => 'vor einem Augenblick',
	'[quant,_1,hour,hours] ago' => 'vor [quant,_1,Stunde,Stunden]',
	'[quant,_1,minute,minutes] ago' => 'vor [quant,_1,Minute,Minuten]',
	'[quant,_1,day,days] ago' => 'vor [quant,_1,Tag,Tagen]',
	'Edit' => 'Bearbeiten',
	'Your session has expired. Please sign in again to comment.' => 'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.',
	'Signing in...' => 'Anmeldung...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'Sie haben nicht die notwendige Berechtigung, um in diesem Blog Kommentare zu schreiben. ([_1]Abmelden[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Danke für Ihre Anmeldung, __NAME__. ([_1]Abmelden[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Anmelden[_2] um zu kommentieren',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Anmelden[_2] um zu kommentieren oder anonym kommentieren',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Antwort auf den <a href="[_1]" onclick="[_2]">Kommentar von [_3]</a>',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Diese Widgetgruppe ist zum Einsatz auf der Startseite ("main_index"). ausgelegt. Weitere Informationen: [_1]',
	'Recent Comments' => 'Aktuelle Kommentare',
	'Recent Entries' => 'Aktuelle Einträge',
	'Recent Assets' => 'Aktuelle Assets',
	'Tag Cloud' => 'Tag-Wolke',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Monat wählen...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archive</a>',

## default_templates/monthly_entry_listing.mtml

## default_templates/new-comment.mtml
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'In Ihrem Weblog [_1] ist ein noch nicht freigeschalteter Kommentar zum Eintrag "[_3]" (#[_2]) eingegangen. Schalten Sie den Kommentar frei, damit er auf Ihrem Weblog erscheint.',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'In Ihrem Weblog [_1] ist ein neuer Kommentar zum Eintrag "[_3]" (#[_2]) eingegangen:',
	'Commenter name: [_1]' => 'Name des Kommentarautors: [_1]',
	'Commenter email address: [_1]' => 'E-Mail-Adresse des Kommentarautors: [_1]',
	'Commenter URL: [_1]' => 'Web-Adresse (URL) des Kommentarautors:',
	'Commenter IP address: [_1]' => 'IP-Adresse des Kommentarautors:',
	'Approve comment:' => 'Kommentar freischalten:',
	'View comment:' => 'Kommentar ansehen:',
	'Edit comment:' => 'Kommentar bearbeiten:',
	'Report comment as spam:' => 'Kommentar als Spam melden:',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'In Ihrem Weblog [_1] ist ein noch nicht freigeschaltetes TrackBack zum Eintrag [_3] (#[_2]) eingegangen. Schalten Sie das TrackBack frei, damit es auf Ihrem Weblog erscheint.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'In Ihrem Weblog [_1] ist ein noch nicht freigeschaltetes TrackBack für die Kategorie [_3] (#[_2]) eingegangen. Schalten Sie das TrackBack frei, damit es auf Ihrem Weblog erscheint.',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'In Ihrem Weblog [_1] ist ein neuer TrackBack zum Eintrag [_3] (#[_2]) eingegangen.',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'In Ihrem Weblog [_1] ist ein neuer TrackBack für die Kategorie [_3] (#[_2]) eingegangen.',
	'Excerpt' => 'Zusammenfassung',
	'Title' => 'Titel',
	'Blog' => 'Blog',
	'IP address' => 'IP-Adresse',
	'Approve TrackBack' => 'TrackBack annehmen',
	'View TrackBack' => 'TrackBack ansehen',
	'Report TrackBack as spam' => 'TrackBack als Spam melden',
	'Edit TrackBack' => 'TrackBack bearbeiten',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => 'Ein neuer [_3] namens &#8222;[_1]&#8220; wurde auf [_2] veröffentlicht.',
	'View entry:' => 'Eintrag ansehen:',
	'View page:' => 'Seite ansehen:',
	'[_1] Title: [_2]' => 'Titel: [_2]',
	'Publish Date: [_1]' => 'Veröffentlichungsdatum:',
	'Message from Sender:' => 'Nachricht des Absenders:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Sie erhalten diese E-Mail, da Sie entweder Nachrichten über Aktualisierungen von [_1] bestellt haben oder da der Autor dachte, daß dieser Eintrag für Sie von Interesse sein könnte. Wenn Sie solche Mitteilungen nicht länger erhalten wollen, wenden Sie sich bitte an ',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] unterstützt',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Mehr über OpenID erfahren',

## default_templates/page.mtml

## default_templates/pages_list.mtml
	'Pages' => 'Seiten',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/recent_assets.mtml

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="Vollständiger Kommentar zu [_4]">weiterlesen</a>',

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Es wurde eine Anfrage zur Änderung Ihres Passwortes in Movable Type gestellt. Bitte klicken Sie auf untenstehenden Link und wählen Sie ein neues Passwort aus um diesen Prozess abzuschließen.',
	'If you did not request this change, you can safely ignore this email.' => 'Wenn Sie diese Änderung nicht wünschen können Sie diese E-Mail bedenkenlos ignorieren.',

## default_templates/search.mtml
	'Search' => 'Suchen',
	'Case sensitive' => 'Groß-/Kleinschreibung unterscheiden',
	'Regex search' => 'Reguläre Ausdrücke verwenden',

## default_templates/search_results.mtml
	'Search Results' => 'Suchergebnisse',
	'Results matching &ldquo;[_1]&rdquo;' => 'Suchergebnisse für &#8222;[_1]&#8220;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Suchergebnisse mit Tag &#8222;[_1]&#8220;',
	'Previous' => 'Zurück',
	'Next' => 'Vor',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Keine Suchergebnisse für &#8222;[_1]&#8220; gefunden',
	'Instructions' => 'Hinweise',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Die Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',
	'movable type' => 'Movable Type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt:',
	'personal OR publishing' => 'Schrank OR Schublade',
	'publishing NOT personal' => 'Regal NOT Schrank',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Zweispaltig - Seitenleiste',
	'3-column layout - Primary Sidebar' => 'Dreispaltig- Primäre Seitenleiste',
	'3-column layout - Secondary Sidebar' => 'Dreispaltig - Sekundäre Seitenleiste',

## default_templates/signin.mtml
	'Sign In' => 'Anmelden',
	'You are signed in as ' => 'Sie sind angemeldet als',
	'sign out' => 'abmelden',
	'You do not have permission to sign in to this blog.' => 'Sie haben keine Berechtigung zur Anmeldung an diesem Blog.',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'Feed abonnieren',
	'Subscribe to this blog\'s feed' => 'Feed dieses Blogs abonnieren',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Feed aller künftigen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Feed aller künftigen Einträge mit &#8222;[_1]&#8220; abonnieren',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed aller mit &#8222;[_1]&#8220; getaggten Ergebnisse abonnieren',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feeds aller Ergebnisse zu &#8222;[_1]&#8220; abonnieren',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a>-Suche',
	'this blog' => 'in diesem Blog',
	'all blogs' => 'in allen Blogs',
	'Blogs that link here' => 'Blogs, die Links auf diese Seite enthalten',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'TrackBack-URL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> von [_3] zu <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Weiterlesen</a>',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Vielen Dank, daß Sie Benachrichtungen über Aktualisierungen von [_1] abonniert haben. Klicken Sie zur Bestätigung bitte auf folgenden Link:',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Kann der Link nicht angeklickt werden, kopieren Sie ihn und fügen ihn in der Adresszeile Ihres Browers ein.',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Bei Erzeugung des Aktivitäts-Feeds ist ein Fehler aufgetreten: [_1].',
	'No permissions.' => 'Keine Berechtigung.',
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Alle TrackBacks',
	'[_1] Comments' => '[_1] Kommentare',
	'All Comments' => 'Alle Kommentare',
	'[_1] Entries' => '[_1] Einträge',
	'All Entries' => 'Alle Einträge',
	'[_1] Activity' => '[_1] Aktivitäten',
	'All Activity' => 'Alle Aktivitäten',
	'Movable Type System Activity' => 'Movable Type System-Aktivität',
	'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',
	'[_1] Pages' => '[_1] Seiten',
	'All Pages' => 'Alle Seiten',

## lib/MT/App/CMS.pm
	'Invalid request' => 'Ungültige Anfrage',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Sie sind dabei, E-Mails zu verschicken, mit denen die ausgewählten Benutzer ihre Passwörter zurücksetzen können. Fortfahren?',
	'_WARNING_DELETE_USER_EUM' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen? Benutzer können ihre Konten selbst wiederherstellen, solange sie noch in externen Verzeichnissen aufgeführt sind.',
	'_WARNING_DELETE_USER' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Hiermit werden die Vorlagen der gewählten Blogs auf die Standardvorlagen zurückgesetzt. Möchten Sie die Vorlagen der gewählten Blogs wirklich zurücksetzen?',
	'Only website log' => 'Nur Website-Log',
	'My [_1] of this [_2]' => 'Meine [_1] dieses [_2]',
	'Published [_1]' => 'Veröffentlichte [_1]',
	'Unpublished [_1]' => 'Nicht veröffentlichte [_1]',
	'Scheduled [_1]' => 'Zeitgeplante [_1]',
	'My [_1]' => 'Meine [_1]',
	'[_1] with comments in the last 7 days' => '[_1] mit Kommentaren in den letzten 7 Tagen',
	'[_1] posted between [_2] and [_3]' => 'Zwischen dem [_2] und dem [_3] veröffentlichte [_1]',
	'[_1] posted since [_2]' => 'Seit dem [_2] veröffentlichte [_1]',
	'[_1] posted on or before [_2]' => 'Am oder vor dem [_2] veröffentlichte [_1]',
	'[_1] of this website' => '[_1] dieser Website',
	'Non-spam TrackBacks on this website' => 'Gültige TrackBacks auf dieser Website',
	'Non-spam Comments on this website' => 'Gültige Kommentare auf dieser Website',
	'Comments on my entries of [_1]' => 'Kommentare zu meinen Einträgen von [_1]',
	'All comments by [_1] \'[_2]\'' => 'Alle Kommentare von [_1] &#8222;[_2]&#8220;',
	'Commenter' => 'Kommentarautor',
	'All comments for [_1] \'[_2]\'' => 'Alle Kommentare für  [_1] &#8222;[_2]&#8220;',
	'Comments posted between [_1] and [_2]' => 'Zwischen [_1] und [_2] veröffentlichte Kommentare',
	'Comments posted since [_1]' => 'Seit [_1] veröffentlichte Kommentare',
	'Comments posted on or before [_1]' => 'Bis einschließlich [_1] veröffentlichte Kommentare',
	'You are not authorized to log in to this blog.' => 'Sie sind nicht berechtigt, sich an diesem Blog anzumelden.',
	'No such blog [_1]' => 'Kein Weblog [_1]',
	'Edit Template' => 'Vorlage bearbeiten',
	'Go Back' => 'Zurück',
	'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
	'None' => 'Kein(e)',
	'Error during publishing: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'This is You' => 'Das sind Sie',
	'Movable Type News' => 'Movable Type Aktuell',
	'Blog Stats' => 'Statistik',
	'Websites' => 'Websites',
	'Blogs' => 'Blogs',
	'Websites and Blogs' => 'Websites und Blogs',
	'Entries' => 'Einträge',
	'Refresh Templates' => 'Vorlagen zurücksetzen',
	'Use Publishing Profile' => 'Veröffentlichungsprofil verwenden',
	'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
	'Add Tags...' => 'Tags hinzufügen...',
	'Tags to add to selected entries' => 'Gewählte Einträge mit diesen Tags versehen',
	'Remove Tags...' => 'Tags entfernen...',
	'Tags to remove from selected entries' => 'Diese Tags von gewählten Einträgen entfernen',
	'Batch Edit Entries' => 'Mehrere Einträge bearbeiten',
	'Unpublish Pages' => 'Seiten nicht mehr veröffentlichen',
	'Tags to add to selected pages' => 'Gewählte Seiten mit diesen Tags versehen',
	'Tags to remove from selected pages' => 'Diese Tags von gewählten Seiten entfernen',
	'Batch Edit Pages' => 'Mehrere Seiten bearbeiten',
	'Tags to add to selected assets' => 'Gewählte Assets mit diesen Tags versehen',
	'Tags to remove from selected assets' => 'Diese Tags von gewählten Assets entfernen',
	'Unpublish TrackBack(s)' => 'TrackBack(s) nicht mehr veröffentlichen',
	'Unpublish Comment(s)' => 'Kommentar(e) nicht mehr veröffentlichen',
	'Trust Commenter(s)' => 'Kommentarautor(en) vertrauen',
	'Untrust Commenter(s)' => 'Kommentarautor(en) nicht mehr vertrauen',
	'Ban Commenter(s)' => 'Kommentarautor(en) sperren',
	'Unban Commenter(s)' => 'Kommentator(en) nicht mehr sperren',
	'Recover Password(s)' => 'Passwort anfordern',
	'Delete' => 'Löschen',
	'Refresh Template(s)' => 'Vorlage(n) zurücksetzen',
	'Move blog(s) ' => 'Blog(s) verschieben',
	'Clone Blog' => 'Blog klonen',
	'Publish Template(s)' => 'Vorlage(n) veröffentlichen',
	'Clone Template(s)' => 'Vorlage(n) klonen',
	'Non-spam TrackBacks' => 'Gültige TrackBacks',
	'Pending TrackBacks' => 'Wartende TrackBacks',
	'Published TrackBacks' => 'Veröffentlichte TrackBacks',
	'TrackBacks on my entries/pages' => 'TrackBacks zu meinen Einträgen/Seiten',
	'TrackBacks in the last 7 days' => 'TrackBacks der letzten 7 Tage',
	'Spam TrackBacks' => 'Spam-TrackBacks',
	'Non-spam Comments' => 'Gültige Kommentare',
	'Pending comments' => 'Zu moderierende Kommentare',
	'Published comments' => 'Veröffentlichte Kommentare',
	'Comments on my entries/pages' => 'Kommentare zu meinen Einträgen/Seiten',
	'Comments in the last 7 days' => 'Kommentare der letzten 7 Tage',
	'Spam Comments' => 'Spam-Kommentare',
	'Tags with entries' => 'Eintrags-Tags',
	'Tags with pages' => 'Seiten-Tags',
	'Tags with assets' => 'Assets-Tags',
	'Enabled Users' => 'Aktive Benutzerkonten',
	'Disabled Users' => 'Deaktivierte Benutzerkonten',
	'Pending Users' => 'Wartende Benutzerkonten',
	'Commenters' => 'Kommentarautoren',
	'Assets' => 'Assets',
	'Users' => 'Benutzer',
	'Design' => 'Gestalten',
	'Settings' => 'Einstellungen',
	'Tools' => 'Tools',
	'Manage' => 'Verwalten',
	'New' => 'Neu',
	'Folders' => 'Ordner',
	'TrackBacks' => 'TrackBacks',
	'Templates' => 'Vorlagen',
	'Widgets' => 'Widgets',
	'Themes' => 'Themen',
	'General' => 'Allgemein',
	'Compose' => 'Schreiben',
	'Feedback' => 'Feedback',
	'Registration' => 'Registrierung',
	'Web Services' => 'Webdienste',
	'IP Banning' => 'IP-Sperren',
	'User' => 'Benutzer',
	'Roles' => 'Rollen',
	'Permissions' => 'Berechtigungen',
	'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
	'Plugins' => 'Plugins',
	'Import Entries' => 'Einträge importieren',
	'Export Entries' => 'Einträge exportieren',
	'Export Theme' => 'Thema exportieren',
	'Backup' => 'Sichern',
	'Restore' => 'Wiederherstellen',
	'Address Book' => 'Adressbuch',
	'Activity Log' => 'Aktivitäten',
	'Create New' => 'Neu anlegen',
	'Asset' => 'Asset',
	'Website' => 'Website',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fehler bei der Zuweisung von Kommentierungsrechten an Benutzer &#8222;[_1] (ID: [_2])&#8220; für Weblog \'[_3] (ID: [_4])\'. Keine geeignete Kommentierungsrolle gefunden.',
	'Can\'t load blog #[_1].' => 'Kann Blog #[_1] nicht laden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ungültiger Anmeldeversuch von Kommentarautor [_1] an Weblog [_2](ID: [_3]) - native Movable Type-Authentifizierung bei diesem Weblog nicht zulässig.',
	'Invalid login.' => 'Login ungültig.',
	'Invalid login' => 'Login ungültig',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Sie wurden erfolgreich authentifiziert, Registrierungen sindaber nicht erlaubt. Bitte wenden Sie sich an den Systemadministrator.',
	'You need to sign up first.' => 'Bitte registrieren Sie sich zuerst.',
	'Permission denied.' => 'Zugriff verweigert.',
	'Login failed: permission denied for user \'[_1]\'' => 'Anmeldung fehlgeschlagen: Zugriff verweigert für Benutzer &#8222;[_1]&#8220;',
	'Login failed: password was wrong for user \'[_1]\'' => 'Anmeldung fehlgeschlagen: falsches Passwort für Benutzer &#8222;[_1]&#8220;',
	'Failed login attempt by disabled user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von deaktiviertem Benutzer &#8222;[_1]&#8220;',
	'Failed login attempt by unknown user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer &#8222;[_1]&#8220;',
	'Signing up is not allowed.' => 'Registrierungen sind nicht erlaubt.',
	'Movable Type Account Confirmation' => 'Movable Type-Anmeldungsbestätigung',
	'System Email Address is not configured.' => 'Die System-E-Mail-Adresse ist nicht konfiguriert.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Kommentarautor &#8222;[_1]&#8220; (ID:[_2]) erfolgreich registriert.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Vielen Dank für Ihre Bestätigung. Sie können sich jetzt anmelden und kommentieren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] hat sich für das Blog &#8222;[_2]&#8220; registriert.',
	'No id' => 'Keine ID',
	'No such comment' => 'Kein entsprechender Kommentar',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
	'IP Banned Due to Excessive Comments' => 'IP-Adresse wegen exzessiver Kommentarabgabe gesperrt',
	'No entry_id' => 'Entry_id fehlt',
	'No such entry \'[_1]\'.' => 'Kein Eintrag &#8222;[_1]&#8220;.',
	'_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in schneller Folge abgegeben. Bitte versuchen Sie es in einigen Augenblicken erneut.',
	'Comments are not allowed on this entry.' => 'Zu diesem Eintrag können keine Kommentare abgegeben werden.',
	'Comment text is required.' => 'Bitte geben Sie einen Kommentartext ein.',
	'An error occurred: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
	'Registration is required.' => 'Registrierung erforderlich',
	'Name and email address are required.' => 'Name und E-Mail-Adresse sind Pflichtfelder',
	'Invalid email address \'[_1]\'' => 'Ungültige E-Mail-Adresse &#8222;[_1]&#8220;',
	'Invalid URL \'[_1]\'' => 'Ungültige Web-Adresse (URL) &#8222;[_1]&#8220;',
	'Text entered was wrong.  Try again.' => 'Der eingegebene Text ist nicht richtig. Bitte versuchen Sie es erneut.',
	'Comment save failed with [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
	'Publish failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Can\'t load template' => 'Kann Vorlage nicht laden',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Fehlgeschlagener Kommentierungsversuch durch wartenden Kommentarautoren &#8222;[_1]&#8220;',
	'Registered User' => 'Registrierter Benutzer',
	'The sign-in attempt was not successful; please try again.' => 'Anmeldeversuch nicht erfolgreich. Bitte versuchen Sie es erneut.',
	'Can\'t load entry #[_1].' => 'Kann Eintrag #[_1] nicht laden.',
	'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag angegeben. Vielleicht gibt es ein Problem mit der Vorlage?',
	'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
	'Invalid entry ID provided' => 'Ungültige Eintrags-ID angegeben',
	'All required fields must have valid values.' => 'Alle erforderlichen Felder müssen gültige Werte aufweisen.',
	'[_1] contains an invalid character: [_2]' => '[_1] enthält  ein ungültiges Zeichen: [_2]',
	'Display Name' => 'Angezeigter Name',
	'Passwords do not match.' => 'Passwörter stimmen nicht überein.',
	'Email Address is invalid.' => 'Die E-Mail-Adresse ist ungültig.',
	'URL is invalid.' => 'Die Web-Adresse (URL) ist ungültig.',
	'Commenter profile has successfully been updated.' => 'Das Profil des Kommentarautoren wurde erfolgreich aktualisiert.',
	'Commenter profile could not be updated: [_1]' => 'Das Profil des Kommentarautoren konnte nicht aktualisiert werden: [_1]',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Bitte geben Sie eine gültige E-Mail-Adresse an.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Erforderliches Parameter blog_id fehlt. Bitte konfigurieren Sie die Benachrichtungsfunktion entsprechend.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Ungültiges Redirect-Parameter. Es muss ein Pfad angegeben sein, der zur Domain dieses Weblogs gehört.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'An die Adresse &#8222;[_1]&#8220; werden bereits Benachrichtigungen über dieses Weblog verschickt.',
	'Please verify your email to subscribe' => 'Bitte bestätigen Sie Ihre E-Mail-Adresse',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Um den Vorgang abzuschließen, klicken Sie bitte auf den Link in der E-Mail, die an [_1] verschickt wurde. Damit stellen Sie sicher, daß die E-Mail-Adresse Ihnen gehört und korrekt eingegeben wurde.',
	'The address [_1] was not subscribed.' => 'Die Adresse [_1] war kein Abonnent.',
	'The address [_1] has been unsubscribed.' => 'Die Adresse [_1] ist kein Abonnent mehr.',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Ungültige Anfrage: ungültige Zeichen für Zeichensatz [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Fehler beim Laden der Website #[_1] zur Bereitstellung an Benutzer. Bitte überprüfen Sie Ihre NewUserDefaultWebsiteId-Einstellugen.',
	'First Weblog' => 'Erstes Weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fehler beim Laden von Blog #[_1] zur Bereitstellung an Benutzer. Bitte überprüfen Sie Ihre NewUserTemplateBlogId-Einstellung.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Fehler bei Bereitstellung des Blogs für neuen Benutzer &#8222;[_1]&#8220; mit Vorlage Blog #[_2].',
	'Error creating directory [_1] for blog #[_2].' => 'Fehler beim Anlegen des Ordners [_1] für Blog #[_2])',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Fehler bei Bereitstellung des Blogs für neuen Benutzer \'[_1] (ID: [_2]\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' für Benutzer \'[_3] (ID: [_4])\' erfolgreich angelegt.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Fehler bei Zuweisung von Administratorensrechten für Blog \'[_3] (ID: [_4])\') an Benutzer \'[_1] (ID: [_2])\'. Keine passende Administratorenrolle gefunden.',
	'Internal Error: Login user is not initialized.' => 'Interner Fehler: Login-Benutzer nicht initialisiert.',
	'The login could not be confirmed because of a database error ([_1])' => 'Anmeldung konnte aufgrund eines Datenbankfehlers nicht durchgeführt werden ([_1])',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Es tut uns leid, aber Sie keine Berechtigung, auf Blogs oder Websites dieser Installation zuzugreifen. Sollte hier ein Irrtum vorliegen, wenden Sie sich bitte an Ihren Movable Type-Systemadministrator.',
	'This account has been disabled. Please see your system administrator for access.' => 'Dieses Benutzerkonto wurde deaktiviert. Bitte wenden Sie sich an Ihren Systemadministrator.',
	'Failed login attempt by pending user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von wartendem Benutzer &#8222;[_1]&#8220;',
	'This account has been deleted. Please see your system administrator for access.' => 'Dieses Benutzerkonto wurde gelöscht. Bitte wenden Sie sich an Ihren Systemadministrator.',
	'User cannot be created: [_1].' => 'Kann Benutzerkonto nicht anlegen: [_1].',
	'User \'[_1]\' has been created.' => 'Benutzerkonto &#8222;[_1]&#8220; angelegt.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) erfolgreich angemeldet',
	'Invalid login attempt from user \'[_1]\'' => 'Ungültiger Anmeldeversuch von Benutzer &#8222;[_1]&#8220;',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) abgemeldet',
	'User requires password.' => 'Passwort erforderlich.',
	'User requires display name.' => 'Anzeigename erforderlich.',
	'Email Address is required for password recovery.' => 'Für Passwort-Anforderungen ist eine E-Mail-Adresse erforderlich.',
	'User requires username.' => 'Benutzername erforderlich.',
	'Username' => 'Benutzername',
	'A user with the same name already exists.' => 'Ein Benutzer mit diesem Namen existiert bereits.',
	'Something wrong happened when trying to process signup: [_1]' => 'Bei der Bearbeitung der Registrierung ist ein Fehler aufgetreten: [_1]',
	'New Comment Added to \'[_1]\'' => 'Neuer Kommentar zu &#8222;[_1]&#8220; eingegangen',
	'Close' => 'Schließen',
	'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu groß.',
	'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
	'Warnings and Log Messages' => 'Warnungen und Logmeldungen',
	'Removed [_1].' => '[_1] entfernt.',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'Suche läuft. Bitte warten Sie, bis Ihre Suche  abgeschlossen ist.',
	'Search failed. Invalid pattern given: [_1]' => 'Suche fehlgeschlagen - ungültiges Suchmuster angegeben: [_1]',
	'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
	'Invalid request.' => 'Ungültige Anfrage.',
	'No alternate template is specified for the Template \'[_1]\'' => 'Keine alternative Vorlage für Vorlage &#8222;[_1]&#8220; angegeben',
	'Opening local file \'[_1]\' failed: [_2]' => 'Die lokale Datei &#8222;[_1]&#8220; konnte nicht geöffnet werden: [_2]',
	'Publishing results failed: [_1]' => 'Die Suchergebnisse konnten nicht ausgegeben werden: [_1]',
	'Search: query for \'[_1]\'' => 'Suche: Suche nach &#8222;[_1]&#8220;',
	'Search: new comment search' => 'Suche: Suche nach neuen Kommentaren',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => 'Ungültiger [_1]-Parameter.',
	'Invalid type: [_1]' => 'Ungültiger Typ: [_1]',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Suche: konnte Ergebnisse nicht zwischenspeichern. [_1] ist nicht verfügbar: [_2]',
	'Invalid format: [_1]' => 'Ungültiges Format: [_1]',
	'Unsupported type: [_1]' => 'Nicht unterstützter Typ: [_1]',
	'Invalid query: [_1]' => 'Ungültige Suchanfrage: [_1]',
	'Invalid archive type' => 'Ungültiger Archivtyp',
	'Invalid value: [_1]' => 'Ungültiger Wert: [_1]',
	'No column was specified to search for [_1].' => 'Keine Spalte zur Suche nach [_1] angegeben.',
	'No such template' => 'Keine solche Vorlage',
	'template_id cannot be a global template' => 'template_id kann keine globale Vorlage sein ',
	'Output file cannot be asp or php' => 'Die Ausgabedatei darf weder vom .asp noch .php sein',
	'You must pass a valid archive_type with the template_id' => 'Bitte übergeben Sie mit der template_id eine gültige archive_type-Angabe',
	'Template must have identifier entry_listing for non-Index archive types' => 'Vorlagen für Nicht-Archiv-Indizes müssen zur Identifizierbarkeit ein entry_listing enthalten.',
	'Blog file extension cannot be asp or php for these archives' => 'Bei diesen Archivtypen dürfen die zugehörigen Dateinamen nicht auf .asp oder .php enden',
	'Template must have identifier main_index for Index archive type' => 'Vorlagen für Archiv-Indizes müssen zur Identifizierbarkeit ein main_index enthalten',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'Die Suche dauert zu lange. Bitte vereinfachen Sie Ihre Suchanfrage und versuchen Sie es erneut.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch verwendet MT::App::Search.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'Ungültige entry_id &#8222;[_1]&#8220;',
	'You must define a Ping template in order to display pings.' => 'Sie müssen eine Ping-Vorlage definieren, um Pings anzeigen zu können.',
	'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
	'Need a TrackBack ID (tb_id).' => 'Benötige TrackBack-ID (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID &#8222;[_1]&#8220;',
	'You are not allowed to send TrackBack pings.' => 'Sie haben keine Berechtigung, TrackBack-Pings zu senden.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Sie senden zu viele TrackBack-Pings zu schnell hintereinander. Bitte versuchen Sie es später erneut.',
	'Need a Source URL (url).' => 'Quelladresse erforderlich (URL).',
	'This TrackBack item is disabled.' => 'Dieser TrackBack-Eintrag ist deaktiviert.',
	'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack für Kategorie &#8222;[_1]&#8220; (ID:[_2])',
	'Can\'t create RSS feed \'[_1]\': ' => 'RSS-Feed &#8222;[_1]&#8220; kann nicht angelegt werden: ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Neuer TrackBack-Ping für Eintrag [_2] (#[_1])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Neuer TrackBack-Ping für Kategorie [_2] (#[_1])',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Die Authentifizierung mit den angebeben Benutzerdaten ist fehlgeschlagen: [_1]',
	'Both passwords must match.' => 'Die beiden Passwörter müssen übereinstimmen.',
	'You must supply a password.' => 'Bitte geben Sie ein Passwort an.',
	'An e-mail address is required.' => 'Bitte geben Sie eine E-Mail-Adresse an.',
	'The \'Publishing Path\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'Der angegebene Veröffentlichungspfad kann vom Webserver nicht beschrieben werden. Stellen Sie sicher, daß der Webserver über Schreibrechte für dieses Verzeichnis verfügt und klicken Sie erneut auf &#8222;Installation abschließen&#8220;.',
	'Invalid session.' => 'Ungültige Session',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Fehlende Berechtigung: Bitte kontaktieren Sie für die Aktualisierung von Movable Type Ihren Administrator.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type erfolgreich auf Version [_1] aktualisiert.',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Blog mit ID [_1] konte nicht geladen werden',
	'Template publishing failed: [_1]' => 'Vorlage konnte nicht veröffentlicht werden: [_1]',
	'Invalid date spec' => 'Ungültiges Datumsformat',
	'Can\'t load templatemap' => 'Kann Vorlagenverknüpfungen nicht laden',
	'Can\'t load template [_1]' => 'Kann Vorlage [_1] nicht laden',
	'Archive publishing failed: [_1]' => 'Archiv konnte nicht veröffentlicht werden: [_1]',
	'Invalid entry ID [_1]' => 'Ungültige Eintrags-ID [_1]',
	'Entry [_1] is not published' => 'Eintrag [_1] nicht veröffentlicht',
	'Invalid category ID \'[_1]\'' => 'Ungültige Kategorie-ID &#8222;[_1]&#8220;',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Zur Nutzung von [_2] ist ein [_1]-Treiber erforderlich.',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Es konnte keine Verbindung zur Datenbank aufgebaut werden. Bitte überprüfen Sie die Einstellungen und versuchen Sie es erneut.',
	'Please select database from the list of database and try again.' => 'Bitte wählen Sie eine Datenbank aus der Liste und versuchen Sie es erneut.',
	'SMTP Server' => 'SMTP-Server',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Testmail vom Movable Type-Konfigurationsassistenten',
	'This is the test email sent by your new installation of Movable Type.' => 'Diese Testmail wurde von Ihrer neuen Movable Type-Installation verschickt.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Dieses Modul ist zur Kodierung von Sonderzeichen erforderlich. Die Kodierung von Sonderzeichen kann über den Schalter NoHTMLEntities in mt-config.cgi abgeschaltet werden.',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Dieses Modul ist zur Nutzung von TrackBacks, weblogs.com-Pings und des MT-Kürzlich-Aktualisiert-Pings erforderlich.',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Dieses Modul ist zur Verwendung des XML-RPC-Servers notwendig.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Dieses Modul ist zum Überschreiben bereits vorhandener Dateien beim Hochladen erforderlich.',
	'This module is required by certain MT plugins available from third parties.' => 'Dieses Modul ist für einige MT-Plugins von Drittanbietern erforderlich.',
	'This module accelerates comment registration sign-ins.' => 'Dieses Modul beschleunigt die Anmeldung als Kommentarautor.',
	'This module is needed to enable comment registration.' => 'Dieses Modul ermöglicht die Registrierung von Kommentarautoren.',
	'This module enables the use of the Atom API.' => 'Dieses Modul ermöglicht die Verwendung der ATOM-API.',
	'This module is required in order to archive files in backup/restore operation.' => 'Dieses Modul ist zur Archivierung von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to compress files in backup/restore operation.' => 'Dieses Modul ist zur Packen von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Dieses Modul ist zum Entpackenvon Dateien  beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Dieses Modul und seine Abhängigkeiten sind zum Einspielen von Sicherheitskopien erforderlich.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Dieses Modul und seine Abhängigkeiten sind zur Authentifizierung von Kommentarautoren per OpenID (z.B. Vox, LiveJournal) erforderlich.',
	'This module is required for sending mail via SMTP Server.' => 'Dieses Modul ist zum Verschicken von E-Mails per SMTP erforderlich.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Dieses Modul ist zur Bestimmung der Größe hochgeladener Dateien erforderlich.',
	'This module is required for cookie authentication.' => 'Dieses Modul ist zur Cookie-Authentifizierung erforderlich.',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'tägliche Autorenarchive',
	'author/author-display-name/yyyy/mm/dd/index.html' => 'autor/anzeigename-des-autors/jjjj/mm/tt/index.html',
	'author/author_display_name/yyyy/mm/dd/index.html' => 'autor/anzeigename_des_autors/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'monatliche Autorenarchive',
	'author/author-display-name/yyyy/mm/index.html' => 'autor/anzeigename-des-autors/jjjj/mm/index.html',
	'author/author_display_name/yyyy/mm/index.html' => 'autor/anzeigename_des_autors/jjjj/mm/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Autorenarchive',
	'author/author-display-name/index.html' => 'autor/anzeigename-des-autors/index.html',
	'author/author_display_name/index.html' => 'autor/anzeigename_des_autors/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'wöchentliche Autorenarchive',
	'author/author-display-name/yyyy/mm/day-week/index.html' => 'autor/anzeigename-des-autors/jjjj/mm/tag-woche/index.html',
	'author/author_display_name/yyyy/mm/day-week/index.html' => 'autor/anzeigename_des_autors/jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'jährliche Autorenarchive',
	'author/author-display-name/yyyy/index.html' => 'autor/anzeigename-des-autors/jjjj/index.html',
	'author/author_display_name/yyyy/index.html' => 'autor/anzeigename_des_autors/jjjj/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'tägliche Kategoriearchive',
	'category/sub-category/yyyy/mm/dd/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tt/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'monatliche Kategoriearchive',
	'category/sub-category/yyyy/mm/index.html' => 'kategorie/unter-kategorie/jjjj/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'kategorie/unter_kategorie/jjjj/mm/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Kategoriearchive',
	'category/sub-category/index.html' => 'kategorie/unter-kategorie/index.html',
	'category/sub_category/index.html' => 'kategorie/unter_kategorie/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'wöchentliche Kategoriearchive',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tag-woche/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'jährliche Kategoriearchive',
	'category/sub-category/yyyy/index.html' => 'kategorie/unter-kategorie/jjjj/index.html',
	'category/sub_category/yyyy/index.html' => 'kategorie/unter_kategorie/jjjj/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'Tagesarchive',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'Einzelarchive',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/eintrags-name.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/eintrags_name.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/eintrags-name/index.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/eintrags_name/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/tt/eintrags-name.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/tt/eintrags_name.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/tt/eintrags-name/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/tt/eintrags_name/index.html',
	'category/sub-category/entry-basename.html' => 'kategorie/unter-kategorie/eintrags-name.html',
	'category/sub-category/entry-basename/index.html' => 'kategorie/unter-kategorie/eintrags-name/index.html',
	'category/sub_category/entry_basename.html' => 'kategorie/unter_kategorie/eintrags_name.html',
	'category/sub_category/entry_basename/index.html' => 'kategorie/unter_kategorie/eintrags_name/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'Monatsarchive',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Seitenarchive',
	'folder-path/page-basename.html' => 'pfad-angabe/seiten-name.html',
	'folder-path/page-basename/index.html' => 'pfad-angabe/seiten-name/index.html',
	'folder_path/page_basename.html' => 'pfad_angabe/seiten_name.html',
	'folder_path/page_basename/index.html' => 'pfad_angabe/seiten_name/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'Wochenarchive',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'Jahresarchive',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Bilder',
	'Actual Dimensions' => 'Ausgangsgröße',
	'[_1] x [_2] pixels' => '[_1] x [_2] Pixel',
	'Error cropping image: [_1]' => 'Fehler beim Beschnitt des Bildes: [_1]',
	'Error scaling image: [_1]' => 'Fehler bei der Skalierung des Bildes: [_1]',
	'Error converting image: [_1]' => 'Fehler bei der Umwandlung des Bildes: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fehler beim Erzeugen des Vorschaubildes: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Can\'t load image #[_1]' => 'Kann Bild #[_1] nicht laden',
	'View image' => 'Bild ansehen',
	'Permission denied setting image defaults for blog #[_1]' => 'Fehlende B: Bild-Voreinstellungen für Weblog #[_1] nicht geändert',
	'Thumbnail image for [_1]' => 'Vorschaubild für [_1]',
	'Invalid basename \'[_1]\'' => 'Ungültiger Basisname &#8222;[_1]&#8220;',
	'Error writing to \'[_1]\': [_2]' => 'Fehler beim Speichern unter &#8222;[_1]&#8220;: [_2]',
	'Popup Page for [_1]' => 'Popup-Seite für [_1]',

## lib/MT/Asset.pm
	'Could not remove asset file [_1] from filesystem: [_2]' => 'Konnte Asset-Datei [_1] nicht aus dem Dateisystem löschen: [_2]',
	'Description' => 'Beschreibung',
	'Location' => 'Ort',
	'string(255)' => 'string(255)',

## lib/MT/Asset/Video.pm
	'Videos' => 'Videos',

## lib/MT/Association.pm
	'Association' => 'Verknüpfung',
	'Associations' => 'Verknüpfungen',
	'association' => 'Verknüpfungen',
	'associations' => 'Verknüpfungen',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Einträge',
	'Invalid blog ID \'[_1]\'' => 'Ungültige Blog-ID &#8222;[_1]&#8220;',
	'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => '[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) hinzugefügt.',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => '[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) bearbeitet.',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Entry &#8222;[_1]&#8220; ([lc,_5] #[_2]) von &#8222;[_3]&#8220; (#[_4]) über Atom-API gelöscht.',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Zur Bestimmung von Höhe und Breite hochgeladener Bilddateien ist das Perl-Modul Image::Size erforderlich.',

## lib/MT/Auth/MT.pm
	'Failed to verify current password.' => 'Derzeitiges Passwort konnte nicht bestätigt werden.',

## lib/MT/Auth/OpenID.pm
	'Couldn\'t save the session' => 'Session konnte nicht gespeichert werden',
	'Could not load Net::OpenID::Consumer.' => 'Konnte Net::OpenID::Consumer nicht laden.',
	'The address entered does not appear to be an OpenID' => 'Die eingegebene Adresse scheint keine OpenID zu sein',
	'The text entered does not appear to be a web address' => 'Der eingegebene Text scheint keine Webadresse zu sein',
	'Unable to connect to [_1]: [_2]' => 'Es konnte keine Verbindung zu [_1] hergestellt werden: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'Die angegebene OpenID konnte nicht verifiziert werden: [_1]',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'Freigabe konnte nicht übernommen werden: [_1]',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Fehlerhafte AuthenticationModule-Konfiguration &#8222;[_1]&#8220;: [_2]',
	'Bad AuthenticationModule config' => 'Fehlerhafte AuthenticationModule-Konfiguration',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'Die Anmeldung erfordert eine sichere Signatur.',
	'The sign-in validation failed.' => 'Bei der Bestätigung der Anmeldung ist ein Fehler aufgetreten.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Auf diesem Blog müssen Kommentarautoren eine E-Mail-Adresse angeben. Wenn Sie das tun möchten, melden Sie sich an und erlauben Sie dem Authentifizierungsdienst, Ihre E-Mail-Adresse weiterzuleiten.',
	'Couldn\'t get public key from url provided' => 'Public Key konnte von der angegebenen Adresse nicht gelesen werden',
	'No public key could be found to validate registration.' => 'Kein Public Key zur Validierung gefunden.',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'Die Überprüfung der TypePad-Signatur ergab binnen [_2] Sekunden [_1], [_3] wurde mit [_4] verifiziert.',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'Die TypePad-Signatur ist zu alt ([_1] Sekunden). Bitte stellen Sie sicher, daß die Uhr Ihres Servers richtig gestellt ist',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Die hochgeladene Datei ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Die hochgeladene Sicherungsdatei stammt aus einer Movable Type-Installation mit anderer Schema-Version ([_1]) wie diese Installation ([_2]). Wir raten daher ausdrücklich davor ab, die Datei in diese Movable Type-Version einzuspielen.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] wird von Movable Type nicht wiederhergestellt.',
	'[_1] records restored.' => '[_1] Einträge wiederhergestellt.',
	'Restoring [_1] records:' => 'Stelle [_1]-Einträge wieder her:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Benutzer mit dem Namen des derzeit angemeldeten Benutzers ([_1]) gefunden. Eintrag übersprungen.',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Benutzer mit gleichem Namen &#8222;[_1]&#8220; gefunden (ID:[_2]).  Die Benutzerdaten wurden entsprechend ersetzt.',
	'Tag \'[_1]\' exists in the system.' => 'Tag &#8222;[_1]&#8220; bereits im System vorhanden.',
	'[_1] records restored...' => '[_1] Einträge wiederhergstellt...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Die Rolle &#8222;[_1]&#8220; wurde in &#8222;[_2]&#8220; umbenannt, da bereits eine Rolle mit diesem Namen vorhanden ist.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Sichere [_1]-Einträge:',
	'[_1] records backed up...' => '[_1] Einträge gesichert...',
	'[_1] records backed up.' => '[_1] Einträge gesichert',
	'There were no [_1] records to be backed up.' => 'Keine [_1]-Einträge zu sichern.',
	'Can\'t open directory \'[_1]\': [_2]' => 'Kann Verzeichnis &#8222;[_1]&#8220; nicht öffnen: [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Keine Manifest-Datei im Importverzeichnis [_1] gefunden.',
	'Can\'t open [_1].' => 'Kann [_1] nicht öffnen.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-Datei [_1] ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Manifest file: [_1]' => 'Manifest-Datei: [_1]',
	'Path was not found for the file ([_1]).' => 'Pfad zu Datei ([_1]) nicht gefunden.',
	'[_1] is not writable.' => 'Kein Schreibzugriff auf [_1]',
	'Error making path \'[_1]\': [_2]' => 'Fehler beim Anlegen des Ordners &#8222;[_1]&#8220;: [_2]',
	'Copying [_1] to [_2]...' => 'Kopiere [_1] nach [_2]...',
	'Failed: ' => 'Fehler: ',
	'Done.' => 'Fertig.',
	'Restoring asset associations ... ( [_1] )' => 'Stelle Asset-Zuweisungen wieder her... ( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'Stelle Asset-Zuweisungen in Eintrag wieder her... ( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'Stelle Asset-Zuweisungen in Seite wieder her ... ( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'Stelle Asset-URLs wieder her... ( [_1] )',
	'Restoring url of the assets in entry ( [_1] )...' => 'Stelle Asset-URLs in Eintrag wieder her... ( [_1] )',
	'Restoring url of the assets in page ( [_1] )...' => 'Stelle Asset-URLs in Seite wieder her ... ( [_1] )',
	'ID for the file was not set.' => 'ID für Datei nicht gesetzt.',
	'The file ([_1]) was not restored.' => 'Datei ([_1]) nicht wiederhergestellt.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Datei &#8222;[_1]&#8220; (ID:[_2])....',
	'failed' => 'Fehlgeschlagen',
	'ok' => 'OK',

## lib/MT/BasicAuthor.pm
	'authors' => 'Autoren',

## lib/MT/Blog.pm
	'First Blog' => 'Erstes Blog',
	'No default templates were found.' => 'Keine Standardvorlagen gefunden.',
	'Clone of [_1]' => 'Klon von [_1]',
	'Cloned blog... new id is [_1].' => 'Blog geklont... Die neue ID lautet: [_1]',
	'Cloning permissions for blog:' => 'Klone Berechtigungen für Webblog:',
	'[_1] records processed...' => '[_1] Einträge bearbeitet...',
	'[_1] records processed.' => '[_1] Einträge bearbeitet.',
	'Cloning associations for blog:' => 'Klone Verknüpfungen für Weblog:',
	'Cloning entries and pages for blog...' => 'Klone Einträge und Seiten für Weblog...',
	'Cloning categories for blog...' => 'Klone Kategorien für Weblog...',
	'Cloning entry placements for blog...' => 'Klone Eintragsplatzierung für Weblog...',
	'Cloning comments for blog...' => 'Klone Kommentare für Weblog...',
	'Cloning entry tags for blog...' => 'Klone Tags für Weblog...',
	'Cloning TrackBacks for blog...' => 'Klone TrackBacks für Weblog...',
	'Cloning TrackBack pings for blog...' => 'Klone TrackBack-Pings für Weblog...',
	'Cloning templates for blog...' => 'Klone Vorlagen für Weblog...',
	'Cloning template maps for blog...' => 'Klone Vorlagenzuweisungen für Weblog...',
	'blog' => 'Blog',
	'blogs' => 'Blogs',
	'Failed to load theme [_1]: [_2]' => 'Laden des Themas [_1] fehlgeschlagen: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Anwendung des Themas [_1] fehlgeschlagen: [_2]',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> in Zeile [_2] unbekannt.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> ohne </[_1]> in Zeile #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> ohne </[_1]> in Zeile [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> ohne  </[_1]> in Zeile[_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Fehler im Vorlagenbefehl <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Unbekannter Vorlagenbefehl gefunden: [_1]',

## lib/MT/Category.pm
	'Category' => 'Kategorie',
	'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
	'Category loop detected' => 'Kategorieschleife festgestellt',
	'string(100) not null' => 'string(100) nicht null',

## lib/MT/CMS/AddressBook.pm
	'No entry ID provided' => 'Keine Eintrags-ID angegeben',
	'No such entry \'[_1]\'' => 'Kein Eintrag &#8222;[_1]&#8220;',
	'No email address for user \'[_1]\'' => 'Keine E-Mail-Addresse für Benutzer &#8222;[_1]&#8220;',
	'No valid recipients found for the entry notification.' => 'Keine gültigen Empfänger für Benachrichtigungen gefunden.',
	'[_1] Update: [_2]' => '[_1] Update: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen([_1]). Überprüfen Sie die MailTransfer-Einstellungen.',
	'Please select a blog.' => 'Bitte wählen Sie ein Blog.',
	'The value you entered was not a valid email address' => 'Die angebene E-Mail-Adresse ist ungültig',
	'The value you entered was not a valid URL' => 'Die angegebene Webadresse (URL) ist ungültig',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Die angegebene E-Mail-Adresse befindet sich bereits auf der Benachrichtigungsliste für dieses Weblog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonnent &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_3]&#8220; aus Adressbuch gelöscht',

## lib/MT/CMS/Asset.pm
	'Files' => 'Dateien',
	'Extension changed from [_1] to [_2]' => 'Erweiterung von [_1] in [_2] geändert',
	'Upload File' => 'Datei hochladen',
	'Can\'t load file #[_1].' => 'Kann Datei #[_1] nicht laden.',
	'No permissions' => 'Keine Berechtigung',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Datei &#8222;[_1]&#8220; hochgeladen von &#8222;[_2]&#8220;',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Datei &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'All Assets' => 'Alle Assets',
	'Untitled' => 'Ohne Name',
	'Saving [_1] failed: [_2]' => '[_1] konnte nicht gespeichert werden: [_2]',
	'Archive Root' => 'Archiv-Wurzel',
	'Site Root' => 'Wurzelverzeichnis',
	'Please select a file to upload.' => 'Bitte wählen die Datei aus, die Sie hochladen möchten.',
	'Invalid filename \'[_1]\'' => 'Ungültiger Dateiname &#8222;[_1]&#8220;',
	'Please select an audio file to upload.' => 'Bitte wählen die Audio-Datei aus, die Sie hochladen möchten.',
	'Please select an image to upload.' => 'Bitte wählen die Bild-Datei aus, die Sie hochladen möchten.',
	'Please select a video to upload.' => 'Bitte wählen die Video-Datei aus, die Sie hochladen möchten.',
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type konnte den Zielpfad nicht beschreiben. Bitte stellen Sie sicher, daß der Webserver Schreibrechte für dieses Verzeichnis besitzt.',
	'Invalid extra path \'[_1]\'' => 'Ungültiger Zusatzpfad &#8222;[_1]&#8220;',
	'Can\'t make path \'[_1]\': [_2]' => 'Kann Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]',
	'Invalid temp file name \'[_1]\'' => 'Ungültiger temporärer Dateiname &#8222;[_1]&#8220;',
	'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von &#8222;[_1]&#8220;: [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von &#8222;[_1]&#8220;: [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Es ist bereits eine Datei namens &#8222;[_1]&#8220; vorhanden. (Installieren Sie File::Temp, um bereits vorhandene  Dateien überschreiben zu können .)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Fehler beim Anlegen der temporären Datei. Bitte überprüfen Sie, ob das in der Konfigurationsdatei eingestellte TempDir (derzeit &#8222;[_1]&#8220;) beschreibbar ist.',
	'unassigned' => 'nicht vergeben',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Es ist bereits eine Datei namens &#8222;[_1]&#8220; vorhanden. Die deshalb angelegte temporäre Datei konnte nicht geöffnet werden: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Konnte Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Die hochgeladene Datei konnte nicht in &#8222;[_1]&#8220; gespeichert werden: [_2]',
	'Uploaded file is not an image.' => 'Die hochgeladene Datei ist keine Bilddatei.',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'Keine IP-Adresse angegeben.',
	'The IP you entered is already banned for this blog.' => 'Diese IP-Adresse ist für dieses Weblog bereits gesperrt.',

## lib/MT/CMS/Blog.pm
	'Cloning blog \'[_1]\'...' => 'Klone Blog &#8222;[_1]&#8220;...',
	'Error' => 'Fehler',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a>.' => 'Fertig! <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Zurück zur Blog-Übersicht</a>.',
	'General Settings' => 'Allgemeine Einstellungen',
	'Plugin Settings' => 'Plugin-Einstellungen',
	'New Blog' => 'Neues Blog',
	'[_1] Activity Feed' => '[_1]-Aktivitäts-Feed',
	'Can\'t load template #[_1].' => 'Kann Vorlage #[_1] nicht laden.',
	'index template \'[_1]\'' => 'Indexvorlage &#8222;[_1]&#8220;',
	'[_1] \'[_2]\'' => '[_1] &#8222;[_2]&#8220;',
	'Publish Site' => 'Site veröffentlichen',
	'Invalid blog' => 'Ungültiges Blog',
	'Select Blog' => 'Blog wählen',
	'Selected Blog' => 'Gewähltes Blog',
	'Type a blog name to filter the choices below.' => 'Geben Sie einen Blognamen ein, um die Auswahl einzuschränken.',
	'Blog Name' => 'Name des Blogs',
	'[_1] changed from [_2] to [_3]' => '[_1] von [_2] in [_3] geändert',
	'Saved [_1] Changes' => '[_1]-Änderungen gespeichert',
	'Saving permissions failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) angelegt von &#8222;[_4]&#8220;',
	'You did not specify a blog name.' => 'Kein Blog-Name angegeben.',
	'Site URL must be an absolute URL.' => 'Site-URL muß eine absolute URL sein.',
	'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
	'You did not specify an Archive Root.' => 'Kein Archiv-Wurzelverzeichnis angebeben.',
	'The number of revisions to store must be a positive integer.' => 'Die Anzahl der zu speichernden Revisionen muss positiv sein.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Weblog &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'Saving blog failed: [_1]' => 'Das Weblog konnte nicht gespeichert werden: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache-Ordner schreiben. Bitte überprüfen Sie die Rechte für den Ordner <code>[_1]</code> in Ihrem Weblog-Verzeichnis.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type konnte kein Verzeichnis zur Zwischenspeicherung Ihrer dynamischen Vorlagen anlegen. Legen Sie daher manuell einen Ordner namens <code>[_1]</code> in Ihrem Weblog-Verzeichnis an.',
	'No blog was selected to clone.' => 'Kein zu klonendes Blog ausgewählt.',
	'This action can only be run on a single blog at a time.' => 'Dieser Vorgang kann nur für jeweils ein Blog gleichzeitig ausgeführt werden.',
	'Invalid blog_id' => 'Ungültige blog_id',
	'This action cannot clone website.' => 'Mit dieser Aktion können keine Websites geklont werden.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Um Kommentare und TrackBacks zu klonen, müssen auch die Eintrage geklont werden.',
	'Entries must be cloned if comments are cloned' => 'Um Kommentare zu klonen, müssen auch die Einträge geklont werden.',
	'Entries must be cloned if trackbacks are cloned' => 'Um TrackBacks zu klonen, müssen auch die Einträge geklont werden.',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'Unterordner',
	'Subcategory' => 'Unterkategorie',
	'The [_1] must be given a name!' => '[_1] muss einen Namen erhalten!',
	'Add a [_1]' => '[_1] hinzufügen',
	'No label' => 'Keine Bezeichnung',
	'Category name cannot be blank.' => 'Kategorienamen dürfen nicht leer sein.',
	'Permission denied: [_1]' => 'Zugriff verweigert: [_1]',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien gleichen Ursprungs müssen eindeutige Namen haben.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Der Kategorie-Basisname &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien gleichen Ursprungs müssen eindeutige Basisnamen haben.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Kategorie &#8222;[_1]&#8220; angelegt von &#8222;[_2]&#8220;',
	'The name \'[_1]\' is too long!' => 'Der Name &#8222;[_1]&#8220; ist zu lang!',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Kategorie &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Kommentar bearbeiten',
	'(untitled)' => '(ohne Überschrift)',
	'Orphaned comment' => 'Verwaister Kommentar',
	'Comments Activity Feed' => 'Kommentar-Aktivitäts-Feed',
	'*User deleted*' => 'Benutzer gelöscht',
	'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen ausgesprochen',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; gesperrt',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat die Sperrung von Kommentarautor &#8222;[_2]&#8220; aufgehoben',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen entzogen',
	'Permission denied' => 'Zugriff verweigert',
	'Parent comment id was not specified.' => 'ID des Elternkommentars nicht angegeben.',
	'Parent comment was not found.' => 'Elternkommentar nicht gefunden.',
	'You can\'t reply to unapproved comment.' => 'Sie können nicht auf nicht freigeschaltete Kommentare antworten.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Kommentar (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht',
	'You don\'t have permission to approve this trackback.' => 'Sie haben keine Berechtigung zur Freischaltung dieses TrackBacks.',
	'Comment on missing entry!' => 'Kommentar gehört zu fehlendem Eintrag',
	'You don\'t have permission to approve this comment.' => 'Sie haben keine Berechtigung zur Freischaltung dieses Kommentars.',
	'You can\'t reply to unpublished comment.' => 'Sie können nicht auf nicht veröffentlichte Kommentare antworten.',

## lib/MT/CMS/Common.pm
	'Permisison denied.' => 'Zugriff verweigert.',
	'The Template Name and Output File fields are required.' => 'Die Felder Vorlagennamen und Ausgabedatei sind erforderlich.',
	'Invalid type [_1]' => 'Ungültiger Typ [_1]',
	'Invalid ID [_1]' => 'Ungültige ID [_1]',
	'Save failed: [_1]' => 'Beim Speichern ist ein Fehler aufgetreten: [_1]',
	'Saving object failed: [_1]' => 'Das Objekt konnte nicht gespeichert werden: [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '&#8222;[_1]&#8220; hat die Vorlage &#8222;[_2]&#8220; des Blogs &#8222;[_3]&#8220; bearbeitet',
	'\'[_1]\' edited the global template \'[_2]\'' => '&#8222;[_1]&#8220; hat die globale Vorlage &#8222;[_2]&#8220; bearbeitet',
	'Invalid parameter' => 'Ungültiges Parameter',
	'Load failed: [_1]' => 'Beim Laden ist ein Fehler augetreten: [_1]',
	'(no reason given)' => '(unbekannte Ursache)',
	'(user deleted)' => '(Benutzer gelöscht)',
	'No Name' => 'Kein Name',
	'Notification List' => 'Benachrichtigungsliste',
	'Removing tag failed: [_1]' => 'Das Tag konnte nicht entfernt werden: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAP konnte nicht geladen werden: [_1]',
	'Removing [_1] failed: [_2]' => '[_1] konnte nicht entfernt werden: [_2]',
	'System templates can not be deleted.' => 'Systemvorlagen können nicht gelöscht werden',
	'Can\'t load [_1] #[_1].' => 'Kann [_1] #[_1] nicht laden.',
	'Saving snapshot failed: [_1]' => 'Speichern des Snapshots fehlgeschlagen: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog doesn\'t have a parent website.' => 'Fehler: Dieses Blog gehört zu keiner übergeordneten Website',
	'Design with Themes' => 'Mit  Themen gestalten',
	'Create and apply a theme to change templates, categories, folders and custom fields.' => 'Erstellen und nutzen Sie Themen, um Vorlagen, Kategorien, Ordner und eigene Felder zusammenhängend zu ändern.', # Translate - New #OK
	'Website Management' => 'Komplexe Websites betreiben',
	'Manage multiple blogs for each website. Now, it\'s much easier to create a portal with MultiBlog.' => 'Der Betrieb von Portalen wurde enorm vereinfacht: statt zahlreicher Einzelblogs können Sie jetzt auch direkt Websites mit mehreren zugehörigen Blogs erstellen.',
	'Revision History' => 'Revisionshistorie',
	'The revision history for entries and templates protects users from unexpected modification.' => 'Movable Type merkt sich jetzt vorherige Versionen von Einträgen und Vorlagen. So sind Sie vor unliebsamen Überraschungen geschützt.',
	'Movable Type Online Manual' => 'Movable Type Online-Handbuch',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Für Neueinsteiger wie für erfahrende Movable Type-Anwender: Erfahren Sie, was Movable Type für Sie leisten kann!',

## lib/MT/CMS/Entry.pm
	'New Entry' => 'Neuer Eintrag',
	'New Page' => 'Neue Seite',
	'pages' => 'Seiten',
	'Tag' => 'Tag',
	'Entry Status' => 'Eintragsstatus',
	'[_1] Feed' => '[_1]-Feed',
	'Can\'t load template.' => 'Kann Vorlage nicht laden.',
	'Publish error: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Kann Vorschaudatei in [_1] nicht erzeugen.',
	'New [_1]' => 'Neuer [_1]',
	'No such [_1].' => 'Kein [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Dieser Basisname wird bereits verwendet. Bitte verwenden Sie einen eindeutigen Basisnamen.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Site Path und URL dieses Weblogs wurden noch nicht konfiguriert. Sie können keine Einträge veröffentlichen, solange das nicht geschehen ist.',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum &#8222;[_1]&#8220; ungültig; erforderliches Formst ist JJJJ-MM-TT SS:MM:SS.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ungültiges Datum &#8222;[_1]&#8220;; das Datum muss existieren.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) hinzugefügt von Benutzer &#8222;[_4]&#8220;',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet und Status geändert von [_4] in [_5] von Benutzer &#8222;[_6]&#8220;',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet von Benutzer &#8222;[_4]&#8220;',
	'Saving placement failed: [_1]' => 'Beim Speichern der Platzierung ist ein Fehler aufgetreten: [_1]',
	'Saving entry \'[_1]\' failed: [_2]' => 'Der Eintrag &#8222;[_1]&#8220; konnte nicht gespeichert werden: [_2]',
	'Removing placement failed: [_1]' => 'Die Platzierung konnte nicht entfernt werden: [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Ping &#8222;[_1]&#8220; fehlgeschlagen: [_2]',
	'(user deleted - ID:[_1])' => '(Benutzer gelöscht - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost für [_2]</a> - Ziehen Sie diesen Link in die Lesezeichenleiste Ihres Browsers und klicken Sie darauf, wenn Sie sich auf einer Website befinden, über die Sie bloggen möchten.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Eintrag &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'Need a status to update entries' => 'Statusangabe erforderlich',
	'Need entries to update status' => 'Einträge erforderlich',
	'One of the entries ([_1]) did not actually exist' => 'Einer der Einträge ([_1]) existiert nicht',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => 'Status von [_1] &#8222;[_2]&#8220; (ID:[_3]) von [_4] in [_5] geändert.',

## lib/MT/CMS/Export.pm
	'Load of blog \'[_1]\' failed: [_2]' => 'Das Weblog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',
	'You do not have export permissions' => 'Sie haben keine Berechtigung für die Exportfunktion',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Der Ordner &#8222;[_1]&#8220; steht in Konflikt mit einem anderen Ordner. Ordner im gleichen Unterordner müssen unterschiedliche Basisnamen haben.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Ordner &#8222;[_1]&#8220; angelegt von &#8222;[_2]&#8220;',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Ordner &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Import/Export',
	'You do not have import permission' => 'Sie haben keine Berechtigung für die Importfunktion',
	'You do not have permission to create users' => 'Sie haben keine Berechtigung, neue Benutzerkonten anzulegen.',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Sollen für die Benutzer Ihres Blogs neue Benutzerkonten angelegt werden, müssen Sie ein Passwort angeben.',
	'Importer type [_1] was not found.' => 'Import-Typ [_1] nicht gefunden.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Jedes Feedback',
	'Publishing' => 'Veröffentliche',
	'System Activity Feed' => 'Systemaktivitäts-Feed',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Aktivitätsprotokoll von &#8222;[_1]&#8220; (ID:[_2]) on &#8222;[_3]&#8220; zurückgesetzt',
	'Activity log reset by \'[_1]\'' => 'Aktivitätsprotokoll zurückgesetzt von &#8222;[_1]&#8220;',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Plugin-Gruppe: [_1]',
	'Individual Plugins' => 'Individuelle Plugins',

## lib/MT/CMS/RptLog.pm
	'RPT Log' => 'RPT-Log',
	'System RPT Feed' => 'RPT-Systemfeed',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Keine den Kriterien entsprechenden [_1] gefunden.',
	'Entry Body' => 'Eintragstext',
	'Extended Entry' => 'Erweiterter Eintrag',
	'Keywords' => 'Schlüsselwörter',
	'Basename' => 'Basisname',
	'Comment Text' => 'Kommentartext',
	'IP Address' => 'IP-Adresse',
	'Source URL' => 'Quell-URL',
	'Page Body' => 'Seitenkörper',
	'Extended Page' => 'Erweiterte Seite',
	'Template Name' => 'Vorlagenname',
	'Text' => 'Text',
	'Linked Filename' => 'Verlinkter Dateiname',
	'Output Filename' => 'Ausgabe-Dateiname',
	'Filename' => 'Dateiname',
	'Label' => 'Bezeichnung',
	'Log Message' => 'Eintrag',
	'Site URL' => 'Site-URL',
	'Search & Replace' => 'Suchen & Ersetzen',
	'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe',
	'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
	'Saving object failed: [_2]' => 'Das Objekt konnte nicht gespeichert werden: [_2]',

## lib/MT/CMS/Tag.pm
	'Invalid type' => 'Ungültiger Typ',
	'New name of the tag must be specified.' => 'Neuer Tagname erforderlich',
	'No such tag' => 'Kein solcher Tag',
	'Error saving entry: [_1]' => 'Fehler beim Speichern des Eintrags: [_1]',
	'Error saving file: [_1]' => 'Fehler beim Speichern der Datei: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',

## lib/MT/CMS/Template.pm
	'index' => 'Index',
	'archive' => 'Archiv',
	'module' => 'Modul',
	'widget' => 'Widget',
	'email' => 'E-Mail',
	'backup' => 'Sichern',
	'system' => 'System',
	'One or more errors were found in this template.' => 'Die Vorlage enthält einen oder mehrere Fehler.',
	'One or more errors were found in included template module ([_1]).' => 'Das verwendete Vorlagenmodul [_1] enthält einen oder mehrere Fehler.',
	'Create template requires type' => 'Zum Anlegen einer Vorlage muss der gewünschter Typ angegeben werden.',
	'Archive' => 'Archiv',
	'Entry or Page' => 'Eintrag oder Seite',
	'New Template' => 'Neuer Vorlage',
	'Index Templates' => 'Index-Vorlagen',
	'Archive Templates' => 'Archiv-Vorlagen',
	'Template Modules' => 'Vorlagenmodule',
	'System Templates' => 'System-Vorlagen',
	'Email Templates' => 'E-Mail-Vorlagen',
	'Template Backups' => 'Vorlagen-Sicherungen',
	'Can\'t locate host template to preview module/widget.' => 'Kann Host-Vorlage zur Vorschau auf Modul/Widget nicht finden.',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LOREM_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'Beispiel, Eintrag, Vorschau',
	'Populating blog with default templates failed: [_1]' => 'Standardvorlagen konnten nicht geladen werden: [_1]',
	'Setting up mappings failed: [_1]' => 'Die Verknüpfungen konnte nicht angelegt werden: [_1]',
	'Saving map failed: [_1]' => 'Die Verknüpfungen konnte nicht gespeichert werden: [_1]',
	'You should not be able to enter 0 as the time.' => '0 sollte nicht als Zeit eingegeben werden können.',
	'You must select at least one event checkbox.' => 'Markieren Sie bitte mindestens ein Ereignis-Auswahlfeld.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Vorlage &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Vorlage &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'Orphaned' => 'Verwaist',
	'Global Templates' => 'Globale Vorlagen',
	' (Backup from [_1])' => '(Sicherung von [_1])',
	'Error creating new template: ' => 'Fehler beim Anlegen der neuen Vorlage',
	'Template Referesh' => 'Vorlagen zurücksetzen',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Überspringe Vorlage &#8222;[_1]&#8220;, da sie keine Standardvorlage zu sein scheint.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Setze Vorlage <strong>[_3]</strong>zurück und erstelle dabei eine <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">Sicherung</a>.',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Überspringe Vorlage &#8222;[_1]&#8220;, da sie unverändert ist.',
	'Copy of [_1]' => 'Kopie von [_1]',
	'Cannot publish a global template.' => 'Kann eine globale Vorlage nicht veröffentlichen.',
	'Widget Template' => 'Widgetvorlage',
	'Widget Templates' => 'Widgetvorlagen',
	'template' => 'Vorlage',
	'Restoring widget set [_1]... ' => 'Stelle Widgetgruppe [_1] wieder her...',
	'Failed.' => 'Fehlgeschlagen.',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Thema nicht gefunden',
	'Failed to uninstall theme' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten',
	'Failed to uninstall theme: [_1]' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten: [_1]',
	'Theme from [_1]' => 'Thema von [_1]',
	'Install into themes directory' => 'In Themenverzeichnis installieren',
	'Download [_1] archive' => '[_1]-Archiv herunterladen',
	'Failed to save theme export info: [_1]' => 'Beim Speichern der Export-Informationen ist ein Fehler aufgetreten: [_1]',
	'Themes Directory [_1] is not writable.' => 'Das Themen-Verzeichis  [_1] kann nicht beschrieben werden.',
	'Error occurred during exporting [_1]: [_2]' => 'Beim Export von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Beim Abschluss von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Bei der Veröffentlichung des Themas ist ein Fehler aufgetreten: [_1]',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Passwort anfordern',
	'User not found' => 'Benutzer nicht gefunden',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Beim Mailversand ist ein Fehler aufgetreten ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, Ihr  Passwort anzufordern.',
	'Password reset token not found' => 'Passwort Reset Token nicht gefunden',
	'Email address not found' => 'E-Mail-Adresse nicht gefunden',
	'Your request to change your password has expired.' => 'Ihre Anfrage auf Änderung Ihres Passworts ist abgelaufen.',
	'Invalid password reset request' => 'Ungültige Anfrage zur Zurücksetzung des Passworts',
	'Please confirm your new password' => 'Bitte bestätigen Sie Ihr neues Passwort',
	'Passwords do not match' => 'Passwörter stimmen nicht überein.',
	'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) offenbar nicht implementiert!',
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Bitte richten Sie zuerst eine System-E-Mail-Adresse ein und versuchen Sie dann erneut, die Testmail zu verschicken.',
	'Please enter a valid email address' => 'Bitte geben Sie eine gültige E-Mail-Adresse ein.',
	'Test email from Movable Type' => 'Testmail von Movable Type',
	'This is the test email sent by your installation of Movable Type.' => 'Diese Testmail wurde von Ihrer Movable Type-Installation verschickt.',
	'Mail was not properly sent' => 'Die E-Mail konnte nicht gesendet werden.',
	'Test e-mail was successfully sent to [_1]' => 'Testmail erfolgreich an [_1] versandt',
	'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Eine Angabe in der Movable Type-Konfigurationsdatei hat Vorrang vor diesen Einstellungen: [_1]. Entfernen Sie das Parameter aus der Konfigurationsdatei, um die entsprechenden Einstellungen hier vornehmen zu können.',
	'Email address is [_1]' => 'Die E-Mail-Adresse lautet [_1]',
	'Debug mode is [_1]' => 'Debugging ist [_1]',
	'Performance logging is on' => 'Performance-Logging aktiviert',
	'Performance logging is off' => 'Performance-Logging deaktiviert',
	'Performance log path is [_1]' => 'Pfad der Performance-Logs: [_1]',
	'Performance log threshold is [_1]' => 'Schwellenwert für Performance-Logging: [_1]',
	'System Settings Changes Took Place' => 'Es wurden Änderungen an den Systemeinstellungen vorgenommen.',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Ungültiger Versuch zur  Passwortanforderung. Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid author_id' => 'Ungültige Autoren-ID',
	'Backup & Restore' => 'Sichern & Wiederherstellen',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Sicherung beschreibbar sein. Bitte überprüfen Sie Ihre TempDir-Einstellung.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Wiederherstellung beschreibbar sein. Bitte überprüfen Sie Ihre TempDir-Einstellung.',
	'No website could be found. You must create a website first.' => 'Keine Website gefunden. Bitte legen Sie zuerst eine Website an.',
	'[_1] is not a number.' => '[_1] ist keine Zahl.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Die Datei [_1] konnte nicht nach [_2] kopiert werden: [_3]',
	'Specified file was not found.' => 'Angegebene Datei nicht gefunden.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] hat Sicherungsdatei erfolgreich heruntergeladen ([_2])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'Einige Assetdateien konnten nicht wiederhergestellt werden.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Bitte verwenden Sie xml, tar.gz, zip, oder manifest als Dateierweiterung.',
	'Unknown file format' => 'Unbekanntes Dateiformat',
	'Some objects were not restored because their parent objects were not restored.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Details finden Sie im <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Aktivitätsprotokoll</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] hat die Wiederherstellung mehrerer Dateien vorzeitig abgebrochen.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Ändere Sitepfad für Weblog&#8222;[_1]&#8220; (ID:[_2])...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Entferne Sitepfad für Weblog &#8222;[_1]&#8220; (ID:[_2])...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Ändere Archivpfad für Weblog &#8222;[_1]&#8220; (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Entferne Archivpfadfür Weblog &#8222;[_1]&#8220; (ID:[_2])...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Asset &#8222;[_1]&#8220; (ID:[_2])...',
	'Please upload [_1] in this page.' => 'Bitte laden Sie [_1] in diese Seite hoch.',
	'File was not uploaded.' => 'Datei wurde nicht hochgeladen.',
	'Restoring a file failed: ' => 'Eine Datei wurde nicht wiederhergestellt: ',
	'Some of the files were not restored correctly.' => 'Einige Daten wurden nicht korrekt wiederhergestellt.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Objekte erfolgreich wiederhergestellt durch Benutzer &#8222;[_1]&#8220;',
	'Can\'t recover password in this configuration' => 'Passwörter können in dieser Konfiguration nicht angefordert werden',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Ungültiger Benutzername &#8222;[_1]&#8220; zur Passwortanforderung verwendet',
	'User name or password hint is incorrect.' => 'Benutzername oder Antwort auf Erinnerungsfrage falsch.',
	'User has not set pasword hint; cannot recover password' => 'Benutzer hat Erinnerungsfrage nicht gesetzt; Passwort kann deshalb nicht angefordert werden',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Ungültiger Versuch einer Passwortanforderung (verwendeter Erinnerungssatz: &#8222;[_1]&#8220;',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'Benutzer &#8222;[_1]&#8220; (#[_2]) hat keine E-Mail-Adresse',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Link zum Zurücksetzen des Passworts für Benutzer &#8222;[_1]&#8220; (#[_2]) an [_3] geschickt.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht widerhergestellt wurden. Details finden Sie im <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Aktivitätsprotokoll</a>.',
	'[_1] is not a directory.' => '[_1] ist kein Ordner.',
	'Error occured during restore process.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten.',
	'Some of files could not be restored.' => 'Einige Dateien konnten nicht wiederhergestellt werden.',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'Die Manifest-Datei &#8222;[_1]&#8220;  ist zu groß. Laden Sie die Datei zur Wiederherstellung daher stattdessen in das Import-Verzeichnis hoch.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Weblog(s) (ID:[_1]) erfolgreich gesichert von Benutzer &#8222;[_2]&#8220;',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type-System erfolgreich gesichert von Benutzer &#8222;[_1]&#8220;',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Einige [_1] wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',

## lib/MT/CMS/TrackBack.pm
	'Junk TrackBacks' => 'TrackBacks als Spam behandeln',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => 'TrackBacks, mit <strong>[_1]</strong> &quot;[_2]&quot;',
	'TrackBack Activity Feed' => 'TrackBack-Aktivitätsfeed',
	'(Unlabeled category)' => '(Namenlose Kategorie)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Kategorie &#8222;[_4]&#8220; gelöscht',
	'(Untitled entry)' => '(Namenloser Eintrag)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht',
	'No Excerpt' => 'Kein Auszug',
	'No Title' => 'Keine Überschrift',
	'Orphaned TrackBack' => 'Verwaistes TrackBack',
	'category' => 'Kategorien',

## lib/MT/CMS/User.pm
	'Create User' => 'Benutzerkonto anlegen',
	'Can\'t load role #[_1].' => 'Kann Rolle #[_1] nicht laden.',
	'Create Role' => 'Rolle anlegen',
	'(newly created user)' => '(neu angelegter Benutzer)',
	'User Associations' => 'Benutzerverknüpfungen',
	'Role Users & Groups' => 'Rollen-Benutzer und -Gruppen',
	'(Custom)' => '(Individuell)',
	'The user' => 'Der Benutzer',
	'Role name cannot be blank.' => 'Rollenname erforderlich.',
	'Another role already exists by that name.' => 'Es ist bereits eine Rolle mit diesem Namen vorhanden.',
	'You cannot define a role without permissions.' => 'Es können keine Rollen ohne Berechtigungen definiert werden.',
	'Invalid ID given for personal blog theme.' => 'Ungültige ID für Thema der persönlichen Blogs',
	'Invalid ID given for personal blog clone location ID.' => 'Ungültige ID für Klonvorlage der persönlichen  Blogs',
	'If personal blog is set, the personal blog location are required.' => 'Zur Erzeugung persönlicher Blogs muss ein Speicherort angegeben werden.',
	'Select a entry author' => 'Eintragsautor wählen',
	'Select a page author' => 'Seitenautor wählen',
	'Selected author' => 'Gewählter Autor',
	'Type a username to filter the choices below.' => 'Geben Sie einen Benutzernamen ein, um die Auswahl einzuschränken',
	'Entry author' => 'Eintragsautor',
	'Page author' => 'Seitenautor',
	'Select a System Administrator' => 'Systemadministrator wählen',
	'Selected System Administrator' => 'Gewählter Systemadministrator',
	'System Administrator' => 'Systemadministrator',
	'represents a user who will be created afterwards' => 'steht für ein Benutzerkonto, das später angelegt werden wird',
	'Select Website' => 'Website wählen',
	'Website Name' => 'Name der Website',
	'Websites Selected' => 'Gewählte Websites',
	'Search Websites' => 'Websites suchen',
	'Select Blogs' => 'Weblogs wählen',
	'Blogs Selected' => 'Gewählte Weblogs',
	'Search Blogs' => 'Blogs suchen',
	'Select Users' => 'Gewählte Benutzer',
	'Users Selected' => 'Gewählte Benutzer',
	'Search Users' => 'Benutzer suchen',
	'Select Roles' => 'Rollen awählen',
	'Role Name' => 'Rollenname',
	'Roles Selected' => 'Gewählte Rollen',
	'' => ' ',
	'Grant Permissions' => 'Berechtigungen zuweisen',
	'You cannot delete your own association.' => 'Sie können nicht Ihre eigene Verknüpfung löschen.',
	'You cannot delete your own user record.' => 'Sie können nicht Ihr eigenes Benutzerkonto löschen.',
	'You have no permission to delete the user [_1].' => 'Keine Berechtigung zum Löschen von Benutzer [_1].',
	'User requires username' => 'Benutzername erforderlich',
	'User requires display name' => 'Anzeigename erforderlich',
	'User requires password' => 'Passwort erforderlich',
	'Email Address is required for password recovery' => 'Für Passwort-Anforderungen ist eine E-Mail-Adresse erforderlich',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',

## lib/MT/CMS/Website.pm
	'New Website' => 'Neue Website',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Website &#8222;[_1]&#8220; (ID: [_2]) gelöscht von &#8222;[_3]&#8220;',
	'Selected Website' => 'Gewählte Website',
	'Type a website name to filter the choices below.' => 'Geben Sie einen Namen ein, um die Auswahl einzuschränken.',
	'Can\'t load website #[_1].' => 'Kann Website #[_1] nicht laden.',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_5]&#8220; von &#8222;[_3]&#8220; nach &#8222;[_4]&#8220; verschoben',

## lib/MT/Comment.pm
	'Comment' => 'Kommentar',
	'Load of entry \'[_1]\' failed: [_2]' => 'Der Eintrag &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'verwendet [_1], sollte [_2] verwenden',
	'uses [_1]' => 'verwendet [_1]',
	'No executable code' => 'Kein ausführbarer Code',
	'Publish-option name must not contain special characters' => 'Der Optionsname darf keine Sonderzeichen enthalten.',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias für [_1] bildet eine Schleife.',
	'Error opening file \'[_1]\': [_2]' => 'Fehler beim Öffnen der Datei &#8222;[_1]&#8220;: [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Konfigurationsanweisung [_1] ohne Wert [_2] in Zeile [_3]',
	'No such config variable \'[_1]\'' => 'Konfigurationsvariable &#8222;[_1]&#8220; nicht vorhanden',

## lib/MT/Config.pm
	'Configuration' => 'Konfiguration',

## lib/MT/Core.pm
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Beim Anlegen des Leistungsprotrokolls-Verzeichnis ist ein Fehler aufgetreten: [_1]. Bitte vergeben Sie entweder Schreibrechte für das  gewählte Verzeichnis oder geben Sie über das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; ein anderes an: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; muss auf ein Verzeichnis, nicht auf eine Datei zeigen',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: das PerformanceLoggingPath-Verzeichnis ist vorhanden, kann aber nicht beschrieben werden: [_1]',
	'MySQL Database (Recommended)' => 'MySQL-Datenbank (empfohlen)',
	'PostgreSQL Database' => 'PostgreSQL-Datenbank',
	'SQLite Database' => 'SQLite-Datenbank',
	'SQLite Database (v2)' => 'SQLite-Datenbank (v2)',
	'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
	'Rich Text' => 'Grafischer Editor',
	'Movable Type Default' => 'Movable Type-Standard',
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Klassisches Blog',
	'Publishes content.' => 'Veröffentlicht Inhalte.',
	'Synchronizes content to other server(s).' => 'Synchronisiert Inhalte mit anderen Servern.',
	'Refreshes object summaries.' => 'Setzt Object Summaries zurück',
	'Adds Summarize workers to queue.' => 'Fügt Summarize Workers zur Warteschlange hinzu',
	'zip' => 'ZIP',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Eintragsliste',
	'Blog URL' => 'Blog-URL',
	'Blog ID' => 'Blog-ID',
	'Entry Excerpt' => 'Eintragsauszug',
	'Entry Link' => 'Eintragslink',
	'Entry Extended Text' => 'Erweiterter Text',
	'Entry Title' => 'Eintragstitel',
	'If Block' => 'If-Block',
	'If/Else Block' => 'If-Else-Block',
	'Include Template Module' => 'Include-Vorlagenmodul',
	'Include Template File' => 'Include-Vorlagendatei',
	'Get Variable' => 'Variable lesen',
	'Set Variable' => 'Variable setzen',
	'Set Variable Block' => 'Variablenblock setzen',
	'Widget Set' => 'Widgetgruppe',
	'Publish Scheduled Entries' => 'Zeitgeplante Einträge veröffentlichen',
	'Add Summary Watcher to queue' => 'Summary Watchers zur Warteschlange hinzufügen',
	'Junk Folder Expiration' => 'Junk-Ordner-Einstellungen',
	'Remove Temporary Files' => 'Temporäre Dateien löschen',
	'Purge Stale Session Records' => 'Abgelaufene Sessiondaten löschen ',
	'Manage Website' => 'Website verwalten',
	'Manage Blog' => 'Blog verwalten',
	'Manage Website with Blogs' => 'Website mit Blogs verwalten',
	'Post Comments' => 'Kommentare schreiben',
	'Create Entries' => 'Neuer Eintrag',
	'Edit All Entries' => 'Alle Einträge bearbeiten',
	'Manage Assets' => 'Assets verwalten',
	'Manage Categories' => 'Kategorien verwalten',
	'Change Settings' => 'Einstellungen ändern',
	'Manage Address Book' => 'Adressbuch verwalten',
	'Manage Tags' => 'Tags verwalten',
	'Manage Templates' => 'Vorlagen verwalten',
	'Manage Feedback' => 'Feedback verwalten',
	'Manage Pages' => 'Seiten verwalten',
	'Manage Users' => 'Benutzer verwalten',
	'Manage Themes' => 'Themen verwalten',
	'Publish Entries' => 'Einträge veröffentlichen',
	'Save Image Defaults' => 'Bild-Voreinstellungen speichern',
	'Send Notifications' => 'Benachrichtigungen versenden',
	'Set Publishing Paths' => 'Veröffentlichungspfade setzen',
	'View Activity Log' => 'Aktivitätsprotokoll ansehen',
	'Create Blogs' => 'Blogs anlegen',
	'Create Websites' => 'Website anlegen',
	'Manage Plugins' => 'Plugins verwalten',
	'View System Activity Log' => 'Systemaktivitätsprotokoll einsehen',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Archivindex',
	'Stylesheet' => 'Stylesheet',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Feed - Aktuelle Einträge',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Einträge nach Monat',
	'Category Entry Listing' => 'Einträge nach Kategorie',
	'Comment Listing' => 'Liste der Kommentare',
	'Improved listing of comments.' => 'Verbesserte Kommentarverwaltung',
	'Comment Response' => 'Kommentar-Antworten',
	'Displays error, pending or confirmation message for comments.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Kommentaren an',
	'Comment Preview' => 'Kommentarvorschau',
	'Displays preview of comment.' => 'Zeigt eine Vorschau des Kommentars an',
	'Dynamic Error' => 'Dynamischer Fehler',
	'Displays errors for dynamically published templates.' => 'Zeigt Fehlermeldungen für dynamisch veröffentlichte Vorlagen an',
	'Popup Image' => 'Popup-Bild',
	'Displays image when user clicks a popup-linked image.' => 'Zeigt Bilder als Pop-Ups an, wenn auf ein Vorschaubild geklickt wird ',
	'Displays results of a search.' => 'Zeigt Suchergebnisse an',
	'About This Page' => 'Über diese Seite',
	'Archive Widgets Group' => 'Archiv-Widgetgruppe',
	'Current Author Monthly Archives' => 'Monatsarchive des aktuellen Autors',
	'Calendar' => 'Kalendar',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Startseiten-Widgetgruppe',
	'Monthly Archives Dropdown' => 'Monatsarchive (Dropdown)',
	'Page Listing' => 'Seitenübersicht',
	'Powered By' => 'Powered by',
	'Syndication' => 'Syndizierung',
	'Technorati Search' => 'Technorati-Suche',
	'Date-Based Author Archives' => 'Datumsbasierte Autorenarchive',
	'Date-Based Category Archives' => 'Datumsbasierte Kategoriearchive',
	'OpenID Accepted' => 'OpenID unterstützt',
	'Comment throttle' => 'Kommentarbegrenzung',
	'Commenter Confirm' => 'Kommentarautorenbestätigung',
	'Commenter Notify' => 'Kommentarautorenbenachrichtigung',
	'New Comment' => 'Neuer Kommentar',
	'New Ping' => 'Neuer Ping',
	'Entry Notify' => 'Eintragsbenachrichtigung',
	'Subscribe Verify' => 'Abonnementbestätigung',

## lib/MT/Entry.pm
	'record does not exist.' => 'Eintrag nicht vorhanden.',
	'Draft' => 'Entwurf',
	'Review' => 'Zur Überprüfung',
	'Future' => 'Künftig',
	'Spam' => 'Spam',
	'Status' => 'Status',
	'Accept Comments' => 'Kommentare annehmen',
	'Body' => 'Text',
	'Extended' => 'Erweiterter Text',
	'Format' => 'Format',
	'Accept Trackbacks' => 'TrackBacks annehmen',
	'Publish Date' => 'Zeitpunkt der Veröffentlichung',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV-Verbindung fehlgeschlagen: [_1]',
	'DAV open failed: [_1]' => 'DAV-&#8222;open&#8220; fehlgeschlagen: [_1]',
	'DAV get failed: [_1]' => 'DAV-&#8222;get&#8220; fehlgeschlagen: [_1]',
	'DAV put failed: [_1]' => 'DAV-&#8222;put&#8220; fehlgeschlagen: [_1]',
	'Deleting \'[_1]\' failed: [_2]' => '&#8222;[_1]&#8220; konnte nicht gelöscht werden: [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'Das Verzeichnis &#8222;[_1]&#8220; konnte nicht angelegt werden: [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => '&#8222;[_1]&#8220; konnte nicht in &#8220;[_2]&#8220; umbenannt werden: [_3]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP-Verbindung fehlgeschlagen: [_1]',
	'SFTP get failed: [_1]' => 'SFTP-&#8222;get&#8220; fehlgeschlagen: [_1]',
	'SFTP put failed: [_1]' => 'SFTP-&#8222;put&#8220; fehlgeschlagen: [_1]',

## lib/MT/Folder.pm
	'Folder' => 'Ordner',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Maximale Dateigröße überschritten: [_1] > [_2]',
	'Can\'t load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Datei &#8222;[_1]&#8220; kann nicht gelesen werden: [_2]',
	'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Bei der Skalierung auf [_1]x[_2] ist ein Fehler aufgetreten: [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Beim Erstellen des quadratischen Ausschnitts von [_1]x[_2] Pixeln Größe ab [_2],[_3] ist ein Fehler aufgetreten: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Bei der Konvertierung des Fotos in [_1] ist ein Fehler aufgetreten: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
	'Unsupported image file type: [_1]' => 'Nicht unterstütztes Bildformat: [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Beim Beschneiden auf [_1]x[_1] Pixel ist ein Fehler aufgetreten: [_2]',
	'Converting to [_1] failed: [_2]' => 'Bei der Konvertierung in [_1] ist ein Fehler aufgetreten: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad zu den NetPBM-Tools gefunden.',
	'Can\'t load GD: [_1]' => 'GD kann nicht geladen werden: [_1]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Kein Blog',
	'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
	'Creating new user (\'[_1]\')...' => 'Lege neuen Benutzer &#8222;[_1]&#8220; an...',
	'Saving user failed: [_1]' => 'Das Benutzerkonto konnte nicht gespeichert werden: [_1]',
	'Assigning permissions for new user...' => 'Weise neuem Benutzer Berechigungen zu...',
	'Saving permission failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'Creating new category (\'[_1]\')...' => 'Lege neue Kategorie &#8222;[_1]&#8220; an...',
	'Saving category failed: [_1]' => 'Die Kategorie konnte nicht gespeichert werden: [_1]',
	'Invalid status value \'[_1]\'' => 'Ungültiger Status-Wert &#8222;[_1]&#8220;',
	'Invalid allow pings value \'[_1]\'' => 'Ungültiger Ping-Status &#8222;[_1]&#8220;',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Kann vorhandenen Eintrag mit Zeitstempel &#8222;[_1]&#8220;  nicht finden; überspringe Kommentare und fahre mit nächstem Eintrag fort...',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importiere in vorhandenen Eintrag [_1] (\&#8222;[_2]&#8220;)',
	'Saving entry (\'[_1]\')...' => 'Speichere Eintrag &#8222;[_1]&#8220;...',
	'ok (ID [_1])' => 'OK (ID [_1])',
	'Saving entry failed: [_1]' => 'Der Eintrag konnte nicht gespeichert werden: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar (von &#8222;[_1]&#8220;) an...',
	'Saving comment failed: [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
	'Creating new ping (\'[_1]\')...' => 'Erzeuge neuen Ping &#8222;[_1]&#8220;)...',
	'Saving ping failed: [_1]' => 'Der Ping konnte nicht gespeichert werden: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Exportvorgang bei Eintrag &#8222;[_1]&#8220; fehlgeschlagen: [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ungültiges Datumsformat &#8222;[_1]&#8220;;  muss &#8222;MM/TT/JJJJ HH:MM:SS AM|PM&#8220; sein (AM|PM optional)',

## lib/MT/Import.pm
	'Can\'t rewind' => 'Kann nicht zurückspulen',
	'Can\'t open \'[_1]\': [_2]' => 'Kann &#8222;[_1]&#8220; nicht öffnen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Keine lesbaren Dateien im Import-Verzeichnis [_1] gefunden.',
	'Importing entries from file \'[_1]\'' => 'Importiere Einträge aus Datei &#8222;[_1]&#8220;',
	'Couldn\'t resolve import format [_1]' => 'Kann Importformat [_1] nicht auflösen',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Anderes System (Movable Type-Format)',

## lib/MT/IPBanList.pm
	'IP Ban' => 'IP-Sperre',
	'IP Bans' => 'IP-Sperren',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Aktion: Als Junk eingestuft (Bewertung unterschreitet Schwellenwert)',
	'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
	'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] abgebrochen: [_2]',
	'Unnamed Junk Filter' => 'Namenloser Junk Filter',
	'Composite score: [_1]' => 'Gesamtbewertung: [_1]',

## lib/MT/Log.pm
	'Log message' => 'Protokolleintrag',
	'Log messages' => 'Protokolleinträge',
	'Page # [_1] not found.' => 'Seite #[_1] nicht gefunden.',
	'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
	'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Unbekannte MailTransfer-Methode &#8222;[_1]&#8220;',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Für das Versenden von E-Mail mittels SMTP ist Mail::Sendmail erforderlich: [_1]',
	'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Kein gültiger Sendmail-Pfad gefunden. Versuchen Sie stattdessen SMTP zu verwenden.',
	'Exec of sendmail failed: [_1]' => 'Sendmail konnte nicht ausgeführt werden: [_1]',

## lib/MT/Notification.pm
	'Contact' => 'Kontakt',
	'Contacts' => 'Kontakte',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Asset-Platzierung',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'Objektbewertung',
	'Object Scores' => 'Objektbewertungen',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Tag-Platzierung',
	'Tag Placements' => 'Tag-Platzierungen',

## lib/MT/Page.pm
	'Load of blog failed: [_1]' => 'Das Weblog konnte nicht geladen werden: [_1]',

## lib/MT/Permission.pm
	'Permission' => 'Berechtigung',

## lib/MT/Placement.pm
	'Category Placement' => 'Kategorie-Platzierung',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugin-Daten',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] aus Regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] aus Test [_4]',

## lib/MT/Plugin.pm
	'Publish' => 'Veröffentlichen',
	'My Text Format' => 'Mein Textformat',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	'Hello, world' => 'Hallo Welt',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Message: [_1]' => 'Nachricht: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Falls vorhanden, muss das drite Argument von add_callback ein MT::Component-Objekt oder ein MT::Plugin sein',
	'4th argument to add_callback must be a CODE reference.' => 'Viertes Argument von add_callback muss eine CODE-Referenz sein.',
	'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins',
	'Invalid priority level [_1] at add_callback' => 'Ungültiger Prioritätslevel [_1] von add_callback',
	'Unnamed plugin' => 'Plugin ohne Namen',
	'[_1] died with: [_2]' => '[_1] abgebrochen mit [_2]',
	'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen',
	'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Keine Konfigurationsdatei gefunden. Haben Sie möglicheweise vergessen, mt-config.cgi-original in mt-config.cgi umzubennen?',
	'Plugin error: [_1] [_2]' => 'Plugin-Fehler: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden.',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'WordPress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! Japan',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Movable Type-Standard',

## lib/MT/Revisable/Local.pm

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Fehlerhaftes RevisioningDriver-Parameter &#8222;[_1]&#8220;: [_2]',
	'Revision not found: [_1]' => 'Revision nicht gefunden: [_1]',
	'There aren\'t the same types of objects, expecting two [_1]' => 'Objektarten stimmen nicht überein, erwarte zwei [_1]',
	'Did not get two [_1]' => 'Nicht zwei [_1] erhalten',
	'Unknown method [_1]' => 'Unbekannte Methode [_1]',
	'Revision Number' => 'Revisionsnummer',

## lib/MT/Role.pm
	'Role' => 'Rolle',
	'Website Administrator' => 'Website-Administrator',
	'Can administer the website.' => 'Kann die Website verwalten',
	'Blog Administrator' => 'Blog-Administrator',
	'Can administer the blog.' => 'Kann das Blog verwalten',
	'Editor' => 'Editor',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kann Dateien hochladen, alle Einträge, Seiten, Kategorien, Ordner und Tags bearbeiten und die Site veröffentlichen.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und Dateien hochladen und veröffentlichen.',
	'Designer' => 'Designer',
	'Can edit, manage, and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Contributor' => 'Gastautor',
	'Can create entries, edit their own entries, and comment.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und kommentieren.',
	'Moderator' => 'Moderator',
	'Can comment and manage feedback.' => 'Kann kommentieren und Feedback verwalten',
	'Can comment.' => 'Kann kommentieren',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Objekt muss zuerst gespeichert werden.',
	'Already scored for this object.' => 'Bewertung für dieses Objekt bereits abgegeben.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Konnte Bewertung für Objekt &#8222;[_1]&#8220; (ID: [_2]) nicht speichern.',

## lib/MT/Session.pm
	'Session' => 'Sitzung',

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'Tags müssen gültige Namen haben',
	'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Konnte Lock für Systemtask nicht setzen. Stellen Sie sicher, daß Schreibrechte für das temporäre Verzeichnis [_1] vorhanden sind.',
	'Error during task \'[_1]\': [_2]' => 'Fehler bei Ausführung des Tasks &#8222;[_1]&#8220;: [_2]',
	'Scheduled Tasks Update' => 'Aktualisierung geplanter Aufgaben',
	'The following tasks were run:' => 'Folgende Tasks wurden ausgeführt:',

## lib/MT/TBPing.pm
	'TrackBack' => 'TrackBack',

## lib/MT/Template/ContextHandlers.pm
	'Warning' => 'Warnung',
	'All About Me' => 'Alles über mich',
	'Remove this widget' => 'Dieses Widget entfernen',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Veröffentlichen[_2] Sie Ihre Site, um die Änderungen wirksam werden zu lassen.',
	'Actions' => 'Aktionen',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Vorlagenbefehl ohne Datumskontext verwendet.',
	'Division by zero.' => 'Teilung durch Null.',
	'[_1] is not a hash.' => '[_1] ist kein Hash-Wert.',
	'No [_1] could be found.' => 'Keine [_1] gefunden.',
	'records' => 'Einträge',
	'No template to include specified' => 'Keine einzubindende Vorlage angegeben',
	'Recursion attempt on [_1]: [_2]' => 'Rekursionsversuch bei [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Kann verwendete Vorlage [_1] &#8222;[_1]&#8220; nicht finden',
	'Writing to \'[_1]\' failed: [_2]' => '&#8222;[_1]&#8220; konnte nicht beschrieben werden: [_2]',
	'Can\'t find blog for id \'[_1]' => 'Kann Blog zu ID &#8222;[_1]&#8220; nicht finden',
	'Can\'t find included file \'[_1]\'' => 'Kann verwendete Datei &#8222;[_1]&#8220; nicht finden',
	'Error opening included file \'[_1]\': [_2]' => 'Fehler beim Öffnen der verwendeten Datei &#8222;[_1]&#8220;: [_2]',
	'Recursion attempt on file: [_1]' => 'Rekursionsversuch bei Datei [_1]',
	'Can\'t load user.' => 'Kann Benutzerkonto nicht laden.',
	'Can\'t find template \'[_1]\'' => 'Kann Vorlage &#8222;[_1]&#8220; nicht finden',
	'Can\'t find entry \'[_1]\'' => 'Kann Eintrag &#8222;[_1]&#8220; nicht finden',
	'Unspecified archive template' => 'Nicht spezifizierte Archivvorlage',
	'Error in file template: [_1]' => 'Fehler in Dateivorlage: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => '&#8222;[_1]&#8220; ist kein gültiger Wert für ein exclude_blogs-Attribut',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Sie haben einen &#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Autoren-Kontexts verwendet - &#8222;MTAuthors&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Eintrags-Kontexts verwendet - &#8222;MTEntries&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of the website; perhaps you mistakenly placed it outside of an \'MTWebsites\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Website-Kontexts verwendet - &#8222;MTWebsite&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of the blog; perhaps you mistakenly placed it outside of an \'MTBlogs\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Blog-Kontexts verwendet - &#8222;MTBlogs&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Kommentar-Kontexts verwendet - &#8222;MTComments&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Ping-Kontextes verwendet - &#8222;MTPings&#8220;-Container erforderlich.',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Asset-Kontexts verwendet - &#8222;MTAssets&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Seiten-Kontexts verwendet - &#8222;MTPages&#8220;-Containers erforderlich',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Archiv-Verknüpfung',
	'Archive Mappings' => 'Archiv-Verknüpfungen',

## lib/MT/Template.pm
	'Template' => 'Vorlage',
	'File not found: [_1]' => 'Datei nicht gefunden: [_1]',
	'Error reading file \'[_1]\': [_2]' => 'Fehler beim Einlesen der Datei &#8222;[_1]&#8220;: [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Veröffentlichungsfehler in Vorlage &#8222;[_1]&#8220;: [_2]',
	'Template with the same name already exists in this blog.' => 'Es existiert bereits eine Vorlage mit diesem Namen in diesem Blog.',
	'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Die verlinkte Datei &#8222;[_1]&#8220; konnte nicht geöffnet werden: [_2]',
	'Index' => 'Index',
	'Category Archive' => 'Kategoriearchiv',
	'Ping Listing' => 'Liste der Pings',
	'Comment Error' => 'Kommentarfehler',
	'Comment Pending' => 'Kommentar wartet',
	'Uploaded Image' => 'Hochgeladendes Bild',
	'Module' => 'Modul',
	'Widget' => 'Widget',
	'Output File' => 'Ausgabedatei',
	'Template Text' => 'Vorlagentext',
	'Rebuild with Indexes' => 'Einschließlich Indizes neu aufbauen',
	'Dynamicity' => 'Dynamik-Art',
	'Build Type' => 'Aufbau-Art',
	'Interval' => 'Intervall',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Gruppeniterator fehlgeschlagen.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit Tages-, Wochen- oder Monatsarchiven verwendet werden.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Sie haben mit einem [_1]-Vorlagenbefehl &#8222;[_2]&#8220;-Archive verlinkt, ohne diese vorher zu veröffentlichen.',
	'You used an [_1] tag outside of the proper context.' => 'Sie haben einen [_1]-Vorlagenbefehl außerhalb seines Kontexts verwendet.',
	'Could not determine entry' => 'Konnte Eintrag nicht bestimmen',

## lib/MT/Template/Tags/Asset.pm
	'No such user \'[_1]\'' => 'Kein Benutzer &#8222;[_1]&#8220;',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Fehler im &#8222;[_2]&#8220;-Attribut: [_1]',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'Das Attribut &#8222;[_2]&#8220; erfordert einen Integer: [_1]',
	'You used an [_1] without a author context set up.' => '[_1] ohne vorhandenen Autorenkontext verwendet.',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: JJJJMM erforderlich',
	'No such category \'[_1]\'' => 'Keine Kategorie &#8222;[_1]&#8220;',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] muss in einem [_2]-Kontext stehen',
	'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fehler beim Sortieren von [_2]: [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] kann nur zusammen mit Kategoriearchiven verwendet werden.',
	'[_1] used outside of [_2]' => '[_1] außerhalb [_2] verwendet',

## lib/MT/Template/Tags/Commenter.pm

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'Der MTCommentFields-Befehl ist nicht mehr verfügbar. Bitte verwenden Sie stattdessen das [_1]-Vorlagenmodul.',
	'Comment Form' => 'Kommentarformular',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Um Kommentarregistrierung zu aktivieren, geben Sie in Ihrer Weblog-Konfiguration oder Ihrem Benutzer-Profil ein TypePad-Token ein.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',
	'Could not create atom id for entry [_1]' => 'Konnte keine Atom-ID für Eintrag [_1] erzeugen',

## lib/MT/Template/Tags/Folder.pm

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'Name erforderlich',
	'Specified WidgetSet \'[_1]\' not found.' => 'Angegebene Widgetgruppe &#8222;[_1]&#8220; nicht gefunden.',
	'' => ' ',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem &#8222;category&#8220;-Attribut des Tags verwendet werden.',

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => '[_1] Haupt- und [_2] Unterkategorien',
	'[_1] top level and [_2] sub folders.' => '[_1] Haupt- und [_2] Unterordner',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Komponente &#8222;[_1]&#8220; nicht gefunden.',
	'Internal error: the importer is not found.' => 'Interner Fehler: Importmodul nicht gefunden.',
	'Compatibility error occured while applying \'[_1]\': [_2].' => 'Bei der Anwendung von &#8222;[_1]&#8220; ist ein Kompatibilitätsfehler aufgetreten: [_2]',
	'An Error occured while applying \'[_1]\': [_2].' => 'Bei der Anwendung von &#8222;[_1]&#8220; ist ein Fehler aufgetreten: [_2]',
	'Fatal error occured while applying \'[_1]\': [_2].' => 'Bei der Anwendung von &#8222;[_1]&#8220; ist ein kritischer Fehler aufgetreten: [_2]',
	'Importer for \'[_1]\' is too old.' => 'Das Importmodul für &#8222;[_1]&#8220; ist zu alt.',
	'Theme element \'[_1]\' is too old for this environment.' => 'Das Element &#8222;[_1]&#8220; des verwendeten Themas ist veraltet und kann hier  nicht eingesetzt werden.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] Seiten',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Laden des Themas fehlgeschlagen: [_1]',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein kritischer Fehler aufgetreten: [_2]',
	'An error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein Fehler aufgetreten: [_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, aber nicht installiert. ',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, installiert ist aber Version [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'Element &#8222;[_1]&#8220;  konnte nicht angewendet werden da [_2]',
	'There was an error scaling image [_1].' => 'Bei der Skalierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	'There was an error converting image [_1].' => 'Bei der Konvertierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	'There was an error creating thumbnail file [_1].' => 'Bei der Erstellung des Vorschaubilds [_1] ist ein Fehler aufgetreten.',
	'Default Prefs' => 'Standard-Voreinstellungen',
	'Template Set' => 'Vorlagengruppe',
	'Static Files' => 'Statische Dateien',
	'Default Pages' => 'Standard-Seiten',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'Dieses Element kann nicht auf Nicht-Blog-Elemente angewendet werden.',
	'default settings for [_1]' => 'Standard-Einstellungen für [_1]',
	'default settings' => 'Standard-Einstellungen',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [_1] templates, [_2] widgets, and [_3] widget sets.' => 'Vorlagengruppe mit [_1] Vorlagen, [_2] Widgets und [_3] Widget-Gruppen.',
	'Widget Sets' => 'Widgetgruppen',
	'Failed to make templates directory: [_1]' => 'Fehler bei Erstellung des Vorlagen-Verzeichnisses: [_1]',
	'Failed to publish template file: [_1]' => 'Fehler bei Veröffentlichung der Vorlagen-Dateien: [_1]',
	'exported_template set' => 'exported_template-Gruppe',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Job-Fehler',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Job-Zielstatus',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Job-Funktion',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Job',

## lib/MT/Trackback.pm

## lib/MT/Upgrade/Core.pm
	'Upgrading Asset path informations...' => 'Aktualisiere Asset-Pfad-Informationen...',
	'Creating initial website and user records...' => 'Lege erste Website und Benutzereinträge an...',
	'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
	'Error creating role record: [_1].' => 'Fehler bei der Erstellung eine Rollen-Eintrags: [_1]. ',
	'First Website' => 'Erste Website',
	'Creating new template: \'[_1]\'.' => 'Erzeuge neue Vorlage: &#8222;[_1]&#8220;',
	'Mapping templates to blog archive types...' => 'Verknüpfe Vorlagen mit Archiven...',
	'Assigning custom dynamic template settings...' => 'Weise benutzerspezifische Einstellungen für dynamische Vorlagen zu...',
	'Assigning user types...' => 'Weise Benutzerkontenarten zu...',
	'Assigning category parent fields...' => 'Weise Elternkategorien zu...',
	'Assigning template build dynamic settings...' => 'Weise Einstellungen für dynamische Veröffentlichung zu...',
	'Assigning visible status for comments...' => 'Setzte Sichtbarkeitsstatus für Kommentare...',
	'Assigning visible status for TrackBacks...' => 'Setzte Sichtbarkeitsstatus für TrackBacks...',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Ungültige Upgrade-Funktion: [_1].',
	'Error loading class [_1].' => 'Fehler beim Laden der Klasse [_1].',
	'Upgrading table for [_1] records...' => 'Aktualisiere Tabelle für [_1]-Einträge...',
	'Upgrading database from version [_1].' => 'Aktualisiere Datenbank von Version [_1].',
	'Database has been upgraded to version [_1].' => 'Datenbank auf Movable Type-Version [_1] aktualisiert',
	'User \'[_1]\' upgraded database to version [_2]' => 'Benutzer &#8222;[_1]&#8220; hat Datenbank auf Version [_2] aktualisiert',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin &#8222;[_1]&#8220; erfolgreich auf Version [_2] (Schemaversion [_3]) aktualisiert',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Benutzer &#8222;[_1]&#8220; hat Plugin &#8222;[_2]&#8220; erfolgreich auf Version [_3] (Schemaversion [_4]) aktualisiert',
	'Plugin \'[_1]\' installed successfully.' => 'Plugin &#8222;[_1]&#8220; erfolgreich installiert',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Benutzer &#8222;[_1]&#8220; hat Plugin &#8222;[_2]&#8220; mit Version [_3] (Schemaversion [_4]) installiert',
	'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1]',
	'Assigning entry comment and TrackBack counts...' => 'Weise Kommentar- und TrackBack-Zahlen zu...',
	'Error saving [_1] record # [_3]: [_2]...' => 'Fehler beim Speichern von [_1]-Eintrag #[_3]: [_2]...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Verknüpfe Vorlagen...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Vorlage [_1] mit [_2] ([_3])',
	'Mapping template ID [_1] to [_2].' => 'Verknüpfe Vorlage [_1] mit [_2]',
	'Creating entry category placements...' => 'Lege Kategoriezuweisungen an...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Aktualisiere Kategorieanordnung...',
	'Assigning comment/moderation settings...' => 'Weise Kommentierungs-/Moderierungs-Einstellungen zu...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => 'Individuell ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Diese Rolle wurde von Movable Type während einer Aktualisierung angelegt.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Entferne Indexvorlage des Dynamic Site Bootstrappers...',
	'Creating configuration record.' => 'Erzeuge Konfigurationseintrag...',
	'Setting your permissions to administrator.' => 'Setze Ihre Administrationsrechte...',
	'Setting blog basename limits...' => 'Setze Basisnamen-Limits...',
	'Setting default blog file extension...' => 'Setze Standard-Dateierweitung...',
	'Updating comment status flags...' => 'Aktualisiere Kommentarstatus...',
	'Updating commenter records...' => 'Aktualisiere Kommentarautoren-Datensätze...',
	'Assigning blog administration permissions...' => 'Weise Administrationsrechte zu...',
	'Setting blog allow pings status...' => 'Weise Ping-Status zu...',
	'Updating blog comment email requirements...' => 'Aktualisiere E-Mail-Einstellungen der Kommentarfunktion...',
	'Assigning entry basenames for old entries...' => 'Weise Alteinträgen Basisnamen zu...',
	'Updating user web services passwords...' => 'Aktualisierte Passwörter für Webdienste...',
	'Updating blog old archive link status...' => 'Aktualisiere Linkstatus der Alteinträge...',
	'Updating entry week numbers...' => 'Aktualisiere Wochendaten...',
	'Updating user permissions for editing tags...' => 'Weise Nutzerrechte für Tag-Verwaltung zu...',
	'Setting new entry defaults for blogs...' => 'Setze Standardwerte für neue Einträge...',
	'Migrating any "tag" categories to new tags...' => 'Migriere "Tag"-Kategorien zu neuen Tags...',
	'Assigning basename for categories...' => 'Weise Kategorien Basisnamen zu...',
	'Assigning user status...' => 'Weise Benuzerstatus zu...',
	'Migrating permissions to roles...' => 'Migriere Berechtigung auf Rollen...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Kommentar veröffentlicht',
	'Your comment has been posted!' => 'Ihr Kommentar wurde veröffentlicht!',
	'Your comment submission failed for the following reasons:' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating permission records to new structure...' => 'Migriere Benutzerrechte in neue Struktur...',
	'Migrating role records to new structure...' => 'Migriere Rollen in neue Struktur...',
	'Migrating system level permissions to new structure...' => 'Migriere Systemberechtigungen in neue Struktur...',
	'Updating system search template records...' => 'Aktualisiere Suchvorlagen...',
	'Renaming PHP plugin file names...' => 'Ändere PHP-Plugin-Dateinamen...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fehler beim Umbenennen von PHP-Datei. Bitte überprüfen Sie das Aktivitätsprotokoll.',
	'Cannot rename in [_1]: [_2].' => 'Kann nicht in [_1] umbenennen: [_2]',
	'Migrating Nofollow plugin settings...' => 'Migriere Nofollow-Einstellungen...',
	'Removing unnecessary indexes...' => 'Entferne nicht verwendete Indizes...',
	'Moving metadata storage for categories...' => 'Verschiebe Metadatenspeicher für Kategorien...',
	'Upgrading metadata storage for [_1]' => 'Aktualisiere Metadatenspeicher für [_1]',
	'Updating password recover email template...' => 'Aktualisierung des Passwort-Wiederherstellungs-Templates...',
	'Assigning junk status for comments...' => 'Setze Junkstatus der Kommentare...',
	'Assigning junk status for TrackBacks...' => 'Setze Junkstatus der TrackBacks...',
	'Populating authored and published dates for entries...' => 'Übernehme Zeitstempel für Einträge...',
	'Updating widget template records...' => 'Aktualisiere Widgetvorlagen...',
	'Classifying category records...' => 'Klassifiziere Kategoriedaten...',
	'Classifying entry records...' => 'Klassifizere Eintragsdaten...',
	'Merging comment system templates...' => 'Führe Kommentierungsvorlagen zusammen...',
	'Populating default file template for templatemaps...' => 'Lege Standardvorlagen für Vorlagenzuweisungen fest...',
	'Removing unused template maps...' => 'Entferne nicht benötigte Vorlagenzuweisungen',
	'Assigning user authentication type...' => 'Weise Art der Benutzerauthentifizierung zu...',
	'Adding new feature widget to dashboard...' => 'Füge "Neue Features"-Widget zum Übersichtsseite hinzu...',
	'Moving OpenID usernames to external_id fields...' => 'Setze OpenID-Benutzernamen als external_id-Felder...',
	'Assigning blog template set...' => 'Weise Vorlagengruppe zu...',
	'Assigning blog page layout...' => 'Weise Blog-Seitenlayout zu...',
	'Assigning author basename...' => 'Weise Autoren-Basisnamen zu...',
	'Assigning embedded flag to asset placements...' => 'Weise Embedded-Flag an Asset-Platzierungen zu...',
	'Updating template build types...' => 'Aktualisiere Vorlagenaufbauarten...',
	'Replacing file formats to use CategoryLabel tag...' => 'Ersetze Dateiformate für CategoryLabel-Befehl...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Populiere generische Website für aktuelles Blog...',
	'Generic Website' => 'Generische Website',
	'Migrating [_1]([_2]).' => 'Migriere [_1] ([_2]).',
	'Granting new role to system administrator...' => 'Weise Systemadministrator neue Rolle zu...',
	'Updating existing role name...' => 'Aktualisiere vorhandene Rollennamen...',
	'_WEBMASTER_MT4' => 'Webmaster',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Populiere neue Rolle für Website...',
	'Can manage pages, Upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Designer (MT4)' => 'Designer (MT4)',
	'Populating new role for theme...' => 'Populiere neue Rolle für Thema...',
	'Can edit, manage and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Assigning new system privilege for system administrator...' => 'Weise neues System-Privileg an Systemadministrator zu...',
	'Assigning to  [_1]...' => 'Weise an [_1] zu...',
	'Migrating mtview.php to MT5 style...' => 'Migriere mtview.php zur MT5-Fassung...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migriere DefaultSiteURL/DefaultSiteRoot zur Website...',
	'New user\'s website' => 'Website neuer Benutzer',
	'Migrating existing [quant,_1,blog,blogs] into websites and its children...' => 'Migriere [quant,1,bestehendes Blog,bestehende Blogs] in Websites und Unterelemente...',
	'Error loading role: [_1].' => 'Fehler beim Laden einer Rolle: [_1]',
	'New WebSite [_1]' => 'Neue Website [_1]',
	'An error occured during generating a website upon upgrade: [_1]' => 'Beim Erzeugen einer Website im Rahmen der Aktualisierung ist ein Fehler aufgetreten: [_1]',
	'Generated a website [_1]' => 'Website [_1] erzeugt',
	'An error occured during migrating a blog\'s site_url: [_1]' => 'Beim Migrieren der Site URL eines Blogs ist ein Fehler aufgetreten:',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Blog [_1] ([_2]) in Website [_3] verschoben',
	'Merging dashboard settings...' => 'Migriere Übersichtsseiten-Einstellungen...',
	'Classifying blogs...' => 'Klassifiziere Blogs...',
	'Rebuilding permissions...' => 'Baue Berechtigungen neu auf...',

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Typangabe erforderlich',
	'Registry could not be loaded' => 'Konnte Registry nicht laden',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Typ muss .tgz sein.',
	'Could not read from filehandle.' => 'Dateihandle nicht lesbar.',
	'File [_1] is not a tgz file.' => '[_1] ist keine .tgz-Datei',
	'File [_1] exists; could not overwrite.' => '[_1] existiert bereits und konnte nicht überschrieben werden',
	'Can\'t extract from the object' => 'Kann aus Objekt nicht extrahieren',
	'Can\'t write to the object' => 'Kann Objekt nicht beschreiben',
	'Both data and file name must be specified.' => 'Sowohl der Daten- als auch der Dateiname müssen angegeben werden.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Typ muss .zip sein.',
	'File [_1] is not a zip file.' => '[_1] ist keine .zip-Datei',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Zur Nutzung der in Movable Type integrierten CAPTCHA-Quelle ist Image::Magick erforderlich.',
	'You need to configure CaptchaSourceImageBase.' => 'Bitte konfigurieren Sie CaptchaSourceImageBase',
	'Image creation failed.' => 'Bilderzeugung fehlgeschlagen.',
	'Image error: [_1]' => 'Bildfehler: [_1]',

## lib/MT/Util.pm
	'moments from now' => 'in einem Augenblick',
	'[quant,_1,hour,hours] from now' => 'in [quant,_1,Stunde,Stunden]',
	'[quant,_1,minute,minutes] from now' => 'in [quant,_1,Minute,Minuten]',
	'[quant,_1,day,days] from now' => 'in [quant,_1,Tag,Tagen]',
	'less than 1 minute from now' => 'in weniger als 1 Minute',
	'less than 1 minute ago' => 'vor weniger als 1 Minute',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'in [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'vor [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'in [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'vor [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
	'[quant,_1,second,seconds] from now' => 'in [quant,_1,Sekunde,Sekunden]',
	'[quant,_1,second,seconds]' => '[quant,_1,Sekunde,Sekunden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'in [quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
	'[quant,_1,minute,minutes]' => '[quant,_1,Minute,Minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,Stunde,Stunden] und [quant,_2,Minute,Minuten]',
	'[quant,_1,hour,hours]' => '[quant,_1,Stunde,Stunden]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,Tag,Tage] und [quant,_2,Stunde,Stunden]',
	'[quant,_1,day,days]' => '[quant,_1,Tag,Tage]',
	'Invalid domain: \'[_1]\'' => 'Ungültige Domain: &#8222;[_1]&#8220;',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archivtyp &#8222;[_1]&#8220; wurde  nicht ausgewählt',
	'Parameter \'[_1]\' is required' => 'Parameter &#8222;[_1]&#8220; erforderlich',
	'You did not set your blog publishing path' => 'Veröffentlichungspfade nicht gesetzt',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Diese Archivdatei existiert bereits. Ändern Sie entweder den Basisnamen oder den Archivpfad. ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Fehler bei der Veröffentlichung von  [_1] &#8222;[_2]&#8220;: [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Fehler bei Veröffentlichtung des Archivs &#8222;[_1]&#8220;: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Temporäre Datei &#8222;[_1]&#8220; konnte nicht umbenannt werden: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Blog-, BlogID- oder Template-Parameter erforderlich.',
	'Template \'[_1]\' does not have an Output File.' => 'Vorlage &#8222;[_1]&#8220; hat keine Ausgabedatei.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Fehler bei der Veröffentlichung zeitgeplanter Einträge: [_1]',

## lib/MT/Website.pm

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- Gruppe komplett ([quant,_1,Datei,Dateien] in [_2] Sekunden)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'Synchronisierung der Dateien abgeschlossen',
	'Done syncing files to [_1] ([_2])' => 'Die Dateien wurden mit [_1] ([_2]) synchronisiert',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Keine WeblogsPingURL in der Konfigurationsdatei definiert',
	'No MTPingURL defined in the configuration file' => 'Keine MTPingURL in der Konfigurationsdatei definiert',
	'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
	'Ping error: [_1]' => 'Ping-Fehler: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
	'No web services password assigned.  Please see your user profile to set it.' => 'Kein Passwort für Webdienste vergeben. Sie können das Passwort in Ihrem Benutzerprofil angegeben.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Der gewünschte Permalink &#8222;[_1]&#8220; ist für diese Seite nicht verfügbar.',
	'Saving folder failed: [_1]' => 'Speichern des Ordners fehlgeschlagen: [_1]',
	'No blog_id' => 'Blog_id fehlt',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '&#8222;mt_[_1]&#8220; kann nur 0 oder 1 sein (war &#8222;[_2]&#8220;)',
	'Not privileged to edit entry' => 'Keine Berechtigung, Einträge zu bearbeiten',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Eintrag &#8222;[_1]&#8220; ([_5] #[_2]) von &#8222;[_3]&#8220; (Benutzer-Nr. [_4]) per XML-RPC gelöscht',
	'Not privileged to get entry' => 'Keine Berechtigung, Einträge einzulesen',
	'Not privileged to set entry categories' => 'Keine Berechtigung, Kategorien zuzuweisen',
	'Not privileged to upload files' => 'Keine Berechtigung, Dateien hochzuladen',
	'No filename provided' => 'Kein Dateiname angegeben',
	'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Funktionen zum Zugriff auf Vorlagen sind auf Grund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',

## mt-static/jquery/jquery.mt.js

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Vorschau nicht verfügbar',
	'View uploaded file' => 'Hochgeladene Datei ansehen',

## mt-static/js/dialog.js
	'(None)' => '(Keine)',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titel:',
	'Description:' => 'Überschrift:',
	'Author:' => 'Autor:',
	'Tags:' => 'Tags:',
	'URL:' => 'URL:',

## mt-static/mt.js
	'delete' => 'löschen',
	'remove' => 'entfernen',
	'enable' => 'aktivieren',
	'disable' => 'deaktivieren',
	'You did not select any [_1] to [_2].' => 'Keine [_1] zu [_2] gewählt.',
	'Are you sure you want to [_2] this [_1]?' => '[_1] wirklich [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Die [_1] ausgewählten [_2] wirklich [_3]?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Rolle wirklich entfernen? Entfernen der Rolle entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '[_1] Rolle(n) wirklich entfernen? Entfernen der Rollen entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'You did not select any [_1] [_2].' => 'Sie haben keine [_1] [_2] gewählt',
	'You can only act upon a minimum of [_1] [_2].' => 'Nur möglich für mindestens [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Nur möglich für höchstens [_1] [_2].',
	'You must select an action.' => 'Bitte wählen Sie zunächst eine Aktion.',
	'to mark as spam' => 'zur Markierung als Spam',
	'to remove spam status' => 'zum Entfernen des Spam-Status',
	'Enter email address:' => 'E-Mail-Adresse eingeben:',
	'Enter URL:' => 'URL eingeben:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Das  Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich mit &#8222;[_2]&#8220; zusammengeführt werden?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich in allen Weblogs mit &#8222;[_2]&#8220; zusammengeführt werden?',
	'Loading...' => 'Lade...',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] von [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/commenter_confirm.mtml

## themes/classic_blog/templates/commenter_notify.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/comment_throttle.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/footer-email.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/new-comment.mtml

## themes/classic_blog/templates/new-ping.mtml

## themes/classic_blog/templates/notify-entry.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/recover-password.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/templates/verify-subscribe.mtml

## themes/classic_blog/theme.yaml
	'Typical and authentic blogging design comes with plenty of styles and the selection of 2 column / 3 column layout. Best for all the bloggers.' => 'Zur Gestaltung Ihres Blogs steht eine reichhaltige Auswahl typischer Designs und zwei- und dreispaltiger Layouts zur Verfügung. Ideal für alle Zwecke.',

## themes/classic_website/templates/about_this_page.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/commenter_confirm.mtml

## themes/classic_website/templates/commenter_notify.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/comment_throttle.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/footer-email.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/new-comment.mtml

## themes/classic_website/templates/new-ping.mtml

## themes/classic_website/templates/notify-entry.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/recover-password.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	'Subscribe to this website\'s feed' => 'Feed dieser Website abonnieren',

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/templates/verify-subscribe.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from blogs under the website.' => 'Erstellen Sie ein Blog-Portal, das die Inhalte verschiedener Blogs der Website zusammenfasst.',
	'Classic Website' => 'Klassische Website',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Navigation' => 'Navigation',
	'Related Content' => 'Verwandte Einträge',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/commenter_confirm.mtml

## themes/pico/templates/commenter_notify.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Kommentarvorschau',

## themes/pico/templates/comment_response.mtml

## themes/pico/templates/comments.mtml

## themes/pico/templates/comment_throttle.mtml

## themes/pico/templates/creative_commons.mtml

## themes/pico/templates/current_author_monthly_archive_list.mtml

## themes/pico/templates/current_category_monthly_archive_list.mtml

## themes/pico/templates/date_based_author_archives.mtml

## themes/pico/templates/date_based_category_archives.mtml

## themes/pico/templates/dynamic_error.mtml

## themes/pico/templates/entry.mtml
	'Home' => 'Startseite',

## themes/pico/templates/entry_summary.mtml

## themes/pico/templates/footer-email.mtml

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	'Subscribe' => 'Abonnieren',

## themes/pico/templates/new-comment.mtml

## themes/pico/templates/new-ping.mtml

## themes/pico/templates/notify-entry.mtml

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/recover-password.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/templates/verify-subscribe.mtml

## themes/pico/theme.yaml
	'Pico is the microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we\'ve moved the sidebars below the list of posts.' => 'Pico ist das Microblogging-Thema, das speziell auf häufige Aktualisierungen des Inhalts ausgelegt ist.  Zur Betonung des Inhalts befinden sich die Seitenleisten unterhalb der Einträge.',
	'Pico' => 'Pico',
	'Pico Styles' => 'Pico-Designs',
	'A collection of styles compatible with Pico themes.' => 'Mit Pro-Themen kompatible Designs',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Suche nach neuen Kommentaren:',
	'the beginning' => 'ingesamt',
	'one week back' => 'der letzten Woche',
	'two weeks back' => 'der letzten zwei Wochen',
	'one month back' => 'des letzten Monats',
	'two months back' => 'der letzten zwei Monate',
	'three months back' => 'der letzten drei Monate',
	'four months back' => 'der letzten vier Monate',
	'five months back' => 'der letzten fünf Monate',
	'six months back' => 'der letzten sechs Monate',
	'one year back' => 'des letzten Jahres',
	'Find new comments' => 'Neue Kommentare finden',
	'Posted in [_1] on [_2]' => 'Veröffentlicht in [_1] am [_2]',
	'No results found' => 'Keine Treffer',
	'No new comments were found in the specified interval.' => 'Keine neuen Kommentare in diesem Zeitraum gefunden.',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Wählen Sie den gewünschten Zeitraum und klicken Sie dann auf &#8222;Neue Kommentare finden&#8220;.',

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'SEARCH FEED AUTODISCOVERY-LINK WIRD NUR ANGEZEIGT, WENN EINE SUCHE AUSGEFÜHRT WURDE',
	'Blog Search Results' => 'Suchergebnisse',
	'Blog search' => 'Blogsuche',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'BEI DIREKTEN SUCHEN WIRD DAS SUCHFORMULAR ANGEZEIGT',
	'Search this site' => 'Diese Site durchsuchen',
	'Match case' => 'Groß-/Kleinschreibung beachten',
	'SEARCH RESULTS DISPLAY' => 'ANZEIGE DER SUCHERGEBNISSE',
	'Matching entries from [_1]' => 'Treffer in [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Mit &#8222;[_2]&#8220; getaggte Einträge aus [_1]',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Geschrieben <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'Showing the first [_1] results.' => 'Erste [_1] Treffer',
	'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
	'Entries matching \'[_1]\'' => 'Einträge mit &#8222;[_1]&#8220;',
	'Entries tagged with \'[_1]\'' => 'Mit &#8222;[_1]&#8220; getaggte Einträge',
	'No pages were found containing \'[_1]\'.' => 'Keine Seiten mit &#8222;[_1]&#8220; gefunden.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Die Suchfunktion sucht standardmäßig nach allen angebenen Begriffen in beliebiger Reihenfolge. Um nach einem exakten Ausdruck zu suchen, setzen Sie diesen bitte in Anführungszeichen.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt.',
	'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE VS TAG-Information',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren.',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit &#8222;[_1]&#8220; abonnieren.',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
	'Feed Subscription' => 'Feed abonnieren',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Was ist das?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
	'Other Tags' => 'Andere Tags',
	'END OF PAGE BODY' => 'PAGE BODY ENDE',
	'END OF CONTAINER' => 'CONTAINER ENDE',

## search_templates/results_feed_rss2.tmpl
	'Search Results for [_1]' => 'Suchergebnisse für [_1]',

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Neues Asset hochladen',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Asset hochladen',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => '[_1]-Backup',
	'What to Backup' => 'Umfang der Sicherung',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Hier können Sie eine Sicherungskopie Ihrer Blogs erstellen. Sicherungen umfassen Benutzerkonten, Rollen, Verknüpfungen, Blogs, Einträge, Kategoriedefinitionen, Vorlagen und Tags.',
	'Everything' => 'Mit allen Blogs',
	'Reset' => 'zurücksetzen',
	'Choose websites...' => 'Websites wählen...',
	'Archive Format' => 'Archivformat',
	'The type of archive format to use.' => 'Das zu verwendende Archivformat',
	'Don\'t compress' => 'Nicht komprimieren',
	'Target File Size' => 'Gewünschte Dateigröße ',
	'Approximate file size per backup file.' => 'Ungefähre Größe pro Backupdatei (MB)',
	'No size limit' => 'Unbegrenzt',
	'Make Backup (b)' => 'Sicherung erstellen (b)',
	'Make Backup' => 'Sicherung erstellen',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Editor-Einstellungen',
	'Your preferences have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'Publishing Defaults' => 'Veröffentlichungs-Voreinstellungen',
	'Listing Default' => 'Listen-Voreinstellung',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Geben Sie entweder die größte Anzahl Einträge an, die auf der Startseite angezeigt werden sollen, oder die höchste Anzahl Tage, aus denen dort Einträge erscheinen sollen.',
	'Days' => 'Tage',
	'Posts' => 'Einträge',
	'Order' => 'Reihenfolge',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Geben Sie an, ob Einträge in chronologischer (älteste zuerst) oder umgekehrt chronologischer Reihenfolge (neueste zuerst) angezeigt werden sollen.',
	'Ascending' => 'Aufsteigend',
	'Descending' => 'Absteigend',
	'Excerpt Length' => 'Länge des Auszugs',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Anzahl der Wörter im automatisch generierten Textauszug.',
	'Date Language' => 'Datumsanzeige',
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
	'Basename Length' => 'Länge des Basisnamens',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Setzt den Wert für den automatisch generierten Basisname des Eintrags. Mögliche Länge: 15 bis 250.',
	'Compose Defaults' => 'Editor-Voreinstellungen',
	'Specifies the default Post Status when creating a new entry.' => 'Gibt an, welcher Veröffentlichungs-Status beim Anlegen neuer Einträge voreingestellt sein soll.', # Translate - New #OK
	'Unpublished' => 'Nicht veröffentlicht',
	'Published' => 'Veröffentlicht',
	'Text Formatting' => 'Textformatierung',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen Kommentare standardmässig zugelassen werden.',
	'Setting Ignored' => 'Einstellung ignoriert',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellung zeigt momentan keine Wirkung, da Kommentare blog- oder systemweit deaktiviert sind.',
	'Accept TrackBacks' => 'TrackBacks annehmen',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen TrackBack standardmässig zugelassen werden.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellungen zeigen momentan keine Wirkung, da TrackBacks blog- oder systemweit deaktiviert sind.',
	'Entry Fields' => 'Eintragsfelder',
	'_USAGE_ENTRYPREFS' => 'Wählen Sie aus, welche Formularfelder in der Eingabemaske angezeigt werden sollen.',
	'Page Fields' => 'Seitenfelder',
	'Punctuation Replacement' => 'Ersetzung von Satzzeichen',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Mit dieser Option können von Textverarbeitungen erzeugte UTF-8-Sonderzeichen automatisch durch gebräuchlichere Äquivalente ersetzt werden.',
	'No substitution' => 'Keine Zeichen ersetzen',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entitäten (&amp#8221;, &amp#8220; usw.)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'ASCII-Äquivalente  (&quot;, \', ..., -, --)',
	'Replace Fields' => 'Felder ersetzen',
	'Save changes to these settings (s)' => 'Einstellungsänderungen speichern (s)',
	'Save Changes' => 'Änderungen speichern',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Feedback-Einstellungen',
	'Spam Settings' => 'Spam-Einstellungen',
	'Automatic Deletion' => 'Automatisches Löschen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam-Feedback nach Ablauf des angegebenen Zeitraums automatisch löschen.',
	'Delete Spam After' => 'Spam löschen nach',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'War ein Element länger als angegeben als Spam markiert war, wird es automatisch gelöscht.',
	'days' => 'Tage',
	'Spam Score Threshold' => 'Spam-Schwellenwert',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Kommentare und TrackBacks bekommen eine Spam-Bewertung zwischen -10 (sicher Spam) und +10 (kein Spam) zugewiesen. Feedback mit einer geringeren Bewertung als eingestellt werden automatisch als Spam markiert.',
	'Less Aggressive' => 'konservativ',
	'Decrease' => 'Abschwächen',
	'Increase' => 'Verstärken',
	'More Aggressive' => 'aggressiv',
	'Include \'nofollow\' in URLs' => '&#8222;nofollow&#8220; setzen',
	'Include the \'nofollow\' attribute in URLs submitted in feedback.' => '&#8222;nofollow&#8220;-Attribut für in Feedback enthaltene URLs setzen.',
	'\'nofollow\' exception for trusted commenters' => '&#8222;nofollow&#8220; nicht für vertraute Kommentarautoren setzen',
	'Do not add the \'nofollow\' attribute when a comment is submitted by a trusted commenter.' => '&#8222;nofollow&#8220;-Attribut nicht in Feedback von vertrauten Autoren setzen.',
	'Comment Settings' => 'Kommentar-Einstellungen',
	'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Authentifizierungsfunktionen stehen nicht zur Verfügung, da mindestens eines der erforderlichen Perl-Module MIME::Base64 und LWP::UserAgent nicht verfügbar ist. Installieren Sie die fehlenden Module und laden Sie dann diese Seite neu, um Authentifizierungsfunktionen konfigurieren und nutzen zu können.',
	'Accept comments according to the policies shown below.' => 'Kommentare nach folgenden Regeln annehmen',
	'Setup Registration' => 'Registierung konfigurieren',
	'Commenting Policy' => 'Kommentierungsregeln',
	'Immediately approve comments from' => 'Kommentare automatisch freischalten von',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Geben Sie an, was mit neuen Kommentaren geschehen soll. Ungeprüfte Kommentare werden zur Moderierung zurückgehalten.',
	'No one' => 'niemandem',
	'Trusted commenters only' => 'von vertrauten Kommentarautoren',
	'Any authenticated commenters' => 'von allen authentifizierten Kommentarautoren',
	'Anyone' => 'jedem',
	'Allow HTML' => 'HTML zulassen',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Bestimmte HTML-Tags in Kommentartexten zulassen. Anderfalls werden sämtliche HTML-Tags herausgefiltert.',
	'Limit HTML Tags' => 'HTML einschränken ',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Geben Sie die HTML-Tags ein, die in Kommentartexten erlaubt sein sollen.',
	'Use defaults' => 'Standardwerte verwenden',
	'([_1])' => '([_1])',
	'Use my settings' => 'Eigene Einstellungen',
	'E-mail Notification' => 'Benachrichtigungen',
	'Specify when Movable Type should notify you of new comments.' => 'Geben Sie an, wann Movable Type Sie über neue Kommentare benachrichtigen soll.',
	'On' => 'Immer',
	'Only when attention is required' => 'Nur wenn eine Entscheidung erforderlich ist',
	'Off' => 'Nie',
	'Comment Display Settings' => 'Kommentaranzeige-Einstellungen',
	'Comment Order' => 'Kommentar- reihenfolge',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie, ob Kommentare in chronologischer oder umgekehrter chronologischer Reihenfolge angezeigt werden sollen,',
	'Auto-Link URLs' => 'URLs automatisch verlinken',
	'Transform URLs in comment text into HTML links.' => 'In Kommentaren enthaltene URLs in HTML-Links umwandeln.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
	'CAPTCHA Provider' => 'CAPTCHA-Quelle',
	'none' => 'Kein(e)',
	'No CAPTCHA provider available' => 'Keine CAPTCHA-Quelle verfügbar',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the \'mt-static/images\' directory.' => 'Keine CAPTCHA-Quelle im System verfügbar.  Überprüfen Sie, ob Image::Magick installiert ist und ob das CaptchaSourceImageBase-Konfigurationsparameter auf ein gültiges Verzeichnis im Ordner &#8222;mt-static/images&#8220; zeigt.',
	'Use Comment Confirmation Page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	'Use comment confirmation page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	'Each commenter\'s browser will be redirected to a comment confirmation page after their comment is accepted.' => 'Nach Abgabe eines Kommentars Autoren automatisch auf Bestätigungsseite weiterleiten.',
	'Trackback Settings' => 'TrackBack-Einstellungen',
	'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
	'Accept TrackBacks from any source.' => 'TrackBacks von allen Quellen annehmen',
	'TrackBack Policy' => 'TrackBack-Regeln',
	'Moderation' => 'Moderation',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks zur Moderation zurückhalten',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Geben Sie an, wann Movable Type Sie über neue TrackBacks benachrichtigen soll.',
	'TrackBack Options' => 'TrackBack-Optionen',
	'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Ist Auto-Discovery aktiviert, werden für HTML-Links in neuen Einträgen automatisch TrackBacks verschickt, wenn die Gegenseite solche akzeptiert.',
	'Enable External TrackBack Auto-Discovery' => 'Auto-Discovery für externe TrackBacks aktivieren',
	'Setting Notice' => 'Nutzungshinweise',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit eingeschränkt. Diese Option ist daher derzeit möglicherweise  nicht oder nur teilweise wirksam.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit deaktiviert. Diese Option ist daher derzeit nicht wirksam.',
	'Enable Internal TrackBack Auto-Discovery' => 'Auto-Discovery für interne TrackBacks aktivieren',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => '[_1]-Plugin-Einstellungen',
	'Useful links' => 'Nützliche Links',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Weitere Plugins',
	'Plugin System' => 'Plugin-System',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin für die gesamte Movable Type-Installation aktivieren oder deaktivieren.',
	'Disable plugin functionality' => 'Plugin-Funktion deaktivieren',
	'Disable Plugins' => 'Plugins deaktivieren',
	'Enable plugin functionality' => 'Plugin-Funktion aktivieren',
	'Enable Plugins' => 'Plugins aktivieren',
	'Your plugin settings have been saved.' => 'Plugin-Einstellungen übernommen',
	'Your plugin settings have been reset.' => 'Plugin-Einstellungen zurückgesetzt',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you must restart your web server for these changes to take effect.' => 'Ihre Plugins wurden konfiguriert. Da Sie mod_perl verwenden, starten Sie Ihren Webserver bitte neu, um die Änderungen wirksam werden zu lassen.',
	'Your plugins have been reconfigured.' => 'Einstellungen übernommen',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'Einstellungen übernommen. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.',
	'Are you sure you want to reset the settings for this plugin?' => 'Wollen Sie die Plugin-Einstellungen wirklich zurücksezten?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Plugins wirklich systemweit deaktivieren?',
	'Are you sure you want to disable this plugin?' => 'Dieses Plugin wirklich deaktivieren?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Plugins wirklich systemweit aktivieren? (Es werden die Plugin-Einstellungen gültig, die bereits vor der Deaktivierung gültig waren.)',
	'Are you sure you want to enable this plugin?' => 'Dieses Plugin wirklich aktivieren?',
	'Settings for [_1]' => 'Einstellungen von [_1]',
	'Failed to Load' => 'Fehler beim Laden',
	'Disable' => 'Deaktivieren',
	'Enabled' => 'Aktiviert',
	'Disabled' => 'Deaktiviert',
	'Enable' => 'Aktivieren',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Dieses Plugin wurde noch nicht für Movable Type  [_1] aktualisiert. Es funktioniert daher möglicherweise nicht einwandfrei.',
	'Plugin error:' => 'Plugin-Fehler:',
	'Info' => 'Info',
	'Resources' => 'Ressourcen',
	'Run [_1]' => '[_1] ausführen',
	'Documentation for [_1]' => 'Dokumentation zu [_1]',
	'Documentation' => 'Dokumentation',
	'More about [_1]' => 'Mehr über [_1]',
	'Plugin Home' => 'Plugin-Website',
	'Author of [_1]' => 'Autor von [_1]',
	'Tag Attributes:' => 'Tag-Attribute:',
	'Text Filters' => 'Textfilter',
	'Junk Filters:' => 'Junkfilter',
	'Reset to Defaults' => 'Voreinstellungen',
	'No plugins with blog-level configuration settings are installed.' => 'Es sind keine Plugins installiert, die Einstellungen auf Blogebene erfordern.',
	'No plugins with configuration settings are installed.' => 'Es sind keine Plugins installiert, die Einstellungen erfordern.',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Fehler: Movable Type konnte kein Verzeichnis für Ihr [_1] anlegen. Sollten Sie das Verzeichnis bereits selbst angelegt haben, stellen Sie bitte sicher, daß der Webserver für Schreibrechte dafür verfügt.',
	'[_1] Settings' => '[_1]-Einstellungen',
	'Name your blog. The name can be changed at any time.' => 'Wählen Sie einen Namen für Ihr Blog. Sie können ihn später jederzeit ändern.',
	'Enter a description for your blog.' => 'Geben Sie eine Beschreibung Ihres Blogs ein.',
	'Time Zone' => 'Zeitzone',
	'Select your time zone from the pulldown menu.' => 'Wählen Sie die gewünschte Zeitzone im Dropdown-Menü.',
	'Time zone not selected' => 'Es wurde keine Zeitzone gewählt',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Neuseeland Sommerzeit)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale Datumslinie Ost)',
	'UTC+11' => 'UTC+11 (Ost-Australische Sommerzeit)',
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
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Osteuropäische Zeit)',
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
	'License' => 'Lizenz',
	'Your blog is currently licensed under:' => 'Ihr Blog ist derzeit lizenziert unter:',
	'Change license' => 'Lizenz ändern',
	'Remove license' => 'Lizenz entfernen',
	'Your blog does not have an explicit Creative Commons license.' => 'Für dieses Blog liegt keine Creative Commons-Lizenz vor.',
	'Select a license' => 'Creative Commons-Lizenz wählen',
	'Publishing Paths' => 'System-Pfade',
	'[_1] URL' => '[_1]-URL',
	'Use subdomain' => 'Subdomain verwenden',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Hinweis: Eine Änderung der Webadresse kann alle Link zu Ihrem Blog ungültig machen.',
	'The URL of your blog. Exclude the filename (i.e. index.html). End with \'/\'. Example: http://www.example.com/blog/' => 'Die URL Ihres Blogs. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem  &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/blog/ ',
	'The URL of your website. Exclude the filename (i.e. index.html).  End with \'/\'. Example: http://www.example.com/' => 'Die URL Ihrer Website. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem  &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/ ',
	'[_1] Root' => '[_1]-Wurzelverzeichnis',
	'Note: Changing your site root requires a complete publish of your site.' => 'Hinweis: Im Anschluss an eine Änderung des Wurzelverzeichnisses muss die gesamte Site neu veröffentlicht werden.',
	'The path where your index files will be published. Do not end with \'/\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog' => 'Der Pfad, in dem die Indexdateien abgelegt werden. Bitte geben Sie den Pfad ohne abschließendes   &#8222;/&#8220; ein, beispielsweise so: /home/mt/public_html/blog oder C:\www\public_html\blog.',
	'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/mt/public_html or C:\www\public_html' => 'Der Pfad, in dem die Indexdateien abgelegt werden. Eine absolute (bei Linux mit &#8222;/&#8220;  oder bei Windows mit &#8220;C:&#8220;  beginnende) Pfadangabe wird bevorzugt. Sie können den Pfad aber auch relativ Sie zu Ihrem Movable Type-Verzeichnis angeben. Beispiel: /home/mt/public_html oder C:\www\public_html', # Translate - New #OK
	'Advanced Archive Publishing' => 'Erweiterte Archivoptionen',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Wählen Sie diese Option nur, wenn Sie Ihre Archive außerhalb des Wurzelverzeichnisses Ihres Blog veröffentlichen müssen.',
	'Publish archives outside of Blog Root' => 'Archive außerhalb Wurzelverzeichnis ablegen',
	'Archive URL' => 'Archivadresse',
	'Enter the URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Geben Sie die Adresse der Archivsektion Ihres Blogs ein, beispielsweise http://beispiel.de/blog/archiv/ ',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Hinweis: Eine Änderung der Archivadresse kann alle Links zu Ihrem Blog ungültig machen.',
	'Enter the path where your archive files will be published. Example: /home/mt/public_html/blog/archives or C:\www\public_html\blog\archives' => 'Geben Sie den lokalen Pfad zu Ihrem Archiv ein, beispielsweise /home/mt/public_html/blog/archiv oder C:\www\public_html\blog\archiv',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Warnung: Eine Änderung des Archivpfads kann sämtliche Links zu Ihrem Blog ungültig machen.',
	'Asynchronous Job Queue' => 'Asynchronous Job Queue',
	'Use Publishing Queue' => 'Warteschlange benutzen',
	'Requires the use of a cron job or a scheduled task on your server to publish pages in the background.' => 'Veröffentlichung im Hintergrund erfordert einen Cronjob oder eine vergleichbare Zeitschienensteuerung auf Ihrem Server.',
	'Use background publishing queue for publishing static pages for this blog' => 'Für die Veröffentlichung der statischen Seiten dieses Blogs Hintergrund-Warteschleife verwenden',
	'Dynamic Publishing Options' => 'Dynamikoptionen',
	'Enable dynamic cache' => 'Dynamischen Cache aktivieren',
	'Enable conditional retrieval' => 'Conditional Retrieval aktivieren',
	'Archive Settings' => 'Archiv-Einstellungen',
	'File Extension' => 'Dateierweiterung',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Geben Sie die gewünschte Erweiterung der Archivdateien an. Möglich sind .html, .shtml, .php usw. Hinweis: Geben Sie die Erweiterung ohne führenden Punkt (&#8222;.&#8220;) ein.',
	'Preferred Archive' => 'Bevorzugte Archive',
	'Used to generate URLs (permalinks) for this blog\'s archived entries. Choose one of the archive type used in this blog\'s archive templates.' => 'Wird zur Erzeugung der dauerhaften Links archivierter Blog-Einträge (Permalinks) verwendet. Wählen Sie dazu einen der in diesem Blog verwendeten Archivtypen aus.',
	'No archives are active' => 'Archive nicht aktiviert',
	'Module Settings' => 'Modul-Einstellungen',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Keine (deaktiviert)',
	'PHP Includes' => 'PHP-Includes',
	'Apache Server-Side Includes' => 'Apache Server-Side-Includes',
	'Active Server Page Includes' => 'Active Server Page-Includes',
	'Java Server Page Includes' => 'Java Server Page-Includes',
	'Module Caching' => 'Modul-Caching',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Entsprechend konfigurierte Vorlagenmodule zwischenzuspeichern erhöht die Leistung Ihres Systems.',
	'Note: Revision History is currently disabled at the system level.' => 'Hinweis: Revisionshistorie ist systemweit deaktiviert',
	'Revision history' => 'Revisionshistorie',
	'Enable revision history' => 'Revisionsshistorie aufzeichnen',
	'Number of revisions per entry/page' => 'Anzahl der Revisionen pro Eintrag/Seite',
	'Number of revisions per page' => 'Anzahl der Revisionen pro Seite',
	'Number of revisions per template' => 'Anzahl der Revisionen pro Vorlage',
	'You must set your Blog Name.' => 'Bitte geben Sie einen Blognamen an',
	'You did not select a time zone.' => 'Bitte wählen Sie eine Zeitzone.',
	'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an',
	'You must set your Local Site Path.' => 'Bitte wählen Sie ein Wurzelverzeichnis',
	'You must set a valid Local Site Path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an',
	'You must set a valid Archive URL.' => 'Bitte definieren Sie eine gültige Archive URL.',
	'You must set Local Archive Path.' => 'Bitte definieren Sie Ihren Local Archive Path.',
	'You must set a valid Local Archive Path.' => 'Bitte definieren Sie einen gültigen Local Archive Path.',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Registrierungs-Einstellungen',
	'Your blog preferences have been saved.' => 'Einstellungen übernommen.',
	'User Registration' => 'Benutzerregistrierung',
	'Allow registration for this website.' => 'Registierung für diese Website ermöglichen',
	'Registration Not Enabled' => 'Registierungen nicht erlauben',
	'Note: Registration is currently disabled at the system level.' => 'Hinweis: Registrierung derzeit systemweit deaktiviert.',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Lesern ermöglichen, sich mit einer der unten aufgeführten Authentifizierungsmethoden als Mitglied dieser Website zu registrieren.',
	'Authentication Methods' => 'Authentifizierungs- methoden',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Hinweis: Sie möchten Kommentare nur von authentifizierten Kommentarautoren zulassen. Allerdings haben Sie die Authentifizierung nicht aktiviert.',
	'Require E-mail Address for Comments via TypePad' => 'Für über TypePad eingehende Kommentare E-Mail-Adresse des Autors verlangen',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'Zur Anmeldung über TypePad muss das TypePad-Benutzerkonto so konfiguriert sein, daß es die E-Mail-Adresse des Autors übermittelt.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Zur Nutzung dieser Authentifizierungsmethode fehlt mindestens ein erforderliches Perl-Modul.',
	'Setup TypePad authentication' => 'TypePad-Authentifizierung einrichten',
	'on the Web Services Settings page.' => 'auf der Seite für Webdienste-Einstellungen.',
	'OpenID providers disabled' => 'OpenID-Provider deaktiviert',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Das zur OpenID-Authentifizierung erforderliche Perl-Modul Digest::SHA1 fehlt.',

## tmpl/cms/cfg_system_general.tmpl
	'A test email was sent.' => 'Testmail verschickt.',
	'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'System Email' => 'System- E-Mail-Adresse',
	'This email address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, and a few other minor events.' => 'Diese Adresse wird von Movable Type für automatisch erzeugte E-Mails verwendet. Automatisch erzeugte Mails werden bei Passwortanforderungen, Registrierungen von Kommentarautoren, zur Benachrichtigung über Kommentare und TrackBack sowie bei einigen weiteren Ereignissen verschickt.',
	'Send Test Email' => 'Testmail verschicken',
	'Debug Mode' => 'Debug-Modus',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Geben Sie ein Zahl größer null ein, um Diagnosemodi zu aktivieren. Welche Modi verfügbar sind, finden sie in der <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Dokumentation des Debug-Modus</a> (englischsprachig).',
	'Performance Logging' => 'Performance-Logging',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified below.' => 'Mit dem Performance-Logging identifizieren Sie Vorgänge, die länger als eine wählbaren Zeitraum benötigen.',
	'Log Path' => 'Logging-Pfad',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Verzeichnis für Log-Dateien. Ihr Webserver benötigt Schreibrechte für dieses Verzeichnis.',
	'Logging Threshold' => 'Logging-Schwellenwert',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Vorgänge, die länger als die angegebene Anzahl von Sekunden benötigen, loggen.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Aktivieren Sie diese Funktion, um Movable Type frühere Versionen von Einträgen, Seiten und Vorlagen vorhalten zu lassen.',
	'Track revision history' => 'Revisionshistorie verfolgen',
	'System-wide Feedback Controls' => 'Systemweite Feedback-Einstellungen',
	'Prohibit Comments' => 'Kommentare nicht zulassen',
	'This will override all individual blog settings.' => 'Dieser Einstellung überragt alle Einstellungen auf Blog-Ebene.',
	'Disable comments for all blogs.' => 'Kommentare für alle Blogs deaktiveren',
	'Prohibit TrackBacks' => 'TrackBacks nicht zulassen',
	'Disable receipt of TrackBacks for all blogs.' => 'Empfang von TrackBacks für alle Blogs deaktivieren',
	'Outbound Notifications' => 'Benachrichtigungen',
	'Prohibit Notification Pings' => 'Pings nicht zulassen',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Versand von Benachrichtigungs-Pings bei Veröffentlichung neuer Einträge systemweit deaktivieren.',
	'Disable notification pings for all blogs.' => 'Benachrichtigungs-Pings für alle Blogs deaktivieren',
	'Send Outbound TrackBacks to' => 'Ausgehende TrackBacks senden an',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Versenden Sie keine TrackBacks und verwenden Sie kein Auto-Disovery für TrackBacks, wenn Ihre Installation privat sein soll.',
	'Any site' => 'Jede Site',
	'(No Outbound TrackBacks)' => '(Kein TrackBack-Versand)',
	'Only to blogs within this system' => 'Nur an Blogs in diesem System',
	'Only to websites on the following domains:' => 'Nur zu  folgenden Domains:',
	'Send Email To' => 'E-Mail schicken an',
	'The email address that should receive a test email from Movable Type.' => 'Die Adresse, an die Movable Type Testmails verschicken soll.',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Benutzereinstellungen',
	'(No website selected)' => '(Keine Website gewählt)',
	'Select website' => 'Website wählen',
	'(None selected)' => '(Kein Blog gewählt)',
	'Allow Registration' => 'Registrierung erlauben',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Bestimmen Sie, welcher Systemadministrator benachrichtigt werden soll, wenn ein Kommentarautor sich erfolgreich selbst registriert hat.',
	'Allow commenters to register with blogs on this system.' => 'Kommentarautoren ermöglichen, sich mit Blogs an diesem System zu registrieren',
	'Notify the following system administrators when a commenter registers:' => 'Folgende Systemadministratoren benachrichtigen, wenn sich ein Kommentarautor registriert hat:',
	'Select system administrators' => 'System-Administrator wählen',
	'Clear' => 'zurücksetzen',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Hinweis: Sie haben noch keine System-E-Mail-Adresse eingerichtet. Benachrichtigungen können daher nicht verschickt werden. Die Adresse kann unter System > Grundeinstellungen eingerichtet werden.',
	'New User Defaults' => 'Voreinstellungen für neue Benutzer',
	'Personal Blog' => 'Persönliches Blog',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Automatisch persönliche Blogs für neue Benutzer anlegen. Dem Benutzer werden für sein persönliches Blog Administrationsrechte zugewiesen.',
	'Automatically create a new blog for each new user.' => 'Für neue Benutzer automatisch eigenes Blog anlegen.',
	'Personal Blog Location' => 'Speicherort für persönliche Blogs',
	'Select a website you wish to use as the location of new personal blogs.' => 'Wählen Sie, unter welcher Website neue persönliche Blogs abgelegt werden sollen.',
	'Change website' => 'Website wechseln',
	'Personal Blog Theme' => 'Thema für persönliche Blogs',
	'Select the theme that should be used for new personal blogs.' => 'Wählen Sie, welches Thema für neue persönliche Blogs genutzt werden soll.',
	'(No theme selected)' => '(Kein Thema gewählt)',
	'Change theme' => 'Thema ändern',
	'Select theme' => 'Thema wählen',
	'Default User Language' => 'Standard-Sprache',
	'Choose the default language to apply to all new users.' => 'Wählen Sie, welche Sprache für neue Benutzerkonten verwendet werden soll.',
	'Default Time Zone' => 'Standard-Zeitzone',
	'Default Tag Delimiter' => 'Standard- Tag-Trennzeichen',
	'Define the default delimiter for entering tags.' => 'Wählen Sie das Standard-Trennzeichen für die Eingabe von Tags',
	'Comma' => 'Komma',
	'Space' => 'Leerzeichen',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Webdienste-Einstellungen',
	'Web Services from Six Apart' => 'Webdieste von Six Apart',
	'Your TypePad token is used to access services from Six Apart like TypePad Connect and TypePad AntiSpam.' => 'Mit Ihrem TypePad-Token erhalten Sie Zugriff auf von Six Apart angebotene Webdienste wie TypePad Conect und TypePad AntiSpam.',
	'TypePad is enabled.' => 'TypePad ist aktiviert.',
	'TypePad token:' => 'TypePad-Schlüssel:',
	'Clear TypePad Token' => 'TypePad-Schlüssel entfernen',
	'Please click the Save Changes button below to disable authentication.' => 'Bitte klicken Sie auf "Änderungen speichern", um die Authentifizierung abzuschalten.',
	'TypePad is not enabled.' => 'Typepad ist nicht aktiviert.',
	'&nbsp;or&nbsp;[_1]obtain a TypePad token[_2] from TypePad.com.' => '&nbsp;oder&nbp;[_1]TypePad-Token von TypePad.com beziehen[_2].',
	'Please click the \'Save Changes\' button below to enable TypePad.' => 'Klicken Sie auf &#8222;Änderungen speichern&#8220;, um TypePad zu aktivieren.',
	'External Notifications' => 'Externe Benachrichtigungen',
	'Notify ping services of website updates' => 'Ping-Dienste über Aktualisierungen dieser Website benachrichtigen',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Movable Type benachrichtigt die angegeben Dienste automatisch, wenn diese Website aktualisiert wird.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Hinweis: Diese Option ist derzeit nicht wirksam, da ausgehende Pings systemweit deaktiviert sind.',
	'Others:' => 'Andere:',
	'(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',
	'Recently Updated Key' => '"Kürzlich aktualisiert"- Schlüssel',
	'If you received a Recently Updated Key with the purchase of a Movable Type license, enter it here.' => 'Wenn Sie einen &#8222;Kürzlich aktualisiert&#8220;-Schlüssel mit Ihrer Movable Type-Lizenz erhalten haben, geben Sie ihn hier ein.',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Übersichtsseite',
	'System Overview' => 'Systemübersicht',
	'Hi, [_1]' => ' Hallo [_1]',
	'Select a Widget...' => 'Widget wählen...',
	'Add' => 'Hinzufügen',
	'Your Dashboard has been updated.' => 'Übersichtsseite aktualisiert.',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Sie haben für die gewünschte Funktion keine Berechtigung. Bei Fragen wenden Sie sich bitte an Ihren Systemadministrator.',
	'Support directory is not writable.' => 'Das Support-Verzeichnis ist nicht beschreibbar.',
	'Detail' => 'Anmerkung',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type kann auf den Ordner &#8222;support&#8220; nicht schreibend zugreifen. Legen Sie unter [_1] ein solches Verzeichnis an und stellen Sie sicher, daß der Webserver über Schreibrechte für diesen Ordner verfügt.',
	'Image::Magick is not configured.' => 'Image::Magick ist nocht nicht konfiguriert.',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Die Benutzerbild-Funktion steht Ihnen derzeit nicht zur Verfügung, da Image::Magick nicht installiert oder nicht richtig konfiguriert ist. Um die Funktion zu nutzen, installieren Sie Image::Magick oder verwenden Sie einen anderen entsprechenden Treiber',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Veröffentlichungseinstellungen bestätigen',
	'Site Path' => 'Lokaler Pfad',
	'Parent Website' => 'Übergeordnete Website',
	'Please choose parent website.' => 'Bitte wählen Sie die übergeordnete Website.',
	'Archive Path' => 'Archivpfad',
	'Continue' => 'Weiter',
	'Continue (s)' => 'Weiter (s)',
	'Back' => 'Zurück',
	'Back (b)' => 'Zurück (b)',
	'You must select a parent website.' => 'Bitte wählen Sie eine übergeordnete Website.',

## tmpl/cms/dialog/asset_insert.tmpl
	'Close (x)' => 'Schließen (x)',

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Image' => 'Bild einfügen',
	'Insert Asset' => 'Asset einfügen',
	'Upload New File' => 'Neue Datei hochladen',
	'Upload New Image' => 'Neues Bild hochladen',
	'Asset Name' => 'Assetname',
	'Size' => 'Größe',
	'Pending' => 'Auf Moderation wartend',
	'View Asset' => 'Asset ansehen',
	'Next (s)' => 'Nächstes (s)',
	'Insert (s)' => 'Einfügen (s)',
	'Insert' => 'Einfügen',
	'Cancel (x)' => 'Abbrechen (x)',
	'No assets could be found.' => 'Keine Assets gefunden.',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Bild in Eintrag/Seite anzeigen',
	'Alignment' => 'Ausrichtung',
	'Left' => 'Links',
	'Center' => 'Zentriert',
	'Right' => 'Rechts',
	'Use thumbnail' => 'Vorschaubild',
	'width:' => 'Breite:',
	'pixels' => 'Pixel',
	'Link image to full-size version in a popup window.' => 'Mit Großansicht in Popup verlinken',
	'Remember these settings' => 'Einstellungen speichern',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Dateioptionen',
	'Create entry using this uploaded file' => 'Eintrag mit hochgeladener Datei anlegen',
	'Create a new entry using this uploaded file.' => 'Neuen Eintrag mit hochgeladener Datei anlegen',
	'Finish (s)' => 'Fertigstellen (s)',
	'Finish' => 'Fertigstellen',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Bitte konfigurieren Sie Ihr Blog.',
	'Your blog has not been published.' => 'Ihr Blog wurde noch nicht veröffentlicht.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Verify Clone Blog Settings' => 'Kloneinstellungen überprüfen',
	'Blog Details' => 'Blog-Details',
	'This is set to the same URL as the original blog.' => 'Das ist die URL des ursprünglichen Blogs.',
	'This will overwrite the original blog.' => 'Das ursprüngliche Blog wird daher beim Klonen überschrieben.',
	'Exclusions' => 'Ausschließen',
	'Exclude Entries/Pages' => 'Einträge/Seiten ausschließen',
	'Exclude Comments' => 'Kommentare ausschließen',
	'Exclude Trackbacks' => 'TrackBacks ausschließen',
	'Exclude Categories/Folders' => 'Kategorien/Ordner ausschließen',
	'Clone' => 'Klonen',
	'Clone Blog Settings' => 'Klon-Einstellungen',
	'Enter the new URL of your public website. Example: http://www.example.com/weblog/' => 'Geben Sie die neue URL Ihrer öffentlichen Website ein, z.B. http://beispiel.de/weblog/',
	'Enter a new path where your main index file will be located. Example: /home/melody/public_html/weblog' => 'Geben Sie den neuen Pfad zu Indexdatei an, z.B. /home/melody/public_html/weblog',
	'Mark the settings that you want cloning to skip' => 'Markieren Sie Objekte, die nicht geklont werden sollen',
	'Entries/Pages' => 'Einträge/Seiten',
	'Categories/Folders' => 'Kategorien/Ordner',
	'Confirm' => 'Bestätigen',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'Auf Kommentar antworten',
	'On [_1], [_2] commented on [_3]' => '[_2] hat am [_1] [_3] kommentiert',
	'Preview of your comment' => 'Kommentarvorschau',
	'Your reply:' => 'Ihre Antwort:',
	'Submit reply (s)' => 'Abschicken (s)',
	'Preview reply (v)' => 'Vorschau (v)',
	'Re-edit reply (r)' => 'Erneut bearbeiten (r)',
	'Re-edit' => 'Erneut bearbeiten',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'In dieser MT-Installation ist keine Rolle vorhanden. [_1]Rolle anlegen</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'In dieser MT-Installation ist keine Gruppe vorhanden. [_1]Gruppe anlegen</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'In dieser MT-Installation ist kein Benutzer vorhanden. [_1]Benutzer anlegen</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'In dieser MT-Installation ist kein Blog vorhanden. [_1]Blog anlegen</a>',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Benachrichtigung versenden',
	'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.',
	'Your [_1]\'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.' => 'Benachrichtigungen beinhalten den Namen Ihres Blogs bzw. Ihrer Website, den Titel des und einen Link zum Eintrag. Optional können Sie auch eine eigene Nachricht und/oder einen Auszug des Eintrags oder den gesamten  Eintragstext mitschicken.',
	'Recipients' => 'Empfänger',
	'Enter email addresses on separate lines or separated by commas.' => 'Verwenden Sie pro Adresse eine Zeile oder trennen Sie ei E-Mail-Adressen mit Kommata.',
	'All addresses from Address Book' => 'Alle Adressen aus dem Adressbuch',
	'Optional Message' => 'Nachricht (optional)',
	'Optional Content' => 'Inhalt (optional)',
	'(Body will be sent without any text formatting applied.)' => '(Der Eintragstext wird ohne Textformatierungen verschickt.)',
	'Send notification (s)' => 'Benachrichtigung absenden (s)',
	'Send' => 'Absenden',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Wählen Sie die gewünschte frühere Version aus.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Passwort ändern',
	'New Password' => 'Neues Passwort',
	'Confirm New Password' => 'Neues Passwort bestätigen',
	'Change' => 'Ändern',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Veröffentlichungsprofil',
	'Choose the profile that best matches the requirements for this blog.' => 'Wählen Sie das Profil, das den Anforderungen dieses Blogs am besten entspricht.',
	'Static Publishing' => 'Statische Veröffentlichung',
	'Immediately publish all templates statically.' => 'Alle Vorlagen sofort statisch veröffentlichen.',
	'Background Publishing' => 'Veröffentlichung im Hintergrund',
	'All templates published statically via Publish Que.' => 'Alle Vorlagen statisch über die Veröffentlichungs-Warteschlange veröffentlichen.',
	'High Priority Static Publishing' => 'Priorisierte statische Veröffentlichung',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Hauptindex, Eintragsarchive und Seitenarchive sofort statisch, alle anderen Vorlagen im Hintergrund statisch veröffentlichen.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Hauptindex und Seitenarchive sofort statisch, alle anderen Vorlagen im Hintergrund statisch veröffentlichen.',
	'Dynamic Publishing' => 'Dynamische Veröffentlichung',
	'Publish all templates dynamically.' => 'Alle Vorlagen dynamisch veröffentlichen.',
	'Dynamic Archives Only' => 'Nur dynamische Archive',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle Archivvorlagen dynamisch, alle anderen Vorlagen sofort statisch veröffentlichen.',
	'This new publishing profile will update all of your templates.' => 'Mit dem neuen Veröffentlichungsprofil werden alle Vorlagen aktualisiert.',
	'Are you sure you wish to continue?' => 'Möchten Sie wirklich fortsetzen?',

## tmpl/cms/dialog/recover.tmpl
	'The email address provided is not unique.  Please enter your username.' => 'Die angegebene E-Mail-Adresse wird mehrfach genutzt. Bitte geben Sie stattdessen Ihren Benutzernamen ein.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Es wurde eine E-Mail mit einem Link zum Zurücksetzen Ihres Passwortes an Ihre Adresse ([_1]) verschickt .',
	'Go Back (x)' => 'Zurück (x)',
	'Sign in to Movable Type (s)' => 'Bei Movable Type anmelden (s)',
	'Sign in to Movable Type' => 'Bei Movable Type anmelden',
	'Recover (s)' => 'Passwort anfordern (s)',
	'Recover' => 'Passwort anfordern',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Globale Vorlagen zurücksetzen',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Kann Vorlagengruppe nicht finden. Bitte wenden Sie das [_1]Thema[_2] an, um Ihre Vorlagen zurückzusetzen.',
	'Revert modifications of theme templates' => 'Änderungen an Themen-Vorlagen zurücknehmen',
	'Reset to theme defaults' => 'Auf Themen-Standardwerte zurücksetzen',
	'Deletes all existing templates and install the selected theme\'s default.' => 'Alle Vorlagen löschen und Standarvorlagen des gewählten Themas installieren.',
	'Refresh global templates' => 'Globale Vorlagen zurücksetzen',
	'Reset to factory defaults' => 'Auf Werkseinstellungen zurücksetzen',
	'Deletes all existing templates and installs factory default template set.' => 'Löscht alle vorhandenen Vorlagen und installiert die Movable Type-Standardvorlagen',
	'Updates current templates while retaining any user-created templates.' => 'Aktualisiert die derzeit gewählten Vorlagen, ohne von Benutzern angelegte Vorlagen zu verändern',
	'Make backups of existing templates first' => 'Sichern Sie zuerst Ihre vorhandenen Vorlagen',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Sie möchten <strong>die derzeit gewählte Vorlagengruppe zurücksetzen</strong>. Das bedeutet:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Sie möchten <strong>die globalen Vorlagen zurücksetzen</strong>. Das bedeutet:',
	'make backups of your templates that can be accessed through your backup filter' => 'die vorhandenen Vorlagen werden gesichert und können später wiederhergestellt werden',
	'potentially install new templates' => 'ggf. werden neue Vorlagen installiert',
	'overwrite some existing templates with new template code' => 'einige vorhandene Vorlagen werden mit neuen Vorlagen überschrieben',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Sie möchten <strong>eine neue Vorlagengruppe installieren</a>. Das umfasst:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Sie möchten <strong>auf die globalen Standardvorlagen zurücksetzen</a>. Das bedeutet:',
	'delete all of the templates in your blog' => 'alle Vorlagen Ihres Blogs werden gelöscht',
	'install new templates from the selected template set' => 'die gewählte Vorlagengruppe wird neu installiert',
	'delete all of your global templates' => 'alle globalen Vorlagen werden gelöscht',
	'install new templates from the default global templates' => 'die globalen Standardvorlagen werden neu installiert',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie die Sicherungsdatei.',
	'View Activity Log (v)' => 'Aktivitätsprotokoll ansehen (v)',
	'All data restored successfully!' => 'Alle Daten erfolgreich wiederhergestellt!',
	'Close (s)' => 'Schließen (s)',
	'Next Page' => 'Nächste Seite',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Diese Seite leitet in drei Sekunden auf eine neue Seite weiter. [_1]Weiterleitung abbrechen[_2].',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Wiederherstellung...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Wiederherstellung mehrerer Dateien',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Abbrechen führt zu verwaisten Objekten. Wiederherstellung wirklich abbrechen?',
	'Please upload the file [_1]' => 'Bitte laden Sie die Datei [_1] hoch',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Thema für persönliche Blogs wählen',
	'Apply' => 'Anwenden',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Asset bearbeiten',
	'Your asset changes have been made.' => 'Änderungen des Assets gespeichert.',
	'Stats' => 'Statistik',
	'[_1] - Created by [_2]' => 'Angelegt von [_2] [_1]',
	'[_1] - Modified by [_2]' => '[_1] - Bearbeitet von [_2]',
	'Appears in...' => 'Verwendet in...',
	'Show all entries' => 'Alle Einträge anzeigen',
	'Show all pages' => 'Alle Seiten anzeigen',
	'This asset has not been used.' => 'Dieses Asset wurde noch nicht verwendet.',
	'Related Assets' => 'Verwandte Assets',
	'No thumbnail image' => 'Kein Vorschaubild',
	'[_1] is missing' => '[_1] fehlt',
	'Type' => 'Typ',
	'Embed Asset' => 'Asset einbetten',
	'View this asset.' => 'Asset anzeigen',
	'View' => 'Ansehen',
	'Save changes to this asset (s)' => 'Assetänderungen speichern (s)',
	'You must specify a name for the asset.' => 'Bitte geben Sie einen Namen für das Asset an.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Profil bearbeiten',
	'This profile has been updated.' => 'Profil aktualisiert',
	'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an [_1] verschickt.',
	'User properties' => 'Benutzer-Eigenschaften',
	'Your web services password is currently' => 'Ihr Passwort für Webdienste lautet derzeit',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Dazu wird ein zufällig erzeugtes neues Passwort per E-Mail an [_2] verschickt werden.\n\nForsetzen?',
	'Error occurred while removing userpic.' => 'Beim Entfernen des Benutzerbildes ist ein Fehler aufgetreten',
	'Profile' => 'Profil',
	'_USER_STATUS_CAPTION' => 'Status',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Status des Benutzerkontos. Um einem Benutzer den Zugriff auf das System zu entziehen, ohne von ihm angelegte Inhalte zu verliren, deaktivieren Sie das jeweilige Benutzerkonto.',
	'_USER_ENABLED' => 'Aktiviert',
	'_USER_PENDING' => 'Schwebend',
	'_USER_DISABLED' => 'Deaktiviert',
	'The username used to login.' => 'Benutzername (für Anmeldung)',
	'External user ID' => 'Externe Benutzer-ID',
	'The name displayed when content from this user is published.' => 'Der Name, der zusammen mit Inhalten dieses Benutzers angezeigt werden soll.',
	'The email address associated with this user.' => 'Mit diesem Benutzer verknüpfte E-Mail-Adresse',
	'Website URL' => 'Website',
	'This User\'s website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.' => 'Die Website dieses Benutzers (z.B. http://movabletype.com/). Ist sowohl dieses als auch das Feld &#8222;Anzeigename&#8220; ausgefüllt, erzeugt Movable Type daraus per Voreinstellung einen Link zur angebenen Website und zeigt diesen unter Einträgen und Kommentaren des Benutzers an.',
	'Userpic' => 'Benutzerbild',
	'The image associated with this user.' => 'Ein diesem Benutzer zugeordnetes Bild',
	'Select Userpic' => 'Benutzerbild wählen',
	'Remove Userpic' => 'Benutzerbild entfernen',
	'Password' => 'Passwort',
	'Current Password' => 'Derzeitiges Passwort',
	'Existing password required to create a new password.' => 'Derzeitiges Passwort zur Passwortänderung erforderlich',
	'Initial Password' => 'Passwort',
	'Enter preferred password.' => 'Bevorzugtes Passwort eingeben',
	'Enter the new password.' => 'Neues Passwort eingeben',
	'Confirm Password' => 'Passwort bestätigen',
	'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen',
	'Password recovery word/phrase' => 'Erinnerungssatz',
	'This word or phrase is not used in the password recovery.' => 'Dieser Ausdruck ist nicht Teil des Erinnerungssatzes',
	'Preferences' => 'Konfigurieren',
	'Language' => 'Sprache',
	'Display language for the Movable Type interface.' => 'Anzeigesprache der Movable Type-Benutzeroberfläche',
	'Text Format' => 'Textformatierung',
	'Default text formatting filter when creating new entries and new pages.' => 'Standard-Textfilter beim Erstellen neuer Seiten und Einträge',
	'(Use Website/Blog Default)' => '(Standardeinstellung verwenden)',
	'Tag Delimiter' => 'Tag-Trennzeichen',
	'Preferred method of separating tags.' => 'Bevorzugtes Trennzeichen für Tags',
	'Web Services Password' => 'Passwort für Webdienste',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Erforderlich für Aktivitätsfeeds und für externe Software, die über XML-RPC oder ATOM-API auf das Weblog zugreift',
	'Reveal' => 'Anzeigen',
	'System Permissions' => 'Berechtigungen',
	'Options' => 'Optionen',
	'Create personal blog for user' => 'Persönliches Blog für den Benutzer anlegen',
	'Create User (s)' => 'Benutzerkonto anlegen (s)',
	'Save changes to this author (s)' => 'Kontoänderungen speichern (s)',
	'_USAGE_PASSWORD_RESET' => 'Hier können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufälliges neues Passwort erzeugt und an <strong>[_1]</strong> verschickt werden.',
	'Initiate Password Recovery' => 'Passwort wiederherstellen',

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Blog anlegen',
	'Your blog configuration has been saved.' => 'Ihre Blog-Konfiguration wurde gespeichert.',
	'You did not select a timezone.' => 'Bitte wählen Sie einen Zeitzone',
	'Blog Theme' => 'Blog-Thema',
	'Select the theme you wish to use for this blog.' => 'Wählen Sie das Thema, das Sie für dieses Blog verwenden möchten.',
	'Name your blog. The blog name can be changed at any time.' => 'Geben Sie Ihrem Blog einen Namen. Der Name kann jederzeit geändert werden.',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/weblog/' => 'Geben Sie die gewünschte URL Ihrere Website ohne Dateinamen ein, z.B. http://beispiel.de/weblog/',
	'Blog Root' => 'Blog-Wurzelverzeichnis',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Der Pfad, in dem Startseite Ihres Blog abgelegt werden soll. Eine absolute (mit  &#8222;/&#8220; beginnende) Pfadangabe wird bevorzugt, Sie können den Pfad aber auch relativ Sie zu Ihrem Movable Type-Verzeichnis angeben. Beispiel: /home/melanie/public_html/blog',
	'Select your timezone from the pulldown menu.' => 'Zeitzone des Weblogs',
	'Blog language.' => 'Blog-Sprache',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Wenn Sie eine andere Sprache als die systemweit festgelegte Standardsprache wählen,  können Sie unterschiedliche globale Vorlagen verwenden, indem Sie die Modulnamen in Ihren Vorlagen entsprechend ändern.',
	'Create Blog (s)' => 'Blog anlegen (s)',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Kategorie bearbeiten',
	'Your category changes have been made.' => 'Die Einstellungen wurden übernommen.',
	'Manage entries in this category' => 'Einträge in dieser Kategorie verwalten',
	'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
	'_CATEGORY_BASENAME' => 'Basisname',
	'This is the basename assigned to your category.' => 'Der dieser Kategorie zugewiesene Basisname',
	'Warning: Changing this category\'s basename may break inbound links.' => 'Achtung: Änderungen des Basisnamens können bestehende externe Links auf diese Kategorieseite ungültig machen',
	'Inbound TrackBacks' => 'TrackBack-Empfang',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Wenn die Option aktiv ist, sind Kategorie-TrackBacks aus allen Quellen zugelassen',
	'View TrackBacks' => 'TrackBacks ansehen',
	'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
	'_USAGE_CATEGORY_PING_URL' => 'Das ist die Adresse für TrackBacks für diese Kategorie. Wenn Sie sie öffentlich machen, kann jeder, der in seinem Blog einen für diese Kategorie relevanten Eintrag geschrieben hat, einen TrackBack-Ping senden. Mittels TrackBack-Tags können Sie diese TrackBacks dann auf Ihrer Seite anzeigen. Näheres dazu finden Sie in der Dokumentation.',
	'Passphrase Protection' => 'Passphrasenschutz',
	'Outbound TrackBacks' => 'TrackBack-Versand',
	'Trackback URLs' => 'TrackBack-URLs',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Geben Sie die Adressen der Websites ein, an die Sie automatisch einen TrackBack-Ping schicken möchten, wenn ein neuer Eintrag in dieser Kategorie veröffentlicht wurde. Verwenden Sie für jede Adresse eine neue Zeile.',
	'Save changes to this category (s)' => 'Kategorieänderungen speichern (s)',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Kommentarautor-Details',
	'Your changes have been saved.' => 'Änderungen gespeichert.',
	'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentarautoren.',
	'The commenter has been banned.' => 'Dieser Kommentarautor wurde gesperrt.',
	'Comments from [_1]' => 'Kommentare von [_1]',
	'commenter' => 'Kommentarautor',
	'commenters' => 'Kommentarautoren',
	'to act upon' => 'bearbeiten',
	'Trust user (t)' => 'Benutzer vertrauen (t)',
	'Trust' => 'Vertrauen',
	'Untrust user (t)' => 'Benutzer nicht mehr vertrauen (t)',
	'Untrust' => 'Nicht vertrauen',
	'Ban user (b)' => 'Benutzer sperren (b)',
	'Ban' => 'Sperren',
	'Unban user (b)' => 'Benutzer nicht mehr sperren (b)',
	'Unban' => 'Entsperren',
	'The Name of the commenter' => 'Name des Kommentarautors',
	'View all comments with this name' => 'Alle Kommentare mit diesem Autorennamen anzeigen',
	'Identity' => 'Identität',
	'The Identity of the commenter' => 'Identität des Kommentarautors',
	'Email' => 'E-Mail',
	'The Email of the commenter' => 'E-Mail-Adresse des Kommentarautors',
	'Withheld' => 'Zurückgehalten',
	'View all comments with this email address' => 'Alle Kommentare von dieser E-Mail-Adresse anzeigen',
	'The URL of the commenter' => 'Web-Adresse (URL) des Kommentarautors',
	'The trusted status of the commenter' => 'Vertrauensstatus des Kommentarautors',
	'Trusted' => 'vertraut',
	'Banned' => 'Gesperrt',
	'Authenticated' => 'Authentifiziert',
	'View all commenters' => 'Alle Kommentarautoren anzeigen',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Kommentar freigeschaltet.',
	'Save changes to this comment (s)' => 'Kommentaränderungen speichern (s)',
	'comment' => 'Kommentar',
	'comments' => 'Kommentare',
	'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
	'Ban This IP' => 'Diese IP-Adresse sperren',
	'Manage Comments' => 'Kommentare verwalten',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'Zeige [_1] Kommentar zu',
	'Reply to this comment' => 'Kommentar beantworten',
	'Update the status of this comment' => 'Kommentarstatus aktualisieren',
	'Approved' => 'Freigeschaltet',
	'Unapproved' => 'Nicht freigeschaltet',
	'Reported as Spam' => 'Als Spam gemeldet',
	'View all comments with this status' => 'Alle Kommentare mit diesem Status anzeigen',
	'Details' => 'Details',
	'Total Feedback Rating: [_1]' => 'Gesamtbewertung: [_1]',
	'Test' => 'Test',
	'Score' => 'Bewertung',
	'Results' => 'Treffer',
	'The name of the person who posted the comment' => 'Name des Kommentarautors',
	'View this commenter detail' => 'Details zum Kommentarautoren anzeigen',
	'(Trusted)' => '(vertraut)',
	'Untrust Commenter' => 'Kommentarautor nicht mehr vertrauen',
	'Ban Commenter' => 'Kommentarautor sperren',
	'(Banned)' => '(gesperrt)',
	'Trust Commenter' => 'Kommentarautor vertrauen',
	'Unban Commenter' => 'Kommentarautor nicht mehr sperren',
	'(Pending)' => '(wartet)',
	'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentarautor anzeigen',
	'Email address of commenter' => 'E-Mail-Adresse des Kommentarautors',
	'Unavailable for OpenID user' => 'Nicht verfügbar für OpenID-Nutzer',
	'URL of commenter' => 'URL des Kommentarautors',
	'No url in profile' => 'Keine URL im Profil',
	'Link' => 'Link',
	'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
	'[_1] this comment was made on' => '[_1] zum Kommentar',
	'[_1] no longer exists' => '[_1] existiert nicht mehr',
	'View all comments on this [_1]' => 'Alle Kommentare zu diesem Eintrag oder dieser Seite',
	'Date' => 'Datum',
	'Date this comment was made' => 'Datum, an dem dieser Kommentar abgegeben wurde',
	'View all comments created on this day' => 'Alle Kommentare dieses Tages anzeigen',
	'IP' => 'IP',
	'IP Address of the commenter' => 'IP-Adresse des Kommentarautors',
	'View all comments from this IP address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
	'Fulltext of the comment entry' => 'Vollständiger Kommentartext',
	'Responses to this comment' => 'Reaktionen auf diesen Kommentar',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Seite bearbeiten',
	'Create Page' => 'Seite anlegen',
	'Add folder' => 'Ordner hinzufügen',
	'Add folder name' => 'Ordnername hinzufügen',
	'Add new folder parent' => 'Neuen übergeordneten Ordner hinzufügen',
	'Preview this page (v)' => 'Vorschau (v)',
	'Delete this page (x)' => 'Seite löschen (x)',
	'View Page' => 'Seite ansehen',
	'Edit Entry' => 'Eintrag bearbeiten',
	'Create Entry' => 'Neuen Eintrag schreiben',
	'Add category' => 'Kategorie hinzufügen',
	'Add category name' => 'Kategoriename hinzufügen',
	'Add new category parent' => 'Neue übergeordnete Kateotrie hinzufügen',
	'Manage Entries' => 'Einträge verwalten',
	'Preview this entry (v)' => 'Vorschau (v)',
	'Delete this entry (x)' => 'Eintrag löschen (x)',
	'View Entry' => 'Eintrag ansehen',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Eintrag automatisch gespeichert [_2]. <a href="[_1]>Automatisch gespeicherte Version wiederherstellen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Seite automatisch gespeichert [_2]. <a href="[_1]>Automatisch gespeicherte Version wiederherstellen</a>',
	'This entry has been saved.' => 'Eintrag gespeichert.',
	'This page has been saved.' => 'Seite gesichert.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
	'_USAGE_VIEW_LOG' => 'Nähere Informationen zum aufgetretenen Fehler finden Sie im <a href="[_1]">Aktivitätsprotokoll</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Einstellungen gespeichert.',
	'Your changes to the comment have been saved.' => 'Kommentaränderungen gespeichert.',
	'Your notification has been sent.' => 'Benachrichtigung gesendet.',
	'You have successfully recovered your saved entry.' => 'Gespeicherten Eintrag erfolgreich wiederhergestellt.',
	'You have successfully recovered your saved page.' => 'Gespeicherte Seite erfolgreich wiederhergestellt.',
	'An error occurred while trying to recover your saved entry.' => 'Bei der Wiederherstellung des gespeicherten Eintrags ist ein Fehler aufgetreten.',
	'An error occurred while trying to recover your saved page.' => 'Bei der Wiederherstellung der gespeicherten Seite ist ein Fehler aufgetreten.',
	'You have successfully deleted the checked comment(s).' => 'Die markierten Kommentare wurden erfolgreich gelöscht.',
	'You have successfully deleted the checked TrackBack(s).' => 'Die markierten TrackBacks wurden erfolgreich gelöscht.',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Version wiederherstellen (Datum: [_1]). Aktueller Status: [_2]',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltenen Tags können nicht geladen werden, da sie entfernt wurden.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltene [_1] können nicht geladen werden, da sie entfernt wurden.',
	'Change Folder' => 'Ordner wechseln',
	'Unpublished (Draft)' => 'Unveröffentlicht (Entwurf)',
	'Unpublished (Review)' => 'Unveröffentlicht (Prüfung)',
	'Scheduled' => 'Zu bestimmtem Zeitpunkt',
	'Unpublished (Spam)' => 'Unveröffentlicht (Spam)',
	'Revision: <strong>[_1]</strong>' => 'Revision <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Revisionen dieser/dieses [_1] anzeigen',
	'View revisions' => 'Revisionen anzeigen',
	'No revision(s) associated with this [_1]' => 'Keine Revision(en) mit dieser/diesem [_1] verknüpft',
	'[_1] - Published by [_2]' => 'Veröffentlicht von [_2] [_1]',
	'[_1] - Edited by [_2]' => 'Bearbeitet von [_2] [_1]',
	'Save' => 'OK',
	'Save Draft' => 'Speichern',
	'Draft this [_1]' => '[_1] als Entwurf speichern',
	'Publish this [_1]' => '[_1] veröffentlichen',
	'Update' => 'Aktualisieren',
	'Update this [_1]' => '[_1] aktualisieren',
	'Unpublish' => 'Nicht mehr veröffentlichen',
	'Unpublish this [_1]' => '[_1] nicht mehr veröffentlichen',
	'Save this [_1]' => '[_1] speichern',
	'Publish On' => 'Veröffentlichen um',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links zu diesem Eintrag ungültig werden.',
	'Change note' => 'Änderungshinweis',
	'You must configure this blog before you can publish this entry.' => 'Bitte konfigurieren Sie das Blog, bevor Sie einen Eintrag veröffentlichen.',
	'You must configure this blog before you can publish this page.' => 'Bitte konfigurieren Sie das Blog, bevor Sie eine Seite veröffentlichen.',
	'edit' => 'Bearbeiten',
	'close' => 'schließen',
	'Accept' => 'Annehmen',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
	'Outbound TrackBack URLs' => 'TrackBack- URLs',
	'[_1] Assets' => '[_1] Assets',
	'Remove this asset.' => 'Dieses Asset entfernen',
	'Remove' => 'Entfernen',
	'No assets' => 'Keine Assets',
	'You have unsaved changes to this entry that will be lost.' => 'Es liegen nicht gespeicherte Eintragsänderungen vor, die verloren gehen werden.',
	'You have unsaved changes to this page that will be lost.' => 'Es liegen nicht gespeicherte Seitenänderungen vor, die verloren gehen werden.',
	'Enter the link address:' => 'Link-Adresse eingeben:',
	'Enter the text to link to:' => 'Link-Text eingeben:',
	'Your entry screen preferences have been saved.' => 'Einstellungen gespeichert.',
	'Are you sure you want to use the Rich Text editor?' => 'Grafischen Editor wirklich verwenden?',
	'Make primary' => 'Als Hauptkategorie',
	'Display Options' => 'Anzeigeoptionen',
	'Fields' => 'Felder',
	'Metadata' => 'Metadaten',
	'Reset display options' => 'Anzeigeoptionen zurücksetzen',
	'Reset display options to blog defaults' => 'Anzeigeoptionen auf Standardeinstellungen zurücksetzen',
	'Reset defaults' => 'Auf Standardeinstellungen zurücksetzen',
	'Save display options' => 'Anzeigeoptionen speichern',
	'OK' => 'OK',
	'This post was held for review, due to spam filtering.' => 'Dieser Eintrag wurde vom Spam-Filter zur Moderation zurückgehalten.',
	'This post was classified as spam.' => 'Dieser Eintrag wurde als Spam erfasst.',
	'Spam Details' => 'Spam-Details',
	'Permalink:' => 'Permalink:',
	'Share' => 'Teilen',
	'Format:' => 'Formatierung:',
	'(comma-delimited list)' => '(Liste mit Kommatrennung)',
	'(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
	'(delimited by \'[_1]\')' => '(Trennung durch &#8222;[_1]&#8220;)',
	'None selected' => 'Keine gewählt',
	'Auto-saving...' => 'Autospeichern...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Zuletzt automatisch gespeichert um [_1]:[_2]:[_3]',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Ordner bearbeiten',
	'Your folder changes have been made.' => 'Änderungen gespeichert',
	'Manage Folders' => 'Ordner verwalten',
	'Manage pages in this folder' => 'Seiten in diesem Ordner verwalten',
	'You must specify a label for the folder.' => 'Sie müssen diesem Ordner eine Bezeichnung geben',
	'Path' => 'Pfad',
	'Save changes to this folder (s)' => 'Ordneränderungen speichern (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'TrackBack bearbeiten',
	'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
	'Manage TrackBacks' => 'TrackBacks verwalten',
	'View [_1]' => '[_1] ansehen',
	'Save changes to this TrackBack (s)' => 'TrackBack-Änderungen speichern (s)',
	'Delete this TrackBack (x)' => 'Diesen TrackBack löschen (x)',
	'Update the status of this TrackBack' => 'TrackBack-Status aktualisieren',
	'Junk' => 'Spam',
	'View all TrackBacks with this status' => 'Alle TrackBacks mit diesem Status ansehen',
	'Source Site' => 'Quelle',
	'Search for other TrackBacks from this site' => 'Weitere TrackBacks von dieser Site suchen',
	'Source Title' => 'Quellname',
	'Search for other TrackBacks with this title' => 'Weitere TrackBacks mit diesem Namen suchen',
	'Search for other TrackBacks with this status' => 'Weitere TrackBacks mit diesem Status suchen',
	'Target [_1]' => 'Ziel-[_1]',
	'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
	'No title' => 'Kein Name',
	'View all TrackBacks on this entry' => 'Alle TrackBacks bei diesem Eintrag anzeigen',
	'Target Category' => 'Zielkategorie',
	'Category no longer exists' => 'Kategorie nicht mehr vorhanden',
	'View all TrackBacks on this category' => 'Alle TrackBacks in dieser Kategorie anzeigen',
	'View all TrackBacks created on this day' => 'Alle TrackBacks dieses Tages anzeigen',
	'View all TrackBacks from this IP address' => 'Alle TrackBacks von dieser IP-Adrese anzeigen',
	'TrackBack Text' => 'TrackBack-Text',
	'Excerpt of the TrackBack entry' => 'TrackBack-Auszug',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Rolle bearbeiten',
	'List Roles' => 'Rollen auflisten',
	'[quant,_1,User,Users] with this role' => '[quant,_1,Benutzer,Benutzer] mit dieser Rolle',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Sie haben die Berechtigungen dieser Rolle geändert. Dadurch werden auch die Berechtigungen der mit dieser Rolle verknüpften Benutzer beeinflusst. Wenn Sie möchten, können Sie daher die Rolle unter neuem Namen speichern.',
	'Role Details' => 'Rolleneigenschaften',
	'Created by' => 'Angelegt von',
	'System' => 'System',
	'Privileges' => 'Berechtigungen',
	'Administration' => 'Verwalten',
	'Authoring and Publishing' => 'Schreiben und veröffentlichen',
	'Designing' => 'Gestalten',
	'Commenting' => 'Kommentieren',
	'Duplicate Roles' => 'Rollen duplizieren',
	'These roles have the same privileges as this role' => 'Folgende Rollen haben die gleichen Berechtigungen wie diese Rolle',
	'Save changes to this role (s)' => 'Rollenänderungen speichern (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Widget bearbeiten',
	'Create Widget' => 'Widget anlegen',
	'Create Template' => 'Vorlage anlegen',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => '[_1] automatisch gespeichert [_3]. <a href="[_2]">Automatisch gespeicherte Version wiederherstellen</a>.',
	'You have successfully recovered your saved [_1].' => 'Gespeicherte Fassung erfolgreich wiederhergestellt.',
	'An error occurred while trying to recover your saved [_1].' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'Restored revision (Date:[_1]).' => 'Revision wiederhergestellt (Datum: [_1])',
	'Your template changes have been saved.' => 'Die Änderungen an der Vorlage wurden gespeichert.',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'Vorlage <a href="[_1]" class="rebuild-link">veröffentlichen</a>.',
	'Your [_1] has been published.' => '[_1] wurde veröffentlicht.',
	'View revisions of this template' => 'Revisionen dieser Vorlage anzeigen',
	'No revision(s) associated with this template' => 'Keine Revision(en) mit dieser Vorlage verknüpft',
	'Useful Links' => 'Nützliche Links',
	'Module Option Settings' => 'Moduloption-Einstellungen',
	'List [_1] templates' => 'Zeige [_1]-Vorlagen',
	'List all templates' => 'Zeige alle Vorlagen',
	'View Published Template' => 'Veröffentlichte Vorlage ansehen',
	'Included Templates' => 'Eingebundene Vorlagen',
	'create' => 'anlegen',
	'Template Tag Docs' => 'Dokumentation der Vorlagenbefehle',
	'Unrecognized Tags' => 'Nicht erkannte Befehle',
	'Save (s)' => 'Sichern (s)',
	'Save Changes (s)' => 'Änderungen speichern (s)',
	'Save and Publish this template (r)' => 'Vorlage speichern und veröffentlichen (r)',
	'Save &amp; Publish' => 'Speichern und veröffentlichen',
	'You have unsaved changes to this template that will be lost.' => 'Es liegen nicht gespeicherte Vorlagenänderungen, die verloren gehen werden.',
	'You must set the Template Name.' => 'Sie müssen einen Vorlagennamen angeben.',
	'You must set the template Output File.' => 'Sie müssen einen Dateinamen angeben.',
	'Processing request...' => 'Verarbeite Anfrage...',
	'Error occurred while updating archive maps.' => 'Bei der Aktualisierung der Archivverknüpfungen ist ein Fehler aufgetreten.',
	'Archive map has been successfully updated.' => 'Archivverknüpfung erfolgreich aktualisiert.',
	'Are you sure you want to remove this template map?' => 'Archivverknüpfung wirklich löschen?',
	'Module Body' => 'Modul-Code',
	'Template Body' => 'Vorlagen-Code',
	'Template Options' => 'Vorlagenoptionen',
	'Output file: <strong>[_1]</strong>' => 'Ausgabedatei: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Aktivierte Verknüpfungen: [_1]',
	'Template Type' => 'Vorlagen-Typ',
	'Custom Index Template' => 'Individuelle Indexvorlage',
	'Link to File' => 'Mit Datei verlinken',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">Mehr über Veröffentlichungs-Einstellungen erfahren</a>',
	'Create Archive Mapping' => 'Neue Archivverknüpfung einrichten',
	'Statically (default)' => 'Statisch (Standard)',
	'Via Publish Queue' => 'Im Hintergrund',
	'On a schedule' => 'Zeitgeplant',
	': every ' => ': alle ',
	'minutes' => 'Minuten',
	'hours' => 'Stunden',
	'Dynamically' => 'Dynamisch',
	'Manually' => 'Manuell',
	'Do Not Publish' => 'Nicht veröffentlichen',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Als <strong>[_1]</strong>-Include verarbeiten',
	'Include cache path' => 'Include Cache-Pfad',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deaktiviert (<a href="[_1]">Veröffentlichungsoptionen ändern</a>)',
	'No caching' => 'Keine Caching',
	'Expire after' => 'Verfallen lassen nach',
	'Expire upon creation or modification of:' => 'Verfallen lassen bei Anlage oder Änderung von:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'Website anlegen',
	'Website Theme' => 'Website-Thema',
	'Select the theme you wish to use for this website.' => 'Wählen Sie das Thema, das Sie für diese Website verwenden möchten.',
	'Name your website. The website name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre Website. Sie können der Name  auch später jederzeit ändern.',
	'Website Root' => 'Wurzelverzeichnis der Website',
	'Create Website (s)' => 'Website anlegen (s)',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Widgetgruppe bearbeiten',
	'Create Widget Set' => 'Widgetgruppe anlegen',
	'Your widget set changes have been saved.' => 'Die Änderungen an der Widgetgruppe wurden gespeichert.',
	'Widget Set Name' => 'Name der Widgetgruppe',
	'Drag and drop the widgets that belong in this Widget Set into the \'Installed Widgets\' column.' => 'Ziehen Sie die Widgets, die in diese Widgetgruppe gehören, in die Spalte  &#8222;Installierte Wigets&#8220;.',
	'Installed Widgets' => 'Installierte Widgets',
	'Available Widgets' => 'Verfügbare Widgets',
	'Save changes to this widget set (s)' => 'Widgetänderungen speichern (s)',
	'You must set Widget Set Name.' => 'Bitte wählen Sie einen Namen für die Widgetgruppe.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Es ist ein Fehler aufgetreten',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => '[_1]-Themen exportieren',
	'Theme package have been saved.' => 'Themenpaket gespeichert.',
	'The name of your theme.' => 'Der Name Ihres Themas',
	'Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, \'-\' or \'_\').' => 'Verwenden Sie bitte nur Buchstaben, Zahlen, Bindestriche oder Unterstriche  (a-z, A-Z, 0-9, &#8222;-&#8220; oder &#8222;_&#8220;).',
	'Version' => 'Version',
	'A version number for this theme.' => 'Die Versionsnummer dieses Themas.',
	'A description for this theme.' => 'Eine Beschreibung dieses Themas',
	'_THEME_AUTHOR' => 'Autor',
	'The author of this theme.' => 'Der Name des Autors dieses Themas',
	'Author link' => 'Autoren-Link',
	'The author\'s website.' => 'Die Website des Autors.',
	'Additional assets to be included in the theme.' => 'Zu diesem Thema gehörende Assets',
	'Destination' => 'Ziel',
	'Select How to get theme.' => 'Bezugsmethode wählen',
	'Setting for [_1]' => 'Einstellungen für [_1]',
	'You must set Theme Name.' => 'Bitte geben Sie einen Namen für das Thema ein.',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Basisnamen müssen mit einem Buchstaben anfangen und dürfen nur  Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => 'Das Thema kann nicht mit diesem Basisnamen installiert, da dieser bereits vorhanden und geschützt ist.',
	'You must set Author Name.' => 'Bitte geben Sie einen Autorennamen an.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Versionsnamen dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',

## tmpl/cms/export.tmpl
	'Export Blog Entries' => 'Blogeinträge exportieren',
	'You must select a blog to export.' => 'Sie müssen wählen, welches Blog exportiert werden soll.',
	'_USAGE_EXPORT_1' => 'Hier können Sie die Einträge, Kommentare und TrackBacks eines Blogs exportieren. Ein Export stellt <em>keine</em> komplette Sicherung eines Blogs dar. Verwenden Sie dafür die Funktion Sichern/Wiederherstellen.',
	'Blog to Export' => 'Zu exportierendes Blog',
	'Select a blog for exporting.' => 'Zu exportierendes Blog',
	'Change blog' => 'Anderes Blog wählen',
	'Select blog' => 'Blog wählen',
	'Export Blog (s)' => 'Blog exportieren (s)',
	'Export Blog' => 'Blog exportieren',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML-Code am Überschriftenanfang (optional)',
	'End title HTML (optional)' => 'HTML-Code am Überschriftenende (optional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Wenn Sie aus einem Weblog-System importieren, das kein eigenes Feld für Überschriften hat, können Sie hier angeben, welche HTML-Ausdrücke den Anfang und das Ende von Überschriften markieren.',
	'Default entry status (optional)' => 'Standard-Eintragsstatus (optional)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Wenn Sie aus einem Weblog-System importieren, das in seiner Exportdatei den Eintragsstatus nicht vermerkt, können Sie hier angeben, welcher Status den importierten Einträgen zugewiesen werden soll.',
	'Select an entry status' => 'Eintragsstatus wählen',

## tmpl/cms/import.tmpl
	'Import Blog Entries' => 'Blog-Einträge importieren',
	'You must select a blog to import.' => 'Wählen Sie, in welches Blog importiert werden soll',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Mit der Import/Export-Funktion können Sie Einträge aus anderen Movable Type-Installationen oder aus anderen Weblog-Systemen übernehmen. Bestehende Einträge können in einem Austauschformat gesichert werden.',
	'Import data into' => 'Daten importieren in',
	'Select a blog to import.' => 'Wählen Sie, in welches Blog importiert werden soll',
	'Importing from' => 'Importieren aus',
	'Ownership of imported entries' => 'Besitzer importierter Einträge',
	'Import as me' => 'Einträge unter meinem Namen importieren',
	'Preserve original user' => 'Einträge unter ursprünglichen Namen importieren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Benutzernamen importieren und einer oder mehrere der Benutzer in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
	'Default password for new users:' => 'Standard-Passwort für neue Benutzer:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Alle importierten Einträge werden Ihnen zugewiesen werden. Wenn Sie möchten, daß die Einträge ihren ursprünglichen Benutzern zugewiesen bleiben, lassen Sie den Import von Ihren Administrator durchführen. Dann werden etwaige erforderliche, aber noch fehlende Benutzerkonten automatisch angelegt.',
	'Upload import file (optional)' => 'Import-Datei hochladen (optional)',
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Wenn Sie eine auf Ihrem Computer gespeicherte Importdatei verwenden wollen, laden Sie diese hier hoch. Alternativ verwendet Movable Type automatisch die Importdatei, die es im &#8222;import&#8220;-Unterordner Ihres Movable Type-Verzeichnis findet.',
	'Import File Encoding' => 'Zeichenkodierung der Importdatei',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Type versucht automatisch die korrekte Zeichenkodierung auszuwählen. Sollte das fehlschlagen, können Sie sie auch explizit angeben.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Standard-Kategorie für Einträge (optional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Standardkdategorie für importierte Einträge ohne Kategorie',
	'Select a category' => 'Kategorie auswählen...',
	'Import Entries (s)' => 'Einträge importieren (s)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Kommentare von unbekannten und nicht authentifizierten Benutzern annehmen.',
	'Require E-mail Address for Anonymous Comments' => 'E-Mail-Adresse von nicht registrierten Kommentarautoren verlangen',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn diese Option aktiv ist, müssen Kommentarautoren eine gültige E-Mail-Adresse angeben.',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Größerer Text',
	'Increase Text Size' => 'Kleinerer Text',
	'Bold' => 'Fett',
	'Italic' => 'Kursiv',
	'Underline' => 'Unterstreichen',
	'Strikethrough' => 'Durchstreichen',
	'Text Color' => 'Textfarbe',
	'Email Link' => 'E-Mail-Link',
	'Begin Blockquote' => 'Zitat Anfang',
	'End Blockquote' => 'Zitat Ende',
	'Bulleted List' => 'Aufzählung',
	'Numbered List' => 'Nummerierte Liste',
	'Left Align Item' => 'Linksbündig',
	'Center Item' => 'Zentieren',
	'Right Align Item' => 'Rechtsbündig',
	'Left Align Text' => 'Linksbündiger Text',
	'Center Text' => 'Zentrierter Text',
	'Right Align Text' => 'Rechtsbündiger Text',
	'Insert File' => 'Datei einfügen',
	'WYSIWYG Mode' => 'Grafischer Editor',
	'HTML Mode' => 'HTML-Modus',

## tmpl/cms/include/archive_maps.tmpl
	'Custom...' => 'Individuell...',

## tmpl/cms/include/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Eine Datei namens &#8222;[_1]&#8220; ist bereits vorhanden. Möchten Sie sie überschreiben?',
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	'No' => 'Nein',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Gewählte Assets löschen (x)',
	'Website/Blog' => 'Website/Blog',
	'Created By' => 'Erstellt von',
	'Created On' => 'Angelegt',
	'Asset Missing' => 'Asset fehlt',

## tmpl/cms/include/asset_upload.tmpl
	'You must set a valid destination.' => 'Bitte geben Sie ein gültiges Ziel ein.',
	'Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]\'s publishing paths[_3] and republish your [_1].' => 'Veröffentlichen Sie zuerst Ihr(e) [_1], um Dateien hochladen zu können. [_2]Konfigurieren Sie die jeweiligen Veröffentlichungs-Pfade[_3] und veröffentlichen Sie die Site bzw. das Blog dann erneut. ',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Um Dateien hochladen zu können, muss Ihr System- oder [_1]-Administrator die Site bzw. das Blog bereits veröffentlicht haben. Bitte kontaktieren Sie daher ihren System- oder [_1]-Administrator.',
	'Asset file(\'[_1]\') has been uploaded.' => 'Asset-Datei (&#8222;[_1]&#8220;) hochgeladen.',
	'Select File to Upload' => 'Hochzuladende Datei wählen',
	'_USAGE_UPLOAD' => 'Dateien können auch in Unterverzeichnisse des gewählten Pfads hochgeladen werden. Existiert das Unterverzeichnis noch nicht, wird es automatisch angelegt.',
	'Upload Destination' => 'Zielverzeichnis',
	'Choose Folder' => 'Ordner wählen',
	'Upload (s)' => 'Hochladen (s)',
	'Upload' => 'Hochladen',

## tmpl/cms/include/author_table.tmpl

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Alle Daten wurden erfolgreich gesichert!',
	'Download This File' => 'Diese Datei herunterladen',
	'_BACKUP_TEMPDIR_WARNING' => 'Gewünschte Daten erfolgreich im Ordner [_1] gesichert. Bitte laden Sie die angegebenen Dateien <strong>sofort</strong> aus [_1] herunter und <strong>löschen</strong> Sie sie unmittelbar danach aus dem Ordner, da sie sensible Informationen enthalten.',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'Der Download der Sicherungsdatei wird in einigen Sekunden automatisch beginnen. Sollte das nicht der Fall sein, klicken Sie <a href="javascript:(void)" onclick="submit_form()">hier</a> um den Download manuell zu starten. Pro Sitzung kann eine Sicherungsdatei nur einmal heruntergeladen werden.',
	'An error occurred during the backup process: [_1]' => 'Beim Backup ist ein Fehler aufgetreten: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Erstelle Sicherung',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Markierte [_1] löschen (x)',
	'[_1] Name' => '[_1] Name',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '1',
	'S|M|T|W|T|F|S' => 'S|M|D|M|D|F|S',
	'January' => 'Januar',
	'Febuary' => 'Februar',
	'March' => 'März',
	'April' => 'April',
	'May' => 'Mai',
	'June' => 'Juni',
	'July' => 'Juli',
	'August' => 'August',
	'September' => 'September',
	'October' => 'Oktober',
	'November' => 'November',
	'December' => 'Dezember',
	'Jan' => 'Jan',
	'Feb' => 'Feb',
	'Mar' => 'Mrz',
	'Apr' => 'Apr',
	'_SHORT_MAY' => 'Mai',
	'Jun' => 'Jun',
	'Jul' => 'Jul',
	'Aug' => 'Aug',
	'Sep' => 'Sep',
	'Oct' => 'Okt',
	'Nov' => 'Nov',
	'Dec' => 'Dez',
	'[_1:calMonth] [_2:calYear]' => '[_1:calMonth] [_2:calYear]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Unterkategorie hinzufügen',
	'Add sub folder' => 'Neuer Unterordner',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Zuletzt kommentiert',
	'Only show trusted commenters' => 'Nur vertrauenswürdige Kommentarautoren anzeigen',
	'Only show banned commenters' => 'Nur gesperrte Kommentarautoren anzeigen',
	'Only show neutral commenters' => 'Nur neutrale Kommentarautoren anzeigen',
	'Edit this commenter' => 'Kommentarautor bearbeiten',
	'View this commenter&rsquo;s profile' => 'Profil des Kommentarautors ansehen',

## tmpl/cms/include/comment_table.tmpl
	'to publish' => 'zu veröffentlichen',
	'Publish selected comments (a)' => 'Gewählte Kommentare veröffentlichen (a)',
	'Delete selected comments (x)' => 'Gewählte Kommentare löschen (x)',
	'Report selected comments as Spam (j)' => 'Gewählte Kommentare als Spam melden (j)',
	'Report selected comments as Not Spam and Publish (j)' => 'Gewählte Kommentare als gültig melden und veröffentlichen (j)',
	'Not Spam' => 'Nicht Spam',
	'Are you sure you want to remove all comments reported as spam?' => 'Wirklich alle als Spam gemeldeten Kommentare löschen?',
	'Delete all comments reported as Spam' => 'Alle als Spam gemeldeten Kommentare löschen',
	'Empty' => 'Leer',
	'Entry/Page' => 'Eintrag/Seite',
	'Only show published comments' => 'Nur veröffentlichte Kommentare anzeigen',
	'Only show spam comments' => 'Nur Spam-Kommentare zeigen',
	'Only show pending comments' => 'Nur nicht veröffentlichte Kommentare anzeigen',
	'Edit this comment' => 'Kommentar bearbeiten',
	'([quant,_1,reply,replies])' => '([quant,_1,Antwort,Antworten])',
	'Blocked' => 'Gesperrt',
	'Edit this [_1] commenter' => '[_1] Kommentarautor bearbeiten',
	'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentarautor suchen',
	'View this entry' => 'Diesen Eintrag ansehen',
	'View this page' => 'Diese Seite ansehen',
	'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. Alle Rechte vorbehalten.',

## tmpl/cms/include/display_options.tmpl
	'_DISPLAY_OPTIONS_SHOW' => 'Zeige',
	'[quant,_1,row,rows]' => '[quant,_1,Zeile,Zeilen]',
	'Compact' => 'Kompakt',
	'Expanded' => 'Erweitert',
	'Date Format' => 'Zeit- angaben',
	'Relative' => 'Relativ',
	'Full' => 'Absolut',

## tmpl/cms/include/entry_table.tmpl
	'Save these [_1] (s)' => 'Diese [_1] speichern (s)',
	'Republish selected [_1] (r)' => 'Gewählte [_1] erneut veröffentlchen (r)',
	'Last Modified' => 'Zuletzt geändert',
	'Created' => 'Angelegt',
	'Only show unpublished entries' => 'Nur unveröffentlichte Einträge anzeigen',
	'Only show unpublished pages' => 'Nur unveröffentlichte Seiten anzeigen',
	'Only show published entries' => 'Nur veröffentlichte Einträge anzeigen',
	'Only show published pages' => 'Nur veröffentlichte Seiten anzeigen',
	'Only show entries for review' => 'Nur zu prüfende Einträge anzeigen',
	'Only show pages for review' => 'Nur zu prüfende Seiten anzeigen',
	'Only show scheduled entries' => 'Nur zeitgeplante Einträge anzeigen',
	'Only show scheduled pages' => 'Nur zeitgeplante Seiten anzeigen',
	'Only show spam entries' => 'Nur Spam-Einträge anzeigen',
	'Only show spam pages' => 'Nur Spam-Seiten anzeigen',
	'View entry' => 'Eintrag ansehen',
	'View page' => 'Seite ansehen',
	'No entries could be found.' => 'Keine Einträge gefunden.',
	'<a href="[_1]">Create an entry</a> now.' => 'Jetzt <a href="[_1]">einen Eintrag schreiben</a>.',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'Keine Seiten gefunden. Jetzt <a href="[_1]">eine Seite anlegen</a>.',
	'to republish' => 'zur erneuten Veröffentlichung',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Aktivitäts-Feed',
	'Set Web Services Password' => 'Passwort für Webdienste wählen',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Das ist eine Beta-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/',
	'Support' => 'Support',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'Forums' => 'Foren',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html',
	'Send Us Feedback' => 'Feedback senden',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> Version [_2]',
	'with' => 'mit',
	'Your Dashboard' => 'Ihre Übersichtsseite',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'Angemeldet als [_1]',
	'Help' => 'Hilfe',
	'Sign out' => 'Abmelden',
	'User Dashboard' => 'Benutzer-Übersichtsseite',
	'Select another website...' => 'Andere Website wählen...',
	'(on [_1])' => '(auf [_1])',
	'Select another blog...' => 'Anderes Blog wählen',
	'Create Blog (on [_1])' => 'Blog anlegen (auf [_1])',
	'View Site' => 'Ansehen',
	'Search (q)' => 'Suche (q)',
	'This website was created during the version-up from the previous version of Movable Type. \'Site Root\' and \'Site URL\' are left blank to retain \'Publishing Paths\' compatibility for blogs those were created at the previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank \'Site Root\' and \'Site URL\'.' => 'Diese Website wurde im Rahmen einer Aktualisierung dieser Movable Type-Installation angelegt. Die Felder &#8222;Wurzelverzeichnis&#8220; und &#8222;Webadresse&#8220; sind leer, um die Kompatibilität  mit bestehenden Blogs zu wahren.  Sie können auf vorhandenen Blogs weiterhin veröffentlichen, diese übergeordnete Website aber solange nicht veröffentlichen, wie die Felder &#8222;Wurzelverzeichnis&#8220; und  &#8222;Webadresse&#8220; leer sind.',
	'from Revision History' => 'aus der Revisionshistorie',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Alle Daten erfolgreich importiert!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importieren...',
	'Importing entries into blog' => 'Importiere Einträge...',
	'Importing entries as user \'[_1]\'' => 'Importiere Einträge als Benutzer &#8222;[_1]&#8220;...',
	'Creating new users for each user found in the blog' => 'Lege Benutzerkonten für jeden Benutzer des Blogs an...',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Weitere Aktionen...',
	'Plugin Actions' => 'Plugin-Aktionen',
	'Go' => 'Ausführen',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => 'Berechtigungen für [_1]',
	'Manage Permissions' => 'Berechtigungen verwalten',
	'Users for [_1]' => 'Benutzer für [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Schritt [_1] von [_2]',
	'Go to [_1]' => 'Gehe zu [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Keine Treffer. Bitte suchen Sie erneut.',
	'Sorry, there is no data for this object set.' => 'Keine Daten für diese Objekte vorhanden.',
	'OK (s)' => 'OK (s)',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Benutzername speichern?',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Keine Protokolleinträge gefunden.',
	'_LOG_TABLE_BY' => 'Von',
	'Show Datail' => 'Details anzeigen',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/member_table.tmpl
	'user' => 'Benutzer',
	'users' => 'Benutzer',
	'Are you sure you want to remove the selected user from this blog?' => 'Gewählte Benutzer wirklich aus diesem Blog entfernen?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => 'Gewählte [_1] Benutzer wirklich aus diesem Blog entfernen?',
	'Remove selected user(s) (r)' => 'Gewählte(n) Benutzer entfernen (r)',
	'Trusted commenter' => 'Vertrauter Kommentarautor',
	'Remove this role' => 'Rolle entfernen',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Hinzugefügt am',
	'Click to edit contact' => 'Klicken, um Kontakt zu bearbeiten',
	'Save changes' => 'Änderungen speichern',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Markierte [_1] veröffentlichen (p)',
	'Report selected [_1] as Spam (j)' => 'Markierte [_1] als Spam melden',
	'Report selected [_1] as Not Spam and Publish (j)' => 'Markierte [_1] freischalten (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'Wirklich alle als Spam gemeldeten TrackBacks löschen?',
	'Deletes all [_1] reported as Spam' => 'Alle als Spam gemeldeten [_1] löschen',
	'From' => 'Von',
	'Target' => 'Nach',
	'Only show published TrackBacks' => 'Nur veröffentlichte TrackBacks anzeigen',
	'Only show spam TrackBacks' => 'Nur Spam-TrackBacks zeigen',
	'Only show pending TrackBacks' => 'Nur nicht veröffentlichte TrackBacks anzeigen',
	'Edit this TrackBack' => 'TrackBack bearbeiten',
	'Go to the source entry of this TrackBack' => 'Eintrag, auf den sich das TrackBack bezieht, aufrufen',
	'View the [_1] for this TrackBack' => '[_1] zu diesem TrackBack ansehen',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Keine Revisionen vorhanden',
	'Note' => 'Hinweis',
	'Saved By' => 'Gesichert von',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz-Meldung',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Archiv-Vorlage anlegen:',
	'Entry Listing' => 'Eintragsliste',
	'Create template module' => 'Vorlagenmodul anlegen',
	'Create index template' => 'Indexvorlage anlegen',
	'Publish selected templates (a)' => 'Ausgewählte Vorlagen veröffentlichen (a)',
	'SSI' => 'SSI',
	'Cached' => 'In Cache',
	'Linked Template' => 'Verlinkte Vorlage',
	'-' => '-',
	'Manual' => 'Manuell',
	'Dynamic' => 'Dynamisch',
	'Publish Queue' => 'Im Hintergrund',
	'Static' => 'Statisch',
	'templates' => 'Vorlagen',

## tmpl/cms/include/theme_exporters/category.tmpl
	'Category Name' => 'Kategoriename',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Ordnername',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'Dateien dieser Typen werden in das Thema aufgenommen: [_1]. Dateien anderen Typs werden ignoriert.',
	'Specify directories' => 'Verzeichnis angeben',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Geben Sie die Verzeichnisse ab Wurzelverzeichnis der Site an, die statische Dateien des Themas enthalten, z.B. css, images, js usw. Verwenden Sie pro Verzeichnis eine Zeile.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'Widgetgruppen',
	'modules' => 'Module',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] enthalten',

## tmpl/cms/include/users_content_nav.tmpl

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Willkommen zu Movable Type',
	'Create Your Account' => 'Legen Sie Ihr Benutzerkonto an',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Wir empfehlen dringend, die Perl-Installation mindestens auf Version [_1] zu aktualisieren. Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>.',
	'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?',
	'View MT-Check (x)' => 'MT-Check anzeigen (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Legen Sie nun ein Administratoren-Konto für Ihr System an. Movable Type wird daraufhin Ihre Datenbank initialisieren.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Um fortfahren zu können, müssen Sie sich gegenüber Ihrem LDAP-Server authentifizieren',
	'The name used by this user to login.' => 'Anmeldename dieses Benutzerkontos',
	'The name used when published.' => 'Anzeigename (für Veröffentlichung)',
	'The user&rsquo;s email address.' => 'E-Mail-Adresse dieses Benutzers',
	'The email address used in the From: header of each email sent from the system.' => 'Die E-Mail-Adresse, die als Absenderadresse vom System versandter E-Mails verwendet wird',
	'Use this as system email address' => 'Diese Adresse als System-E-Mail-Adresse verwenden',
	'The user&rsquo;s preferred language.' => 'Gewünschte Spracheinstellung',
	'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
	'Your LDAP username.' => 'Ihr LDAP-Benutzername.',
	'Enter your LDAP password.' => 'Geben Sie Ihr LDAP-Passwort ein.',
	'The initial account name is required.' => 'Benutzername erforderlich',
	'The display name is required.' => 'Anzeigename erforderlich',
	'The e-mail address is required.' => 'Bitte geben Sie Ihre E-Mail-Adresse an.',
	'Password recovery word/phrase is required.' => 'Passwort-Erinnerungsfrage erforderlich',

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'Assets erfolgreich gelöscht.',
	'New Asset' => 'Neues Asset',
	'Quickfilters' => 'Schnellfilter',
	'Showing only: [_1]' => 'Zeige nur: [_1]',
	'Remove filter' => 'aufheben',
	'All [_1]' => 'Alle [_1]',
	'change' => 'ändern',
	'[_1] where [_2] is [_3]' => '[_1] mit [_2] [_3]',
	'Show only assets where' => 'Zeige nur Assets mit',
	'type' => 'Typ',
	'tag (exact match)' => 'Tag (genau)',
	'tag (fuzzy match)' => 'Tag (unscharf)',
	'is' => ' ',
	'Filter' => 'Zeigen',

## tmpl/cms/list_association.tmpl
	'Members' => 'Mitglieder',
	'permission' => 'Berechtigung',
	'permissions' => 'Berechtigungen',
	'Remove selected permissions (x)' => 'Gewählte Berechtigungen entziehen (x)',
	'Revoke Permission' => 'Berechtigung entziehen',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_1] <em>[_2]</em> ist derzeit deaktiviert.',
	'Grant Website Permission' => 'Website-Berechtigung zuweisen',
	'Grant Blog Permission' => 'Blog-Berechtigung zuweisen',
	'You can not create permissions for disabled users.' => 'Deaktivierten Benutzern können keine Berechtigungen zugewiesen werden.',
	'Grant Permission' => 'Berechtigungen zuweisen',
	'Assign Website Role to User' => 'Website-Rolle an Benutzer zuweisen',
	'Assign Blog Role to User' => 'Blog-Rolle an Benutzer zuweisen',
	'Add a user to this blog' => 'Benutzer zu diesem Blog hinzufügen',
	'Grant website permission to a user' => 'Website-Berechtigung an Benutzer zuweisen',
	'Grant blog permission to a user' => 'Blog-Berechtigung an Benutzer zuweisen',
	'You have successfully revoked the given permission(s).' => 'Berechtigungen erfolgreich entzogen',
	'You have successfully granted the given permission(s).' => 'Berechtigungen erfolgreich zugewiesen',
	'No permissions could be found.' => 'Keine Berechtigungen gefunden.',

## tmpl/cms/list_author.tmpl
	'You have successfully disabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich deaktiviert',
	'You have successfully enabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich aktiviert',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Gewählte Benutzerkonten erfolgreich aus Movable Type gelöscht',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Die gelöschten Benutzerkonten sind im externen Verzeichnis weiterhin vorhanden. Die Benutzer können sich daher weiterhin an Movable Type Advanced anmelden.',
	'You have successfully synchronized users\' information with the external directory.' => 'Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie im externen Verzeichnis nicht mehr vorhanden sind.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Bei der Synchronisierung ist ein Fehler aufgetreten. Das  <a href=\'[_1]\'>Aktivitätsprotokoll</a> enthält nähere Informationen.',
	'Enable selected users (e)' => 'Gewählte Benutzerkonten aktivieren (e)',
	'_USER_ENABLE' => 'Aktivieren',
	'Disable selected users (d)' => 'Gewählte Benutzerkonten deaktivieren (d)',
	'_USER_DISABLE' => 'Deaktivieren',
	'Showing All Users' => 'Zeige alle Benutzer',
	'_NO_SUPERUSER_DISABLE' => 'Sie können Ihr eigenes Benutzerkonto nicht deaktivieren, da Sie Verwalter dieser Movable Type-Installation sind.',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'IP-Sperren-Einstellungen',
	'IP addresses' => 'IP-Adressen',
	'Delete selected IP Address (x)' => 'Gewählte IP-Adressen löschen (x)',
	'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefügt.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die ausgewählten IP-Adressen erfolgreich aus der Liste entfernt.',
	'Ban IP Address' => 'IP-Adresse sperren',
	'No IP Address is banned.' => 'Keine IP-Adressen gesperrt',
	'Date Banned' => 'gesperrt am',

## tmpl/cms/list_blog.tmpl
	'Manage [_1]' => '[_1] verwalten',
	'You have successfully deleted the website from the Movable Type system.' => 'Website erfolgreich aus diesem Movable Type-System gelöscht.',
	'You have successfully deleted the blog from the website.' => 'Blog erfolgreich aus der Website gelöscht.',
	'You have successfully refreshed your templates.' => 'Vorlagen erfolgreich zurückgesetzt.',
	'You have successfully moved selected blogs to another website.' => 'Blogs erfolgreich in andere Website verschoben.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',
	'You can not refresh templates: [_1]' => 'Sie können Vorlagen nicht zurücksetzen: [_1]',
	'The website was not deleted. You need to delete blogs under the website.' => 'Die Website wurde nicht gelöscht. Bitte löschen Sie zuerst alle zu dieser Website gehörende Blogs.',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'Kategorieänderungen gespeichert.',
	'You have successfully deleted the selected category.' => 'Gewählte Kategorie erfolgreich gelöscht.',
	'categories' => 'Kategorien',
	'Delete selected category (x)' => 'Gewählte Kategorie löschen (x)',
	'Create top level category' => 'Hauptkategorie anlegen',
	'New Parent [_1]' => 'Neuen Haupt[_1]',
	'Create Category' => 'Kategorie anlegen',
	'Create' => 'Neu',
	'Top Level' => 'Hauptebene',
	'Collapse' => 'Einklappen',
	'Expand' => 'Ausklappen',
	'Create Subcategory' => 'Unterkategorie anlegen',
	'Move Category' => 'Kategorie verschieben',
	'Move' => 'Verschieben',
	'[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
	'[quant,_1,TrackBack,TrackBacks]' => '[quant,_1,TrackBack,TrackBacks]',
	'No categories could be found.' => 'Keine Kategorien gefunden.',

## tmpl/cms/list_comment.tmpl
	'The selected comment(s) has been approved.' => 'Die gewählten Kommentare wurden freigeschaltet.',
	'All comments reported as spam have been removed.' => 'Alle als Spam markierten Kommentare wurden entfernt.',
	'The selected comment(s) has been unapproved.' => 'Die gewählten Kommentare sind nicht mehr freigeschaltet',
	'The selected comment(s) has been reported as spam.' => 'Die gewählten Kommentare wurden als Spam gemeldet',
	'The selected comment(s) has been recovered from spam.' => 'Die gewählten Kommentare wurden aus dem Spam wiederhergestellt',
	'The selected comment(s) has been deleted from the database.' => 'Die gewählten Kommentar(e) wurden aus der Datenbank gelöscht.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
	'No comments appeared to be spam.' => 'Kein Kommentar scheint Spam zu sein.',
	'[_1] (Disabled)' => '[_1] (deaktiviert)',
	'[_1] on entries created within the last [_2] days' => '[_1] zu Einträgen, die in den letzten [_2] Tagen angelegt wurden',
	'[_1] on entries created more than [_2] days ago' => '[_1] zu Einträgen, die vor mehr als [_2] Tagen angelegt wurden',
	'status' => 'Status',
	'approved' => 'Freigeschaltet',
	'pending' => 'auf Moderation wartend',
	'spam' => 'Spam',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Eintragsfeed',
	'Pages Feed' => 'Seitenfeed',
	'The entry has been deleted from the database.' => 'Eintrag aus der Datenbank gelöscht.',
	'The page has been deleted from the database.' => 'Seite aus der Datenbank gelöscht.',
	'Show only entries where' => 'Zeige nur Einträge mit',
	'Show only pages where' => 'Zeige nur Seiten mit',
	'asset' => 'Asset',
	'published' => 'veröffentlicht',
	'unpublished' => 'nicht veröffentlicht',
	'review' => 'zur Überprüfung',
	'scheduled' => 'zeitgeplant',
	'Select A User:' => 'Benutzerkonto wählen: ',
	'User Search...' => 'Benutzer suchen...',
	'Recent Users...' => 'Aktuelle  Benutzer...',

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'Ordneränderungen gespeichert.',
	'You have successfully deleted the selected folder.' => 'Gewählte Ordner erfolgreich gelöscht.',
	'Delete selected folders (x)' => 'Gewählte Ordner löschen (x)',
	'Create top level folder' => 'Neuen Hauptordner anlegen',
	'Create Folder' => 'Ordner anlegen',
	'Create Subfolder' => 'Unterordner anlegen',
	'Move Folder' => 'Ordner verschieben',
	'[quant,_1,page,pages]' => '[quant,_1,Seite,Seiten]',
	'No folders could be found.' => 'Keine Ordner gefunden.',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove the user from this role?' => 'Dem Benutzer wirklich diese Rolle entziehen?',
	'Add a user to this website' => 'Benutzer zu dieser Website hinzufügen',
	'Show only users where' => 'Zeige nur Benutzer mit',
	'role' => 'Rolle',
	'enabled' => 'aktiv',
	'disabled' => 'deaktiviert',

## tmpl/cms/list_notification.tmpl
	'Manage [_1] Address Book' => '[_1]-Adressbuch verwalten',
	'You have added [_1] to your address book.' => '[_1] zum Adressbuch hinzugefügt.',
	'You have successfully deleted the selected contacts from your address book.' => 'Gewählte Kontakte erfolgreich aus dem Adressbuch gelöscht.',
	'Download Address Book (CSV)' => 'Adressbuch herunterladen (CSV)',
	'contact' => 'Kontakt',
	'contacts' => 'Kontakte',
	'Create Contact' => 'Kontakt anlegen',
	'Add Contact' => 'Kontakt hinzufügen',

## tmpl/cms/list_ping.tmpl
	'The selected TrackBack(s) has been approved.' => 'Gewählte TrackBacks freigeschaltet.',
	'All TrackBacks reported as spam have been removed.' => 'Alle als Spam gemeldeten TrackBacks entfernt.',
	'The selected TrackBack(s) has been unapproved.' => 'Gewählte TrackBacks nicht mehr freigeschaltet.',
	'The selected TrackBack(s) has been reported as spam.' => 'Gewählte TrackBack(s) als Spam gemeldet.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Gewählte TrackBacks(s) aus Spam wiederhergestellt',
	'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
	'No TrackBacks appeared to be spam.' => 'Kein TrackBack scheint Spam zu sein.',
	'Show only [_1] where' => 'Zeige nur [_1] mit',
	'unapproved' => 'Nicht freigeschaltet',

## tmpl/cms/list_role.tmpl
	'Manage Roles' => 'Rollen verwalten',
	'You have successfully deleted the role(s).' => 'Rolle(n) erfolgreich gelöscht.',
	'roles' => 'Rollen',
	'Role Is Active' => 'Rolle ist aktiv',
	'Role Not Being Used' => 'Rolle wird derzeit nicht verwendet',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen',
	'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht',
	'tag' => 'Tag',
	'tags' => 'Tags',
	'Specify new name of the tag.' => 'Geben Sie den neuen Namen des Tags an',
	'Tag Name' => 'Name des Tags',
	'Click to edit tag name' => 'Klicken, um Namen des Tags  zu bearbeiten',
	'Rename [_1]' => '[_1] umbenennen',
	'Rename' => 'Umbenennen',
	'Show all [_1] with this tag' => 'Alle [_1] mit diesem Tag zeigen',
	'[quant,_1,_2,_3]' => '[quant,_1,_2,_3]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Das Tag &#8222;[_2]&#8220; ist schon vorhanden. &#8222;[_1]&#8220; wirklich in allen Blogs mit &#8222;[_2]&#8220; zusammenführen?',
	'An error occurred while testing for the new tag name.' => 'Bei der Überprüfung des neuen Tag-Namens ist ein Fehler aufgetreten.',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => '[_1]-Vorlagen verwalten',
	'Manage Global Templates' => 'Gobale Vorlagen verwalten', # Translate - New #OK
	'Show All Templates' => 'Alle Vorlagen anzeigen',
	'Publishing Settings' => 'Veröffentlichungs-Einstellungen',
	'You have successfully deleted the checked template(s).' => 'Vorlage(n) erfolgreich gelöscht.',
	'Your templates have been published.' => 'Die Vorlagen wurden veröffentlicht.',
	'Selected template(s) has been copied.' => 'Die gewählte(n) Vorlage(n) wurden kopiert.',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => '[_1]-Themen',
	'All Themes' => 'Alle Themen',
	'Theme [_1] has been uninstalled.' => 'Das Thema [_1] wurde deinstalliert.',
	'Theme [_1] has been applied.' => 'Das Thema [_1] wurde angewendet.',
	'Some error occured while applying theme.' => 'Bei der Anwendung des Themas ist ein Fehler aufgetreten.',
	'see more detail.' => 'Details anzeigen',
	'Failed' => 'Fehlgeschlagen',
	'[quant,_1,warning,warnings]' => '[quant,_1,Warnung,Warnungen]',
	'Current Theme' => 'Derzeitiges Thema',
	'In Use' => 'Verwendet',
	'Uninstall' => 'Deinstallieren',
	'Author: ' => 'Autor:',
	'This theme cannot be applied to the website due to [_1] errors' => 'Dieses Thema kann wegen [_1]Fehlern nicht auf die Website angewendet werden.',
	'Errors' => 'Fehler',
	'Warnings' => 'Warnungen',
	'Theme Errors' => 'Themen-Fehler',
	'Theme Warnings' => 'Themen-Warnungen',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht auf die Website angewendet werden. [_1] Elemente werden übersprungen.',
	'Theme Information' => 'Themen-Infos',
	'No themes are installed.' => 'Keine Themen installiert.',
	'Themes for Both Blogs and Websites' => 'Themen für Blogs und Websites',
	'Themes for Blogs' => 'Themen für Blogs',
	'Themes for Websites' => 'Themen für Websites',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => '[_1]-Widgets verwalten',
	'Delete selected Widget Sets (x)' => 'Gewählte Widget-Gruppen löschen (x)',
	'Helpful Tips' => 'Nützliche Hinweise',
	'To add a widget set to your templates, use the following syntax:' => 'Um eine Widgetgruppe in eine Vorlage einzubinden, verwenden Sie folgenden Code:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Name der Widgetgruppe&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Änderungen gespeichert.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Widget-Gruppe(n) erfolgreich gelöscht.',
	'No Widget Sets could be found.' => 'Keine Widgetgruppen gefunden.',
	'Create widget template' => 'Widgetvorlage anlegen',

## tmpl/cms/login.tmpl
	'Sign in' => 'Anmelden',
	'Your Movable Type session has ended.' => 'Ihre Movable Type-Sitzung ist abgelaufen oder Sie haben sich abgemeldet.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Unten können Sie sich erneut anmelden.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an, um den Vorgang fortzusetzen.',
	'Sign In (s)' => 'Anmelden (s)',
	'Forgot your password?' => 'Passwort vergessen?',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack',
	'Pinging sites...' => 'Sende Pings...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'Erfolgreiche TrackBacks',
	'Failed Trackbacks' => 'Fehlgeschlagene TrackBacks',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Kopieren Sie diese Adressen im Eintragseditor in das Formularfeld für die zu verschickenden TrackBacks, um es erneut zu versuchen.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Veröffentliche [_1]',
	'Publish <em>[_1]</em>' => '<em>[_1]</em> veröffentlichen',
	'_REBUILD_PUBLISH' => 'Veröffentlichen',
	'All Files' => 'Alle Dateien',
	'Index Template: [_1]' => 'Index-Vorlagen: [_1]',
	'Only Indexes' => 'Nur Indizes',
	'Only [_1] Archives' => 'Nur Archive: [_1]',
	'Publish (s)' => 'Veröffentlichen (s)',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Erfolg',
	'The files for [_1] have been published.' => 'Dateien für [_1] veröffentlicht.',
	'Your [_1] archives have been published.' => '[_1]-Archive veröffentlicht.',
	'Your [_1] templates have been published.' => '[_1]-Vorlagen veröffentlicht.',
	'Publish time: [_1].' => 'Dauer: [_1]',
	'View your site.' => 'Site ansehen',
	'View this page.' => 'Seite ansehen',
	'Publish Again (s)' => 'Erneut veröffentlichen (s)',
	'Publish Again' => 'Erneut veröffentlichen',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Vorschau auf [_1]',
	'Re-Edit this [_1]' => '[_1] erneut bearbeiten',
	'Re-Edit this [_1] (e)' => '[_1] erneut bearbeiten (e)',
	'Save this [_1] (s)' => '[_1] speichern (s)',
	'Cancel (c)' => 'Abbrechen (c)',

## tmpl/cms/preview_strip.tmpl
	'Return to the compose screen' => 'Zurück zur Eingabe',
	'Return to the compose screen (e)' => 'Zurück zur Eingabe (e)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Eintrag &8222;[_1]&#8220;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Seite &#8222;[_1]6#8220;',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Sie sehen eine Vorschau auf die Vorlage &#8222;[_1]&#8221;',
	'(Publish time: [_1] seconds)' => '(Ausgegeben in [_1] Sekunden)',
	'Return to the template editor (e)' => 'Zurück zum Vorlagen-Editor (e)',
	'Return to the template editor' => 'Zurück zum Vorlagen-Editor',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Veröffentliche...',
	'Publishing [_1]...' => 'Veröffentliche [_1]...',
	'Publishing [_1] [_2]...' => 'Veröffentliche [_1] [_2]',
	'Publishing [_1] dynamic links...' => 'Veröffentliche [_1] (dynamisch)',
	'Publishing [_1] archives...' => 'Veröffentliche [_1]...',
	'Publishing [_1] templates...' => 'Veröffentliche [_1]...',
	'[_1]% Complete' => '%1 fertig',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Passwörter anfordern',
	'No users were selected to process.' => 'Keine Benutzer zur Bearbeitung ausgewählt.',
	'Return' => 'Zurück',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Vorlagen zurücksetzen',
	'No templates were selected to process.' => 'Keine Vorlagen gewählt.',
	'Return to templates' => 'Zurück zu Vorlagen',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Wiederherstellungen nicht erneut wiederhergestellt werden.',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie das Aktivitätsprotokoll.',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Movable Type wiederherstellen',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'System aus Sicherheitskopie wiederherstellen',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'XML::SAX und/oder Abhängigkeiten dieses Perl-Moduls fehlen. Ohne diese Module kann Movable Type das System nicht wiederherstellen.',
	'Backup File' => 'Sicherungsdatei',
	'If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder within your Movable Type directory.' => 'Befindet sich die Sicherungsdatei nicht auf dem Server, können Sie sie hier hochladen. Andersfalls prüft Movable Type automatisch das Verzeichnis &#8222;import&#8220; Ihrer Movable Type-Installation auf gültige Sicherungsdateien. ',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Anwählen, um auch Dateien mit einer neueren Schemaversionen wiederherstellen zu können. HINWEIS: Nichtbeachtung der Schemaverion kann Ihre Movable Type-Installation dauerhaft beschädigen.',
	'Ignore schema version conflicts' => 'Versionskonflikte ignorieren',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Vorhandene globale Vorlagen mit globalen Vorlagen aus der Sicherungsdatei überschreiben',
	'Overwrite global templates.' => 'Globale Vorlagen überschreiben',
	'Restore (r)' => 'Wiederherstellen (r)',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus, das ersetzt werden soll.',
	'Search Again' => 'Erneut suchen',
	'Case Sensitive' => 'Groß/Kleinschreibung beachten',
	'Regex Match' => 'Reguläre Ausdrücke verwenden',
	'Limited Fields' => 'Felder eingrenzen',
	'Date Range' => 'Zeitraum eingrenzen',
	'Reported as Spam?' => 'Als Spam gemeldet?',
	'Search Fields:' => 'Felder eingrenzen:',
	'_DATE_FROM' => 'Von',
	'_DATE_TO' => 'Bis',
	'Submit search (s)' => 'Suchen (s)',
	'Replace' => 'Ersetzen',
	'Replace Checked' => 'Gewählte ersetzen',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,Element,Elemente] erfolgreich ersetzt.',
	'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
	'Show all matches' => 'Zeige alle Treffer',
	'[quant,_1,result,results] found' => '[quant,_1,Treffer,Treffer] gefunden',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Erstellen Sie Ihre erste Website',
	'In order to properly publish your website, you must provide Movable Type with your website\'s URL and the filesystem path where its files should be published.' => 'Geben Sie die gewünschte URL und den gewünschten Pfad im Dateisystem Ihres Servers an, unter denen Movable Type Ihre Website veröffentlichen soll.',
	'My First Website' => 'Meine erste Website',
	'Publishing Path' => 'Veröffentlichungspfad',
	'The \'Publishing Path\' is the directory in your web server\'s filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.' => 'Der Veröffentlichungspfad ist der Pfad im Dateisytem Ihres Servers, in dem Movable Type die Dateien Ihrer Website ablegt. Der Webserver muss Schreibrechte für diesen Ordner haben.',
	'Theme' => 'Thema',
	'Select the theme you wish to use for this new website.' => 'Wählen Sie das Thema, das Sie für die neue Website verwenden möchten.',
	'Finish install (s)' => 'Installation abschließen (s)',
	'Finish install' => 'Installation abschließen',
	'Back (x)' => 'Zurück (x)',
	'The website name is required.' => 'Bitte geben Sie  den gewünschten Namen der Website ein.',
	'The website URL is required.' => 'Bitte geben Sie die gewünschte URL der Website ein.',
	'The publishing path is required.' => 'Pfadangabe erforderlich.',
	'The timezone is required.' => 'Zeitzone erforderlich.',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'Benutzerzahl',
	'Number of users registered in this system.' => 'Anzahl der in diesem System registrierten Benutzer',
	'Total Users' => 'Benutzer insgesamt',
	'Memcache Status' => 'Memcache-Status',
	'Memcache is [_1].' => 'Memcache ist [_1].',
	'Memcache Server is [_1].' => 'Der Memcache-Server ist [_1].',
	'Server Model' => 'Server-Modell',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.' => 'Movable Type konnte das Skript &#8222;mt-check.cgi&#8220; nicht finden. Überprüfen Sie, ob das Skript vorhanden ist und, falls erforderlich, ob das CheckScript-Parameter korrekt gesetzt ist.',

## tmpl/cms/theme_export_replace.tmpl
	'Export theme folder already exists \'[_1]\'. You can overwrite a existing theme, or cancel to change the Basename?' => 'Der Exportordner existiert bereits: &#8222;[_1]&#8220;. Setzen Sie fort, um das vorhandene Thema zu überschreiben oder brechen Sie ab, um den Ordnernamen zu ändern.',
	'Overwrite' => 'Überschreiben',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisiere Datenbank...',
	'Upgrading database...' => 'Aktualisiere Datenbank...',
	'Error during installation:' => 'Fehler während Installation:',
	'Error during upgrade:' => 'Fehler während Upgrade:',
	'Return to Movable Type (s)' => 'Zurück zu Movable Type (s)',
	'Return to Movable Type' => 'Zurück zu Movable Type',
	'Your database is already current.' => 'Ihre Datenbank ist bereits auf dem aktuellen Stand.',
	'Installation complete!' => 'Installation abgeschlossen!',
	'Upgrade complete!' => 'Aktualisierung abgeschlossen!',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Zeit für eine Aktualisierung!',
	'Upgrade Check' => 'Aktualisierungs-Überprüfung',
	'Do you want to proceed with the upgrade anyway?' => 'Aktualisierung dennoch durchführen?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.',
	'The Movable Type Upgrade Guide can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Den Movable Type Upgrade Guide finden Sie <a href=\'[_1]\' target=\'_blank\'>hier</a>.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Zusätzlich müssen folgende Movable Type-Komponenten installiert oder aktualisiert werden:',
	'The following Movable Type components require upgrading or installation:' => 'Die folgenden Movable Type-Komponenten müssen installiert oder aktualisiert werden:',
	'Begin Upgrade' => 'Aktualisierung durchführen',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Herzlichen Glückwunsch, Sie haben Ihre Installation erfolgreich auf Movable Type [_1] aktualisiert!',
	'Your Movable Type installation is already up to date.' => 'Ihre Movable Type-Installation ist bereits auf dem neuesten Stand.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Aktivitätsprotokoll zurückgesetzt',
	'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',
	'All times are displayed in GMT.' => 'Alle Zeiten in GMT',
	'Show only errors' => 'Nur Fehlermeldungen anzeigen',
	'System Activity Log' => 'System-Aktivitätsprotokoll',
	'Filtered' => 'Gefilterte',
	'Filtered Activity Feed' => 'Gefilterter Aktivitätsfeed',
	'Download Filtered Log (CSV)' => 'Gefiltertes Protokoll herunterladen (CSV)',
	'Download Log (CSV)' => 'Protokoll herunterladen (CSV)',
	'Clear Activity Log' => 'Aktivitätsprotokoll zurücksetzen',
	'Are you sure you want to reset the activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
	'Showing all log records' => 'Alle Einträge',
	'Showing log records where' => 'Einträge mit',
	'Show log records where' => 'Zeige Einträge mit',
	'level' => 'Art',
	'classification' => 'Thema',
	'Security' => 'Sicherheit',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sicherheit oder Fehler',
	'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
	'Not debug' => 'Kein Debug',
	'Debug/error' => 'Debug/Fehler',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartz-Fehler-Log',
	'Showing all Schwartz errors' => 'Alle Schwartz-Fehler zeigen',

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Aktuelle Kommentare',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] zu [_4]',
	'View all comments' => 'Alle Kommentare',
	'No comments available.' => 'Keine Kommentare vorhanden.',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Aktuelle Einträge',
	'...' => '...',
	'Posted by [_1] [_2] in [_3]' => 'Von [_1] [_2] in [_3]',
	'Posted by [_1] [_2]' => 'Von [_1] [_2]',
	'Tagged: [_1]' => 'Getaggt: [_1]',
	'View all entries' => 'Alle Einträge',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'In diesem Blog wurden noch keine Einträge angelegt. <a href="[_1]">Jetzt Eintrag anlegen</a>',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,Eintrag,Einträge] getaggt mit &#8222;[_2]&#8221;',
	'No entries available.' => 'Keine Einträge vorhanden.',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Fehler beim Einlesen der aktuellen Einträge.',
	'Loading recent entries...' => 'Lade aktuelle Einträge...',
	'Jan.' => 'Januar',
	'Feb.' => 'Februar',
	'July.' => 'Juli',
	'Aug.' => 'August',
	'Sept.' => 'September',
	'Oct.' => 'Oktober',
	'Nov.' => 'November',
	'Dec.' => 'Dezember',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'Sie haben <a href=\'[_3]\'>[quant,_1,Kommentar,Kommentare] von [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'Sie haben <a href=\'[_3]\'>[quant,_1,Eintrag,Einträge] von [_2]</a>',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'Das sind Sie',
	'Welcome to [_1].' => 'Willkommen zu [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Sie können Ihr Blog vom links befindlichen Menü aus verwalten.',
	'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
	'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Movable Type Technischer Support',
	'Movable Type Community Forums' => 'Movable Type Community-Foren',
	'Change this message.' => 'Diese Nachricht ändern.',
	'Edit this message.' => 'Diese Nachricht bearbeiten.',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Ihre aktuellen Websites und Blogs',
	'[quant,_1,blog,blogs]' => '[quant,_1,Blog,Blogs]',
	'[quant,_1,comment,comments]' => '[quant,_1,Kommentar,Kommentare]',
	'No website could be found. [_1]' => 'Keine Website gefunden. [_1]',
	'Create a new' => 'Neu anlegen',
	'No blog could be found.' => 'Keine Blogs gefunden.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Neues',
	'MT News' => 'MT Aktuell',
	'Learning MT' => 'MT lernen',
	'Hacking MT' => 'MT hacken',
	'Pronet' => 'Pronet',
	'No Movable Type news available.' => 'Es liegen keine Movable Type-Nachrichten vor.',
	'No Learning Movable Type news available.' => 'Es liegen keine Learning Movable Type-Nachrichten vor',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Schnellzugriff',
	'Import Content' => 'Importieren',
	'Blog Preferences' => 'Blog-Einstellungen',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Vielen Dank, daß Sie sich für Movable Type entschieden haben',
	'You are now ready to:' => 'Sie können jetzt:',
	'Create a new page on your website' => 'Eine neue Seite auf Ihrer Website anlegen',
	'Create a blog on your website' => 'Ein neues Blog auf Ihrer Website anlegen',
	'Create a blog (many blogs can exist in one website) to start posting.' => 'Ein Blog anlegen und sofort anfangen, zu veröffentlichen. Eine Website kann dabei mehrere Weblogs umfassen.',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform:' => 'Herzlich willkommen zu Movable Type, der leistungsstärksten Blogging-, Publishing- und Social Media-Plattform:',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Neu in Movable Type [_1]',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Keine Blogs gefunden. [_1]',

## tmpl/cms/widget/recent_websites.tmpl

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Ihr <a href="[_1]">letzter Eintrag</a> war [_2] in <a href="[_3]">[_4]</a>',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Ihr letzter Eintrag war [_1] auf <a href="[_2]">[_3]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Sie haben <a href="[_1]>[quant,_2,Entwurf,Entwürfe]</a>.',
	'You have [quant,_1,draft,drafts].' => 'Sie haben [quant,_1,Entwurf,Entwürfe].',
	'You\'ve written <a href="[_1][_2]">[quant,_3,entry,entries]</a>, <a href="[_1][_4]">[quant,_5,page,pages]</a> with <a href="[_1][_6]">[quant,_7,comment,comments]</a>.' => 'Sie haben <a href="[_1][_2]">[quant,_3,Eintrag,Einträge]</a> und <a href="[_1][_4]">[quant,_5,Seite,Seiten]</a> mit <a href="[_1][_6]">[quant,_7,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a> und <a href="[_3]">[quant,_4,Seite,Seiten]</a> mit [quant,_5,Kommentar,Kommentaren] geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a> und [quant,_3,Seite,Seiten] mit <a href="[_4]">[quant,_5,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a>  und [quant,_3,Seite,Seiten] mit [quant,_4,Kommentar,Kommentaren] geschrieben.',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.' => 'Sie haben [quant,_1,Eintrag,Einträge] und <a href="[_2]">[quant,_3,Seite,Seiten]</a> mit <a href="[_4]">[quant,_5,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].' => 'Sie haben [quant,_1,Eintrag,Einträge] und <a href="[_2]">[quant,_3,Seite,Seiten]</a> mit [quant,_4,Kommentar,Kommentaren] geschrieben.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Sie haben [quant,_1,Eintrag,Einträge] und [quant,_2,Seite,Seiten] mit <a href="[_3]">[quant,_4,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].' => 'Sie haben [quant,_1,Eintrag,Einträge] und [quant,_2,Seite,Seiten] mit [quant,_3,Kommentar,Kommentaren] geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a> und <a href="[_3]">[quant,_4,Seite,Seiten]</a> geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a> und [quant,_3,Seite,Seiten] geschrieben.',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.' => 'Sie haben [quant,_1,Eintrag,Einträge] und <a href="[_2]">[quant,_3,Seite,Seiten]</a> geschrieben.',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages].' => 'Sie haben [quant,_1,Eintrag,Einträge] und [quant,_2,Seite,Seiten] geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'Sie haben <a href="[_1]">[quant,_2,Eintrag,Einträge]</a> mit <a href="[_3]">[quant,_4,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].' => 'Sie haben <a href="[_1]">[quant,_2,Seite,Seiten]</a> mit [quant,_3,Kommentar,Kommentaren] geschrieben.',
	'You\'ve written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.' => 'Sie haben [quant,_1,Seite,Seiten] mit <a href="[_2]">[quant,_3,Kommentar,Kommentaren]</a> geschrieben.',
	'You\'ve written [quant,_1,page,pages] with [quant,_2,comment,comments].' => 'Sie haben [quant,_1,Seite,Seiten] mit [quant,_2,Kommentar,Kommentaren]geschrieben.',
	'Edit your profile' => 'Profil bearbeiten',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Ihr AIM- oder AOL-Bildschirmname',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Mit Ihrem AIM- oder AOL-Bildschirmnamen anmelden. Ihr Bildschirmname wird öffentlich angezeigt.',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Mit Ihrem Gmail-Konto anmelden',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Bei Movable Type mit Ihrem[_1]-Konto[_2] anmelden',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Ihre Hatena-ID',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Ihr LiveJournal-Benutzername',
	'Learn more about LiveJournal.' => 'Mehr über LiveJournal erfahren',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'OpenID-URL',
	'Sign in using your OpenID identity.' => 'Mit Ihrer OpenID-Kennung anmelden',
	'Sign in with one of your existing third party OpenID accounts.' => 'Mit einer Ihrer vorhandenen OpenID-Kennungen anmelden',
	'http://www.openid.net/' => 'http://www.openid.net/',
	'Learn more about OpenID.' => 'Mehr über OpenID erfahren',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad ist ein kostenloses und offenes Identitäts-System, mit dem Sie Kommentare auf Weblogs verfassen und sich bei Websites anmelden können. Melden Sie sich kostenlos an.',
	'Sign in or register with TypePad.' => 'Anmelden oder bei TypePad registrieren',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'Ihre Vox-Blog-URL',
	'Learn more about Vox.' => 'Mehr über Vox erfahren',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Ihr Wordpress.com-Benutzername',
	'Sign in using your WordPress.com username.' => 'Mit Ihrem Wordpress.com-Benutzernamen anmelden',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'OpenID für Ihr Yahoo! Japan-Konto jetzt aktivieren',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Aktivieren Sie jetzt OpenID für Ihr Yahoo!-Benutzerkonto',

## tmpl/comment/error.tmpl
	'Go Back (s)' => 'Zurück (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Anmelden zum Kommentieren',
	'Sign in using' => 'Anmelden mit',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Noch nicht Mitglied? <a href="[_1]">Jetzt anmelden</a>!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Ihr Profil',
	'Your login name.' => 'Ihr Benutzername',
	'The name appears on your comment.' => 'Dieser Name wird unter Ihren Kommentaren angezeigt.',
	'Your email address.' => 'Ihre E-Mail-Adresse',
	'Select a password for yourself.' => 'Eigenes Passwort',
	'The URL of your website. (Optional)' => 'URL Ihrer Website (optional)',
	'Return to the <a href="[_1]">original page</a>.' => 'Zurück zur <a href="[_1]">Ausgangsseite</a>.',

## tmpl/comment/register.tmpl
	'Create an account' => 'Konto anlegen',
	'Register' => 'Registrieren',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Vielen Dank für Ihre Anmeldung',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Bevor Sie kommentieren können, müssen Sie  Ihre Registrierung noch bestätigen. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Um die Registrierung abzuschließen, bestätigen Sie bitte Ihre Anmeldung. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Um Ihre Registrierung zu bestätigen und Ihr Konto zu aktivieren, klicken Sie bitte auf den Link in dieser E-Mail.',
	'Return to the original entry.' => 'Zurück zum ursprünglichen Eintrag',
	'Return to the original page.' => 'Zurück zur ursprünglichen Seite',

## tmpl/comment/signup.tmpl
	'Password Confirm' => 'Passwortbestätigung',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
	'_ERROR_CONFIG_FILE' => 'Ihre Movable Type-Konfigurationsdatei fehlt, ist fehlerhaft oder kann nicht gelesen werden. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',
	'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
	'_ERROR_DATABASE_CONNECTION' => 'Die Datenbankeinstellungen in Ihrer Konfigurationsdatei fehlen oder sind fehlerhaft. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',
	'CGI Path Configuration Required' => 'CGI-Pfad muß eingestellt sein',
	'_ERROR_CGI_PATH' => 'Die CGIPath-Angabe in Ihrer Konfigurationsdatei fehlt oder ist fehlerhaft. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type-Aktivitätsprotokoll',

## tmpl/feeds/feed_comment.tmpl
	'More like this' => 'Ähnliche Einträge',
	'From this blog' => 'Aus diesem Blog',
	'On this entry' => 'Zu diesem Eintrag',
	'By commenter identity' => 'Nach Identität des Kommentarautoren',
	'By commenter name' => 'Nach Namen des Kommentarautoren',
	'By commenter email' => 'Nach E-Mail-Adresse des Kommentarautoren',
	'By commenter URL' => 'Nach Web-Adresse (URL) des Kommentarautoren',
	'On this day' => 'An diesem Tag',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'Von diesem Autoren',

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Quelle',
	'By source blog' => 'Nach Quelle',
	'By source title' => 'Nach Name der Quelle',
	'By source URL' => 'By URL der Quelle',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

## tmpl/include/chromeless_header.tmpl

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Richten Sie Ihr erstes Blog ein',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Damit Ihr Blog veröffentlicht werden kann, geben Sie bitte die Webadresse (URL), unter der der Blog erscheinen soll, und den Pfad im Dateisystem, unter dem Movable Type die Dateien dieses Blog ablegen soll, an.',
	'My First Blog' => 'Mein erstes Blog',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Der Veröffentlichungspfad ist der Pfad auf Ihrem Webserver, in dem Movable Type die Dateien dieses Blogs ablegt.',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Konfigurierung des temporären Verzeichnisses',
	'You should configure you temporary directory settings.' => 'Hier legen Sie fest, in welchem Verzeichnis temporäre Dateien gespeichert werden.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to continue configuration.' => 'TempDir erfolgreich konfiguriert. Klicken Sie auf &#8222;Weiter&#8220;, um die Konfigurierung fortsetzen.',
	'[_1] could not be found.' => '[_1] nicht gefunden.',
	'TempDir is required.' => 'TempDir ist erforderlich.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Pfad Ihres temporären Verzeichnisses',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Konfigurationsdatei',
	'The [_1] configuration file can\'t be located.' => 'Die [_1]-Konfigurationsdatei kann nicht gefunden werden.',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => 'Kopieren Sie folgenden Text in eine Datei namens &#8222;mt-config.cgi&#8220; und legen diese im Movable Type-Hauptverzeichnis ab (das Verzeichnis, in dem sich auch die Datei mt.cgi befindet)',
	'The wizard was unable to save the [_1] configuration file.' => 'Die [_1]-Konfigurationsdatei konnte nicht gespeichert werden.',
	'Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => 'Stellen Sie sicher, daß Ihr Webserver Schreibrechte für Ihr [_1]-Wurzelverzeichnis hat (also für den Ordner, der die Datei mt.cgi enthält)  und klicken Sie dann auf  &#8222;Erneut versuchen&#8220;.',
	'Congratulations! You\'ve successfully configured [_1].' => 'Herzlichen Glückwunsch! Sie haben die [_1] erfolgreich konfiguriert.',
	'Your configuration settings have been written to the following file:' => 'Ihre Einstellungen wurden in folgender Datei gespeichert:',
	'To change the settings, click the \'Back\' button below.' => 'Um diese Einstellungen zu ändern, klicken Sie auf &#8222;Zurück&#8220;.',
	'Show the mt-config.cgi file generated by the wizard' => 'Vom Konfigurationsassistenten erzeugte mt-config.cgi-Datei anzeigen',
	'The mt-config.cgi file has been created manually.' => 'Die mt-congig.cgi-Konfigurationsdatei wurde manuell erstellt.',
	'Retry' => 'Erneut versuchen',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Datenbankkonfigurierung',
	'Your database configuration is complete.' => 'Ihre Datenbankkonfigurierung ist abgeschlossen.',
	'You may proceed to the next step.' => 'Sie können mit dem nächsten Schritt fortfahren.',
	'Please enter the parameters necessary for connecting to your database.' => 'Bitte geben Sie zur Herstellung der Datenkbankverbindung notwendigen Daten ein.',
	'Show Current Settings' => 'Einstellungen anzeigen',
	'Database Type' => 'Datenbanktyp',
	'Select One...' => 'Auswählen...',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Wird Ihr Datenbanksystem nicht aufgeführt? Führen Sie die <a href="[_1]" target="_blank">Movable Type Systemüberprüfung</a> durch, um zu erfahren, ob zusätzliche Module erforderlich sind.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Klicken Sie nach der Installation <a href="javascript:void(0)" onclick="[_1]">hier, um diese Ansicht zu aktualisieren</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Mehr über <a href="[_1]" target="blank">Datenbankkonfiguration</a> erfahren',
	'Database Path' => 'Datenbankpfad',
	'The physical file path for your SQLite database. ' => 'Physischer Pfad zur SQLite-Datenbank',
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Mit der  Voreinstellung &#8222;./db/mt.db&#8220; wird die Datenbankdatei unterhalb Ihres Movable Type-Verzeichnisses angelegt.',
	'Database Server' => 'Hostname',
	'This is usually \'localhost\'.' => 'Meistens &#8222;localhost&#8220;',
	'Database Name' => 'Datenbankname',
	'The name of your SQL database (this database must already exist).' => 'Name Ihrer SQL-Datenbank (die Datenbank muss bereits vorhanden sein)',
	'The username to login to your SQL database.' => 'Benutzername Ihrer SQL-Datenbank',
	'The password to login to your SQL database.' => 'Passwort Ihrer SQL-Datenbank',
	'Show Advanced Configuration Options' => 'Erweiterte Optionen anzeigen',
	'Database Port' => 'Port',
	'This can usually be left blank.' => 'Braucht normalerweise nicht angegeben zu werden',
	'Database Socket' => 'Socket',
	'Publish Charset' => 'Zeichenkodierung',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'Der Microsoft SQL Server-Treiber unterstützt ausschließlich die Zeichenkodierungen Shift_JIS und ISO-8859-1. UTF-8 oder andere Kodierungen können nicht verwendet werden.',
	'Test Connection' => 'Verbindung testen',
	'You must set your Database Path.' => 'Pfad zur Datenbank erforderlich',
	'You must set your Username.' => 'Geben Sie Ihren Benutzernamen an.',
	'You must set your Database Server.' => 'Geben Sie Ihren Datenbankserver an.',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Mailkonfigurierung',
	'Your mail configuration is complete.' => 'Ihre Mail-Konfigurierung ist abgeschlossen.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Überprüfen Sie den Eingang der Testmail in Ihrem Postfach und fahren Sie dann mit dem nächsten Schritt fort.',
	'Show current mail settings' => 'Mail-Einstellungen anzeigen',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Geben Sie an, auf welchem Wege Movable Type E-Mails verschicken soll. E-Mails werden beispielsweise zur Benachrichtigung über neue Kommentare verschickt.',
	'An error occurred while attempting to send mail: ' => 'Mailversand fehlgeschlagen: ',
	'Send email via:' => 'E-Mails versenden per:',
	'sendmail Path' => 'sendmail-Pfad',
	'The physical file path for your sendmail binary.' => 'Pfad zu sendmail',
	'Outbound Mail Server (SMTP)' => 'SMTP-Server',
	'Address of your SMTP Server.' => 'Adresse Ihres SMTP-Servers',
	'Mail address to which test email should be sent' => 'Zieladresse der Testmail',
	'From mail address' => 'Absenderadresse',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Überprüfung der Systemvoraussetzungen',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Die folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung erforderlich (Movable Type speichert Ihre Daten in einer Datenbank). Bitte installieren Sie die hier genannten Pakete und klicken Sie danach auf &#8222;Erneut versuchen&#8220;.',
	'All required Perl modules were found.' => 'Alle erforderlichen Perl-Module sind vorhanden.',
	'You are ready to proceed with the installation of Movable Type.' => 'Sie können die Installation von Movable Type fortsetzen.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Einige optionale Perl-Module wurden nicht gefunden. <a href="javascript:void(0)" onclick="[_1]">Optionale Module anzeigen</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Mindestens ein von Movable Type erforderliche Perl-Modul wurde nicht gefunden.',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber erforderlich. Bitte installieren Sie sie und klicken dann auf &#8222;Erneut versuchen&#8220;.',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'Einige optionale Perl-Module wurden nicht gefunden. Die Installation kann ohne diese Module fortgesetzt werden. Sie können jederzeit bei Bedarf nachinstalliert werden. &#8222;Erneut versuchen&#8220; wiederholt die Modulsuche.',
	'Missing Database Modules' => 'Fehlende Datenbank-Module',
	'Missing Optional Modules' => 'Nicht vorhandene optionale Module',
	'Missing Required Modules' => 'Fehlende erforderliche Module',
	'Minimal version requirement: [_1]' => 'Mindestens erforderliche Version: [_1]',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	'Learn more about installing Perl modules.' => 'Mehr über die Installation von Perl-Modulen erfahren',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Alle erforderlichen Pakete vorhanden. Sie brauchen keine weiteren Pakete zu installieren.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Es ist bereits eine Konfigurationsdatei vorhanden',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type erfordert JavaScript. Bitte aktivieren Sie es in Ihren Browsereinstellungen und laden diese Seite dann neu.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Dieser Konfigurationsassistent hilft Ihnen, die zum Betrieb von Movable Type erforderlichen Grundeinstellungen vorzunehmen.',
	'Default language.' => 'Standardsprache',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => '<strong>Fehler: &#8222;[_1]&#8220; nicht gefunden.</strong> Bitte verschieben Sie die statischen Dateien erst in das Verzeichnis oder überprüfen Sie die Einstellungen.',
	'Configure Static Web Path' => 'Statischen Web-Pfad konfigurieren',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type wird mit einem Verzeichnis namens [_1] ausgeliefert, das einige wichtige Bild-, JavaScript- und Stylesheet-Dateien enthält.',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => 'Der [_1]-Ordner befindet sich im Hauptverzeichnis von Movable Type, ist aufgrund der Serverkonfiguration vom Webserver aber nicht erreichbar. Verschieben Sie den Ordner [_1] daher an einen Ort, auf dem der Webserver zugreifen kann (z.B. in das Web-Wurzelverzeichnis).',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Das Verzeichnis wurde entweder umbenannt oder an einen Ort außerhalb des Movable Type-Verzeichnisses verschoben.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Wenn Sie den [_1]-Ordner an einen vom Webserver erreichbaren Ort verschoben haben, geben Sie die Adresse unten an.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Die Adresse kann in dieser Form: [_1] oder einfach als [_2] angegeben werden. ',
	'This path must be in the form of [_1]' => 'Der Pfad muss in dieser Form angegeben werden: [_1]',
	'Static web path' => 'Statischer Webpfad',
	'Static file path' => 'Statischer Dateipfad',
	'Begin' => 'Anfangen',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Es ist bereits eine Konfigurationsdatei (mt-config.cgi) vorhanden. Sie können sich daher sofort <a href="[_1]">bei Movable Type anmelden</a>.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Um mit dem Konfigurationsassistenten eine neue Konfigurationsdatei zu erzeugen, entfernen Sie die vorhandene Konfigurationsdatei und laden Sie diese Seite neu.',

## addons/Commercial.pack/config.yaml
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Eine professionell gestaltete, übersichtlich strukturierte und leicht anpass- und erweiterbare Website. ',
	'_PWT_ABOUT_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec
tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque
pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium
fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae,
vulputate et, dignissim at, pede. Integer pellentesque orci at nibh.
Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a,
bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti
sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.
Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo.
Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- Entfernen Sie diesen Link nach der Bearbeitung -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'_PWT_CONTACT_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>

<p>Wir freuen uns darauf, von Ihnen zu hören. Schicken Sie Ihre E-Mail bitte an email (at) domainname.de</p>

<!-- Entfernen Sie diesen Link nach der Bearbeitung  -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'Welcome to our new website!' => 'Willkommen auf unserer neuen Website!',
	'_PWT_HOME_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec
tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque
pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut
placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium
a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla
quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate
et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a,
bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti
sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.
Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo.
Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat
metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis
faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci
diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim
massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- Entfernen Sie diesen Link nach der Bearbeitung  -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl +
\'?__mode=view&_type=page&id=\' + page_id + \'&blog_id=\' + blog_id; return
false">Inhalt bearbeiten</a>
</p>
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Legen Sie ein Blog als Teil einer umfangreicheren Website an. Das funktioniert besonders gut mit der Vorlage &#8222;Professionelle Website&#8220;.',
	'Photo' => 'Foto',
	'Embed' => 'Einbetten',
	'Custom Fields' => 'Eigene Felder',
	'Updating Universal Template Set to Professional Website set...' => 'Aktualisiere \'Universelle Vorlagengruppe\' in Vorlagengruppe \'Profesionelle Website\'',
	'Professional Styles' => 'Pro-Themen',
	'A collection of styles compatible with Professional themes.' => 'Mit Pro-Themen kompatible Designs',
	'Professional Website' => 'Professionelle Website',
	'Blog Index' => 'Blog-Index',
	'Header' => 'Kopf',
	'Footer' => 'Fußzeile',
	'Entry Metadata' => 'Eintrags-Metadaten',
	'Page Detail' => 'Seiteninformationen',
	'Powered By (Footer)' => 'Powered by (Fußzeile)',
	'Recent Entries Expanded' => 'Neueste Einträge (erweitert)',
	'Footer Links' => 'Fußzeilen-Links',
	'Main Sidebar' => 'Haupt-Seitenspalte',
	'Blog Activity' => 'Blog-Aktivität',
	'Professional Blog' => 'Professionelles Blog',
	'Entry Detail' => 'Eintragsdetails',
	'Blog Archives' => 'Blog-Archive',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Zeige',
	'Date & Time' => 'Datum- und Uhrzeit',
	'Date Only' => 'Nur Datum',
	'Time Only' => 'Nur Uhrzeit',
	'Please enter all allowable options for this field as a comma delimited list' => 'Bitte geben Sie alle für dieses Feld zulässigen Optionen als kommagetrennte Liste ein.',
	'[_1] Fields' => '[_1]-Felder',
	'Edit Field' => 'Feld bearbeiten',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ungültige Datumsangabe \'[_1]\' - Datumsangaben müssen das Format JJJJ-MM-TT HH:MM:SS haben.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ungültige Datumsangabe \'[_1]\' - Datumsangaben sollten tatsächliche Daten sein',
	'Please enter valid URL for the URL field: [_1]' => 'Bitte geben Sie eine gültige Web-Adresse in das Feld [_1] ein.',
	'Please enter some value for required \'[_1]\' field.' => 'Bitte füllen Sie das erforderliche Feld \'[_1]\' aus.',
	'Please ensure all required fields have been filled in.' => 'Bitte füllen Sie alle erforderlichen Felder aus.',
	'The template tag \'[_1]\' is an invalid tag name.' => '\'[_1]\' ist ein ungültiger Befehlsname.',
	'The template tag \'[_1]\' is already in use.' => 'Vorlagenbefehl \'[_1]\' bereits vorhanden',
	'The basename \'[_1]\' is already in use.' => 'Basisname \'[_1]\' bereits vorhanden',
	'You must select other type if object is the comment.' => 'Wählen Sie einen anderen Typ, wenn sich das Feld auf Kommentare bezieht.',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Speichern Sie genau die Informationen, die Sie möchten, indem Sie die Formulare und Felder von Einträgen, Seiten, Ordnern, Kategorien und Benutzerkonten frei anpassen.',
	' ' => ' ',
	'Single-Line Text' => 'Einzeiliger Text',
	'Multi-Line Text' => 'Mehrzeiliger Text',
	'Checkbox' => 'Auswahlkästchen',
	'Date and Time' => 'Datum und Uhrzeit',
	'Drop Down Menu' => 'Drop-Down-Menü',
	'Radio Buttons' => 'Auswahlknöpfe',
	'Embed Object' => 'Objekt einbetten',
	'Post Type' => 'Eintragsart',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Stelle eigene Felder aus MT::PluginData wieder her...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Stelle Assetverknüpfungen aus eigenen Feldern wieder her...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Stelle die Adressen der in eigenen Feldern verwendeten Assets wieder her...',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Feld',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Wird der \'[_1]\'-Befehl im richtigen Kontext verwendet? Kann [_2] nicht finden',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => '\'[_1]\'-Befehl außerhalb des passenden Kontexts verwendet.',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] eigene Felder',
	'a field on this blog' => 'Ein Feld dieses Blogs',
	'a field on system wide' => 'Ein systemweites Feld',
	'Conflict of [_1] "[_2]" with [_3]' => ' [_1] "[_2]" steht in Konflikt mit [_3]',
	'Template Tag' => 'Vorlagenbefehl',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Verschiebe Metadatenspeicher für Seiten...',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Neues von <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Links' => 'Links',

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] meinte zu [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Einträge ([_1]) Kommentare ([_2])',

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml

## addons/Commercial.pack/templates/professional/website/pages_list.mtml

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => 'zu [_1]',
	'By [_1] | Comments ([_2])' => 'Von [_1] | Kommentare ([_2])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => '[_1] wählen',
	'Remove [_1]' => '[_1] löschen',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Diese Felder anzeigen',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Daten in eigenen Feldern gespeichert.',
	'Save changes to blog (s)' => 'Änderungen des Blogs speichern (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Keine eigenen Felder gefunden. Jetzt ein <a href="[_1]">Feld anlegen</a>.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Eigenes Feld bearbeiten',
	'Create Custom Field' => 'Eigenes Feld anlegen',
	'The selected fields(s) has been deleted from the database.' => 'Gewählten Felder aus Datenbank gelöscht.',
	'You must enter information into the required fields highlighted below before the Custom Field can be created.' => 'Bitte füllen Sie alle hervorgehobenen Felder aus.',
	'System Object' => 'Systemobjekt',
	'Choose the system object where this Custom Field should appear.' => 'Wählen Sie das Systemobjekt, auf das sich dieses Feld beziehen soll.',
	'Select...' => 'Wählen...',
	'Required?' => 'Erforderlich?',
	'Is data entry required in this Custom Field?' => 'Muss dieses Feld ausgefüllt werden?',
	'Must the user enter data into this Custom Field before the object may be saved?' => 'Sollen Benutzer dieses Feld ausfüllen müssen, bevor sie das Objekt speichern können?',
	'Default' => 'Standardwert',
	'You must save this Custom Field before setting a default value.' => 'Speichern Sie das Feld, um den Standardwert festlegen zu können.',
	'_CF_BASENAME' => 'Basisname',
	'The basename must be unique within this installation of Movable Type.' => 'Der Basisname des Felds muss systemweit eindeutig sein.',
	'Warning: Changing this field\'s basename may require changes to existing templates.' => 'Hinweis: Eine Änderung des Basisnamens eines Feldes kann die Bearbeitung vorhandener Vorlagen notwendig machen.',
	'Example Template Code' => 'Beispiel-Vorlagencode',
	'Show In These [_1]' => 'In diesen [_1] anzeigen',
	'Save this field (s)' => 'Dieses Feld speichern (s)',
	'field' => 'Feld',
	'fields' => 'Felder',
	'Delete this field (x)' => 'Dieses Feld löschen (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objekt',

## addons/Commercial.pack/tmpl/list_field.tmpl
	'Manage Custom Fields' => 'Felder verwalten',
	'New [_1] Field' => 'Neues [_1] Feld',
	'Delete selected fields (x)' => 'Gewählte Felder löschen (x)',
	'No fields could be found.' => 'Keine Felder gefunden.',
	'Display on' => 'Anzeigen in',
	'System-Wide' => 'Systemweit',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'öffnen',
	'click-down and drag to move this field' => 'bei gedrückter Maustaste ziehen, um das Feld zu verschieben',
	'click to %toggle% this box' => 'klicken um das Feld an- oder abzuwählen',
	'use the arrow keys to move this box' => 'mit den Pfeiltasten verschieben',
	', or press the enter key to %toggle% it' => 'oder Enter drücken zum An- oder Abwählen',

## addons/Community.pack/config.yaml
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Leser-Interaktion fördern: rollen Sie neue Funktionen aus, die es Ihren Lesern leicht machen, mit Ihnen und Ihrem Unternehmen zu interagieren',
	'Create forums where users can post topics and responses to topics.' => 'Bieten Sie Foren an, in denen Ihre Leser untereinander diskutieren können.',
	'Community' => 'Feedback',
	'Pending Entries' => 'Wartende Einträge',
	'Spam Entries' => 'Spam-Einträge',
	'Following Users' => 'Benutzern folgen',
	'Being Followed' => 'Gefolgt werden',
	'Sanitize' => 'Bereinigen',
	'Recently Scored' => 'Kürzlich bewertet',
	'Recent Submissions' => 'Aktuelle Beiträge',
	'Most Popular Entries' => 'Beliebteste Einträge',
	'Registrations' => 'Registrierungen',
	'Login Form' => 'Anmeldeformular',
	'Registration Form' => 'Registrierungsformular',
	'Registration Confirmation' => 'Registrierungsbestätigung',
	'Profile Error' => 'Profilfehler',
	'Profile View' => 'Profilansicht',
	'Profile Edit Form' => 'Formular zur Profilbearbeitung',
	'Profile Feed' => 'Profil-Feed',
	'New Password Form' => 'Formular zur Anforderung neuer Passwörter',
	'New Password Reset Form' => 'Formular zum Zurücksetzen neuer Passwörter',
	'Form Field' => 'Formularfeld',
	'Status Message' => 'Statusnachricht',
	'Simple Header' => 'Einfache Kopfzeile',
	'Simple Footer' => 'Einfache Fußzeile',
	'Header' => 'Kopf',
	'Footer' => 'Fußzeile',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Email verification' => 'E-Mail-Bestätigung',
	'Registration notification' => 'Registrierungsbenachrichtigung',
	'New entry notification' => 'Eintragsbenachrichtigung',
	'Community Styles' => 'Community-Styles',
	'A collection of styles compatible with Community themes.' => 'Mit Community-Themen kompatible Designs',
	'Community Blog' => 'Community-Blog',
	'Atom ' => 'Atom ',
	'Entry Response' => 'Antwort auf Eintrag',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Beiträgen an.',
	'Entry Detail' => 'Eintragsdetails',
	'Entry Metadata' => 'Eintrags-Metadaten',
	'Page Detail' => 'Seitendetails',
	'Entry Form' => 'Eintragsformular',
	'Content Navigation' => 'Inhaltsnavigation',
	'Activity Widgets' => 'Aktivitäten-Widgets',
	'Archive Widgets' => 'Archiv-Widgets',
	'Community Forum' => 'Community-Forum',
	'Entry Feed' => 'Eintrags-Feed',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Beiträgen an.',
	'Popular Entry' => 'Beliebter Eintrag',
	'Entry Table' => 'Eintragstabelle',
	'Content Header' => 'Inhaltskopf',
	'Category Groups' => 'Kategoriegruppen',
	'Default Widgets' => 'Standard-Widgets',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'Keine Vorlage für das Anmeldeformular definiert',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Bevor Sie sich anmelden können, bestätigen Sie bitte Ihre E-Mail-Adresse. <a href="[_1]>Bestätigungsmail erneut senden</a>.',
	'Your confirmation have expired. Please register again.' => 'Ihre Anmeldung ist abgelaufen. Bitte registrieren Sie sich erneut.',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Benutzer \'[_1]\' (ID:[_2]) erfolgreich registriert.',
	'Thanks for the confirmation.  Please sign in.' => 'Danke für die Bestätigung. Bitte melden Sie sich an.',
	'[_1] registered to Movable Type.' => '[_1] hat sich bei Movable Type registriert',
	'Login required' => 'Anmeldung erforderlich',
	'Title or Content is required.' => 'Titel oder Text erforderlich',
	'System template entry_response not found in blog: [_1]' => 'Systemvorlage entry_response für Blog [_1] nicht gefunden',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Neuer Eintrag \'[_1]\' zu Blog \'[_2]\' hinzugefügt.',
	'Id or Username is required' => 'ID oder Benutzername erforderlich',
	'Unknown user' => 'Unbekannter Benutzer',
	'Recent Entries from [_1]' => 'Aktuelle Eintrage von [_1]',
	'Responses to Comments from [_1]' => 'Reaktionen auf Kommentare von  [_1]',
	'Actions from [_1]' => 'Aktionen von [_1]',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Users followed by [_1]' => 'Benutzer, denen [_1] folgt',
	'Users following [_1]' => 'Benutzer, die [_1] folgt',
	'Following' => 'Benutzer, denen Sie folgen',
	'Followers' => 'Benutzer, die Ihnen folgen',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => '\'[_1]\'-Befehl außerhalb eines MtIfEntryRecommended-Blocks verwendet - \'MTIfEntryRecommended\'-Block erforderlich',
	'Click here to recommend' => 'Empfehlen',
	'Click here to follow' => 'Klicken, um zu folgen',
	'Click here to leave' => 'Klicken, um nicht mehr zu folgen',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/templates/blog/about_this_page.mtml

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Kommentar zu [_1]',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Der Inhalt von #comments-content wird durch Aufrufe des Paginierungs-Skripts ersetzt',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Startseite',

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/entry_create.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Um einen Eintrag in diesem Blog anzulegen, registrieren Sie sich bitte erst.',
	'You don\'t have permission to post.' => 'Sie haben nicht genügend Benutzerrechte um zu veröffentlichen.',
	'Sign in to create an entry.' => 'Melden Sie sich an, um einen Eintrag zu schreiben.',
	'Select Category...' => 'Kategorie wählen...',

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Neues von <em>[_1]</em>',

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => 'Stimme',
	'Votes' => 'Stimmen',

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Danke, daß Sie einen Eintrag geschrieben haben.',
	'Entry Pending' => 'Eintrag noch nicht freigegeben',
	'Your entry has been received and held for approval by the blog owner.' => 'Ihr Eintrag ist eingegangen und muss nun vom Blogbetreiber freigeschaltet werden.',
	'Entry Posted' => 'Eintrag veröffentlicht',
	'Your entry has been posted.' => 'Ihr Eintrag wurde veröffentlicht.',
	'Your entry has been received.' => 'Ihr Eintrag ist eingegangen.',
	'Return to the <a href="[_1]">blog\'s main index</a>.' => 'Zurück zur <a href="[_1]">Startseite</a>.',

## addons/Community.pack/templates/blog/entry_summary.mtml

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] meinte zu [_3]</a>: [_4]',

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/blog/search_results.mtml

## addons/Community.pack/templates/blog/sidebar.mtml

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'Forengruppen',
	'Last Topic: [_1] by [_2] on [_3]' => 'Letztes Thema: [_1] von [_2] um [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Seien Sie die erste Person, <a href="[_1]">die ein Thema in diesem Forum eröffnet</a>!',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] antwortete auf <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Antwort schreiben',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Antwort auf [_1]',
	'Previewing your Reply' => 'Vorschau Ihrer Antwort',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Antwort eingegangen',
	'Your reply has been accepted.' => 'Ihre Antwort ist bei uns eingegangen.',
	'Thank you for replying.' => 'Vielen Dank, daß Sie geantwortet haben.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Ihre Antwort ist bei uns eingegangen. Sie wird veröffentlicht, sobald der Forums-Administrator sie freigeschaltet hat.',
	'Reply Submission Error' => 'Es ist ein Fehler aufgetreten',
	'Your reply submission failed for the following reasons: [_1]' => 'Ihr konnte aus folgendem Grund nicht angemommen werden:',
	'Return to the <a href="[_1]">original topic</a>.' => 'Zurück zum <a href="[_1]">Ausgangsthema</a>.',

## addons/Community.pack/templates/forum/comments.mtml
	'1 Reply' => '1 Antwort',
	'# Replies' => '# Antworten',
	'No Replies' => 'Keine Antworten',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'Thema eröffnen',

## addons/Community.pack/templates/forum/content_nav.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Neues Thema eröffnen',

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Thema',
	'Select Forum...' => 'Forum wählen...',
	'Forum' => 'Forum',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Beliebte Themen',
	'Last Reply' => 'Letzte Antwort',
	'Permalink to this Reply' => 'Peramanenter Link zu dieser Antwort',
	'By [_1]' => 'Von [_1]',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Danke, daß Sie ein neues Thema eröffnet haben!',
	'Topic Pending' => 'Thema noch nicht freigegeben',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Ihr Thema  ist eingegangen und muss nun vom Forenadministrator freigeschaltet werden.',
	'Topic Posted' => 'Thema veröffentlicht',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Ihr Thema ist eingegangen und wurde veröffentlicht. Vielen Dank!',
	'Return to the <a href="[_1]">forum\'s homepage</a>.' => 'Zurück zur <a href="[_1]">Startseite</a> des Forums.',

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Aktuelle Themen',
	'Replies' => 'Antworten',
	'Closed' => 'Geschlossen',
	'Post the first topic in this forum.' => 'Eröffnen Sie das erste Thema in diesem Forum',

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Danke für Ihre Anmeldung, ',
	'. Now you can reply to this topic.' => '. Sie können nun Ihre Antwort schreiben.',
	'You do not have permission to comment on this blog.' => 'Sie haben nicht die notwendige Berechtigung, um in diesem Blog Kommentare zu schreiben.',
	' to reply to this topic.' => 'um auf dieses Thema zu antworten.',
	' to reply to this topic,' => 'um auf dieses Thema zu antworten',
	'or ' => 'oder ',
	'reply anonymously.' => 'antworten Sie anonym.',

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Startseite',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Themen zu &#8222;[_1]&8220;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Mit &#8222;[_1]&8220; getaggte Themen',
	'Topics' => 'Themen',

## addons/Community.pack/templates/forum/sidebar.mtml

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Alle Foren',
	'[_1] Forum' => '[_1]-Forum',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => 'Danke, daß Sie sich ein [_1]-Konto angelegt haben.',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Zur Ihren eigenen Sicherheit und um Mißbrauch vorzubeugen bestätigen Sie nun bitte Ihre Angaben. Daraufhin können Sie sich sofort bei [_1] anmelden.',
	'If you did not make this request, or you don\'t want to register for an account to [_1], then no further action is required.' => 'Sollten Sie sich nicht angemeldet haben oder sollten Sie sich doch nicht registrieren wollen, brauchen Sie nichts weiter zu tun.',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Blogbeschreibung',

## addons/Community.pack/templates/global/javascript.mtml

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Als <a href="[_1]">[_2]</a> angemeldet',
	'Logout' => 'Abmelden',
	'Hello [_1]' => 'Hallo [_1]',
	'Forgot Password' => 'Passwort vergessen',
	'Sign up' => 'Registrieren',

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Noch nicht registriert?&nbsp;&nbsp;<a href="[_1]">Einfach jetzt registrieren</a>!',

## addons/Community.pack/templates/global/navigation.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	'A new entry \'[_1]([_2])\' has been posted on your blog [_3].' => 'In Ihrem Blog [_3] wurde ein neuer Eintrag \'[_1]([_2])\' veröffentlicht.',
	'Author name: [_1]' => 'Name des Autors: [_1]',
	'Author nickname: [_1]' => 'Nickname des Autors: [_1]',
	'Title: [_1]' => 'Titel: [_1]',
	'Edit entry:' => 'Eintrag bearbeiten:',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Reset Password' => 'Passwort zurücksetzen',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]>Zurück zur Ausgangsseite</a> oder <a href="[_2]>Profil ansehen</a>.',

## addons/Community.pack/templates/global/profile_error.mtml
	'ERROR MSG HERE' => 'ERROR MSG HERE',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] in [_2] veröffentlicht',
	'Commented on [_1] in [_2]' => '[_1] in [_2] kommentiert',
	'Voted on [_1] in [_2]' => 'Für [_1] in [_2] gestimmt',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] hat für <a href="[_2]">[_3]</a> in [_4] gestimmt',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Benutzerprofil',
	'Recent Actions from [_1]' => 'Aktuelle Aktionen von [_1]',
	'You are following [_1].' => 'Sie folgen [_1]',
	'Unfollow' => 'Nicht mehr folgen',
	'Follow' => 'Folgen',
	'You are followed by [_1].' => '[_1] folgt Ihnen.',
	'You are not followed by [_1].' => '[_1] folgt Ihnen nicht.',
	'Website:' => 'Website:',
	'Recent Actions' => 'Aktuelle Aktionen',
	'Comment Threads' => 'Kommentar-Threads',
	'Commented on [_1]' => '[_1] kommentiert',
	'Favorited [_1] on [_2]' => '[_1] in [_2] zum Favoriten gemacht',
	'No recent actions.' => 'Keine aktuellen Aktionen',
	'[_1] commented on ' => '[_1] kommentierte',
	'No responses to comments.' => 'Keine Kommentarantworten',
	'Not following anyone' => 'Sie folgen niemandem',
	'Not being followed' => 'Niemand folgt Ihnen',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Authentifizierungsmail verschickt',
	'Profile Created' => 'Profil angelegt',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Zurück zur Ausgangsseite</a>',

## addons/Community.pack/templates/global/register_form.mtml

## addons/Community.pack/templates/global/register_notification_email.mtml

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Sie sind als <a href="[_1]">[_2]</a> angemeldet.',
	'You are signed in as [_1]' => 'Sie sind als [_1] angemeldet.',
	'Edit profile' => 'Profil bearbeiten',
	'Not a member? <a href="[_1]">Register</a>' => 'Noch kein Mitglied? <a href="[_1]>Registieren</a>',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Community',
	'Anonymous Recommendation' => 'Anonyme Empfehlungen',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Anonymen (nicht angemeldeten) Benutzern erlauben, Diskussionen zu empfehlen. Die IP-Adressen nicht angemeldeter Benutzer werden gespeichert.',
	'Allow anonymous user to recommend' => 'Anonymen Benutzern erlauben Empfehlen auszusprechen',
	'Save changes to blog (s)' => 'Blog-?nderungen speichern (s)',

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => 'Aktuelle Registrierungen',
	'default userpic' => 'Standard-Benutzerbild',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Sie haben [quant,_1,Registrierung,Registrierungen] von [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'Keine beliebten Einträge.',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'Keine kürzlich als Favoriten gespeicherte Einträge.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Enterprise.pack/app-cms.yaml
	'Are you sure you want to delete the selected group(s)?' => 'Gewählte Gruppe(n) wirklich löschen?',
	'Groups' => 'Gruppen',
	'Bulk Author Export' => 'Stapelexport von Autoren',
	'Bulk Author Import' => 'Stapelimport von Autoren',
	'Synchronize Users' => 'Benutzer synchronisieren',
	'Synchronize Groups' => 'Gruppen synchronisieren',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Dieses Modul ist zur Nutzung der LDAP-Authentifizierung erforderlich.',
	'This module is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'Dieses Modul ist zur Nutzung von SSL/TLS-Verbindungen bei der LDAP-Authentifizierung erforderlich.',

## addons/Enterprise.pack/config.yaml
	'Advanced Pack' => 'Advanced-Pack',
	'Oracle Database' => 'Oracle-Datenbank',
	'Microsoft SQL Server Database' => 'Microsoft SQL Server-Datenbank',
	'Microsoft SQL Server Database (UTF-8 support)' => 'Microsoft SQL Server-Datenbank (mit UTF-8-Unterstüzung)',
	'External Directory Synchronization' => 'Synchronisierung mit externem Verzeichnis',
	'Populating author\'s external ID to have lower case user name...' => 'Setze externe Benutzerkennung für kleingeschriebene Benutzernamen...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'User [_1]([_2]) not found.' => 'Benutzerkonto [_1]([_2]) nicht gefunden.',
	'User \'[_1]\' cannot be updated.' => 'Benutzerkonto \'[_1]\' kann nicht aktualisiert werden.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Benutzerkonto \'[_1]\' mit LDAP-Login-ID aktualisiert.',
	'LDAP user [_1] not found.' => 'LDAP-Benutzerkonto [_1] nicht gefunden.',
	'User [_1] cannot be updated.' => 'Benutzerkonto [_1] kann nicht aktualisiert werden.',
	'User cannot be updated: [_1].' => 'Benutzerkonto kann nicht aktualisiert werden: [_1].',
	'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'Fehlgeschlagener Anmeldeversuch von Benutzer \'[_1]\' aus LDAP gelöscht.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Benutzerkonto \'[_1]\' mit LDAP-Login-Name aktualisiert.',
	"Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID." => "Fehlgeschlagener Anmeldeversuch durch Benutzer &#8222;[_1]&#8220;. Im System ist bereits ein Benutzer mit diesem Benutzernamen, aber anderer UUID vorhanden.",
	'User \'[_1]\' account is disabled.' => 'Benutzerkonto \'[_1]\' ist deaktiviert.',
	'LDAP users synchronization interrupted.' => 'LDAP-Benutzersynchronisierung unterbrochen.',
	'Loading MT::LDAP failed: [_1]' => 'Beim Laden von MT::LDAP ist ein Fehler aufgetreten: [_1]',
	'External user synchronization failed.' => 'Synchronisierung externer Benutzer fehlgeschlagen.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Es wurde versucht, alle Administratorenkonten zu deaktivieren. Synchronisation unterbrochen.',
	'The following users\' information were modified:' => 'Die Daten folgender Benutzer wurden geändert:',
	'The following users were disabled:' => 'Die folgenden Benutzer wurden deaktiviert:',
	'LDAP users synchronized.' => 'LDAP-Benutzer synchronisiert.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'Gruppen können nur synchronisiert werden, wenn LDAPGroupIdAttribute und/oder LDAPGroupNameAttribute gesetzt ist.',
	'LDAP groups synchronized with existing groups.' => 'LDAP-Gruppen mit vorhandenen Gruppen sychnronisiert.',
	'The following groups\' information were modified:' => 'Die Daten folgender Gruppen wurden geändert:',
	'No LDAP group was found using given filter.' => 'Keine entsprechenden LDAP-Gruppen gefunden.',
	"Filter used to search for groups: [_1]\nSearch base: [_2]" => "Verwendeter Suchfilter: [_1]
Suchbasis: [_2]",
	'(none)' => '(Keine)',
	'The following groups were deleted:' => 'Die folgenden Gruppen wurden gelöscht:',
	'Failed to create a new group: [_1]' => 'Fehler beim Anlegen einer neuen Gruppe: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => '[_1]-Direktive muss gesetzt sein, um LDAP-Gruppenmitgliedschaften mit Movable Type Advanced zu synchronisieren.',
	'Members removed: ' => 'Entfernte Mitglieder:',
	'Members added: ' => 'Hinzugefügte Mitglieder:',
	'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Die Mitgliedschaften der Gruppe \'[_2]\' (#[_3]) wurden bei der Sychronisierung mit dem externen Verzeichnis verändert.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'Zur Synchronisierung von Gruppen muss LDAPUserGroupMemberAttribute gesetzt sein.',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Fehlerhaftes Format in Zeile [_1]: [_2]',
	'Invalid command: [_1]' => 'Unbekannter Befehl: [_1]',
	'Invalid number of columns for [_1]' => 'Ungültige Spaltenzahl für [_1]',
	'Invalid user name: [_1]' => 'Ungültiger Benutzername: [_1]',
	'Invalid display name: [_1]' => 'Ungültiger Anzeigename: [_1]',
	'Invalid email address: [_1]' => 'Ungültige E-Mail-Adresse: [_1]',
	'Invalid language: [_1]' => 'Ungültige Sprache: [_1]',
	'Invalid password: [_1]' => 'Ungültiges Passwort: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Ungültiger Passwort-Erinnerungssatz: [_1]',
	'Invalid weblog name: [_1]' => 'Ungültiger Weblogname: [_1]',
	'Invalid weblog description: [_1]' => 'Ungültige Weblogbeschreibung: [_1]',
	'Invalid site url: [_1]' => 'Ungültige Webadresse: [_1]',
	'Invalid site root: [_1]' => 'Ungültiges Wurzelverzeichnis: [_1]',
	'Invalid timezone: [_1]' => 'Ungültige Zeitzone: [_1]',
	'Invalid new user name: [_1]' => 'Ungültiger neuer Benutzername: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Benutzer mit gleichem Namen gefunden, Registrierung daher nicht durchgeführt: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Blog für Benutzer \'[_1]\' kann nicht angelegt werden.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Blog \'[_1]\' für Benutzer \'[_2]\' angelegt.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Fehler bei der Zuweisung von Blog-Administrationsrechten für Blog \'[_3] (ID: [_4])\' an Benutzer \'[_1] (ID: [_2])\'. Keine geeignete Administratorenrolle gefunden.',
	'Permission granted to user \'[_1]\'' => 'Berechtigungenga an Benutzer \'[_1]\' vergeben',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'Benutzerkonto \'[_1]\' bereits vorhanden, Aktualisierung daher nicht durchgeführt: [_2] ',
	'User \'[_1]\' not found.  Update was not processed.' => 'Benutzerkonto \'[_1]\' nicht gefunden, Aktualisierung daher nicht durchgeführt. ',
	'User \'[_1]\' has been updated.' => 'Benutzerkonto \'[_1]\' aktualisiert.',
	'User \'[_1]\' was found, but delete was not processed' => 'Benutzerkonto \'[_1]\' gefunden, aber Löschung nicht durchgeführt.',
	'User \'[_1]\' not found.  Delete was not processed.' => 'Benutzerkonto \'[_1]\' nicht gefunden, Löschung daher nicht durchgeführt.',
	'User \'[_1]\' has been deleted.' => 'Benutzerkonto \'[_1]\' gelöscht.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Add [_1] to a blog' => '[_1] zu Blog hinzufügen',
	'You can not create associations for disabled groups.' => 'Deaktivierte Gruppen können nicht zugewiesen werden.',
	'Assign Role to Group' => 'Rolle an Gruppe zuweisen',
	'Add a group to this blog' => 'Diesem Blog Gruppe hinzufügen',
	'Grant permission to a group' => 'Berechtigung an Gruppe vergeben',
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced hat während der Synchronisation versucht, Ihr Benutzerkonto zu deaktivieren. Das deutet auf einen Fehler in der externen Benutzerverwaltung hin. Überprüfen Sie daher die dortigen Einstellungen, bevor Sie Ihre Arbeit in Movable Type forsetzen.',
	'Group requires name' => 'Gruppenname erforderlich',
	'Invalid group' => 'Ungültige Gruppe',
	'Add Users to Group [_1]' => 'Benutzer zu Gruppe [_1] hinzufügen',
	'Users & Groups' => 'Benutzer und Gruppen',
	'User Groups' => 'Benutzergruppen',
	'Group load failed: [_1]' => 'Fehler beim Laden einer Gruppe:',
	'User load failed: [_1]' => 'Fehler beim Laden eines Benutzers:',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Benutzer \'[_1]\' (ID:[_2]) von \'[_5]\' aus Gruppe \'[_3]\' (ID:[_4]) entfernt',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Benutzer \'[_1]\' (ID:[_2]) von \'[_5]\' zu Gruppe \'[_3]\' (ID:[_4]) hinzugefügt',
	'Group Profile' => 'Gruppenprofile',
	'Author load failed: [_1]' => 'Fehler beim Laden eines Autoren: [_1]',
	'Invalid user' => 'Ungültiger Benutzer',
	'Assign User [_1] to Groups' => 'Gruppen an Benutzer [_1] zuweisen',
	'Select Groups' => 'Gruppen auswählen',
	'Group' => 'Gruppe',
	'Groups Selected' => 'Gewählte Gruppen',
	'Type a group name to filter the choices below.' => 'Geben Sie einen Gruppennamen ein, um die Auswahl einzuschränken.',
	'Group Name' => 'Gruppenname',
	'Search Groups' => 'Gruppen suchen',
	'Bulk import cannot be used under external user management.' => 'Stapelimport ist bei externer Benutzerverwaltung nicht möglich.',
	'Bulk management' => 'Stapelverwaltung',
	'No record found in the file.  Make sure the file uses CRLF as the line ending character.' => 'Keine Eintr?ge in der Datei gefunden. Stellen Sie sicher, da? CRLF f?r den Zeilenwechsel verwendet wird.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Benutzer] registiert, [quant,_2,Benutzerkonto,Benutzerkonten] aktualisiert, [quant,_3,Benutzerkonto,Benutzerkonten] gel?scht.',
	'The group' => 'Die Gruppe',
	'User/Group' => 'Benutzer/Gruppe',
	'A user can\'t change his/her own username in this environment.' => 'Benutzer können ihre eigenen Benutzernamen in diesem Kontext nicht ändern.',
	'An error occurred when enabling this user.' => 'Bei der Aktivierung dieses Benutzerkontos ist ein Fehler aufgetreten',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Bereite Binärdaten zur Speicherung in Microsoft SQL Server vor...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Login',
	'Found' => 'Gefunden',
	'Not Found' => 'Nicht gefunden',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ungültiges LDAPAuthURL-Schema: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Verbindung zu LDAP-Server [_1] fehlgeschlagen: [_2]',
	'User not found on LDAP: [_1]' => 'Benutzer nicht im LDAP-Verzeichnis gefunden:',
	'Binding to LDAP server failed: [_1]' => 'Bindung an LDAP-Server fehlgeschlagen: [_1]',
	'More than one user with the same name found on LDAP: [_1]' => 'Mehrere Benutzer mit identischem Namen im LDAP-Verzeichnis gefunden: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] wird von dieser Version des Microsoft SQL Server-Treibers nicht unterstützt.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Diese Version des UMSSQLServer-Treibers erfordert DBD::ODBC in der Version 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Diese Version des UMSSQLServer-Treiber erfodert ein mit Unicode-Unterstützung compiliertes DBD::ODBC.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Benutzerverwaltung im Stapel',
	'_USAGE_AUTHORS_2' => 'Sie können Benutzerkonto im Stapel anlegen, bearbeiten und löschen, indem Sie CSV-formatierte Steuerungsdatei mit den entsprechenden Daten und Befehlen hochladen.',
	'Upload source file' => 'Quelldatei hochladen',
	'Specify the CSV-formatted source file for upload' => 'Geben Sie die hochzuladende CSV-Quelldatei an',
	'Source File Encoding' => 'Zeichenkodierung der Quelldatei',
	'Upload (u)' => 'Hochladen (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'Authentication Configuration' => 'Authentifizierungs- Einstellungen',
	'You must set your Authentication URL.' => 'Authentifizierungs-URL erforderlich',
	'You must set your Group search base.' => 'Groupsearchbase-Attribut erforderlich',
	'You must set your UserID attribute.' => 'UserID-Attribut erforderlich',
	'You must set your email attribute.' => 'Email-Attribut erforderlich',
	'You must set your user fullname attribute.' => 'Userfullname-Attribut erforderlich',
	'You must set your user member attribute.' => 'Usermember-Attribut erforderlich',
	'You must set your GroupID attribute.' => 'GroupID-Attribut erforderlich',
	'You must set your group name attribute.' => 'Groupname-Attribut erforderlich',
	'You must set your group fullname attribute.' => 'Groupfullname-Attribut erforderlich',
	'You must set your group member attribute.' => 'Groupmember-Attribut erforderlich',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Wenn Sie LDAP-Authentifizierung verwenden möchten, können Sie hier die entsprechenden Einstellungen vornehmen.',
	'Your configuration was successful.' => 'Konfigurierung erfolgreich.',
	'Click \'Continue\' below to configure the External User Management settings.' => 'Klicken Sie auf \'Weiter\', um die externe Benutzerverwaltung zu konfigurieren.',
	'Click \'Continue\' below to configure your LDAP attribute mappings.' => 'Klicken Sie auf \'Weiter\', um die LDAP-Attribute zuzuweisen.',
	'Your LDAP configuration is complete.' => 'Ihre LDAP-Konfigurierung ist abgeschlossen.',
	'To finish with the configuration wizard, press \'Continue\' below.' => 'Mit einem Klick auf \'Weiter\' schließen Sie die Konfigurierung ab.',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Es konnte keine Verbindung zum LDAP-Server aufgebaut werden: ',
	'Use LDAP' => 'LDAP verwenden',
	'Authentication URL' => 'Authentifizierungs-URL',
	'The URL to access for LDAP authentication.' => 'Adresse (URL) zur LDAP-Authentifizierung',
	'Authentication DN' => 'Authentifizierungs-DN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Optionaler DN zur LDAP-Bindung bei der Benutzersuche',
	'Authentication password' => 'Authentifizierungs- Passwort',
	'Used for setting the password of the LDAP DN.' => 'Wird zur Einstellung des LDAP DN-Passworts verwendet',
	'SASL Mechanism' => 'SASL-Mechanismus',
	'The name of SASL Mechanism to use for both binding and authentication.' => 'Name des für Bindung und Authentifizierung verwendeten SASL-Mechanismus',
	'Test Username' => 'Test-Benutzername',
	'Test Password' => 'Test-Passwort',
	'Enable External User Management' => 'Externe Benutzerverwaltung aktivieren',
	'Synchronization Frequency' => 'Aktualisierungsintervall',
	'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Aktualisierungsintervall in Minuten (Standard: 60 Minuten)',
	'15 Minutes' => '15 Minuten',
	'30 Minutes' => '30 Minuten',
	'60 Minutes' => '60 Minuten',
	'90 Minutes' => '90 Minuten',
	'Group search base attribute' => 'Groupsearchbase-Attribut',
	'Group filter attribute' => 'Groupfilter-Attribut',
	'Search Results (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'CN' => 'CN (Common Name)',
	'No groups were found with these settings.' => 'Keine Gruppe mit diesen Einstellungen gefunden.',
	'Attribute mapping' => 'Attributzuordnung',
	'LDAP Server' => 'LDAP-Server',
	'Other' => 'Anderer',
	'User ID attribute' => 'UserID-Attribut',
	'Email Attribute' => 'Email-Attribut',
	'User fullname attribute' => 'Userfullname-Attribut',
	'User member attribute' => 'Usermember-Attribut',
	'GroupID attribute' => 'GroupID-Attribut',
	'Group name attribute' => 'Groupname-Attribut',
	'Group fullname attribute' => 'Groupfullname-Attribut',
	'Group member attribute' => 'Groupmember-Attribut',
	'Search result (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'Group Fullname' => 'Groupfullname',
	'Group Member' => 'Groupmember',
	'No groups could be found.' => 'Keine Gruppen gefunden.',
	'User Fullname' => 'Userfullname',
	'No users could be found.' => 'Keine Benutzer gefunden.',
	'Test connection to LDAP' => 'LDAP-Verbindung testen',
	'Test search' => 'Testsuche',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users updated successfully!' => 'Alle Benutzerkonten erfolgreich aktualisiert!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Während der Aktualisierung ist ein Fehler aufgetreten. Bitte überprüfen Sie Ihre CSV-Datei.',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Bitte legen Sie einige Gruppen an.',
	'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Bitte legen Sie zuerst einige Gruppen an. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Klicken Sie hier </a> um Gruppen anzulegen.',

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Gruppe bearbeiten',
	'Create Group' => 'Gruppe anlegen',
	'Group profile has been updated.' => 'Gruppenprofil aktualisiert.',
	'LDAP Group ID' => 'LDAP-Gruppen-ID',
	'The LDAP directory ID for this group.' => 'Die ID dieser Gruppe im LDAP-Verzeichnis',
	'Status of group in the system. Disabling a group removes its members&rsquo; access to the system but preserves their content and history.' => 'Globaler Gruppenstatus. Deaktivierung einer Gruppe entzieht ihren Mitgliedern den Zugang zum System. Inhalte und Nutzungsverläufe der Mitglieder bleiben jedoch erhalten.',
	'The name used for identifying this group.' => 'Der zur Idenfifizierung diesser Gruppe verwendete Name',
	'The display name for this group.' => 'Der Anzeigename dieser Gruppe',
	'Enter a description for your group.' => 'Geben Sie eine Gruppenbeschreibung ein.',
	'Created on' => 'Angelegt',
	'Save changes to this field (s)' => 'Feld-?nderungen speichern (s)',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'group' => 'Gruppe',
	'groups' => 'Gruppen',
	'Enable selected group (e)' => 'Gew?hlte Gruppe aktivieren (e)',
	'Disable selected group (d)' => 'Gew?hlte Gruppe deaktivieren (d)',
	'Remove selected group (d)' => 'Gew?hlte Gruppe entfernen (d)',
	'Only show enabled groups' => 'Nur aktivierte Gruppen zeigen',
	'Only show disabled groups' => 'Nur deaktivierte Gruppen zeigen',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Benutzer und Gruppen für [_1]',
	'Group Associations for [_1]' => 'Gruppenzuweisungen für [_1]',

## addons/Enterprise.pack/tmpl/include/users_content_nav.tmpl
	'Users &amp; Groups' => 'Benutzer und Gruppen',

## addons/Enterprise.pack/tmpl/list_group_member.tmpl
	'[_1]: Group Members' => '[_1]: Gruppenmitglieder',
	'<em>[_1]</em>: Group Members' => '<em>[_1]</em>: Gruppenmitglieder',
	'You have successfully deleted the users.' => 'Benutzer erfolgreich gelöscht.',
	'You have successfully added new users to this group.' => 'Benutzer erfolgreich zur Gruppe hinzugefügt.',
	'You have successfully synchronized users\' information with external directory.' => 'Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.',
	'Some ([_1]) of the selected users could not be re-enabled because they were no longer found in LDAP.' => 'Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie nicht mehr im LDAP-Verzeichnis vorhanden sind.',
	'You have successfully removed the users from this group.' => 'Benutzer erfolgreich aus Gruppe entfernt.',
	'Group Disabled' => 'Gruppe deaktiviert',
	'You can not add users to a disabled group.' => 'Zu deaktivierten Gruppen können keine Benutzer hinzugefügt werden.',
	'Add user to [_1]' => 'Benutzer zu [_1] hinzufügen',
	'member' => 'Mitglied',
	'Show Enabled Members' => 'Aktivierte Mitglieder zeigen',
	'Show Disabled Members' => 'Deaktivierte Mitglieder zeigen',
	'Show All Members' => 'Alle Mitglieder zeigen',
	'None.' => 'Keine.',
	'(Showing all users.)' => '(Zeige alle Benutzer)',
	'Showing only users whose [_1] is [_2].' => 'Zeige nur Benutzer mit [_2].',
	'Show' => 'Anzeigen',
	'all' => 'alle',
	'only' => 'nur',
	'users where' => 'Benutzer mit',
	'No members in group' => 'Gruppe ohne Mitglieder',
	'Only show enabled users' => 'Nur aktivierte Benutzer zeigen',
	'Only show disabled users' => 'Nur deaktivierte Benutzer zeigen',
	'You did not select any [_1] to remove.' => 'Keine zu entfernende [_1] gewählt.',
	'Are you sure you want to remove this [_1] from this group?' => '[_1] wirklich aus dieser Gruppe entfernen?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => '[_1] gewählten [_2] wirklich aus dieser Gruppe entfernen?',
	'to remove' => 'zu entfernen',

## addons/Enterprise.pack/tmpl/list_group.tmpl
	'[_1]: User&rsquo;s Groups' => '[_1]: Zugewiesene Gruppen',
	'Manage Groups' => 'Gruppen verwalten',
	'You have successfully disabled the selected group(s).' => 'Gewählte Gruppe(n) erfolgreich deaktiviert.',
	'You have successfully enabled the selected group(s).' => 'Gewählte Gruppe(n) erfolgreich aktiviert.',
	'You have successfully deleted the groups from the Movable Type system.' => 'Gruppen erfolgreich aus dem System gelöscht.',
	'You have successfully synchronized groups\' information with the external directory.' => 'Gruppeninformationen erfolgreich mit externem Verzeichnis synchronisiert.',
	'The user <em>[_1]</em> is currently disabled.' => 'Das Benutzerkonto von <em>[_1]</em> ist derzeit deaktiviert.',
	'You can not add disabled users to groups.' => 'Deaktivierte Benutzer können nicht zu Gruppen hinzugefügt werden.',
	'Add [_1] to another group' => '[_1] zu weiterer Gruppe hinzufügen',
	'Are you sure you want to remove this [_1]?' => '[_1] wirklich entfernen?',
	'Are you sure you want to remove the [_1] selected [_2]?' => '[_1] gewählte [_2] wirklich entfernen?',

## plugins/ActionStreams/blog_tmpl/actions.mtml
	'Recent Actions' => 'Aktuelle Aktionen',

## plugins/ActionStreams/blog_tmpl/archive.mtml

## plugins/ActionStreams/blog_tmpl/banner_footer.mtml

## plugins/ActionStreams/blog_tmpl/comment_listing.mtml

## plugins/ActionStreams/blog_tmpl/elsewhere.mtml
	'Find [_1] Elsewhere' => '[_1] anderswo finden',

## plugins/ActionStreams/blog_tmpl/main_index.mtml

## plugins/ActionStreams/blog_tmpl/sidebar.mtml

## plugins/ActionStreams/config.yaml
	'Manages authors\' accounts and actions on sites elsewhere around the web' => 'Verwaltet die Benutzerkonten und Ereignisse des Autors auf anderen Websites',
	'Are you sure you want to hide EVERY event in EVERY action stream?' => 'Wirklich ALLE Ereignisse in ALLEN Action Streams verstecken?',
	'Are you sure you want to show EVERY event in EVERY action stream?' => 'Wirklich ALLE Ereignisse in ALLEN Action Streams anzeigen?',
	'Deleted events that are still available from the remote service will be added back in the next scan. Only events that are no longer available from your profile will remain deleted. Are you sure you want to delete the selected event(s)?' => 'Gelöschte Ereignisse, die bei dem jeweiligen Web-Dienst noch aufgeführt sind, werden bei der nächsten Aktualisierung wieder hinzugefügt. Gelöscht werden nur Ereignisse, die nicht mehr in Ihrem Profil verfügbar sind. Gewählte Ereignisse wirklich löschen?',
	'Hide All' => 'Alle verbergen',
	'Show All' => 'Alle zeigen',
	'Poll for new events' => 'Auf neue Ereignisse abfragen',
	'Update Events' => 'Ereignisse aktualisieren',
	'Action Stream' => 'Action Streams',
	'Main Index (Recent Actions)' => 'Startseite (aktuelle Aktionen)',
	'Action Archive' => 'Aktions-Archiv',
	'Feed - Recent Activity' => 'Feed - Aktuelle Aktivitäten',
	'Find Authors Elsewhere' => 'Autoren anderswo finden',
	'Enabling default action streams for selected profiles...' => 'Aktiviere Standard-Action Streams für die gewählten Profile...',

## plugins/ActionStreams/lib/ActionStreams/Event.pm
	'[_1] updating [_2] events for [_3]' => '[_1] aktualisiert [_2]-Ereignisse für [_3]',
	'Error updating events for [_1]\'s [_2] stream (type [_3] ident [_4]): [_5]' => 'Fehler bei der Aktualisierung der Ereignisse für [_1]s [_2]-Stream (Typ [_3], Ident [_4]): [_5]',
	'Could not load class [_1] for stream [_2] [_3]: [_4]' => 'Konnte Klasse [_1] für Stream [_2] [_3] nicht laden: [_4]',
	'No URL to fetch for [_1] results' => 'Keine URL zum Einlesen von [_1]-Ergebnissen',
	'Could not fetch [_1]: [_2]' => '[_1] konnte nicht einlesen gewerden: [_2]',
	'Aborted fetching [_1]: [_2]' => 'Einlesen von [_1] abgebrochen: [_2]',

## plugins/ActionStreams/lib/ActionStreams/Plugin.pm
	'Other Profiles' => 'Andere Profile',
	'Profiles' => 'Profile',
	'Actions from the service [_1]' => 'Aktionen bei [_1]',
	'Actions that are shown' => 'Angezeigte Ereignisse',
	'Actions that are hidden' => 'Versteckte Ereignisse',
	'No such event [_1]' => 'Kein solches Ereignis [_1]',
	'[_1] Profile' => '[_1] Profil',

## plugins/ActionStreams/lib/ActionStreams/Tags.pm
	'No user [_1]' => 'Kein Benutzer [_1]',

## plugins/ActionStreams/lib/ActionStreams/Upgrade.pm
	'Updating classification of [_1] [_2] actions...' => 'Aktualisiere Klassifizierungen von [_1] [_2]-Aktionen',
	'Renaming "[_1]" data of [_2] [_3] actions...' => 'Benenne "[_1]"-Daten von [_2] [_3]-Aktionen um...',

## plugins/ActionStreams/lib/ActionStreams/Worker.pm
	'No such author with ID [_1]' => 'Kein solcher Autor mit ID [_1]',

## plugins/ActionStreams/services.yaml
	'1up.com' => '1up.com',
	'43Things' => '43Things',
	'Screen name' => 'Bildschirmname',
	'backtype' => 'backtype',
	'Bebo' => 'Bebo',
	'Catster' => 'Catster',
	'COLOURlovers' => 'COLOURlovers',
	'Cork\'\'d\'' => 'Cork\'d',
	'Delicious' => 'Delicious',
	'Destructoid' => 'Destructoid',
	'Digg' => 'Digg',
	'Dodgeball' => 'Dodgeball',
	'Dogster' => 'Dogster',
	'Dopplr' => 'Dopplr',
	'Facebook' => 'Facebook',
	'User ID' => 'Benutzerkennung',
	'You can find your Facebook userid within your profile URL.  For example, http://www.facebook.com/profile.php?id=24400320.' => 'Ihre Facebook-Benutzerkennung ist die Zahl in der Webadresse Ihres Profils; z.B. http://www.facebook.com/profile.php?id=24400320',
	'FFFFOUND!' => 'FFFFOUND!',
	'Flickr' => 'Flickr',
	'Enter your Flickr userid which contains "@" in it, e.g. 36381329@N00.  Flickr userid is NOT the username in the URL of your photostream.' => 'Ihre Flickr-Benutzerkennung ist NICHT Ihr Benutzername, sondern der Teil der Webadresse Ihres Profils mit dem "@"-Zeichen; z.B. 36381329@N00',
	'FriendFeed' => 'FriendFeed',
	'Gametap' => 'Gametap',
	'Google Blogs' => 'Google Blogs',
	'Search term' => 'Suchbegriff',
	'Google News' => 'Google News',
	'Search for' => 'Suchen nach',
	'Goodreads' => 'Goodreads',
	'You can find your Goodreads userid within your profile URL. For example, http://www.goodreads.com/user/show/123456.' => 'Ihre Goodreads-Benutzerkennung ist die Zahl in der Webadresse Ihres Profils; z.B. http://www.goodreads.com/user/show/123456',
	'Google Reader' => 'Google Reader',
	'Sharing ID' => 'Sharing-ID',
	'Hi5' => 'Hi5',
	'IconBuffet' => 'IconBuffet',
	'ICQ' => 'ICQ',
	'UIN' => 'UIN',
	'Identi.ca' => 'Identi.ca',
	'Iminta' => 'Iminta',
	'iStockPhoto' => 'iStockPhoto',
	'You can find your istockphoto userid within your profile URL.  For example, http://www.istockphoto.com/user_view.php?id=1234567.' => 'Ihre istockphoto-Benutzerkennung ist die Zahl in der Webadresse Ihres Profils; z.B. http://www.istockphoto.com/user_view.php?id=1234567',
	'IUseThis' => 'IUseThis',
	'iwatchthis' => 'iwatchthis',
	'Jabber' => 'Jabber',
	'Jabber ID' => 'Jabber-ID',
	'Jaiku' => 'Jaiku',
	'Kongregate' => 'Kongregate',
	'Last.fm' => 'Last.fm',
	'LinkedIn' => 'LinkedIn',
	'Profile URL' => 'Profil-URL',
	'Ma.gnolia' => 'Ma.gnolia',
	'MOG' => 'MOG',
	'MSN Messenger\'' => 'MSN Messenger',
	'Multiply' => 'Multiply',
	'MySpace' => 'MySpace',
	'Netflix' => 'Netflix',
	'Netflix RSS ID' => 'Netflix RSS-ID',
	'To find your Netflix RSS ID, click "RSS" at the bottom of any page on the Netflix site, then copy and paste in your "Queue" link.' => 'Ihre Netflix RSS-ID finden Sie, indem Sie auf einer beliebigen Netflix-Seite unten auf "RSS" klicken und dann den "Queue"-Link koppieren',
	'Netvibes' => 'Netvibes',
	'Newsvine' => 'Newsvine',
	'Ning' => 'Ning',
	'Social Network URL' => 'Social Network-URL',
	'Ohloh' => 'Ohloh',
	'Orkut' => 'Orkut',
	'You can find your orkut uid within your profile URL. For example, http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789' => 'Ihre Orkut-Benutzerkennung ist die Zahl in der Webadresse Ihres Profils nach "uid="; z.B. http://www.orkut.com/Main#Profile.aspx?rl=ls&uid=1234567890123456789',
	'Pandora' => 'Pandora',
	'Picasa Web Albums' => 'Picasa Web-Alben',
	'p0pulist' => 'p0pulist',
	'You can find your p0pulist user id within your Hot List URL. for example, http://p0pulist.com/list/hot_list/10000' => 'Ihre p0pulist-Benutzerkennung ist die Zahl in der Webadresse Ihres Profil; z.B. http://p0pulist.com/list/hot_list/10000',
	'Pownce' => 'Pownce',
	'Reddit' => 'Reddit',
	'Skype' => 'Skype',
	'SlideShare' => 'SlideShare',
	'Smugmug' => 'Smugmug',
	'SonicLiving' => 'SonicLiving',
	'You can find your SonicLiving userid within your share&subscribe URL. For example, http://sonicliving.com/user/12345/feeds' => 'Ihre SonicLiving-Benutzerkennung ist die Zahl in der Webadresse Ihrer Share&Subscribe-Seite; z.B. http://sonicliving.com/user/12345/feeds',
	'Steam' => 'Steam',
	'StumbleUpon' => 'StumbleUpon',
	'Tabblo' => 'Tabblo',
	'Blank should be replaced by positive sign (+).' => 'Verwenden Sie statt Leerzeichen Pluszeichen (+)',
	'Tribe' => 'Tribe',
	'You can find your tribe userid within your profile URL.  For example, http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a.' => 'Ihre Tribe-Benutzerkennung ist die Zahl in der Webadresse Ihres Profils; z.B. http://people.tribe.net/dcdc61ed-696a-40b5-80c1-e9a9809a726a',
	'Tumblr' => 'Tumblr',
	'Twitter' => 'Twitter',
	'TwitterSearch' => 'TwitterSearch',
	'Uncrate' => 'Uncrate',
	'Upcoming' => 'Upcoming',
	'Viddler' => 'Viddler',
	'Vimeo' => 'Vimeo',
	'Virb' => 'Virb',
	'You can find your VIRB userid within your home URL.  For example, http://www.virb.com/backend/2756504321310091/your_home.' => 'Ihre Virb-Benutzerkennung ist die Zahl in der Webadresse Ihrer Startseite; z.B. http://www.virb.com/backend/2756504321310091/your_home',
	'Vox name' => 'Vox-Name',
	'Wists' => 'Wists',
	'Xbox Live\'' => 'Xbox Live',
	'Gamertag' => 'Gamertag',
	'Yahoo! Messenger\'' => 'Yahoo! Messenger',
	'Yelp' => 'Yelp',
	'YouTube' => 'YouTube',
	'Zooomr' => 'Zooomr',

## plugins/ActionStreams/streams.yaml
	'Currently Playing' => 'Aktuelle Spiele',
	'The games in your collection you\'re currently playing' => 'Spiele, die Sie derzeit spielen',
	'Comments you have made on the web' => 'Kommentare, die Sie im Web geschrieben haben',
	'Colors' => 'Farben',
	'Colors you saved' => 'Ihre gespeicherten Farben',
	'Palettes' => 'Paletten',
	'Palettes you saved' => 'Ihre gespeicherten Paletten',
	'Patterns' => 'Muster',
	'Patterns you saved' => 'Ihre gespeicherten Muster',
	'Favorite Palettes' => 'Lieblings-Paletten',
	'Palettes you saved as favorites' => 'Paletten, die Sie als Favoriten gespeichert haben',
	'Reviews' => 'Kritiken',
	'Your wine reviews' => 'Ihre Wein-Kritiken',
	'Cellar' => 'Weinkeller',
	'Wines you own' => 'Weine in Ihrer Sammlung',
	'Shopping List' => 'Shopping-Liste',
	'Wines you want to buy' => 'Weine, die Sie kaufen möchten',
	'Links' => 'Links',
	'Your public links' => 'Ihre öffentlichen Links',
	'Dugg' => 'Gediggt',
	'Links you dugg' => 'Links, die Sie gediggt haben',
	'Submissions' => 'Eingereicht',
	'Links you submitted' => 'Links, die Sie eingereicht haben',
	'Found' => 'Gefunden',
	'Photos you found' => 'Fotos, die Sie gefunden haben',
	'Favorites' => 'Favoriten',
	'Photos you marked as favorites' => 'Fotos, die Sie als Favoriten gespeichert haben',
	'Photos' => 'Fotos',
	'Photos you posted' => 'Fotos, die Sie veröffentlicht haben',
	'Likes' => 'Gefallen',
	'Things from your friends that you "like"' => 'Veröffentlichungen Ihrer Freude, die Ihnen gefallen haben',
	'Leaderboard scores' => 'Leaderboard-Scores',
	'Your high scores in games with leaderboards' => 'Ihre High Scores in Leaderboard-Spielen',
	'Blog posts about your search term' => 'Blog-Einträge zu Ihrem Suchbegriff',
	'Stories' => 'Nachrichten',
	'News Stories matching your search' => 'Nachrichten zu Ihrem Suchbegriff',
	'To read' => 'Zu lesen',
	'Books on your "to-read" shelf' => 'Bücher, die Sie noch lesen möchten',
	'Reading' => 'Aktuelle Lektüre',
	'Books on your "currently-reading" shelf' => 'Bücher, die Sie derzeit lesen',
	'Read' => 'Gelesen',
	'Books on your "read" shelf' => 'Bücher, die Sie bereits gelesen haben',
	'Shared' => 'Geteilt',
	'Your shared items' => 'Geteilte Artikel',
	'Deliveries' => 'Lieferungen',
	'Icon sets you were delivered' => 'Ihre gelieferten Icon-Gruppen',
	'Notices' => 'Hinweise',
	'Notices you posted' => 'Hinweise, die Sie veröffentlicht haben',
	'Intas' => 'Intas',
	'Links you saved' => 'Ihre veröffentlichten Links',
	'Photos you posted that were approved' => 'Fotos von Ihnen, die auf Zustimmung gestoßen sind',
	'Recent events' => 'Aktuelle Ereignisse',
	'Events from your recent events feed' => 'Ereignisse von Ihrem Aktuelle Ereignisse-Feed',
	'Apps you use' => 'Anwendungen',
	'The applications you saved as ones you use' => 'Anwendungen, die Sie einsetzen',
	'Videos you saved as watched' => 'Videos, die Sie gesehen haben',
	'Jaikus' => 'Jaikus',
	'Jaikus you posted' => 'Ihre Jaikus',
	'Games you saved as favorites' => 'Spiele, die Sie als Favoriten gespeichert haben',
	'Achievements' => 'Erfolge',
	'Achievements you won' => 'Erfolge, die Sie erzielt haben',
	'Tracks' => 'Lieder',
	'Songs you recently listened to (High spam potential!)' => 'Lieder, die Sie kürzlich gehört haben (hohe Spam-Gefahr!)',
	'Loved Tracks' => 'Lieblingslieder',
	'Songs you marked as "loved"' => 'Ihre Lieblingslieder',
	'Journal Entries' => 'Tagebuch-Einträge',
	'Your recent journal entries' => 'Ihre aktuellen Tagebuch-Einträge',
	'Events' => 'Veranstaltungen',
	'The events you said you\'ll be attending' => 'Veranstaltungen, an denen Sie  teilnehmen werden',
	'Your public posts to your journal' => 'Ihre öffentlichen Tagebuch-Einträge',
	'Queue' => 'Ausleihliste',
	'Movies you added to your rental queue' => 'Filme auf Ihrer Ausleihliste',
	'Recent Movies' => 'Aktuelle Filme',
	'Recent Rental Activity' => 'Kürzlich ausgeliehene Filme',
	'Kudos' => 'Kudos',
	'Kudos you have received' => 'Kudos, die Sie erhalten haben',
	'Favorite Songs' => 'Lieblings-Lieder',
	'Songs you marked as favorites' => 'Ihre Lieblings-Lieder',
	'Favorite Artists' => 'Lieblings-Musiker',
	'Artists you marked as favorites' => 'Ihre Lieblings-Musiker',
	'Stations' => 'Sender',
	'Radio stations you added' => 'Radiostationen, die Sie in Ihre Liste aufgenommen haben',
	'List' => 'Liste',
	'Things you put in your list' => 'Dinge auf Ihrer Liste',
	'Notes' => 'Notizen',
	'Your public notes' => 'Ihre öffentlichen Notizen',
	'Comments you posted' => 'Ihre Kommentare',
	'Articles you submitted' => 'Artikel, die Sie eingereicht haben',
	'Articles you liked (your votes must be public)' => 'Artikel, die Ihnen gefallen haben (bei öffentlicher Abstimmung)',
	'Dislikes' => 'Nicht gefallen',
	'Articles you disliked (your votes must be public)' => 'Artikel, die Ihnen nicht gefallen haben (bei öffentlicher Abstimmung)',
	'Slideshows you saved as favorites' => 'Slideshows, die Sie als Favoriten gespeichert haben',
	'Slideshows' => 'Slideshows',
	'Slideshows you posted' => 'Slideshows, die Sie veröffentlicht haben',
	'Your achievements for achievement-enabled games' => 'Ihre Achievements bei Spielen, die das Achievements-System unterstützen',
	'Stuff' => 'Sachen',
	'Things you posted' => 'Sachen, die Sie veröffentlicht haben',
	'Tweets' => 'Tweets',
	'Your public tweets' => 'Ihre öffentlichen Tweets',
	'Public tweets you saved as favorites' => 'Öffentliche Tweets, die Sie als Ihre Favoriten gespeichert haben',
	'Tweets about your search term' => 'Tweets zu Ihren Suchbegriffen',
	'Saved' => 'Gespeichert',
	'Things you saved as favorites' => 'Dinge, die Sie als Favoriten gespeichert haben',
	'Events you are watching or attending' => 'Veranstaltungen, an denen Sie teilnehmen',
	'Videos you posted' => 'Videos, die Sie veröffentlicht haben',
	'Videos you liked' => 'Videos, die Ihnen gefallen haben',
	'Public assets you saved as favorites' => 'Öffentliche Assets, die Sie als Favoriten gespeichert haben',
	'Your public photos in your Vox library' => 'Ihre öffentlichen Fotos in Ihrer Vox-Sammlung',
	'Your public posts to your Vox' => 'Ihre öffentlichen Einträge auf Vox',
	'The posts available from the website\'s feed' => 'Die im Feed der Website verfügbaren Einträge.',
	'Stuff you saved' => 'Sachen, die Sie gespeichert haben',
	'Gamerscore' => 'Gamerscore',
	'Notes when your gamerscore passes an even number' => 'Benachrichtigt Sie, wenn Ihr Gamerscore eine gerade Zahl überschritten wird',
	'Places you reviewed' => 'Orte, über die Sie Kritiken geschrieben haben',
	'Videos you saved as favorites' => 'Vidoes, die Sie als Favoriten gespeichert haben',

## plugins/ActionStreams/tmpl/blog_config_template.tmpl
	'Rebuild Indexes' => 'Indizes neu aufbauen',
	'If selected, this blog\'s indexes will be rebuilt when new action stream events are discovered.' => 'Falls aktiviert, werden die Indizes dieses Blogs neu aufgebaut, wenn neue Action Stream-Ereignisse eintreffen',
	'Enable rebuilding' => 'Neuaufbau aktivieren',

## plugins/ActionStreams/tmpl/dialog_add_profile.tmpl
	'Add Profile' => 'Profil hinzufügen',
	'Your user name or ID is required.' => 'Ihr Benutzername oder Ihre ID ist erforderlich.',
	'Add a profile on a social networking or instant messaging service.' => 'Profil bei einem Social Network oder Instant Messaging-Dienst hinzufügen',
	'Service' => 'Dienst',
	'Select a service where you already have an account.' => 'Wählen Sie einen Dienst, bei dem Sie bereits ein Benutzerkonto haben.',
	'Enter your account on the selected service.' => 'Geben Sie Ihren Benutzernamen beim gewählten Dienst ein.',
	'For example:' => 'Beispiel:',
	'Action Streams' => 'Action Streams:',
	'Select the action streams to collect from the selected service.' => 'Wählen Sie, welche Action Streams beim gewählten Dienst abgefragt werden sollen.',
	'No streams are available for this service.' => 'Für diesen Dienst sind keine Action Streams verfügbar.',
	'Add Profile (s)' => 'Profil hinzufügen (s)',

## plugins/ActionStreams/tmpl/dialog_edit_profile.tmpl
	'Edit a profile on a social networking or instant messaging service.' => 'Bearbeiten Sie Ihr Profil bei einem Social Network oder Instant Messaging-Dienst.',

## plugins/ActionStreams/tmpl/list_profileevent.tmpl
	'The selected events were deleted.' => 'Die gewählten Ereignisse wurden gelöscht.',
	'The selected events were hidden.' => 'Die gewählten Ereignisse werden verborgen.',
	'The selected events were shown.' => 'Die gewählten Ereignisse werden angezeigt.',
	'All action stream events were hidden.' => 'Die Action Stream-Ereignisse werden verborgen.',
	'All action stream events were shown.' => 'Alle Action Stream-Ereignisse werden angezeigt.',
	'event' => 'Ereignis',
	'events' => 'Ereignisse',
	'Hide selected events (h)' => 'Gewählte Ereignisse verbergen (h)',
	'Hide' => 'Verbergen',
	'Show selected events (h)' => 'Gewählte Ereignisse anzeigen (h)',
	'Show' => 'Anzeigen',
	'All stream actions' => 'Alle Ereignisse des Streams',
	'Show only actions where' => 'Nur Ereignisse zeigen',
	'service' => 'bei Dienst',
	'visibility' => 'mit Sichtbarkeit',
	'hidden' => 'versteckt',
	'shown' => 'sichtbar',
	'No events could be found.' => 'Keine Ereignisse gefunden',
	'Event' => 'Ereignis',
	'Shown' => 'Angezeigt',
	'Hidden' => 'Verborgen',
	'View action link' => 'Action Link anzeigen',
	'<mt:var name="object_label_plural" escape="js">' => '<mt:var name="object_label_plural" escape="js">',

## plugins/ActionStreams/tmpl/other_profiles.tmpl
	'The selected profile was added.' => 'Gewähltes Profil hinzugefügt.',
	'The selected profiles were removed.' => 'Gewählte Profile entfernt.',
	'The selected profiles were scanned for updates.' => 'Gewählte Profile auf Aktualisierungen überprüft.',
	'The changes to the profile have been saved.' => 'Profiländerungen gespeichert.',
	'profile' => 'Profil',
	'profiles' => 'Profile',
	'Delete selected profiles (x)' => 'Gewählte Profile löschen (x)',
	'to update' => 'zu aktualisieren',
	'Scan now for new actions' => 'Jetzt auf neue Aktionen überprüfen',
	'Update Now' => 'Jetzt aktualisieren',
	'No profiles were found.' => 'Keine Profile gefunden.',
	'external_link_target' => 'external_link_target',
	'View Profile' => 'Proil ansehen',

## plugins/ActionStreams/tmpl/widget_recent.mtml
	'Your Recent Actions' => 'Ihre aktuellen Aktionen',
	'blog this' => 'Diese Sache bloggen',
	'No actions could be found.' => 'Keine Aktionen gefunden.',

## plugins/CommunityActionStreams/config.yaml
	'Action streams for community events: add entry, add comment, add favorite, follow user.' => 'Action Streams für Community-Ereignisse: Eintrag hinzufügen, Kommentar hinzufügen, Favoriten hinzufügen, Benutzer folgen',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm

## plugins/FacebookCommenters/plugin.pl
	'Provides commenter registration through Facebook Connect.' => 'Ermöglicht es Kommentarautoren, sich über Facebook Connect zu registrieren',
	'Set up Facebook Commenters plugin' => 'Facebook Kommentarautoren-Plugin einrichten',
	'{*actor*} commented on the blog post <a href="{*post_url*}">{*post_title*}</a>.' => '{*actor*} hat den Blog-Eintrag <a href="{*post_url*}">{*post_title*}</a> kommentiert.',
	'Could not register story template with Facebook: [_1]. Did you enter the correct application secret?' => 'Das Story Template konnte nicht bei Facebook registriert werden: [_1]. Haben Sie das Application Secret richtig eingegeben?',
	'Could not register story template with Facebook: [_1]' => 'Das Story Template konnte nicht bei Facebook registriert werden: [_1]. ',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Facebook Application Key',
	'The key for the Facebook application associated with your blog.' => 'Der Application Key der mit Ihrem Blog verknüpften Facebook-Anwendung',
	'Edit Facebook App' => 'Facebook-Anwendung bearbeiten',
	'Create Facebook App' => 'Facebook-Anwendung erstellen',
	'Facebook Application Secret' => 'Facebook Application Secret',
	'The secret for the Facebook application associated with your blog.' => 'Das Application Secret der mit Ihrem Blog verknüpften Facebook-Anwendung',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Beim Einlesen von [_1] ist ein Fehler aufgetreten (zurückgegebener HTTP-Status: [_2]). Es wird die zuletzt erfolgreich eingelesene Version des Feeds verwendet.',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Beim Einlesen von [_1] ist ein Fehler aufgetreten (zurückgegebener HTTP-Status: [_2]). Es liegt keine vorherige Version des Feeds vor.',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' ist ein erforderliches Argument von [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] außerhalb seines Kontexts verwendet.',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Mit Feeds.App Lite binden Sie externe Newsfeeds in Ihre Blogs ein. Noch mehr Möglichkeiten erhalten Sie durch ein <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade auf Feeds.App</a>.',
	'Create a Feed Widget' => 'Feed-Widget anlegen',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widget Creator',
	'Configure feed widget settings' => 'Feed-Widget konfigurieren',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Vergeben Sie einen Namen für das Widget. Dieser Name wird auch als Name des Feeds in Ihrem Blog angezeigt werden.',
	'[_1] Feed Widget' => '[_1]-Feed-Widget',
	'Select the maximum number of entries to display.' => 'Anzahl der höchstens anzuzeigenden Einträge',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Alle',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => 'Keine Feeds per [_1] entdeckt.',
	'An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">here</a> for more detail and please try again.' => 'Fehler beim Einlesen von [_1]. Beachten Sie die  <a href="javascript:void(0)" onclick="closeDialog(\'http://www.feedvalidator.org/check.cgi?url=[_2]\')">Hinweise des Feed Validators</a> und versuchen Sie es ggf. erneut.',
	'A widget named <strong>[_1]</strong> has been created.' => 'Widget <strong>[_1]</strong> angelegt.',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">WidgetManager</a> or the following MTInclude tag:' => 'Sie können &ldquo;[_1]&rdquo; jetzt <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">bearbeiten</a> oder in Ihr Blog <a href="javascript:void(0)" onclick="closeDialog(\'[_3]\')">einbinden</a>. Alternativ können Sie dazu auch diesen MTInclude-Befehl verwenden:',
	'You may now <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:' => 'Sie können &ldquo;[_1]&rdquo; jetzt <a href="javascript:void(0)" onclick="closeDialog(\'[_2]\')">bearbeiten</a> oder mit diesem MTInclude-Befehl in Ihr Blog einbinden:',
	'Create Another' => 'Weiteres Widget anlegen',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Mehrere Feeds gefunden',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Wählen Sie den zu verwendenden Feed. <em>Feeds.App Lite unterstützt RSS 1.0-, RSS 2.0- und ATOM-Feeds.</em>',
	'URI' => 'URI',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'Geben Sie die Adresse eines Feeds oder einer Website an.',
	'Create a widget from a feed' => 'Feed als Widget anzeigen',
	'Feed or Site URL' => 'Feed- oder Website-URL',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Geben Sie die URL eines Feeds oder einer Website, die Feeds anbietet, ein:',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Ein Plugin, mit dem HTML wie normaler Text eingegeben werden kann.',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown mit SmartyPants',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => 'Wandelt einfache Interpunktionszeichen in typographisch korrekte Zecichen um.',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'Ihre Anmeldung über mixi ist fehlgeschlagen. Bitte versuchen Sie es erneut.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'Ermöglicht es Kommentarautoren, sich per OpenID mit ihrem mixi-Benutzernamen und -Passwort bei Movable Type anzumelden',
	'Sign in using your mixi ID' => 'Mit Ihrer mixi-ID anmelden',
	'Click the button to sign in using your mixi ID' => 'Klicken Sie den Knopf an, um sich mit Ihrer mixi-ID anzumelden',
	'mixi' => 'mixi',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Es ist bereits eine mixi-ID für Ihr Blog registriert. <a href="[_1]">Klicken Sie hier</a>, um die mixi-ID dieses Blogs zu ändern. Klicken Sie auf Zurücksetzen, um alle mixi-Benutzer kommentieren zu lassen. Derzeit können nur Ihre my mixi-Benutzer kommentieren.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Wenn Sie nur Ihre my mixi-Benutzer kommentieren lassen wollen, <a href="[_1]">klicken Sie hier</a>, um sich mit Ihrer mixi-ID anzumelden.',

## plugins/Motion/config.yaml
	'A Movable Type theme with structured entries and action streams.' => 'Ein Movable Type-Thema mit strukturierten Einträgen und Action Streams.',
	'Adjusting field types for embed custom fields...' => 'Passe Feldtypen für eingebettete individuelle Felder an...',
	'Updating favoriting namespace for Motion...' => 'Aktualisieren Favoriten-Namespace für Motion...',
	'Motion Themes' => 'Motion-Designs',
	'Themes for Motion template set' => 'Designs für die Motion-Vorlagengruppe',
	'Motion' => 'Motion',
	'Post Type' => 'Eintragsart',
	'Photo' => 'Foto',
	'Embed Object' => 'Objekt einbetten',
	'MT JavaScript' => 'MT-JavaScript',
	'Motion MT JavaScript' => 'Motion MT JavaScript',
	'Motion JavaScript' => 'Motion JavaScript',
	'Entry Listing: Monthly' => 'Eintragsliste: Monatlich',
	'Entry Listing: Category' => 'Eintragsliste: Kategorie',
	'|' => '|',
	'Entry Response' => 'Eintragsantworten',
	'Profile View' => 'Profilansicht',
	'Profile Edit Form' => 'Profilbearbeitungsformular',
	'Profile Error' => 'Profilfehler',
	'Profile Feed' => 'Profil-Feed',
	'Login Form' => 'Anmeldeformular',
	'Register Confirmation' => 'Registrierungs-Bestätigung',
	'New Password Reset Form' => 'Formular zum Zurücksetzen neuer Passwörter',
	'New Password Form' => 'Formular für neues Passwort',
	'User Profile' => 'Benutzerprofil',
	'Actions (Local)' => 'Aktionen (lokal)',
	'Single Entry' => 'Einzeleintrag',
	'Messaging' => 'Messaging',
	'Form Field' => 'Formularfeld',
	'About Pages' => 'Über-Seiten',
	'About Site' => 'Über-Site',
	'Gallery' => 'Galerie',
	'Main Column Actions' => 'Hauptspalte: Aktionen',
	'Main Column Posting Form (All Media)' => 'Hauptspalte: Eingabeformular (alle Medien)',
	'Main Column Posting Form (Text Only, Like Twitter)' => 'Hauptspalte: Eingabeformular (nur Text, z.B. Twitter)',
	'Main Column Registration' => 'Hauptspalte: Registrierung',
	'Fans' => 'Fans',
	'Popular Entries' => 'Beliebte Einträge',
	'Elsewhere' => 'Anderswo',
	'Following' => 'Benutzer, denen Sie folgen',
	'Followers' => 'Benutzer, die Ihnen folgen',
	'User Archives' => 'Benutzerarchiv',
	'Blogroll' => 'Blogrolle',
	'Feeds' => 'Feeds',
	'Main Column Content' => 'Hauptspalten-Inhalt',
	'Main Index Widgets' => 'Hauptspalten-Widgets',
	'Archive Widgets' => 'Archiv-Widgets',
	'Entry Widgets' => 'Eintrags-Widgets',
	'Footer Widgets' => 'Fußzeilen-Widgets',
	'Default Widgets' => 'Standard-Widgets',
	'Profile Widgets' => 'Profil-Widgets',

## plugins/Motion/lib/Motion/Search.pm
	'This module works with MT::App::Search.' => 'Dieses Modul verwendet MT::App:Search.',
	'Specify the blog_id of a blog that has Motion template set.' => 'Geben Sie die blog_id eines Blogs mit der Motion-Vorlagengruppe an.',
	'Error loading template: [_1]' => 'Fehler beim Laden der Vorlage: [_1]',

## plugins/Motion/templates/Motion/actions_local.mtml
	'[_1] commented on [_2]' => '[_1] kommentierte auf [_2]',
	'[_1] favorited [_2]' => '[_1] hat [_2] zum Favoriten gemacht',
	'No recent actions.' => 'Keine aktuellen Aktionen',

## plugins/Motion/templates/Motion/actions.mtml
	'[_1] is now following [_2]' => '[_1] folgt jetzt [_2]',
	'[_1] favorited [_2] on [_3]' => '[_1] hat [_2] auf [_3] zum Favoriten gemacht',

## plugins/Motion/templates/Motion/archive_index.mtml

## plugins/Motion/templates/Motion/banner_footer.mtml

## plugins/Motion/templates/Motion/banner_header.mtml

## plugins/Motion/templates/Motion/comment_detail.mtml

## plugins/Motion/templates/Motion/comment_listing.mtml

## plugins/Motion/templates/Motion/comment_preview.mtml

## plugins/Motion/templates/Motion/comment_response.mtml
	'<strong>Bummer....</strong> [_1]' => '<strong>Huch...</strong>',

## plugins/Motion/templates/Motion/comments.mtml
	'what will you say?' => 'Was würden Sie sagen?',
	'[_1] [_2]in reply to comment from [_3][_4]' => '[_1] [_2] alt Antwort auf den Kommentar von [_3][_4]',
	'Write a comment...' => 'Schreiben Sie einen Kommmentar...',

## plugins/Motion/templates/Motion/dynamic_error.mtml

## plugins/Motion/templates/Motion/entry_listing_author.mtml
	'Archived Entries from [_1]' => 'Archivierte Einträge von [_1]',
	'Recent Entries from [_1]' => 'Aktuelle Eintrage von [_1]',

## plugins/Motion/templates/Motion/entry_listing_category.mtml

## plugins/Motion/templates/Motion/entry_listing_monthly.mtml

## plugins/Motion/templates/Motion/entry.mtml

## plugins/Motion/templates/Motion/entry_response.mtml

## plugins/Motion/templates/Motion/entry_summary.mtml
	'By [_1] <span class="date">on [_2]</span>' => 'Von [_1] <span class="date">am [_2]</span>',
	'Unpublish this post' => 'Eintrag nicht mehr veröffentlichen',
	'1 <span>Comment</span>' => '1 <span>Kommentar</span>',
	'# <span>Comments</span>' => '# <span>Kommentare</span>',
	'0 <span>Comments</span>' => '0 <span>Kommentare</span>',
	'1 <span>TrackBack</span>' => '1 <span>TrackBack</span>',
	'# <span>TrackBacks</span>' => '# <span>TrackBacks</span>',
	'0 <span>TrackBacks</span>' => '0 <span>TrackBacks</span>',
	'Posted to [_1]' => 'Veröffentlicht in [_1]',

## plugins/Motion/templates/Motion/form_field.mtml
	'(Optional)' => '(Optional)',

## plugins/Motion/templates/Motion/javascript.mtml
	'Please select a file to post.' => 'Bitte wählen die Datei, die Sie hochladen möchten',
	'You selected an unsupported file type.' => 'Das gewählte Dateiformat wird nicht unterstützt.',

## plugins/Motion/templates/Motion/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Noch nicht registriert?&nbsp;&nbsp;<a href="[_1]">Einfach jetzt registrieren</a>!',
	'Forgot?' => 'Vergessen?',

## plugins/Motion/templates/Motion/main_index.mtml

## plugins/Motion/templates/Motion/member_index.mtml

## plugins/Motion/templates/Motion/motion_js.mtml
	'Add userpic' => 'Benutzerbild einfügen',

## plugins/Motion/templates/Motion/new_password.mtml
	'Choose New Password' => 'Wählen Sie Ihr neues Passwort',

## plugins/Motion/templates/Motion/page.mtml

## plugins/Motion/templates/Motion/password_reset.mtml
	'Reset Password' => 'Passwort zurücksetzen',

## plugins/Motion/templates/Motion/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_1] in [_2] veröffentlicht',
	'Commented on [_1] in [_2]' => '[_1] in [_2] kommentiert',
	'followed [_1]' => 'folgt [_1]',

## plugins/Motion/templates/Motion/register_confirmation.mtml
	'Authentication Email Sent' => 'Authentifizierungsmail verschickt',
	'Profile Created' => 'Profil angelegt',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Zurück zur Ausgangsseite</a>',

## plugins/Motion/templates/Motion/register.mtml
	'Enter a password for yourself.' => 'Geben Sie Ihr gewünschtes Passwort ein.',
	'The URL of your website.' => 'Die Adresse (URL) Ihrer Website.',

## plugins/Motion/templates/Motion/search_results.mtml

## plugins/Motion/templates/Motion/sidebar.mtml

## plugins/Motion/templates/Motion/single_entry.mtml
	'Note: This post is being held for approval by the site owner.' => 'Hinweis: Dieser Eintrag ist vom Betreiber der Site noch nicht freigeschaltet worden.',
	'<a href="[_1]">Most recent comment by <strong>[_2]</strong> on [_3]</a>' => '<a href="[_1]">Aktuelle Kommentare von <strong>[_2]</strong> zu [_3]</a>',
	'[_1] posted [_2] on [_3]' => '[_1] hat [_2] auf [_3] veröfentlicht',

## plugins/Motion/templates/Motion/trackbacks.mtml

## plugins/Motion/templates/Motion/user_profile_edit.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]>Zurück zur Ausgangsseite</a> oder <a href="[_2]>Profil ansehen</a>.',

## plugins/Motion/templates/Motion/user_profile.mtml
	'Recent Actions from [_1]' => 'Aktuelle Aktionen von [_1]',
	'Responses to Comments from [_1]' => 'Reaktionen auf Kommentare von  [_1]',
	'You are following [_1].' => 'Sie folgen [_1]',
	'Unfollow' => 'Nicht mehr folgen',
	'Follow' => 'Folgen',
	'Profile Data' => 'Profil-Daten',
	'More Entries by [_1]' => 'Weitere Einträge von [_1]',
	'Recent Actions' => 'Aktuelle Aktionen',
	'_PROFILE_COMMENT_LENGTH' => '10',
	'Comment Threads' => 'Kommentar-Threads',
	'[_1] commented on ' => '[_1] kommentierte',
	'No responses to comments.' => 'Keine Kommentarantworten',

## plugins/Motion/templates/Motion/widget_about_ssite.mtml
	'About' => 'Über',
	'The Motion Template Set is a great example of the type of site you can build with Movable Type.' => 'Die Motion-Vorlagengruppe ist ein tolles Beispiel für die große Bandbreite von Websites, die Sie mit Movable Type erstellen können.',

## plugins/Motion/templates/Motion/widget_categories.mtml

## plugins/Motion/templates/Motion/widget_elsewhere.mtml
	'Are you sure you want to remove the [_1] from your profile?' => '[_1] wirklich aus Ihrem Profil entfernen?',
	'Your user name or ID is required.' => 'Ihr Benutzername oder Ihre ID ist erforderlich.',
	'Add a Service' => 'Einen Dienst hinzufügen',
	'Service' => 'Dienst',
	'Select a service...' => 'Wählen Sie einen Dienst aus',
	'Your Other Profiles' => 'Ihre anderen Profile',
	'Find [_1] Elsewhere' => '[_1] anderswo finden',
	'Remove service' => 'Dienst entfernen',

## plugins/Motion/templates/Motion/widget_fans.mtml

## plugins/Motion/templates/Motion/widget_followers.mtml
	'Not being followed' => 'Niemand folgt Ihnen',

## plugins/Motion/templates/Motion/widget_following.mtml
	'Not following anyone' => 'Sie folgen niemandem',

## plugins/Motion/templates/Motion/widget_gallery.mtml
	'Recent Photos' => 'Aktuelle Fotos',

## plugins/Motion/templates/Motion/widget_main_column_actions.mtml

## plugins/Motion/templates/Motion/widget_main_column_posting_form.mtml
	'QuickPost' => 'QuickPost',
	'Text post' => 'Text',
	'Photo post' => 'Foto',
	'Link post' => 'Link',
	'Embed post' => 'Eingebettet',
	'Audio post' => 'Töne',
	'URL of web page' => 'Adresse (URL) der Webseite',
	'Select photo file' => 'Bilddatei wählen',
	'Only GIF, JPEG and PNG image files are supported.' => 'Unterstützt werden die Formate GIF, JPG und PNG.',
	'Select audio file' => 'Audiodatei wählen',
	'Only MP3 audio files are supported.' => 'Unterstützt wird das Format MP3.',
	'Paste embed code' => 'Einbett-Code einfügen',
	'Content' => 'Inhalt',
	'more options' => 'Weitere Optionen',
	'Post' => 'Veröffentlichen',

## plugins/Motion/templates/Motion/widget_main_column_posting_form_text.mtml

## plugins/Motion/templates/Motion/widget_main_column_registration.mtml
	'<a href="javascript:void(0)" onclick="[_1]">Sign In</a>' => '<a href="javascript:void(0)" onclick="[_1]">Anmelden</a>',
	'Not a member? <a href="[_1]">Register</a>' => 'Noch kein Mitglied? <a href="[_1]>Registieren</a>',
	'(or <a href="javascript:void(0)" onclick="[_1]">Sign In</a>)' => '(oder <a href="javascript:void(0)" onclick="[_1]">anmelden</a>)',
	'No posting privileges.' => 'Keine Veröffentlichungs-Rechte.',

## plugins/Motion/templates/Motion/widget_members.mtml

## plugins/Motion/templates/Motion/widget_monthly_archives.mtml

## plugins/Motion/templates/Motion/widget_popular_entries.mtml
	'posted by <a href="[_1]">[_2]</a> on [_3]' => 'von <a href="[_1]">[_2]</a> auf [_3]',

## plugins/Motion/templates/Motion/widget_powered_by.mtml

## plugins/Motion/templates/Motion/widget_recent_comments.mtml
	'<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>' => '<p>[_3]...</p><div class="comment-attribution">[_4]<br /><a href="[_1]">[_2]</a></div>',

## plugins/Motion/templates/Motion/widget_recent_entries.mtml
	'posted by [_1] on [_2]' => 'veröffentlicht von [_1] auf [_2]',

## plugins/Motion/templates/Motion/widget_search.mtml

## plugins/Motion/templates/Motion/widget_signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Sie sind als <a href="[_1]">[_2]</a> angemeldet.',
	'You are signed in as [_1]' => 'Sie sind als [_1] angemeldet.',
	'Edit profile' => 'Profil bearbeiten',

## plugins/Motion/templates/Motion/widget_tag_cloud.mtml

## plugins/Motion/templates/Motion/widget_user_archives.mtml
	'Recenty entries from [_1]' => 'Aktuelle Einträge von [_1]',

## plugins/Motion/tmpl/edit_linkpost.tmpl

## plugins/Motion/tmpl/edit_videopost.tmpl
	'Embed code' => 'Einbett-Code',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'Die Attribute include_blogs, exclude_blog, blog_ids und blog_id können nicht gemeinsam verwendet werden.',
	'The value of the blog_id attribute must be a single blog ID.' => 'blog_id erfordert genau eine Blog-ID als Wert.',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'include_blogs und exclude_blogs erfordern mindestens eine Blog-ID als Wert. Mehrere IDs sind per Kommata zu trennen.',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Stelle MultiBlog-Trigger für Blog #[_1] wieder her....',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog-Tags können nicht veschachtelt werden.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Ungültiges "mode"-Attribut [_1]. Gültige Werte sind "loop" und "context".',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Mit MultiBlog können Sie Inhalte anderer Blogs übernehmen und die dazu erforderlichen Veröffentlichungsregeln definieren.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Neuen Auslöser anlegen',
	'Search Weblogs' => 'Weblogs suchen',
	'When this' => 'Wenn',
	'* All blogs in this website' => '* Alle Blogs dieser Website',
	'Select to apply this trigger to all blogs in this website.' => 'Diesen Trigger auf alle Blogs dieser Website anwenden',
	'* All websites and blogs in this system' => '* Alle Websites und Blogs dieser Installation',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Diesen Trigger auf alle Websites und Blogs dieser Installation anwenden',
	'saves an entry/page' => 'ein Eintrag / eine Seite gespeichert wird',
	'publishes an entry/page' => 'ein Eintrag / eine Seite veröffentlicht wird',
	'publishes a comment' => 'ein Kommentar veröffentlicht wird',
	'publishes a TrackBack' => 'ein TrackBack veröffentlicht wird',
	'rebuild indexes.' => 'Indizes neu aufbauen.',
	'rebuild indexes and send pings.' => 'Indizes neu aufbauen und Pings senden.',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Wenn in',
	'Weblog' => 'Weblog',
	'Trigger' => 'Auslöser',
	'Action' => 'Aktion',
	'Content Privacy' => 'Externer Zugriff auf Inhalte',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Hier können Sie festlegen, ob andere Blogs dieser Movable Type-Installation die Inhalte dieses Blogs verwenden dürfen oder nicht. Diese Einstellung hat Vorrang vor der globalen MultiBlog-Konfiguration.',
	'Use system default' => 'System-Voreinstellung verwenden',
	'Allow' => 'Aggregation zulassen',
	'Disallow' => 'Aggregation nicht zulassen',
	'MTMultiBlog tag default arguments' => 'MultiBlog- Standardargumente',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Ermöglicht die Verwendung von MTMultiBlog ohne include_blogs- und exclude_blogs-Attribute. Erlaubte Werte sind \'all\' oder per Kommata getrennte BlogIDs.',
	'Include blogs' => 'Einzuschließende Blogs',
	'Exclude blogs' => 'Auszuschließende Blogs',
	'Rebuild Triggers' => 'Auslöser für Neuaufbau',
	'Create Rebuild Trigger' => 'Auslöser für Neuaufbau definieren',
	'You have not defined any rebuild triggers.' => 'Es sind keine Auslöser definiert.',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'MultiBlog-Auslöser definieren',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Systemwite Aggregations- Voreinstellung',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit nicht erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Kann IP-Adresse der Quelladresse [_1] nicht auflösen',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation: Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'No links are present in feedback' => 'Keine Links enthalten',
	'Number of links exceed junk limit ([_1])' => 'Anzahl der Links übersteigt Spam-Schwellenwert ([_1] Links)',
	'Number of links exceed moderation limit ([_1])' => 'Anzahl der Links übersteigt Moderations-Schwellenwert ([_1] Links)',
	'Link was previously published (comment id [_1]).' => 'Link wurde bereits veröffentlicht (Kommentar [_1])',
	'Link was previously published (TrackBack id [_1]).' => 'Link wurde bereits veröffentlicht (TrackBack [_1])',
	'E-mail was previously published (comment id [_1]).' => 'E-Mail-Adresse wurde bereits veröffentlicht (Kommentar [_1])',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Moderierung: Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.',
	'domain \'[_1]\' found on service [_2]' => 'Domain &#8222;[_1]&#8220;gefunden bei [_2]',
	'[_1] found on service [_2]' => '[_1] gefunden bei [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup-Modul zur Nutzung von Sperrlisten zur Feedback-Überprüfung',
	'SpamLookup IP Lookup' => 'SpamLookup für IP-Adressen',
	'SpamLookup Domain Lookup' => 'SpamLookup für Domains',
	'SpamLookup TrackBack Origin' => 'SpamLookup für TrackBack-Herkunft',
	'Despam Comments' => 'Spam aus Kommentaren entfernen',
	'Despam TrackBacks' => 'Spam aus TrackBacks entfernen',
	'Despam' => 'Spam entfernen',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup-Modul zur Überprüfung von Links in Feedback',
	'SpamLookup Link Filter' => 'SpamLookup zur Linkfilterung',
	'SpamLookup Link Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter Links',
	'SpamLookup Email Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter E-Mail-Adressen',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup-Modul zur automatischen Einordnung von Feedback nach Schlüsselbegriffen zur Moderation oder als Spam.',
	'SpamLookup Keyword Filter' => 'SpamLookup Schlüsselbegriff-Filter',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'Von eingehendem Feedback können die IP-Adressen und die enthaltenen Hyperlinks  in Schwarzlisten nachgeschlagen werden. Stammt ein eingehender Kommentar oder TrackBack von einer dort gelisteten IP-Adresse oder enthält er Links zu einer dort gelisteten Domain, kann er  automatisch zur Moderation zurückgehalten oder als Spam angesehen werden. Für TrackBacks sind zusätzliche Prüfungen möglich.',
	'IP Address Lookups' => 'Nachschlagen von IP-Adressen',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen moderieren',
	'Junk feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen als Spam ansehen',
	'Adjust scoring' => 'Gewichtung anpassen',
	'Score weight:' => 'Gewichtung',
	'Less' => 'kleiner',
	'More' => 'größer',
	'block' => 'sperren',
	'IP Blacklist Services' => 'IP-Schwarzlisten',
	'Domain Name Lookups' => 'Nachschlagen von Domain-Namen',
	'Moderate feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains moderieren',
	'Junk feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains als Spam ansehen',
	'Domain Blacklist Services' => 'Domain-Schwarzlisten',
	'Advanced TrackBack Lookups' => 'Zusätzliche TrackBack-Prüfungen',
	'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen moderieren',
	'Junk TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen als Spam ansehen',
	'Lookup Whitelist' => 'Weißliste',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Tragen Sie hier IP-Adressen und Domains, die nicht nachgeschlagen werden sollten, ein. Verwenden Sie pro Eintrag eine Zeile. ',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Die Anzahl der in eingehendem Feedback enthaltenen Hyperlinks kann kontrolliert werden. Feedback mit sehr vielen Links kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden. Umgekehrt kann Feedback, das gar keine Links enthält oder nur solche, die zuvor bereits freigegeben wurden, automatisch positiv bewertet werden.',
	'Link Limits' => 'Link-Schwellenwert',
	'Credit feedback rating when no hyperlinks are present' => 'Feedback ohne Hyperlinks positiv bewerten',
	'Moderate when more than' => 'Moderieren bei mehr als',
	'link(s) are given' => 'Link(s)',
	'Junk when more than' => 'Als Spam ansehen bei mehr als',
	'Link Memory' => 'Bereits veröffentlichte Links',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Feedback positiv bewerten, wenn die Quelladresse (URL) bereits veröffentlicht wurde.',
	'Only applied when no other links are present in message of feedback.' => 'Nur anwenden, wenn keine anderen Links im Feedbacktext enthalten sind',
	'Exclude URLs from comments published within last [_1] days.' => 'URLs aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',
	'Email Memory' => 'Bereits veröffentlichte E-Mail-Adressen',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Feedback positiv bewerten, wenn bereits zuvor Kommentare von der gleichen E-Mail-Adresse veröffentlicht wurden.',
	'Exclude Email addresses from comments published within last [_1] days.' => 'E-Mail-Adressen aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Eingehendes Feedback kann auf wählbare Schlüsselbegriffe, Domainnamen und Muster durchsucht werden. Feedback mit Treffern kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden.',
	'Keywords to Moderate' => 'Bei Auftreten dieser Schlüsselwörter Feedback moderieren',
	'Keywords to Junk' => 'Bei Auftreten dieser Schlüsselwörter Feedback als Spam ansehen',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt installieren. ',
	'MT 4 Style Library' => 'MT 4-Designs',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Mit den Standardvorlagen von MT 3.3+  kompatible Designvorlagen',
	'Styles' => 'Designs',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Ihr mt-static-Ordner konnte nicht gefunden werden. Bitte konfigurieren Sie \'StaticFilePath\' um fortzufahren.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem \'themes\'-Ordner hat.',
	'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',
	'Invalid URL: [_1]' => 'Ungültige URL: [_1]',
	'(Untitled)' => '(ohne Überschrift)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => '[_1]-Stil wählen',
	'3-Columns, Wide, Thin, Thin' => 'Dreispaltig: breit - schmal - schmal',
	'3-Columns, Thin, Wide, Thin' => 'Dreispaltig: schmal - breit - schmal',
	'3-Columns, Thin, Thin, Wide' => 'Dreispaltig: schmal - schmal - breit',
	'2-Columns, Thin, Wide' => 'Zweispaltig: schmal - breit',
	'2-Columns, Wide, Thin' => 'Zweispaltig: breit - schmal',
	'2-Columns, Wide, Medium' => 'Zweispaltig: breit - mittel',
	'2-Columns, Medium, Wide' => 'Zweispaltig: mittel - breit',
	'1-Column, Wide, Bottom' => 'Einspaltig: breit - Fußzeile',
	'None available' => 'Keine verfügbar',
	'Applying...' => 'Wende an...',
	'Apply Design' => 'Design übernehmen',
	'Error applying theme: ' => 'Fehler bei der Übernahme des Themas:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Das gewählte Thema wurde übernommen. Da das Layout geändert wurde, veröffentlichen Sie das Blog bitte erneut, um die Änderungen wirksam werden zu lassen.',
	'The selected theme has been applied!' => 'Das Thema wurde übernommen!',
	'Error loading themes! -- [_1]' => 'Fehler beim Laden der Themen -- [_1]',
	'Stylesheet or Repository URL' => 'URL des Stylesheets oder der Sammlung',
	'Stylesheet or Repository URL:' => 'URL des Stylesheets oder der Sammlung:',
	'Download Styles' => 'Designs herunterladen',
	'Current theme for your weblog' => 'Aktuelles Theme Ihres Weblogs',
	'Current Style' => 'Derzeitige Design',
	'Locally saved themes' => 'Lokal gespeicherte Themes',
	'Saved Styles' => 'Gespeicherte Designs',
	'Default Styles' => 'Standarddesigns',
	'Single themes from the web' => 'Einzelne Themes aus dem Web',
	'More Styles' => 'Weitere Designs',
	'Selected Design' => 'Gewähltes Design',
	'Layout' => 'Layout',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Korrekt formatierter Text leicht gemacht',
	'Textile 2' => 'Textile 2',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'API-Schlüssel erforderlich',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Spamfilter-Gewichtung',
	'Least Weight' => 'Geringstes Gewicht',
	'Most Weight' => 'Größtes Gewicht',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Kommentare und TrackBacks erhalten eine Spam-Bewertung zwischen -10 (mit Sicherheit Spam) und +10 (mit Sicherheit kein Spam). Hier können Sie einstellen, wieviel Gewicht diese Bewertung im Verhältnis zu anderen Spamfiltern, die Sie möglicherweise ebenfalls installiert haben, erhalten soll.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'Blockierter Spam',
	'on this blog' => 'in diesem Blog',
	'on this system' => 'in diesem System',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'API-Schlüssel',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'Um dieses Plugin zu aktivieren, benötigen Sie einen kostenlosen TypePad AntiSpam API-Schlüssel. <strong>Sie erhalten Ihren kostenlosen API-Schlüssel auf [_1]antispam.typepad.com[_2]</strong>. Geben Sie Ihren Schlüssel in das folgende Feld ein.',
	'Service Host' => 'Dienstadresse',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'Die Standard-Dienstadresse für TypePad AntiSpam ist api.antispam.typepad.com. Ändern Sie diese Angabe nur dann, wenn Sie einen anderen Dienst verwenden, der mit der TypePad Antispam-API kompatibel ist.',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam schützt Ihr Blog vor Kommentar- und TrackBack-Spam. Mit dem TypePad AntiSpam-Plugin wird jeder eingehende Kommentar und jedes eingehende TrackBack vom TypePad AntiSpam-Service überprüft und, falls es sich um Spam handelt, von Movable Type automatisch herausgefiltert. Kommentare und TrackBacks können auch manuell als Spam oder gültiges Feedback markiert werden. TypePad AntiSpam ist adaptiv und lernt dabei nicht nur aus Ihren Eingaben, sondern aus denen aller Benutzer des Dienstes. TypePad AntiSpam ist ein kostenloser Dienst von Six Apart.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'Bisher [quant,_1,Spam-Nachricht,Spam-Nachrichten] in diesem Blog und [quant,_2,Spam-Nachricht,Spam-Nachrichten] systemweit von TypePad AntiSpam blockiert.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'Bisher [quant,_1,Spam-Nachricht,Spam-Nachrichten] von TypePad AntiSpam blockiert.',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Verifizierung des TypePad AntiSpam API-Schlüssels fehlgeschlagen: [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => 'Der angegebene TypePad AntiSpam API-Schlüssel ist ungültig.',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager 1.1 - Diese Version des Plugins dient ausschließlich dazu, Daten älterer Versionen auf das Movable Type Core-Schema zu aktualisieren. Sie können diese Plugin daher nach Installation bzw. Aktualisierung von Movable Type gefahrlos löschen.',
	'Moving storage of Widget Manager [_2]...' => 'Verschiebe Speicherort des Widget Managers [_2]...',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Datei ist nicht im WXR-Format.',
	'Creating new tag (\'[_1]\')...' => 'Lege neuen Tag (\'[_1]\') an...',
	'Saving tag failed: [_1]' => 'Speichern des Tags fehlgeschlagen: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Doppeltes Asset (\'[_1]\') gefunden. Überspringe...',
	'Saving asset (\'[_1]\')...' => 'Speichere Asset (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' und tagge Asset (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Doppelter Eintrag gefunden. Überspringe...',
	'Saving page (\'[_1]\')...' => 'Speichere Seite (\'[_1]\')...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'Bevor Sie WordPress-Einträge in Movable Type importieren, sollten Sie zuerst die <a href=\'[_1]\'>Veröffentlichungspfade Ihres Weblogs einstellen</a>.',
	'Upload path for this WordPress blog' => 'Uploadpfad für dieses WordPress-Blog',
	'Replace with' => 'Ersetzen durch',
	'Download attachments' => 'Anhänge herunterladen',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Lädt Anhänge von Wordpress-Blogs im Hintergrund herunter. Cronjob erforderlich.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Anhänge (Bilder und Dateien) des importierten Wordpress-Blogs herunterladen.',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'Aus WordPress exportiertes RSS in Movable Type importieren',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'WP-Anhänge per HTTP herunterladen',
	
	'The file([_1]) you uploaded is not allowed.' => 'Die hochgeladene Datei ([_1]) ist nicht zulässig.', 
        'Migrating CustomFields type...' => 'Migriere Arten der eigenen Felder...', 
        'Can\'t locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'Kann Net:LDAP nicht finden. Net::LDAP ist zur Authentifizierung über LDAP erforderlich.', 

);

## New words: 71

1;
