# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::de;
use strict;
use warnings;
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
	'(Display Name not set)' => '(Kein Anzeigename festgelegt)',
	'Author Yearly' => 'Autor jährlich',
	'Author Monthly' => 'Autor monatlich',
	'Author Daily' => 'Autor täglich',
	'Author Weekly' => 'Autor wöchentlich',
	'Category' => 'Kategorie',
	'Category Yearly' => 'Kategorie jährlich',
	'Category Monthly' => 'Kategorie monatlich',
	'Category Daily' => 'Kategorie täglich',
	'Category Weekly' => 'Kategorie wöchentlich',
	'CONTENTTYPE_ADV' => 'Inhaltstyparchiv',
	'CONTENTTYPE-DAILY_ADV' => 'tägliches Inhaltstyparchiv',
	'CONTENTTYPE-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv',
	'CONTENTTYPE-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv',
	'CONTENTTYPE-YEARLY_ADV' => 'jährliches Inhaltstyparchiv',
	'CONTENTTYPE-AUTHOR_ADV' => 'Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-CATEGORY_ADV' => 'Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Kategorie',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'Archivtyp nicht gefunden - [_1]', # Translate - New # OK

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtauthorhasentry.php

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Befehl [_1] ohne Datums-Kontext verwendet.',

## php/lib/block.mtcategorysets.php
	'No Category Set could be found.' => 'Kein Kategorie-Set gefunden.',
	'No Content Type could be found.' => 'Keine Inhaltstypen gefunden.',

## php/lib/block.mtcontentauthoruserpicasset.php
	'You used an \'[_1]\' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an \'MTContents\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Inhalte-Kontexts verwendet - &#8222;MTContents&#8220;-Container erforderlich',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found.' => 'Keine Inhaltsfelder gefunden.',
	'No Content Field Type could be found.' => 'Keine Felder für Inhaltstypen gefunden.',

## php/lib/block.mtcontentfields.php

## php/lib/block.mtcontents.php

## php/lib/block.mtentries.php

## php/lib/block.mthasplugin.php
	'name is required.' => 'Name erforderlich',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Befehl [_1] ohne gültiges Namens-Attribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'Sie haben einen &#8222;[_1]&#8220;-Befehl ohne gültiges Namensattribut verwendet.',
	'\'[_1]\' is not a hash.' => '&#8222;[_1]&#8220; ist kein Hash.',
	'Invalid index.' => 'Index ungültig.',
	'\'[_1]\' is not an array.' => '&#8222;[_1]&#8220; ist kein Array.',
	'\'[_1]\' is not a valid function.' => '&#8222;[_1]&#8220; ist keine gültige Funktion.',

## php/lib/block.mttags.php
	'content_type modifier cannot be used with type "[_1]".' => 'Das Attribut content_type kann nicht mit Typ "[_1]" verwendet werden.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Geben Sie die Zeichen ein, die Sie in obigem Bild sehen.',

## php/lib/content_field_type_lib.php
	'No Label (ID:[_1])' => 'Keine Bezeichnung (ID:[_1])',
	'No category_set setting in content field type.' => 'Inhaltsfeld-Typ ohne category_set-Einstellung ',

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

## php/lib/function.mtcontentauthordisplayname.php

## php/lib/function.mtcontentauthoremail.php

## php/lib/function.mtcontentauthorid.php

## php/lib/function.mtcontentauthorlink.php

## php/lib/function.mtcontentauthorurl.php

## php/lib/function.mtcontentauthorusername.php

## php/lib/function.mtcontentauthoruserpic.php

## php/lib/function.mtcontentauthoruserpicurl.php

## php/lib/function.mtcontentcreateddate.php

## php/lib/function.mtcontentdate.php

## php/lib/function.mtcontentfieldlabel.php

## php/lib/function.mtcontentfieldtype.php

## php/lib/function.mtcontentfieldvalue.php

## php/lib/function.mtcontentid.php

## php/lib/function.mtcontentmodifieddate.php

## php/lib/function.mtcontentpermalink.php

## php/lib/function.mtcontentscount.php

## php/lib/function.mtcontentsitedescription.php

## php/lib/function.mtcontentsiteid.php

## php/lib/function.mtcontentsitename.php

## php/lib/function.mtcontentsiteurl.php

## php/lib/function.mtcontentstatus.php

## php/lib/function.mtcontenttypedescription.php

## php/lib/function.mtcontenttypeid.php

## php/lib/function.mtcontenttypename.php

## php/lib/function.mtcontenttypeuniqueid.php

## php/lib/function.mtcontentuniqueid.php

## php/lib/function.mtcontentunpublisheddate.php

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Eintrag',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Die Option &#8222;parent&#8220; kann nicht zusammen mit &#8222;[_1]&#8220; verwendet werden.',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Passwörter müssen mindestens [_1] Zeichen lang sein',
	'Password should not include your Username' => 'Ihr Benutzername darf nicht Teil Ihres Passworts sein',
	'Password should include letters and numbers' => 'Passwörter müssen sowohl Buchstaben als auch Ziffern enthalten',
	'Password should include lowercase and uppercase letters' => 'Passwörter müssen sowohl Groß- als auch Kleinbuchstaben enthalten',
	'Password should contain symbols such as #!$%' => 'Passwörter müssen mindestens ein Sonderzeichen wie #!$% enthalten',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]-Befehl ohne gültiges [_2]-Attribut verwendet.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'Mindestlänge [_1] Zeichen',
	', uppercase and lowercase letters' => 'Groß- und Kleinbuchstaben',
	', letters and numbers' => 'Buchstaben und Ziffern',
	', symbols (such as #!$%)' => 'Sonderzeichen (#!$% usw.)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtsetvar.php

## php/lib/function.mtsitecontentcount.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Ungültiger [_1]-Parameter.',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '&#8222;[_1]&#8220; ist keine gültige Hash-Funktion.',
	'\'[_1]\' is not a valid function for an array.' => '&#8222;[_1]&#8220; ist keine gültige Array-Funktion.',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Wenn die Attribute exclude_blogs und include_blogs gemeinsam verwendet werden, geben Sie die gleichen Blog-IDs nicht gleichzeitig für beide an. ',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Seite nicht gefunden - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type Systemüberprüfung',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Sie haben für die gewünschte Funktion keine Berechtigung. Bei Fragen wenden Sie sich bitte an Ihren Systemadministrator.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Die MT-Systemüberprüfung ist deaktiviert, wenn bereits eine gültige Konfigurationdabei mt-config.cgi vorhanden ist.',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Das Skript mt-check.cgi führt eine Überprüfung Ihrer Systemkonfiguration durch und stellt fest, ob alle zum Betrieb von Movable Type erforderlichen Komponenten vorhanden sind.},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'Die auf Ihrem Server installierte Perl-Version [_1] ist älter als die mindestens erforderliche Version [_2]. Bitte aktualisieren Sie Ihre Installation daher auf Perl [_2] oder neuer.',
	'System Information' => 'Systeminformation',
	'Movable Type version:' => 'Movable Type-Version:',
	'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
	'MT home directory:' => 'MT-Wurzelverzeichnis:',
	'Operating system:' => 'Betriebssystem;',
	'Perl version:' => 'Perl-Version:',
	'Perl include path:' => 'Perl-Include-Pfad:',
	'Web server:' => 'Webserver:',
	'(Probably) running under cgiwrap or suexec' => '(Wahrscheinlich) ausgeführt unter cgiwrap oder suexec',
	'[_1] [_2] Modules' => '[_1] [_2]-Modue',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Die folgenden Module sind <strong>optional</strong>. Sie brauchen zusätzlich nur dann installiert zu werden, wenn Sie die von ihnen bereitgestellten Funktionen nutzen möchten.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Die folgenden Module sind zur Abindung der Datenbank an Movable Type erforderlich. Zur Nutzung des Systems müssen DBI und das Modul für den jeweiligen Datenbank-Typ installiert sein.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert oder die installierte [_1]-Version ist zu alt.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert.',
	'Please consult the installation instructions for help in installing [_1].' => 'Bitte beachten Sie bei der Installation von [_1] die Installationshinweise.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'Die auf Ihrem Server installierte Version von DBD::mysql ist nicht mit Movable Type kompatibel. Bitte installieren Sie die aktuelle Version.',
	'The $mod is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '$mod ist korrekt installiert, benötigt aber ein aktuelleres DBI-Modul. Bitte beachten Sie die obigen Hinweise zu diesem Modul.',
	'Your server has [_1] installed (version [_2]).' => 'Auf Ihrem Server ist [_1] in der Version [_2] installiert.',
	'Movable Type System Check Successful' => 'Der Movable Type-Systemcheck war erfolgreich!',
	q{You're ready to go!} => q{Sie können sofort anfangen!},
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Module sind auf Ihrem Server installiert. Beginnen Sie jetzt mit der Installation von Movable Type.',
	'CGI is required for all Movable Type application functionality.' => 'CGI ist für sämtliche Movable Type-Funktionen erforderlich.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size ist zum Hochladen von Dateien erforderlich (um die Größe hochgeladener Bilder bestimmen zu können)',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec ist auf allen unterstützten Betriebssystem ',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie ist zur Nutzung der Cookie-Authentifizierung erforderlich.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent ist zur Erzeugung von Movable Type-Konfigurationsdateien mit dem Konfigurationsassistenten erforderlich.',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util ist zur Initialisierung von Movable Type erforderlich.',
	'HTML::Entities is required by CGI.pm' => 'HTML::Entities ist für CGI.pm erforderlich.',
	'DBI is required to work with most supported databases.' => 'DBI ist für die meisten Datenbank-Typen erforderlich.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI und DBD::mysql sind zur Nutzung von Movable Type mit einer MySQL-Datenbank erforderlich.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind zur Nutzung von Movable Type mit einer PostgreSQL-Datenbank erforderlich.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind zur Nutzung von Movable Type mit einer SQLite-Datenbank erforderlich.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI und DBD::SQLite2 sind zur Nutzung von Movable Type mit einer SQLite 2.x-Datenbank erforderlich.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA ist für den verbesserten Schutz der verwendeten Passwörter erforderlich.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Dieses Modul und seine Abhängigkeiten sind zum Betrieb von Movable Type unter psgi erforderlich.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Dieses Modul und seine Abhängigkeiten sind zum Betrieb von Movable Type unter psgi erforderlich.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Die Installation von HTML::Parser ist optional . Dieses Modul ist erforderlich, wenn Sie das TrackBack-System, weblogs.com-Pings und andere Aktualisierungs-Benachrichtigungen verwenden wollen.',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'Die Installation von SOAP::Lite ist optional. Dieses Modul ist zur Nutzung des XML-RPC-Servers von Movable Type erforderlich.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'Die Installation von File::Temp ist optional. Dieses Modul ist erforderlich, wenn Sie beim Hochladen von Dateien vorhandene Dateien überschreiben können möchten.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Die Installation von List::Util ist optional. Dieses Modul ist zur Nutzung der Veröffentlichungs-Warteschlange erforderlich.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => 'Die Installation von [_1] ist optional. Es ist eines der Module, das zur automatischen Erzeugung von Vorschaubildern verwendet werden kann. ',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'Die Installation von IPC::Run ist optional. Es ist erforderlich, wenn Sie NetPBM zur Erzeugung von Vorschaubildern verwenden möchten.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Die Installation von Storable ist optional. Es wird von einigen Movable-Type-Plugins von Drittanbietern benötigt.',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Die Installation von Crypt::DSA ist optional. Dieses Modul beschleunigt den Anmeldevorgang für Kommentarautoren.',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support. Also this module is required for Google Analytics site statistics.' => 'Dieses Modul und seine Abhängigkeiten sind zur Authentifizierung von Kommentarautoren per OpenID über SSL erforderlich, z.B. für AOL und Yahoo!. Sie sind außerdem für die Nutzung von Google Analytics erforderlich.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File ist erforderlich, wenn sich Kommentarautoren über eine OpenID bei Yahoo! Japan authentifizieren können sollen.',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 ist zur Registrierung von Kommentarautoren und zum Versenden von Mails über SMTP-Server erforderlich.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist zur Nutzung der Atom-API erforderlich.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached und ein auf dem Movable-Type-Server laufender memcached-Server sind zur Zwischenspeicherung von Objekten im Arbeitsspeicher erforderlich.',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar ist für Dateioperationen beim Erstellen und Einspielen von Backups erforderlich.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip ist zum Packen von Backup-Dateien erforderlich.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gzip ist zum Entpacken von Backup-Dateien erforderlich.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip ist für Dateioperationen beim Erstellen und Einspielen von Backups erforderlich.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX und seine Abhängigkeiten sind zum Einspielen von Backups erforderlich.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 und seine Abhängigkeiten sind zur Authentifizierung mittels OpenID (einschließlich LiveJournal) erforderlich.',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP ist für den Versand von E-Mails über SMTP-Server erforderlich.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Dieses Modul und seine Abhängigkeiten sind zur Verwendung von CRAM-MD5, DIGEST-MD5 und LOGIN SASL erforderlich.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL ist für alle SSL/TSL-Verbindungen erforderlich, beispielsweise für Statistiken von Google Analytics und für sichere SMTP-Authentifizierung.',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay ist zur Verwendung von SMTP Auth über SSL oder mit STARTSSL erforderlich.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Dieses Modul ist für ein test-Attribut des MTIf-Befehls erforderlich.',
	'This module is used by the Markdown text filter.' => 'Dieses Modul ist für den Markdown-Textfilter erforderlich.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Dieses Modul ist für mt-search.cgi erforderlich, wenn Sie Perl älter als 5.8 einsetzen.',
	'This module required for action streams.' => 'Dieses Modul ist für Action Streams erforderlich.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Dieses Modul ist für Google Analytics und zur Überprüfung von SSL-Zertifikaten erforderlich.',
	'This module is required for executing run-periodic-tasks.' => 'Dieses Modul wird zur periodischen Ausführung von Tasks erforderlich.',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] ist optional. Es handelt sich um eine bessere, kleinere und schnellere Alternative zu YAML::Tiny.',
	'The [_1] database driver is required to use [_2].' => 'Ein [_1]-Datenbanktreiber ist erforderlich, um eine [_2] zu nutzen.',
	'DBI is required to store data in database.' => 'DBI ist zur Nutzung von Datenbanken erforderlich.',
	'Checking for' => 'Überprüfe',
	'Installed' => 'Installiert',
	'Data Storage' => 'Datenbank',
	'Required' => 'Erforderlich',
	'Optional' => 'Optional',
	'Details' => 'Details',
	'unknown' => 'unbekannt',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Über diese Seite',
	'About this Archive' => 'Über dieses Archiv',
	'About Archives' => 'Über das Archiv',
	'This page contains links to all of the archived content.' => 'Diese Seite enthält Links zu allen archivierten Inhalten.',
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
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>, alle Einträge im <a href="[_2]">Archiv</a>.',

## default_templates/archive_index.mtml
	'HTML Head' => 'HTML-Kopf',
	'Archives' => 'Archiv',
	'Banner Header' => 'Banner-Kopf',
	'Monthly Archives' => 'Monatsarchiv',
	'Categories' => 'Kategorien',
	'Author Archives' => 'Autorenarchiv',
	'Category Monthly Archives' => 'Monatliches Kategoriearchiv',
	'Author Monthly Archives' => 'Monatliches Autorenarchiv',
	'Sidebar' => 'Seitenleiste',
	'Banner Footer' => 'Banner-Fuß',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Diese Widgetgruppe zeigt auf die jeweilige Archivseite zugeschnittene Informationen an: [_1] ',
	'Current Category Monthly Archives' => 'Monatsarchiv der aktuellen Kategorie',
	'Category Archives' => 'Kategoriearchiv',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autoren',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by<br /><a href="https://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a href="[_1]">Creative Commons-Lizenz</a>.',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Monatskalender. Die Datumsangaben werden automatisch mit den jeweiligen Seiten des Tagesarchivs verlinkt.',
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
	'[_1] Archives' => '[_1]-Archiv',
	'Recently in <em>[_1]</em> Category' => 'Neues in der Kategorie <em>[_1]</em>',
	'Entry Summary' => 'Zusammenfassung',
	'Main Index' => 'Übersicht',

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Monatsarchiv',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Jährliches Autorenarchiv',
	'Author Weekly Archives' => 'Wöchentliches Autorenarchiv',
	'Author Daily Archives' => 'Tägliches Autorenarchiv',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Jährliches Kategoriearchiv',
	'Category Weekly Archives' => 'Wöchentliches Kategoriearchiv',
	'Category Daily Archives' => 'Tägliches Kategoriearchiv',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Seite nicht gefunden',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Von [_1] zu [_2]',
	'1 Comment' => '1 Kommentar',
	'# Comments' => '# Kommentare',
	'No Comments' => 'Keine Kommentare',
	'1 TrackBack' => '1 TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Keine TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',
	'Comments' => 'Kommentare',

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
	'The sign-in attempt was not successful; Please try again.' => 'Anmeldeversuch nicht erfolgreich. Bitte versuchen Sie es erneut.',

## default_templates/lockout-ip.mtml
	'This email is to notify you that an IP address has been locked out.' => 'Eine IP-Adresse wurde automatisch gesperrt.',
	'IP Address: [_1]' => 'IP-Adresse: [_1]',
	'Recovery: [_1]' => 'Entsperren: [_1]',
	'Mail Footer' => 'Mail-Signatur',

## default_templates/lockout-user.mtml
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Ein Movable Type-Benutzerkonto wurde automatisch gesperrt.',
	'Username: [_1]' => 'Benutzername: [_1]',
	'Display Name: [_1]' => 'Benutzername: [_1]',
	'Email: [_1]' => 'E-Mail-Adresse:',
	'If you want to permit this user to participate again, click the link below.' => 'Um das Konto wieder freizuschalten, klicken Sie auf folgenden Link.',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Diese Widgetgruppe erscheint ausschließlich auf der Startseite (bzw. auf der von der Vorlage "main_index" erzeugten Seite). Weitere Informationen: [_1]',
	'Recent Comments' => 'Aktuelle Kommentare',
	'Recent Entries' => 'Aktuelle Einträge',
	'Recent Assets' => 'Aktuelle Assets',
	'Tag Cloud' => 'Tag-Wolke',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Monat wählen...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archiv</a>',

## default_templates/monthly_entry_listing.mtml

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Ein neuer [_3] namens &#8222;[_1]&#8220; wurde auf [_2] veröffentlicht.},
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

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Um das Passwort Ihres Movable-Type-Benutzerkontos zu ändern, klicken Sie bitte auf folgenden Link.',
	'If you did not request this change, you can safely ignore this email.' => 'Wenn Sie Ihr Passwort nicht ändern möchten, können Sie diese E-Mail bedenkenlos ignorieren.',

## default_templates/search.mtml
	'Search' => 'Suchen',

## default_templates/search_results.mtml
	'Search Results' => 'Suchergebnis',
	'Results matching &ldquo;[_1]&rdquo;' => 'Suchergebnis für &#8222;[_1]&#8220;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Suchergebnis für Tag &#8222;[_1]&#8220;',
	'Previous' => 'Zurück',
	'Next' => 'Vor',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Kein Suchergebnis für &#8222;[_1]&#8220;',
	'Instructions' => 'Hinweise',
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'ie Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',
	'movable type' => 'Movable Type',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'Die Boolschen Operatoren AND, OR und NOT werden unterstützt:',
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
	q{Subscribe to this blog's feed} => q{Feed dieses Blogs abonnieren},
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Feed aller künftigen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Feed aller künftigen Einträge mit &#8222;[_1]&#8220; abonnieren',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed aller mit &#8222;[_1]&#8220; getaggten Ergebnisse abonnieren',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feeds aller Ergebnisse zu &#8222;[_1]&#8220; abonnieren',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{<a href='http://www.technorati.com/'>Technorati</a>-Suche},
	'this blog' => 'in diesem Blog',
	'all blogs' => 'in allen Blogs',
	'Blogs that link here' => 'Blogs, die Links auf diese Seite enthalten',

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Bei Erzeugung des Aktivitäts-Feeds ist ein Fehler aufgetreten: [_1].',
	'No permissions.' => 'Keine Berechtigung.',
	'[_1] Entries' => '[_1] Einträge',
	'All Entries' => 'Alle Einträge',
	'[_1] Activity' => '[_1] Aktivitäten',
	'All Activity' => 'Alle Aktivitäten',
	'Invalid request.' => 'Ungültige Anfrage.',
	'Movable Type System Activity' => 'Movable Type System-Aktivität',
	'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',
	'[_1] Pages' => '[_1] Seiten',
	'All Pages' => 'Alle Seiten',
	'[_1] "[_2]" Content Data' => '[_1] "[_2]"-Inhaltsdaten',
	'All "[_1]" Content Data' => 'Alle "[_1]"-Inhaltsdaten',

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Nicht alle Websites gelöscht. Bitte löschen Sie zuerst die zu den jeweiligen Websites gehörende Blogs.',

## lib/MT/App/CMS.pm
	'[_1]\'s Group' => 'Gruppen von [_1]',
	'Invalid request' => 'Ungültige Anfrage',
	'Add a user to this [_1]' => 'Benutzer zur [_1] hinzufügen',
	'Are you sure you want to reset the activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Sie sind dabei, E-Mails zu verschicken, mit denen die gewählten Benutzer ihre Passwörter zurücksetzen können. Fortfahren?',
	'_WARNING_DELETE_USER_EUM' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen? Benutzer können ihre Konten selbst wiederherstellen, solange sie noch in externen Verzeichnissen aufgeführt sind.',
	'_WARNING_DELETE_USER' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Hiermit werden die Vorlagen der gewählten Blogs auf die Standardvorlagen zurückgesetzt. Möchten Sie die Vorlagen der gewählten Blogs wirklich zurücksetzen?',
	'Are you sure you want to delete the selected group(s)?' => 'Gewählte Gruppe(n) wirklich löschen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Gewählte(n) Benutzer wirklich aus Gruppe entfernen?',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'Groups ([_1])' => 'Gruppen ([_1])',
	'Failed login attempt by user who does not have sign in permission. \'[_1]\' (ID:[_2])' => 'Fehlgeschlagener Anmeldeversuch von Benutzer ohne Anmeldeberechtigung. \'[_1]\' (ID:[_2])',
	'Invalid login.' => 'Login ungültig.',
	'Cannot load blog (ID:[_1])' => 'Kann Blog (ID:[_1]) nicht laden',
	'No such blog [_1]' => 'Kein Weblog [_1]',
	'Invalid parameter' => 'Ungültiges Parameter',
	'Edit Template' => 'Vorlage bearbeiten',
	'Back' => 'Zurück',
	'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
	'entry' => 'Eintrag',
	'content data' => 'Inhaltsdaten',
	'None' => 'Kein(e)',
	'Error during publishing: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Movable Type News' => 'Movable Type Aktuell',
	'Notification Dashboard' => 'Notification Dashboard',
	'Site Stats' => 'Site-Statistik',
	'Updates' => 'Updates',
	'Activity Log' => 'Aktivitäten',
	'Site List' => 'Site-Liste',
	'Site List for Mobile' => 'Site-Liste in Mobilansicht', # Translate - New # OK
	'Refresh Templates' => 'Vorlagen zurücksetzen',
	'Use Publishing Profile' => 'Veröffentlichungsprofil verwenden',
	'Create Role' => 'Rolle anlegen',
	'Grant Permission' => 'Berechtigungen zuweisen',
	'Clear Activity Log' => 'Aktivitätsprotokoll zurücksetzen',
	'Download Log (CSV)' => 'Protokoll herunterladen (CSV)',
	'Add IP Address' => 'IP-Adresse hinzufüge',
	'Add Contact' => 'Kontakt hinzufügen',
	'Download Address Book (CSV)' => 'Adressbuch herunterladen (CSV)',
	'Add user to group' => 'Benutzer zu Gruppe hinzufügen',
	'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
	'Add Tags...' => 'Tags hinzufügen...',
	'Tags to add to selected entries' => 'Gewählte Einträge mit diesen Tags versehen',
	'Remove Tags...' => 'Tags entfernen...',
	'Tags to remove from selected entries' => 'Diese Tags von gewählten Einträgen entfernen',
	'Batch Edit Entries' => 'Mehrere Einträge bearbeiten',
	'Publish' => 'Veröffentlichen',
	'Delete' => 'Löschen',
	'Unpublish Pages' => 'Seiten nicht mehr veröffentlichen',
	'Tags to add to selected pages' => 'Gewählte Seiten mit diesen Tags versehen',
	'Tags to remove from selected pages' => 'Diese Tags von gewählten Seiten entfernen',
	'Batch Edit Pages' => 'Mehrere Seiten bearbeiten',
	'Tags to add to selected assets' => 'Gewählte Assets mit diesen Tags versehen',
	'Tags to remove from selected assets' => 'Diese Tags von gewählten Assets entfernen',
	'Recover Password(s)' => 'Passwort anfordern',
	'Enable' => 'Aktivieren',
	'Disable' => 'Deaktivieren',
	'Unlock' => 'Entsperren',
	'Remove' => 'Entfernen',
	'Refresh Template(s)' => 'Vorlage(n) zurücksetzen',
	'Move child site(s) ' => 'Untersite(s) verschieben',
	'Clone Child Site' => 'Untersite klonen',
	'Publish Template(s)' => 'Vorlage(n) veröffentlichen',
	'Clone Template(s)' => 'Vorlage(n) klonen',
	'Revoke Permission' => 'Berechtigung entziehen',
	'Rebuild' => 'Neu aufbauen',
	'View Site' => 'Ansehen',
	'Profile' => 'Profil',
	'Documentation' => 'Dokumentation',
	'Sign out' => 'Abmelden',
	'Sites' => 'Sites',
	'Content Data' => 'Inhaltsdaten',
	'Entries' => 'Einträge',
	'Category Sets' => 'Kategorie-Sets',
	'Assets' => 'Assets',
	'Content Types' => 'Inhaltstypen',
	'Groups' => 'Gruppen',
	'Feedbacks' => 'Feeback',
	'Roles' => 'Rollen',
	'Design' => 'Gestalten',
	'Filters' => 'Filter',
	'Settings' => 'Einstellungen',
	'Tools' => 'Tools',
	'Manage' => 'Verwalten',
	'New' => 'Neu',
	'Manage Members' => 'Mitglieder verwalten',
	'Associations' => 'Verknüpfungen',
	'Import' => 'Importieren',
	'Export' => 'Exportieren',
	'Folders' => 'Ordner',
	'Upload' => 'Hochladen',
	'Themes' => 'Themen',
	'General' => 'Allgemein',
	'Compose' => 'Schreiben',
	'Feedback' => 'Feedback',
	'Web Services' => 'Webdienste',
	'Plugins' => 'Plugins',
	'Rebuild Trigger' => 'Auslöser für Neuaufbau',
	'IP Banning' => 'IP-Sperren',
	'User' => 'Benutzer',
	'Search & Replace' => 'Suchen & Ersetzen',
	'Import Sites' => 'Sites importieren',
	'Export Sites' => 'Sites exportieren',
	'Export Site' => 'Site exportieren',
	'Export Theme' => 'Thema exportieren',
	'Address Book' => 'Adressbuch',
	'Asset' => 'Asset',
	'Website' => 'Website',
	'Blog' => 'Blog',
	'Permissions' => 'Berechtigungen',

## lib/MT/App.pm
	'Problem with this request: corrupt character data for character set [_1]' => 'Es ist ein Fehler aufgetreten: ungültige Zeichen für Zeichensatz [_1]',
	'Cannot load blog #[_1]' => 'Konnte Blog #[_1] nicht laden',
	'Internal Error: Login user is not initialized.' => 'Interner Fehler: Login-Benutzer nicht initialisiert.',
	'The login could not be confirmed because of a database error ([_1])' => 'Der Anmeldevorgang konnte wegen eines Datenbankfehlers nicht abgeschlossen werden ([_1])',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Sie sind nicht berechtigt, auf Blogs oder Websites dieser Movable-Type-Installation zuzugreifen. Sollte es sich dabei um einen Fehler handeln, wenden Sie sich bitte an Ihren Administrator.',
	'Cannot load blog #[_1].' => 'Konnte Blog #[_1] nicht laden.',
	'Failed login attempt by unknown user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von deaktiviertem Benutzer \'[_1]\'',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde deaktiviert. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Failed login attempt by pending user \'[_1]\'' => 'Fehlgeschlagener Anmeldeversuch von wartendem Benutzer &#8222;[_1]&#8220;',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde gelöscht. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'User cannot be created: [_1].' => 'Kann Benutzerkonto nicht anlegen: [_1].',
	'User \'[_1]\' has been created.' => 'Benutzerkonto &#8222;[_1]&#8220; angelegt.',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Es tut uns leid, aber Sie keine Berechtigung, auf Blogs oder Websites dieser Installation zuzugreifen. Sollte hier ein Irrtum vorliegen, wenden Sie sich bitte an Ihren Movable Type-Systemadministrator.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) erfolgreich angemeldet',
	'Invalid login attempt from user \'[_1]\'' => 'Ungültiger Anmeldeversuch von Benutzer &#8222;[_1]&#8220;',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) abgemeldet',
	'User requires password.' => 'Passwort erforderlich.',
	'Passwords do not match.' => 'Die Passwörter stimmen nicht überein.',
	'URL is invalid.' => 'Die URL ist ungültig.',
	'User requires display name.' => 'Anzeigename erforderlich.',
	'[_1] contains an invalid character: [_2]' => '[_1] enthält ein ungültiges Zeichen: [_2]',
	'Display Name' => 'Anzeigename',
	'Email Address is invalid.' => 'Die E-Mail-Adresse ist ungültig.',
	'Email Address' => 'E-Mail-Adresse',
	'Email Address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'User requires username.' => 'Benutzername erforderlich.',
	'Username' => 'Benutzername',
	'A user with the same name already exists.' => 'Ein Benutzer mit diesem Namen existiert bereits.',
	'Text entered was wrong.  Try again.' => 'Der eingegebene Text ist nicht richtig. Bitte versuchen Sie es erneut.',
	'An error occurred while trying to process signup: [_1]' => 'Bei der Bearbeitung Ihrer Anmeldung ist ein Fehler aufgetreten: [_1]',
	'New Comment Added to \'[_1]\'' => 'Neuer Kommentar zu &#8222;[_1]&#8220; eingegangen',
	'System Email Address is not configured.' => 'Die System-E-Mail-Adresse ist nicht konfiguriert.',
	'Unknown error occurred.' => 'Es ist ein unbekannter Fehler aufgetreten.',
	'Close' => 'Schließen',
	'Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive \'[_1]\': [_2]' => 'Die in IISFastCGIMonitoringFilePath angegebene Monitoring-Datei konnte nicht geöffnet werden:',
	'Failed to open pid file [_1]: [_2]' => 'Konnte PID-Datei [_1] nicht öffnen: [_2]',
	'Failed to send reboot signal: [_1]' => 'Konnte Reboot-Signal nicht senden: [_1]',
	'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu groß.',
	'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
	'Warnings and Log Messages' => 'Warnungen und Logmeldungen',
	'Removed [_1].' => '[_1] entfernt.',
	'Cannot load entry #[_1].' => 'Konnte Eintrag #[_1] nicht laden',
	'You did not have permission for this action.' => 'Zu dieser Aktion sind Sie nicht berechtigt.',

## lib/MT/App/Search/ContentData.pm
	'Invalid archive type' => 'Ungültiger Archivtyp',
	'Invalid value: [_1]' => 'Ungültiger Wert: [_1]',
	'Invalid query: [_1]' => 'Ungültige Suchanfrage: [_1]',
	'Invalid SearchContentTypes "[_1]": [_2]' => 'Ungültiges SearchContentTypes "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'Ungültiges SearchContentTypes: [_1]',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Ungültiger Typ: [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Konnte Suchergebnis nicht zwischenspeichern. [_1] nicht verfügbar: [_2]',
	'Invalid format: [_1]' => 'Ungültiges Format: [_1]',
	'Unsupported type: [_1]' => 'Nicht unterstützter Typ: [_1]',
	'No column was specified to search for [_1].' => 'Keine Spalte zur Suche nach [_1] angegeben.',
	'Search: query for \'[_1]\'' => 'Suche: Suche nach &#8222;[_1]&#8220;',
	'No alternate template is specified for template \'[_1]\'' => 'Keine Alternative zu Vorlage &#8222;[_1]&#8220; angegeben.',
	'Opening local file \'[_1]\' failed: [_2]' => 'Konnte lokale Datei &#8222;[_1]&#8220; nicht öffnen: [_2]',
	'No such template' => 'Keine solche Vorlage',
	'template_id cannot refer to a global template' => 'template_id kann sich nicht auf eine globale Vorlage beziehen.',
	'Output file cannot be of the type asp or php' => 'Die Ausgabedatei kann nicht im Format ASP oder PHP sein. ',
	'You must pass a valid archive_type with the template_id' => 'Bitte übergeben Sie mit der template_id eine gültige archive_type-Angabe',
	'Template must be archive listing for non-Index archive types' => 'Verwenden Sie eine Archivliste für Archive ohne Indizes',
	'Filename extension cannot be asp or php for these archives' => 'Bei diesem Archivtyp darf die Dateierweiterung nicht ASP oder PHP lauten.',
	'Template must be a main_index for Index archive type' => 'Verwenden Sie für Index-Archivseiten eine main_index-Vorlage.',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'Die Suche dauert zu lange. Bitte vereinfachen Sie Ihre Suchanfrage und versuchen Sie es erneut.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch verwendet MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Authentifizierung mit den angegeben Daten fehlgeschlagen: [_1]',
	'Both passwords must match.' => 'Die beiden Passwörter müssen übereinstimmen.',
	'You must supply a password.' => 'Bitte geben Sie ein Passwort an.',
	'Invalid email address \'[_1]\'' => 'Ungültige E-Mail-Adresse \'[_1]\'',
	'The \'Website Root\' provided below is not allowed' => 'Das angegebene Wurzelverzeichnis der Website ist ungültig bzw. nicht zulässig.',
	'The \'Website Root\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'Der Server kann das angegebene Wurzelverzeichnis der Website nicht beschreiben. Bitte ändern Sie die entsprechenden Zugriffs- und/oder Besitzer-Rechte und klicken Sie dann erneut auf \'Installation abschließen\'.',
	'Invalid session.' => 'Ungültige Session',
	'Invalid parameter.' => 'Parameter ungültig.',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Keine Berechtigung. Bitte wenden Sie sich zur Aktualisierung dieser Movable-Type-Installation an Ihren Administrator.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type erfolgreich auf Version [_1] aktualisiert.',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Zur Nutzung von [_2] ist ein [_1]-Treiber erforderlich.',
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Die Datenbankverbindung konnte nicht aufgebaut werden. Bitte überprüfen Sie die Einstellungen und versuchen Sie es erneut.',
	'Please select a database from the list of available databases and try again.' => 'Bitte wählen Sie einen Datenbank-Typ aus der Liste der verfügbaren Typen und versuchen Sie es erneut.',
	'SMTP Server' => 'SMTP-Server',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Testmail vom Movable Type-Konfigurationsassistenten',
	'This is the test email sent by your new installation of Movable Type.' => 'Diese Testmail wurde von Ihrer neuen Movable Type-Installation verschickt.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP ist für den Versand von E-Mails über SMTP-Server erforderlich.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Dieses Modul ist zur Nutzung des XML-RPC-Servers von Movable Type erforderlich.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Dieses Modul ist zum Überschreiben bereits vorhandener Dateien beim Hochladen erforderlich.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Dieses Modul ist zur Erzeugung von Vorschaubildern von hochgeladenen Dateien erforderlich.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Dieses Modul ist erforderlich, wenn Sie NetPBM als Bildquelle verwenden möchten.',
	'This module is required by certain MT plugins available from third parties.' => 'Dieses Modul ist für einige MT-Plugins von Drittanbietern erforderlich.',
	'This module accelerates comment registration sign-ins.' => 'Dieses Modul beschleunigt die Anmeldung als Kommentarautor.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File ist zur Authentifizierung von Kommentarautoren über OpenID bei Yahoo! Japan erforderlich.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Dieses Modul ist zur Registrierung von Kommentarautoren und zum Versand von E-Mails über SMTP erforderlich.',
	'This module enables the use of the Atom API.' => 'Dieses Modul ermöglicht die Verwendung der ATOM-API.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Dieses Modul ist zur Verwendung von memcached als Cache-System für Movable Type erforderlich.',
	'This module is required in order to archive files in backup/restore operation.' => 'Dieses Modul ist zur Archivierung von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to compress files in backup/restore operation.' => 'Dieses Modul ist zur Packen von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Dieses Modul ist zum Entpacken von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Dieses Modul und seine Abhängigkeiten sind zum Einspielen von Sicherheitskopien erforderlich.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Dieses Modul und seine Abhängigkeiten sind zur Authentifizierung von Kommentar-Autoren mittels OpenID (einschließlich LiveJournal) erforderlich.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Dieses Modul ist für mt-search.cgi erforderlich, wenn Sie Movable Type unter Perl älter als Version 5.8 ausführen.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherheitskopien erforderlich sind.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck ist optional. Es handelt sich um eine bessere, kleinere und schnellere Alternative zu YAML::Tiny.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Dieses Modul ist zur Bestimmung der Größe hochgeladener Dateien erforderlich.',
	'This module is required for cookie authentication.' => 'Dieses Modul ist zur Cookie-Authentifizierung erforderlich.',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'tägliches Autorenarchiv',
	'author/author-basename/yyyy/mm/dd/index.html' => 'autor/autoren-basisname/jjjj/mm/tt/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'autor/autoren_basisname/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'monatliches Autorenarchiv',
	'author/author-basename/yyyy/mm/index.html' => 'autor/autoren-basisname/jjjj/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'autor/autoren_basisname/jjjj/mm/index.hmtl',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Autorenarchiv',
	'author/author-basename/index.html' => 'autor/autoren-basisname/index.html',
	'author/author_basename/index.html' => 'autor/autoren-basisname/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'wöchentliches Autorenarchiv',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'autor/autoren-basisname/jjjj/mm/wochen-tag/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'autor/autoren-basisname/jjjj/mm/wochen-tag/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'jährliches Autorenarchiv',
	'author/author-basename/yyyy/index.html' => 'autor/autoren-basisname/jjjj/index.html',
	'author/author_basename/yyyy/index.html' => 'autor/autoren_basisname/jjjj/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'tägliches Kategoriearchiv',
	'category/sub-category/yyyy/mm/dd/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tt/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'monatliches Kategoriearchiv',
	'category/sub-category/yyyy/mm/index.html' => 'kategorie/unter-kategorie/jjjj/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'kategorie/unter_kategorie/jjjj/mm/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Kategoriearchiv',
	'category/sub-category/index.html' => 'kategorie/unter-kategorie/index.html',
	'category/sub_category/index.html' => 'kategorie/unter_kategorie/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'wöchentliches Kategoriearchiv',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tag-woche/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'jährliches Kategoriearchiv',
	'category/sub-category/yyyy/index.html' => 'kategorie/unter-kategorie/jjjj/index.html',
	'category/sub_category/yyyy/index.html' => 'kategorie/unter_kategorie/jjjj/index.html',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm

## lib/MT/ArchiveType/ContentTypeAuthor.pm

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm

## lib/MT/ArchiveType/ContentTypeCategory.pm

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'DAILY_ADV' => 'Tagesarchiv',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'MONTHLY_ADV' => 'Monatsarchiv',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'yyyy/mm/content-basename.html' => 'jjjj/mm/inhalts-basisname.html',
	'yyyy/mm/content_basename.html' => 'jjjj/mm/inhalts_basisname.html',
	'yyyy/mm/content-basename/index.html' => 'jjjj/mm/inhalts-basisname/index.html',
	'yyyy/mm/content_basename/index.html' => 'jjjj/mm/inhalts_basisname/index.html',
	'yyyy/mm/dd/content-basename.html' => 'jjjj/mm/tt/inhalts-basisname.html',
	'yyyy/mm/dd/content_basename.html' => 'jjjj/mm/tt/inhalts_basisname.html',
	'yyyy/mm/dd/content-basename/index.html' => 'jjjj/mm/tt/inhalts-basisname/index.html',
	'yyyy/mm/dd/content_basename/index.html' => 'jjjj/mm/tt/inhalts_basisname/index.html',
	'author/author-basename/content-basename/index.html' => 'autor/autoren-basisname/inhalts-basisname/index.html',
	'author/author_basename/content_basename/index.html' => 'autor/autoren_basisname/inhalts_basisname/index.html',
	'author/author-basename/content-basename.html' => 'autor/autoren-basisname/inhalts-basisname.html',
	'author/author_basename/content_basename.html' => 'autor/autoren_basisname/inhalts_basisname.html',
	'category/sub-category/content-basename.html' => 'kategorie/unter-kategorie/inhalts-basisname.html',
	'category/sub-category/content-basename/index.html' => 'kategorie/unter-kategorie/inhalts-basisname/index.html',
	'category/sub_category/content_basename.html' => 'kategorie/unter_kategorie/inhalts_basisname.html',
	'category/sub_category/content_basename/index.html' => 'kategorie/unter_kategorie/inhalts_basisname/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'WEEKLY_ADV' => 'Wochenarchiv',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'YEARLY_ADV' => 'Jahresarchiv',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/ArchiveType/Daily.pm

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'Einzelarchiv',
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

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Seitenarchiv',
	'folder-path/page-basename.html' => 'pfad-angabe/seiten-name.html',
	'folder-path/page-basename/index.html' => 'pfad-angabe/seiten-name/index.html',
	'folder_path/page_basename.html' => 'pfad_angabe/seiten_name.html',
	'folder_path/page_basename/index.html' => 'pfad_angabe/seiten_name/index.html',

## lib/MT/ArchiveType/Weekly.pm

## lib/MT/ArchiveType/Yearly.pm

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
	'Cannot load image #[_1]' => 'Kann Bild #[_1] nicht laden',
	'View image' => 'Bild ansehen',
	'Thumbnail image for [_1]' => 'Vorschaubild für [_1]',
	'Saving [_1] failed: [_2]' => '[_1] konnte nicht gespeichert werden: [_2]',
	'Invalid basename \'[_1]\'' => 'Ungültiger Basisname &#8222;[_1]&#8220;',
	'Error writing to \'[_1]\': [_2]' => 'Fehler beim Schreiben auf &#8222;[_1]&#8220;: [_2] ',
	'Popup page for [_1]' => 'Popup-Seite für [_1]',
	'Scaling image failed: Invalid parameter.' => 'Skalieren des Bildes fehlgeschlagen: Parameter ungültig.',
	'Cropping image failed: Invalid parameter.' => 'Beschneiden des Bildes fehlgeschlagen: Parameter ungültig.',
	'Rotating image failed: Invalid parameter.' => 'Drehen des Bildes fehlgeschlagen: Parameter ungültig.',
	'Writing metadata failed: [_1]' => 'Schreiben von Metadaten fehlgeschlagen: [_1]',
	'Error writing metadata to \'[_1]\': [_2]' => 'Schreiben von Metadaten in \'[_1]\' fehlgeschlagen: [_2]',
	'Extracting image metadata failed: [_1]' => 'Auslesen der Metadaten des Bildes fehlgeschlagen: [_1]',
	'Writing image metadata failed: [_1]' => 'Schreiben der Metadaten des Bildes fehlgeschlagen: [_1]',

## lib/MT/Asset.pm
	'Deleted' => 'Gelöscht',
	'Enabled' => 'Aktiviert',
	'Disabled' => 'Deaktiviert',
	'missing' => 'fehlt',
	'extant' => 'vorhanden',
	'Assets with Missing File' => 'Assets mit fehlender Datei',
	'Assets with Extant File' => 'Assets mit vorhandener Datei',
	'Assets in [_1] field of [_2] \'[_4]\' (ID:[_3])' => 'Assets im [_1]-Feld von [_2] \'[_4]\' (ID:[_3])',
	'No Label' => 'Keine Bezeichnung',
	'Content Field ( id: [_1] ) does not exists.' => 'Inhaltsfeld ( id: [_1] ) existiert nicht.',
	'Content Data ( id: [_1] ) does not exists.' => 'Inhaltsdaten ( id: [_1] ) existieren nicht.',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'Inhaltstyp dieser Inhaltsdaten ( id: [_1] ) existiert nicht.',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Konnte Asset-Datei [_1] nicht aus Dateisystem löschen: [_2]',
	'Description' => 'Beschreibung',
	'Name' => 'Name',
	'URL' => 'URL',
	'Location' => 'Ort',
	'Could not create asset cache path: [_1]' => 'Konnte Asset-Cache-Pfad nicht anlegen: [_1]',
	'string(255)' => 'string(255)',
	'Label' => 'Bezeichnung',
	'Type' => 'Typ',
	'Filename' => 'Dateiname',
	'File Extension' => 'Dateierweiterung',
	'Pixel Width' => 'Breite in Pixel',
	'Pixel Height' => 'Höhe in Pixel',
	'Except Userpic' => 'Benutzerbild ausnehmen',
	'Author Status' => 'Status des Autors',
	'Missing File' => 'Datei fehlt',
	'Content Field' => 'Inhaltsfeld',
	'Assets of this website' => 'Assets dieser Website',

## lib/MT/Asset/Video.pm
	'Videos' => 'Videos',

## lib/MT/Association.pm
	'Association' => 'Verknüpfung',
	'Permissions of group: [_1]' => 'Gruppen-Berechtigungen: [_1]',
	'Group' => 'Gruppe',
	'Permissions with role: [_1]' => 'Berechtigungen der Rolle [_1]',
	'User is [_1]' => 'Benutzer ist [_1]',
	'Permissions for [_1]' => 'Berechtigungen für [_1]',
	'association' => 'Verknüpfungen',
	'associations' => 'Verknüpfungen',
	'User/Group' => 'Benutzer/Gruppe',
	'User/Group Name' => 'Benutzer-/Gruppen-Name',
	'Role' => 'Rolle',
	'Role Name' => 'Rollenname',
	'Role Detail' => 'Rolle-Details',
	'Site Name' => 'Site-Name',
	'Permissions for Users' => 'Benutzer-Berechtigungen',
	'Permissions for Groups' => 'Gruppen-Berechtigungen',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Einträge',
	'Invalid blog ID \'[_1]\'' => 'Ungültige Blog-ID &#8222;[_1]&#8220;',
	'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
	'Removing stats cache failed.' => 'Löschen des Statistik-Caches fehlgeschlagen.',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => '[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) hinzugefügt.',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => '[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) bearbeitet.',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Entry &#8222;[_1]&#8220; ([lc,_5] #[_2]) von &#8222;[_3]&#8220; (#[_4]) über Atom-API gelöscht.',
	'\'[_1]\' is not allowed to upload by system settings.: [_2]' => '\'[_1]\' hat laut System-Einstellungen keine Upload-Berechtigung: [_2]',
	'Invalid image file format.' => 'Ungültiges Bildformat.',
	'Cannot make path \'[_1]\': [_2]' => 'Kann Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Zur Bestimmung der Höhe und Breite hochgeladener Bilder ist das Perl-Modul Image::Size erforderlich.',

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => 'Das aktuelle Passwort konnte nicht verifiziert werden.',
	'Password contains invalid character.' => 'Das Passwort enthält mindestens ein ungültiges Zeichen.',
	'Missing required module' => 'Ein erforderliches Modul fehlt',

## lib/MT/Author.pm
	'Users' => 'Benutzer',
	'Active' => 'Aktiv',
	'Pending' => 'Auf Moderation wartend',
	'Not Locked Out' => 'Nicht gesperrt',
	'Locked Out' => 'Gesperrt',
	'MT Users' => 'MT-Benutzer',
	'Commenters' => 'Kommentarautoren',
	'Registered User' => 'Registrierter Benutzer',
	'The approval could not be committed: [_1]' => 'Bestätigung konnte nicht übernommen werden: [_1]',
	'Userpic' => 'Benutzerbild',
	'User Info' => 'Benutzerinfo',
	'__ENTRY_COUNT' => 'Einträge',
	'Content Data Count' => 'Anzahl Inhaltsdaten',
	'Created by' => 'Angelegt von',
	'Status' => 'Status',
	'Website URL' => 'Website',
	'Privilege' => 'Privilegien',
	'Lockout' => 'Sperrung',
	'Enabled Users' => 'Aktive Benutzerkonten',
	'Disabled Users' => 'Deaktivierte Benutzerkonten',
	'Pending Users' => 'Wartende Benutzerkonten',
	'Locked out Users' => 'Gesperrte Benutzerkonten',
	'MT Native Users' => 'Native MT-Benutzer',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Fehlerhafte AuthenticationModule-Konfiguration &#8222;[_1]&#8220;: [_2]',
	'Bad AuthenticationModule config' => 'Fehlerhafte AuthenticationModule-Konfiguration',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'Die hochgeladene Datei ist keine gültige aus Movable Type exportierte Manifest-Datei.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'Die hochgeladene Manifest-Datei wurde zwar mit Movable Type erzeugt, aber mit einem anderen Schema ([_1]) als es von diesem System verwendet wird ([_2]). Sie sollten sie daher nicht in diese Version von Movable Type importieren.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] kann nicht in Movable Type importiert werden.',
	'[_1] records imported.' => '[_1] Datensätze importiert.',
	'Importing [_1] records:' => 'Importiere [_1] Datensätze:',
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Benutzer mit dem gleichen Namen wie der aktuelle Benutzer in der Exportdatei gefunden ([_1]), Datensatz übersprungen.',
	'A user with the same name \'[_1]\' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.' => 'Benutzer mit dem gleichen Namen \'[_1]\' in der Exportdatei gefunden (ID:[_2]), vorhandene Daten mit denen aus der Exportdatei ersetzt.',
	'Invalid serializer version was specified.' => 'Ungültiger Serializer angegeben.',
	'Tag \'[_1]\' exists in the system.' => 'Tag &#8222;[_1]&#8220; bereits im System vorhanden.',
	'[_1] records imported...' => '[_1] Datensätze importiert...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Die Rolle &#8222;[_1]&#8220; wurde in &#8222;[_2]&#8220; umbenannt, da bereits eine Rolle mit diesem Namen vorhanden ist.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => 'Einstellungen auf Systemebene für Plugin &#8222;[_1]&#8220; bereits vorhanden; überspringe Eintrag.',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Diese Datei kann nicht importiert werden, da dazu das Perl-Modul Digest::SHA erforderlich ist. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'Diese Datei kann nicht importiert werden, da weder im vorhandenen Movable-Type-System noch in den Exportdaten eine Site vorhanden ist. Bitte legen Sie zuerst eine Site an.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "Laufwerk voll. Datei kann nicht geschrieben werden.",
	'Exporting [_1] records:' => 'Exportiere [_1]-Datensätze:',
	'[_1] records exported...' => '[_1]-Datensätze exportiert...',
	'[_1] records exported.' => '[_1]-Datensätze exportiert.',
	'There were no [_1] records to be exported.' => 'Keine [_1]-Datensätze zu exportieren.',
	'Cannot open directory \'[_1]\': [_2]' => 'Kann Verzeichnis &#8222;[_1]&#8220; nicht öffnen: [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Keine Manifest-Datei im Importverzeichnis [_1] gefunden.',
	'Cannot open [_1].' => 'Kann [_1] nicht öffnen.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-Datei [_1] ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Manifest file: [_1]' => 'Manifest-Datei: [_1]',
	'Path was not found for the file, [_1].' => 'Verzeichnis für Datei nicht gefunden, [_1]',
	'[_1] is not writable.' => 'Kein Schreibzugriff auf [_1]',
	'Error making path \'[_1]\': [_2]' => 'Fehler beim Anlegen des Ordners &#8222;[_1]&#8220;: [_2]',
	'Copying [_1] to [_2]...' => 'Kopiere [_1] nach [_2]...',
	'Failed: ' => 'Fehler: ',
	'Done.' => 'Fertig.',
	'Importing asset associations ... ( [_1] )' => 'Importiere Asset-Verknüpfungen ... ( [_1] )',
	'Importing asset associations in entry ... ( [_1] )' => 'Importiere Asset-Verknüpfungen in Eintrag .... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'Importiere Asset-Verknüpfungen in Seite .... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'Importiere Inhaltsdaten ... ( [_1] )',
	'Rebuilding permissions ... ( [_1] )' => 'Baue Berechtigungen neu auf ... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'Importiere Asset-URLs ( [_1] )...',
	'Importing url of the assets in entry ( [_1] )...' => 'Importiere Asset-URLs in Eintrag ( [_1] )...',
	'Importing url of the assets in page ( [_1] )...' => 'Importiere Asset-URLs in Seite ( [_1] )...',
	'ID for the file was not set.' => 'ID für Datei nicht gesetzt.',
	'The file ([_1]) was not imported.' => 'Datei ([_1]) nicht importiert',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Datei &#8222;[_1]&#8220; (ID:[_2])....',
	'failed' => 'Fehlgeschlagen',
	'ok' => 'OK',

## lib/MT/BasicAuthor.pm
	'authors' => 'Autoren',

## lib/MT/Blog.pm
	'Child Site' => 'Untersite',
	'Child Sites' => 'Untersites',
	'*Site/Child Site deleted*' => '*Site/Untersite gelöscht*',
	'First Blog' => 'Erstes Blog',
	'No default templates were found.' => 'Keine Standardvorlagen gefunden.',
	'archive_type is needed in Archive Mapping \'[_1]\'' => 'archive_type in Archiv-Verknüpfung \'[_1]\' erforderlich',
	'Invalid archive_type \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ungültiger archive_type \'[_1]\' in Archiv-Verknüpfung \'[_2]\'',
	'Invalid datetime_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ungültiges datetime_field \'[_1]\' in Archiv-Verknüpfung \'[_2]\'',
	'Invalid category_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ungültiges category_field \'[_1]\' in Archiv-Verknüpfung \'[_2]\'',
	'category_field is required in Archive Mapping \'[_1]\'' => 'category_field in Archiv-Verknüpfung \'[_1]\' erforderlich',
	'Clone of [_1]' => 'Klon von [_1]',
	'Cloned child site... new id is [_1].' => 'Untersite geklont mit neuer ID [_1] geklont...',
	'Cloning permissions for blog:' => 'Klone Berechtigungen für Webblog:',
	'[_1] records processed...' => '[_1] Einträge bearbeitet...',
	'[_1] records processed.' => '[_1] Einträge bearbeitet.',
	'Cloning associations for blog:' => 'Klone Verknüpfungen für Weblog:',
	'Cloning entries and pages for blog...' => 'Klone Einträge und Seiten für Weblog...',
	'Cloning categories for blog...' => 'Klone Kategorien für Weblog...',
	'Cloning entry placements for blog...' => 'Klone Eintragsplatzierung für Weblog...',
	'Cloning entry tags for blog...' => 'Klone Tags für Weblog...',
	'Cloning templates for blog...' => 'Klone Vorlagen für Weblog...',
	'Cloning template maps for blog...' => 'Klone Vorlagenzuweisungen für Weblog...',
	'Failed to load theme [_1]: [_2]' => 'Laden des Themas [_1] fehlgeschlagen: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Anwendung des Themas [_1] fehlgeschlagen: [_2]',
	'__PAGE_COUNT' => 'Seiten',
	'__ASSET_COUNT' => 'Assets',
	'Content Type' => 'Inhaltstyp',
	'Content Type Count' => 'Anzahl Inhaltstypen',
	'Parent Site' => 'Übergeordnete Site',
	'Theme' => 'Thema',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> in Zeile [_2] unbekannt.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> ohne </[_1]> in Zeile #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> ohne </[_1]> in Zeile [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> ohne </[_1]> in Zeile[_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Fehler im Vorlagenbefehl <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Unbekannter Vorlagenbefehl gefunden: [_1]',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,Eintrag,Einträge,Keine Einträge]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,Seite,Seiten,Keine Seiten]',
	'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
	'Category loop detected' => 'Kategorieschleife festgestellt',
	'string(100) not null' => 'string(100) nicht null',
	'Basename' => 'Basisname',
	'Parent' => 'Mutter',

## lib/MT/CategorySet.pm
	'Category Set' => 'Kategorie-Set',
	'name "[_1]" is already used.' => 'Name "[_1]" wird bereits verwendet.',
	'Category Count' => 'Anzahl Kategorien',
	'Category Label' => 'Kategorie-Bezeichung',
	'Content Type Name' => 'Inhaltstyp-Name',

## lib/MT/CMS/AddressBook.pm
	'No entry ID was provided' => 'Keine Eintrags-ID angegeben.',
	'No such entry \'[_1]\'' => 'Kein Eintrag &#8222;[_1]&#8220;',
	'No valid recipients were found for the entry notification.' => 'Keine gültigen Empfänger-Adressen für Benachrichtigung gefunden.',
	'[_1] Update: [_2]' => '[_1] Update: [_2]',
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Mailversand fehlgeschlagen ([_1]). Sind die MailTransfer-Einstellungen richtig?',
	'Please select a blog.' => 'Bitte wählen Sie ein Blog.',
	'The text you entered is not a valid email address.' => 'Der eingegebene Text ist keine gültige E-Mail-Adresse.',
	'The text you entered is not a valid URL.' => 'Der eingegebene Text ist keine gültige Web-Adresse (URL).',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Die angegebene E-Mail-Adresse befindet sich bereits auf der Benachrichtigungsliste für dieses Weblog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonnent &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_3]&#8220; aus Adressbuch gelöscht',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(Benutzer gelöscht)',
	'Files' => 'Dateien',
	'Extension changed from [_1] to [_2]' => 'Erweiterung von [_1] in [_2] geändert',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Das Vorschaubild konnte nicht angelegt werden, da [_1] diesen Dateityp nicht unterstützt.',
	'Upload Asset' => 'Asset hochladen',
	'Invalid Request.' => 'Ungültige Anfrage.',
	'Permission denied.' => 'Zugriff verweigert.',
	'File with name \'[_1]\' already exists. Upload has been cancelled.' => 'Eine Datei namens \'[_1]\' ist bereits vorhanden. Der Vorgang wurde abgebrochen.',
	'Cannot load file #[_1].' => 'Kann Datei #[_1] nicht laden.',
	'No permissions' => 'Keine Berechtigung',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Datei &#8222;[_1]&#8220; hochgeladen von &#8222;[_2]&#8220;',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Datei &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'Untitled' => 'Ohne Name',
	'Site' => 'Site',
	'basename of user' => 'Basisname des Benutzers',
	'<[_1] Root>' => '<[_1]-Wurzel>',
	'<[_1] Root>/[_2]' => '<[_1]-Wurzel>/[_2]',
	'Archive' => 'Archiv',
	'Custom...' => 'Individuell...',
	'Please select a file to upload.' => 'Bitte wählen die Datei aus, die Sie hochladen möchten.',
	'Invalid filename \'[_1]\'' => 'Ungültiger Dateiname &#8222;[_1]&#8220;',
	'Please select an audio file to upload.' => 'Bitte wählen die Audio-Datei aus, die Sie hochladen möchten.',
	'Please select an image to upload.' => 'Bitte wählen die Bild-Datei aus, die Sie hochladen möchten.',
	'Please select a video to upload.' => 'Bitte wählen die Video-Datei aus, die Sie hochladen möchten.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type konnte nicht in das angegebene Verzeichnis schreiben. Bitte stellen Sie sicher, daß der Server Schreibzugriff auf dieses Verzeichnis hat.',
	'Invalid extra path \'[_1]\'' => 'Ungültiger Zusatzpfad &#8222;[_1]&#8220;',
	'Invalid temp file name \'[_1]\'' => 'Ungültiger temporärer Dateiname &#8222;[_1]&#8220;',
	'Error opening \'[_1]\': [_2]' => 'Fehler beim Öffnen von &#8222;[_1]&#8220;: [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Fehler beim Löschen von &#8222;[_1]&#8220;: [_2]',
	'File with name \'[_1]\' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)' => 'Eine Datei &#8222;[_1]&#8220; existiert bereits. (Installieren Sie das Perl-Modul File::Temp, um zuvor hochgeladene Dateien überschreiben zu können.',
	'Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently \'[_1]\'. ' => 'Temporäre Datei konnte nicht angelegt werden. Der angegebene Pfad muss vom Webserver beschrieben werden können. Bitte überprüfen Sie das Parameter TempDir in Ihrer Konfigurationsdatei. Derzeitiger Einstellung: [_1]',
	'unassigned' => 'nicht vergeben',
	'File with name \'[_1]\' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]' => 'Eine Datei &#8222;[_1]&#8220; existiert bereits und der Webserver konnte keine temporäre Datei anlegen: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Konnte Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Die hochgeladene Datei konnte nicht in &#8222;[_1]&#8220; gespeichert werden: [_2]',
	'Uploaded file is not an image.' => 'Die hochgeladene Datei ist keine Bilddatei.',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Vorhandene Dateien können nicht mit Dateien anderen Typs überschrieben werden. Vorhandene Datei: [_1], neue Datei: [_2]',
	'File with name \'[_1]\' already exists.' => 'Eine Datei namens \'[_1]\' existiert bereits.',
	'Cannot load asset #[_1].' => 'Asset #[_1] konnte nicht geladen werden',
	'Save failed: [_1]' => 'Beim Speichern ist ein Fehler aufgetreten: [_1]',
	'Saving object failed: [_1]' => 'Das Objekt konnte nicht gespeichert werden: [_1]',
	'Transforming image failed: [_1]' => 'Umformung des Bildes fehlgeschlagen: [_1]',
	'Cannot load asset #[_1]' => 'Asset #[_1] konnte nicht geladen werden.',

## lib/MT/CMS/Blog.pm
	q{Cloning child site '[_1]'...} => q{Klone Untersite '[_1]'...},
	'Error' => 'Fehler',
	'Finished!' => 'Fertig!',
	'General Settings' => 'Allgemeine Einstellungen',
	'Compose Settings' => 'Editor-Einstellungen',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Eine Angabe in der Movable Type-Konfigurationsdatei hat Vorrang vor diesen Einstellungen: [_1]. Entfernen Sie die Angabe aus der Konfigurationsdatei, um die entsprechenden Einstellungen hier vornehmen zu können.',
	'Feedback Settings' => 'Feedback-Einstellungen',
	'Plugin Settings' => 'Plugin-Einstellungen',
	'Registration Settings' => 'Registrierungs-Einstellungen',
	'Create Child Site' => 'Untersite anlegen',
	'Cannot load template #[_1].' => 'Kann Vorlage #[_1] nicht laden.',
	'Cannot load content data #[_1].' => 'Kann Inhaltsdaten #[_1] nicht laden.',
	'index template \'[_1]\'' => 'Indexvorlage &#8222;[_1]&#8220;',
	'[_1] \'[_2]\'' => '[_1] &#8222;[_2]&#8220;',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'(no name)' => '(ohne Name)',
	'Publish Site' => 'Site veröffentlichen',
	'Select Child Site' => 'Untersite wählen',
	'Selected Child Site' => 'Gewählte Untersite',
	'Enter a site name to filter the choices below.' => 'Geben Sie einen Sitenamen ein, um die Auswahl einzuschränken.',
	'The \'[_1]\' provided below is not writable by the web server. Change the directory ownership or permissions and try again.' => 'Der Webserver hat keinen Schreibzugriff auf \'[_1]\'. Bitte vergeben Sie entsprechende Benutzerrechte und versuchen Sie es erneut.',
	'Blog Root' => 'Blog-Wurzelverzeichnis',
	'Website Root' => 'Wurzelverzeichnis der Website',
	'Saving permissions failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'[_1] changed from [_2] to [_3]' => '[_1] von [_2] in [_3] geändert',
	'Saved [_1] Changes' => '[_1]-Änderungen gespeichert',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) angelegt von &#8222;[_4]&#8220;',
	'You did not specify a blog name.' => 'Kein Blog-Name angegeben.',
	'Site URL must be an absolute URL.' => 'Site-URL muß eine absolute URL sein.',
	'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
	'You did not specify an Archive Root.' => 'Kein Archiv-Wurzelverzeichnis angebeben.',
	'The number of revisions to store must be a positive integer.' => 'Die Anzahl der zu speichernden Revisionen muss positiv sein.',
	'Please choose a preferred archive type.' => 'Bitte geben Sie eine bevorzugte Archiv-Art an.',
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
	'\'[_1]\' (ID:[_2]) has been copied as \'[_3]\' (ID:[_4]) by \'[_5]\' (ID:[_6]).' => '&#8222;[_1]&#8220; (ID: [_2]) wurde von &#8222;[_5]&#8220; (ID: [_6]) als &#8222;[_3]&#8220; (ID: [_4]) kopiert.',

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => '[_1] muss einen Namen erhalten!',
	'Invalid category_set_id: [_1]' => 'Ungültige category_set_id: [_1]',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => '[_1] konnte nicht aktualisiert werden: [_2] wurde verändert, nachdem Sie diese Seite aufriefen. ',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Konnte [_1] ([_2]) nicht aktualisieren: Objekt nicht gefunden.',
	'[_1] order has been edited by \'[_2]\'.' => 'Die [_1]-Reihenfolge wurde von &#8222;[_2]&#8220; geändert.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Ihre Änderungen wurden übernommen ([_1] hinzugefügt, [_2] bearbeitet, [_3] gelöscht). <a href="#" onclick="[_4]" class="mt-rebuild">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen: Unterkategorien dürfen nicht wie ihre Hauptkategorie heißen.',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Der Kategorie-Basisname &#8222;[_1]&#8220; steht im Konflikt mit dem Basisnamen einer anderen Kategorie: Unterkategorien dürfen nicht den gleichen Basisnamen wie ihre Hauptkategorie haben.',
	'The name \'[_1]\' is too long!' => 'Der Name &#8222;[_1]&#8220; ist zu lang!',
	'Category \'[_1]\' created by \'[_2]\'.' => 'Kategorie &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_2]&#8220;',
	'Category \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Kategorie &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Kategorie &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien gleichen Ursprungs müssen eindeutige Namen haben.',
	'Edit [_1]' => '[_1] bearbeiten',
	'Create [_1]' => '[_1] anlegen',
	'Manage [_1]' => '[_1] verwalten',
	'Create Category Set' => 'Kategorie-Set anlegen',

## lib/MT/CMS/CategorySet.pm

## lib/MT/CMS/Common.pm
	'Invalid type [_1]' => 'Ungültiger Typ [_1]',
	'The Template Name and Output File fields are required.' => 'Die Felder &#8222;Vorlagennamen&#8220; und &#8222;Ausgabedatei&#8220; sind erforderlich.',
	'Invalid ID [_1]' => 'Ungültige ID [_1]',
	'The blog root directory must be within [_1].' => 'Das Wurzelverzeichnis des Blogs muss in [_1] liegen.',
	'The website root directory must be within [_1].' => 'Das Wurzelverzeichnis der Website muss in [_1] liegen.',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '&#8222;[_1]&#8220; hat die Vorlage &#8222;[_2]&#8220; des Blogs &#8222;[_3]&#8220; bearbeitet',
	'\'[_1]\' edited the global template \'[_2]\'' => '&#8222;[_1]&#8220; hat die globale Vorlage &#8222;[_2]&#8220; bearbeitet',
	'Load failed: [_1]' => 'Beim Laden ist ein Fehler augetreten: [_1]',
	'(no reason given)' => '(unbekannte Ursache)',
	'Web Services Settings' => 'Webdienste-Einstellungen',
	'Error occurred during permission check: [_1]' => 'Bei der Prüfung der Zugriffsrechte ist ein Fehler aufgetreten: [_1]',
	'Invalid filter: [_1]' => 'Ungültiger Filter: [_1]',
	'New Filter' => 'Neuer Filter',
	'__SELECT_FILTER_VERB' => 'ist',
	'All [_1]' => 'Alle [_1]',
	'[_1] Feed' => '[_1]-Feed',
	'Unknown list type' => 'Unbekannter Listentyp',
	'Invalid filter terms: [_1]' => 'Ungültiger Filterbegriff: [_1]',
	'An error occurred while counting objects: [_1]' => 'Beim Zählen von Objekten ist ein Fehler aufgetreten: [_1]',
	'An error occurred while loading objects: [_1]' => 'Beim Laden von Objekten ist ein Fehler aufgetreten: [_1]',
	'Removing tag failed: [_1]' => 'Das Tag konnte nicht entfernt werden: [_1]',
	'Removing [_1] failed: [_2]' => '[_1] konnte nicht entfernt werden: [_2]',
	'System templates cannot be deleted.' => 'Systemvorlagen können nicht gelöscht werden.',
	'The selected [_1] has been deleted from the database.' => 'Gewählte [_2] aus der Datenbank gelöscht.',
	'Permission denied: [_1]' => 'Zugriff verweigert: [_1]',
	'Saving snapshot failed: [_1]' => 'Speichern des Snapshots fehlgeschlagen: [_1]',

## lib/MT/CMS/ContentData.pm
	'Cannot load content field (UniqueID:[_1]).' => 'Konnte Inhaltsfeld nicht laden (UniqueID:[_1]).',
	'The value of [_1] is automatically used as a data label.' => 'Der Wert von [_1] wird automatisch als Bezeichnung verwendet.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Site-Pfad und URL dieses Weblogs wurden noch nicht konfiguriert. Sie können keine Einträge veröffentlichen, solange das nicht geschehen ist.',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum &#8222;[_1]&#8220; ungültig. Geben Sie den Zeitpunkt der Veröffentlichung in diesem Format an: JJJJ-MM-TT HH:MM:SS.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss im Format JJJJ-MM-TT SS:MM:SS angegeben werden.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be dates in the future.' => 'Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunk, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss in der Zukunft liegen.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be later than the corresponding \'Published on\' date.' => 'Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss nach dem Zeitpunkt der Veröffentlichung liegen.',
	'Cannot load content_type #[_1]' => 'Konnte content_type #[_1] nicht laden',
	'New [_1] \'[_4]\' (ID:[_2]) added by user \'[_3]\'' => '[_3] \'[_4]\' (ID:[_2]) von Benutzer \'[_3]\' hinzugefügt',
	'[_1] \'[_5]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => '[_1] \'[_5]\' von Benutzer \'[_5]\' bearbeitet und Status von [_3] in [_4] geändert',
	'[_1] \'[_4]\' (ID:[_2]) edited by user \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) von Benutzer \'[_3]\' bearbeitet',
	'[_1] \'[_4]\' (ID:[_2]) deleted by \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) von Benutzer \'[_3]\' gelöscht',
	'Create new [_1]' => '[_1] anlegen',
	'Cannot load template.' => 'Kann Vorlage nicht laden.',
	'Publish error: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Unable to create preview files in this location: [_1]' => 'Kann Vorschau-Dateien hier nicht erzeugen:',
	'(untitled)' => '(unbenannt)',
	'New [_1]' => 'Neuer [_1]',
	'Need a status to update content data' => 'Status zur Aktualisierungen der Inhaltsdaten erforderlich',
	'Need content data to update status' => 'Inhaltsdaten zur Aktualisierung des Status erforderlich',
	'One of the content data ([_1]) did not exist' => 'Bestimmte Inhaltsdaten ([_1]) existieren nicht.',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => 'Status von [_1] (ID:[_2]) von [_3] in [_4] geändert',
	'(No Label)' => '(unbenannt)',
	'Unpublish Contents' => 'Inhalte zurückziehen',

## lib/MT/CMS/ContentType.pm
	'Create Content Type' => 'Inhaltstyp anlegen',
	'Cannot load content type #[_1]' => 'Inhaltstyp #[_1] konnte nicht geladen werden',
	'The content type name is required.' => 'Bitte geben Sie den Namen des Inhaltstyps ein.',
	'The content type name must be shorter than 255 characters.' => 'Der Name des Inhaltstyps darf höchstens 255 Zeichen lang sein.',
	'Name \'[_1]\' is already used.' => 'Der Name \'[_1]\' wird bereits verwendet.',
	'Cannot load content field data (ID: [_1])' => 'Kann Inhaltsfelder-Daten nicht laden (ID: [_1])',
	'Saving content field failed: [_1]' => 'Speichern des Inhaltsfelds fehlgeschlagen: [_1]',
	'Saving content type failed: [_1]' => 'Speichern des Inhaltstyps fehlgeschlagen: [_1]',
	'A label for content field of \'[_1]\' is required.' => 'Bezeichnung für \'[_1]\'-Inhaltsfeld erforderlich.',
	'A label for content field of \'[_1]\' should be shorter than 255 characters.' => 'Die Bezeichnung des \'[_1]\'-Inhaltsfelds darf höchstens 255 Zeichen lang sein.',
	'A description for content field of \'[_1]\' should be shorter than 255 characters.' => 'Die Beschreibung des \'[_1]\'-Inhaltfelds darf höchstens 255 Zeichen lang sein.',
	'*User deleted*' => '*Benutzer gelöscht*',
	'Content Type Boilerplates' => 'Inhaltstyp-Bausteine',
	'Manage Content Type Boilerplates' => 'Inhaltstyp-Bausteine verwalten',
	'Content Type \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Inhaltstyp \'[_1]\' (ID:[_2]) von Benutzer \'[_3]\' hinzugefügt',
	'A content field \'[_1]\' ([_2]) was added' => 'Inhaltsfeld \'[_1]\' ([_2]) hinzugefügt',
	'A content field options of \'[_1]\' ([_2]) was changed' => 'Einstellung von Inhaltsfeld \'[_1]\'([_2]) geändert',
	'Some content fields were deleted: ([_1])' => 'Inhaltsfelder gelöscht: ([_1])',
	'Content Type \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Inhaltstyp \'[_1]\' (ID:[_2]) von Benutzer \'[_3]\' bearbeitet',
	'Content Type \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Inhaltstyp \'[_1]\' (ID:[_2]) von Benutzer \'[_3]\' gelöscht',
	'Create new content type' => 'Neuen Inhaltstyp anlegen',

## lib/MT/CMS/Dashboard.pm
	'Error: This child site does not have a parent site.' => 'Fehler: Diese Untersite hat keine übergeordnete Site.',
	'Not configured' => 'Nicht konfiguriert',
	'Please contact your Movable Type system administrator.' => 'Bitte wenden Sie sich an Ihren Movable Type-Administrator.',
	'The support directory is not writable.' => 'Das Support-Verzeichnis ist nicht beschreibbar.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type kann auf den Ordner &#8222;support&#8220; nicht schreibend zugreifen. Legen Sie unter [_1] ein solches Verzeichnis an und stellen Sie sicher, daß der Webserver über Schreibrechte für diesen Ordner verfügt.',
	'ImageDriver is not configured.' => 'ImageDriver ist nicht konfiguriert.',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Auf Ihrem System ist keine Bildquelle vorhanden oder aber fehlerhaft konfiguiert. Eine Bildquelle ist zur korrekten Funktion der Benutzerbild-Funktionen erforderlich. Installieren Sie Image::Magick, NetPBM oder Imager und konfiguieren Sie die ImageDriver-Direktive entsprechend.',
	'The System Email Address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>' => 'Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw. Bitte bestätigen Sie Ihre <a href="[_1]>Einstellungen</a>.',
	'Cannot verify SSL certificate.' => 'SSL-Zertifikat kann nicht überprüft werden.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Bitte installieren Sie das Modul Mozilla::CA. Um diese Meldung zu unterdrücken, ergänzen Sie mt-config.cgi um die Zeile "SSLVerifyNone 1". Das wird allerdings nicht empfohlen.',
	'Can verify SSL certificate, but verification is disabled.' => 'SSL-Zertifikate können bestätigt werden, die Funktion ist aber deaktiviert.',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Sie sollten die Zeile "SSLVerifyNone 1" aus mt-config.cgi entfernen.',
	'System' => 'System',
	'Unknown Content Type' => 'Unbekannter Inhaltstypen',
	'Page Views' => 'Seitenaufrufe',

## lib/MT/CMS/Debug.pm

## lib/MT/CMS/Entry.pm
	'New Entry' => 'Neuer Eintrag',
	'New Page' => 'Neue Seite',
	'No such [_1].' => 'Kein [_1].',
	'This basename has already been used. You should use an unique basename.' => 'Basisname bereits verwendet. Bitte wählen Sie einen noch nicht verwendeten.',
	'Saving placement failed: [_1]' => 'Beim Speichern der Platzierung ist ein Fehler aufgetreten: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Datum &#8222;[_1]&#8220; ungültig. [_2]-Datumsangaben müssen im Format JJJJ-MM-TT HH:MM:SS vorliegen.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be earlier than the corresponding \'Unpublished on\' date \'[_2]\'.' => 'Datum &#8222;[_1]&#8220; ungültig. Das Datum der Veröffentlichung muss vor dem Zeitpunkt liegen, ab dem der Eintrag nicht mehr veröffentlicht werden soll (derzeit [_2]).',
	'authored on' => 'geschrieben am',
	'modified on' => 'bearbeitet am',
	'Saving entry \'[_1]\' failed: [_2]' => 'Der Eintrag &#8222;[_1]&#8220; konnte nicht gespeichert werden: [_2]',
	'Removing placement failed: [_1]' => 'Die Platzierung konnte nicht entfernt werden: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet und Status geändert von [_4] in [_5] von Benutzer &#8222;[_6]&#8220;',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet von Benutzer &#8222;[_4]&#8220;',
	'(user deleted - ID:[_1])' => '(Benutzer gelöscht - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost für [_2]</a> - Ziehen Sie dieses Bookmarklet in die Lesezeichenleiste Ihres Browsers. Klicken Sie darauf, wenn Sie sich auf einer Website befinden, über die Sie bloggen möchten.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) hinzugefügt von Benutzer &#8222;[_4]&#8220;',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '[_1] &#8222;[_2]&#8220; (ID:[_3]) gelöscht von &#8222;[_4]&#8220;',
	'Need a status to update entries' => 'Statusangabe erforderlich',
	'Need entries to update status' => 'Einträge erforderlich',
	'One of the entries ([_1]) did not exist' => 'Einer der Einträge ([_1]) existiert nicht.',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => 'Status von [_1] &#8222;[_2]&#8220; (ID:[_3]) von [_4] in [_5] geändert.',
	'/' => '/',

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Site-Einträge exportieren',
	'Please select a site.' => 'Bitte wählen Sie eine Site.',
	'Loading site \'[_1]\' failed: [_2]' => 'Laden der Seite \'[_1]\' fehlgeschlagen: [_2]',
	'You do not have export permissions' => 'Sie haben keine Berechtigung für die Exportfunktion',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: Label is required.' => 'Filter nicht gespeichert: Bezeichnung erforderlich',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Filter nicht gespeichert: Bezeichnung "[_1]" bereits in Verwendung.',
	'No such filter' => 'Kein entsprechender Filter vorhanden',
	'Permission denied' => 'Zugriff verweigert',
	'Failed to save filter: [_1]' => 'Filter nicht gespeichert: [_1]',
	'Failed to delete filter(s): [_1]' => 'Filter nicht gelöscht: [_1]',
	'Removed [_1] filters successfully.' => '[_1] Filter erfolgreich entfernt.',
	'[_1] ( created by [_2] )' => '[_1] (angelegt von [_2])',
	'(Legacy) ' => '(Altsystem)',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Der Ordner &#8222;[_1]&#8220; steht in Konflikt mit einem anderen Ordner. Ordner im gleichen Unterordner müssen unterschiedliche Basisnamen haben.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Ordner &#8222;[_1]&#8220; angelegt von &#8222;[_2]&#8220;',
	'Folder \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Ordner &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Ordner &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',

## lib/MT/CMS/Group.pm
	'Each group must have a name.' => 'Jede Gruppe muss einen eigenen Namen haben.',
	'Select Users' => 'Benutzer wählen',
	'Users Selected' => 'Gewählte Benutzer',
	'Search Users' => 'Benutzer suchen',
	'Select Groups' => 'Gruppen auswählen',
	'Group Name' => 'Gruppenname',
	'Groups Selected' => 'Gewählte Gruppen',
	'Search Groups' => 'Gruppen suchen',
	'Add Users to Groups' => 'Benutzer zu Gruppen hinzufügen',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Benutzer \'[_1]\' (ID:[_2]) von \'[_5]\' aus Gruppe \'[_3]\' (ID:[_4]) entfernt',
	'Group load failed: [_1]' => 'Fehler beim Laden einer Gruppe:',
	'User load failed: [_1]' => 'Fehler beim Laden eines Benutzers:',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Benutzer \'[_1]\' (ID:[_2]) von \'[_5]\' zu Gruppe \'[_3]\' (ID:[_4]) hinzugefügt',
	'Create Group' => 'Gruppe anlegen',
	'Author load failed: [_1]' => 'Fehler beim Laden eines Autoren: [_1]',

## lib/MT/CMS/Import.pm
	'Cannot load site #[_1].' => 'Konnte Site #[_1] nicht laden.',
	'Import Site Entries' => 'Site-Einträge importieren',
	'You do not have import permission' => 'Sie haben keine Berechtigung für die Importfunktion',
	'You do not have permission to create users' => 'Sie haben keine Berechtigung, neue Benutzerkonten anzulegen.',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'Bitte geben Sie ein Passwort an, um automatisch neue Benutzerkonten für alle Benutzer Ihrer Site anzulegen.',
	'Importer type [_1] was not found.' => 'Import-Typ [_1] nicht gefunden.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Jedes Feedback',
	'Publishing' => 'Veröffentliche',
	'System Activity Feed' => 'Systemaktivitäts-Feed',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Aktivitätsprotokoll von &#8222;[_1]&#8220; (ID:[_2]) on &#8222;[_3]&#8220; zurückgesetzt',
	'Activity log reset by \'[_1]\'' => 'Aktivitätsprotokoll zurückgesetzt von &#8222;[_1]&#8220;',

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Konnte Plugin-Einstellungen nicht speichern: [_1]',
	'Plugin Set: [_1]' => 'Plugin-Gruppe: [_1]',
	'Individual Plugins' => 'Individuelle Plugins',
	'Plugin' => 'Plugin',

## lib/MT/CMS/RebuildTrigger.pm
	'Select Site' => 'Site wählen',
	'Select Content Type' => 'Inhaltstyp wählen',
	'Create Rebuild Trigger' => 'Auslöser für Neuaufbau definieren',
	'Search Sites and Child Sites' => 'Sites und Untersites suchen',
	'Search Content Type' => 'Inhaltstyp suchen',
	'(All child sites in this site)' => '(Alle Untersites dieser Site)',
	'Select to apply this trigger to all child sites in this site.' => 'Diesen Auslöser für alle Untersites dieser Site verwenden.',
	'(All sites and child sites in this system)' => '(Alle Sites und Untersites im System)',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Diesen Auslöser für alle Sites und Untersites in diesem System verwenden.',
	'Entry or Page' => 'Eintrag oder Seite',
	'Comment' => 'Kommentar',
	'Trackback' => 'TrackBack',
	'saves an entry/page' => 'ein Eintrag/eine Seite gespeichert wird',
	'Entry/Page' => 'Eintrag/Seite',
	'Save' => 'OK',
	'publishes an entry/page' => 'ein Eintrag/eine Seite veröffentlicht wird',
	'unpublishes an entry/page' => 'ein Eintrag/eine Seite nicht mehr veröffentlicht wird',
	'Unpublish' => 'Nicht mehr veröffentlichen',
	'saves a content' => 'speichert einen Inhalt',
	'publishes a content' => 'veröffentlicht einen Inhalt',
	'unpublishes a content' => 'veröffentlicht einen Inhalt nicht mehr',
	'publishes a comment' => 'ein Kommentar veröffentlicht wird',
	'publishes a TrackBack' => 'ein TrackBack veröffentlicht wird',
	'TrackBack' => 'TrackBack',
	'rebuild indexes.' => 'Indizes neu aufbauen.',
	'rebuild indexes and send pings.' => 'Indizes neu aufbauen und Pings senden.',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Keine den Kriterien entsprechenden [_1] gefunden.',
	'Data Label' => 'Daten-Bezeichnung',
	'Title' => 'Titel',
	'Entry Body' => 'Eintragstext',
	'Extended Entry' => 'Erweiterter Eintrag',
	'Keywords' => 'Schlüsselwörter',
	'Excerpt' => 'Auszug',
	'Page Body' => 'Seitenkörper',
	'Extended Page' => 'Erweiterte Seite',
	'Template Name' => 'Vorlagenname',
	'Text' => 'Text',
	'Linked Filename' => 'Verlinkter Dateiname',
	'Output Filename' => 'Ausgabe-Dateiname',
	'IP Address' => 'IP-Adresse',
	'Log Message' => 'Eintrag',
	'Site URL' => 'Site-URL',
	'Site Root' => 'Wurzelverzeichnis',
	'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe',
	'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
	'replace_handler of [_1] field is invalid' => 'replace_handler des [_1]-Felds ungültig',
	'"[_1]" field is required.' => 'Feld "[_1]" erforderlich.',
	'ss_validator of [_1] field is invalid' => 'ss_validator des [_1]-Felds ungültig',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" ist für das "[_2]"-Feld von "[_3]" nicht gültig (ID:[_4]): [_5]',
	'Searched for: \'[_1]\' Replaced with: \'[_2]\'' => '\'[_1]\' durch \'[_2]\' ersetzt.',
	'[_1] \'[_2]\' (ID:[_3]) updated by user \'[_4]\' using Search & Replace.' => '[_1] \'[_2]\' (ID:[_3]) von Benutzer \'[_4]\' per Suchen und Ersetzen aktualisiert.',
	'Templates' => 'Vorlagen',

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Bitte geben Sie einen neuen Tag-Namen an.',
	'No such tag' => 'Kein solcher Tag',
	'The tag was successfully renamed' => 'Tag erfolgreich umbenannt.',
	'Error saving entry: [_1]' => 'Fehler beim Speichern des Eintrags: [_1]',
	'Successfully added [_1] tags for [_2] entries.' => '[_1] Tags erfolgreich zu [_2] Einträgen hinzugefügt.',
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
	'Unknown blog' => 'Unbekanntes Blog',
	'One or more errors were found in the included template module ([_1]).' => 'Das eingebundene Vorlagen-Modul enthält einen oder mehrere Fehler ([_1]).',
	'Global Template' => 'Globale Vorlage',
	'Invalid Blog' => 'Ungültiges Blog',
	'Global' => 'Global',
	'You must specify a template type when creating a template' => 'Bitte geben Sie den Typ der neuen Vorlage an.',
	'contnt type' => 'Inhaltstyp',
	'Content Type Archive' => 'Inhaltstyp-Archiv',
	'Create Widget' => 'Widget anlegen',
	'Create Template' => 'Vorlage anlegen',
	'No Name' => 'Kein Name',
	'Index Templates' => 'Index-Vorlagen',
	'Archive Templates' => 'Archiv-Vorlagen',
	'Content Type Templates' => 'Inhaltstyp-Vorlagen',
	'Template Modules' => 'Vorlagenmodule',
	'System Templates' => 'System-Vorlagen',
	'Email Templates' => 'E-Mail-Vorlagen',
	'Template Backups' => 'Vorlagen-Sicherungen',
	'Widget Template' => 'Widgetvorlage',
	'Widget Templates' => 'Widgetvorlagen',
	'Cannot locate host template to preview module/widget.' => 'Kann Host-Vorlage zur Vorschau auf Modul/Widget nicht finden.',
	'Cannot preview without a template map!' => 'Vorschau ohne Vorlagen-Verknüpfung nicht möglich.',
	'Preview' => 'Vorschau',
	'Unable to create preview file in this location: [_1]' => 'Kann Vorschaudatei in [_1] nicht erzeugen.',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LOREM_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'Beispiel, Eintrag, Vorschau',
	'Published Date' => 'Veröffentlichungs-Datum',
	'Cannot load templatemap' => 'Kann Vorlagenverknüpfungen nicht laden',
	'Saving map failed: [_1]' => 'Die Verknüpfungen konnte nicht gespeichert werden: [_1]',
	'You should not be able to enter zero (0) as the time.' => 'Null (0) ist keine gültige Zeitangabe.',
	'You must select at least one event checkbox.' => 'Markieren Sie bitte mindestens ein Ereignis-Auswahlfeld.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Vorlage &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Vorlage &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'Orphaned' => 'Verwaist',
	'Global Templates' => 'Globale Vorlagen',
	' (Backup from [_1])' => '(Sicherung von [_1])',
	'Error creating new template: ' => 'Fehler beim Anlegen der neuen Vorlage',
	'Setting up mappings failed: [_1]' => 'Die Verknüpfungen konnte nicht angelegt werden: [_1]',
	'Template Refresh' => 'Vorlagen zurücksetzen',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Überspringe Vorlage &#8222;[_1]&#8220;, da sie keine Standardvorlage zu sein scheint.',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Setze Vorlage <strong>[_3]</strong>zurück und erstelle dabei eine <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">Sicherung</a>.',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Überspringe Vorlage &#8222;[_1]&#8220;, da sie unverändert ist.',
	'Copy of [_1]' => 'Kopie von [_1]',
	'Cannot publish a global template.' => 'Kann eine globale Vorlage nicht veröffentlichen.',
	'Create Widget Set' => 'Widgetgruppe anlegen',
	'template' => 'Vorlage',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Thema nicht gefunden',
	'Failed to uninstall theme' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten',
	'Failed to uninstall theme: [_1]' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten: [_1]',
	'Theme from [_1]' => 'Thema von [_1]',
	'Install into themes directory' => 'In Themenverzeichnis installieren',
	'Download [_1] archive' => '[_1]-Archiv herunterladen',
	'Export Themes' => 'Themen exportieren',
	'Failed to load theme export template for [_1]: [_2]' => 'Beim Laden der Vorlage für den Themen-Export von [_1] ist ein Fehler aufgetreten: [_2]',
	'Failed to save theme export info: [_1]' => 'Beim Speichern der Export-Informationen ist ein Fehler aufgetreten: [_1]',
	'Themes directory [_1] is not writable.' => 'Das Themen-Verzeichis [_1] kann nicht beschrieben werden.',
	'All themes directories are not writable.' => 'Sämtliche Themen-Verzeichnisse können nicht beschrieben werden.',
	'Error occurred during exporting [_1]: [_2]' => 'Beim Export von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Beim Abschluss von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Bei der Veröffentlichung des Themas ist ein Fehler aufgetreten: [_1]',
	'Themes Directory [_1] is not writable.' => 'Das Themen-Verzeichis [_1] kann nicht beschrieben werden.',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Passwort anfordern',
	'Email address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'Invalid email address' => 'Ungültige E-Mail-Adresse',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Beim Mailversand ist ein Fehler aufgetreten ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, Ihr Passwort anzufordern.',
	'Password reset token not found' => 'Passwort Reset Token nicht gefunden',
	'Email address not found' => 'E-Mail-Adresse nicht gefunden',
	'User not found' => 'Benutzer nicht gefunden',
	'Your request to change your password has expired.' => 'Ihre Anfrage auf Änderung Ihres Passworts ist abgelaufen.',
	'Invalid password reset request' => 'Ungültige Anfrage zur Zurücksetzung des Passworts',
	'Please confirm your new password' => 'Bitte bestätigen Sie Ihr neues Passwort',
	'Passwords do not match' => 'Passwörter stimmen nicht überein.',
	'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) offenbar nicht implementiert!',
	'Error occurred while attempting to [_1]: [_2]' => 'Während [_1] ist ein Fehler aufgetreten: [_2]',
	'Please enter a valid email address.' => 'Bitte geben Sie eine gültige E-Mail-Adresse an.',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Bitte richten Sie zuerst die System-E-Mail-Adresse ein. Versuchen Sie dann erneut, die Testmail zu verschicken.',
	'Test email from Movable Type' => 'Testmail von Movable Type',
	'This is the test email sent by Movable Type.' => 'Das ist die Test-E-Mail, die Ihre Movable Type-Installation verschickt hat.',
	'Test e-mail was successfully sent to [_1]' => 'Testmail erfolgreich an [_1] versandt',
	'E-mail was not properly sent. [_1]' => 'Versand der Testmail fehlgeschlagen. [_1]',
	'Email address is [_1]' => 'Die E-Mail-Adresse lautet [_1]',
	'Debug mode is [_1]' => 'Debugging ist [_1]',
	'Performance logging is on' => 'Performance-Logging aktiviert',
	'Performance logging is off' => 'Performance-Logging deaktiviert',
	'Performance log path is [_1]' => 'Pfad der Performance-Logs: [_1]',
	'Performance log threshold is [_1]' => 'Schwellenwert für Performance-Logging: [_1]',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath ungültig. Die Pfadangabe muss gültig und absolut statt relativ.',
	'Prohibit comments is on' => 'Kommentare unterbinden ist aktiviert',
	'Prohibit comments is off' => 'Kommentare unterbinden ist deaktiviert',
	'Prohibit trackbacks is on' => 'Trackbacks unterbinden ist aktiviert',
	'Prohibit trackbacks is off' => 'Trackbacks unterbinden ist deaktiviert',
	'Prohibit notification pings is on' => 'Benachrichtigungs-Pings unterbinden ist aktiviert',
	'Prohibit notification pings is off' => 'Benachrichtigungs-Pings ist deaktiviert',
	'Outbound trackback limit is [_1]' => 'Ausgehende TrackBacks sind auf [_1] Stück limiert',
	'Any site' => 'Jede Site',
	'Only to blogs within this system' => 'Nur an Blogs in diesem System',
	'[_1] is [_2]' => '[_1] ist [_2]',
	'none' => 'Kein(e)',
	'Changing image quality is [_1]' => 'Anpassung der Bildqualität ist [_1]',
	'Image quality(JPEG) is [_1]' => 'Bildqualität (JPG) steht auf Stufe [_1]',
	'Image quality(PNG) is [_1]' => 'Bildqualität (PNG) steht auf Stufe [_1]',
	'System Settings Changes Took Place' => 'Es wurden Änderungen an den Systemeinstellungen vorgenommen.',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Versuch zur Passwortanforderung ungültig: Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid author_id' => 'Ungültige Autoren-ID',
	'Temporary directory needs to be writable for export to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss für den Exportvorgang beschreibbar sein. Bitte überprüfen Sie das Konfigurationsparameter TempDir.',
	'Temporary directory needs to be writable for import to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss für den Importvorgang beschreibbar sein. Bitte überprüfen Sie das Konfigurationsparameter TempDir.',
	'[_1] is not a number.' => '[_1] ist keine Zahl.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Die Datei [_1] konnte nicht nach [_2] kopiert werden: [_3]',
	'Specified file was not found.' => 'Angegebene Datei nicht gefunden.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] hat Exportdatei [_2] erfolgreich heruntergeladen',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be imported.' => 'Einige Asset-Dateien konnten nicht importiert werden.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Bitte verwenden Sie xml, tar.gz, zip, oder manifest als Dateierweiterung.',
	'Some objects were not imported because their parent objects were not imported.' => 'Einige Objekte wurden nicht importiert, weil deren Übergeordneten Objekte nicht importiert wurden.',
	'Detailed information is in the activity log.' => 'Details finden Sie im Aktivitätsprotokoll.',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] hat den gleichzeitigen Import mehrerer Dateien vorzeitig abgebrochen.',
	'Changing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Ändere Site-Pfad der Site \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Entferne Site-Pfad der Site \'[_1]\' (ID:[_2]...',
	'Changing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Ändere Archiv-Pfad der Site \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Entferne Archiv-Pfad der Site \'[_1]\' (ID:[_2])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Ändere Datei-Pfad für FileInfo-Eintrag (ID:[_1])...',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Ändere URL für FileInfo-Eintrag (ID:[_1])',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Ändere Pfad für Asset &#8222;[_1]&#8220; (ID:[_2])...',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'Die Manifest-Datei [_1] ist keine gültige Movable-Type-Exportdatei.',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'Die Exportdatei [_1] konnte nicht aus dem Dateisystem gelöscht werden: [_2]',
	'Some of the exported files could not be removed.' => 'Einige der exportierten Dateien konnten nicht entfernt werden.',
	'Please upload [_1] in this page.' => 'Bitte laden Sie [_1] in diese Seite hoch.',
	'File was not uploaded.' => 'Datei wurde nicht hochgeladen.',
	'Importing a file failed: ' => 'Importieren einer Datei fehlgeschlagen:',
	'Some of the files were not imported correctly.' => 'Einige Dateien wurden nicht fehlerfrei importiert.',
	'Successfully imported objects to Movable Type system by user \'[_1]\'' => 'Objekte von Benutzer \'[_1]\' erforderlich in das Movable-Type-System importiert',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ungültiger Versuch zur Passwortanforderung. Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Cannot recover password in this configuration' => 'Passwörter können in dieser Konfiguration nicht angefordert werden',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'Benutzer &#8222;[_1]&#8220; (#[_2]) hat keine E-Mail-Adresse',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Link zum Zurücksetzen des Passworts für Benutzer &#8222;[_1]&#8220; (#[_2]) an [_3] geschickt.',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Einige Objekte wurden nicht importiert, da ihre Übergeordneten Objekte nicht importiert wurden. Detaillierte Informationen finden Sie im Aktivitätsprotokoll.',
	'[_1] is not a directory.' => '[_1] ist kein Ordner.',
	'Error occurred during import process.' => 'Beim Importieren ist ein Fehler aufgetreten.',
	'Some of files could not be imported.' => 'Einige Dateien konnten nicht importiert werden',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'Die hochgeladene Datei ist keine gültige aus Movable Type exportierte Manifest-Datei',
	'Manifest file \'[_1]\' is too large. Please use import directory for importing.' => 'Die Manifest-Datei \'[_1]\' ist zu groß. Bitte lesen Sie sie über das das Import-Verzeichnis ein.',
	'Site(s) (ID:[_1]) was/were successfully exported by user \'[_2]\'' => 'Site(s) (ID:[_1]) erfolgreich von Benutzer \'[_2]\' exportiert.',
	'Movable Type system was successfully exported by user \'[_1]\'' => 'Movable-Type-System erfolgreich von Benutzer \'[_1]\' exportiert.',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Einige [_1] wurden nicht importiert, da ihre Übergeordneten Objekte nicht importiert wurden.',
	'Recipients for lockout notification' => 'Empfänger von Sperr-Benachrichtigungen',
	'User lockout limit' => 'Anzahl Versuche bis Kontosperrung',
	'User lockout interval' => 'Zeitraum bis Kontosperrung',
	'IP address lockout limit' => 'Anzahl Versuche bis IP-Sperrung',
	'IP address lockout interval' => 'Zeitraum bis IP-Sperrung',
	'Lockout IP address whitelist' => 'Diese IP-Adresse nie sperren',

## lib/MT/CMS/User.pm
	'For improved security, please change your password' => 'Bitte ändern Sie Ihr Passwort, um die Sicherheit zu erhöhen.',
	'Create User' => 'Benutzerkonto anlegen',
	'Cannot load role #[_1].' => 'Kann Rolle #[_1] nicht laden.',
	'Role name cannot be blank.' => 'Rollenname erforderlich.',
	'Another role already exists by that name.' => 'Es ist bereits eine Rolle mit diesem Namen vorhanden.',
	'You cannot define a role without permissions.' => 'Es können keine Rollen ohne Berechtigungen definiert werden.',
	'Invalid type' => 'Ungültiger Typ',
	'User \'[_1]\' (ID:[_2]) could not be re-enabled by \'[_3]\'' => 'Benutzerkonto \'[_1]\' (ID:[_2]) konnte nicht von \'[_3]\' reaktiviert werden ',
	'User Settings' => 'Benutzer-Einstellungen',
	'Invalid ID given for personal blog theme.' => 'Ungültige ID für Thema der persönlichen Blogs',
	'Invalid ID given for personal blog clone location ID.' => 'Ungültige ID für Klonvorlage der persönlichen Blogs',
	'Minimum password length must be an integer and greater than zero.' => 'Bitte geben Sie als Mindest-Passwortlänge eine ganze Zahl größer null an.',
	'Select a entry author' => 'Eintragsautor wählen',
	'Select a page author' => 'Seitenautor wählen',
	'Selected author' => 'Gewählter Autor',
	'Type a username to filter the choices below.' => 'Geben Sie einen Benutzernamen ein, um die Auswahl einzuschränken',
	'Select a System Administrator' => 'Systemadministrator wählen',
	'Selected System Administrator' => 'Gewählter Systemadministrator',
	'System Administrator' => 'Systemadministrator',
	'(newly created user)' => '(neu angelegter Benutzer)',
	'Sites Selected' => 'Gewählte Sites',
	'Select Roles' => 'Rollen wählen',
	'Roles Selected' => 'Gewählte Rollen',
	'Grant Permissions' => 'Berechtigungen zuweisen',
	'Select Groups And Users' => 'Gruppen und Benutzer wählen',
	'Groups/Users Selected' => 'Gewählte Gruppen/Benutzer',
	'You cannot delete your own association.' => 'Sie können nicht Ihre eigene Verknüpfung löschen.',
	'[_1]\'s Associations' => 'Verknüpfungen von [_1]',
	'You have no permission to delete the user [_1].' => 'Keine Berechtigung zum Löschen von Benutzer [_1].',
	'User requires username' => 'Benutzername erforderlich',
	'User requires display name' => 'Anzeigename erforderlich',
	'User requires password' => 'Passwort erforderlich',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Benutzer &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;',
	'represents a user who will be created afterwards' => 'steht für ein Benutzerkonto, das später angelegt werden wird',

## lib/MT/CMS/Website.pm
	'Create Site' => 'Site anlegen',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Website &#8222;[_1]&#8220; (ID: [_2]) gelöscht von &#8222;[_3]&#8220;',
	'Selected Site' => 'Gewählte Sites',
	'Type a website name to filter the choices below.' => 'Geben Sie einen Namen ein, um die Auswahl einzuschränken.',
	'This action cannot move a top-level site.' => 'Sites der obersten Ebene können mit dieser Aktion nicht verschoben werden.',
	'Type a site name to filter the choices below.' => 'Geben Sie einen Sitenamen ein, um die Auswahl einzuschränken.',
	'Cannot load website #[_1].' => 'Kann Website #[_1] nicht laden.',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_5]&#8220; von &#8222;[_3]&#8220; nach &#8222;[_4]&#8220; verschoben',

## lib/MT/Comment.pm
	'Loading entry \'[_1]\' failed: [_2]' => 'Eintrag &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',
	'Loading blog \'[_1]\' failed: [_2]' => 'Laden des Blogs &#8222;[_1]&#8220; fehlgeschlagen: [_2]',

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

## lib/MT/ContentData.pm
	'Invalid content type' => 'Ungültiger Inhaltstyp',
	'Saving content field index failed: [_1]' => 'Speichern des Inhaltsfeld-Index fehlgeschlagen: [_1]',
	'Removing content field indexes failed: [_1]' => 'Entfernen des Inhaltsfeld-Index fehlgeschlagen: [_1]',
	'Saving object asset failed: [_1]' => 'Speichern des Assets des Objekts fehlgeschlagen: [_1]',
	'Removing object assets failed: [_1]' => 'Entfernen des Assets des Objekts fehlgeschlagen: [_1]',
	'Saving object tag failed: [_1]' => 'Speichern des Tags des Objekts fehlgeschlagen: [_1]',
	'Removing object tags failed: [_1]' => 'Entfernen der Tags des Objekts fehlgeschlagen: [_1]',
	'Saving object category failed: [_1]' => 'Speichern der Kategorie des Objekts fehlgeschlagen: [_1]',
	'Removing object categories failed: [_1]' => 'Entfernen der Kategorien des Objekts fehlgeschlagen: [_1]',
	'record does not exist.' => 'Eintrag nicht vorhanden.',
	'Cannot load content field #[_1]' => 'Konnte Inhaltsfeld #[_1] nicht laden',
	'Publish Date' => 'Zeitpunkt der Veröffentlichung',
	'Unpublish Date' => 'Zeitpunkt der Zurückziehung',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] (ID: [_2]) nicht vorhanden.',
	'Contents by [_1]' => 'Inhalte von [_1]',
	'Tags fields' => 'Tag-Felder',
	'(No label)' => '(Keine Bezeichnung)',
	'Identifier' => 'Kennung',
	'Link' => 'Link',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Inhaltsfeld-Index',
	'Content Field Indexes' => 'Inhaltstyp-Indizes',

## lib/MT/ContentField.pm
	'Content Fields' => 'Inhaltsfelder',
	'Edit [_1] field' => '[_1]-Feld bearbeiten',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Zeige alle [_1]-Assets',
	'You must select or upload correct assets for field \'[_1]\' that has asset type \'[_2]\'.' => 'Bitte verwenden Sie für das Feld \'[_1]\' Assets vom Typ \'[_2]\'.',
	'A minimum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 0.' => 'Bitte geben Sie für die Mindestauswahl von \'[_1]\' ([_2]) eine ganze Zahl größer oder gleich 0 ein.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 1.' => 'Bitte geben Sie für die Höchstauswahl von \'[_1]\' ([_2]) eine ganze Zahl größer oder gleich 1 ein.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to the minimum selection number.' => 'Bitte geben Sie für die Höchstauswahl von \'[_1]\' ([_2]) eine ganze Zahl größer oder gleich der Mindestauswahl ein.',

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'Ungültige Kategorie-IDs [_1] in "[_2]"-Feld',
	'You must select a source category set.' => 'Bitte wählen Sie ein Quell-Kategorie-Set aus.',
	'The source category set is not found in this site.' => 'Das Quell-Kategorie-Set ist in dieser Site nicht vorhanden.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'Keine passenden Kategorie gefunden. Legen Sie einen Kategorie an, um Kategorie-Felder verwenden zu können.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'You must enter at least one label-value pair.' => 'Geben Sie mindestens ein Bezeichnung-Wert-Paar ein.',
	'A label for each value is required.' => 'Geben Sie jedem Wert eine Bezeichung.',
	'A value for each label is required.' => 'Geben Sie jeder Bezeichnung einen Wert.',

## lib/MT/ContentFieldType/Common.pm
	'is selected' => 'ist gewählt',
	'is not selected' => 'ist nicht gewählt',
	'In [_1] column, [_2] [_3]' => '[_2] [_3] in [_1]-Spalte',
	'Invalid [_1] in "[_2]" field.' => '[_1] im Feld "[_2]" ist ungültig.',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '[_1] im Feld "[_3]" muss kleiner oder gleich [_2] sein',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '[_1] im Feld "[_3]" muss größer oder gleich [_2] sein',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Im Feld "[_2]" kann nur genau ein [_1] gewählt werden.',
	'Invalid values in "[_1]" field: [_2]' => 'Ungültige Werte im Feld "[_1]": [_2]',
	'"[_1]" field value must be less than or equal to [_2].' => 'Wert des Felds "[_1]" muss kleiner oder gleich [_2] sein.',
	'"[_1]" field value must be greater than or equal to [_2]' => 'Wert des Felds "[_1]" muss größer oder gleich [_2] sein.',

## lib/MT/ContentFieldType/ContentType.pm
	'No Label (ID:[_1]' => 'Keine Bezeichnung (ID:[_1]',
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'Ungültige Inhaltsdaten-IDs im Feld "[_2]": [_1]',
	'You must select a source content type.' => 'Bitte wählen Sie einen Quell-Inhaltstyp.',
	'The source Content Type is not found in this site.' => 'Quell-Inhaltstyp in dieser Site nicht gefunden.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'Es stehen keine Inhaltstypen zur Auswahl. Bitte legen Sie zuerst einen neuen Inhaltstyp an, um Inhaltstyp-Felder zu verwenden.',

## lib/MT/ContentFieldType/Date.pm
	'Invalid date \'[_1]\'; An initial date value must be in the format YYYY-MM-DD.' => 'Ungültiges Datum \'[_1]\'. Bitte geben Sie das Ursprungsdatum im Format JJJJ-MM-TT an.',

## lib/MT/ContentFieldType/DateTime.pm
	'Invalid date \'[_1]\'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ungültiges Datum \'[_1]\'. Bitte geben Sie den Ursprungszeitpunkt im Format JJJJ-MM-TT HH:MM:SS an.',

## lib/MT/ContentFieldType/MultiLineText.pm

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value must be a number.' => 'Feld "[_1]" muss eine Zahl enthalten.',
	'"[_1]" field value has invalid precision.' => 'Feld "[_1]" hat eine unzulässige Anzahl Dezimalstellen.',
	'Number of decimal places must be a positive integer.' => 'Bitte geben Sie als Anzahl Dezimalstellen eine positive ganze Zahl ein.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'Bitte geben Sie als Anzahl Dezimalstellen eine positive ganze Zahl zwischen 0 und [_1] ein.',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Mindestwert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Mindestwert eine ganze Zahl zwischen [_1] und [_2] ein.',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Höchstwert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Höchstwert eine ganze Zahl zwischen [_1] und [_2] ein.',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Ursprungswert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'An initial value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Ursprungswert eine ganze Zahl zwischen [_1] und [_2] ein.',

## lib/MT/ContentFieldType.pm
	'Single Line Text' => 'Einzeiliger Text',
	'Multi Line Text' => 'Mehrzeiliger Text',
	'Number' => 'Zahl',
	'Date and Time' => 'Datum und Uhrzeit',
	'Date' => 'Datum',
	'Time' => 'Uhrzeit',
	'Select Box' => 'Auswahlkästchen',
	'Radio Button' => 'Radiobutton',
	'Checkboxes' => 'Checkboxen',
	'Audio Asset' => 'Audiodatei',
	'Video Asset' => 'Videodatei',
	'Image Asset' => 'Bilddatei',
	'Embedded Text' => 'Eingebetteter Text',
	'__LIST_FIELD_LABEL' => 'Liste', # Translate - New # OK
	'Table' => 'Tabelle',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Bitte geben Sie Bezeichner für die Werte ein.',
	'A value of values is required.' => 'Bitte geben Sie Werte für die Werte ein.',

## lib/MT/ContentFieldType/SelectBox.pm

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => 'Feld "[_1]" zu lang.',
	'"[_1]" field is too short.' => 'Feld "[_2] zu kurz.',
	'A minimum length number for \'[_1]\' ([_2]) must be a positive integer between 0 and [_3].' => 'Bitte geben Sie als Mindestlänge von \'[_1]\' ([_2]) eine ganze Zahl zwischen 0 und [_3] an.',
	'A maximum length number for \'[_1]\' ([_2]) must be a positive integer between 1 and [_3].' => 'Bitte geben Sie als Höchstlänge von \'[_1]\' ([_2]) eine ganze Zahl zwischen 0 und [_3] an.',
	'An initial value for \'[_1]\' ([_2]) must be shorter than [_3] characters' => 'Der Ursprungswert von \'[_1]\' ([_2]) muss kürzer als [_3] Zeichen sein.',

## lib/MT/ContentFieldType/Table.pm
	'Initial number of rows for \'[_1]\' ([_2]) must be a positive integer.' => 'Bitte geben Sie als ursprüngliche Anzahl Zeilen von \'[_1]\' ([_2]) eine positive ganze Zahl ein.',
	'Initial number of columns for \'[_1]\' ([_2]) must be a positive integer.' => 'Bitte geben Sie ursprüngliche Anzahl Spalten von \'[_1]\' ([_2]) eine positive ganze Zahl ein.',

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tags [_1] in "[_2]" field.' => 'Kann Tags [_1] nicht in Feld "[_2]" anlegen.',
	'Cannot create tag "[_1]": [_2]' => 'Kann Tag "[_1]" nicht anlegen: [_2]',
	'An initial value for \'[_1]\' ([_2]) must be an shorter than 255 characters' => 'Der Ursprungswert von \'[_1]\' ([_2]) muss kürzer als 255 Zeichen sein.',

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'Invalid time \'[_1]\'; An initial time value be in the format HH:MM:SS.' => 'Zeitangabe \'[_1]\' ungültig. Bitte geben Sie die Ursprungszeit im Format HH:MM:SS an.',

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'Ungültige URL im Feld "[_1]".',
	'An initial value for \'[_1]\' ([_2]) must be shorter than 2000 characters' => 'Der Ursprungswert von \'[_1]\' ([_2]) muss kürzer als 2000 Zeichen sein.',

## lib/MT/ContentPublisher.pm
	'Loading of blog \'[_1]\' failed: [_2]' => 'Blog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archivtyp &#8222;[_1]&#8220; wurde nicht ausgewählt',
	'Load of blog \'[_1]\' failed: [_2]' => 'Blog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]',
	'Parameter \'[_1]\' is required' => 'Parameter &#8222;[_1]&#8220; erforderlich',
	'Parameter \'[_1]\' is invalid' => 'Parameter &#8222;[_1]&#8220; ungültig',
	'Load of blog \'[_1]\' failed' => 'Blog \'[_1]\' konnte nicht geladen werden',
	'[_1] archive type requires [_2] parameter' => 'Für den Archivtyp [_1] ist das Parameter [_2] erforderlich.',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Fehler bei der Veröffentlichung von [_1] &#8222;[_2]&#8220;: [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Fehler bei Veröffentlichung des Archivs &#8222;[_1]&#8220;: [_2]',
	'Writing to \'[_1]\' failed: [_2]' => '&#8222;[_1]&#8220; konnte nicht beschrieben werden: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Temporäre Datei &#8222;[_1]&#8220; konnte nicht umbenannt werden: [_2]',
	'You did not set your blog publishing path' => 'Veröffentlichungspfade nicht gesetzt',
	'Cannot load catetory. (ID: [_1]' => 'Konnte Kategorie nicht laden. (ID: [_1])',
	'Scheduled publishing.' => 'Zeitgeplante Veröffentlichtung.',
	'An error occurred while publishing scheduled contents: [_1]' => 'Bei der zeitgeplanten Veröffentlichtung von Inhalten ist ein Fehler augetreten: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Bei der zeitgeplanten Zurückziehung von Inhalten ist ein Fehler aufgetreten: [_1]',

## lib/MT/ContentType.pm
	'Manage Content Data' => 'Inhaltsdaten verwalten',
	'Create Content Data' => 'Inhaltsdaten anlegen',
	'Publish Content Data' => 'Inhaltsdaten veröffentlichen',
	'Edit All Content Data' => 'Alle Inhaltsdaten bearbeiten',
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (Site: "[_2]" ID: [_3])',
	'Content Data # [_1] not found.' => 'Inhaltsdaten # [_1] nicht gefunden.',
	'Tags with [_1]' => 'Tags mit [_1]',
	'string(40)' => 'string(40)',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'Konnte keine eindeutige unique_id erzeugen',

## lib/MT/Core.pm
	'This is often \'localhost\'.' => 'Meistens \'localhost\'.',
	'The physical file path for your SQLite database. ' => 'Physischer Pfad zur SQLite-Datenbank',
	'[_1] in [_2]: [_3]' => '[_1] in [_2]: [_3]',
	'option is required' => 'Option erforderlich.',
	'Days must be a number.' => 'Tage müssen als Zahl angegeben werden.',
	'Invalid date.' => 'Ungültiges Datum',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] zwischen [_3] und [_4]',
	'[_1] [_2] since [_3]' => '[_1] [_2] seit',
	'[_1] [_2] or before [_3]' => '[_1] [_2] oder bevor [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] dieser [_3] Tage',
	'[_1] [_2] future' => '[_1] [_2] in der Zukunft',
	'[_1] [_2] past' => '[_1] [_2] zurück',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Title' => 'Kein Name',
	'(system)' => '(System)',
	'*Website/Blog deleted*' => 'Website/Blog gelöscht',
	'My [_1]' => 'Meine [_1]',
	'[_1] of this Site' => '[_1] dieser Site',
	'IP Banlist is disabled by system configuration.' => 'Die IP-Sperrliste ist systemweit deaktiviert.',
	'Address Book is disabled by system configuration.' => 'Das Adressbuch ist systemweit deaktiviert.',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Beim Anlegen des Leistungsprotrokolls-Ordners [_1] ist ein Fehler aufgetreten. Bitte vergeben Sie entweder Schreibrechte für das gewählte Verzeichnis oder geben Sie über das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; ein anderes an. [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: Das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; muss auf ein Verzeichnis, nicht auf eine Datei zeigen. [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: Das unter PerformanceLoggingPath angegebene Verzeichnis ist vorhanden, kann aber nicht beschrieben werden. [_1]',
	'MySQL Database (Recommended)' => 'MySQL-Datenbank (empfohlen)',
	'PostgreSQL Database' => 'PostgreSQL-Datenbank',
	'SQLite Database' => 'SQLite-Datenbank',
	'SQLite Database (v2)' => 'SQLite-Datenbank (v2)',
	'Database Server' => 'Hostname',
	'Database Name' => 'Datenbankname',
	'Password' => 'Passwort',
	'Database Path' => 'Datenbankpfad',
	'Database Port' => 'Port',
	'Database Socket' => 'Socket',
	'ID' => 'ID',
	'No label' => 'Keine Bezeichnung',
	'Date Created' => 'Angelegt',
	'Date Modified' => 'Bearbeitet',
	'Author Name' => 'Autorenname',
	'Tag' => 'Tag',
	'Legacy Quick Filter' => 'Schnellfilter (Altsystem)',
	'My Items' => 'Meine Elemente',
	'Log' => 'Log',
	'Activity Feed' => 'Aktivitäts-Feed',
	'Folder' => 'Ordner',
	'Member' => 'Mitglied',
	'Members' => 'Mitglieder',
	'Permission' => 'Berechtigung',
	'IP address' => 'IP-Adresse',
	'IP addresses' => 'IP-Adressen',
	'IP Banning Settings' => 'IP-Sperren-Einstellungen',
	'Contact' => 'Kontakt',
	'Manage Address Book' => 'Adressbuch verwalten',
	'Filter' => 'Zeigen',
	'Manage Content Type' => 'Inhaltstyp verwalten',
	'Manage Group Members' => 'Gruppenmitglieder verwalten',
	'Group Members' => 'Gruppenmitglieder',
	'Group Member' => 'Groupmember',
	'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
	'Rich Text' => 'Grafischer Editor',
	'Movable Type Default' => 'Movable Type-Standard',
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
	'Blog Name' => 'Name des Blogs',
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
	'Unpublish Past Entries' => 'Frühere Einträge nicht mehr veröffentlichen',
	'Publish Scheduled Contents' => 'Zeitgeplante Inhalte veröffentlichen',
	'Unpublish Past Contents' => 'Frühere Inhalte nicht mehr veröffentlichen',
	'Add Summary Watcher to queue' => 'Summary Watchers zur Warteschlange hinzufügen',
	'Junk Folder Expiration' => 'Junk-Ordner-Einstellungen',
	'Remove Temporary Files' => 'Temporäre Dateien löschen',
	'Purge Stale Session Records' => 'Abgelaufene Sessiondaten löschen ',
	'Purge Stale DataAPI Session Records' => 'Abgelaufene DataAPI-Sessiondaten löschen',
	'Remove expired lockout data' => 'Abgelaufene Sperrdaten löschen',
	'Purge Unused FileInfo Records' => 'Nicht verwendete FileInfo-Einträge löschen',
	'Remove Compiled Template Files' => 'Kompilierte Vorlagen-Dateien entfernen',
	'Manage Sites' => 'Sites verwalten',
	'Manage Website' => 'Website verwalten',
	'Manage Blog' => 'Blog verwalten',
	'Manage Website with Blogs' => 'Website mit Blogs verwalten',
	'Create Sites' => 'Sites anlegen',
	'Post Comments' => 'Kommentare schreiben',
	'Create Entries' => 'Neuer Eintrag',
	'Edit All Entries' => 'Alle Einträge bearbeiten',
	'Manage Assets' => 'Assets verwalten',
	'Manage Categories' => 'Kategorien verwalten',
	'Change Settings' => 'Einstellungen ändern',
	'Manage Tags' => 'Tags verwalten',
	'Manage Templates' => 'Vorlagen verwalten',
	'Manage Feedback' => 'Feedback verwalten',
	'Manage Content Types' => 'Inhaltstypen verwalten',
	'Manage Pages' => 'Seiten verwalten',
	'Manage Users' => 'Benutzer verwalten',
	'Manage Themes' => 'Themen verwalten',
	'Publish Entries' => 'Einträge veröffentlichen',
	'Send Notifications' => 'Benachrichtigungen versenden',
	'Set Publishing Paths' => 'Veröffentlichungspfade setzen',
	'View Activity Log' => 'Aktivitätsprotokoll ansehen',
	'Manage Category Set' => 'Kategorie-Set verwalten',
	'Upload File' => 'Datei hochladen',
	'Create Child Sites' => 'Untersite anlegen',
	'Manage Plugins' => 'Plugins verwalten',
	'View System Activity Log' => 'Systemaktivitätsprotokoll einsehen',
	'Sign In(CMS)' => 'Anmelden (CMS)',
	'Sign In(Data API)' => 'Anmelden (Data-API)',
	'Create Websites' => 'Website anlegen',
	'Manage Users & Groups' => 'Benutzer und Gruppen verwalten',

## lib/MT/DataAPI/Callback/Blog.pm
	'A parameter "[_1]" is required.' => 'Parameter "[_1]" erforderlich.',
	'The website root directory must be an absolute path: [_1]' => 'Das Wurzelverzeichnis der Website muss als absoluter Pfad angegeben werden: [_1]',
	'Invalid theme_id: [_1]' => 'Ungültige theme_id: [_1]',
	'Cannot apply website theme to blog: [_1]' => 'Kann Thema der Website nicht auf das Blog anwenden: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'The label \'[_1]\' is too long.' => 'Die Bezeichnung \'[_1]\' ist zu lang.',
	'Parent [_1] (ID:[_2]) not found.' => 'Eltern-[_1] nicht gefunden (ID:[_2])',

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => 'Der Name \'[_1]\' wird in der gleichen Site bereits verwendet.',

## lib/MT/DataAPI/Callback/ContentData.pm
	'There is an invalid field data: [_1]' => 'Ein Feld enthält ungültige Daten: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'Parameter "[_1]" ungültig: [_2]',
	'Invalid option key(s): [_1]' => 'Ungültige(r) Optionsschlüssel: [_1]',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler von Typ "[_1] ungültig.',
	'Invalid option(s): [_1]' => 'Ungültige Option(en): [_1]',

## lib/MT/DataAPI/Callback/ContentType.pm

## lib/MT/DataAPI/Callback/Entry.pm

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Parameter "[_1]" ist ungültig.',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'Ungültige author_id: [_1]',
	'Log (ID:[_1]) deleted by \'[_2]\'' => 'Log (ID:[_1]) gelöscht von \'[_2]\'',

## lib/MT/DataAPI/Callback/Role.pm

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Befehls-Name ungültig: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Archiv-Art ungültig: [_1]',

## lib/MT/DataAPI/Callback/Template.pm

## lib/MT/DataAPI/Callback/User.pm
	'Invalid language: [_1]' => 'Sprache ungültig: [_1]',
	'Invalid dateFormat: [_1]' => 'dateFormat ungültig: [_1]',
	'Invalid textFormat: [_1]' => 'textFormat ungültig: [_1]',

## lib/MT/DataAPI/Callback/Widget.pm

## lib/MT/DataAPI/Callback/WidgetSet.pm

## lib/MT/DataAPI/Endpoint/Auth.pm
	'Failed login attempt by user who does not have sign in permission via data api. \'[_1]\' (ID:[_2])' => 'Fehlgeschlagener Anmeldeversuch von Benutzer ohne Anmeldeberechtigung über Data-API. \'[_1]\' (ID:[_2])',
	'User \'[_1]\' (ID:[_2]) logged in successfully via data api.' => 'Benutzer \'[_1]\' (ID:[_2]) erfolgreich über Data-API angemeldet.',

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Ungültiges dateFrom-Parameter: [_1]',
	'Invalid dateTo parameter: [_1]' => 'Ungültiges dateTo-Parameter: [_1]',

## lib/MT/DataAPI/Endpoint/Entry.pm

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'The asset does not support generating a thumbnail file.' => 'Für dieses Asset kann kein Vorschaubild erzeugt werden.',
	'Invalid width: [_1]' => 'Breite ungültig: [_1]',
	'Invalid height: [_1]' => 'Höhe ungültig: [_1]',
	'Invalid scale: [_1]' => 'Maßstabl ungültig: [_1]',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Beim Backup ist ein Fehler aufgetreten: [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Sicherung beschreibbar sein. Bitte überprüfen Sie Ihre TempDir-Einstellung.',
	'Invalid backup_what: [_1]' => 'backup_what-Parameter ungültig: [_1]',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format-Parameter ungültig: [_1]',
	'Invalid limit_size: [_1]' => 'limit_size-Parameter ungültig: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie das Aktivitätsprotokoll.',
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Wiederherstellungen nicht erneut wiederhergestellt werden.',

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Unter Blog ID:[_1] konnte kein Blog angelegt werden.',
	'Either parameter of "url" or "subdomain" is required.' => 'Parameter "url" oder "subdomain" erforderlich.',
	'Site not found' => 'Site nicht gefunden',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Die Website "[_1] (ID:[_2]) enthält noch Blogs und wurde daher nicht gelöscht. Löschen Sie zuerst diese Blogs, um die Site löschen zu können.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'[_1] not found' => '[_1] nicht gefunden',
	'Loading object failed: [_1]' => 'Konnte Objekt nicht laden: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Bitte geben Sie ein "password"-Parameter an, wenn Sie neue Benutzerkonten für die im Blog gelisteten Benutzer anlegen möchten.',
	'Invalid import_type: [_1]' => 'import_type-Parameter ungültig: [_1]',
	'Invalid encoding: [_1]' => 'Zeichencodierung ungültig: [_1]',
	'Invalid convert_breaks: [_1]' => 'convert_breaks-Parameter ungültig: [_1]',
	'Invalid default_cat_id: [_1]' => 'default_cat_it-Parameter ungültig: [_1]',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden.',
	'A resource "[_1]" is required.' => 'Resource "[_1]" erforderlich.',
	'Could not found archive template for [_1].' => 'Archiv-Vorlage für [_1] nicht gefunden.',
	'Preview data not found.' => 'Vorschaudaten nicht gefunden.',

## lib/MT/DataAPI/Endpoint/v2/Folder.pm

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Das Anlegen der Gruppe ist fehlgeschlagen: ExternalGroupmanagement ist aktiv.',
	'Cannot add member to inactive group.' => 'Zu inaktiven Gruppen können keine Mitglieder hinzugefügt werden.',
	'Adding member to group failed: [_1]' => 'Hinzufügen des Mitglieds zur Gruppe ist fehlgeschlagen: [_1]',
	'Removing member from group failed: [_1]' => 'Entfernen des Mitglieds aus der Gruppe ist fehlgeschlagen: [_1]',
	'Group not found' => 'Gruppe nicht gefunden',
	'Member not found' => 'Mitglied nicht gefunden',
	'A resource "member" is required.' => '"member"-Angabe erforderlich.',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Protokolleintrag',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	'\'folder\' parameter is invalid.' => 'Das \'folder\'-Parameter ist ungültig.',

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Granting permission failed: [_1]' => 'Zuweisen der Berechtigung fehlgeschlagen: [_1]',
	'Role not found' => 'Rolle nicht gefunden',
	'Revoking permission failed: [_1]' => 'Entzug der Berechtigung fehlgeschlagen: [_1]',
	'Association not found' => 'Verknüpfung nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Role.pm

## lib/MT/DataAPI/Endpoint/v2/Search.pm

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Private Tags, die für systemweite Objekte verwendet werden, können nicht gelöscht werden.',
	'Cannot delete private tag in system scope.' => 'Private Tags im Systemkontext können nicht gelöscht werden.',
	'Tag not found' => 'Tag nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Vorlage "[_1]" ist keine Archiv-Vorlage.',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'Template not found' => 'Vorlage nicht gefunden',
	'Cannot delete [_1] template.' => 'Die [_1]-Vorlage konnte nicht gelöscht werden.',
	'Cannot publish [_1] template.' => 'Die [_1]-Vorlage konnte nicht veröffentlicht werden.',
	'A parameter "refresh_type" is invalid: [_1]' => 'Das "refresh_type"-Parameter ist ungültig: [_1]',
	'Cannot clone [_1] template.' => 'Die [_1]-Vorlage konnte nicht geklont werden.',
	'A resource "template" is required.' => '"Template"-Ressource erforderlich.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Cannot apply website theme to blog.' => 'Das Thema konnte nicht auf die Website angewendet werden.',
	'Changing site theme failed: [_1]' => 'Wechseln des Site-Themas fehlgeschlagen: [_1]',
	'Applying theme failed: [_1]' => 'Anwendung des Themas fehlgeschlagen: [_1]',
	'Cannot uninstall this theme.' => 'Das Thema konnte nicht deinstalliert werden.',
	'Cannot uninstall theme because the theme is in use.' => 'Das Thema konnte nicht deinstalliert werden, da es verwendet wird.',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_ids dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten und müssen mit einem Buchstaben beginnen.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_versions dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten.',
	'Cannot install new theme with existing (and protected) theme\'s basename: [_1]' => 'Das neue Thema kann nicht installiert werden, da der Basename bereits existiert und geschützt ist: [_1]',
	'Export theme folder already exists \'[_1]\'. You can overwrite an existing theme with \'overwrite_yes=1\' parameter, or change the Basename.' => 'Ein Export-Ordner \'[_1]\' existiert bereits. Sie können das vorhandene Thema überschreiben, indem sie das Parameter \'overwrite_yes=1\' verwenden, oder ändern Sie den Basisnamen.',
	'Unknown archiver type: [_1]' => 'Unbekannter Archivtyp: [_1]',

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'Die angegebene E-Mail-Adresse wird mehrfach verwendet. Geben Sie daher im Parameter "name" Ihren Benutzernamen an.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Es wurde eine E-Mail mit einem Link zum Zurücksetzen Ihres Passwortes an Ihre Adresse ([_1]) verschickt .',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Widget not found' => 'Widget nicht gefunden',
	'Removing Widget failed: [_1]' => 'Löschen des Widgets fehlgeschlagen: [_1]',
	'Widgetset not found' => 'Widgetgruppe nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => '"widgetset" erforderlich.',
	'Removing Widgetset failed: [_1]' => 'Löschen der Widgetgruppe fehlgeschlagen: [_1]',

## lib/MT/DataAPI/Endpoint/v3/Asset.pm

## lib/MT/DataAPI/Endpoint/v4/Category.pm

## lib/MT/DataAPI/Endpoint/v4/CategorySet.pm

## lib/MT/DataAPI/Endpoint/v4/ContentData.pm

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is required.' => 'Parameter "content_fileds" erforderlich.',
	'A parameter "content_fields" is invalid.' => 'Parameter "content_fields" ungültig.',

## lib/MT/DataAPI/Endpoint/v4/ContentType.pm

## lib/MT/DataAPI/Endpoint/v4/Search.pm

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kann "[_1]" nicht als ISO-8601-Zeitangabe lesen',

## lib/MT/DataAPI/Resource/v4/ContentData.pm

## lib/MT/DefaultTemplates.pm
	'Comment Form' => 'Kommentarformular',
	'Navigation' => 'Navigation',
	'Blog Index' => 'Blog-Index',
	'Search Results for Content Data' => 'Suchergebnis für Inhaltsdaten',
	'Archive Index' => 'Archiv-Index',
	'Stylesheet' => 'Stylesheet',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Feed - Aktuelle Einträge',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Einträge nach Monat',
	'Category Entry Listing' => 'Einträge nach Kategorie',
	'Dynamic Error' => 'Dynamische Fehlermeldungen',
	'Displays errors for dynamically-published templates.' => 'Zeigt Fehlermeldung von dynamisch erzeugten Vorlagen an.',
	'Popup Image' => 'Popup-Bild',
	'Displays image when user clicks a popup-linked image.' => 'Zeigt Bilder als Pop-Ups an, wenn auf ein Vorschaubild geklickt wird ',
	'Displays results of a search.' => 'Zeigt Suchergebnisse an',
	'About This Page' => 'Über diese Seite',
	'Archive Widgets Group' => 'Archiv-Widgetgruppe',
	'Current Author Monthly Archives' => 'Monatsarchiv des aktuellen Autors',
	'Calendar' => 'Kalendar',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Startseiten-Widgetgruppe',
	'Monthly Archives Dropdown' => 'Monatsarchiv (Dropdown)',
	'Page Listing' => 'Seitenübersicht',
	'Powered By' => 'Powered by',
	'Syndication' => 'Syndizierung',
	'Technorati Search' => 'Technorati-Suche',
	'Date-Based Author Archives' => 'Datumsbasiertes Autorenarchiv',
	'Date-Based Category Archives' => 'Datumsbasiertes Kategoriearchiv',
	'OpenID Accepted' => 'OpenID unterstützt',
	'Entry Notify' => 'Eintragsbenachrichtigung',
	'User Lockout' => 'Kontensperre',
	'IP Address Lockout' => 'IP-Sperre',

## lib/MT/Entry.pm
	'View [_1]' => '[_1] ansehen',
	'Entries from category: [_1]' => 'Einträge aus Kategorie [_1]',
	'NONE' => 'KEIN(E)',
	'Draft' => 'Entwurf',
	'Published' => 'Veröffentlicht',
	'Reviewing' => 'In Prüfung',
	'Scheduled' => 'Zu bestimmtem Zeitpunkt',
	'Junk' => 'Spam',
	'Unpublished (End)' => 'Unveröffentlicht (Ende)',
	'Entries by [_1]' => 'Einträge nach [_1]',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Ugültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Category-Objekte handeln.',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Ungültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Asset-Objekte handeln.',
	'Review' => 'Zur Überprüfung',
	'Future' => 'Künftig',
	'Spam' => 'Spam',
	'Accept Comments' => 'Kommentare annehmen',
	'Body' => 'Text',
	'Extended' => 'Erweiterter Text',
	'Format' => 'Format',
	'Accept Trackbacks' => 'TrackBacks annehmen',
	'Primary Category' => 'Hauptkategorie',
	'-' => '-',
	'Author ID' => 'ID des Autors',
	'My Entries' => 'Meine Einträge',
	'Entries in This Website' => 'Einträge auf dieser Website',
	'Published Entries' => 'Veröffentlichte Einträge',
	'Draft Entries' => 'Eintrags-Entwürfe',
	'Unpublished Entries' => 'Unveröffentlichte Einträge',
	'Scheduled Entries' => 'Zeitgeplante Einträge',

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

## lib/MT/Filter.pm
	'Invalid filter type [_1]:[_2]' => 'Dateityp [_1] ungültig: [_2]',
	'Invalid sort key [_1]:[_2]' => 'Sortierschlüssel [_1] ungültig: [_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_items" und "editable_filters" können nicht gleichzeitig verwendet werden.',
	'System Object' => 'Systemobjekt',

## lib/MT/Folder.pm

## lib/MT/Group.pm
	'Backing up [_1] records:' => 'Sichere [_1]-Einträge:',
	'[_1] records backed up.' => '[_1] Einträge gesichert',
	'Groups associated with author: [_1]' => 'Mit Autor verknüpfte Gruppen: [_1]',
	'Inactive' => 'Inaktiv',
	'Members of group: [_1]' => 'Gruppenmitglieder: [_1]',
	'__GROUP_MEMBER_COUNT' => 'Mitglieder',
	'My Groups' => 'Meine Gruppen',
	'__COMMENT_COUNT' => 'Kommentare',
	'Email' => 'E-Mail',
	'Active Groups' => 'Aktive Gruppen',
	'Disabled Groups' => 'Deaktivierte Gruppen',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'GD kann nicht geladen werden: [_1]',
	'Unsupported image file type: [_1]' => 'Nicht unterstütztes Bildformat: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Datei &#8222;[_1]&#8220; kann nicht gelesen werden: [_2]',
	'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'Drehen (um [_1] Grad) wird nicht unterstützt.',

## lib/MT/Image/ImageMagick.pm
	'Cannot load Image::Magick: [_1]' => 'Image::Magick kann nicht geladen werden: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Bei der Skalierung auf [_1]x[_2] ist ein Fehler aufgetreten: [_3]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Beim Beschnitt auf ein [_1]x[_2] großes Quadrat ab der Stelle [_3], [_4] ist ein Fehler aufgetreten: [_5]',
	'Flip horizontal failed: [_1]' => 'Horizontales Spiegeln fehlgeschlagen: [_1]',
	'Flip vertical failed: [_1]' => 'Vertikales Spiegeln fehlgeschlagen: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Drehen (um [_1] Grad) fehlgeschlagen: [_2]',
	'Converting image to [_1] failed: [_2]' => 'Bei der Konvertierung des Fotos in [_1] ist ein Fehler aufgetreten: [_2]',
	'Outputting image failed: [_1]' => 'Ausgabe des Bildes fehlgeschlagen: [_1]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Imager kann nicht geladen werden: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
	'Reading alpha channel of image failed: [_1]' => 'Der Alphakanal des Bildes konnte nicht eingelesen werden: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Beschneiden auf [_1]x[_2] fehlgeschlagen: [_3]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad zu den NetPBM-Tools gefunden.',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => 'Bildquelle [_1] ungültig',
	'Saving [_1] failed: Invalid image file format.' => 'Konnte [_1] nicht speichern: Dateiformat ungültig',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Maximale Dateigröße überschritten: [_1] > [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Kein Blog',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Sollen für die Benutzer Ihres Blogs neue Benutzerkonten angelegt werden, müssen Sie ein Passwort angeben.',
	'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
	'Creating new user (\'[_1]\')...' => 'Lege neuen Benutzer &#8222;[_1]&#8220; an...',
	'Saving user failed: [_1]' => 'Das Benutzerkonto konnte nicht gespeichert werden: [_1]',
	'Creating new category (\'[_1]\')...' => 'Lege neue Kategorie &#8222;[_1]&#8220; an...',
	'Saving category failed: [_1]' => 'Die Kategorie konnte nicht gespeichert werden: [_1]',
	'Invalid status value \'[_1]\'' => 'Ungültiger Status-Wert &#8222;[_1]&#8220;',
	'Invalid allow pings value \'[_1]\'' => 'Ungültiger Ping-Status &#8222;[_1]&#8220;',
	'Cannot find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Kann vorhandenen Eintrag mit Zeitstempel &#8222;[_1]&#8220; nicht finden; überspringe Kommentare und fahre mit nächstem Eintrag fort...',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importiere in vorhandenen Eintrag [_1] (\&#8222;[_2]&#8220;)',
	'Saving entry (\'[_1]\')...' => 'Speichere Eintrag &#8222;[_1]&#8220;...',
	'ok (ID [_1])' => 'OK (ID [_1])',
	'Saving entry failed: [_1]' => 'Der Eintrag konnte nicht gespeichert werden: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Exportvorgang bei Eintrag &#8222;[_1]&#8220; fehlgeschlagen: [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ungültiges Datumsformat &#8222;[_1]&#8220;; muss &#8222;MM/TT/JJJJ HH:MM:SS AM|PM&#8220; sein (AM|PM optional)',

## lib/MT/Import.pm
	'Cannot rewind' => 'Kann nicht zurückspulen',
	'Cannot open \'[_1]\': [_2]' => 'Kann &#8222;[_1]&#8220; nicht öffnen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Keine lesbaren Dateien im Import-Verzeichnis [_1] gefunden.',
	'Importing entries from file \'[_1]\'' => 'Importiere Einträge aus Datei &#8222;[_1]&#8220;',
	'File not found: [_1]' => 'Datei nicht gefunden: [_1]',
	'Could not resolve import format [_1]' => 'Kann Importformat [_1] nicht auflösen',
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

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'Konnte Listeneigenschaft [_1] nicht initialisieren.[_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Initialisierung der Listeneigenschaft [_1] fehlgeschlagen.[_2]: Keine Definition für Spalte [_3] gefunden.',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Initialisierung der Listeneigenschaft [_1] fehlgeschlagen.[_2]: Der Spaltentyp wird nicht unterstützt.',
	'[_1] (id:[_2])' => '[_1] (ID:[_2])', # Translate - Case # OK

## lib/MT/Lockout.pm
	'Cannot find author for id \'[_1]\'' => 'Kein Autor mit ID [_1] gefunden',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Benutzerkonto gesperrt. IP-Adresse: [_1], Benutzername: [_2]',
	'User Was Locked Out' => 'Benutzerkonto gesperrt',
	'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IP-Adresse gesperrt. IP-Adresse: [_1], Benutzername: [_2]',
	'IP Address Was Locked Out' => 'IP-Adresse gesperrt',
	'User has been unlocked. Username: [_1]' => 'Benutzerkonto entsperrt. Benutzername: [_1]',

## lib/MT/Log.pm
	'Log messages' => 'Protokolleinträge',
	'Security' => 'Sicherheit',
	'Warning' => 'Warnung',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sicherheit oder Fehler',
	'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
	'Not debug' => 'Kein Debug',
	'Debug/error' => 'Debug/Fehler',
	'Showing only ID: [_1]' => 'Zeige nur ID [_1]',
	'Page # [_1] not found.' => 'Seite #[_1] nicht gefunden.',
	'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
	'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
	'TrackBacks' => 'TrackBacks',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',
	'blog' => 'Blog',
	'website' => 'Website',
	'search' => 'suchen',
	'author' => 'Autor',
	'ping' => 'Ping',
	'theme' => 'Thema',
	'folder' => 'Ordner',
	'plugin' => 'Plugin',
	'page' => 'Seite',
	'Message' => 'Mitteilung',
	'By' => 'Von',
	'Class' => 'Typ',
	'Level' => 'Stufe',
	'Metadata' => 'Metadaten',
	'Logs on This Website' => 'Logs dieser Website',
	'Show only errors' => 'Nur Fehlermeldungen anzeigen',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Unbekannte MailTransfer-Methode &#8222;[_1]&#8220;',
	'Username and password is required for SMTP authentication.' => 'Zur SMTP-Authentifizierung sind Benutzername und Passwort erforderlich.',
	'Error connecting to SMTP server [_1]:[_2]' => 'Zum SMTP-Server [_1] konnte keine Verbindung aufgebaut werden: [_2]',
	'Authentication failure: [_1]' => 'Fehler bei der Authentifizierung: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Kein gültiger Sendmail-Pfad gefunden. Versuchen Sie stattdessen SMTP zu verwenden.',
	'Exec of sendmail failed: [_1]' => 'Sendmail konnte nicht ausgeführt werden: [_1]',
	'Following required module(s) were not found: ([_1])' => 'Diese erforderlichen Module fehlen: ([_1])',

## lib/MT/Notification.pm
	'Contacts' => 'Kontakte',
	'Click to edit contact' => 'Klicken, um Kontakt zu bearbeiten',
	'Save Changes' => 'Änderungen speichern',
	'Cancel' => 'Abbrechen',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Asset-Platzierung',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Kategorie-Platzierung',
	'Category Placements' => 'Kategorie-Platzierungen',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'Objektbewertung',
	'Object Scores' => 'Objektbewertungen',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Tag-Platzierung',
	'Tag Placements' => 'Tag-Platzierungen',

## lib/MT/Page.pm
	'Pages in folder: [_1]' => 'Seiten im Ordner [_1]',
	'Loading blog failed: [_1]' => 'Laden des Blogs fehlgeschlagen: [_1]',
	'(root)' => '(Wurzel)',
	'My Pages' => 'Meine Seiten',
	'Pages in This Website' => 'Seiten in dieser Website',
	'Published Pages' => 'Veröffentlichte Seiten',
	'Draft Pages' => 'Seiten-Entwürfe',
	'Unpublished Pages' => 'Unveröffentlichte Seiten',
	'Scheduled Pages' => 'Zeitgeplante Seiten',

## lib/MT/Permission.pm

## lib/MT/Placement.pm

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugin-Daten',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] aus Regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] aus Test [_4]',

## lib/MT/Plugin.pm
	'My Text Format' => 'Mein Textformat',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'Version [_1]',
	'https://www.movabletype.com/' => 'https://www.movabletype.com/',
	'Hello, world' => 'Hallo Welt',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Message: [_1]' => 'Nachricht: [_1]',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Falls vorhanden, muss das dritte Argument von add_callback ein MT::Component- oder MT::Plugin-Objekt sein.',
	'Fourth argument to add_callback must be a CODE reference.' => 'Das vierte Argument von add_callback muss eine CODE-Referenz sein.',
	'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins',
	'Invalid priority level [_1] at add_callback' => 'Ungültiger Prioritätslevel [_1] von add_callback',
	'Internal callback' => 'Interner Callback',
	'Unnamed plugin' => 'Plugin ohne Namen',
	'[_1] died with: [_2]' => '[_1] abgebrochen mit [_2]',
	'Bad LocalLib config ([_1]): [_2]' => 'Fehlerhafte LocalLib-Einstellungen ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen',
	'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Keine Konfigurationsdatei gefunden. Haben Sie möglicheweise vergessen, mt-config.cgi-original in mt-config.cgi umzubennen?',
	'Plugin error: [_1] [_2]' => 'Plugin-Fehler: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden.',
	'Error while creating email: [_1]' => 'Fehler beim Anlegen einer E-Mail: [_1]',
	'An error occurred: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
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

## lib/MT/RebuildTrigger.pm
	'Restoring rebuild trigger for blog #[_1]...' => 'Stelle Neuaufbau-Auslöser für Blog #[_1] wieder her...',
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Stelle Neuaufbau-Auslöser für Inhaltstyp #[_1] wieder her...',

## lib/MT/Revisable/Local.pm

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Fehlerhaftes RevisioningDriver-Parameter &#8222;[_1]&#8220;: [_2]',
	'Revision not found: [_1]' => 'Revision nicht gefunden: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Objektarten stimmen nicht überein, erwarte zwei [_1]',
	'Did not get two [_1]' => 'Nicht zwei [_1] erhalten',
	'Unknown method [_1]' => 'Unbekannte Methode [_1]',
	'Revision Number' => 'Revisionsnummer',

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => 'Aktiv',
	'__ROLE_INACTIVE' => 'Inaktiv',
	'Site Administrator' => 'Site-Administrator',
	'Can administer the site.' => 'Kann die Site verwalten.',
	'Editor' => 'Editor',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kann Dateien hochladen, alle Einträge, Seiten, Kategorien, Ordner und Tags bearbeiten und die Site veröffentlichen.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und Dateien hochladen und veröffentlichen.',
	'Designer' => 'Designer',
	'Can edit, manage, and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish site/child site templates.' => 'Kann Seite verwalten, Dateien hochladen und Vorlagen von Sites und Untersites veröffentlichen.',
	'Contributor' => 'Gastautor',
	'Can create entries, edit their own entries, and comment.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und kommentieren.',
	'Content Designer' => 'Content-Designer',
	'Can manage content types, content data and category sets.' => 'Kann Inhaltstyp, Inhaltsdaten und Kategorie-Set verwalten.',
	'__ROLE_STATUS' => 'Status',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Objekt muss zuerst gespeichert werden.',
	'Already scored for this object.' => 'Bewertung für dieses Objekt bereits abgegeben.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Konnte Bewertung für Objekt &#8222;[_1]&#8220; (ID: [_2]) nicht speichern.',

## lib/MT/Session.pm
	'Session' => 'Sitzung',

## lib/MT/Tag.pm
	'Private' => 'Privat',
	'Not Private' => 'Nicht privat',
	'Tag must have a valid name' => 'Tags müssen gültige Namen haben',
	'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.',
	'Tags with Entries' => 'Tags mit Einträgen',
	'Tags with Pages' => 'Tags mit Seiten',
	'Tags with Assets' => 'Tags mit Assets',

## lib/MT/TaskMgr.pm
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Konnte Lock zur Ausführung der Systemtasks nicht setzen. Stellen Sie sicher, daß das TempDir [_1] beschrieben werden kann.',
	'Error during task \'[_1]\': [_2]' => 'Fehler bei Ausführung des Tasks &#8222;[_1]&#8220;: [_2]',
	'Scheduled Tasks Update' => 'Aktualisierung geplanter Aufgaben',
	'The following tasks were run:' => 'Folgende Tasks wurden ausgeführt:',

## lib/MT/TBPing.pm

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Alles über mich',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Veröffentlichen[_2] Sie Ihre(n) [_3], um die Änderungen wirksam werden zu lassen.',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Veröffentlichen[_2] Sie Ihre Site, um die Änderungen wirksam werden zu lassen.',
	'Actions' => 'Aktionen',
	'The entered message is displayed as a input field hint.' => 'Dieser Text wird als Hinweis für das Eingabefeld angezeigt.',
	'Is this field required?' => 'Ist dieses Feld erforderlich?',
	'Display Options' => 'Anzeigeoptionen',
	'Choose the display options for this content field in the listing screen.' => 'Wählen Sie, wie dieses Inhaltsfeld in der Listenansicht angezeigt werden soll',
	'Force' => 'Erzwingen',
	'Default' => 'Standardwert',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Vorlagenbefehl ohne Datumskontext verwendet.',
	'Division by zero.' => 'Teilung durch Null.',
	'[_1] is not a hash.' => '[_1] ist kein Hash-Wert.',
	'blog(s)' => 'Blog(s)',
	'website(s)' => 'Website(s)',
	'No [_1] could be found.' => 'Keine [_1] gefunden.',
	'records' => 'Einträge',
	'id attribute is required' => 'Attribut "id" erforderlich.',
	'No template to include was specified' => 'Keine einzubindende Vorlage angegeben',
	'Recursion attempt on [_1]: [_2]' => 'Rekursionsversuch bei [_1]: [_2]',
	'Cannot find included template [_1] \'[_2]\'' => 'Kann verwendete Vorlage [_1] &#8222;[_1]&#8220; nicht finden',
	'Error in [_1] [_2]: [_3]' => 'Fehler in [_1] [_2]: [_3]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'Das Einbinden von Dateien wurde über das Konfigurationsparameter AllowFileInclude deaktiviert.',
	'Cannot find blog for id \'[_1]' => 'Kann Blog zu ID &#8222;[_1]&#8220; nicht finden',
	'Cannot find included file \'[_1]\'' => 'Kann verwendete Datei &#8222;[_1]&#8220; nicht finden',
	'Error opening included file \'[_1]\': [_2]' => 'Fehler beim Öffnen der verwendeten Datei &#8222;[_1]&#8220;: [_2]',
	'Recursion attempt on file: [_1]' => 'Rekursionsversuch bei Datei [_1]',
	'Cannot load user.' => 'Kann Benutzerkonto nicht laden.',
	'Cannot find template \'[_1]\'' => 'Kann Vorlage &#8222;[_1]&#8220; nicht finden',
	'Cannot find entry \'[_1]\'' => 'Kann Eintrag &#8222;[_1]&#8220; nicht finden',
	'Unspecified archive template' => 'Nicht spezifizierte Archiv-Vorlage',
	'Error in file template: [_1]' => 'Fehler in Dateivorlage: [_1]',
	'Cannot load template' => 'Kann Vorlage nicht laden',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => '&#8222;[_1]&#8220; ist kein gültiger Wert für ein exclude_blogs-Attribut',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wenn die gleichen Blog-ID gleichzeitig in den include_blogs- und exclude_blogs-Attributen eines mt:Entries-Befehls verwendet werden, werden die entsprechenden Blogs ausgeschlossen.',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => 'Sie haben einen &#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Autoren-Kontexts verwendet - &#8222;MTAuthors&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Eintrags-Kontexts verwendet - &#8222;MTEntries&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Website-Kontexts verwendet - &#8222;MTWebsite&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?' => '&#8222;[_1]&#8220;-Vorlagenbefehl in einem Blog ohne zugehörige Website verwendet - möglicherweise ist die Blog-Zuordnung fehlerhaft',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Blog-Kontexts verwendet - &#8222;MTBlogs&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of the site;' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb des Site-Kontexts verwendet;', # Translate - New # OK
	'You used an \'[_1]\' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an \'MTComments\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Kommentar-Kontexts verwendet - &#8222;MTComments&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an \'MTPings\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Ping-Kontextes verwendet - &#8222;MTPings&#8220;-Container erforderlich.',
	'You used an \'[_1]\' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an \'MTAssets\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Asset-Kontexts verwendet - &#8222;MTAssets&#8220;-Container erforderlich',
	'You used an \'[_1]\' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a \'MTPages\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Seiten-Kontexts verwendet - &#8222;MTPages&#8220;-Containers erforderlich',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Archiv-Verknüpfung',
	'Archive Mappings' => 'Archiv-Verknüpfungen',

## lib/MT/Template.pm
	'Template' => 'Vorlage',
	'Template load error: [_1]' => 'Fehler beim Laden der Vorlage: [_1]',
	'Tried to load the template file from outside of the include path \'[_1]\'' => 'Das System hat versucht, die Vorlagendatei von außerhalb des Include-Pfads &#8222;[_1]&#8220; zu lesen',
	'Error reading file \'[_1]\': [_2]' => 'Fehler beim Einlesen der Datei &#8222;[_1]&#8220;: [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Veröffentlichungsfehler in Vorlage &#8222;[_1]&#8220;: [_2]',
	'Content Type is required.' => 'Inhaltstyp erforderlich.',
	'Template name must be unique within this [_1].' => 'Vorlagennamen dürfen innerhalb des/der [_1] nicht doppelt vorkommen.',
	'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Die verlinkte Datei &#8222;[_1]&#8220; konnte nicht geöffnet werden: [_2]',
	'Index' => 'Index',
	'Category Archive' => 'Kategoriearchiv',
	'Comment Listing' => 'Liste der Kommentare',
	'Ping Listing' => 'Liste der Pings',
	'Comment Preview' => 'Kommentarvorschau',
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
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Sie haben mit einem [_1]-Vorlagenbefehl &#8222;[_2]&#8220;-Archivseiten verlinkt, ohne diese bereits angelegt zu haben.',
	'You used an [_1] tag outside of the proper context.' => 'Sie haben einen [_1]-Vorlagenbefehl außerhalb seines Kontexts verwendet.',
	'Could not determine entry' => 'Konnte Eintrag nicht bestimmen',
	'Could not determine content' => 'Konnte Inhalt nicht bestimmen',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'Sort_by="score" erfordert einen Namespace.',
	'No such user \'[_1]\'' => 'Kein Benutzer &#8222;[_1]&#8220;',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Fehler im &#8222;[_2]&#8220;-Attribut: [_1]',
	'[_1] must be a number.' => '[_1] muss eine Zahl sein.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'Das Attribut &#8222;[_2]&#8220; erfordert einen Integer: [_1]',
	'You used an [_1] without a author context set up.' => '[_1] ohne vorhandenen Autorenkontext verwendet.',

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Ungültiges "mode"-Attribut [_1]. Gültige Werte sind "loop" und "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'week_starts_with in ungültigem Format angegeben. Verwenden Sie einen dieser Ausdrücke: Mon|Tue|Wed|Thu|Fri|Sat|Sun',
	'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: JJJJMM erforderlich',
	'No such category \'[_1]\'' => 'Keine Kategorie &#8222;[_1]&#8220;',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] muss in einem [_2]-Kontext stehen',
	'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fehler beim Sortieren von [_2]: [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => '"sorty_by" und "sort_method" können nicht gemeinsam in [_1] verwendet werden.',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] kann nur zusammen mit veröffentlichem [_2]-Archiv verwendet werden.',
	'[_1] used outside of [_2]' => '[_1] außerhalb [_2] verwendet',

## lib/MT/Template/Tags/ContentType.pm
	'Invalid tag_handler of [_1].' => 'tag_handler von [_1] ungültig.',
	'Invalid field_value_handler of [_1].' => 'field_value_handler von [_1] ungültig.',
	'Content Type was not found. Blog ID: [_1]' => 'Inhaltstyp nicht gefunden. Blog-ID: [_1]',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',
	'Could not create atom id for entry [_1]' => 'Konnte keine Atom-ID für Eintrag [_1] erzeugen',

## lib/MT/Template/Tags/Misc.pm
	'Specified WidgetSet \'[_1]\' not found.' => 'Angegebene Widgetgruppe &#8222;[_1]&#8220; nicht gefunden.',

## lib/MT/Template/Tags/Tag.pm

## lib/MT/Template/Tags/Website.pm

## lib/MT/Theme/Category.pm
	'Failed to save category_order: [_1]' => 'Speichern von category_order fehlgeschlagen: [_1]',
	'Failed to save folder_order: [_1]' => 'Speichern von folder_order fehlgeschlagen: [_1]',
	'[_1] top level and [_2] sub categories.' => '[_1] Haupt- und [_2] Unterkategorien',
	'[_1] top level and [_2] sub folders.' => '[_1] Haupt- und [_2] Unterordner',

## lib/MT/Theme/CategorySet.pm
	'[_1] category sets.' => '[_1] Kategorie-Sets.',

## lib/MT/Theme/ContentData.pm
	'Failed to find content type: [_1]' => 'Inhaltstyp nicht gefunden: [_1]',
	'Invalid theme_data_import_handler of [_1].' => 'theme_data_import_handler von [_1] ungültig.',
	'[_1] content data.' => '[_1]-Inhaltsdaten',

## lib/MT/Theme/ContentType.pm
	'Invalid theme_import_handler of [_1].' => 'theme_import_handler von [_1] ungültig.',
	'[_1] content types.' => '[_1] Inhaltstypen',
	'some content field in this theme has invalid type.' => 'Der Typ einiger Inhaltsfelder in diesem Thema ist ungültig. ',
	'some content type in this theme have been installed already.' => 'Inhaltstyp in diesem Thema bereits installiert.',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Komponente &#8222;[_1]&#8220; nicht gefunden.',
	'Internal error: the importer is not found.' => 'Interner Fehler: Importmodul nicht gefunden.',
	'Compatibility error occurred while applying \'[_1]\': [_2].' => 'Bei der Anwendung von \'[_1]\' ist ein Kompatibilitäts-Fehler aufgetreten: [_2]',
	'An Error occurred while applying \'[_1]\': [_2].' => 'Bei der Anwendung von \'[_1]\' ist ein Fehler aufgetreten: [_2]',
	'Fatal error occurred while applying \'[_1]\': [_2].' => 'Bei der Anwendung von \'[_1]\' ist ein kritischer Fehler aufgetreten: [_2]',
	'Importer for \'[_1]\' is too old.' => 'Das Importmodul für &#8222;[_1]&#8220; ist zu alt.',
	'Theme element \'[_1]\' is too old for this environment.' => 'Das Element &#8222;[_1]&#8220; des verwendeten Themas ist veraltet und kann hier nicht eingesetzt werden.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] Seiten',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Laden des Themas fehlgeschlagen: [_1]',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein kritischer Fehler aufgetreten: [_2]',
	'An error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein Fehler aufgetreten: [_2]',
	'Failed to copy file [_1]:[_2]' => 'Kopieren der Datei [_1] fehlgeschlagen: [_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, aber nicht installiert. ',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, installiert ist aber Version [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'Element &#8222;[_1]&#8220; konnte nicht angewendet werden da [_2]',
	'There was an error scaling image [_1].' => 'Bei der Skalierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	'There was an error converting image [_1].' => 'Bei der Konvertierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	'There was an error creating thumbnail file [_1].' => 'Bei der Erstellung des Vorschaubildes [_1] ist ein Fehler aufgetreten.',
	'Default Prefs' => 'Standard-Voreinstellungen',
	'Default Pages' => 'Standard-Seiten',
	'Template Set' => 'Vorlagengruppe',
	'Default Content Data' => 'Ursprungs-Inhaltsdaten',
	'Static Files' => 'Statische Dateien',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'Dieses Element kann nicht auf Nicht-Blog-Elemente angewendet werden.',
	'Failed to save blog object: [_1]' => 'Konnte Blog-Objekt nicht speichern: [_1]',
	'default settings for [_1]' => 'Standard-Einstellungen für [_1]',
	'default settings' => 'Standard-Einstellungen',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Vorlagengruppe mit [quant,_1,Vorlage,Vorlagen], [quant,_2,Widget,Widgets] und [quant,_3,Widget-Gruppe, Widget-Gruppen].',
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
	'Upgrading asset path information...' => 'Aktualisiere Pfadangaben von Assets...',
	'Creating initial user records...' => 'Lege Ausgangs-Benutzerdatensätze an...',
	'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
	'Error creating role record: [_1].' => 'Fehler bei der Erstellung eine Rollen-Eintrags: [_1]. ',
	'Creating new template: \'[_1]\'.' => 'Erzeuge neue Vorlage: &#8222;[_1]&#8220;',
	'Mapping templates to blog archive types...' => 'Verknüpfe Vorlagen mit Archiv...',
	'Expiring cached MT News widget...' => 'Verwerfe gecachte MT-News-Widgets...',
	'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1]',
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
	'Error saving [_1] record # [_3]: [_2]...' => 'Fehler beim Speichern von [_1]-Eintrag #[_3]: [_2]...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Verknüpfe Vorlagen...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Vorlage [_1] mit [_2] ([_3])',
	'Mapping template ID [_1] to [_2].' => 'Verknüpfe Vorlage [_1] mit [_2]',
	'Creating entry category placements...' => 'Lege Kategoriezuweisungen an...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Aktualisiere Kategoriezuweisungen...',
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
	'Confirmation...' => 'Bestätigung',
	'Your comment has been posted!' => 'Ihr Kommentar wurde veröffentlicht!',
	'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar.',
	'Your comment has been received and held for review by a blog administrator.' => 'Ihr Kommentar wurde abgeschickt. Er erscheint, sobald der Administrator des Blogs ihn freigeschaltet hat.',
	'Comment Submission Error' => 'Beim Abschicken des Kommentars ist ein Fehler aufgetreten',
	'Your comment submission failed for the following reasons:' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">Zurück zum Eintrag</a>',
	'Migrating permission records to new structure...' => 'Migriere Benutzerrechte in neue Struktur...',
	'Migrating role records to new structure...' => 'Migriere Rollen in neue Struktur...',
	'Migrating system level permissions to new structure...' => 'Migriere Systemberechtigungen in neue Struktur...',
	'Updating system search template records...' => 'Aktualisiere Suchvorlagen...',
	'Renaming PHP plugin file names...' => 'Ändere PHP-Plugin-Dateinamen...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fehler beim Umbenennen von PHP-Datei. Bitte überprüfen Sie das Aktivitätsprotokoll.',
	'Cannot rename in [_1]: [_2].' => 'Kann nicht in [_1] umbenennen: [_2]',
	'Migrating Nofollow plugin settings...' => 'Migriere Nofollow-Einstellungen...',
	'Comment Response' => 'Kommentar-Antworten',
	'Removing unnecessary indexes...' => 'Entferne nicht verwendete Indizes...',
	'Moving metadata storage for categories...' => 'Verschiebe Metadatenspeicher für Kategorien...',
	'Upgrading metadata storage for [_1]' => 'Aktualisiere Metadatenspeicher für [_1]',
	'Assigning entry comment and TrackBack counts...' => 'Weise Kommentar- und TrackBack-Zahlen zu...',
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
	'Website Administrator' => 'Website-Administrator',
	'Can administer the website.' => 'Kann die Website verwalten',
	'Can manage pages, Upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Designer (MT4)' => 'Designer (MT4)',
	'Populating new role for theme...' => 'Populiere neue Rolle für Thema...',
	'Can edit, manage and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Assigning new system privilege for system administrator...' => 'Weise neues System-Privileg an Systemadministrator zu...',
	'Assigning to  [_1]...' => 'Weise an [_1] zu...',
	'Migrating mtview.php to MT5 style...' => 'Migriere mtview.php zur MT5-Fassung...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migriere DefaultSiteURL/DefaultSiteRoot zur Website...',
	'New user\'s website' => 'Website neuer Benutzer',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migriere vorhandene [quant,_1,Blog,Blogs] in Websites und Kinder...',
	'Error loading role: [_1].' => 'Fehler beim Laden einer Rolle: [_1]',
	'New WebSite [_1]' => 'Neue Website [_1]',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Beim Anlegen einer Website während des Upgrades ist ein Fehler aufgetreten: [_1]',
	'Generated a website [_1]' => 'Website [_1] angelegt',
	'An error occurred during migrating a blog\'s site_url: [_1]' => 'Beim Migrieren der site_url eines Blogs ist ein Fehler aufgetreten: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Blog [_1] ([_2]) in Website [_3] verschoben',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Entferne Technorati-Ping-Dienst von [_1] (ID: [_2]).',
	'Recovering type of author...' => 'Stelle Autorentypen wieder her...',
	'Classifying blogs...' => 'Klassifiziere Blogs...',
	'Rebuilding permissions...' => 'Baue Berechtigungen neu auf...',
	'Assigning ID of author for entries...' => 'Weise Autoren-IDs zu Eintragen zu...',
	'Removing widget from dashboard...' => 'Entferne Widget aus Übersichtsseite...',
	'Ordering Categories and Folders of Blogs...' => 'Sortiere Ordner und Kategorien der Blogs...',
	'Ordering Folders of Websites...' => 'Sortiere Ordner der Websites...',
	'Setting the \'created by\' ID for any user for whom this field is not defined...' => 'Setze \'created by\'-ID für Benutzerkonten ohne diese Angabe...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Setze Sprache für alle Blogs zur Verbesserung der Datumsanzeige...',
	'Adding notification dashboard widget...' => 'Füge Benachrichtungs-Widget zu Dashboard hinzu...',

## lib/MT/Upgrade/v6.pm
	'Fixing TheSchwartz::Error table...' => 'Repariere TheSchwartz::Error-Tabelle...',
	'Migrating current blog to a website...' => 'Migriere aktuelles Blog auf Website...',
	'Migrating the record for recently accessed blogs...' => 'Migriere Aufzeichnung der kürzlich aufgerufenen Blogs....',
	'Adding Website Administrator role...' => 'Füge Website-Administratoren-Rolle hinzu...',
	'Adding "Site stats" dashboard widget...' => 'Füge Site-Statistik-Widget hinzu...',
	'Reordering dashboard widgets...' => 'Ordne Dashboard-Widgets neu an...',
	'Rebuilding permission records...' => 'Baue Berechtigungs-Datensätze neu auf...',

## lib/MT/Upgrade/v7.pm
	'Create new role: [_1]...' => 'Lege neue Rolle [_1] an...',
	'change [_1] to [_2]' => 'ändere [_1] in [_2]',
	'Assign a Site Administrator Role for Manage Website...' => 'Weise Website verwalten eine Site-Administrator-Rolle zu...',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Weise Website mit Blogs verwalten eine Site-Administrator-Rolle zu...',
	'add administer_site permission for Blog Administrator...' => 'Weise Blog-Administrator administer-site-Berechtigung zu...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Ändere die Rolle Untersite-Administrator in Site-Administrator...',
	'Child Site Administrator' => 'Untersite-Administrator',
	'Rebuilding object categories...' => 'Baue Objekt-Kategorien neu auf ...',
	'Error removing records: [_1]' => 'Fehler beim Entfernen von Datensätzen: [_1]',
	'Error saving record: [_1]' => 'Fehler beim Speichern eines Datensatzes: [_1]',
	'Rebuilding object tags...' => 'Baue Objekt-Tags neu auf...',
	'Rebuilding object assets...' => 'Baue Objekt-Assets neu auf...',
	'Rebuilding content field permissions...' => 'Baue Inhaltsfelder-Berechtigungen neu auf...',
	'Create a new role for creating a child site...' => 'Lege neue Berechtigung zum Anlegen von Untersites an...',
	'Migrating create child site permissions...' => 'Migriere Untersite-Berechtigungen...',
	'Migrating MultiBlog settings...' => 'Migriere MultiBlog-Einstellungen...',
	'Migrating fields column of MT::ContentType...' => 'Migriere Spalte "fields" von MT::ContentType....',
	'Migrating data column of MT::ContentData...' => 'Migriere Spalte "data" von MT::ContentData...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Baue MT::ContentFieldIndex von Zahlenfeld neu auf...',
	'Error removing record (ID:[_1]): [_2].' => 'Fehler beim Entfernen eines Datensatzes (ID:[_1]): [_2]',
	'Error saving record (ID:[_1]): [_2].' => 'Fehler beim Speichern eines Datensatzes (ID:[_1]): [_2]',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Baue MT::ContentFieldIndex von multi_line_text-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Baue MT::ContentFieldIndex von tables-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Baue MT::ContentFieldIndex von embedded_text-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Baue MT::ContentFieldIndex von url-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Baue MT::ContentFieldIndex von single-line-Feld neu auf...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Baue MT::Permission-Datensätze neu auf (entferne edit_categories)...',
	'Cleaning up content field indexes...' => 'Räume Inhaltsfeld-Indizes auf...',
	'Cleaning up objectasset records for content data...' => 'Räume objectasset-Datensätze von Inhaltsdaten auf...',
	'Cleaning up objectcategory records for content data...' => 'Räume objectcategory-Datensätze von Inhaltsdaten auf...',
	'Cleaning up objecttag records for content data...' => 'Räume objecttag-Datensätze von Inhaltsdaten auf...',
	'Truncating values of value_varchar column...' => 'Kürze value_varchar-Spalte...',
	'Migrating Max Length option of Single Line Text fields...' => 'Migriere Längenoption für einzeiligen Textfelder...',
	'Reset default dashboard widgets...' => 'Setze Standard-Dashboard-Widgets zurück...',
	'Rebuilding Content Type count of Category Sets...' => 'Baue Inhaltstypen-Zähler in Kategorie-Sets neu auf...', # Translate - New # OK
	'Adding site list dashboard widget for mobile...' => 'Füge Site-Listen-Widget zum Dashboard hin...', # Translate - New # OK

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Typangabe erforderlich',
	'Registry could not be loaded' => 'Konnte Registry nicht laden',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Typ muss .tgz sein.',
	'Could not read from filehandle.' => 'Dateihandle nicht lesbar.',
	'File [_1] is not a tgz file.' => '[_1] ist keine .tgz-Datei',
	'File [_1] exists; could not overwrite.' => '[_1] existiert bereits und konnte nicht überschrieben werden',
	'[_1] in the archive is not a regular file' => '[_1] im Archiv ist keine reguläre Datei', # Translate - New # OK
	'[_1] in the archive is an absolute path' => '[_1] im Archiv ist ein absoluter Pfad', # Translate - New # OK
	'[_1] in the archive contains ..' => '[_1] im Archiv enthält ...', # Translate - New # OK
	'Cannot extract from the object' => 'Kann aus Objekt nicht extrahieren',
	'Cannot write to the object' => 'Kann Objekt nicht beschreiben',
	'Both data and file name must be specified.' => 'Sowohl der Daten- als auch der Dateiname müssen angegeben werden.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Typ muss .zip sein.',
	'File [_1] is not a zip file.' => '[_1] ist keine .zip-Datei',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Zur Nutzung der in Movable Type integrierten CAPTCHA-Quelle ist Image::Magick erforderlich.',
	'You need to configure CaptchaSourceImageBase.' => 'Bitte konfigurieren Sie CaptchaSourceImageBase',
	'Type the characters you see in the picture above.' => 'Geben Sie die Zeichen ein, die Sie im obigen Bild sehen.',
	'Image creation failed.' => 'Bilderzeugung fehlgeschlagen.',
	'Image error: [_1]' => 'Bildfehler: [_1]',

## lib/MT/Util/Log.pm
	'Unknown Logger Level: [_1]' => 'Unbekannter Logger-Level: [_1]',
	'Invalid Log module' => 'Unbekanntes Log-Modul',
	'Cannot load Log module: [_1]' => 'Konnte Log-Modul nicht laden: [_1]',

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

## lib/MT/Util/YAML.pm
	'Invalid YAML module' => 'Ungültiges YAML-Modul',
	'Cannot load YAML module: [_1]' => 'Konnte YAML-Modul nicht laden: [_1]',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Diese Archivdatei existiert bereits. Ändern Sie entweder den Basisnamen oder den Archivpfad. ([_1])',
	'Blog, BlogID or Template param must be specified.' => 'Blog-, BlogID- oder Template-Parameter erforderlich.',
	'Template \'[_1]\' does not have an Output File.' => 'Vorlage &#8222;[_1]&#8220; hat keine Ausgabedatei.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Fehler bei der Veröffentlichung zeitgeplanter Einträge: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Fehler beim Zurückziehen älterer Einträge: [_1]',

## lib/MT/Website.pm
	'First Website' => 'Erste Website',
	'Child Site Count' => 'Anzahl Untersites',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'Veröffentlichung im Hintergrund abgeschlossen',
	'Published: [_1]' => 'Veröffentlicht: [_1]',
	'Error rebuilding file [_1]:[_2]' => 'Fehler beim Neuaufbau der Datei [_1]: [_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- Gruppe komplett ([quant,_1,Datei,Dateien] in [_2] Sekunden)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "Fehler beim rsyncen der Dateien in [_1]:",
	'Done Synchronizing Files' => 'Datei-Sychronisierung abgeschlossen',
	'Done syncing files to [_1] ([_2])' => 'Die Dateien wurden mit [_1] ([_2]) synchronisiert',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
	'No web services password assigned.  Please see your user profile to set it.' => 'Kein Passwort für Webdienste vergeben. Sie können das Passwort in Ihrem Benutzerprofil angegeben.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Der gewünschte Permalink &#8222;[_1]&#8220; ist für diese Seite nicht verfügbar.',
	'Saving folder failed: [_1]' => 'Speichern des Ordners fehlgeschlagen: [_1]',
	'No blog_id' => 'Blog_id fehlt',
	'Invalid login' => 'Ungültiges Login',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '&#8222;mt_[_1]&#8220; kann nur 0 oder 1 sein (war &#8222;[_2]&#8220;)',
	'No entry_id' => 'Keine entry_id',
	'Invalid entry ID \'[_1]\'' => 'Ungültige Eintrags-ID \'[_1]\'',
	'Not allowed to edit entry' => 'Darf Eintrag nicht ändern',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Eintrag &#8222;[_1]&#8220; ([_5] #[_2]) von &#8222;[_3]&#8220; (Benutzer-Nr. [_4]) per XML-RPC gelöscht',
	'Not allowed to get entry' => 'Darf Eintrag nicht lesen',
	'Not allowed to set entry categories' => 'Darf Kategorien nicht zuweisen',
	'Publishing failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Not allowed to upload files' => 'Darf Dateien nicht hochladen',
	'No filename provided' => 'Kein Dateiname angegeben',
	'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Zur Bestimmung von Höhe und Breite hochgeladener Bilddateien ist das Perl-Modul Image::Size erforderlich.',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Funktionen zum Zugriff auf Vorlagen sind auf Grund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',

## mt-static/addons/Cloud.pack/js/cfg_config_directives.js
	'A configuration directive is required.' => 'Konfigurationsparameter erforderlich.', # Translate - New # OK
	'[_1] cannot be updated.' => '[_1] kann nicht aktualisiert werden.', # Translate - New # OK
	'Although [_1] can be updated by Movable Type, it cannot be updated on this screen.' => '[_1] kann nicht aus dieser Ansicht heraus von Movable Type aktualisiert werden.', # Translate - New # OK
	'[_1] already exists.' => '[_1] ist bereits vorhanden.', # Translate - New # OK
	'A configuration value is required.' => 'Konfigurationswert erforderlich.', # Translate - New # OK
	'The HASH type configuration directive should be in the format of "key=value"' => 'HASH-Konfigurationsparameter sollten im Format "Schlüssel=Wert" angegeben werden.', # Translate - New # OK
	'[_1] for [_2] already exists.' => '[_1] ist für [_2] bereits vorhanden.', # Translate - New # OK
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',
	'Are you sure you want to remove [_1]?' => '[_1] wirklich entfernen?', # Translate - New # OK
	'configuration directive' => 'Konfigurationsparameter', # Translate - New # OK

## mt-static/addons/Cloud.pack/js/cms.js
	'Continue' => 'Weiter',
	'You have unsaved changes to this page that will be lost.' => 'Es liegen nicht gespeicherte Seitenänderungen vor, die verloren gehen werden.',

## mt-static/addons/Sync.pack/js/cms.js

## mt-static/chart-api/deps/raphael-min.js
	'+e.x+' => '+e.x+',

## mt-static/chart-api/mtchart.js

## mt-static/chart-api/mtchart.min.js

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Ungültiger Wert',
	'You have an error in your input.' => 'Eine Eingabe ist fehlerhaft.',
	'Options less than or equal to [_1] must be selected' => 'Bitte wählen Sie höchstens [_1] Optionen',
	'Options greater than or equal to [_1] must be selected' => 'Bitte wählen Sie mindestens [_1] Optionen',
	'Please select one of these options' => 'Bitte wählen Sie eine der Optionen',
	'Only 1 option can be selected' => 'Bitte wählen Sie genau eine Option',
	'Invalid date format' => 'Ungültiges Datumsformat',
	'Invalid time format' => 'Ungültiges Zeitformat',
	'Invalid URL' => 'Ungültige Web-Adresse (URL)',
	'This field is required' => 'Dieses Feld ist erforderlich.',
	'This field must be an integer' => 'Integer in diesem Feld erforderlich.',
	'This field must be a signed integer' => 'Integer mit Vorzeichen in diesem Feld erforderlich',
	'This field must be a number' => 'Zahl in diesem Feld erforderlich.',
	'This field must be a signed number' => 'Zahl mit Vorzeichen in diesem Feld erforderlich',
	'Please input [_1] characters or more' => 'Bitte geben Sie mindestens [_1] Zeichen ein',

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Keine Vorschau verfügbar',
	'Dimensions' => 'Abmessungen',
	'File Name' => 'Dateiname',

## mt-static/js/cms.js

## mt-static/js/contenttype/contenttype.js

## mt-static/js/contenttype/tag/content-fields.tag
	'Data Label Field' => 'Bezeichnungsfeld für Daten',
	'Show input field to enter data label' => 'Eingabefeld zur Eingabe der Datenbezeichung anzeigen',
	'Unique ID' => 'Eindeutige ID',
	'Allow users to change the display and sort of fields by display option' => 'Benutzern erlauben, die Anzeige und Reihenfolge der Felder zu ändern',
	'close' => 'schließen',
	'Drag and drop area' => 'Drag-und-Drop-Bereich',
	'Please add a content field.' => 'Bitte fügen Sie ein Inhaltsfeld ein.',

## mt-static/js/contenttype/tag/content-field.tag
	'Move' => 'Verschieben',
	'ContentField' => 'ContentField',

## mt-static/js/dialog.js
	'(None)' => '(Keine)',

## mt-static/js/image_editor/fabric.js
	' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ' => ' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ',
	', (-this.width / 2), , (-this.height/2), ' => ', (-this.width / 2), , (-this.height/2), ',
	' + (-this.width/2) +  + (-this.height/2) + ' => ' + (-this.width/2) +  + (-this.height/2) + ',
	', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ' => ', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ',
	',
        -this.width / 2, ,
        -this.height + heightOfLine, ' => ',
        -this.width / 2, ,
        -this.height + heightOfLine, ',

## mt-static/js/image_editor/fabric.min.js
	'+e(n.x,r)++e(n.y,r)+' => '+e(n.x,r)++e(n.y,r)+',
	',i(r.textLeft,2)," ",i(r.textTop,2),' => ',i(r.textLeft,2)," ",i(r.textTop,2),',

## mt-static/js/listing/list_data.js
	'[_1] - Filter [_2]' => '[_1]-Filter [_2]',

## mt-static/js/listing/listing.js
	'act upon' => 'reagieren',
	'You did not select any [_1] to [_2].' => 'Keine [_1] zu [_2] gewählt.',
	'You can only act upon a minimum of [_1] [_2].' => 'Nur möglich für mindestens [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Nur möglich für höchstens [_1] [_2].',
	'Are you sure you want to [_2] this [_1]?' => '[_1] wirklich [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Die [_1] gewählten [_2] wirklich [_3]?',
	'Label "[_1]" is already in use.' => 'Bezeichnung "[_1]" bereits vorhanden.',
	'Are you sure you want to remove filter \'[_1]\'?' => 'Filter \'[_1]\' wirklich entfernen?',

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'Show' => 'Anzeigen',
	'25 rows' => '25 Zeilen',
	'50 rows' => '50 Zeilen',
	'100 rows' => '100 Zeilen',
	'200 rows' => '200 Zeilen',

## mt-static/js/listing/tag/display-options.tag
	'Reset defaults' => 'Auf Standardeinstellungen zurücksetzen',
	'Column' => 'Spalte',
	'User Display Option is disabled now.' => 'Anzeigeoptionen für Benutzer deaktiviert.',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Select action' => 'Aktion wählen', # Translate - New # OK
	'Plugin Actions' => 'Plugin-Aktionen',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Weitere Aktionen...',

## mt-static/js/listing/tag/list-actions.tag

## mt-static/js/listing/tag/list-filter.tag
	'Filter:' => 'Filter:',
	'Reset Filter' => 'Filer zurücksetzen',
	'Select Filter Item...' => 'Filterelement wählen...',
	'Add' => 'Hinzufügen',
	'Select Filter' => 'Filter wählen',
	'My Filters' => 'Meine Filter',
	'rename' => 'umbenennen',
	'Create New' => 'Neu anlegen',
	'Built in Filters' => 'Eingebaute Filter',
	'Apply' => 'Anwenden',
	'Save As' => 'Speichern als',
	'Filter Label' => 'Filter-Bezeichnung',

## mt-static/js/listing/tag/list-pagination-for-mobile.tag

## mt-static/js/listing/tag/list-pagination-for-pc.tag

## mt-static/js/listing/tag/list-table.tag
	'Loading...' => 'Lade...',
	'Select All' => 'Alle auswählen',
	'All' => 'Alle', # Translate - Case # OK
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] von [_3]',
	'Select all [_1] items' => 'Alle [_1] Elemente auswählen',
	'All [_1] items are selected' => 'Alle [_1] Elemente ausgewählt',
	'Select' => 'Wählen',

## mt-static/js/mt/util.js
	'You did not select any [_1] [_2].' => 'Sie haben keine [_1] [_2] gewählt',
	'delete' => 'löschen',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Rolle wirklich entfernen? Entfernen der Rolle entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '[_1] Rolle(n) wirklich entfernen? Entfernen der Rollen entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'You must select an action.' => 'Bitte wählen Sie zunächst eine Aktion.',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titel:',
	'Description:' => 'Überschrift:',
	'Author:' => 'Autor:',
	'Tags:' => 'Tags:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a valid path.' => 'Bitte geben Sie einen gültigen Pfad an.',
	'You must set a path beginning with %s or %a.' => 'Pfade müssen mit %s oder %a beginnen.',

## mt-static/mt.js
	'remove' => 'entfernen',
	'enable' => 'aktivieren',
	'disable' => 'deaktivieren',
	'publish' => 'veröffentlichen',
	'unlock' => 'entsperren',
	'to mark as spam' => 'zur Markierung als Spam',
	'to remove spam status' => 'zum Entfernen des Spam-Status',
	'Enter email address:' => 'E-Mail-Adresse eingeben:',
	'Enter URL:' => 'URL eingeben:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich mit &#8222;[_2]&#8220; zusammengeführt werden?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich in allen Weblogs mit &#8222;[_2]&#8220; zusammengeführt werden?',
	'Same name tag already exists.' => 'Ein Tag mit diesem Namen ist bereits vorhanden.',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1]-Block bearbeiten',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Code einbetten',
	'Please enter the embed code here.' => 'Bitte geben Sie den einzubettenden Code hier ein.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Überschrift',
	'Heading Level' => 'Ebene der Überschrift',
	'Please enter the Header Text here.' => 'Bitte geben Sie die Überschrift hier ein.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale Trennlinie',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Text',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Wählen Sie einen Block',

## mt-static/plugins/BlockEditor/lib/js/modal_window.js

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Textbaustein einfügen',

## mt-static/plugins/Loupe/js/vendor.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'Es liegen nicht gespeicherte Änderungen vor. Wirklich verlassen?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'Wert',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%Y-%m-%d' => '%Y-%m-%d',
	'%H:%M:%S' => '%H:%M:%S',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Fullscreen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Class Name' => 'Name der Klasse',
	'Bold (Ctrl+B)' => 'Fett (Strg+B)',
	'Italic (Ctrl+I)' => 'Kursiv (Strg+I)',
	'Underline (Ctrl+U)' => 'Unterstrichen (Strg+U)',
	'Strikethrough' => 'Durchstreichen',
	'Block Quotation' => 'Zitat',
	'Unordered List' => 'Unsortierte Liste',
	'Ordered List' => 'Sortierte Liste',
	'Horizontal Line' => 'Trennlinie',
	'Insert/Edit Link' => 'Link einfügen/bearbeiten',
	'Unlink' => 'Link entfernen',
	'Undo (Ctrl+Z)' => 'Rückgängig (Strg+Z)',
	'Redo (Ctrl+Y)' => 'Wiederholen (Strg+Y)',
	'Select Text Color' => 'Schriftfarbe wählen',
	'Select Background Color' => 'Hintergrundfarbe wählen',
	'Remove Formatting' => 'Formatierung entfernen',
	'Align Left' => 'Linsbündig',
	'Align Center' => 'Zentriert',
	'Align Right' => 'Rechtsbündig',
	'Indent' => 'Einrücken',
	'Outdent' => 'Ausrücken',
	'Insert Link' => 'Link einfügen',
	'Insert HTML' => 'HTML einfügen',
	'Insert Image Asset' => 'Bild aus Assets einfügen',
	'Insert Asset Link' => 'Link aus Assets einfügen',
	'Toggle Fullscreen Mode' => 'Vollbildmodus aktivieren/deaktivieren',
	'Toggle HTML Edit Mode' => 'HTML-Editor aktivieren/deaktivieren',
	'Strong Emphasis' => 'Starke Betonung',
	'Emphasis' => 'Betonung',
	'List Item' => 'Listenelement',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/plugin.min.js
	'Paste is now in plain text mode. Contents will now be pasted as plain text until you toggle this option off.' => 'Plain Text einfügen. Solange diese Option aktiv ist, werden Inhalte ohne Formatierung eingefügt.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.js
	'Error: Form submit field collision.' => 'Fehler: Kollision mit Submit-Feld des Formulars',
	'Error: No form element found.' => 'Fehler: Kein Formularelement gefunden.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.js
	'Server response wasn\'t proper JSON.' => 'Der Server hat kein einwandfreies JSON zurückgegeben.',
	'The spelling service was not found: (' => 'Rechtschreibhilfe-Dienst nicht gefunden: (',
	')' => ')',
	'No misspellings found.' => 'Keine Rechtschreibfehler gefunden.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.js
	'No templates defined.' => 'Keine Vorlagen definiert.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/textcolor/plugin.js
	'No color' => 'Keine Farbe',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.js
	'Table of Contents' => 'Inhaltsverzeichnis',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.js
	'Image uploading...' => 'Lade Bilder hoch...',

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.min.js
	'Your browser doesn\'t support direct access to the clipboard. Please use the Ctrl+X/C/V keyboard shortcuts instead.' => 'Ihr Browser unterstützt keinen direkten Zugriff auf die Zwischenablage. Bitte benutzen Sie die Tastenkombinationen Strg+X/C/V.',
	'Rich Text Area. Press ALT-F9 for menu. Press ALT-F10 for toolbar. Press ALT-0 for help' => 'Grafischer Editor. Drücken Sie Alt-F9 für das Menü, Alt-F10 für die Werkzeugleiste, Alt-F0 für Hilfe.',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] hat auf den <a href="[_2]">Kommentar von [_3]</a> geantwortet</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Kommentardetails',

## themes/classic_blog/templates/comment_preview.mtml
	'Previewing your Comment' => 'Vorschau Ihres Kommentars',
	'Leave a comment' => 'Kommentar schreiben',
	'Replying to comment from [_1]' => 'Antwort auf den Kommentar von [_1]',
	'(You may use HTML tags for style)' => '(Zur Formatierung können HTML-Tags verwendet werden.)',
	'Submit' => 'Abschicken',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'Ihr Kommentar ist eingegangen!',
	'Your comment submission failed for the following reasons: [_1]' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden: [_1]',

## themes/classic_blog/templates/comments.mtml
	'The data is modified by the paginate script' => 'Die Daten werden vom Paginierungsskript modifiziert.',
	'Remember personal info?' => 'Persönliche Angaben speichern?',

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="Vollständiger Kommentar zu [_4]">weiterlesen</a>',

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'TrackBack-URL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> von [_3] zu <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Weiterlesen</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Klassisches Blog-Design mit zahlreichen Stilvorlagen und zwei- und dreispaltigen Layouts. Ideal für alle Blogging-Zwecke.',
	'Improved listing of comments.' => 'Verbesserte Kommentarverwaltung',
	'Displays preview of comment.' => 'Zeigt eine Vorschau des Kommentars an',
	'Displays error, pending or confirmation message for comments.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Kommentaren an',
	'Displays results of a search for content data.' => 'Zeigt Ergebnisse der Suche nach Inhaltsdaten an.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag dieses Blogs',
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag dieses Blogs.',

## themes/classic_website/templates/archive_index.mtml

## themes/classic_website/templates/archive_widgets_group.mtml

## themes/classic_website/templates/author_archive_list.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'Blogs',

## themes/classic_website/templates/calendar.mtml

## themes/classic_website/templates/category_archive_list.mtml

## themes/classic_website/templates/category_entry_listing.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/current_author_monthly_archive_list.mtml

## themes/classic_website/templates/current_category_monthly_archive_list.mtml

## themes/classic_website/templates/date_based_author_archives.mtml

## themes/classic_website/templates/date_based_category_archives.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/monthly_archive_dropdown.mtml

## themes/classic_website/templates/monthly_archive_list.mtml

## themes/classic_website/templates/monthly_entry_listing.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Feed dieser Website abonnieren},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Für Portale, die die Inhalte mehrerer Blogs in einer gemeinsamen Website anzeigen.',
	'Classic Website' => 'Klassische Website',

## themes/eiger/templates/banner_footer.mtml
	'This blog is licensed under a <a rel="license" href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a rel="license" href="[_1]">Creative Commons-Lizenz</a>.',

## themes/eiger/templates/category_archive_list.mtml

## themes/eiger/templates/category_entry_listing.mtml
	'Home' => 'Startseite',
	'Pagination' => 'Paginierung',
	'Related Contents (Blog)' => 'Verwandte Inhalte (Blog)',

## themes/eiger/templates/comment_detail.mtml

## themes/eiger/templates/comment_form.mtml
	'Post a Comment' => 'Kommentar schreiben',
	'Reply to comment' => 'Kommentar beantworten',

## themes/eiger/templates/comment_preview.mtml

## themes/eiger/templates/comment_response.mtml
	'Your comment has been received and held for approval by the blog owner.' => 'Ihr Kommentar ist eingegangen und muss nun vom Blogbetreiber freigeschaltet werden.',

## themes/eiger/templates/comments.mtml

## themes/eiger/templates/dynamic_error.mtml
	'Related Contents (Index)' => 'Verwandte Inhalte (Index)',

## themes/eiger/templates/entries_list.mtml
	'Read more' => 'Weiterlesen',

## themes/eiger/templates/entry.mtml
	'Posted on' => 'Veröffentlicht am',
	'Previous entry' => 'Vorheriger Eintrag',
	'Next entry' => 'Nächster Eintrag',
	'Zenback' => 'Zenback',

## themes/eiger/templates/entry_summary.mtml

## themes/eiger/templates/index_page.mtml
	'Main Image' => 'Titelbild',

## themes/eiger/templates/javascript.mtml
	'The sign-in attempt was not successful; please try again.' => 'Anmeldeversuch nicht erfolgreich. Bitte versuchen Sie es erneut.',

## themes/eiger/templates/javascript_theme.mtml
	'Menu' => 'Menü',

## themes/eiger/templates/main_index.mtml

## themes/eiger/templates/navigation.mtml
	'About' => 'Über',

## themes/eiger/templates/page.mtml

## themes/eiger/templates/pages_list.mtml

## themes/eiger/templates/pagination.mtml
	'Older entries' => 'Ältere Einträge',
	'Newer entries' => 'Neuere Einträge',

## themes/eiger/templates/recent_entries.mtml

## themes/eiger/templates/sample_widget_01.mtml
	'Sample Widget' => 'Beispiel-Widget',
	'This is sample widget' => 'Das ist ein Beispiel-Widget',

## themes/eiger/templates/sample_widget_02.mtml
	'Advertisement' => 'Werbung',

## themes/eiger/templates/sample_widget_03.mtml
	'Banner' => 'Banner',

## themes/eiger/templates/sample_widget_04.mtml
	'Links' => 'Links',
	'Link Text' => 'Linktext',

## themes/eiger/templates/search.mtml

## themes/eiger/templates/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Die Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Die boolschen Operatoren AND, OR und NOT werden unterstützt:',

## themes/eiger/templates/styles.mtml
	'for Comments, Trackbacks' => 'für Kommentare und TrackBacks',
	'Sample Style' => 'Beispiel-Design',

## themes/eiger/templates/syndication.mtml

## themes/eiger/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> - [_3]</a>' => '<a href="[_1]">[_2]</a> - [_3]</a>',

## themes/eiger/templates/yearly_archive_dropdown.mtml
	'Select a Year...' => 'Jahr wählen...',

## themes/eiger/templates/yearly_archive_list.mtml

## themes/eiger/templates/yearly_entry_listing.mtml

## themes/eiger/templates/zenback.mtml
	'Please paste the Zenback script code here' => 'Fügen Sie hier den Code Ihres Zenback-Skripts ein',

## themes/eiger/theme.yaml
	'_THEME_DESCRIPTION' => '&#8222;Eiger&#8220; ist ein flexibel anpassbares Responsive-Thema. Über CSS-Media-Queries werden Ihre Seiten nicht nur automatisch optimal an die Fenstergröße des jeweiligen Computers oder Mobilgeräts angepasst. Mit den Movable-Type-eigenen Funktionen gestalten Sie darüber hinaus Navigationselemente, Logos und Kopfzeilen im Handumdrehen nach Ihren Vorstellungen.',
	'_ABOUT_PAGE_TITLE' => 'Über-Seite',
	'_ABOUT_PAGE_BODY' => '<p>Das ist eine Beispiel-"Über"-Seite. Auf dieser Seite werden üblicherweise Informationen zu Ihrer Person oder Ihrem Unternehmen angezeigt.</p><p>Wenn Sie den <code>@ABOUT_PAGE</code>-Befehl auf einer Seite verwenden, werden Links zu ihr in den Navigationsleisten im Kopf- und Fußbereich angezeigt.',
	'_SAMPLE_PAGE_TITLE' => 'Beispielseite',
	'_SAMPLE_PAGE_BODY' => '<p>Das ist eine Beispiel-Seite.</p><p>Wenn Sie den <code>@ADD_TO_SITE_NAV</code>-Befehl in einer Seite verwenden, werden Links zu ihr in den Navigationsleisten im Kopf- und Fußbereich angezeigt.</p>',
	'Eiger' => 'Eiger',
	'Index Page' => 'Index-Seite',
	'Stylesheet for IE (8 or lower)' => 'Stylesheet für IE 8 und älter',
	'JavaScript - Theme' => 'JavaScript - Thema',
	'Yearly Entry Listing' => 'Jährliche Eintragsliste',
	'Displays errors for dynamically published templates.' => 'Zeigt Fehlermeldung von dynamisch erzeugten Vorlagen an.',
	'Yearly Archives Dropdown' => 'Jahresarchiv (Dropdown)',
	'Yearly Archives' => 'Jahresarchiv',
	'Sample Widget 01' => 'Beispiel-Widget 01',
	'Sample Widget 02' => 'Beispiel-Widget 02',
	'Sample Widget 03' => 'Beispiel-Widget 03',
	'Sample Widget 04' => 'Beispiel-Widget 04',

## themes/mont-blanc/theme.yaml
	'__DESCRIPTION' => '&#8222;Rainier&#8220; ist ein flexibel anpassbares Thema mit Responsive Web Design. Über CSS-Media-Queries wird der Inhalt Ihrer Seiten automatisch optimal an die Fenstergröße des jeweils verwendeten Computers oder Mobilgeräts angepasst. Mit den Movable-Type-eigenen Funktionen gestalten Sie Navigationselemente, Logos und Kopfzeilen im Handumdrehen nach Ihren Vorstellungen.',
	'Mont-Blanc' => 'Mont-Blanc',
	'Summary' => 'Zusammenfassung',
	'og:image' => 'og:image',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Related Content' => 'Verwandte Einträge',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Kommentarvorschau',

## themes/pico/templates/comment_response.mtml

## themes/pico/templates/comments.mtml

## themes/pico/templates/creative_commons.mtml

## themes/pico/templates/current_author_monthly_archive_list.mtml

## themes/pico/templates/current_category_monthly_archive_list.mtml

## themes/pico/templates/date_based_author_archives.mtml

## themes/pico/templates/date_based_category_archives.mtml

## themes/pico/templates/dynamic_error.mtml

## themes/pico/templates/entry.mtml

## themes/pico/templates/entry_summary.mtml

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	'Subscribe' => 'Abonnieren',

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/theme.yaml
	q{Pico is a microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Pico ist das Microblogging-Thema, das speziell auf einfache und häufige Aktualisierungen ausgelegt ist. Zur Betonung der aktuellen Inhalte werden die Seitenleisten unterhalb der Einträge angezeigt.},
	'Pico' => 'Pico',
	'Pico Styles' => 'Pico-Designs',
	'A collection of styles compatible with Pico themes.' => 'Mit Pro-Themen kompatible Designs',

## themes/rainier/templates/banner_footer.mtml

## themes/rainier/templates/category_archive_list.mtml

## themes/rainier/templates/category_entry_listing.mtml
	'Related Contents' => 'Verwandte Inhalte',

## themes/rainier/templates/comment_detail.mtml

## themes/rainier/templates/comment_form.mtml

## themes/rainier/templates/comment_preview.mtml

## themes/rainier/templates/comment_response.mtml

## themes/rainier/templates/comments.mtml

## themes/rainier/templates/dynamic_error.mtml

## themes/rainier/templates/entry.mtml
	'Posted on [_1]' => 'Veröffentlicht am [_1]',
	'by [_1]' => 'von [_1]',
	'in [_1]' => 'auf',

## themes/rainier/templates/entry_summary.mtml
	'Continue reading' => 'Weiterlesen',

## themes/rainier/templates/javascript.mtml

## themes/rainier/templates/javascript_theme.mtml

## themes/rainier/templates/main_index.mtml

## themes/rainier/templates/monthly_archive_dropdown.mtml

## themes/rainier/templates/monthly_archive_list.mtml

## themes/rainier/templates/monthly_entry_listing.mtml

## themes/rainier/templates/navigation.mtml

## themes/rainier/templates/page.mtml
	'Last update' => 'Zuletzt aktualisiert',

## themes/rainier/templates/pages_list.mtml

## themes/rainier/templates/pagination.mtml

## themes/rainier/templates/recent_comments.mtml
	'__VIEW_COMMENT' => '[_1] zu <a href="[_2]" title="Vollständiger Kommentar zu: [_3]">[_3]</a>',

## themes/rainier/templates/recent_entries.mtml

## themes/rainier/templates/search.mtml

## themes/rainier/templates/search_results.mtml

## themes/rainier/templates/syndication.mtml

## themes/rainier/templates/tag_cloud.mtml

## themes/rainier/templates/trackbacks.mtml

## themes/rainier/templates/zenback.mtml
	'Please paste Zenback script code here.' => 'Bitte fügen Sie den Code Ihres Zenback-Skripts hier ein.',

## themes/rainier/theme.yaml
	'About Page' => 'Über-Seite',
	'Example page' => 'Beispielseite',
	'Rainier' => 'Rainier',
	'Styles for Rainier' => 'Designs für Rainier',
	'A collection of styles compatible with Rainier themes.' => 'Mit Rainier-Themen kompatible Designs',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Suche nach neuen Kommentaren:',
	'the beginning' => 'ingesamt',
	'one week ago' => 'vor einer Woche',
	'two weeks ago' => 'vor zwei Wochen',
	'one month ago' => 'vor einem Monat',
	'two months ago' => 'vor zwei Monaten',
	'three months ago' => 'vor drei Monaten',
	'four months ago' => 'vor vier Monaten',
	'five months ago' => 'vor fünf Monaten',
	'six months ago' => 'vor sechs Monaten',
	'one year ago' => 'vor eine mJahr',
	'Find new comments' => 'Neue Kommentare finden',
	'Posted in [_1] on [_2]' => 'Veröffentlicht in [_1] am [_2]',
	'No results found' => 'Keine Treffer',
	'No new comments were found in the specified interval.' => 'Keine neuen Kommentare in diesem Zeitraum gefunden.',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Wählen Sie den gewünschten Zeitraum und klicken Sie dann auf &#8222;Neue Kommentare finden&#8220;.},

## search_templates/content_data_default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'AUTODISCOVERY-LINK FÜR SUCH-FEEDS WIRD NUR NACH ABSCHLUSS EINER SUCHE VERÖFFENTLICHT',
	'Site Search Results' => 'Suchergebnis in der Site',
	'Site search' => 'Site-Suche',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'BEI DIREKTEN SUCHEN WIRD DAS SUCHFORMULAR ANGEZEIGT',
	'Search this site' => 'Diese Site durchsuchen',
	'SEARCH RESULTS DISPLAY' => 'ANZEIGE DER SUCHERGEBNISSE',
	'Matching content data from [_1]' => 'Passende Inhaltsdaten aus [_1]',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Veröffentlicht <MTIfNonEmpty tag="ContentAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'Showing the first [_1] results.' => 'Erste [_1] Treffer',
	'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
	q{Content Data matching '[_1]'} => q{Inhalte für '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Mit '[_1]' getaggte Inhalte},
	q{No pages were found containing '[_1]'.} => q{Keine Seiten mit &#8222;[_1]&#8220; gefunden.},
	'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE VS TAG-Information',
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Inhalte abonnieren.},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Inhalte zu &#8222;[_1]&#8220; abonnieren.},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
	'Feed Subscription' => 'Feed abonnieren',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Was ist das?',
	'END OF PAGE BODY' => 'PAGE BODY ENDE',
	'END OF CONTAINER' => 'CONTAINER ENDE',

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Suchergebnis für [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Suchergebnis im Blog',
	'Blog search' => 'Suche im Blog',
	'Match case' => 'Groß-/Kleinschreibung beachten',
	'Regex search' => 'Reguläre Ausdrücke verwenden',
	'Matching entries from [_1]' => 'Treffer in [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Mit &#8222;[_2]&#8220; getaggte Einträge aus [_1]},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Veröffentlicht <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	q{Entries matching '[_1]'} => q{Einträge mit &#8222;[_1]&#8220;},
	q{Entries tagged with '[_1]'} => q{Mit &#8222;[_1]&#8220; getaggte Einträge},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit &#8222;[_1]&#8220; abonnieren.},
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
	'Other Tags' => 'Andere Tags',

## search_templates/results_feed_rss2.tmpl

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Neues Asset hochladen',

## tmpl/cms/asset_upload.tmpl

## tmpl/cms/backup.tmpl
	'What to Export' => 'Was soll exportiert werden',
	'Everything' => 'Mit allen Blogs',
	'Reset' => 'zurücksetzen',
	'Choose sites...' => 'Sites wählen...',
	'Archive Format' => 'Archiv-Format',
	q{Don't compress} => q{Nicht komprimieren},
	'Target File Size' => 'Gewünschte Dateigröße ',
	'No size limit' => 'Unbegrenzt',
	'Export (e)' => 'Exportieren (e)',

## tmpl/cms/cfg_entry.tmpl
	'Your preferences have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'Publishing Defaults' => 'Veröffentlichungs-Voreinstellungen',
	'Listing Default' => 'Listen-Voreinstellung',
	'Days' => 'Tage',
	'Posts' => 'Einträge',
	'Order' => 'Reihenfolge',
	'Ascending' => 'Aufsteigend',
	'Descending' => 'Absteigend',
	'Excerpt Length' => 'Länge des Auszugs',
	'Date Language' => 'Datumsanzeige',
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
	'Compose Defaults' => 'Editor-Voreinstellungen',
	'Unpublished' => 'Nicht veröffentlicht',
	'Text Formatting' => 'Textformatierung',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
	'Setting Ignored' => 'Einstellung ignoriert',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare auf Untersites oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare site- oder systemweit deaktiviert sind.',
	'Accept TrackBacks' => 'TrackBacks annehmen',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks auf Untersites oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks site- oder systemweit deaktiviert sind.',
	'Entry Fields' => 'Eintragsfelder',
	'Page Fields' => 'Seitenfelder',
	'WYSIWYG Editor Setting' => 'Einstellungen des grafischen Editors',
	'Content CSS' => 'CSS für Inhalte',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'Sie können eigenes CSS für Inhalte nutzen, sofern der verwendete grafische Editor diese Funktion unterstützt. Referenzieren Sie Ihre CSS-Datei über ihre URL oder mit {{theme_static}}. Beispiel: {{theme_static}}pfad/zur/css-datei.css',
	'Punctuation Replacement Setting' => 'Ersetzung von Satzzeichen',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Mit dieser Option können von Textverarbeitungen erzeugte UTF-8-Sonderzeichen automatisch durch gebräuchlichere Äquivalente ersetzt werden.',
	'Punctuation Replacement' => 'Ersetzung von Satzzeichen',
	'No substitution' => 'Keine Zeichen ersetzen',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entitäten (&amp#8221;, &amp#8220; usw.)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{ASCII-Äquivalente (&quot;, ', ..., -, --)},
	'Replace Fields' => 'Felder ersetzen',
	'Image default insertion options' => 'Standardvorgang für das Einfügen von Bildern',
	'Use thumbnail' => 'Vorschaubild verwenden',
	'width:' => 'Breite:',
	'pixels' => 'Pixel',
	'Alignment' => 'Ausrichtung',
	'Left' => 'Links',
	'Center' => 'Mitte',
	'Right' => 'Rechts',
	'Link to popup window' => 'Mit Popup-Fenster verlinken',
	'Link image to full-size version in a popup window.' => 'Bild mit Version in voller Größe in Popup-Fenster verlinken',
	'Save changes to these settings (s)' => 'Änderungen speichern (s)',
	'The range for Basename Length is 15 to 250.' => 'Basisnamen können zwischen 15 und 250 Zeichen lang sein.',
	'You must set valid default thumbnail width.' => 'Bitte geben Sie eine gültige Breite für die Vorschaubilder an.',

## tmpl/cms/cfg_feedback.tmpl
	'Spam Settings' => 'Spam-Einstellungen',
	'Automatic Deletion' => 'Automatisches Löschen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam-Feedback nach Ablauf des angegebenen Zeitraums automatisch löschen.',
	'Delete Spam After' => 'Spam löschen nach',
	'days' => 'Tage',
	'Spam Score Threshold' => 'Spam-Schwellenwert',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Die Skala reicht von -10 bis +10. Je höher der Wert, desto eher werden Kommentare und TrackBacks als Spam angesehen.',
	q{Apply 'nofollow' to URLs} => q{'nofollow' an URLs anhängen},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Aktivieren Sie diese Option, um bei Links in Kommentaren und TrackBacks das 'nofollow'-Attribut zu setzen.},
	q{'nofollow' exception for trusted commenters} => q{'nofollow' nicht für vertraute Kommentarautoren setzen},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{&#8222;nofollow&#8220;-Attribut nicht in Feedback von vertrauten Autoren setzen.},
	'Comment Settings' => 'Kommentar-Einstellungen',
	'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Authentifizierungsfunktionen stehen nicht zur Verfügung, da mindestens eines der erforderlichen Perl-Module MIME::Base64 und LWP::UserAgent nicht verfügbar ist. Installieren Sie die fehlenden Module und laden Sie dann diese Seite neu, um Authentifizierungsfunktionen konfigurieren und nutzen zu können.',
	'Accept comments according to the policies shown below.' => 'Kommentare nach folgenden Regeln annehmen',
	'Setup Registration' => 'Registierung konfigurieren',
	'Commenting Policy' => 'Kommentierungsregeln',
	'Immediately approve comments from' => 'Kommentare automatisch freischalten von',
	'No one' => 'niemandem',
	'Trusted commenters only' => 'von vertrauten Kommentarautoren',
	'Any authenticated commenters' => 'von allen authentifizierten Kommentarautoren',
	'Anyone' => 'jedem',
	'Allow HTML' => 'HTML zulassen',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Bestimmte HTML-Tags in Kommentartexten zulassen. Anderfalls werden sämtliche HTML-Tags herausgefiltert.',
	'Limit HTML Tags' => 'HTML einschränken ',
	'Use defaults' => 'Standardwerte verwenden',
	'([_1])' => '([_1])',
	'Use my settings' => 'Eigene Einstellungen',
	'E-mail Notification' => 'Benachrichtigungen',
	'On' => 'Immer',
	'Only when attention is required' => 'Nur wenn eine Entscheidung erforderlich ist',
	'Off' => 'Nie',
	'Comment Display Settings' => 'Kommentaranzeige-Einstellungen',
	'Comment Order' => 'Kommentar- reihenfolge',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie, ob Kommentare in chronologischer oder umgekehrter chronologischer Reihenfolge angezeigt werden sollen,',
	'Auto-Link URLs' => 'URLs automatisch verlinken',
	'Transform URLs in comment text into HTML links.' => 'In Kommentaren enthaltene URLs in HTML-Links umwandeln.',
	'CAPTCHA Provider' => 'CAPTCHA-Quelle',
	'No CAPTCHA provider available' => 'Keine CAPTCHA-Quelle verfügbar',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Keine CAPTCHA-Quelle im System verfügbar. Überprüfen Sie, ob Image::Magick installiert ist und ob das CaptchaSourceImageBase-Konfigurationsparameter auf ein gültiges Verzeichnis im Ordner &#8222;mt-static/images&#8220; zeigt.},
	'Use Comment Confirmation Page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Nach Abgabe eines Kommentars Autoren automatisch auf Bestätigungsseite weiterleiten.},
	'Trackback Settings' => 'TrackBack-Einstellungen',
	'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
	'Accept TrackBacks from any source.' => 'TrackBacks von allen Quellen annehmen',
	'TrackBack Policy' => 'TrackBack-Regeln',
	'Moderation' => 'Moderation',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks zur Moderation zurückhalten',
	'TrackBack Options' => 'TrackBack-Optionen',
	'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
	'Enable External TrackBack Auto-Discovery' => 'Auto-Discovery für externe TrackBacks aktivieren',
	'Setting Notice' => 'Nutzungshinweise',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit eingeschränkt. Diese Option ist daher derzeit möglicherweise nicht oder nur teilweise wirksam.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit deaktiviert. Diese Option ist daher derzeit nicht wirksam.',
	'Enable Internal TrackBack Auto-Discovery' => 'Auto-Discovery für interne TrackBacks aktivieren',

## tmpl/cms/cfg_plugin.tmpl
	'Plugin System' => 'Plugin-System',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin für die gesamte Movable Type-Installation aktivieren oder deaktivieren.',
	'Disable plugin functionality' => 'Plugin-Funktion deaktivieren',
	'Disable Plugins' => 'Plugins deaktivieren',
	'Enable plugin functionality' => 'Plugin-Funktion aktivieren',
	'Enable Plugins' => 'Plugins aktivieren',
	'_PLUGIN_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Weitere Plugins',
	'Your plugin settings have been saved.' => 'Plugin-Einstellungen übernommen',
	'Your plugin settings have been reset.' => 'Plugin-Einstellungen zurückgesetzt',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Ihre Plugins wurden konfiguriert. Da Sie mod_perl verwenden, starten Sie Ihren Webserver bitte neu, um die Änderungen wirksam werden zu lassen.},
	'Your plugins have been reconfigured.' => 'Einstellungen übernommen',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Einstellungen übernommen. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.},
	'Are you sure you want to reset the settings for this plugin?' => 'Wollen Sie die Plugin-Einstellungen wirklich zurücksezten?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Plugins wirklich systemweit deaktivieren?',
	'Are you sure you want to disable this plugin?' => 'Dieses Plugin wirklich deaktivieren?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Plugins wirklich systemweit aktivieren? (Es werden die Plugin-Einstellungen gültig, die bereits vor der Deaktivierung gültig waren.)',
	'Are you sure you want to enable this plugin?' => 'Dieses Plugin wirklich aktivieren?',
	'Failed to load' => 'Fehler beim Laden',
	'Failed to Load' => 'Fehler beim Laden',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Dieses Plugin wurde noch nicht für Movable Type [_1] aktualisiert. Es funktioniert daher möglicherweise nicht einwandfrei.',
	'Plugin error:' => 'Plugin-Fehler:',
	'Info' => 'Info',
	'Resources' => 'Ressourcen',
	'Run [_1]' => '[_1] ausführen',
	'Documentation for [_1]' => 'Dokumentation zu [_1]',
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
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type konnte kein Cache-Verzeichnis für die dynamische Veröffentlichung erstellen. Bitte legen Sie ein Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website an.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache schreiben. Bitte weisen Sie dem Server Schreibrechte für das Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website zu.',
	'[_1] Settings' => '[_1]-Einstellungen',
	'Time Zone' => 'Zeitzone',
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
	'Language' => 'Sprache',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Wenn Sie eine andere Sprache als die systemweit festgelegte Standardsprache wählen, können Sie unterschiedliche globale Vorlagen verwenden, indem Sie die Modulnamen in Ihren Vorlagen entsprechend ändern.',
	'License' => 'Lizenz',
	'Your child site is currently licensed under:' => 'Ihre Untersite steht derzeit unter dieser Lizenz:',
	'Your site is currently licensed under:' => 'Ihre Site steht derzeit unter dieser Lizenz:',
	'Change license' => 'Lizenz ändern',
	'Remove license' => 'Lizenz entfernen',
	'Your child site does not have an explicit Creative Commons license.' => 'Ihre Untersite verfügt über keine Creative-Commons-Lizenz.',
	'Your site does not have an explicit Creative Commons license.' => 'Ihre Site verfügt über keine Creative-Commons-Lizenz.',
	'Select a license' => 'Creative Commons-Lizenz wählen',
	'Publishing Paths' => 'System-Pfade',
	'Use subdomain' => 'Subdomain verwenden',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => 'Achtung: Eine Änderung der [_1]-Adresse kann alle Links in Ihrem/Ihrer [_1] ungültig machen.',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{Die URL Ihrer Untersite. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{Die URL Ihrer Site. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/},
	'Use absolute path' => 'Absolute Pfadangabe verwenden',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Achtung: nach Änderung des [_1]-Wurzelverzeichnis muss die/das gesamte [_1] neu veröffentlicht werden.',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	'Advanced Archive Publishing' => 'Erweiterte Archivoptionen',
	'Publish archives outside of Site Root' => 'Archive außerhalb Site-Wurzelverzeichnis veröffentlichen',
	'Archive URL' => 'Archiv-Adresse',
	'Warning: Changing the archive URL can result in breaking all links in your [_1].' => 'Achtung: Eine Änderung der Archiv-Adresse kann alle Links in Ihrem/Ihrer [_1] ungültig machen.',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Die URL des Archivs Ihrer Untersite. Beispiel: http://beispiel.de/blog/archiv/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'Die URL des Archivs Ihrer Site.  Beispiel: http://beispiel.de/archiv/',
	'Archive Root' => 'Archiv-Wurzel',
	'Warning: Changing the archive path can result in breaking all links in your [_1].' => 'Achtung: Eine Änderung des Archiv-Pfads kann alle Links in Ihrem/Ihrer [_1] ungültig machen.',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog'},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	'Dynamic Publishing Options' => 'Dynamikoptionen',
	'Enable dynamic cache' => 'Dynamischen Cache aktivieren',
	'Enable conditional retrieval' => 'Conditional Retrieval aktivieren',
	'Archive Settings' => 'Archiv-Einstellungen',
	'Preferred Archive' => 'Bevorzugte Archive',
	'Choose archive type' => 'Archiv-Typ wählen',
	'No archives are active' => 'Archiv nicht aktiviert',
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Erzeugt dauerhafte URLs archivierter Einträge dieser Untersite (Permalinks). Wählen Sie dazu einen der in dieser Site verwendeten Archivtypen aus.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Erzeugt dauerhafte URLs archivierter Einträge dieser Site (Permalinks). Wählen Sie dazu einen der in dieser Site verwendeten Archivtypen aus.},
	'Publish With No Entries' => 'Leer veröffentlichen',
	'Publish category archive without entries' => 'Leere Kategoriearchive veröffentlichen',
	'Module Settings' => 'Modul-Einstellungen',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Keine (deaktiviert)',
	'PHP Includes' => 'PHP-Includes',
	'Apache Server-Side Includes' => 'Apache Server-Side-Includes',
	'Active Server Page Includes' => 'Active Server Page-Includes',
	'Java Server Page Includes' => 'Java Server Page-Includes',
	'Module Caching' => 'Modul-Caching',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Entsprechend konfigurierte Vorlagenmodule zwischenzuspeichern erhöht die Leistung Ihres Systems.',
	'Revision History' => 'Revisionshistorie',
	'Note: Revision History is currently disabled at the system level.' => 'Hinweis: Revisionshistorie ist systemweit deaktiviert',
	'Revision history' => 'Revisionshistorie',
	'Enable revision history' => 'Revisionsshistorie aufzeichnen',
	'Number of revisions per entry/page' => 'Anzahl der Revisionen pro Eintrag/Seite',
	'Number of revisions per content data' => 'Anzahl der Revisionen pro Inhalt',
	'Number of revisions per template' => 'Anzahl der Revisionen pro Vorlage',
	'Upload Destination' => 'Zielverzeichnis',
	'Allow to change at upload' => 'Darf beim Hochladen geändert werden',
	'Rename filename' => 'Datei umbenennen',
	'Rename non-ascii filename automatically' => 'Nicht-ASCII-Dateinamen automatisch umbenennen',
	'Operation if a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'Upload and rename' => 'Hochladen und umbenennen',
	'Overwrite existing file' => 'Vorhandene Datei überschreiben',
	'Cancel upload' => 'Vorgang abbrechen',
	'Normalize orientation' => 'Bilder automatisch drehen',
	'Enable orientation normalization' => 'Automatisches Drehen aktivieren',
	'You must set your Child Site Name.' => 'Bitte geben Sie den Namen der Untersite ein.',
	'You must set your Site Name.' => 'Bitte geben Sie den Namen der Site ein.',
	'You did not select a time zone.' => 'Bitte wählen Sie eine Zeitzone.',
	'You must set a valid URL.' => 'Bitte geben Sie eine gültige URL ein.',
	'You must set your Local file Path.' => 'Bitte geben Sie einen lokalen Dateipfad an.',
	'You must set a valid Local file Path.' => 'Bitte geben Sie einen gültigen lokalen Dateipfad an.',
	'Site root must be under [_1]' => 'Das Wurzelverzeichnis der Website muss unter [_1] liegen',
	'You must set a valid Archive URL.' => 'Bitte geben Sie eine gültige Archiv-Adresse an.',
	'You must set your Local Archive Path.' => 'Bitte geben Sie einen lokalen Archiv-Pfad an.',
	'You must set a valid Local Archive Path.' => 'Bitte geben Sie einen gültigen lokalen Archiv-Pfad an.',

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Config Rebuild Trigger' => 'Auslöser für Neuaufbau konfigurieren',
	'Rebuild Trigger settings has been saved.' => 'Auslöser-Einstellungen gespeichert.',
	'Content Privacy' => 'Externer Zugriff auf Inhalte',
	'Use system default' => 'System-Voreinstellung verwenden',
	'Allow' => 'Aggregation zulassen',
	'Disallow' => 'Aggregation nicht zulassen',
	'MTMultiBlog tag default arguments' => 'MultiBlog- Standardargumente',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Ermöglicht die Verwendung von MTMultiBlog ohne include_blogs- und exclude_blogs-Attribute. Erlaubte Werte sind 'all' oder per Kommata getrennte BlogIDs.},
	'Include sites/child sites' => 'Sites/Untersites einschließen',
	'Exclude sites/child sites' => 'Sites/Untersites ausschließen',
	'Rebuild Triggers' => 'Auslöser für Neuaufbau',
	'You have not defined any rebuild triggers.' => 'Es sind keine Auslöser definiert.',
	'When' => 'Wenn in',
	'Site/Child Site' => 'Site/Untersite',
	'Data' => 'Daten',
	'Trigger' => 'Auslöser',
	'Action' => 'Aktion',
	'Default system aggregation policy' => 'Systemwite Aggregations- Voreinstellung',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit nicht erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',

## tmpl/cms/cfg_registration.tmpl
	'Your site preferences have been saved.' => 'Site-Einstellungen gespeichert.',
	'User Registration' => 'Benutzerregistrierung',
	'Registration Not Enabled' => 'Registrierungen nicht zulassen',
	'Note: Registration is currently disabled at the system level.' => 'Hinweis: Registrierungen sind derzeit systemweit deaktiviert.',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'Besuchern erlauben, sich auf einem der unten aufgeführten Wege als Mitglied dieser Site zu registrieren.',
	'New Created User' => 'Neu angelegte Benutzerkonten',
	'Select a role that you want assigned to users that are created in the future.' => 'Wählen Sie die Rolle, die künftig angelegten Benutzerkonten automatisch zugewiesen werden soll.',
	'(No role selected)' => '(Keine Rolle gewählt)',
	'Select roles' => 'Rollen awählen',
	'Authentication Methods' => 'Authentifizierungs- methoden',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Das zur OpenID-Authentifizierung erforderliche Perl-Modul Digest::SHA1 fehlt.',
	'Please select authentication methods to accept comments.' => 'Wählen Sie, auf welche Weise sich Kommentar-Autoren authentifizieren können sollen.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Zur Nutzung dieser Authentifizierungsmethode fehlt mindestens ein erforderliches Perl-Modul.',

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'Imager does not support ImageQualityPng.' => 'ImageQualityPng wird von Imager nicht unterstützt.',
	'A test mail was sent.' => 'Testmail verschickt.',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Mindestens eine Ihrer Site oder Untersites folgt nicht den in BaseSitePath angegebenen Beschränkungen.',
	'System Email Address' => 'System-E-Mail-Adresse',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw.},
	'Send Test Mail' => 'Testmail verschicken',
	'Debug Mode' => 'Debug-Modus',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Werte ungleich 0 aktivieren den Debug-Modus, in dem zusätzliche Diagnose-Informationen zur Fehlersuche angezeigt werden. Weitere Informationen finden Sie in der <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Dokumentation</a>.',
	'Performance Logging' => 'Performance-Logging',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Performance-Logging protokolliert Ereignisse, die länger als eine von Ihnen bestimmbare Zeitspanne dauern.',
	'Turn on performance logging' => 'Performance-Logging aktivieren',
	'Log Path' => 'Logging-Pfad',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Verzeichnis für Log-Dateien. Ihr Webserver benötigt Schreibrechte für dieses Verzeichnis.',
	'Logging Threshold' => 'Logging-Schwellenwert',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Vorgänge, die länger als die angegebene Anzahl von Sekunden benötigen, loggen.',
	'Track revision history' => 'Revisionshistorie verfolgen',
	'Site Path Limitation' => 'Site-Pfad-Begrenzung',
	'Base Site Path' => 'Basis-Site-Pfad',
	'Allow sites to be placed only under this directory' => 'Sites nur unterhalb dieses Verzeichnisses zulassen',
	'System-wide Feedback Controls' => 'Systemweite Feedback-Einstellungen',
	'Prohibit Comments' => 'Kommentare nicht zulassen',
	'Disable comments for all sites and child sites.' => 'Kommentare auf allen Sites und Untersites deaktivieren.',
	'Prohibit TrackBacks' => 'TrackBacks nicht zulassen',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Empfang von TrackBacks auf allen Sites und Untersites deaktivieren.',
	'Outbound Notifications' => 'Benachrichtigungen',
	'Prohibit Notification Pings' => 'Pings nicht zulassen',
	'Disable notification pings for all sites and child sites.' => 'Benachrichtigung-Pings für alle Sites und Untersites deaktivieren.',
	'Send Outbound TrackBacks to' => 'Ausgehende TrackBacks senden an',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Versenden Sie keine TrackBacks und verwenden Sie kein Auto-Disovery für TrackBacks, wenn Ihre Installation privat sein soll.',
	'(No Outbound TrackBacks)' => '(Kein TrackBack-Versand)',
	'Only to child sites within this system' => 'Nur an Untersites innerhalb dieses Systems',
	'Only to sites on the following domains:' => 'Nur an folgende Domains:',
	'Lockout Settings' => 'Sperr-Einstellungen',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Bitte wählen Sie, welcher Administrator über automatische IP- und Benutzerkonten-Sperrungen informiert werden soll. Wählen Sie keinen Administrator, wird die System-E-Mail-Adresse verwendet.},
	'Clear' => 'zurücksetzen',
	'(None selected)' => '(Kein Blog gewählt)',
	'User lockout policy' => 'Kontensperrung',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Movable Type-Benutzerkonten werden automatisch gesperrt, wenn das zugehörige Passwort binnen [_2] Sekunden mindestens [_1] mal in Folge falsch eingegeben wurde.',
	'IP address lockout policy' => 'IP-Sperrung',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'IP-Liste. Sind nicht zum eigenen Netzwerk gehörende IP-Adressen enthalten, werden fehlgeschlagene Anmeldeversuche über diese nicht aufgezeichnet. Verwenden Sie pro Adresse eine Zeile oder trennen Sie die Adressen mit Kommas.',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'IP-Adresse werden automatisch gesperrt, wenn von ihr binnen [_2] mindestens [_1] ungültige  Anmeldeversuche ausgingen.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Diese IP-Adressen werden nie gesperrt:},
	'Image Quality Settings' => 'Bildqualitäts-Einstellungen',
	'Changing image quality' => 'Bildqualität anpassen',
	'Enable image quality changing.' => 'Anpassung der Bildqualität aktivieren',
	'Image quality(JPEG)' => 'Bildqualität (JPG)',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 75.' => 'Qualitätsstufe, in der hochgeladene JPG-Bilder und die zugehörigen Vorschaubilder gespeichert werden sollen. Die Skala reicht von 0 bis 100. Die Standardstufe ist 75.',
	'Image quality(PNG)' => 'Bildqualität (PNG)',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'Qualitätsstufe, in der hochgeladene PNF-Bilder und die zugehörigen Vorschaubilder gespeichert werden sollen. . Die Skala reicht von 0 bis 9. Die Standardstufe ist 7.',
	'Send Mail To' => 'Mail senden an',
	'The email address that should receive a test email from Movable Type.' => 'Die Adresse, an die Movable Type Testmails verschicken soll.',
	'Send' => 'Absenden',
	'You must set a valid absolute Path.' => 'Bitte geben Sie einen gültigen absoluten Pfad an.',
	'You must set an integer value between 0 and 100.' => 'Bitte geben Sie eine ganze Zahl zwischen 0 und 100 ein.',
	'You must set an integer value between 0 and 9.' => 'Bitte geben Sie iene ganze Zahl zwischen 0 und 9 ein.',

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => 'Registrierung erlauben',
	'Allow commenters to register on this system.' => 'Kommentarautoren ermöglichen, sich selbst zu registrieren.',
	'Notify the following system administrators when a commenter registers:' => 'Folgende Systemadministratoren benachrichtigen, wenn sich ein Kommentarautor registriert hat:',
	'Select system administrators' => 'System-Administrator wählen',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Hinweis: Sie haben noch keine System-E-Mail-Adresse eingerichtet. Benachrichtigungen können daher nicht verschickt werden. Die Adresse kann unter System > Grundeinstellungen eingerichtet werden.',
	'Password Validation' => 'Passwortregeln',
	'Options' => 'Optionen',
	'Should contain uppercase and lowercase letters.' => 'Klein- und Großbuchstaben erforderlich',
	'Should contain letters and numbers.' => 'Buchstaben und Ziffern erforderlich',
	'Should contain special characters.' => 'Sonderzeichen erforderlich',
	'Minimum Length' => 'Mindestlänge',
	'This field must be a positive integer.' => 'Positive ganze Zahl erforderlich.',
	'New User Defaults' => 'Voreinstellungen für neue Benutzer',
	'Default User Language' => 'Standard-Sprache',
	'Default Time Zone' => 'Standard-Zeitzone',
	'Default Tag Delimiter' => 'Standard- Tag-Trennzeichen',
	'Comma' => 'Komma',
	'Space' => 'Leerzeichen',

## tmpl/cms/cfg_web_services.tmpl
	'Data API Settings' => 'Data-API-Einstellungen',
	'Data API' => 'Data-API',
	'Enable Data API in this site.' => 'Data-API für diese Site aktivieren.',
	'Enable Data API in system scope.' => 'Data-API systemweit aktivieren.',
	'External Notifications' => 'Externe Benachrichtigungen',
	'Notify ping services of [_1] updates' => 'Ping-Dienste über [_1]-Aktualisierungen benachrichtigen',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Hinweis: Diese Option ist derzeit nicht wirksam, da ausgehende Pings systemweit deaktiviert sind.',
	'Others:' => 'Andere:',
	'(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',

## tmpl/cms/content_data/select_edit.tmpl

## tmpl/cms/content_data/select_list.tmpl
	'Select List Content Type' => 'Listen-Inhaltstyp wählen',
	'No Content Type.' => 'Kein Inhaltstyp.',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to select multiple assets?' => 'Benutzern erlauben, mehrere Assets auszuwählen?',
	'Minimum number of selections' => 'Mindestauswahl',
	'Maximum number of selections' => 'Höchstauswahl',
	'Allow users to upload a new audio asset?' => 'Benutzern erlauben, neue Audio-Dateien hochzuladen?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => 'Benutzern erlauben, mehrere Bilder auszuwählen?',
	'Allow users to upload a new image asset?' => 'Benutzern erlauben, neue Bilder hochzuladen?',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to upload a new asset?' => 'Benutzern erlauben, neue Assets hochzuladen?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => 'Benutzern erlauben, mehrere Videos auszuwählen?',
	'Allow users to upload a new video asset?' => 'Benutzern erlauben, neue Videos hochzuladen?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to select multiple categories?' => 'Benutzern erlauben, mehrere Kategorien auszuwählen?',
	'Allow users to create new categories?' => 'Benutzern erlauben, neue Kategorien anzulegen?',
	'Source Category Set' => 'Quell-Kategorie-Set',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Values' => 'Werte',
	'Selected' => 'Ausgewählt',
	'Value' => 'Wert',
	'add' => 'Hinzufügen',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => 'Benutzern erlauben, mehrere Werte auszuwählen?',
	'Source Content Type' => 'Quell-Inhaltstyp',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'Keine passenden Inhaltstypen gefunden. Legen Sie einen Inhaltstyp an, um Inhaltstyp-Felder verwenden zu können.',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Anfangswert (Datum)',
	'Initial Value (Time)' => 'Anfangswert (Uhrzeit)',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Anfangswert',

## tmpl/cms/content_field_type_options/embedded_text.tmpl

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => 'Eingabeformat',

## tmpl/cms/content_field_type_options/number.tmpl
	'Min Value' => 'Kleinster Wert',
	'Max Value' => 'Größter Wert',
	'Number of decimal places' => 'Anzahl Dezimalstellen',

## tmpl/cms/content_field_type_options/radio_button.tmpl

## tmpl/cms/content_field_type_options/select_box.tmpl

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Min Length' => 'Kleinste Länge',
	'Max Length' => 'Größte Länge',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Initial Rows' => 'Ursprungsanzahl Reihen',
	'Initial Cols' => 'Ursprungsanzahl Spalten',
	'Allow users to increase/decrease rows?' => 'Benutzern erlauben, die Anzahl der Zeilen zu ändern?',
	'Allow users to increase/decrease cols?' => 'Benutzern erlauben, die Anzahl der Spalten zu ändern?',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to input multiple values?' => 'Benutzern erlauben, mehrere Werte einzugeben?',
	'Allow users to create new tags?' => 'Benutzern erlauben, neue Tags anzulegen?',

## tmpl/cms/content_field_type_options/time.tmpl

## tmpl/cms/content_field_type_options/url.tmpl

## tmpl/cms/dashboard/dashboard.tmpl
	'System Overview' => 'Systemübersicht',
	'Dashboard' => 'Übersichtsseite',
	'Select a Widget...' => 'Widget wählen...',
	'Your Dashboard has been updated.' => 'Übersichtsseite aktualisiert.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Veröffentlichungseinstellungen bestätigen',
	'Site Path' => 'Lokaler Pfad',
	'Please choose parent site.' => 'Bitte wählen Sie die übergeordnete Site.',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Geben Sie die neue Adresse (URL) Ihrer öffentlichen Untersite mit abschließendem '/' ein. Beispiel: http://beispiel.de/blog/},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit \'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Geben Sie die neue Adresse des Archivs Ihrer Untersite an. Beispiel: http://beispiel.de/blog/archiv/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs ohne abschließendes '/' oder  '\' an. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	'Continue (s)' => 'Weiter (s)',
	'Back (b)' => 'Zurück (b)',
	'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an',
	'You must set a valid local site path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an',
	'You must select a parent site.' => 'Bitte wählen Sie eine Übergeordnete Site.',

## tmpl/cms/dialog/asset_edit.tmpl
	'Edit Asset' => 'Asset bearbeiten',
	'Your edited image has been saved.' => 'Das bearbeitete Bild wurde gespeichert.',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'Die Metadaten dieses Bildes sind nicht lesbar und können daher nicht aktualisiert werden.',
	'Error creating thumbnail file.' => 'Fehler beim Erstellen des Vorschaubilds',
	'File Size' => 'Dateigröße',
	'Edit Image' => 'Bild bearbeiten',
	'Save changes to this asset (s)' => 'Änderungen des Assets speichern (s)',
	'Close (x)' => 'Schließen (x)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Dialog wirklich schließen?',
	'Your changes have been saved.' => 'Änderungen gespeichert.',
	'An error occurred.' => 'Es ist ein Fehler aufgetreten.',

## tmpl/cms/dialog/asset_field_insert.tmpl

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Asset hinzufügen',
	'Choose Asset' => 'Asset auswählen',
	'Library' => 'Bibliothek',
	'Next (s)' => 'Nächstes (s)',
	'Insert (s)' => 'Einfügen (s)',
	'Insert' => 'Einfügen',
	'Cancel (x)' => 'Abbrechen (x)',

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
	'Child Site Details' => 'Details der Untersite',
	'This is set to the same URL as the original child site.' => 'Das ist die URL des ursprünglichen Untersite.',
	'This will overwrite the original child site.' => 'Die ursprünglich Untersite wird daher beim Klonen überschrieben.',
	'Exclusions' => 'Ausschließen',
	'Exclude Entries/Pages' => 'Einträge/Seiten ausschließen',
	'Exclude Comments' => 'Kommentare ausschließen',
	'Exclude Trackbacks' => 'TrackBacks ausschließen',
	'Exclude Categories/Folders' => 'Kategorien/Ordner ausschließen',
	'Clone' => 'Klonen',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => 'Achtung: Eine Änderung der Archiv-Adresse kann alle Links in Ihrer Untersite ungültig machen.',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Achtung: Eine Änderung des Archiv-Pfads kann alle Links in Ihrer Untersite ungültig machen.',
	'Entries/Pages' => 'Einträge/Seiten',
	'Categories/Folders' => 'Kategorien/Ordner',
	'Confirm' => 'Bestätigen',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => '[_2] hat am [_1] [_3] kommentiert',
	'Your reply:' => 'Ihre Antwort:',
	'Submit reply (s)' => 'Abschicken (s)',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => '[_1] hinzufügen',
	'Choose [_1]' => '[_1] wählen',
	'Create and Insert' => 'Anlegen und einfügen',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'In dieser MT-Installation ist keine Rolle vorhanden. [_1]Rolle anlegen</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'In dieser MT-Installation ist keine Gruppe vorhanden. [_1]Gruppe anlegen</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'In dieser MT-Installation ist kein Benutzer vorhanden. [_1]Benutzer anlegen</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'In dieser MT-Installation ist kein Blog vorhanden. [_1]Blog anlegen</a>',
	'all' => 'alle',

## tmpl/cms/dialog/create_trigger_select_site.tmpl

## tmpl/cms/dialog/create_trigger.tmpl
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'Wenn <span class="badge source-data-badge">Daten</span> in <span class="badge source-site-badge">Site</span> <span class="badge source-trigger-badge">ausgelöst</span> sind, <span class="badge destination-action-badge">Aktion</span> in <span class="badge destination-site-badge">Site</span> ausführen',
	'Select Trigger Object' => 'Auslöser-Objekt wählen',
	'Object Name' => 'Objektname',
	'Select Trigger Event' => 'Auslöser-Ereignis wählen',
	'Event' => 'Ereignis',
	'Select Trigger Action' => 'Auslöser-Aktion wählen',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',

## tmpl/cms/dialog/dialog_select_group_user.tmpl

## tmpl/cms/dialog/edit_image.tmpl
	'Width' => 'Breite',
	'Height' => 'Höhe',
	'Keep aspect ratio' => 'Seitenverhältnis beibehalten',
	'Remove All metadata' => 'Alle Metadaten entfernen',
	'Remove GPS metadata' => 'GPS-Metadaten entfernen',
	'Rotate right' => 'Nach rechts drehen',
	'Rotate left' => 'Nach links drehen',
	'Flip horizontal' => 'Horizontal spiegeln',
	'Flip vertical' => 'Vertikal spiegeln',
	'Crop' => 'Beschneiden',
	'Undo' => 'Rückgängig',
	'Redo' => 'Wiederholen',
	'Save (s)' => 'Sichern (s)',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Ihre Änderungen an diesem Bild wurden noch nicht gespeichert und gehen verloren. Dialog wirklich schließen?',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Benachrichtigung versenden',
	'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{Benachrichtigungen beinhalten den Namen Ihres Blogs bzw. Ihrer Website, den Titel des und einen Link zum Eintrag. Optional können Sie auch eine eigene Nachricht und/oder einen Auszug des Eintrags oder den gesamten Eintragstext mitschicken.},
	'Recipients' => 'Empfänger',
	'Enter email addresses on separate lines or separated by commas.' => 'Verwenden Sie pro Adresse eine Zeile oder trennen Sie ei E-Mail-Adressen mit Kommata.',
	'All addresses from Address Book' => 'Alle Adressen aus dem Adressbuch',
	'Optional Message' => 'Nachricht (optional)',
	'Optional Content' => 'Inhalt (optional)',
	'(Body will be sent without any text formatting applied.)' => '(Der Eintragstext wird ohne Textformatierungen verschickt.)',
	'Send notification (s)' => 'Benachrichtigung absenden (s)',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Wählen Sie die gewünschte frühere Version aus.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Insert Options' => 'Einfüge-Optionen',
	'Display [_1]' => '[_1] anzeigen',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Passwort ändern',
	'Enter the new password.' => 'Neues Passwort eingeben',
	'New Password' => 'Neues Passwort',
	'Confirm New Password' => 'Neues Passwort bestätigen',
	'Change' => 'Ändern',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Veröffentlichungsprofil',
	'child site' => 'Untersite',
	'site' => 'Site',
	'Choose the profile that best matches the requirements for this [_1].' => 'Wählen Sie das Profil, das Ihren Anforderungen  am besten entspricht.',
	'Static Publishing' => 'Statische Veröffentlichung',
	'Immediately publish all templates statically.' => 'Alle Vorlagen sofort statisch veröffentlichen.',
	'Background Publishing' => 'Veröffentlichung im Hintergrund',
	'All templates published statically via Publish Queue.' => 'Alle Vorlagen im Hintergrund statisch veröffentlichen.',
	'High Priority Static Publishing' => 'Priorisierte statische Veröffentlichung',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Hauptindex, Eintragsarchiv und Seitenarchiv sofort statisch, alle anderen Vorlagen im Hintergrund statisch veröffentlichen.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Hauptindex und Seitenarchiv sofort statisch, alle anderen Vorlagen im Hintergrund statisch veröffentlichen.',
	'Dynamic Publishing' => 'Dynamische Veröffentlichung',
	'Publish all templates dynamically.' => 'Alle Vorlagen dynamisch veröffentlichen.',
	'Dynamic Archives Only' => 'Nur Archiv dynamisch',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle Archiv-Vorlagen dynamisch, alle anderen Vorlagen sofort statisch veröffentlichen.',
	'This new publishing profile will update your publishing settings.' => 'Das neue Veröffentlichungs-Profil ändert Ihre Veröffentlichungs-Einstellungen.',
	'Are you sure you wish to continue?' => 'Wirklich fortsetzen?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'Passwort zurücksetzen',
	'The email address provided is not unique.  Please enter your username.' => 'Die angegebene E-Mail-Adresse wird mehrfach genutzt. Bitte geben Sie stattdessen Ihren Benutzernamen ein.',
	'Back (x)' => 'Zurück (x)',
	'Sign in to Movable Type (s)' => 'Bei Movable Type anmelden (s)',
	'Sign in to Movable Type' => 'Bei Movable Type anmelden',
	'Reset (s)' => 'Zurücksetzen (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Globale Vorlagen zurücksetzen',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Kann Vorlagengruppe nicht finden. Bitte wenden Sie das [_1]Thema[_2] an, um Ihre Vorlagen zurückzusetzen.',
	'Revert modifications of theme templates' => 'Änderungen an Themen-Vorlagen zurücknehmen',
	'Reset to theme defaults' => 'Auf Themen-Standardwerte zurücksetzen',
	q{Deletes all existing templates and install the selected theme's default.} => q{Alle Vorlagen löschen und Standarvorlagen des gewählten Themas installieren.},
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
	'An error occurred during the import process: [_1] Please check your import file.' => 'Während des Importvorgangs ist ein Fehler aufgetreten. Bitte überprüfen Sie Ihre Importdatei.',
	'View Activity Log (v)' => 'Aktivitätsprotokoll ansehen (v)',
	'All data imported successfully!' => 'Alle Daten erfolgreich importiert!',
	'Close (s)' => 'Schließen (s)',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Diese Seite leitet in drei Sekunden auf eine neue Seite weiter. [_1]Weiterleitung abbrechen[_2].',
	'Next Page' => 'Nächste Seite',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importieren...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Wiederherstellung mehrerer Dateien',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Abbrechen führt zu verwaisten Objekten. Wiederherstellung wirklich abbrechen?',
	'Please upload the file [_1]' => 'Bitte laden Sie die Datei [_1] hoch',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to user' => 'Nutzer Berechtigungen für diese Site zuweisen',
	'Grant site permission to group' => 'Gruppe Berechtigungen für diese Site zuweisen',

## tmpl/cms/dialog/start_create_trigger.tmpl
	'You must select Object Type.' => 'Bitte wählen Sie einen Objekttyp.',
	'You must select Content Type.' => 'Bitten wählen Sie einen Inhaltstyp',
	'You must select Event.' => 'Bitte wählen Sie ein Ereignis.',
	'Object Type' => 'Objekttyp',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Stats' => 'Statistik',
	'[_1] - Created by [_2]' => 'Angelegt von [_2] [_1]',
	'[_1] - Modified by [_2]' => '[_1] - Bearbeitet von [_2]',
	'Appears in...' => 'Verwendet in...',
	'This asset has been used by other users.' => 'Das Asset wird von anderen Benutzern verwendet.',
	'Related Assets' => 'Verwandte Assets',
	'Prev' => 'Zurück',
	'[_1] is missing' => '[_1] fehlt',
	'Embed Asset' => 'Asset einbetten',
	'You must specify a name for the asset.' => 'Bitte geben Sie einen Namen für das Asset an.',
	'You have unsaved changes to this asset that will be lost.' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Möchten Sie das Bild wirklich bearbeiten?',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Profil bearbeiten',
	'This profile has been updated.' => 'Profil aktualisiert',
	'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an [_1] verschickt.',
	'This profile has been unlocked.' => 'Benutzerkonto entsperrt',
	'This user was classified as pending.' => 'Benutzer auf wartend gesetzt.',
	'This user was classified as disabled.' => 'Benutzerkonto deaktiviert.',
	'This user was locked out.' => 'Benutzerkonto gesperrt',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Um dieses Benutzerkonto zu entsperren, klicken Sie auf 'Entsperren'. <a href="[_1]">Entsperren</a>},
	'User properties' => 'Benutzer-Eigenschaften',
	'Your web services password is currently' => 'Ihr Passwort für Webdienste lautet derzeit',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Dazu wird ein zufällig erzeugtes neues Passwort per E-Mail an [_2] verschickt werden.\n\nForsetzen?',
	'Error occurred while removing userpic.' => 'Beim Entfernen des Benutzerbildes ist ein Fehler aufgetreten',
	'_USER_STATUS_CAPTION' => 'Status',
	'_USER_ENABLED' => 'Aktiviert',
	'_USER_PENDING' => 'Schwebend',
	'_USER_DISABLED' => 'Deaktiviert',
	'External user ID' => 'Externe Benutzer-ID',
	'The name displayed when content from this user is published.' => 'Der Name, der zusammen mit Inhalten dieses Benutzers angezeigt werden soll.',
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Die Website dieses Benutzers (z.B. https://movabletype.com/). Ist sowohl dieses als auch das Feld &#8222;Anzeigename&#8220; ausgefüllt, erzeugt Movable Type daraus per Voreinstellung einen Link zur angebenen Website und zeigt diesen unter Einträgen und Kommentaren des Benutzers an.},
	'Select Userpic' => 'Benutzerbild wählen',
	'Remove Userpic' => 'Benutzerbild entfernen',
	'Current Password' => 'Derzeitiges Passwort',
	'Initial Password' => 'Passwort',
	'Enter preferred password.' => 'Bevorzugtes Passwort eingeben',
	'Confirm Password' => 'Passwort bestätigen',
	'Password recovery word/phrase' => 'Erinnerungssatz',
	'Preferences' => 'Konfigurieren',
	'Display language for the Movable Type interface.' => 'Anzeigesprache der Movable Type-Benutzeroberfläche',
	'Text Format' => 'Textformatierung',
	'Default text formatting filter when creating new entries and new pages.' => 'Standard-Textfilter beim Erstellen neuer Seiten und Einträge',
	'(Use Site Default)' => '(Site-Standardwerte verwenden)',
	'Date Format' => 'Zeit- angaben',
	'Default date formatting in the Movable Type interface.' => 'Standard-Datums-Formatierung in der Movable Type-Oberfläche',
	'Relative' => 'Relativ',
	'Full' => 'Absolut',
	'Tag Delimiter' => 'Tag-Trennzeichen',
	'Preferred method of separating tags.' => 'Bevorzugtes Trennzeichen für Tags',
	'Web Services Password' => 'Passwort für Webdienste',
	'Reveal' => 'Anzeigen',
	'System Permissions' => 'Berechtigungen',
	'Create User (s)' => 'Benutzerkonto anlegen (s)',
	'Save changes to this author (s)' => 'Kontoänderungen speichern (s)',
	'_USAGE_PASSWORD_RESET' => 'Hier können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufälliges neues Passwort erzeugt und an <strong>[_1]</strong> verschickt werden.',
	'Initiate Password Recovery' => 'Passwort wiederherstellen',
	'You must use half-width character for password.' => 'Bitte verwenden Sie für das Passwort halbbreite Zeichen.',

## tmpl/cms/edit_blog.tmpl
	'Your child site configuration has been saved.' => 'Die Einstellungen der Untersite wurden gespeichert.',
	'You must set your Local Site Path.' => 'Bitte geben Sie den lokalen Pfad der Site an.',
	'Site Theme' => 'Site-Thema',
	'Select the theme you wish to use for this child site.' => 'Wählen Sie das Thema, das Sie für diese Untersite verwenden möchten.',
	'Name your child site. The site name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre Untersite. Sie könnten ihn später jederzeit ändern.',
	'Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Geben Sie die Web-Adresse (URL) Ihrer Untersite ohne Dateinamen (z.B. index.html) ein. Beispiel: http://beispiel.de/',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' or '\' und möglichst in absoluter Form, also am Anfang unter Linux mit '/' oder mit 'C:\' unter Windows. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'Zeitzone des Weblogs',
	'Create Child Site (s)' => 'Untersite anlegen (s)',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Kategorie bearbeiten',
	'Useful links' => 'Nützliche Links',
	'Manage entries in this category' => 'Einträge in dieser Kategorie verwalten',
	'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
	'You must specify a basename for the category.' => 'Geben Sie einen Basisnamen für die Kategorie an.',
	'Please enter a valid basename.' => 'Bitte geben Sie einen gültigen Basisnamen ein.',
	'_CATEGORY_BASENAME' => 'Basisname',
	'This is the basename assigned to your category.' => 'Der dieser Kategorie zugewiesene Basisname',
	q{Warning: Changing this category's basename may break inbound links.} => q{Achtung: Änderungen des Basisnamens können bestehende externe Links auf diese Kategorieseite ungültig machen},
	'Inbound TrackBacks' => 'TrackBack-Empfang',
	'Allow pings' => 'Pings erlauben',
	'View TrackBacks' => 'TrackBacks ansehen',
	'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
	'Passphrase Protection' => 'Passphrasenschutz',
	'Outbound TrackBacks' => 'TrackBack-Versand',
	'Trackback URLs' => 'TrackBack-URLs',
	'Save changes to this category (s)' => 'Kategorieänderungen speichern (s)',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Kommentarautor-Details',
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
	'View all comments with this name' => 'Alle Kommentare mit diesem Autorennamen anzeigen',
	'Identity' => 'Identität',
	'View' => 'Ansehen',
	'Withheld' => 'Zurückgehalten',
	'View all comments with this email address' => 'Alle Kommentare von dieser E-Mail-Adresse anzeigen',
	'Trusted' => 'vertraut',
	'Banned' => 'Gesperrt',
	'Authenticated' => 'Authentifiziert',

## tmpl/cms/edit_comment.tmpl
	'Edit Comment' => 'Kommentar bearbeiten',
	'The comment has been approved.' => 'Kommentar freigeschaltet.',
	'This comment was classified as spam.' => 'Kommentar als Spam mariert.',
	'Total Feedback Rating: [_1]' => 'Gesamtbewertung: [_1]',
	'Test' => 'Test',
	'Score' => 'Bewertung',
	'Results' => 'Treffer',
	'Save changes to this comment (s)' => 'Kommentaränderungen speichern (s)',
	'comment' => 'Kommentar',
	'comments' => 'Kommentare',
	'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
	'Manage Comments' => 'Kommentare verwalten',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'Zeige [_1] Kommentar zu',
	'Reply to this comment' => 'Kommentar beantworten',
	'Approved' => 'Freigeschaltet',
	'Unapproved' => 'Nicht freigeschaltet',
	'Reported as Spam' => 'Als Spam gemeldet',
	'View all comments with this status' => 'Alle Kommentare mit diesem Status anzeigen',
	'Commenter' => 'Kommentarautor',
	'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentarautor anzeigen',
	'Commenter Status' => 'Kommentarautoren-Status',
	'View this commenter detail' => 'Details zum Kommentarautoren anzeigen',
	'Untrust Commenter' => 'Kommentarautor nicht mehr vertrauen',
	'Ban Commenter' => 'Kommentarautor sperren',
	'Trust Commenter' => 'Kommentarautor vertrauen',
	'Unban Commenter' => 'Kommentarautor nicht mehr sperren',
	'Unavailable for OpenID user' => 'Nicht verfügbar für OpenID-Nutzer',
	'No url in profile' => 'Keine URL im Profil',
	'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
	'[_1] no longer exists' => '[_1] existiert nicht mehr',
	'View all comments on this [_1]' => 'Alle Kommentare zu diesem Eintrag oder dieser Seite',
	'View all comments created on this day' => 'Alle Kommentare dieses Tages anzeigen',
	'View all comments from this IP Address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
	'Comment Text' => 'Kommentartext',
	'Responses to this comment' => 'Reaktionen auf diesen Kommentar',

## tmpl/cms/edit_content_data.tmpl
	'You have successfully recovered your saved content data.' => 'Gespeicherte Inhaltsdaten erfolgreich wiederhergestellt.',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Inhaltsdaten automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'An error occurred while trying to recover your saved content data.' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'This [_1] has been saved.' => '[_1] gespeichert.',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Weitere(s) [_2] anlegen?</a>',
	'Revision: <strong>[_1]</strong>' => 'Revision <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Revisionen dieser/dieses [_1] anzeigen',
	'View revisions' => 'Revisionen anzeigen',
	'No revision(s) associated with this [_1]' => 'Keine Revision(en) mit dieser/diesem [_1] verknüpft',
	'Publish this [_1]' => '[_1] veröffentlichen',
	'Draft this [_1]' => '[_1] als Entwurf speichern',
	'Schedule' => 'Zeitplan',
	'Update' => 'Aktualisieren',
	'Update this [_1]' => '[_1] aktualisieren',
	'Unpublish this [_1]' => '[_1] nicht mehr veröffentlichen',
	'Save this [_1]' => '[_1] speichern',
	'You must configure this blog before you can publish this content data.' => 'Bitte konfigurieren Sie das Blog, bevor Sie diesen Inhalt veröffentlichen.',
	'Unpublished (Draft)' => 'Unveröffentlicht (Entwurf)',
	'Unpublished (Review)' => 'Unveröffentlicht (Prüfung)',
	'Unpublished (Spam)' => 'Unveröffentlicht (Spam)',
	'Publish On' => 'Veröffentlichen um',
	'Published Time' => 'Zeitpunkt der Veröffentlichung',
	'Unpublished Date' => 'Zeitpunkt der Zurückziehung',
	'Unpublished Time' => 'Zeitpunkt der Zurückziehung',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	q{Warning: Changing this content data's basename may break inbound links.} => q{Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links ungültig werden},
	'Change note' => 'Änderungshinweis',
	'You must configure this blog before you can publish this entry.' => 'Bitte konfigurieren Sie das Blog, bevor Sie einen Eintrag veröffentlichen.',
	'You must configure this blog before you can publish this page.' => 'Bitte konfigurieren Sie das Blog, bevor Sie eine Seite veröffentlichen.',
	'Permalink:' => 'Permalink:',
	'Enter a label to identify this data' => 'Geben Sie eine Bezeichnung für diese Daten ein',
	'(Min length: [_1] / Max length: [_2])' => '(Mindestlänge [_1], Höchstlänge [_2])',
	'(Min length: [_1])' => '(Mindestlänge [_1])',
	'(Max length: [_1])' => '(Höchstlänge [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min [_1], max [_2], [_3] Dezimalstellen)',
	'(Min: [_1] / Max: [_2])' => '(Min [_1], max [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min [_1], [_2] Dezimalstellen)',
	'(Min: [_1])' => '(Min: [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max [_1], [_2] Dezimalstellen)',
	'(Max: [_1])' => '(Max [_1])',
	'(Number of decimal places: [_1])' => '([_1] Dezimalstellen)',
	'(Min select: [_1] / Max select: [_2])' => '(Min [_1], max [_2] wählen)',
	'(Min select: [_1])' => '(Min [_1] wählen)',
	'(Max select: [_1])' => '(Max [_1] wählen',
	'(Min tags: [_1] / Max tags: [_2])' => '(Min [_1], max [_2] Tags)',
	'(Min tags: [_1])' => '(Min [_1] Tags)',
	'(Max tags: [_2])' => '(Max [_2] Tags)',
	'One tag only' => '(Genau 1 Tag)',
	'@' => '@',
	'Not specified' => 'Nicht angegeben',
	'Auto-saving...' => 'Autospeichern...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Zuletzt automatisch gespeichert um [_1]:[_2]:[_3]',

## tmpl/cms/edit_content_type.tmpl
	'Edit Content Type' => 'Inhaltstyp bearbeiten',
	'Contents type settings has been saved.' => 'Inhaltstyp-Einstellungen gespeichert.',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'Einige Inhaltsfelder wurden nicht gelöscht. Bitte entfernen Sie zuerst ihre Archiv-Verknüpfungen.',
	'Available Content Fields' => 'Verfügbare Inhaltsfelder',
	'Unavailable Content Fields' => 'Nicht verfügbare Inhaltsfelder',
	'Reason' => 'Grund',
	'1 or more label-value pairs are required' => 'Mindestens ein Bezeichnung-Wert-Paar erforderlich',
	'This field must be unique in this content type' => 'Dieses Feld kann in diesem Inhaltstyp nur ein Mal verwendet werden',

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Diese [_1] speichern (s)',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Seite bearbeiten',
	'Create Page' => 'Seite anlegen',
	'Add new folder parent' => 'Neuen Eltern-Ordner hinzufügen',
	'Preview this page (v)' => 'Vorschau (v)',
	'Delete this page (x)' => 'Seite löschen (x)',
	'View Page' => 'Seite ansehen',
	'Edit Entry' => 'Eintrag bearbeiten',
	'Create Entry' => 'Neuen Eintrag schreiben',
	'Category Name' => 'Kategoriename',
	'Add new category parent' => 'Neue Eltern-Kategorie hinzufügen',
	'Manage Entries' => 'Einträge verwalten',
	'Preview this entry (v)' => 'Vorschau (v)',
	'Delete this entry (x)' => 'Eintrag löschen (x)',
	'View Entry' => 'Eintrag ansehen',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Eintrag automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Seite automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
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
	'This post was held for review, due to spam filtering.' => 'Dieser Eintrag wurde vom Spam-Filter zur Moderation zurückgehalten.',
	'This post was classified as spam.' => 'Dieser Eintrag wurde als Spam erfasst.',
	'Add folder' => 'Ordner hinzufügen',
	'Change Folder' => 'Ordner wechseln',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	q{Warning: Changing this entry's basename may break inbound links.} => q{Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links zu diesem Eintrag ungültig werden.},
	'Add category' => 'Kategorie hinzufügen',
	'edit' => 'Bearbeiten',
	'Accept' => 'Annehmen',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
	'Outbound TrackBack URLs' => 'TrackBack- URLs',
	'[_1] Assets' => '[_1] Assets',
	'Add Entry Asset' => 'Eintrags-Asset hinzufügen',
	'No assets' => 'Keine Assets',
	'You have unsaved changes to this entry that will be lost.' => 'Es liegen nicht gespeicherte Eintragsänderungen vor, die verloren gehen werden.',
	'Enter the link address:' => 'Link-Adresse eingeben:',
	'Enter the text to link to:' => 'Link-Text eingeben:',
	'Converting to rich text may result in changes to your current document.' => 'Wandlung in Rich Text kann ihre bisherigen Formatierungen beeinträchtigen.',
	'Make primary' => 'Als Hauptkategorie',
	'Fields' => 'Felder',
	'Reset display options to blog defaults' => 'Anzeigeoptionen auf Standardeinstellungen zurücksetzen',
	'Draggable' => 'Klick- und ziehbar',
	'Share' => 'Teilen',
	'Format:' => 'Formatierung:',
	'Rich Text(HTML mode)' => 'Rich Text (HTML-Modus)', # Translate - New # OK
	'(comma-delimited list)' => '(Liste mit Kommatrennung)',
	'(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
	q{(delimited by '[_1]')} => q{(Trennung durch &#8222;[_1]&#8220;)},
	'None selected' => 'Keine gewählt',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Ordner bearbeiten',
	'Manage Folders' => 'Ordner verwalten',
	'Manage pages in this folder' => 'Seiten in diesem Ordner verwalten',
	'You must specify a label for the folder.' => 'Sie müssen diesem Ordner eine Bezeichnung geben',
	'Path' => 'Pfad',
	'Save changes to this folder (s)' => 'Ordneränderungen speichern (s)',

## tmpl/cms/edit_group.tmpl
	'Edit Group' => 'Gruppe bearbeiten',
	'This group profile has been updated.' => 'Gruppenprofil aktualisiert.',
	'This group was classified as pending.' => 'Gruppe auf wartend gesetzt.',
	'This group was classified as disabled.' => 'Gruppe deaktiviert.',
	'Member ([_1])' => 'Mitglied ([_1])',
	'Members ([_1])' => 'Mitglieder ([_1])',
	'Permission ([_1])' => 'Berechtigung ([_1])',
	'Permissions ([_1])' => 'Berechtigungen ([_1])',
	'LDAP Group ID' => 'LDAP-Gruppen-ID',
	'The LDAP directory ID for this group.' => 'Die ID dieser Gruppe im LDAP-Verzeichnis',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'Systemweiter Gruppenstatus. Die Deaktivierung einer Gruppe entzieht ihren Mitgliedern den Zugang zum System. Inhalte und Nutzungsverläufe der Mitglieder bleiben jedoch erhalten.',
	'The name used for identifying this group.' => 'Der zur Idenfifizierung diesser Gruppe verwendete Name',
	'The display name for this group.' => 'Der Anzeigename dieser Gruppe',
	'The description for this group.' => 'Die Beschreibung dieser Gruppe.',
	'Created By' => 'Erstellt von',
	'Created On' => 'Angelegt',
	'Save changes to this field (s)' => 'Feld-?nderungen speichern (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'TrackBack bearbeiten',
	'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
	'This trackback was classified as spam.' => 'TrackBack als Spam markiert.',
	'Save changes to this TrackBack (s)' => 'TrackBack-Änderungen speichern (s)',
	'Delete this TrackBack (x)' => 'Diesen TrackBack löschen (x)',
	'Manage TrackBacks' => 'TrackBacks verwalten',
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

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Rolle bearbeiten',
	'Association (1)' => 'Verknüpfung (1)',
	'Associations ([_1])' => 'Verknüpfungen ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Sie haben die Berechtigungen dieser Rolle geändert. Dadurch werden auch die Berechtigungen der mit dieser Rolle verknüpften Benutzer beeinflusst. Wenn Sie möchten, können Sie daher die Rolle unter neuem Namen speichern.',
	'Role Details' => 'Rolleneigenschaften',
	'Privileges' => 'Berechtigungen',
	'Administration' => 'Verwalten',
	'Authoring and Publishing' => 'Schreiben und veröffentlichen',
	'Designing' => 'Gestalten',
	'Commenting' => 'Kommentieren',
	'Content Type Privileges' => 'Berechtigungen für Inhaltstyp',
	'Duplicate Roles' => 'Rollen duplizieren',
	'Save changes to this role (s)' => 'Rollenänderungen speichern (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Widget bearbeiten',
	'Create Index Template' => 'Indexvorlage anlegen',
	'Create Entry Archive Template' => 'Vorlage für Eintrags-Archiv anlegen',
	'Create Entry Listing Archive Template' => 'Vorlage für Eintrags-Listenarchiv anlegen',
	'Create Page Archive Template' => 'Vorlage für Seiten-Archiv anlegen',
	'Create Content Type Archive Template' => 'Vorlage für Inhaltstyp-Archiv anlegen',
	'Create Content Type Listing Archive Template' => 'Vorlage für Inhaltstyp-Listenarchiv anlegen',
	'Create Template Module' => 'Vorlagenmodul anlegen',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => '[_1] automatisch gespeichert [_3]. <a href="[_2]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'You have successfully recovered your saved [_1].' => 'Gespeicherte Fassung erfolgreich wiederhergestellt.',
	'An error occurred while trying to recover your saved [_1].' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'Restored revision (Date:[_1]).' => 'Revision wiederhergestellt (Datum: [_1])',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'Vorlage <a href="[_1]" class="rebuild-link">veröffentlichen</a>.',
	'Your [_1] has been published.' => '[_1] wurde veröffentlicht.',
	'New Template' => 'Neuer Vorlage',
	'View revisions of this template' => 'Revisionen dieser Vorlage anzeigen',
	'No revision(s) associated with this template' => 'Keine Revision(en) mit dieser Vorlage verknüpft',
	'Useful Links' => 'Nützliche Links',
	'List [_1] templates' => 'Zeige [_1]-Vorlagen',
	'List all templates' => 'Zeige alle Vorlagen',
	'Module Option Settings' => 'Moduloption-Einstellungen',
	'View Published Template' => 'Veröffentlichte Vorlage ansehen',
	'Included Templates' => 'Eingebundene Vorlagen',
	'create' => 'anlegen',
	'Copy Unique ID' => 'Eindeutige ID kopieren',
	'Content field' => 'Inhaltsfeld',
	'Select Content Field' => 'Inhaltsfeld wählen',
	'Create a new Content Type?' => 'Neuen Inhaltstyp anlegen?',
	'Save Changes (s)' => 'Änderungen speichern (s)',
	'Save and Publish this template (r)' => 'Vorlage speichern und veröffentlichen (r)',
	'Save &amp; Publish' => 'Speichern und veröffentlichen',
	'You have unsaved changes to this template that will be lost.' => 'Es liegen nicht gespeicherte Vorlagenänderungen, die verloren gehen werden.',
	'You must set the Template Name.' => 'Bitte geben Sie einen Vorlagennamen ein.',
	'You must select the Content Type.' => 'Bitte wählen Sie einen Inhaltstyp.',
	'You must set the template Output File.' => 'Bitte geben Sie Namen für die Ausgabedatei ein.',
	'Module Body' => 'Modul-Code',
	'Template Body' => 'Vorlagen-Code',
	'Code Highlight' => 'Code farbig darstellen',
	'Template Type' => 'Vorlagen-Typ',
	'Custom Index Template' => 'Individuelle Indexvorlage',
	'Link to File' => 'Mit Datei verlinken',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">Mehr über Veröffentlichungs-Einstellungen erfahren</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => '<a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Mehr über das Erstellen von Archivpfaden erfahren',
	'Category Field' => 'Kategorie-Feld',
	'Date & Time Field' => 'Datums-/Uhrzeit-Feld',
	'Create Archive Mapping' => 'Neue Archiv-Verknüpfung einrichten',
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
	'Processing request...' => 'Verarbeite Anfrage...',
	'Error occurred while updating archive maps.' => 'Bei der Aktualisierung der Archiv-Verknüpfungen ist ein Fehler aufgetreten.',
	'Archive map has been successfully updated.' => 'Archiv-Verknüpfung erfolgreich aktualisiert.',
	'Are you sure you want to remove this template map?' => 'Archiv-Verknüpfung wirklich löschen?',

## tmpl/cms/edit_website.tmpl
	'Your site configuration has been saved.' => 'Die Site-Einstellungen wurden gespeichert.',
	'Select the theme you wish to use for this site.' => 'Wählen Sie das Thema, das Sie für diese Site verwenden möchten.',
	'Name your site. The site name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre SIte. Sie können ihn später jederzeit ändern.',
	'Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Geben Sie die Web-Adresse (URL) Ihrer Site ohne Dateinamen (z.B. index.html) ein. Beispiel: http://beispiel.com/',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Geben Sie den Pfad an, unter dem die Startseiten-Datei abgelegt werden soll. Optimal ist eine Angabe in absoluter Form, also unter Linux mit '/' oder unter Windows mit 'C:\' am Anfang, aber eine relative Angabe ist auch möglich. Beispiel: /home/melody/public_html/ oder C:\www\public_htm},
	'Create Site (s)' => 'Site anlegen (s)',
	'This field is required.' => 'Feld erforderlich.',
	'Please enter a valid URL.' => 'Bitte geben Sie eine gültige Adresse ein.',
	'Please enter a valid site path.' => 'Bitte geben Sie einen gültigen Site-Pfad ein.',
	'You did not select a timezone.' => 'Bitte wählen Sie einen Zeitzone',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Widgetgruppe bearbeiten',
	'Widget Set Name' => 'Name der Widgetgruppe',
	'Save changes to this widget set (s)' => 'Widgetänderungen speichern (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Ziehen Sie die Widgets, die in diese Widgetgruppe gehören, in die Spalte &#8222;Installierte Wigets&#8220;.},
	'Available Widgets' => 'Verfügbare Widgets',
	'Installed Widgets' => 'Installierte Widgets',
	'You must set Widget Set Name.' => 'Bitte wählen Sie einen Namen für die Widgetgruppe.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Es ist ein Fehler aufgetreten',

## tmpl/cms/export_theme.tmpl
	'Theme package have been saved.' => 'Themenpaket gespeichert.',
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Verwenden Sie bitte nur Buchstaben, Zahlen, Bindestriche oder Unterstriche (a-z, A-Z, 0-9, &#8222;-&#8220; oder &#8222;_&#8220;).},
	'Version' => 'Version',
	'_THEME_AUTHOR' => 'Autor',
	'Author link' => 'Autoren-Link',
	'Destination' => 'Ziel',
	'Setting for [_1]' => 'Einstellungen für [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Basisnamen müssen mit einem Buchstaben anfangen und dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => 'Das Thema kann nicht mit diesem Basisnamen installiert, da dieser bereits vorhanden und geschützt ist.',
	'You must set Theme Name.' => 'Bitte geben Sie einen Namen für das Thema ein.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Versionsnamen dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => '[_1] Einträge exportieren',
	'[_1] to Export' => 'Zu exportierende [_1]',
	'_USAGE_EXPORT_1' => 'Hier können Sie die Einträge, Kommentare und TrackBacks eines Blogs exportieren. Ein Export stellt <em>keine</em> komplette Sicherung eines Blogs dar. Verwenden Sie dafür die Funktion Sichern/Wiederherstellen.',
	'Export [_1]' => '[_1] exportieren',

## tmpl/cms/field_html/field_html_asset.tmpl
	'No Assets' => 'Keine Assets',
	'No Asset' => 'Kein Asset',
	'Assets less than or equal to [_1] must be selected' => 'Wählen Sie höchstens [_1] Assets',
	'Assets greater than or equal to [_1] must be selected' => 'Wählen Sie mindestens [_1] Assets',
	'Only 1 asset can be selected' => 'Wählen Sie genau ein Asset',

## tmpl/cms/field_html/field_html_categories.tmpl
	'This field is disabled because valid Category Set is not selected in this field.' => 'Dieses Feld ist deaktiviert, da kein gültiges Kategorie-Set gewählt wurde.',
	'Add sub category' => 'Unterkategorie hinzufügen',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No field data.' => 'Keine Feld-Daten.', # Translate - New # OK
	'No [_1]' => 'Kein [_1]',
	'This field is disabled because valid Content Type is not selected in this field.' => 'Dieses Feld ist deaktivieren, da kein gültiger Inhaltstyp gewählt wurde.',
	'[_1] less than or equal to [_2] must be selected' => 'Wählen Sie höchstens [_1] [_2]',
	'[_1] greater than or equal to [_2] must be selected' => 'Wählen Sie mindestens [_1] [_2]',
	'Only 1 [_1] can be selected' => 'Wählen Sie genau ein [_1]',

## tmpl/cms/field_html/field_html_datetime.tmpl

## tmpl/cms/field_html/field_html_list.tmpl

## tmpl/cms/field_html/field_html_multi_line_text.tmpl

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'Nicht ausgewählt',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML-Code am Überschriftenanfang (optional)',
	'End title HTML (optional)' => 'HTML-Code am Überschriftenende (optional)',
	'Default entry status (optional)' => 'Standard-Eintragsstatus (optional)',
	'Select an entry status' => 'Eintragsstatus wählen',

## tmpl/cms/import.tmpl
	'Import [_1] Entries' => '[_1] Einträge importieren',
	'You must select a site to import.' => 'Wählen Sie die zu importierende Site',
	'Enter a default password for new users.' => 'Geben Sie ein Standard-Passwort für neue Benutzer ein.',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Übernehmen Sie mit der Import-Funktion Einträge aus anderen Movable-Type-Installationen oder sogar anderen Blog-Systemen. Exportieren Sie Ihre Einträge, um ein Backup oder eine Kopie anzulegen.',
	'Import data into' => 'Daten importieren in',
	'Select site' => 'Site auswählen',
	'Importing from' => 'Importieren aus',
	'Ownership of imported entries' => 'Besitzer importierter Einträge',
	'Import as me' => 'Einträge unter meinem Namen importieren',
	'Preserve original user' => 'Einträge unter ursprünglichen Namen importieren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Benutzernamen importieren und einer oder mehrere der Benutzer in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
	'Default password for new users:' => 'Standard-Passwort für neue Benutzer:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Alle importierten Einträge werden Ihnen zugewiesen werden. Wenn Sie möchten, daß die Einträge ihren ursprünglichen Benutzern zugewiesen bleiben, lassen Sie den Import von Ihren Administrator durchführen. Dann werden etwaige erforderliche, aber noch fehlende Benutzerkonten automatisch angelegt.',
	'Upload import file (optional)' => 'Import-Datei hochladen (optional)',
	'Apply this formatting if text format is not set on each entry.' => 'Diese Formatierung verwenden wenn Format nicht in jedem Eintrag einzeln angegeben',
	'Import File Encoding' => 'Zeichenkodierung der Importdatei',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Standard-Kategorie für Einträge (optional)',
	'Select a category' => 'Kategorie auswählen...',
	'Import Entries (s)' => 'Einträge importieren (s)',
	'Import Entries' => 'Einträge importieren',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Kommentare von unbekannten und nicht authentifizierten Benutzern annehmen.',
	'Require name and E-mail Address for Anonymous Comments' => 'E-Mail-Adresse von nicht registrierten Kommentarautoren verlangen',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn diese Option aktiv ist, müssen Kommentarautoren eine gültige E-Mail-Adresse angeben.',

## tmpl/cms/include/archetype_editor_multi.tmpl
	'Decrease Text Size' => 'Kleinerer Text',
	'Increase Text Size' => 'Größerer Text',
	'Bold' => 'Fett',
	'Italic' => 'Kursiv',
	'Underline' => 'Unterstreichen',
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
	'Insert Image' => 'Bild einfügen',
	'Insert File' => 'Datei einfügen',
	'WYSIWYG Mode' => 'Grafischer Editor',
	'HTML Mode' => 'HTML-Modus',

## tmpl/cms/include/archetype_editor.tmpl
	'Text Color' => 'Textfarbe',
	'Check Spelling' => 'Rechtschreibung prüfen',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Einklappen',

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Eine Datei namens &#8222;[_1]&#8220; ist bereits vorhanden. Möchten Sie sie überschreiben?},
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	'No' => 'Nein',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Gewählte Assets löschen (x)',
	'Size' => 'Größe',
	'Asset Missing' => 'Asset fehlt',
	'No thumbnail image' => 'Kein Vorschaubild',

## tmpl/cms/include/asset_upload.tmpl
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Veröffentlichen Sie zuerst Ihr(e) [_1], um Dateien hochladen zu können. [_2]Konfigurieren Sie die jeweiligen Veröffentlichungs-Pfade[_3] und veröffentlichen Sie die Site bzw. das Blog dann erneut. },
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Um Dateien hochladen zu können, muss Ihr System- oder [_1]-Administrator die Site bzw. das Blog bereits veröffentlicht haben. Bitte kontaktieren Sie daher ihren System- oder [_1]-Administrator.',
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Auf '[_1]' kann nicht geschrieben werden. Sie können Bilder hochladen, aber es werden keine Vorschaubilder erzeugt.},
	q{Asset file('[_1]') has been uploaded.} => q{Asset-Datei (&#8222;[_1]&#8220;) hochgeladen.},
	'Select File to Upload' => 'Hochzuladende Datei wählen',
	'_USAGE_UPLOAD' => 'Dateien können auch in Unterverzeichnisse des gewählten Pfads hochgeladen werden. Existiert das Unterverzeichnis noch nicht, wird es automatisch angelegt.',
	'Choose Folder' => 'Ordner wählen',
	'Upload (s)' => 'Hochladen (s)',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] enthält Zeichen, die nicht für Ordnernamen verwendet werden dürfen: [_2]',

## tmpl/cms/include/async_asset_list.tmpl
	'Asset Type: ' => 'Asset-Art:',
	'All Types' => 'Alle Arten',
	'label' => 'Bezeichnung',
	'[_1] - [_2] of [_3]' => '[_1]-[_2] von [_3]',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose files to upload or drag files.' => 'Hochzuladende Dateien hierher ziehen oder Dateien auswählen.', # improved
	'Choose file to upload or drag file.' => 'Hochzuladende Datei hierher ziehen oder Datei auswählen.', # improved
	'Choose files to upload.' => 'Hochzuladende Dateien auswählen.', # Translate - New # OK
	'Choose file to upload.' => 'Hochzuladende Datei auswählen', # Translate - New # OK
	'Upload Settings' => 'Hochlade-Einstellungen', # Translate - New # OK
	'Upload Options' => 'Hochlade-Optionen',
	'Operation for a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'Drag and drop here' => 'Hierhin ziehen und ablegen',
	'Cancelled: [_1]' => 'Abgebrochen: [_1]',
	'The file you tried to upload is too large: [_1]' => 'Die gewählte Datei ist zu groß: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] ist keine gültige [_2]-Datei',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => 'Gewählte Benutzerkonten aktivieren (e)',
	'_USER_ENABLE' => 'Aktivieren',
	'Disable selected users (d)' => 'Gewählte Benutzerkonten deaktivieren (d)',
	'_USER_DISABLE' => 'Deaktivieren',
	'user' => 'Benutzer',
	'users' => 'Benutzer',
	'_NO_SUPERUSER_DISABLE' => 'Sie können Ihr eigenes Benutzerkonto nicht deaktivieren, da Sie Verwalter dieser Movable Type-Installation sind.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => 'Alle Daten erfolgreich exportiert!',
	'_BACKUP_TEMPDIR_WARNING' => 'Gewünschte Daten erfolgreich im Ordner [_1] gesichert. Bitte laden Sie die angegebenen Dateien <strong>sofort</strong> aus [_1] herunter und <strong>löschen</strong> Sie sie unmittelbar danach aus dem Ordner, da sie sensible Informationen enthalten.',
	'Export Files' => 'Dateien exportieren',
	'Download This File' => 'Diese Datei herunterladen',
	'Download: [_1]' => 'Herunterladen: [_1]',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'Der Download der Sicherungsdatei wird in einigen Sekunden automatisch beginnen. Sollte das nicht der Fall sein, klicken Sie <a href="javascript:(void)" onclick="submit_form()">hier</a> um den Download manuell zu starten. Pro Sitzung kann eine Sicherungsdatei nur einmal heruntergeladen werden.',
	'An error occurred during the export process: [_1]' => 'Beim Exportieren ist ein Fehler aufgetreten: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Exportiere Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'enthält',
	'does not contain' => 'enthält nicht',
	'__STRING_FILTER_EQUAL' => 'ist',
	'starts with' => 'beginnt mit',
	'ends with' => 'endet auf',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'is blank' => 'ist leer',
	'is not blank' => 'ist nicht leer',
	'__INTEGER_FILTER_EQUAL' => 'ist',
	'__INTEGER_FILTER_NOT_EQUAL' => 'ist nicht',
	'is greater than' => 'ist größer als',
	'is greater than or equal to' => 'ist größer als oder gleich',
	'is less than' => 'ist kleiner als',
	'is less than or equal to' => 'ist kleiner als oder gleich',
	'is between' => 'ist zwischen',
	'is within the last' => 'ist in den letzten',
	'is before' => 'ist vor',
	'is after' => 'ist nach',
	'is after now' => 'ist nach jetzt',
	'is before now' => 'ist vor jetzt',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'[_1] and [_2]' => '[_1] und [_2]',
	'_FILTER_DATE_DAYS' => '[_1] Tage',
	'__TIME_FILTER_HOURS' => 'ist innerhalb der letzten',
	'[_1] hours' => '[_1] Stunden',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => 'Einige Vorlagen wurden nicht zurückgesetzt.',
	'Some sites were not deleted. You need to delete child sites under the site first.' => 'Einige Sites wurden nicht gelöscht. Bitte löschen Sie zuerst alle Untersites.',
	'Delete selected [_1] (x)' => 'Markierte [_1] löschen (x)',
	'[_1] Name' => '[_1] Name',

## tmpl/cms/include/breadcrumbs.tmpl

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'Neuer Unterordner',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Zuletzt kommentiert',
	'Edit this commenter' => 'Kommentarautor bearbeiten',
	'View this commenter&rsquo;s profile' => 'Profil des Kommentarautors ansehen',

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => 'Gewählte Kommentare veröffentlichen (a)',
	'Delete selected comments (x)' => 'Gewählte Kommentare löschen (x)',
	'Edit this comment' => 'Kommentar bearbeiten',
	'Reply' => 'Antworten',
	'([quant,_1,reply,replies])' => '([quant,_1,Antwort,Antworten])',
	'Blocked' => 'Gesperrt',
	'Edit this [_1] commenter' => '[_1] Kommentarautor bearbeiten',
	'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentarautor suchen',
	'Anonymous' => 'Anonym',
	'View this entry' => 'Diesen Eintrag ansehen',
	'View this page' => 'Diese Seite ansehen',
	'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',
	'to republish' => 'zur erneuten Veröffentlichung',

## tmpl/cms/include/content_data_list.tmpl

## tmpl/cms/include/content_data_table.tmpl
	'Republish selected [_1] (r)' => 'Gewählte [_1] erneut veröffentlchen (r)',
	'Created' => 'Angelegt',
	'View Content Data' => 'Inhaltsdaten anzeigen',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Alle Rechte vorbehalten.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Werkzeugleiste ausblenden',
	'Hide &raquo;' => 'Ausblenden &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Schlüssel',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variable',
	'No COOKIE data' => 'Keine COOKIE-Daten',
	'Input Parameters' => 'Eingabe-Parameter',
	'No Input Parameters' => 'Keine Eingabe-Parameter',

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/debug_toolbar/vcs.tmpl

## tmpl/cms/include/display_options.tmpl

## tmpl/cms/include/entry_table.tmpl
	'Last Modified' => 'Zuletzt geändert',
	'View entry' => 'Eintrag ansehen',
	'View page' => 'Seite ansehen',
	'No entries could be found.' => 'Keine Einträge gefunden.',
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => 'Jetzt <a href="[_1]" class="alert-link">einen Eintrag anlegen</a>.',
	'No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.' => 'Keine Seiten gefunden. Jetzt <a href="[_1]" class="alert-link">eine Seite anlegen</a>.',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Passwort für Webdienste wählen',

## tmpl/cms/include/footer.tmpl
	'DEVELOPER PREVIEW' => 'ENTWICKLER-VORSCHAU',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Das ist eine Alpha-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'BETA' => 'BETA',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Das ist eine Beta-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'https://www.movabletype.org' => 'https://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org/',
	'Support' => 'Support',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'Forums' => 'Foren',
	'Send Us Feedback' => 'Feedback senden',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'with' => 'mit',

## tmpl/cms/include/group_table.tmpl
	'Enable selected group (e)' => 'Gew?hlte Gruppe aktivieren (e)',
	'Disable selected group (d)' => 'Gew?hlte Gruppe deaktivieren (d)',
	'group' => 'Gruppe',
	'groups' => 'Gruppen',
	'Remove selected group (d)' => 'Gew?hlte Gruppe entfernen (d)',

## tmpl/cms/include/header.tmpl
	'Help' => 'Hilfe',
	'Search (q)' => 'Suche (q)',
	'Search [_1]' => '[_1] suchen',
	'Select an action' => 'Aktion wählen',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Diese Website wurde bei der Aktualisierung der Movable Type-Installation automatisch angelegt. Wurzelverzeichnis und Adresse wurden nicht dabei festgelegt, damit die Pfade der mit früheren Movable-Type-Versionen erstellten Blogs gültig bleiben. Sie können in den vorhandenen Blogs wie gewohnt Einträge veröffentlichen, nicht aber die Website selbst veröffentlichen, solange die genannten Felder noch leer sind.},
	'from Revision History' => 'aus der Revisionshistorie',

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden.},

## tmpl/cms/include/import_start.tmpl
	'Importing entries into [_1]' => 'Importiere Einträge...',
	q{Importing entries as user '[_1]'} => q{Importiere Einträge als Benutzer &#8222;[_1]&#8220;...},
	'Creating new users for each user found in the [_1]' => 'Lege Benutzerkonten für jeden Benutzer des [_1] an...',

## tmpl/cms/include/insert_options_image.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Ausführen',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Schritt [_1] von [_2]',
	'Go to [_1]' => 'Gehe zu [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Keine Treffer. Bitte suchen Sie erneut.',
	'Sorry, there is no data for this object set.' => 'Keine Daten für diese Objekte vorhanden.',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Benutzername speichern?',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Keine Protokolleinträge gefunden.',
	'_LOG_TABLE_BY' => 'Von',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this [_1]?' => 'Die gewählten Benutzerkonten wirklich aus [_1] entfernen?',
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Die [_1] gewählten wirklich aus dieser [_2] entfernen?',
	'Remove selected user(s) (r)' => 'Gewählte(n) Benutzer entfernen (r)',
	'Remove this role' => 'Rolle entfernen',

## tmpl/cms/include/mobile_global_menu.tmpl
	'Select another site...' => 'Andere Site wählen...',
	'Select another child site...' => 'Andere Untersite wählen...',
	'PC View' => 'Desktop-Ansicht', # Translate - New # OK

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Hinzugefügt am',
	'Save changes' => 'Änderungen speichern',

## tmpl/cms/include/old_footer.tmpl
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> Version [_2]',
	q{_LOCALE_CALENDAR_HEADER_} => q{'So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'},
	'Your Dashboard' => 'Ihre Übersichtsseite',

## tmpl/cms/include/pagination.tmpl
	'First' => 'Anfang',
	'Last' => 'Ende',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Markierte [_1] veröffentlichen (p)',
	'From' => 'Von',
	'Target' => 'Nach',
	'Moderated' => 'Moderiert',
	'Edit this TrackBack' => 'TrackBack bearbeiten',
	'Go to the source entry of this TrackBack' => 'Eintrag, auf den sich das TrackBack bezieht, aufrufen',
	'View the [_1] for this TrackBack' => '[_1] zu diesem TrackBack ansehen',

## tmpl/cms/include/primary_navigation.tmpl
	'Open Panel' => 'Panel öffnen',
	'Open Site Menu' => 'Site-Menü öffnen',
	'Close Site Menu' => 'Site-Menü schließen',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Keine Revisionen vorhanden',
	'_REVISION_DATE_' => 'Datum',
	'Note' => 'Hinweis',
	'Saved By' => 'Gesichert von',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz-Meldung',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'Benutzer-Übersichtsseite',
	'Websites' => 'Websites',
	'Select another website...' => 'Andere Website wählen...',
	'(on [_1])' => '(auf [_1])',
	'Select another blog...' => 'Anderes Blog wählen',
	'Create Website' => 'Website anlegen',
	'Create Blog (on [_1])' => 'Blog anlegen (auf [_1])',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Published by [_2]' => '[_1] - Veröffentlicht von [_2]',
	'[_1] - Edited by [_2]' => '[_1] - Bearbeitet von [_2]',

## tmpl/cms/include/template_table.tmpl
	'No content type could be found.' => 'Keine Inhaltstypen gefunden.',
	'Create Archive Template:' => 'Archiv-Vorlage anlegen:',
	'Publish selected templates (a)' => 'Gewählte Vorlagen veröffentlichen (a)',
	'Archive Path' => 'Archivpfad',
	'SSI' => 'SSI',
	'Cached' => 'Gecacht',
	'Manual' => 'Manuell',
	'Dynamic' => 'Dynamisch',
	'Publish Queue' => 'Im Hintergrund',
	'Static' => 'Statisch',
	'Uncached' => 'Nicht gecacht',
	'templates' => 'Vorlagen',
	'to publish' => 'zu veröffentlichen',

## tmpl/cms/include/theme_exporters/category_set.tmpl

## tmpl/cms/include/theme_exporters/category.tmpl

## tmpl/cms/include/theme_exporters/content_type.tmpl

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Ordnername',
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">Blog-URL<mt:else>Site-URL</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'Dateien dieser Typen werden in das Thema aufgenommen: [_1]. Dateien anderen Typs werden ignoriert.',
	'Specify directories' => 'Verzeichnis angeben',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Geben Sie die Verzeichnisse ab Wurzelverzeichnis der Site an, die statische Dateien des Themas enthalten, z.B. css, images, js usw. Verwenden Sie pro Verzeichnis eine Zeile.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'Widgetgruppen',
	'modules' => 'Module',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] enthalten',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Willkommen zu Movable Type',
	'Create Your Account' => 'Legen Sie Ihr Benutzerkonto an',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Wir empfehlen dringend, die Perl-Installation mindestens auf Version [_1] zu aktualisieren. Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>.',
	'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?',
	'View MT-Check (x)' => 'MT-Check anzeigen (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Legen Sie nun ein Administratoren-Konto für Ihr System an. Movable Type wird daraufhin Ihre Datenbank initialisieren.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Um fortfahren zu können, müssen Sie sich gegenüber Ihrem LDAP-Server authentifizieren',
	'System Email' => 'System- E-Mail-Adresse',
	'Use this as system email address' => 'Diese Adresse als System-E-Mail-Adresse verwenden',
	'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
	'Finish install (s)' => 'Installation abschließen (s)',
	'Finish install' => 'Installation abschließen',
	'The initial account name is required.' => 'Benutzername erforderlich',
	'The display name is required.' => 'Anzeigename erforderlich',
	'The e-mail address is required.' => 'Bitte geben Sie Ihre E-Mail-Adresse an.',

## tmpl/cms/layout/common/footer.tmpl

## tmpl/cms/layout/dashboard.tmpl
	'reload' => 'neu laden',
	'Reload' => 'Neu laden',

## tmpl/cms/list_category.tmpl
	'Top Level' => 'Hauptebene',
	'[_1] label' => 'Bezeichnung',
	'Alert' => 'Hinweis',
	'Change and move' => 'Ändern und verschieben',
	'Rename' => 'Umbenennen',
	'Label is required.' => 'Bezeichnung erforderlich.',
	'Label is too long.' => 'Bezeichnung zu lang.',
	'Duplicated label on this level.' => 'Bezeichnung auf dieser Ebene bereits vorhanden.',
	'Basename is required.' => 'Basisname erforderlich.',
	'Invalid Basename.' => 'Basisname ungültig.',
	'Duplicated basename on this level.' => 'Basisname auf dieser Ebene bereits vorhanden.',
	'Add child [_1]' => 'Unter-[_1] hinzufügen',
	'Remove [_1]' => '[_1] löschen',
	'[_1] \'[_2]\' already exists.' => '[_1] &#8222;[_2]&#8220; bereits vorhanden.',
	'Are you sure you want to remove [_1] [_2]?' => '[_1] [_2] wirklich entfernen?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => '[_1] [_2] mit [_3] Unter-[_4] wirklich entfernen?',

## tmpl/cms/list_common.tmpl
	'Feed' => 'Feed',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Eintragsfeed',
	'Pages Feed' => 'Seitenfeed',
	'The entry has been deleted from the database.' => 'Eintrag aus der Datenbank gelöscht.',
	'The page has been deleted from the database.' => 'Seite aus der Datenbank gelöscht.',
	'Quickfilters' => 'Schnellfilter',
	'[_1] (Disabled)' => '[_1] (deaktiviert)',
	'Showing only: [_1]' => 'Zeige nur: [_1]',
	'Remove filter' => 'aufheben',
	'change' => 'ändern',
	'[_1] where [_2] is [_3]' => '[_1] mit [_2] [_3]',
	'Show only entries where' => 'Zeige nur Einträge mit',
	'Show only pages where' => 'Zeige nur Seiten mit',
	'status' => 'Status',
	'tag (exact match)' => 'Tag (genau)',
	'tag (fuzzy match)' => 'Tag (unscharf)',
	'asset' => 'Asset',
	'is' => ' ',
	'published' => 'veröffentlicht',
	'unpublished' => 'nicht veröffentlicht',
	'review' => 'zur Überprüfung',
	'scheduled' => 'zeitgeplant',
	'spam' => 'Spam',
	'Select A User:' => 'Benutzerkonto wählen: ',
	'User Search...' => 'Benutzer suchen...',
	'Recent Users...' => 'Aktuelle Benutzer...',
	'Select...' => 'Wählen...',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Assets erfolgreich gelöscht.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Kann '[_1]' nicht beschreiben. Vorschaubilder werden möglicherweise nicht angezeigt.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => 'Berechtigungen erfolgreich entzogen',
	'You have successfully granted the given permission(s).' => 'Berechtigungen erfolgreich zugewiesen',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich deaktiviert',
	'You have successfully enabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich aktiviert',
	'You have successfully unlocked the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich entsperrt',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Gewählte Benutzerkonten erfolgreich aus Movable Type gelöscht',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Die gelöschten Benutzerkonten sind im externen Verzeichnis weiterhin vorhanden. Die Benutzer können sich daher weiterhin an Movable Type Advanced anmelden.',
	q{You have successfully synchronized users' information with the external directory.} => q{Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie im externen Verzeichnis nicht mehr vorhanden sind.',
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie fehlerhafte Parameter aufweisen. Details finden Sie im <a href='[_2]' class="alert-link">Aktivitätsprotokoll</a>.},
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Bei der Synchronisierung ist ein Fehler aufgetreten. Details fnden Sie im <a href='[_1]' class="alert-link">Aktivitätsprotokoll</a>.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefügt.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die gewählten IP-Adressen erfolgreich aus der Liste entfernt.',
	'' => '', # Translate - New # OK
	'The IP you entered is already banned for this site.' => 'Diese IP-Adresse ist bereits gesperrt.', # Translate - New # OK
	'Invalid IP address.' => 'Ungültige IP-Adresse.',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Site erfolgreich aus dem Movable-Type-System gelöscht. Die zugehörigen Dateien sind noch vorhanden. Bitte löschen Sie sie, falls Sie se nicht mehr benötigen.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'Untersite erfolgreich aus dem Movable-Type-System gelöscht. Die zugehörigen Dateien sind noch vorhanden. Bitte löschen Sie sie, falls Sie se nicht mehr benötigen.',
	'You have successfully refreshed your templates.' => 'Vorlagen erfolgreich zurückgesetzt.',
	'You have successfully moved selected child sites to another site.' => 'Untersite erfolgreich in andere Site verschoben.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => 'Einige Kategorien konnten nicht gelöscht werden. Bitte löschen Sie zuerst die Kategoriefelder aus dem Kategorie-Set.',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'Die gewählten Kommentare wurden freigeschaltet.',
	'All comments reported as spam have been removed.' => 'Alle als Spam markierten Kommentare wurden entfernt.',
	'The selected comment(s) has been unapproved.' => 'Die gewählten Kommentare sind nicht mehr freigeschaltet',
	'The selected comment(s) has been reported as spam.' => 'Die gewählten Kommentare wurden als Spam gemeldet',
	'The selected comment(s) has been recovered from spam.' => 'Die gewählten Kommentare wurden aus dem Spam wiederhergestellt',
	'The selected comment(s) has been deleted from the database.' => 'Die gewählten Kommentar(e) wurden aus der Datenbank gelöscht.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
	'No comments appear to be spam.' => 'Scheinbar ist kein Kommentar Spam.',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'Inhaltsdaten aus Datenbank gelöscht.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'The content type has been deleted from the database.' => 'Inhaltstyp aus Datenbank gelöscht.',
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'Einige Inhaltstypen wurden nicht gelöscht. Biite löschen Sie zuerst die zugehörigen Archiv-Vorlagen oder entfernen Sie alle Inhaltstyp-Felder aus dem Inhaltstyp.',

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => 'Gruppe(n) erfolgreich deaktiviert.',
	'You successfully enabled the selected group(s).' => 'Gruppe(n) erfolgreich aktiviert.',
	'You successfully deleted the groups from the Movable Type system.' => 'Gruppen erfolgreich aus der Movable Type-Installation gelöscht.',
	q{You successfully synchronized the groups' information with the external directory.} => q{Gruppendaten erfolgreich mit externem Verzeichnis synchronisiert.},
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Bei der Synchronisierung ist ein Fehler aufgetreten. Nähere Informationen finden Sie im <a href='[_1]'>Aktivitätsprotokoll</a>.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'Benutzerkonten erfolgreich gelöscht.',
	'You successfully added new users to this group.' => 'Benutzer erfolgreich zu Gruppe hinzugefügt.',
	q{You successfully synchronized users' information with the external directory.} => q{Benutzerdaten erfolgreich mit externem Verzeichnis synchronisiert.},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Einige ([_2]) der Benutzerkonten wurden nicht wieder aktiviert, da sie nicht mehr im LDAP vorhanden sind.',
	'You successfully removed the users from this group.' => 'Benutzer erfolgreich aus Gruppe entfernt.',

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',
	'All times are displayed in GMT.' => 'Alle Zeiten in GMT',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have updated your contact in your address book.' => 'Kontakt im Adressbuch aktualisiert.',
	'You have added new contact to your address book.' => 'Neuen Kontakt ins Adressbuch eingetragen.',
	'You have successfully deleted the selected contacts from your address book.' => 'Gewählte Kontakte erfolgreich aus dem Adressbuch gelöscht.',

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => 'Gewählte TrackBacks freigeschaltet.',
	'All TrackBacks reported as spam have been removed.' => 'Alle als Spam gemeldeten TrackBacks entfernt.',
	'The selected TrackBack(s) has been unapproved.' => 'Gewählte TrackBacks nicht mehr freigeschaltet.',
	'The selected TrackBack(s) has been reported as spam.' => 'Gewählte TrackBack(s) als Spam gemeldet.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Gewählte TrackBacks(s) aus Spam wiederhergestellt',
	'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
	'No TrackBacks appeared to be spam.' => 'Kein TrackBack scheint Spam zu sein.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Rolle(n) erfolgreich gelöscht.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen',
	'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht',
	'Specify new name of the tag.' => 'Geben Sie den neuen Namen des Tags an',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Das Tag &#8222;[_2]&#8220; ist schon vorhanden. &#8222;[_1]&#8220; wirklich in allen Blogs mit &#8222;[_2]&#8220; zusammenführen?',

## tmpl/cms/list_template.tmpl
	'Show All Templates' => 'Alle Vorlagen anzeigen',
	'Content type Templates' => 'Inhaltstyp-Vorlagen',
	'Publishing Settings' => 'Veröffentlichungs-Einstellungen',
	'Helpful Tips' => 'Nützliche Hinweise',
	'To add a widget set to your templates, use the following syntax:' => 'Um eine Widgetgruppe in eine Vorlage einzubinden, verwenden Sie folgenden Code:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Name der Widgetgruppe&quot;$&gt;</strong>',
	'You have successfully deleted the checked template(s).' => 'Vorlage(n) erfolgreich gelöscht.',
	'Your templates have been published.' => 'Die Vorlagen wurden veröffentlicht.',
	'Selected template(s) has been copied.' => 'Die gewählte(n) Vorlage(n) wurden kopiert.',
	'Select template type' => 'Inhaltstyp wählen',
	'Entry Archive' => 'Eintrags-Archiv',
	'Entry Listing Archive' => 'Eintrags-Listenarchiv',
	'Page Archive' => 'Seiten-Archiv',
	'Content Type Listing Archive' => 'Inhaltstyp-Listenarchiv',
	'Template Module' => 'Vorlagenmodul',
	'Create new template (c)' => 'Neue Vorlage anlegen (c)',
	'Create' => 'Anlegen',
	'Delete selected Widget Sets (x)' => 'Gewählte Widget-Gruppen löschen (x)',
	'No widget sets could be found.' => 'Keine Widgetgruppen gefunden.',

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'Alle Themen',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	'Find Themes' => 'Themen finden',
	'Theme [_1] has been uninstalled.' => 'Thema [_1] deinstalliert.',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] angewendet (mit <a href="[_2]" class="alert-link">[quant,_3,Warnung,Warnungen]</a>).',
	'Theme [_1] has been applied.' => 'Thema [_1] angewendet.',
	'Failed' => 'Fehlgeschlagen',
	'[quant,_1,warning,warnings]' => '[quant,_1,Warnung,Warnungen]',
	'Reapply' => 'Erneut anwenden',
	'Uninstall' => 'Deinstallieren',
	'Author: ' => 'Autor:',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Diese Thema kann wegen [_1] Fehlern nicht in der Untersite verwendet werden',
	'This theme cannot be applied to the site due to [_1] errors' => 'Diese Thema kann wegen [_1] Fehlern nicht in der Site verwendet werden',
	'Errors' => 'Fehler',
	'Warnings' => 'Warnungen',
	'Theme Errors' => 'Themen-Fehler',
	'Theme Warnings' => 'Themen-Warnungen',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht in der Untersite verwendet werden. [_1] Elemente übersprungen.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht in der Site verwendet werden. [_1] Elemente übersprungen.',
	'Theme Information' => 'Themen-Infos',
	'No themes are installed.' => 'Keine Themen installiert.',
	'Current Theme' => 'Derzeitiges Thema',
	'Themes in Use' => 'Verwendete Themen',
	'Available Themes' => 'Verfügbare Themen',

## tmpl/cms/login.tmpl
	'Sign in' => 'Anmelden',
	'Your Movable Type session has ended.' => 'Ihre Movable Type-Sitzung ist abgelaufen oder Sie haben sich abgemeldet.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Unten können Sie sich erneut anmelden.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an, um den Vorgang fortzusetzen.',
	'Forgot your password?' => 'Passwort vergessen?',
	'Sign In (s)' => 'Anmelden (s)',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Noch nicht implementiert.',

## tmpl/cms/pinging.tmpl
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
	'Only [_1] Archives' => 'Nur Archiv: [_1]',
	'Publish (s)' => 'Veröffentlichen (s)',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Erfolg',
	'The files for [_1] have been published.' => 'Dateien für [_1] veröffentlicht.',
	'Your [_1] archives have been published.' => '[_1]-Archiv veröffentlicht.',
	'Your [_1] templates have been published.' => '[_1]-Vorlagen veröffentlicht.',
	'Publish time: [_1].' => 'Dauer: [_1]',
	'View your site.' => 'Site ansehen',
	'View this page.' => 'Seite ansehen',
	'Publish Again (s)' => 'Erneut veröffentlichen (s)',
	'Publish Again' => 'Erneut veröffentlichen',

## tmpl/cms/preview_content_data_content.tmpl

## tmpl/cms/preview_content_data_strip.tmpl
	'Return to the compose screen' => 'Zurück zur Eingabe',
	'Return to the compose screen (e)' => 'Zurück zur Eingabe (e)',
	'Publish this [_1] (s)' => '[_1] veröffentlichen (s)',
	'Save this [_1] (s)' => '[_1] speichern (s)',
	'Re-Edit this [_1]' => '[_1] erneut bearbeiten',
	'Re-Edit this [_1] (e)' => '[_1] erneut bearbeiten (e)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'Vorschau auf &#8222;[_1]&#8220-Inhalt &#8222;[_2]&#8220 ;',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Vorschau auf [_1]',

## tmpl/cms/preview_entry.tmpl
	'Save this entry' => 'Eintrag speichern',
	'Save this entry (s)' => 'Eintrag speichern (s)',
	'Re-Edit this entry' => 'Eintrag erneut bearbeiten',
	'Re-Edit this entry (e)' => 'Eintrag erneut bearbeiten (e)',
	'Save this page' => 'Seite speichern',
	'Save this page (s)' => 'Seite speichern (s)',
	'Re-Edit this page' => 'Seite erneut bearbeiten',
	'Re-Edit this page (e)' => 'Seite erneut bearbeiten (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'Eintrag veröffentlichen',
	'Publish this entry (s)' => 'Eintrag veröffentlichen (s)',
	'Publish this page' => 'Seite veröffentlichen',
	'Publish this page (s)' => 'Seite veröffentlichen (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Eintrag &#8222;[_1]&#8220;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Seite &#8222;[_1]6#8220;',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vorschau auf Vorlage &#8222;[_1]&#8221;',
	'(Publish time: [_1] seconds)' => '(Ausgegeben in [_1] Sekunden)',
	'Save this template (s)' => 'Vorlage speichern (s)',
	'Save this template' => 'Vorlage speichern',
	'Re-Edit this template (e)' => 'Vorlage erneut bearbeiten (e)',
	'Re-Edit this template' => 'Vorlage erneut bearbeiten',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'Es wurden noch keine Kategorien angelegt. Für die Vorschau werden daher Beispieldaten verwendet. Veröffentlicht werden kann die Vorlage erst, wenn mindestens eine Kategorie angelegt wurde., ',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Veröffentliche...',
	'Publishing [_1]...' => 'Veröffentliche [_1]...',
	'Publishing <em>[_1]</em>...' => 'Veröffentliche <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Veröffentliche [_1] [_2]',
	'Publishing [_1] dynamic links...' => 'Veröffentliche [_1] (dynamisch)',
	'Publishing [_1] archives...' => 'Veröffentliche [_1]...',
	'Publishing [_1] templates...' => 'Veröffentliche [_1]...',
	'Complete [_1]%' => '[_1]% fertig',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Entsperren',
	q{User '[_1]' has been unlocked.} => q{Benutzer '[_1]' entsperrt.},

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Passwörter anfordern',
	'No users were selected to process.' => 'Keine Benutzer zur Bearbeitung ausgewählt.',
	'Return' => 'Zurück',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'Keine Vorlagen gewählt.',
	'Return to templates' => 'Zurück zu Vorlagen',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1] Details finden Sie im Aktivitätsprotokoll.',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Importiere Movable Type',

## tmpl/cms/restore.tmpl
	'Import from Exported file' => 'Import aus exportierter Datei',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'XML::SAX und/oder Abhängigkeiten dieses Perl-Moduls fehlen. Ohne diese Module kann Movable Type das System nicht wiederherstellen.',
	'Exported File' => 'Exportierte Datei',
	'Overwrite global templates.' => 'Globale Vorlagen überschreiben',
	'Import (i)' => 'Importieren (i)',

## tmpl/cms/search_replace.tmpl
	'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
	'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus, das ersetzt werden soll.',
	'Search Again' => 'Erneut suchen',
	'Case Sensitive' => 'Groß/Kleinschreibung beachten',
	'Regex Match' => 'Reguläre Ausdrücke verwenden',
	'Limited Fields' => 'Felder eingrenzen',
	'Date/Time Range' => 'Datums-/Zeit-Bereich',
	'Date Range' => 'Zeitraum eingrenzen',
	'Reported as Spam?' => 'Als Spam gemeldet?',
	'(search only)' => '(nur suchen)',
	'Field' => 'Feld',
	'_DATE_FROM' => 'Von',
	'_DATE_TO' => 'Bis',
	'_TIME_FROM' => 'Von',
	'_TIME_TO' => 'Bis',
	'Submit search (s)' => 'Suchen (s)',
	'Search For' => 'Suchen nach',
	'Replace With' => 'Ersetzen durch',
	'Replace Checked' => 'Gewählte ersetzen',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,Element,Elemente] erfolgreich ersetzt.',
	'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
	'Show all matches' => 'Zeige alle Treffer',
	'[quant,_1,result,results] found' => '[quant,_1,Treffer,Treffer] gefunden',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Benutzer insgesamt',
	'Memcached Status' => 'Memcached-Status',
	'configured' => 'konfiguriert',
	'disabled' => 'deaktiviert',
	'Memcached is [_1].' => 'Memcached ist [_1]',
	'available' => 'verfügbar',
	'unavailable' => 'nicht verfügbar',
	'Memcached Server is [_1].' => 'Memcached-Server ist [_1].',
	'Server Model' => 'Server-Modell',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type konnte das Skript &#8222;mt-check.cgi&#8220; nicht finden. Überprüfen Sie, ob das Skript vorhanden ist und, falls erforderlich, ob das CheckScript-Parameter korrekt gesetzt ist.},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Der Exportordner existiert bereits: &#8222;[_1]&#8220;. Setzen Sie fort, um das vorhandene Thema zu überschreiben oder brechen Sie ab, um den Ordnernamen zu ändern.},
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
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Den Movable Type Upgrade Guide finden Sie <a href='[_1]' target='_blank'>hier</a>.},
	'In addition, the following Movable Type components require upgrading or installation:' => 'Zusätzlich müssen folgende Movable Type-Komponenten installiert oder aktualisiert werden:',
	'The following Movable Type components require upgrading or installation:' => 'Die folgenden Movable Type-Komponenten müssen installiert oder aktualisiert werden:',
	'Begin Upgrade' => 'Aktualisierung durchführen',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Herzlichen Glückwunsch, Sie haben Ihre Installation erfolgreich auf Movable Type [_1] aktualisiert!',
	'Your Movable Type installation is already up to date.' => 'Ihre Movable Type-Installation ist bereits auf dem neuesten Stand.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Aktivitätsprotokoll zurückgesetzt',
	'System Activity Log' => 'System-Aktivitätsprotokoll',
	'Filtered' => 'Gefilterte',
	'Filtered Activity Feed' => 'Gefilterter Aktivitätsfeed',
	'Download Filtered Log (CSV)' => 'Gefiltertes Protokoll herunterladen (CSV)',
	'Showing all log records' => 'Alle Einträge',
	'Showing log records where' => 'Einträge mit',
	'Show log records where' => 'Zeige Einträge mit',
	'level' => 'Art',
	'classification' => 'Thema',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartz-Fehler-Log',
	'Showing all Schwartz errors' => 'Alle Schwartz-Fehler zeigen',

## tmpl/cms/widget/activity_log.tmpl

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Neues',
	'No Movable Type news available.' => 'Es liegen keine Movable Type-Nachrichten vor.',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Nachricht vom System',
	'warning' => 'Warnung',

## tmpl/cms/widget/site_list_for_mobile.tmpl

## tmpl/cms/widget/site_list.tmpl
	'Setting' => 'Einstellung',
	'List' => 'Liste',
	'Recent Posts' => 'Aktuelle Einträge',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Statistik-Einstellungen',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Aktive Benutzer',

## tmpl/cms/widget/updates.tmpl
	'Update check failed. Please check server network settings.' => 'Update-Prüfung fehlgeschlagen. Bitte überprüfen Sie Ihre Netzwerkeinstellungen.',
	'Update check is disabled.' => 'Update-Prüfung deaktiviert.',
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Update auf Version [_1] verfügbar. Details finden Sie in den <a href="[_2]" target="_blank">News</a>.',
	'Movable Type is up to date.' => 'Movable Type ist aktuell.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Zurück (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Anmelden zum Kommentieren',
	'Sign in using' => 'Anmelden mit',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Noch nicht Mitglied? <a href="[_1]">Jetzt anmelden</a>!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Ihr Profil',
	'Select a password for yourself.' => 'Eigenes Passwort',
	'Return to the <a href="[_1]">original page</a>.' => 'Zurück zur <a href="[_1]">Ausgangsseite</a>.',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Vielen Dank für Ihre Anmeldung',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Bevor Sie kommentieren können, müssen Sie Ihre Registrierung noch bestätigen. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Um die Registrierung abzuschließen, bestätigen Sie bitte Ihre Anmeldung. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Um Ihre Registrierung zu bestätigen und Ihr Konto zu aktivieren, klicken Sie bitte auf den Link in dieser E-Mail.',
	'Return to the original entry.' => 'Zurück zum ursprünglichen Eintrag',
	'Return to the original page.' => 'Zurück zur ursprünglichen Seite',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Konto anlegen',
	'Password Confirm' => 'Passwortbestätigung',
	'Register' => 'Registrieren',

## tmpl/data_api/include/login_mt.tmpl

## tmpl/data_api/login.tmpl

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
	'From this [_1]' => 'Von diesem',
	'On this entry' => 'Zu diesem Eintrag',
	'By commenter identity' => 'Nach Identität des Kommentarautoren',
	'By commenter name' => 'Nach Namen des Kommentarautoren',
	'By commenter email' => 'Nach E-Mail-Adresse des Kommentarautoren',
	'By commenter URL' => 'Nach Web-Adresse (URL) des Kommentarautoren',
	'On this day' => 'An diesem Tag',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'Von diesem Autoren',

## tmpl/feeds/feed_entry.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source [_1]' => 'Quelle [_1]',
	'By source blog' => 'Nach Quelle',
	'By source title' => 'Nach Name der Quelle',
	'By source URL' => 'Nach URL der Quelle',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Konfigurierung des temporären Verzeichnisses',
	'You should configure your temporary directory settings.' => 'Sie sollten die temporäres Verzeichnis konfigurieren.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDir erfolgreich konfiguriert. Klicken Sie auf &#8222;Weiter&#8220;, um die Konfigurierung fortsetzen.},
	'[_1] could not be found.' => '[_1] nicht gefunden.',
	'TempDir is required.' => 'TempDir ist erforderlich.',
	'TempDir' => 'TempDir',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Konfigurationsdatei',
	'The [_1] configuration file cannot be located.' => 'Die [_1]-Konfigurationsdatei kann nicht gefunden werden.',
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Kopieren Sie folgenden Text in eine Datei namens &#8222;mt-config.cgi&#8220; und legen diese im Movable Type-Hauptverzeichnis ab (das Verzeichnis, in dem sich auch die Datei mt.cgi befindet)},
	'The wizard was unable to save the [_1] configuration file.' => 'Die [_1]-Konfigurationsdatei konnte nicht gespeichert werden.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Stellen Sie sicher, daß Ihr Webserver Schreibrechte für Ihr [_1]-Wurzelverzeichnis hat (also für den Ordner, der die Datei mt.cgi enthält) und klicken Sie dann auf &#8222;Erneut versuchen&#8220;.},
	q{Congratulations! You've successfully configured [_1].} => q{Herzlichen Glückwunsch! Sie haben die [_1] erfolgreich konfiguriert.},
	'Show the mt-config.cgi file generated by the wizard' => 'Vom Konfigurationsassistenten erzeugte mt-config.cgi-Datei anzeigen',
	'The mt-config.cgi file has been created manually.' => 'Die mt-congig.cgi-Konfigurationsdatei wurde manuell erstellt.',
	'Retry' => 'Erneut versuchen',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Datenbankkonfigurierung',
	'Your database configuration is complete.' => 'Ihre Datenbankkonfigurierung ist abgeschlossen.',
	'You may proceed to the next step.' => 'Sie können mit dem nächsten Schritt fortfahren.',
	'Show Current Settings' => 'Einstellungen anzeigen',
	'Please enter the parameters necessary for connecting to your database.' => 'Bitte geben Sie zur Herstellung der Datenkbankverbindung notwendigen Daten ein.',
	'Database Type' => 'Datenbanktyp',
	'Select One...' => 'Auswählen...',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Wird Ihr Datenbanksystem nicht aufgeführt? Führen Sie die <a href="[_1]" target="_blank">Movable Type Systemüberprüfung</a> durch, um zu erfahren, ob zusätzliche Module erforderlich sind.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Klicken Sie nach der Installation <a href="javascript:void(0)" onclick="[_1]">hier, um diese Ansicht zu aktualisieren</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Mehr über <a href="[_1]" target="blank">Datenbankkonfiguration</a> erfahren',
	'Show Advanced Configuration Options' => 'Erweiterte Optionen anzeigen',
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
	'Send mail via:' => 'Mails versenden über:',
	'Sendmail Path' => 'sendmail-Pfad',
	'Outbound Mail Server (SMTP)' => 'SMTP-Server',
	'Address of your SMTP Server.' => 'Adresse Ihres SMTP-Servers',
	'Port number for Outbound Mail Server' => 'Port-Nummer des Servers für ausgehende Mail',
	'Port number of your SMTP Server.' => 'Port-Nummer Ihres SMTP-Servers',
	'Use SMTP Auth' => 'SMTP Auth verwenden',
	'SMTP Auth Username' => 'SMTP-Auth-Benutzername',
	'Username for your SMTP Server.' => 'Benutzername Ihres SMTP-Servers',
	'SMTP Auth Password' => 'SMTP-Auth-Passwort',
	'Password for your SMTP Server.' => 'Passwort Ihres SMTP-Servers',
	'SSL Connection' => 'SSL-Verbindung',
	'Cannot use [_1].' => 'Kann [_1] nicht verwenden.',
	'Do not use SSL' => 'SSL nicht verwenden',
	'Use SSL' => 'SSL verwenden',
	'Use STARTTLS' => 'STARTTLS verwenden',
	'Send Test Email' => 'Testmail verschicken',
	'Mail address to which test email should be sent' => 'Zieladresse der Testmail',
	'Skip' => 'Überspringen',
	'You must set the SMTP server port number.' => 'Bitte geben Sie die Port-Nummer Ihres SMTP-Servers an.',
	'This field must be an integer.' => 'Bitte geben Sie eine ganze Zahl ein.',
	'You must set the system email address.' => 'Bitte geben Sie die System-E-Mail-Adresse an.',
	'You must set the Sendmail path.' => 'Bitte geben Sie Ihren Pfad zu Sendmail an.',
	'You must set the SMTP server address.' => 'Bitte geben Sie die Adresse Ihres SMTP-Servers an.',
	'You must set a username for the SMTP server.' => 'Bitte geben Sie den Benutzernamen Ihres SMTP-Servers an.',
	'You must set a password for the SMTP server.' => 'Bitte geben Sie das Passwort Ihres SMTP-Servers an.',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Überprüfung der Systemvoraussetzungen',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Die folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung erforderlich. Movable Type speichert die Daten Ihrer Sites und Untersites in einer Datenbank. Bitte installieren Sie eines der hier genannten Pakete und klicken Sie anschließend auf &#8222;Erneut versuchen&#8220;.},
	'All required Perl modules were found.' => 'Alle erforderlichen Perl-Module sind vorhanden.',
	'You are ready to proceed with the installation of Movable Type.' => 'Sie können die Installation von Movable Type fortsetzen.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Einige optionale Perl-Module wurden nicht gefunden. <a href="javascript:void(0)" onclick="[_1]">Optionale Module anzeigen</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Mindestens ein von Movable Type erforderliche Perl-Modul wurde nicht gefunden.',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber erforderlich. Bitte installieren Sie sie und klicken dann auf &#8222;Erneut versuchen&#8220;.},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Einige optionale Perl-Module wurden nicht gefunden. Die Installation kann ohne diese Module fortgesetzt werden. Sie können jederzeit bei Bedarf nachinstalliert werden. &#8222;Erneut versuchen&#8220; wiederholt die Modulsuche.},
	'Missing Database Modules' => 'Fehlende Datenbank-Module',
	'Missing Optional Modules' => 'Nicht vorhandene optionale Module',
	'Missing Required Modules' => 'Fehlende erforderliche Module',
	'Minimal version requirement: [_1]' => 'Mindestens erforderliche Version: [_1]',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	'Learn more about installing Perl modules.' => 'Mehr über die Installation von Perl-Modulen erfahren',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Alle erforderlichen Pakete vorhanden. Sie brauchen keine weiteren Pakete zu installieren.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Es ist bereits eine Konfigurationsdatei vorhanden',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type erfordert JavaScript. Bitte aktivieren Sie es in Ihren Browsereinstellungen und laden diese Seite dann neu.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Dieser Konfigurationsassistent hilft Ihnen, die zum Betrieb von Movable Type erforderlichen Grundeinstellungen vorzunehmen.',
	'Configure Static Web Path' => 'Statischen Web-Pfad konfigurieren',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Fehler: &#8222;[_1]&#8220; nicht gefunden.</strong> Bitte verschieben Sie die statischen Dateien erst in das Verzeichnis oder überprüfen Sie die Einstellungen.},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type wird mit einem Verzeichnis namens [_1] ausgeliefert, das einige wichtige Bild-, JavaScript- und Stylesheet-Dateien enthält.',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{Der [_1]-Ordner befindet sich im Hauptverzeichnis von Movable Type, ist aufgrund der Serverkonfiguration vom Webserver aber nicht erreichbar. Verschieben Sie den Ordner [_1] daher an einen Ort, auf dem der Webserver zugreifen kann (z.B. in das Web-Wurzelverzeichnis).},
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Das Verzeichnis wurde entweder umbenannt oder an einen Ort außerhalb des Movable Type-Verzeichnisses verschoben.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Wenn Sie den [_1]-Ordner an einen vom Webserver erreichbaren Ort verschoben haben, geben Sie die Adresse unten an.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Die Adresse kann in dieser Form: [_1] oder einfach als [_2] angegeben werden. ',
	'This path must be in the form of [_1]' => 'Der Pfad muss in dieser Form angegeben werden: [_1]',
	'Static web path' => 'Statischer Webpfad',
	'Static file path' => 'Statischer Dateipfad',
	'Begin' => 'Anfangen',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Es ist bereits eine Konfigurationsdatei (mt-config.cgi) vorhanden. Sie können sich daher sofort <a href="[_1]">bei Movable Type anmelden</a>.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Um mit dem Konfigurationsassistenten eine neue Konfigurationsdatei zu erzeugen, entfernen Sie die vorhandene Konfigurationsdatei und laden Sie diese Seite neu.',

## addons/Cloud.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype/',
	'Cloud Services' => 'Cloud-Dienste', # Translate - New # OK
	'Basic Authentication' => 'Basisauthentifizierung', # Translate - New # OK
	'Redirect' => 'Weiterleitung', # Translate - New # OK
	'Auto Update' => 'Automatische Updates', # Translate - New # OK
	'FTPS Password' => 'FTPS-Passwort', # Translate - New # OK
	'SSL Certificates' => 'SSL-Zertifikate', # Translate - New # OK
	'IP Restriction' => 'IP-Beschränkung', # Translate - New # OK
	'Full Restore' => 'Systemwiederherstellung', # Translate - New # OK
	'Config Directives' => 'Konfigurationsparameter', # Translate - New # OK
	'Disk Usage' => 'Festplattenbelegung', # Translate - New # OK

## addons/Cloud.pack/lib/Cloud/App/CMS.pm
	'Owner' => 'Besitzer', # Translate - New # OK
	'Creator' => 'Ersteller', # Translate - New # OK
	'FTP passowrd for [_1] has successfully been updated.' => 'FTP-Passwort von [_1] erfolgreich aktualisiert.', # Translate - New # OK
	'Unable to reset [_1] FTPS password.' => 'FTPS-Passwort [_1] konnte nicht zurückgesetzt werden.', # Translate - New # OK
	'Failed to update [_1]: some of [_2] were changed after you opened this screen.' => '[_1] konnte nicht aktualisiert werden: [_2] wurde geändert, nachdem Sie diese Seite aufgerufen haben.', # Translate - New # OK
	'Basic Authentication setting' => 'Basisauthentifizierungs-Einstellungen', # Translate - New # OK
	'Cannot access to this uri: [_1]' => 'Auf die URI kann nicht zugegriffen werden: [_1]', # Translate - New # OK
	'Basic authentication for site has successfully been updated.' => 'Basisauthentifizierungs-Einstellungen erfolgreich aktualisiert.', # Translate - New # OK
	'Unable to update Basic Authentication settings.' => 'Die Basisauthentifizierungs-Einstellungen konnten nicht aktualisiert werden', # Translate - New # OK
	'Administration Screen Setting' => 'Administrationsbereichs-Einstellungen', # Translate - New # OK
	'The URL you specified is not available.' => 'Die angegebene URL ist nicht verfügbar.', # Translate - New # OK
	'Unable to update Admin Screen URL settings.' => 'Administrationsbereichs-URL konnte nicht aktualisiert werden.', # Translate - New # OK
	'The URL for administration screen has successfully been updated.' => 'URL des Administrationsbereichs erfolgreich aktualisiert.', # Translate - New # OK
	'Cannot delete basicauth_admin file.' => 'basicauth_admin-Datei konnte nicht gelöscht werden', # Translate - New # OK
	'Basic authentication for administration screen has successfully been cleared.' => 'Basisauthentifizierung für den Administrationsbereich erfolgreich entfernt.', # Translate - New # OK
	'User ID is required.' => 'Benutzer-ID erforderlich.', # Translate - New # OK
	'Password is required.' => 'Passwort erfolgreich.', # Translate - New # OK
	'Unable to update basic authentication for administration screen.' => 'Basisauthentifizierung für Administrationsbereich konnte nicht aktualisiert werden.', # Translate - New # OK
	'Unable to write temporary file.' => 'Temporäre Datei konnte nicht geschrieben werden.', # Translate - New # OK
	'Basic authentication for administration screen has successfully been updated.' => 'Basisauthentifizierung für Administrationsbereich erfolgreich aktualisiert.', # Translate - New # OK
	'Cannot delete ip_restriction_[_1] file.' => 'ip_restriction_[_1]-Datei konnte nicht gelöscht werden.', # Translate - New # OK
	'IP restriction for administration screen has successfully been cleared.' => 'IP-Beschränkung für Administrationsbereich erfolgreich entfernt.', # Translate - New # OK
	'[_1] is not a valid IP address.' => '[_1] ist keine gültige IP-Adresse.', # Translate - New # OK
	'Unable to write allowed IP addresses file.' => 'Die Datei mit den zulässigen IP-Adressen konnte nicht geschrieben werden.', # Translate - New # OK
	'IP restriction white list for administration screen  has successfully been updated.' => 'Zulässige IP-Adressen für Administrationsbereich erfolgreich aktualisiert.', # Translate - New # OK
	'HTTP Redirect' => 'HTTP-Weiterleitung', # Translate - New # OK
	'HTTP Redirect setting' => 'Weiterleitungs-Einstellungen', # Translate - New # OK
	'HTTP redirect settings has successfully updated.' => 'Weiterleitungs-Einstellungen erfolgreich aktualisiert.', # Translate - New # OK
	'Unable to update HTTP Redirect settings.' => 'Die Weiterleitungs-Einstellungen konnten nicht aktualisiert werden.', # Translate - New # OK
	'Update SSL Certification' => 'SSL-Zertifikat aktualisieren', # Translate - New # OK
	'__SSL_CERT_UPDATE' => 'Aktualisieren', # Translate - New # OK
	'__SSL_CERT_INSTALL' => 'installieren', # Translate - New # OK
	'Cannot copy default cert file.' => 'Die Standard-Zertifikats-Datei konnte nicht kopiert werden.', # Translate - New # OK
	'Unable to create temporary path: [_1]' => 'Temporäre Pfad konnte nicht erzeugt werden: [_1]', # Translate - New # OK
	'SSL certification has successfully been updated.' => 'SSL-Verschlüsselung wurde erfolgreich aktualisiert.', # Translate - New # OK
	'Unable to update SSL certification.' => 'SSL-Verschlüsselung konnte nicht aktualisiert werden.', # Translate - New # OK
	'Manage Configuration Directives' => 'Konfigurationsparameter verwalten', # Translate - New # OK
	'Config Directive' => 'Konfigurationsparameter', # Translate - New # OK
	'Movable Type environment settings has successfully been updated.' => 'Umgebungseinstellungen erfolgreich aktualisiert.', # Translate - New # OK
	'Restoring Backup Data' => 'Stelle Sicherungsdaten wieder her', # Translate - New # OK
	'backup data' => 'Sicherungsdaten', # Translate - New # OK
	'Invalid backup file name.' => 'Der Name der Sicherungsdatei ist ungültig.', # Translate - New # OK
	'Cannot copy backup file to workspace.' => 'Die Sicherungsdatei konnte nicht in den Arbeitsbereich kopiert werden.', # Translate - New # OK
	'Could not save the site settings because the number of domains that have been used exceeds the number of domains which can be available.' => 'Die Website-Einstellungen konnten nicht gespeichert werden: Die Anzahl der verwendeten Domains übersteigt die Anzahl der verfügbaren Domains.', # Translate - New # OK
	'Could not create the site because the number of domains that have been used exceeds the number of domains which can be available.' => 'Die Website konnte nicht angelegt werden: Die Anzahl der verwendeten Domains übersteigt die Anzahl der verfügbaren Domains.', # Translate - New # OK
	'Auto Update Settings' => 'Aktualisierungs-Einstellungen', # Translate - New # OK
	'Unable to write AUTOUPDATE file: [_1]' => 'Die AUTOUPDATE-Datei konnte nicht geschrieben werden: [_1]', # Translate - New # OK
	'Auto update settings has successfully been updated.' => 'Aktualisierungs-Einstellungen erfolgreich aktualisiert.', # Translate - New # OK
	'IP Restriction Settings' => 'IP-Beschränkungs-Einstellungen', # Translate - New # OK
	'IP Restriction settings' => 'IP-Beschränkungs-Einstellungen', # Translate - New # OK
	'Domain, Path and IP addresses are required.' => 'Domainname, Pfad und IP-Adressen sind erforderlich.', # Translate - New # OK
	'\'[_1]\' does not exist.' => '\'[_1]\' existiert nicht.', # Translate - New # OK
	'\'[_1]\' is invalid path.' => 'Der Pfad \'[_1]\' ist ungültig.', # Translate - New # OK
	'Unable to create acl path: [_1]' => 'ACL-Pfad konnte nicht angelegt werden: [_1]', # Translate - New # OK
	'Cannot write to acl directory: [_1]' => 'Kein Schreibzugriff auf ACL-Verzeichnis: [_1]', # Translate - New # OK
	'Cannot write to acl file: [_1]' => 'Kein Schreibzugriff auf ACL-Datei: [_1]', # Translate - New # OK
	'IP restriction for site has successfully been updated.' => 'IP-Beschränkung für diese Site wurden erfolgreich aktualisiert.', # Translate - New # OK
	'Cannot apply access restriction settings. Perhaps, the path or IP address you entered is not a valid.' => 'Die Einstellungen wurden nicht übernommen. Möglicherweise ist eine Pfadangabe oder eine IP-Adresse ungültig.', # Translate - New # OK
	'Unable to remove acl file.' => 'Die ACL-Datei konnte nicht entfernt werden.', # Translate - New # OK

## addons/Cloud.pack/lib/Cloud/App.pm
	'Your Movable Type will be automatically updated on [_1].' => 'Ihr Movable Type wird automatisch am [_1] aktualisiert werden.', # Translate - New # OK
	'New version of Movable Type has been released on [_1].' => 'Eine neue Version von Movable Type ist am [_1] erschienen.', # Translate - New # OK
	'Disk usage rate is [_1]%.' => 'Festplattenplatz zu [_1]% belegt.', # Translate - New # OK
	'<a href="[_1]">Refresh cached disk usage rate data.</a>' => '<a href="[_1]">Festplattenplatz neu berechnen.</a>', # Translate - New # OK
	'An error occurred while reading version information.' => 'Versionsangabe konnte nicht abgerufen werden.', # Translate - New # OK

## addons/Cloud.pack/lib/Cloud/Template.pm
	'Unify the existence of www. <a href="[_1]">Detail</a>' => 'WWW-Subdomain verwenden. <a href="[_1]">Weitere Informationen</a>', # Translate - New # OK
	'https://www.movabletype.jp/documentation/cloud/guide/multi-domain.html' => 'https://www.movabletype.jp/documentation/cloud/guide/multi-domain.html', # Translate - New # OK
	'\'Site Root\' or \'Archive Root\' has been changed. You must move existing contents.' => 'Wurzelverezeichnis der Website oder des Archivs geändert. Bitte verschieben Sie die bestehenden Ordner entsprechend.', # Translate - New # OK

## addons/Cloud.pack/lib/Cloud/Upgrade.pm
	'Disabling any plugins...' => 'Deaktiviere alle Plugins...', # Translate - New # OK

## addons/Cloud.pack/lib/Cloud/Util.pm
	'Cannot read resource file.' => 'Ressourcen-Datei konnte nicht gelesen werden.', # Translate - New # OK
	'Cannot get the resource data.' => 'Ressourcen-Daten konnten nicht abgerufen werden.', # Translate - New # OK
	'Unknown CPU type.' => 'Unbekannter CPU-Typ.', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_auto_update.tmpl
	'Auto update setting have been saved.' => 'Aktualisierungs-Einstellungen gespeichert.', # Translate - New # OK
	'Current installed version of Movable Type is the latest version.' => 'Diese Movable-Type-Installation ist aktuell.', # Translate - New # OK
	'New version of Movable Type is available.' => 'Eine neue Version von Movable Type ist verfügbar.', # Translate - New # OK
	'Last Update' => 'Letzte Aktualisierung', # Translate - Case # OK
	'Movable Type [_1] on [_2]' => 'Movable Type [_1] am [_2]', # Translate - New # OK
	'Available version' => 'Verfügbare Version', # Translate - New # OK
	'Movable Type [_1] (released on [_2])' => 'Movable Type [_1] (erschienen am [_2])', # Translate - New # OK
	'Your Movable Type will be automatically updated on [_1], regardless of your settings.' => 'Unabhängig von Ihren Einstellungen wird Ihr Movable Type am [_1] automatisch aktualisiert werden.', # Translate - New # OK
	'Auto update' => 'Automatisches Update', # Translate - New # OK
	'Enable	automatic update of Movable Type' => 'Automatische Aktualisierung von Movable Type aktivieren', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_basic_authentication.tmpl
	'Manage Basic Authentication' => 'Basisauthentifizierung verwalten', # Translate - New # OK
	'/path/to/authentication' => '/pfad/zur/authentifizierung', # Translate - New # OK
	'User ID' => 'Benutzer-ID', # Translate - New # OK
	'URI is required.' => 'URI erforderlich.', # Translate - New # OK
	'Invalid URI.' => 'Ungültige URI.', # Translate - New # OK
	'User ID must be with alphabet, number or symbols (excludes back slash) only.' => 'Die Benutzer-ID darf keinen Backlash enhalten.', # Translate - New # OK
	'Password must be with alphabet, number or symbols (excludes back slash) only.' => 'Das Passwort darf keinen Backslash enthalten.', # Translate - New # OK
	'basic authentication setting' => 'Basisauthentifizierung-Einstellung', # Translate - New # OK
	'basic authentication settings' => 'Basisauthentifizierungs-Einstellungen', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_config_directives.tmpl
	'Configuration directive' => 'Konfigurationsparameter', # Translate - New # OK
	'Configuration value' => 'Konfigurationswert', # Translate - New # OK
	'Reference' => 'Referenz', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_disk_usage.tmpl
	'User Contents Files' => 'Benutzerdateien', # Translate - New # OK
	'Buckup Files' => 'Sicherungsdateien', # Translate - New # OK
	'Free Disk Space' => 'Freier Festplattenplatz', # Translate - New # OK
	'User Contents' => 'Benutzerinhalte', # Translate - New # OK
	'Backup' => 'Sicherungen', # Translate - Case # OK
	'Others' => 'Sonstiges', # Translate - New # OK
	'Free' => 'Frei', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_ftps_password.tmpl
	'Reset FTPS Password' => 'FTPS-Passwort zurücksetzen', # Translate - New # OK
	'Please select the account for which you want to reset the password.' => 'Bitte wählen Sie das Benutzerkonto, dessen Passwort zurückgesetzt werden soll.', # Translate - New # OK
	'Owner Password' => 'Besitzer-Passwort', # Translate - New # OK
	'Creator Password' => 'Ersteller-Passwort', # Translate - New # OK
	'Password has been saved.' => 'Passwort gespeichert.', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_http_redirect.tmpl
	'Manage HTTP Redirect' => 'HTTP-Weiterleitung verwalten', # Translate - New # OK
	'/path/of/redirect' => '/pfad/der/weiterleitung', # Translate - New # OK
	'http://example.com or /path/to/redirect' => 'http://beispiel.de oder /pfad/der/weiterleitung', # Translate - New # OK
	'Redirect URL is required.' => 'Weiterleitungs-URL erforderlich.', # Translate - New # OK
	'Redirect url is same as URI' => 'Weiterleitungs-URl und URI sind identisch.', # Translate - New # OK
	'HTTP redirect setting' => 'HTTP-Weiterleitungs-Einstellung', # Translate - New # OK
	'HTTP redirect settings' => 'HTTP-Weiterleitungs-Einstellungen', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_ip_restriction.tmpl
	'Administration screen settings have been saved.' => 'Administrationsbereichs-Einstellungen gespeichert.', # Translate - New # OK
	'Domain name like example.com' => 'Domainname wie beispiel.de', # Translate - New # OK
	'Path begin with / like /path' => 'Mit / beginnender Pfad wie /pfad', # Translate - New # OK
	'IP addresses that are allowed to access' => 'IP-Adressen, von denen aus zugegriffen werden darf', # Translate - New # OK
	'Domain is required.' => 'Domainname erforderlich.', # Translate - New # OK
	'"[_1]" does not exist.' => '"[_1]" existiert nicht.', # Translate - New # OK
	'Invalid Path.' => 'Ungültiger Pfad.', # Translate - New # OK
	'This combination of domain and path already exists.' => 'Diese Domain-Pfad-Kombination existiert bereits.', # Translate - New # OK
	'IP is required.' => 'IP-Adress erforderlich.', # Translate - New # OK
	'[_1] is invalid IP Address.' => '[_1] ist keine gültige IP-Adresse.', # Translate - New # OK
	'IP restriction settings' => 'IP-Beschränkungs-Einstellungen', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_security.tmpl
	'Administration screen setting have been saved.' => 'Administrationsbereichs-Einstellung gespeichert.', # Translate - New # OK
	'Administration screen url have been reset to default.' => 'Administrationsbereichs-URL auf Standardwert zurücksetzen.', # Translate - New # OK
	'Admin Screen URL' => 'Administrationsbereichs-URL', # Translate - New # OK
	'Protect administration screen by Basic Authentication' => 'Administrationsbereich mit Basisauthentifizierung sichern', # Translate - New # OK
	'Access Restriction' => 'Zugriffsbeschränkung', # Translate - New # OK
	'Restricts IP addresses that can access to administration screen.' => 'Beschränkt den Zugriff auf das Administrations-Menü auf bestimmte IP-Adressen.', # Translate - New # OK
	'Please add the IP address which allows access to the upper list. You can specify multiple IP addresses separated by commas or line breaks. When the current remote IP address  is not contained, it may become impossible to access an administration screen. For details.' => 'Bitte geben Sie die IP-Adressen an, von denen Zugriff möglich sein soll. Verwenden Sie Kommas oder Zeilenumbrüche zwischen mehreren Adressen. Bitte geben Sie auch die Remote-IP an, die Sie derzeit verwenden. Andersfalls können Sie möglicherweise nicht mehr auf Administrations-Funktionen zugreifen. Weitere Informationen.', # Translate - New # OK
	'Your IP address is [_1].' => 'Ihre IP-Adrese ist [_1].', # Translate - New # OK
	'Restricts IP address that can access to public CGI such as Search and Data API.' => 'Begrenzt, von welchen IP-Adressen aus auf öffentliche CGI-Skripte wie Suche und die Data-API zugegriffen werden kann.', # Translate - New # OK
	'IP address list is required.' => 'IP-Liste erforderlich.', # Translate - New # OK
	'administration screen' => 'Administrationsbereich', # Translate - New # OK
	' and ' => ' und ', # Translate - New # OK
	'public access CGI' => 'öffentliches CGI', # Translate - New # OK
	'The remote IP address is not included in the white list ([_1]). Are you sure you want to restrict the current remote IP address?' => 'Ihre Remote-IP ist nicht in der Liste der zulässigen Adressen enthalten ([_1]). Zugriff von Ihrer atuellen Remote-IP wirklich sperren?', # Translate - New # OK
	'Are you sure you want to save restrict access settings?' => 'Beschränkungs-Einstellungen wirklich speichern?', # Translate - New # OK

## addons/Cloud.pack/tmpl/cfg_ssl_certification.tmpl
	'Install SSL Certification' => 'SSL-Verschlüsselung installieren', # Translate - New # OK
	'SSL certification have been updated.' => 'SSL-Verschlüsselung aktualisiert.', # Translate - New # OK
	'SSL certification have been reset to default.' => 'SSL-Verschlüsselung auf Standardwerte zurückgesetzt.', # Translate - New # OK
	'The current server certification is as follows.' => 'Derzeit ist die Verschlüsselung wie folgt konfiguriert.', # Translate - New # OK
	q{To [_1] the server certificate, please enter the required information in the following fields. To revert back to the initial certificate, please press the 'Remove SSL Certification' button. The passphrase for 'Secret Key' must be released.} => q{Um das Server-Zertifikat zu [_1], füllen Sie bitte die folgenden Felder aus. Um zu den ursprünglichen Verschlüsselungs-Einstellungen zurückzukehren, klicken Sie bitte auf 'SSL-Verschlüsselung entfernen'. Bei 'Geheimer Schlüssel' geben Sie bitte die Passphrase an.}, # Translate - New # OK
	'Server Certification' => 'Server-Zertifikat', # Translate - New # OK
	'Secret Key' => 'Geheimer Schlüssel', # Translate - New # OK
	'Intermediate Certification' => 'Zwischenzertifikat', # Translate - New # OK
	'Remove SSL Certification' => 'SSL-Verschlüsselung entfernen', # Translate - New # OK

## addons/Cloud.pack/tmpl/full_restore.tmpl
	'Restoring Full Backup Data' => 'Sicherung vollständig wiederherstellen', # Translate - New # OK
	q{Restored backup data from '[_1]' at [_2]} => q{Sicherungs von '[_1]' um [_2] wiederhergestellt}, # Translate - New # OK
	'When restoring back-up data, the contents will revert to the point when the back-up data was created. Please note that any changes made to the data, contents, and received comments and trackback after this restoration point will be discarded. Also, while in the process of restoration, any present data will be backed up automatically. After restoration is complete, it is possible to return to the status of the data before restoration was executed.' => 'Bei der Wiederherstellung einer Sicherungsdatei werden alle Inhalte auf den Zeitpunkt zurückgesetzt, an dem die Sicherung erstellt wurde. Alle danach gemachten Änderungen und alle danach eingegangenen Kommentare und TrackBacks werden verworfen. Im Rahmen der Wiederherstellung wird der aktuelle Zustand automatisch gesichert. Sie können also bei Bedarf anschließend zum jetzigen Zustand zurückkehren.', # Translate - New # OK
	'Restore' => 'Wiederherstellen', # Translate - New # OK
	'Are you sure you want restore from selected backup file?' => 'Daten aus ausgewählter Sicherungsdatei wirklich wiederherstellen?', # Translate - New # OK

## addons/Commercial.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype/',
	'Professionally designed, well-structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Professionell gestaltete, gut strukturierte und einfach anpassbare Website. Die Standardseiten, Fußzeile und Navigation können Sie einfach konfigurieren.',
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
',
	'_PWT_CONTACT_BODY' => '
<p><strong>Platzhalter - Geben Sie hier Ihren eigenen Text ein.</strong></p>

<p>Wir freuen uns darauf, von Ihnen zu hören. Schicken Sie Ihre E-Mail bitte an email (at) domainname.de</p>
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
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Legen Sie ein Blog als Teil einer umfangreicheren Website an. Das funktioniert besonders gut mit der Vorlage Professionelle Website.',
	'Unknown Type' => 'Unbekannter Typ',
	'Unknown Object' => 'Unbekannts Objekt',
	'Not Required' => 'Nicht erforderlich',
	'Are you sure you want to delete the selected CustomFields?' => 'Gewählte eigene Felder wirklich löschen?',
	'Photo' => 'Foto',
	'Embed' => 'Einbetten',
	'Custom Fields' => 'Eigene Felder',
	'Template tag' => 'Vorlagenbefehl',
	'Updating Universal Template Set to Professional Website set...' => 'Aktualisiere \'Universelle Vorlagengruppe\' in Vorlagengruppe \'Profesionelle Website\'',
	'Migrating CustomFields type...' => 'Migriere CustomFields-Typen...',
	'Converting CustomField type...' => 'Wandle CustomFields-Typen...',
	'Professional Styles' => 'Pro-Themen',
	'A collection of styles compatible with Professional themes.' => 'Mit Pro-Themen kompatible Designs',
	'Professional Website' => 'Professionelle Website',
	'Entry Listing' => 'Eintragsliste',
	'Header' => 'Kopf',
	'Footer' => 'Fußzeile',
	'Entry Detail' => 'Eintragsdetails',
	'Entry Metadata' => 'Eintrags-Metadaten',
	'Page Detail' => 'Seiteninformationen',
	'Footer Links' => 'Fußzeilen-Links',
	'Powered By (Footer)' => 'Powered by (Fußzeile)',
	'Recent Entries Expanded' => 'Neueste Einträge (erweitert)',
	'Main Sidebar' => 'Haupt-Seitenspalte',
	'Blog Activity' => 'Blog-Aktivität',
	'Professional Blog' => 'Professionelles Blog',
	'Blog Archives' => 'Blog-Archiv',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Date & Time' => 'Datum- und Uhrzeit',
	'Date Only' => 'Nur Datum',
	'Time Only' => 'Nur Uhrzeit',
	'Please enter all allowable options for this field as a comma delimited list' => 'Bitte geben Sie alle für dieses Feld zulässigen Optionen als kommagetrennte Liste ein.',
	'Exclude Custom Fields' => 'Eigene Felder ausschließen',
	'[_1] Fields' => '[_1]-Felder',
	'Create Custom Field' => 'Eigenes Feld anlegen',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben müssen das Format JJJJ-MM-TT HH:MM:SS haben.',
	'Please enter valid URL for the URL field: [_1]' => 'Bitte geben Sie eine gültige Web-Adresse in das Feld [_1] ein.',
	'Please enter some value for required \'[_1]\' field.' => 'Bitte füllen Sie das erforderliche Feld &#8222;[_1]&#8220; aus.',
	'Please ensure all required fields have been filled in.' => 'Bitte füllen Sie alle erforderlichen Felder aus.',
	'The template tag \'[_1]\' is an invalid tag name.' => '&#8222;[_1]&#8220; ist kein gültiger Befehlsname.',
	'The template tag \'[_1]\' is already in use.' => 'Vorlagenbefehl &#8222;[_1]&#8220; bereits vorhanden',
	'blog and the system' => 'Blog und das system',
	'website and the system' => 'Website und das System',
	'The basename \'[_1]\' is already in use. It must be unique within this [_2].' => 'Der Basisname &#8222;[_1]&#8220; wird bereits verwendent. Er muss auf dieser [_2] eindeutig sein.',
	'You must select other type if object is the comment.' => 'Wählen Sie einen anderen Typ, wenn sich das Feld auf Kommentare bezieht.',
	'type' => 'Typ',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Speichern Sie genau die Informationen, die Sie möchten, indem Sie die Formulare und Felder von Einträgen, Seiten, Ordnern, Kategorien und Benutzerkonten frei anpassen.',
	' ' => ' ',
	'Single-Line Text' => 'Einzeiliger Text',
	'Multi-Line Text' => 'Mehrzeiliger Text',
	'Checkbox' => 'Auswahlkästchen',
	'Drop Down Menu' => 'Drop-Down-Menü',
	'Radio Buttons' => 'Auswahlknöpfe',
	'Embed Object' => 'Objekt einbetten',
	'Post Type' => 'Eintragsart',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Importing custom fields data stored in MT::PluginData...' => 'Importiere Daten eigener Felder aus MT::PluginData...',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Importiere in eigenen Feldern gefundene Asset-Verknüpfungen ( [_1] ) ...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Importiere URL der in eigenen Feldern verknüpften Assets ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'The type "[_1]" is invalid.' => 'Der Typ "[_1]" ist ungültig.',
	'The systemObject "[_1]" is invalid.' => 'Das systemObject "[_1]" ist ungültig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben sollten tatsächliche Daten sein',
	'Please enter valid option for the [_1] field: [_2]' => 'Bitte geben Sie eine gültige Option für das [_1]-Feld an: [_2]',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Das angegebene includeShared-Parameter ist ungültig: [_1]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'The template tag \'[_1]\' is already in use in the system level' => 'Der Vorlagenbefehl &#8222;[_1]&#8220; wird auf Systemebene bereits verwendet.',
	'The template tag \'[_1]\' is already in use in [_2]' => 'Der Vorlagenbefehl &#8222;[_1]&#8220; wird bereits in [_2] verwendet.',
	'The template tag \'[_1]\' is already in use in this blog' => 'Der Vorlagenbefehl &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.',
	'The \'[_1]\' of the template tag \'[_2]\' that is already in use in [_3] is [_4].' => 'Das bereits in [_3] verwendete &#8222;[_1]&#8220; des Vorlagenbefehls &#8222;[_2]&#8220; ist [_4].',
	'_CF_BASENAME' => 'Basisname',
	'__CF_REQUIRED_VALUE__' => 'Wert',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Wird der Befehl [_1] im richtigen Kontext verwendet? Kann [_2] nicht finden',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Befehl [_1] außerhalb des passenden Kontexts verwendet.',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] eigene Felder',
	'a field on this blog' => 'Ein Feld dieses Blogs',
	'a field on system wide' => 'Ein systemweites Feld',
	'Conflict of [_1] "[_2]" with [_3]' => ' [_1] "[_2]" steht in Konflikt mit [_3]',
	'Template Tag' => 'Vorlagenbefehl',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Verschiebe Metadatenspeicher für Seiten...',
	'Removing CustomFields display-order from plugin data...' => 'Entferne Anzeigereihenfolge eigener Felder aus Plugin-Daten...',
	'Removing unlinked CustomFields...' => 'Entferne nicht verwendete eigene Felder...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Klone Felder dieses Blogs:',

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

## addons/Commercial.pack/templates/professional/website/archive_index.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Einträge ([_1]) Kommentare ([_2])',

## addons/Commercial.pack/templates/professional/website/categories.mtml

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_detail.mtml

## addons/Commercial.pack/templates/professional/website/entry_listing.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry.mtml

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
	'Case sensitive' => 'Groß-/Kleinschreibung unterscheiden',

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Diese Felder anzeigen',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Eigenes Feld bearbeiten',
	'The selected field(s) has been deleted from the database.' => 'Gewählten Felder aus Datenbank gelöscht.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'Bitte füllen Sie alle hervorgehobenen Felder aus.',
	'You must save this custom field before setting a default value.' => 'Speichern Sie das Feld, um den Standardwert festlegen zu können.',
	'Choose the system object where this custom field should appear.' => 'Wählen Sie das Systemobjekt, auf das sich dieses Feld beziehen soll.',
	'Required?' => 'Erforderlich?',
	'Must the user enter data into this custom field before the object may be saved?' => 'Sollen Benutzer dieses Feld ausfüllen müssen, bevor sie das Objekt speichern können?',
	'The basename must be unique within this [_1].' => 'Der Basisname muss in diesem [_1] eindeutig sein.',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Hinweis: Eine Ã„nderung des Basisnamens eines Feldes kann die Bearbeitung vorhandener Vorlagen notwendig machen.},
	'Example Template Code' => 'Beispiel-Vorlagencode',
	'Show In These [_1]' => 'In diesen [_1] anzeigen',
	'Save this field (s)' => 'Dieses Feld speichern (s)',
	'field' => 'Feld',
	'fields' => 'Felder',
	'Delete this field (x)' => 'Dieses Feld löschen (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objekt',

## addons/Commercial.pack/tmpl/listing/field_list_header.tmpl

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'öffnen',
	'click-down and drag to move this field' => 'bei gedrückter Maustaste ziehen, um das Feld zu verschieben',
	'click to %toggle% this box' => 'klicken um das Feld an- oder abzuwählen',
	'use the arrow keys to move this box' => 'mit den Pfeiltasten verschieben',
	', or press the enter key to %toggle% it' => 'oder Enter drücken zum An- oder Abwählen',

## addons/Enterprise.pack/app-cms.yaml
	'Bulk Author Export' => 'Stapelexport von Autoren',
	'Bulk Author Import' => 'Stapelimport von Autoren',
	'Synchronize Users' => 'Benutzer synchronisieren',
	'Synchronize Groups' => 'Gruppen synchronisieren',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Dieses Modul ist zur Nutzung der LDAP-Authentifizierung erforderlich.',

## addons/Enterprise.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype/',
	'Advanced Pack' => 'Advanced-Pack',
	'Oracle Database (Recommended)' => 'Oracle-Datenbank (empfohlen)',
	'Microsoft SQL Server Database' => 'Microsoft SQL Server-Datenbank',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Microsoft SQL Server-Datenbank mit UTF-8-Unterstützung (empfohlen)',
	'Publish Charset' => 'Zeichenkodierung',
	'ODBC Driver' => 'ODBC-Treiber',
	'External Directory Synchronization' => 'Synchronisierung mit externem Verzeichnis',
	'Populating author\'s external ID to have lower case user name...' => 'Setze externe Benutzerkennung für kleingeschriebene Benutzernamen...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'Cannot connect to LDAP server.' => 'Es konnte keine Verbindung zum LDAP-Server hergestellt werden.',
	'User [_1]([_2]) not found.' => 'Benutzerkonto [_1]([_2]) nicht gefunden.',
	'User \'[_1]\' cannot be updated.' => 'Benutzerkonto \'[_1]\' kann nicht aktualisiert werden.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Benutzerkonto \'[_1]\' mit LDAP-Login-ID aktualisiert.',
	'LDAP user [_1] not found.' => 'LDAP-Benutzerkonto [_1] nicht gefunden.',
	'User [_1] cannot be updated.' => 'Benutzerkonto [_1] kann nicht aktualisiert werden.',
	'User cannot be updated: [_1].' => 'Benutzerkonto kann nicht aktualisiert werden: [_1].',
	'Failed login attempt by user \'[_1]\' who was deleted from LDAP.' => 'Fehlgeschlagener Anmeldeversuch von aus LDAP gelöschtem Benutzer \'[_1]\'.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Benutzerkonto \'[_1]\' mit LDAP-Login-Name aktualisiert.',
	'Failed login attempt by user \'[_1]\'. A user with that username already exists in the system with a different UUID.' => 'Fehlgeschlagener Anmeldeversuch von Benutzer \'[_1]\'. Es ist weiterer Benutzer mit gleichem Benutzernamen, aber anderer UUID im System vorhanden.',
	'User \'[_1]\' account is disabled.' => 'Benutzerkonto \'[_1]\' ist deaktiviert.',
	'LDAP users synchronization interrupted.' => 'LDAP-Benutzersynchronisierung unterbrochen.',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Laden von MT::LDAP::Multi fehlgeschlagen: [_1]',
	'External user synchronization failed.' => 'Synchronisierung externer Benutzer fehlgeschlagen.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Es wurde versucht, alle Administratorenkonten zu deaktivieren. Synchronisation unterbrochen.',
	'Information about the following users was modified:' => 'Folgende Benutzerkonten wurden bearbeitet:',
	'The following users were disabled:' => 'Folgende Benutzerkonten wurden deaktiviert:',
	'LDAP users synchronized.' => 'LDAP-Benutzer synchronisiert.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'Zur Synchronisierung von Gruppen muss LDAPGroupIDAttribute und/oder LDAPGroupNameAttribute gesetzt sein.',
	'Primary group members cannot be synchronized with Active Directory.' => 'Primäre Gruppenmitglieder können nicht per Active Directory synchronisiert werden.',
	'Cannot synchronize LDAP groups members.' => 'LDAP-Gruppenmitglieder konnten nicht synchronisiert werden.',
	'User filter was not built: [_1]' => 'Benutzerfilter nicht erzeugt: [_1]',
	'LDAP groups synchronized with existing groups.' => 'LDAP-Gruppen mit vorhandenen Gruppen sychnronisiert.',
	'Information about the following groups was modified:' => 'Folgende Gruppen wurden bearbeitet:',
	'No LDAP group was found using the filter provided.' => 'Keine LDAP-Gruppe mit dem angegebenen Filter gefunden.',
	'The filter used to search for groups was: \'[_1]\'. Search base was: \'[_2]\'' => 'Für die Gruppensuche verwendeter Filter: \'[_1]\'. Suchbasis: \'[_2]\'',
	'(none)' => '(Keine)',
	'The following groups were deleted:' => 'Die folgenden Gruppen wurden gelöscht:',
	'Failed to create a new group: [_1]' => 'Fehler beim Anlegen einer neuen Gruppe: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => '[_1]-Direktive muss gesetzt sein, um LDAP-Gruppenmitgliedschaften mit Movable Type Advanced zu synchronisieren.',
	'Cannot get group \'[_1]\' (#[_2]) entry and its all member attributes from external directory.' => 'Kann Mitglieder und Attribute der Gruppe \'[_1]\' (#2) nicht aus externem Verzeichnis beziehen.',
	'Cannot get member entries of group \'[_1]\' (#[_2]) from external directory.' => 'Kann Mitgliedseinträge der Gruppe \'[_1]\' (#2) nicht aus externem Verzeichnis beziehen.',
	'Members removed: ' => 'Entfernte Mitglieder:',
	'Members added: ' => 'Hinzugefügte Mitglieder:',
	'Memberships in the group \'[_2]\' (#[_3]) were changed as a result of synchronizing with the external directory.' => 'Mitgliedschaften der Gruppe \'[_2]\' (#[_3]) wurden durch die Synchronisierung mit dem externen Verzeichnis verändert.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'Zur Synchronisierung von Gruppen muss LDAPUserGroupMemberAttribute gesetzt sein.',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAP konnte nicht geladen werden: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => 'Formatierungsfehler in Zeile [_1]: [_2]',
	'Invalid command: [_1]' => 'Unbekannter Befehl: [_1]',
	'Invalid number of columns for [_1]' => 'Ungültige Spaltenzahl für [_1]',
	'Invalid user name: [_1]' => 'Ungültiger Benutzername: [_1]',
	'Invalid display name: [_1]' => 'Ungültiger Anzeigename: [_1]',
	'Invalid email address: [_1]' => 'Ungültige E-Mail-Adresse: [_1]',
	'Invalid password: [_1]' => 'Ungültiges Passwort: [_1]',
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Benutzer mit gleichem Namen gefunden und Konto daher nicht angelegt: [_1]',
	'Permission granted to user \'[_1]\'' => 'Berechtigungenga an Benutzer \'[_1]\' vergeben',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => 'Benutzer \'[_1]\' bereits vorhanden, Konto daher nicht aktualisiert: [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'Benutzer \'[_1]\' nicht gefunden, Konto daher nicht aktualisiert.',
	'User \'[_1]\' has been updated.' => 'Benutzerkonto \'[_1]\' aktualisiert.',
	'User \'[_1]\' was found, but the deletion was not processed' => 'Benutzer \'[_1]\' gefunden, Konto aber nicht gelöscht',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'Benutzer \'[_1]\' nicht gefunden, Konto daher nicht gelöscht',
	'User \'[_1]\' has been deleted.' => 'Benutzerkonto \'[_1]\' gelöscht.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced hat während der Synchronisation versucht, Ihr Benutzerkonto zu deaktivieren. Das deutet auf einen Fehler in der externen Benutzerverwaltung hin. Ãœberprüfen Sie daher die dortigen Einstellungen, bevor Sie Ihre Arbeit in Movable Type forsetzen.',
	'Bulk import cannot be used under external user management.' => 'Stapelimport ist bei externer Benutzerverwaltung nicht möglich.',
	'Users & Groups' => 'Benutzer und Gruppen',
	'Bulk management' => 'Stapelverwaltung',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Keine Einträge in Datei gefunden. Bitte stellen Sie sicher, daß für die Zeilenenden CRLF verwendet wird.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Benutzer] registiert, [quant,_2,Benutzerkonto,Benutzerkonten] aktualisiert, [quant,_3,Benutzerkonto,Benutzerkonten] gelöscht.',
	'Bulk author export cannot be used under external user management.' => 'Stapelexport von Benutzerkonten bei externer Benutzerverwaltung nicht möglich.',
	'A user cannot change his/her own username in this environment.' => 'Benutzer können ihre eigenen Benutzernamen in diesem Kontext nicht ändern.',
	'An error occurred when enabling this user.' => 'Bei der Aktivierung dieses Benutzerkontos ist ein Fehler aufgetreten',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Bereite Binärdaten zur Speicherung in Microsoft SQL Server vor...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Login',
	'Found' => 'Gefunden',
	'Not Found' => 'Nicht gefunden',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ungültiges LDAPAuthURL-Schema: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Verbindung zu LDAP-Server [_1] fehlgeschlagen: [_2]',
	'Entry not found in LDAP: [_1]' => 'Eintrag nicht im LDAP-Verzeichnig gefunden: [_1]',
	'Binding to LDAP server failed: [_1]' => 'Bindung an LDAP-Server fehlgeschlagen: [_1]',
	'User not found in LDAP: [_1]' => 'Benutzer nicht im LDAP-Verzeichnis gefunden: [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'Mehrere Benutzer mit dem gleichen Namen im LDAP-Verzeichnis gefunden: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] wird von dieser Version des MS SQL Server-Treibers nicht unterstützt.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Diese Version des UMSSQLServer-Treibers erfordert DBD::ODBC in der Version 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Diese Version des UMSSQLServer-Treiber erfodert ein mit Unicode-Unterstützung compiliertes DBD::ODBC.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Benutzerverwaltung im Stapel',
	'_USAGE_AUTHORS_2' => 'Sie können Benutzerkonto im Stapel anlegen, bearbeiten und löschen, indem Sie CSV-formatierte Steuerungsdatei mit den entsprechenden Daten und Befehlen hochladen.',
	'Upload source file' => 'Quelldatei hochladen',
	'Specify the CSV-formatted source file for upload' => 'Geben Sie die hochzuladende CSV-Quelldatei an',
	'Source File Encoding' => 'Zeichenkodierung der Quelldatei',
	'Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.' => 'Movable Type versucht automatisch die Zeichenkodierung Ihrer Importdatei zu ermitteln. Sie können die Kodierung aber auch selbst angeben.',
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
	'An error occurred while attempting to connect to the LDAP server: ' => 'Es konnte keine Verbindung zum LDAP-Server aufgebaut werden: ',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Wenn Sie LDAP-Authentifizierung verwenden möchten, können Sie hier die entsprechenden Einstellungen vornehmen.',
	'Your configuration was successful.' => 'Konfigurierung erfolgreich.',
	q{Click 'Continue' below to configure the External User Management settings.} => q{Klicken Sie auf 'Weiter', um die externe Benutzerverwaltung zu konfigurieren.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Klicken Sie auf 'Weiter', um die LDAP-Attribute zuzuweisen.},
	'Your LDAP configuration is complete.' => 'Ihre LDAP-Konfigurierung ist abgeschlossen.',
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Mit einem Klick auf 'Weiter' schließen Sie die Konfigurierung ab.},
	'Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'Kann Net::LDAP nicht finden. Net::LDAP ist zur Authentifizierung über LDAP erforderlich.',
	'Use LDAP' => 'LDAP verwenden',
	'Authentication URL' => 'Authentifizierungs-URL',
	'The URL to access for LDAP authentication.' => 'Adresse (URL) zur LDAP-Authentifizierung',
	'Authentication DN' => 'Authentifizierungs-DN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Optionaler DN zur LDAP-Bindung bei der Benutzersuche',
	'Authentication password' => 'Authentifizierungs- Passwort',
	'Used for setting the password of the LDAP DN.' => 'Wird zur Einstellung des LDAP DN-Passworts verwendet',
	'SASL Mechanism' => 'SASL-Mechanismus',
	'The name of the SASL Mechanism used for both binding and authentication.' => 'Name des zur Bindung und zur Authentifizierung verwendeten SASL-Mechanismus',
	'Test Username' => 'Test-Benutzername',
	'Test Password' => 'Test-Passwort',
	'Enable External User Management' => 'Externe Benutzerverwaltung aktivieren',
	'Synchronization Frequency' => 'Aktualisierungsintervall',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'Synchronisierungintervall in Minuten (Standard: alle 60 Minuten)',
	'15 Minutes' => '15 Minuten',
	'30 Minutes' => '30 Minuten',
	'60 Minutes' => '60 Minuten',
	'90 Minutes' => '90 Minuten',
	'Group Search Base Attribute' => 'Groupsearchbase-Attribut',
	'Group Filter Attribute' => 'Groupfilter-Attribut',
	'Search Results (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'CN' => 'CN (Common Name)',
	'No groups were found with these settings.' => 'Keine Gruppe mit diesen Einstellungen gefunden.',
	'Attribute mapping' => 'Attributzuordnung',
	'LDAP Server' => 'LDAP-Server',
	'Other' => 'Anderer',
	'User ID Attribute' => 'UserID-Attribut',
	'Email Attribute' => 'Email-Attribut',
	'User Fullname Attribute' => 'Userfullname-Attribut',
	'User Member Attribute' => 'Usermember-Attribut',
	'GroupID Attribute' => 'GroupID-Attribut',
	'Group Name Attribute' => 'Groupname-Attribut',
	'Group Fullname Attribute' => 'Groupfullname-Attribut',
	'Group Member Attribute' => 'Groupmember-Attribut',
	'Search Result (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'Group Fullname' => 'Groupfullname',
	'(and [_1] more members)' => '(und [_1] weitere Mitglieder)',
	'No groups could be found.' => 'Keine Gruppen gefunden.',
	'User Fullname' => 'Userfullname',
	'(and [_1] more groups)' => '(und [_1] weitere Gruppen)',
	'No users could be found.' => 'Keine Benutzer gefunden.',
	'Test connection to LDAP' => 'LDAP-Verbindung testen',
	'Test search' => 'Testsuche',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Alle Benutzerkonten erfolgreich aktualisiert.',
	'An error occurred during the update process. Please check your CSV file.' => 'Bei der Aktualisierung ist ein Fehler aufgetreten. Ãœberprüfen Sie die CSV-Datei.',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Sync.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype/',
	'Migrated sync setting' => 'Sync-Einstellungen migriert',
	'Content Delivery' => 'Content Delivery',
	'Sync Name' => 'Name der Synchronisations-Einstellung',
	'Sync Datetime' => 'Zeitpunkt',
	'Manage Sync Settings' => 'Synchronisations-Einstellungen bearbeiten',
	'Sync Setting' => 'Synchronisations-Einstellung',
	'Sync Settings' => 'Synchronisations-Einstellungen',
	'Create new sync setting' => 'Neue Synchronisations-Einstellung erstellen',
	'Contents Sync' => 'Inhalte synchonisieren',
	'Remove sync PID files' => 'PID-Dateien entfernen',
	'Updating MT::SyncSetting table...' => 'Aktualisiere MT::SyncSetting-Tabelle...',
	'Migrating settings of contents sync on website...' => 'Migriere Synchronisations-Einstellungen für Website...',
	'Migrating settings of contents sync on blog...' => 'Migriere Synchronisations-Einstellungen für Blog...',
	'Re-creating job of contents sync...' => 'Erstelle Synchronisations-Jobs neu...',

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'Auf das Remote-Verzeichnis \'[_1]\' kann nicht zugegriffen werden.',
	'Deleting file \'[_1]\' failed.' => 'Löschen der Datei \'[_1]\' fehlgeschlagen.',
	'Deleting path \'[_1]\' failed.' => 'Löschen des Ordners \'[_1]\' fehlgeschlagen.',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Es sind Dateien  oder Ordner vorhanden, deren Namen mit einem Punkt (.) oder Leerzeichen enden. Diese Elemente können nicht synchronisiert werden: [_2]',
	'Unable to write temporary file ([_1]): [_2]' => 'Die temporäre Datei [_1] konnte nicht geschrieben werden: [_2]',
	'Unable to get size of temporary file ([_1]): [_2]' => 'Die Größe der temporären Datei konnte nicht festgestellt werden ([_1]): [_2]',
	'FTP reconnection was failed. ([_1])' => 'FTP-Verbindung fehlgeschlagen. ([_1])',
	'FTP connection lost.' => 'FTP-Verbindung verloren.',
	'FTP connection timeout.' => 'Zeitüberschreitung bei der FTP-Anfrage.',
	'Unable to write remote files. Please check activity log for more details.: [_1]' => 'Remote-Dateien konnten nicht geschrieben werden. Weitere Informationen finden Sie im Aktivitäts-Log: [_1]',
	'Unable to write remote files ([_1]): [_2]' => 'Remote-Dateien ([_1]) konnten nicht geschrieben werden: [_2]',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Failed to remove sync list. (ID:\'[_1]\')' => 'Konnte Synchronisations-Liste nicht löschen. (ID:\'[_1]\')',
	'Failed to update sync list. (ID:\'[_1]\')' => 'Konnte Synchronisations-Liste nicht aktualisieren. (ID:\'[_1]\')',
	'Failed to create sync list.' => 'Konnte Synchronisations-Liste nicht anlegen.',
	'Failed to save sync list. (ID:\'[_1]\')' => 'Konnte Synchronisations-Liste nicht speichern. (ID:\'[_1]\')',
	'Error switching directory.' => 'Fehler beim Verzeichniswechsel.',
	'Synchronization([_1]) with an external server([_2]) has been successfully finished.' => 'Synchronisation([_1]) mit externem Server([_2]) erfolgreich abgeschlossen.',
	'Failed to Synchronization([_1]) with an external server([_2]).' => 'Synchronisation([_1]) mit externem Server([_2]) fehlgeschlagen.',

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Temp Directory [_1] is not writable.' => 'Das temporäre Verzeichnis [_1] kann nicht beschrieben werden.',
	'Incomplete file copy to Temp Directory.' => 'Datei unvollständig in das temporäre Verzeichnis kopiert.', # Translate - New # OK
	'Failed to remove "[_1]": [_2]' => '"[_1]" konnte nicht entfernt werden: [_2]', # Translate - New # OK
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Es ist ein Rsync-Fehler aufgetreten, Exit-Code [_1]: [_2]',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Synchronisations-Dateiliste',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Synchronisations-Einstellungen',

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	'Sync setting # [_1] not found.' => 'Synchronisations-Einstellungen [_1] nicht gefunden.',
	'This sync setting is being processed already.' => 'Diese Synchronisations-Einstellungwird bereits verarbeitet.',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'Fertig: Die Synchronisation mit dem externen Server wurde erfolgreich abgeschlossen.',
	'Saving sync settings failed: [_1]' => 'Sichern der Synchronisations-Einstellungen fehlgeschlagen: [_1]',
	'Failed to remove temporary directory: [_1]' => 'Das temporäre Verzeichnis konnte nicht entfernt werden: [_1]',
	'Failed to remove pid file.' => 'Die PID-Datei konnte nicht entfernt werden.',
	'This email is to notify you that failed to sync with an external server.' => 'Hinweis: Bei der Synchronisation mit dem externen Server ist ein Fehler aufgetreten.',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Copied [_1]' => '[_1] kopiert',
	'Create Sync Setting' => 'Synchronisations-Einstellung anlegen',
	'The sync setting with the same name already exists.' => 'Synchronisations-Einstellungen mit diesem Namen existieren bereits.',
	'Reached the upper limit of the parallel execution.' => 'Maximale Anzahl gleichzeitig ausführbarer Vorgänge erreicht.',
	'Process ID can\'t be acquired.' => 'Es konnte keine Process ID erworben werden.',
	'Sync setting \'[_1]\' (ID: [_2]) edited by [_3].' => 'Synchronisations-Einstellung \'[_1]\' (ID: [_2]) von [_3] bearbeitet.',
	'Sync setting \'[_1]\' (ID: [_2]) deleted by [_3].' => 'Synchronisations-Einstellung \'[_1]\' (ID: [_2]) von [_3] gelöscht.',
	'An error occurred while attempting to connect to the FTP server \'[_1]\': [_2]' => 'Bei der Verbindung mit dem FTP-Server \'[_1]\' ist ein Fehler aufgetreten: [_2]',
	'An error occurred while attempting to retrieve the current directory from \'[_1]\'' => 'Beim Einlesen des aktuellen Verzeichnisses von \'[_1]\' ist ein Fehler aufgetreten.',
	'An error occurred while attempting to retrieve the list of directories from \'[_1]\'' => 'Beim Einlesen der Verzeichnisliste von \'[_1]\' ist ein Fehler aufgetreten.',

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Entferne alle Synchronisations-Jobs...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Settings' => 'Synchronisations-Einstellungen',
	'Contents sync settings has been saved.' => 'Synchronisations-Einstellungen gespeichert.',
	'The sync settings has been copied but not saved yet.' => 'Die Synchronisations-Einstellungen wurden kopiert, aber noch nicht gesichert.',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Mindestens eine Vorlage wird dynamisch veröffentlicht. Dynamische Veröffentlichung wird vom Zielserver möglicherweise nicht unterstützt.',
	'Run synchronization now' => 'Jetzt synchronisieren',
	'Copy this sync setting' => 'Diese Synchronisations-Einstellung kopieren',
	'Sync Date' => 'Synchronisations-Zeitpunkt',
	'Recipient for Notification' => 'Benachrichtigungs-Empfänger',
	'Receive only error notification' => 'Nur bei Fehlern benachrichtigen',
	'htaccess' => 'htaccess',
	'Do not send .htaccess and .htpasswd file' => '.htaccess- und .htpasswd-Dateien nicht senden',
	'Destinations' => 'Synchronisations-Ziele',
	'Add destination' => 'Ziel hinzufügen',
	'Sync Type' => 'Art der Synchronisation',
	'Sync type not selected' => 'Keine Synchronisationsart gewählt',
	'FTP' => 'FTP',
	'Rsync' => 'Rsync',
	'FTP Server' => 'FTP-Server',
	'Port' => 'Port',
	'SSL' => 'SSL',
	'Enable SSL' => 'SSL aktivieren',
	'Net::FTPSSL is not available.' => 'Net:FTP is nicht verfügbar.',
	'Start Directory' => 'Ausgangsverzeichnis',
	'Rsync Destination' => 'Rsync-Ziel',
	'Are you sure you want to run synchronization?' => 'Wirklich synchronisieren?',
	'Sync all files' => 'Alle Dateien synchronisieren',
	'Please select a sync type.' => 'Bitte wählen Sie eine Synchronisationsart',
	'Sync name is required.' => 'Bitte geben Sie einen Namen an.',
	'Sync name should be shorter than [_1] characters.' => 'Der Name sollte höchstens [_1] Zeichen lang sein.',
	'The sync date must be in the future.' => 'Der Zeitpunkt der Synchronisation muss in der Zukunft liegen.',
	'Invalid time.' => 'Zeitangabe ungültig.',
	'You must make one or more destination settings.' => 'Bitte geben Sie mindestens ein Ziel an.',
	'Are you sure you want to remove this settings?' => 'Diese Einstellung wirklich entfernen?',

## addons/Sync.pack/tmpl/dialog/contents_sync_now.tmpl
	'Sync Now!' => 'Jetzt synchronisieren',
	'Preparing...' => 'Bereite vor...',
	'Synchronizing...' => 'Synchronisiere...',
	'Finish!' => 'Fertig!',
	'The synchronization was interrupted. Unable to resume.' => 'Die Synchronisation wurde unterbrochen. Der Vorgang kann nicht fortgesetzt werden.',

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Block-Editor.',
	'Block Editor' => 'Block-Editor',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => 'Neues Bild hochladen',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => 'Sortieren', # Translate - New # OK
	'No block in this field.' => 'Kein Block in diesem Feld.', # Translate - New # OK
	'Changing to plain text is not possible to return to the block edit.' => 'Nach Wechsel auf unformatierten Text kann nicht zum Block-Editor zurückgekehrt werden.',
	'Changing to block editor is not possible to result return to your current document.' => 'Nach Wechsel zum Block-Editor kann nicht zurückgewechselt werden.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alternativtext',
	'Caption' => 'Titel',

## plugins/Comments/config.yaml
	'Provides Comments.' => 'Ermöglicht Kommentare. ',
	'Mark as Spam' => 'Als Spam markieren',
	'Remove Spam status' => 'Kein Spam',
	'Unpublish Comment(s)' => 'Kommentar(e) nicht mehr veröffentlichen',
	'Trust Commenter(s)' => 'Kommentarautor(en) vertrauen',
	'Untrust Commenter(s)' => 'Kommentarautor(en) nicht mehr vertrauen',
	'Ban Commenter(s)' => 'Kommentarautor(en) sperren',
	'Unban Commenter(s)' => 'Kommentator(en) nicht mehr sperren',
	'Registration' => 'Registrierung',
	'Manage Commenters' => 'Kommentar-Autoren verwalten',
	'Comment throttle' => 'Kommentarbegrenzung',
	'Commenter Confirm' => 'Kommentarautorenbestätigung',
	'Commenter Notify' => 'Kommentarautorenbenachrichtigung',
	'New Comment' => 'Neuer Kommentar',

## plugins/Comments/default_templates/comment_detail.mtml

## plugins/Comments/default_templates/commenter_confirm.mtml
	'Thank you for registering an account to comment on [_1].' => 'Danke, daß Sie sich zum Kommentieren bei [_1] registriert haben.',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Bitte bestätigen Sie Ihr Benutzerkonto und Ihre E-Mail-Adresse. Das ist nur ein Mal erforderlich. Anschließend können Sie direkt auf [_1] Kommentare schreiben.',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'Um Ihr Benutzerkonto zu bestätigen, klicken Sie auf folgende Adresse oder kopieren Sie sie in die Adresszeile Ihres Browsers:',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Sollten Sie sich nicht registriert haben oder Sie sich doch nicht auf [_1] kommentieren möchten, brauchen Sie nichts weiter zu tun.},
	'Sincerely,' => ' Ihr',

## plugins/Comments/default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Ein neuer Benutzer hat sich erfolgreich auf '[_1]' registriert. Hier die Angaben dieses Benutzers.},
	'New User Information:' => 'Informationen über den neuen Benutzer:',
	'Full Name: [_1]' => 'Vollständiger Name: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Um das zugehörige Benutzerkonto aufzurufen oder zu bearbeiten, klicken Sie bitte auf folgende Adresse (oder kopieren Sie sie und fügen Sie sie in Adresszeile Ihres Browsers ein):',

## plugins/Comments/default_templates/comment_listing.mtml

## plugins/Comments/default_templates/comment_preview.mtml

## plugins/Comments/default_templates/comment_response.mtml

## plugins/Comments/default_templates/comments.mtml

## plugins/Comments/default_templates/comment_throttle.mtml
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Soll diese Adresse nicht gesperrt und dem Benutzer ermöglicht werden, wieder von dieser Adresse aus kommentieren zu können, entfernen Sie sie unter Blog-Konfiguration - IP-Sperren aus der Sperrliste.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Die IP-Adresse eines Besuchers Ihres Weblogs [_1] wurde automatisch gesperrt, da er versucht hat, mehr Kommentare als in [_2] Sekunden zulässig zu veröffentlichen.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Dadurch wird verhindert, daß Ihr Blog mit automatisch erzeugten Kommentaren überschwemmt wird. Die gesperrte Adresse lautet',

## plugins/Comments/default_templates/new-comment.mtml
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Zu Eintrag #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschalteter Kommentar eingegangen. Schalten Sie ihn frei, um ihn auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Zu Seite #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschalteter Kommentar eingegangen. Schalten Sie ihn frei, um ihn auf Ihrer Website erscheinen zu lassen.},
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Zu Eintrag #[_2] ([_3]) ist ein neuer Kommentar auf Ihrer Website '[_1]' erschienen.},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Zu Seite #[_2] ([_3]) ist ein neuer Kommentar auf Ihrer Website '[_1]' erschienen.},
	'Commenter name: [_1]' => 'Name des Kommentarautors: [_1]',
	'Commenter email address: [_1]' => 'E-Mail-Adresse des Kommentarautors: [_1]',
	'Commenter URL: [_1]' => 'Web-Adresse (URL) des Kommentarautors:',
	'Commenter IP address: [_1]' => 'IP-Adresse des Kommentarautors:',
	'Approve comment:' => 'Kommentar freischalten:',
	'View comment:' => 'Kommentar ansehen:',
	'Edit comment:' => 'Kommentar bearbeiten:',
	'Report the comment as spam:' => 'Kommentar als Spam melden:',

## plugins/Comments/default_templates/recent_comments.mtml

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'[_1] Comments' => '[_1] Kommentare',
	'All Comments' => 'Alle Kommentare',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'Wirklich alle als Spam markierte Kommentare löschen?',
	'Delete all Spam comments' => 'Alle Spam-Kommentare löschen',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Klone Kommentare für Weblog...',

## plugins/Comments/lib/Comments/CMS/Search.pm

## plugins/Comments/lib/Comments/Import.pm
	'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar (von &#8222;[_1]&#8220;) an...',
	'Saving comment failed: [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',

## plugins/Comments/lib/Comments.pm
	'Search for other comments from anonymous commenters' => 'Nach anderen anonym abgegeben Kommentaren suchen',
	'__ANONYMOUS_COMMENTER' => 'Anonym',
	'Search for other comments from this deleted commenter' => 'Nach anderen Kommentaren des gelöschten Autors suchen',
	'(Deleted)' => '(Gelöscht)',
	'Edit this [_1] commenter.' => 'Diesen [_1] Kommentar-Autor bearbeiten',
	'Comments on [_1]: [_2]' => 'Kommentare zu [_1]: [_2]',
	'Not spam' => 'Nicht Spam',
	'Reported as spam' => 'Als Spam gemeldet',
	'All comments by [_1] \'[_2]\'' => 'Alle Kommentare von [_1] &#8222;[_2]&#8220;',
	'__COMMENTER_APPROVED' => 'Bestätigt',
	'Moderator' => 'Moderator',
	'Can comment and manage feedback.' => 'Kann kommentieren und Feedback verwalten',
	'Can comment.' => 'Kann kommentieren',
	'Comments on My Entries/Pages' => 'Kommentare zu meinen Einträgen/Seiten',
	'Entry/Page Status' => 'Eintrags-/Seiten-Status',
	'Date Commented' => 'Kommentardatum',
	'Comments in This Website' => 'Kommentare auf dieser Website',
	'Non-spam comments' => 'Gültige Kommentare',
	'Non-spam comments on this website' => 'Gültige Kommentare auf dieser Website',
	'Pending comments' => 'Zu moderierende Kommentare',
	'Published comments' => 'Veröffentlichte Kommentare',
	'Comments on my entries/pages' => 'Kommentare zu meinen Einträgen/Seiten',
	'Comments in the last 7 days' => 'Kommentare der letzten 7 Tage',
	'Spam comments' => 'Spam-Kommentare',
	'Enabled Commenters' => 'Aktive Kommentar-Autoren',
	'Disabled Commenters' => 'Deaktivierte Kommentar-Autoren',
	'Pending Commenters' => 'Wartende Kommentar-Autoren',
	'Externally Authenticated Commenters' => 'Extern authentifizierte Kommentar-Autoren',
	'Entries with Comments Within the Last 7 Days' => 'Einträge mit Kommentaren in den letzten 7 Tagen',
	'Pages with comments in the last 7 days' => 'Seiten mit Kommentaren in den letzten 7 Tagen',

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Lege ursprüngliche Kommentar-Rollen an...',

## plugins/Comments/lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fehler bei der Zuweisung von Kommentierungsrechten an Benutzer &#8222;[_1] (ID: [_2])&#8220; für Weblog \'[_3] (ID: [_4])\'. Keine geeignete Kommentierungsrolle gefunden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ungültiger Anmeldeversuch von Kommentarautor [_1] an Weblog [_2](ID: [_3]) - native Movable Type-Authentifizierung bei diesem Weblog nicht zulässig.',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Sie haben sich erfolgreich authentifiziert, dürfen sich aber nicht anmelden. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'You need to sign up first.' => 'Bitte registrieren Sie sich zuerst.',
	'Login failed: permission denied for user \'[_1]\'' => 'Anmeldung fehlgeschlagen: Zugriff verweigert für Benutzer &#8222;[_1]&#8220;',
	'Login failed: password was wrong for user \'[_1]\'' => 'Anmeldung fehlgeschlagen: falsches Passwort für Benutzer &#8222;[_1]&#8220;',
	'Signing up is not allowed.' => 'Registrierungen sind nicht erlaubt.',
	'Movable Type Account Confirmation' => 'Movable Type-Anmeldungsbestätigung',
	'Your confirmation has expired. Please register again.' => 'Ihre Bestätigung ist nicht mehr gültig. Bitte registrieren Sie sich erneut.',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Zurück zur Ausgangsseite</a>',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Kommentarautor &#8222;[_1]&#8220; (ID:[_2]) erfolgreich registriert.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Vielen Dank für Ihre Bestätigung. Sie können sich jetzt anmelden und kommentieren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] hat sich für das Blog &#8222;[_2]&#8220; registriert.',
	'No id' => 'Keine ID',
	'No such comment' => 'Kein entsprechender Kommentar',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
	'IP Banned Due to Excessive Comments' => 'IP-Adresse wegen exzessiver Kommentarabgabe gesperrt',
	'No such entry \'[_1]\'.' => 'Kein Eintrag &#8222;[_1]&#8220;.',
	'_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in schneller Folge abgegeben. Bitte versuchen Sie es in einigen Augenblicken erneut.',
	'Comments are not allowed on this entry.' => 'Zu diesem Eintrag können keine Kommentare abgegeben werden.',
	'Comment text is required.' => 'Bitte geben Sie einen Kommentartext ein.',
	'Registration is required.' => 'Registrierung erforderlich',
	'Name and E-mail address are required.' => 'Name und E-Mail-Adresse sind erforderlich',
	'Invalid URL \'[_1]\'' => 'Ungültige Web-Adresse (URL) &#8222;[_1]&#8220;',
	'Comment save failed with [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Fehlgeschlagener Kommentierungsversuch durch wartenden Kommentarautoren &#8222;[_1]&#8220;',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Weiterleitung auf eine externe Website. Wenn Sie dieser Site vertrauen, klicken Sie bitte auf diesen Link: [_1]',
	'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag angegeben. Vielleicht gibt es ein Problem mit der Vorlage?',
	'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
	'Invalid entry ID provided' => 'Ungültige Eintrags-ID angegeben',
	'All required fields must be populated.' => 'Alle erforderlichen Felder müssen ausgefüllt sein.',
	'Commenter profile has successfully been updated.' => 'Das Profil des Kommentarautoren wurde erfolgreich aktualisiert.',
	'Commenter profile could not be updated: [_1]' => 'Das Profil des Kommentarautoren konnte nicht aktualisiert werden: [_1]',

## plugins/Comments/lib/MT/CMS/Comment.pm
	'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen ausgesprochen',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; gesperrt',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat die Sperrung von Kommentarautor &#8222;[_2]&#8220; aufgehoben',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen entzogen',
	'The parent comment id was not specified.' => 'ID des Eltern-Kommentars nicht angegeben.',
	'The parent comment was not found.' => 'Eltern-Kommentar nicht gefunden.',
	'You cannot reply to unapproved comment.' => 'Sie können nicht auf nicht freigeschaltete Kommentare antworten.',
	'You cannot create a comment for an unpublished entry.' => 'Nicht veröffentlichte Einträge können nicht kommentiert werden.',
	'You cannot reply to unpublished comment.' => 'Auf nicht veröffentlichte Kommentare kann nicht geantwortet werden.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Kommentar (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht',
	'You do not have permission to approve this trackback.' => 'Sie haben keine Benutzerrechte zur Freischaltung des TrackBacks.',
	'The entry corresponding to this comment is missing.' => 'Zugehöriger Eintrag fehlt.',
	'You do not have permission to approve this comment.' => 'Sie haben keine Benutzerrechte zur Freischaltung des Kommentars.',
	'Orphaned comment' => 'Verwaister Kommentar',

## plugins/Comments/lib/MT/DataAPI/Endpoint/Comment.pm

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Der Befehl &#8222;[_1]&#8220; wird nicht mehr unterstützt. Verwenden Sie stattdessen den Befehl \'[_2]\'.',

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'Der Befehl MTComentFields steht nicht mehr zur Verfügung. Binden Sie stattdessen das Vorlagenmodul [_1] ein. ',

## plugins/Comments/php/function.mtcommentauthorlink.php

## plugins/Comments/php/function.mtcommentauthor.php

## plugins/Comments/php/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'Der Befehl &#8222;[_1]&#8220; ist veraltet. Bitte verwenden Sie stattdessen \'[_2]\'',

## plugins/Comments/php/function.mtcommentreplytolink.php

## plugins/Comments/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Bild',

## plugins/Comments/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Original-Test',

## plugins/Comments/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/FacebookCommenters/config.yaml
	'Provides commenter registration through Facebook Connect.' => 'Ermöglicht es Kommentarautoren, sich über Facebook Connect zu registrieren',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Facebook Kommentarautoren-Plugin einrichten',
	'The login could not be confirmed because of no/invalid blog_id' => 'Das Login konnte nicht bestätigt werden, da die blog_id fehlt oder ungültig ist.',
	'Authentication failure: [_1], reason:[_2]' => 'Authentifizierung fehlgeschlagen: [_1]. Grund: [_2]',
	'Failed to created commenter.' => 'Konnte Kommentarautoren nicht anlegen.',
	'Failed to create a session.' => 'Konnte Session nicht anlegen.',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Zur Verwendung des Facebook-Kommentarautoren-Plugins muss eines der Perl-Module Crypt::SSLeay oder IO::Socket::SSL installiert sein.',
	'Please enter your Facebook App key and secret.' => 'Geben Sie Ihren Facebook-App-Key und den zugehörigen Code ein.',
	'Could not verify this app with Facebook: [_1]' => 'Die App konnte nicht mit Facebook verknüpft werden:  [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'OAuth Redirect URL of Facebook Login' => 'OAuth-Weiterleitungs-URL von Facebook login',
	'Please set this URL to "Valid OAuth redirect URIs" field of Facebook Login.' => 'Bitte tragen Sie hier die "Gültigen OAuth Redirect URIs" aus Facebook Login ein.',
	'Facebook App ID' => 'Facebook Application Key',
	'The key for the Facebook application associated with your blog.' => 'Der Application Key der mit Ihrem Blog verknüpften Facebook-Anwendung',
	'Edit Facebook App' => 'Facebook-Anwendung bearbeiten',
	'Create Facebook App' => 'Facebook-Anwendung erstellen',
	'Facebook Application Secret' => 'Facebook Application Secret',
	'The secret for the Facebook application associated with your blog.' => 'Das Application Secret der mit Ihrem Blog verknüpften Facebook-Anwendung',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Textbausteine verwalten',
	'Boilerplate' => 'Textbaustein',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => '&#8222;Textbaustein einfügen&#8220;-Symbol in der TinyMCE-Symbolleiste anzeigen',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte Textbaustein nicht laden',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Boilerplate' => 'Textbaustein',
	'Select a Boilerplate' => 'Textbaustein wählen',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Boilerplates' => 'Textbausteine',
	'Create Boilerplate' => 'Textbaustein anlegen',
	'Are you sure you want to delete the selected boilerplates?' => 'Gewählten Textbaustein wirklich löschen?',
	'Boilerplate' => 'Textbaustein',
	'My Boilerplate' => 'Meine Textbausteine',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Der Textbaustein \'[_1]\' wird in dieser Site bereits verwendet.',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Der Textbaustein  &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Textbaustein bearbeiten',
	'This boilerplate has been saved.' => 'Textbaustein gespeichert',
	'Save changes to this boilerplate (s)' => 'Änderungen des Textbausteins speichern (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Der Textbaustein  &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Textbaustein aus Datenbank gelöscht',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Site-Statistik-Plugin auf Basis von Google Analytics',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Ein zur Nutzung der Google-Analytics-API erforderliches Perl-Modul fehlt: [_1].',
	'You did not specify a client ID.' => 'Bitte geben Sie eine Client ID an.',
	'You did not specify a code.' => 'Bitte geben Sie einen Code an.',
	'The name of the profile' => 'Profilname',
	'The web property ID of the profile' => 'Die Web Property ID des Profils',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Beim Bezug des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Bei der Aktualisierung des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Beim Abrufen der Konten ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Beim Abrufen der Profile ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Beim Abrufen der Statistikdaten ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API-Fehler',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Profil wählen',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2-Einstellungen',
	'This [_2] is using the settings of [_1].' => 'In diesem [_2] werden die Einstellungen von [_1] verwendet.',
	'Other Google account' => 'Anderes Google-Konto',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Erstellen Sie über die <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> eine OAuth2-Client-ID mit dieser Redirect-URI, bevor Sie ein Profil wählen.},
	'Redirect URI of the OAuth2 application' => 'Redirect-URI der OAuth2-Anwendung',
	'Client ID of the OAuth2 application' => 'Client-ID der OAuth2-Anwendung',
	'Client secret of the OAuth2 application' => 'Client Secret der OAuth2-Anwendung',
	'Google Analytics profile' => 'Google Analytics-Profil',
	'Select Google Analytics profile' => 'Google Analytics-Profil wählen',
	'(No profile selected)' => '(Kein Profil gewählt)',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Die Client ID oder das Client Secret von Google Analytics wurde geändert, ohne das Profil zu aktualisieren. Einstellungen wirklich speichern?',

## plugins/Loupe/lib/Loupe/App.pm
	'Loupe settings has been successfully. You can send invitation email to users via <a href="[_1]">Loupe Plugin Settings</a>.' => 'Loupe ist jetzt eingerichtet. Laden Sie auch Ihre Benutzer zu Loupe ein. Einladungen können Sie in den <a href="[_1]">Loupe-Einstellungen</a> verschicken.',
	'Error saving Loupe settings: [_1]' => 'Konnte Loupe-Einstellungen nicht sichern: [_1]',
	'Send invitation email' => 'Einladungs-Mail verschicken',
	'Could not send a invitation mail because Loupe is not enabled.' => 'Einladung konnte nicht verschickt werden, da Loupe nicht aktiviert ist.',
	'Welcome to Loupe' => 'Willkommen bei Loupe',

## plugins/Loupe/lib/Loupe/Mail.pm
	'Loupe invitation mail has been sent to [_3] for user \'[_1]\' (user #[_2]).' => 'Loupe-Einladung für \'[_1]\' (#[_2]) an [_3] verschickt.',

## plugins/Loupe/lib/Loupe.pm
	'Loupe\'s HTML file name must not be blank.' => 'Der Name der Loupe-HTML-Datei muss mindestens ein Zeichen lang sein.',
	'The URL should not include any directory name: [_1]' => 'Die URL darf keinen Verzeichnisnamen enthalten: [_1]',
	'Could not create Loupe directory: [_1]' => 'Konnte Loup-Verzeichnis nicht anlegen: [_1]',
	'Loupe HTML file has been created: [_1]' => 'Loupe-HTML-Datei angelegt: [_1]',
	'Could not create Loupe HTML file: [_1]' => 'Konnte Loupe-HTML-Datei nicht anlegen: [_1]',
	'Loupe HTML file has been deleted: [_1]' => 'Loupe-HTML-Datei gelöscht: [_1]',
	'Could not delete Loupe HTML file: [_1]' => 'Konnte Loupe-HTML-Datei nicht löschen: [_1]',

## plugins/Loupe/lib/Loupe/Upgrade.pm
	'Adding Loupe dashboard widget...' => 'Installiere Loupe-Dashboard-Widget...',

## plugins/Loupe/Loupe.pl
	'Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics.' => 'Loupe ist die benutzerfreundliche Lösung für Movable Type auf Mobilgeräten, mit der Sie Einträge und Kommentare freischalten, Fotos hochladen und Ihre Zugriffszahlen aufrufen können.',

## plugins/Loupe/tmpl/dialog/welcome_mail_result.tmpl
	'Send Loupe welcome email' => 'Loupe-Begrüßungsmail verschicken',

## plugins/Loupe/tmpl/system_config.tmpl
	'Enable Loupe' => 'Loupe aktivieren',
	q{The URL of Loupe's HTML file.} => q{Adresse (URL) der Loupe-HTML-Datei.},

## plugins/Loupe/tmpl/welcome_mail_html.tmpl
	'Your MT blog status at a glance' => 'Ihr Movable Type-Status auf einen Blick',
	'Dear [_1], ' => 'Hallo [_1],',
	'With Loupe, you can check the status of your blog without having to sign in to your Movable Type account.' => 'mit Loupe verwalten Sie Ihre Blogs von unterwegs, ohne dazu das vollständige Movable-Type-Interface aufrufen zu müssen. ',
	'View Access Analysis' => 'Zugriffszahlen ansehen',
	'Approve Entries' => 'Einträge freischalten',
	'Reply to Comments' => 'Kommentare beantworten',
	'Loupe is best used with a smartphone (iPhone or Android 4.0 or higher)' => 'Loupe ist für Smartphones gemacht (iPhone, Android und andere)',
	'Try Loupe' => 'Loupe jetzt testen',
	'Perfect for Mini-tasking' => 'Perfektes Mini-Tasking',
	'_LOUPE_BRIEF' => 'Welche Einträge sind momentan beliebt? Haben mir meine Autoren neue Einträge zur Freischaltung geschickt? Und diesen Kommentar möchte ich sofort beantworten. - Alle diese Dinge können Sie jetzt direkt von Ihrem Smartphone aus erledigen. Mit Loupe ist es so einfach wie nie, Ihr Blog auch unterwegs aktuell zu halten!',
	'Use Loupe to help manage your Movable Type blogs no matter where you are!' => 'Mit Loupe verwalten Sie Ihre Movable-Type-Blogs egal wo Sie sind!',
	'Social Media' => 'Social Media',
	'https://twitter.com/movabletype' => 'https://twitter.com/movabletype',
	'Contact Us' => 'Kontakt',
	'http://www.movabletype.org/' => 'http://movabletype.org/',
	'http://plugins.movabletype.org' => 'http://plugins.movabletype.org',

## plugins/Loupe/tmpl/welcome_mail_plain.tmpl
	'Loupe is ready for use!' => 'Loupe ist bereits startklar!',

## plugins/Loupe/tmpl/widget/welcome_to_loupe.tmpl
	'Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">See more details.</a>' => 'Loupe ist die benutzerfreundliche Lösung für Movable Type auf Mobilgeräten, mit der Sie Einträge und Kommentare freischalten, Fotos hochladen und Ihre Zugriffszahlen aufrufen können. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">Weitere Informationen in englischer Sprache</a>.',
	'Loupe can be used without complex configuration, you can get started immediately.' => 'Sie können sofort anfangen - Loupe braucht nicht erst aufwendig konfiguriert zu werden',
	'Configure Loupe' => 'Loupe konfigurieren',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Ein Plugin, mit dem HTML wie normaler Text eingegeben werden kann.',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown mit SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Wandelt einfache Interpunktionszeichen in typographisch korrekte Zecichen um.},

## plugins/OpenID/config.yaml
	'Provides OpenID authentication.' => 'Ermöglicht Authentifizierung über OpenID',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Ein zur Authentifizierung von Kommentarautoren per Google ID erforderliches Perl-Moduul fehlt: [_1].',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'Konnte Session nicht speichern.',
	'Could not load Net::OpenID::Consumer.' => 'Konnte Net::OpenID::Consumer nicht laden.',
	'The address entered does not appear to be an OpenID endpoint.' => 'Die angebene Adresse ist kein OpenID-Endpunkt.',
	'The text entered does not appear to be a valid web address.' => 'Der eingegebene Text ist keine gültige Web-Adresse.',
	'Unable to connect to [_1]: [_2]' => 'Konnte keine Verbindung zu [_1] aufbauen: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'Die angegebene OpenID konnte nicht bestätigt werden: [_1]',

## plugins/OpenID/tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Ihr AIM- oder AOL-Bildschirmname',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Mit Ihrem AIM- oder AOL-Bildschirmnamen anmelden. Ihr Bildschirmname wird öffentlich angezeigt.',

## plugins/OpenID/tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Mit Ihrem Gmail-Konto anmelden',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Bei Movable Type mit Ihrem[_1]-Konto[_2] anmelden',

## plugins/OpenID/tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Ihre Hatena-ID',

## plugins/OpenID/tmpl/comment/auth_livedoor.tmpl

## plugins/OpenID/tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Ihr LiveJournal-Benutzername',
	'Learn more about LiveJournal.' => 'Mehr über LiveJournal erfahren',

## plugins/OpenID/tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'OpenID-URL',
	'Sign in with one of your existing third party OpenID accounts.' => 'Mit einer Ihrer vorhandenen OpenID-Kennungen anmelden',
	'http://www.openid.net/' => 'http://www.openid.net/',
	'Learn more about OpenID.' => 'Mehr über OpenID erfahren',

## plugins/OpenID/tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Ihr Wordpress.com-Benutzername',
	'Sign in using your WordPress.com username.' => 'Mit Ihrem Wordpress.com-Benutzernamen anmelden',

## plugins/OpenID/tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'OpenID für Ihr Yahoo! Japan-Konto jetzt aktivieren',

## plugins/OpenID/tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Aktivieren Sie jetzt OpenID für Ihr Yahoo!-Benutzerkonto',

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
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Von eingehendem Feedback können die IP-Adressen und enthaltene Hyperlinks überprüft werden. Stammt ein eingehender Kommentar oder TrackBack von einer schwarzgelisteten IP-Adresse oder enthält er Links zu einer dort gelisteten Domain, kann er automatisch zur Moderation zurückgehalten oder in den Spam-Ordner der Site gelegt werden. Für TrackBacks sind zusätzliche Prüfungen möglich.},
	'IP Address Lookups' => 'Prüfen von IP-Adressen',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen moderieren',
	'Junk feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen als Spam ansehen',
	'Adjust scoring' => 'Gewichtung anpassen',
	'Score weight:' => 'Gewichtung',
	'block' => 'sperren',
	'IP Blacklist Services' => 'IP-Schwarzlisten',
	'Domain Name Lookups' => 'Prüfen von Domain-Namen',
	'Moderate feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains moderieren',
	'Junk feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains als Spam ansehen',
	'Domain Blacklist Services' => 'Domain-Schwarzlisten',
	'Advanced TrackBack Lookups' => 'Zusätzliche TrackBack-Prüfungen',
	'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen moderieren',
	'Junk TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen als Spam ansehen',
	'Lookup Whitelist' => 'Weißliste',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Tragen Sie hier IP-Adressen und Domains ein, die nicht  geprüft werden sollen. Verwenden Sie pro Eintrag eine Zeile. ',

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

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Korrekt formatierter Text leicht gemacht',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Als Standard festgelegter grafischer Editor.',
	'TinyMCE' => 'TinyMCE',

## plugins/Trackback/config.yaml
	'Provides Trackback.' => 'Ermöglicht TrackBack.',
	'Mark as Spam' => 'Als Spam markieren',
	'Remove Spam status' => 'Kein Spam',
	'Unpublish TrackBack(s)' => 'TrackBack(s) nicht mehr veröffentlichen',
	'weblogs.com' => 'weblogs.com',
	'New Ping' => 'Neuer Ping',

## plugins/Trackback/default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Eintrag #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Seite #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Kategorie #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Zu Eintrag #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website '[_1]' erschienen.},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Zu Seite #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website '[_1]' erschienen.},
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Zu Kategorie #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website'[_1]' erschienen.},
	'Approve TrackBack' => 'TrackBack annehmen',
	'View TrackBack' => 'TrackBack ansehen',
	'Report TrackBack as spam' => 'TrackBack als Spam melden',
	'Edit TrackBack' => 'TrackBack bearbeiten',

## plugins/Trackback/default_templates/trackbacks.mtml

## plugins/Trackback/lib/MT/App/Trackback.pm
	'You must define a Ping template in order to display pings.' => 'Sie müssen eine Ping-Vorlage definieren, um Pings anzeigen zu können.
',
	'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
	'TrackBack ID (tb_id) is required.' => 'TrackBack_ID (tb_id) erforderlich.',
	'Invalid TrackBack ID \'[_1]\'' => 'Ungültige TrackBack-ID &#8222;[_1]&#8220;',
	'You are not allowed to send TrackBack pings.' => 'Sie haben keine Berechtigung, TrackBack-Pings zu senden.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Sie versenden TrackBacks-Pings zu schnell hintereinander. B
itte versuchen Sie es später erneut.',
	'You need to provide a Source URL (url).' => 'Bitte geben Sie eine Quell-URL (url) an.',
	'Invalid URL \'[_1]\'' => 'Ungültige URL \'[_1]\'',
	'This TrackBack item is disabled.' => 'Dieser TrackBack-Eintrag ist deaktiviert.',
	'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack für Kategorie &#8222;[_1]&#8220; (ID:[_2])',
	'Cannot create RSS feed \'[_1]\': ' => 'RSS-Feed &#8222;[_1]&#8220; kann nicht angelegt werden: ',
	'New TrackBack ping to \'[_1]\'' => 'Neuer TrackBack-Ping an &#8222;[_1]&#8220;',
	'New TrackBack ping to category \'[_1]\'' => 'Neuer TrackBack-Ping an Kategorie &#8222;[_1]&#8220;',

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Namenlose Kategorie)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8
220; aus Kategorie &#8222;[_4]&#8220; gelöscht',
	'(Untitled entry)' => '(Namenloser Eintrag)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220
; aus Eintrag &#8222;[_4]&#8220; gelöscht',
	'No Excerpt' => 'Kein Auszug',
	'Orphaned TrackBack' => 'Verwaistes TrackBack',
	'category' => 'Kategorien',

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem &#8222;category&#8220;-Attribut des Tags verwendet werden.',

## plugins/Trackback/lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Keine WeblogsPingURL in der Konfigurationsdatei definiert',
	'No MTPingURL defined in the configuration file' => 'Keine MTPingURL in der Konfigurationsdatei definiert',
	'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
	'Ping error: [_1]' => 'Ping-Fehler: [_1]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Alle TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Wirklich alle als Spam markierten TrackBacks löschen?',
	'Delete all Spam trackbacks' => 'Alle Spam-TrackBacks löschen',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBacks for blog...' => 'Klone TrackBacks für Weblog...',
	'Cloning TrackBack pings for blog...' => 'Klone TrackBack-Pings für Weblog...',

## plugins/Trackback/lib/Trackback/CMS/Comment.pm
	'You do not have permission to approve this trackback.' => 'Sie sind nicht berechtigt, TrackBacks freizuschalten.',
	'The entry corresponding to this comment is missing.' => 'Der zu diesem Kommentar gehörende Eintrag fehlt.',
	'You do not have permission to approve this comment.' => 'Sie sind nicht berechtigt, Kommentare freizuschalten.',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	'Ping \'[_1]\' failed: [_2]' => 'Ping &#8222;[_1]&#8220; fehlgeschlagen: [_2]',

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'Quell-URL',

## plugins/Trackback/lib/Trackback/Import.pm
	'Creating new ping (\'[_1]\')...' => 'Erzeuge neuen Ping &#8222;[_1]&#8220;)...',
	'Saving ping failed: [_1]' => 'Der Ping konnte nicht gespeichert werden: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping von: [_2] - [_3]</a>',
	'Not spam' => 'Nicht Spam',
	'Reported as spam' => 'Als Spam gemeldet',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks zu [_1]: [_2]',
	'__PING_COUNT' => 'TrackBacks',
	'Trackback Text' => 'TrackBack-Text',
	'Trackbacks on My Entries/Pages' => 'TrackBacks zu meinen Einträgen/Seiten',
	'Non-spam trackbacks' => 'Gültige TrackBacks',
	'Non-spam trackbacks on this website' => 'Gültige TrackBacks auf dieser Website',
	'Pending trackbacks' => 'Wartende TrackBacks',
	'Published trackbacks' => 'Veröffentlichte TrackBacks',
	'Trackbacks on my entries/pages' => 'TrackBacks zu meinen Einträgen/Seiten',
	'Trackbacks in the last 7 days' => 'TrackBacks der letzten 7 Tage',
	'Spam trackbacks' => 'Spam-TrackBacks',

## plugins/Trackback/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Bild',

## plugins/Trackback/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Original-Test',

## plugins/Trackback/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager 1.1 - Diese Version des Plugins dient ausschließlich dazu, Daten älterer Versionen auf das Movable Type Core-Schema zu aktualisieren. Sie können diese Plugin daher nach Installation bzw. Aktualisierung von Movable Type gefahrlos löschen.',
	'Moving storage of Widget Manager [_2]...' => 'Verschiebe Speicherort des Widget Managers [_2]...',
	'Failed.' => 'Fehlgeschlagen.',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Aus WordPress exportiertes RSS in Movable Type importieren',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => 'WordPress-Anhänge via HTTP herunterladen.',

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'No Site' => 'Keine Site',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Datei ist nicht im WXR-Format.',
	'Creating new tag (\'[_1]\')...' => 'Lege neuen Tag (\'[_1]\') an...',
	'Saving tag failed: [_1]' => 'Speichern des Tags fehlgeschlagen: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Doppeltes Asset (\'[_1]\') gefunden. Ãœberspringe...',
	'Saving asset (\'[_1]\')...' => 'Speichere Asset (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' und tagge Asset (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Doppelter Eintrag gefunden. Ãœberspringe...',
	'Saving page (\'[_1]\')...' => 'Speichere Seite (\'[_1]\')...',
	'Creating new comment (from \'[_1]\')...' => 'Lege neuen Kommentar (von &#8222;[_1]&#8220;) an...',
	'Saving comment failed: [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
	'Creating new ping (\'[_1]\')...' => 'Erzeuge neuen Ping &#8222;[_1]&#8220;)...',
	'Saving ping failed: [_1]' => 'Der Ping konnte nicht gespeichert werden: [_1]',
	'Assigning permissions for new user...' => 'Weise neuem Benutzer Berechtigungen zu...',
	'Saving permission failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{Bevor Sie WordPress-Einträge in Movable Type importieren, sollten Sie die <a href='[_1]'>Veröffentlichungspfade Ihrer Site einstellen</a>.},
	'Upload path for this WordPress blog' => 'Uploadpfad für dieses WordPress-Blog',
	'Replace with' => 'Ersetzen durch',
	'Download attachments' => 'Anhänge herunterladen',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Lädt Anhänge von Wordpress-Blogs im Hintergrund herunter. Cronjob erforderlich.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Anhänge (Bilder und Dateien) des importierten Wordpress-Blogs herunterladen.',

	'Synchronization([_1]) with an external server([_2]) has been successfully started.' => 'Synchronisation ([_1]) mit externem Server ([_2]) erfolgreich gestartet.', # Translate - New # OK
	'This email is to notify you that synchronization with an external server has been successfully started.' => 'Mit dieser E-Mail wird darauf hingewiesen, dass die Synchronisation mit einem externen Server erfolgreich gestartet wurde.', # Translate - New # OK
	'Immediate sync job is being registered. This job will be executed in next run-periodic-tasks execution.' => 'Der sofortige Synchronisations-Job wird registriert. Der Job wird bei der nächsten periodischen Ausführung von Aufgaben erledigt.', # Translate - New # OK
	'Immediate sync job has been registered.' => 'Sofortiger Synchronisations-Job registriert.', # Translate - New # OK
	'Register immediate sync job' => 'Sofortigen Synchronisations-Job registrieren', # Translate - New # OK
	'Are you sure you want to register immediate sync job?' => 'Sofortigen Synchronisations-Job wirklich registrieren?', # Translate - New # OK	
);

## New words: 1146

1;
