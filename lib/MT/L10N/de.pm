# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

## addons/Commercial.pack/config.yaml
	'Are you sure you want to delete the selected CustomFields?' => 'Gewählte eigene Felder wirklich löschen?',
	'Child Site' => 'Untersite',
	'No Name' => 'Kein Name',
	'Required' => 'Erforderlich',
	'Site' => 'Site',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Create Custom Field' => 'Eigenes Feld anlegen',
	'Custom Fields' => 'Eigene Felder',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Speichern Sie genau die Informationen, die Sie möchten, indem Sie die Formulare und Felder von Einträgen, Seiten, Ordnern, Kategorien und Benutzerkonten frei anpassen.',
	'Movable Type' => 'Movable Type',
	'Permission denied.' => 'Zugriff verweigert.',
	'Please ensure all required fields have been filled in.' => 'Bitte füllen Sie alle erforderlichen Felder aus.',
	'Please enter valid URL for the URL field: [_1]' => 'Bitte geben Sie eine gültige Web-Adresse in das Feld [_1] ein.',
	'Saving permissions failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'View image' => 'Bild ansehen',
	'You must select other type if object is the comment.' => 'Wählen Sie einen anderen Typ, wenn sich das Feld auf Kommentare bezieht.',
	'blog and the system' => 'Blog und das system',
	'blog' => 'Blog',
	'type' => 'Typ',
	'website and the system' => 'Website und das System',
	'website' => 'Website',
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben müssen das Format JJJJ-MM-TT HH:MM:SS haben.},
	q{Please enter some value for required '[_1]' field.} => q{Bitte füllen Sie das erforderliche Feld &#8222;[_1]&#8220; aus.},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{Der Basisname &#8222;[_1]&#8220; wird bereits verwendent. Er muss auf dieser [_2] eindeutig sein.},
	q{The template tag '[_1]' is already in use.} => q{Vorlagenbefehl &#8222;[_1]&#8220; bereits vorhanden},
	q{The template tag '[_1]' is an invalid tag name.} => q{&#8222;[_1]&#8220; ist kein gültiger Befehlsname.},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) hinzugefügt von Benutzer &#8222;[_4]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) gelöscht von &#8222;[_4]&#8220;},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => 'Fertig.',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Importiere in eigenen Feldern gefundene Asset-Verknüpfungen ( [_1] ) ...',
	'Importing custom fields data stored in MT::PluginData...' => 'Importiere Daten eigener Felder aus MT::PluginData...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Importiere URL der in eigenen Feldern verknüpften Assets ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Bitte geben Sie eine gültige Option für das [_1]-Feld an: [_2]',
	q{Invalid date '[_1]'; dates should be real dates.} => q{Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben sollten tatsächliche Daten sein},

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => 'Parameter "[_1]" erforderlich.',
	'The systemObject "[_1]" is invalid.' => 'Das systemObject "[_1]" ist ungültig.',
	'The type "[_1]" is invalid.' => 'Der Typ "[_1]" ist ungültig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Das angegebene includeShared-Parameter ist ungültig: [_1]',
	'Removing [_1] failed: [_2]' => '[_1] konnte nicht entfernt werden: [_2]',
	'Saving [_1] failed: [_2]' => '[_1] konnte nicht gespeichert werden: [_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Feld',
	'Fields' => 'Felder',
	'System Object' => 'Systemobjekt',
	'Type' => 'Typ',
	'_CF_BASENAME' => 'Basisname',
	'__CF_REQUIRED_VALUE__' => 'Wert',
	q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{Das bereits in [_3] verwendete &#8222;[_1]&#8220; des Vorlagenbefehls &#8222;[_2]&#8220; ist [_4].},
	q{The template tag '[_1]' is already in use in [_2]} => q{Der Vorlagenbefehl &#8222;[_1]&#8220; wird bereits in [_2] verwendet.},
	q{The template tag '[_1]' is already in use in the system level} => q{Der Vorlagenbefehl &#8222;[_1]&#8220; wird auf Systemebene bereits verwendet.},
	q{The template tag '[_1]' is already in use in this blog} => q{Der Vorlagenbefehl &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.},

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	q{Are you sure you have used a '[_1]' tag in the correct context? We could not find the [_2]} => q{Wird der Befehl [_1] im richtigen Kontext verwendet? Kann [_2] nicht finden},
	q{You used an '[_1]' tag outside of the context of the correct content; } => q{Befehl [_1] außerhalb des passenden Kontexts verwendet.},

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'Conflict of [_1] "[_2]" with [_3]' => ' [_1] "[_2]" steht in Konflikt mit [_3]',
	'a field on system wide' => 'Ein systemweites Feld',
	'a field on this blog' => 'Ein Feld dieses Blogs',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Klone Felder dieses Blogs:',
	'[_1] records processed.' => '[_1] Einträge bearbeitet.',
	'[_1] records processed...' => '[_1] Einträge bearbeitet...',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAP konnte nicht geladen werden: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Benutzer mit gleichem Namen gefunden und Konto daher nicht angelegt: [_1]',
	'Formatting error at line [_1]: [_2]' => 'Formatierungsfehler in Zeile [_1]: [_2]',
	'Invalid command: [_1]' => 'Unbekannter Befehl: [_1]',
	'Invalid display name: [_1]' => 'Ungültiger Anzeigename: [_1]',
	'Invalid email address: [_1]' => 'Ungültige E-Mail-Adresse: [_1]',
	'Invalid language: [_1]' => 'Sprache ungültig: [_1]',
	'Invalid number of columns for [_1]' => 'Ungültige Spaltenzahl für [_1]',
	'Invalid password: [_1]' => 'Ungültiges Passwort: [_1]',
	'Invalid user name: [_1]' => 'Ungültiger Benutzername: [_1]',
	'User cannot be created: [_1].' => 'Kann Benutzerkonto nicht anlegen: [_1].',
	'User cannot be updated: [_1].' => 'Benutzerkonto kann nicht aktualisiert werden: [_1].',
	q{Permission granted to user '[_1]'} => q{Berechtigungenga an Benutzer '[_1]' vergeben},
	q{User '[_1]' already exists. The update was not processed: [_2]} => q{Benutzer '[_1]' bereits vorhanden, Konto daher nicht aktualisiert: [_2]},
	q{User '[_1]' has been created.} => q{Benutzerkonto &#8222;[_1]&#8220; angelegt.},
	q{User '[_1]' has been deleted.} => q{Benutzerkonto '[_1]' gelöscht.},
	q{User '[_1]' has been updated.} => q{Benutzerkonto '[_1]' aktualisiert.},
	q{User '[_1]' not found.  The deletion was not processed.} => q{Benutzer '[_1]' nicht gefunden, Konto daher nicht gelöscht},
	q{User '[_1]' not found.  The update was not processed.} => q{Benutzer '[_1]' nicht gefunden, Konto daher nicht aktualisiert.},
	q{User '[_1]' was found, but the deletion was not processed} => q{Benutzer '[_1]' gefunden, Konto aber nicht gelöscht},

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'(no reason given)' => '(unbekannte Ursache)',
	'A user cannot change his/her own username in this environment.' => 'Benutzer können ihre eigenen Benutzernamen in diesem Kontext nicht ändern.',
	'An error occurred when enabling this user.' => 'Bei der Aktivierung dieses Benutzerkontos ist ein Fehler aufgetreten',
	'Bulk author export cannot be used under external user management.' => 'Stapelexport von Benutzerkonten bei externer Benutzerverwaltung nicht möglich.',
	'Bulk import cannot be used under external user management.' => 'Stapelimport ist bei externer Benutzerverwaltung nicht möglich.',
	'Bulk management' => 'Stapelverwaltung',
	'Cannot rewind' => 'Kann nicht zurückspulen',
	'Load failed: [_1]' => 'Beim Laden ist ein Fehler augetreten: [_1]',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Keine Einträge in Datei gefunden. Bitte stellen Sie sicher, daß für die Zeilenenden CRLF verwendet wird.',
	'Please select a file to upload.' => 'Bitte wählen die Datei aus, die Sie hochladen möchten.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Benutzer] registiert, [quant,_2,Benutzerkonto,Benutzerkonten] aktualisiert, [quant,_3,Benutzerkonto,Benutzerkonten] gelöscht.',
	'Users & Groups' => 'Benutzer und Gruppen',
	'Users' => 'Benutzer',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'Zur Synchronisierung von Gruppen muss LDAPGroupIDAttribute und/oder LDAPGroupNameAttribute gesetzt sein.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Es wurde versucht, alle Administratorenkonten zu deaktivieren. Synchronisation unterbrochen.',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Bereite Binärdaten zur Speicherung in Microsoft SQL Server vor...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => 'Gefunden',
	'Login' => 'Login',
	'Not Found' => 'Nicht gefunden',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Binding to LDAP server failed: [_1]' => 'Bindung an LDAP-Server fehlgeschlagen: [_1]',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert oder die installierte [_1]-Version ist zu alt.',
	'Entry not found in LDAP: [_1]' => 'Eintrag nicht im LDAP-Verzeichnig gefunden: [_1]',
	'Error connecting to LDAP server [_1]: [_2]' => 'Verbindung zu LDAP-Server [_1] fehlgeschlagen: [_2]',
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ungültiges LDAPAuthURL-Schema: [_1].',
	'More than one user with the same name found in LDAP: [_1]' => 'Mehrere Benutzer mit dem gleichen Namen im LDAP-Verzeichnis gefunden: [_1]',
	'User not found in LDAP: [_1]' => 'Benutzer nicht im LDAP-Verzeichnis gefunden: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] wird von dieser Version des MS SQL Server-Treibers nicht unterstützt.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Diese Version des UMSSQLServer-Treiber erfodert ein mit Unicode-Unterstützung compiliertes DBD::ODBC.',
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Diese Version des UMSSQLServer-Treibers erfordert DBD::ODBC in der Version 1.14.',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'Kann Vorlage nicht laden.',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen ([_1]). Sind die MailTransfer-Einstellungen richtig?',
	q{Cannot find author for id '[_1]'} => q{Kein Autor mit ID [_1] gefunden},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Es ist ein Rsync-Fehler aufgetreten, Exit-Code [_1]: [_2]',
	'Failed to remove "[_1]": [_2]' => '"[_1]" konnte nicht entfernt werden: [_2]',
	'Incomplete file copy to Temp Directory.' => 'Datei unvollständig in das temporäre Verzeichnis kopiert.',
	'Temp Directory [_1] is not writable.' => 'Das temporäre Verzeichnis [_1] kann nicht beschrieben werden.',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Synchronisations-Dateiliste',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*User deleted*' => '*Benutzer gelöscht*',
	'Are you sure you want to reset the sync log?' => 'Synchronisation-Protokoll wirklich zurücksetzen?',
	'FTP' => 'FTP',
	'Invalid parameter.' => 'Parameter ungültig.',
	'Rsync' => 'Rsync',
	'Showing only ID: [_1]' => 'Zeige nur ID [_1]',
	'Sync Name' => 'Name der Synchronisations-Einstellung',
	'Sync Result' => 'Synchronisation-Ergebnis',
	'Sync Type' => 'Art der Synchronisation',
	'Trigger' => 'Auslöser',
	'[_1] in [_2]: [_3]' => '[_1] in [_2]: [_3]',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Synchronisations-Einstellungen',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '', # Translate - New

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Create Sync Setting' => 'Synchronisations-Einstellung anlegen',
	'Invalid request.' => 'Ungültige Anfrage.',
	'Permission denied: [_1]' => 'Zugriff verweigert: [_1]',
	'Save failed: [_1]' => 'Beim Speichern ist ein Fehler aufgetreten: [_1]',
	'Sync Settings' => 'Synchronisations-Einstellungen',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => 'Vorherige Synchronisations-Dateiliste geleert. [_1] von [_2].',
	'The sync setting with the same name already exists.' => 'Synchronisations-Einstellungen mit diesem Namen existieren bereits.',
	'[_1] (copy)' => '', # Translate - New
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{Bei der Verbindung mit dem FTP-Server '[_1]' ist ein Fehler aufgetreten: [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{}, # Translate - New
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{}, # Translate - New
	q{Deleting sync file list failed "[_1]": [_2]} => q{Löschen der Synchronisations-Dateiliste mit '[_1]' fehlgeschlagen: [_2]},
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{}, # Translate - New
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{Synchronisations-Einstellung '[_1]' (ID: [_2]) von [_3] gelöscht.},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{Synchronisations-Einstellung '[_1]' (ID: [_2]) von [_3] bearbeitet.},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Entferne alle Synchronisations-Jobs...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Are you sure you want to remove this settings?' => 'Diese Einstellung wirklich entfernen?',
	'Invalid date.' => 'Ungültiges Datum',
	'Invalid time.' => 'Zeitangabe ungültig.',
	'Sync name is required.' => 'Bitte geben Sie einen Namen an.',
	'Sync name should be shorter than [_1] characters.' => 'Der Name sollte höchstens [_1] Zeichen lang sein.',
	'The sync date must be in the future.' => 'Der Zeitpunkt der Synchronisation muss in der Zukunft liegen.',
	'You must make one or more destination settings.' => 'Bitte geben Sie mindestens ein Ziel an.',

## default_templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> ist das nächste Archiv.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> ist die nächste Kategorie.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag in diesem Blog.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> ist das vorherige Archiv.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> ist die vorherige Kategorie.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag in diesem Blog.',
	'About Archives' => 'Über das Archiv',
	'About this Archive' => 'Über dieses Archiv',
	'About this Entry' => 'Über diese Seite',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>, alle Einträge im <a href="[_2]">Archiv</a>.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Aktuelle Einträge finden Sie auf der <a href="[_1]">Startseite</a>.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Diese Seite enthält einen einen einzelnen Eintrag von [_1] vom <em>[_2]</em>.',
	'This page contains links to all of the archived content.' => 'Diese Seite enthält Links zu allen archivierten Inhalten.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Diese Seite enthält alle Einträge von <strong>[_1]</strong> von neu nach alt.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Diese Archivseite enthält alle Einträge der Kategorie <strong>[_1]</strong> aus <strong>[_2]</strong>.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Diese Seite enthält aktuelle Einträge der Kategorie <strong>[_1]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</strong> aus <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Diese Seite enthält aktuelle Einträge von <strong>[_1]</strong>.',

## default_templates/archive_index.mtml
	'Archives' => 'Archiv',
	'Author Archives' => 'Autorenarchiv',
	'Author Monthly Archives' => 'Monatliches Autorenarchiv',
	'Banner Footer' => 'Banner-Fuß',
	'Banner Header' => 'Banner-Kopf',
	'Categories' => 'Kategorien',
	'Category Monthly Archives' => 'Monatliches Kategoriearchiv',
	'HTML Head' => 'HTML-Kopf',
	'Monthly Archives' => 'Monatsarchiv',
	'Sidebar' => 'Seitenleiste',

## default_templates/archive_widgets_group.mtml
	'Category Archives' => 'Kategoriearchiv',
	'Current Category Monthly Archives' => 'Monatsarchiv der aktuellen Kategorie',
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Diese Widgetgruppe zeigt auf die jeweilige Archivseite zugeschnittene Informationen an: [_1] ',

## default_templates/author_archive_list.mtml
	'Authors' => 'Autoren',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a href="[_1]">Creative Commons-Lizenz</a>.',
	'_POWERED_BY' => 'Powered by<br /><a href="https://www.movabletype.org/"><$MTProductName$></a>',

## default_templates/calendar.mtml
	'Fri' => 'Fr',
	'Friday' => 'Freitag',
	'Mon' => 'Mo',
	'Monday' => 'Montag',
	'Monthly calendar with links to daily posts' => 'Monatskalender. Die Datumsangaben werden automatisch mit den jeweiligen Seiten des Tagesarchivs verlinkt.',
	'Sat' => 'Sa',
	'Saturday' => 'Samstag',
	'Sun' => 'So',
	'Sunday' => 'Sonntag',
	'Thu' => 'Do',
	'Thursday' => 'Donnerstag',
	'Tue' => 'Di',
	'Tuesday' => 'Dienstag',
	'Wed' => 'Mi',
	'Wednesday' => 'Mittwoch',

## default_templates/category_entry_listing.mtml
	'Entry Summary' => 'Zusammenfassung',
	'Main Index' => 'Übersicht',
	'Recently in <em>[_1]</em> Category' => 'Neues in der Kategorie <em>[_1]</em>',
	'[_1] Archives' => '[_1]-Archiv',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Monatsarchiv',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Daily Archives' => 'Tägliches Autorenarchiv',
	'Author Weekly Archives' => 'Wöchentliches Autorenarchiv',
	'Author Yearly Archives' => 'Jährliches Autorenarchiv',

## default_templates/date_based_category_archives.mtml
	'Category Daily Archives' => 'Tägliches Kategoriearchiv',
	'Category Weekly Archives' => 'Wöchentliches Kategoriearchiv',
	'Category Yearly Archives' => 'Jährliches Kategoriearchiv',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Seite nicht gefunden',

## default_templates/entry.mtml
	'# Comments' => '# Kommentare',
	'# TrackBacks' => '# TrackBacks',
	'1 Comment' => '1 Kommentar',
	'1 TrackBack' => '1 TrackBack',
	'By [_1] on [_2]' => 'Von [_1] zu [_2]',
	'Comments' => 'Kommentare',
	'No Comments' => 'Keine Kommentare',
	'No TrackBacks' => 'Keine TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '<a rel="bookmark" href="[_1]">[_2]</a> weiterlesen',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/javascript.mtml
	'Edit' => 'Bearbeiten',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Antwort auf den <a href="[_1]" onclick="[_2]">Kommentar von [_3]</a>',
	'Signing in...' => 'Anmeldung...',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Danke für Ihre Anmeldung, __NAME__. ([_1]Abmelden[_2])',
	'The sign-in attempt was not successful; Please try again.' => 'Anmeldeversuch nicht erfolgreich. Bitte versuchen Sie es erneut.',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'Sie haben nicht die notwendige Berechtigung, um in diesem Blog Kommentare zu schreiben. ([_1]Abmelden[_2])',
	'Your session has expired. Please sign in again to comment.' => 'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Anmelden[_2] um zu kommentieren oder anonym kommentieren',
	'[_1]Sign in[_2] to comment.' => '[_1]Anmelden[_2] um zu kommentieren',
	'[quant,_1,day,days] ago' => 'vor [quant,_1,Tag,Tagen]',
	'[quant,_1,hour,hours] ago' => 'vor [quant,_1,Stunde,Stunden]',
	'[quant,_1,minute,minutes] ago' => 'vor [quant,_1,Minute,Minuten]',
	'moments ago' => 'vor einem Augenblick',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'IP-Adresse: [_1]',
	'Mail Footer' => 'Mail-Signatur',
	'Recovery: [_1]' => 'Entsperren: [_1]',
	'This email is to notify you that an IP address has been locked out.' => 'Eine IP-Adresse wurde automatisch gesperrt.',

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => 'Benutzername: [_1]',
	'Email: [_1]' => 'E-Mail-Adresse:',
	'If you want to permit this user to participate again, click the link below.' => 'Um das Konto wieder freizuschalten, klicken Sie auf folgenden Link.',
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Ein Movable Type-Benutzerkonto wurde automatisch gesperrt.',
	'Username: [_1]' => 'Benutzername: [_1]',

## default_templates/main_index_widgets_group.mtml
	'Recent Assets' => 'Aktuelle Assets',
	'Recent Comments' => 'Aktuelle Kommentare',
	'Recent Entries' => 'Aktuelle Einträge',
	'Tag Cloud' => 'Tag-Wolke',
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Diese Widgetgruppe erscheint ausschließlich auf der Startseite (bzw. auf der von der Vorlage "main_index" erzeugten Seite). Weitere Informationen: [_1]',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Monat wählen...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archiv</a>',

## default_templates/notify-entry.mtml
	'Message from Sender:' => 'Nachricht des Absenders:',
	'Publish Date: [_1]' => 'Veröffentlichungsdatum:',
	'View entry:' => 'Eintrag ansehen:',
	'View page:' => 'Seite ansehen:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Sie erhalten diese E-Mail, da Sie entweder Nachrichten über Aktualisierungen von [_1] bestellt haben oder da der Autor dachte, daß dieser Eintrag für Sie von Interesse sein könnte. Wenn Sie solche Mitteilungen nicht länger erhalten wollen, wenden Sie sich bitte an ',
	'[_1] Title: [_2]' => 'Titel: [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Ein neuer [_3] namens &#8222;[_1]&#8220; wurde auf [_2] veröffentlicht.},

## default_templates/openid.mtml
	'Learn more about OpenID' => 'Mehr über OpenID erfahren',
	'[_1] accepted here' => '[_1] unterstützt',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',

## default_templates/pages_list.mtml
	'Pages' => 'Seiten',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Um das Passwort Ihres Movable-Type-Benutzerkontos zu ändern, klicken Sie bitte auf folgenden Link.',
	'If you did not request this change, you can safely ignore this email.' => 'Wenn Sie Ihr Passwort nicht ändern möchten, können Sie diese E-Mail bedenkenlos ignorieren.',

## default_templates/search.mtml
	'Search' => 'Suchen',

## default_templates/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'ie Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',
	'Instructions' => 'Hinweise',
	'Next' => 'Vor',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Kein Suchergebnis für &#8222;[_1]&#8220;',
	'Previous' => 'Zurück',
	'Results matching &ldquo;[_1]&rdquo;' => 'Suchergebnis für &#8222;[_1]&#8220;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Suchergebnis für Tag &#8222;[_1]&#8220;',
	'Search Results' => 'Suchergebnis',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'Die Boolschen Operatoren AND, OR und NOT werden unterstützt:',
	'movable type' => 'Movable Type',
	'personal OR publishing' => 'Schrank OR Schublade',
	'publishing NOT personal' => 'Regal NOT Schrank',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Zweispaltig - Seitenleiste',
	'3-column layout - Primary Sidebar' => 'Dreispaltig- Primäre Seitenleiste',
	'3-column layout - Secondary Sidebar' => 'Dreispaltig - Sekundäre Seitenleiste',

## default_templates/signin.mtml
	'Sign In' => 'Anmelden',
	'You are signed in as ' => 'Sie sind angemeldet als',
	'You do not have permission to sign in to this blog.' => 'Sie haben keine Berechtigung zur Anmeldung an diesem Blog.',
	'sign out' => 'abmelden',

## default_templates/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feeds aller Ergebnisse zu &#8222;[_1]&#8220; abonnieren',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed aller mit &#8222;[_1]&#8220; getaggten Ergebnisse abonnieren',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Feed aller künftigen Einträge mit &#8222;[_1]&#8220; abonnieren',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Feed aller künftigen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren',
	'Subscribe to feed' => 'Feed abonnieren',
	q{Subscribe to this blog's feed} => q{Feed dieses Blogs abonnieren},

## lib/MT.pm
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
	'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft',
	'Bad LocalLib config ([_1]): [_2]' => 'Fehlerhafte LocalLib-Einstellungen ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen',
	'Error while creating email: [_1]' => 'Fehler beim Anlegen einer E-Mail: [_1]',
	'Fourth argument to add_callback must be a CODE reference.' => 'Das vierte Argument von add_callback muss eine CODE-Referenz sein.',
	'Google' => 'Google',
	'Hatena' => 'Hatena',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Hello, world' => 'Hallo Welt',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Falls vorhanden, muss das dritte Argument von add_callback ein MT::Component- oder MT::Plugin-Objekt sein.',
	'Internal callback' => 'Interner Callback',
	'Invalid priority level [_1] at add_callback' => 'Ungültiger Prioritätslevel [_1] von add_callback',
	'LiveJournal' => 'LiveJournal',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Keine Konfigurationsdatei gefunden. Haben Sie möglicheweise vergessen, mt-config.cgi-original in mt-config.cgi umzubennen?',
	'Movable Type default' => 'Movable Type-Standard',
	'OpenID' => 'OpenID',
	'Plugin error: [_1] [_2]' => 'Plugin-Fehler: [_1] [_2]',
	'Powered by [_1]' => 'Powered by [_1]',
	'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => 'Plugin ohne Namen',
	'Version [_1]' => 'Version [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'WordPress.com',
	'Yahoo! JAPAN' => 'Yahoo! Japan',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1] abgebrochen mit [_2]',
	'https://www.movabletype.com/' => 'https://www.movabletype.com/',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'livedoor' => 'livedoor',
	q{Loading template '[_1]' failed.} => q{Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden.},

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App.pm
	'(Display Name not set)' => '(Kein Anzeigename festgelegt)',
	'A user with the same name already exists.' => 'Ein Benutzer mit diesem Namen existiert bereits.',
	'An error occurred while trying to process signup: [_1]' => 'Bei der Bearbeitung Ihrer Anmeldung ist ein Fehler aufgetreten: [_1]',
	'Back' => 'Zurück',
	'Cannot load blog #[_1]' => 'Konnte Blog #[_1] nicht laden',
	'Cannot load blog #[_1].' => 'Konnte Blog #[_1] nicht laden.',
	'Cannot load entry #[_1].' => 'Konnte Eintrag #[_1] nicht laden',
	'Cannot load site #[_1].' => 'Konnte Site #[_1] nicht laden.',
	'Close' => 'Schließen',
	'Display Name' => 'Anzeigename',
	'Email Address is invalid.' => 'Die E-Mail-Adresse ist ungültig.',
	'Email Address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'Email Address' => 'E-Mail-Adresse',
	'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
	'Failed login attempt by anonymous user' => '', # Translate - New
	'Failed to open pid file [_1]: [_2]' => 'Konnte PID-Datei [_1] nicht öffnen: [_2]',
	'Failed to send reboot signal: [_1]' => 'Konnte Reboot-Signal nicht senden: [_1]',
	'Internal Error: Login user is not initialized.' => 'Interner Fehler: Login-Benutzer nicht initialisiert.',
	'Invalid login.' => 'Login ungültig.',
	'Invalid request' => 'Ungültige Anfrage',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Es tut uns leid, aber Sie keine Berechtigung, auf Blogs oder Websites dieser Installation zuzugreifen. Sollte hier ein Irrtum vorliegen, wenden Sie sich bitte an Ihren Movable Type-Systemadministrator.',
	'Password should be longer than [_1] characters' => 'Passwörter müssen mindestens [_1] Zeichen lang sein',
	'Password should contain symbols such as #!$%' => 'Passwörter müssen mindestens ein Sonderzeichen wie #!$% enthalten',
	'Password should include letters and numbers' => 'Passwörter müssen sowohl Buchstaben als auch Ziffern enthalten',
	'Password should include lowercase and uppercase letters' => 'Passwörter müssen sowohl Groß- als auch Kleinbuchstaben enthalten',
	'Password should not include your Username' => 'Ihr Benutzername darf nicht Teil Ihres Passworts sein',
	'Passwords do not match.' => 'Die Passwörter stimmen nicht überein.',
	'Problem with this request: corrupt character data for character set [_1]' => 'Es ist ein Fehler aufgetreten: ungültige Zeichen für Zeichensatz [_1]',
	'Removed [_1].' => '[_1] entfernt.',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Sie sind nicht berechtigt, auf Blogs oder Websites dieser Movable-Type-Installation zuzugreifen. Sollte es sich dabei um einen Fehler handeln, wenden Sie sich bitte an Ihren Administrator.',
	'System Email Address is not configured.' => 'Die System-E-Mail-Adresse ist nicht konfiguriert.',
	'Text entered was wrong.  Try again.' => 'Der eingegebene Text ist nicht richtig. Bitte versuchen Sie es erneut.',
	'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu groß.',
	'The login could not be confirmed because of a database error ([_1])' => 'Der Anmeldevorgang konnte wegen eines Datenbankfehlers nicht abgeschlossen werden ([_1])',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde gelöscht. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde deaktiviert. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'URL is invalid.' => 'Die URL ist ungültig.',
	'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
	'Unknown error occurred.' => 'Es ist ein unbekannter Fehler aufgetreten.',
	'User requires display name.' => 'Anzeigename erforderlich.',
	'User requires password.' => 'Passwort erforderlich.',
	'User requires username.' => 'Benutzername erforderlich.',
	'Username' => 'Benutzername',
	'Warnings and Log Messages' => 'Warnungen und Logmeldungen',
	'You did not have permission for this action.' => 'Zu dieser Aktion sind Sie nicht berechtigt.',
	'[_1] contains an invalid character: [_2]' => '[_1] enthält ein ungültiges Zeichen: [_2]',
	q{Failed login attempt by deleted user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by disabled user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von deaktiviertem Benutzer '[_1]'},
	q{Failed login attempt by locked-out user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by pending user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von wartendem Benutzer &#8222;[_1]&#8220;},
	q{Failed login attempt by unknown user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer '[_1]'},
	q{Failed login attempt by user '[_1]'} => q{}, # Translate - New
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{Die in IISFastCGIMonitoringFilePath angegebene Monitoring-Datei konnte nicht geöffnet werden:},
	q{Invalid login attempt from user '[_1]'} => q{Ungültiger Anmeldeversuch von Benutzer &#8222;[_1]&#8220;},
	q{New Comment Added to '[_1]'} => q{Neuer Kommentar zu &#8222;[_1]&#8220; eingegangen},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) erfolgreich angemeldet},
	q{User '[_1]' (ID:[_2]) logged out} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) abgemeldet},

## lib/MT/App/ActivityFeeds.pm
	'All "[_1]" Content Data' => 'Alle "[_1]"-Inhaltsdaten',
	'All Activity' => 'Alle Aktivitäten',
	'All Entries' => 'Alle Einträge',
	'All Pages' => 'Alle Seiten',
	'An error occurred while generating the activity feed: [_1].' => 'Bei Erzeugung des Aktivitäts-Feeds ist ein Fehler aufgetreten: [_1].',
	'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
	'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',
	'Movable Type System Activity' => 'Movable Type System-Aktivität',
	'No permissions.' => 'Keine Berechtigung.',
	'[_1] "[_2]" Content Data' => '[_1] "[_2]"-Inhaltsdaten',
	'[_1] Activity' => '[_1] Aktivitäten',
	'[_1] Entries' => '[_1] Einträge',
	'[_1] Pages' => '[_1] Seiten',

## lib/MT/App/CMS.pm
	'Activity Log' => 'Aktivitäten',
	'Add Contact' => 'Kontakt hinzufügen',
	'Add IP Address' => 'IP-Adresse hinzufüge',
	'Add Tags...' => 'Tags hinzufügen...',
	'Add a user to this [_1]' => 'Benutzer zur [_1] hinzufügen',
	'Add user to group' => 'Benutzer zu Gruppe hinzufügen',
	'Address Book' => 'Adressbuch',
	'Are you sure you want to delete the selected group(s)?' => 'Gewählte Gruppe(n) wirklich löschen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Gewählte(n) Benutzer wirklich aus Gruppe entfernen?',
	'Are you sure you want to reset the activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
	'Asset' => 'Asset',
	'Assets' => 'Assets',
	'Associations' => 'Verknüpfungen',
	'Batch Edit Entries' => 'Mehrere Einträge bearbeiten',
	'Batch Edit Pages' => 'Mehrere Seiten bearbeiten',
	'Blog' => 'Blog',
	'Cannot load blog (ID:[_1])' => 'Kann Blog (ID:[_1]) nicht laden',
	'Category Sets' => 'Kategorie-Sets',
	'Clear Activity Log' => 'Aktivitätsprotokoll zurücksetzen',
	'Clone Child Site' => 'Untersite klonen',
	'Clone Template(s)' => 'Vorlage(n) klonen',
	'Compose' => 'Schreiben',
	'Content Data' => 'Inhaltsdaten',
	'Content Types' => 'Inhaltstypen',
	'Create Role' => 'Rolle anlegen',
	'Delete' => 'Löschen',
	'Design' => 'Gestalten',
	'Disable' => 'Deaktivieren',
	'Documentation' => 'Dokumentation',
	'Download Address Book (CSV)' => 'Adressbuch herunterladen (CSV)',
	'Download Log (CSV)' => 'Protokoll herunterladen (CSV)',
	'Edit Template' => 'Vorlage bearbeiten',
	'Enable' => 'Aktivieren',
	'Entries' => 'Einträge',
	'Entry' => 'Eintrag',
	'Error during publishing: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Export Site' => 'Site exportieren',
	'Export Sites' => 'Sites exportieren',
	'Export Theme' => 'Thema exportieren',
	'Export' => 'Exportieren',
	'Feedback' => 'Feedback',
	'Feedbacks' => 'Feeback',
	'Filters' => 'Filter',
	'Folders' => 'Ordner',
	'General' => 'Allgemein',
	'Grant Permission' => 'Berechtigungen zuweisen',
	'Groups ([_1])' => 'Gruppen ([_1])',
	'Groups' => 'Gruppen',
	'IP Banning' => 'IP-Sperren',
	'Import Sites' => 'Sites importieren',
	'Import' => 'Importieren',
	'Invalid parameter' => 'Ungültiges Parameter',
	'Manage Members' => 'Mitglieder verwalten',
	'Manage' => 'Verwalten',
	'Movable Type News' => 'Movable Type Aktuell',
	'Move child site(s) ' => 'Untersite(s) verschieben',
	'New' => 'Neu',
	'No such blog [_1]' => 'Kein Weblog [_1]',
	'None' => 'Kein(e)',
	'Notification Dashboard' => 'Notification Dashboard',
	'Page' => 'Seite',
	'Permissions' => 'Berechtigungen',
	'Plugins' => 'Plugins',
	'Profile' => 'Profil',
	'Publish Template(s)' => 'Vorlage(n) veröffentlichen',
	'Publish' => 'Veröffentlichen',
	'Rebuild Trigger' => 'Auslöser für Neuaufbau',
	'Rebuild' => 'Neu aufbauen',
	'Recover Password(s)' => 'Passwort anfordern',
	'Refresh Template(s)' => 'Vorlage(n) zurücksetzen',
	'Refresh Templates' => 'Vorlagen zurücksetzen',
	'Remove Tags...' => 'Tags entfernen...',
	'Remove' => 'Entfernen',
	'Revoke Permission' => 'Berechtigung entziehen',
	'Roles' => 'Rollen',
	'Search & Replace' => 'Suchen & Ersetzen',
	'Settings' => 'Einstellungen',
	'Sign out' => 'Abmelden',
	'Site List for Mobile' => 'Site-Liste in Mobilansicht',
	'Site List' => 'Site-Liste',
	'Site Stats' => 'Site-Statistik',
	'Sites' => 'Sites',
	'System Information' => 'Systeminformation',
	'Tags to add to selected assets' => 'Gewählte Assets mit diesen Tags versehen',
	'Tags to add to selected entries' => 'Gewählte Einträge mit diesen Tags versehen',
	'Tags to add to selected pages' => 'Gewählte Seiten mit diesen Tags versehen',
	'Tags to remove from selected assets' => 'Diese Tags von gewählten Assets entfernen',
	'Tags to remove from selected entries' => 'Diese Tags von gewählten Einträgen entfernen',
	'Tags to remove from selected pages' => 'Diese Tags von gewählten Seiten entfernen',
	'Themes' => 'Themen',
	'Tools' => 'Tools',
	'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
	'Unlock' => 'Entsperren',
	'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
	'Unpublish Pages' => 'Seiten nicht mehr veröffentlichen',
	'Updates' => 'Updates',
	'Upload' => 'Hochladen',
	'Use Publishing Profile' => 'Veröffentlichungsprofil verwenden',
	'User' => 'Benutzer',
	'View Site' => 'Ansehen',
	'Web Services' => 'Webdienste',
	'Website' => 'Website',
	'_WARNING_DELETE_USER' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen?',
	'_WARNING_DELETE_USER_EUM' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen? Benutzer können ihre Konten selbst wiederherstellen, solange sie noch in externen Verzeichnissen aufgeführt sind.',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Sie sind dabei, E-Mails zu verschicken, mit denen die gewählten Benutzer ihre Passwörter zurücksetzen können. Fortfahren?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Hiermit werden die Vorlagen der gewählten Blogs auf die Standardvorlagen zurückgesetzt. Möchten Sie die Vorlagen der gewählten Blogs wirklich zurücksetzen?',
	'content data' => 'Inhaltsdaten',
	'entry' => 'Eintrag',
	q{Failed login attempt by user who does not have sign in permission. '[_1]' (ID:[_2])} => q{Fehlgeschlagener Anmeldeversuch von Benutzer ohne Anmeldeberechtigung. '[_1]' (ID:[_2])},
	q{[_1]'s Group} => q{Gruppen von [_1]},

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Nicht alle Websites gelöscht. Bitte löschen Sie zuerst die zu den jeweiligen Websites gehörende Blogs.',

## lib/MT/App/DataAPI.pm
	'[_1] must be a number.' => '[_1] muss eine Zahl sein.',
	'[_1] must be an integer and between [_2] and [_3].' => '[_1] muss eine ganze Zahl zwischen [_2] und [_3] sein.',

## lib/MT/App/Search.pm
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Konnte Suchergebnis nicht zwischenspeichern. [_1] nicht verfügbar: [_2]',
	'Filename extension cannot be asp or php for these archives' => 'Bei diesem Archivtyp darf die Dateierweiterung nicht ASP oder PHP lauten.',
	'Invalid [_1] parameter.' => 'Ungültiger [_1]-Parameter.',
	'Invalid archive type' => 'Ungültiger Archivtyp',
	'Invalid format: [_1]' => 'Ungültiges Format: [_1]',
	'Invalid query: [_1]' => 'Ungültige Suchanfrage: [_1]',
	'Invalid type: [_1]' => 'Ungültiger Typ: [_1]',
	'Invalid value: [_1]' => 'Ungültiger Wert: [_1]',
	'No column was specified to search for [_1].' => 'Keine Spalte zur Suche nach [_1] angegeben.',
	'No such template' => 'Keine solche Vorlage',
	'Output file cannot be of the type asp or php' => 'Die Ausgabedatei kann nicht im Format ASP oder PHP sein. ',
	'Template must be a main_index for Index archive type' => 'Verwenden Sie für Index-Archivseiten eine main_index-Vorlage.',
	'Template must be archive listing for non-Index archive types' => 'Verwenden Sie eine Archivliste für Archive ohne Indizes',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'Die Suche dauert zu lange. Bitte vereinfachen Sie Ihre Suchanfrage und versuchen Sie es erneut.',
	'Unsupported type: [_1]' => 'Nicht unterstützter Typ: [_1]',
	'You must pass a valid archive_type with the template_id' => 'Bitte übergeben Sie mit der template_id eine gültige archive_type-Angabe',
	'template_id cannot refer to a global template' => 'template_id kann sich nicht auf eine globale Vorlage beziehen.',
	q{No alternate template is specified for template '[_1]'} => q{Keine Alternative zu Vorlage &#8222;[_1]&#8220; angegeben.},
	q{Opening local file '[_1]' failed: [_2]} => q{Konnte lokale Datei &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Search: query for '[_1]'} => q{Suche: Suche nach &#8222;[_1]&#8220;},

## lib/MT/App/Search/ContentData.pm
	'Invalid SearchContentTypes "[_1]": [_2]' => 'Ungültiges SearchContentTypes "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'Ungültiges SearchContentTypes: [_1]',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch verwendet MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'Die beiden Passwörter müssen übereinstimmen.',
	'Could not authenticate using the credentials provided: [_1].' => 'Authentifizierung mit den angegeben Daten fehlgeschlagen: [_1]',
	'Invalid session.' => 'Ungültige Session',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type erfolgreich auf Version [_1] aktualisiert.',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Keine Berechtigung. Bitte wenden Sie sich zur Aktualisierung dieser Movable-Type-Installation an Ihren Administrator.',
	'You must supply a password.' => 'Bitte geben Sie ein Passwort an.',
	q{Invalid email address '[_1]'} => q{Ungültige E-Mail-Adresse '[_1]'},
	q{The 'Website Root' provided below is not allowed} => q{Das angegebene Wurzelverzeichnis der Website ist ungültig bzw. nicht zulässig.},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{Der Server kann das angegebene Wurzelverzeichnis der Website nicht beschreiben. Bitte ändern Sie die entsprechenden Zugriffs- und/oder Besitzer-Rechte und klicken Sie dann erneut auf 'Installation abschließen'.},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Die Datenbankverbindung konnte nicht aufgebaut werden. Bitte überprüfen Sie die Einstellungen und versuchen Sie es erneut.',
	'CGI is required for all Movable Type application functionality.' => 'CGI ist für sämtliche Movable Type-Funktionen erforderlich.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File ist zur Authentifizierung von Kommentarautoren über OpenID bei Yahoo! Japan erforderlich.',
	'DBI is required to work with most supported databases.' => 'DBI ist für die meisten Datenbank-Typen erforderlich.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA ist für den verbesserten Schutz der verwendeten Passwörter erforderlich.',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec ist auf allen unterstützten Betriebssystem ',
	'HTML::Entities is required by CGI.pm' => 'HTML::Entities ist für CGI.pm erforderlich.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Die Installation von HTML::Parser ist optional . Dieses Modul ist erforderlich, wenn Sie das TrackBack-System, weblogs.com-Pings und andere Aktualisierungs-Benachrichtigungen verwenden wollen.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL ist für alle SSL/TSL-Verbindungen erforderlich, beispielsweise für Statistiken von Google Analytics und für sichere SMTP-Authentifizierung.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent ist zur Erzeugung von Movable Type-Konfigurationsdateien mit dem Konfigurationsassistenten erforderlich.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Die Installation von List::Util ist optional. Dieses Modul ist zur Nutzung der Veröffentlichungs-Warteschlange erforderlich.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP ist für den Versand von E-Mails über SMTP-Server erforderlich.',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay ist zur Verwendung von SMTP Auth über SSL oder mit STARTSSL erforderlich.',
	'Please select a database from the list of available databases and try again.' => 'Bitte wählen Sie einen Datenbank-Typ aus der Liste der verfügbaren Typen und versuchen Sie es erneut.',
	'SMTP Server' => 'SMTP-Server',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util ist zur Initialisierung von Movable Type erforderlich.',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Testmail vom Movable Type-Konfigurationsassistenten',
	'The [_1] database driver is required to use [_2].' => 'Ein [_1]-Datenbanktreiber ist erforderlich, um eine [_2] zu nutzen.',
	'The [_1] driver is required to use [_2].' => 'Zur Nutzung von [_2] ist ein [_1]-Treiber erforderlich.',
	'This is the test email sent by your new installation of Movable Type.' => 'Diese Testmail wurde von Ihrer neuen Movable Type-Installation verschickt.',
	'This module accelerates comment registration sign-ins.' => 'Dieses Modul beschleunigt die Anmeldung als Kommentarautor.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Dieses Modul und seine Abhängigkeiten sind zur Authentifizierung von Kommentar-Autoren mittels OpenID (einschließlich LiveJournal) erforderlich.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Dieses Modul und seine Abhängigkeiten sind zum Einspielen von Sicherheitskopien erforderlich.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Dieses Modul und seine Abhängigkeiten sind zur Verwendung von CRAM-MD5, DIGEST-MD5 und LOGIN SASL erforderlich.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Dieses Modul und seine Abhängigkeiten sind zum Betrieb von Movable Type unter psgi erforderlich.',
	'This module enables the use of the Atom API.' => 'Dieses Modul ermöglicht die Verwendung der ATOM-API.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Dieses Modul ist zur Nutzung des XML-RPC-Servers von Movable Type erforderlich.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Dieses Modul ist zur Erzeugung von Vorschaubildern von hochgeladenen Dateien erforderlich.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Dieses Modul ist zum Überschreiben bereits vorhandener Dateien beim Hochladen erforderlich.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Dieses Modul ist erforderlich, wenn Sie NetPBM als Bildquelle verwenden möchten.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Dieses Modul ist zur Registrierung von Kommentarautoren und zum Versand von E-Mails über SMTP erforderlich.',
	'This module is required by certain MT plugins available from third parties.' => 'Dieses Modul ist für einige MT-Plugins von Drittanbietern erforderlich.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Dieses Modul ist für mt-search.cgi erforderlich, wenn Sie Movable Type unter Perl älter als Version 5.8 ausführen.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Dieses Modul ist für Google Analytics und zur Überprüfung von SSL-Zertifikaten erforderlich.',
	'This module is required for XML-RPC API.' => 'Dieses Modul ist für XML-RPC API erforderlich.',
	'This module is required for cookie authentication.' => 'Dieses Modul ist zur Cookie-Authentifizierung erforderlich.',
	'This module is required for executing run-periodic-tasks.' => 'Dieses Modul wird zur periodischen Ausführung von Tasks erforderlich.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Dieses Modul ist zur Bestimmung der Größe hochgeladener Dateien erforderlich.',
	'This module is required in order to archive files in backup/restore operation.' => 'Dieses Modul ist zur Archivierung von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to compress files in backup/restore operation.' => 'Dieses Modul ist zur Packen von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Dieses Modul ist zum Entpacken von Dateien beim Erstellen und Einspielen von Sicherheitskopien erforderlich.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Dieses Modul ist zur Verwendung von memcached als Cache-System für Movable Type erforderlich.',
	'This module is used by the Markdown text filter.' => 'Dieses Modul ist für den Markdown-Textfilter erforderlich.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Dieses Modul ist für ein test-Attribut des MTIf-Befehls erforderlich.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherheitskopien erforderlich sind.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck ist optional. Es handelt sich um eine bessere, kleinere und schnellere Alternative zu YAML::Tiny.',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Autor',
	'author/author-basename/index.html' => 'autor/autoren-basisname/index.html',
	'author/author_basename/index.html' => 'autor/autoren-basisname/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'Autor täglich',
	'author/author-basename/yyyy/mm/dd/index.html' => 'autor/autoren-basisname/jjjj/mm/tt/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'autor/autoren_basisname/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'Autor monatlich',
	'author/author-basename/yyyy/mm/index.html' => 'autor/autoren-basisname/jjjj/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'autor/autoren_basisname/jjjj/mm/index.hmtl',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'Autor wöchentlich',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'autor/autoren-basisname/jjjj/mm/wochen-tag/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'autor/autoren-basisname/jjjj/mm/wochen-tag/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'Autor jährlich',
	'author/author-basename/yyyy/index.html' => 'autor/autoren-basisname/jjjj/index.html',
	'author/author_basename/yyyy/index.html' => 'autor/autoren_basisname/jjjj/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Kategorie',
	'category/sub-category/index.html' => 'kategorie/unter-kategorie/index.html',
	'category/sub_category/index.html' => 'kategorie/unter_kategorie/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'Kategorie täglich',
	'category/sub-category/yyyy/mm/dd/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tt/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'Kategorie monatlich',
	'category/sub-category/yyyy/mm/index.html' => 'kategorie/unter-kategorie/jjjj/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'kategorie/unter_kategorie/jjjj/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'Kategorie wöchentlich',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'kategorie/unter-kategorie/jjjj/mm/tag-woche/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'kategorie/unter_kategorie/jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'Kategorie jährlich',
	'category/sub-category/yyyy/index.html' => 'kategorie/unter-kategorie/jjjj/index.html',
	'category/sub_category/yyyy/index.html' => 'kategorie/unter_kategorie/jjjj/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'CONTENTTYPE_ADV' => 'Inhaltstyparchiv',
	'author/author-basename/content-basename.html' => 'autor/autoren-basisname/inhalts-basisname.html',
	'author/author-basename/content-basename/index.html' => 'autor/autoren-basisname/inhalts-basisname/index.html',
	'author/author_basename/content_basename.html' => 'autor/autoren_basisname/inhalts_basisname.html',
	'author/author_basename/content_basename/index.html' => 'autor/autoren_basisname/inhalts_basisname/index.html',
	'category/sub-category/content-basename.html' => 'kategorie/unter-kategorie/inhalts-basisname.html',
	'category/sub-category/content-basename/index.html' => 'kategorie/unter-kategorie/inhalts-basisname/index.html',
	'category/sub_category/content_basename.html' => 'kategorie/unter_kategorie/inhalts_basisname.html',
	'category/sub_category/content_basename/index.html' => 'kategorie/unter_kategorie/inhalts_basisname/index.html',
	'yyyy/mm/content-basename.html' => 'jjjj/mm/inhalts-basisname.html',
	'yyyy/mm/content-basename/index.html' => 'jjjj/mm/inhalts-basisname/index.html',
	'yyyy/mm/content_basename.html' => 'jjjj/mm/inhalts_basisname.html',
	'yyyy/mm/content_basename/index.html' => 'jjjj/mm/inhalts_basisname/index.html',
	'yyyy/mm/dd/content-basename.html' => 'jjjj/mm/tt/inhalts-basisname.html',
	'yyyy/mm/dd/content-basename/index.html' => 'jjjj/mm/tt/inhalts-basisname/index.html',
	'yyyy/mm/dd/content_basename.html' => 'jjjj/mm/tt/inhalts_basisname.html',
	'yyyy/mm/dd/content_basename/index.html' => 'jjjj/mm/tt/inhalts_basisname/index.html',

## lib/MT/ArchiveType/ContentTypeAuthor.pm
	'CONTENTTYPE-AUTHOR_ADV' => 'Inhaltstyparchiv nach Autor',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Autor',

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Autor',

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Autor',

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Autor',

## lib/MT/ArchiveType/ContentTypeCategory.pm
	'CONTENTTYPE-CATEGORY_ADV' => 'Inhaltstyparchiv nach Kategorie',

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Kategorie',

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Kategorie',

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Kategorie',

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Kategorie',

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'CONTENTTYPE-DAILY_ADV' => 'tägliches Inhaltstyparchiv',
	'DAILY_ADV' => 'Täglich',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/tt/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'CONTENTTYPE-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv',
	'MONTHLY_ADV' => 'Monatlich',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'CONTENTTYPE-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv',
	'WEEKLY_ADV' => 'Wöchentlich',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'CONTENTTYPE-YEARLY_ADV' => 'jährliches Inhaltstyparchiv',
	'YEARLY_ADV' => 'Jährlich',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'Individuell',
	'category/sub-category/entry-basename.html' => 'kategorie/unter-kategorie/eintrags-name.html',
	'category/sub-category/entry-basename/index.html' => 'kategorie/unter-kategorie/eintrags-name/index.html',
	'category/sub_category/entry_basename.html' => 'kategorie/unter_kategorie/eintrags_name.html',
	'category/sub_category/entry_basename/index.html' => 'kategorie/unter_kategorie/eintrags_name/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/tt/eintrags-name.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/tt/eintrags-name/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/tt/eintrags_name.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/tt/eintrags_name/index.html',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/eintrags-name.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/eintrags-name/index.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/eintrags_name.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/eintrags_name/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Seite',
	'folder-path/page-basename.html' => 'pfad-angabe/seiten-name.html',
	'folder-path/page-basename/index.html' => 'pfad-angabe/seiten-name/index.html',
	'folder_path/page_basename.html' => 'pfad_angabe/seiten_name.html',
	'folder_path/page_basename/index.html' => 'pfad_angabe/seiten_name/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'Assets dieser Website',
	'Assets with Extant File' => 'Assets mit vorhandener Datei',
	'Assets with Missing File' => 'Assets mit fehlender Datei',
	'Audio' => 'Audio',
	'Author Status' => 'Status des Autors',
	'Content Data ( id: [_1] ) does not exists.' => 'Inhaltsdaten ( id: [_1] ) existieren nicht.',
	'Content Field ( id: [_1] ) does not exists.' => 'Inhaltsfeld ( id: [_1] ) existiert nicht.',
	'Content Field' => 'Inhaltsfeld',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'Inhaltstyp dieser Inhaltsdaten ( id: [_1] ) existiert nicht.',
	'Could not create asset cache path: [_1]' => 'Konnte Asset-Cache-Pfad nicht anlegen: [_1]',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Konnte Asset-Datei [_1] nicht aus Dateisystem löschen: [_2]',
	'Deleted' => 'Gelöscht',
	'Description' => 'Beschreibung',
	'Disabled' => 'Deaktiviert',
	'Enabled' => 'Aktiviert',
	'Except Userpic' => 'Benutzerbild ausnehmen',
	'File Extension' => 'Dateierweiterung',
	'File' => 'Datei',
	'Filename' => 'Dateiname',
	'Image' => 'Bild',
	'Label' => 'Bezeichnung',
	'Location' => 'Ort',
	'Missing File' => 'Datei fehlt',
	'Name' => 'Name',
	'No Label' => 'Keine Bezeichnung',
	'Pixel Height' => 'Höhe in Pixel',
	'Pixel Width' => 'Breite in Pixel',
	'URL' => 'URL',
	'Video' => 'Video',
	'extant' => 'vorhanden',
	'missing' => 'fehlt',
	q{Assets in [_1] field of [_2] '[_4]' (ID:[_3])} => q{Assets im [_1]-Feld von [_2] '[_4]' (ID:[_3])},

## lib/MT/Asset/Audio.pm
	'audio' => 'Audio',

## lib/MT/Asset/Image.pm
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Actual Dimensions' => 'Ausgangsgröße',
	'Cannot load image #[_1]' => 'Kann Bild #[_1] nicht laden',
	'Cropping image failed: Invalid parameter.' => 'Beschneiden des Bildes fehlgeschlagen: Parameter ungültig.',
	'Error converting image: [_1]' => 'Fehler bei der Umwandlung des Bildes: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fehler beim Erzeugen des Vorschaubildes: [_1]',
	'Error cropping image: [_1]' => 'Fehler beim Beschnitt des Bildes: [_1]',
	'Error scaling image: [_1]' => 'Fehler bei der Skalierung des Bildes: [_1]',
	'Extracting image metadata failed: [_1]' => 'Auslesen der Metadaten des Bildes fehlgeschlagen: [_1]',
	'Images' => 'Bilder',
	'Popup page for [_1]' => 'Popup-Seite für [_1]',
	'Rotating image failed: Invalid parameter.' => 'Drehen des Bildes fehlgeschlagen: Parameter ungültig.',
	'Scaling image failed: Invalid parameter.' => 'Skalieren des Bildes fehlgeschlagen: Parameter ungültig.',
	'Thumbnail image for [_1]' => 'Vorschaubild für [_1]',
	'Writing image metadata failed: [_1]' => 'Schreiben der Metadaten des Bildes fehlgeschlagen: [_1]',
	'Writing metadata failed: [_1]' => 'Schreiben von Metadaten fehlgeschlagen: [_1]',
	'[_1] x [_2] pixels' => '[_1] x [_2] Pixel',
	q{Error writing metadata to '[_1]': [_2]} => q{Schreiben von Metadaten in '[_1]' fehlgeschlagen: [_2]},
	q{Error writing to '[_1]': [_2]} => q{Fehler beim Schreiben auf &#8222;[_1]&#8220;: [_2] },
	q{Invalid basename '[_1]'} => q{Ungültiger Basisname &#8222;[_1]&#8220;},

## lib/MT/Asset/Video.pm
	'Videos' => 'Videos',
	'video' => 'Video',

## lib/MT/Association.pm
	'Association' => 'Verknüpfung',
	'Group' => 'Gruppe',
	'Permissions for Groups' => 'Gruppen-Berechtigungen',
	'Permissions for Users' => 'Benutzer-Berechtigungen',
	'Permissions for [_1]' => 'Berechtigungen für [_1]',
	'Permissions of group: [_1]' => 'Gruppen-Berechtigungen: [_1]',
	'Permissions with role: [_1]' => 'Berechtigungen der Rolle [_1]',
	'Role Detail' => 'Rolle-Details',
	'Role Name' => 'Rollenname',
	'Role' => 'Rolle',
	'Site Name' => 'Site-Name',
	'User is [_1]' => 'Benutzer ist [_1]',
	'User/Group Name' => 'Benutzer-/Gruppen-Name',
	'User/Group' => 'Benutzer/Gruppe',
	'association' => 'Verknüpfungen',
	'associations' => 'Verknüpfungen',

## lib/MT/AtomServer.pm
	'Invalid image file format.' => 'Ungültiges Bildformat.',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Zur Bestimmung der Höhe und Breite hochgeladener Bilder ist das Perl-Modul Image::Size erforderlich.',
	'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
	'Removing stats cache failed.' => 'Löschen des Statistik-Caches fehlgeschlagen.',
	'[_1]: Entries' => '[_1]: Einträge',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]' hat laut System-Einstellungen keine Upload-Berechtigung: [_2]},
	q{Cannot make path '[_1]': [_2]} => q{Kann Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]},
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{Entry &#8222;[_1]&#8220; ([lc,_5] #[_2]) von &#8222;[_3]&#8220; (#[_4]) über Atom-API gelöscht.},
	q{Invalid blog ID '[_1]'} => q{Ungültige Blog-ID &#8222;[_1]&#8220;},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) hinzugefügt.},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) bearbeitet.},

## lib/MT/Auth.pm
	'Bad AuthenticationModule config' => 'Fehlerhafte AuthenticationModule-Konfiguration',
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{Fehlerhafte AuthenticationModule-Konfiguration &#8222;[_1]&#8220;: [_2]},

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => 'Das aktuelle Passwort konnte nicht verifiziert werden.',
	'Missing required module' => 'Ein erforderliches Modul fehlt',
	'Password contains invalid character.' => 'Das Passwort enthält mindestens ein ungültiges Zeichen.',

## lib/MT/Author.pm
	'Active' => 'Aktiv',
	'Commenters' => 'Kommentarautoren',
	'Content Data Count' => 'Anzahl Inhaltsdaten',
	'Created by' => 'Angelegt von',
	'Disabled Users' => 'Deaktivierte Benutzerkonten',
	'Enabled Users' => 'Aktive Benutzerkonten',
	'Locked Out' => 'Gesperrt',
	'Locked out Users' => 'Gesperrte Benutzerkonten',
	'Lockout' => 'Sperrung',
	'MT Native Users' => 'Native MT-Benutzer',
	'MT Users' => 'MT-Benutzer',
	'Not Locked Out' => 'Nicht gesperrt',
	'Pending Users' => 'Wartende Benutzerkonten',
	'Pending' => 'Auf Moderation wartend',
	'Privilege' => 'Privilegien',
	'Registered User' => 'Registrierter Benutzer',
	'Status' => 'Status',
	'The approval could not be committed: [_1]' => 'Bestätigung konnte nicht übernommen werden: [_1]',
	'User Info' => 'Benutzerinfo',
	'Userpic' => 'Benutzerbild',
	'Website URL' => 'Website',
	'__ENTRY_COUNT' => 'Einträge',
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## lib/MT/BackupRestore.pm
	'Cannot open [_1].' => 'Kann [_1] nicht öffnen.',
	'Copying [_1] to [_2]...' => 'Kopiere [_1] nach [_2]...',
	'Exporting [_1] records:' => 'Exportiere [_1]-Datensätze:',
	'Failed: ' => 'Fehler: ',
	'ID for the file was not set.' => 'ID für Datei nicht gesetzt.',
	'Importing asset associations ... ( [_1] )' => 'Importiere Asset-Verknüpfungen ... ( [_1] )',
	'Importing asset associations in entry ... ( [_1] )' => 'Importiere Asset-Verknüpfungen in Eintrag .... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'Importiere Asset-Verknüpfungen in Seite .... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'Importiere Inhaltsdaten ... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'Importiere Asset-URLs ( [_1] )...',
	'Importing url of the assets in entry ( [_1] )...' => 'Importiere Asset-URLs in Eintrag ( [_1] )...',
	'Importing url of the assets in page ( [_1] )...' => 'Importiere Asset-URLs in Seite ( [_1] )...',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-Datei [_1] ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Manifest file: [_1]' => 'Manifest-Datei: [_1]',
	'No manifest file could be found in your import directory [_1].' => 'Keine Manifest-Datei im Importverzeichnis [_1] gefunden.',
	'Path was not found for the file, [_1].' => 'Verzeichnis für Datei nicht gefunden, [_1]',
	'Rebuilding permissions ... ( [_1] )' => 'Baue Berechtigungen neu auf ... ( [_1] )',
	'The file ([_1]) was not imported.' => 'Datei ([_1]) nicht importiert',
	'There were no [_1] records to be exported.' => 'Keine [_1]-Datensätze zu exportieren.',
	'[_1] is not writable.' => 'Kein Schreibzugriff auf [_1]',
	'[_1] records exported.' => '[_1]-Datensätze exportiert.',
	'[_1] records exported...' => '[_1]-Datensätze exportiert...',
	'failed' => 'Fehlgeschlagen',
	'ok' => 'OK',
	qq{\nCannot write file. Disk full.} => qq{Laufwerk voll. Datei kann nicht geschrieben werden.},
	q{Cannot open directory '[_1]': [_2]} => q{Kann Verzeichnis &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{Ändere Pfad für Datei &#8222;[_1]&#8220; (ID:[_2])....},
	q{Error making path '[_1]': [_2]} => q{Fehler beim Anlegen des Ordners &#8222;[_1]&#8220;: [_2]},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Benutzer mit dem gleichen Namen wie der aktuelle Benutzer in der Exportdatei gefunden ([_1]), Datensatz übersprungen.',
	'Importing [_1] records:' => 'Importiere [_1] Datensätze:',
	'Invalid serializer version was specified.' => 'Ungültiger Serializer angegeben.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'Die hochgeladene Manifest-Datei wurde zwar mit Movable Type erzeugt, aber mit einem anderen Schema ([_1]) als es von diesem System verwendet wird ([_2]). Sie sollten sie daher nicht in diese Version von Movable Type importieren.',
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'Die hochgeladene Datei ist keine gültige aus Movable Type exportierte Manifest-Datei.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] kann nicht in Movable Type importiert werden.',
	'[_1] records imported.' => '[_1] Datensätze importiert.',
	'[_1] records imported...' => '[_1] Datensätze importiert...',
	q{A user with the same name '[_1]' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.} => q{Benutzer mit dem gleichen Namen '[_1]' in der Exportdatei gefunden (ID:[_2]), vorhandene Daten mit denen aus der Exportdatei ersetzt.},
	q{Tag '[_1]' exists in the system.} => q{Tag &#8222;[_1]&#8220; bereits im System vorhanden.},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{Die Rolle &#8222;[_1]&#8220; wurde in &#8222;[_2]&#8220; umbenannt, da bereits eine Rolle mit diesem Namen vorhanden ist.},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{Einstellungen auf Systemebene für Plugin &#8222;[_1]&#8220; bereits vorhanden; überspringe Eintrag.},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'Diese Datei kann nicht importiert werden, da weder im vorhandenen Movable-Type-System noch in den Exportdaten eine Site vorhanden ist. Bitte legen Sie zuerst eine Site an.',
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Diese Datei kann nicht importiert werden, da dazu das Perl-Modul Digest::SHA erforderlich ist. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',

## lib/MT/BasicAuthor.pm
	'authors' => 'Autoren',

## lib/MT/Blog.pm
	'*Site/Child Site deleted*' => '*Site/Untersite gelöscht*',
	'Child Sites' => 'Untersites',
	'Clone of [_1]' => 'Klon von [_1]',
	'Cloned child site... new id is [_1].' => 'Untersite geklont mit neuer ID [_1] geklont...',
	'Cloning associations for blog:' => 'Klone Verknüpfungen für Weblog:',
	'Cloning categories for blog...' => 'Klone Kategorien für Weblog...',
	'Cloning entries and pages for blog...' => 'Klone Einträge und Seiten für Weblog...',
	'Cloning entry placements for blog...' => 'Klone Eintragsplatzierung für Weblog...',
	'Cloning entry tags for blog...' => 'Klone Tags für Weblog...',
	'Cloning permissions for blog:' => 'Klone Berechtigungen für Webblog:',
	'Cloning template maps for blog...' => 'Klone Vorlagenzuweisungen für Weblog...',
	'Cloning templates for blog...' => 'Klone Vorlagen für Weblog...',
	'Content Type Count' => 'Anzahl Inhaltstypen',
	'Content Type' => 'Inhaltstyp',
	'Failed to apply theme [_1]: [_2]' => 'Anwendung des Themas [_1] fehlgeschlagen: [_2]',
	'Failed to load theme [_1]: [_2]' => 'Laden des Themas [_1] fehlgeschlagen: [_2]',
	'First Blog' => 'Erstes Blog',
	'No default templates were found.' => 'Keine Standardvorlagen gefunden.',
	'Parent Site' => 'Übergeordnete Site',
	'Theme' => 'Thema',
	'__ASSET_COUNT' => 'Assets',
	'__PAGE_COUNT' => 'Seiten',
	q{Invalid archive_type '[_1]' in Archive Mapping '[_2]'} => q{Ungültiger archive_type '[_1]' in Archiv-Verknüpfung '[_2]'},
	q{Invalid category_field '[_1]' in Archive Mapping '[_2]'} => q{Ungültiges category_field '[_1]' in Archiv-Verknüpfung '[_2]'},
	q{Invalid datetime_field '[_1]' in Archive Mapping '[_2]'} => q{Ungültiges datetime_field '[_1]' in Archiv-Verknüpfung '[_2]'},
	q{archive_type is needed in Archive Mapping '[_1]'} => q{archive_type in Archiv-Verknüpfung '[_1]' erforderlich},
	q{category_field is required in Archive Mapping '[_1]'} => q{category_field in Archiv-Verknüpfung '[_1]' erforderlich},

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> in Zeile [_2] unbekannt.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> ohne </[_1]> in Zeile #',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> ohne </[_1]> in Zeile[_2]',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> ohne </[_1]> in Zeile [_2].',
	'Error in <mt[_1]> tag: [_2]' => 'Fehler im Vorlagenbefehl <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Unbekannter Vorlagenbefehl gefunden: [_1]',

## lib/MT/CMS/AddressBook.pm
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Mailversand fehlgeschlagen ([_1]). Sind die MailTransfer-Einstellungen richtig?',
	'No entry ID was provided' => 'Keine Eintrags-ID angegeben.',
	'No valid recipients were found for the entry notification.' => 'Keine gültigen Empfänger-Adressen für Benachrichtigung gefunden.',
	'Please select a blog.' => 'Bitte wählen Sie ein Blog.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Die angegebene E-Mail-Adresse befindet sich bereits auf der Benachrichtigungsliste für dieses Weblog.',
	'The text you entered is not a valid URL.' => 'Der eingegebene Text ist keine gültige Web-Adresse (URL).',
	'The text you entered is not a valid email address.' => 'Der eingegebene Text ist keine gültige E-Mail-Adresse.',
	'[_1] Update: [_2]' => '[_1] Update: [_2]',
	q{No such entry '[_1]'} => q{Kein Eintrag &#8222;[_1]&#8220;},
	q{Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'} => q{Abonnent &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_3]&#8220; aus Adressbuch gelöscht},

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(Benutzer gelöscht)',
	'<[_1] Root>' => '<[_1]-Wurzel>',
	'<[_1] Root>/[_2]' => '<[_1]-Wurzel>/[_2]',
	'Archive' => 'Archiv',
	'Cannot load asset #[_1]' => 'Asset #[_1] konnte nicht geladen werden.',
	'Cannot load asset #[_1].' => 'Asset #[_1] konnte nicht geladen werden',
	'Cannot load file #[_1].' => 'Kann Datei #[_1] nicht laden.',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Vorhandene Dateien können nicht mit Dateien anderen Typs überschrieben werden. Vorhandene Datei: [_1], neue Datei: [_2]',
	'Custom...' => 'Individuell...',
	'Extension changed from [_1] to [_2]' => 'Erweiterung von [_1] in [_2] geändert',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Das Vorschaubild konnte nicht angelegt werden, da [_1] diesen Dateityp nicht unterstützt.',
	'Files' => 'Dateien',
	'Invalid Request.' => 'Ungültige Anfrage.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type konnte nicht in das angegebene Verzeichnis schreiben. Bitte stellen Sie sicher, daß der Server Schreibzugriff auf dieses Verzeichnis hat.',
	'No permissions' => 'Keine Berechtigung',
	'Please select a video to upload.' => 'Bitte wählen die Video-Datei aus, die Sie hochladen möchten.',
	'Please select an audio file to upload.' => 'Bitte wählen die Audio-Datei aus, die Sie hochladen möchten.',
	'Please select an image to upload.' => 'Bitte wählen die Bild-Datei aus, die Sie hochladen möchten.',
	'Saving object failed: [_1]' => 'Das Objekt konnte nicht gespeichert werden: [_1]',
	'Transforming image failed: [_1]' => 'Umformung des Bildes fehlgeschlagen: [_1]',
	'Untitled' => 'Ohne Name',
	'Upload Asset' => 'Asset hochladen',
	'Uploaded file is not an image.' => 'Die hochgeladene Datei ist keine Bilddatei.',
	'basename of user' => 'Basisname des Benutzers',
	'none' => 'Kein(e)',
	'unassigned' => 'nicht vergeben',
	q{Could not create upload path '[_1]': [_2]} => q{Konnte Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{Temporäre Datei konnte nicht angelegt werden. Der angegebene Pfad muss vom Webserver beschrieben werden können. Bitte überprüfen Sie das Parameter TempDir in Ihrer Konfigurationsdatei. Derzeitiger Einstellung: [_1]},
	q{Error deleting '[_1]': [_2]} => q{Fehler beim Löschen von &#8222;[_1]&#8220;: [_2]},
	q{Error opening '[_1]': [_2]} => q{Fehler beim Öffnen von &#8222;[_1]&#8220;: [_2]},
	q{Error writing upload to '[_1]': [_2]} => q{Die hochgeladene Datei konnte nicht in &#8222;[_1]&#8220; gespeichert werden: [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Datei &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{File '[_1]' uploaded by '[_2]'} => q{Datei &#8222;[_1]&#8220; hochgeladen von &#8222;[_2]&#8220;},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{Eine Datei &#8222;[_1]&#8220; existiert bereits. (Installieren Sie das Perl-Modul File::Temp, um zuvor hochgeladene Dateien überschreiben zu können.},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{Eine Datei namens '[_1]' ist bereits vorhanden. Der Vorgang wurde abgebrochen.},
	q{File with name '[_1]' already exists.} => q{Eine Datei namens '[_1]' existiert bereits.},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{Eine Datei &#8222;[_1]&#8220; existiert bereits und der Webserver konnte keine temporäre Datei anlegen: [_2]},
	q{Invalid extra path '[_1]'} => q{Ungültiger Zusatzpfad &#8222;[_1]&#8220;},
	q{Invalid filename '[_1]'} => q{Ungültiger Dateiname &#8222;[_1]&#8220;},
	q{Invalid temp file name '[_1]'} => q{Ungültiger temporärer Dateiname &#8222;[_1]&#8220;},

## lib/MT/CMS/Blog.pm
	'(no name)' => '(ohne Name)',
	'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
	'Blog Root' => 'Blog-Wurzelverzeichnis',
	'Cannot load content data #[_1].' => 'Kann Inhaltsdaten #[_1] nicht laden.',
	'Cannot load template #[_1].' => 'Kann Vorlage #[_1] nicht laden.',
	'Compose Settings' => 'Editor-Einstellungen',
	'Create Child Site' => 'Untersite anlegen',
	'Enter a site name to filter the choices below.' => 'Geben Sie einen Sitenamen ein, um die Auswahl einzuschränken.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Um Kommentare und TrackBacks zu klonen, müssen auch die Eintrage geklont werden.',
	'Entries must be cloned if comments are cloned' => 'Um Kommentare zu klonen, müssen auch die Einträge geklont werden.',
	'Entries must be cloned if trackbacks are cloned' => 'Um TrackBacks zu klonen, müssen auch die Einträge geklont werden.',
	'Error' => 'Fehler',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache-Ordner schreiben. Bitte überprüfen Sie die Rechte für den Ordner <code>[_1]</code> in Ihrem Weblog-Verzeichnis.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type konnte kein Verzeichnis zur Zwischenspeicherung Ihrer dynamischen Vorlagen anlegen. Legen Sie daher manuell einen Ordner namens <code>[_1]</code> in Ihrem Weblog-Verzeichnis an.',
	'Feedback Settings' => 'Feedback-Einstellungen',
	'Finished!' => 'Fertig!',
	'General Settings' => 'Allgemeine Einstellungen',
	'Invalid blog_id' => 'Ungültige blog_id',
	'No blog was selected to clone.' => 'Kein zu klonendes Blog ausgewählt.',
	'Please choose a preferred archive type.' => 'Bitte geben Sie eine bevorzugte Archiv-Art an.',
	'Plugin Settings' => 'Plugin-Einstellungen',
	'Publish Site' => 'Site veröffentlichen',
	'Registration Settings' => 'Registrierungs-Einstellungen',
	'Saved [_1] Changes' => '[_1]-Änderungen gespeichert',
	'Saving blog failed: [_1]' => 'Das Weblog konnte nicht gespeichert werden: [_1]',
	'Select Child Site' => 'Untersite wählen',
	'Selected Child Site' => 'Gewählte Untersite',
	'Site URL must be an absolute URL.' => 'Site-URL muß eine absolute URL sein.',
	'The number of revisions to store must be a positive integer.' => 'Die Anzahl der zu speichernden Revisionen muss positiv sein.',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Eine Angabe in der Movable Type-Konfigurationsdatei hat Vorrang vor diesen Einstellungen: [_1]. Entfernen Sie die Angabe aus der Konfigurationsdatei, um die entsprechenden Einstellungen hier vornehmen zu können.',
	'This action can only be run on a single blog at a time.' => 'Dieser Vorgang kann nur für jeweils ein Blog gleichzeitig ausgeführt werden.',
	'This action cannot clone website.' => 'Mit dieser Aktion können keine Websites geklont werden.',
	'Website Root' => 'Wurzelverzeichnis der Website',
	'You did not specify a blog name.' => 'Kein Blog-Name angegeben.',
	'You did not specify an Archive Root.' => 'Kein Archiv-Wurzelverzeichnis angebeben.',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'[_1] changed from [_2] to [_3]' => '[_1] von [_2] in [_3] geändert',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{&#8222;[_1]&#8220; (ID: [_2]) wurde von &#8222;[_5]&#8220; (ID: [_6]) als &#8222;[_3]&#8220; (ID: [_4]) kopiert.},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Weblog &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{Cloning child site '[_1]'...} => q{Klone Untersite '[_1]'...},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{Der Webserver hat keinen Schreibzugriff auf '[_1]'. Bitte vergeben Sie entsprechende Benutzerrechte und versuchen Sie es erneut.},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) angelegt von &#8222;[_4]&#8220;},
	q{[_1] '[_2]'} => q{[_1] &#8222;[_2]&#8220;},
	q{index template '[_1]'} => q{Indexvorlage &#8222;[_1]&#8220;},

## lib/MT/CMS/Category.pm
	'Category Set' => 'Kategorie-Set',
	'Create Category Set' => 'Kategorie-Set anlegen',
	'Create [_1]' => '[_1] anlegen',
	'Edit [_1]' => '[_1] bearbeiten',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => '[_1] konnte nicht aktualisiert werden: [_2] wurde verändert, nachdem Sie diese Seite aufriefen. ',
	'Invalid category_set_id: [_1]' => 'Ungültige category_set_id: [_1]',
	'Manage [_1]' => '[_1] verwalten',
	'The [_1] must be given a name!' => '[_1] muss einen Namen erhalten!',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Konnte [_1] ([_2]) nicht aktualisieren: Objekt nicht gefunden.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Ihre Änderungen wurden übernommen ([_1] hinzugefügt, [_2] bearbeitet, [_3] gelöscht). <a href="#" onclick="[_4]" class="mt-rebuild">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',
	'category_set' => 'Kategorie-Set',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;},
	q{Category '[_1]' created by '[_2]'.} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_2]&#8220;},
	q{Category Set '[_1]' (ID:[_2]) edited by '[_3]'} => q{Kategorie-Set &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;},
	q{Category Set '[_1]' created by '[_2]'.} => q{Kategorie-Set &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_2]&#8220;},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{Der Kategorie-Basisname &#8222;[_1]&#8220; steht im Konflikt mit dem Basisnamen einer anderen Kategorie: Unterkategorien dürfen nicht den gleichen Basisnamen wie ihre Hauptkategorie haben.},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien gleichen Ursprungs müssen eindeutige Namen haben.},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen: Unterkategorien dürfen nicht wie ihre Hauptkategorie heißen.},
	q{The name '[_1]' is too long!} => q{Der Name &#8222;[_1]&#8220; ist zu lang!},
	q{[_1] order has been edited by '[_2]'.} => q{Die [_1]-Reihenfolge wurde von &#8222;[_2]&#8220; geändert.},

## lib/MT/CMS/CategorySet.pm
	q{Category Set '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Kategorie-Set &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},

## lib/MT/CMS/Common.pm
	'All [_1]' => 'Alle [_1]',
	'An error occurred while counting objects: [_1]' => 'Beim Zählen von Objekten ist ein Fehler aufgetreten: [_1]',
	'An error occurred while loading objects: [_1]' => 'Beim Laden von Objekten ist ein Fehler aufgetreten: [_1]',
	'Error occurred during permission check: [_1]' => 'Bei der Prüfung der Zugriffsrechte ist ein Fehler aufgetreten: [_1]',
	'Invalid ID [_1]' => 'Ungültige ID [_1]',
	'Invalid filter terms: [_1]' => 'Ungültiger Filterbegriff: [_1]',
	'Invalid filter: [_1]' => 'Ungültiger Filter: [_1]',
	'Invalid type [_1]' => 'Ungültiger Typ [_1]',
	'New Filter' => 'Neuer Filter',
	'Removing tag failed: [_1]' => 'Das Tag konnte nicht entfernt werden: [_1]',
	'Saving snapshot failed: [_1]' => 'Speichern des Snapshots fehlgeschlagen: [_1]',
	'System templates cannot be deleted.' => 'Systemvorlagen können nicht gelöscht werden.',
	'The Template Name and Output File fields are required.' => 'Die Felder &#8222;Vorlagennamen&#8220; und &#8222;Ausgabedatei&#8220; sind erforderlich.',
	'The blog root directory must be within [_1].' => 'Das Wurzelverzeichnis des Blogs muss in [_1] liegen.',
	'The selected [_1] has been deleted from the database.' => 'Gewählte [_2] aus der Datenbank gelöscht.',
	'The website root directory must be within [_1].' => 'Das Wurzelverzeichnis der Website muss in [_1] liegen.',
	'Unknown list type' => 'Unbekannter Listentyp',
	'Web Services Settings' => 'Webdienste-Einstellungen',
	'[_1] Feed' => '[_1]-Feed',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => '[_1] beschädigte Revisionen von [_2] (id: [_3]) wurden gelöscht.',
	'__SELECT_FILTER_VERB' => 'ist',
	q{'[_1]' edited the global template '[_2]'} => q{&#8222;[_1]&#8220; hat die globale Vorlage &#8222;[_2]&#8220; bearbeitet},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{&#8222;[_1]&#8220; hat die Vorlage &#8222;[_2]&#8220; des Blogs &#8222;[_3]&#8220; bearbeitet},

## lib/MT/CMS/ContentData.pm
	'(No Label)' => '(unbenannt)',
	'(untitled)' => '(unbenannt)',
	'Cannot load content field (UniqueID:[_1]).' => 'Konnte Inhaltsfeld nicht laden (UniqueID:[_1]).',
	'Cannot load content_type #[_1]' => 'Konnte content_type #[_1] nicht laden',
	'Create new [_1]' => '[_1] anlegen',
	'Need a status to update content data' => 'Status zur Aktualisierungen der Inhaltsdaten erforderlich',
	'Need content data to update status' => 'Inhaltsdaten zur Aktualisierung des Status erforderlich',
	'New [_1]' => 'Neuer [_1]',
	'No Label (ID:[_1])' => 'Keine Bezeichnung (ID:[_1])',
	'One of the content data ([_1]) did not exist' => 'Bestimmte Inhaltsdaten ([_1]) existieren nicht.',
	'Publish error: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'The value of [_1] is automatically used as a data label.' => 'Der Wert von [_1] wird automatisch als Bezeichnung verwendet.',
	'Unable to create preview files in this location: [_1]' => 'Kann Vorschau-Dateien hier nicht erzeugen:',
	'Unpublish Contents' => 'Inhalte zurückziehen',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Site-Pfad und URL dieses Weblogs wurden noch nicht konfiguriert. Sie können keine Einträge veröffentlichen, solange das nicht geschehen ist.',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => 'Status von [_1] (ID:[_2]) von [_3] in [_4] geändert',
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. Geben Sie den Zeitpunkt der Veröffentlichung in diesem Format an: JJJJ-MM-TT HH:MM:SS.},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss im Format JJJJ-MM-TT SS:MM:SS angegeben werden.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunk, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss in der Zukunft liegen.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss nach dem Zeitpunkt der Veröffentlichung liegen.},
	q{New [_1] '[_4]' (ID:[_2]) added by user '[_3]'} => q{[_1] '[_4]' (ID:[_2]) von Benutzer '[_3]' hinzugefügt},
	q{[_1] '[_4]' (ID:[_2]) deleted by '[_3]'} => q{[_1] '[_4]' (ID:[_2]) von Benutzer '[_3]' gelöscht},
	q{[_1] '[_4]' (ID:[_2]) edited by user '[_3]'} => q{[_1] '[_4]' (ID:[_2]) von Benutzer '[_3]' bearbeitet},
	q{[_1] '[_6]' (ID:[_2]) edited and its status changed from [_3] to [_4] by user '[_5]'} => q{[_1] '[_6]' von Benutzer '[_5]' bearbeitet und Status von [_3] in [_4] geändert},

## lib/MT/CMS/ContentType.pm
	'Cannot load content field data (ID: [_1])' => 'Kann Inhaltsfelder-Daten nicht laden (ID: [_1])',
	'Cannot load content type #[_1]' => 'Inhaltstyp #[_1] konnte nicht geladen werden',
	'Content Type Boilerplates' => 'Inhaltstyp-Bausteine',
	'Create Content Type' => 'Inhaltstyp anlegen',
	'Create new content type' => 'Neuen Inhaltstyp anlegen',
	'Manage Content Type Boilerplates' => 'Inhaltstyp-Bausteine verwalten',
	'Saving content field failed: [_1]' => 'Speichern des Inhaltsfelds fehlgeschlagen: [_1]',
	'Saving content type failed: [_1]' => 'Speichern des Inhaltstyps fehlgeschlagen: [_1]',
	'Some content fields were deleted: ([_1])' => 'Inhaltsfelder gelöscht: ([_1])',
	'The content type name is required.' => 'Bitte geben Sie den Namen des Inhaltstyps ein.',
	'The content type name must be shorter than 255 characters.' => 'Der Name des Inhaltstyps darf höchstens 255 Zeichen lang sein.',
	'content_type' => 'Inhaltstyp',
	q{A content field '[_1]' ([_2]) was added} => q{Inhaltsfeld '[_1]' ([_2]) hinzugefügt},
	q{A content field options of '[_1]' ([_2]) was changed} => q{Einstellung von Inhaltsfeld '[_1]'([_2]) geändert},
	q{A description for content field of '[_1]' should be shorter than 255 characters.} => q{Die Beschreibung des '[_1]'-Inhaltfelds darf höchstens 255 Zeichen lang sein.},
	q{A label for content field of '[_1]' is required.} => q{Bezeichnung für '[_1]'-Inhaltsfeld erforderlich.},
	q{A label for content field of '[_1]' should be shorter than 255 characters.} => q{Die Bezeichnung des '[_1]'-Inhaltsfelds darf höchstens 255 Zeichen lang sein.},
	q{Content Type '[_1]' (ID:[_2]) added by user '[_3]'} => q{Inhaltstyp '[_1]' (ID:[_2]) von Benutzer '[_3]' hinzugefügt},
	q{Content Type '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Inhaltstyp '[_1]' (ID:[_2]) von Benutzer '[_3]' gelöscht},
	q{Content Type '[_1]' (ID:[_2]) edited by user '[_3]'} => q{Inhaltstyp '[_1]' (ID:[_2]) von Benutzer '[_3]' bearbeitet},
	q{Field '[_1]' and '[_2]' must not coexist within the same content type.} => q{}, # Translate - New
	q{Field '[_1]' must be unique in this content type.} => q{}, # Translate - New
	q{Name '[_1]' is already used.} => q{Der Name '[_1]' wird bereits verwendet.},

## lib/MT/CMS/Dashboard.pm
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Auf Ihrem System ist keine Bildquelle vorhanden oder aber fehlerhaft konfiguiert. Eine Bildquelle ist zur korrekten Funktion der Benutzerbild-Funktionen erforderlich. Installieren Sie Graphics::Magick, Image::Magick, NetPBM oder Imager und konfiguieren Sie die ImageDriver-Direktive entsprechend.',
	'Can verify SSL certificate, but verification is disabled.' => 'SSL-Zertifikate können bestätigt werden, die Funktion ist aber deaktiviert.',
	'Cannot verify SSL certificate.' => 'SSL-Zertifikat kann nicht überprüft werden.',
	'Error: This child site does not have a parent site.' => 'Fehler: Diese Untersite hat keine übergeordnete Site.',
	'ImageDriver is not configured.' => 'ImageDriver ist nicht konfiguriert.',
	'Not configured' => 'Nicht konfiguriert',
	'Page Views' => 'Seitenaufrufe',
	'Please contact your Movable Type system administrator.' => 'Bitte wenden Sie sich an Ihren Movable Type-Administrator.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Bitte installieren Sie das Modul Mozilla::CA. Um diese Meldung zu unterdrücken, ergänzen Sie mt-config.cgi um die Zeile "SSLVerifyNone 1". Das wird allerdings nicht empfohlen.',
	'System' => 'System',
	'The support directory is not writable.' => 'Das Support-Verzeichnis ist nicht beschreibbar.',
	'Unknown Content Type' => 'Unbekannter Inhaltstypen',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Sie sollten die Zeile "SSLVerifyNone 1" aus mt-config.cgi entfernen.',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type kann auf den Ordner &#8222;support&#8220; nicht schreibend zugreifen. Legen Sie unter [_1] ein solches Verzeichnis an und stellen Sie sicher, daß der Webserver über Schreibrechte für diesen Ordner verfügt.},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw. Bitte bestätigen Sie Ihre <a href="[_1]>Einstellungen</a>.},

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(Benutzer gelöscht - ID:[_1])',
	'/' => '/',
	'Need a status to update entries' => 'Statusangabe erforderlich',
	'Need entries to update status' => 'Einträge erforderlich',
	'New Entry' => 'Neuer Eintrag',
	'New Page' => 'Neue Seite',
	'No such [_1].' => 'Kein [_1].',
	'One of the entries ([_1]) did not exist' => 'Einer der Einträge ([_1]) existiert nicht.',
	'Removing placement failed: [_1]' => 'Die Platzierung konnte nicht entfernt werden: [_1]',
	'Saving placement failed: [_1]' => 'Beim Speichern der Platzierung ist ein Fehler aufgetreten: [_1]',
	'This basename has already been used. You should use an unique basename.' => 'Basisname bereits verwendet. Bitte wählen Sie einen noch nicht verwendeten.',
	'authored on' => 'geschrieben am',
	'modified on' => 'bearbeitet am',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">QuickPost für [_2]</a> - Ziehen Sie dieses Bookmarklet in die Lesezeichenleiste Ihres Browsers. Klicken Sie darauf, wenn Sie sich auf einer Website befinden, über die Sie bloggen möchten.},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{Datum &#8222;[_1]&#8220; ungültig. Das Datum der Veröffentlichung muss vor dem Zeitpunkt liegen, ab dem der Eintrag nicht mehr veröffentlicht werden soll (derzeit [_2]).},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. [_2]-Datumsangaben müssen im Format JJJJ-MM-TT HH:MM:SS vorliegen.},
	q{Saving entry '[_1]' failed: [_2]} => q{Der Eintrag &#8222;[_1]&#8220; konnte nicht gespeichert werden: [_2]},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet und Status geändert von [_4] in [_5] von Benutzer &#8222;[_6]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet von Benutzer &#8222;[_4]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{Status von [_1] &#8222;[_2]&#8220; (ID:[_3]) von [_4] in [_5] geändert.},

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Site-Einträge exportieren',
	'Please select a site.' => 'Bitte wählen Sie eine Site.',
	'You do not have export permissions' => 'Sie haben keine Berechtigung für die Exportfunktion',
	q{Loading site '[_1]' failed: [_2]} => q{Laden der Seite '[_1]' fehlgeschlagen: [_2]},

## lib/MT/CMS/Filter.pm
	'(Legacy) ' => '(Altsystem)',
	'Failed to delete filter(s): [_1]' => 'Filter nicht gelöscht: [_1]',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Filter nicht gespeichert: Bezeichnung "[_1]" bereits in Verwendung.',
	'Failed to save filter: Label is required.' => 'Filter nicht gespeichert: Bezeichnung erforderlich',
	'Failed to save filter: [_1]' => 'Filter nicht gespeichert: [_1]',
	'No such filter' => 'Kein entsprechender Filter vorhanden',
	'Permission denied' => 'Zugriff verweigert',
	'Removed [_1] filters successfully.' => '[_1] Filter erfolgreich entfernt.',
	'[_1] ( created by [_2] )' => '[_1] (angelegt von [_2])',

## lib/MT/CMS/Folder.pm
	q{Folder '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Ordner &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{Folder '[_1]' (ID:[_2]) edited by '[_3]'} => q{Ordner &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;},
	q{Folder '[_1]' created by '[_2]'} => q{Ordner &#8222;[_1]&#8220; angelegt von &#8222;[_2]&#8220;},
	q{The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.} => q{Der Ordner &#8222;[_1]&#8220; steht in Konflikt mit einem anderen Ordner. Ordner im gleichen Unterordner müssen unterschiedliche Basisnamen haben.},

## lib/MT/CMS/Group.pm
	'Add Users to Groups' => 'Benutzer zu Gruppen hinzufügen',
	'Author load failed: [_1]' => 'Fehler beim Laden eines Autoren: [_1]',
	'Create Group' => 'Gruppe anlegen',
	'Each group must have a name.' => 'Jede Gruppe muss einen eigenen Namen haben.',
	'Group Name' => 'Gruppenname',
	'Group load failed: [_1]' => 'Fehler beim Laden einer Gruppe:',
	'Groups Selected' => 'Gewählte Gruppen',
	'Search Groups' => 'Gruppen suchen',
	'Search Users' => 'Benutzer suchen',
	'Select Groups' => 'Gruppen auswählen',
	'Select Users' => 'Benutzer wählen',
	'User load failed: [_1]' => 'Fehler beim Laden eines Benutzers:',
	'Users Selected' => 'Gewählte Benutzer',
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{Benutzer '[_1]' (ID:[_2]) von '[_5]' aus Gruppe '[_3]' (ID:[_4]) entfernt},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{Benutzer '[_1]' (ID:[_2]) von '[_5]' zu Gruppe '[_3]' (ID:[_4]) hinzugefügt},

## lib/MT/CMS/Import.pm
	'Import Site Entries' => 'Site-Einträge importieren',
	'Importer type [_1] was not found.' => 'Import-Typ [_1] nicht gefunden.',
	'You do not have import permission' => 'Sie haben keine Berechtigung für die Importfunktion',
	'You do not have permission to create users' => 'Sie haben keine Berechtigung, neue Benutzerkonten anzulegen.',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'Bitte geben Sie ein Passwort an, um automatisch neue Benutzerkonten für alle Benutzer Ihrer Site anzulegen.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Jedes Feedback',
	'Publishing' => 'Veröffentliche',
	'System Activity Feed' => 'Systemaktivitäts-Feed',
	q{Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{Aktivitätsprotokoll von &#8222;[_1]&#8220; (ID:[_2]) on &#8222;[_3]&#8220; zurückgesetzt},
	q{Activity log reset by '[_1]'} => q{Aktivitätsprotokoll zurückgesetzt von &#8222;[_1]&#8220;},

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Konnte Plugin-Einstellungen nicht speichern: [_1]',
	'Individual Plugins' => 'Individuelle Plugins',
	'Plugin Set: [_1]' => 'Plugin-Gruppe: [_1]',
	'Plugin' => 'Plugin',
	'Plugins are disabled by [_1]' => '', # Translate - New
	'Plugins are enabled by [_1]' => '', # Translate - New
	q{Plugin '[_1]' is disabled by [_2]} => q{}, # Translate - New
	q{Plugin '[_1]' is enabled by [_2]} => q{}, # Translate - New

## lib/MT/CMS/RebuildTrigger.pm
	'(All child sites in this site)' => '(Alle Untersites dieser Site)',
	'(All sites and child sites in this system)' => '(Alle Sites und Untersites im System)',
	'Comment' => 'Kommentar',
	'Create Rebuild Trigger' => 'Auslöser für Neuaufbau definieren',
	'Entry/Page' => 'Eintrag/Seite',
	'Format Error: Comma-separated-values contains wrong number of fields.' => 'Format Fehler: Durch Kommas getrennte Werte enthalten eine falsche Anzahl von Feldern.',
	'Format Error: Trigger data include illegal characters.' => 'Format Fehler: Triggerdaten enthalten unzulässige Zeichen.',
	'Save' => 'OK',
	'Search Content Type' => 'Inhaltstyp suchen',
	'Search Sites and Child Sites' => 'Sites und Untersites suchen',
	'Select Content Type' => 'Inhaltstyp wählen',
	'Select Site' => 'Site wählen',
	'Select to apply this trigger to all child sites in this site.' => 'Diesen Auslöser für alle Untersites dieser Site verwenden.',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Diesen Auslöser für alle Sites und Untersites in diesem System verwenden.',
	'TrackBack' => 'TrackBack',
	'__UNPUBLISHED' => 'Nicht mehr veröffentlichen',
	'rebuild indexes and send pings.' => 'Indizes neu aufbauen und Pings senden.',
	'rebuild indexes.' => 'Indizes neu aufbauen.',

## lib/MT/CMS/Search.pm
	'"[_1]" field is required.' => 'Feld "[_1]" erforderlich.',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" ist für das "[_2]"-Feld von "[_3]" nicht gültig (ID:[_4]): [_5]',
	'Basename' => 'Basisname',
	'Data Label' => 'Daten-Bezeichnung',
	'Entry Body' => 'Eintragstext',
	'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
	'Excerpt' => 'Auszug',
	'Extended Entry' => 'Erweiterter Eintrag',
	'Extended Page' => 'Erweiterte Seite',
	'IP Address' => 'IP-Adresse',
	'Invalid date(s) specified for date range.' => 'Ungültige Datumsangabe',
	'Keywords' => 'Schlüsselwörter',
	'Linked Filename' => 'Verlinkter Dateiname',
	'Log Message' => 'Eintrag',
	'No [_1] were found that match the given criteria.' => 'Keine den Kriterien entsprechenden [_1] gefunden.',
	'Output Filename' => 'Ausgabe-Dateiname',
	'Page Body' => 'Seitenkörper',
	'Site Root' => 'Wurzelverzeichnis',
	'Site URL' => 'Site-URL',
	'Template Name' => 'Vorlagenname',
	'Templates' => 'Vorlagen',
	'Text' => 'Text',
	'Title' => 'Titel',
	'replace_handler of [_1] field is invalid' => 'replace_handler des [_1]-Felds ungültig',
	'ss_validator of [_1] field is invalid' => 'ss_validator des [_1]-Felds ungültig',
	q{Searched for: '[_1]' Replaced with: '[_2]'} => q{'[_1]' durch '[_2]' ersetzt.},
	q{[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.} => q{[_1] '[_2]' (ID:[_3]) von Benutzer '[_4]' per Suchen und Ersetzen aktualisiert.},

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Bitte geben Sie einen neuen Tag-Namen an.',
	'Error saving entry: [_1]' => 'Fehler beim Speichern des Eintrags: [_1]',
	'Error saving file: [_1]' => 'Fehler beim Speichern der Datei: [_1]',
	'No such tag' => 'Kein solcher Tag',
	'Successfully added [_1] tags for [_2] entries.' => '[_1] Tags erfolgreich zu [_2] Einträgen hinzugefügt.',
	'The tag was successfully renamed' => 'Tag erfolgreich umbenannt.',
	q{Tag '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Tag &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},

## lib/MT/CMS/Template.pm
	' (Backup from [_1])' => '(Sicherung von [_1])',
	'Archive Templates' => 'Archiv-Vorlagen',
	'Cannot load templatemap' => 'Kann Vorlagenverknüpfungen nicht laden',
	'Cannot locate host template to preview module/widget.' => 'Kann Host-Vorlage zur Vorschau auf Modul/Widget nicht finden.',
	'Cannot preview without a template map!' => 'Vorschau ohne Vorlagen-Verknüpfung nicht möglich.',
	'Cannot publish a global template.' => 'Kann eine globale Vorlage nicht veröffentlichen.',
	'Content Type Archive' => 'Inhaltstyp-Archiv',
	'Content Type Templates' => 'Inhaltstyp-Vorlagen',
	'Copy of [_1]' => 'Kopie von [_1]',
	'Create Template' => 'Vorlage anlegen',
	'Create Widget Set' => 'Widgetgruppe anlegen',
	'Create Widget' => 'Widget anlegen',
	'Email Templates' => 'E-Mail-Vorlagen',
	'Entry or Page' => 'Eintrag oder Seite',
	'Error creating new template: ' => 'Fehler beim Anlegen der neuen Vorlage',
	'Global Template' => 'Globale Vorlage',
	'Global Templates' => 'Globale Vorlagen',
	'Global' => 'Global',
	'Index Templates' => 'Index-Vorlagen',
	'Invalid Blog' => 'Ungültiges Blog',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LOREM_IPSUM_TEXT_MORE',
	'Lorem ipsum' => 'Lorem ipsum',
	'One or more errors were found in the included template module ([_1]).' => 'Das eingebundene Vorlagen-Modul enthält einen oder mehrere Fehler ([_1]).',
	'One or more errors were found in this template.' => 'Die Vorlage enthält einen oder mehrere Fehler.',
	'Orphaned' => 'Verwaist',
	'Preview' => 'Vorschau',
	'Published Date' => 'Veröffentlichungs-Datum',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Setze Vorlage <strong>[_3]</strong>zurück und erstelle dabei eine <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">Sicherung</a>.',
	'Saving map failed: [_1]' => 'Die Verknüpfungen konnte nicht gespeichert werden: [_1]',
	'Setting up mappings failed: [_1]' => 'Die Verknüpfungen konnte nicht angelegt werden: [_1]',
	'System Templates' => 'System-Vorlagen',
	'Template Backups' => 'Vorlagen-Sicherungen',
	'Template Modules' => 'Vorlagenmodule',
	'Template Refresh' => 'Vorlagen zurücksetzen',
	'Unable to create preview file in this location: [_1]' => 'Kann Vorschaudatei in [_1] nicht erzeugen.',
	'Unknown blog' => 'Unbekanntes Blog',
	'Widget Template' => 'Widgetvorlage',
	'Widget Templates' => 'Widgetvorlagen',
	'You must select at least one event checkbox.' => 'Markieren Sie bitte mindestens ein Ereignis-Auswahlfeld.',
	'You must specify a template type when creating a template' => 'Bitte geben Sie den Typ der neuen Vorlage an.',
	'You should not be able to enter zero (0) as the time.' => 'Null (0) ist keine gültige Zeitangabe.',
	'archive' => 'Archiv',
	'backup' => 'Sichern',
	'content type' => 'Inhaltstyp',
	'email' => 'E-Mail',
	'index' => 'Index',
	'module' => 'Modul',
	'sample, entry, preview' => 'Beispiel, Eintrag, Vorschau',
	'system' => 'System',
	'template' => 'Vorlage',
	'widget' => 'Widget',
	q{Skipping template '[_1]' since it appears to be a custom template.} => q{Überspringe Vorlage &#8222;[_1]&#8220;, da sie keine Standardvorlage zu sein scheint.},
	q{Skipping template '[_1]' since it has not been changed.} => q{Überspringe Vorlage &#8222;[_1]&#8220;, da sie unverändert ist.},
	q{Template '[_1]' (ID:[_2]) created by '[_3]'} => q{Vorlage &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;},
	q{Template '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Vorlage &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},

## lib/MT/CMS/Theme.pm
	'All themes directories are not writable.' => 'Sämtliche Themen-Verzeichnisse können nicht beschrieben werden.',
	'Download [_1] archive' => '[_1]-Archiv herunterladen',
	'Error occurred during exporting [_1]: [_2]' => 'Beim Export von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Beim Abschluss von [_1] ist ein Fehler aufgetreten: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Bei der Veröffentlichung des Themas ist ein Fehler aufgetreten: [_1]',
	'Export Themes' => 'Themen exportieren',
	'Failed to load theme export template for [_1]: [_2]' => 'Beim Laden der Vorlage für den Themen-Export von [_1] ist ein Fehler aufgetreten: [_2]',
	'Failed to save theme export info: [_1]' => 'Beim Speichern der Export-Informationen ist ein Fehler aufgetreten: [_1]',
	'Failed to uninstall theme' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten',
	'Failed to uninstall theme: [_1]' => 'Bei der Deinstallation des Themas ist ein Fehler aufgetreten: [_1]',
	'Install into themes directory' => 'In Themenverzeichnis installieren',
	'Theme from [_1]' => 'Thema von [_1]',
	'Theme not found' => 'Thema nicht gefunden',
	'Themes Directory [_1] is not writable.' => 'Das Themen-Verzeichis [_1] kann nicht beschrieben werden.',
	'Themes directory [_1] is not writable.' => 'Das Themen-Verzeichis [_1] kann nicht beschrieben werden.',

## lib/MT/CMS/Tools.pm
	'Any site' => 'Jede Site',
	'Cannot recover password in this configuration' => 'Passwörter können in dieser Konfiguration nicht angefordert werden',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Ändere URL für FileInfo-Eintrag (ID:[_1])',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Ändere Datei-Pfad für FileInfo-Eintrag (ID:[_1])...',
	'Changing image quality is [_1]' => 'Anpassung der Bildqualität ist [_1]',
	'Copying file [_1] to [_2] failed: [_3]' => 'Die Datei [_1] konnte nicht nach [_2] kopiert werden: [_3]',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'Die Exportdatei [_1] konnte nicht aus dem Dateisystem gelöscht werden: [_2]',
	'Debug mode is [_1]' => 'Debugging ist [_1]',
	'Detailed information is in the activity log.' => 'Details finden Sie im Aktivitätsprotokoll.',
	'E-mail was not properly sent. [_1]' => 'Versand der Testmail fehlgeschlagen. [_1]',
	'Email address is [_1]' => 'Die E-Mail-Adresse lautet [_1]',
	'Email address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'Email address not found' => 'E-Mail-Adresse nicht gefunden',
	'Error occurred during import process.' => 'Beim Importieren ist ein Fehler aufgetreten.',
	'Error occurred while attempting to [_1]: [_2]' => 'Während [_1] ist ein Fehler aufgetreten: [_2]',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Beim Mailversand ist ein Fehler aufgetreten ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, Ihr Passwort anzufordern.',
	'File was not uploaded.' => 'Datei wurde nicht hochgeladen.',
	'IP address lockout interval' => 'Zeitraum bis IP-Sperrung',
	'IP address lockout limit' => 'Anzahl Versuche bis IP-Sperrung',
	'Image quality(JPEG) is [_1]' => 'Bildqualität (JPG) steht auf Stufe [_1]',
	'Image quality(PNG) is [_1]' => 'Bildqualität (PNG) steht auf Stufe [_1]',
	'Importing a file failed: ' => 'Importieren einer Datei fehlgeschlagen:',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath ungültig. Die Pfadangabe muss gültig und absolut statt relativ.',
	'Invalid author_id' => 'Ungültige Autoren-ID',
	'Invalid email address' => 'Ungültige E-Mail-Adresse',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Versuch zur Passwortanforderung ungültig: Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ungültiger Versuch zur Passwortanforderung. Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid password reset request' => 'Ungültige Anfrage zur Zurücksetzung des Passworts',
	'Lockout IP address whitelist' => 'Diese IP-Adresse nie sperren',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'Die Manifest-Datei [_1] ist keine gültige Movable-Type-Exportdatei.',
	'Only to blogs within this system' => 'Nur an Blogs in diesem System',
	'Outbound trackback limit is [_1]' => 'Ausgehende TrackBacks sind auf [_1] Stück limiert',
	'Password Recovery' => 'Passwort anfordern',
	'Password reset token not found' => 'Passwort Reset Token nicht gefunden',
	'Passwords do not match' => 'Passwörter stimmen nicht überein.',
	'Performance log path is [_1]' => 'Pfad der Performance-Logs: [_1]',
	'Performance log threshold is [_1]' => 'Schwellenwert für Performance-Logging: [_1]',
	'Performance logging is off' => 'Performance-Logging deaktiviert',
	'Performance logging is on' => 'Performance-Logging aktiviert',
	'Please confirm your new password' => 'Bitte bestätigen Sie Ihr neues Passwort',
	'Please enter a valid email address.' => 'Bitte geben Sie eine gültige E-Mail-Adresse an.',
	'Please upload [_1] in this page.' => 'Bitte laden Sie [_1] in diese Seite hoch.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Bitte verwenden Sie xml, tar.gz, zip, oder manifest als Dateierweiterung.',
	'Prohibit comments is off' => 'Kommentare unterbinden ist deaktiviert',
	'Prohibit comments is on' => 'Kommentare unterbinden ist aktiviert',
	'Prohibit notification pings is off' => 'Benachrichtigungs-Pings ist deaktiviert',
	'Prohibit notification pings is on' => 'Benachrichtigungs-Pings unterbinden ist aktiviert',
	'Prohibit trackbacks is off' => 'Trackbacks unterbinden ist deaktiviert',
	'Prohibit trackbacks is on' => 'Trackbacks unterbinden ist aktiviert',
	'Recipients for lockout notification' => 'Empfänger von Sperr-Benachrichtigungen',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Einige [_1] wurden nicht importiert, da ihre Übergeordneten Objekte nicht importiert wurden.',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Einige Objekte wurden nicht importiert, da ihre Übergeordneten Objekte nicht importiert wurden. Detaillierte Informationen finden Sie im Aktivitätsprotokoll.',
	'Some objects were not imported because their parent objects were not imported.' => 'Einige Objekte wurden nicht importiert, weil deren Übergeordneten Objekte nicht importiert wurden.',
	'Some of files could not be imported.' => 'Einige Dateien konnten nicht importiert werden',
	'Some of the actual files for assets could not be imported.' => 'Einige Asset-Dateien konnten nicht importiert werden.',
	'Some of the exported files could not be removed.' => 'Einige der exportierten Dateien konnten nicht entfernt werden.',
	'Some of the files were not imported correctly.' => 'Einige Dateien wurden nicht fehlerfrei importiert.',
	'Specified file was not found.' => 'Angegebene Datei nicht gefunden.',
	'Started importing sites' => '', # Translate - New
	'Started importing sites: [_1]' => '', # Translate - New
	'System Settings Changes Took Place' => 'Es wurden Änderungen an den Systemeinstellungen vorgenommen.',
	'Temporary directory needs to be writable for export to work correctly.  Please check (Export)TempDir configuration directive.' => 'Das temporäre Verzeichnis muss für den Exportvorgang beschreibbar sein. Bitte überprüfen Sie das Konfigurationsparameter (Export)TempDir.',
	'Temporary directory needs to be writable for import to work correctly.  Please check (Export)TempDir configuration directive.' => 'Das temporäre Verzeichnis muss für den Importvorgang beschreibbar sein. Bitte überprüfen Sie das Konfigurationsparameter (Export)TempDir.',
	'Test e-mail was successfully sent to [_1]' => 'Testmail erfolgreich an [_1] versandt',
	'Test email from Movable Type' => 'Testmail von Movable Type',
	'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) offenbar nicht implementiert!',
	'This is the test email sent by Movable Type.' => 'Das ist die Test-E-Mail, die Ihre Movable Type-Installation verschickt hat.',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'Die hochgeladene Datei ist keine gültige aus Movable Type exportierte Manifest-Datei',
	'User lockout interval' => 'Zeitraum bis Kontosperrung',
	'User lockout limit' => 'Anzahl Versuche bis Kontosperrung',
	'User not found' => 'Benutzer nicht gefunden',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Bitte richten Sie zuerst die System-E-Mail-Adresse ein. Versuchen Sie dann erneut, die Testmail zu verschicken.',
	'Your request to change your password has expired.' => 'Ihre Anfrage auf Änderung Ihres Passworts ist abgelaufen.',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] hat den gleichzeitigen Import mehrerer Dateien vorzeitig abgebrochen.',
	'[_1] is [_2]' => '[_1] ist [_2]',
	'[_1] is not a directory.' => '[_1] ist kein Ordner.',
	'[_1] is not a number.' => '[_1] ist keine Zahl.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] hat Exportdatei [_2] erfolgreich heruntergeladen',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{Link zum Zurücksetzen des Passworts für Benutzer &#8222;[_1]&#8220; (#[_2]) an [_3] geschickt.},
	q{Changing Archive Path for the site '[_1]' (ID:[_2])...} => q{Ändere Archiv-Pfad der Site '[_1]' (ID:[_2])...},
	q{Changing Site Path for the site '[_1]' (ID:[_2])...} => q{Ändere Site-Pfad der Site '[_1]' (ID:[_2])...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{Ändere Pfad für Asset &#8222;[_1]&#8220; (ID:[_2])...},
	q{Manifest file '[_1]' is too large. Please use import directory for importing.} => q{Die Manifest-Datei '[_1]' ist zu groß. Bitte lesen Sie sie über das das Import-Verzeichnis ein.},
	q{Movable Type system was successfully exported by user '[_1]'} => q{Movable-Type-System erfolgreich von Benutzer '[_1]' exportiert.},
	q{Removing Archive Path for the site '[_1]' (ID:[_2])...} => q{Entferne Archiv-Pfad der Site '[_1]' (ID:[_2])...},
	q{Removing Site Path for the site '[_1]' (ID:[_2])...} => q{Entferne Site-Pfad der Site '[_1]' (ID:[_2]...},
	q{Site(s) (ID:[_1]) was/were successfully exported by user '[_2]'} => q{Site(s) (ID:[_1]) erfolgreich von Benutzer '[_2]' exportiert.},
	q{Successfully imported objects to Movable Type system by user '[_1]'} => q{Objekte von Benutzer '[_1]' erforderlich in das Movable-Type-System importiert},
	q{User '[_1]' (user #[_2]) does not have email address} => q{Benutzer &#8222;[_1]&#8220; (#[_2]) hat keine E-Mail-Adresse},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(neu angelegter Benutzer)',
	'Another role already exists by that name.' => 'Es ist bereits eine Rolle mit diesem Namen vorhanden.',
	'Cannot load role #[_1].' => 'Kann Rolle #[_1] nicht laden.',
	'Create User' => 'Benutzerkonto anlegen',
	'For improved security, please change your password' => 'Bitte ändern Sie Ihr Passwort, um die Sicherheit zu erhöhen.',
	'Grant Permissions' => 'Berechtigungen zuweisen',
	'Groups/Users Selected' => 'Gewählte Gruppen/Benutzer',
	'Invalid ID given for personal blog clone location ID.' => 'Ungültige ID für Klonvorlage der persönlichen Blogs',
	'Invalid ID given for personal blog theme.' => 'Ungültige ID für Thema der persönlichen Blogs',
	'Invalid type' => 'Ungültiger Typ',
	'Minimum password length must be an integer and greater than zero.' => 'Bitte geben Sie als Mindest-Passwortlänge eine ganze Zahl größer null an.',
	'Role name cannot be blank.' => 'Rollenname erforderlich.',
	'Roles Selected' => 'Gewählte Rollen',
	'Select Groups And Users' => 'Gruppen und Benutzer wählen',
	'Select Roles' => 'Rollen wählen',
	'Select a System Administrator' => 'Systemadministrator wählen',
	'Select a entry author' => 'Eintragsautor wählen',
	'Select a page author' => 'Seitenautor wählen',
	'Selected System Administrator' => 'Gewählter Systemadministrator',
	'Selected author' => 'Gewählter Autor',
	'Sites Selected' => 'Gewählte Sites',
	'System Administrator' => 'Systemadministrator',
	'Type a username to filter the choices below.' => 'Geben Sie einen Benutzernamen ein, um die Auswahl einzuschränken',
	'User Settings' => 'Benutzer-Einstellungen',
	'User requires display name' => 'Anzeigename erforderlich',
	'User requires password' => 'Passwort erforderlich',
	'User requires username' => 'Benutzername erforderlich',
	'You cannot define a role without permissions.' => 'Es können keine Rollen ohne Berechtigungen definiert werden.',
	'You cannot delete your own association.' => 'Sie können nicht Ihre eigene Verknüpfung löschen.',
	'You have no permission to delete the user [_1].' => 'Keine Berechtigung zum Löschen von Benutzer [_1].',
	'represents a user who will be created afterwards' => 'steht für ein Benutzerkonto, das später angelegt werden wird',
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{Benutzerkonto '[_1]' (ID:[_2]) konnte nicht von '[_3]' reaktiviert werden },
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{[_1]'s Associations} => q{Verknüpfungen von [_1]},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'Kann Website #[_1] nicht laden.',
	'Create Site' => 'Site anlegen',
	'Selected Site' => 'Gewählte Sites',
	'This action cannot move a top-level site.' => 'Sites der obersten Ebene können mit dieser Aktion nicht verschoben werden.',
	'Type a site name to filter the choices below.' => 'Geben Sie einen Sitenamen ein, um die Auswahl einzuschränken.',
	'Type a website name to filter the choices below.' => 'Geben Sie einen Namen ein, um die Auswahl einzuschränken.',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{Blog &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_5]&#8220; von &#8222;[_3]&#8220; nach &#8222;[_4]&#8220; verschoben},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Website &#8222;[_1]&#8220; (ID: [_2]) gelöscht von &#8222;[_3]&#8220;},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
	'Category loop detected' => 'Kategorieschleife festgestellt',
	'Category' => 'Kategorie',
	'Parent' => 'Mutter',
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,Eintrag,Einträge,Keine Einträge]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,Seite,Seiten,Keine Seiten]',

## lib/MT/CategorySet.pm
	'Category Count' => 'Anzahl Kategorien',
	'Category Label' => 'Kategorie-Bezeichung',
	'Content Type Name' => 'Inhaltstyp-Name',
	'name "[_1]" is already used.' => 'Name "[_1]" wird bereits verwendet.',
	'name is required.' => 'Name erforderlich',

## lib/MT/Comment.pm
	q{Loading blog '[_1]' failed: [_2]} => q{Laden des Blogs &#8222;[_1]&#8220; fehlgeschlagen: [_2]},
	q{Loading entry '[_1]' failed: [_2]} => q{Eintrag &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},

## lib/MT/Compat/v3.pm
	'No executable code' => 'Kein ausführbarer Code',
	'Publish-option name must not contain special characters' => 'Der Optionsname darf keine Sonderzeichen enthalten.',
	'uses [_1]' => 'verwendet [_1]',
	'uses: [_1], should use: [_2]' => 'verwendet [_1], sollte [_2] verwenden',

## lib/MT/Component.pm
	q{Loading template '[_1]' failed: [_2]} => q{Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},

## lib/MT/Config.pm
	'Configuration' => 'Konfiguration',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias für [_1] bildet eine Schleife.',
	'Config directive [_1] without value at [_2] line [_3]' => 'Konfigurationsanweisung [_1] ohne Wert [_2] in Zeile [_3]',
	q{Error opening file '[_1]': [_2]} => q{Fehler beim Öffnen der Datei &#8222;[_1]&#8220;: [_2]},
	q{No such config variable '[_1]'} => q{Konfigurationsvariable &#8222;[_1]&#8220; nicht vorhanden},

## lib/MT/ContentData.pm
	'(No label)' => '(Keine Bezeichnung)',
	'Author' => 'Autor',
	'Cannot load content field #[_1]' => 'Konnte Inhaltsfeld #[_1] nicht laden',
	'Contents by [_1]' => 'Inhalte von [_1]',
	'Identifier' => 'Kennung',
	'Invalid content type' => 'Ungültiger Inhaltstyp',
	'Link' => 'Link',
	'No Content Type could be found.' => 'Keine Inhaltstypen gefunden.',
	'Publish Date' => 'Zeitpunkt der Veröffentlichung',
	'Removing content field indexes failed: [_1]' => 'Entfernen des Inhaltsfeld-Index fehlgeschlagen: [_1]',
	'Removing object assets failed: [_1]' => 'Entfernen des Assets des Objekts fehlgeschlagen: [_1]',
	'Removing object categories failed: [_1]' => 'Entfernen der Kategorien des Objekts fehlgeschlagen: [_1]',
	'Removing object tags failed: [_1]' => 'Entfernen der Tags des Objekts fehlgeschlagen: [_1]',
	'Saving content field index failed: [_1]' => 'Speichern des Inhaltsfeld-Index fehlgeschlagen: [_1]',
	'Saving object asset failed: [_1]' => 'Speichern des Assets des Objekts fehlgeschlagen: [_1]',
	'Saving object category failed: [_1]' => 'Speichern der Kategorie des Objekts fehlgeschlagen: [_1]',
	'Saving object tag failed: [_1]' => 'Speichern des Tags des Objekts fehlgeschlagen: [_1]',
	'Tags fields' => 'Tag-Felder',
	'Unpublish Date' => 'Zeitpunkt der Zurückziehung',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] (ID: [_2]) nicht vorhanden.',
	'basename is too long.' => '', # Translate - New
	'record does not exist.' => 'Eintrag nicht vorhanden.',

## lib/MT/ContentField.pm
	'Cannot load content field data_type [_1]' => '', # Translate - New
	'Content Fields' => 'Inhaltsfelder',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Inhaltsfeld-Index',
	'Content Field Indexes' => 'Inhaltstyp-Indizes',

## lib/MT/ContentFieldType.pm
	'Audio Asset' => 'Audiodatei',
	'Checkboxes' => 'Checkboxen',
	'Date and Time' => 'Datum und Uhrzeit',
	'Date' => 'Datum',
	'Embedded Text' => 'Eingebetteter Text',
	'Image Asset' => 'Bilddatei',
	'Multi Line Text' => 'Mehrzeiliger Text',
	'Number' => 'Zahl',
	'Radio Button' => 'Radiobutton',
	'Select Box' => 'Auswahlkästchen',
	'Single Line Text' => 'Einzeiliger Text',
	'Table' => 'Tabelle',
	'Text Display Area' => '', # Translate - New
	'Time' => 'Uhrzeit',
	'Video Asset' => 'Videodatei',
	'__LIST_FIELD_LABEL' => 'Liste',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Zeige alle [_1]-Assets',
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.} => q{Bitte geben Sie für die Höchstauswahl von '[_1]' ([_2]) eine ganze Zahl größer oder gleich 1 ein.},
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.} => q{Bitte geben Sie für die Höchstauswahl von '[_1]' ([_2]) eine ganze Zahl größer oder gleich der Mindestauswahl ein.},
	q{A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.} => q{Bitte geben Sie für die Mindestauswahl von '[_1]' ([_2]) eine ganze Zahl größer oder gleich 0 ein.},
	q{You must select or upload correct assets for field '[_1]' that has asset type '[_2]'.} => q{Bitte verwenden Sie für das Feld '[_1]' Assets vom Typ '[_2]'.},

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'Ungültige Kategorie-IDs [_1] in "[_2]"-Feld',
	'No category_set setting in content field type.' => 'Inhaltsfeld-Typ ohne category_set-Einstellung ',
	'The source category set is not found in this site.' => 'Das Quell-Kategorie-Set ist in dieser Site nicht vorhanden.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'Keine passenden Kategorie gefunden. Legen Sie einen Kategorie an, um Kategorie-Felder verwenden zu können.',
	'You must select a source category set.' => 'Bitte wählen Sie ein Quell-Kategorie-Set aus.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'A label for each value is required.' => 'Geben Sie jedem Wert eine Bezeichung.',
	'A value for each label is required.' => 'Geben Sie jeder Bezeichnung einen Wert.',
	'You must enter at least one label-value pair.' => 'Geben Sie mindestens ein Bezeichnung-Wert-Paar ein.',

## lib/MT/ContentFieldType/Common.pm
	'"[_1]" field value must be greater than or equal to [_2]' => 'Wert des Felds "[_1]" muss größer oder gleich [_2] sein.',
	'"[_1]" field value must be less than or equal to [_2].' => 'Wert des Felds "[_1]" muss kleiner oder gleich [_2] sein.',
	'In [_1] column, [_2] [_3]' => '[_2] [_3] in [_1]-Spalte',
	'Invalid [_1] in "[_2]" field.' => '[_1] im Feld "[_2]" ist ungültig.',
	'Invalid values in "[_1]" field: [_2]' => 'Ungültige Werte im Feld "[_1]": [_2]',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Im Feld "[_2]" kann nur genau ein [_1] gewählt werden.',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '[_1] im Feld "[_3]" muss größer oder gleich [_2] sein',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '[_1] im Feld "[_3]" muss kleiner oder gleich [_2] sein',
	'is not selected' => 'ist nicht gewählt',
	'is selected' => 'ist gewählt',

## lib/MT/ContentFieldType/ContentType.pm
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'Ungültige Inhaltsdaten-IDs im Feld "[_2]": [_1]',
	'No Label (ID:[_1]' => 'Keine Bezeichnung (ID:[_1]',
	'The source Content Type is not found in this site.' => 'Quell-Inhaltstyp in dieser Site nicht gefunden.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'Es stehen keine Inhaltstypen zur Auswahl. Bitte legen Sie zuerst einen neuen Inhaltstyp an, um Inhaltstyp-Felder zu verwenden.',
	'You must select a source content type.' => 'Bitte wählen Sie einen Quell-Inhaltstyp.',

## lib/MT/ContentFieldType/Date.pm
	q{Invalid date '[_1]'; An initial date value must be in the format YYYY-MM-DD.} => q{Ungültiges Datum '[_1]'. Bitte geben Sie das Ursprungsdatum im Format JJJJ-MM-TT an.},

## lib/MT/ContentFieldType/DateTime.pm
	q{Invalid date '[_1]'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ungültiges Datum '[_1]'. Bitte geben Sie den Ursprungszeitpunkt im Format JJJJ-MM-TT HH:MM:SS an.},

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value has invalid precision.' => 'Feld "[_1]" hat eine unzulässige Anzahl Dezimalstellen.',
	'"[_1]" field value must be a number.' => 'Feld "[_1]" muss eine Zahl enthalten.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Höchstwert eine ganze Zahl zwischen [_1] und [_2] ein.',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Höchstwert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Mindestwert eine ganze Zahl zwischen [_1] und [_2] ein.',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Mindestwert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'An initial value must be an integer and between [_1] and [_2]' => 'Bitte geben Sie als Ursprungswert eine ganze Zahl zwischen [_1] und [_2] ein.',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'Bitte geben Sie als Ursprungswert eine ganze Zahl ein. Um Dezimalstellen verwenden Sie können, konfigurieren Sie das Feld entsprechend.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'Bitte geben Sie als Anzahl Dezimalstellen eine positive ganze Zahl zwischen 0 und [_1] ein.',
	'Number of decimal places must be a positive integer.' => 'Bitte geben Sie als Anzahl Dezimalstellen eine positive ganze Zahl ein.',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Bitte geben Sie Bezeichner für die Werte ein.',
	'A value of values is required.' => 'Bitte geben Sie Werte für die Werte ein.',

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => 'Feld "[_1]" zu lang.',
	'"[_1]" field is too short.' => 'Feld "[_2] zu kurz.',
	q{A maximum length number for '[_1]' ([_2]) must be a positive integer between 1 and [_3].} => q{Bitte geben Sie als Höchstlänge von '[_1]' ([_2]) eine ganze Zahl zwischen 0 und [_3] an.},
	q{A minimum length number for '[_1]' ([_2]) must be a positive integer between 0 and [_3].} => q{Bitte geben Sie als Mindestlänge von '[_1]' ([_2]) eine ganze Zahl zwischen 0 und [_3] an.},
	q{An initial value for '[_1]' ([_2]) must be shorter than [_3] characters} => q{Der Ursprungswert von '[_1]' ([_2]) muss kürzer als [_3] Zeichen sein.},

## lib/MT/ContentFieldType/Table.pm
	q{Initial number of columns for '[_1]' ([_2]) must be a positive integer.} => q{Bitte geben Sie ursprüngliche Anzahl Spalten von '[_1]' ([_2]) eine positive ganze Zahl ein.},
	q{Initial number of rows for '[_1]' ([_2]) must be a positive integer.} => q{Bitte geben Sie als ursprüngliche Anzahl Zeilen von '[_1]' ([_2]) eine positive ganze Zahl ein.},

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tag "[_1]": [_2]' => 'Kann Tag "[_1]" nicht anlegen: [_2]',
	'Cannot create tags [_1] in "[_2]" field.' => 'Kann Tags [_1] nicht in Feld "[_2]" anlegen.',
	q{An initial value for '[_1]' ([_2]) must be an shorter than 255 characters} => q{Der Ursprungswert von '[_1]' ([_2]) muss kürzer als 255 Zeichen sein.},

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	q{Invalid time '[_1]'; An initial time value be in the format HH:MM:SS.} => q{Zeitangabe '[_1]' ungültig. Bitte geben Sie die Ursprungszeit im Format HH:MM:SS an.},

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'Ungültige URL im Feld "[_1]".',
	q{An initial value for '[_1]' ([_2]) must be shorter than 2000 characters} => q{Der Ursprungswert von '[_1]' ([_2]) muss kürzer als 2000 Zeichen sein.},

## lib/MT/ContentPublisher.pm
	'An error occurred while publishing scheduled contents: [_1]' => 'Bei der zeitgeplanten Veröffentlichtung von Inhalten ist ein Fehler augetreten: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Bei der zeitgeplanten Zurückziehung von Inhalten ist ein Fehler aufgetreten: [_1]',
	'Cannot load catetory. (ID: [_1]' => 'Konnte Kategorie nicht laden. (ID: [_1])',
	'Scheduled publishing.' => 'Zeitgeplante Veröffentlichtung.',
	'You did not set your site publishing path' => 'Veröffentlichungspfade nicht gesetzt',
	'[_1] archive type requires [_2] parameter' => 'Für den Archivtyp [_1] ist das Parameter [_2] erforderlich.',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{Fehler bei der Veröffentlichung von [_1] &#8222;[_2]&#8220;: [_3]},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{Fehler bei Veröffentlichung des Archivs &#8222;[_1]&#8220;: [_2]},
	q{Archive type '[_1]' is not a chosen archive type} => q{Archivtyp &#8222;[_1]&#8220; wurde nicht ausgewählt},
	q{Load of blog '[_1]' failed: [_2]} => q{Blog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},
	q{Load of blog '[_1]' failed} => q{Blog '[_1]' konnte nicht geladen werden},
	q{Loading of blog '[_1]' failed: [_2]} => q{Blog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},
	q{Parameter '[_1]' is invalid} => q{Parameter &#8222;[_1]&#8220; ungültig},
	q{Parameter '[_1]' is required} => q{Parameter &#8222;[_1]&#8220; erforderlich},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{Temporäre Datei &#8222;[_1]&#8220; konnte nicht umbenannt werden: [_2]},
	q{Writing to '[_1]' failed: [_2]} => q{&#8222;[_1]&#8220; konnte nicht beschrieben werden: [_2]},

## lib/MT/ContentType.pm
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (Site: "[_2]" ID: [_3])',
	'Content Data # [_1] not found.' => 'Inhaltsdaten # [_1] nicht gefunden.',
	'Create Content Data' => 'Inhaltsdaten anlegen',
	'Edit All Content Data' => 'Alle Inhaltsdaten bearbeiten',
	'Manage Content Data' => 'Inhaltsdaten verwalten',
	'Publish Content Data' => 'Inhaltsdaten veröffentlichen',
	'Tags with [_1]' => 'Tags mit [_1]',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'Konnte keine eindeutige unique_id erzeugen',

## lib/MT/Core.pm
	'(system)' => '(System)',
	'*Website/Blog deleted*' => 'Website/Blog gelöscht',
	'Activity Feed' => 'Aktivitäts-Feed',
	'Add Summary Watcher to queue' => 'Summary Watchers zur Warteschlange hinzufügen',
	'Address Book is disabled by system configuration.' => 'Das Adressbuch ist systemweit deaktiviert.',
	'Adds Summarize workers to queue.' => 'Fügt Summarize Workers zur Warteschlange hinzu',
	'Blog ID' => 'Blog-ID',
	'Blog Name' => 'Name des Blogs',
	'Blog URL' => 'Blog-URL',
	'Change Settings' => 'Einstellungen ändern',
	'Classic Blog' => 'Klassisches Blog',
	'Contact' => 'Kontakt',
	'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
	'Create Child Sites' => 'Untersite anlegen',
	'Create Entries' => 'Neuer Eintrag',
	'Create Sites' => 'Sites anlegen',
	'Create Websites' => 'Website anlegen',
	'Database Name' => 'Datenbankname',
	'Database Path' => 'Datenbankpfad',
	'Database Port' => 'Port',
	'Database Server' => 'Hostname',
	'Database Socket' => 'Socket',
	'Date Created' => 'Angelegt',
	'Date Modified' => 'Bearbeitet',
	'Days must be a number.' => 'Tage müssen als Zahl angegeben werden.',
	'Edit All Entries' => 'Alle Einträge bearbeiten',
	'Entries List' => 'Eintragsliste',
	'Entry Excerpt' => 'Eintragsauszug',
	'Entry Extended Text' => 'Erweiterter Text',
	'Entry Link' => 'Eintragslink',
	'Entry Title' => 'Eintragstitel',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Beim Anlegen des Leistungsprotrokolls-Ordners [_1] ist ein Fehler aufgetreten. Bitte vergeben Sie entweder Schreibrechte für das gewählte Verzeichnis oder geben Sie über das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; ein anderes an. [_2]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: Das unter PerformanceLoggingPath angegebene Verzeichnis ist vorhanden, kann aber nicht beschrieben werden. [_1]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Beim Anlegen des Leistungsprotrokolls ist ein Fehler aufgetreten: Das Konfigurationsparameter &#8222;PerformanceLoggingPath&#8220; muss auf ein Verzeichnis, nicht auf eine Datei zeigen. [_1]',
	'Filter' => 'Zeigen',
	'Folder' => 'Ordner',
	'Get Variable' => 'Variable lesen',
	'Group Member' => 'Groupmember',
	'Group Members' => 'Gruppenmitglieder',
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => 'Die IP-Sperrliste ist systemweit deaktiviert.',
	'IP Banning Settings' => 'IP-Sperren-Einstellungen',
	'IP address' => 'IP-Adresse',
	'IP addresses' => 'IP-Adressen',
	'If Block' => 'If-Block',
	'If/Else Block' => 'If-Else-Block',
	'Include Template File' => 'Include-Vorlagendatei',
	'Include Template Module' => 'Include-Vorlagenmodul',
	'Junk Folder Expiration' => 'Junk-Ordner-Einstellungen',
	'Legacy Quick Filter' => 'Schnellfilter (Altsystem)',
	'Log' => 'Log',
	'Manage Address Book' => 'Adressbuch verwalten',
	'Manage All Content Data' => 'Alle inhaltsdaten verwalten',
	'Manage Assets' => 'Assets verwalten',
	'Manage Blog' => 'Blog verwalten',
	'Manage Categories' => 'Kategorien verwalten',
	'Manage Category Set' => 'Kategorie-Set verwalten',
	'Manage Content Type' => 'Inhaltstyp verwalten',
	'Manage Content Types' => 'Inhaltstypen verwalten',
	'Manage Feedback' => 'Feedback verwalten',
	'Manage Group Members' => 'Gruppenmitglieder verwalten',
	'Manage Pages' => 'Seiten verwalten',
	'Manage Plugins' => 'Plugins verwalten',
	'Manage Sites' => 'Sites verwalten',
	'Manage Tags' => 'Tags verwalten',
	'Manage Templates' => 'Vorlagen verwalten',
	'Manage Themes' => 'Themen verwalten',
	'Manage Users & Groups' => 'Benutzer und Gruppen verwalten',
	'Manage Users' => 'Benutzer verwalten',
	'Manage Website with Blogs' => 'Website mit Blogs verwalten',
	'Manage Website' => 'Website verwalten',
	'Member' => 'Mitglied',
	'Members' => 'Mitglieder',
	'Movable Type Default' => 'Movable Type-Standard',
	'My Items' => 'Meine Elemente',
	'My [_1]' => 'Meine [_1]',
	'MySQL Database (Recommended)' => 'MySQL-Datenbank (empfohlen)',
	'No Title' => 'Kein Name',
	'No label' => 'Keine Bezeichnung',
	'Password' => 'Passwort',
	'Permission' => 'Berechtigung',
	'Post Comments' => 'Kommentare schreiben',
	'PostgreSQL Database' => 'PostgreSQL-Datenbank',
	'Publish Entries' => 'Einträge veröffentlichen',
	'Publish Scheduled Contents' => 'Zeitgeplante Inhalte veröffentlichen',
	'Publish Scheduled Entries' => 'Zeitgeplante Einträge veröffentlichen',
	'Publishes content.' => 'Veröffentlicht Inhalte.',
	'Purge Stale DataAPI Session Records' => 'Abgelaufene DataAPI-Sessiondaten löschen',
	'Purge Stale Session Records' => 'Abgelaufene Sessiondaten löschen ',
	'Purge Unused FileInfo Records' => 'Nicht verwendete FileInfo-Einträge löschen',
	'Refreshes object summaries.' => 'Setzt Object Summaries zurück',
	'Remove Compiled Template Files' => 'Kompilierte Vorlagen-Dateien entfernen',
	'Remove Temporary Files' => 'Temporäre Dateien löschen',
	'Remove expired lockout data' => 'Abgelaufene Sperrdaten löschen',
	'Rich Text' => 'Grafischer Editor',
	'SQLite Database (v2)' => 'SQLite-Datenbank (v2)',
	'SQLite Database' => 'SQLite-Datenbank',
	'Send Notifications' => 'Benachrichtigungen versenden',
	'Set Publishing Paths' => 'Veröffentlichungspfade setzen',
	'Set Variable Block' => 'Variablenblock setzen',
	'Set Variable' => 'Variable setzen',
	'Sign In(CMS)' => 'Anmelden (CMS)',
	'Sign In(Data API)' => 'Anmelden (Data-API)',
	'Synchronizes content to other server(s).' => 'Synchronisiert Inhalte mit anderen Servern.',
	'Tag' => 'Tag',
	'The physical file path for your SQLite database. ' => 'Physischer Pfad zur SQLite-Datenbank',
	'Unpublish Past Contents' => 'Frühere Inhalte nicht mehr veröffentlichen',
	'Unpublish Past Entries' => 'Frühere Einträge nicht mehr veröffentlichen',
	'Upload File' => 'Datei hochladen',
	'View Activity Log' => 'Aktivitätsprotokoll ansehen',
	'View System Activity Log' => 'Systemaktivitätsprotokoll einsehen',
	'Widget Set' => 'Widgetgruppe',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] zwischen [_3] und [_4]',
	'[_1] [_2] future' => '[_1] [_2] in der Zukunft',
	'[_1] [_2] or before [_3]' => '[_1] [_2] oder bevor [_3]',
	'[_1] [_2] past' => '[_1] [_2] zurück',
	'[_1] [_2] since [_3]' => '[_1] [_2] seit',
	'[_1] [_2] these [_3] days' => '[_1] [_2] dieser [_3] Tage',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'[_1] of this Site' => '[_1] dieser Site',
	'option is required' => 'Option erforderlich.',
	'tar.gz' => 'tar.gz',
	'zip' => 'ZIP',
	q{This is often 'localhost'.} => q{Meistens 'localhost'.},

## lib/MT/DataAPI/Callback/Blog.pm
	'Cannot apply website theme to blog: [_1]' => 'Kann Thema der Website nicht auf das Blog anwenden: [_1]',
	'Invalid theme_id: [_1]' => 'Ungültige theme_id: [_1]',
	'The website root directory must be an absolute path: [_1]' => 'Das Wurzelverzeichnis der Website muss als absoluter Pfad angegeben werden: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'Parent [_1] (ID:[_2]) not found.' => 'Eltern-[_1] nicht gefunden (ID:[_2])',
	q{The label '[_1]' is too long.} => q{Die Bezeichnung '[_1]' ist zu lang.},

## lib/MT/DataAPI/Callback/CategorySet.pm
	q{Name "[_1]" is used in the same site.} => q{Der Name '[_1]' wird in der gleichen Site bereits verwendet.},

## lib/MT/DataAPI/Callback/ContentData.pm
	'"[_1]" is required.' => '', # Translate - New
	'There is an invalid field data: [_1]' => 'Ein Feld enthält ungültige Daten: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'Parameter "[_1]" ungültig: [_2]',
	'Invalid option key(s): [_1]' => 'Ungültige(r) Optionsschlüssel: [_1]',
	'Invalid option(s): [_1]' => 'Ungültige Option(en): [_1]',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler von Typ "[_1] ungültig.',

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Parameter "[_1]" ist ungültig.',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'Ungültige author_id: [_1]',
	'log' => 'Log',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{Log (ID:[_1]) gelöscht von '[_2]'},

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Befehls-Name ungültig: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Archiv-Art ungültig: [_1]',

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => 'dateFormat ungültig: [_1]',
	'Invalid textFormat: [_1]' => 'textFormat ungültig: [_1]',

## lib/MT/DataAPI/Endpoint/Auth.pm
	q{Failed login attempt by user who does not have sign in permission via data api. '[_1]' (ID:[_2])} => q{Fehlgeschlagener Anmeldeversuch von Benutzer ohne Anmeldeberechtigung über Data-API. '[_1]' (ID:[_2])},
	q{User '[_1]' (ID:[_2]) logged in successfully via data api.} => q{Benutzer '[_1]' (ID:[_2]) erfolgreich über Data-API angemeldet.},

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Ungültiges dateFrom-Parameter: [_1]',
	'Invalid dateTo parameter: [_1]' => 'Ungültiges dateTo-Parameter: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'Invalid height: [_1]' => 'Höhe ungültig: [_1]',
	'Invalid scale: [_1]' => 'Maßstabl ungültig: [_1]',
	'Invalid width: [_1]' => 'Breite ungültig: [_1]',
	'The asset does not support generating a thumbnail file.' => 'Für dieses Asset kann kein Vorschaubild erzeugt werden.',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Beim Backup ist ein Fehler aufgetreten: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie das Aktivitätsprotokoll.',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format-Parameter ungültig: [_1]',
	'Invalid backup_what: [_1]' => 'backup_what-Parameter ungültig: [_1]',
	'Invalid limit_size: [_1]' => 'limit_size-Parameter ungültig: [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Sicherung beschreibbar sein. Bitte überprüfen Sie Ihre (Export)TempDir-Einstellung.',
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Wiederherstellungen nicht erneut wiederhergestellt werden.},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Unter Blog ID:[_1] konnte kein Blog angelegt werden.',
	'Either parameter of "url" or "subdomain" is required.' => 'Parameter "url" oder "subdomain" erforderlich.',
	'Site not found' => 'Site nicht gefunden',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Die Website "[_1] (ID:[_2]) enthält noch Blogs und wurde daher nicht gelöscht. Löschen Sie zuerst diese Blogs, um die Site löschen zu können.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'Loading object failed: [_1]' => 'Konnte Objekt nicht laden: [_1]',
	'[_1] not found' => '[_1] nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1]" is required.' => 'Resource "[_1]" erforderlich.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',
	'Could not found archive template for [_1].' => 'Archiv-Vorlage für [_1] nicht gefunden.',
	'Invalid convert_breaks: [_1]' => 'convert_breaks-Parameter ungültig: [_1]',
	'Invalid default_cat_id: [_1]' => 'default_cat_it-Parameter ungültig: [_1]',
	'Invalid encoding: [_1]' => 'Zeichencodierung ungültig: [_1]',
	'Invalid import_type: [_1]' => 'import_type-Parameter ungültig: [_1]',
	'Preview data not found.' => 'Vorschaudaten nicht gefunden.',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Bitte geben Sie ein "password"-Parameter an, wenn Sie neue Benutzerkonten für die im Blog gelisteten Benutzer anlegen möchten.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden.},

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => '"member"-Angabe erforderlich.',
	'Adding member to group failed: [_1]' => 'Hinzufügen des Mitglieds zur Gruppe ist fehlgeschlagen: [_1]',
	'Cannot add member to inactive group.' => 'Zu inaktiven Gruppen können keine Mitglieder hinzugefügt werden.',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Das Anlegen der Gruppe ist fehlgeschlagen: ExternalGroupmanagement ist aktiv.',
	'Group not found' => 'Gruppe nicht gefunden',
	'Member not found' => 'Mitglied nicht gefunden',
	'Removing member from group failed: [_1]' => 'Entfernen des Mitglieds aus der Gruppe ist fehlgeschlagen: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Protokolleintrag',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{Das 'folder'-Parameter ist ungültig.},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Verknüpfung nicht gefunden',
	'Granting permission failed: [_1]' => 'Zuweisen der Berechtigung fehlgeschlagen: [_1]',
	'Revoking permission failed: [_1]' => 'Entzug der Berechtigung fehlgeschlagen: [_1]',
	'Role not found' => 'Rolle nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Private Tags, die für systemweite Objekte verwendet werden, können nicht gelöscht werden.',
	'Cannot delete private tag in system scope.' => 'Private Tags im Systemkontext können nicht gelöscht werden.',
	'Tag not found' => 'Tag nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'A parameter "refresh_type" is invalid: [_1]' => 'Das "refresh_type"-Parameter ist ungültig: [_1]',
	'A resource "template" is required.' => '"Template"-Ressource erforderlich.',
	'Cannot clone [_1] template.' => 'Die [_1]-Vorlage konnte nicht geklont werden.',
	'Cannot delete [_1] template.' => 'Die [_1]-Vorlage konnte nicht gelöscht werden.',
	'Cannot get [_1] template.' => '', # Translate - New
	'Cannot preview [_1] template.' => '', # Translate - New
	'Cannot publish [_1] template.' => 'Die [_1]-Vorlage konnte nicht veröffentlicht werden.',
	'Cannot refresh [_1] template.' => '', # Translate - New
	'Cannot update [_1] template.' => '', # Translate - New
	'Template not found' => 'Vorlage nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Vorlage "[_1]" ist keine Archiv-Vorlage.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Applying theme failed: [_1]' => 'Anwendung des Themas fehlgeschlagen: [_1]',
	'Cannot apply website theme to blog.' => 'Das Thema konnte nicht auf die Website angewendet werden.',
	'Cannot uninstall theme because the theme is in use.' => 'Das Thema konnte nicht deinstalliert werden, da es verwendet wird.',
	'Cannot uninstall this theme.' => 'Das Thema konnte nicht deinstalliert werden.',
	'Changing site theme failed: [_1]' => 'Wechseln des Site-Themas fehlgeschlagen: [_1]',
	'Unknown archiver type: [_1]' => 'Unbekannter Archivtyp: [_1]',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_ids dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten und müssen mit einem Buchstaben beginnen.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_versions dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten.',
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{Das neue Thema kann nicht installiert werden, da der Basename bereits existiert und geschützt ist: [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{Ein Export-Ordner '[_1]' existiert bereits. Sie können das vorhandene Thema überschreiben, indem sie das Parameter 'overwrite_yes=1' verwenden, oder ändern Sie den Basisnamen.},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Es wurde eine E-Mail mit einem Link zum Zurücksetzen Ihres Passwortes an Ihre Adresse ([_1]) verschickt .',
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'Die angegebene E-Mail-Adresse wird mehrfach verwendet. Geben Sie daher im Parameter "name" Ihren Benutzernamen an.',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Removing Widget failed: [_1]' => 'Löschen des Widgets fehlgeschlagen: [_1]',
	'Widget not found' => 'Widget nicht gefunden',
	'Widgetset not found' => 'Widgetgruppe nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => '"widgetset" erforderlich.',
	'Removing Widgetset failed: [_1]' => 'Löschen der Widgetgruppe fehlgeschlagen: [_1]',

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is invalid.' => 'Parameter "content_fields" ungültig.',
	'A parameter "content_fields" is required.' => 'Parameter "content_fileds" erforderlich.',

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kann "[_1]" nicht als ISO-8601-Zeitangabe lesen',

## lib/MT/DefaultTemplates.pm
	'About This Page' => 'Über diese Seite',
	'Archive Index' => 'Archiv-Index',
	'Archive Widgets Group' => 'Archiv-Widgetgruppe',
	'Blog Index' => 'Blog-Index',
	'Calendar' => 'Kalendar',
	'Category Entry Listing' => 'Einträge nach Kategorie',
	'Comment Form' => 'Kommentarformular',
	'Creative Commons' => 'Creative Commons',
	'Current Author Monthly Archives' => 'Monatsarchiv des aktuellen Autors',
	'Date-Based Author Archives' => 'Datumsbasiertes Autorenarchiv',
	'Date-Based Category Archives' => 'Datumsbasiertes Kategoriearchiv',
	'Displays errors for dynamically-published templates.' => 'Zeigt Fehlermeldung von dynamisch erzeugten Vorlagen an.',
	'Displays image when user clicks a popup-linked image.' => 'Zeigt Bilder als Pop-Ups an, wenn auf ein Vorschaubild geklickt wird ',
	'Displays results of a search.' => 'Zeigt Suchergebnisse an',
	'Dynamic Error' => 'Dynamische Fehlermeldungen',
	'Entry Notify' => 'Eintragsbenachrichtigung',
	'Feed - Recent Entries' => 'Feed - Aktuelle Einträge',
	'Home Page Widgets Group' => 'Startseiten-Widgetgruppe',
	'IP Address Lockout' => 'IP-Sperre',
	'JavaScript' => 'JavaScript',
	'Monthly Archives Dropdown' => 'Monatsarchiv (Dropdown)',
	'Monthly Entry Listing' => 'Einträge nach Monat',
	'Navigation' => 'Navigation',
	'OpenID Accepted' => 'OpenID unterstützt',
	'Page Listing' => 'Seitenübersicht',
	'Popup Image' => 'Popup-Bild',
	'Powered By' => 'Powered by',
	'RSD' => 'RSD',
	'Search Results for Content Data' => 'Suchergebnis für Inhaltsdaten',
	'Stylesheet' => 'Stylesheet',
	'Syndication' => 'Syndizierung',
	'User Lockout' => 'Kontensperre',

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'Kommentare annehmen',
	'Accept Trackbacks' => 'TrackBacks annehmen',
	'Author ID' => 'ID des Autors',
	'Body' => 'Text',
	'Draft Entries' => 'Eintrags-Entwürfe',
	'Draft' => 'Entwurf',
	'Entries by [_1]' => 'Einträge nach [_1]',
	'Entries from category: [_1]' => 'Einträge aus Kategorie [_1]',
	'Entries in This Site' => 'Einträge auf dieser Website',
	'Extended' => 'Erweiterter Text',
	'Format' => 'Format',
	'Future' => 'Künftig',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Ungültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Asset-Objekte handeln.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Ugültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Category-Objekte handeln.',
	'Junk' => 'Spam',
	'My Entries' => 'Meine Einträge',
	'NONE' => 'KEIN(E)',
	'Primary Category' => 'Hauptkategorie',
	'Published Entries' => 'Veröffentlichte Einträge',
	'Published' => 'Veröffentlicht',
	'Review' => 'Zur Überprüfung',
	'Reviewing' => 'In Prüfung',
	'Scheduled Entries' => 'Zeitgeplante Einträge',
	'Scheduled' => 'Zu bestimmtem Zeitpunkt',
	'Spam' => 'Spam',
	'Unpublished (End)' => 'Unveröffentlicht (Ende)',
	'Unpublished Entries' => 'Unveröffentlichte Einträge',
	'View [_1]' => '[_1] ansehen',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV-Verbindung fehlgeschlagen: [_1]',
	'DAV get failed: [_1]' => 'DAV-&#8222;get&#8220; fehlgeschlagen: [_1]',
	'DAV open failed: [_1]' => 'DAV-&#8222;open&#8220; fehlgeschlagen: [_1]',
	'DAV put failed: [_1]' => 'DAV-&#8222;put&#8220; fehlgeschlagen: [_1]',
	q{Creating path '[_1]' failed: [_2]} => q{Das Verzeichnis &#8222;[_1]&#8220; konnte nicht angelegt werden: [_2]},
	q{Deleting '[_1]' failed: [_2]} => q{&#8222;[_1]&#8220; konnte nicht gelöscht werden: [_2]},
	q{Renaming '[_1]' to '[_2]' failed: [_3]} => q{&#8222;[_1]&#8220; konnte nicht in &#8220;[_2]&#8220; umbenannt werden: [_3]},

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP-Verbindung fehlgeschlagen: [_1]',
	'SFTP get failed: [_1]' => 'SFTP-&#8222;get&#8220; fehlgeschlagen: [_1]',
	'SFTP put failed: [_1]' => 'SFTP-&#8222;put&#8220; fehlgeschlagen: [_1]',

## lib/MT/Filter.pm
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_items" und "editable_filters" können nicht gleichzeitig verwendet werden.',
	'Invalid filter type [_1]:[_2]' => 'Dateityp [_1] ungültig: [_2]',
	'Invalid sort key [_1]:[_2]' => 'Sortierschlüssel [_1] ungültig: [_2]',

## lib/MT/Group.pm
	'Active Groups' => 'Aktive Gruppen',
	'Disabled Groups' => 'Deaktivierte Gruppen',
	'Email' => 'E-Mail',
	'Groups associated with author: [_1]' => 'Mit Autor verknüpfte Gruppen: [_1]',
	'Inactive' => 'Inaktiv',
	'Members of group: [_1]' => 'Gruppenmitglieder: [_1]',
	'My Groups' => 'Meine Gruppen',
	'__COMMENT_COUNT' => 'Kommentare',
	'__GROUP_MEMBER_COUNT' => 'Mitglieder',

## lib/MT/IPBanList.pm
	'IP Ban' => 'IP-Sperre',
	'IP Bans' => 'IP-Sperren',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Maximale Dateigröße überschritten: [_1] > [_2]',
	'Invalid Image Driver [_1]' => 'Bildquelle [_1] ungültig',
	'Saving [_1] failed: Invalid image file format.' => 'Konnte [_1] nicht speichern: Dateiformat ungültig',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'GD kann nicht geladen werden: [_1]',
	'Reading image failed: [_1]' => 'Bild kann nicht geladen werden: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'Drehen (um [_1] Grad) wird nicht unterstützt.',
	'Unsupported image file type: [_1]' => 'Nicht unterstütztes Bildformat: [_1]',
	q{Reading file '[_1]' failed: [_2]} => q{Datei &#8222;[_1]&#8220; kann nicht gelesen werden: [_2]},

## lib/MT/Image/ImageMagick.pm
	'Cannot load [_1]: [_2]' => '', # Translate - New
	'Converting image to [_1] failed: [_2]' => 'Bei der Konvertierung des Fotos in [_1] ist ein Fehler aufgetreten: [_2]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Beim Beschnitt auf ein [_1]x[_2] großes Quadrat ab der Stelle [_3], [_4] ist ein Fehler aufgetreten: [_5]',
	'Flip horizontal failed: [_1]' => 'Horizontales Spiegeln fehlgeschlagen: [_1]',
	'Flip vertical failed: [_1]' => 'Vertikales Spiegeln fehlgeschlagen: [_1]',
	'Outputting image failed: [_1]' => 'Ausgabe des Bildes fehlgeschlagen: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Drehen (um [_1] Grad) fehlgeschlagen: [_2]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Bei der Skalierung auf [_1]x[_2] ist ein Fehler aufgetreten: [_3]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Imager kann nicht geladen werden: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'IPC::Run kann nicht geladen werden: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Beschneiden auf [_1]x[_2] fehlgeschlagen: [_3]',
	'Reading alpha channel of image failed: [_1]' => 'Der Alphakanal des Bildes konnte nicht eingelesen werden: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Kein gültiger Pfad zu den NetPBM-Tools gefunden.',

## lib/MT/Import.pm
	'Another system (Movable Type format)' => 'Anderes System (Movable Type-Format)',
	'Could not resolve import format [_1]' => 'Kann Importformat [_1] nicht auflösen',
	'File not found: [_1]' => 'Datei nicht gefunden: [_1]',
	'No readable files could be found in your import directory [_1].' => 'Keine lesbaren Dateien im Import-Verzeichnis [_1] gefunden.',
	q{Cannot open '[_1]': [_2]} => q{Kann &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Importing entries from file '[_1]'} => q{Importiere Einträge aus Datei &#8222;[_1]&#8220;},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
	'No Blog' => 'Kein Blog',
	'Saving category failed: [_1]' => 'Die Kategorie konnte nicht gespeichert werden: [_1]',
	'Saving entry failed: [_1]' => 'Der Eintrag konnte nicht gespeichert werden: [_1]',
	'Saving user failed: [_1]' => 'Das Benutzerkonto konnte nicht gespeichert werden: [_1]',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Sollen für die Benutzer Ihres Blogs neue Benutzerkonten angelegt werden, müssen Sie ein Passwort angeben.',
	'ok (ID [_1])' => 'OK (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{Kann vorhandenen Eintrag mit Zeitstempel &#8222;[_1]&#8220; nicht finden; überspringe Kommentare und fahre mit nächstem Eintrag fort...},
	q{Creating new category ('[_1]')...} => q{Lege neue Kategorie &#8222;[_1]&#8220; an...},
	q{Creating new user ('[_1]')...} => q{Lege neuen Benutzer &#8222;[_1]&#8220; an...},
	q{Export failed on entry '[_1]': [_2]} => q{Exportvorgang bei Eintrag &#8222;[_1]&#8220; fehlgeschlagen: [_2]},
	q{Importing into existing entry [_1] ('[_2]')} => q{Importiere in vorhandenen Eintrag [_1] (\&#8222;[_2]&#8220;)},
	q{Invalid allow pings value '[_1]'} => q{Ungültiger Ping-Status &#8222;[_1]&#8220;},
	q{Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)} => q{Ungültiges Datumsformat &#8222;[_1]&#8220;; muss &#8222;MM/TT/JJJJ HH:MM:SS AM|PM&#8220; sein (AM|PM optional)},
	q{Invalid status value '[_1]'} => q{Ungültiger Status-Wert &#8222;[_1]&#8220;},
	q{Saving entry ('[_1]')...} => q{Speichere Eintrag &#8222;[_1]&#8220;...},

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Aktion: Als Junk eingestuft (Bewertung unterschreitet Schwellenwert)',
	'Action: Published (default action)' => 'Aktion: Veröffentlicht (Standardaktion)',
	'Composite score: [_1]' => 'Gesamtbewertung: [_1]',
	'Junk Filter [_1] died with: [_2]' => 'Junk-Filter [_1] abgebrochen: [_2]',
	'Unnamed Junk Filter' => 'Namenloser Junk Filter',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'Konnte Listeneigenschaft [_1] nicht initialisieren.[_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Initialisierung der Listeneigenschaft [_1] fehlgeschlagen.[_2]: Keine Definition für Spalte [_3] gefunden.',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Initialisierung der Listeneigenschaft [_1] fehlgeschlagen.[_2]: Der Spaltentyp wird nicht unterstützt.',
	'[_1] (id:[_2])' => '[_1] (ID:[_2])',

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'IP-Adresse gesperrt',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IP-Adresse gesperrt. IP-Adresse: [_1], Benutzername: [_2]',
	'User Was Locked Out' => 'Benutzerkonto gesperrt',
	'User has been unlocked. Username: [_1]' => 'Benutzerkonto entsperrt. Benutzername: [_1]',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Benutzerkonto gesperrt. IP-Adresse: [_1], Benutzername: [_2]',

## lib/MT/Log.pm
	'By' => 'Von',
	'Class' => 'Typ',
	'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
	'Debug' => 'Debug',
	'Debug/error' => 'Debug/Fehler',
	'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
	'Information' => 'Information',
	'Level' => 'Stufe',
	'Log messages' => 'Protokolleinträge',
	'Logs on This Site' => 'Logs dieser Website',
	'Message' => 'Mitteilung',
	'Metadata' => 'Metadaten',
	'Not debug' => 'Kein Debug',
	'Notice' => 'Signifikanter Information',
	'Page # [_1] not found.' => 'Seite #[_1] nicht gefunden.',
	'Security or error' => 'Sicherheit oder Fehler',
	'Security' => 'Sicherheit',
	'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
	'Show only errors' => 'Nur Fehlermeldungen anzeigen',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',
	'TrackBacks' => 'TrackBacks',
	'Warning' => 'Warnung',
	'author' => 'Autor',
	'folder' => 'Ordner',
	'page' => 'Seite',
	'ping' => 'Ping',
	'plugin' => 'Plugin',
	'search' => 'suchen',
	'theme' => 'Thema',

## lib/MT/Mail.pm
	'Authentication failure: [_1]' => 'Fehler bei der Authentifizierung: [_1]',
	'Error connecting to SMTP server [_1]:[_2]' => 'Zum SMTP-Server [_1] konnte keine Verbindung aufgebaut werden: [_2]',
	'Exec of sendmail failed: [_1]' => 'Sendmail konnte nicht ausgeführt werden: [_1]',
	'Following required module(s) were not found: ([_1])' => 'Diese erforderlichen Module fehlen: ([_1])',
	'Username and password is required for SMTP authentication.' => 'Zur SMTP-Authentifizierung sind Benutzername und Passwort erforderlich.',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Kein gültiger Sendmail-Pfad gefunden. Versuchen Sie stattdessen SMTP zu verwenden.',
	q{Unknown MailTransfer method '[_1]'} => q{Unbekannte MailTransfer-Methode &#8222;[_1]&#8220;},

## lib/MT/Notification.pm
	'Cancel' => 'Abbrechen',
	'Click to edit contact' => 'Klicken, um Kontakt zu bearbeiten',
	'Contacts' => 'Kontakte',
	'Save Changes' => 'Änderungen speichern',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Asset-Platzierung',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Kategorie-Platzierung',
	'Category Placements' => 'Kategorie-Platzierungen',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Objektbewertung',
	'Object Scores' => 'Objektbewertungen',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Tag-Platzierung',
	'Tag Placements' => 'Tag-Platzierungen',

## lib/MT/Page.pm
	'(root)' => '(Wurzel)',
	'Draft Pages' => 'Seiten-Entwürfe',
	'Loading blog failed: [_1]' => 'Laden des Blogs fehlgeschlagen: [_1]',
	'My Pages' => 'Meine Seiten',
	'Pages in This Site' => 'Seiten in dieser Website',
	'Pages in folder: [_1]' => 'Seiten im Ordner [_1]',
	'Published Pages' => 'Veröffentlichte Seiten',
	'Scheduled Pages' => 'Zeitgeplante Seiten',
	'Unpublished Pages' => 'Unveröffentlichte Seiten',

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

## lib/MT/Plugin.pm
	'My Text Format' => 'Mein Textformat',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] aus Regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] aus Test [_4]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugin-Daten',

## lib/MT/RebuildTrigger.pm
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Stelle Neuaufbau-Auslöser für Inhaltstyp #[_1] wieder her...',
	'Restoring rebuild trigger for blog #[_1]...' => 'Stelle Neuaufbau-Auslöser für Blog #[_1] wieder her...',

## lib/MT/Revisable.pm
	'Did not get two [_1]' => 'Nicht zwei [_1] erhalten',
	'Revision Number' => 'Revisionsnummer',
	'Revision not found: [_1]' => 'Revision nicht gefunden: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Objektarten stimmen nicht überein, erwarte zwei [_1]',
	'Unknown method [_1]' => 'Unbekannte Methode [_1]',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{Fehlerhaftes RevisioningDriver-Parameter &#8222;[_1]&#8220;: [_2]},

## lib/MT/Role.pm
	'Can administer the site.' => 'Kann die Site verwalten.',
	'Can create entries, edit their own entries, and comment.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und kommentieren.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und Dateien hochladen und veröffentlichen.',
	'Can edit, manage, and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Can manage content types, content data and category sets.' => 'Kann Inhaltstyp, Inhaltsdaten und Kategorie-Set verwalten.',
	'Can manage pages, upload files and publish site/child site templates.' => 'Kann Seite verwalten, Dateien hochladen und Vorlagen von Sites und Untersites veröffentlichen.',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kann Dateien hochladen, alle Einträge, Seiten, Kategorien, Ordner und Tags bearbeiten und die Site veröffentlichen.',
	'Content Designer' => 'Content-Designer',
	'Contributor' => 'Gastautor',
	'Designer' => 'Designer',
	'Editor' => 'Editor',
	'Site Administrator' => 'Site-Administrator',
	'Webmaster' => 'Webmaster',
	'__ROLE_ACTIVE' => 'Aktiv',
	'__ROLE_INACTIVE' => 'Inaktiv',
	'__ROLE_STATUS' => 'Status',

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Bewertung für dieses Objekt bereits abgegeben.',
	'Object must be saved first.' => 'Objekt muss zuerst gespeichert werden.',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{Konnte Bewertung für Objekt &#8222;[_1]&#8220; (ID: [_2]) nicht speichern.},

## lib/MT/Session.pm
	'Session' => 'Sitzung',

## lib/MT/Tag.pm
	'Not Private' => 'Nicht privat',
	'Private' => 'Privat',
	'Tag must have a valid name' => 'Tags müssen gültige Namen haben',
	'Tags with Assets' => 'Tags mit Assets',
	'Tags with Entries' => 'Tags mit Einträgen',
	'Tags with Pages' => 'Tags mit Seiten',
	'This tag is referenced by others.' => 'Andere Tags verweisen auf dieses Tag.',

## lib/MT/TaskMgr.pm
	'Scheduled Tasks Update' => 'Aktualisierung geplanter Aufgaben',
	'The following tasks were run:' => 'Folgende Tasks wurden ausgeführt:',
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Konnte Lock zur Ausführung der Systemtasks nicht setzen. Stellen Sie sicher, daß das TempDir [_1] beschrieben werden kann.',
	q{Error during task '[_1]': [_2]} => q{Fehler bei Ausführung des Tasks &#8222;[_1]&#8220;: [_2]},

## lib/MT/Template.pm
	'Build Type' => 'Aufbau-Art',
	'Category Archive' => 'Kategoriearchiv',
	'Comment Error' => 'Kommentarfehler',
	'Comment Listing' => 'Liste der Kommentare',
	'Comment Pending' => 'Kommentar wartet',
	'Comment Preview' => 'Kommentarvorschau',
	'Content Type is required.' => 'Inhaltstyp erforderlich.',
	'Dynamicity' => 'Dynamik-Art',
	'Index' => 'Index',
	'Individual' => '', # Translate - New
	'Interval' => 'Intervall',
	'Module' => 'Modul',
	'Output File' => 'Ausgabedatei',
	'Ping Listing' => 'Liste der Pings',
	'Rebuild with Indexes' => 'Einschließlich Indizes neu aufbauen',
	'Template Text' => 'Vorlagentext',
	'Template load error: [_1]' => 'Fehler beim Laden der Vorlage: [_1]',
	'Template name must be unique within this [_1].' => 'Vorlagennamen dürfen innerhalb des/der [_1] nicht doppelt vorkommen.',
	'Template' => 'Vorlage',
	'Uploaded Image' => 'Hochgeladendes Bild',
	'Widget' => 'Widget',
	'You cannot use a [_1] extension for a linked file.' => 'Sie können keine [_1]-Erweiterung für eine verlinkte Datei verwenden.',
	q{Error reading file '[_1]': [_2]} => q{Fehler beim Einlesen der Datei &#8222;[_1]&#8220;: [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{Die verlinkte Datei &#8222;[_1]&#8220; konnte nicht geöffnet werden: [_2]},
	q{Publish error in template '[_1]': [_2]} => q{Veröffentlichungsfehler in Vorlage &#8222;[_1]&#8220;: [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{Das System hat versucht, die Vorlagendatei von außerhalb des Include-Pfads &#8222;[_1]&#8220; zu lesen},

## lib/MT/Template/Context.pm
	'No Category Set could be found.' => 'Kein Kategorie-Set gefunden.',
	'No Content Field could be found.' => 'Keine Inhaltsfelder gefunden.',
	'No Content Field could be found: "[_1]"' => '', # Translate - New
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wenn die gleichen Blog-ID gleichzeitig in den include_blogs- und exclude_blogs-Attributen eines mt:Entries-Befehls verwendet werden, werden die entsprechenden Blogs ausgeschlossen.',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{&#8222;[_1]&#8220; ist kein gültiger Wert für ein exclude_blogs-Attribut},
	q{You have an error in your '[_2]' attribute: [_1]} => q{Fehler im &#8222;[_2]&#8220;-Attribut: [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl in einem Blog ohne zugehörige Website verwendet - möglicherweise ist die Blog-Zuordnung fehlerhaft},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{Sie haben einen &#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Autoren-Kontexts verwendet - &#8222;MTAuthors&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Kommentar-Kontexts verwendet - &#8222;MTComments&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Inhalte-Kontexts verwendet - &#8222;MTContents&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Seiten-Kontexts verwendet - &#8222;MTPages&#8220;-Containers erforderlich},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Ping-Kontextes verwendet - &#8222;MTPings&#8220;-Container erforderlich.},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Asset-Kontexts verwendet - &#8222;MTAssets&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Eintrags-Kontexts verwendet - &#8222;MTEntries&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Blog-Kontexts verwendet - &#8222;MTBlogs&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of the site;} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb des Site-Kontexts verwendet;},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Website-Kontexts verwendet - &#8222;MTWebsite&#8220;-Container erforderlich},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => 'Buchstaben und Ziffern',
	', symbols (such as #!$%)' => 'Sonderzeichen (#!$% usw.)',
	', uppercase and lowercase letters' => 'Groß- und Kleinbuchstaben',
	'Actions' => 'Aktionen',
	'All About Me' => 'Alles über mich',
	'Cannot load template' => 'Kann Vorlage nicht laden',
	'Cannot load user.' => 'Kann Benutzerkonto nicht laden.',
	'Choose the display options for this content field in the listing screen.' => 'Wählen Sie, wie dieses Inhaltsfeld in der Listenansicht angezeigt werden soll',
	'Default' => 'Standardwert',
	'Display Options' => 'Anzeigeoptionen',
	'Division by zero.' => 'Teilung durch Null.',
	'Error in [_1] [_2]: [_3]' => 'Fehler in [_1] [_2]: [_3]',
	'Error in file template: [_1]' => 'Fehler in Dateivorlage: [_1]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'Das Einbinden von Dateien wurde über das Konfigurationsparameter AllowFileInclude deaktiviert.',
	'Force' => 'Erzwingen',
	'Invalid index.' => 'Index ungültig.',
	'Is this field required?' => 'Ist dieses Feld erforderlich?',
	'No [_1] could be found.' => 'Keine [_1] gefunden.',
	'No template to include was specified' => 'Keine einzubindende Vorlage angegeben',
	'Optional' => 'Optional',
	'Recursion attempt on [_1]: [_2]' => 'Rekursionsversuch bei [_1]: [_2]',
	'Recursion attempt on file: [_1]' => 'Rekursionsversuch bei Datei [_1]',
	'The entered message is displayed as a input field hint.' => 'Dieser Text wird als Hinweis für das Eingabefeld angezeigt.',
	'Unspecified archive template' => 'Nicht spezifizierte Archiv-Vorlage',
	'You used a [_1] tag without a valid name attribute.' => 'Sie haben einen &#8222;[_1]&#8220;-Befehl ohne gültiges Namensattribut verwendet.',
	'You used an [_1] tag without a date context set up.' => 'Sie haben einen [_1]-Vorlagenbefehl ohne Datumskontext verwendet.',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]-Befehl ohne gültiges [_2]-Attribut verwendet.',
	'[_1] [_2]' => '[_1] [_2]',
	'[_1] is not a hash.' => '[_1] ist kein Hash-Wert.',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Veröffentlichen[_2] Sie Ihre(n) [_3], um die Änderungen wirksam werden zu lassen.',
	'[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.' => '', # Translate - New
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Veröffentlichen[_2] Sie Ihre Site, um die Änderungen wirksam werden zu lassen.',
	'blog(s)' => 'Blog(s)',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'id attribute is required' => 'Attribut "id" erforderlich.',
	'minimum length of [_1]' => 'Mindestlänge [_1] Zeichen',
	'records' => 'Einträge',
	'website(s)' => 'Website(s)',
	q{'[_1]' is not a hash.} => q{&#8222;[_1]&#8220; ist kein Hash.},
	q{'[_1]' is not a valid function for a hash.} => q{&#8222;[_1]&#8220; ist keine gültige Hash-Funktion.},
	q{'[_1]' is not a valid function for an array.} => q{&#8222;[_1]&#8220; ist keine gültige Array-Funktion.},
	q{'[_1]' is not a valid function.} => q{&#8222;[_1]&#8220; ist keine gültige Funktion.},
	q{'[_1]' is not an array.} => q{&#8222;[_1]&#8220; ist kein Array.},
	q{'parent' modifier cannot be used with '[_1]'} => q{Die Option &#8222;parent&#8220; kann nicht zusammen mit &#8222;[_1]&#8220; verwendet werden.},
	q{Cannot find blog for id '[_1]} => q{Kann Blog zu ID &#8222;[_1]&#8220; nicht finden},
	q{Cannot find entry '[_1]'} => q{Kann Eintrag &#8222;[_1]&#8220; nicht finden},
	q{Cannot find included file '[_1]'} => q{Kann verwendete Datei &#8222;[_1]&#8220; nicht finden},
	q{Cannot find included template [_1] '[_2]'} => q{Kann verwendete Vorlage [_1] &#8222;[_1]&#8220; nicht finden},
	q{Cannot find template '[_1]'} => q{Kann Vorlage &#8222;[_1]&#8220; nicht finden},
	q{Error opening included file '[_1]': [_2]} => q{Fehler beim Öffnen der verwendeten Datei &#8222;[_1]&#8220;: [_2]},

## lib/MT/Template/Tags/Archive.pm
	'Could not determine content' => 'Konnte Inhalt nicht bestimmen',
	'Could not determine entry' => 'Konnte Eintrag nicht bestimmen',
	'Group iterator failed.' => 'Gruppeniterator fehlgeschlagen.',
	'You used an [_1] tag outside of the proper context.' => 'Sie haben einen [_1]-Vorlagenbefehl außerhalb seines Kontexts verwendet.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kann nur mit Tages-, Wochen- oder Monatsarchiven verwendet werden.',
	q{You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.} => q{Sie haben mit einem [_1]-Vorlagenbefehl &#8222;[_2]&#8220;-Archivseiten verlinkt, ohne diese bereits angelegt zu haben.},

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'Sort_by="score" erfordert einen Namespace.',
	q{No such user '[_1]'} => q{Kein Benutzer &#8222;[_1]&#8220;},

## lib/MT/Template/Tags/Author.pm
	'You used an [_1] without a author context set up.' => '[_1] ohne vorhandenen Autorenkontext verwendet.',
	q{The '[_2]' attribute will only accept an integer: [_1]} => q{Das Attribut &#8222;[_2]&#8220; erfordert einen Integer: [_1]},

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Ungültiges "mode"-Attribut [_1]. Gültige Werte sind "loop" und "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: JJJJMM erforderlich',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'week_starts_with in ungültigem Format angegeben. Verwenden Sie einen dieser Ausdrücke: Mon|Tue|Wed|Thu|Fri|Sat|Sun',
	q{No such category '[_1]'} => q{Keine Kategorie &#8222;[_1]&#8220;},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
	'Cannot use sort_by and sort_method together in [_1]' => '"sorty_by" und "sort_method" können nicht gemeinsam in [_1] verwendet werden.',
	'Error sorting [_2]: [_1]' => 'Fehler beim Sortieren von [_2]: [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] muss in einem [_2]-Kontext stehen',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] kann nur zusammen mit veröffentlichem [_2]-Archiv verwendet werden.',
	'[_1] used outside of [_2]' => '[_1] außerhalb [_2] verwendet',

## lib/MT/Template/Tags/ContentType.pm
	'Content Type was not found. Blog ID: [_1]' => 'Inhaltstyp nicht gefunden. Blog-ID: [_1]',
	'Invalid field_value_handler of [_1].' => 'field_value_handler von [_1] ungültig.',
	'Invalid tag_handler of [_1].' => 'tag_handler von [_1] ungültig.',
	'No Content Field Type could be found.' => 'Keine Felder für Inhaltstypen gefunden.',

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => 'Konnte keine Atom-ID für Eintrag [_1] erzeugen',
	'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',

## lib/MT/Template/Tags/Misc.pm
	q{Specified WidgetSet '[_1]' not found.} => q{Angegebene Widgetgruppe &#8222;[_1]&#8220; nicht gefunden.},

## lib/MT/Template/Tags/Tag.pm
	'content_type modifier cannot be used with type "[_1]".' => 'Das Attribut content_type kann nicht mit Typ "[_1]" verwendet werden.',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Archiv-Verknüpfung',
	'Archive Mappings' => 'Archiv-Verknüpfungen',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Job-Fehler',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Job-Zielstatus',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Job-Funktion',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Job',

## lib/MT/Theme.pm
	'A fatal error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein kritischer Fehler aufgetreten: [_2]',
	'An error occurred while applying element [_1]: [_2].' => 'Bei der Anwendung des Elements [_1] ist ein Fehler aufgetreten: [_2]',
	'Default Content Data' => 'Ursprungs-Inhaltsdaten',
	'Default Pages' => 'Standard-Seiten',
	'Default Prefs' => 'Standard-Voreinstellungen',
	'Failed to copy file [_1]:[_2]' => 'Kopieren der Datei [_1] fehlgeschlagen: [_2]',
	'Failed to load theme [_1].' => 'Laden des Themas fehlgeschlagen: [_1]',
	'Static Files' => 'Statische Dateien',
	'Template Set' => 'Vorlagengruppe',
	'There was an error converting image [_1].' => 'Bei der Konvertierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	'There was an error creating thumbnail file [_1].' => 'Bei der Erstellung des Vorschaubildes [_1] ist ein Fehler aufgetreten.',
	'There was an error scaling image [_1].' => 'Bei der Skalierung der Bilddatei [_1] ist ein Fehler aufgetreten.',
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but is not installed.} => q{Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, aber nicht installiert. },
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but the installed version is [_3].} => q{Zur Nutzung dieses Themas ist [_1] in Version [_2] oder neuer erforderlich, installiert ist aber Version [_3].},
	q{Element '[_1]' cannot be applied because [_2]} => q{Element &#8222;[_1]&#8220; konnte nicht angewendet werden da [_2]},

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
	'Internal error: the importer is not found.' => 'Interner Fehler: Importmodul nicht gefunden.',
	q{An Error occurred while applying '[_1]': [_2].} => q{Bei der Anwendung von '[_1]' ist ein Fehler aufgetreten: [_2]},
	q{Compatibility error occurred while applying '[_1]': [_2].} => q{Bei der Anwendung von '[_1]' ist ein Kompatibilitäts-Fehler aufgetreten: [_2]},
	q{Component '[_1]' is not found.} => q{Komponente &#8222;[_1]&#8220; nicht gefunden.},
	q{Fatal error occurred while applying '[_1]': [_2].} => q{Bei der Anwendung von '[_1]' ist ein kritischer Fehler aufgetreten: [_2]},
	q{Importer for '[_1]' is too old.} => q{Das Importmodul für &#8222;[_1]&#8220; ist zu alt.},
	q{Theme element '[_1]' is too old for this environment.} => q{Das Element &#8222;[_1]&#8220; des verwendeten Themas ist veraltet und kann hier nicht eingesetzt werden.},

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] Seiten',

## lib/MT/Theme/Pref.pm
	'Failed to save blog object: [_1]' => 'Konnte Blog-Objekt nicht speichern: [_1]',
	'default settings for [_1]' => 'Standard-Einstellungen für [_1]',
	'default settings' => 'Standard-Einstellungen',
	'this element cannot apply for non blog object.' => 'Dieses Element kann nicht auf Nicht-Blog-Elemente angewendet werden.',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Vorlagengruppe mit [quant,_1,Vorlage,Vorlagen], [quant,_2,Widget,Widgets] und [quant,_3,Widget-Gruppe, Widget-Gruppen].',
	'Failed to make templates directory: [_1]' => 'Fehler bei Erstellung des Vorlagen-Verzeichnisses: [_1]',
	'Failed to publish template file: [_1]' => 'Fehler bei Veröffentlichung der Vorlagen-Dateien: [_1]',
	'Widget Sets' => 'Widgetgruppen',
	'exported_template set' => 'exported_template-Gruppe',

## lib/MT/Upgrade.pm
	'Database has been upgraded to version [_1].' => 'Datenbank auf Movable Type-Version [_1] aktualisiert',
	'Error loading class [_1].' => 'Fehler beim Laden der Klasse [_1].',
	'Error loading class: [_1].' => 'Fehler beim Laden einer Klasse: [_1]',
	'Error saving [_1] record # [_3]: [_2]...' => 'Fehler beim Speichern von [_1]-Eintrag #[_3]: [_2]...',
	'Invalid upgrade function: [_1].' => 'Ungültige Upgrade-Funktion: [_1].',
	'Upgrading database from version [_1].' => 'Aktualisiere Datenbank von Version [_1].',
	'Upgrading table for [_1] records...' => 'Aktualisiere Tabelle für [_1]-Einträge...',
	q{Plugin '[_1]' installed successfully.} => q{Plugin &#8222;[_1]&#8220; erfolgreich installiert},
	q{Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).} => q{Plugin &#8222;[_1]&#8220; erfolgreich auf Version [_2] (Schemaversion [_3]) aktualisiert},
	q{User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).} => q{Benutzer &#8222;[_1]&#8220; hat Plugin &#8222;[_2]&#8220; mit Version [_3] (Schemaversion [_4]) installiert},
	q{User '[_1]' upgraded database to version [_2]} => q{Benutzer &#8222;[_1]&#8220; hat Datenbank auf Version [_2] aktualisiert},
	q{User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).} => q{Benutzer &#8222;[_1]&#8220; hat Plugin &#8222;[_2]&#8220; erfolgreich auf Version [_3] (Schemaversion [_4]) aktualisiert},

## lib/MT/Upgrade/Core.pm
	'Assigning category parent fields...' => 'Weise Elternkategorien zu...',
	'Assigning custom dynamic template settings...' => 'Weise benutzerspezifische Einstellungen für dynamische Vorlagen zu...',
	'Assigning template build dynamic settings...' => 'Weise Einstellungen für dynamische Veröffentlichung zu...',
	'Assigning user types...' => 'Weise Benutzerkontenarten zu...',
	'Assigning visible status for TrackBacks...' => 'Setzte Sichtbarkeitsstatus für TrackBacks...',
	'Assigning visible status for comments...' => 'Setzte Sichtbarkeitsstatus für Kommentare...',
	'Creating initial user records...' => 'Lege Ausgangs-Benutzerdatensätze an...',
	'Error creating role record: [_1].' => 'Fehler bei der Erstellung eine Rollen-Eintrags: [_1]. ',
	'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
	'Expiring cached MT News widget...' => 'Verwerfe gecachte MT-News-Widgets...',
	'Mapping templates to blog archive types...' => 'Verknüpfe Vorlagen mit Archiv...',
	'Upgrading asset path information...' => 'Aktualisiere Pfadangaben von Assets...',
	q{Creating new template: '[_1]'.} => q{Erzeuge neue Vorlage: &#8222;[_1]&#8220;},

## lib/MT/Upgrade/v1.pm
	'Creating entry category placements...' => 'Lege Kategoriezuweisungen an...',
	'Creating template maps...' => 'Verknüpfe Vorlagen...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Verknüpfe Vorlage [_1] mit [_2] ([_3])',
	'Mapping template ID [_1] to [_2].' => 'Verknüpfe Vorlage [_1] mit [_2]',

## lib/MT/Upgrade/v2.pm
	'Assigning comment/moderation settings...' => 'Weise Kommentierungs-/Moderierungs-Einstellungen zu...',
	'Updating category placements...' => 'Aktualisiere Kategoriezuweisungen...',

## lib/MT/Upgrade/v3.pm
	'Assigning basename for categories...' => 'Weise Kategorien Basisnamen zu...',
	'Assigning blog administration permissions...' => 'Weise Administrationsrechte zu...',
	'Assigning entry basenames for old entries...' => 'Weise Alteinträgen Basisnamen zu...',
	'Assigning user status...' => 'Weise Benuzerstatus zu...',
	'Creating configuration record.' => 'Erzeuge Konfigurationseintrag...',
	'Custom ([_1])' => 'Individuell ([_1])',
	'Migrating any "tag" categories to new tags...' => 'Migriere "Tag"-Kategorien zu neuen Tags...',
	'Migrating permissions to roles...' => 'Migriere Berechtigung auf Rollen...',
	'Removing Dynamic Site Bootstrapper index template...' => 'Entferne Indexvorlage des Dynamic Site Bootstrappers...',
	'Setting blog allow pings status...' => 'Weise Ping-Status zu...',
	'Setting blog basename limits...' => 'Setze Basisnamen-Limits...',
	'Setting default blog file extension...' => 'Setze Standard-Dateierweitung...',
	'Setting new entry defaults for blogs...' => 'Setze Standardwerte für neue Einträge...',
	'Setting your permissions to administrator.' => 'Setze Ihre Administrationsrechte...',
	'This role was generated by Movable Type upon upgrade.' => 'Diese Rolle wurde von Movable Type während einer Aktualisierung angelegt.',
	'Updating blog comment email requirements...' => 'Aktualisiere E-Mail-Einstellungen der Kommentarfunktion...',
	'Updating blog old archive link status...' => 'Aktualisiere Linkstatus der Alteinträge...',
	'Updating comment status flags...' => 'Aktualisiere Kommentarstatus...',
	'Updating commenter records...' => 'Aktualisiere Kommentarautoren-Datensätze...',
	'Updating entry week numbers...' => 'Aktualisiere Wochendaten...',
	'Updating user permissions for editing tags...' => 'Weise Nutzerrechte für Tag-Verwaltung zu...',
	'Updating user web services passwords...' => 'Aktualisierte Passwörter für Webdienste...',

## lib/MT/Upgrade/v4.pm
	'Adding new feature widget to dashboard...' => 'Füge "Neue Features"-Widget zum Übersichtsseite hinzu...',
	'Assigning author basename...' => 'Weise Autoren-Basisnamen zu...',
	'Assigning blog page layout...' => 'Weise Blog-Seitenlayout zu...',
	'Assigning blog template set...' => 'Weise Vorlagengruppe zu...',
	'Assigning embedded flag to asset placements...' => 'Weise Embedded-Flag an Asset-Platzierungen zu...',
	'Assigning entry comment and TrackBack counts...' => 'Weise Kommentar- und TrackBack-Zahlen zu...',
	'Assigning junk status for TrackBacks...' => 'Setze Junkstatus der TrackBacks...',
	'Assigning junk status for comments...' => 'Setze Junkstatus der Kommentare...',
	'Assigning user authentication type...' => 'Weise Art der Benutzerauthentifizierung zu...',
	'Cannot rename in [_1]: [_2].' => 'Kann nicht in [_1] umbenennen: [_2]',
	'Classifying category records...' => 'Klassifiziere Kategoriedaten...',
	'Classifying entry records...' => 'Klassifizere Eintragsdaten...',
	'Comment Posted' => 'Kommentar veröffentlicht',
	'Comment Response' => 'Kommentar-Antworten',
	'Comment Submission Error' => 'Beim Abschicken des Kommentars ist ein Fehler aufgetreten',
	'Confirmation...' => 'Bestätigung',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fehler beim Umbenennen von PHP-Datei. Bitte überprüfen Sie das Aktivitätsprotokoll.',
	'Merging comment system templates...' => 'Führe Kommentierungsvorlagen zusammen...',
	'Migrating Nofollow plugin settings...' => 'Migriere Nofollow-Einstellungen...',
	'Migrating permission records to new structure...' => 'Migriere Benutzerrechte in neue Struktur...',
	'Migrating role records to new structure...' => 'Migriere Rollen in neue Struktur...',
	'Migrating system level permissions to new structure...' => 'Migriere Systemberechtigungen in neue Struktur...',
	'Moving OpenID usernames to external_id fields...' => 'Setze OpenID-Benutzernamen als external_id-Felder...',
	'Moving metadata storage for categories...' => 'Verschiebe Metadatenspeicher für Kategorien...',
	'Populating authored and published dates for entries...' => 'Übernehme Zeitstempel für Einträge...',
	'Populating default file template for templatemaps...' => 'Lege Standardvorlagen für Vorlagenzuweisungen fest...',
	'Removing unnecessary indexes...' => 'Entferne nicht verwendete Indizes...',
	'Removing unused template maps...' => 'Entferne nicht benötigte Vorlagenzuweisungen',
	'Renaming PHP plugin file names...' => 'Ändere PHP-Plugin-Dateinamen...',
	'Replacing file formats to use CategoryLabel tag...' => 'Ersetze Dateiformate für CategoryLabel-Befehl...',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">Zurück zum Eintrag</a>',
	'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar.',
	'Updating password recover email template...' => 'Aktualisierung des Passwort-Wiederherstellungs-Templates...',
	'Updating system search template records...' => 'Aktualisiere Suchvorlagen...',
	'Updating template build types...' => 'Aktualisiere Vorlagenaufbauarten...',
	'Updating widget template records...' => 'Aktualisiere Widgetvorlagen...',
	'Upgrading metadata storage for [_1]' => 'Aktualisiere Metadatenspeicher für [_1]',
	'Your comment has been posted!' => 'Ihr Kommentar wurde veröffentlicht!',
	'Your comment has been received and held for review by a blog administrator.' => 'Ihr Kommentar wurde abgeschickt. Er erscheint, sobald der Administrator des Blogs ihn freigeschaltet hat.',
	'Your comment submission failed for the following reasons:' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden:',
	'[_1]: [_2]' => '[_1]: [_2]',

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => 'Füge Benachrichtungs-Widget zu Dashboard hinzu...',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Beim Anlegen einer Website während des Upgrades ist ein Fehler aufgetreten: [_1]',
	'Assigning ID of author for entries...' => 'Weise Autoren-IDs zu Eintragen zu...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Setze Sprache für alle Blogs zur Verbesserung der Datumsanzeige...',
	'Assigning new system privilege for system administrator...' => 'Weise neues System-Privileg an Systemadministrator zu...',
	'Assigning to  [_1]...' => 'Weise an [_1] zu...',
	'Can administer the website.' => 'Kann die Website verwalten',
	'Can edit, manage and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Can manage pages, Upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Classifying blogs...' => 'Klassifiziere Blogs...',
	'Designer (MT4)' => 'Designer (MT4)',
	'Error loading role: [_1].' => 'Fehler beim Laden einer Rolle: [_1]',
	'Generated a website [_1]' => 'Website [_1] angelegt',
	'Generic Website' => 'Generische Website',
	'Granting new role to system administrator...' => 'Weise Systemadministrator neue Rolle zu...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migriere DefaultSiteURL/DefaultSiteRoot zur Website...',
	'Migrating [_1]([_2]).' => 'Migriere [_1] ([_2]).',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migriere vorhandene [quant,_1,Blog,Blogs] in Websites und Kinder...',
	'Migrating mtview.php to MT5 style...' => 'Migriere mtview.php zur MT5-Fassung...',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Blog [_1] ([_2]) in Website [_3] verschoben',
	'New WebSite [_1]' => 'Neue Website [_1]',
	'Ordering Categories and Folders of Blogs...' => 'Sortiere Ordner und Kategorien der Blogs...',
	'Ordering Folders of Websites...' => 'Sortiere Ordner der Websites...',
	'Populating generic website for current blogs...' => 'Populiere generische Website für aktuelles Blog...',
	'Populating new role for theme...' => 'Populiere neue Rolle für Thema...',
	'Populating new role for website...' => 'Populiere neue Rolle für Website...',
	'Rebuilding permissions...' => 'Baue Berechtigungen neu auf...',
	'Recovering type of author...' => 'Stelle Autorentypen wieder her...',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Entferne Technorati-Ping-Dienst von [_1] (ID: [_2]).',
	'Removing widget from dashboard...' => 'Entferne Widget aus Übersichtsseite...',
	'Updating existing role name...' => 'Aktualisiere vorhandene Rollennamen...',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Website Administrator' => 'Website-Administrator',
	'_WEBMASTER_MT4' => 'Webmaster',
	q{An error occurred during migrating a blog's site_url: [_1]} => q{Beim Migrieren der site_url eines Blogs ist ein Fehler aufgetreten: [_1]},
	q{New user's website} => q{Website neuer Benutzer},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{Setze 'created by'-ID für Benutzerkonten ohne diese Angabe...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => 'Füge Site-Statistik-Widget hinzu...',
	'Adding Website Administrator role...' => 'Füge Website-Administratoren-Rolle hinzu...',
	'Fixing TheSchwartz::Error table...' => 'Repariere TheSchwartz::Error-Tabelle...',
	'Migrating current blog to a website...' => 'Migriere aktuelles Blog auf Website...',
	'Migrating the record for recently accessed blogs...' => 'Migriere Aufzeichnung der kürzlich aufgerufenen Blogs....',
	'Rebuilding permission records...' => 'Baue Berechtigungs-Datensätze neu auf...',
	'Reordering dashboard widgets...' => 'Ordne Dashboard-Widgets neu an...',

## lib/MT/Upgrade/v7.pm
	'Adding site list dashboard widget for mobile...' => 'Füge Site-Listen-Widget zum Dashboard hin...',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Weise Website mit Blogs verwalten eine Site-Administrator-Rolle zu...',
	'Assign a Site Administrator Role for Manage Website...' => 'Weise Website verwalten eine Site-Administrator-Rolle zu...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Ändere die Rolle Untersite-Administrator in Site-Administrator...',
	'Child Site Administrator' => 'Untersite-Administrator',
	'Cleaning up content field indexes...' => 'Räume Inhaltsfeld-Indizes auf...',
	'Cleaning up objectasset records for content data...' => 'Räume objectasset-Datensätze von Inhaltsdaten auf...',
	'Cleaning up objectcategory records for content data...' => 'Räume objectcategory-Datensätze von Inhaltsdaten auf...',
	'Cleaning up objecttag records for content data...' => 'Räume objecttag-Datensätze von Inhaltsdaten auf...',
	'Create a new role for creating a child site...' => 'Lege neue Berechtigung zum Anlegen von Untersites an...',
	'Create new role: [_1]...' => 'Lege neue Rolle [_1] an...',
	'Error removing record (ID:[_1]): [_2].' => 'Fehler beim Entfernen eines Datensatzes (ID:[_1]): [_2]',
	'Error removing records: [_1]' => 'Fehler beim Entfernen von Datensätzen: [_1]',
	'Error saving record (ID:[_1]): [_2].' => 'Fehler beim Speichern eines Datensatzes (ID:[_1]): [_2]',
	'Error saving record: [_1]' => 'Fehler beim Speichern eines Datensatzes: [_1]',
	'Migrating Max Length option of Single Line Text fields...' => 'Migriere Längenoption für einzeiligen Textfelder...',
	'Migrating MultiBlog settings...' => 'Migriere MultiBlog-Einstellungen...',
	'Migrating create child site permissions...' => 'Migriere Untersite-Berechtigungen...',
	'Migrating data column of MT::ContentData...' => 'Migriere Spalte "data" von MT::ContentData...',
	'Migrating fields column of MT::ContentType...' => 'Migriere Spalte "fields" von MT::ContentType....',
	'MultiBlog migration for site(ID:[_1]) is skipped due to the data breakage.' => '', # Translate - New
	'MultiBlog migration is skipped due to the data breakage.' => '', # Translate - New
	'Rebuilding Content Type count of Category Sets...' => 'Baue Inhaltstypen-Zähler in Kategorie-Sets neu auf...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Baue MT::ContentFieldIndex von embedded_text-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Baue MT::ContentFieldIndex von multi_line_text-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Baue MT::ContentFieldIndex von Zahlenfeld neu auf...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Baue MT::ContentFieldIndex von single-line-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Baue MT::ContentFieldIndex von tables-Feld neu auf...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Baue MT::ContentFieldIndex von url-Feld neu auf...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Baue MT::Permission-Datensätze neu auf (entferne edit_categories)...',
	'Rebuilding content field permissions...' => 'Baue Inhaltsfelder-Berechtigungen neu auf...',
	'Rebuilding object assets...' => 'Baue Objekt-Assets neu auf...',
	'Rebuilding object categories...' => 'Baue Objekt-Kategorien neu auf ...',
	'Rebuilding object tags...' => 'Baue Objekt-Tags neu auf...',
	'Remove SQLSetNames...' => '', # Translate - New
	'Reorder DEBUG level' => '', # Translate - New
	'Reorder SECURITY level' => '', # Translate - New
	'Reorder WARNING level' => '', # Translate - New
	'Reset default dashboard widgets...' => 'Setze Standard-Dashboard-Widgets zurück...',
	'Some MultiBlog migrations for site(ID:[_1]) are skipped due to the data breakage.' => '', # Translate - New
	'Truncating values of value_varchar column...' => 'Kürze value_varchar-Spalte...',
	'add administer_site permission for Blog Administrator...' => 'Weise Blog-Administrator administer-site-Berechtigung zu...',
	'change [_1] to [_2]' => 'ändere [_1] in [_2]',

## lib/MT/Util.pm
	'[quant,_1,day,days] from now' => 'in [quant,_1,Tag,Tagen]',
	'[quant,_1,day,days]' => '[quant,_1,Tag,Tage]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'vor [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'in [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,Tag,Tage] und [quant,_2,Stunde,Stunden]',
	'[quant,_1,hour,hours] from now' => 'in [quant,_1,Stunde,Stunden]',
	'[quant,_1,hour,hours]' => '[quant,_1,Stunde,Stunden]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'vor [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'in [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,Stunde,Stunden] und [quant,_2,Minute,Minuten]',
	'[quant,_1,minute,minutes] from now' => 'in [quant,_1,Minute,Minuten]',
	'[quant,_1,minute,minutes]' => '[quant,_1,Minute,Minuten]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'in [quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
	'[quant,_1,second,seconds] from now' => 'in [quant,_1,Sekunde,Sekunden]',
	'[quant,_1,second,seconds]' => '[quant,_1,Sekunde,Sekunden]',
	'less than 1 minute ago' => 'vor weniger als 1 Minute',
	'less than 1 minute from now' => 'in weniger als 1 Minute',
	'moments from now' => 'in einem Augenblick',
	q{Invalid domain: '[_1]'} => q{Ungültige Domain: &#8222;[_1]&#8220;},

## lib/MT/Util/Archive.pm
	'Registry could not be loaded' => 'Konnte Registry nicht laden',
	'Type must be specified' => 'Typangabe erforderlich',

## lib/MT/Util/Archive/BinTgz.pm
	'Both data and file name must be specified.' => 'Sowohl der Daten- als auch der Dateiname müssen angegeben werden.',
	'Cannot extract from the object' => 'Kann aus Objekt nicht extrahieren',
	'Cannot find external archiver: [_1]' => '', # Translate - New
	'Cannot write to the object' => 'Kann Objekt nicht beschreiben',
	'Failed to create an archive [_1]: [_2]' => '', # Translate - New
	'File [_1] exists; could not overwrite.' => '[_1] existiert bereits und konnte nicht überschrieben werden',
	'Type must be tgz.' => 'Typ muss .tgz sein.',
	'[_1] in the archive contains ..' => '[_1] im Archiv enthält ...',
	'[_1] in the archive is an absolute path' => '[_1] im Archiv ist ein absoluter Pfad',
	'[_1] in the archive is not a regular file' => '[_1] im Archiv ist keine reguläre Datei',

## lib/MT/Util/Archive/BinZip.pm
	'Failed to rename an archive [_1]: [_2]' => '', # Translate - New
	'Type must be zip' => 'Typ muss .zip sein.',

## lib/MT/Util/Archive/Tgz.pm
	'Could not read from filehandle.' => 'Dateihandle nicht lesbar.',
	'File [_1] is not a tgz file.' => '[_1] ist keine .tgz-Datei',

## lib/MT/Util/Archive/Zip.pm
	'File [_1] is not a zip file.' => '[_1] ist keine .zip-Datei',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Image creation failed.' => 'Bilderzeugung fehlgeschlagen.',
	'Image error: [_1]' => 'Bildfehler: [_1]',
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Zur Nutzung der in Movable Type integrierten CAPTCHA-Quelle ist Image::Magick erforderlich.',
	'Type the characters you see in the picture above.' => 'Geben Sie die Zeichen ein, die Sie im obigen Bild sehen.',
	'You need to configure CaptchaSourceImageBase.' => 'Bitte konfigurieren Sie CaptchaSourceImageBase',

## lib/MT/Util/Log.pm
	'Cannot load Log module: [_1]' => 'Konnte Log-Modul nicht laden: [_1]',
	'Logger configuration for Log module [_1] seems problematic' => '', # Translate - New
	'Unknown Logger Level: [_1]' => 'Unbekannter Logger-Level: [_1]',

## lib/MT/Util/YAML.pm
	'Cannot load YAML module: [_1]' => 'Konnte YAML-Modul nicht laden: [_1]',
	'Invalid YAML module' => 'Ungültiges YAML-Modul',

## lib/MT/WeblogPublisher.pm
	'An error occurred while publishing scheduled entries: [_1]' => 'Fehler bei der Veröffentlichung zeitgeplanter Einträge: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Fehler beim Zurückziehen älterer Einträge: [_1]',
	'Blog, BlogID or Template param must be specified.' => 'Blog-, BlogID- oder Template-Parameter erforderlich.',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Diese Archivdatei existiert bereits. Ändern Sie entweder den Basisnamen oder den Archivpfad. ([_1])',
	'unpublish' => 'Nicht mehr veröffentlichen',
	q{Template '[_1]' does not have an Output File.} => q{Vorlage &#8222;[_1]&#8220; hat keine Ausgabedatei.},

## lib/MT/Website.pm
	'Child Site Count' => 'Anzahl Untersites',
	'First Website' => 'Erste Website',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- Gruppe komplett ([quant,_1,Datei,Dateien] in [_2] Sekunden)',
	'Background Publishing Done' => 'Veröffentlichung im Hintergrund abgeschlossen',
	'Error rebuilding file [_1]:[_2]' => 'Fehler beim Neuaufbau der Datei [_1]: [_2]',
	'Published: [_1]' => 'Veröffentlicht: [_1]',

## lib/MT/Worker/Sync.pm
	'Done Synchronizing Files' => 'Datei-Sychronisierung abgeschlossen',
	'Done syncing files to [_1] ([_2])' => 'Die Dateien wurden mit [_1] ([_2]) synchronisiert',
	qq{Error during rsync of files in [_1]:\n} => qq{Fehler beim rsyncen der Dateien in [_1]:},

## lib/MT/XMLRPCServer.pm
	'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
	'Invalid login' => 'Ungültiges Login',
	'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
	'No blog_id' => 'Blog_id fehlt',
	'No entry_id' => 'Keine entry_id',
	'No filename provided' => 'Kein Dateiname angegeben',
	'No web services password assigned.  Please see your user profile to set it.' => 'Kein Passwort für Webdienste vergeben. Sie können das Passwort in Ihrem Benutzerprofil angegeben.',
	'Not allowed to edit entry' => 'Darf Eintrag nicht ändern',
	'Not allowed to get entry' => 'Darf Eintrag nicht lesen',
	'Not allowed to set entry categories' => 'Darf Kategorien nicht zuweisen',
	'Not allowed to upload files' => 'Darf Dateien nicht hochladen',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Zur Bestimmung von Höhe und Breite hochgeladener Bilddateien ist das Perl-Modul Image::Size erforderlich.',
	'Publishing failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Saving folder failed: [_1]' => 'Speichern des Ordners fehlgeschlagen: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Funktionen zum Zugriff auf Vorlagen sind auf Grund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{Eintrag &#8222;[_1]&#8220; ([_5] #[_2]) von &#8222;[_3]&#8220; (Benutzer-Nr. [_4]) per XML-RPC gelöscht},
	q{Invalid entry ID '[_1]'} => q{Ungültige Eintrags-ID '[_1]'},
	q{Requested permalink '[_1]' is not available for this page} => q{Der gewünschte Permalink &#8222;[_1]&#8220; ist für diese Seite nicht verfügbar.},
	q{Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')} => q{&#8222;mt_[_1]&#8220; kann nur 0 oder 1 sein (war &#8222;[_2]&#8220;)},

## mt-check.cgi
	'(Probably) running under cgiwrap or suexec' => '(Wahrscheinlich) ausgeführt unter cgiwrap oder suexec',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar ist für Dateioperationen beim Erstellen und Einspielen von Backups erforderlich.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip ist für Dateioperationen beim Erstellen und Einspielen von Backups erforderlich.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie ist zur Nutzung der Cookie-Authentifizierung erforderlich.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File ist erforderlich, wenn sich Kommentarautoren über eine OpenID bei Yahoo! Japan authentifizieren können sollen.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached und ein auf dem Movable-Type-Server laufender memcached-Server sind zur Zwischenspeicherung von Objekten im Arbeitsspeicher erforderlich.',
	'Checking for' => 'Überprüfe',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Die Installation von Crypt::DSA ist optional. Dieses Modul beschleunigt den Anmeldevorgang für Kommentarautoren.',
	'Current working directory:' => 'Aktuelles Arbeitsverzeichnis:',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI und DBD::Pg sind zur Nutzung von Movable Type mit einer PostgreSQL-Datenbank erforderlich.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI und DBD::SQLite sind zur Nutzung von Movable Type mit einer SQLite-Datenbank erforderlich.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI und DBD::SQLite2 sind zur Nutzung von Movable Type mit einer SQLite 2.x-Datenbank erforderlich.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI und DBD::mysql sind zur Nutzung von Movable Type mit einer MySQL-Datenbank erforderlich.',
	'DBI is required to store data in database.' => 'DBI ist zur Nutzung von Datenbanken erforderlich.',
	'Data Storage' => 'Datenbank',
	'Details' => 'Details',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 und seine Abhängigkeiten sind zur Authentifizierung mittels OpenID (einschließlich LiveJournal) erforderlich.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'Die Installation von File::Temp ist optional. Dieses Modul ist erforderlich, wenn Sie beim Hochladen von Dateien vorhandene Dateien überschreiben können möchten.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip ist zum Packen von Backup-Dateien erforderlich.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gzip ist zum Entpacken von Backup-Dateien erforderlich.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'Die Installation von IPC::Run ist optional. Es ist erforderlich, wenn Sie NetPBM zur Erzeugung von Vorschaubildern verwenden möchten.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size ist zum Hochladen von Dateien erforderlich (um die Größe hochgeladener Bilder bestimmen zu können)',
	'Installed' => 'Installiert',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 ist zur Registrierung von Kommentarautoren und zum Versenden von Mails über SMTP-Server erforderlich.',
	'MT home directory:' => 'MT-Wurzelverzeichnis:',
	'Movable Type System Check Successful' => 'Der Movable Type-Systemcheck war erfolgreich!',
	'Movable Type System Check' => 'Movable Type Systemüberprüfung',
	'Movable Type version:' => 'Movable Type-Version:',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP ist für den Versand von E-Mails über SMTP-Server erforderlich.',
	'Operating system:' => 'Betriebssystem;',
	'Perl include path:' => 'Perl-Include-Pfad:',
	'Perl version:' => 'Perl-Version:',
	'Please consult the installation instructions for help in installing [_1].' => 'Bitte beachten Sie bei der Installation von [_1] die Installationshinweise.',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'Die Installation von SOAP::Lite ist optional. Dieses Modul ist zur Nutzung des XML-RPC-Servers von Movable Type erforderlich.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Die Installation von Storable ist optional. Es wird von einigen Movable-Type-Plugins von Drittanbietern benötigt.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'Die auf Ihrem Server installierte Version von DBD::mysql ist nicht mit Movable Type kompatibel. Bitte installieren Sie die aktuelle Version.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Die MT-Systemüberprüfung ist deaktiviert, wenn bereits eine gültige Konfigurationdabei mt-config.cgi vorhanden ist.',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '[_1] ist korrekt installiert, benötigt aber ein aktuelleres DBI-Modul. Bitte beachten Sie die obigen Hinweise zu diesem Modul.',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Die folgenden Module sind <strong>optional</strong>. Sie brauchen zusätzlich nur dann installiert zu werden, wenn Sie die von ihnen bereitgestellten Funktionen nutzen möchten.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Die folgenden Module sind zur Abindung der Datenbank an Movable Type erforderlich. Zur Nutzung des Systems müssen DBI und das Modul für den jeweiligen Datenbank-Typ installiert sein.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'Die auf Ihrem Server installierte Perl-Version [_1] ist älter als die mindestens erforderliche Version [_2]. Bitte aktualisieren Sie Ihre Installation daher auf Perl [_2] oder neuer.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Dieses Modul und seine Abhängigkeiten sind zum Betrieb von Movable Type unter psgi erforderlich.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Dieses Modul ist für mt-search.cgi erforderlich, wenn Sie Perl älter als 5.8 einsetzen.',
	'This module required for action streams.' => '', # Translate - New
	'Web server:' => 'Webserver:',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom ist zur Nutzung der Atom-API erforderlich.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX und seine Abhängigkeiten sind zum Einspielen von Backups erforderlich.',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Sie haben für die gewünschte Funktion keine Berechtigung. Bei Fragen wenden Sie sich bitte an Ihren Systemadministrator.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Auf Ihrem Server ist [_1] selbst oder ein von [_1] erforderliches Modul nicht installiert.',
	'Your server has [_1] installed (version [_2]).' => 'Auf Ihrem Server ist [_1] in der Version [_2] installiert.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle erforderlichen Module sind auf Ihrem Server installiert. Beginnen Sie jetzt mit der Installation von Movable Type.',
	'[_1] [_2] Modules' => '[_1] [_2]-Modue',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] ist optional. Es handelt sich um eine bessere, kleinere und schnellere Alternative zu YAML::Tiny.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => 'Die Installation von [_1] ist optional. Es ist eines der Module, das zur automatischen Erzeugung von Vorschaubildern verwendet werden kann. ',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] ist optional. Es gehört zu den Modulen, die zum Einspielen von Sicherungskopien erforderlich sind.',
	'unknown' => 'unbekannt',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Das Skript mt-check.cgi führt eine Überprüfung Ihrer Systemkonfiguration durch und stellt fest, ob alle zum Betrieb von Movable Type erforderlichen Komponenten vorhanden sind.},
	q{You're ready to go!} => q{Sie können sofort anfangen!},

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => 'Weiter',
	'You have unsaved changes to this page that will be lost.' => 'Es liegen nicht gespeicherte Seitenänderungen vor, die verloren gehen werden.',

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'Ungültige Web-Adresse (URL)',
	'Invalid date format' => 'Ungültiges Datumsformat',
	'Invalid time format' => 'Ungültiges Zeitformat',
	'Invalid value' => 'Ungültiger Wert',
	'Only 1 option can be selected' => 'Bitte wählen Sie genau eine Option',
	'Options greater than or equal to [_1] must be selected' => 'Bitte wählen Sie mindestens [_1] Optionen',
	'Options less than or equal to [_1] must be selected' => 'Bitte wählen Sie höchstens [_1] Optionen',
	'Please input [_1] characters or more' => 'Bitte geben Sie mindestens [_1] Zeichen ein',
	'Please select one of these options' => 'Bitte wählen Sie eine der Optionen',
	'This field is required' => 'Dieses Feld ist erforderlich.',
	'This field must be a number' => 'Zahl in diesem Feld erforderlich.',
	'This field must be a signed integer' => 'Integer mit Vorzeichen in diesem Feld erforderlich',
	'This field must be a signed number' => 'Zahl mit Vorzeichen in diesem Feld erforderlich',
	'This field must be an integer' => 'Integer in diesem Feld erforderlich.',
	'You have an error in your input.' => 'Eine Eingabe ist fehlerhaft.',

## mt-static/js/assetdetail.js
	'Dimensions' => 'Abmessungen',
	'File Name' => 'Dateiname',
	'No Preview Available.' => 'Keine Vorschau verfügbar',

## mt-static/js/contenttype/tag/content-field.tag
	'ContentField' => 'ContentField',
	'Move' => 'Verschieben',

## mt-static/js/contenttype/tag/content-fields.tag
	'Allow users to change the display and sort of fields by display option' => 'Benutzern erlauben, die Anzeige und Reihenfolge der Felder zu ändern',
	'Data Label Field' => 'Bezeichnungsfeld für Daten',
	'Drag and drop area' => 'Drag-und-Drop-Bereich',
	'Please add a content field.' => 'Bitte fügen Sie ein Inhaltsfeld ein.',
	'Show input field to enter data label' => 'Eingabefeld zur Eingabe der Datenbezeichung anzeigen',
	'Unique ID' => 'Eindeutige ID',
	'close' => 'schließen',

## mt-static/js/dialog.js
	'(None)' => '(Keine)',

## mt-static/js/listing/list_data.js
	'Unknown Filter' => '', # Translate - New
	'[_1] - Filter [_2]' => '[_1]-Filter [_2]',

## mt-static/js/listing/listing.js
	'Are you sure you want to [_2] this [_1]?' => '[_1] wirklich [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Die [_1] gewählten [_2] wirklich [_3]?',
	'Label "[_1]" is already in use.' => 'Bezeichnung "[_1]" bereits vorhanden.',
	'One or more fields in the filter item are not filled in properly.' => '', # Translate - New
	'You can only act upon a maximum of [_1] [_2].' => 'Nur möglich für höchstens [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Nur möglich für mindestens [_1] [_2].',
	'You did not select any [_1] to [_2].' => 'Keine [_1] zu [_2] gewählt.',
	'act upon' => 'reagieren',
	q{Are you sure you want to remove filter '[_1]'?} => q{Filter '[_1]' wirklich entfernen?},

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'[_1] rows' => '[_1] Zeilen',
	'Show' => 'Anzeigen',

## mt-static/js/listing/tag/display-options.tag
	'Column' => 'Spalte',
	'Reset defaults' => 'Auf Standardeinstellungen zurücksetzen',
	'User Display Option is disabled now.' => 'Anzeigeoptionen für Benutzer deaktiviert.',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Plugin Actions' => 'Plugin-Aktionen',
	'Select action' => 'Aktion wählen',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Weitere Aktionen...',

## mt-static/js/listing/tag/list-filter.tag
	'Add' => 'Hinzufügen',
	'Apply' => 'Anwenden',
	'Built in Filters' => 'Eingebaute Filter',
	'Create New' => 'Neu anlegen',
	'Filter Label' => 'Filter-Bezeichnung',
	'Filter:' => 'Filter:',
	'My Filters' => 'Meine Filter',
	'Reset Filter' => 'Filer zurücksetzen',
	'Save As' => 'Speichern als',
	'Select Filter Item...' => 'Filterelement wählen...',
	'Select Filter' => 'Filter wählen',
	'rename' => 'umbenennen',

## mt-static/js/listing/tag/list-table.tag
	'All [_1] items are selected' => 'Alle [_1] Elemente ausgewählt',
	'All' => 'Alle',
	'Loading...' => 'Lade...',
	'Select All' => 'Alle auswählen',
	'Select all [_1] items' => 'Alle [_1] Elemente auswählen',
	'Select' => 'Wählen',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] von [_3]',

## mt-static/js/mt/util.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '[_1] Rolle(n) wirklich entfernen? Entfernen der Rollen entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Rolle wirklich entfernen? Entfernen der Rolle entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'You did not select any [_1] [_2].' => 'Sie haben keine [_1] [_2] gewählt',
	'You must select an action.' => 'Bitte wählen Sie zunächst eine Aktion.',
	'delete' => 'löschen',

## mt-static/js/tc/mixer/display.js
	'Author:' => 'Autor:',
	'Description:' => 'Überschrift:',
	'Tags:' => 'Tags:',
	'Title:' => 'Titel:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a path beginning with %s or %a.' => 'Pfade müssen mit %s oder %a beginnen.',
	'You must set a valid path.' => 'Bitte geben Sie einen gültigen Pfad an.',

## mt-static/mt.js
	'Enter URL:' => 'URL eingeben:',
	'Enter email address:' => 'E-Mail-Adresse eingeben:',
	'Same name tag already exists.' => 'Ein Tag mit diesem Namen ist bereits vorhanden.',
	'disable' => 'deaktivieren',
	'enable' => 'aktivieren',
	'publish' => 'veröffentlichen',
	'remove' => 'entfernen',
	'to mark as spam' => 'zur Markierung als Spam',
	'to remove spam status' => 'zum Entfernen des Spam-Status',
	'unlock' => 'entsperren',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich in allen Weblogs mit &#8222;[_2]&#8220; zusammengeführt werden?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich mit &#8222;[_2]&#8220; zusammengeführt werden?},

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1]-Block bearbeiten',

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Code einbetten',
	'Please enter the embed code here.' => 'Bitte geben Sie den einzubettenden Code hier ein.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading Level' => 'Ebene der Überschrift',
	'Heading' => 'Überschrift',
	'Please enter the Header Text here.' => 'Bitte geben Sie die Überschrift hier ein.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale Trennlinie',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js
	'image' => 'Bild',

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Text',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Wählen Sie einen Block',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Textbaustein einfügen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'Es liegen nicht gespeicherte Änderungen vor. Wirklich verlassen?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'Wert',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%H:%M:%S' => '%H:%M:%S',
	'%Y-%m-%d' => '%Y-%m-%d',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Align Center' => 'Zentriert',
	'Align Left' => 'Linsbündig',
	'Align Right' => 'Rechtsbündig',
	'Block Quotation' => 'Zitat',
	'Bold (Ctrl+B)' => 'Fett (Strg+B)',
	'Class Name' => 'Name der Klasse',
	'Emphasis' => 'Betonung',
	'Horizontal Line' => 'Trennlinie',
	'Indent' => 'Einrücken',
	'Insert Asset Link' => 'Link aus Assets einfügen',
	'Insert HTML' => 'HTML einfügen',
	'Insert Image Asset' => 'Bild aus Assets einfügen',
	'Insert Link' => 'Link einfügen',
	'Insert/Edit Link' => 'Link einfügen/bearbeiten',
	'Italic (Ctrl+I)' => 'Kursiv (Strg+I)',
	'List Item' => 'Listenelement',
	'Ordered List' => 'Sortierte Liste',
	'Outdent' => 'Ausrücken',
	'Redo (Ctrl+Y)' => 'Wiederholen (Strg+Y)',
	'Remove Formatting' => 'Formatierung entfernen',
	'Select Background Color' => 'Hintergrundfarbe wählen',
	'Select Text Color' => 'Schriftfarbe wählen',
	'Strikethrough' => 'Durchstreichen',
	'Strong Emphasis' => 'Starke Betonung',
	'Toggle Fullscreen Mode' => 'Vollbildmodus aktivieren/deaktivieren',
	'Toggle HTML Edit Mode' => 'HTML-Editor aktivieren/deaktivieren',
	'Underline (Ctrl+U)' => 'Unterstrichen (Strg+U)',
	'Undo (Ctrl+Z)' => 'Rückgängig (Strg+Z)',
	'Unlink' => 'Link entfernen',
	'Unordered List' => 'Unsortierte Liste',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Fullscreen',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Copy column' => '', # Translate - New
	'Cut column' => '', # Translate - New
	'Horizontal align' => '', # Translate - New
	'Paste column after' => '', # Translate - New
	'Paste column before' => '', # Translate - New
	'Vertical align' => '', # Translate - New

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'Archivtyp nicht gefunden - [_1]',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Befehl [_1] ohne Datums-Kontext verwendet.',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found: \"[_1]\"' => '', # Translate - New

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Befehl [_1] ohne gültiges Namens-Attribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/captcha_lib.php
	'Type the characters shown in the picture above.' => 'Geben Sie die Zeichen ein, die Sie in obigem Bild sehen.',

## php/lib/function.mtassettype.php
	'file' => 'Datei',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Wenn die Attribute exclude_blogs und include_blogs gemeinsam verwendet werden, geben Sie die gleichen Blog-IDs nicht gleichzeitig für beide an. ',

## php/mt.php
	'Page not found - [_1]' => 'Seite nicht gefunden - [_1]',

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'[_1] - [_2] of [_3]' => '[_1]-[_2] von [_3]',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl
	'Cancelled: [_1]' => 'Abgebrochen: [_1]',
	'The file you tried to upload is too large: [_1]' => 'Die gewählte Datei ist zu groß: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] ist keine gültige [_2]-Datei',

## plugins/Comments/lib/Comments.pm
	'(Deleted)' => '(Gelöscht)',
	'Approved' => 'Freigeschaltet',
	'Banned' => 'Gesperrt',
	'Can comment and manage feedback.' => 'Kann kommentieren und Feedback verwalten',
	'Can comment.' => 'Kann kommentieren',
	'Commenter' => 'Kommentarautor',
	'Comments on [_1]: [_2]' => 'Kommentare zu [_1]: [_2]',
	'Edit this [_1] commenter.' => 'Diesen [_1] Kommentar-Autor bearbeiten',
	'Moderator' => 'Moderator',
	'Not spam' => 'Nicht Spam',
	'Reply' => 'Antworten',
	'Reported as spam' => 'Als Spam gemeldet',
	'Search for other comments from anonymous commenters' => 'Nach anderen anonym abgegeben Kommentaren suchen',
	'Search for other comments from this deleted commenter' => 'Nach anderen Kommentaren des gelöschten Autors suchen',
	'Unapproved' => 'Nicht freigeschaltet',
	'__ANONYMOUS_COMMENTER' => 'Anonym',
	'__COMMENTER_APPROVED' => 'Bestätigt',
	q{All comments by [_1] '[_2]'} => q{Alle Kommentare von [_1] &#8222;[_2]&#8220;},

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'All Comments' => 'Alle Kommentare',
	'[_1] Comments' => '[_1] Kommentare',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'Wirklich alle als Spam markierte Kommentare löschen?',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Klone Kommentare für Weblog...',

## plugins/Comments/lib/Comments/Import.pm
	'Saving comment failed: [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	q{Creating new comment (from '[_1]')...} => q{Lege neuen Kommentar (von &#8222;[_1]&#8220;) an...},

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Lege ursprüngliche Kommentar-Rollen an...',

## plugins/Comments/lib/MT/App/Comments.pm
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Zurück zur Ausgangsseite</a>',
	'All required fields must be populated.' => 'Alle erforderlichen Felder müssen ausgefüllt sein.',
	'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
	'Comment save failed with [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Comment text is required.' => 'Bitte geben Sie einen Kommentartext ein.',
	'Commenter profile could not be updated: [_1]' => 'Das Profil des Kommentarautoren konnte nicht aktualisiert werden: [_1]',
	'Commenter profile has successfully been updated.' => 'Das Profil des Kommentarautoren wurde erfolgreich aktualisiert.',
	'Comments are not allowed on this entry.' => 'Zu diesem Eintrag können keine Kommentare abgegeben werden.',
	'IP Banned Due to Excessive Comments' => 'IP-Adresse wegen exzessiver Kommentarabgabe gesperrt',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ungültiger Anmeldeversuch von Kommentarautor [_1] an Weblog [_2](ID: [_3]) - native Movable Type-Authentifizierung bei diesem Weblog nicht zulässig.',
	'Invalid entry ID provided' => 'Ungültige Eintrags-ID angegeben',
	'Movable Type Account Confirmation' => 'Movable Type-Anmeldungsbestätigung',
	'Name and E-mail address are required.' => 'Name und E-Mail-Adresse sind erforderlich',
	'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag angegeben. Vielleicht gibt es ein Problem mit der Vorlage?',
	'No id' => 'Keine ID',
	'No such comment' => 'Kein entsprechender Kommentar',
	'Registration is required.' => 'Registrierung erforderlich',
	'Signing up is not allowed.' => 'Registrierungen sind nicht erlaubt.',
	'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Sie haben sich erfolgreich authentifiziert, dürfen sich aber nicht anmelden. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Vielen Dank für Ihre Bestätigung. Sie können sich jetzt anmelden und kommentieren.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Weiterleitung auf eine externe Website. Wenn Sie dieser Site vertrauen, klicken Sie bitte auf diesen Link: [_1]',
	'You need to sign up first.' => 'Bitte registrieren Sie sich zuerst.',
	'Your confirmation has expired. Please register again.' => 'Ihre Bestätigung ist nicht mehr gültig. Bitte registrieren Sie sich erneut.',
	'_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in schneller Folge abgegeben. Bitte versuchen Sie es in einigen Augenblicken erneut.',
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{Kommentarautor &#8222;[_1]&#8220; (ID:[_2]) erfolgreich registriert.},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{Fehler bei der Zuweisung von Kommentierungsrechten an Benutzer &#8222;[_1] (ID: [_2])&#8220; für Weblog '[_3] (ID: [_4])'. Keine geeignete Kommentierungsrolle gefunden.},
	q{Failed comment attempt by pending registrant '[_1]'} => q{Fehlgeschlagener Kommentierungsversuch durch wartenden Kommentarautoren &#8222;[_1]&#8220;},
	q{Invalid URL '[_1]'} => q{Ungültige URL '[_1]'},
	q{Login failed: password was wrong for user '[_1]'} => q{Anmeldung fehlgeschlagen: falsches Passwort für Benutzer &#8222;[_1]&#8220;},
	q{Login failed: permission denied for user '[_1]'} => q{Anmeldung fehlgeschlagen: Zugriff verweigert für Benutzer &#8222;[_1]&#8220;},
	q{No such entry '[_1]'.} => q{Kein Eintrag &#8222;[_1]&#8220;.},
	q{[_1] registered to the blog '[_2]'} => q{[_1] hat sich für das Blog &#8222;[_2]&#8220; registriert.},

## plugins/Comments/lib/MT/CMS/Comment.pm
	'Commenter Details' => 'Kommentarautor-Details',
	'Edit Comment' => 'Kommentar bearbeiten',
	'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
	'Orphaned comment' => 'Verwaister Kommentar',
	'The entry corresponding to this comment is missing.' => 'Der zu diesem Kommentar gehörende Eintrag fehlt.',
	'The parent comment id was not specified.' => 'ID des Eltern-Kommentars nicht angegeben.',
	'The parent comment was not found.' => 'Eltern-Kommentar nicht gefunden.',
	'You cannot create a comment for an unpublished entry.' => 'Nicht veröffentlichte Einträge können nicht kommentiert werden.',
	'You cannot reply to unapproved comment.' => 'Sie können nicht auf nicht freigeschaltete Kommentare antworten.',
	'You cannot reply to unpublished comment.' => 'Auf nicht veröffentlichte Kommentare kann nicht geantwortet werden.',
	'You do not have permission to approve this comment.' => 'Sie sind nicht berechtigt, Kommentare freizuschalten.',
	'You do not have permission to approve this trackback.' => 'Sie sind nicht berechtigt, TrackBacks freizuschalten.',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Kommentar (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht},
	q{User '[_1]' banned commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; gesperrt},
	q{User '[_1]' trusted commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen ausgesprochen},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat die Sperrung von Kommentarautor &#8222;[_2]&#8220; aufgehoben},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen entzogen},

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'Anonymous' => 'Anonym',
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'Der Befehl MTComentFields steht nicht mehr zur Verfügung. Binden Sie stattdessen das Vorlagenmodul [_1] ein. ',

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{Der Befehl &#8222;[_1]&#8220; wird nicht mehr unterstützt. Verwenden Sie stattdessen den Befehl '[_2]'.},

## plugins/Comments/php/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{Der Befehl &#8222;[_1]&#8220; ist veraltet. Bitte verwenden Sie stattdessen '[_2]'},

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'The login could not be confirmed because of no/invalid blog_id' => 'Das Login konnte nicht bestätigt werden, da die blog_id fehlt oder ungültig ist.',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Gewählten Textbaustein wirklich löschen?',
	'Boilerplates' => 'Textbausteine',
	'Create Boilerplate' => 'Textbaustein anlegen',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{Der Textbaustein '[_1]' wird in dieser Site bereits verwendet.},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplate' => 'Textbaustein',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Der Textbaustein  &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.},

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte Textbaustein nicht laden',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Ein zur Nutzung der Google-Analytics-API erforderliches Perl-Modul fehlt: [_1].',
	'The name of the profile' => 'Profilname',
	'The web property ID of the profile' => 'Die Web Property ID des Profils',
	'You did not specify a client ID.' => 'Bitte geben Sie eine Client ID an.',
	'You did not specify a code.' => 'Bitte geben Sie einen Code an.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting accounts: [_1]: [_2]' => 'Beim Abrufen der Konten ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Beim Abrufen der Profile ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when getting token: [_1]: [_2]' => 'Beim Bezug des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Bei der Aktualisierung des Tokens ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Beim Abrufen der Statistikdaten ist ein Fehler aufgetreten: [_1]: [_2]',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Ein zur Authentifizierung von Kommentarautoren per Google ID erforderliches Perl-Moduul fehlt: [_1].',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Konnte Net::OpenID::Consumer nicht laden.',
	'Could not save the session' => 'Konnte Session nicht speichern.',
	'Could not verify the OpenID provided: [_1]' => 'Die angegebene OpenID konnte nicht bestätigt werden: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Das zur OpenID-Authentifizierung erforderliche Perl-Modul Digest::SHA1 fehlt.',
	'The address entered does not appear to be an OpenID endpoint.' => 'Die angebene Adresse ist kein OpenID-Endpunkt.',
	'The text entered does not appear to be a valid web address.' => 'Der eingegebene Text ist keine gültige Web-Adresse.',
	'Unable to connect to [_1]: [_2]' => 'Konnte keine Verbindung zu [_1] aufbauen: [_2]',

## plugins/Textile/textile2.pl
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',

## plugins/Trackback/lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'Dieser TrackBack-Eintrag ist deaktiviert.',
	'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
	'TrackBack ID (tb_id) is required.' => 'TrackBack_ID (tb_id) erforderlich.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
	'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
	'You are not allowed to send TrackBack pings.' => 'Sie haben keine Berechtigung, TrackBack-Pings zu senden.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Sie versenden TrackBacks-Pings zu schnell hintereinander. B
itte versuchen Sie es später erneut.',
	'You must define a Ping template in order to display pings.' => 'Sie müssen eine Ping-Vorlage definieren, um Pings anzeigen zu können.
',
	'You need to provide a Source URL (url).' => 'Bitte geben Sie eine Quell-URL (url) an.',
	q{Cannot create RSS feed '[_1]': } => q{RSS-Feed &#8222;[_1]&#8220; kann nicht angelegt werden: },
	q{Invalid TrackBack ID '[_1]'} => q{Ungültige TrackBack-ID &#8222;[_1]&#8220;},
	q{New TrackBack ping to '[_1]'} => q{Neuer TrackBack-Ping an &#8222;[_1]&#8220;},
	q{New TrackBack ping to category '[_1]'} => q{Neuer TrackBack-Ping an Kategorie &#8222;[_1]&#8220;},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{TrackBack für Kategorie &#8222;[_1]&#8220; (ID:[_2])},

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Namenlose Kategorie)',
	'(Untitled entry)' => '(Namenloser Eintrag)',
	'Edit TrackBack' => 'TrackBack bearbeiten',
	'No Excerpt' => 'Kein Auszug',
	'Orphaned TrackBack' => 'Verwaistes TrackBack',
	'category' => 'Kategorien',
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Kategorie &#8222;[_4]&#8220; gelöscht},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht},

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem &#8222;category&#8220;-Attribut des Tags verwendet werden.},

## plugins/Trackback/lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
	'No MTPingURL defined in the configuration file' => 'Keine MTPingURL in der Konfigurationsdatei definiert',
	'No WeblogsPingURL defined in the configuration file' => 'Keine WeblogsPingURL in der Konfigurationsdatei definiert',
	'Ping error: [_1]' => 'Ping-Fehler: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping von: [_2] - [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks zu [_1]: [_2]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'All TrackBacks' => 'Alle TrackBacks',
	'[_1] TrackBacks' => '[_1] TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Wirklich alle als Spam markierten TrackBacks löschen?',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBack pings for blog...' => 'Klone TrackBack-Pings für Weblog...',
	'Cloning TrackBacks for blog...' => 'Klone TrackBacks für Weblog...',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	q{Ping '[_1]' failed: [_2]} => q{Ping &#8222;[_1]&#8220; fehlgeschlagen: [_2]},

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'Quell-URL',

## plugins/Trackback/lib/Trackback/Import.pm
	'Saving ping failed: [_1]' => 'Der Ping konnte nicht gespeichert werden: [_1]',
	q{Creating new ping ('[_1]')...} => q{Erzeuge neuen Ping &#8222;[_1]&#8220;)...},

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'Archive Root' => 'Archiv-Wurzel',
	'No Site' => 'Keine Site',

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => 'Fehlgeschlagen.',
	'Moving storage of Widget Manager [_2]...' => 'Verschiebe Speicherort des Widget Managers [_2]...',

## plugins/spamlookup/lib/spamlookup.pm
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'E-mail was previously published (comment id [_1]).' => 'E-Mail-Adresse wurde bereits veröffentlicht (Kommentar [_1])',
	'Failed to resolve IP address for source URL [_1]' => 'Kann IP-Adresse der Quelladresse [_1] nicht auflösen',
	'Link was previously published (TrackBack id [_1]).' => 'Link wurde bereits veröffentlicht (TrackBack [_1])',
	'Link was previously published (comment id [_1]).' => 'Link wurde bereits veröffentlicht (Kommentar [_1])',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Moderation: Die IP-Adresse der Domain ([_2]) stimmt nicht mit der Ping-IP-Adresse ([_3]) überein. URL: [_1]',
	'No links are present in feedback' => 'Keine Links enthalten',
	'Number of links exceed junk limit ([_1])' => 'Anzahl der Links übersteigt Spam-Schwellenwert ([_1] Links)',
	'Number of links exceed moderation limit ([_1])' => 'Anzahl der Links übersteigt Moderations-Schwellenwert ([_1] Links)',
	'[_1] found on service [_2]' => '[_1] gefunden bei [_2]',
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{Moderierung: Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.},
	q{Word Filter match on '[_1]': '[_2]'.} => q{Schlüsselwortfilter angesprochen bei &#8222;[_1]&#8220;: &#8222;[_2]&#8220;.},
	q{domain '[_1]' found on service [_2]} => q{Domain &#8222;[_1]&#8220;gefunden bei [_2]},

## search_templates/comments.tmpl
	'Find new comments' => 'Neue Kommentare finden',
	'No new comments were found in the specified interval.' => 'Keine neuen Kommentare in diesem Zeitraum gefunden.',
	'No results found' => 'Keine Treffer',
	'Posted in [_1] on [_2]' => 'Veröffentlicht in [_1] am [_2]',
	'Search for new comments from:' => 'Suche nach neuen Kommentaren:',
	'five months ago' => 'vor fünf Monaten',
	'four months ago' => 'vor vier Monaten',
	'one month ago' => 'vor einem Monat',
	'one week ago' => 'vor einer Woche',
	'one year ago' => 'vor eine mJahr',
	'six months ago' => 'vor sechs Monaten',
	'the beginning' => 'ingesamt',
	'three months ago' => 'vor drei Monaten',
	'two months ago' => 'vor zwei Monaten',
	'two weeks ago' => 'vor zwei Wochen',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Wählen Sie den gewünschten Zeitraum und klicken Sie dann auf &#8222;Neue Kommentare finden&#8220;.},

## search_templates/content_data_default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
	'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
	'END OF CONTAINER' => 'CONTAINER ENDE',
	'END OF PAGE BODY' => 'PAGE BODY ENDE',
	'Feed Subscription' => 'Feed abonnieren',
	'Matching content data from [_1]' => 'Passende Inhaltsdaten aus [_1]',
	'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Veröffentlicht <MTIfNonEmpty tag="ContentAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'AUTODISCOVERY-LINK FÜR SUCH-FEEDS WIRD NUR NACH ABSCHLUSS EINER SUCHE VERÖFFENTLICHT',
	'SEARCH RESULTS DISPLAY' => 'ANZEIGE DER SUCHERGEBNISSE',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE VS TAG-Information',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'BEI DIREKTEN SUCHEN WIRD DAS SUCHFORMULAR ANGEZEIGT',
	'Search this site' => 'Diese Site durchsuchen',
	'Showing the first [_1] results.' => 'Erste [_1] Treffer',
	'Site Search Results' => 'Suchergebnis in der Site',
	'Site search' => 'Site-Suche',
	'What is this?' => 'Was ist das?',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{Content Data matching '[_1]'} => q{Inhalte für '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Mit '[_1]' getaggte Inhalte},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Inhalte zu &#8222;[_1]&#8220; abonnieren.},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Inhalte abonnieren.},
	q{No pages were found containing '[_1]'.} => q{Keine Seiten mit &#8222;[_1]&#8220; gefunden.},

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Suchergebnis für [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Suchergebnis im Blog',
	'Blog search' => 'Suche im Blog',
	'Match case' => 'Groß-/Kleinschreibung beachten',
	'Matching entries from [_1]' => 'Treffer in [_1]',
	'Other Tags' => 'Andere Tags',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Veröffentlicht <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'Regex search' => 'Reguläre Ausdrücke verwenden',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
	q{Entries from [_1] tagged with '[_2]'} => q{Mit &#8222;[_2]&#8220; getaggte Einträge aus [_1]},
	q{Entries matching '[_1]'} => q{Einträge mit &#8222;[_1]&#8220;},
	q{Entries tagged with '[_1]'} => q{Mit &#8222;[_1]&#8220; getaggte Einträge},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit &#8222;[_1]&#8220; abonnieren.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren.},

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] hat auf den <a href="[_2]">Kommentar von [_3]</a> geantwortet</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Kommentardetails',

## themes/classic_blog/templates/comment_preview.mtml
	'(You may use HTML tags for style)' => '(Zur Formatierung können HTML-Tags verwendet werden.)',
	'Leave a comment' => 'Kommentar schreiben',
	'Previewing your Comment' => 'Vorschau Ihres Kommentars',
	'Replying to comment from [_1]' => 'Antwort auf den Kommentar von [_1]',
	'Submit' => 'Abschicken',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'Ihr Kommentar ist eingegangen!',
	'Your comment submission failed for the following reasons: [_1]' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden: [_1]',

## themes/classic_blog/templates/comments.mtml
	'Remember personal info?' => 'Persönliche Angaben speichern?',
	'The data is modified by the paginate script' => 'Die Daten werden vom Paginierungsskript modifiziert.',

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="Vollständiger Kommentar zu [_4]">weiterlesen</a>',

## themes/classic_blog/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> von [_3] zu <a href="[_4]">[_5]</a>',
	'TrackBack URL: [_1]' => 'TrackBack-URL: [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Weiterlesen</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Klassisches Blog-Design mit zahlreichen Stilvorlagen und zwei- und dreispaltigen Layouts. Ideal für alle Blogging-Zwecke.',
	'Displays error, pending or confirmation message for comments.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Kommentaren an',
	'Displays preview of comment.' => 'Zeigt eine Vorschau des Kommentars an',
	'Displays results of a search for content data.' => 'Zeigt Ergebnisse der Suche nach Inhaltsdaten an.',
	'Improved listing of comments.' => 'Verbesserte Kommentarverwaltung',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag dieses Blogs.',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag dieses Blogs',

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'Blogs',

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Feed dieser Website abonnieren},

## themes/classic_website/theme.yaml
	'Classic Website' => 'Klassische Website',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Für Portale, die die Inhalte mehrerer Blogs in einer gemeinsamen Website anzeigen.',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Neues Asset hochladen',

## tmpl/cms/backup.tmpl
	'Archive Format' => 'Archiv-Format',
	'Choose sites...' => 'Sites wählen...',
	'Everything' => 'Mit allen Blogs',
	'Export (e)' => 'Exportieren (e)',
	'No size limit' => 'Unbegrenzt',
	'Reset' => 'zurücksetzen',
	'Target File Size' => 'Gewünschte Dateigröße ',
	'What to Export' => 'Was soll exportiert werden',
	q{Don't compress} => q{Nicht komprimieren},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'TrackBacks annehmen',
	'Alignment' => 'Ausrichtung',
	'Ascending' => 'Aufsteigend',
	'Basename Length' => 'Länge des Basisnamens',
	'Center' => 'Mitte',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entitäten (&amp#8221;, &amp#8220; usw.)',
	'Compose Defaults' => 'Editor-Voreinstellungen',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'Sie können eigenes CSS für Inhalte nutzen, sofern der verwendete grafische Editor diese Funktion unterstützt. Referenzieren Sie Ihre CSS-Datei über ihre URL oder mit {{theme_static}}. Beispiel: {{theme_static}}pfad/zur/css-datei.css',
	'Content CSS' => 'CSS für Inhalte',
	'Czech' => 'Tschechisch',
	'Danish' => 'Dänisch',
	'Date Language' => 'Datumsanzeige',
	'Days' => 'Tage',
	'Descending' => 'Absteigend',
	'Display in popup' => '', # Translate - New
	'Display on the same screen' => '', # Translate - New
	'Dutch' => 'Holländisch',
	'English' => 'Englisch',
	'Entry Fields' => 'Eintragsfelder',
	'Estonian' => 'Estnisch',
	'Excerpt Length' => 'Länge des Auszugs',
	'French' => 'Französisch',
	'German' => 'Deutsch',
	'Icelandic' => 'Isländisch',
	'Image default insertion options' => 'Standardvorgang für das Einfügen von Bildern',
	'Italian' => 'Italienisch',
	'Japanese' => 'Japanisch',
	'Left' => 'Links',
	'Link from image' => '', # Translate - New
	'Link to original image' => '', # Translate - New
	'Listing Default' => 'Listen-Voreinstellung',
	'No substitution' => 'Keine Zeichen ersetzen',
	'Norwegian' => 'Norwegisch',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks auf Untersites oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks site- oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare auf Untersites oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare site- oder systemweit deaktiviert sind.',
	'Order' => 'Reihenfolge',
	'Page Fields' => 'Seitenfelder',
	'Polish' => 'Polnisch',
	'Portuguese' => 'Portugiesisch',
	'Posts' => 'Einträge',
	'Publishing Defaults' => 'Veröffentlichungs-Voreinstellungen',
	'Punctuation Replacement Setting' => 'Ersetzung von Satzzeichen',
	'Punctuation Replacement' => 'Ersetzung von Satzzeichen',
	'Replace Fields' => 'Felder ersetzen',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Mit dieser Option können von Textverarbeitungen erzeugte UTF-8-Sonderzeichen automatisch durch gebräuchlichere Äquivalente ersetzt werden.',
	'Right' => 'Rechts',
	'Save changes to these settings (s)' => 'Änderungen speichern (s)',
	'Setting Ignored' => 'Einstellung ignoriert',
	'Slovak' => 'Slowakisch',
	'Slovenian' => 'Slovenisch',
	'Spanish' => 'Spanisch',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
	'Suomi' => 'Finnisch',
	'Swedish' => 'Schwedisch',
	'Text Formatting' => 'Textformatierung',
	'The range for Basename Length is 15 to 250.' => 'Basisnamen können zwischen 15 und 250 Zeichen lang sein.',
	'Unpublished' => 'Nicht veröffentlicht',
	'Use thumbnail' => 'Vorschaubild verwenden',
	'WYSIWYG Editor Setting' => 'Einstellungen des grafischen Editors',
	'You must set valid default thumbnail width.' => 'Bitte geben Sie eine gültige Breite für die Vorschaubilder an.',
	'Your preferences have been saved.' => 'Die Einstellungen wurden gespeichert.',
	'pixels' => 'Pixel',
	'width:' => 'Breite:',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{ASCII-Äquivalente (&quot;, ', ..., -, --)},

## tmpl/cms/cfg_feedback.tmpl
	'([_1])' => '([_1])',
	'Accept TrackBacks from any source.' => 'TrackBacks von allen Quellen annehmen',
	'Accept comments according to the policies shown below.' => 'Kommentare nach folgenden Regeln annehmen',
	'Allow HTML' => 'HTML zulassen',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Bestimmte HTML-Tags in Kommentartexten zulassen. Anderfalls werden sämtliche HTML-Tags herausgefiltert.',
	'Any authenticated commenters' => 'von allen authentifizierten Kommentarautoren',
	'Anyone' => 'jedem',
	'Auto-Link URLs' => 'URLs automatisch verlinken',
	'Automatic Deletion' => 'Automatisches Löschen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam-Feedback nach Ablauf des angegebenen Zeitraums automatisch löschen.',
	'CAPTCHA Provider' => 'CAPTCHA-Quelle',
	'Comment Display Settings' => 'Kommentaranzeige-Einstellungen',
	'Comment Order' => 'Kommentar- reihenfolge',
	'Comment Settings' => 'Kommentar-Einstellungen',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Authentifizierungsfunktionen stehen nicht zur Verfügung, da mindestens eines der erforderlichen Perl-Module MIME::Base64 und LWP::UserAgent nicht verfügbar ist. Installieren Sie die fehlenden Module und laden Sie dann diese Seite neu, um Authentifizierungsfunktionen konfigurieren und nutzen zu können.',
	'Commenting Policy' => 'Kommentierungsregeln',
	'Delete Spam After' => 'Spam löschen nach',
	'E-mail Notification' => 'Benachrichtigungen',
	'Enable External TrackBack Auto-Discovery' => 'Auto-Discovery für externe TrackBacks aktivieren',
	'Enable Internal TrackBack Auto-Discovery' => 'Auto-Discovery für interne TrackBacks aktivieren',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks zur Moderation zurückhalten',
	'Immediately approve comments from' => 'Kommentare automatisch freischalten von',
	'Limit HTML Tags' => 'HTML einschränken ',
	'Moderation' => 'Moderation',
	'No CAPTCHA provider available' => 'Keine CAPTCHA-Quelle verfügbar',
	'No one' => 'niemandem',
	'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit deaktiviert. Diese Option ist daher derzeit nicht wirksam.',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit eingeschränkt. Diese Option ist daher derzeit möglicherweise nicht oder nur teilweise wirksam.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
	'Off' => 'Nie',
	'On' => 'Immer',
	'Only when attention is required' => 'Nur wenn eine Entscheidung erforderlich ist',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie, ob Kommentare in chronologischer oder umgekehrter chronologischer Reihenfolge angezeigt werden sollen,',
	'Setting Notice' => 'Nutzungshinweise',
	'Setup Registration' => 'Registierung konfigurieren',
	'Spam Score Threshold' => 'Spam-Schwellenwert',
	'Spam Settings' => 'Spam-Einstellungen',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Die Skala reicht von -10 bis +10. Je höher der Wert, desto eher werden Kommentare und TrackBacks als Spam angesehen.',
	'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
	'TrackBack Options' => 'TrackBack-Optionen',
	'TrackBack Policy' => 'TrackBack-Regeln',
	'Trackback Settings' => 'TrackBack-Einstellungen',
	'Transform URLs in comment text into HTML links.' => 'In Kommentaren enthaltene URLs in HTML-Links umwandeln.',
	'Trusted commenters only' => 'von vertrauten Kommentarautoren',
	'Use Comment Confirmation Page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	'Use defaults' => 'Standardwerte verwenden',
	'Use my settings' => 'Eigene Einstellungen',
	'days' => 'Tage',
	q{'nofollow' exception for trusted commenters} => q{'nofollow' nicht für vertraute Kommentarautoren setzen},
	q{Apply 'nofollow' to URLs} => q{'nofollow' an URLs anhängen},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{&#8222;nofollow&#8220;-Attribut nicht in Feedback von vertrauten Autoren setzen.},
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Nach Abgabe eines Kommentars Autoren automatisch auf Bestätigungsseite weiterleiten.},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Aktivieren Sie diese Option, um bei Links in Kommentaren und TrackBacks das 'nofollow'-Attribut zu setzen.},
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Keine CAPTCHA-Quelle im System verfügbar. Überprüfen Sie, ob Image::Magick installiert ist und ob das CaptchaSourceImageBase-Konfigurationsparameter auf ein gültiges Verzeichnis im Ordner &#8222;mt-static/images&#8220; zeigt.},

## tmpl/cms/cfg_plugin.tmpl
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Plugins wirklich systemweit deaktivieren?',
	'Are you sure you want to disable this plugin?' => 'Dieses Plugin wirklich deaktivieren?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Plugins wirklich systemweit aktivieren? (Es werden die Plugin-Einstellungen gültig, die bereits vor der Deaktivierung gültig waren.)',
	'Are you sure you want to enable this plugin?' => 'Dieses Plugin wirklich aktivieren?',
	'Are you sure you want to reset the settings for this plugin?' => 'Wollen Sie die Plugin-Einstellungen wirklich zurücksezten?',
	'Author of [_1]' => 'Autor von [_1]',
	'Disable Plugins' => 'Plugins deaktivieren',
	'Disable plugin functionality' => 'Plugin-Funktion deaktivieren',
	'Documentation for [_1]' => 'Dokumentation zu [_1]',
	'Enable Plugins' => 'Plugins aktivieren',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin für die gesamte Movable Type-Installation aktivieren oder deaktivieren.',
	'Enable plugin functionality' => 'Plugin-Funktion aktivieren',
	'Failed to Load' => 'Fehler beim Laden',
	'Failed to load' => 'Fehler beim Laden',
	'Find Plugins' => 'Weitere Plugins',
	'Info' => 'Info',
	'Junk Filters:' => 'Junkfilter',
	'More about [_1]' => 'Mehr über [_1]',
	'No plugins with blog-level configuration settings are installed.' => 'Es sind keine Plugins installiert, die Einstellungen auf Blogebene erfordern.',
	'No plugins with configuration settings are installed.' => 'Es sind keine Plugins installiert, die Einstellungen erfordern.',
	'Plugin Home' => 'Plugin-Website',
	'Plugin System' => 'Plugin-System',
	'Plugin error:' => 'Plugin-Fehler:',
	'Reset to Defaults' => 'Voreinstellungen',
	'Resources' => 'Ressourcen',
	'Run [_1]' => '[_1] ausführen',
	'Tag Attributes:' => 'Tag-Attribute:',
	'Text Filters' => 'Textfilter',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Dieses Plugin wurde noch nicht für Movable Type [_1] aktualisiert. Es funktioniert daher möglicherweise nicht einwandfrei.',
	'Your plugin settings have been reset.' => 'Plugin-Einstellungen zurückgesetzt',
	'Your plugin settings have been saved.' => 'Plugin-Einstellungen übernommen',
	'Your plugins have been reconfigured.' => 'Einstellungen übernommen',
	'_PLUGIN_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Ihre Plugins wurden konfiguriert. Da Sie mod_perl verwenden, starten Sie Ihren Webserver bitte neu, um die Änderungen wirksam werden zu lassen.},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Einstellungen übernommen. Da Sie mod_perl verwenden, müssen Sie Ihren Webserver neu starten, damit die Änderungen wirksam werden.},

## tmpl/cms/cfg_prefs.tmpl
	'Active Server Page Includes' => 'Active Server Page-Includes',
	'Advanced Archive Publishing' => 'Erweiterte Archivoptionen',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Entsprechend konfigurierte Vorlagenmodule zwischenzuspeichern erhöht die Leistung Ihres Systems.',
	'Allow to change at upload' => 'Darf beim Hochladen geändert werden',
	'Apache Server-Side Includes' => 'Apache Server-Side-Includes',
	'Archive Settings' => 'Archiv-Einstellungen',
	'Archive URL' => 'Archiv-Adresse',
	'Cancel upload' => 'Vorgang abbrechen',
	'Change license' => 'Lizenz ändern',
	'Choose archive type' => 'Archiv-Typ wählen',
	'Dynamic Publishing Options' => 'Dynamikoptionen',
	'Enable conditional retrieval' => 'Conditional Retrieval aktivieren',
	'Enable dynamic cache' => 'Dynamischen Cache aktivieren',
	'Enable orientation normalization' => 'Automatisches Drehen aktivieren',
	'Enable revision history' => 'Revisionsshistorie aufzeichnen',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache schreiben. Bitte weisen Sie dem Server Schreibrechte für das Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website zu.',
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Fehler: Movable Type konnte kein Verzeichnis für Ihr [_1] anlegen. Sollten Sie das Verzeichnis bereits selbst angelegt haben, stellen Sie bitte sicher, daß der Webserver für Schreibrechte dafür verfügt.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type konnte kein Cache-Verzeichnis für die dynamische Veröffentlichung erstellen. Bitte legen Sie ein Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website an.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Wenn Sie eine andere Sprache als die systemweit festgelegte Standardsprache wählen, können Sie unterschiedliche globale Vorlagen verwenden, indem Sie die Modulnamen in Ihren Vorlagen entsprechend ändern.',
	'Java Server Page Includes' => 'Java Server Page-Includes',
	'Language' => 'Sprache',
	'License' => 'Lizenz',
	'Module Caching' => 'Modul-Caching',
	'Module Settings' => 'Modul-Einstellungen',
	'No archives are active' => 'Archiv nicht aktiviert',
	'None (disabled)' => 'Keine (deaktiviert)',
	'Normalize orientation' => 'Bilder automatisch drehen',
	'Note: Revision History is currently disabled at the system level.' => 'Hinweis: Revisionshistorie ist systemweit deaktiviert',
	'Number of revisions per content data' => 'Anzahl der Revisionen pro Inhalt',
	'Number of revisions per entry/page' => 'Anzahl der Revisionen pro Eintrag/Seite',
	'Number of revisions per template' => 'Anzahl der Revisionen pro Vorlage',
	'Operation if a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'Overwrite existing file' => 'Vorhandene Datei überschreiben',
	'PHP Includes' => 'PHP-Includes',
	'Preferred Archive' => 'Bevorzugte Archive',
	'Publish With No Entries' => 'Leer veröffentlichen',
	'Publish archives outside of Site Root' => 'Archive außerhalb Site-Wurzelverzeichnis veröffentlichen',
	'Publish category archive without entries' => 'Leere Kategoriearchive veröffentlichen',
	'Publishing Paths' => 'System-Pfade',
	'Remove license' => 'Lizenz entfernen',
	'Rename filename' => 'Datei umbenennen',
	'Rename non-ascii filename automatically' => 'Nicht-ASCII-Dateinamen automatisch umbenennen',
	'Revision History' => 'Revisionshistorie',
	'Revision history' => 'Revisionshistorie',
	'Select a license' => 'Creative Commons-Lizenz wählen',
	'Server Side Includes' => 'Server Side Includes',
	'Site root must be under [_1]' => 'Das Wurzelverzeichnis der Website muss unter [_1] liegen',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Die URL des Archivs Ihrer Untersite. Beispiel: http://beispiel.de/blog/archiv/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'Die URL des Archivs Ihrer Site.  Beispiel: http://beispiel.de/archiv/',
	'Time Zone' => 'Zeitzone',
	'Time zone not selected' => 'Es wurde keine Zeitzone gewählt',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universal Time Coordinated)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Mitteleuropäische Zeit)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Ost-Australische Zeit)',
	'UTC+11' => 'UTC+11 (Ost-Australische Sommerzeit)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale Datumslinie Ost)',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Neuseeland Sommerzeit)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Osteuropäische Zeit)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad-/Moskau-Zeit)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iranische Zeit)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Russische Föderationszone 3)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Russische Föderationszone 4)',
	'UTC+5.5 (Indian)' => 'UTC+5,5 (Indische Zeit)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Russische Föderationszone 5)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (Nord Sumatra-Zeit)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (West-Australische Zeit)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chinesische Küstenzeit)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japanische Zeit)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Zentral-Australische Zeit)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (Westafrikanische Zeit)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Aleuten-Hawaii-Zeit)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Alaska, Nome-Zeit)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Azoren-Zeit)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantische Zeit)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Neufundland-Zeit)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantische Zeit)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Ostamerikanische Zeit)',
	'UTC-6 (Central Time)' => 'UTC-6 (Zentralamerikanische Zeit)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Amerikanische Gebirgszeit)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Pazifische Zeit)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska-Zeit)',
	'Upload Destination' => 'Zielverzeichnis',
	'Upload and rename' => 'Hochladen und umbenennen',
	'Use absolute path' => 'Absolute Pfadangabe verwenden',
	'Use subdomain' => 'Subdomain verwenden',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'You did not select a time zone.' => 'Bitte wählen Sie eine Zeitzone.',
	'You must set a valid Archive URL.' => 'Bitte geben Sie eine gültige Archiv-Adresse an.',
	'You must set a valid Local Archive Path.' => 'Bitte geben Sie einen gültigen lokalen Archiv-Pfad an.',
	'You must set a valid Local file Path.' => 'Bitte geben Sie einen gültigen lokalen Dateipfad an.',
	'You must set a valid URL.' => 'Bitte geben Sie eine gültige URL ein.',
	'You must set your Child Site Name.' => 'Bitte geben Sie den Namen der Untersite ein.',
	'You must set your Local Archive Path.' => 'Bitte geben Sie einen lokalen Archiv-Pfad an.',
	'You must set your Local file Path.' => 'Bitte geben Sie einen lokalen Dateipfad an.',
	'You must set your Site Name.' => 'Bitte geben Sie den Namen der Site ein.',
	'Your child site does not have an explicit Creative Commons license.' => 'Ihre Untersite verfügt über keine Creative-Commons-Lizenz.',
	'Your child site is currently licensed under:' => 'Ihre Untersite steht derzeit unter dieser Lizenz:',
	'Your site does not have an explicit Creative Commons license.' => 'Ihre Site verfügt über keine Creative-Commons-Lizenz.',
	'Your site is currently licensed under:' => 'Ihre Site steht derzeit unter dieser Lizenz:',
	'[_1] Settings' => '[_1]-Einstellungen',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{Die URL Ihrer Untersite. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{Die URL Ihrer Site. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog'},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Erzeugt dauerhafte URLs archivierter Einträge dieser Untersite (Permalinks). Wählen Sie dazu einen der in dieser Site verwendeten Archivtypen aus.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Erzeugt dauerhafte URLs archivierter Einträge dieser Site (Permalinks). Wählen Sie dazu einen der in dieser Site verwendeten Archivtypen aus.},

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Action' => 'Aktion',
	'Allow' => 'Aggregation zulassen',
	'Config Rebuild Trigger' => 'Auslöser für Neuaufbau konfigurieren',
	'Content Privacy' => 'Externer Zugriff auf Inhalte',
	'Cross-site aggregation will be allowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to restrict access to their content by other sites.' => '', # Translate - New
	'Cross-site aggregation will be disallowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to allow access to their content by other sites.' => '', # Translate - New
	'Data' => 'Daten',
	'Default system aggregation policy' => 'Systemwite Aggregations- Voreinstellung',
	'Disallow' => 'Aggregation nicht zulassen',
	'Exclude sites/child sites' => 'Sites/Untersites ausschließen',
	'Include sites/child sites' => 'Sites/Untersites einschließen',
	'MTMultiBlog tag default arguments' => 'MultiBlog- Standardargumente',
	'Rebuild Trigger settings have been saved.' => 'Auslöser-Einstellungen gespeichert.',
	'Rebuild Triggers' => 'Auslöser für Neuaufbau',
	'Site/Child Site' => 'Site/Untersite',
	'Use system default' => 'System-Voreinstellung verwenden',
	'When' => 'Wenn in',
	'You have not defined any rebuild triggers.' => 'Es sind keine Auslöser definiert.',
	q{Enables use of the MTSites tag without include_sites/exclude_sites attributes. Comma-separated SiteIDs or 'all' (include_sites only) are acceptable values.} => q{}, # Translate - New

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(Keine Rolle gewählt)',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'Besuchern erlauben, sich auf einem der unten aufgeführten Wege als Mitglied dieser Site zu registrieren.',
	'Authentication Methods' => 'Authentifizierungs- methoden',
	'New Created User' => 'Neu angelegte Benutzerkonten',
	'Note: Registration is currently disabled at the system level.' => 'Hinweis: Registrierungen sind derzeit systemweit deaktiviert.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Zur Nutzung dieser Authentifizierungsmethode fehlt mindestens ein erforderliches Perl-Modul.',
	'Please select authentication methods to accept comments.' => 'Wählen Sie, auf welche Weise sich Kommentar-Autoren authentifizieren können sollen.',
	'Registration Not Enabled' => 'Registrierungen nicht zulassen',
	'Select a role that you want assigned to users that are created in the future.' => 'Wählen Sie die Rolle, die künftig angelegten Benutzerkonten automatisch zugewiesen werden soll.',
	'Select roles' => 'Rollen awählen',
	'User Registration' => 'Benutzerregistrierung',
	'Your site preferences have been saved.' => 'Site-Einstellungen gespeichert.',

## tmpl/cms/cfg_system_general.tmpl
	'(No Outbound TrackBacks)' => '(Kein TrackBack-Versand)',
	'(None selected)' => '(Kein Blog gewählt)',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Movable Type-Benutzerkonten werden automatisch gesperrt, wenn das zugehörige Passwort binnen [_2] Sekunden mindestens [_1] mal in Folge falsch eingegeben wurde.',
	'A test mail was sent.' => 'Testmail verschickt.',
	'Allow sites to be placed only under this directory' => 'Sites nur unterhalb dieses Verzeichnisses zulassen',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'IP-Adresse werden automatisch gesperrt, wenn von ihr binnen [_2] mindestens [_1] ungültige  Anmeldeversuche ausgingen.',
	'Base Site Path' => 'Basis-Site-Pfad',
	'Changing image quality' => 'Bildqualität anpassen',
	'Clear' => 'zurücksetzen',
	'Debug Mode' => 'Debug-Modus',
	'Disable comments for all sites and child sites.' => 'Kommentare auf allen Sites und Untersites deaktivieren.',
	'Disable notification pings for all sites and child sites.' => 'Benachrichtigung-Pings für alle Sites und Untersites deaktivieren.',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Empfang von TrackBacks auf allen Sites und Untersites deaktivieren.',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Versenden Sie keine TrackBacks und verwenden Sie kein Auto-Disovery für TrackBacks, wenn Ihre Installation privat sein soll.',
	'Enable image quality changing.' => 'Anpassung der Bildqualität aktivieren',
	'IP address lockout policy' => 'IP-Sperrung',
	'Image Quality Settings' => 'Bildqualitäts-Einstellungen',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 85.' => 'Qualitätsstufe, in der hochgeladene JPG-Bilder und die zugehörigen Vorschaubilder gespeichert werden sollen. Die Skala reicht von 0 bis 100. Die Standardstufe ist 85.',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'Qualitätsstufe, in der hochgeladene PNF-Bilder und die zugehörigen Vorschaubilder gespeichert werden sollen. . Die Skala reicht von 0 bis 9. Die Standardstufe ist 7.',
	'Image quality(JPEG)' => 'Bildqualität (JPG)',
	'Image quality(PNG)' => 'Bildqualität (PNG)',
	'Imager does not support ImageQualityPng.' => 'ImageQualityPng wird von Imager nicht unterstützt.',
	'Lockout Settings' => 'Sperr-Einstellungen',
	'Log Path' => 'Logging-Pfad',
	'Logging Threshold' => 'Logging-Schwellenwert',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Mindestens eine Ihrer Site oder Untersites folgt nicht den in BaseSitePath angegebenen Beschränkungen.',
	'Only to child sites within this system' => 'Nur an Untersites innerhalb dieses Systems',
	'Only to sites on the following domains:' => 'Nur an folgende Domains:',
	'Outbound Notifications' => 'Benachrichtigungen',
	'Performance Logging' => 'Performance-Logging',
	'Prohibit Comments' => 'Kommentare nicht zulassen',
	'Prohibit Notification Pings' => 'Pings nicht zulassen',
	'Prohibit TrackBacks' => 'TrackBacks nicht zulassen',
	'Send Mail To' => 'Mail senden an',
	'Send Outbound TrackBacks to' => 'Ausgehende TrackBacks senden an',
	'Send Test Mail' => 'Testmail verschicken',
	'Send' => 'Absenden',
	'Site Path Limitation' => 'Site-Pfad-Begrenzung',
	'System Email Address' => 'System-E-Mail-Adresse',
	'System-wide Feedback Controls' => 'Systemweite Feedback-Einstellungen',
	'The email address that should receive a test email from Movable Type.' => 'Die Adresse, an die Movable Type Testmails verschicken soll.',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Verzeichnis für Log-Dateien. Ihr Webserver benötigt Schreibrechte für dieses Verzeichnis.',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'IP-Liste. Sind nicht zum eigenen Netzwerk gehörende IP-Adressen enthalten, werden fehlgeschlagene Anmeldeversuche über diese nicht aufgezeichnet. Verwenden Sie pro Adresse eine Zeile oder trennen Sie die Adressen mit Kommas.',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Vorgänge, die länger als die angegebene Anzahl von Sekunden benötigen, loggen.',
	'Track revision history' => 'Revisionshistorie verfolgen',
	'Turn on performance logging' => 'Performance-Logging aktivieren',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Performance-Logging protokolliert Ereignisse, die länger als eine von Ihnen bestimmbare Zeitspanne dauern.',
	'User lockout policy' => 'Kontensperrung',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Werte ungleich 0 aktivieren den Debug-Modus, in dem zusätzliche Diagnose-Informationen zur Fehlersuche angezeigt werden. Weitere Informationen finden Sie in der <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Dokumentation</a>.',
	'You must set a valid absolute Path.' => 'Bitte geben Sie einen gültigen absoluten Pfad an.',
	'You must set an integer value between 0 and 100.' => 'Bitte geben Sie eine ganze Zahl zwischen 0 und 100 ein.',
	'You must set an integer value between 0 and 9.' => 'Bitte geben Sie iene ganze Zahl zwischen 0 und 9 ein.',
	'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Diese IP-Adressen werden nie gesperrt:},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Bitte wählen Sie, welcher Administrator über automatische IP- und Benutzerkonten-Sperrungen informiert werden soll. Wählen Sie keinen Administrator, wird die System-E-Mail-Adresse verwendet.},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw.},

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => 'Registrierung erlauben',
	'Allow commenters to register on this system.' => 'Kommentarautoren ermöglichen, sich selbst zu registrieren.',
	'Comma' => 'Komma',
	'Default Tag Delimiter' => 'Standard- Tag-Trennzeichen',
	'Default Time Zone' => 'Standard-Zeitzone',
	'Default User Language' => 'Standard-Sprache',
	'Minimum Length' => 'Mindestlänge',
	'New User Defaults' => 'Voreinstellungen für neue Benutzer',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Hinweis: Sie haben noch keine System-E-Mail-Adresse eingerichtet. Benachrichtigungen können daher nicht verschickt werden. Die Adresse kann unter System > Grundeinstellungen eingerichtet werden.',
	'Notify the following system administrators when a commenter registers:' => 'Folgende Systemadministratoren benachrichtigen, wenn sich ein Kommentarautor registriert hat:',
	'Options' => 'Optionen',
	'Password Validation' => 'Passwortregeln',
	'Select system administrators' => 'System-Administrator wählen',
	'Should contain letters and numbers.' => 'Buchstaben und Ziffern erforderlich',
	'Should contain special characters.' => 'Sonderzeichen erforderlich',
	'Should contain uppercase and lowercase letters.' => 'Klein- und Großbuchstaben erforderlich',
	'Space' => 'Leerzeichen',
	'This field must be a positive integer.' => 'Positive ganze Zahl erforderlich.',

## tmpl/cms/cfg_web_services.tmpl
	'(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',
	'Data API Settings' => 'Data-API-Einstellungen',
	'Data API' => 'Data-API',
	'Enable Data API in system scope.' => 'Data-API systemweit aktivieren.',
	'Enable Data API in this site.' => 'Data-API für diese Site aktivieren.',
	'External Notifications' => 'Externe Benachrichtigungen',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Hinweis: Diese Option ist derzeit nicht wirksam, da ausgehende Pings systemweit deaktiviert sind.',
	'Notify ping services of [_1] updates' => 'Ping-Dienste über [_1]-Aktualisierungen benachrichtigen',
	'Others:' => 'Andere:',

## tmpl/cms/content_data/select_list.tmpl
	'No Content Type.' => 'Kein Inhaltstyp.',
	'Select List Content Type' => 'Listen-Inhaltstyp wählen',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to select multiple assets?' => 'Benutzern erlauben, mehrere Assets auszuwählen?',
	'Allow users to upload a new asset?' => 'Benutzern erlauben, neue Assets hochzuladen?',
	'Maximum number of selections' => 'Höchstauswahl',
	'Minimum number of selections' => 'Mindestauswahl',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to upload a new audio asset?' => 'Benutzern erlauben, neue Audio-Dateien hochzuladen?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => 'Benutzern erlauben, mehrere Bilder auszuwählen?',
	'Allow users to upload a new image asset?' => 'Benutzern erlauben, neue Bilder hochzuladen?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => 'Benutzern erlauben, mehrere Videos auszuwählen?',
	'Allow users to upload a new video asset?' => 'Benutzern erlauben, neue Videos hochzuladen?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to create new categories?' => 'Benutzern erlauben, neue Kategorien anzulegen?',
	'Allow users to select multiple categories?' => 'Benutzern erlauben, mehrere Kategorien auszuwählen?',
	'Source Category Set' => 'Quell-Kategorie-Set',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Selected' => 'Ausgewählt',
	'Value' => 'Wert',
	'Values' => 'Werte',
	'add' => 'Hinzufügen',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => 'Benutzern erlauben, mehrere Werte auszuwählen?',
	'Source Content Type' => 'Quell-Inhaltstyp',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'Keine passenden Inhaltstypen gefunden. Legen Sie einen Inhaltstyp an, um Inhaltstyp-Felder verwenden zu können.',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Anfangswert',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Anfangswert (Datum)',
	'Initial Value (Time)' => 'Anfangswert (Uhrzeit)',

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => 'Eingabeformat',
	'Use all rich text decoration buttons' => '', # Translate - New

## tmpl/cms/content_field_type_options/number.tmpl
	'Max Value' => 'Größter Wert',
	'Min Value' => 'Kleinster Wert',
	'Number of decimal places' => 'Anzahl Dezimalstellen',

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Max Length' => 'Größte Länge',
	'Min Length' => 'Kleinste Länge',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Allow users to increase/decrease cols?' => 'Benutzern erlauben, die Anzahl der Spalten zu ändern?',
	'Allow users to increase/decrease rows?' => 'Benutzern erlauben, die Anzahl der Zeilen zu ändern?',
	'Initial Cols' => 'Ursprungsanzahl Spalten',
	'Initial Rows' => 'Ursprungsanzahl Reihen',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to create new tags?' => 'Benutzern erlauben, neue Tags anzulegen?',
	'Allow users to input multiple values?' => 'Benutzern erlauben, mehrere Werte einzugeben?',

## tmpl/cms/content_field_type_options/text_label.tmpl
	'This block is only visible in the administration screen for comments.' => '', # Translate - New
	'__TEXT_LABEL_TEXT' => '', # Translate - New

## tmpl/cms/dashboard/dashboard.tmpl
	'Dashboard' => 'Übersichtsseite',
	'Select a Widget...' => 'Widget wählen...',
	'System Overview' => 'Systemübersicht',
	'Your Dashboard has been updated.' => 'Übersichtsseite aktualisiert.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => 'Zurück (b)',
	'Confirm Publishing Configuration' => 'Veröffentlichungseinstellungen bestätigen',
	'Continue (s)' => 'Weiter (s)',
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Geben Sie die neue Adresse des Archivs Ihrer Untersite an. Beispiel: http://beispiel.de/blog/archiv/',
	'Please choose parent site.' => 'Bitte wählen Sie die übergeordnete Site.',
	'Site Path' => 'Lokaler Pfad',
	'You must select a parent site.' => 'Bitte wählen Sie eine Übergeordnete Site.',
	'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an',
	'You must set a valid local site path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Geben Sie die neue Adresse (URL) Ihrer öffentlichen Untersite mit abschließendem '/' ein. Beispiel: http://beispiel.de/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs ohne abschließendes '/' oder  '\' an. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit \'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},

## tmpl/cms/dialog/asset_edit.tmpl
	'An error occurred.' => 'Es ist ein Fehler aufgetreten.',
	'Close (x)' => 'Schließen (x)',
	'Edit Asset' => 'Asset bearbeiten',
	'Edit Image' => 'Bild bearbeiten',
	'Error creating thumbnail file.' => 'Fehler beim Erstellen des Vorschaubilds',
	'File Size' => 'Dateigröße',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'Die Metadaten dieses Bildes sind nicht lesbar und können daher nicht aktualisiert werden.',
	'Save changes to this asset (s)' => 'Änderungen des Assets speichern (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Dialog wirklich schließen?',
	'Your changes have been saved.' => 'Änderungen gespeichert.',
	'Your edited image has been saved.' => 'Das bearbeitete Bild wurde gespeichert.',

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Asset hinzufügen',
	'Cancel (x)' => 'Abbrechen (x)',
	'Choose Asset' => 'Asset auswählen',
	'Insert (s)' => 'Einfügen (s)',
	'Insert' => 'Einfügen',
	'Library' => 'Bibliothek',
	'Next (s)' => 'Nächstes (s)',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'Neuen Eintrag mit hochgeladener Datei anlegen',
	'Create entry using this uploaded file' => 'Eintrag mit hochgeladener Datei anlegen',
	'File Options' => 'Dateioptionen',
	'Finish (s)' => 'Fertigstellen (s)',
	'Finish' => 'Fertigstellen',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Bitte konfigurieren Sie Ihr Blog.',
	'Your blog has not been published.' => 'Ihr Blog wurde noch nicht veröffentlicht.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Categories/Folders' => 'Kategorien/Ordner',
	'Child Site Details' => 'Details der Untersite',
	'Clone' => 'Klonen',
	'Confirm' => 'Bestätigen',
	'Entries/Pages' => 'Einträge/Seiten',
	'Exclude Categories/Folders' => 'Kategorien/Ordner ausschließen',
	'Exclude Comments' => 'Kommentare ausschließen',
	'Exclude Entries/Pages' => 'Einträge/Seiten ausschließen',
	'Exclude Trackbacks' => 'TrackBacks ausschließen',
	'Exclusions' => 'Ausschließen',
	'This is set to the same URL as the original child site.' => 'Das ist die URL des ursprünglichen Untersite.',
	'This will overwrite the original child site.' => 'Die ursprünglich Untersite wird daher beim Klonen überschrieben.',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => 'Achtung: Eine Änderung der Archiv-Adresse kann alle Links in Ihrer Untersite ungültig machen.',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Achtung: Eine Änderung des Archiv-Pfads kann alle Links in Ihrer Untersite ungültig machen.',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => '[_2] hat am [_1] [_3] kommentiert',
	'Reply to comment' => 'Kommentar beantworten',
	'Submit reply (s)' => 'Abschicken (s)',
	'Your reply:' => 'Ihre Antwort:',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => '[_1] hinzufügen',
	'Choose [_1]' => '[_1] wählen',
	'Create and Insert' => 'Anlegen und einfügen',

## tmpl/cms/dialog/create_association.tmpl
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'In dieser MT-Installation ist kein Blog vorhanden. [_1]Blog anlegen</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'In dieser MT-Installation ist keine Gruppe vorhanden. [_1]Gruppe anlegen</a>',
	'No roles exist in this installation. [_1]Create a role</a>' => 'In dieser MT-Installation ist keine Rolle vorhanden. [_1]Rolle anlegen</a>',
	'No sites exist in this installation. [_1]Create a site</a>' => 'In dieser MT-Installation ist kein Site vorhanden. [_1]Site anlegen</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'In dieser MT-Installation ist kein Benutzer vorhanden. [_1]Benutzer anlegen</a>',
	'all' => 'alle',

## tmpl/cms/dialog/create_trigger.tmpl
	'Event' => 'Ereignis',
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'Wenn <span class="badge source-data-badge">Daten</span> in <span class="badge source-site-badge">Site</span> <span class="badge source-trigger-badge">ausgelöst</span> sind, <span class="badge destination-action-badge">Aktion</span> in <span class="badge destination-site-badge">Site</span> ausführen',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',
	'Object Name' => 'Objektname',
	'Select Trigger Action' => 'Auslöser-Aktion wählen',
	'Select Trigger Event' => 'Auslöser-Ereignis wählen',
	'Select Trigger Object' => 'Auslöser-Objekt wählen',

## tmpl/cms/dialog/edit_image.tmpl
	'Crop' => 'Beschneiden',
	'Flip horizontal' => 'Horizontal spiegeln',
	'Flip vertical' => 'Vertikal spiegeln',
	'Height' => 'Höhe',
	'Keep aspect ratio' => 'Seitenverhältnis beibehalten',
	'Redo' => 'Wiederholen',
	'Remove All metadata' => 'Alle Metadaten entfernen',
	'Remove GPS metadata' => 'GPS-Metadaten entfernen',
	'Rotate left' => 'Nach links drehen',
	'Rotate right' => 'Nach rechts drehen',
	'Save (s)' => 'Sichern (s)',
	'Undo' => 'Rückgängig',
	'Width' => 'Breite',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Ihre Änderungen an diesem Bild wurden noch nicht gespeichert und gehen verloren. Dialog wirklich schließen?',

## tmpl/cms/dialog/entry_notify.tmpl
	'(Body will be sent without any text formatting applied.)' => '(Der Eintragstext wird ohne Textformatierungen verschickt.)',
	'All addresses from Address Book' => 'Alle Adressen aus dem Adressbuch',
	'Enter email addresses on separate lines or separated by commas.' => 'Verwenden Sie pro Adresse eine Zeile oder trennen Sie ei E-Mail-Adressen mit Kommata.',
	'Optional Content' => 'Inhalt (optional)',
	'Optional Message' => 'Nachricht (optional)',
	'Recipients' => 'Empfänger',
	'Send a Notification' => 'Benachrichtigung versenden',
	'Send notification (s)' => 'Benachrichtigung absenden (s)',
	'You must specify at least one recipient.' => 'Bitte geben Sie mindestens einen Empfänger an.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{Benachrichtigungen beinhalten den Namen Ihres Blogs bzw. Ihrer Website, den Titel des und einen Link zum Eintrag. Optional können Sie auch eine eigene Nachricht und/oder einen Auszug des Eintrags oder den gesamten Eintragstext mitschicken.},

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Wählen Sie die gewünschte frühere Version aus.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Display [_1]' => '[_1] anzeigen',
	'Insert Options' => 'Einfüge-Optionen',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Passwort ändern',
	'Change' => 'Ändern',
	'Confirm New Password' => 'Neues Passwort bestätigen',
	'Enter the new password.' => 'Neues Passwort eingeben',
	'New Password' => 'Neues Passwort',
	'The password for the user \'[_1]\' has been recovered.' => '', # Translate - New

## tmpl/cms/dialog/publishing_profile.tmpl
	'All templates published statically via Publish Queue.' => 'Alle Vorlagen im Hintergrund statisch veröffentlichen.',
	'Are you sure you wish to continue?' => 'Wirklich fortsetzen?',
	'Background Publishing' => 'Veröffentlichung im Hintergrund',
	'Choose the profile that best matches the requirements for this [_1].' => 'Wählen Sie das Profil, das Ihren Anforderungen  am besten entspricht.',
	'Dynamic Archives Only' => 'Nur Archiv dynamisch',
	'Dynamic Publishing' => 'Dynamische Veröffentlichung',
	'Execute' => '', # Translate - New
	'High Priority Static Publishing' => 'Priorisierte statische Veröffentlichung',
	'Immediately publish Main Index and Feed template, Entry archives, Page archives and ContentType archives statically. Use Publish Queue to publish all other templates statically.' => '', # Translate - New
	'Immediately publish all templates statically.' => 'Alle Vorlagen sofort statisch veröffentlichen.',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle Archiv-Vorlagen dynamisch, alle anderen Vorlagen sofort statisch veröffentlichen.',
	'Publish all templates dynamically.' => 'Alle Vorlagen dynamisch veröffentlichen.',
	'Publishing Profile' => 'Veröffentlichungsprofil',
	'Static Publishing' => 'Statische Veröffentlichung',
	'This new publishing profile will update your publishing settings.' => 'Das neue Veröffentlichungs-Profil ändert Ihre Veröffentlichungs-Einstellungen.',
	'child site' => 'Untersite',
	'site' => 'Site',

## tmpl/cms/dialog/recover.tmpl
	'Back (x)' => 'Zurück (x)',
	'Reset (s)' => 'Zurücksetzen (s)',
	'Reset Password' => 'Passwort zurücksetzen',
	'Sign in to Movable Type (s)' => 'Bei Movable Type anmelden (s)',
	'Sign in to Movable Type' => 'Bei Movable Type anmelden',
	'The email address provided is not unique.  Please enter your username.' => 'Die angegebene E-Mail-Adresse wird mehrfach genutzt. Bitte geben Sie stattdessen Ihren Benutzernamen ein.',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Kann Vorlagengruppe nicht finden. Bitte wenden Sie das [_1]Thema[_2] an, um Ihre Vorlagen zurückzusetzen.',
	'Deletes all existing templates and installs factory default template set.' => 'Löscht alle vorhandenen Vorlagen und installiert die Movable Type-Standardvorlagen',
	'Make backups of existing templates first' => 'Sichern Sie zuerst Ihre vorhandenen Vorlagen',
	'Refresh Global Templates' => 'Globale Vorlagen zurücksetzen',
	'Refresh global templates' => 'Globale Vorlagen zurücksetzen',
	'Reset to factory defaults' => 'Auf Werkseinstellungen zurücksetzen',
	'Reset to theme defaults' => 'Auf Themen-Standardwerte zurücksetzen',
	'Revert modifications of theme templates' => 'Änderungen an Themen-Vorlagen zurücknehmen',
	'Updates current templates while retaining any user-created templates.' => 'Aktualisiert die derzeit gewählten Vorlagen, ohne von Benutzern angelegte Vorlagen zu verändern',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Sie möchten <strong>eine neue Vorlagengruppe installieren</a>. Das umfasst:',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Sie möchten <strong>die derzeit gewählte Vorlagengruppe zurücksetzen</strong>. Das bedeutet:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Sie möchten <strong>die globalen Vorlagen zurücksetzen</strong>. Das bedeutet:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Sie möchten <strong>auf die globalen Standardvorlagen zurücksetzen</a>. Das bedeutet:',
	'delete all of the templates in your blog' => 'alle Vorlagen Ihres Blogs werden gelöscht',
	'delete all of your global templates' => 'alle globalen Vorlagen werden gelöscht',
	'install new templates from the default global templates' => 'die globalen Standardvorlagen werden neu installiert',
	'install new templates from the selected template set' => 'die gewählte Vorlagengruppe wird neu installiert',
	'make backups of your templates that can be accessed through your backup filter' => 'die vorhandenen Vorlagen werden gesichert und können später wiederhergestellt werden',
	'overwrite some existing templates with new template code' => 'einige vorhandene Vorlagen werden mit neuen Vorlagen überschrieben',
	'potentially install new templates' => 'ggf. werden neue Vorlagen installiert',
	q{Deletes all existing templates and install the selected theme's default.} => q{Alle Vorlagen löschen und Standarvorlagen des gewählten Themas installieren.},

## tmpl/cms/dialog/restore_end.tmpl
	'All data imported successfully!' => 'Alle Daten erfolgreich importiert!',
	'An error occurred during the import process: [_1] Please check your import file.' => 'Während des Importvorgangs ist ein Fehler aufgetreten. Bitte überprüfen Sie Ihre Importdatei.',
	'Close (s)' => 'Schließen (s)',
	'Next Page' => 'Nächste Seite',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Diese Seite leitet in drei Sekunden auf eine neue Seite weiter. [_1]Weiterleitung abbrechen[_2].',
	'View Activity Log (v)' => 'Aktivitätsprotokoll ansehen (v)',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importieren...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Abbrechen führt zu verwaisten Objekten. Wiederherstellung wirklich abbrechen?',
	'Please upload the file [_1]' => 'Bitte laden Sie die Datei [_1] hoch',
	'Restore: Multiple Files' => 'Wiederherstellung mehrerer Dateien',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to group' => 'Gruppe Berechtigungen für diese Site zuweisen',
	'Grant site permission to user' => 'Nutzer Berechtigungen für diese Site zuweisen',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => 'Verwendet in...',
	'Embed Asset' => 'Asset einbetten',
	'Prev' => 'Zurück',
	'Related Assets' => 'Verwandte Assets',
	'Stats' => 'Statistik',
	'This asset has been used by other users.' => 'Das Asset wird von anderen Benutzern verwendet.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Möchten Sie das Bild wirklich bearbeiten?',
	'You have unsaved changes to this asset that will be lost.' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren.',
	'You must specify a name for the asset.' => 'Bitte geben Sie einen Namen für das Asset an.',
	'[_1] - Created by [_2]' => 'Angelegt von [_2] [_1]',
	'[_1] - Modified by [_2]' => '[_1] - Bearbeitet von [_2]',
	'[_1] is missing' => '[_1] fehlt',

## tmpl/cms/edit_author.tmpl
	'(Use Site Default)' => '(Site-Standardwerte verwenden)',
	'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an [_1] verschickt.',
	'Confirm Password' => 'Passwort bestätigen',
	'Create User (s)' => 'Benutzerkonto anlegen (s)',
	'Current Password' => 'Derzeitiges Passwort',
	'Date Format' => 'Zeit- angaben',
	'Default date formatting in the Movable Type interface.' => 'Standard-Datums-Formatierung in der Movable Type-Oberfläche',
	'Default text formatting filter when creating new entries and new pages.' => 'Standard-Textfilter beim Erstellen neuer Seiten und Einträge',
	'Display language for the Movable Type interface.' => 'Anzeigesprache der Movable Type-Benutzeroberfläche',
	'Edit Profile' => 'Profil bearbeiten',
	'Enter preferred password.' => 'Bevorzugtes Passwort eingeben',
	'Error occurred while removing userpic.' => 'Beim Entfernen des Benutzerbildes ist ein Fehler aufgetreten',
	'External user ID' => 'Externe Benutzer-ID',
	'Full' => 'Absolut',
	'Initial Password' => 'Passwort',
	'Initiate Password Recovery' => 'Passwort wiederherstellen',
	'Password recovery word/phrase' => 'Erinnerungssatz',
	'Preferences' => 'Konfigurieren',
	'Preferred method of separating tags.' => 'Bevorzugtes Trennzeichen für Tags',
	'Relative' => 'Relativ',
	'Remove Userpic' => 'Benutzerbild entfernen',
	'Reveal' => 'Anzeigen',
	'Save changes to this author (s)' => 'Kontoänderungen speichern (s)',
	'Select Userpic' => 'Benutzerbild wählen',
	'System Permissions' => 'Berechtigungen',
	'Tag Delimiter' => 'Tag-Trennzeichen',
	'Text Format' => 'Textformatierung',
	'The name displayed when content from this user is published.' => 'Der Name, der zusammen mit Inhalten dieses Benutzers angezeigt werden soll.',
	'This profile has been unlocked.' => 'Benutzerkonto entsperrt',
	'This profile has been updated.' => 'Profil aktualisiert',
	'This user was classified as disabled.' => 'Benutzerkonto deaktiviert.',
	'This user was classified as pending.' => 'Benutzer auf wartend gesetzt.',
	'This user was locked out.' => 'Benutzerkonto gesperrt',
	'User properties' => 'Benutzer-Eigenschaften',
	'Web Services Password' => 'Passwort für Webdienste',
	'You must use half-width character for password.' => 'Bitte verwenden Sie für das Passwort halbbreite Zeichen.',
	'Your web services password is currently' => 'Ihr Passwort für Webdienste lautet derzeit',
	'_USAGE_PASSWORD_RESET' => 'Hier können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufälliges neues Passwort erzeugt und an <strong>[_1]</strong> verschickt werden.',
	'_USER_DISABLED' => 'Deaktiviert',
	'_USER_ENABLED' => 'Aktiviert',
	'_USER_PENDING' => 'Schwebend',
	'_USER_STATUS_CAPTION' => 'Status',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Dazu wird ein zufällig erzeugtes neues Passwort per E-Mail an [_2] verschickt werden.\n\nForsetzen?',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Um dieses Benutzerkonto zu entsperren, klicken Sie auf 'Entsperren'. <a href="[_1]">Entsperren</a>},
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Die Website dieses Benutzers (z.B. https://movabletype.com/). Ist sowohl dieses als auch das Feld &#8222;Anzeigename&#8220; ausgefüllt, erzeugt Movable Type daraus per Voreinstellung einen Link zur angebenen Website und zeigt diesen unter Einträgen und Kommentaren des Benutzers an.},

## tmpl/cms/edit_blog.tmpl
	'Create Child Site (s)' => 'Untersite anlegen (s)',
	'Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Geben Sie die Web-Adresse (URL) Ihrer Untersite ohne Dateinamen (z.B. index.html) ein. Beispiel: http://beispiel.de/',
	'Name your child site. The site name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre Untersite. Sie könnten ihn später jederzeit ändern.',
	'Select the theme you wish to use for this child site.' => 'Wählen Sie das Thema, das Sie für diese Untersite verwenden möchten.',
	'Select your timezone from the pulldown menu.' => 'Zeitzone des Weblogs',
	'Site Theme' => 'Site-Thema',
	'You must set your Local Site Path.' => 'Bitte geben Sie den lokalen Pfad der Site an.',
	'Your child site configuration has been saved.' => 'Die Einstellungen der Untersite wurden gespeichert.',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' or '\' und möglichst in absoluter Form, also am Anfang unter Linux mit '/' oder mit 'C:\' unter Windows. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Allow pings' => 'Pings erlauben',
	'Edit Category' => 'Kategorie bearbeiten',
	'Inbound TrackBacks' => 'TrackBack-Empfang',
	'Manage entries in this category' => 'Einträge in dieser Kategorie verwalten',
	'Outbound TrackBacks' => 'TrackBack-Versand',
	'Passphrase Protection' => 'Passphrasenschutz',
	'Please enter a valid basename.' => 'Bitte geben Sie einen gültigen Basisnamen ein.',
	'Save changes to this category (s)' => 'Kategorieänderungen speichern (s)',
	'This is the basename assigned to your category.' => 'Der dieser Kategorie zugewiesene Basisname',
	'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
	'Trackback URLs' => 'TrackBack-URLs',
	'Useful links' => 'Nützliche Links',
	'View TrackBacks' => 'TrackBacks ansehen',
	'You must specify a basename for the category.' => 'Geben Sie einen Basisnamen für die Kategorie an.',
	'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
	'_CATEGORY_BASENAME' => 'Basisname',
	q{Warning: Changing this category's basename may break inbound links.} => q{Achtung: Änderungen des Basisnamens können bestehende externe Links auf diese Kategorieseite ungültig machen},

## tmpl/cms/edit_comment.tmpl
	'Ban Commenter' => 'Kommentarautor sperren',
	'Comment Text' => 'Kommentartext',
	'Commenter Status' => 'Kommentarautoren-Status',
	'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
	'Manage Comments' => 'Kommentare verwalten',
	'No url in profile' => 'Keine URL im Profil',
	'Reply to this comment' => 'Kommentar beantworten',
	'Reported as Spam' => 'Als Spam gemeldet',
	'Responses to this comment' => 'Reaktionen auf diesen Kommentar',
	'Results' => 'Treffer',
	'Save changes to this comment (s)' => 'Kommentaränderungen speichern (s)',
	'Score' => 'Bewertung',
	'Test' => 'Test',
	'The comment has been approved.' => 'Kommentar freigeschaltet.',
	'This comment was classified as spam.' => 'Kommentar als Spam mariert.',
	'Total Feedback Rating: [_1]' => 'Gesamtbewertung: [_1]',
	'Trust Commenter' => 'Kommentarautor vertrauen',
	'Trusted' => 'vertraut',
	'Unavailable for OpenID user' => 'Nicht verfügbar für OpenID-Nutzer',
	'Unban Commenter' => 'Kommentarautor nicht mehr sperren',
	'Untrust Commenter' => 'Kommentarautor nicht mehr vertrauen',
	'View [_1] comment was left on' => 'Zeige [_1] Kommentar zu',
	'View all comments by this commenter' => 'Alle Kommentare von diesem Kommentarautor anzeigen',
	'View all comments created on this day' => 'Alle Kommentare dieses Tages anzeigen',
	'View all comments from this IP Address' => 'Alle Kommentare von dieser IP-Adresse anzeigen',
	'View all comments on this [_1]' => 'Alle Kommentare zu diesem Eintrag oder dieser Seite',
	'View all comments with this URL' => 'Alle Kommentare mit dieser URL anzeigen',
	'View all comments with this email address' => 'Alle Kommentare von dieser E-Mail-Adresse anzeigen',
	'View all comments with this status' => 'Alle Kommentare mit diesem Status anzeigen',
	'View this commenter detail' => 'Details zum Kommentarautoren anzeigen',
	'[_1] no longer exists' => '[_1] existiert nicht mehr',
	'_external_link_target' => '_blank',
	'comment' => 'Kommentar',
	'comments' => 'Kommentare',

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => 'Authentifiziert',
	'Ban user (b)' => 'Benutzer sperren (b)',
	'Ban' => 'Sperren',
	'Comments from [_1]' => 'Kommentare von [_1]',
	'Identity' => 'Identität',
	'The commenter has been banned.' => 'Dieser Kommentarautor wurde gesperrt.',
	'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentarautoren.',
	'Trust user (t)' => 'Benutzer vertrauen (t)',
	'Trust' => 'Vertrauen',
	'Unban user (b)' => 'Benutzer nicht mehr sperren (b)',
	'Unban' => 'Entsperren',
	'Untrust user (t)' => 'Benutzer nicht mehr vertrauen (t)',
	'Untrust' => 'Nicht vertrauen',
	'View all comments with this name' => 'Alle Kommentare mit diesem Autorennamen anzeigen',
	'View' => 'Ansehen',
	'Withheld' => 'Zurückgehalten',
	'commenter' => 'Kommentarautor',
	'commenters' => 'Kommentarautoren',
	'to act upon' => 'bearbeiten',

## tmpl/cms/edit_content_data.tmpl
	'(Max length: [_1])' => '(Höchstlänge [_1])',
	'(Max select: [_1])' => '(Max [_1] wählen',
	'(Max tags: [_1])' => '(Max [_1] Tags)',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max [_1], [_2] Dezimalstellen)',
	'(Max: [_1])' => '(Max [_1])',
	'(Min length: [_1] / Max length: [_2])' => '(Mindestlänge [_1], Höchstlänge [_2])',
	'(Min length: [_1])' => '(Mindestlänge [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(Min [_1], max [_2] wählen)',
	'(Min select: [_1])' => '(Min [_1] wählen)',
	'(Min tags: [_1] / Max tags: [_2])' => '(Min [_1], max [_2] Tags)',
	'(Min tags: [_1])' => '(Min [_1] Tags)',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min [_1], max [_2], [_3] Dezimalstellen)',
	'(Min: [_1] / Max: [_2])' => '(Min [_1], max [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min [_1], [_2] Dezimalstellen)',
	'(Min: [_1])' => '(Min: [_1])',
	'(Number of decimal places: [_1])' => '([_1] Dezimalstellen)',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Weitere(s) [_2] anlegen?</a>',
	'@' => '@',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Inhaltsdaten automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'An error occurred while trying to recover your saved content data.' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'Auto-saving...' => 'Autospeichern...',
	'Change note' => 'Änderungshinweis',
	'Draft this [_1]' => '[_1] als Entwurf speichern',
	'Enter a label to identify this data' => 'Geben Sie eine Bezeichnung für diese Daten ein',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Zuletzt automatisch gespeichert um [_1]:[_2]:[_3]',
	'No revision(s) associated with this [_1]' => 'Keine Revision(en) mit dieser/diesem [_1] verknüpft',
	'Not specified' => 'Nicht angegeben',
	'One tag only' => '(Genau 1 Tag)',
	'Permalink:' => 'Permalink:',
	'Publish On' => 'Veröffentlichen um',
	'Publish this [_1]' => '[_1] veröffentlichen',
	'Published Time' => 'Zeitpunkt der Veröffentlichung',
	'Revision: <strong>[_1]</strong>' => 'Revision <strong>[_1]</strong>',
	'Save this [_1]' => '[_1] speichern',
	'Schedule' => 'Zeitplan',
	'This [_1] has been saved.' => '[_1] gespeichert.',
	'Unpublish this [_1]' => '[_1] nicht mehr veröffentlichen',
	'Unpublished (Draft)' => 'Unveröffentlicht (Entwurf)',
	'Unpublished (Review)' => 'Unveröffentlicht (Prüfung)',
	'Unpublished (Spam)' => 'Unveröffentlicht (Spam)',
	'Unpublished Date' => 'Zeitpunkt der Zurückziehung',
	'Unpublished Time' => 'Zeitpunkt der Zurückziehung',
	'Update this [_1]' => '[_1] aktualisieren',
	'Update' => 'Aktualisieren',
	'View revisions of this [_1]' => 'Revisionen dieser/dieses [_1] anzeigen',
	'View revisions' => 'Revisionen anzeigen',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	'You have successfully recovered your saved content data.' => 'Gespeicherte Inhaltsdaten erfolgreich wiederhergestellt.',
	'You must configure this site before you can publish this content data.' => '', # Translate - New
	q{Warning: Changing this content data's basename may break inbound links.} => q{Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links ungültig werden},

## tmpl/cms/edit_content_type.tmpl
	'1 or more label-value pairs are required' => 'Mindestens ein Bezeichnung-Wert-Paar erforderlich',
	'Available Content Fields' => 'Verfügbare Inhaltsfelder',
	'Contents type settings has been saved.' => 'Inhaltstyp-Einstellungen gespeichert.',
	'Edit Content Type' => 'Inhaltstyp bearbeiten',
	'Reason' => 'Grund',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'Einige Inhaltsfelder wurden nicht gelöscht. Bitte entfernen Sie zuerst ihre Archiv-Verknüpfungen.',
	'This field must be unique in this content type' => 'Dieses Feld kann in diesem Inhaltstyp nur ein Mal verwendet werden',
	'Unavailable Content Fields' => 'Nicht verfügbare Inhaltsfelder',

## tmpl/cms/edit_entry.tmpl
	'(comma-delimited list)' => '(Liste mit Kommatrennung)',
	'(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Eintrag automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Seite automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'Accept' => 'Annehmen',
	'Add Entry Asset' => 'Eintrags-Asset hinzufügen',
	'Add category' => 'Kategorie hinzufügen',
	'Add new category parent' => 'Neue Eltern-Kategorie hinzufügen',
	'Add new folder parent' => 'Neuen Eltern-Ordner hinzufügen',
	'An error occurred while trying to recover your saved entry.' => 'Bei der Wiederherstellung des gespeicherten Eintrags ist ein Fehler aufgetreten.',
	'An error occurred while trying to recover your saved page.' => 'Bei der Wiederherstellung der gespeicherten Seite ist ein Fehler aufgetreten.',
	'Category Name' => 'Kategoriename',
	'Change Folder' => 'Ordner wechseln',
	'Converting to rich text may result in changes to your current document.' => 'Wandlung in Rich Text kann ihre bisherigen Formatierungen beeinträchtigen.',
	'Create Entry' => 'Neuen Eintrag schreiben',
	'Create Page' => 'Seite anlegen',
	'Delete this entry (x)' => 'Eintrag löschen (x)',
	'Delete this page (x)' => 'Seite löschen (x)',
	'Draggable' => 'Klick- und ziehbar',
	'Edit Entry' => 'Eintrag bearbeiten',
	'Edit Page' => 'Seite bearbeiten',
	'Enter the link address:' => 'Link-Adresse eingeben:',
	'Enter the text to link to:' => 'Link-Text eingeben:',
	'Format:' => 'Formatierung:',
	'Make primary' => 'Als Hauptkategorie',
	'Manage Entries' => 'Einträge verwalten',
	'No assets' => 'Keine Assets',
	'None selected' => 'Keine gewählt',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
	'Outbound TrackBack URLs' => 'TrackBack- URLs',
	'Preview this entry (v)' => 'Vorschau (v)',
	'Preview this page (v)' => 'Vorschau (v)',
	'Reset display options to blog defaults' => 'Anzeigeoptionen auf Standardeinstellungen zurücksetzen',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Version wiederherstellen (Datum: [_1]). Aktueller Status: [_2]',
	'Selected Categories' => '', # Translate - New
	'Share' => 'Teilen',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltene [_1] können nicht geladen werden, da sie entfernt wurden.',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltenen Tags können nicht geladen werden, da sie entfernt wurden.',
	'This entry has been saved.' => 'Eintrag gespeichert.',
	'This page has been saved.' => 'Seite gesichert.',
	'This post was classified as spam.' => 'Dieser Eintrag wurde als Spam erfasst.',
	'This post was held for review, due to spam filtering.' => 'Dieser Eintrag wurde vom Spam-Filter zur Moderation zurückgehalten.',
	'View Entry' => 'Eintrag ansehen',
	'View Page' => 'Seite ansehen',
	'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	'You have successfully deleted the checked TrackBack(s).' => 'Die markierten TrackBacks wurden erfolgreich gelöscht.',
	'You have successfully deleted the checked comment(s).' => 'Die markierten Kommentare wurden erfolgreich gelöscht.',
	'You have successfully recovered your saved entry.' => 'Gespeicherten Eintrag erfolgreich wiederhergestellt.',
	'You have successfully recovered your saved page.' => 'Gespeicherte Seite erfolgreich wiederhergestellt.',
	'You have unsaved changes to this entry that will be lost.' => 'Es liegen nicht gespeicherte Eintragsänderungen vor, die verloren gehen werden.',
	'You must configure this site before you can publish this entry.' => '', # Translate - New
	'You must configure this site before you can publish this page.' => '', # Translate - New
	'Your changes to the comment have been saved.' => 'Kommentaränderungen gespeichert.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Einstellungen gespeichert.',
	'Your notification has been sent.' => 'Benachrichtigung gesendet.',
	'[_1] Assets' => '[_1] Assets',
	'_USAGE_VIEW_LOG' => 'Nähere Informationen zum aufgetretenen Fehler finden Sie im <a href="[_1]">Aktivitätsprotokoll</a>.',
	'edit' => 'Bearbeiten',
	q{(delimited by '[_1]')} => q{(Trennung durch &#8222;[_1]&#8220;)},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links zu diesem Eintrag ungültig werden.},

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Diese [_1] speichern (s)',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Ordner bearbeiten',
	'Manage Folders' => 'Ordner verwalten',
	'Manage pages in this folder' => 'Seiten in diesem Ordner verwalten',
	'Path' => 'Pfad',
	'Save changes to this folder (s)' => 'Ordneränderungen speichern (s)',
	'You must specify a label for the folder.' => 'Sie müssen diesem Ordner eine Bezeichnung geben',

## tmpl/cms/edit_group.tmpl
	'Created By' => 'Erstellt von',
	'Created On' => 'Angelegt',
	'Edit Group' => 'Gruppe bearbeiten',
	'LDAP Group ID' => 'LDAP-Gruppen-ID',
	'Member ([_1])' => 'Mitglied ([_1])',
	'Members ([_1])' => 'Mitglieder ([_1])',
	'Permission ([_1])' => 'Berechtigung ([_1])',
	'Permissions ([_1])' => 'Berechtigungen ([_1])',
	'Save changes to this field (s)' => 'Feld-?nderungen speichern (s)',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'Systemweiter Gruppenstatus. Die Deaktivierung einer Gruppe entzieht ihren Mitgliedern den Zugang zum System. Inhalte und Nutzungsverläufe der Mitglieder bleiben jedoch erhalten.',
	'The LDAP directory ID for this group.' => 'Die ID dieser Gruppe im LDAP-Verzeichnis',
	'The description for this group.' => 'Die Beschreibung dieser Gruppe.',
	'The display name for this group.' => 'Der Anzeigename dieser Gruppe',
	'The name used for identifying this group.' => 'Der zur Idenfifizierung diesser Gruppe verwendete Name',
	'This group profile has been updated.' => 'Gruppenprofil aktualisiert.',
	'This group was classified as disabled.' => 'Gruppe deaktiviert.',
	'This group was classified as pending.' => 'Gruppe auf wartend gesetzt.',

## tmpl/cms/edit_ping.tmpl
	'Category no longer exists' => 'Kategorie nicht mehr vorhanden',
	'Delete this TrackBack (x)' => 'Diesen TrackBack löschen (x)',
	'Edit Trackback' => 'TrackBack bearbeiten',
	'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
	'Manage TrackBacks' => 'TrackBacks verwalten',
	'No title' => 'Kein Name',
	'Save changes to this TrackBack (s)' => 'TrackBack-Änderungen speichern (s)',
	'Search for other TrackBacks from this site' => 'Weitere TrackBacks von dieser Site suchen',
	'Search for other TrackBacks with this status' => 'Weitere TrackBacks mit diesem Status suchen',
	'Search for other TrackBacks with this title' => 'Weitere TrackBacks mit diesem Namen suchen',
	'Source Site' => 'Quelle',
	'Source Title' => 'Quellname',
	'Target Category' => 'Zielkategorie',
	'Target [_1]' => 'Ziel-[_1]',
	'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
	'This trackback was classified as spam.' => 'TrackBack als Spam markiert.',
	'TrackBack Text' => 'TrackBack-Text',
	'View all TrackBacks created on this day' => 'Alle TrackBacks dieses Tages anzeigen',
	'View all TrackBacks from this IP address' => 'Alle TrackBacks von dieser IP-Adrese anzeigen',
	'View all TrackBacks on this category' => 'Alle TrackBacks in dieser Kategorie anzeigen',
	'View all TrackBacks on this entry' => 'Alle TrackBacks bei diesem Eintrag anzeigen',
	'View all TrackBacks with this status' => 'Alle TrackBacks mit diesem Status ansehen',

## tmpl/cms/edit_role.tmpl
	'Administration' => 'Verwalten',
	'Association (1)' => 'Verknüpfung (1)',
	'Associations ([_1])' => 'Verknüpfungen ([_1])',
	'Authoring and Publishing' => 'Schreiben und veröffentlichen',
	'Check All' => '', # Translate - New
	'Commenting' => 'Kommentieren',
	'Content Field Privileges' => '', # Translate - New
	'Content Type Privileges' => 'Berechtigungen für Inhaltstyp',
	'Designing' => 'Gestalten',
	'Duplicate Roles' => 'Rollen duplizieren',
	'Edit Role' => 'Rolle bearbeiten',
	'Privileges' => 'Berechtigungen',
	'Role Details' => 'Rolleneigenschaften',
	'Save changes to this role (s)' => 'Rollenänderungen speichern (s)',
	'Uncheck All' => '', # Translate - New
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Sie haben die Berechtigungen dieser Rolle geändert. Dadurch werden auch die Berechtigungen der mit dieser Rolle verknüpften Benutzer beeinflusst. Wenn Sie möchten, können Sie daher die Rolle unter neuem Namen speichern.',

## tmpl/cms/edit_template.tmpl
	': every ' => ': alle ',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'Vorlage <a href="[_1]" class="rebuild-link">veröffentlichen</a>.',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => '[_1] automatisch gespeichert [_3]. <a href="[_2]">Automatisch gespeicherte Fassung wiederherstellen</a>',
	'An error occurred while trying to recover your saved [_1].' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'Archive map has been successfully updated.' => 'Archiv-Verknüpfung erfolgreich aktualisiert.',
	'Are you sure you want to remove this template map?' => 'Archiv-Verknüpfung wirklich löschen?',
	'Category Field' => 'Kategorie-Feld',
	'Code Highlight' => 'Code farbig darstellen',
	'Content field' => 'Inhaltsfeld',
	'Copy Unique ID' => 'Eindeutige ID kopieren',
	'Create Archive Mapping' => 'Neue Archiv-Verknüpfung einrichten',
	'Create Content Type Archive Template' => 'Vorlage für Inhaltstyp-Archiv anlegen',
	'Create Content Type Listing Archive Template' => 'Vorlage für Inhaltstyp-Listenarchiv anlegen',
	'Create Entry Archive Template' => 'Vorlage für Eintrags-Archiv anlegen',
	'Create Entry Listing Archive Template' => 'Vorlage für Eintrags-Listenarchiv anlegen',
	'Create Index Template' => 'Indexvorlage anlegen',
	'Create Page Archive Template' => 'Vorlage für Seiten-Archiv anlegen',
	'Create Template Module' => 'Vorlagenmodul anlegen',
	'Create a new Content Type?' => 'Neuen Inhaltstyp anlegen?',
	'Custom Index Template' => 'Individuelle Indexvorlage',
	'Date & Time Field' => 'Datums-/Uhrzeit-Feld',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deaktiviert (<a href="[_1]">Veröffentlichungsoptionen ändern</a>)',
	'Do Not Publish' => 'Nicht veröffentlichen',
	'Dynamically' => 'Dynamisch',
	'Edit Widget' => 'Widget bearbeiten',
	'Error occurred while updating archive maps.' => 'Bei der Aktualisierung der Archiv-Verknüpfungen ist ein Fehler aufgetreten.',
	'Expire after' => 'Verfallen lassen nach',
	'Expire upon creation or modification of:' => 'Verfallen lassen bei Anlage oder Änderung von:',
	'Include cache path' => 'Include Cache-Pfad',
	'Included Templates' => 'Eingebundene Vorlagen',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">Mehr über Veröffentlichungs-Einstellungen erfahren</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => '<a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Mehr über das Erstellen von Archivpfaden erfahren',
	'Link to File' => 'Mit Datei verlinken',
	'List [_1] templates' => 'Zeige [_1]-Vorlagen',
	'List all templates' => 'Zeige alle Vorlagen',
	'Manually' => 'Manuell',
	'Module Body' => 'Modul-Code',
	'Module Option Settings' => 'Moduloption-Einstellungen',
	'New Template' => 'Neuer Vorlage',
	'No caching' => 'Keine Caching',
	'No revision(s) associated with this template' => 'Keine Revision(en) mit dieser Vorlage verknüpft',
	'On a schedule' => 'Zeitgeplant',
	'Process as <strong>[_1]</strong> include' => 'Als <strong>[_1]</strong>-Include verarbeiten',
	'Processing request...' => 'Verarbeite Anfrage...',
	'Restored revision (Date:[_1]).' => 'Revision wiederhergestellt (Datum: [_1])',
	'Save &amp; Publish' => 'Speichern und veröffentlichen',
	'Save Changes (s)' => 'Änderungen speichern (s)',
	'Save and Publish this template (r)' => 'Vorlage speichern und veröffentlichen (r)',
	'Select Content Field' => 'Inhaltsfeld wählen',
	'Server Side Include' => 'Server Side Include',
	'Statically (default)' => 'Statisch (Standard)',
	'Template Body' => 'Vorlagen-Code',
	'Template Type' => 'Vorlagen-Typ',
	'Useful Links' => 'Nützliche Links',
	'Via Publish Queue' => 'Im Hintergrund',
	'View Published Template' => 'Veröffentlichte Vorlage ansehen',
	'View revisions of this template' => 'Revisionen dieser Vorlage anzeigen',
	'You have successfully recovered your saved [_1].' => 'Gespeicherte Fassung erfolgreich wiederhergestellt.',
	'You have unsaved changes to this template that will be lost.' => 'Es liegen nicht gespeicherte Vorlagenänderungen, die verloren gehen werden.',
	'You must select the Content Type.' => 'Bitte wählen Sie einen Inhaltstyp.',
	'You must set the Template Name.' => 'Bitte geben Sie einen Vorlagennamen ein.',
	'You must set the template Output File.' => 'Bitte geben Sie Namen für die Ausgabedatei ein.',
	'Your [_1] has been published.' => '[_1] wurde veröffentlicht.',
	'create' => 'anlegen',
	'hours' => 'Stunden',
	'minutes' => 'Minuten',

## tmpl/cms/edit_website.tmpl
	'Create Site (s)' => 'Site anlegen (s)',
	'Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Geben Sie die Web-Adresse (URL) Ihrer Site ohne Dateinamen (z.B. index.html) ein. Beispiel: http://beispiel.com/',
	'Name your site. The site name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre SIte. Sie können ihn später jederzeit ändern.',
	'Please enter a valid URL.' => 'Bitte geben Sie eine gültige Adresse ein.',
	'Please enter a valid site path.' => 'Bitte geben Sie einen gültigen Site-Pfad ein.',
	'Select the theme you wish to use for this site.' => 'Wählen Sie das Thema, das Sie für diese Site verwenden möchten.',
	'This field is required.' => 'Feld erforderlich.',
	'You did not select a timezone.' => 'Bitte wählen Sie einen Zeitzone',
	'Your site configuration has been saved.' => 'Die Site-Einstellungen wurden gespeichert.',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Geben Sie den Pfad an, unter dem die Startseiten-Datei abgelegt werden soll. Optimal ist eine Angabe in absoluter Form, also unter Linux mit '/' oder unter Windows mit 'C:\' am Anfang, aber eine relative Angabe ist auch möglich. Beispiel: /home/melody/public_html/ oder C:\www\public_htm},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => 'Verfügbare Widgets',
	'Edit Widget Set' => 'Widgetgruppe bearbeiten',
	'Installed Widgets' => 'Installierte Widgets',
	'Save changes to this widget set (s)' => 'Widgetänderungen speichern (s)',
	'Widget Set Name' => 'Name der Widgetgruppe',
	'You must set Widget Set Name.' => 'Bitte wählen Sie einen Namen für die Widgetgruppe.',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Ziehen Sie die Widgets, die in diese Widgetgruppe gehören, in die Spalte &#8222;Installierte Wigets&#8220;.},

## tmpl/cms/error.tmpl
	'An error occurred' => 'Es ist ein Fehler aufgetreten',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => '[_1] Einträge exportieren',
	'Export [_1]' => '[_1] exportieren',
	'[_1] to Export' => 'Zu exportierende [_1]',
	'_USAGE_EXPORT_1' => 'Hier können Sie die Einträge, Kommentare und TrackBacks eines Blogs exportieren. Ein Export stellt <em>keine</em> komplette Sicherung eines Blogs dar. Verwenden Sie dafür die Funktion Sichern/Wiederherstellen.',

## tmpl/cms/export_theme.tmpl
	'Author link' => 'Autoren-Link',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Basisnamen müssen mit einem Buchstaben anfangen und dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Destination' => 'Ziel',
	'Setting for [_1]' => 'Einstellungen für [_1]',
	'Theme package have been saved.' => 'Themenpaket gespeichert.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Versionsnamen dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Version' => 'Version',
	'You must set Theme Name.' => 'Bitte geben Sie einen Namen für das Thema ein.',
	'_THEME_AUTHOR' => 'Autor',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Das Thema kann nicht mit diesem Basisnamen installiert, da dieser bereits vorhanden und geschützt ist.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Verwenden Sie bitte nur Buchstaben, Zahlen, Bindestriche oder Unterstriche (a-z, A-Z, 0-9, &#8222;-&#8220; oder &#8222;_&#8220;).},

## tmpl/cms/field_html/field_html_asset.tmpl
	'Assets greater than or equal to [_1] must be selected' => 'Wählen Sie mindestens [_1] Assets',
	'Assets less than or equal to [_1] must be selected' => 'Wählen Sie höchstens [_1] Assets',
	'No Asset' => 'Kein Asset',
	'No Assets' => 'Keine Assets',
	'Only 1 asset can be selected' => 'Wählen Sie genau ein Asset',

## tmpl/cms/field_html/field_html_categories.tmpl
	'Add sub category' => 'Unterkategorie hinzufügen',
	'This field is disabled because valid Category Set is not selected in this field.' => 'Dieses Feld ist deaktiviert, da kein gültiges Kategorie-Set gewählt wurde.',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No [_1]' => 'Kein [_1]',
	'No field data.' => 'Keine Feld-Daten.',
	'Only 1 [_1] can be selected' => 'Wählen Sie genau ein [_1]',
	'This field is disabled because valid Content Type is not selected in this field.' => 'Dieses Feld ist deaktivieren, da kein gültiger Inhaltstyp gewählt wurde.',
	'[_1] greater than or equal to [_2] must be selected' => 'Wählen Sie mindestens [_1] [_2]',
	'[_1] less than or equal to [_2] must be selected' => 'Wählen Sie höchstens [_1] [_2]',

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'Nicht ausgewählt',

## tmpl/cms/field_html/field_html_table.tmpl
	'All possible cells should be selected so to merge cells into one' => '', # Translate - New
	'Cell is not selected' => '', # Translate - New
	'Only one cell should be selected' => '', # Translate - New
	'Source' => '', # Translate - New
	'align center' => '', # Translate - New
	'align left' => '', # Translate - New
	'align right' => '', # Translate - New
	'change to td' => '', # Translate - New
	'change to th' => '', # Translate - New
	'insert column on the left' => '', # Translate - New
	'insert column on the right' => '', # Translate - New
	'insert row above' => '', # Translate - New
	'insert row below' => '', # Translate - New
	'merge cell' => '', # Translate - New
	'remove column' => '', # Translate - New
	'remove row' => '', # Translate - New
	'split cell' => '', # Translate - New
	q{The top left cell's value of the selected range will only be saved. Are you sure you want to continue?} => q{}, # Translate - New
	q{You can't paste here} => q{}, # Translate - New
	q{You can't split the cell anymore} => q{}, # Translate - New

## tmpl/cms/import.tmpl
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Apply this formatting if text format is not set on each entry.' => 'Diese Formatierung verwenden wenn Format nicht in jedem Eintrag einzeln angegeben',
	'Default category for entries (optional)' => 'Standard-Kategorie für Einträge (optional)',
	'Default password for new users:' => 'Standard-Passwort für neue Benutzer:',
	'Enter a default password for new users.' => 'Geben Sie ein Standard-Passwort für neue Benutzer ein.',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Benutzernamen importieren und einer oder mehrere der Benutzer in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
	'Import Entries (s)' => 'Einträge importieren (s)',
	'Import Entries' => 'Einträge importieren',
	'Import File Encoding' => 'Zeichenkodierung der Importdatei',
	'Import [_1] Entries' => '[_1] Einträge importieren',
	'Import as me' => 'Einträge unter meinem Namen importieren',
	'Importing from' => 'Importieren aus',
	'Ownership of imported entries' => 'Besitzer importierter Einträge',
	'Preserve original user' => 'Einträge unter ursprünglichen Namen importieren',
	'Select a category' => 'Kategorie auswählen...',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Übernehmen Sie mit der Import-Funktion Einträge aus anderen Movable-Type-Installationen oder sogar anderen Blog-Systemen. Exportieren Sie Ihre Einträge, um ein Backup oder eine Kopie anzulegen.',
	'Upload import file (optional)' => 'Import-Datei hochladen (optional)',
	'You must select a site to import.' => 'Wählen Sie die zu importierende Site',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Alle importierten Einträge werden Ihnen zugewiesen werden. Wenn Sie möchten, daß die Einträge ihren ursprünglichen Benutzern zugewiesen bleiben, lassen Sie den Import von Ihren Administrator durchführen. Dann werden etwaige erforderliche, aber noch fehlende Benutzerkonten automatisch angelegt.',

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => 'Standard-Eintragsstatus (optional)',
	'End title HTML (optional)' => 'HTML-Code am Überschriftenende (optional)',
	'Select an entry status' => 'Eintragsstatus wählen',
	'Start title HTML (optional)' => 'HTML-Code am Überschriftenanfang (optional)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Kommentare von unbekannten und nicht authentifizierten Benutzern annehmen.',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Wenn diese Option aktiv ist, müssen Kommentarautoren eine gültige E-Mail-Adresse angeben.',
	'Require name and E-mail Address for Anonymous Comments' => 'E-Mail-Adresse von nicht registrierten Kommentarautoren verlangen',

## tmpl/cms/include/archetype_editor.tmpl
	'Begin Blockquote' => 'Zitat Anfang',
	'Bold' => 'Fett',
	'Bulleted List' => 'Aufzählung',
	'Center Item' => 'Zentieren',
	'Center Text' => 'Zentrierter Text',
	'Check Spelling' => 'Rechtschreibung prüfen',
	'Decrease Text Size' => 'Kleinerer Text',
	'Email Link' => 'E-Mail-Link',
	'End Blockquote' => 'Zitat Ende',
	'HTML Mode' => 'HTML-Modus',
	'Increase Text Size' => 'Größerer Text',
	'Insert File' => 'Datei einfügen',
	'Insert Image' => 'Bild einfügen',
	'Italic' => 'Kursiv',
	'Left Align Item' => 'Linksbündig',
	'Left Align Text' => 'Linksbündiger Text',
	'Numbered List' => 'Nummerierte Liste',
	'Right Align Item' => 'Rechtsbündig',
	'Right Align Text' => 'Rechtsbündiger Text',
	'Text Color' => 'Textfarbe',
	'Underline' => 'Unterstreichen',
	'WYSIWYG Mode' => 'Grafischer Editor',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Einklappen',
	'Preferred' => '', # Translate - New

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'Nein',
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Eine Datei namens &#8222;[_1]&#8220; ist bereits vorhanden. Möchten Sie sie überschreiben?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'Asset fehlt',
	'Delete selected assets (x)' => 'Gewählte Assets löschen (x)',
	'No thumbnail image' => 'Kein Vorschaubild',
	'Size' => 'Größe',

## tmpl/cms/include/asset_upload.tmpl
	'Choose Folder' => 'Ordner wählen',
	'Select File to Upload' => 'Hochzuladende Datei wählen',
	'Upload (s)' => 'Hochladen (s)',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Um Dateien hochladen zu können, muss Ihr System- oder [_1]-Administrator die Site bzw. das Blog bereits veröffentlicht haben. Bitte kontaktieren Sie daher ihren System- oder [_1]-Administrator.',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] enthält Zeichen, die nicht für Ordnernamen verwendet werden dürfen: [_2]',
	'_USAGE_UPLOAD' => 'Dateien können auch in Unterverzeichnisse des gewählten Pfads hochgeladen werden. Existiert das Unterverzeichnis noch nicht, wird es automatisch angelegt.',
	q{Asset file('[_1]') has been uploaded.} => q{Asset-Datei (&#8222;[_1]&#8220;) hochgeladen.},
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Veröffentlichen Sie zuerst Ihr(e) [_1], um Dateien hochladen zu können. [_2]Konfigurieren Sie die jeweiligen Veröffentlichungs-Pfade[_3] und veröffentlichen Sie die Site bzw. das Blog dann erneut. },
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Auf '[_1]' kann nicht geschrieben werden. Sie können Bilder hochladen, aber es werden keine Vorschaubilder erzeugt.},

## tmpl/cms/include/async_asset_list.tmpl
	'All Types' => 'Alle Arten',
	'Asset Type: ' => 'Asset-Art:',
	'label' => 'Bezeichnung',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose file to upload or drag file.' => 'Hochzuladende Datei hierher ziehen oder Datei auswählen.',
	'Choose file to upload.' => 'Hochzuladende Datei auswählen',
	'Choose files to upload or drag files.' => 'Hochzuladende Dateien hierher ziehen oder Dateien auswählen.',
	'Choose files to upload.' => 'Hochzuladende Dateien auswählen.',
	'Drag and drop here' => 'Hierhin ziehen und ablegen',
	'Operation for a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'Upload Options' => 'Hochlade-Optionen',
	'Upload Settings' => 'Hochlade-Einstellungen',

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => 'Gewählte Benutzerkonten deaktivieren (d)',
	'Enable selected users (e)' => 'Gewählte Benutzerkonten aktivieren (e)',
	'_NO_SUPERUSER_DISABLE' => 'Sie können Ihr eigenes Benutzerkonto nicht deaktivieren, da Sie Verwalter dieser Movable Type-Installation sind.',
	'_USER_DISABLE' => 'Deaktivieren',
	'_USER_ENABLE' => 'Aktivieren',
	'user' => 'Benutzer',
	'users' => 'Benutzer',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => 'Alle Daten erfolgreich exportiert!',
	'An error occurred during the export process: [_1]' => 'Beim Exportieren ist ein Fehler aufgetreten: [_1]',
	'Download This File' => 'Diese Datei herunterladen',
	'Download: [_1]' => 'Herunterladen: [_1]',
	'Export Files' => 'Dateien exportieren',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'Der Download der Sicherungsdatei wird in einigen Sekunden automatisch beginnen. Sollte das nicht der Fall sein, klicken Sie <a href="javascript:(void)" onclick="submit_form()">hier</a> um den Download manuell zu starten. Pro Sitzung kann eine Sicherungsdatei nur einmal heruntergeladen werden.',
	'_BACKUP_TEMPDIR_WARNING' => 'Gewünschte Daten erfolgreich im Ordner [_1] gesichert. Bitte laden Sie die angegebenen Dateien <strong>sofort</strong> aus [_1] herunter und <strong>löschen</strong> Sie sie unmittelbar danach aus dem Ordner, da sie sensible Informationen enthalten.',

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Exportiere Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'[_1] and [_2]' => '[_1] und [_2]',
	'[_1] hours' => '[_1] Stunden',
	'_FILTER_DATE_DAYS' => '[_1] Tage',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'__INTEGER_FILTER_EQUAL' => 'ist',
	'__INTEGER_FILTER_NOT_EQUAL' => 'ist nicht',
	'__STRING_FILTER_EQUAL' => 'ist',
	'__TIME_FILTER_HOURS' => 'ist innerhalb der letzten',
	'contains' => 'enthält',
	'does not contain' => 'enthält nicht',
	'ends with' => 'endet auf',
	'is after now' => 'ist nach jetzt',
	'is after' => 'ist nach',
	'is before now' => 'ist vor jetzt',
	'is before' => 'ist vor',
	'is between' => 'ist zwischen',
	'is blank' => 'ist leer',
	'is greater than or equal to' => 'ist größer als oder gleich',
	'is greater than' => 'ist größer als',
	'is less than or equal to' => 'ist kleiner als oder gleich',
	'is less than' => 'ist kleiner als',
	'is not blank' => 'ist nicht leer',
	'is within the last' => 'ist in den letzten',
	'starts with' => 'beginnt mit',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Markierte [_1] löschen (x)',
	'Some sites were not deleted. You need to delete child sites under the site first.' => 'Einige Sites wurden nicht gelöscht. Bitte löschen Sie zuerst alle Untersites.',
	'Some templates were not refreshed.' => 'Einige Vorlagen wurden nicht zurückgesetzt.',
	'[_1] Name' => '[_1] Name',

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'Neuer Unterordner',

## tmpl/cms/include/comment_table.tmpl
	'([quant,_1,reply,replies])' => '([quant,_1,Antwort,Antworten])',
	'Blocked' => 'Gesperrt',
	'Delete selected comments (x)' => 'Gewählte Kommentare löschen (x)',
	'Edit this [_1] commenter' => '[_1] Kommentarautor bearbeiten',
	'Edit this comment' => 'Kommentar bearbeiten',
	'Publish selected comments (a)' => 'Gewählte Kommentare veröffentlichen (a)',
	'Search for all comments from this IP address' => 'Nach Kommentaren von dieser IP-Adresse suchen',
	'Search for comments by this commenter' => 'Nach Kommentaren von diesem Kommentarautor suchen',
	'View this entry' => 'Diesen Eintrag ansehen',
	'View this page' => 'Diese Seite ansehen',
	'to republish' => 'zur erneuten Veröffentlichung',

## tmpl/cms/include/commenter_table.tmpl
	'Edit this commenter' => 'Kommentarautor bearbeiten',
	'Last Commented' => 'Zuletzt kommentiert',
	'View this commenter&rsquo;s profile' => 'Profil des Kommentarautors ansehen',

## tmpl/cms/include/content_data_table.tmpl
	'Created' => 'Angelegt',
	'Republish selected [_1] (r)' => 'Gewählte [_1] erneut veröffentlchen (r)',
	'Unpublish' => 'Nicht mehr veröffentlichen',
	'View Content Data' => 'Inhaltsdaten anzeigen',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Alle Rechte vorbehalten.',

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => 'Jetzt <a href="[_1]" class="alert-link">einen Eintrag anlegen</a>.',
	'Last Modified' => 'Zuletzt geändert',
	'No entries could be found.' => 'Keine Einträge gefunden.',
	'No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.' => 'Keine Seiten gefunden. Jetzt <a href="[_1]" class="alert-link">eine Seite anlegen</a>.',
	'View entry' => 'Eintrag ansehen',
	'View page' => 'Seite ansehen',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Passwort für Webdienste wählen',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'BETA' => 'BETA',
	'DEVELOPER PREVIEW' => 'ENTWICKLER-VORSCHAU',
	'Forums' => 'Foren',
	'MovableType.org' => 'MovableType.org',
	'Send Us Feedback' => 'Feedback senden',
	'Support' => 'Support',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Das ist eine Alpha-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Das ist eine Beta-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org/',
	'https://www.movabletype.org' => 'https://www.movabletype.org',
	'with' => 'mit',

## tmpl/cms/include/group_table.tmpl
	'Disable selected group (d)' => 'Gew?hlte Gruppe deaktivieren (d)',
	'Enable selected group (e)' => 'Gew?hlte Gruppe aktivieren (e)',
	'Remove selected group (d)' => 'Gew?hlte Gruppe entfernen (d)',
	'group' => 'Gruppe',
	'groups' => 'Gruppen',

## tmpl/cms/include/header.tmpl
	'Help' => 'Hilfe',
	'Search (q)' => 'Suche (q)',
	'Search [_1]' => '[_1] suchen',
	'Select an action' => 'Aktion wählen',
	'from Revision History' => 'aus der Revisionshistorie',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Diese Website wurde bei der Aktualisierung der Movable Type-Installation automatisch angelegt. Wurzelverzeichnis und Adresse wurden nicht dabei festgelegt, damit die Pfade der mit früheren Movable-Type-Versionen erstellten Blogs gültig bleiben. Sie können in den vorhandenen Blogs wie gewohnt Einträge veröffentlichen, nicht aber die Website selbst veröffentlichen, solange die genannten Felder noch leer sind.},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => 'Lege Benutzerkonten für jeden Benutzer des [_1] an...',
	'Importing entries into [_1]' => 'Importiere Einträge...',
	q{Importing entries as user '[_1]'} => q{Importiere Einträge als Benutzer &#8222;[_1]&#8220;...},

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Ausführen',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => 'Gehe zu [_1]',
	'Sorry, there is no data for this object set.' => 'Keine Daten für diese Objekte vorhanden.',
	'Sorry, there were no results for your search. Please try searching again.' => 'Keine Treffer. Bitte suchen Sie erneut.',
	'Step [_1] of [_2]' => 'Schritt [_1] von [_2]',

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP: [_1]',
	'No log records could be found.' => 'Keine Protokolleinträge gefunden.',
	'_LOG_TABLE_BY' => 'Von',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Benutzername speichern?',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Die [_1] gewählten wirklich aus dieser [_2] entfernen?',
	'Are you sure you want to remove the selected user from this [_1]?' => 'Die gewählten Benutzerkonten wirklich aus [_1] entfernen?',
	'Remove selected user(s) (r)' => 'Gewählte(n) Benutzer entfernen (r)',
	'Remove this role' => 'Rolle entfernen',

## tmpl/cms/include/mobile_global_menu.tmpl
	'PC View' => 'Desktop-Ansicht',
	'Select another child site...' => 'Andere Untersite wählen...',
	'Select another site...' => 'Andere Site wählen...',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Hinzugefügt am',
	'Save changes' => 'Änderungen speichern',

## tmpl/cms/include/old_footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> Version [_2]',
	'Wiki' => 'Wiki',
	'Your Dashboard' => 'Ihre Übersichtsseite',
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	q{_LOCALE_CALENDAR_HEADER_} => q{'So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'},

## tmpl/cms/include/pagination.tmpl
	'First' => 'Anfang',
	'Last' => 'Ende',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'TrackBack bearbeiten',
	'From' => 'Von',
	'Go to the source entry of this TrackBack' => 'Eintrag, auf den sich das TrackBack bezieht, aufrufen',
	'Moderated' => 'Moderiert',
	'Publish selected [_1] (p)' => 'Markierte [_1] veröffentlichen (p)',
	'Target' => 'Nach',
	'View the [_1] for this TrackBack' => '[_1] zu diesem TrackBack ansehen',

## tmpl/cms/include/primary_navigation.tmpl
	'Close Site Menu' => 'Site-Menü schließen',
	'Open Panel' => 'Panel öffnen',
	'Open Site Menu' => 'Site-Menü öffnen',

## tmpl/cms/include/revision_table.tmpl
	'*Deleted due to data breakage*' => '*Wegen Datenbruch gelöscht*',
	'No revisions could be found.' => 'Keine Revisionen vorhanden',
	'Note' => 'Hinweis',
	'Saved By' => 'Gesichert von',
	'_REVISION_DATE_' => 'Datum',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz-Meldung',

## tmpl/cms/include/scope_selector.tmpl
	'(on [_1])' => '(auf [_1])',
	'Create Blog (on [_1])' => 'Blog anlegen (auf [_1])',
	'Create Website' => 'Website anlegen',
	'Select another blog...' => 'Anderes Blog wählen',
	'Select another website...' => 'Andere Website wählen...',
	'User Dashboard' => 'Benutzer-Übersichtsseite',
	'Websites' => 'Websites',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Edited by [_2]' => '[_1] - Bearbeitet von [_2]',
	'[_1] - Published by [_2]' => '[_1] - Veröffentlicht von [_2]',

## tmpl/cms/include/template_table.tmpl
	'Archive Path' => 'Archivpfad',
	'Cached' => 'Gecacht',
	'Create Archive Template:' => 'Archiv-Vorlage anlegen:',
	'Dynamic' => 'Dynamisch',
	'Manual' => 'Manuell',
	'No content type could be found.' => 'Keine Inhaltstypen gefunden.',
	'Publish Queue' => 'Im Hintergrund',
	'Publish selected templates (a)' => 'Gewählte Vorlagen veröffentlichen (a)',
	'SSI' => 'SSI',
	'Static' => 'Statisch',
	'Uncached' => 'Nicht gecacht',
	'templates' => 'Vorlagen',
	'to publish' => 'zu veröffentlichen',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">Blog-URL<mt:else>Site-URL</mt:if>',
	'Folder Name' => 'Ordnername',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'Dateien dieser Typen werden in das Thema aufgenommen: [_1]. Dateien anderen Typs werden ignoriert.',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Geben Sie die Verzeichnisse ab Wurzelverzeichnis der Site an, die statische Dateien des Themas enthalten, z.B. css, images, js usw. Verwenden Sie pro Verzeichnis eine Zeile.',
	'Specify directories' => 'Verzeichnis angeben',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] enthalten',
	'modules' => 'Module',
	'widget sets' => 'Widgetgruppen',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Legen Sie Ihr Benutzerkonto an',
	'Do you want to proceed with the installation anyway?' => 'Möchten Sie die Installation dennoch fortsetzen?',
	'Finish install (s)' => 'Installation abschließen (s)',
	'Finish install' => 'Installation abschließen',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Legen Sie nun ein Administratoren-Konto für Ihr System an. Movable Type wird daraufhin Ihre Datenbank initialisieren.',
	'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
	'System Email' => 'System- E-Mail-Adresse',
	'The display name is required.' => 'Anzeigename erforderlich',
	'The e-mail address is required.' => 'Bitte geben Sie Ihre E-Mail-Adresse an.',
	'The initial account name is required.' => 'Benutzername erforderlich',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Um fortfahren zu können, müssen Sie sich gegenüber Ihrem LDAP-Server authentifizieren',
	'Use this as system email address' => 'Diese Adresse als System-E-Mail-Adresse verwenden',
	'View MT-Check (x)' => 'MT-Check anzeigen (x)',
	'Welcome to Movable Type' => 'Willkommen zu Movable Type',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Wir empfehlen dringend, die Perl-Installation mindestens auf Version [_1] zu aktualisieren. Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>.',

## tmpl/cms/layout/dashboard.tmpl
	'Reload' => 'Neu laden',
	'reload' => 'neu laden',

## tmpl/cms/list_category.tmpl
	'Add child [_1]' => 'Unter-[_1] hinzufügen',
	'Alert' => 'Hinweis',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => '[_1] [_2] mit [_3] Unter-[_4] wirklich entfernen?',
	'Are you sure you want to remove [_1] [_2]?' => '[_1] [_2] wirklich entfernen?',
	'Basename is required.' => 'Basisname erforderlich.',
	'Change and move' => 'Ändern und verschieben',
	'Duplicated basename on this level.' => 'Basisname auf dieser Ebene bereits vorhanden.',
	'Duplicated label on this level.' => 'Bezeichnung auf dieser Ebene bereits vorhanden.',
	'Invalid Basename.' => 'Basisname ungültig.',
	'Label is required.' => 'Bezeichnung erforderlich.',
	'Label is too long.' => 'Bezeichnung zu lang.',
	'Remove [_1]' => '[_1] löschen',
	'Rename' => 'Umbenennen',
	'Top Level' => 'Hauptebene',
	'[_1] label' => 'Bezeichnung',
	q{[_1] '[_2]' already exists.} => q{[_1] &#8222;[_2]&#8220; bereits vorhanden.},

## tmpl/cms/list_common.tmpl
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Feed' => 'Feed',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Eintragsfeed',
	'Pages Feed' => 'Seitenfeed',
	'Quickfilters' => 'Schnellfilter',
	'Recent Users...' => 'Aktuelle Benutzer...',
	'Remove filter' => 'aufheben',
	'Select A User:' => 'Benutzerkonto wählen: ',
	'Select...' => 'Wählen...',
	'Show only entries where' => 'Zeige nur Einträge mit',
	'Show only pages where' => 'Zeige nur Seiten mit',
	'Showing only: [_1]' => 'Zeige nur: [_1]',
	'The entry has been deleted from the database.' => 'Eintrag aus der Datenbank gelöscht.',
	'The page has been deleted from the database.' => 'Seite aus der Datenbank gelöscht.',
	'User Search...' => 'Benutzer suchen...',
	'[_1] (Disabled)' => '[_1] (deaktiviert)',
	'[_1] where [_2] is [_3]' => '[_1] mit [_2] [_3]',
	'asset' => 'Asset',
	'change' => 'ändern',
	'is' => ' ',
	'published' => 'veröffentlicht',
	'review' => 'zur Überprüfung',
	'scheduled' => 'zeitgeplant',
	'spam' => 'Spam',
	'status' => 'Status',
	'tag (exact match)' => 'Tag (genau)',
	'tag (fuzzy match)' => 'Tag (unscharf)',
	'unpublished' => 'nicht veröffentlicht',

## tmpl/cms/list_template.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Name der Widgetgruppe&quot;$&gt;</strong>',
	'Content Type Listing Archive' => 'Inhaltstyp-Listenarchiv',
	'Content type Templates' => 'Inhaltstyp-Vorlagen',
	'Create new template (c)' => 'Neue Vorlage anlegen (c)',
	'Create' => 'Anlegen',
	'Delete selected Widget Sets (x)' => 'Gewählte Widget-Gruppen löschen (x)',
	'Entry Archive' => 'Eintrags-Archiv',
	'Entry Listing Archive' => 'Eintrags-Listenarchiv',
	'Helpful Tips' => 'Nützliche Hinweise',
	'No widget sets could be found.' => 'Keine Widgetgruppen gefunden.',
	'Page Archive' => 'Seiten-Archiv',
	'Publishing Settings' => 'Veröffentlichungs-Einstellungen',
	'Select template type' => 'Inhaltstyp wählen',
	'Selected template(s) has been copied.' => 'Die gewählte(n) Vorlage(n) wurden kopiert.',
	'Show All Templates' => 'Alle Vorlagen anzeigen',
	'Template Module' => 'Vorlagenmodul',
	'To add a widget set to your templates, use the following syntax:' => 'Um eine Widgetgruppe in eine Vorlage einzubinden, verwenden Sie folgenden Code:',
	'You have successfully deleted the checked template(s).' => 'Vorlage(n) erfolgreich gelöscht.',
	'You have successfully refreshed your templates.' => 'Vorlagen erfolgreich zurückgesetzt.',
	'Your templates have been published.' => 'Die Vorlagen wurden veröffentlicht.',

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'Alle Themen',
	'Author: ' => 'Autor:',
	'Available Themes' => 'Verfügbare Themen',
	'Current Theme' => 'Derzeitiges Thema',
	'Errors' => 'Fehler',
	'Failed' => 'Fehlgeschlagen',
	'Find Themes' => 'Themen finden',
	'No themes are installed.' => 'Keine Themen installiert.',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht in der Untersite verwendet werden. [_1] Elemente übersprungen.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht in der Site verwendet werden. [_1] Elemente übersprungen.',
	'Reapply' => 'Erneut anwenden',
	'Theme Errors' => 'Themen-Fehler',
	'Theme Information' => 'Themen-Infos',
	'Theme Warnings' => 'Themen-Warnungen',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] angewendet (mit <a href="[_2]" class="alert-link">[quant,_3,Warnung,Warnungen]</a>).',
	'Theme [_1] has been applied.' => 'Thema [_1] angewendet.',
	'Theme [_1] has been uninstalled.' => 'Thema [_1] deinstalliert.',
	'Themes in Use' => 'Verwendete Themen',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Diese Thema kann wegen [_1] Fehlern nicht in der Untersite verwendet werden',
	'This theme cannot be applied to the site due to [_1] errors' => 'Diese Thema kann wegen [_1] Fehlern nicht in der Site verwendet werden',
	'Uninstall' => 'Deinstallieren',
	'Warnings' => 'Warnungen',
	'[quant,_1,warning,warnings]' => '[quant,_1,Warnung,Warnungen]',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Assets erfolgreich gelöscht.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Kann '[_1]' nicht beschreiben. Vorschaubilder werden möglicherweise nicht angezeigt.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully granted the given permission(s).' => 'Berechtigungen erfolgreich zugewiesen',
	'You have successfully revoked the given permission(s).' => 'Berechtigungen erfolgreich entzogen',

## tmpl/cms/listing/author_list_header.tmpl
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie im externen Verzeichnis nicht mehr vorhanden sind.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Die gelöschten Benutzerkonten sind im externen Verzeichnis weiterhin vorhanden. Die Benutzer können sich daher weiterhin an Movable Type Advanced anmelden.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Gewählte Benutzerkonten erfolgreich aus Movable Type gelöscht',
	'You have successfully disabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich deaktiviert',
	'You have successfully enabled the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich aktiviert',
	'You have successfully unlocked the selected user(s).' => 'Gewählte Benutzerkonten erfolgreich entsperrt',
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Bei der Synchronisierung ist ein Fehler aufgetreten. Details fnden Sie im <a href='[_1]' class="alert-link">Aktivitätsprotokoll</a>.},
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie fehlerhafte Parameter aufweisen. Details finden Sie im <a href='[_2]' class="alert-link">Aktivitätsprotokoll</a>.},
	q{You have successfully synchronized users' information with the external directory.} => q{Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => 'Ungültige IP-Adresse.',
	'The IP you entered is already banned for this site.' => 'Diese IP-Adresse ist bereits gesperrt.',
	'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefügt.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die gewählten IP-Adressen erfolgreich aus der Liste entfernt.',

## tmpl/cms/listing/blog_list_header.tmpl
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'Untersite erfolgreich aus dem Movable-Type-System gelöscht. Die zugehörigen Dateien sind noch vorhanden. Bitte löschen Sie sie, falls Sie se nicht mehr benötigen.',
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Site erfolgreich aus dem Movable-Type-System gelöscht. Die zugehörigen Dateien sind noch vorhanden. Bitte löschen Sie sie, falls Sie se nicht mehr benötigen.',
	'You have successfully moved selected child sites to another site.' => 'Untersite erfolgreich in andere Site verschoben.',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => 'Einige Kategorien konnten nicht gelöscht werden. Bitte löschen Sie zuerst die Kategoriefelder aus dem Kategorie-Set.',

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'Alle als Spam markierten Kommentare wurden entfernt.',
	'No comments appear to be spam.' => 'Scheinbar ist kein Kommentar Spam.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
	'The selected comment(s) has been approved.' => 'Die gewählten Kommentare wurden freigeschaltet.',
	'The selected comment(s) has been deleted from the database.' => 'Die gewählten Kommentar(e) wurden aus der Datenbank gelöscht.',
	'The selected comment(s) has been recovered from spam.' => 'Die gewählten Kommentare wurden aus dem Spam wiederhergestellt',
	'The selected comment(s) has been reported as spam.' => 'Die gewählten Kommentare wurden als Spam gemeldet',
	'The selected comment(s) has been unapproved.' => 'Die gewählten Kommentare sind nicht mehr freigeschaltet',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'Inhaltsdaten aus Datenbank gelöscht.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'Einige Inhaltstypen wurden nicht gelöscht. Biite löschen Sie zuerst die zugehörigen Archiv-Vorlagen oder entfernen Sie alle Inhaltstyp-Felder aus dem Inhaltstyp.',
	'The content type has been deleted from the database.' => 'Inhaltstyp aus Datenbank gelöscht.',

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'Gruppen erfolgreich aus der Movable Type-Installation gelöscht.',
	'You successfully disabled the selected group(s).' => 'Gruppe(n) erfolgreich deaktiviert.',
	'You successfully enabled the selected group(s).' => 'Gruppe(n) erfolgreich aktiviert.',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Bei der Synchronisierung ist ein Fehler aufgetreten. Nähere Informationen finden Sie im <a href='[_1]'>Aktivitätsprotokoll</a>.},
	q{You successfully synchronized the groups' information with the external directory.} => q{Gruppendaten erfolgreich mit externem Verzeichnis synchronisiert.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Einige ([_2]) der Benutzerkonten wurden nicht wieder aktiviert, da sie nicht mehr im LDAP vorhanden sind.',
	'You successfully added new users to this group.' => 'Benutzer erfolgreich zu Gruppe hinzugefügt.',
	'You successfully deleted the users.' => 'Benutzerkonten erfolgreich gelöscht.',
	'You successfully removed the users from this group.' => 'Benutzer erfolgreich aus Gruppe entfernt.',
	q{You successfully synchronized users' information with the external directory.} => q{Benutzerdaten erfolgreich mit externem Verzeichnis synchronisiert.},

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => 'Alle Zeiten in GMT',
	'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added new contact to your address book.' => 'Neuen Kontakt ins Adressbuch eingetragen.',
	'You have successfully deleted the selected contacts from your address book.' => 'Gewählte Kontakte erfolgreich aus dem Adressbuch gelöscht.',
	'You have updated your contact in your address book.' => 'Kontakt im Adressbuch aktualisiert.',

## tmpl/cms/listing/ping_list_header.tmpl
	'All TrackBacks reported as spam have been removed.' => 'Alle als Spam gemeldeten TrackBacks entfernt.',
	'No TrackBacks appeared to be spam.' => 'Kein TrackBack scheint Spam zu sein.',
	'The selected TrackBack(s) has been approved.' => 'Gewählte TrackBacks freigeschaltet.',
	'The selected TrackBack(s) has been deleted from the database.' => 'TrackBack(s) aus Datenbank gelöscht.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Gewählte TrackBacks(s) aus Spam wiederhergestellt',
	'The selected TrackBack(s) has been reported as spam.' => 'Gewählte TrackBack(s) als Spam gemeldet.',
	'The selected TrackBack(s) has been unapproved.' => 'Gewählte TrackBacks nicht mehr freigeschaltet.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Rolle(n) erfolgreich gelöscht.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Specify new name of the tag.' => 'Geben Sie den neuen Namen des Tags an',
	'You have successfully deleted the selected tags.' => 'Markierte Tags erfolgreich gelöscht',
	'Your tag changes and additions have been made.' => 'Tag-Änderungen übernommen',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all blogs?} => q{Das Tag &#8222;[_2]&#8220; ist schon vorhanden. &#8222;[_1]&#8220; wirklich in allen Blogs mit &#8222;[_2]&#8220; zusammenführen?},

## tmpl/cms/login.tmpl
	'Forgot your password?' => 'Passwort vergessen?',
	'Sign In (s)' => 'Anmelden (s)',
	'Sign in' => 'Anmelden',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Unten können Sie sich erneut anmelden.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an, um den Vorgang fortzusetzen.',
	'Your Movable Type session has ended.' => 'Ihre Movable Type-Sitzung ist abgelaufen oder Sie haben sich abgemeldet.',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Noch nicht implementiert.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Sende Pings...',
	'Trackback' => 'TrackBack',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'Fehlgeschlagene TrackBacks',
	'Successful Trackbacks' => 'Erfolgreiche TrackBacks',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Kopieren Sie diese Adressen im Eintragseditor in das Formularfeld für die zu verschickenden TrackBacks, um es erneut zu versuchen.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Alle Dateien',
	'Index Template: [_1]' => 'Index-Vorlagen: [_1]',
	'Only Indexes' => 'Nur Indizes',
	'Only [_1] Archives' => 'Nur Archiv: [_1]',
	'Publish (s)' => 'Veröffentlichen (s)',
	'Publish <em>[_1]</em>' => '<em>[_1]</em> veröffentlichen',
	'Publish [_1]' => 'Veröffentliche [_1]',
	'_REBUILD_PUBLISH' => 'Veröffentlichen',

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => 'Erneut veröffentlichen (s)',
	'Publish Again' => 'Erneut veröffentlichen',
	'Publish time: [_1].' => 'Dauer: [_1]',
	'Success' => 'Erfolg',
	'The files for [_1] have been published.' => 'Dateien für [_1] veröffentlicht.',
	'View this page.' => 'Seite ansehen',
	'View your site.' => 'Site ansehen',
	'Your [_1] archives have been published.' => '[_1]-Archiv veröffentlicht.',
	'Your [_1] templates have been published.' => '[_1]-Vorlagen veröffentlicht.',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Vorschau auf [_1]',
	'Re-Edit this [_1] (e)' => '[_1] erneut bearbeiten (e)',
	'Re-Edit this [_1]' => '[_1] erneut bearbeiten',
	'Return to the compose screen (e)' => 'Zurück zur Eingabe (e)',
	'Return to the compose screen' => 'Zurück zur Eingabe',
	'Save this [_1] (s)' => '[_1] speichern (s)',

## tmpl/cms/preview_content_data_strip.tmpl
	'Publish this [_1] (s)' => '[_1] veröffentlichen (s)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'Vorschau auf &#8222;[_1]&#8220-Inhalt &#8222;[_2]&#8220 ;',

## tmpl/cms/preview_entry.tmpl
	'Re-Edit this entry (e)' => 'Eintrag erneut bearbeiten (e)',
	'Re-Edit this entry' => 'Eintrag erneut bearbeiten',
	'Re-Edit this page (e)' => 'Seite erneut bearbeiten (e)',
	'Re-Edit this page' => 'Seite erneut bearbeiten',
	'Save this entry (s)' => 'Eintrag speichern (s)',
	'Save this entry' => 'Eintrag speichern',
	'Save this page (s)' => 'Seite speichern (s)',
	'Save this page' => 'Seite speichern',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry (s)' => 'Eintrag veröffentlichen (s)',
	'Publish this entry' => 'Eintrag veröffentlichen',
	'Publish this page (s)' => 'Seite veröffentlichen (s)',
	'Publish this page' => 'Seite veröffentlichen',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Eintrag &#8222;[_1]&#8220;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vorschau auf Seite &#8222;[_1]6#8220;',

## tmpl/cms/preview_template_strip.tmpl
	'(Publish time: [_1] seconds)' => '(Ausgegeben in [_1] Sekunden)',
	'Re-Edit this template (e)' => 'Vorlage erneut bearbeiten (e)',
	'Re-Edit this template' => 'Vorlage erneut bearbeiten',
	'Save this template (s)' => 'Vorlage speichern (s)',
	'Save this template' => 'Vorlage speichern',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'Es wurden noch keine Kategorien angelegt. Für die Vorschau werden daher Beispieldaten verwendet. Veröffentlicht werden kann die Vorlage erst, wenn mindestens eine Kategorie angelegt wurde., ',
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vorschau auf Vorlage &#8222;[_1]&#8221;',

## tmpl/cms/rebuilding.tmpl
	'Complete [_1]%' => '[_1]% fertig',
	'Publishing <em>[_1]</em>...' => 'Veröffentliche <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Veröffentliche [_1] [_2]',
	'Publishing [_1] archives...' => 'Veröffentliche [_1]...',
	'Publishing [_1] dynamic links...' => 'Veröffentliche [_1] (dynamisch)',
	'Publishing [_1] templates...' => 'Veröffentliche [_1]...',
	'Publishing [_1]...' => 'Veröffentliche [_1]...',
	'Publishing...' => 'Veröffentliche...',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Entsperren',
	q{User '[_1]' has been unlocked.} => q{Benutzer '[_1]' entsperrt.},

## tmpl/cms/recover_password_result.tmpl
	'No users were selected to process.' => 'Keine Benutzer zur Bearbeitung ausgewählt.',
	'Recover Passwords' => 'Passwörter anfordern',
	'Return' => 'Zurück',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'Keine Vorlagen gewählt.',
	'Return to templates' => 'Zurück zu Vorlagen',

## tmpl/cms/restore.tmpl
	'Exported File' => 'Exportierte Datei',
	'Import (i)' => 'Importieren (i)',
	'Import from Exported file' => 'Import aus exportierter Datei',
	'Overwrite global templates.' => 'Globale Vorlagen überschreiben',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'XML::SAX und/oder Abhängigkeiten dieses Perl-Moduls fehlen. Ohne diese Module kann Movable Type das System nicht wiederherstellen.',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1] Details finden Sie im Aktivitätsprotokoll.',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Importiere Movable Type',

## tmpl/cms/search_replace.tmpl
	'(search only)' => '(nur suchen)',
	'Case Sensitive' => 'Groß/Kleinschreibung beachten',
	'Date Range' => 'Zeitraum eingrenzen',
	'Date/Time Range' => 'Datums-/Zeit-Bereich',
	'Limited Fields' => 'Felder eingrenzen',
	'Regex Match' => 'Reguläre Ausdrücke verwenden',
	'Replace Checked' => 'Gewählte ersetzen',
	'Replace With' => 'Ersetzen durch',
	'Reported as Spam?' => 'Als Spam gemeldet?',
	'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
	'Search Again' => 'Erneut suchen',
	'Search For' => 'Suchen nach',
	'Show all matches' => 'Zeige alle Treffer',
	'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
	'Submit search (s)' => 'Suchen (s)',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,Element,Elemente] erfolgreich ersetzt.',
	'You must select one or more items to replace.' => 'Wählen Sie mindestens ein Element aus, das ersetzt werden soll.',
	'[quant,_1,result,results] found' => '[quant,_1,Treffer,Treffer] gefunden',
	'_DATE_FROM' => 'Von',
	'_DATE_TO' => 'Bis',
	'_TIME_FROM' => 'Von',
	'_TIME_TO' => 'Bis',

## tmpl/cms/system_check.tmpl
	'Memcached Server is [_1].' => 'Memcached-Server ist [_1].',
	'Memcached Status' => 'Memcached-Status',
	'Memcached is [_1].' => 'Memcached ist [_1]',
	'Server Model' => 'Server-Modell',
	'Total Users' => 'Benutzer insgesamt',
	'available' => 'verfügbar',
	'configured' => 'konfiguriert',
	'disabled' => 'deaktiviert',
	'unavailable' => 'nicht verfügbar',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type konnte das Skript &#8222;mt-check.cgi&#8220; nicht finden. Überprüfen Sie, ob das Skript vorhanden ist und, falls erforderlich, ob das CheckScript-Parameter korrekt gesetzt ist.},

## tmpl/cms/theme_export_replace.tmpl
	'Overwrite' => 'Überschreiben',
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Der Exportordner existiert bereits: &#8222;[_1]&#8220;. Setzen Sie fort, um das vorhandene Thema zu überschreiben oder brechen Sie ab, um den Ordnernamen zu ändern.},

## tmpl/cms/upgrade.tmpl
	'Begin Upgrade' => 'Aktualisierung durchführen',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Herzlichen Glückwunsch, Sie haben Ihre Installation erfolgreich auf Movable Type [_1] aktualisiert!',
	'Do you want to proceed with the upgrade anyway?' => 'Aktualisierung dennoch durchführen?',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Zusätzlich müssen folgende Movable Type-Komponenten installiert oder aktualisiert werden:',
	'Return to Movable Type' => 'Zurück zu Movable Type',
	'The following Movable Type components require upgrading or installation:' => 'Die folgenden Movable Type-Komponenten müssen installiert oder aktualisiert werden:',
	'Time to Upgrade!' => 'Zeit für eine Aktualisierung!',
	'Upgrade Check' => 'Aktualisierungs-Überprüfung',
	'Your Movable Type installation is already up to date.' => 'Ihre Movable Type-Installation ist bereits auf dem neuesten Stand.',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Es wurde eine neue Version von Movable Type installiert. Ihre Datenbank wird nun auf den aktuellen Stand gebracht.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Den Movable Type Upgrade Guide finden Sie <a href='[_1]' target='_blank'>hier</a>.},

## tmpl/cms/upgrade_runner.tmpl
	'Error during installation:' => 'Fehler während Installation:',
	'Error during upgrade:' => 'Fehler während Upgrade:',
	'Initializing database...' => 'Initialisiere Datenbank...',
	'Installation complete!' => 'Installation abgeschlossen!',
	'Return to Movable Type (s)' => 'Zurück zu Movable Type (s)',
	'Upgrade complete!' => 'Aktualisierung abgeschlossen!',
	'Upgrading database...' => 'Aktualisiere Datenbank...',
	'Your database is already current.' => 'Ihre Datenbank ist bereits auf dem aktuellen Stand.',

## tmpl/cms/view_log.tmpl
	'Download Filtered Log (CSV)' => 'Gefiltertes Protokoll herunterladen (CSV)',
	'Filtered Activity Feed' => 'Gefilterter Aktivitätsfeed',
	'Filtered' => 'Gefilterte',
	'Show log records where' => 'Zeige Einträge mit',
	'Showing all log records' => 'Alle Einträge',
	'Showing log records where' => 'Einträge mit',
	'System Activity Log' => 'System-Aktivitätsprotokoll',
	'The activity log has been reset.' => 'Aktivitätsprotokoll zurückgesetzt',
	'classification' => 'Thema',
	'level' => 'Art',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartz-Fehler-Log',
	'Showing all Schwartz errors' => 'Alle Schwartz-Fehler zeigen',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Neues',
	'No Movable Type news available.' => 'Es liegen keine Movable Type-Nachrichten vor.',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Nachricht vom System',
	'warning' => 'Warnung',

## tmpl/cms/widget/site_list.tmpl
	'Recent Posts' => 'Aktuelle Einträge',
	'Setting' => 'Einstellung',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Statistik-Einstellungen',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Aktive Benutzer',

## tmpl/cms/widget/updates.tmpl
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Update auf Version [_1] verfügbar. Details finden Sie in den <a href="[_2]" target="_blank">News</a>.',
	'Available updates ([_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => '', # Translate - New
	'Movable Type is up to date.' => 'Movable Type ist aktuell.',
	'Update check failed. Please check server network settings.' => 'Update-Prüfung fehlgeschlagen. Bitte überprüfen Sie Ihre Netzwerkeinstellungen.',
	'Update check is disabled.' => 'Update-Prüfung deaktiviert.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Zurück (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Noch nicht Mitglied? <a href="[_1]">Jetzt anmelden</a>!',
	'Sign in to comment' => 'Anmelden zum Kommentieren',
	'Sign in using' => 'Anmelden mit',

## tmpl/comment/profile.tmpl
	'Return to the <a href="[_1]">original page</a>.' => 'Zurück zur <a href="[_1]">Ausgangsseite</a>.',
	'Select a password for yourself.' => 'Eigenes Passwort',
	'Your Profile' => 'Ihr Profil',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Konto anlegen',
	'Password Confirm' => 'Passwortbestätigung',
	'Register' => 'Registrieren',

## tmpl/comment/signup_thanks.tmpl
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Bevor Sie kommentieren können, müssen Sie Ihre Registrierung noch bestätigen. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'Return to the original entry.' => 'Zurück zum ursprünglichen Eintrag',
	'Return to the original page.' => 'Zurück zur ursprünglichen Seite',
	'Thanks for signing up' => 'Vielen Dank für Ihre Anmeldung',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Um die Registrierung abzuschließen, bestätigen Sie bitte Ihre Anmeldung. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Um Ihre Registrierung zu bestätigen und Ihr Konto zu aktivieren, klicken Sie bitte auf den Link in dieser E-Mail.',

## tmpl/error.tmpl
	'CGI Path Configuration Required' => 'CGI-Pfad muß eingestellt sein',
	'Database Connection Error' => 'Verbindung mit Datenbank fehlgeschlagen',
	'Missing Configuration File' => 'Fehlende Konfigurationsdatei',
	'_ERROR_CGI_PATH' => 'Die CGIPath-Angabe in Ihrer Konfigurationsdatei fehlt oder ist fehlerhaft. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',
	'_ERROR_CONFIG_FILE' => 'Ihre Movable Type-Konfigurationsdatei fehlt, ist fehlerhaft oder kann nicht gelesen werden. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',
	'_ERROR_DATABASE_CONNECTION' => 'Die Datenbankeinstellungen in Ihrer Konfigurationsdatei fehlen oder sind fehlerhaft. Anweisungen zur Konfigurierung finden Sie im Abschnitt <a href="javascript:void(0)">Installation and Configuration</a> der Movable Type-Dokumentation.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type-Aktivitätsprotokoll',

## tmpl/feeds/feed_comment.tmpl
	'By commenter URL' => 'Nach Web-Adresse (URL) des Kommentarautoren',
	'By commenter email' => 'Nach E-Mail-Adresse des Kommentarautoren',
	'By commenter identity' => 'Nach Identität des Kommentarautoren',
	'By commenter name' => 'Nach Namen des Kommentarautoren',
	'From this [_1]' => 'Von diesem',
	'More like this' => 'Ähnliche Einträge',
	'On this day' => 'An diesem Tag',
	'On this entry' => 'Zu diesem Eintrag',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'Von diesem Autoren',

## tmpl/feeds/feed_ping.tmpl
	'By source URL' => 'Nach URL der Quelle',
	'By source blog' => 'Nach Quelle',
	'By source title' => 'Nach Name der Quelle',
	'Source [_1]' => 'Quelle [_1]',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDir ist erforderlich.',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'Konfigurierung des temporären Verzeichnisses',
	'You should configure your temporary directory settings.' => 'Sie sollten die temporäres Verzeichnis konfigurieren.',
	'[_1] could not be found.' => '[_1] nicht gefunden.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDir erfolgreich konfiguriert. Klicken Sie auf &#8222;Weiter&#8220;, um die Konfigurierung fortsetzen.},

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Konfigurationsdatei',
	'Retry' => 'Erneut versuchen',
	'Show the mt-config.cgi file generated by the wizard' => 'Vom Konfigurationsassistenten erzeugte mt-config.cgi-Datei anzeigen',
	'The [_1] configuration file cannot be located.' => 'Die [_1]-Konfigurationsdatei kann nicht gefunden werden.',
	'The mt-config.cgi file has been created manually.' => 'Die mt-congig.cgi-Konfigurationsdatei wurde manuell erstellt.',
	'The wizard was unable to save the [_1] configuration file.' => 'Die [_1]-Konfigurationsdatei konnte nicht gespeichert werden.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Stellen Sie sicher, daß Ihr Webserver Schreibrechte für Ihr [_1]-Wurzelverzeichnis hat (also für den Ordner, der die Datei mt.cgi enthält) und klicken Sie dann auf &#8222;Erneut versuchen&#8220;.},
	q{Congratulations! You've successfully configured [_1].} => q{Herzlichen Glückwunsch! Sie haben die [_1] erfolgreich konfiguriert.},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Kopieren Sie folgenden Text in eine Datei namens &#8222;mt-config.cgi&#8220; und legen diese im Movable Type-Hauptverzeichnis ab (das Verzeichnis, in dem sich auch die Datei mt.cgi befindet)},

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Datenbankkonfigurierung',
	'Database Type' => 'Datenbanktyp',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Wird Ihr Datenbanksystem nicht aufgeführt? Führen Sie die <a href="[_1]" target="_blank">Movable Type Systemüberprüfung</a> durch, um zu erfahren, ob zusätzliche Module erforderlich sind.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Klicken Sie nach der Installation <a href="javascript:void(0)" onclick="[_1]">hier, um diese Ansicht zu aktualisieren</a>.',
	'Please enter the parameters necessary for connecting to your database.' => 'Bitte geben Sie zur Herstellung der Datenkbankverbindung notwendigen Daten ein.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Mehr über <a href="[_1]" target="blank">Datenbankkonfiguration</a> erfahren',
	'Select One...' => 'Auswählen...',
	'Show Advanced Configuration Options' => 'Erweiterte Optionen anzeigen',
	'Show Current Settings' => 'Einstellungen anzeigen',
	'Test Connection' => 'Verbindung testen',
	'You may proceed to the next step.' => 'Sie können mit dem nächsten Schritt fortfahren.',
	'You must set your Database Path.' => 'Pfad zur Datenbank erforderlich',
	'You must set your Database Server.' => 'Geben Sie Ihren Datenbankserver an.',
	'You must set your Username.' => 'Geben Sie Ihren Benutzernamen an.',
	'Your database configuration is complete.' => 'Ihre Datenbankkonfigurierung ist abgeschlossen.',
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',

## tmpl/wizard/optional.tmpl
	'Address of your SMTP Server.' => 'Adresse Ihres SMTP-Servers',
	'An error occurred while attempting to send mail: ' => 'Mailversand fehlgeschlagen: ',
	'Cannot use [_1].' => 'Kann [_1] nicht verwenden.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Überprüfen Sie den Eingang der Testmail in Ihrem Postfach und fahren Sie dann mit dem nächsten Schritt fort.',
	'Do not use SSL' => 'SSL nicht verwenden',
	'Mail Configuration' => 'Mailkonfigurierung',
	'Mail address to which test email should be sent' => 'Zieladresse der Testmail',
	'Outbound Mail Server (SMTP)' => 'SMTP-Server',
	'Password for your SMTP Server.' => 'Passwort Ihres SMTP-Servers',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Geben Sie an, auf welchem Wege Movable Type E-Mails verschicken soll. E-Mails werden beispielsweise zur Benachrichtigung über neue Kommentare verschickt.',
	'Port number for Outbound Mail Server' => 'Port-Nummer des Servers für ausgehende Mail',
	'Port number of your SMTP Server.' => 'Port-Nummer Ihres SMTP-Servers',
	'SMTP Auth Password' => 'SMTP-Auth-Passwort',
	'SMTP Auth Username' => 'SMTP-Auth-Benutzername',
	'SSL Connection' => 'SSL-Verbindung',
	'Send Test Email' => 'Testmail verschicken',
	'Send mail via:' => 'Mails versenden über:',
	'Sendmail Path' => 'sendmail-Pfad',
	'Show current mail settings' => 'Mail-Einstellungen anzeigen',
	'Skip' => 'Überspringen',
	'This field must be an integer.' => 'Bitte geben Sie eine ganze Zahl ein.',
	'Use SMTP Auth' => 'SMTP Auth verwenden',
	'Use SSL' => 'SSL verwenden',
	'Use STARTTLS' => 'STARTTLS verwenden',
	'Username for your SMTP Server.' => 'Benutzername Ihres SMTP-Servers',
	'You must set a password for the SMTP server.' => 'Bitte geben Sie das Passwort Ihres SMTP-Servers an.',
	'You must set a username for the SMTP server.' => 'Bitte geben Sie den Benutzernamen Ihres SMTP-Servers an.',
	'You must set the SMTP server address.' => 'Bitte geben Sie die Adresse Ihres SMTP-Servers an.',
	'You must set the SMTP server port number.' => 'Bitte geben Sie die Port-Nummer Ihres SMTP-Servers an.',
	'You must set the Sendmail path.' => 'Bitte geben Sie Ihren Pfad zu Sendmail an.',
	'You must set the system email address.' => 'Bitte geben Sie die System-E-Mail-Adresse an.',
	'Your mail configuration is complete.' => 'Ihre Mail-Konfigurierung ist abgeschlossen.',

## tmpl/wizard/packages.tmpl
	'All required Perl modules were found.' => 'Alle erforderlichen Perl-Module sind vorhanden.',
	'Learn more about installing Perl modules.' => 'Mehr über die Installation von Perl-Modulen erfahren',
	'Minimal version requirement: [_1]' => 'Mindestens erforderliche Version: [_1]',
	'Missing Database Modules' => 'Fehlende Datenbank-Module',
	'Missing Optional Modules' => 'Nicht vorhandene optionale Module',
	'Missing Required Modules' => 'Fehlende erforderliche Module',
	'One or more Perl modules required by Movable Type could not be found.' => 'Mindestens ein von Movable Type erforderliche Perl-Modul wurde nicht gefunden.',
	'Requirements Check' => 'Überprüfung der Systemvoraussetzungen',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Einige optionale Perl-Module wurden nicht gefunden. <a href="javascript:void(0)" onclick="[_1]">Optionale Module anzeigen</a>',
	'You are ready to proceed with the installation of Movable Type.' => 'Sie können die Installation von Movable Type fortsetzen.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Alle erforderlichen Pakete vorhanden. Sie brauchen keine weiteren Pakete zu installieren.',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Einige optionale Perl-Module wurden nicht gefunden. Die Installation kann ohne diese Module fortgesetzt werden. Sie können jederzeit bei Bedarf nachinstalliert werden. &#8222;Erneut versuchen&#8220; wiederholt die Modulsuche.},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber erforderlich. Bitte installieren Sie sie und klicken dann auf &#8222;Erneut versuchen&#8220;.},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Die folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung erforderlich. Movable Type speichert die Daten Ihrer Sites und Untersites in einer Datenbank. Bitte installieren Sie eines der hier genannten Pakete und klicken Sie anschließend auf &#8222;Erneut versuchen&#8220;.},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Es ist bereits eine Konfigurationsdatei (mt-config.cgi) vorhanden. Sie können sich daher sofort <a href="[_1]">bei Movable Type anmelden</a>.',
	'Begin' => 'Anfangen',
	'Configuration File Exists' => 'Es ist bereits eine Konfigurationsdatei vorhanden',
	'Configure Static Web Path' => 'Statischen Web-Pfad konfigurieren',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type erfordert JavaScript. Bitte aktivieren Sie es in Ihren Browsereinstellungen und laden diese Seite dann neu.',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type wird mit einem Verzeichnis namens [_1] ausgeliefert, das einige wichtige Bild-, JavaScript- und Stylesheet-Dateien enthält.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Wenn Sie den [_1]-Ordner an einen vom Webserver erreichbaren Ort verschoben haben, geben Sie die Adresse unten an.',
	'Static file path' => 'Statischer Dateipfad',
	'Static web path' => 'Statischer Webpfad',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Die Adresse kann in dieser Form: [_1] oder einfach als [_2] angegeben werden. ',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Das Verzeichnis wurde entweder umbenannt oder an einen Ort außerhalb des Movable Type-Verzeichnisses verschoben.',
	'This path must be in the form of [_1]' => 'Der Pfad muss in dieser Form angegeben werden: [_1]',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Dieser Konfigurationsassistent hilft Ihnen, die zum Betrieb von Movable Type erforderlichen Grundeinstellungen vorzunehmen.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Um mit dem Konfigurationsassistenten eine neue Konfigurationsdatei zu erzeugen, entfernen Sie die vorhandene Konfigurationsdatei und laden Sie diese Seite neu.',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Fehler: &#8222;[_1]&#8220; nicht gefunden.</strong> Bitte verschieben Sie die statischen Dateien erst in das Verzeichnis oder überprüfen Sie die Einstellungen.},
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{Der [_1]-Ordner befindet sich im Hauptverzeichnis von Movable Type, ist aufgrund der Serverkonfiguration vom Webserver aber nicht erreichbar. Verschieben Sie den Ordner [_1] daher an einen Ort, auf dem der Webserver zugreifen kann (z.B. in das Web-Wurzelverzeichnis).},
);

1;
