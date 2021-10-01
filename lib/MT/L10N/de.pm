# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::de;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## addons/Commercial.pack/config.yaml
	'A collection of styles compatible with Professional themes.' => 'Mit Pro-Themen kompatible Designs',
	'About This Page' => 'Über diese Seite',
	'Archive Index' => 'Archiv-Index',
	'Archive Widgets Group' => 'Archiv-Widgetgruppe',
	'Are you sure you want to delete the selected CustomFields?' => 'Gewählte eigene Felder wirklich löschen?',
	'Audio' => 'Audio',
	'Author Archives' => 'Autorenarchiv',
	'Basename' => 'Basisname',
	'Blog Activity' => 'Blog-Aktivität',
	'Blog Archives' => 'Blog-Archiv',
	'Blog Index' => 'Blog-Index',
	'Blogs' => 'Blogs',
	'Calendar' => 'Kalendar',
	'Categories' => 'Kategorien',
	'Category Archives' => 'Kategoriearchiv',
	'Comment Detail' => 'Kommentardetails',
	'Comment Form' => 'Kommentarformular',
	'Comment Listing' => 'Liste der Kommentare',
	'Comment Preview' => 'Kommentarvorschau',
	'Comment Response' => 'Kommentar-Antworten',
	'Comments' => 'Kommentare',
	'Contact' => 'Kontakt',
	'Converting CustomField type...' => 'Wandle CustomFields-Typen...',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Legen Sie ein Blog als Teil einer umfangreicheren Website an. Das funktioniert besonders gut mit der Vorlage Professionelle Website.',
	'Creative Commons' => 'Creative Commons',
	'Current Author Monthly Archives' => 'Monatsarchiv des aktuellen Autors',
	'Current Category Monthly Archives' => 'Monatsarchiv der aktuellen Kategorie',
	'Custom Fields' => 'Eigene Felder',
	'Date-Based Author Archives' => 'Datumsbasiertes Autorenarchiv',
	'Date-Based Category Archives' => 'Datumsbasiertes Kategoriearchiv',
	'Delete' => 'Löschen',
	'Description' => 'Beschreibung',
	'Dynamic Error' => 'Dynamische Fehlermeldungen',
	'Embed' => 'Einbetten',
	'Entry Detail' => 'Eintragsdetails',
	'Entry Listing' => 'Eintragsliste',
	'Entry Metadata' => 'Eintrags-Metadaten',
	'Entry Summary' => 'Zusammenfassung',
	'Entry' => 'Eintrag',
	'Feed - Recent Entries' => 'Feed - Aktuelle Einträge',
	'Field' => 'Feld',
	'Footer Links' => 'Fußzeilen-Links',
	'Footer' => 'Fußzeile',
	'Header' => 'Kopf',
	'Home Page Widgets Group' => 'Startseiten-Widgetgruppe',
	'JavaScript' => 'JavaScript',
	'Link' => 'Link',
	'Main Index' => 'Übersicht',
	'Main Sidebar' => 'Haupt-Seitenspalte',
	'Manage' => 'Verwalten',
	'Migrating CustomFields type...' => 'Migriere CustomFields-Typen...',
	'Monthly Archives Dropdown' => 'Monatsarchiv (Dropdown)',
	'Monthly Archives' => 'Monatsarchiv',
	'Name' => 'Name',
	'New' => 'Neu',
	'No Name' => 'Kein Name',
	'Not Required' => 'Nicht erforderlich',
	'OpenID Accepted' => 'OpenID unterstützt',
	'Page Detail' => 'Seitendetails',
	'Page Listing' => 'Seitenübersicht',
	'Page' => 'Seite',
	'Photo' => 'Foto',
	'Popup Image' => 'Popup-Bild',
	'Powered By (Footer)' => 'Powered by (Fußzeile)',
	'Professional Blog' => 'Professionelles Blog',
	'Professional Styles' => 'Pro-Themen',
	'Professional Website' => 'Professionelle Website',
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Eine professionell gestaltete, übersichtlich strukturierte und leicht anpass- und erweiterbare Website. ',
	'RSD' => 'RSD',
	'Recent Assets' => 'Aktuelle Assets',
	'Recent Comments' => 'Aktuelle Kommentare',
	'Recent Entries Expanded' => 'Neueste Einträge (erweitert)',
	'Recent Entries' => 'Aktuelle Einträge',
	'Required' => 'Erforderlich',
	'Search Results' => 'Suchergebnis',
	'Search' => 'Suchen',
	'Sidebar' => 'Seitenleiste',
	'Sign In' => 'Anmelden',
	'Stylesheet' => 'Stylesheet',
	'Syndication' => 'Syndizierung',
	'System Object' => 'Systemobjekt',
	'Tag Cloud' => 'Tag-Wolke',
	'Tag' => 'Tag',
	'Tags' => 'Tags',
	'Template tag' => 'Vorlagenbefehl',
	'TrackBacks' => 'TrackBacks',
	'Type' => 'Typ',
	'Unknown Object' => 'Unbekannts Objekt',
	'Unknown Type' => 'Unbekannter Typ',
	'Website/Blog Name' => 'Name der Website/des Blogs',
	'Welcome to our new website!' => 'Willkommen auf unserer neuen Website!',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
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
	'__SELECT_FILTER_VERB' => 'ist',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/',
	q{Updating Universal Template Set to Professional Website set...} => q{Aktualisiere 'Universelle Vorlagengruppe' in Vorlagengruppe 'Profesionelle Website'},

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Checkbox' => 'Auswahlkästchen',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Speichern Sie genau die Informationen, die Sie möchten, indem Sie die Formulare und Felder von Einträgen, Seiten, Ordnern, Kategorien und Benutzerkonten frei anpassen.',
	'Date & Time' => 'Datum- und Uhrzeit',
	'Date Only' => 'Nur Datum',
	'Date and Time' => 'Datum und Uhrzeit',
	'Drop Down Menu' => 'Drop-Down-Menü',
	'Edit Field' => 'Feld bearbeiten',
	'Embed Object' => 'Objekt einbetten',
	'Exclude Custom Fields' => 'Eigene Felder ausschließen',
	'Invalid request.' => 'Ungültige Anfrage.',
	'Movable Type' => 'Movable Type',
	'Multi-Line Text' => 'Mehrzeiliger Text',
	'Permission denied.' => 'Zugriff verweigert.',
	'Please ensure all required fields have been filled in.' => 'Bitte füllen Sie alle erforderlichen Felder aus.',
	'Please enter all allowable options for this field as a comma delimited list' => 'Bitte geben Sie alle für dieses Feld zulässigen Optionen als kommagetrennte Liste ein.',
	'Please enter valid URL for the URL field: [_1]' => 'Bitte geben Sie eine gültige Web-Adresse in das Feld [_1] ein.',
	'Post Type' => 'Eintragsart',
	'Radio Buttons' => 'Auswahlknöpfe',
	'Saving permissions failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'Show' => 'Anzeigen',
	'Single-Line Text' => 'Einzeiliger Text',
	'Time Only' => 'Nur Uhrzeit',
	'URL' => 'URL',
	'View image' => 'Bild ansehen',
	'You must select other type if object is the comment.' => 'Wählen Sie einen anderen Typ, wenn sich das Feld auf Kommentare bezieht.',
	'[_1] Fields' => '[_1]-Felder',
	'blog and the system' => 'Blog und das system',
	'blog' => 'Blog',
	'type' => 'Typ',
	'website and the system' => 'Website und das System',
	'website' => 'Website',
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben müssen das Format JJJJ-MM-TT HH:MM:SS haben.},
	q{Invalid date '[_1]'; dates should be real dates.} => q{Ungültige Datumsangabe &#8222;[_1]&#8220; - Datumsangaben sollten tatsächliche Daten sein},
	q{Please enter some value for required '[_1]' field.} => q{Bitte füllen Sie das erforderliche Feld &#8222;[_1]&#8220; aus.},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{Der Basisname &#8222;[_1]&#8220; wird bereits verwendent. Er muss auf dieser [_2] eindeutig sein.},
	q{The template tag '[_1]' is already in use.} => q{Vorlagenbefehl &#8222;[_1]&#8220; bereits vorhanden},
	q{The template tag '[_1]' is an invalid tag name.} => q{&#8222;[_1]&#8220; ist kein gültiger Befehlsname.},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) hinzugefügt von Benutzer &#8222;[_4]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) gelöscht von &#8222;[_4]&#8220;},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => 'Fertig.',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Stelle Assetverknüpfungen aus eigenen Feldern wieder her...',
	'Restoring custom fields data stored in MT::PluginData...' => 'Stelle eigene Felder aus MT::PluginData wieder her...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'Stelle die Adressen der in eigenen Feldern verwendeten Assets wieder her...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Bitte geben Sie eine gültige Option für das [_1]-Feld an: [_2]',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => 'Parameter "[_1]" erforderlich.',
	'The systemObject "[_1]" is invalid.' => 'Das systemObject "[_1]" ist ungültig.',
	'The type "[_1]" is invalid.' => 'Der Typ "[_1]" ist ungültig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Das angegebene includeShared-Parameter ist ungültig: [_1]',
	'Removing [_1] failed: [_2]' => '[_1] konnte nicht entfernt werden: [_2]',
	'Saving [_1] failed: [_2]' => '[_1] konnte nicht gespeichert werden: [_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Fields' => 'Felder',
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
	'Template Tag' => 'Vorlagenbefehl',
	'[_1] custom fields' => '[_1] eigene Felder',
	'a field on system wide' => 'Ein systemweites Feld',
	'a field on this blog' => 'Ein Feld dieses Blogs',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Verschiebe Metadatenspeicher für Seiten...',
	'Removing CustomFields display-order from plugin data...' => 'Entferne Anzeigereihenfolge eigener Felder aus Plugin-Daten...',
	'Removing unlinked CustomFields...' => 'Entferne nicht verwendete eigene Felder...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Klone Felder dieses Blogs:',
	'[_1] records processed.' => '[_1] Einträge bearbeitet.',
	'[_1] records processed...' => '[_1] Einträge bearbeitet...',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml
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

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml
	'Archives' => 'Archiv',

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Diese Widgetgruppe zeigt auf die jeweilige Archivseite zugeschnittene Informationen an: [_1] ',

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml
	'Authors' => 'Autoren',
	'[_1] ([_2])' => '[_1] ([_2])',

## addons/Commercial.pack/templates/professional/blog/calendar.mtml
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

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] hat auf den <a href="[_2]">Kommentar von [_3]</a> geantwortet</a>',

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml
	'(You may use HTML tags for style)' => '(Zur Formatierung können HTML-Tags verwendet werden.)',
	'Cancel' => 'Abbrechen',
	'Email Address' => 'E-Mail-Adresse',
	'Leave a comment' => 'Kommentar schreiben',
	'Preview' => 'Vorschau',
	'Remember personal info?' => 'Persönliche Angaben speichern?',
	'Replying to comment from [_1]' => 'Antwort auf den Kommentar von [_1]',
	'Submit' => 'Abschicken',

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml
	'Previewing your Comment' => 'Vorschau Ihres Kommentars',

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml
	'Back' => 'Zurück',
	'Comment Submission Error' => 'Beim Abschicken des Kommentars ist ein Fehler aufgetreten',
	'Confirmation...' => 'Bestätigung',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">Zurück zum Eintrag</a>',
	'Thank you for commenting.' => 'Vielen Dank für Ihren Kommentar.',
	'Your comment has been received and held for review by a blog administrator.' => 'Ihr Kommentar wurde abgeschickt. Er erscheint, sobald der Administrator des Blogs ihn freigeschaltet hat.',
	'Your comment has been submitted!' => 'Ihr Kommentar ist eingegangen!',
	'Your comment submission failed for the following reasons: [_1]' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden: [_1]',

## addons/Commercial.pack/templates/professional/blog/comments.mtml
	'# Comments' => '# Kommentare',
	'1 Comment' => '1 Kommentar',
	'Next' => 'Vor',
	'No Comments' => 'Keine Kommentare',
	'Previous' => 'Zurück',
	'The data is modified by the paginate script' => 'Die Daten werden vom Paginierungsskript modifiziert.',

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Dieses Blog steht unter einer <a href="[_1]">Creative Commons-Lizenz</a>.',

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Monatsarchiv',

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml
	'Author Daily Archives' => 'Tägliches Autorenarchiv',
	'Author Monthly Archives' => 'Monatliches Autorenarchiv',
	'Author Weekly Archives' => 'Wöchentliches Autorenarchiv',
	'Author Yearly Archives' => 'Jährliches Autorenarchiv',

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml
	'Category Daily Archives' => 'Tägliches Kategoriearchiv',
	'Category Monthly Archives' => 'Monatliches Kategoriearchiv',
	'Category Weekly Archives' => 'Wöchentliches Kategoriearchiv',
	'Category Yearly Archives' => 'Jährliches Kategoriearchiv',

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml
	'Page Not Found' => 'Seite nicht gefunden',

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Neues von <em>[_1]</em>',
	'Recently in <em>[_1]</em> Category' => 'Neues in der Kategorie <em>[_1]</em>',
	'[_1] Archives' => '[_1]-Archiv',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml
	'# TrackBacks' => '# TrackBacks',
	'1 TrackBack' => '1 TrackBack',
	'By [_1] on [_2]' => 'Von [_1] zu [_2]',

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '<a rel="bookmark" href="[_1]">[_2]</a> weiterlesen',

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Home' => 'Startseite',
	'Links' => 'Links',

## addons/Commercial.pack/templates/professional/blog/javascript.mtml
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

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Diese Widgetgruppe erscheint ausschließlich auf der Startseite (bzw. auf der von der Vorlage "main_index" erzeugten Seite). Weitere Informationen: [_1]',

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Monat wählen...',

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archiv</a>',

## addons/Commercial.pack/templates/professional/blog/openid.mtml
	'Learn more about OpenID' => 'Mehr über OpenID erfahren',
	'[_1] accepted here' => '[_1] unterstützt',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml
	'Pages' => 'Seiten',

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml
	'_POWERED_BY' => 'Powered by<br /><a href="https://www.movabletype.org/"><$MTProductName$></a>',

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] meinte zu [_3]</a>: [_4]',

## addons/Commercial.pack/templates/professional/blog/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'ie Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',
	'Instructions' => 'Hinweise',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Kein Suchergebnis für &#8222;[_1]&#8220;',
	'Results matching &ldquo;[_1]&rdquo;' => 'Suchergebnis für &#8222;[_1]&#8220;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Suchergebnis für Tag &#8222;[_1]&#8220;',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'Die Boolschen Operatoren AND, OR und NOT werden unterstützt:',
	'movable type' => 'Movable Type',
	'personal OR publishing' => 'Schrank OR Schublade',
	'publishing NOT personal' => 'Regal NOT Schrank',

## addons/Commercial.pack/templates/professional/blog/signin.mtml
	'You are signed in as ' => 'Sie sind angemeldet als',
	'You do not have permission to sign in to this blog.' => 'Sie haben keine Berechtigung zur Anmeldung an diesem Blog.',
	'sign out' => 'abmelden',

## addons/Commercial.pack/templates/professional/blog/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feeds aller Ergebnisse zu &#8222;[_1]&#8220; abonnieren',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed aller mit &#8222;[_1]&#8220; getaggten Ergebnisse abonnieren',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Feed aller künftigen Einträge mit &#8222;[_1]&#8220; abonnieren',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Feed aller künftigen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren',
	'Subscribe to feed' => 'Feed abonnieren',
	q{Subscribe to this blog's feed} => q{Feed dieses Blogs abonnieren},

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> von [_3] zu <a href="[_4]">[_5]</a>',
	'No TrackBacks' => 'Keine TrackBacks',
	'TrackBack URL: [_1]' => 'TrackBack-URL: [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Weiterlesen</a>',

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Einträge ([_1]) Kommentare ([_2])',

## addons/Commercial.pack/templates/professional/website/comment_response.mtml
	'Return to the <a href="[_1]">original page</a>.' => 'Zurück zur <a href="[_1]">Ausgangsseite</a>.',

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'By [_1] | Comments ([_2])' => 'Von [_1] | Kommentare ([_2])',
	'on [_1]' => 'zu [_1]',

## addons/Commercial.pack/templates/professional/website/search.mtml
	'Case sensitive' => 'Groß-/Kleinschreibung unterscheiden',
	'Regex search' => 'Reguläre Ausdrücke verwenden',

## addons/Commercial.pack/templates/professional/website/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Die Suchfunktion sucht nach allen angebenen Begriffen in beliebiger Reihenfolge. Verwenden Sie Anführungszeichen, um einen exakten Ausdruck zu suchen:',

## addons/Commercial.pack/templates/professional/website/syndication.mtml
	q{Subscribe to this website's feed} => q{Feed dieser Website abonnieren},

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => '[_1] wählen',
	'Remove [_1]' => '[_1] löschen',
	'View' => 'Ansehen',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Diese Felder anzeigen',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Daten in eigenen Feldern gespeichert.',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Keine eigenen Felder gefunden. Jetzt ein <a href="[_1]">Feld anlegen</a>.',
	'Save Changes' => 'Änderungen speichern',
	'Save changes to blog (s)' => 'Blog-Änderungen speichern (s)',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Choose the system object where this custom field should appear.' => 'Wählen Sie das Systemobjekt, auf das sich dieses Feld beziehen soll.',
	'Create Custom Field' => 'Eigenes Feld anlegen',
	'Default' => 'Standardwert',
	'Delete this field (x)' => 'Dieses Feld löschen (x)',
	'Edit Custom Field' => 'Eigenes Feld bearbeiten',
	'Example Template Code' => 'Beispiel-Vorlagencode',
	'Is data entry required in this custom field?' => 'Muss dieses Feld ausgefüllt werden?',
	'Must the user enter data into this custom field before the object may be saved?' => 'Sollen Benutzer dieses Feld ausfüllen müssen, bevor sie das Objekt speichern können?',
	'Options' => 'Optionen',
	'Required?' => 'Erforderlich?',
	'Save this field (s)' => 'Dieses Feld speichern (s)',
	'Save' => 'OK',
	'Select...' => 'Wählen...',
	'Show In These [_1]' => 'In diesen [_1] anzeigen',
	'The basename must be unique within this [_1].' => 'Der Basisname muss in diesem [_1] eindeutig sein.',
	'The selected field(s) has been deleted from the database.' => 'Gewählten Felder aus Datenbank gelöscht.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'Bitte füllen Sie alle hervorgehobenen Felder aus.',
	'You must save this custom field before setting a default value.' => 'Speichern Sie das Feld, um den Standardwert festlegen zu können.',
	'Your changes have been saved.' => 'Änderungen gespeichert.',
	'field' => 'Feld',
	'fields' => 'Felder',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Hinweis: Eine Änderung des Basisnamens eines Feldes kann die Bearbeitung vorhandener Vorlagen notwendig machen.},

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objekt',

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	', or press the enter key to %toggle% it' => 'oder Enter drücken zum An- oder Abwählen',
	'click to %toggle% this box' => 'klicken um das Feld an- oder abzuwählen',
	'click-down and drag to move this field' => 'bei gedrückter Maustaste ziehen, um das Feld zu verschieben',
	'close' => 'schließen',
	'open' => 'öffnen',
	'use the arrow keys to move this box' => 'mit den Pfeiltasten verschieben',

## addons/Community.pack/config.yaml
	'A collection of styles compatible with Community themes.' => 'Mit Community-Themen kompatible Designs',
	'Activity Widgets' => 'Aktivitäten-Widgets',
	'Archive Widgets' => 'Archiv-Widgets',
	'Atom ' => 'Atom ',
	'Category Groups' => 'Kategoriegruppen',
	'Community Blog' => 'Community-Blog',
	'Community Forum' => 'Community-Forum',
	'Community Styles' => 'Community-Styles',
	'Community' => 'Feedback',
	'Content Header' => 'Inhaltskopf',
	'Content Navigation' => 'Inhaltsnavigation',
	'Create Entry' => 'Neuen Eintrag schreiben',
	'Create forums where users can post topics and responses to topics.' => 'Bieten Sie Foren an, in denen Ihre Leser untereinander diskutieren können.',
	'Default Widgets' => 'Standard-Widgets',
	'Displays error, pending or confirmation message for comments.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Kommentaren an',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Beiträgen an.',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Zeigt Bestätigungs-, Moderations- und Fehlermeldungen zu neuen Beiträgen an.',
	'Displays errors for dynamically-published templates.' => 'Zeigt Fehlermeldung von dynamisch erzeugten Vorlagen an.',
	'Displays image when user clicks a popup-linked image.' => 'Zeigt Bilder als Pop-Ups an, wenn auf ein Vorschaubild geklickt wird ',
	'Displays preview of comment.' => 'Zeigt eine Vorschau des Kommentars an',
	'Displays results of a search.' => 'Zeigt Suchergebnisse an',
	'Email verification' => 'E-Mail-Bestätigung',
	'Entry Feed' => 'Eintrags-Feed',
	'Entry Form' => 'Eintragsformular',
	'Entry Response' => 'Antwort auf Eintrag',
	'Entry Table' => 'Eintragstabelle',
	'Followed by' => 'Gefolgt von',
	'Followers' => 'Ihnen folgen',
	'Following' => 'Sie folgen',
	'Form Field' => 'Formularfeld',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Improved listing of comments.' => 'Verbesserte Kommentarverwaltung',
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Leser-Interaktion fördern: rollen Sie neue Funktionen aus, die es Ihren Lesern leicht machen, mit Ihnen und Ihrem Unternehmen zu interagieren',
	'Login Form' => 'Anmeldeformular',
	'Most Popular Entries' => 'Beliebteste Einträge',
	'New Password Form' => 'Formular zur Anforderung neuer Passwörter',
	'New Password Reset Form' => 'Formular zum Zurücksetzen neuer Passwörter',
	'New entry notification' => 'Neuer Eintragsbenachrichtigung',
	'Pending Entries' => 'Wartende Einträge',
	'Popular Entry' => 'Beliebter Eintrag',
	'Powered By' => 'Powered by',
	'Profile Edit Form' => 'Formular zur Profilbearbeitung',
	'Profile Feed' => 'Profil-Feed',
	'Profile View' => 'Profilansicht',
	'Recent Submissions' => 'Aktuelle Beiträge',
	'Recently Scored' => 'Kürzlich bewertet',
	'Registration Confirmation' => 'Registrierungsbestätigung',
	'Registration Form' => 'Registrierungsformular',
	'Registration notification' => 'Registrierungsbenachrichtigung',
	'Registrations' => 'Registrierungen',
	'Sanitize' => 'Bereinigen',
	'Simple Footer' => 'Einfache Fußzeile',
	'Simple Header' => 'Einfache Kopfzeile',
	'Spam Entries' => 'Spam-Einträge',
	'Status Message' => 'Statusnachricht',
	'Userpic' => 'Benutzerbild',
	'Users followed by [_1]' => 'Benutzer, denen [_1] folgt',
	'Users following [_1]' => 'Benutzer, die [_1] folgt',

## addons/Community.pack/lib/MT/App/Community.pm
	'(Display Name not set)' => '(Kein Anzeigename festgelegt)',
	'(No email address)' => '(Keine E-Mail-Adresse)',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Zurück zur Ausgangsseite</a>',
	'Actions from [_1]' => 'Aktionen von [_1]',
	'All required fields must have valid values.' => 'Alle erforderlichen Felder müssen gültige Werte aufweisen.',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Bevor Sie sich anmelden können, bestätigen Sie bitte Ihre E-Mail-Adresse. <a href="[_1]">Bestätigungsmail erneut senden</a>.',
	'Cannot load blog #[_1].' => 'Konnte Blog #[_1] nicht laden.',
	'Cannot load entry #[_1].' => 'Kann Eintrag #[_1] nicht laden.',
	'Comments from [_1]' => 'Kommentare von [_1]',
	'Display Name' => 'Anzeigename',
	'Email Address is invalid.' => 'Die E-Mail-Adresse ist ungültig.',
	'Failed to verify the current password.' => 'Das aktuelle Passwort konnte nicht verifiziert werden.',
	'For improved security, please change your password' => 'Bitte ändern Sie Ihr Passwort, um die Sicherheit zu erhöhen.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ungültiger Anmeldeversuch von Kommentarautor [_1] an Weblog [_2](ID: [_3]) - native Movable Type-Authentifizierung bei diesem Weblog nicht zulässig.',
	'Invalid login' => 'Ungültiges Login',
	'Invalid login.' => 'Login ungültig.',
	'Invalid parameter' => 'Ungültiges Parameter',
	'Invalid request' => 'Ungültige Anfrage',
	'Login required' => 'Anmeldung erforderlich',
	'Movable Type Account Confirmation' => 'Movable Type-Anmeldungsbestätigung',
	'No login form template defined' => 'Keine Vorlage für das Anmeldeformular definiert',
	'Password contains invalid character.' => 'Das Passwort enthält mindestens ein ungültiges Zeichen.',
	'Passwords do not match.' => 'Die Passwörter stimmen nicht überein.',
	'Please select a video to upload.' => 'Bitte wählen die Video-Datei aus, die Sie hochladen möchten.',
	'Please select an audio file to upload.' => 'Bitte wählen die Audio-Datei aus, die Sie hochladen möchten.',
	'Please select an image to upload.' => 'Bitte wählen die Bild-Datei aus, die Sie hochladen möchten.',
	'Publish failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Recent Entries from [_1]' => 'Aktuelle Eintrage von [_1]',
	'Responses to Comments from [_1]' => 'Reaktionen auf Kommentare von [_1]',
	'Saving object failed: [_1]' => 'Das Objekt konnte nicht gespeichert werden: [_1]',
	'Signing up is not allowed.' => 'Registrierungen sind nicht erlaubt.',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Sie wurden erfolgreich authentifiziert, Registrierungen sindaber nicht erlaubt. Bitte wenden Sie sich an den Systemadministrator.',
	'System Email Address is not configured.' => 'Die System-E-Mail-Adresse ist nicht konfiguriert.',
	'System template entry_response not found in blog: [_1]' => 'Systemvorlage entry_response für Blog [_1] nicht gefunden',
	'Thanks for the confirmation.  Please sign in.' => 'Danke für die Bestätigung. Bitte melden Sie sich an.',
	'The login could not be confirmed because of a database error ([_1])' => 'Der Anmeldevorgang konnte wegen eines Datenbankfehlers nicht abgeschlossen werden ([_1])',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde deaktiviert. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Title or Content is required.' => 'Titel oder Text erforderlich',
	'URL is invalid.' => 'Die URL ist ungültig.',
	'Unknown user' => 'Unbekannter Benutzer',
	'You are trying to redirect to external resources: [_1]' => 'Weiterleitung zu externer Seite: [_1]',
	'You need to sign up first.' => 'Bitte registrieren Sie sich zuerst.',
	'Your confirmation have expired. Please register again.' => 'Ihre Anmeldung ist abgelaufen. Bitte registrieren Sie sich erneut.',
	'[_1] contains an invalid character: [_2]' => '[_1] enthält ein ungültiges Zeichen: [_2]',
	'[_1] registered to Movable Type.' => '[_1] hat sich bei Movable Type registriert',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]' hat laut System-Einstellungen keine Upload-Berechtigung: [_2]},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{Fehler bei der Zuweisung von Kommentierungsrechten an Benutzer &#8222;[_1] (ID: [_2])&#8220; für Weblog '[_3] (ID: [_4])'. Keine geeignete Kommentierungsrolle gefunden.},
	q{Error writing upload to '[_1]': [_2]} => q{Die hochgeladene Datei konnte nicht in &#8222;[_1]&#8220; gespeichert werden: [_2]},
	q{Failed comment attempt by pending registrant '[_1]'} => q{Fehlgeschlagener Kommentierungsversuch durch wartenden Kommentarautoren &#8222;[_1]&#8220;},
	q{Failed login attempt by disabled user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von deaktiviertem Benutzer '[_1]'},
	q{Failed login attempt by pending user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von wartendem Benutzer &#8222;[_1]&#8220;},
	q{Failed login attempt by unknown user '[_1]'} => q{Fehlgeschlagener Anmeldeversuch von unbekanntem Benutzer '[_1]'},
	q{Invalid filename '[_1]'} => q{Ungültiger Dateiname &#8222;[_1]&#8220;},
	q{Login failed: password was wrong for user '[_1]'} => q{Anmeldung fehlgeschlagen: falsches Passwort für Benutzer &#8222;[_1]&#8220;},
	q{Login failed: permission denied for user '[_1]'} => q{Anmeldung fehlgeschlagen: Zugriff verweigert für Benutzer &#8222;[_1]&#8220;},
	q{New entry '[_1]' added to the blog '[_2]'} => q{Neuer Eintrag '[_1]' zu Blog '[_2]' hinzugefügt.},
	q{User '[_1]' (ID:[_2]) has been successfully registered.} => q{Benutzer '[_1]' (ID:[_2]) erfolgreich registriert.},
	q{[_1] registered to the blog '[_2]'} => q{[_1] hat sich für das Blog &#8222;[_2]&#8220; registriert.},

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type konnte den Zielpfad nicht beschreiben. Bitte stellen Sie sicher, daß der Webserver Schreibrechte für dieses Verzeichnis besitzt.',
	q{Cannot make path '[_1]': [_2]} => q{Kann Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]},
	q{Invalid extra path '[_1]'} => q{Ungültiger Zusatzpfad &#8222;[_1]&#8220;},

## addons/Community.pack/lib/MT/Community/Tags.pm
	'Click here to follow' => 'Klicken, um zu folgen',
	'Click here to leave' => 'Klicken, um nicht mehr zu folgen',
	'Click here to recommend' => 'Empfehlen',
	q{You used an '[_1]' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an 'MTIfEntryRecommended' container?} => q{'[_1]'-Befehl außerhalb eines MtIfEntryRecommended-Blocks verwendet - 'MTIfEntryRecommended'-Block erforderlich},

## addons/Community.pack/lib/MT/Community/Upgrade.pm
	'Removing Profile Error global system template...' => 'Entferne globale Profile-Error-Vorlage...',

## addons/Community.pack/templates/blog/about_this_page.mtml
	'This page contains a single entry by <a href="[_1]">[_2]</a> published on <em>[_3]</em>.' => 'Diese Seite enthält einen einen einzelnen Eintrag von <a href="[_1]">[_2]</a> vom <em>[_3]</em>.',

## addons/Community.pack/templates/blog/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Dies ist eine spezielle Widgetgruppe, die vom jeweiligen Archiv-Typ abhängige Informationen ausgibt.',

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Kommentar zu [_1]',

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'Der Inhalt von #comments-content wird durch Aufrufe des Paginierungs-Skripts ersetzt',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Startseite',

## addons/Community.pack/templates/blog/entry_form.mtml
	'Body' => 'Text',
	'Category' => 'Kategorie',
	'In order to create an entry on this blog you must first register.' => 'Um einen Eintrag in diesem Blog anzulegen, registrieren Sie sich bitte erst.',
	'Select Category...' => 'Kategorie wählen...',
	'Sign in to create an entry.' => 'Melden Sie sich an, um einen Eintrag zu schreiben.',
	'Title' => 'Titel',
	q{You don't have permission to post.} => q{Sie haben nicht genügend Benutzerrechte um zu veröffentlichen.},

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => 'Stimme',
	'Votes' => 'Stimmen',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Entry Pending' => 'Eintrag noch nicht freigegeben',
	'Entry Posted' => 'Eintrag veröffentlicht',
	'Thank you for posting an entry.' => 'Danke, daß Sie einen Eintrag geschrieben haben.',
	'Your entry has been posted.' => 'Ihr Eintrag wurde veröffentlicht.',
	'Your entry has been received and held for approval by the blog owner.' => 'Ihr Eintrag ist eingegangen und muss nun vom Blogbetreiber freigeschaltet werden.',
	'Your entry has been received.' => 'Ihr Eintrag ist eingegangen.',
	q{Return to the <a href="[_1]">blog's main index</a>.} => q{Zurück zur <a href="[_1]">Startseite</a>.},

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Diese Widgetgruppe ist zum Einsatz auf der Startseite ("main_index"). ausgelegt. Weitere Informationen: [_1]',

## addons/Community.pack/templates/blog/powered_by.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## addons/Community.pack/templates/forum/category_groups.mtml
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Seien Sie die erste Person, <a href="[_1]">die ein Thema in diesem Forum eröffnet</a>!',
	'Forum Groups' => 'Forengruppen',
	'Last Topic: [_1] by [_2] on [_3]' => 'Letztes Thema: [_1] von [_2] um [_3]',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] antwortete auf <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Antwort schreiben',
	'Reply' => 'Antworten',

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Previewing your Reply' => 'Vorschau Ihrer Antwort',
	'Reply to [_1]' => 'Antwort auf [_1]',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submission Error' => 'Es ist ein Fehler aufgetreten',
	'Reply Submitted' => 'Antwort eingegangen',
	'Return to the <a href="[_1]">original topic</a>.' => 'Zurück zum <a href="[_1]">Ausgangsthema</a>.',
	'Thank you for replying.' => 'Vielen Dank, daß Sie geantwortet haben.',
	'Your reply has been accepted.' => 'Ihre Antwort ist bei uns eingegangen.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Ihre Antwort ist bei uns eingegangen. Sie wird veröffentlicht, sobald der Forums-Administrator sie freigeschaltet hat.',
	'Your reply submission failed for the following reasons: [_1]' => 'Ihr konnte aus folgendem Grund nicht angemommen werden:',

## addons/Community.pack/templates/forum/comments.mtml
	'# Replies' => '# Antworten',
	'1 Reply' => '1 Antwort',
	'No Replies' => 'Keine Antworten',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'Thema eröffnen',

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Neues Thema eröffnen',

## addons/Community.pack/templates/forum/entry_form.mtml
	'Forum' => 'Forum',
	'Select Forum...' => 'Forum wählen...',
	'Topic' => 'Thema',

## addons/Community.pack/templates/forum/entry_popular.mtml
	'By [_1]' => 'Von [_1]',
	'Last Reply' => 'Letzte Antwort',
	'Permalink to this Reply' => 'Peramanenter Link zu dieser Antwort',
	'Popular topics' => 'Beliebte Themen',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Danke, daß Sie ein neues Thema eröffnet haben!',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Ihr Thema ist eingegangen und muss nun vom Forenadministrator freigeschaltet werden.',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Ihr Thema ist eingegangen und wurde veröffentlicht. Vielen Dank!',
	'Topic Pending' => 'Thema noch nicht freigegeben',
	'Topic Posted' => 'Thema veröffentlicht',
	q{Return to the <a href="[_1]">forum's homepage</a>.} => q{Zurück zur <a href="[_1]">Startseite</a> des Forums.},

## addons/Community.pack/templates/forum/entry_table.mtml
	'Closed' => 'Geschlossen',
	'Post the first topic in this forum.' => 'Eröffnen Sie das erste Thema in diesem Forum',
	'Recent Topics' => 'Aktuelle Themen',
	'Replies' => 'Antworten',

## addons/Community.pack/templates/forum/javascript.mtml
	' to reply to this topic,' => 'um auf dieses Thema zu antworten',
	' to reply to this topic.' => 'um auf dieses Thema zu antworten.',
	'. Now you can reply to this topic.' => '. Sie können nun Ihre Antwort schreiben.',
	'Sign in' => 'Anmelden',
	'Thanks for signing in,' => 'Danke für Ihre Anmeldung, ',
	'You do not have permission to comment on this blog.' => 'Sie haben nicht die notwendige Berechtigung, um in diesem Blog Kommentare zu schreiben.',
	'or ' => 'oder ',
	'reply anonymously.' => 'antworten Sie anonym.',

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Startseite',

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Themen zu &#8222;[_1]&8220;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Mit &#8222;[_1]&8220; getaggte Themen',
	'Topics' => 'Themen',

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Alle Foren',
	'[_1] Forum' => '[_1]-Forum',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Zur Ihren eigenen Sicherheit und um Mißbrauch vorzubeugen bestätigen Sie nun bitte Ihre Angaben. Daraufhin können Sie sich sofort bei [_1] anmelden.',
	'Mail Footer' => 'Mail-Signatur',
	'Sincerely,' => ' Ihr',
	'Thank you for registering an account to [_1].' => 'Danke, daß Sie sich ein [_1]-Konto angelegt haben.',
	'Thank you very much for your understanding.' => 'Vielen Dank',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Klicken Sie dazu auf folgenden Link (oder kopieren Sie Adresse und fügen Sie sie in Adresszeile Ihres Browsers ein):',
	q{If you did not make this request, or you don't want to register for an account to [_1], then no further action is required.} => q{Sollten Sie sich nicht angemeldet haben oder sollten Sie sich doch nicht registrieren wollen, brauchen Sie nichts weiter zu tun.},

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Blogbeschreibung',
	'Blog Name' => 'Name des Blogs',

## addons/Community.pack/templates/global/login_form.mtml
	'Forgot your password?' => 'Passwort vergessen?',
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Noch nicht registriert?&nbsp;&nbsp;<a href="[_1]">Einfach jetzt registrieren</a>!',
	'Password' => 'Passwort',
	'Remember me?' => 'Benutzername speichern?',
	'Sign in using' => 'Anmelden mit',
	'Username' => 'Benutzername',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Edit Profile' => 'Profil bearbeiten',
	'Forgot Password' => 'Passwort vergessen',
	'Hello [_1]' => 'Hallo [_1]',
	'Logged in as <a href="[_1]">[_2]</a>' => 'Als <a href="[_1]">[_2]</a> angemeldet',
	'Logout' => 'Abmelden',
	'Sign up' => 'Registrieren',

## addons/Community.pack/templates/global/new_entry_email.mtml
	'Author name: [_1]' => 'Name des Autors: [_1]',
	'Author nickname: [_1]' => 'Nickname des Autors: [_1]',
	'Edit entry:' => 'Eintrag bearbeiten:',
	'Publish Date: [_1]' => 'Veröffentlichungsdatum:',
	'Title: [_1]' => 'Titel: [_1]',
	'View entry:' => 'Eintrag ansehen:',
	q{A new entry '[_1]([_2])' has been posted on your blog [_3].} => q{In Ihrem Blog [_3] wurde ein neuer Eintrag '[_1]([_2])' veröffentlicht.},

## addons/Community.pack/templates/global/new_password.mtml
	'Change Password' => 'Passwort ändern',
	'Change' => 'Ändern',
	'Confirm New Password' => 'Neues Passwort bestätigen',
	'Enter the new password.' => 'Neues Passwort eingeben',
	'New Password' => 'Neues Passwort',

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Es wurde eine E-Mail mit einem Link zum Zurücksetzen Ihres Passwortes an Ihre Adresse ([_1]) verschickt .',
	'Back (x)' => 'Zurück (x)',
	'Go Back (x)' => 'Zurück (x)',
	'Reset (s)' => 'Zurücksetzen (s)',
	'Reset Password' => 'Passwort zurücksetzen',
	'Reset' => 'zurücksetzen',
	'Sign in to Movable Type (s)' => 'Bei Movable Type anmelden (s)',
	'Sign in to Movable Type' => 'Bei Movable Type anmelden',
	'The email address provided is not unique.  Please enter your username.' => 'Die angegebene E-Mail-Adresse wird mehrfach genutzt. Bitte geben Sie stattdessen Ihren Benutzernamen ein.',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Confirm Password' => 'Passwort bestätigen',
	'Current Password' => 'Derzeitiges Passwort',
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]>Zurück zur Ausgangsseite</a> oder <a href="[_2]>Profil ansehen</a>.',
	'Save (s)' => 'Sichern (s)',
	'This profile has been updated.' => 'Profil aktualisiert',
	'Website URL' => 'Website',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Commented on [_1] in [_2]' => '[_1] in [_2] kommentiert',
	'Posted [_1] to [_2]' => '[_1] in [_2] veröffentlicht',
	'Voted on [_1] in [_2]' => 'Für [_1] in [_2] gestimmt',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] hat für <a href="[_2]">[_3]</a> in [_4] gestimmt',

## addons/Community.pack/templates/global/profile_view.mtml
	'Comment Threads' => 'Kommentar-Threads',
	'Commented on [_1]' => '[_1] kommentiert',
	'Favorited [_1] on [_2]' => '[_1] in [_2] zum Favoriten gemacht',
	'Follow' => 'Folgen',
	'No recent actions.' => 'Keine aktuellen Aktionen',
	'No responses to comments.' => 'Keine Kommentarantworten',
	'Not being followed' => 'Niemand folgt Ihnen',
	'Not following anyone' => 'Sie folgen niemandem',
	'Recent Actions from [_1]' => 'Aktuelle Aktionen von [_1]',
	'Recent Actions' => 'Aktuelle Aktionen',
	'Unfollow' => 'Nicht mehr folgen',
	'User Profile' => 'Benutzerprofil',
	'Website:' => 'Website:',
	'You are followed by [_1].' => '[_1] folgt Ihnen.',
	'You are following [_1].' => 'Sie folgen [_1]',
	'You are not followed by [_1].' => '[_1] folgt Ihnen nicht.',
	'[_1] commented on ' => '[_1] kommentierte',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Authentifizierungsmail verschickt',
	'Profile Created' => 'Profil angelegt',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Um die Registrierung abzuschließen, bestätigen Sie bitte Ihre Anmeldung. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Um Ihre Registrierung zu bestätigen und Ihr Konto zu aktivieren, klicken Sie bitte auf den Link in dieser E-Mail.',

## addons/Community.pack/templates/global/register_form.mtml
	'Initial Password' => 'Passwort',
	'Password Confirm' => 'Passwortbestätigung',
	'Repeat the password for confirmation.' => 'Passwort zur Bestätigung wiederholen',
	'Select a password for yourself.' => 'Eigenes Passwort',
	'The URL of your website. (Optional)' => 'URL Ihrer Website (optional)',
	'The name appears on your comment.' => 'Dieser Name wird unter Ihren Kommentaren angezeigt.',
	'Your email address.' => 'Ihre E-Mail-Adresse',
	'Your login name.' => 'Ihr Benutzername',

## addons/Community.pack/templates/global/register_notification_email.mtml
	'Email: [_1]' => 'E-Mail-Adresse:',
	'Full Name: [_1]' => 'Vollständiger Name: [_1]',
	'New User Information:' => 'Informationen über den neuen Benutzer:',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Um das zugehörige Benutzerkonto aufzurufen oder zu bearbeiten, klicken Sie bitte auf folgende Adresse (oder kopieren Sie sie und fügen Sie sie in Adresszeile Ihres Browsers ein):',
	'Username: [_1]' => 'Benutzername: [_1]',
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{Ein neuer Benutzer hat sich erfolgreich für &#8222;[_1]&#8220; registriert. Unten finden Sie nähere Informationen über diesen Benutzer.},

## addons/Community.pack/templates/global/search.mtml
	'Go' => 'Ausführen',

## addons/Community.pack/templates/global/signin.mtml
	'Edit profile' => 'Profil bearbeiten',
	'Not a member? <a href="[_1]">Register</a>' => 'Noch kein Mitglied? <a href="[_1]">Registieren</a>',
	'Sign out' => 'Abmelden',
	'You are signed in as <a href="[_1]">[_2]</a>' => 'Sie sind als <a href="[_1]">[_2]</a> angemeldet.',
	'You are signed in as [_1]' => 'Sie sind als [_1] angemeldet.',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Allow anonymous user to recommend' => 'Anonymen Benutzern erlauben Empfehlen auszusprechen',
	'Anonymous Recommendation' => 'Anonyme Empfehlungen',
	'Archive Root' => 'Archiv-Wurzel',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Anonymen (nicht angemeldeten) Benutzern erlauben, Diskussionen zu empfehlen. Die IP-Adressen nicht angemeldeter Benutzer werden gespeichert.',
	'Community Settings' => 'Community',
	'If enabled, all moderated entries will be filtered by Junk Filter.' => 'Wenn diese Option aktiviert ist, werden moderierte Einträge automatisch auf Spam überprüft.',
	'Junk Filter' => 'Spam-Filter',
	'Site Root' => 'Wurzelverzeichnis',
	'Upload Destination' => 'Zielverzeichnis',
	'You must set a valid path.' => 'Bitte geben Sie einen gültigen Pfad an.',
	'Your preferences have been saved.' => 'Die Einstellungen wurden gespeichert.',

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Author' => 'Autor',
	'Recent Registrations' => 'Aktuelle Registrierungen',
	'You have [quant,_1,registration,registrations] from [_2]' => 'Sie haben [quant,_1,Registrierung,Registrierungen] von [_2]',
	'default userpic' => 'Standard-Benutzerbild',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'Keine beliebten Einträge.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml
	'No Title' => 'Kein Name',
	'No entries available.' => 'Keine Einträge vorhanden.',
	'Posted by [_1] [_2] in [_3]' => 'Von [_1] [_2] in [_3]',
	'Posted by [_1] [_2]' => 'Von [_1] [_2]',
	'Tagged: [_1]' => 'Getaggt: [_1]',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'Keine kürzlich als Favoriten gespeicherte Einträge.',

## addons/Enterprise.pack/app-cms.yaml
	'Add user to group' => 'Benutzer zu Gruppe hinzufügen',
	'Are you sure you want to delete the selected group(s)?' => 'Gewählte Gruppe(n) wirklich löschen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Gewählte(n) Benutzer wirklich aus Gruppe entfernen?',
	'Bulk Author Export' => 'Stapelexport von Autoren',
	'Bulk Author Import' => 'Stapelimport von Autoren',
	'Disable' => 'Deaktivieren',
	'Enable' => 'Aktivieren',
	'Groups ([_1])' => 'Gruppen ([_1])',
	'Groups' => 'Gruppen',
	'Manage Member' => 'Mitglieder verwalten',
	'Remove' => 'Entfernen',
	'Synchronize Groups' => 'Gruppen synchronisieren',
	'Synchronize Users' => 'Benutzer synchronisieren',
	q{[_1]'s Group} => q{Gruppen von [_1]},

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Dieses Modul ist zur Nutzung der LDAP-Authentifizierung erforderlich.',

## addons/Enterprise.pack/config.yaml
	'Active Groups' => 'Aktive Gruppen',
	'Active' => 'Aktiv',
	'Advanced Pack' => 'Advanced-Pack',
	'Disabled Groups' => 'Deaktivierte Gruppen',
	'Disabled Users' => 'Deaktivierte Benutzerkonten',
	'Disabled' => 'Deaktiviert',
	'Email' => 'E-Mail',
	'Enabled Users' => 'Aktive Benutzerkonten',
	'Enabled' => 'Aktiviert',
	'External Directory Synchronization' => 'Synchronisierung mit externem Verzeichnis',
	'Group Member' => 'Groupmember',
	'Group Members' => 'Gruppenmitglieder',
	'Group Name' => 'Gruppenname',
	'Group' => 'Gruppe',
	'Groups associated with author: [_1]' => 'Mit Autor verknüpfte Gruppen: [_1]',
	'Inactive' => 'Inaktiv',
	'Invalid parameter.' => 'Parameter ungültig.',
	'Manage Group Members' => 'Gruppenmitglieder verwalten',
	'Members of group: [_1]' => 'Gruppenmitglieder: [_1]',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Microsoft SQL Server-Datenbank mit UTF-8-Unterstützung (empfohlen)',
	'Microsoft SQL Server Database' => 'Microsoft SQL Server-Datenbank',
	'My Groups' => 'Meine Gruppen',
	'ODBC Driver' => 'ODBC-Treiber',
	'Oracle Database (Recommended)' => 'Oracle-Datenbank (empfohlen)',
	'Pending' => 'Auf Moderation wartend',
	'Permissions for Groups' => 'Gruppen-Berechtigungen',
	'Permissions for Users' => 'Benutzer-Berechtigungen',
	'Permissions of group: [_1]' => 'Gruppen-Berechtigungen: [_1]',
	'Publish Charset' => 'Zeichenkodierung',
	'Status' => 'Status',
	'User Info' => 'Benutzerinfo',
	'User' => 'Benutzer',
	'User/Group Name' => 'Benutzer-/Gruppen-Name',
	'User/Group' => 'Benutzer/Gruppe',
	'__COMMENT_COUNT' => 'Kommentare',
	'__ENTRY_COUNT' => 'Einträge',
	'__GROUP_MEMBER_COUNT' => 'Mitglieder',
	q{Populating author's external ID to have lower case user name...} => q{Setze externe Benutzerkennung für kleingeschriebene Benutzernamen...},

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'(none)' => '(Keine)',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Es wurde versucht, alle Administratorenkonten zu deaktivieren. Synchronisation unterbrochen.',
	'Cannot connect to LDAP server.' => 'Es konnte keine Verbindung zum LDAP-Server hergestellt werden.',
	'Cannot synchronize LDAP groups members.' => 'LDAP-Gruppenmitglieder konnten nicht synchronisiert werden.',
	'External user synchronization failed.' => 'Synchronisierung externer Benutzer fehlgeschlagen.',
	'Failed to create a new group: [_1]' => 'Fehler beim Anlegen einer neuen Gruppe: [_1]',
	'Information about the following groups was modified:' => 'Folgende Gruppen wurden bearbeitet:',
	'Information about the following users was modified:' => 'Folgende Benutzerkonten wurden bearbeitet:',
	'LDAP groups synchronized with existing groups.' => 'LDAP-Gruppen mit vorhandenen Gruppen sychnronisiert.',
	'LDAP user [_1] not found.' => 'LDAP-Benutzerkonto [_1] nicht gefunden.',
	'LDAP users synchronization interrupted.' => 'LDAP-Benutzersynchronisierung unterbrochen.',
	'LDAP users synchronized.' => 'LDAP-Benutzer synchronisiert.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'Zur Synchronisierung von Gruppen muss LDAPUserGroupMemberAttribute gesetzt sein.',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Laden von MT::LDAP::Multi fehlgeschlagen: [_1]',
	'Members added: ' => 'Hinzugefügte Mitglieder:',
	'Members removed: ' => 'Entfernte Mitglieder:',
	'No LDAP group was found using the filter provided.' => 'Keine LDAP-Gruppe mit dem angegebenen Filter gefunden.',
	'Primary group members cannot be synchronized with Active Directory.' => 'Primäre Gruppenmitglieder können nicht per Active Directory synchronisiert werden.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'Zur Synchronisierung von Gruppen muss LDAPGroupIDAttribute und/oder LDAPGroupNameAttribute gesetzt sein.',
	'The following groups were deleted:' => 'Die folgenden Gruppen wurden gelöscht:',
	'The following users were disabled:' => 'Folgende Benutzerkonten wurden deaktiviert:',
	'User [_1] cannot be updated.' => 'Benutzerkonto [_1] kann nicht aktualisiert werden.',
	'User [_1]([_2]) not found.' => 'Benutzerkonto [_1]([_2]) nicht gefunden.',
	'User cannot be created: [_1].' => 'Kann Benutzerkonto nicht anlegen: [_1].',
	'User cannot be updated: [_1].' => 'Benutzerkonto kann nicht aktualisiert werden: [_1].',
	'User filter was not built: [_1]' => 'Benutzerfilter nicht erzeugt: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => '[_1]-Direktive muss gesetzt sein, um LDAP-Gruppenmitgliedschaften mit Movable Type Advanced zu synchronisieren.',
	q{Cannot get group '[_1]' (#[_2]) entry and its all member attributes from external directory.} => q{Kann Mitglieder und Attribute der Gruppe '[_1]' (#2) nicht aus externem Verzeichnis beziehen.},
	q{Cannot get member entries of group '[_1]' (#[_2]) from external directory.} => q{Kann Mitgliedseinträge der Gruppe '[_1]' (#2) nicht aus externem Verzeichnis beziehen.},
	q{Failed login attempt by user '[_1]' who was deleted from LDAP.} => q{Fehlgeschlagener Anmeldeversuch von aus LDAP gelöschtem Benutzer '[_1]'.},
	q{Failed login attempt by user '[_1]'. A user with that username already exists in the system with a different UUID.} => q{Fehlgeschlagener Anmeldeversuch von Benutzer '[_1]'. Es ist weiterer Benutzer mit gleichem Benutzernamen, aber anderer UUID im System vorhanden.},
	q{Memberships in the group '[_2]' (#[_3]) were changed as a result of synchronizing with the external directory.} => q{Mitgliedschaften der Gruppe '[_2]' (#[_3]) wurden durch die Synchronisierung mit dem externen Verzeichnis verändert.},
	q{The filter used to search for groups was: '[_1]'. Search base was: '[_2]'} => q{Für die Gruppensuche verwendeter Filter: '[_1]'. Suchbasis: '[_2]'},
	q{User '[_1]' account is disabled.} => q{Benutzerkonto '[_1]' ist deaktiviert.},
	q{User '[_1]' cannot be updated.} => q{Benutzerkonto '[_1]' kann nicht aktualisiert werden.},
	q{User '[_1]' updated with LDAP login ID.} => q{Benutzerkonto '[_1]' mit LDAP-Login-ID aktualisiert.},
	q{User '[_1]' updated with LDAP login name '[_2]'.} => q{Benutzerkonto '[_1]' mit LDAP-Login-Name aktualisiert.},

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAP konnte nicht geladen werden: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Benutzer mit gleichem Namen gefunden und Konto daher nicht angelegt: [_1]',
	'Formatting error at line [_1]: [_2]' => 'Formatierungsfehler in Zeile [_1]: [_2]',
	'Invalid blog URL: [_1]' => 'Ungültige Blog-URL: [_1]',
	'Invalid command: [_1]' => 'Unbekannter Befehl: [_1]',
	'Invalid display name: [_1]' => 'Ungültiger Anzeigename: [_1]',
	'Invalid email address: [_1]' => 'Ungültige E-Mail-Adresse: [_1]',
	'Invalid language: [_1]' => 'Sprache ungültig: [_1]',
	'Invalid number of columns for [_1]' => 'Ungültige Spaltenzahl für [_1]',
	'Invalid password: [_1]' => 'Ungültiges Passwort: [_1]',
	'Invalid site root: [_1]' => 'Ungültiges Wurzelverzeichnis: [_1]',
	'Invalid theme ID: [_1]' => 'Ungültige Themen-ID: [_1]',
	'Invalid timezone: [_1]' => 'Ungültige Zeitzone: [_1]',
	'Invalid user name: [_1]' => 'Ungültiger Benutzername: [_1]',
	'Invalid weblog name: [_1]' => 'Ungültiger Weblogname: [_1]',
	q{'Personal Blog Location' setting is required to create new user blogs.} => q{Zum Anlegen neuer Benutzerblogs muss in den Einstellungen deren Speicherort angegeben sein.},
	q{A theme '[_1]' was not found.} => q{Thema '[_1]' nicht gefunden.},
	q{Blog '[_1]' for user '[_2]' has been created.} => q{Blog '[_1]' für Benutzer '[_2]' angelegt.},
	q{Blog for user '[_1]' can not be created.} => q{Blog für Benutzer '[_1]' kann nicht angelegt werden.},
	q{Error assigning weblog administration rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable weblog administrator role was found.} => q{Fehler bei der Zuweisung von Blog-Administrationsrechten für Blog '[_3] (ID: [_4])' an Benutzer '[_1] (ID: [_2])'. Keine geeignete Administratorenrolle gefunden.},
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
	'Add Users to Group [_1]' => 'Benutzer zu Gruppe [_1] hinzufügen',
	'Add Users to Groups' => 'Benutzer zu Gruppen hinzufügen',
	'An error occurred when enabling this user.' => 'Bei der Aktivierung dieses Benutzerkontos ist ein Fehler aufgetreten',
	'Assign User [_1] to Groups' => 'Gruppen an Benutzer [_1] zuweisen',
	'Author load failed: [_1]' => 'Fehler beim Laden eines Autoren: [_1]',
	'Bulk author export cannot be used under external user management.' => 'Stapelexport von Benutzerkonten bei externer Benutzerverwaltung nicht möglich.',
	'Bulk import cannot be used under external user management.' => 'Stapelimport ist bei externer Benutzerverwaltung nicht möglich.',
	'Bulk management' => 'Stapelverwaltung',
	'Cannot rewind' => 'Kann nicht zurückspulen',
	'Each group must have a name.' => 'Jede Gruppe muss einen eigenen Namen haben.',
	'Group Profile' => 'Gruppenprofile',
	'Group load failed: [_1]' => 'Fehler beim Laden einer Gruppe:',
	'Groups Selected' => 'Gewählte Gruppen',
	'Invalid group' => 'Ungültige Gruppe',
	'Invalid user' => 'Ungültiger Benutzer',
	'Load failed: [_1]' => 'Beim Laden ist ein Fehler augetreten: [_1]',
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced hat während der Synchronisation versucht, Ihr Benutzerkonto zu deaktivieren. Das deutet auf einen Fehler in der externen Benutzerverwaltung hin. Überprüfen Sie daher die dortigen Einstellungen, bevor Sie Ihre Arbeit in Movable Type forsetzen.',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Keine Einträge in Datei gefunden. Bitte stellen Sie sicher, daß für die Zeilenenden CRLF verwendet wird.',
	'Please select a file to upload.' => 'Bitte wählen die Datei aus, die Sie hochladen möchten.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Benutzer] registiert, [quant,_2,Benutzerkonto,Benutzerkonten] aktualisiert, [quant,_3,Benutzerkonto,Benutzerkonten] gelöscht.',
	'Search Groups' => 'Gruppen suchen',
	'Search Users' => 'Benutzer suchen',
	'Select Groups' => 'Gruppen auswählen',
	'Select Users' => 'Gewählte Benutzer',
	'Type a group name to filter the choices below.' => 'Geben Sie einen Gruppennamen ein, um die Auswahl einzuschränken.',
	'Type a username to filter the choices below.' => 'Geben Sie einen Benutzernamen ein, um die Auswahl einzuschränken',
	'User load failed: [_1]' => 'Fehler beim Laden eines Benutzers:',
	'Users & Groups' => 'Benutzer und Gruppen',
	'Users Selected' => 'Gewählte Benutzer',
	'Users' => 'Benutzer',
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{Benutzer '[_1]' (ID:[_2]) von '[_5]' aus Gruppe '[_3]' (ID:[_4]) entfernt},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{Benutzer '[_1]' (ID:[_2]) von '[_5]' zu Gruppe '[_3]' (ID:[_4]) hinzugefügt},

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Parameter "[_1]" ist ungültig.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => '"member"-Angabe erforderlich.',
	'Adding member to group failed: [_1]' => 'Hinzufügen des Mitglieds zur Gruppe ist fehlgeschlagen: [_1]',
	'Cannot add member to inactive group.' => 'Zu inaktiven Gruppen können keine Mitglieder hinzugefügt werden.',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Das Anlegen der Gruppe ist fehlgeschlagen: ExternalGroupmanagement ist aktiv.',
	'Group not found' => 'Gruppe nicht gefunden',
	'Member not found' => 'Mitglied nicht gefunden',
	'Removing member from group failed: [_1]' => 'Entfernen des Mitglieds aus der Gruppe ist fehlgeschlagen: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Verknüpfung nicht gefunden',
	'Granting permission failed: [_1]' => 'Zuweisen der Berechtigung fehlgeschlagen: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Bereite Binärdaten zur Speicherung in Microsoft SQL Server vor...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => 'Gefunden',
	'Login' => 'Login',
	'Not Found' => 'Nicht gefunden',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/Group.pm
	'Backing up [_1] records:' => 'Sichere [_1]-Einträge:',
	'[_1] records backed up.' => '[_1] Einträge gesichert',

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

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Cancel (x)' => 'Abbrechen (x)',
	'Manage Users in bulk' => 'Benutzerverwaltung im Stapel',
	'Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.' => 'Movable Type versucht automatisch die Zeichenkodierung Ihrer Importdatei zu ermitteln. Sie können die Kodierung aber auch selbst angeben.',
	'Source File Encoding' => 'Zeichenkodierung der Quelldatei',
	'Specify the CSV-formatted source file for upload' => 'Geben Sie die hochzuladende CSV-Quelldatei an',
	'Upload (u)' => 'Hochladen (u)',
	'Upload source file' => 'Quelldatei hochladen',
	'Upload' => 'Hochladen',
	'[_1] Edit</a>' => '[_1] bearbeiten</a>',
	'[_1] Setting</a>' => '[_1]-Einstellungen</a>',
	'_USAGE_AUTHORS_2' => 'Sie können Benutzerkonto im Stapel anlegen, bearbeiten und löschen, indem Sie CSV-formatierte Steuerungsdatei mit den entsprechenden Daten und Befehlen hochladen.',
	q{New user blog would be created on '[_1]'.} => q{Neue Benutzerblogs werden auf '[_1]' angelegt.},
	q{You must set 'Personal Blog Location' to create a new blog for each new user.} => q{Um für neue Benutzer automatisch neue Blogs anzulegen, legen Sie bitte deren Speicherort fest.},

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'(and [_1] more groups)' => '(und [_1] weitere Gruppen)',
	'(and [_1] more members)' => '(und [_1] weitere Mitglieder)',
	'15 Minutes' => '15 Minuten',
	'30 Minutes' => '30 Minuten',
	'60 Minutes' => '60 Minuten',
	'90 Minutes' => '90 Minuten',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Es konnte keine Verbindung zum LDAP-Server aufgebaut werden: ',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Optionaler DN zur LDAP-Bindung bei der Benutzersuche',
	'Attribute mapping' => 'Attributzuordnung',
	'Authentication Configuration' => 'Authentifizierungs- Einstellungen',
	'Authentication DN' => 'Authentifizierungs-DN',
	'Authentication URL' => 'Authentifizierungs-URL',
	'Authentication password' => 'Authentifizierungs- Passwort',
	'CN' => 'CN (Common Name)',
	'Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'Kann Net::LDAP nicht finden. Net::LDAP ist zur Authentifizierung über LDAP erforderlich.',
	'Continue' => 'Weiter',
	'Email Attribute' => 'Email-Attribut',
	'Enable External User Management' => 'Externe Benutzerverwaltung aktivieren',
	'Group Filter Attribute' => 'Groupfilter-Attribut',
	'Group Fullname Attribute' => 'Groupfullname-Attribut',
	'Group Fullname' => 'Groupfullname',
	'Group Member Attribute' => 'Groupmember-Attribut',
	'Group Name Attribute' => 'Groupname-Attribut',
	'Group Search Base Attribute' => 'Groupsearchbase-Attribut',
	'GroupID Attribute' => 'GroupID-Attribut',
	'LDAP Server' => 'LDAP-Server',
	'No groups could be found.' => 'Keine Gruppen gefunden.',
	'No groups were found with these settings.' => 'Keine Gruppe mit diesen Einstellungen gefunden.',
	'No users could be found.' => 'Keine Benutzer gefunden.',
	'Other' => 'Anderer',
	'SASL Mechanism' => 'SASL-Mechanismus',
	'Search Result (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'Search Results (max 10 entries)' => 'Suchergebnis (ersten 10 Treffer)',
	'Select One...' => 'Auswählen...',
	'Synchronization Frequency' => 'Aktualisierungsintervall',
	'Test Password' => 'Test-Passwort',
	'Test Username' => 'Test-Benutzername',
	'Test connection to LDAP' => 'LDAP-Verbindung testen',
	'Test search' => 'Testsuche',
	'The URL to access for LDAP authentication.' => 'Adresse (URL) zur LDAP-Authentifizierung',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'Synchronisierungintervall in Minuten (Standard: alle 60 Minuten)',
	'The name of the SASL Mechanism used for both binding and authentication.' => 'Name des zur Bindung und zur Authentifizierung verwendeten SASL-Mechanismus',
	'Use LDAP' => 'LDAP verwenden',
	'Used for setting the password of the LDAP DN.' => 'Wird zur Einstellung des LDAP DN-Passworts verwendet',
	'User Fullname Attribute' => 'Userfullname-Attribut',
	'User Fullname' => 'Userfullname',
	'User ID Attribute' => 'UserID-Attribut',
	'User Member Attribute' => 'Usermember-Attribut',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'Wenn Sie LDAP-Authentifizierung verwenden möchten, können Sie hier die entsprechenden Einstellungen vornehmen.',
	'You must set your Authentication URL.' => 'Authentifizierungs-URL erforderlich',
	'You must set your Group search base.' => 'Groupsearchbase-Attribut erforderlich',
	'You must set your GroupID attribute.' => 'GroupID-Attribut erforderlich',
	'You must set your UserID attribute.' => 'UserID-Attribut erforderlich',
	'You must set your email attribute.' => 'Email-Attribut erforderlich',
	'You must set your group fullname attribute.' => 'Groupfullname-Attribut erforderlich',
	'You must set your group member attribute.' => 'Groupmember-Attribut erforderlich',
	'You must set your group name attribute.' => 'Groupname-Attribut erforderlich',
	'You must set your user fullname attribute.' => 'Userfullname-Attribut erforderlich',
	'You must set your user member attribute.' => 'Usermember-Attribut erforderlich',
	'Your LDAP configuration is complete.' => 'Ihre LDAP-Konfigurierung ist abgeschlossen.',
	'Your configuration was successful.' => 'Konfigurierung erfolgreich.',
	q{Click 'Continue' below to configure the External User Management settings.} => q{Klicken Sie auf 'Weiter', um die externe Benutzerverwaltung zu konfigurieren.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Klicken Sie auf 'Weiter', um die LDAP-Attribute zuzuweisen.},
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Mit einem Klick auf 'Weiter' schließen Sie die Konfigurierung ab.},

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Alle Benutzerkonten erfolgreich aktualisiert.',
	'An error occurred during the update process. Please check your CSV file.' => 'Bei der Aktualisierung ist ein Fehler aufgetreten. Überprüfen Sie die CSV-Datei.',
	'Close' => 'Schließen',

## addons/Enterprise.pack/tmpl/dialog/dialog_select_group_user.tmpl
	'Close (x)' => 'Schließen (x)',
	'No groups exist in this installation. [_1]Create a group</a>' => 'In dieser MT-Installation ist keine Gruppe vorhanden. [_1]Gruppe anlegen</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'In dieser MT-Installation ist kein Benutzer vorhanden. [_1]Benutzer anlegen</a>',

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'Bitte legen Sie einige Gruppen an.',
	q{Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Click here</a> to create a group.} => q{Bitte legen Sie zuerst einige Gruppen an. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Klicken Sie hier </a> um Gruppen anzulegen.},

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Create Group' => 'Gruppe anlegen',
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
	'System' => 'System',
	'The LDAP directory ID for this group.' => 'Die ID dieser Gruppe im LDAP-Verzeichnis',
	'The description for this group.' => 'Die Beschreibung dieser Gruppe.',
	'The display name for this group.' => 'Der Anzeigename dieser Gruppe',
	'The name used for identifying this group.' => 'Der zur Idenfifizierung diesser Gruppe verwendete Name',
	'This group profile has been updated.' => 'Gruppenprofil aktualisiert.',
	'This group was classified as disabled.' => 'Gruppe deaktiviert.',
	'This group was classified as pending.' => 'Gruppe auf wartend gesetzt.',
	'Useful links' => 'Nützliche Links',
	'_USER_DISABLED' => 'Deaktiviert',
	'_USER_ENABLED' => 'Aktiviert',
	'_USER_STATUS_CAPTION' => 'Status',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'Disable selected group (d)' => 'Gew?hlte Gruppe deaktivieren (d)',
	'Enable selected group (e)' => 'Gew?hlte Gruppe aktivieren (e)',
	'Members' => 'Mitglieder',
	'Remove selected group (d)' => 'Gew?hlte Gruppe entfernen (d)',
	'_USER_DISABLE' => 'Deaktivieren',
	'_USER_ENABLE' => 'Aktivieren',
	'group' => 'Gruppe',
	'groups' => 'Gruppen',
	'to act upon' => 'bearbeiten',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Permissions for [_1]' => 'Berechtigungen für [_1]',
	'Users &amp; Groups for [_1]' => 'Benutzer und Gruppen für [_1]',

## addons/Enterprise.pack/tmpl/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'Gruppen erfolgreich aus der Movable Type-Installation gelöscht.',
	'You successfully disabled the selected group(s).' => 'Gruppe(n) erfolgreich deaktiviert.',
	'You successfully enabled the selected group(s).' => 'Gruppe(n) erfolgreich aktiviert.',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Bei der Synchronisierung ist ein Fehler aufgetreten. Nähere Informationen finden Sie im <a href='[_1]'>Aktivitätsprotokoll</a>.},
	q{You successfully synchronized the groups' information with the external directory.} => q{Gruppendaten erfolgreich mit externem Verzeichnis synchronisiert.},

## addons/Enterprise.pack/tmpl/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Einige ([_2]) der Benutzerkonten wurden nicht wieder aktiviert, da sie nicht mehr im LDAP vorhanden sind.',
	'You successfully added new users to this group.' => 'Benutzer erfolgreich zu Gruppe hinzugefügt.',
	'You successfully deleted the users.' => 'Benutzerkonten erfolgreich gelöscht.',
	'You successfully removed the users from this group.' => 'Benutzer erfolgreich aus Gruppe entfernt.',
	q{You successfully synchronized users' information with the external directory.} => q{Benutzerdaten erfolgreich mit externem Verzeichnis synchronisiert.},

## addons/Sync.pack/config.yaml
	'Contents Sync' => 'Inhalte synchonisieren',
	'Create new sync setting' => 'Neue Synchronisations-Einstellung erstellen',
	'Manage Sync Settings' => 'Synchronisations-Einstellungen bearbeiten',
	'Migrated sync setting' => 'Sync-Einstellungen migriert',
	'Migrating settings of contents sync on blog...' => 'Migriere Synchronisations-Einstellungen für Blog...',
	'Migrating settings of contents sync on website...' => 'Migriere Synchronisations-Einstellungen für Website...',
	'Re-creating job of contents sync...' => 'Erstelle Synchronisations-Jobs neu...',
	'Remove sync PID files' => 'PID-Dateien entfernen',
	'Remove unnecessary sync file list' => '',
	'Sync Datetime' => 'Zeitpunkt',
	'Sync Log' => '',
	'Sync Name' => 'Name der Synchronisations-Einstellung',
	'Sync Setting' => 'Synchronisations-Einstellung',
	'Sync Settings' => 'Synchronisations-Einstellungen',
	'Sync' => 'Sync',
	'Updating MT::SyncSetting table...' => 'Aktualisiere MT::SyncSetting-Tabelle...',
	'https://www.sixapart.com/movabletype/' => '',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'Kann Vorlage nicht laden.',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Mailversand fehlgeschlagen ([_1]). Sind die MailTransfer-Einstellungen richtig?',
	'Synchronization error notification' => 'Benachrichtigung bei fehlgeschlagener Synchronisation',
	'Synchronization start notification' => '',
	'Synchronization success notification' => 'Benachrichtigung bei erfolgreicher Synchronisation',
	q{Cannot find author for id '[_1]'} => q{Kein Autor mit ID [_1] gefunden},

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'  tried [_1] times but failed. ([_2]): [_3]' => '',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Es sind Dateien  oder Ordner vorhanden, deren Namen mit einem Punkt (.) oder Leerzeichen enden. Diese Elemente können nicht synchronisiert werden: [_2]',
	'Failed to create sync list.' => 'Konnte Synchronisations-Liste nicht anlegen.',
	'Some files/directories are not removed from [_1]: [_2]' => '',
	'Unable to write remote files ([_1]): [_2]' => 'Remote-Dateien ([_1]) konnten nicht geschrieben werden: [_2]',
	q{Cannot access to remote directory '[_1]'} => q{Auf das Remote-Verzeichnis '[_1]' kann nicht zugegriffen werden.},
	q{Failed to remove sync list. (ID:'[_1]')} => q{Konnte Synchronisations-Liste nicht löschen. (ID:'[_1]')},
	q{Failed to update sync list. (ID:'[_1]')} => q{Konnte Synchronisations-Liste nicht aktualisieren. (ID:'[_1]')},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Es ist ein Rsync-Fehler aufgetreten, Exit-Code [_1]: [_2]',
	'Error switching directory.' => 'Fehler beim Verzeichniswechsel.',
	'Failed to remove "[_1]": [_2]' => '"[_1]" konnte nicht entfernt werden: [_2]',
	'Incomplete file copy to Temp Directory.' => 'Datei unvollständig in das temporäre Verzeichnis kopiert.',
	'Temp Directory [_1] is not writable.' => 'Das temporäre Verzeichnis [_1] kann nicht beschrieben werden.',

## addons/Sync.pack/lib/MT/MergedSyncStatus.pm
	'Failed to update sync file status.: "[_1]"' => '',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Synchronisations-Dateiliste',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*Sync setting deleted*' => '*Synchronisation-Einstellung gelöscht*',
	'*User deleted*' => 'Benutzer gelöscht',
	'Are you sure you want to reset the sync log?' => 'Synchronisation-Protokoll wirklich zurücksetzen?',
	'By' => 'Von',
	'Clear Sync Log' => 'Synchronisation-Protokoll leeren',
	'Destination Name' => 'Zielname',
	'Download Sync Log (CSV)' => 'Synchronisation-Protokoll herunterladen (CSV)',
	'Error' => 'Fehler',
	'FTP Server' => 'FTP-Server',
	'FTP' => 'FTP',
	'Finish Date' => 'End-Datum',
	'Finish Time' => 'End-Zeitpunkt',
	'Message' => 'Mitteilung',
	'Notify To' => '',
	'Parallel' => 'Parallel',
	'Port' => 'Port',
	'Rsync Additional Options' => 'Rsync-Optionen',
	'Rsync Destination' => 'Rsync-Ziel',
	'Rsync' => 'Rsync',
	'Scheduled' => 'Zu bestimmtem Zeitpunkt',
	'Showing only ID: [_1]' => 'Zeige nur ID [_1]',
	'Site Path' => 'Lokaler Pfad',
	'Start Date' => 'Start-Datum',
	'Start Directory' => 'Ausgangsverzeichnis',
	'Start Time' => 'Start-Zeitpunkt',
	'Success' => 'Erfolg',
	'Suspended' => '',
	'Sync Logs' => 'Synchronisation-Protokolle',
	'Sync Result' => 'Synchronisation-Ergebnis',
	'Sync Type' => 'Art der Synchronisation',
	'Trigger' => 'Auslöser',
	'[_1] in [_2]: [_3]' => '[_1] in [_2]: [_3]',

## addons/Sync.pack/lib/MT/SyncQueue.pm
	'Sync Queue' => '', # Translate - New

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Synchronisations-Einstellungen',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '', # Translate - New

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	', Error: [_1]' => '',
	'Date: [_1], Blog: [_2]' => '',
	'Date: [_1], Website: [_2]' => '',
	'Failed to Synchronization([_1]) with an external server([_2]).' => 'Synchronisation([_1]) mit externem Server([_2]) fehlgeschlagen.',
	'Failed to insert a new job for ([_1])' => '',
	'Sync setting # [_1] not found.' => 'Synchronisations-Einstellungen [_1] nicht gefunden.',
	'Sync setting ([_1]) is being processed already.' => '',
	'Synchronization has successfully finished.' => 'Synchronisation erfolgreich abgeschlossen.',
	'Synchronization has successfully suspended.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully finished.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully resumed.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully started.' => '',
	'Synchronization([_1]) with an external server([_2]) has successfully suspended.' => '',
	q{Failed to save sync list. (ID:'[_1]')} => q{Konnte Synchronisations-Liste nicht speichern. (ID:'[_1]')},

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Immediate sync job for [_1] is registered by [_2]' => '',
	'Permission denied: [_1]' => 'Zugriff verweigert: [_1]',
	'Save failed: [_1]' => 'Beim Speichern ist ein Fehler aufgetreten: [_1]',
	'Saving sync settings failed: [_1]' => 'Sichern der Synchronisations-Einstellungen fehlgeschlagen: [_1]',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => 'Vorherige Synchronisations-Dateiliste geleert. [_1] von [_2].',
	'The sync setting with the same name already exists.' => 'Synchronisations-Einstellungen mit diesem Namen existieren bereits.',
	'[_1] (copy)' => '', # Translate - New
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{Bei der Verbindung mit dem FTP-Server '[_1]' ist ein Fehler aufgetreten: [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{}, # Translate - New
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{}, # Translate - New
	q{Deleting sync file list failed "[_1]": [_2]} => q{Löschen der Synchronisations-Dateiliste mit '[_1]' fehlgeschlagen: [_2]},
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{}, # Translate - New
	q{Queued items for destination '[_1]' is removed by [_2].} => q{},
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{Synchronisations-Einstellung '[_1]' (ID: [_2]) von [_3] gelöscht.},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{Synchronisations-Einstellung '[_1]' (ID: [_2]) von [_3] bearbeitet.},
	q{Synchronization log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{},
	q{Synchronization log for website '[_1]' (ID:[_2]) reset by '[_3]'} => q{},
	q{Synchronization log reset by '[_1]'} => q{Synchronisations-Protokoll von '[_1]' zurückgesetzt},
	q{Synchronization status information for destination '[_1]' is removed by [_2].} => q{},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Entferne alle Synchronisations-Jobs...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'@' => '@',
	'A duplicate destination name exists.' => 'Zielname bereits vorhanden.',
	'Add destination' => 'Ziel hinzufügen',
	'After a sync job is executed, an email notification will be sent to the user who registered the job, and to the system administrator (default) or the recipient specified above.' => 'Nach erfolgter Synchronisation wird eine E-Mail-Benachrichtigung an den Benutzer, der die Synchronisation angelegt hat, verschickt. Außerdem erhält als Standard der Administrator oder der oben angegebene Empfänger die Benachrichtigung.',
	'Are you sure you want to clear synchronization queue of this destination?' => '',
	'Are you sure you want to clear synchronization status of this destination?' => '',
	'Are you sure you want to clear the previous synchronization file list?' => 'Vorherige Synchronisations-Dateiliste wirklich leeren?',
	'Are you sure you want to register immediate sync job?' => '',
	'Are you sure you want to remove this settings?' => 'Diese Einstellung wirklich entfernen?',
	'Clear synchronization queue' => '',
	'Clear synchronization status' => '',
	'Clear the previous synchronization file list' => 'Vorherige Synchronisations-Dateiliste leeren',
	'Contents Sync Settings' => 'Synchronisations-Einstellungen',
	'Contents sync settings has been saved.' => 'Synchronisations-Einstellungen gespeichert.',
	'Copy this sync setting' => 'Diese Synchronisations-Einstellung kopieren',
	'Deleting...' => 'Lösche...',
	'Destination ID' => '',
	'Destination name should be shorter than [_1] characters.' => 'Zielnamen dürfen höchstens [_1] Zeichen lang sein.',
	'Destinations' => 'Synchronisations-Ziele',
	'Do not send .htaccess and .htpasswd file' => '.htaccess- und .htpasswd-Dateien nicht senden',
	'Enable SSL' => 'SSL aktivieren',
	'Immediate sync job is being registered. This job will be executed in next run-periodic-tasks execution.' => '',
	'Invalid date.' => 'Ungültiges Datum',
	'Invalid time.' => 'Zeitangabe ungültig.',
	'Loading...' => 'Lade...',
	'OK' => 'OK',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Mindestens eine Vorlage wird dynamisch veröffentlicht. Dynamische Veröffentlichung wird vom Zielserver möglicherweise nicht unterstützt.',
	'Please select a sync type.' => 'Bitte wählen Sie eine Synchronisationsart',
	'Receive only error notification' => 'Nur bei Fehlern benachrichtigen',
	'Recipient for Notification' => 'Benachrichtigungs-Empfänger',
	'Register immediate sync job' => '',
	'Remove queued items to abort synchronization.' => '',
	'Remove synchronization status information.' => '',
	'SSL is not available.' => '',
	'SSL' => 'SSL',
	'Save changes to these settings (s)' => 'Änderungen speichern (s)',
	'Sync Date' => 'Synchronisations-Zeitpunkt',
	'Sync Type *' => 'Synchronisationsart *',
	'Sync all files' => 'Alle Dateien synchronisieren',
	'Sync name is required.' => 'Bitte geben Sie einen Namen an.',
	'Sync name should be shorter than [_1] characters.' => 'Der Name sollte höchstens [_1] Zeichen lang sein.',
	'Sync setting is not saved yet' => '',
	'Sync type not selected' => 'Keine Synchronisationsart gewählt',
	'The previous synchronization file list has been cleared.' => 'Vorherige Synchronisations-Dateiliste geleert.',
	'The sync date must be in the future.' => 'Der Zeitpunkt der Synchronisation muss in der Zukunft liegen.',
	'The sync settings has been copied but not saved yet.' => 'Die Synchronisations-Einstellungen wurden kopiert, aber noch nicht gesichert.',
	'This destination has been synchronized before.' => '',
	'This destination has never been synchronized.' => '',
	'This destination is queued to be synchronized.' => '',
	'This destination will be fully synchronized next time.' => '',
	'View sync log' => 'Synchronisations-Protokoll anzeigen',
	'You must make one or more destination settings.' => 'Bitte geben Sie mindestens ein Ziel an.',
	'htaccess' => 'htaccess',
	q{Queued items for destination '[_1]' has been removed} => q{},
	q{Sync status information for destination '[_1]' has been removed} => q{},

## addons/Sync.pack/tmpl/mail_contents_sync.tmpl
	'Executer' => 'Ausführender',
	'Site' => '',

## default_templates/archive_index.mtml
	'Banner Footer' => 'Banner-Fuß',
	'Banner Header' => 'Banner-Kopf',
	'HTML Head' => 'HTML-Kopf',

## default_templates/comment_throttle.mtml
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Die IP-Adresse eines Besuchers Ihres Weblogs [_1] wurde automatisch gesperrt, da er versucht hat, mehr Kommentare als in [_2] Sekunden zulässig zu veröffentlichen.',
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Soll diese Adresse nicht gesperrt und dem Benutzer ermöglicht werden, wieder von dieser Adresse aus kommentieren zu können, entfernen Sie sie unter Blog-Konfiguration - IP-Sperren aus der Sperrliste.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Dadurch wird verhindert, daß Ihr Blog mit automatisch erzeugten Kommentaren überschwemmt wird. Die gesperrte Adresse lautet',

## default_templates/commenter_confirm.mtml
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Bitte bestätigen Sie Ihr Benutzerkonto und Ihre E-Mail-Adresse. Das ist nur ein Mal erforderlich. Anschließend können Sie direkt auf [_1] Kommentare schreiben.',
	'Thank you for registering an account to comment on [_1].' => 'Danke, daß Sie sich zum Kommentieren bei [_1] registriert haben.',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'Um Ihr Benutzerkonto zu bestätigen, klicken Sie auf folgende Adresse oder kopieren Sie sie in die Adresszeile Ihres Browsers:',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Sollten Sie sich nicht registriert haben oder Sie sich doch nicht auf [_1] kommentieren möchten, brauchen Sie nichts weiter zu tun.},

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Ein neuer Benutzer hat sich erfolgreich auf '[_1]' registriert. Hier die Angaben dieses Benutzers.},

## default_templates/entry.mtml
	'Trackbacks' => 'TrackBacks',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'IP-Adresse: [_1]',
	'Recovery: [_1]' => 'Entsperren: [_1]',
	'This email is to notify you that an IP address has been locked out.' => 'Eine IP-Adresse wurde automatisch gesperrt.',

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => 'Benutzername: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Um das Konto wieder freizuschalten, klicken Sie auf folgenden Link.',
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Ein Movable Type-Benutzerkonto wurde automatisch gesperrt.',

## default_templates/new-comment.mtml
	'Approve comment:' => 'Kommentar freischalten:',
	'Commenter IP address: [_1]' => 'IP-Adresse des Kommentarautors:',
	'Commenter URL: [_1]' => 'Web-Adresse (URL) des Kommentarautors:',
	'Commenter email address: [_1]' => 'E-Mail-Adresse des Kommentarautors: [_1]',
	'Commenter name: [_1]' => 'Name des Kommentarautors: [_1]',
	'Edit comment:' => 'Kommentar bearbeiten:',
	'Report the comment as spam:' => 'Kommentar als Spam melden:',
	'View comment:' => 'Kommentar ansehen:',
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Zu Eintrag #[_2] ([_3]) ist ein neuer Kommentar auf Ihrer Website '[_1]' erschienen.},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Zu Seite #[_2] ([_3]) ist ein neuer Kommentar auf Ihrer Website '[_1]' erschienen.},
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Zu Eintrag #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschalteter Kommentar eingegangen. Schalten Sie ihn frei, um ihn auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Zu Seite #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschalteter Kommentar eingegangen. Schalten Sie ihn frei, um ihn auf Ihrer Website erscheinen zu lassen.},

## default_templates/new-ping.mtml
	'Approve TrackBack' => 'TrackBack annehmen',
	'Blog' => 'Blog',
	'Edit TrackBack' => 'TrackBack bearbeiten',
	'Excerpt' => 'Auszug',
	'IP address' => 'IP-Adresse',
	'Report TrackBack as spam' => 'TrackBack als Spam melden',
	'View TrackBack' => 'TrackBack ansehen',
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Zu Kategorie #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website'[_1]' erschienen.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Zu Eintrag #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website '[_1]' erschienen.},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Zu Seite #[_2] ([_3]) ist ein neues TrackBack auf Ihrer Website '[_1]' erschienen.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Kategorie #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Eintrag #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Zu Seite #[_2] ([_3]) Ihrer Website '[_1]' ist ein noch nicht freigeschaltetes TrackBack eingegangen. Schalten Sie es frei, um es auf Ihrer Website erscheinen zu lassen.},

## default_templates/notify-entry.mtml
	'Message from Sender:' => 'Nachricht des Absenders:',
	'View page:' => 'Seite ansehen:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Sie erhalten diese E-Mail, da Sie entweder Nachrichten über Aktualisierungen von [_1] bestellt haben oder da der Autor dachte, daß dieser Eintrag für Sie von Interesse sein könnte. Wenn Sie solche Mitteilungen nicht länger erhalten wollen, wenden Sie sich bitte an ',
	'[_1] Title: [_2]' => 'Titel: [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Ein neuer [_3] namens &#8222;[_1]&#8220; wurde auf [_2] veröffentlicht.},

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="Vollständiger Kommentar zu [_4]">weiterlesen</a>',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Um das Passwort Ihres Movable-Type-Benutzerkontos zu ändern, klicken Sie bitte auf folgenden Link.',
	'If you did not request this change, you can safely ignore this email.' => 'Wenn Sie Ihr Passwort nicht ändern möchten, können Sie diese E-Mail bedenkenlos ignorieren.',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Zweispaltig - Seitenleiste',
	'3-column layout - Primary Sidebar' => 'Dreispaltig- Primäre Seitenleiste',
	'3-column layout - Secondary Sidebar' => 'Dreispaltig - Sekundäre Seitenleiste',

## lib/MT.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Ein zur Authentifizierung von Kommentarautoren per Google ID erforderliches Perl-Moduul fehlt: [_1].',
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
	'Bad CGIPath config' => 'CGIPath-Einstellung fehlerhaft',
	'Bad LocalLib config ([_1]): [_2]' => 'Fehlerhafte LocalLib-Einstellungen ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Fehlerhafte ObjectDriver-Einstellungen',
	'Error while creating email: [_1]' => 'Fehler beim Anlegen einer E-Mail: [_1]',
	'Fourth argument to add_callback must be a CODE reference.' => 'Das vierte Argument von add_callback muss eine CODE-Referenz sein.',
	'Google' => 'Google',
	'Got an error: [_1]' => 'Es ist ein Fehler aufgetreten: [_1]',
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
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Das zur OpenID-Authentifizierung erforderliche Perl-Modul Digest::SHA1 fehlt.',
	'Two plugins are in conflict' => 'Konflikt zwischen zwei Plugins',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => 'Plugin ohne Namen',
	'Version [_1]' => 'Version [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'WordPress.com',
	'Yahoo! JAPAN' => 'Yahoo! Japan',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1] abgebrochen mit [_2]',
	'http://www.movabletype.com/' => 'http://www.movabletype.com/',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'livedoor' => 'livedoor',
	q{Loading of blog '[_1]' failed: [_2]} => q{Blog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},
	q{Loading template '[_1]' failed.} => q{Die Vorlage &#8222;[_1]&#8220; konnte nicht geladen werden.},

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App.pm
	'A user with the same name already exists.' => 'Ein Benutzer mit diesem Namen existiert bereits.',
	'An error occurred while trying to process signup: [_1]' => 'Bei der Bearbeitung Ihrer Anmeldung ist ein Fehler aufgetreten: [_1]',
	'Cannot load blog (ID:[_1])' => 'Kann Blog (ID:[_1]) nicht laden',
	'Email Address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fehler beim Laden von Blog #[_1] zur Bereitstellung an Benutzer. Bitte überprüfen Sie Ihre NewUserTemplateBlogId-Einstellung.',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Fehler beim Laden der Website #[_1] zur Bereitstellung an Benutzer. Bitte überprüfen Sie Ihre NewUserDefaultWebsiteId-Einstellugen.',
	'Error sending mail: [_1]' => 'Fehler beim Versenden von Mail: [_1]',
	'Failed to open pid file [_1]: [_2]' => 'Konnte PID-Datei [_1] nicht öffnen: [_2]',
	'Failed to send reboot signal: [_1]' => 'Konnte Reboot-Signal nicht senden: [_1]',
	'First Weblog' => 'Erstes Weblog',
	'Internal Error: Login user is not initialized.' => 'Interner Fehler: Login-Benutzer nicht initialisiert.',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Es tut uns leid, aber Sie keine Berechtigung, auf Blogs oder Websites dieser Installation zuzugreifen. Sollte hier ein Irrtum vorliegen, wenden Sie sich bitte an Ihren Movable Type-Systemadministrator.',
	'Password should be longer than [_1] characters' => 'Passwörter müssen mindestens [_1] Zeichen lang sein',
	'Password should contain symbols such as #!$%' => 'Passwörter müssen mindestens ein Sonderzeichen wie #!$% enthalten',
	'Password should include letters and numbers' => 'Passwörter müssen sowohl Buchstaben als auch Ziffern enthalten',
	'Password should include lowercase and uppercase letters' => 'Passwörter müssen sowohl Groß- als auch Kleinbuchstaben enthalten',
	'Password should not include your Username' => 'Ihr Benutzername darf nicht Teil Ihres Passworts sein',
	'Problem with this request: corrupt character data for character set [_1]' => 'Es ist ein Fehler aufgetreten: ungültige Zeichen für Zeichensatz [_1]',
	'Removed [_1].' => '[_1] entfernt.',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Sie sind nicht berechtigt, auf Blogs oder Websites dieser Movable-Type-Installation zuzugreifen. Sollte es sich dabei um einen Fehler handeln, wenden Sie sich bitte an Ihren Administrator.',
	'Text entered was wrong.  Try again.' => 'Der eingegebene Text ist nicht richtig. Bitte versuchen Sie es erneut.',
	'The file you uploaded is too large.' => 'Die hochgeladene Datei ist zu groß.',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Dieses Benutzerkonto wurde gelöscht. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Unknown action [_1]' => 'Unbekannte Aktion [_1]',
	'Unknown error' => '', # Translate - New
	'User requires display name.' => 'Anzeigename erforderlich.',
	'User requires password.' => 'Passwort erforderlich.',
	'User requires username.' => 'Benutzername erforderlich.',
	'Warnings and Log Messages' => 'Warnungen und Logmeldungen',
	'You did not have permission for this action.' => 'Zu dieser Aktion sind Sie nicht berechtigt.',
	q{Blog '[_1]' (ID: [_2]) for user '[_3]' (ID: [_4]) has been created.} => q{Blog '[_1]' (ID: [_2]) für Benutzer &#8222;[_3]&#8220; (ID: [_4]) erfolgreich angelegt.},
	q{Error assigning blog administration rights to user '[_1]' (ID: [_2]) for blog '[_3]' (ID: [_4]). No suitable blog administrator role was found.} => q{Fehler bei Zuweisung von Administratorensrechten für Blog &#8222;[_3]&#8220; (ID: [_4])) an Benutzer &#8222;[_1]&#8220; (ID: [_2]). Keine passende Administratorenrolle gefunden.},
	q{Error provisioning blog for new user '[_1]' (ID: [_2]).} => q{Fehler bei Bereitstellung des Blogs für neuen Benutzer &#8222;[_1]&#8220; (ID: [_2]).},
	q{Error provisioning blog for new user '[_1]' using template blog #[_2].} => q{Fehler bei Bereitstellung des Blogs für neuen Benutzer &#8222;[_1]&#8220; mit Vorlage Blog #[_2].},
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{Die in IISFastCGIMonitoringFilePath angegebene Monitoring-Datei konnte nicht geöffnet werden:},
	q{Invalid login attempt from user '[_1]'} => q{Ungültiger Anmeldeversuch von Benutzer &#8222;[_1]&#8220;},
	q{New Comment Added to '[_1]'} => q{Neuer Kommentar zu &#8222;[_1]&#8220; eingegangen},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) erfolgreich angemeldet},
	q{User '[_1]' (ID:[_2]) logged out} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) abgemeldet},

## lib/MT/App/ActivityFeeds.pm
	'All Activity' => 'Alle Aktivitäten',
	'All Comments' => 'Alle Kommentare',
	'All Entries' => 'Alle Einträge',
	'All Pages' => 'Alle Seiten',
	'All TrackBacks' => 'Alle TrackBacks',
	'An error occurred while generating the activity feed: [_1].' => 'Bei Erzeugung des Aktivitäts-Feeds ist ein Fehler aufgetreten: [_1].',
	'Error loading [_1]: [_2]' => 'Fehler beim Laden von [_1]: [_2]',
	'Movable Type Debug Activity' => 'Movable Type Debug-Aktivität',
	'Movable Type System Activity' => 'Movable Type System-Aktivität',
	'No permissions.' => 'Keine Berechtigung.',
	'[_1] Activity' => '[_1] Aktivitäten',
	'[_1] Comments' => '[_1] Kommentare',
	'[_1] Entries' => '[_1] Einträge',
	'[_1] Pages' => '[_1] Seiten',
	'[_1] TrackBacks' => '[_1] TrackBacks',

## lib/MT/App/CMS.pm
	'Activity Log' => 'Aktivitäten',
	'Add Contact' => 'Kontakt hinzufügen',
	'Add IP Address' => 'IP-Adresse hinzufüge',
	'Add Tags...' => 'Tags hinzufügen...',
	'Add a user to this [_1]' => 'Benutzer zur [_1] hinzufügen',
	'Address Book' => 'Adressbuch',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Auf Ihrem System ist keine Bildquelle vorhanden oder aber fehlerhaft konfiguiert. Eine Bildquelle ist zur korrekten Funktion der Benutzerbild-Funktionen erforderlich. Installieren Sie Graphics::Magick, Image::Magick, NetPBM oder Imager und konfiguieren Sie die ImageDriver-Direktive entsprechend.',
	'Are you sure you want to remove all comments reported as spam?' => 'Wirklich alle als Spam markierte Kommentare löschen?',
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Wirklich alle als Spam markierten TrackBacks löschen?',
	'Are you sure you want to reset the activity log?' => 'Aktivitätsprotokoll wirklich zurücksetzen?',
	'Asset' => 'Asset',
	'Assets' => 'Assets',
	'Backup' => 'Sichern',
	'Ban Commenter(s)' => 'Kommentarautor(en) sperren',
	'Batch Edit Entries' => 'Mehrere Einträge bearbeiten',
	'Batch Edit Pages' => 'Mehrere Seiten bearbeiten',
	'Blog Stats' => 'Blog-Statistik',
	'Can verify SSL certificate, but verification is disabled.' => 'SSL-Zertifikate können bestätigt werden, die Funktion ist aber deaktiviert.',
	'Cannot verify SSL certificate.' => 'SSL-Zertifikat kann nicht überprüft werden.',
	'Clear Activity Log' => 'Aktivitätsprotokoll zurücksetzen',
	'Clone Blog' => 'Blog klonen',
	'Clone Template(s)' => 'Vorlage(n) klonen',
	'Commenters' => 'Kommentarautoren',
	'Compose' => 'Schreiben',
	'Create Role' => 'Rolle anlegen',
	'Delete all Spam comments' => 'Alle Spam-Kommentare löschen',
	'Delete all Spam trackbacks' => 'Alle Spam-TrackBacks löschen',
	'Design' => 'Gestalten',
	'Download Address Book (CSV)' => 'Adressbuch herunterladen (CSV)',
	'Download Log (CSV)' => 'Protokoll herunterladen (CSV)',
	'Edit Template' => 'Vorlage bearbeiten',
	'Entries' => 'Einträge',
	'Error during publishing: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Export Entries' => 'Einträge exportieren',
	'Export Theme' => 'Thema exportieren',
	'Feedback' => 'Feedback',
	'Folders' => 'Ordner',
	'General' => 'Allgemein',
	'Grant Permission' => 'Berechtigungen zuweisen',
	'IP Banning' => 'IP-Sperren',
	'ImageDriver is not configured.' => 'ImageDriver ist nicht konfiguriert.',
	'Import Entries' => 'Einträge importieren',
	'Listing Filters' => 'Listenfilter',
	'Mark as Spam' => 'Als Spam markieren',
	'Movable Type News' => 'Movable Type Aktuell',
	'Move blog(s) ' => 'Blog(s) verschieben',
	'No such blog [_1]' => 'Kein Weblog [_1]',
	'None' => 'Kein(e)',
	'Notification Dashboard' => 'Notification Dashboard',
	'Permissions' => 'Berechtigungen',
	'Personal Stats' => 'Persönliche Statistik',
	'Please contact your Movable Type system administrator.' => 'Bitte wenden Sie sich an Ihren Movable Type-Administrator.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Bitte installieren Sie das Modul Mozilla::CA. Um diese Meldung zu unterdrücken, ergänzen Sie mt-config.cgi um die Zeile "SSLVerifyNone 1". Das wird allerdings nicht empfohlen.',
	'Plugins' => 'Plugins',
	'Profile' => 'Profil',
	'Publish Template(s)' => 'Vorlage(n) veröffentlichen',
	'Publish' => 'Veröffentlichen',
	'Recover Password(s)' => 'Passwort anfordern',
	'Refresh Template(s)' => 'Vorlage(n) zurücksetzen',
	'Refresh Templates' => 'Vorlagen zurücksetzen',
	'Registration' => 'Registrierung',
	'Remove Spam status' => 'Kein Spam',
	'Remove Tags...' => 'Tags entfernen...',
	'Restore' => 'Wiederherstellen',
	'Revoke Permission' => 'Berechtigung entziehen',
	'Roles' => 'Rollen',
	'Search &amp; Replace' => 'Suchen &amp; Ersetzen',
	'Settings' => 'Einstellungen',
	'Site Stats' => 'Site-Statistik',
	'System Information' => 'Systeminformation',
	'Tags to add to selected assets' => 'Gewählte Assets mit diesen Tags versehen',
	'Tags to add to selected entries' => 'Gewählte Einträge mit diesen Tags versehen',
	'Tags to add to selected pages' => 'Gewählte Seiten mit diesen Tags versehen',
	'Tags to remove from selected assets' => 'Diese Tags von gewählten Assets entfernen',
	'Tags to remove from selected entries' => 'Diese Tags von gewählten Einträgen entfernen',
	'Tags to remove from selected pages' => 'Diese Tags von gewählten Seiten entfernen',
	'Templates' => 'Vorlagen',
	'The support directory is not writable.' => 'Das Support-Verzeichnis ist nicht beschreibbar.',
	'Themes' => 'Themen',
	'Tools' => 'Tools',
	'Trust Commenter(s)' => 'Kommentarautor(en) vertrauen',
	'Unban Commenter(s)' => 'Kommentator(en) nicht mehr sperren',
	'Unknown object type [_1]' => 'Unbekannter Objekttyp [_1]',
	'Unlock' => 'Entsperren',
	'Unpublish Comment(s)' => 'Kommentar(e) nicht mehr veröffentlichen',
	'Unpublish Entries' => 'Einträge nicht mehr veröffentlichen',
	'Unpublish Pages' => 'Seiten nicht mehr veröffentlichen',
	'Unpublish TrackBack(s)' => 'TrackBack(s) nicht mehr veröffentlichen',
	'Untrust Commenter(s)' => 'Kommentarautor(en) nicht mehr vertrauen',
	'Use Publishing Profile' => 'Veröffentlichungsprofil verwenden',
	'Web Services' => 'Webdienste',
	'Website' => 'Website',
	'Websites and Blogs' => 'Websites und Blogs',
	'Websites' => 'Websites',
	'Widgets' => 'Widgets',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Sie sollten die Zeile "SSLVerifyNone 1" aus mt-config.cgi entfernen.',
	'_WARNING_DELETE_USER' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen?',
	'_WARNING_DELETE_USER_EUM' => 'Die Löschung eines Benutzerkontos kann nicht rückgängig gemacht werden und führt zu verwaisten Einträgen. Um nicht mehr benötigte Benutzerkonten zu entfernen oder um Benutzern den Zugriff auf das System zu entziehen, wird daher empfohlen, die jeweiligen Benutzerkonten nicht zu löschen, sondern zu deaktivieren. Möchten Sie die gewählten Benutzerkonten dennoch löschen? Benutzer können ihre Konten selbst wiederherstellen, solange sie noch in externen Verzeichnissen aufgeführt sind.',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Sie sind dabei, E-Mails zu verschicken, mit denen die gewählten Benutzer ihre Passwörter zurücksetzen können. Fortfahren?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Hiermit werden die Vorlagen der gewählten Blogs auf die Standardvorlagen zurückgesetzt. Möchten Sie die Vorlagen der gewählten Blogs wirklich zurücksetzen?',
	'entry' => 'Eintrag',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type kann auf den Ordner &#8222;support&#8220; nicht schreibend zugreifen. Legen Sie unter [_1] ein solches Verzeichnis an und stellen Sie sicher, daß der Webserver über Schreibrechte für diesen Ordner verfügt.},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw. Bitte bestätigen Sie Ihre <a href="[_1]>Einstellungen</a>.},

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Nicht alle Websites gelöscht. Bitte löschen Sie zuerst die zu den jeweiligen Websites gehörende Blogs.',

## lib/MT/App/Comments.pm
	'All required fields must be populated.' => 'Alle erforderlichen Felder müssen ausgefüllt sein.',
	'Cannot load template' => 'Kann Vorlage nicht laden',
	'Comment on "[_1]" by [_2].' => 'Kommentar zu "[_1]" von [_2].',
	'Comment save failed with [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Comment text is required.' => 'Bitte geben Sie einen Kommentartext ein.',
	'Commenter profile could not be updated: [_1]' => 'Das Profil des Kommentarautoren konnte nicht aktualisiert werden: [_1]',
	'Commenter profile has successfully been updated.' => 'Das Profil des Kommentarautoren wurde erfolgreich aktualisiert.',
	'Comments are not allowed on this entry.' => 'Zu diesem Eintrag können keine Kommentare abgegeben werden.',
	'IP Banned Due to Excessive Comments' => 'IP-Adresse wegen exzessiver Kommentarabgabe gesperrt',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] gesperrt, da mehr als 8 Kommentare in [_2] Sekunden abgegeben wurden.',
	'Invalid entry ID provided' => 'Ungültige Eintrags-ID angegeben',
	'Name and E-mail address are required.' => 'Name und E-Mail-Adresse sind erforderlich',
	'No entry was specified; perhaps there is a template problem?' => 'Es wurde kein Eintrag angegeben. Vielleicht gibt es ein Problem mit der Vorlage?',
	'No entry_id' => 'Keine entry_id',
	'No id' => 'Keine ID',
	'No such comment' => 'Kein entsprechender Kommentar',
	'Publishing failed: [_1]' => 'Veröffentlichung fehlgeschlagen: [_1]',
	'Registered User' => 'Registrierter Benutzer',
	'Registration is required.' => 'Registrierung erforderlich',
	'Somehow, the entry you tried to comment on does not exist' => 'Der Eintrag, den Sie kommentieren möchten, existiert nicht.',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Sie haben sich erfolgreich authentifiziert, dürfen sich aber nicht anmelden. Bitte wenden Sie sich an Ihren Movable-Type-Administrator.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Vielen Dank für Ihre Bestätigung. Sie können sich jetzt anmelden und kommentieren.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Weiterleitung auf eine externe Website. Wenn Sie dieser Site vertrauen, klicken Sie bitte auf diesen Link: [_1]',
	'Your confirmation has expired. Please register again.' => 'Ihre Bestätigung ist nicht mehr gültig. Bitte registrieren Sie sich erneut.',
	'_THROTTLED_COMMENT' => 'Sie haben zu viele Kommentare in schneller Folge abgegeben. Bitte versuchen Sie es in einigen Augenblicken erneut.',
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{Kommentarautor &#8222;[_1]&#8220; (ID:[_2]) erfolgreich registriert.},
	q{Invalid URL '[_1]'} => q{Ungültige Web-Adresse (URL) &#8222;[_1]&#8220;},
	q{Invalid email address '[_1]'} => q{Ungültige E-Mail-Adresse '[_1]'},
	q{No such entry '[_1]'.} => q{Kein Eintrag &#8222;[_1]&#8220;.},

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
	'Template must be an entry_listing for non-Index archive types' => 'Verwenden Sie für Nicht-Index-Archivseiten eine entry_listing-Vorlage.',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'Die Suche dauert zu lange. Bitte vereinfachen Sie Ihre Suchanfrage und versuchen Sie es erneut.',
	'Unsupported type: [_1]' => 'Nicht unterstützter Typ: [_1]',
	'You must pass a valid archive_type with the template_id' => 'Bitte übergeben Sie mit der template_id eine gültige archive_type-Angabe',
	'template_id cannot refer to a global template' => 'template_id kann sich nicht auf eine globale Vorlage beziehen.',
	q{No alternate template is specified for template '[_1]'} => q{Keine Alternative zu Vorlage &#8222;[_1]&#8220; angegeben.},
	q{Opening local file '[_1]' failed: [_2]} => q{Konnte lokale Datei &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Search: query for '[_1]'} => q{Suche: Suche nach &#8222;[_1]&#8220;},

## lib/MT/App/Search/Legacy.pm
	'A search is in progress. Please wait until it is completed and try again.' => 'Es läuft bereits eine Suche. Bitte versuchen Sie es danach erneut.',
	'File not found: [_1]' => 'Datei nicht gefunden: [_1]',
	'Publishing results failed: [_1]' => 'Ausgabe der Suchergebnisse fehlgeschlagen: [_1]',
	'Search failed. Invalid pattern given: [_1]' => 'Suche fehlgeschlagen - ungültiges Suchmuster angegeben: [_1]',
	'Search failed: [_1]' => 'Suche fehlgeschlagen: [_1]',
	'Search: new comment search' => 'Suche: Neue Kommentare',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch verwendet MT::App::Search.',

## lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'Dieser TrackBack-Eintrag ist deaktiviert.',
	'This TrackBack item is protected by a passphrase.' => 'Dieser TrackBack-Eintrag ist passwortgeschützt.',
	'TrackBack ID (tb_id) is required.' => 'TrackBack_ID (tb_id) erforderlich.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack zu "[_1]" von "[_2]".',
	'Trackback pings must use HTTP POST' => 'Trackbacks müssen HTTP-POST verwenden',
	'You are not allowed to send TrackBack pings.' => 'Sie haben keine Berechtigung, TrackBack-Pings zu senden.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Sie versenden TrackBacks-Pings zu schnell hintereinander. Bitte versuchen Sie es später erneut.',
	'You must define a Ping template in order to display pings.' => 'Sie müssen eine Ping-Vorlage definieren, um Pings anzeigen zu können.',
	'You need to provide a Source URL (url).' => 'Bitte geben Sie eine Quell-URL (url) an.',
	q{Cannot create RSS feed '[_1]': } => q{RSS-Feed &#8222;[_1]&#8220; kann nicht angelegt werden: },
	q{Invalid TrackBack ID '[_1]'} => q{Ungültige TrackBack-ID &#8222;[_1]&#8220;},
	q{Invalid entry ID '[_1]'} => q{Ungültige Eintrags-ID '[_1]'},
	q{New TrackBack ping to '[_1]'} => q{Neuer TrackBack-Ping an &#8222;[_1]&#8220;},
	q{New TrackBack ping to category '[_1]'} => q{Neuer TrackBack-Ping an Kategorie &#8222;[_1]&#8220;},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{TrackBack für Kategorie &#8222;[_1]&#8220; (ID:[_2])},

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'Die beiden Passwörter müssen übereinstimmen.',
	'Could not authenticate using the credentials provided: [_1].' => 'Authentifizierung mit den angegeben Daten fehlgeschlagen: [_1]',
	'Invalid session.' => 'Ungültige Session',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type erfolgreich auf Version [_1] aktualisiert.',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Keine Berechtigung. Bitte wenden Sie sich zur Aktualisierung dieser Movable-Type-Installation an Ihren Administrator.',
	'You must supply a password.' => 'Bitte geben Sie ein Passwort an.',
	q{The 'Website Root' provided below is not allowed} => q{Das angegebene Wurzelverzeichnis der Website ist ungültig bzw. nicht zulässig.},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{Der Server kann das angegebene Wurzelverzeichnis der Website nicht beschreiben. Bitte ändern Sie die entsprechenden Zugriffs- und/oder Besitzer-Rechte und klicken Sie dann erneut auf 'Installation abschließen'.},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Die Datenbankverbindung konnte nicht aufgebaut werden. Bitte überprüfen Sie die Einstellungen und versuchen Sie es erneut.',
	'CGI is required for all Movable Type application functionality.' => 'CGI ist für sämtliche Movable Type-Funktionen erforderlich.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.' => 'Cache::File ist zur Authentifizierung von Kommentarautoren per OpenID an Yahoo! Japan erforderlich.',
	'DBI is required to work with most supported databases.' => 'DBI ist für die meisten Datenbank-Typen erforderlich.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA ist für den verbesserten Schutz der verwendeten Passwörter erforderlich.',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec ist auf allen unterstützten Betriebssystem ',
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
	'This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.' => 'Dieses Modul ist zur Registrierung von Kommentarautoren und zum Versenden von Mails über SMTP-Server erforderlich.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Dieses Modul ist zur Kodierung von Sonderzeichen erforderlich. Die Kodierung von Sonderzeichen kann über den Schalter NoHTMLEntities in mt-config.cgi abgeschaltet werden.',
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
	'This module is required in order to use memcached as caching mechanism used by Movable Type.' => 'Dieses Modul ist zur Nutzung von memcached als Cache-System erforderlich.',
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

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'Täglich',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/tt/index.html',

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

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'Monatlich',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Seite',
	'folder-path/page-basename.html' => 'pfad-angabe/seiten-name.html',
	'folder-path/page-basename/index.html' => 'pfad-angabe/seiten-name/index.html',
	'folder_path/page_basename.html' => 'pfad_angabe/seiten_name.html',
	'folder_path/page_basename/index.html' => 'pfad_angabe/seiten_name/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'Wöchentlich',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/tag-woche/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'Jährlich',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'Assets dieser Website',
	'Assets with Extant File' => 'Assets mit vorhandener Datei',
	'Assets with Missing File' => 'Assets mit fehlender Datei',
	'Author Status' => 'Status des Autors',
	'Could not create asset cache path: [_1]' => 'Konnte Asset-Cache-Pfad nicht anlegen: [_1]',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Konnte Asset-Datei [_1] nicht aus Dateisystem löschen: [_2]',
	'Deleted' => 'Gelöscht',
	'Except Userpic' => 'Benutzerbild ausnehmen',
	'File Extension' => 'Dateierweiterung',
	'File' => 'Datei',
	'Filename' => 'Dateiname',
	'Image' => 'Bild',
	'Label' => 'Bezeichnung',
	'Location' => 'Ort',
	'Missing File' => 'Datei fehlt',
	'Pixel height' => 'Höhe in Pixeln',
	'Pixel width' => 'Breite in Pixeln',
	'Video' => 'Video',
	'extant' => 'vorhanden',
	'missing' => 'fehlt',

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
	'Permission denied setting image defaults for blog #[_1]' => 'Fehlende B: Bild-Voreinstellungen für Weblog #[_1] nicht geändert',
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
	'Associations' => 'Verknüpfungen',
	'Permissions with role: [_1]' => 'Berechtigungen der Rolle [_1]',
	'Role Detail' => 'Rolle-Details',
	'Role Name' => 'Rollenname',
	'Role' => 'Rolle',
	'User Name' => 'Benutzername',
	'User is [_1]' => 'Benutzer ist [_1]',
	'__WEBSITE_BLOG_NAME' => 'Name der Website/des Blogs',
	'association' => 'Verknüpfungen',
	'associations' => 'Verknüpfungen',

## lib/MT/AtomServer.pm
	'Invalid image file format.' => 'Ungültiges Bildformat.',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Zur Bestimmung der Höhe und Breite hochgeladener Bilder ist das Perl-Modul Image::Size erforderlich.',
	'PreSave failed [_1]' => 'PreSave fehlgeschlagen [_1]',
	'Removing stats cache failed.' => 'Löschen des Statistik-Caches fehlgeschlagen.',
	'[_1]: Entries' => '[_1]: Einträge',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{Entry &#8222;[_1]&#8220; ([lc,_5] #[_2]) von &#8222;[_3]&#8220; (#[_4]) über Atom-API gelöscht.},
	q{Invalid blog ID '[_1]'} => q{Ungültige Blog-ID &#8222;[_1]&#8220;},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) hinzugefügt.},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{[_4] (#[_3]) von Benutzer &#8222;[_1]&#8220; (Benutzer-Nr. [_2]) bearbeitet.},

## lib/MT/Auth.pm
	'Bad AuthenticationModule config' => 'Fehlerhafte AuthenticationModule-Konfiguration',
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{Fehlerhafte AuthenticationModule-Konfiguration &#8222;[_1]&#8220;: [_2]},

## lib/MT/Auth/MT.pm
	'Missing required module' => 'Ein erforderliches Modul fehlt',

## lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Konnte Net::OpenID::Consumer nicht laden.',
	'Could not save the session' => 'Konnte Session nicht speichern.',
	'Could not verify the OpenID provided: [_1]' => 'Die angegebene OpenID konnte nicht bestätigt werden: [_1]',
	'The address entered does not appear to be an OpenID endpoint.' => 'Die angebene Adresse ist kein OpenID-Endpunkt.',
	'The text entered does not appear to be a valid web address.' => 'Der eingegebene Text ist keine gültige Web-Adresse.',
	'Unable to connect to [_1]: [_2]' => 'Konnte keine Verbindung zu [_1] aufbauen: [_2]',

## lib/MT/Auth/TypeKey.pm
	'Could not get public key from the URL provided.' => 'Konnte keinen öffentlichen Schlüssel von der angegebenen Adresse beziehen.',
	'INVALID' => 'UNGÜLTIG',
	'No public key could be found to validate registration.' => 'Kein Public Key zur Validierung gefunden.',
	'Sign in requires a secure signature.' => 'Die Anmeldung erfordert eine sichere Signatur.',
	'The sign-in validation failed.' => 'Bei der Bestätigung der Anmeldung ist ein Fehler aufgetreten.',
	'This weblog requires commenters to pass an email address. If you would like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Auf diesem Weblog müssen Kommentarautoren ihre E-Mail-Adresse angeben. Um das zu tun, melden Sie sich erneut an und erlauben Sie Ihrem Authentifizierungs-Dienst, Ihre E-Mail-Adresse zu übermitteln.',
	'TypePad signature verification returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypePad-Signaturbestätigung ergab nach [_2] Sekunden [_1], [_3] mit [_4] geprüft.',
	'VALID' => 'GÜLTIG',
	q{The TypePad signature is out of date ([_1] seconds old). Ensure that your server's clock is correct.} => q{Die TypePad-Signatur ist veraltet ([_1] Sekunden alt). Ist die Uhr Ihres Servers richtig gestellt?},

## lib/MT/Author.pm
	'Banned' => 'Gesperrt',
	'Created by' => 'Angelegt von',
	'Disabled Commenters' => 'Deaktivierte Kommentar-Autoren',
	'Enabled Commenters' => 'Aktive Kommentar-Autoren',
	'Externally Authenticated Commenters' => 'Extern authentifizierte Kommentar-Autoren',
	'Locked Out' => 'Gesperrt',
	'Locked out Users' => 'Gesperrte Benutzerkonten',
	'Lockout' => 'Sperrung',
	'MT Native Users' => 'Native MT-Benutzer',
	'MT Users' => 'MT-Benutzer',
	'Not Locked Out' => 'Nicht gesperrt',
	'Pending Commenters' => 'Wartende Kommentar-Autoren',
	'Pending Users' => 'Wartende Benutzerkonten',
	'Privilege' => 'Privilegien',
	'The approval could not be committed: [_1]' => 'Bestätigung konnte nicht übernommen werden: [_1]',
	'__COMMENTER_APPROVED' => 'Bestätigt',
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## lib/MT/BackupRestore.pm
	'Cannot open [_1].' => 'Kann [_1] nicht öffnen.',
	'Copying [_1] to [_2]...' => 'Kopiere [_1] nach [_2]...',
	'Failed: ' => 'Fehler: ',
	'ID for the file was not set.' => 'ID für Datei nicht gesetzt.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-Datei [_1] ist keine gültige Movable Type Backup-Manifest-Datei.',
	'Manifest file: [_1]' => 'Manifest-Datei: [_1]',
	'No manifest file could be found in your import directory [_1].' => 'Keine Manifest-Datei im Importverzeichnis [_1] gefunden.',
	'Path was not found for the file, [_1].' => 'Verzeichnis für Datei nicht gefunden, [_1]',
	'Restoring asset associations ... ( [_1] )' => 'Stelle Asset-Zuweisungen wieder her... ( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'Stelle Asset-Zuweisungen in Eintrag wieder her... ( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'Stelle Asset-Zuweisungen in Seite wieder her ... ( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'Stelle Asset-URLs wieder her... ( [_1] )',
	'Restoring url of the assets in entry ( [_1] )...' => 'Stelle Asset-URLs in Eintrag wieder her... ( [_1] )',
	'Restoring url of the assets in page ( [_1] )...' => 'Stelle Asset-URLs in Seite wieder her ... ( [_1] )',
	'The file ([_1]) was not restored.' => 'Datei ([_1]) nicht wiederhergestellt.',
	'There were no [_1] records to be backed up.' => 'Keine [_1]-Einträge zu sichern.',
	'[_1] is not writable.' => 'Kein Schreibzugriff auf [_1]',
	'[_1] records backed up...' => '[_1] Einträge gesichert...',
	'failed' => 'Fehlgeschlagen',
	'ok' => 'OK',
	qq{\nCannot write file. Disk full.} => qq{Laufwerk voll. Datei kann nicht geschrieben werden.},
	q{Cannot open directory '[_1]': [_2]} => q{Kann Verzeichnis &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{Ändere Pfad für Datei &#8222;[_1]&#8220; (ID:[_2])....},
	q{Error making path '[_1]': [_2]} => q{Fehler beim Anlegen des Ordners &#8222;[_1]&#8220;: [_2]},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.' => 'Benutzerkonto mit gleichem Benutzeramen wie aktueller Nutzer in Backup gefunden ([_1]). Eintrag übersprungen.',
	'Invalid serializer version was specified.' => 'Ungültiger Serializer angegeben.',
	'Restoring [_1] records:' => 'Stelle [_1]-Einträge wieder her:',
	'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.' => 'Die hochgeladene Manifest-Datei wurde zwar mit Movable Type erstellt, bezieht sich aber auf eine andere Schema-Version ([_1]) als dieses System ([_2]). Sie sollten daher dieses Backup nicht in diese Movable Type-Installation einspielen.',
	'The uploaded file was not a valid Movable Type backup manifest file.' => 'Die hochgeladene Datei ist keine gültige Manifest-Datei eines Movable-Type-Backups.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] wird von Movable Type nicht wiederhergestellt.',
	'[_1] records restored.' => '[_1] Einträge wiederhergestellt.',
	'[_1] records restored...' => '[_1] Einträge wiederhergstellt...',
	q{A user with the same name '[_1]' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.} => q{Benutzerkonto mit gleichem Benutzernamen &#8222;[_1]&#8220; mit ID [_2] in Backup gefunden und mit Daten aus Backup ersetzt.},
	q{Tag '[_1]' exists in the system.} => q{Tag &#8222;[_1]&#8220; bereits im System vorhanden.},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{Die Rolle &#8222;[_1]&#8220; wurde in &#8222;[_2]&#8220; umbenannt, da bereits eine Rolle mit diesem Namen vorhanden ist.},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{Einstellungen auf Systemebene für Plugin &#8222;[_1]&#8220; bereits vorhanden; überspringe Eintrag.},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot restore requested file because a website was not found in either the existing Movable Type system or the backup data. A website must be created first.' => 'Diese Datei konnte nicht eingespielt werden, da weder diese Movable-Type-Installation noch die Backup-Daten eine Website beinhalten. Legen Sie daher zuerst eine Website an.',
	'Cannot restore requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Diese Datei konnte nicht eingespielt werden, da dazu das Digest::SHA-Perl-Modul erforderlich ist. Wenden Sie sich bitte an Ihren Movable-Type-Administrator.',

## lib/MT/BasicAuthor.pm
	'authors' => 'Autoren',

## lib/MT/Blog.pm
	'*Website/Blog deleted*' => 'Website/Blog gelöscht',
	'Clone of [_1]' => 'Klon von [_1]',
	'Cloned blog... new id is [_1].' => 'Blog geklont... Die neue ID lautet: [_1]',
	'Cloning TrackBack pings for blog...' => 'Klone TrackBack-Pings für Weblog...',
	'Cloning TrackBacks for blog...' => 'Klone TrackBacks für Weblog...',
	'Cloning associations for blog:' => 'Klone Verknüpfungen für Weblog:',
	'Cloning categories for blog...' => 'Klone Kategorien für Weblog...',
	'Cloning comments for blog...' => 'Klone Kommentare für Weblog...',
	'Cloning entries and pages for blog...' => 'Klone Einträge und Seiten für Weblog...',
	'Cloning entry placements for blog...' => 'Klone Eintragsplatzierung für Weblog...',
	'Cloning entry tags for blog...' => 'Klone Tags für Weblog...',
	'Cloning permissions for blog:' => 'Klone Berechtigungen für Webblog:',
	'Cloning template maps for blog...' => 'Klone Vorlagenzuweisungen für Weblog...',
	'Cloning templates for blog...' => 'Klone Vorlagen für Weblog...',
	'Failed to apply theme [_1]: [_2]' => 'Anwendung des Themas [_1] fehlgeschlagen: [_2]',
	'Failed to load theme [_1]: [_2]' => 'Laden des Themas [_1] fehlgeschlagen: [_2]',
	'First Blog' => 'Erstes Blog',
	'No default templates were found.' => 'Keine Standardvorlagen gefunden.',
	'Theme' => 'Thema',
	'__ASSET_COUNT' => 'Assets',
	'__PAGE_COUNT' => 'Seiten',

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
	'/' => '/',
	'<' => '<',
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
	'Transforming image failed: [_1]' => 'Umformung des Bildes fehlgeschlagen: [_1]',
	'Untitled' => 'Ohne Name',
	'Upload File' => 'Datei hochladen',
	'Uploaded file is not an image.' => 'Die hochgeladene Datei ist keine Bilddatei.',
	'basename of user' => 'Basisname des Benutzers',
	'none' => 'Kein(e)',
	'unassigned' => 'nicht vergeben',
	q{Could not create upload path '[_1]': [_2]} => q{Konnte Pfad &#8222;[_1]&#8220; nicht anlegen: [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{Temporäre Datei konnte nicht angelegt werden. Der angegebene Pfad muss vom Webserver beschrieben werden können. Bitte überprüfen Sie das Parameter TempDir in Ihrer Konfigurationsdatei. Derzeitiger Einstellung: [_1]},
	q{Error deleting '[_1]': [_2]} => q{Fehler beim Löschen von &#8222;[_1]&#8220;: [_2]},
	q{Error opening '[_1]': [_2]} => q{Fehler beim Öffnen von &#8222;[_1]&#8220;: [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Datei &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{File '[_1]' uploaded by '[_2]'} => q{Datei &#8222;[_1]&#8220; hochgeladen von &#8222;[_2]&#8220;},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{Eine Datei &#8222;[_1]&#8220; existiert bereits. (Installieren Sie das Perl-Modul File::Temp, um zuvor hochgeladene Dateien überschreiben zu können.},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{Eine Datei namens '[_1]' ist bereits vorhanden. Der Vorgang wurde abgebrochen.},
	q{File with name '[_1]' already exists.} => q{Eine Datei namens '[_1]' existiert bereits.},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{Eine Datei &#8222;[_1]&#8220; existiert bereits und der Webserver konnte keine temporäre Datei anlegen: [_2]},
	q{Invalid temp file name '[_1]'} => q{Ungültiger temporärer Dateiname &#8222;[_1]&#8220;},

## lib/MT/CMS/BanList.pm
	'The IP you entered is already banned for this blog.' => 'Diese IP-Adresse ist für dieses Weblog bereits gesperrt.',
	'You did not enter an IP address to ban.' => 'Keine IP-Adresse angegeben.',

## lib/MT/CMS/Blog.pm
	'Archive URL must be an absolute URL.' => 'Archiv-URLs müssen absolut sein.',
	'Blog Root' => 'Blog-Wurzelverzeichnis',
	'Cannot load template #[_1].' => 'Kann Vorlage #[_1] nicht laden.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Um Kommentare und TrackBacks zu klonen, müssen auch die Eintrage geklont werden.',
	'Entries must be cloned if comments are cloned' => 'Um Kommentare zu klonen, müssen auch die Einträge geklont werden.',
	'Entries must be cloned if trackbacks are cloned' => 'Um TrackBacks zu klonen, müssen auch die Einträge geklont werden.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache-Ordner schreiben. Bitte überprüfen Sie die Rechte für den Ordner <code>[_1]</code> in Ihrem Weblog-Verzeichnis.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fehler: Movable Type konnte kein Verzeichnis zur Zwischenspeicherung Ihrer dynamischen Vorlagen anlegen. Legen Sie daher manuell einen Ordner namens <code>[_1]</code> in Ihrem Weblog-Verzeichnis an.',
	'Finished!' => 'Fertig!',
	'General Settings' => 'Allgemeine Einstellungen',
	'Invalid blog' => 'Ungültiges Blog',
	'Invalid blog_id' => 'Ungültige blog_id',
	'New Blog' => 'Neues Blog',
	'No blog was selected to clone.' => 'Kein zu klonendes Blog ausgewählt.',
	'Please choose a preferred archive type.' => 'Bitte geben Sie eine bevorzugte Archiv-Art an.',
	'Plugin Settings' => 'Plugin-Einstellungen',
	'Publish Site' => 'Site veröffentlichen',
	'Saved [_1] Changes' => '[_1]-Änderungen gespeichert',
	'Saving blog failed: [_1]' => 'Das Weblog konnte nicht gespeichert werden: [_1]',
	'Select Blog' => 'Blog wählen',
	'Selected Blog' => 'Gewähltes Blog',
	'Site URL must be an absolute URL.' => 'Site-URL muß eine absolute URL sein.',
	'The number of revisions to store must be a positive integer.' => 'Die Anzahl der zu speichernden Revisionen muss positiv sein.',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Eine Angabe in der Movable Type-Konfigurationsdatei hat Vorrang vor diesen Einstellungen: [_1]. Entfernen Sie die Angabe aus der Konfigurationsdatei, um die entsprechenden Einstellungen hier vornehmen zu können.',
	'This action can only be run on a single blog at a time.' => 'Dieser Vorgang kann nur für jeweils ein Blog gleichzeitig ausgeführt werden.',
	'This action cannot clone website.' => 'Mit dieser Aktion können keine Websites geklont werden.',
	'Type a blog name to filter the choices below.' => 'Geben Sie einen Blognamen ein, um die Auswahl einzuschränken.',
	'Website Root' => 'Wurzelverzeichnis der Website',
	'You did not specify a blog name.' => 'Kein Blog-Name angegeben.',
	'You did not specify an Archive Root.' => 'Kein Archiv-Wurzelverzeichnis angebeben.',
	'[_1] changed from [_2] to [_3]' => '[_1] von [_2] in [_3] geändert',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{&#8222;[_1]&#8220; (ID: [_2]) wurde von &#8222;[_5]&#8220; (ID: [_6]) als &#8222;[_3]&#8220; (ID: [_4]) kopiert.},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Weblog &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{Cloning blog '[_1]'...} => q{Klone Blog &#8222;[_1]&#8220;...},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{Der Webserver hat keinen Schreibzugriff auf '[_1]'. Bitte vergeben Sie entsprechende Benutzerrechte und versuchen Sie es erneut.},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) angelegt von &#8222;[_4]&#8220;},
	q{[_1] '[_2]'} => q{[_1] &#8222;[_2]&#8220;},
	q{index template '[_1]'} => q{Indexvorlage &#8222;[_1]&#8220;},

## lib/MT/CMS/Category.pm
	'Add a [_1]' => '[_1] hinzufügen',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => '[_1] konnte nicht aktualisiert werden: [_2] wurde verändert, nachdem Sie diese Seite aufriefen. ',
	'No label' => 'Keine Bezeichnung',
	'The [_1] must be given a name!' => '[_1] muss einen Namen erhalten!',
	'The category name cannot be blank.' => 'Kategorienamen können nicht leer sein.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Konnte [_1] ([_2]) nicht aktualisieren: Objekt nicht gefunden.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Ihre Änderungen wurden übernommen ([_1] hinzugefügt, [_2] bearbeitet, [_3] gelöscht). <a href="#" onclick="[_4]" class="mt-rebuild">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) bearbeitet von &#8222;[_3]&#8220;},
	q{Category '[_1]' created by '[_2]'.} => q{Kategorie &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_2]&#8220;},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{Der Kategorie-Basisname &#8222;[_1]&#8220; steht im Konflikt mit dem Basisnamen einer anderen Kategorie: Unterkategorien dürfen nicht den gleichen Basisnamen wie ihre Hauptkategorie haben.},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen. Hauptkategorien und Unterkategorien gleichen Ursprungs müssen eindeutige Namen haben.},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Der Kategoriename &#8222;[_1]&#8220; steht im Konflikt mit einem anderen Kategorienamen: Unterkategorien dürfen nicht wie ihre Hauptkategorie heißen.},
	q{The name '[_1]' is too long!} => q{Der Name &#8222;[_1]&#8220; ist zu lang!},
	q{[_1] order has been edited by '[_2]'.} => q{Die [_1]-Reihenfolge wurde von &#8222;[_2]&#8220; geändert.},

## lib/MT/CMS/Comment.pm
	'(untitled)' => '(ohne Überschrift)',
	'Edit Comment' => 'Kommentar bearbeiten',
	'No such commenter [_1].' => 'Kein Kommentarautor [_1].',
	'Orphaned comment' => 'Verwaister Kommentar',
	'The entry corresponding to this comment is missing.' => 'Zugehöriger Eintrag fehlt.',
	'The parent comment id was not specified.' => 'ID des Eltern-Kommentars nicht angegeben.',
	'The parent comment was not found.' => 'Eltern-Kommentar nicht gefunden.',
	'You cannot create a comment for an unpublished entry.' => 'Nicht veröffentlichte Einträge können nicht kommentiert werden.',
	'You cannot reply to unapproved comment.' => 'Sie können nicht auf nicht freigeschaltete Kommentare antworten.',
	'You cannot reply to unpublished comment.' => 'Auf nicht veröffentlichte Kommentare kann nicht geantwortet werden.',
	'You do not have permission to approve this comment.' => 'Sie haben keine Benutzerrechte zur Freischaltung des Kommentars.',
	'You do not have permission to approve this trackback.' => 'Sie haben keine Benutzerrechte zur Freischaltung des TrackBacks.',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Kommentar (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht},
	q{User '[_1]' banned commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; gesperrt},
	q{User '[_1]' trusted commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen ausgesprochen},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat die Sperrung von Kommentarautor &#8222;[_2]&#8220; aufgehoben},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{Benutzer &#8222;[_1]&#8220; hat Kommentarautor &#8222;[_2]&#8220; das Vertrauen entzogen},

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
	'[_1] Feed' => '[_1]-Feed',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => '[_1] beschädigte Revisionen von [_2] (id: [_3]) wurden gelöscht.',
	q{'[_1]' edited the global template '[_2]'} => q{&#8222;[_1]&#8220; hat die globale Vorlage &#8222;[_2]&#8220; bearbeitet},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{&#8222;[_1]&#8220; hat die Vorlage &#8222;[_2]&#8220; des Blogs &#8222;[_3]&#8220; bearbeitet},

## lib/MT/CMS/Dashboard.pm
	'Error: This blog does not have a parent website.' => 'Fehler: Dieses Blog gehört zu keiner Website.',
	'Not configured' => 'Nicht konfiguriert',
	'Page Views' => 'Seitenaufrufe',

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(Benutzer gelöscht - ID:[_1])',
	'Entry Status' => 'Eintragsstatus',
	'Need a status to update entries' => 'Statusangabe erforderlich',
	'Need entries to update status' => 'Einträge erforderlich',
	'New Entry' => 'Neuer Eintrag',
	'New Page' => 'Neue Seite',
	'New [_1]' => 'Neuer [_1]',
	'No such [_1].' => 'Kein [_1].',
	'One of the entries ([_1]) did not exist' => 'Einer der Einträge ([_1]) existiert nicht.',
	'Publish error: [_1]' => 'Fehler bei der Veröffentlichung: [_1]',
	'Removing placement failed: [_1]' => 'Die Platzierung konnte nicht entfernt werden: [_1]',
	'Saving placement failed: [_1]' => 'Beim Speichern der Platzierung ist ein Fehler aufgetreten: [_1]',
	'This basename has already been used. You should use an unique basename.' => 'Basisname bereits verwendet. Bitte wählen Sie einen noch nicht verwendeten.',
	'Unable to create preview files in this location: [_1]' => 'Kann Vorschau-Dateien hier nicht erzeugen:',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Site Path und URL dieses Weblogs wurden noch nicht konfiguriert. Sie können keine Einträge veröffentlichen, solange das nicht geschehen ist.',
	'authored on' => 'geschrieben am',
	'modified on' => 'bearbeitet am',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">QuickPost für [_2]</a> - Ziehen Sie dieses Bookmarklet in die Lesezeichenleiste Ihres Browsers. Klicken Sie darauf, wenn Sie sich auf einer Website befinden, über die Sie bloggen möchten.},
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. Geben Sie den Zeitpunkt der Veröffentlichung in diesem Format an: JJJJ-MM-TT HH:MM:SS.},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{Datum &#8222;[_1]&#8220; ungültig. Das Datum der Veröffentlichung muss vor dem Zeitpunkt liegen, ab dem der Eintrag nicht mehr veröffentlicht werden soll (derzeit [_2]).},
	q{Invalid date '[_1]'; 'Published on' dates should be real dates.} => q{Datum &#8222;[_1]&#8220; ungültig. Geben Sie einen echten Zeitpunkt der Veröffentlichung an.},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss im Format JJJJ-MM-TT SS:MM:SS angegeben werden.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunk, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss in der Zukunft liegen.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, muss nach dem Zeitpunkt der Veröffentlichung liegen.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be real dates.} => q{Datum &#8222;[_1]&#8220; ungültig. Der Zeitpunkt, ab dem der Eintrag nicht mehr veröffentlicht werden soll, sollte echt sein.},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Datum &#8222;[_1]&#8220; ungültig. [_2]-Datumsangaben müssen im Format JJJJ-MM-TT HH:MM:SS vorliegen.},
	q{Invalid date '[_1]'; [_2] dates should be real dates.} => q{Datum &#8222;[_1]&#8220; ungültig; [_2]-Daten sollten echte Daten sein.},
	q{Ping '[_1]' failed: [_2]} => q{Ping &#8222;[_1]&#8220; fehlgeschlagen: [_2]},
	q{Saving entry '[_1]' failed: [_2]} => q{Der Eintrag &#8222;[_1]&#8220; konnte nicht gespeichert werden: [_2]},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet und Status geändert von [_4] in [_5] von Benutzer &#8222;[_6]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_1] &#8222;[_2]&#8220; (ID:[_3]) bearbeitet von Benutzer &#8222;[_4]&#8220;},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{Status von [_1] &#8222;[_2]&#8220; (ID:[_3]) von [_4] in [_5] geändert.},

## lib/MT/CMS/Export.pm
	'You do not have export permissions' => 'Sie haben keine Berechtigung für die Exportfunktion',
	q{Loading blog '[_1]' failed: [_2]} => q{Laden des Blogs &#8222;[_1]&#8220; fehlgeschlagen: [_2]},

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

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Import/Export',
	'Importer type [_1] was not found.' => 'Import-Typ [_1] nicht gefunden.',
	'You do not have import permission' => 'Sie haben keine Berechtigung für die Importfunktion',
	'You do not have permission to create users' => 'Sie haben keine Berechtigung, neue Benutzerkonten anzulegen.',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Sollen für die Benutzer Ihres Blogs neue Benutzerkonten angelegt werden, müssen Sie ein Passwort angeben.',

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
	'Plugins are disabled by [_1]' => '', # Translate - New
	'Plugins are enabled by [_1]' => '', # Translate - New
	q{Plugin '[_1]' is disabled by [_2]} => q{}, # Translate - New
	q{Plugin '[_1]' is enabled by [_2]} => q{}, # Translate - New

## lib/MT/CMS/Search.pm
	'Comment Text' => 'Kommentartext',
	'Entry Body' => 'Eintragstext',
	'Error in search expression: [_1]' => 'Fehler im Suchausdruck: [_1]',
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
	'Search & Replace' => 'Suchen & Ersetzen',
	'Site URL' => 'Site-URL',
	'Source URL' => 'Quell-URL',
	'Template Name' => 'Vorlagenname',
	'Text' => 'Text',
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
	'Copy of [_1]' => 'Kopie von [_1]',
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
	'New Template' => 'Neuer Vorlage',
	'One or more errors were found in the included template module ([_1]).' => 'Das eingebundene Vorlagen-Modul enthält einen oder mehrere Fehler ([_1]).',
	'One or more errors were found in this template.' => 'Die Vorlage enthält einen oder mehrere Fehler.',
	'Orphaned' => 'Verwaist',
	'Populating blog with default templates failed: [_1]' => 'Standardvorlagen konnten nicht geladen werden: [_1]',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Setze Vorlage <strong>[_3]</strong>zurück und erstelle dabei eine <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">Sicherung</a>.',
	'Saving map failed: [_1]' => 'Die Verknüpfungen konnte nicht gespeichert werden: [_1]',
	'Setting up mappings failed: [_1]' => 'Die Verknüpfungen konnte nicht angelegt werden: [_1]',
	'System Templates' => 'System-Vorlagen',
	'Template Backups' => 'Vorlagen-Sicherungen',
	'Template Modules' => 'Vorlagenmodule',
	'Template Referesh' => 'Vorlagen zurücksetzen',
	'Unable to create preview file in this location: [_1]' => 'Kann Vorschaudatei in [_1] nicht erzeugen.',
	'Unknown blog' => 'Unbekanntes Blog',
	'Widget Template' => 'Widgetvorlage',
	'Widget Templates' => 'Widgetvorlagen',
	'You must select at least one event checkbox.' => 'Markieren Sie bitte mindestens ein Ereignis-Auswahlfeld.',
	'You must specify a template type when creating a template' => 'Bitte geben Sie den Typ der neuen Vorlage an.',
	'You should not be able to enter zero (0) as the time.' => 'Null (0) ist keine gültige Zeitangabe.',
	'archive' => 'Archiv',
	'backup' => 'Sichern',
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
	'Backup & Restore' => 'Sichern & Wiederherstellen',
	'Cannot recover password in this configuration' => 'Passwörter können in dieser Konfiguration nicht angefordert werden',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Ändere URL für FileInfo-Eintrag (ID:[_1])',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Ändere Datei-Pfad für FileInfo-Eintrag (ID:[_1])...',
	'Changing image quality is [_1]' => 'Anpassung der Bildqualität ist [_1]',
	'Copying file [_1] to [_2] failed: [_3]' => 'Die Datei [_1] konnte nicht nach [_2] kopiert werden: [_3]',
	'Could not remove backup file [_1] from the filesystem: [_2]' => 'Konnte die Sicherungsdatei [_1] nicht aus dem Dateisystem löschen: [_2]',
	'Debug mode is [_1]' => 'Debugging ist [_1]',
	'Detailed information is in the activity log.' => 'Details finden Sie im Aktivitätsprotokoll.',
	'E-mail was not properly sent. [_1]' => 'Versand der Testmail fehlgeschlagen. [_1]',
	'Email address is [_1]' => 'Die E-Mail-Adresse lautet [_1]',
	'Email address is required for password reset.' => 'Die E-Mail-Adresse ist zum Zurücksetzen des Passworts erforderlich.',
	'Email address not found' => 'E-Mail-Adresse nicht gefunden',
	'Error occurred during restore process.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten.',
	'Error occurred while attempting to [_1]: [_2]' => 'Während [_1] ist ein Fehler aufgetreten: [_2]',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Beim Mailversand ist ein Fehler aufgetreten ([_1]). Überprüfen Sie die entsprechenden Einstellungen und versuchen Sie dann erneut, Ihr Passwort anzufordern.',
	'File was not uploaded.' => 'Datei wurde nicht hochgeladen.',
	'IP address lockout interval' => 'Zeitraum bis IP-Sperrung',
	'IP address lockout limit' => 'Anzahl Versuche bis IP-Sperrung',
	'Image quality(JPEG) is [_1]' => 'Bildqualität (JPG) steht auf Stufe [_1]',
	'Image quality(PNG) is [_1]' => 'Bildqualität (PNG) steht auf Stufe [_1]',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath ungültig. Die Pfadangabe muss gültig und absolut statt relativ.',
	'Invalid author_id' => 'Ungültige Autoren-ID',
	'Invalid email address' => 'Ungültige E-Mail-Adresse',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Versuch zur Passwortanforderung ungültig: Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ungültiger Versuch zur Passwortanforderung. Passwörter können in dieser Konfiguration nicht angefordert werden.',
	'Invalid password reset request' => 'Ungültige Anfrage zur Zurücksetzung des Passworts',
	'Lockout IP address whitelist' => 'Diese IP-Adresse nie sperren',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
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
	'Restoring a file failed: ' => 'Eine Datei wurde nicht wiederhergestellt: ',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Einige [_1] wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the activity log.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht widerhergestellt wurden. Details finden Sie im Aktivitätsprotokoll.',
	'Some objects were not restored because their parent objects were not restored.' => 'Einige Objekte wurden nicht wiederhergestellt, da ihre Elternobjekte nicht wiederhergestellt wurden.',
	'Some of files could not be restored.' => 'Einige Dateien konnten nicht wiederhergestellt werden.',
	'Some of the actual files for assets could not be restored.' => 'Einige Assetdateien konnten nicht wiederhergestellt werden.',
	'Some of the backup files could not be removed.' => 'Es konnten nicht alle Sicherungsdateien entfernt werden.',
	'Some of the files were not restored correctly.' => 'Einige Daten wurden nicht korrekt wiederhergestellt.',
	'Specified file was not found.' => 'Angegebene Datei nicht gefunden.',
	'Started restoring' => '', # Translate - New
	'Started restoring: [_1]' => '', # Translate - New
	'System Settings Changes Took Place' => 'Es wurden Änderungen an den Systemeinstellungen vorgenommen.',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Sicherung beschreibbar sein. Bitte überprüfen Sie Ihre (Export)TempDir-Einstellung.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check (Export)TempDir configuration directive.' => 'Das temporäre Verzeichnis muss zur Wiederherstellung beschreibbar sein. Bitte überprüfen Sie Ihre (Export)TempDir-Einstellung.',
	'Test e-mail was successfully sent to [_1]' => 'Testmail erfolgreich an [_1] versandt',
	'Test email from Movable Type' => 'Testmail von Movable Type',
	'That action ([_1]) is apparently not implemented!' => 'Aktion ([_1]) offenbar nicht implementiert!',
	'This is the test email sent by Movable Type.' => 'Das ist die Test-E-Mail, die Ihre Movable Type-Installation verschickt hat.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Die hochgeladene Datei ist keine gültige Movable Type Backup-Manifest-Datei.',
	'User lockout interval' => 'Zeitraum bis Kontosperrung',
	'User lockout limit' => 'Anzahl Versuche bis Kontosperrung',
	'User not found' => 'Benutzer nicht gefunden',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Bitte richten Sie zuerst die System-E-Mail-Adresse ein. Versuchen Sie dann erneut, die Testmail zu verschicken.',
	'Your request to change your password has expired.' => 'Ihre Anfrage auf Änderung Ihres Passworts ist abgelaufen.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] hat die Wiederherstellung mehrerer Dateien vorzeitig abgebrochen.',
	'[_1] is [_2]' => '[_1] ist [_2]',
	'[_1] is not a directory.' => '[_1] ist kein Ordner.',
	'[_1] is not a number.' => '[_1] ist keine Zahl.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] hat Sicherungsdatei erfolgreich heruntergeladen ([_2])',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{Link zum Zurücksetzen des Passworts für Benutzer &#8222;[_1]&#8220; (#[_2]) an [_3] geschickt.},
	q{Blog(s) (ID:[_1]) was/were successfully backed up by user '[_2]'} => q{Weblog(s) (ID:[_1]) erfolgreich gesichert von Benutzer &#8222;[_2]&#8220;},
	q{Changing Archive Path for the blog '[_1]' (ID:[_2])...} => q{Ändere Archiv-Pfad für Weblog &#8222;[_1]&#8220; (ID:[_2])...},
	q{Changing Site Path for the blog '[_1]' (ID:[_2])...} => q{Ändere Site-Pfad für Weblog&#8222;[_1]&#8220; (ID:[_2])...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{Ändere Pfad für Asset &#8222;[_1]&#8220; (ID:[_2])...},
	q{Manifest file '[_1]' is too large. Please use import direcotry for restore.} => q{Die Manifest-Datei &#8222;[_1]&#8220; ist zu groß. Laden Sie die Datei zur Wiederherstellung daher stattdessen in das Import-Verzeichnis hoch.},
	q{Movable Type system was successfully backed up by user '[_1]'} => q{Movable Type-System erfolgreich gesichert von Benutzer &#8222;[_1]&#8220;},
	q{Removing Archive Path for the blog '[_1]' (ID:[_2])...} => q{Entferne Archiv-Pfad für Weblog &#8222;[_1]&#8220; (ID:[_2])...},
	q{Removing Site Path for the blog '[_1]' (ID:[_2])...} => q{Entferne Site-Pfad für Weblog &#8222;[_1]&#8220; (ID:[_2])...},
	q{Successfully restored objects to Movable Type system by user '[_1]'} => q{Objekte erfolgreich wiederhergestellt durch Benutzer &#8222;[_1]&#8220;},
	q{User '[_1]' (user #[_2]) does not have email address} => q{Benutzer &#8222;[_1]&#8220; (#[_2]) hat keine E-Mail-Adresse},

## lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Namenlose Kategorie)',
	'(Untitled entry)' => '(Namenloser Eintrag)',
	'No Excerpt' => 'Kein Auszug',
	'Orphaned TrackBack' => 'Verwaistes TrackBack',
	'category' => 'Kategorien',
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Kategorie &#8222;[_4]&#8220; gelöscht},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Ping (ID:[_1]) von &#8222;[_2]&#8220; von &#8222;[_3]&#8220; aus Eintrag &#8222;[_4]&#8220; gelöscht},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(neu angelegter Benutzer)',
	'Another role already exists by that name.' => 'Es ist bereits eine Rolle mit diesem Namen vorhanden.',
	'Blogs Selected' => 'Gewählte Weblogs',
	'Cannot load role #[_1].' => 'Kann Rolle #[_1] nicht laden.',
	'Create User' => 'Benutzerkonto anlegen',
	'Grant Permissions' => 'Berechtigungen zuweisen',
	'If personal blog is set, the personal blog location are required.' => 'Zur Erzeugung persönlicher Blogs muss ein Speicherort angegeben werden.',
	'Invalid ID given for personal blog clone location ID.' => 'Ungültige ID für Klonvorlage der persönlichen Blogs',
	'Invalid ID given for personal blog theme.' => 'Ungültige ID für Thema der persönlichen Blogs',
	'Invalid type' => 'Ungültiger Typ',
	'Minimum password length must be an integer and greater than zero.' => 'Bitte geben Sie als Mindest-Passwortlänge eine ganze Zahl größer null an.',
	'Role name cannot be blank.' => 'Rollenname erforderlich.',
	'Roles Selected' => 'Gewählte Rollen',
	'Select Blogs' => 'Weblogs wählen',
	'Select Roles' => 'Rollen wählen',
	'Select Website' => 'Website wählen',
	'Select a System Administrator' => 'Systemadministrator wählen',
	'Select a entry author' => 'Eintragsautor wählen',
	'Select a page author' => 'Seitenautor wählen',
	'Selected System Administrator' => 'Gewählter Systemadministrator',
	'Selected author' => 'Gewählter Autor',
	'System Administrator' => 'Systemadministrator',
	'User requires display name' => 'Anzeigename erforderlich',
	'User requires password' => 'Passwort erforderlich',
	'User requires username' => 'Benutzername erforderlich',
	'Website Name' => 'Name der Website',
	'Websites Selected' => 'Gewählte Websites',
	'You cannot define a role without permissions.' => 'Es können keine Rollen ohne Berechtigungen definiert werden.',
	'You cannot delete your own association.' => 'Sie können nicht Ihre eigene Verknüpfung löschen.',
	'You cannot delete your own user record.' => 'Sie können nicht Ihr eigenes Benutzerkonto löschen.',
	'You have no permission to delete the user [_1].' => 'Keine Berechtigung zum Löschen von Benutzer [_1].',
	'represents a user who will be created afterwards' => 'steht für ein Benutzerkonto, das später angelegt werden wird',
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{Benutzerkonto '[_1]' (ID:[_2]) konnte nicht von '[_3]' reaktiviert werden },
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) angelegt von &#8222;[_3]&#8220;},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Benutzer &#8222;[_1]&#8220; (ID:[_2]) gelöscht von &#8222;[_3]&#8220;},
	q{[_1]'s Associations} => q{Verknüpfungen von [_1]},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'Kann Website #[_1] nicht laden.',
	'New Website' => 'Neue Website',
	'Selected Website' => 'Gewählte Website',
	'Type a website name to filter the choices below.' => 'Geben Sie einen Namen ein, um die Auswahl einzuschränken.',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{Blog &#8222;[_1]&#8220; (ID: [_2]) von &#8222;[_5]&#8220; von &#8222;[_3]&#8220; nach &#8222;[_4]&#8220; verschoben},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Website &#8222;[_1]&#8220; (ID: [_2]) gelöscht von &#8222;[_3]&#8220;},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Kategorien müssen im gleichen Blog vorhanden sein',
	'Category loop detected' => 'Kategorieschleife festgestellt',
	'Parent' => 'Mutter',
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,Eintrag,Einträge,Keine Einträge]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,Seite,Seiten,Keine Seiten]',

## lib/MT/Comment.pm
	'(Deleted)' => '(Gelöscht)',
	'Approved' => 'Freigeschaltet',
	'Comment' => 'Kommentar',
	'Commenter Status' => 'Kommentarautoren-Status',
	'Commenter' => 'Kommentarautor',
	'Comments in This Website' => 'Kommentare auf dieser Website',
	'Comments in the last 7 days' => 'Kommentare der letzten 7 Tage',
	'Comments on My Entries/Pages' => 'Kommentare zu meinen Einträgen/Seiten',
	'Comments on [_1]: [_2]' => 'Kommentare zu [_1]: [_2]',
	'Comments on my entries/pages' => 'Kommentare zu meinen Einträgen/Seiten',
	'Edit this [_1] commenter.' => 'Diesen [_1] Kommentar-Autor bearbeiten',
	'Entry/Page Status' => '', # Translate - New
	'Entry/Page' => 'Eintrag/Seite',
	'Non-spam comments on this website' => 'Gültige Kommentare auf dieser Website',
	'Non-spam comments' => 'Gültige Kommentare',
	'Not spam' => 'Nicht Spam',
	'Pending comments' => 'Zu moderierende Kommentare',
	'Published comments' => 'Veröffentlichte Kommentare',
	'Reported as spam' => 'Als Spam gemeldet',
	'Search for other comments from anonymous commenters' => 'Nach anderen anonym abgegeben Kommentaren suchen',
	'Search for other comments from this deleted commenter' => 'Nach anderen Kommentaren des gelöschten Autors suchen',
	'Spam comments' => 'Spam-Kommentare',
	'Unapproved' => 'Nicht freigeschaltet',
	'__ANONYMOUS_COMMENTER' => 'Anonym',
	q{All comments by [_1] '[_2]'} => q{Alle Kommentare von [_1] &#8222;[_2]&#8220;},
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

## lib/MT/Core.pm
	'(system)' => '(System)',
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'Activity Feed' => 'Aktivitäts-Feed',
	'Add Summary Watcher to queue' => 'Summary Watchers zur Warteschlange hinzufügen',
	'Address Book is disabled by system configuration.' => 'Das Adressbuch ist systemweit deaktiviert.',
	'Adds Summarize workers to queue.' => 'Fügt Summarize Workers zur Warteschlange hinzu',
	'Author Name' => 'Autorenname',
	'Blog ID' => 'Blog-ID',
	'Blog URL' => 'Blog-URL',
	'Change Settings' => 'Einstellungen ändern',
	'Classic Blog' => 'Klassisches Blog',
	'Convert Line Breaks' => 'Zeilenumbrüche konvertieren',
	'Create Blogs' => 'Blogs anlegen',
	'Create Entries' => 'Neuer Eintrag',
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
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => 'Die IP-Sperrliste ist systemweit deaktiviert.',
	'IP Banning Settings' => 'IP-Sperren-Einstellungen',
	'IP addresses' => 'IP-Adressen',
	'If Block' => 'If-Block',
	'If/Else Block' => 'If-Else-Block',
	'Include Template File' => 'Include-Vorlagendatei',
	'Include Template Module' => 'Include-Vorlagenmodul',
	'Junk Folder Expiration' => 'Junk-Ordner-Einstellungen',
	'Legacy Quick Filter' => 'Schnellfilter (Altsystem)',
	'Log' => 'Log',
	'Manage Address Book' => 'Adressbuch verwalten',
	'Manage Assets' => 'Assets verwalten',
	'Manage Blog' => 'Blog verwalten',
	'Manage Categories' => 'Kategorien verwalten',
	'Manage Commenters' => 'Kommentar-Autoren verwalten',
	'Manage Feedback' => 'Feedback verwalten',
	'Manage Pages' => 'Seiten verwalten',
	'Manage Plugins' => 'Plugins verwalten',
	'Manage Tags' => 'Tags verwalten',
	'Manage Templates' => 'Vorlagen verwalten',
	'Manage Themes' => 'Themen verwalten',
	'Manage Users' => 'Benutzer verwalten',
	'Manage Website with Blogs' => 'Website mit Blogs verwalten',
	'Manage Website' => 'Website verwalten',
	'Member' => 'Mitglied',
	'Movable Type Default' => 'Movable Type-Standard',
	'My Items' => 'Meine Elemente',
	'My [_1]' => 'Meine [_1]',
	'MySQL Database (Recommended)' => 'MySQL-Datenbank (empfohlen)',
	'No Label' => 'Keine Bezeichnung',
	'Permission' => 'Berechtigung',
	'Post Comments' => 'Kommentare schreiben',
	'PostgreSQL Database' => 'PostgreSQL-Datenbank',
	'Publish Entries' => 'Einträge veröffentlichen',
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
	'Save Image Defaults' => 'Bild-Voreinstellungen speichern',
	'Send Notifications' => 'Benachrichtigungen versenden',
	'Set Publishing Paths' => 'Veröffentlichungspfade setzen',
	'Set Variable Block' => 'Variablenblock setzen',
	'Set Variable' => 'Variable setzen',
	'Synchronizes content to other server(s).' => 'Synchronisiert Inhalte mit anderen Servern.',
	'The physical file path for your SQLite database. ' => 'Physischer Pfad zur SQLite-Datenbank',
	'Trackback' => 'TrackBack',
	'Unpublish Past Entries' => 'Frühere Einträge nicht mehr veröffentlichen',
	'View Activity Log' => 'Aktivitätsprotokoll ansehen',
	'View System Activity Log' => 'Systemaktivitätsprotokoll einsehen',
	'Widget Set' => 'Widgetgruppe',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] zwischen [_3] und [_4]',
	'[_1] [_2] future' => '[_1] [_2] in der Zukunft',
	'[_1] [_2] or before [_3]' => '[_1] [_2] oder bevor [_3]',
	'[_1] [_2] past' => '[_1] [_2] zurück',
	'[_1] [_2] since [_3]' => '[_1] [_2] seit',
	'[_1] [_2] these [_3] days' => '[_1] [_2] dieser [_3] Tage',
	'[_1] of this Website' => '[_1] dieser Website',
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

## lib/MT/DataAPI/Callback/Log.pm
	'A paramter "[_1]" is required.' => 'Parameter "[_1]" erforderlich.',
	'author_id (ID:[_1]) is invalid.' => 'Ungültige author_id: [_1]',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{Log (ID:[_1]) gelöscht von '[_2]'},
	'log' => 'Log',

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Befehls-Name ungültig: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Archiv-Art ungültig: [_1]',

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => 'dateFormat ungültig: [_1]',
	'Invalid textFormat: [_1]' => 'textFormat ungültig: [_1]',

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
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Wiederherstellungen nicht erneut wiederhergestellt werden.},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Unter Blog ID:[_1] konnte kein Blog angelegt werden.',
	'Either parameter of "url" or "subdomain" is required.' => 'Parameter "url" oder "subdomain" erforderlich.',
	'Site not found' => 'Site nicht gefunden',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Die Website "[_1] (ID:[_2]) enthält noch Blogs und wurde daher nicht gelöscht. Löschen Sie zuerst diese Blogs, um die Site löschen zu können.',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1_]" is required.' => 'Ressource "[_1]" erforderlich.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Beim Importieren ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie Ihre Import-Datei.',
	'Could not found archive template for [_1].' => 'Archiv-Vorlage für [_1] nicht gefunden.',
	'Invalid convert_breaks: [_1]' => 'convert_breaks-Parameter ungültig: [_1]',
	'Invalid default_cat_id: [_1]' => 'default_cat_it-Parameter ungültig: [_1]',
	'Invalid encoding: [_1]' => 'Zeichencodierung ungültig: [_1]',
	'Invalid import_type: [_1]' => 'import_type-Parameter ungültig: [_1]',
	'Preview data not found.' => 'Vorschaudaten nicht gefunden.',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Bitte geben Sie ein "password"-Parameter an, wenn Sie neue Benutzerkonten für die im Blog gelisteten Benutzer anlegen möchten.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Vergessen Sie nicht, die verwendeten Dateien aus dem &#8222;import&#8220;-Ordner zu entfernen, damit sie bei künftigen Importvorgängen nicht erneut importiert werden.},

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Protokolleintrag',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{Das 'folder'-Parameter ist ungültig.},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
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
	'Cannot publish [_1] template.' => 'Die [_1]-Vorlage konnte nicht veröffentlicht werden.',
	'Template not found' => 'Vorlage nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Vorlage "[_1]" ist keine Archiv-Vorlage.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Applying theme failed: [_1]' => 'Anwendung des Themas fehlgeschlagen: [_1]',
	'Cannot apply website theme to blog.' => 'Das Thema konnte nicht auf die Website angewendet werden.',
	'Cannot uninstall theme because the theme is in use.' => 'Das Thema konnte nicht deinstalliert werden, da es verwendet wird.',
	'Cannot uninstall this theme.' => 'Das Thema konnte nicht deinstalliert werden.',
	'Changing site theme failed: [_1]' => 'Wechseln des Site-Themas fehlgeschlagen: [_1]',
	'Unknown archiver type : $arctype' => 'Unkenannter Archiver-Typ: $arctype',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_ids dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten und müssen mit einem Buchstaben beginnen.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_versions dürfen nur Buchstaben, Ziffern, Bindestriche und Unterstriche enthalten.',
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{Das neue Thema kann nicht installiert werden, da der Basename bereits existiert und geschützt ist: [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{Ein Export-Ordner '[_1]' existiert bereits. Sie können das vorhandene Thema überschreiben, indem sie das Parameter 'overwrite_yes=1' verwenden, oder ändern Sie den Basisnamen.},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'Die angegebene E-Mail-Adresse wird mehrfach verwendet. Geben Sie daher im Parameter "name" Ihren Benutzernamen an.',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Removing Widget failed: [_1]' => 'Löschen des Widgets fehlgeschlagen: [_1]',
	'Widget not found' => 'Widget nicht gefunden',
	'Widgetset not found' => 'Widgetgruppe nicht gefunden',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => '"widgetset" erforderlich.',
	'Removing Widgetset failed: [_1]' => 'Löschen der Widgetgruppe fehlgeschlagen: [_1]',

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kann "[_1]" nicht als ISO-8601-Zeitangabe lesen',

## lib/MT/DefaultTemplates.pm
	'Category Entry Listing' => 'Einträge nach Kategorie',
	'Comment throttle' => 'Kommentarbegrenzung',
	'Commenter Confirm' => 'Kommentarautorenbestätigung',
	'Commenter Notify' => 'Kommentarautorenbenachrichtigung',
	'Entry Notify' => 'Eintragsbenachrichtigung',
	'IP Address Lockout' => 'IP-Sperre',
	'Monthly Entry Listing' => 'Einträge nach Monat',
	'New Comment' => 'Neuer Kommentar',
	'New Ping' => 'Neuer Ping',
	'User Lockout' => 'Kontensperre',

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'Kommentare annehmen',
	'Accept Trackbacks' => 'TrackBacks annehmen',
	'Author ID' => 'ID des Autors',
	'Date Commented' => 'Kommentardatum',
	'Draft Entries' => 'Eintrags-Entwürfe',
	'Draft' => 'Entwurf',
	'Entries by [_1]' => 'Einträge nach [_1]',
	'Entries from category: [_1]' => 'Einträge aus Kategorie [_1]',
	'Entries in This Website' => 'Einträge auf dieser Website',
	'Entries with Comments Within the Last 7 Days' => 'Einträge mit Kommentaren in den letzten 7 Tagen',
	'Extended' => 'Erweiterter Text',
	'Format' => 'Format',
	'Future' => 'Künftig',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Ungültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Asset-Objekte handeln.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Ugültiges Argument. Es muss sich durchgängig um bereits gespeicherte MT::Category-Objekte handeln.',
	'Junk' => 'Spam',
	'My Entries' => 'Meine Einträge',
	'NONE' => 'KEIN(E)',
	'Primary Category' => 'Hauptkategorie',
	'Publish Date' => 'Zeitpunkt der Veröffentlichung',
	'Published Entries' => 'Veröffentlichte Einträge',
	'Published' => 'Veröffentlicht',
	'Review' => 'Zur Überprüfung',
	'Reviewing' => 'In Prüfung',
	'Scheduled Entries' => 'Zeitgeplante Einträge',
	'Spam' => 'Spam',
	'Unpublish Date' => 'Zeitpunkt der Zurückziehung',
	'Unpublished (End)' => 'Unveröffentlicht (Ende)',
	'Unpublished Entries' => 'Unveröffentlichte Einträge',
	'View [_1]' => '[_1] ansehen',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] (ID: [_2]) nicht vorhanden.',
	'__PING_COUNT' => 'TrackBacks',
	'basename is too long.' => '', # Translate - New
	'record does not exist.' => 'Eintrag nicht vorhanden.',

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
	'Filters' => 'Filter',
	'Invalid filter type [_1]:[_2]' => 'Dateityp [_1] ungültig: [_2]',
	'Invalid sort key [_1]:[_2]' => 'Sortierschlüssel [_1] ungültig: [_2]',

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
	'No readable files could be found in your import directory [_1].' => 'Keine lesbaren Dateien im Import-Verzeichnis [_1] gefunden.',
	q{Cannot open '[_1]': [_2]} => q{Kann &#8222;[_1]&#8220; nicht öffnen: [_2]},
	q{Importing entries from file '[_1]'} => q{Importiere Einträge aus Datei &#8222;[_1]&#8220;},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => 'Entweder ImportAs oder ParentAuthor erforderlich',
	'No Blog' => 'Kein Blog',
	'Saving category failed: [_1]' => 'Die Kategorie konnte nicht gespeichert werden: [_1]',
	'Saving comment failed: [_1]' => 'Der Kommentar konnte nicht gespeichert werden: [_1]',
	'Saving entry failed: [_1]' => 'Der Eintrag konnte nicht gespeichert werden: [_1]',
	'Saving ping failed: [_1]' => 'Der Ping konnte nicht gespeichert werden: [_1]',
	'Saving user failed: [_1]' => 'Das Benutzerkonto konnte nicht gespeichert werden: [_1]',
	'ok (ID [_1])' => 'OK (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{Kann vorhandenen Eintrag mit Zeitstempel &#8222;[_1]&#8220; nicht finden; überspringe Kommentare und fahre mit nächstem Eintrag fort...},
	q{Creating new category ('[_1]')...} => q{Lege neue Kategorie &#8222;[_1]&#8220; an...},
	q{Creating new comment (from '[_1]')...} => q{Lege neuen Kommentar (von &#8222;[_1]&#8220;) an...},
	q{Creating new ping ('[_1]')...} => q{Erzeuge neuen Ping &#8222;[_1]&#8220;)...},
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

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'IP-Adresse gesperrt',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IP-Adresse gesperrt. IP-Adresse: [_1], Benutzername: [_2]',
	'User Was Locked Out' => 'Benutzerkonto gesperrt',
	'User has been unlocked. Username: [_1]' => 'Benutzerkonto entsperrt. Benutzername: [_1]',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Benutzerkonto gesperrt. IP-Adresse: [_1], Benutzername: [_2]',

## lib/MT/Log.pm
	'Class' => 'Typ',
	'Comment # [_1] not found.' => 'Kommentar #[_1] nicht gefunden.',
	'Debug' => 'Debug',
	'Debug/error' => 'Debug/Fehler',
	'Entry # [_1] not found.' => 'Eintrag #[_1] nicht gefunden.',
	'Information' => 'Information',
	'Level' => 'Stufe',
	'Log messages' => 'Protokolleinträge',
	'Logs on This Website' => 'Logs dieser Website',
	'Metadata' => 'Metadaten',
	'Not debug' => 'Kein Debug',
	'Notice' => 'Signifikanter Information',
	'Page # [_1] not found.' => 'Seite #[_1] nicht gefunden.',
	'Security or error' => 'Sicherheit oder Fehler',
	'Security' => 'Sicherheit',
	'Security/error/warning' => 'Sicherheit/Fehler/Warnung',
	'Show only errors' => 'Nur Fehlermeldungen anzeigen',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] nicht gefunden.',
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
	'Click to edit contact' => 'Klicken, um Kontakt zu bearbeiten',
	'Contacts' => 'Kontakte',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Asset-Platzierung',

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
	'Pages in This Website' => 'Seiten in dieser Website',
	'Pages in folder: [_1]' => 'Seiten im Ordner [_1]',
	'Pages with comments in the last 7 days' => 'Seiten mit Kommentaren in den letzten 7 Tagen',
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

## lib/MT/Placement.pm
	'Category Placement' => 'Kategorie-Platzierung',

## lib/MT/Plugin.pm
	'My Text Format' => 'Mein Textformat',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] aus Regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] aus Test [_4]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugin-Daten',

## lib/MT/Revisable.pm
	'Did not get two [_1]' => 'Nicht zwei [_1] erhalten',
	'Revision Number' => 'Revisionsnummer',
	'Revision not found: [_1]' => 'Revision nicht gefunden: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Objektarten stimmen nicht überein, erwarte zwei [_1]',
	'Unknown method [_1]' => 'Unbekannte Methode [_1]',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{Fehlerhaftes RevisioningDriver-Parameter &#8222;[_1]&#8220;: [_2]},

## lib/MT/Role.pm
	'Blog Administrator' => 'Blog-Administrator',
	'Can administer the blog.' => 'Kann das Blog verwalten',
	'Can administer the website.' => 'Kann die Website verwalten',
	'Can comment and manage feedback.' => 'Kann kommentieren und Feedback verwalten',
	'Can comment.' => 'Kann kommentieren',
	'Can create entries, edit their own entries, and comment.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und kommentieren.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kann Einträge anlegen, eigene Einträge bearbeiten und Dateien hochladen und veröffentlichen.',
	'Can edit, manage, and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Can manage pages, upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kann Dateien hochladen, alle Einträge, Seiten, Kategorien, Ordner und Tags bearbeiten und die Site veröffentlichen.',
	'Contributor' => 'Gastautor',
	'Designer' => 'Designer',
	'Editor' => 'Editor',
	'Moderator' => 'Moderator',
	'Webmaster' => 'Webmaster',
	'Website Administrator' => 'Website-Administrator',
	'__ROLE_ACTIVE' => 'Aktiv',
	'__ROLE_INACTIVE' => 'Inaktiv',
	'__ROLE_STATUS' => 'Status',

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Bewertung für dieses Objekt bereits abgegeben.',
	'Object must be saved first.' => 'Objekt muss zuerst gespeichert werden.',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{Konnte Bewertung für Objekt &#8222;[_1]&#8220; (ID: [_2]) nicht speichern.},

## lib/MT/Session.pm
	'Session' => 'Sitzung',

## lib/MT/TBPing.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping von: [_2] - [_3]</a>',
	'From' => 'Von',
	'Non-spam trackbacks on this website' => 'Gültige TrackBacks auf dieser Website',
	'Non-spam trackbacks' => 'Gültige TrackBacks',
	'Pending trackbacks' => 'Wartende TrackBacks',
	'Published trackbacks' => 'Veröffentlichte TrackBacks',
	'Source Site' => 'Quelle',
	'Source Title' => 'Quellname',
	'Spam trackbacks' => 'Spam-TrackBacks',
	'Target' => 'Nach',
	'TrackBack' => 'TrackBack',
	'Trackback Text' => 'TrackBack-Text',
	'Trackbacks in the last 7 days' => 'TrackBacks der letzten 7 Tage',
	'Trackbacks on My Entries/Pages' => 'TrackBacks zu meinen Einträgen/Seiten',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks zu [_1]: [_2]',
	'Trackbacks on my entries/pages' => 'TrackBacks zu meinen Einträgen/Seiten',

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
	'Comment Pending' => 'Kommentar wartet',
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
	q{Load of blog '[_1]' failed: [_2]} => q{Das Weblog &#8222;[_1]&#8220; konnte nicht geladen werden: [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{Die verlinkte Datei &#8222;[_1]&#8220; konnte nicht geöffnet werden: [_2]},
	q{Publish error in template '[_1]': [_2]} => q{Veröffentlichungsfehler in Vorlage &#8222;[_1]&#8220;: [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{Das System hat versucht, die Vorlagendatei von außerhalb des Include-Pfads &#8222;[_1]&#8220; zu lesen},

## lib/MT/Template/Context.pm
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wenn die gleichen Blog-ID gleichzeitig in den include_blogs- und exclude_blogs-Attributen eines mt:Entries-Befehls verwendet werden, werden die entsprechenden Blogs ausgeschlossen.',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{&#8222;[_1]&#8220; ist kein gültiger Wert für ein exclude_blogs-Attribut},
	q{You have an error in your '[_2]' attribute: [_1]} => q{Fehler im &#8222;[_2]&#8220;-Attribut: [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl in einem Blog ohne zugehörige Website verwendet - möglicherweise ist die Blog-Zuordnung fehlerhaft},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{Sie haben einen &#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Autoren-Kontexts verwendet - &#8222;MTAuthors&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Kommentar-Kontexts verwendet - &#8222;MTComments&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Seiten-Kontexts verwendet - &#8222;MTPages&#8220;-Containers erforderlich},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Ping-Kontextes verwendet - &#8222;MTPings&#8220;-Container erforderlich.},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Asset-Kontexts verwendet - &#8222;MTAssets&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Eintrags-Kontexts verwendet - &#8222;MTEntries&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Blog-Kontexts verwendet - &#8222;MTBlogs&#8220;-Container erforderlich},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Website-Kontexts verwendet - &#8222;MTWebsite&#8220;-Container erforderlich},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => 'Buchstaben und Ziffern',
	', symbols (such as #!$%)' => 'Sonderzeichen (#!$% usw.)',
	', uppercase and lowercase letters' => 'Groß- und Kleinbuchstaben',
	'Actions' => 'Aktionen',
	'All About Me' => 'Alles über mich',
	'Cannot load user.' => 'Kann Benutzerkonto nicht laden.',
	'Division by zero.' => 'Teilung durch Null.',
	'Error in [_1] [_2]: [_3]' => 'Fehler in [_1] [_2]: [_3]',
	'Error in file template: [_1]' => 'Fehler in Dateivorlage: [_1]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'Das Einbinden von Dateien wurde über das Konfigurationsparameter AllowFileInclude deaktiviert.',
	'Invalid index.' => 'Index ungültig.',
	'No [_1] could be found.' => 'Keine [_1] gefunden.',
	'No template to include was specified' => 'Keine einzubindende Vorlage angegeben',
	'Recursion attempt on [_1]: [_2]' => 'Rekursionsversuch bei [_1]: [_2]',
	'Recursion attempt on file: [_1]' => 'Rekursionsversuch bei Datei [_1]',
	'Remove this widget' => 'Dieses Widget entfernen',
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
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
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
	q{Writing to '[_1]' failed: [_2]} => q{&#8222;[_1]&#8220; konnte nicht beschrieben werden: [_2]},

## lib/MT/Template/Tags/Archive.pm
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

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Ungültiges Datumsformat: JJJJMM erforderlich',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'week_starts_with in ungültigem Format angegeben. Verwenden Sie einen dieser Ausdrücke: Mon|Tue|Wed|Thu|Fri|Sat|Sun',
	q{No such category '[_1]'} => q{Keine Kategorie &#8222;[_1]&#8220;},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => 'Kann Paket [_1] nicht finden: [_2]',
	'Cannot use sort_by and sort_method together in [_1]' => '"sorty_by" und "sort_method" können nicht gemeinsam in [_1] verwendet werden.',
	'Error sorting [_2]: [_1]' => 'Fehler beim Sortieren von [_2]: [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] muss in einem [_2]-Kontext stehen',
	'[_1] cannot be used without publishing Category archive.' => '[_1] kann nur mit Kategoriearchiv verwendet werden.',
	'[_1] used outside of [_2]' => '[_1] außerhalb [_2] verwendet',

## lib/MT/Template/Tags/Comment.pm
	'Anonymous' => 'Anonym',
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'Der Befehl MTComentFields steht nicht mehr zur Verfügung. Binden Sie stattdessen das Vorlagenmodul [_1] ein. ',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Um Kommentarregistrierung zu aktivieren, geben Sie in Ihrer Weblog-Konfiguration oder Ihrem Benutzer-Profil ein TypePad-Token ein.',
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'TypePad-Authentifizierung ist für dieses Blog nicht aktiviert. MTremoteSignInLink kann daher nicht verwendet werden.',

## lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{Der Befehl &#8222;[_1]&#8220; wird nicht mehr unterstützt. Verwenden Sie stattdessen den Befehl '[_2]'.},

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => 'Konnte keine Atom-ID für Eintrag [_1] erzeugen',
	'You used <$MTEntryFlag$> without a flag.' => 'Sie haben <$MTEntryFlag$> ohne Flag verwendet.',

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'Name erforderlich',
	q{Specified WidgetSet '[_1]' not found.} => q{Angegebene Widgetgruppe &#8222;[_1]&#8220; nicht gefunden.},

## lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$> muss im Kategoriekontext stehen oder mit dem &#8222;category&#8220;-Attribut des Tags verwendet werden.},

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
	'[_1] top level and [_2] sub categories.' => '[_1] Haupt- und [_2] Unterkategorien',
	'[_1] top level and [_2] sub folders.' => '[_1] Haupt- und [_2] Unterordner',

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
	'Assigning entry comment and TrackBack counts...' => 'Weise Kommentar- und TrackBack-Zahlen zu...',
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
	'Creating initial website and user records...' => 'Lege erste Website und Benutzereinträge an...',
	'Error creating role record: [_1].' => 'Fehler bei der Erstellung eine Rollen-Eintrags: [_1]. ',
	'Error saving record: [_1].' => 'Fehler beim Speichern eines Datensatzes: [_1].',
	'Expiring cached MT News widget...' => 'Verwerfe gecachte MT-News-Widgets...',
	'First Website' => 'Erste Website',
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
	'Assigning junk status for TrackBacks...' => 'Setze Junkstatus der TrackBacks...',
	'Assigning junk status for comments...' => 'Setze Junkstatus der Kommentare...',
	'Assigning user authentication type...' => 'Weise Art der Benutzerauthentifizierung zu...',
	'Cannot rename in [_1]: [_2].' => 'Kann nicht in [_1] umbenennen: [_2]',
	'Classifying category records...' => 'Klassifiziere Kategoriedaten...',
	'Classifying entry records...' => 'Klassifizere Eintragsdaten...',
	'Comment Posted' => 'Kommentar veröffentlicht',
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
	'Updating password recover email template...' => 'Aktualisierung des Passwort-Wiederherstellungs-Templates...',
	'Updating system search template records...' => 'Aktualisiere Suchvorlagen...',
	'Updating template build types...' => 'Aktualisiere Vorlagenaufbauarten...',
	'Updating widget template records...' => 'Aktualisiere Widgetvorlagen...',
	'Upgrading metadata storage for [_1]' => 'Aktualisiere Metadatenspeicher für [_1]',
	'Your comment has been posted!' => 'Ihr Kommentar wurde veröffentlicht!',
	'Your comment submission failed for the following reasons:' => 'Ihr Kommentar konnte aus folgenden Gründen nicht abgeschickt werden:',
	'[_1]: [_2]' => '[_1]: [_2]',

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => 'Füge Benachrichtungs-Widget zu Dashboard hinzu...',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Beim Anlegen einer Website während des Upgrades ist ein Fehler aufgetreten: [_1]',
	'Assigning ID of author for entries...' => 'Weise Autoren-IDs zu Eintragen zu...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Setze Sprache für alle Blogs zur Verbesserung der Datumsanzeige...',
	'Assigning new system privilege for system administrator...' => 'Weise neues System-Privileg an Systemadministrator zu...',
	'Assigning to  [_1]...' => 'Weise an [_1] zu...',
	'Can edit, manage and publish blog templates and themes.' => 'Kann Vorlagen und Themen bearbeiten, verwalten und veröffentlichen.',
	'Can manage pages, Upload files and publish blog templates.' => 'Kann Seiten verwalten, Dateien hochladen und Vorlagen veröffentlichen.',
	'Classifying blogs...' => 'Klassifiziere Blogs...',
	'Designer (MT4)' => 'Designer (MT4)',
	'Error loading role: [_1].' => 'Fehler beim Laden einer Rolle: [_1]',
	'Generated a website [_1]' => 'Website [_1] angelegt',
	'Generic Website' => 'Generische Website',
	'Granting new role to system administrator...' => 'Weise Systemadministrator neue Rolle zu...',
	'Merging dashboard settings...' => 'Migriere Übersichtsseiten-Einstellungen...',
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
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'Entferne Technorati-Ping-Dienst von [_1] (ID: [_2]).',
	'Removing widget from dashboard...' => 'Entferne Widget aus Übersichtsseite...',
	'Updating existing role name...' => 'Aktualisiere vorhandene Rollennamen...',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'_WEBMASTER_MT4' => 'Webmaster',
	q{An error occurred during migrating a blog's site_url: [_1]} => q{Beim Migrieren der site_url eines Blogs ist ein Fehler aufgetreten: [_1]},
	q{New user's website} => q{Website neuer Benutzer},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{Setze 'created by'-ID für Benutzerkonten ohne diese Angabe...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => 'Füge Site-Statistik-Widget hinzu...',
	'Adding Website Administrator role...' => 'Füge Website-Administratoren-Rolle hinzu...',
	'Fixing MTReleaseNumber...' => '', # Translate - New
	'Fixing TheSchwartz::Error table...' => 'Repariere TheSchwartz::Error-Tabelle...',
	'Migrating "This is you" dashboard widget...' => 'Migriere Das-sind-Sie-Widget...',
	'Migrating current blog to a website...' => 'Migriere aktuelles Blog auf Website...',
	'Migrating the record for recently accessed blogs...' => 'Migriere Aufzeichnung der kürzlich aufgerufenen Blogs....',
	'Rebuilding permission records...' => 'Baue Berechtigungs-Datensätze neu auf...',
	'Remove SQLSetNames...' => '', # Translate - New
	'Reorder DEBUG level' => '', # Translate - New
	'Reorder SECURITY level' => '', # Translate - New
	'Reorder WARNING level' => '', # Translate - New
	'Reordering dashboard widgets...' => 'Ordne Dashboard-Widgets neu an...',

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
	'Scheduled publishing.' => 'Zeitgeplante Veröffentlichtung.',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Diese Archivdatei existiert bereits. Ändern Sie entweder den Basisnamen oder den Archivpfad. ([_1])',
	'You did not set your blog publishing path' => 'Veröffentlichungspfade nicht gesetzt',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{Fehler bei der Veröffentlichung von [_1] &#8222;[_2]&#8220;: [_3]},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{Fehler bei Veröffentlichung des Archivs &#8222;[_1]&#8220;: [_2]},
	q{Archive type '[_1]' is not a chosen archive type} => q{Archivtyp &#8222;[_1]&#8220; wurde nicht ausgewählt},
	q{Parameter '[_1]' is required} => q{Parameter &#8222;[_1]&#8220; erforderlich},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{Temporäre Datei &#8222;[_1]&#8220; konnte nicht umbenannt werden: [_2]},
	q{Template '[_1]' does not have an Output File.} => q{Vorlage &#8222;[_1]&#8220; hat keine Ausgabedatei.},
	'unpublish' => 'Nicht mehr veröffentlichen',

## lib/MT/Website.pm
	'__BLOG_COUNT' => 'Blogs',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- Gruppe komplett ([quant,_1,Datei,Dateien] in [_2] Sekunden)',
	'Background Publishing Done' => 'Veröffentlichung im Hintergrund abgeschlossen',
	'Error rebuilding file [_1]:[_2]' => 'Fehler beim Neuaufbau der Datei [_1]: [_2]',
	'Published: [_1]' => 'Veröffentlicht: [_1]',

## lib/MT/Worker/Sync.pm
	'Done Synchornizing Files' => 'Synchronisierung der Dateien abgeschlossen',
	'Done syncing files to [_1] ([_2])' => 'Die Dateien wurden mit [_1] ([_2]) synchronisiert',
	qq{Error during rsync of files in [_1]:\n} => qq{Fehler beim rsyncen der Dateien in [_1]:},

## lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'HTTP-Fehler: [_1]',
	'No MTPingURL defined in the configuration file' => 'Keine MTPingURL in der Konfigurationsdatei definiert',
	'No WeblogsPingURL defined in the configuration file' => 'Keine WeblogsPingURL in der Konfigurationsdatei definiert',
	'Ping error: [_1]' => 'Ping-Fehler: [_1]',

## lib/MT/XMLRPCServer.pm
	'Error writing uploaded file: [_1]' => 'Fehler beim Schreiben der hochgeladenen Datei: [_1]',
	'Invalid timestamp format' => 'Ungültiges Zeitstempel-Format',
	'No blog_id' => 'Blog_id fehlt',
	'No filename provided' => 'Kein Dateiname angegeben',
	'No web services password assigned.  Please see your user profile to set it.' => 'Kein Passwort für Webdienste vergeben. Sie können das Passwort in Ihrem Benutzerprofil angegeben.',
	'Not allowed to edit entry' => 'Darf Eintrag nicht ändern',
	'Not allowed to get entry' => 'Darf Eintrag nicht lesen',
	'Not allowed to set entry categories' => 'Darf Kategorien nicht zuweisen',
	'Not allowed to upload files' => 'Darf Dateien nicht hochladen',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Zur Bestimmung von Höhe und Breite hochgeladener Bilddateien ist das Perl-Modul Image::Size erforderlich.',
	'Saving folder failed: [_1]' => 'Speichern des Ordners fehlgeschlagen: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Funktionen zum Zugriff auf Vorlagen sind auf Grund von Unterschieden zwischen der Blogger-API und der MovableType-API nicht implementiert.',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{Eintrag &#8222;[_1]&#8220; ([_5] #[_2]) von &#8222;[_3]&#8220; (Benutzer-Nr. [_4]) per XML-RPC gelöscht},
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
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities ist zur Kodierung bestimmter Zeichen erforderlich. Diese Funktion kann mittels der NoHTMLEntities-Direktive in der Konfigurationsdatei deaktiviert werden.',
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
	'Optional' => 'Optional',
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

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'Ungültige Web-Adresse (URL)',
	'Invalid date format' => 'Ungültiges Datumsformat',
	'Invalid value' => 'Ungültiger Wert',
	'This field is required' => 'Dieses Feld ist erforderlich.',
	'This field must be a number' => 'Zahl in diesem Feld erforderlich.',
	'This field must be an integer' => 'Integer in diesem Feld erforderlich.',
	'You have an error in your input.' => 'Eine Eingabe ist fehlerhaft.',

## mt-static/js/assetdetail.js
	'Dimensions' => 'Abmessungen',
	'File Name' => 'Dateiname',
	'No Preview Available.' => 'Keine Vorschau verfügbar',

## mt-static/js/dialog.js
	'(None)' => '(Keine)',

## mt-static/js/tc/mixer/display.js
	'Author:' => 'Autor:',
	'Description:' => 'Überschrift:',
	'Tags:' => 'Tags:',
	'Title:' => 'Titel:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a path begining with %s or %a.' => 'Bitte geben Sie einen Pfad an, der mit %s oder %a beginnt.',

## mt-static/mt.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => '[_1] Rolle(n) wirklich entfernen? Entfernen der Rollen entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Rolle wirklich entfernen? Entfernen der Rolle entzieht allen derzeit damit verknüpften Benutzern und Gruppen die entsprechenden Berechtigungen.',
	'Are you sure you want to [_2] this [_1]?' => '[_1] wirklich [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Die [_1] ausgewählten [_2] wirklich [_3]?',
	'Enter URL:' => 'URL eingeben:',
	'Enter email address:' => 'E-Mail-Adresse eingeben:',
	'First' => 'Anfang',
	'Last' => 'Ende',
	'Prev' => 'Zurück',
	'You can only act upon a maximum of [_1] [_2].' => 'Nur möglich für höchstens [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Nur möglich für mindestens [_1] [_2].',
	'You did not select any [_1] [_2].' => 'Sie haben keine [_1] [_2] gewählt',
	'You did not select any [_1] to [_2].' => 'Keine [_1] zu [_2] gewählt.',
	'You must select an action.' => 'Bitte wählen Sie zunächst eine Aktion.',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] von [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',
	'delete' => 'löschen',
	'disable' => 'deaktivieren',
	'enable' => 'aktivieren',
	'publish' => 'veröffentlichen',
	'remove' => 'entfernen',
	'to mark as spam' => 'zur Markierung als Spam',
	'to remove spam status' => 'zum Entfernen des Spam-Status',
	'unlock' => 'entsperren',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich in allen Weblogs mit &#8222;[_2]&#8220; zusammengeführt werden?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{Das Tag &#8222;[_2]&#8220; ist bereits vorhanden. Soll &#8222;[_1]&#8220; wirklich mit &#8222;[_2]&#8220; zusammengeführt werden?},

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Textbaustein einfügen',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Textbaustein',
	'Select Boilerplate' => 'Textbausteine wählen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Align Center' => 'Zentriert',
	'Align Left' => 'Linsbündig',
	'Align Right' => 'Rechtsbündig',
	'Block Quotation' => 'Zitat',
	'Bold (Ctrl+B)' => 'Fett (Strg+B)',
	'Horizontal Line' => 'Trennlinie',
	'Indent' => 'Einrücken',
	'Insert/Edit Link' => 'Link einfügen/bearbeiten',
	'Italic (Ctrl+I)' => 'Kursiv (Strg+I)',
	'Ordered List' => 'Sortierte Liste',
	'Outdent' => 'Ausrücken',
	'Redo (Ctrl+Y)' => 'Wiederholen (Strg+Y)',
	'Remove Formatting' => 'Formatierung entfernen',
	'Select Background Color' => 'Hintergrundfarbe wählen',
	'Select Text Color' => 'Schriftfarbe wählen',
	'Strikethrough' => 'Durchstreichen',
	'Underline (Ctrl+U)' => 'Unterstrichen (Strg+U)',
	'Undo (Ctrl+Z)' => 'Rückgängig (Strg+Z)',
	'Unlink' => 'Link entfernen',
	'Unordered List' => 'Unsortierte Liste',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/core.js
	'Class Name' => 'Name der Klasse',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'HTML einfügen',
	'Source' => 'Quelle',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Emphasis' => 'Betonung',
	'Insert Asset Link' => 'Link aus Assets einfügen',
	'Insert Image Asset' => 'Bild aus Assets einfügen',
	'Insert Link' => 'Link einfügen',
	'List Item' => 'Listenelement',
	'Strong Emphasis' => 'Starke Betonung',
	'Toggle Fullscreen Mode' => 'Vollbildmodus aktivieren/deaktivieren',
	'Toggle HTML Edit Mode' => 'HTML-Editor aktivieren/deaktivieren',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Fullscreen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode' => 'paste.plaintext_mode',
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'Wert',

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
	'sort_by="score" must be used together with a namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Befehl [_1] ohne Datums-Kontext verwendet.',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Befehl [_1] ohne gültiges Namens-Attribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/captcha_lib.php
	'Type the characters shown in the picture above.' => 'Geben Sie die Zeichen ein, die Sie in obigem Bild sehen.',

## php/lib/function.mtassettype.php
	'file' => 'Datei',
	'image' => 'Bild',

## php/lib/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{Der Befehl &#8222;[_1]&#8220; ist veraltet. Bitte verwenden Sie stattdessen '[_2]'},

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'TypePad-Authentifizierung ist in diesem Blog nicht aktiviert. MTRemoteSignInLink kann daher nicht verwendet werden.',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Wenn die Attribute exclude_blogs und include_blogs gemeinsam verwendet werden, geben Sie die gleichen Blog-IDs nicht gleichzeitig für beide an. ',

## php/mt.php
	'Page not found - [_1]' => 'Seite nicht gefunden - [_1]',

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
	'Manage boilerplate.' => 'Textbausteine verwalten',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Gewählten Textbaustein wirklich löschen?',
	'Create New' => 'Neu anlegen',
	'My Boilerplate' => 'Meine Textbausteine',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{Der Textbaustein '[_1]' wird in dieser Site bereits verwendet.},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Textbausteine',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Der Textbaustein  &#8222;[_1]&#8220; wird in diesem Blog bereits verwendet.},

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Create Boilerplate' => 'Textbaustein anlegen',
	'Edit Boilerplate' => 'Textbaustein bearbeiten',
	'Save changes to this boilerplate (s)' => 'Änderungen des Textbausteins speichern (s)',
	'This boilerplate has been saved.' => 'Textbaustein gespeichert',

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Textbaustein aus Datenbank gelöscht',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => '&#8222;Textbaustein einfügen&#8220;-Symbol in der TinyMCE-Symbolleiste anzeigen',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte Textbaustein nicht laden',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Textbaustein wählen',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Site-Statistik-Plugin auf Basis von Google Analytics',

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

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API-Fehler',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Profil wählen',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'(No profile selected)' => '(Kein Profil gewählt)',
	'Client ID of the OAuth2 application' => 'Client-ID der OAuth2-Anwendung',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Die Client ID oder das Client Secret von Google Analytics wurde geändert, ohne das Profil zu aktualisieren. Einstellungen wirklich speichern?',
	'Client secret of the OAuth2 application' => 'Client Secret der OAuth2-Anwendung',
	'Google Analytics 4 (GA4) is not supported.' => '',
	'Google Analytics profile' => 'Google Analytics-Profil',
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2-Einstellungen',
	'Other Google account' => 'Anderes Google-Konto',
	'Redirect URI of the OAuth2 application' => 'Redirect-URI der OAuth2-Anwendung',
	'Select Google Analytics profile' => 'Google Analytics-Profil wählen',
	'This [_2] is using the settings of [_1].' => 'In diesem [_2] werden die Einstellungen von [_1] verwendet.',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Erstellen Sie über die <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> eine OAuth2-Client-ID mit dieser Redirect-URI, bevor Sie ein Profil wählen.},

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Ein Plugin, mit dem HTML wie normaler Text eingegeben werden kann.',
	'Markdown With SmartyPants' => 'Markdown mit SmartyPants',
	'Markdown' => 'Markdown',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Wandelt einfache Interpunktionszeichen in typographisch korrekte Zecichen um.},

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Stelle MultiBlog-Trigger für Blog #[_1] wieder her....',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog-Tags können nicht veschachtelt werden.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Ungültiges "mode"-Attribut [_1]. Gültige Werte sind "loop" und "context".',

## plugins/MultiBlog/multiblog.pl
	'(All blogs in this website)' => '(Alle Blogs dieser Website)',
	'(All websites and blogs in this system)' => '(Alle Websites und Blogs in diesem System)',
	'Create Trigger' => 'Neuen Auslöser anlegen',
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Mit MultiBlog können Sie Inhalte anderer Blogs übernehmen und die dazu erforderlichen Veröffentlichungsregeln definieren.',
	'MultiBlog' => 'MultiBlog',
	'Search Weblogs' => 'Weblogs suchen',
	'Select to apply this trigger to all blogs in this website.' => 'Diesen Trigger auf alle Blogs dieser Website anwenden',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Diesen Trigger auf alle Websites und Blogs dieser Installation anwenden',
	'Updating the MultiBlog trigger cache...' => 'Aktualisiere den MultiBlog-Trigger-Cache...',
	'Website/Blog' => 'Website/Blog',
	'When this' => 'Wenn',
	'publishes a TrackBack' => 'ein TrackBack veröffentlicht wird',
	'publishes a comment' => 'ein Kommentar veröffentlicht wird',
	'publishes an entry/page' => 'ein Eintrag/eine Seite veröffentlicht wird',
	'rebuild indexes and send pings.' => 'Indizes neu aufbauen und Pings senden.',
	'rebuild indexes.' => 'Indizes neu aufbauen.',
	'saves an entry/page' => 'ein Eintrag/eine Seite gespeichert wird',
	'unpublishes an entry/page' => 'ein Eintrag/eine Seite nicht mehr veröffentlicht wird',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'Action' => 'Aktion',
	'Allow' => 'Aggregation zulassen',
	'Content Privacy' => 'Externer Zugriff auf Inhalte',
	'Create Rebuild Trigger' => 'Auslöser für Neuaufbau definieren',
	'Disallow' => 'Aggregation nicht zulassen',
	'Exclude blogs' => 'Auszuschließende Blogs',
	'Include blogs' => 'Einzuschließende Blogs',
	'MTMultiBlog tag default arguments' => 'MultiBlog- Standardargumente',
	'Rebuild Triggers' => 'Auslöser für Neuaufbau',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Hier können Sie festlegen, ob andere Blogs dieser Movable Type-Installation die Inhalte dieses Blogs verwenden dürfen oder nicht. Diese Einstellung hat Vorrang vor der globalen MultiBlog-Konfiguration.',
	'Use system default' => 'System-Voreinstellung verwenden',
	'When' => 'Wenn in',
	'You have not defined any rebuild triggers.' => 'Es sind keine Auslöser definiert.',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Ermöglicht die Verwendung von MTMultiBlog ohne include_blogs- und exclude_blogs-Attribute. Erlaubte Werte sind 'all' oder per Kommata getrennte BlogIDs.},

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'MultiBlog-Auslöser definieren',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Verwendung von Bloginhalten in anderen Blogs dieser Installation systemweit nicht erlauben. Auf Blog-Ebene gemachte Einstellungen sind vorranging, so daß diese Voreinstellung für einzelne Blogs außer Kraft gesetzt werden kann.',
	'Default system aggregation policy' => 'Systemwite Aggregations- Voreinstellung',

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
	'Publish (s)' => 'Veröffentlichen (s)',
	'Re-Edit (e)' => '',
	'Re-Edit' => '',
	'Rich Text(HTML mode)' => '',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Listing.pm
	'All' => '',
	'Filters which you created from PC.' => '',
	'_DISPLAY_OPTIONS_SHOW' => 'Zeige',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Search.pm
	'Search [_1]' => '[_1] suchen',

## plugins/SmartphoneOption/smartphone.yaml
	'Revision: <strong>[_1]</strong>' => 'Revision <strong>[_1]</strong>',
	'Smartphone Main' => '',
	'Smartphone Sub' => '',
	'Unpublish' => 'Nicht mehr veröffentlichen',
	'View revisions of this [_1]' => 'Revisionen dieser/dieses [_1] anzeigen',
	'View revisions' => 'Revisionen anzeigen',
	'to [_1]' => '',

## plugins/SmartphoneOption/tmpl/cms/dialog/select_formatted_text.tmpl
	'Continue (s)' => 'Weiter (s)',
	'No boilerplate could be found.' => '',

## plugins/StyleCatcher/config.yaml
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Mit den Standardvorlagen von MT 3.3+  kompatible Designvorlagen',
	'MT 4 Style Library' => 'MT 4-Designs',
	'Moving current style to blog_meta for blog...' => 'Verschiebe aktuelle Designvorlage des Blogs nach blog_meta...',
	'Moving current style to blog_meta for website...' => 'Verschiebe aktuelle Designvorlage der Website nach blog_meta...',
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'Mit StyleCatchter können Sie spielend leicht neue Designvorlagen für Ihre Blogs finden und mit wenigen Klicks direkt installieren. ',
	'Styles' => 'Designs',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Permission Denied.' => 'Zugriff verweigert.',
	'Successfully applied new theme selection.' => 'Neue Themenauswahl erfolgreich angewendet.',
	q{Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue.} => q{Ihr mt-static-Ordner konnte nicht gefunden werden. Bitte konfigurieren Sie 'StaticFilePath' um fortzufahren.},

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'Ungültige URL: [_1]',
	q{Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.} => q{Konnte den Ordner [_1] nicht anlegen. Stellen Sie sicher, daß der Webserver Schreibrechte auf dem 'themes'-Ordner hat.},

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Konnte StyleCatcher-Bibliothek nicht laden: [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(ohne Überschrift)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'1-Column, Wide, Bottom' => 'Einspaltig: breit - Fußzeile',
	'2-Columns, Medium, Wide' => 'Zweispaltig: mittel - breit',
	'2-Columns, Thin, Wide' => 'Zweispaltig: schmal - breit',
	'2-Columns, Wide, Medium' => 'Zweispaltig: breit - mittel',
	'2-Columns, Wide, Thin' => 'Zweispaltig: breit - schmal',
	'3-Columns, Thin, Thin, Wide' => 'Dreispaltig: schmal - schmal - breit',
	'3-Columns, Thin, Wide, Thin' => 'Dreispaltig: schmal - breit - schmal',
	'3-Columns, Wide, Thin, Thin' => 'Dreispaltig: breit - schmal - schmal',
	'Apply Design' => 'Design übernehmen',
	'Applying...' => 'Wende an...',
	'Current Style' => 'Derzeitige Design',
	'Current theme for your weblog' => 'Aktuelles Theme Ihres Weblogs',
	'Default Styles' => 'Standarddesigns',
	'Download Styles' => 'Designs herunterladen',
	'Error applying theme: ' => 'Fehler bei der Übernahme des Themas:',
	'Error loading themes! -- [_1]' => 'Fehler beim Laden der Themen -- [_1]',
	'Layout' => 'Layout',
	'Locally saved themes' => 'Lokal gespeicherte Themes',
	'More Styles' => 'Weitere Designs',
	'None available' => 'Keine verfügbar',
	'Saved Styles' => 'Gespeicherte Designs',
	'Select a [_1] Style' => '[_1]-Stil wählen',
	'Selected Design' => 'Gewähltes Design',
	'Single themes from the web' => 'Einzelne Themes aus dem Web',
	'Stylesheet or Repository URL' => 'URL des Stylesheets oder der Sammlung',
	'Stylesheet or Repository URL:' => 'URL des Stylesheets oder der Sammlung:',
	'The selected theme has been applied!' => 'Das Thema wurde übernommen!',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Das gewählte Thema wurde übernommen. Da das Layout geändert wurde, veröffentlichen Sie das Blog bitte erneut, um die Änderungen wirksam werden zu lassen.',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Korrekt formatierter Text leicht gemacht',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Als Standard festgelegter grafischer Editor.',
	'TinyMCE' => 'TinyMCE',

## plugins/WXRImporter/config.yaml
	'"Download WP attachments via HTTP."' => 'WordPress-Anhänge via HTTP herunterladen.',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'Import WordPress exported RSS into MT.' => 'Aus WordPress exportiertes RSS in Movable Type importieren',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'Assigning permissions for new user...' => 'Weise neuem Benutzer Berechtigungen zu...',
	'Entry has no MT::Trackback object!' => 'Eintrag hat kein MT::Trackback-Objekt!',
	'File is not in WXR format.' => 'Datei ist nicht im WXR-Format.',
	'Saving permission failed: [_1]' => 'Die Berechtigungen konnten nicht gespeichert werden: [_1]',
	'Saving tag failed: [_1]' => 'Speichern des Tags fehlgeschlagen: [_1]',
	q{ and asset will be tagged ('[_1]')...} => q{ und tagge Asset ('[_1]')...},
	q{Creating new tag ('[_1]')...} => q{Lege neuen Tag ('[_1]') an...},
	q{Duplicate asset ('[_1]') found.  Skipping.} => q{Doppeltes Asset ('[_1]') gefunden. Überspringe...},
	q{Duplicate entry ('[_1]') found.  Skipping.} => q{Doppelter Eintrag gefunden. Überspringe...},
	q{Saving asset ('[_1]')...} => q{Speichere Asset ('[_1]')...},
	q{Saving page ('[_1]')...} => q{Speichere Seite ('[_1]')...},

## plugins/WXRImporter/tmpl/options.tmpl
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Anhänge (Bilder und Dateien) des importierten Wordpress-Blogs herunterladen.',
	'Download attachments' => 'Anhänge herunterladen',
	'Replace with' => 'Ersetzen durch',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Lädt Anhänge von Wordpress-Blogs im Hintergrund herunter. Cronjob erforderlich.',
	'Upload path for this WordPress blog' => 'Uploadpfad für dieses WordPress-Blog',
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{Bevor Sie WordPress-Einträge in Movable Type importieren, sollten Sie zuerst die <a href='[_1]'>Veröffentlichungspfade Ihres Weblogs einstellen</a>.},

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => 'Fehlgeschlagen.',
	'Moving storage of Widget Manager [_2]...' => 'Verschiebe Speicherort des Widget Managers [_2]...',
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager 1.1 - Diese Version des Plugins dient ausschließlich dazu, Daten älterer Versionen auf das Movable Type Core-Schema zu aktualisieren. Sie können diese Plugin daher nach Installation bzw. Aktualisierung von Movable Type gefahrlos löschen.',

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
	'Finish (s)' => 'Fertigstellen (s)',
	'Finish' => 'Fertigstellen',
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

## plugins/spamlookup/spamlookup.pl
	'Despam Comments' => 'Spam aus Kommentaren entfernen',
	'Despam TrackBacks' => 'Spam aus TrackBacks entfernen',
	'Despam' => 'Spam entfernen',
	'SpamLookup Domain Lookup' => 'SpamLookup für Domains',
	'SpamLookup IP Lookup' => 'SpamLookup für IP-Adressen',
	'SpamLookup TrackBack Origin' => 'SpamLookup für TrackBack-Herkunft',
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup-Modul zur Nutzung von Sperrlisten zur Feedback-Überprüfung',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup Email Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter E-Mail-Adressen',
	'SpamLookup Link Filter' => 'SpamLookup zur Linkfilterung',
	'SpamLookup Link Memory' => 'SpamLookup zur Betrachtung bereits veröffentlichter Links',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup-Modul zur Überprüfung von Links in Feedback',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup Keyword Filter' => 'SpamLookup Schlüsselbegriff-Filter',
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup-Modul zur automatischen Einordnung von Feedback nach Schlüsselbegriffen zur Moderation oder als Spam.',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Adjust scoring' => 'Gewichtung anpassen',
	'Advanced TrackBack Lookups' => 'Zusätzliche TrackBack-Prüfungen',
	'Decrease' => 'Abschwächen',
	'Domain Blacklist Services' => 'Domain-Schwarzlisten',
	'Domain Name Lookups' => 'Prüfen von Domain-Namen',
	'IP Address Lookups' => 'Prüfen von IP-Adressen',
	'IP Blacklist Services' => 'IP-Schwarzlisten',
	'Increase' => 'Verstärken',
	'Junk TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen als Spam ansehen',
	'Junk feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains als Spam ansehen',
	'Junk feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen als Spam ansehen',
	'Less' => 'kleiner',
	'Lookup Whitelist' => 'Weißliste',
	'Moderate TrackBacks from suspicious sources' => 'TrackBacks aus dubiosen Quellen moderieren',
	'Moderate feedback containing blacklisted domains' => 'Feedback von schwarzgelisteten Domains moderieren',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback von schwarzgelisteten IP-Adressen moderieren',
	'More' => 'größer',
	'Off' => 'Nie',
	'Score weight:' => 'Gewichtung',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Tragen Sie hier IP-Adressen und Domains ein, die nicht geprüft werden sollen. Verwenden Sie pro Eintrag eine Zeile.',
	'block' => 'sperren',
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Von eingehendem Feedback können die IP-Adressen und die enthaltenen Hyperlinks in Schwarzlisten nachgeschlagen werden. Stammt ein eingehender Kommentar oder TrackBack von einer dort gelisteten IP-Adresse oder enthält er Links zu einer dort gelisteten Domain, kann er automatisch zur Moderation zurückgehalten oder als Spam angesehen werden. Für TrackBacks sind zusätzliche Prüfungen möglich.},

## plugins/spamlookup/tmpl/url_config.tmpl
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Feedback positiv bewerten, wenn die Quelladresse (URL) bereits veröffentlicht wurde.',
	'Credit feedback rating when no hyperlinks are present' => 'Feedback ohne Hyperlinks positiv bewerten',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Feedback positiv bewerten, wenn bereits zuvor Kommentare von der gleichen E-Mail-Adresse veröffentlicht wurden.',
	'Email Memory' => 'Bereits veröffentlichte E-Mail-Adressen',
	'Exclude Email addresses from comments published within last [_1] days.' => 'E-Mail-Adressen aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',
	'Exclude URLs from comments published within last [_1] days.' => 'URLs aus Kommentaren, die in den letzten [_1] Tagen veröffentlicht wurden, ausnehmen.',
	'Junk when more than' => 'Als Spam ansehen bei mehr als',
	'Link Limits' => 'Link-Schwellenwert',
	'Link Memory' => 'Bereits veröffentlichte Links',
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Die Anzahl der in eingehendem Feedback enthaltenen Hyperlinks kann kontrolliert werden. Feedback mit sehr vielen Links kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden. Umgekehrt kann Feedback, das gar keine Links enthält oder nur solche, die zuvor bereits freigegeben wurden, automatisch positiv bewertet werden.',
	'Moderate when more than' => 'Moderieren bei mehr als',
	'Only applied when no other links are present in message of feedback.' => 'Nur anwenden, wenn keine anderen Links im Feedbacktext enthalten sind',
	'link(s) are given' => 'Link(s)',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Eingehendes Feedback kann auf wählbare Schlüsselbegriffe, Domainnamen und Muster durchsucht werden. Feedback mit Treffern kann automatisch zur Moderation zurückgehalten oder als Spam angesehen werden.',
	'Keywords to Junk' => 'Bei Auftreten dieser Schlüsselwörter Feedback als Spam ansehen',
	'Keywords to Moderate' => 'Bei Auftreten dieser Schlüsselwörter Feedback moderieren',

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

## search_templates/default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DIV BETA SUCHINFOS ANFANG',
	'Blog Search Results' => 'Suchergebnis im Blog',
	'Blog search' => 'Suche im Blog',
	'END OF ALPHA SEARCH RESULTS DIV' => 'DIV ALPHA SUCHERGEBNISSE ENDE',
	'END OF CONTAINER' => 'CONTAINER ENDE',
	'END OF PAGE BODY' => 'PAGE BODY ENDE',
	'Feed Subscription' => 'Feed abonnieren',
	'Match case' => 'Groß-/Kleinschreibung beachten',
	'Matching entries from [_1]' => 'Treffer in [_1]',
	'NO RESULTS FOUND MESSAGE' => 'KEINE TREFFER-NACHRICHT',
	'Other Tags' => 'Andere Tags',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Veröffentlicht <MTIfNonEmpty tag="EntryAuthorDisplayName">von [_1] </MTIfNonEmpty>am [_2]',
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'AUTODISCOVERY-LINK FÜR SUCH-FEEDS WIRD NUR NACH ABSCHLUSS EINER SUCHE VERÖFFENTLICHT',
	'SEARCH RESULTS DISPLAY' => 'ANZEIGE DER SUCHERGEBNISSE',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'SUCHE/TAG FEED-ABO-INFO',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'SETZE VARIABLEN FÜR SUCHE VS TAG-Information',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'BEI DIREKTEN SUCHEN WIRD DAS SUCHFORMULAR ANGEZEIGT',
	'Search this site' => 'Diese Site durchsuchen',
	'Showing the first [_1] results.' => 'Erste [_1] Treffer',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG-LISTE NUR FÜR SUCHE',
	'What is this?' => 'Was ist das?',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{Entries from [_1] tagged with '[_2]'} => q{Mit &#8222;[_2]&#8220; getaggte Einträge aus [_1]},
	q{Entries matching '[_1]'} => q{Einträge mit &#8222;[_1]&#8220;},
	q{Entries tagged with '[_1]'} => q{Mit &#8222;[_1]&#8220; getaggte Einträge},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen Einträge mit &#8222;[_1]&#8220; abonnieren.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Wenn Sie einen Feedreader verwenden, können Sie einen Feed aller neuen mit &#8222;[_1]&#8220; getaggten Einträge abonnieren.},
	q{No pages were found containing '[_1]'.} => q{Keine Seiten mit &#8222;[_1]&#8220; gefunden.},

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Suchergebnisse für [_1]',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Klassisches Blog-Design mit zahlreichen Stilvorlagen und zwei- und dreispaltigen Layouts. Ideal für alle Blogging-Zwecke.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> ist der nächste Eintrag dieses Blogs.',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> ist der vorherige Eintrag dieses Blogs',

## themes/classic_website/theme.yaml
	'Classic Website' => 'Klassische Website',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Für Portale, die die Inhalte mehrerer Blogs in einer gemeinsamen Website anzeigen.',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Neues Asset hochladen',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Asset hochladen',

## tmpl/cms/backup.tmpl
	'Approximate file size per backup file.' => 'Ungefähre Größe pro Backup-Datei (MB)',
	'Archive Format' => 'Archiv-Format',
	'Backup [_1]' => '[_1]-Backup',
	'Choose websites...' => 'Websites wählen...',
	'Everything' => 'Mit allen Blogs',
	'Make Backup (b)' => 'Sicherung erstellen (b)',
	'Make Backup' => 'Sicherung erstellen',
	'No size limit' => 'Unbegrenzt',
	'Target File Size' => 'Gewünschte Dateigröße ',
	'The type of archive format to use.' => 'Das zu verwendende Archiv-Format',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Hier können Sie eine Sicherungskopie Ihrer Blogs erstellen. Sicherungen umfassen Benutzerkonten, Rollen, Verknüpfungen, Blogs, Einträge, Kategoriedefinitionen, Vorlagen und Tags.',
	'What to Backup' => 'Umfang der Sicherung',
	q{Don't compress} => q{Nicht komprimieren},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'TrackBacks annehmen',
	'Alignment' => 'Ausrichtung',
	'Ascending' => 'Aufsteigend',
	'Basename Length' => 'Länge des Basisnamens',
	'Center' => 'Mitte',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entitäten (&amp#8221;, &amp#8220; usw.)',
	'Compose Defaults' => 'Editor-Voreinstellungen',
	'Compose Settings' => 'Editor-Einstellungen',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'Sie können eigenes CSS für Inhalte nutzen, sofern der verwendete grafische Editor diese Funktion unterstützt. Referenzieren Sie Ihre CSS-Datei über ihre URL oder mit {{theme_static}}. Beispiel: {{theme_static}}pfad/zur/css-datei.css',
	'Content CSS' => 'CSS für Inhalte',
	'Czech' => 'Tschechisch',
	'Danish' => 'Dänisch',
	'Date Language' => 'Datumsanzeige',
	'Days' => 'Tage',
	'Descending' => 'Absteigend',
	'Dutch' => 'Holländisch',
	'English' => 'Englisch',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Anzahl der Wörter im automatisch generierten Textauszug.',
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
	'Link image to full-size version in a popup window.' => 'Bild mit Version in voller Größe in Popup-Fenster verlinken',
	'Link to popup window' => 'Mit Popup-Fenster verlinken',
	'Listing Default' => 'Listen-Voreinstellung',
	'No substitution' => 'Keine Zeichen ersetzen',
	'Norwegian' => 'Norwegisch',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks blog- oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since TrackBacks are disabled either website or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da TrackBacks Website- oder systemweit deaktiviert sind. ',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare blog- oder systemweit deaktiviert sind.',
	'Note: This option is currently ignored since comments are disabled either website or system-wide.' => 'Hinweis: Diese Einstellung zeigt derzeit keine Wirkung, da Kommentare Website- odersystemweit deaktiviert sind.',
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
	'Select the language in which you would like dates on your blog displayed.' => 'Sprache für Datumsanzeigen',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Geben Sie entweder die größte Anzahl Einträge an, die auf der Startseite angezeigt werden sollen, oder die höchste Anzahl Tage, aus denen dort Einträge erscheinen sollen.',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Geben Sie an, ob Einträge in chronologischer (älteste zuerst) oder umgekehrt chronologischer Reihenfolge (neueste zuerst) angezeigt werden sollen.',
	'Setting Ignored' => 'Einstellung ignoriert',
	'Slovak' => 'Slowakisch',
	'Slovenian' => 'Slovenisch',
	'Spanish' => 'Spanisch',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen Kommentare standardmässig zugelassen werden.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Legt fest, ob bei neuen Einträgen TrackBack standardmässig zugelassen werden.',
	'Specifies the default Post Status when creating a new entry.' => 'Gibt an, welcher Veröffentlichungs-Status beim Anlegen neuer Einträge voreingestellt sein soll.',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Gibt an, welche Textformatierungsoption standardmäßig beim Erstellen eines neuen Eintrags verwendet werden soll',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Setzt den Wert für den automatisch generierten Basisname des Eintrags. Mögliche Länge: 15 bis 250.',
	'Suomi' => 'Finnisch',
	'Swedish' => 'Schwedisch',
	'Text Formatting' => 'Textformatierung',
	'The range for Basename Length is 15 to 250.' => 'Basisnamen können zwischen 15 und 250 Zeichen lang sein.',
	'Unpublished' => 'Nicht veröffentlicht',
	'Use thumbnail' => 'Vorschaubild verwenden',
	'WYSIWYG Editor Setting' => 'Einstellungen des grafischen Editors',
	'You must set valid default thumbnail width.' => 'Bitte geben Sie eine gültige Breite für die Vorschaubilder an.',
	'_USAGE_ENTRYPREFS' => 'Wählen Sie aus, welche Formularfelder in der Eingabemaske angezeigt werden sollen.',
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
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Kommentare und TrackBacks bekommen eine Spam-Bewertung zwischen -10 (sicher Spam) und +10 (kein Spam) zugewiesen. Feedback mit einer geringeren Bewertung als eingestellt werden automatisch als Spam markiert.',
	'Delete Spam After' => 'Spam löschen nach',
	'E-mail Notification' => 'Benachrichtigungen',
	'Enable External TrackBack Auto-Discovery' => 'Auto-Discovery für externe TrackBacks aktivieren',
	'Enable Internal TrackBack Auto-Discovery' => 'Auto-Discovery für interne TrackBacks aktivieren',
	'Feedback Settings' => 'Feedback-Einstellungen',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks zur Moderation zurückhalten',
	'Immediately approve comments from' => 'Kommentare automatisch freischalten von',
	'Less Aggressive' => 'konservativ',
	'Limit HTML Tags' => 'HTML einschränken ',
	'Moderation' => 'Moderation',
	'More Aggressive' => 'aggressiv',
	'No CAPTCHA provider available' => 'Keine CAPTCHA-Quelle verfügbar',
	'No one' => 'niemandem',
	'Note: Commenting is currently disabled at the system level.' => 'Hinweise: Die Kommentarfunktion ist derzeit für das Gesamtsystem ausgeschaltet.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit deaktiviert. Diese Option ist daher derzeit nicht wirksam.',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Hinweis: Ausgehende TrackBacks sind derzeit systemweit eingeschränkt. Diese Option ist daher derzeit möglicherweise nicht oder nur teilweise wirksam.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Hinweis: TrackBacks sind derzeit im Gesamtsystem deaktiviert.',
	'On' => 'Immer',
	'Only when attention is required' => 'Nur wenn eine Entscheidung erforderlich ist',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Wählen Sie, ob Kommentare in chronologischer oder umgekehrter chronologischer Reihenfolge angezeigt werden sollen,',
	'Setting Notice' => 'Nutzungshinweise',
	'Setup Registration' => 'Registierung konfigurieren',
	'Spam Score Threshold' => 'Spam-Schwellenwert',
	'Spam Settings' => 'Spam-Einstellungen',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Legt fest, welche Textformatierungsoption standardmäßig für Kommentare verwendet werden soll.',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Geben Sie die HTML-Tags ein, die in Kommentartexten erlaubt sein sollen.',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Geben Sie an, was mit neuen Kommentaren geschehen soll. Ungeprüfte Kommentare werden zur Moderierung zurückgehalten.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Geben Sie an, wann Movable Type Sie über neue TrackBacks benachrichtigen soll.',
	'Specify when Movable Type should notify you of new comments.' => 'Geben Sie an, wann Movable Type Sie über neue Kommentare benachrichtigen soll.',
	'TrackBack Auto-Discovery' => 'TrackBack Auto-Discovery',
	'TrackBack Options' => 'TrackBack-Optionen',
	'TrackBack Policy' => 'TrackBack-Regeln',
	'Trackback Settings' => 'TrackBack-Einstellungen',
	'Transform URLs in comment text into HTML links.' => 'In Kommentaren enthaltene URLs in HTML-Links umwandeln.',
	'Trusted commenters only' => 'von vertrauten Kommentarautoren',
	'Use Comment Confirmation Page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	'Use comment confirmation page' => 'Bei Abgabe von Kommentaren Bestätigungsseite anzeigen',
	'Use defaults' => 'Standardwerte verwenden',
	'Use my settings' => 'Eigene Einstellungen',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'War ein Element länger als angegeben als Spam markiert war, wird es automatisch gelöscht.',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Ist Auto-Discovery aktiviert, werden für HTML-Links in neuen Einträgen automatisch TrackBacks verschickt, wenn die Gegenseite solche akzeptiert.',
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
	'Documentation' => 'Dokumentation',
	'Enable Plugins' => 'Plugins aktivieren',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin für die gesamte Movable Type-Installation aktivieren oder deaktivieren.',
	'Enable plugin functionality' => 'Plugin-Funktion aktivieren',
	'Failed to Load' => 'Fehler beim Laden',
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
	'Settings for [_1]' => 'Einstellungen von [_1]',
	'Tag Attributes:' => 'Tag-Attribute:',
	'Text Filters' => 'Textfilter',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Dieses Plugin wurde noch nicht für Movable Type [_1] aktualisiert. Es funktioniert daher möglicherweise nicht einwandfrei.',
	'Your plugin settings have been reset.' => 'Plugin-Einstellungen zurückgesetzt',
	'Your plugin settings have been saved.' => 'Plugin-Einstellungen übernommen',
	'Your plugins have been reconfigured.' => 'Einstellungen übernommen',
	'[_1] Plugin Settings' => '[_1]-Plugin-Einstellungen',
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
	'Blog root must be under [_1]' => 'Das Wurzelverzeichnis der Website muss in [_1] liegen.',
	'Cancel upload' => 'Vorgang abbrechen',
	'Change license' => 'Lizenz ändern',
	'Choose archive type' => 'Archiv-Typ wählen',
	'Dynamic Publishing Options' => 'Dynamikoptionen',
	'Enable conditional retrieval' => 'Conditional Retrieval aktivieren',
	'Enable dynamic cache' => 'Dynamischen Cache aktivieren',
	'Enable orientation normalization' => 'Automatisches Drehen aktivieren',
	'Enable revision history' => 'Revisionsshistorie aufzeichnen',
	'Enter a description for your blog.' => 'Geben Sie eine Beschreibung Ihres Blogs ein.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type kann nicht in den Vorlagen-Cache schreiben. Bitte weisen Sie dem Server Schreibrechte für das Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website zu.',
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Fehler: Movable Type konnte kein Verzeichnis für Ihr [_1] anlegen. Sollten Sie das Verzeichnis bereits selbst angelegt haben, stellen Sie bitte sicher, daß der Webserver für Schreibrechte dafür verfügt.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Fehler: Movable Type konnte kein Cache-Verzeichnis für die dynamische Veröffentlichung erstellen. Bitte legen Sie ein Verzeichnis <code>[_1]</code> im Wurzelverzeichnis der Website an.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Wenn Sie eine andere Sprache als die systemweit festgelegte Standardsprache wählen, können Sie unterschiedliche globale Vorlagen verwenden, indem Sie die Modulnamen in Ihren Vorlagen entsprechend ändern.',
	'Java Server Page Includes' => 'Java Server Page-Includes',
	'Language' => 'Sprache',
	'License' => 'Lizenz',
	'Module Caching' => 'Modul-Caching',
	'Module Settings' => 'Modul-Einstellungen',
	'Name your blog. The name can be changed at any time.' => 'Wählen Sie einen Namen für Ihr Blog. Sie können ihn später jederzeit ändern.',
	'No archives are active' => 'Archiv nicht aktiviert',
	'None (disabled)' => 'Keine (deaktiviert)',
	'Normalize orientation' => 'Bilder automatisch drehen',
	'Note: Revision History is currently disabled at the system level.' => 'Hinweis: Revisionshistorie ist systemweit deaktiviert',
	'Number of revisions per entry/page' => 'Anzahl der Revisionen pro Eintrag/Seite',
	'Number of revisions per template' => 'Anzahl der Revisionen pro Vorlage',
	'Operation if a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'Overwrite existing file' => 'Vorhandene Datei überschreiben',
	'PHP Includes' => 'PHP-Includes',
	'Preferred Archive' => 'Bevorzugte Archive',
	'Publish With No Entries' => 'Leer veröffentlichen',
	'Publish archives outside of [_1] Root' => 'Archive außerhalb des [_1]-Wurzelverzeichnisses veröffentlichen',
	'Publish category archive without entries' => 'Leere Kategoriearchive veröffentlichen',
	'Publishing Paths' => 'System-Pfade',
	'Remove license' => 'Lizenz entfernen',
	'Rename filename' => 'Datei umbenennen',
	'Rename non-ascii filename automatically' => 'Nicht-ASCII-Dateinamen automatisch umbenennen',
	'Revision History' => 'Revisionshistorie',
	'Revision history' => 'Revisionshistorie',
	'Select a license' => 'Creative Commons-Lizenz wählen',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Wählen Sie diese Option nur, wenn Sie Ihr Archiv außerhalb des Wurzelverzeichnisses Ihres Blog veröffentlichen müssen.',
	'Select your time zone from the pulldown menu.' => 'Wählen Sie die gewünschte Zeitzone im Dropdown-Menü.',
	'Server Side Includes' => 'Server Side Includes',
	'The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Unter dieser URL erscheint das Archiv Ihres Blogs, beispielsweise unter http://beispiel.de/blog/archiv/',
	'The URL of the archives section of your website. Example: http://www.example.com/archives/' => 'Unter dieser URL erscheint das Archiv Ihrer Website, beispielsweise unter http://beispiel.de/archiv/',
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
	'Upload and rename' => 'Hochladen und umbenennen',
	'Use absolute path' => 'Absolute Pfadangabe verwenden',
	'Use subdomain' => 'Subdomain verwenden',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Website root must be under [_1]' => 'Das Wurzelverzeichnis der Website muss in [_1] liegen.',
	'You did not select a time zone.' => 'Bitte wählen Sie eine Zeitzone.',
	'You must set a valid Archive URL.' => 'Bitte geben Sie eine gültige Archiv-Adresse an.',
	'You must set a valid Local Archive Path.' => 'Bitte geben Sie einen gültigen lokalen Archiv-Pfad an.',
	'You must set a valid Local file Path.' => 'Bitte geben Sie einen gültigen lokalen Dateipfad an.',
	'You must set a valid URL.' => 'Bitte geben Sie eine gültige URL ein.',
	'You must set your Blog Name.' => 'Bitte geben Sie einen Blognamen an.',
	'You must set your Local Archive Path.' => 'Bitte geben Sie einen lokalen Archiv-Pfad an.',
	'You must set your Local file Path.' => 'Bitte geben Sie einen lokalen Dateipfad an.',
	'Your blog does not have an explicit Creative Commons license.' => 'Für dieses Blog liegt keine Creative Commons-Lizenz vor.',
	'Your blog is currently licensed under:' => 'Ihr Blog ist derzeit lizenziert unter:',
	'Your website does not have an explicit Creative Commons license.' => 'Für diese Website liegt keine Creative Commons-Lizenz vor.',
	'Your website is currently licensed under:' => 'Ihre Website ist derzeit lizenziert unter:',
	'[_1] Root' => '[_1]-Wurzelverzeichnis',
	'[_1] Settings' => '[_1]-Einstellungen',
	'[_1] URL' => '[_1]-URL',
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{Geben Sie die gewünschte Erweiterung der Archiv-Dateien an. Möglich sind .html, .shtml, .php usw. Hinweis: Geben Sie die Erweiterung ohne führenden Punkt (&#8222;.&#8220;) ein.},
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{Die URL Ihres Blogs. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/blog/ },
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{Die URL Ihrer Website. Bitte geben Sie die Adresse ohne Dateinamen und mit abschließendem &#8222;/&#8220; ein, beispielsweise so: http://beispiel.de/ },
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien des Archivs veröffentlicht. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog'},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Unter diesem Pfad werden die Index-Dateien abgelegt. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive types used in this blog's archive templates.} => q{Wird zur Erzeugung der dauerhaften Links archivierter Einträge (Permalinks) verwendet. Wählen Sie dazu einen der in diesem Blog verwendeten Archiv-Typen aus.},
	q{Used to generate URLs (permalinks) for this website's archived entries. Choose one of the archive types used in this website's archive templates.} => q{Wird zur Erzeugung der dauerhaften Links archivierter Einträge (Permalinks) verwendet. Wählen Sie dazu einen der in dieser Website verwendeten Archiv-Typen aus.},

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(Keine Rolle gewählt)',
	'Allow registration for this website.' => 'Registrierungen für diese Website zulassen',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Ermöglichen Sie Lesern, sich mit einer der unten aufgeführten Methoden als Mitglied dieser Website zu registrieren.',
	'Authentication Methods' => 'Authentifizierungs- methoden',
	'New Created User' => 'Neu angelegte Benutzerkonten',
	'Note: Registration is currently disabled at the system level.' => 'Hinweis: Registrierungen sind derzeit systemweit deaktiviert.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Zur Nutzung dieser Authentifizierungsmethode fehlt mindestens ein erforderliches Perl-Modul.',
	'Please select authentication methods to accept comments.' => 'Wählen Sie, auf welche Weise sich Kommentar-Autoren authentifizieren können sollen.',
	'Registration Not Enabled' => 'Registrierungen nicht zulassen',
	'Registration Settings' => 'Registrierungs-Einstellungen',
	'Select a role that you want assigned to users that are created in the future.' => 'Wählen Sie die Rolle, die künftig angelegten Benutzerkonten automatisch zugewiesen werden soll.',
	'Select roles' => 'Rollen awählen',
	'User Registration' => 'Benutzerregistrierung',
	'Your blog preferences have been saved.' => 'Einstellungen für Blog übernommen.',
	'Your website preferences have been saved.' => 'Einstellungen für Website übernommen.',

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
	'Disable comments for all websites and blogs.' => 'Kommentare für alle Websites und Blogs deaktivieren',
	'Disable notification pings for all websites and blogs.' => 'Benachrichtigungs-Pings für alle Websites und Blogs deaktivieren.',
	'Disable receipt of TrackBacks for all websites and blogs.' => 'Empfang von TrackBacks für alle Websites und Blogs deaktivieren',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Versand von Benachrichtigungs-Pings bei Veröffentlichung neuer Einträge systemweit deaktivieren.',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Versenden Sie keine TrackBacks und verwenden Sie kein Auto-Disovery für TrackBacks, wenn Ihre Installation privat sein soll.',
	'Enable image quality changing.' => 'Anpassung der Bildqualität aktivieren',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Aktivieren Sie diese Funktion, um Movable Type frühere Versionen von Einträgen, Seiten und Vorlagen vorhalten zu lassen.',
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
	'One or more of your websites or blogs are not following the base site path (value of BaseSitePath) restriction.' => 'Mindestens eines Ihrer Blog oder eines Ihrer Sites erfüllt nicht die Base-Site-Path-Anforderungen, die in BaseSitePath angegeben sind.',
	'Only to websites on the following domains:' => 'Nur zu folgenden Domains:',
	'Outbound Notifications' => 'Benachrichtigungen',
	'Performance Logging' => 'Performance-Logging',
	'Prohibit Comments' => 'Kommentare nicht zulassen',
	'Prohibit Notification Pings' => 'Pings nicht zulassen',
	'Prohibit TrackBacks' => 'TrackBacks nicht zulassen',
	'Select' => 'Wählen',
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
	'This will override all individual blog settings.' => 'Dieser Einstellung überragt alle Einstellungen auf Blog-Ebene.',
	'Track revision history' => 'Revisionshistorie verfolgen',
	'Turn on performance logging' => 'Performance-Logging aktivieren',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Performance-Logging protokolliert Ereignisse, die länger als eine von Ihnen bestimmbare Zeitspanne dauern.',
	'User lockout policy' => 'Kontensperrung',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Geben Sie ein Zahl größer null ein, um Diagnosemodi zu aktivieren. Welche Modi verfügbar sind, finden sie in der <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Dokumentation des Debug-Modus</a> (englischsprachig).',
	'You must set a valid absolute Path.' => 'Bitte geben Sie einen gültigen absoluten Pfad an.',
	'You must set an integer value between 0 and 100.' => 'Bitte geben Sie eine ganze Zahl zwischen 0 und 100 ein.',
	'You must set an integer value between 0 and 9.' => 'Bitte geben Sie iene ganze Zahl zwischen 0 und 9 ein.',
	'Your settings have been saved.' => 'Die Einstellungen wurden gespeichert.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Diese IP-Adressen werden nie gesperrt:},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Bitte wählen Sie, welcher Administrator über automatische IP- und Benutzerkonten-Sperrungen informiert werden soll. Wählen Sie keinen Administrator, wird die System-E-Mail-Adresse verwendet.},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Movable Type verwendet diese Adresse als Absenderadresse für vom System verschickte Mails, beispielsweise bei Passwort-Anforderungen, Kommentar-Benachrichtigungen usw.},

## tmpl/cms/cfg_system_users.tmpl
	'(No theme selected)' => '(Kein Thema gewählt)',
	'(No website selected)' => '(Keine Website gewählt)',
	'Allow Registration' => 'Registrierung erlauben',
	'Allow commenters to register on this system.' => 'Kommentarautoren ermöglichen, sich selbst zu registrieren.',
	'Automatically create a new blog for each new user.' => 'Für neue Benutzer automatisch eigenes Blog anlegen.',
	'Change theme' => 'Thema ändern',
	'Change website' => 'Website wechseln',
	'Choose the default language to apply to all new users.' => 'Wählen Sie, welche Sprache für neue Benutzerkonten verwendet werden soll.',
	'Comma' => 'Komma',
	'Default Tag Delimiter' => 'Standard- Tag-Trennzeichen',
	'Default Time Zone' => 'Standard-Zeitzone',
	'Default User Language' => 'Standard-Sprache',
	'Define the default delimiter for entering tags.' => 'Wählen Sie das Standard-Trennzeichen für die Eingabe von Tags',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Automatisch persönliche Blogs für neue Benutzer anlegen. Dem Benutzer werden für sein persönliches Blog Administrationsrechte zugewiesen.',
	'Minimun Length' => 'Mindestlänge',
	'New User Defaults' => 'Voreinstellungen für neue Benutzer',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Hinweis: Sie haben noch keine System-E-Mail-Adresse eingerichtet. Benachrichtigungen können daher nicht verschickt werden. Die Adresse kann unter System > Grundeinstellungen eingerichtet werden.',
	'Notify the following system administrators when a commenter registers:' => 'Folgende Systemadministratoren benachrichtigen, wenn sich ein Kommentarautor registriert hat:',
	'Password Validation' => 'Passwortregeln',
	'Personal Blog Location' => 'Speicherort für persönliche Blogs',
	'Personal Blog Theme' => 'Thema für persönliche Blogs',
	'Personal Blog' => 'Persönliches Blog',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Bestimmen Sie, welcher Systemadministrator benachrichtigt werden soll, wenn ein Kommentarautor sich erfolgreich selbst registriert hat.',
	'Select a website you wish to use as the location of new personal blogs.' => 'Wählen Sie, unter welcher Website neue persönliche Blogs abgelegt werden sollen.',
	'Select system administrators' => 'System-Administrator wählen',
	'Select the theme that should be used for new personal blogs.' => 'Wählen Sie, welches Thema für neue persönliche Blogs genutzt werden soll.',
	'Select theme' => 'Thema wählen',
	'Select website' => 'Website wählen',
	'Should contain letters and numbers.' => 'Buchstaben und Ziffern erforderlich',
	'Should contain special characters.' => 'Sonderzeichen erforderlich',
	'Should contain uppercase and lowercase letters.' => 'Klein- und Großbuchstaben erforderlich',
	'Space' => 'Leerzeichen',
	'This field must be a positive integer.' => 'Positive ganze Zahl erforderlich.',
	'User Settings' => 'Benutzer-Einstellungen',

## tmpl/cms/cfg_web_services.tmpl
	'(Separate URLs with a carriage return.)' => '(Pro Zeile eine URL)',
	'Data API Settings' => 'Data-API-Einstellungen',
	'Data API' => 'Data-API',
	'Enable Data API in system scope.' => 'Data-API systemweit aktivieren.',
	'Enable Data API in this site.' => 'Data-API für diese Site aktivieren.',
	'External Notifications' => 'Externe Benachrichtigungen',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Hinweis: Diese Option ist derzeit nicht wirksam, da ausgehende Pings systemweit deaktiviert sind.',
	'Notify ping services of website updates' => 'Ping-Dienste über Aktualisierungen dieser Website benachrichtigen',
	'Others:' => 'Andere:',
	'Web Services Settings' => 'Webdienste-Einstellungen',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Movable Type benachrichtigt die angegeben Dienste automatisch, wenn diese Website aktualisiert wird.',

## tmpl/cms/dashboard.tmpl
	'Add' => 'Hinzufügen',
	'Dashboard' => 'Übersichtsseite',
	'Select a Widget...' => 'Widget wählen...',
	'System Overview' => 'Systemübersicht',
	'Your Dashboard has been updated.' => 'Übersichtsseite aktualisiert.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => 'Zurück (b)',
	'Confirm Publishing Configuration' => 'Veröffentlichungseinstellungen bestätigen',
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Geben Sie die neue Adresse des Archivs Ihres Blogs an. Beispiel: http://beispiel.de/blog/archiv/',
	'Parent Website' => 'Eltern-Website',
	'Please choose parent website.' => 'Bitte wählen Sie die Eltern-Website.',
	'You must select a parent website.' => 'Bitte wählen Sie eine Eltern-Website.',
	'You must set a valid Site URL.' => 'Bitte geben Sie eine gültige Adresse (URL) an',
	'You must set a valid local site path.' => 'Bitte geben Sie ein gültiges lokales Verzeichnis an',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{Geben Sie die neue Adresse (URL) Ihres öffentlichen Blogs mit abschließendem '/' ein. Beispiel: http://beispiel.de/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit 'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zu den Index-Dateien des Archivs ohne abschließendes '/' oder  '\' an. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Geben Sie den neuen Pfad zur Startseiten-Datei an. Bitte geben Sie möglichst einen absoluten (bei Linux mit '/' oder bei Windows mit \'C:\' beginnenden) Pfad an und verwenden Sie kein abschließendes '/' oder '\'. Beispiel: /home/mt/public_html oder C:\www\public_html},

## tmpl/cms/dialog/asset_edit.tmpl
	'An error occurred.' => 'Es ist ein Fehler aufgetreten.',
	'Edit Image' => 'Bild bearbeiten',
	'Error creating thumbnail file.' => 'Fehler beim Erstellen des Vorschaubilds',
	'File Size' => 'Dateigröße',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'Die Metadaten dieses Bildes sind nicht lesbar und können daher nicht aktualisiert werden.',
	'Save changes to this asset (s)' => 'Änderungen des Assets speichern (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Dialog wirklich schließen?',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren. Möchten Sie das Bild wirklich bearbeiten?',
	'Your edited image has been saved.' => 'Das bearbeitete Bild wurde gespeichert.',

## tmpl/cms/dialog/asset_list.tmpl
	'Asset Name' => 'Assetname',
	'Insert (s)' => 'Einfügen (s)',
	'Insert Asset' => 'Asset einfügen',
	'Insert Image' => 'Bild einfügen',
	'Insert' => 'Einfügen',
	'Next (s)' => 'Nächstes (s)',
	'No assets could be found.' => 'Keine Assets gefunden.',
	'Size' => 'Größe',
	'Upload New File' => 'Neue Datei hochladen',
	'Upload New Image' => 'Neues Bild hochladen',

## tmpl/cms/dialog/asset_modal.tmpl
	'Library' => 'Bibliothek',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'Neuen Eintrag mit hochgeladener Datei anlegen',
	'Create entry using this uploaded file' => 'Eintrag mit hochgeladener Datei anlegen',
	'File Options' => 'Dateioptionen',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Bild in Eintrag/Seite anzeigen',
	'Remember these settings' => 'Einstellungen speichern',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Bitte konfigurieren Sie Ihr Blog.',
	'Your blog has not been published.' => 'Ihr Blog wurde noch nicht veröffentlicht.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'Blog-Details',
	'Categories/Folders' => 'Kategorien/Ordner',
	'Clone' => 'Klonen',
	'Confirm' => 'Bestätigen',
	'Entries/Pages' => 'Einträge/Seiten',
	'Exclude Categories/Folders' => 'Kategorien/Ordner ausschließen',
	'Exclude Comments' => 'Kommentare ausschließen',
	'Exclude Entries/Pages' => 'Einträge/Seiten ausschließen',
	'Exclude Trackbacks' => 'TrackBacks ausschließen',
	'Exclusions' => 'Ausschließen',
	'Mark the settings that you want cloning to skip' => 'Markieren Sie Objekte, die nicht geklont werden sollen',
	'Publish archives outside of Blog Root' => 'Archiv außerhalb Wurzelverzeichnis ablegen',
	'This is set to the same URL as the original blog.' => 'Das ist die URL des ursprünglichen Blogs.',
	'This will overwrite the original blog.' => 'Das ursprüngliche Blog wird daher beim Klonen überschrieben.',
	'Warning: Changing the archive URL can result in breaking all links in your blog.' => 'Hinweis: Eine Änderung der Archiv-Adresse kann alle Links zu Ihrem Blog ungültig machen.',
	'Warning: Changing the archive path can result in breaking all links in your blog.' => 'Warnung: Eine Änderung des Archiv-Pfads kann sämtliche internen Links Ihres Blogs ungültig machen.',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => '[_2] hat am [_1] [_3] kommentiert',
	'Reply to comment' => 'Kommentar beantworten',
	'Submit reply (s)' => 'Abschicken (s)',
	'Your reply:' => 'Ihre Antwort:',

## tmpl/cms/dialog/create_association.tmpl
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'In dieser MT-Installation ist kein Blog vorhanden. [_1]Blog anlegen</a>',
	'No roles exist in this installation. [_1]Create a role</a>' => 'In dieser MT-Installation ist keine Rolle vorhanden. [_1]Rolle anlegen</a>',
	'No websites exist in this installation. [_1]Create a website</a>' => 'In dieser MT-Installation ist kein Website vorhanden. [_1]Website anlegen</a>',

## tmpl/cms/dialog/edit_image.tmpl
	'Apply' => 'Anwenden',
	'Crop' => 'Beschneiden',
	'Flip horizontal' => 'Horizontal spiegeln',
	'Flip vertical' => 'Vertikal spiegeln',
	'H:' => 'H:',
	'Keep aspect ratio' => 'Seitenverhältnis beibehalten',
	'Redo' => 'Wiederholen',
	'Remove All metadata' => 'Alle Metadaten entfernen',
	'Remove GPS metadata' => 'GPS-Metadaten entfernen',
	'Rotate left' => 'Nach links drehen',
	'Rotate right' => 'Nach rechts drehen',
	'Undo' => 'Rückgängig',
	'W:' => 'B:',
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
	'Display [_1] in entry/page' => '[_1] im Eintrag/auf der Seite anzeigen',
	'Insert Options' => 'Einfüge-Optionen',

## tmpl/cms/dialog/new_password.tmpl
	'The password for the user \'[_1]\' has been recovered.' => '', # Translate - New

## tmpl/cms/dialog/publishing_profile.tmpl
	'All templates published statically via Publish Que.' => 'Alle Vorlagen statisch über die Veröffentlichungs-Warteschlange veröffentlichen.',
	'Are you sure you wish to continue?' => 'Wirklich fortsetzen?',
	'Background Publishing' => 'Veröffentlichung im Hintergrund',
	'Choose the profile that best matches the requirements for this blog.' => 'Wählen Sie das Profil, das den Anforderungen dieses Blogs am besten entspricht.',
	'Choose the profile that best matches the requirements for this website.' => '', # Translate - New
	'Dynamic Archives Only' => 'Nur Archiv dynamisch',
	'Dynamic Publishing' => 'Dynamische Veröffentlichung',
	'Execute' => '', # Translate - New
	'High Priority Static Publishing' => 'Priorisierte statische Veröffentlichung',
	'Immediately publish Main Index and Feed templates, preferred Individual and Page archives statically. Use Publish Queue to publish all other templates statically.' => '', # Translate - New
	'Immediately publish all templates statically.' => 'Alle Vorlagen sofort statisch veröffentlichen.',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle Archiv-Vorlagen dynamisch, alle anderen Vorlagen sofort statisch veröffentlichen.',
	'Publish all templates dynamically.' => 'Alle Vorlagen dynamisch veröffentlichen.',
	'Publishing Profile' => 'Veröffentlichungsprofil',
	'Static Publishing' => 'Statische Veröffentlichung',
	'This new publishing profile will update your publishing settings.' => 'Das neue Veröffentlichungs-Profil ändert Ihre Veröffentlichungs-Einstellungen.',

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
	'All data restored successfully!' => 'Alle Daten erfolgreich wiederhergestellt!',
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Bei der Wiederherstellung ist ein Fehler aufgetreten: [_1]. Bitte überprüfen Sie die Sicherungsdatei.',
	'Close (s)' => 'Schließen (s)',
	'Next Page' => 'Nächste Seite',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Diese Seite leitet in drei Sekunden auf eine neue Seite weiter. [_1]Weiterleitung abbrechen[_2].',
	'View Activity Log (v)' => 'Aktivitätsprotokoll ansehen (v)',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Wiederherstellung...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Abbrechen führt zu verwaisten Objekten. Wiederherstellung wirklich abbrechen?',
	'Please upload the file [_1]' => 'Bitte laden Sie die Datei [_1] hoch',
	'Restore: Multiple Files' => 'Wiederherstellung mehrerer Dateien',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant blog permission to group' => 'Berechtigung für Blog zuweisen an Gruppe',
	'Grant blog permission to user' => 'Berechtigung für Blog zuweisen an Benutzer',
	'Grant website permission to group' => 'Berechtigung für Website zuweisen an Gruppe',
	'Grant website permission to user' => 'Berechtigung für Website zuweisen an Benutzer',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Thema für persönliche Blogs wählen',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => 'Verwendet in...',
	'Copy' => '', # Translate - New
	'Edit Asset' => 'Asset bearbeiten',
	'Embed Asset' => 'Asset einbetten',
	'Related Assets' => 'Verwandte Assets',
	'Stats' => 'Statistik',
	'This asset has been used by other users.' => 'Das Asset wird von anderen Benutzern verwendet.',
	'You have unsaved changes to this asset that will be lost.' => 'Ihre Änderungen an diesem Asset wurden noch nicht gespeichert und gehen verloren.',
	'You must specify a name for the asset.' => 'Bitte geben Sie einen Namen für das Asset an.',
	'[_1] - Created by [_2]' => 'Angelegt von [_2] [_1]',
	'[_1] - Modified by [_2]' => '[_1] - Bearbeitet von [_2]',
	'[_1] is missing' => '[_1] fehlt',

## tmpl/cms/edit_author.tmpl
	'(Use Website/Blog Default)' => '(Standardeinstellung verwenden)',
	'A new password has been generated and sent to the email address [_1].' => 'Ein neues Passwort wurde erzeugt und an [_1] verschickt.',
	'Create User (s)' => 'Benutzerkonto anlegen (s)',
	'Create personal blog for user' => 'Persönliches Blog für den Benutzer anlegen',
	'Date Format' => 'Zeit- angaben',
	'Default date formatting in the Movable Type interface.' => 'Standard-Datums-Formatierung in der Movable Type-Oberfläche',
	'Default text formatting filter when creating new entries and new pages.' => 'Standard-Textfilter beim Erstellen neuer Seiten und Einträge',
	'Display language for the Movable Type interface.' => 'Anzeigesprache der Movable Type-Benutzeroberfläche',
	'Enter preferred password.' => 'Bevorzugtes Passwort eingeben',
	'Error occurred while removing userpic.' => 'Beim Entfernen des Benutzerbildes ist ein Fehler aufgetreten',
	'Existing password required to create a new password.' => 'Derzeitiges Passwort zur Passwortänderung erforderlich',
	'External user ID' => 'Externe Benutzer-ID',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Erforderlich für Aktivitätsfeeds und für externe Software, die über XML-RPC oder ATOM-API auf das Weblog zugreift',
	'Full' => 'Absolut',
	'Initiate Password Recovery' => 'Passwort wiederherstellen',
	'Password recovery word/phrase' => 'Erinnerungssatz',
	'Preferences' => 'Konfigurieren',
	'Preferred method of separating tags.' => 'Bevorzugtes Trennzeichen für Tags',
	'Relative' => 'Relativ',
	'Remove Userpic' => 'Benutzerbild entfernen',
	'Reveal' => 'Anzeigen',
	'Save changes to this author (s)' => 'Kontoänderungen speichern (s)',
	'Select Userpic' => 'Benutzerbild wählen',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Status des Benutzerkontos. Um einem Benutzer den Zugriff auf das System zu entziehen, ohne von ihm angelegte Inhalte zu verliren, deaktivieren Sie das jeweilige Benutzerkonto.',
	'System Permissions' => 'Berechtigungen',
	'Tag Delimiter' => 'Tag-Trennzeichen',
	'Text Format' => 'Textformatierung',
	'The email address associated with this user.' => 'Mit diesem Benutzer verknüpfte E-Mail-Adresse',
	'The image associated with this user.' => 'Ein diesem Benutzer zugeordnetes Bild',
	'The name displayed when content from this user is published.' => 'Der Name, der zusammen mit Inhalten dieses Benutzers angezeigt werden soll.',
	'The username used to login.' => 'Benutzername (für Anmeldung)',
	'This profile has been unlocked.' => 'Benutzerkonto entsperrt',
	'This user was classified as disabled.' => 'Benutzerkonto deaktiviert.',
	'This user was classified as pending.' => 'Benutzer auf wartend gesetzt.',
	'This user was locked out.' => 'Benutzerkonto gesperrt',
	'This word or phrase is not used in the password recovery.' => 'Dieser Ausdruck ist nicht Teil des Erinnerungssatzes',
	'User properties' => 'Benutzer-Eigenschaften',
	'Web Services Password' => 'Passwort für Webdienste',
	'You must use half-width character for password.' => 'Bitte verwenden Sie für das Passwort halbbreite Zeichen.',
	'Your web services password is currently' => 'Ihr Passwort für Webdienste lautet derzeit',
	'_USAGE_PASSWORD_RESET' => 'Hier können Sie das Passwort dieses Benutzers zurücksetzen. Dazu wird ein zufälliges neues Passwort erzeugt und an <strong>[_1]</strong> verschickt werden.',
	'_USER_PENDING' => 'Schwebend',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Sie sind dabei, das Passwort von [_1] zurückzusetzen. Dazu wird ein zufällig erzeugtes neues Passwort per E-Mail an [_2] verschickt werden.\n\nForsetzen?',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Um dieses Benutzerkonto zu entsperren, klicken Sie auf 'Entsperren'. <a href="[_1]">Entsperren</a>},
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Die Website dieses Benutzers (z.B. http://movabletype.com/). Ist sowohl dieses als auch das Feld &#8222;Anzeigename&#8220; ausgefüllt, erzeugt Movable Type daraus per Voreinstellung einen Link zur angebenen Website und zeigt diesen unter Einträgen und Kommentaren des Benutzers an.},

## tmpl/cms/edit_blog.tmpl
	'Blog Theme' => 'Blog-Thema',
	'Create Blog (s)' => 'Blog anlegen (s)',
	'Create Blog' => 'Blog anlegen',
	'Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Geben Sie die Web-Adresse (URL) Ihres Blogs ohne Dateinamen (z.B. index.html) ein. Beispiel: http://beispiel.com/blog/',
	'Name your blog. The blog name can be changed at any time.' => 'Geben Sie Ihrem Blog einen Namen. Der Name kann jederzeit geändert werden.',
	'Select the theme you wish to use for this blog.' => 'Wählen Sie das Thema, das Sie für dieses Blog verwenden möchten.',
	'Select your timezone from the pulldown menu.' => 'Zeitzone des Weblogs',
	'You must set your Local Site Path.' => 'Bitte geben Sie den lokalen Pfad der Site an.',
	'Your blog configuration has been saved.' => 'Ihre Blog-Konfiguration wurde gespeichert.',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' or '\' und möglichst in absoluter Form, also am Anfang unter Linux mit '/' oder mit 'C:\' unter Windows. Beispiel: /home/mt/public_html oder C:\www\public_html},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Der Pfad, unter dem die Index-Dateien abgelegt werden sollen, ohne abschließendes '/' oder '\'. Beispiel: /home/mt/public_html/blog oder C:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Kategorie bearbeiten',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Geben Sie die Adressen der Websites ein, an die Sie automatisch einen TrackBack-Ping schicken möchten, wenn ein neuer Eintrag in dieser Kategorie veröffentlicht wurde. Verwenden Sie für jede Adresse eine neue Zeile.',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Wenn die Option aktiv ist, sind Kategorie-TrackBacks aus allen Quellen zugelassen',
	'Inbound TrackBacks' => 'TrackBack-Empfang',
	'Manage entries in this category' => 'Einträge in dieser Kategorie verwalten',
	'Outbound TrackBacks' => 'TrackBack-Versand',
	'Passphrase Protection' => 'Passphrasenschutz',
	'Please enter a valid basename.' => 'Bitte geben Sie einen gültigen Basisnamen ein.',
	'Save changes to this category (s)' => 'Kategorieänderungen speichern (s)',
	'This is the basename assigned to your category.' => 'Der dieser Kategorie zugewiesene Basisname',
	'TrackBack URL for this category' => 'TrackBack-URL für diese Kategorie',
	'Trackback URLs' => 'TrackBack-URLs',
	'View TrackBacks' => 'TrackBacks ansehen',
	'You must specify a basename for the category.' => 'Geben Sie einen Basisnamen für die Kategorie an.',
	'You must specify a label for the category.' => 'Geben Sie einen Namen für die Kategorie an.',
	'_CATEGORY_BASENAME' => 'Basisname',
	'_USAGE_CATEGORY_PING_URL' => 'Das ist die Adresse für TrackBacks für diese Kategorie. Wenn Sie sie öffentlich machen, kann jeder, der in seinem Blog einen für diese Kategorie relevanten Eintrag geschrieben hat, einen TrackBack-Ping senden. Mittels TrackBack-Tags können Sie diese TrackBacks dann auf Ihrer Seite anzeigen. Näheres dazu finden Sie in der Dokumentation.',
	q{Warning: Changing this category's basename may break inbound links.} => q{Achtung: Änderungen des Basisnamens können bestehende externe Links auf diese Kategorieseite ungültig machen},

## tmpl/cms/edit_comment.tmpl
	'(Banned)' => '(gesperrt)',
	'(Pending)' => '(wartet)',
	'(Trusted)' => '(vertraut)',
	'Ban Commenter' => 'Kommentarautor sperren',
	'Date this comment was made' => 'Datum, an dem dieser Kommentar abgegeben wurde',
	'Date' => 'Datum',
	'Delete this comment (x)' => 'Diesen Kommentar löschen (x)',
	'Email address of commenter' => 'E-Mail-Adresse des Kommentarautors',
	'Fulltext of the comment entry' => 'Vollständiger Kommentartext',
	'IP Address of the commenter' => 'IP-Adresse des Kommentarautors',
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
	'The name of the person who posted the comment' => 'Name des Kommentarautors',
	'This comment was classified as spam.' => 'Kommentar als Spam mariert.',
	'Total Feedback Rating: [_1]' => 'Gesamtbewertung: [_1]',
	'Trust Commenter' => 'Kommentarautor vertrauen',
	'Trusted' => 'vertraut',
	'URL of commenter' => 'URL des Kommentarautors',
	'Unavailable for OpenID user' => 'Nicht verfügbar für OpenID-Nutzer',
	'Unban Commenter' => 'Kommentarautor nicht mehr sperren',
	'Untrust Commenter' => 'Kommentarautor nicht mehr vertrauen',
	'Update the status of this comment' => 'Kommentarstatus aktualisieren',
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
	'[_1] this comment was made on' => '[_1] zum Kommentar',
	'_external_link_target' => '_blank',
	'comment' => 'Kommentar',
	'comments' => 'Kommentare',

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => 'Authentifiziert',
	'Ban user (b)' => 'Benutzer sperren (b)',
	'Ban' => 'Sperren',
	'Commenter Details' => 'Kommentarautor-Details',
	'Identity' => 'Identität',
	'The Email Address of the commenter' => 'E-Mail-Adresse des Kommentarautors',
	'The Identity of the commenter' => 'Identität des Kommentarautors',
	'The Name of the commenter' => 'Name des Kommentarautors',
	'The Website URL of the commenter' => 'URL des Kommentarautors',
	'The commenter has been banned.' => 'Dieser Kommentarautor wurde gesperrt.',
	'The commenter has been trusted.' => 'Sie vertrauen diesem Kommentarautoren.',
	'The trusted status of the commenter' => 'Vertrauensstatus des Kommentarautors',
	'Trust user (t)' => 'Benutzer vertrauen (t)',
	'Trust' => 'Vertrauen',
	'Unban user (b)' => 'Benutzer nicht mehr sperren (b)',
	'Unban' => 'Entsperren',
	'Untrust user (t)' => 'Benutzer nicht mehr vertrauen (t)',
	'Untrust' => 'Nicht vertrauen',
	'View all comments with this name' => 'Alle Kommentare mit diesem Autorennamen anzeigen',
	'Withheld' => 'Zurückgehalten',
	'commenter' => 'Kommentarautor',
	'commenters' => 'Kommentarautoren',

## tmpl/cms/edit_entry.tmpl
	'(comma-delimited list)' => '(Liste mit Kommatrennung)',
	'(space-delimited list)' => '(Liste mit Leerzeichentrennung)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Eintrag automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Version wiederherstellen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Seite automatisch gespeichert [_2]. <a href="[_1]">Automatisch gespeicherte Version wiederherstellen</a>',
	'Accept' => 'Annehmen',
	'Add category' => 'Kategorie hinzufügen',
	'Add new category parent' => 'Neue Eltern-Kategorie hinzufügen',
	'Add new folder parent' => 'Neuen Eltern-Ordner hinzufügen',
	'An error occurred while trying to recover your saved entry.' => 'Bei der Wiederherstellung des gespeicherten Eintrags ist ein Fehler aufgetreten.',
	'An error occurred while trying to recover your saved page.' => 'Bei der Wiederherstellung der gespeicherten Seite ist ein Fehler aufgetreten.',
	'Auto-saving...' => 'Autospeichern...',
	'Category Name' => 'Kategoriename',
	'Change Folder' => 'Ordner wechseln',
	'Change note' => 'Änderungshinweis',
	'Converting to rich text may result in changes to your current document.' => 'Wandlung in Rich Text kann ihre bisherigen Formatierungen beeinträchtigen.',
	'Create Page' => 'Seite anlegen',
	'Delete this entry (x)' => 'Eintrag löschen (x)',
	'Delete this page (x)' => 'Seite löschen (x)',
	'Draft this [_1]' => '[_1] als Entwurf speichern',
	'Edit Entry' => 'Eintrag bearbeiten',
	'Edit Page' => 'Seite bearbeiten',
	'Enter the link address:' => 'Link-Adresse eingeben:',
	'Enter the text to link to:' => 'Link-Text eingeben:',
	'Format:' => 'Formatierung:',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Zuletzt automatisch gespeichert um [_1]:[_2]:[_3]',
	'Make primary' => 'Als Hauptkategorie',
	'Manage Entries' => 'Einträge verwalten',
	'No assets' => 'Keine Assets',
	'No revision(s) associated with this [_1]' => 'Keine Revision(en) mit dieser/diesem [_1] verknüpft',
	'None selected' => 'Keine gewählt',
	'Not specified' => 'Nicht angegeben',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Es sind ein oder mehrere Fehler beim Senden von TrackBacks aufgetreten.',
	'Outbound TrackBack URLs' => 'TrackBack- URLs',
	'Permalink:' => 'Permalink:',
	'Preview this entry (v)' => 'Vorschau (v)',
	'Preview this page (v)' => 'Vorschau (v)',
	'Publish On' => 'Veröffentlichen um',
	'Publish this [_1]' => '[_1] veröffentlichen',
	'Remove this asset.' => 'Dieses Asset entfernen',
	'Reset defaults' => 'Auf Standardeinstellungen zurücksetzen',
	'Reset display options to blog defaults' => 'Anzeigeoptionen auf Standardeinstellungen zurücksetzen',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Version wiederherstellen (Datum: [_1]). Aktueller Status: [_2]',
	'Save this [_1]' => '[_1] speichern',
	'Schedule' => 'Zeitplan',
	'Share' => 'Teilen',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltene [_1] können nicht geladen werden, da sie entfernt wurden.',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Einige in der Version enthaltenen Tags können nicht geladen werden, da sie entfernt wurden.',
	'This entry has been saved.' => 'Eintrag gespeichert.',
	'This page has been saved.' => 'Seite gesichert.',
	'This post was classified as spam.' => 'Dieser Eintrag wurde als Spam erfasst.',
	'This post was held for review, due to spam filtering.' => 'Dieser Eintrag wurde vom Spam-Filter zur Moderation zurückgehalten.',
	'Unpublish this [_1]' => '[_1] nicht mehr veröffentlichen',
	'Unpublished (Draft)' => 'Unveröffentlicht (Entwurf)',
	'Unpublished (Review)' => 'Unveröffentlicht (Prüfung)',
	'Unpublished (Spam)' => 'Unveröffentlicht (Spam)',
	'Update this [_1]' => '[_1] aktualisieren',
	'Update' => 'Aktualisieren',
	'View Entry' => 'Eintrag ansehen',
	'View Page' => 'Seite ansehen',
	'View Previously Sent TrackBacks' => 'TrackBacks anzeigen',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Warnung: Wenn Sie den Basisnamen manuell einstellen, ist es nicht auszuschließen, daß der gewählte Name bereits existiert.',
	'You have successfully deleted the checked TrackBack(s).' => 'Die markierten TrackBacks wurden erfolgreich gelöscht.',
	'You have successfully deleted the checked comment(s).' => 'Die markierten Kommentare wurden erfolgreich gelöscht.',
	'You have successfully recovered your saved entry.' => 'Gespeicherten Eintrag erfolgreich wiederhergestellt.',
	'You have successfully recovered your saved page.' => 'Gespeicherte Seite erfolgreich wiederhergestellt.',
	'You have unsaved changes to this entry that will be lost.' => 'Es liegen nicht gespeicherte Eintragsänderungen vor, die verloren gehen werden.',
	'You have unsaved changes to this page that will be lost.' => 'Es liegen nicht gespeicherte Seitenänderungen vor, die verloren gehen werden.',
	'You must configure this blog before you can publish this entry.' => 'Bitte konfigurieren Sie das Blog, bevor Sie einen Eintrag veröffentlichen.',
	'You must configure this blog before you can publish this page.' => 'Bitte konfigurieren Sie das Blog, bevor Sie eine Seite veröffentlichen.',
	'Your changes to the comment have been saved.' => 'Kommentaränderungen gespeichert.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Einstellungen gespeichert.',
	'Your notification has been sent.' => 'Benachrichtigung gesendet.',
	'[_1] - Edited by [_2]' => 'Bearbeitet von [_2] [_1]',
	'[_1] - Published by [_2]' => 'Veröffentlicht von [_2] [_1]',
	'[_1] Assets' => '[_1] Assets',
	'_USAGE_VIEW_LOG' => 'Nähere Informationen zum aufgetretenen Fehler finden Sie im <a href="[_1]">Aktivitätsprotokoll</a>.',
	'edit' => 'Bearbeiten',
	q{(delimited by '[_1]')} => q{(Trennung durch &#8222;[_1]&#8220;)},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Warnung: Wenn Sie den Basisnamen nachträglich ändern, können externe Links zu diesem Eintrag ungültig werden.},

## tmpl/cms/edit_entry_batch.tmpl
	'Published Date' => 'Veröffentlichungs-Datum',
	'Save these [_1] (s)' => 'Diese [_1] speichern (s)',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Ordner bearbeiten',
	'Manage Folders' => 'Ordner verwalten',
	'Manage pages in this folder' => 'Seiten in diesem Ordner verwalten',
	'Path' => 'Pfad',
	'Save changes to this folder (s)' => 'Ordneränderungen speichern (s)',
	'You must specify a label for the folder.' => 'Sie müssen diesem Ordner eine Bezeichnung geben',

## tmpl/cms/edit_ping.tmpl
	'Category no longer exists' => 'Kategorie nicht mehr vorhanden',
	'Delete this TrackBack (x)' => 'Diesen TrackBack löschen (x)',
	'Edit Trackback' => 'TrackBack bearbeiten',
	'Entry no longer exists' => 'Eintrag nicht mehr vorhanden',
	'Excerpt of the TrackBack entry' => 'TrackBack-Auszug',
	'Manage TrackBacks' => 'TrackBacks verwalten',
	'No title' => 'Kein Name',
	'Save changes to this TrackBack (s)' => 'TrackBack-Änderungen speichern (s)',
	'Search for other TrackBacks from this site' => 'Weitere TrackBacks von dieser Site suchen',
	'Search for other TrackBacks with this status' => 'Weitere TrackBacks mit diesem Status suchen',
	'Search for other TrackBacks with this title' => 'Weitere TrackBacks mit diesem Namen suchen',
	'Target Category' => 'Zielkategorie',
	'Target [_1]' => 'Ziel-[_1]',
	'The TrackBack has been approved.' => 'TrackBack wurde freigeschaltet.',
	'This trackback was classified as spam.' => 'TrackBack als Spam markiert.',
	'TrackBack Text' => 'TrackBack-Text',
	'Update the status of this TrackBack' => 'TrackBack-Status aktualisieren',
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
	'Commenting' => 'Kommentieren',
	'Designing' => 'Gestalten',
	'Duplicate Roles' => 'Rollen duplizieren',
	'Edit Role' => 'Rolle bearbeiten',
	'Privileges' => 'Berechtigungen',
	'Role Details' => 'Rolleneigenschaften',
	'Save changes to this role (s)' => 'Rollenänderungen speichern (s)',
	'These roles have the same privileges as this role' => 'Folgende Rollen haben die gleichen Berechtigungen wie diese Rolle',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Sie haben die Berechtigungen dieser Rolle geändert. Dadurch werden auch die Berechtigungen der mit dieser Rolle verknüpften Benutzer beeinflusst. Wenn Sie möchten, können Sie daher die Rolle unter neuem Namen speichern.',

## tmpl/cms/edit_template.tmpl
	': every ' => ': alle ',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'Vorlage <a href="[_1]" class="rebuild-link">veröffentlichen</a>.',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => '[_1] automatisch gespeichert [_3]. <a href="[_2]">Automatisch gespeicherte Version wiederherstellen</a>.',
	'An error occurred while trying to recover your saved [_1].' => 'Bei der Wiederherstellung der gespeicherten Fassung ist ein Fehler aufgetreten.',
	'Archive map has been successfully updated.' => 'Archiv-Verknüpfung erfolgreich aktualisiert.',
	'Are you sure you want to remove this template map?' => 'Archiv-Verknüpfung wirklich löschen?',
	'Create Archive Mapping' => 'Neue Archiv-Verknüpfung einrichten',
	'Create Template' => 'Vorlage anlegen',
	'Create Widget' => 'Widget anlegen',
	'Custom Index Template' => 'Individuelle Indexvorlage',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Deaktiviert (<a href="[_1]">Veröffentlichungsoptionen ändern</a>)',
	'Do Not Publish' => 'Nicht veröffentlichen',
	'Dynamically' => 'Dynamisch',
	'Edit Widget' => 'Widget bearbeiten',
	'Enabled Mappings: [_1]' => 'Aktivierte Verknüpfungen: [_1]',
	'Error occurred while updating archive maps.' => 'Bei der Aktualisierung der Archiv-Verknüpfungen ist ein Fehler aufgetreten.',
	'Expire after' => 'Verfallen lassen nach',
	'Expire upon creation or modification of:' => 'Verfallen lassen bei Anlage oder Änderung von:',
	'Include cache path' => 'Include Cache-Pfad',
	'Included Templates' => 'Eingebundene Vorlagen',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">Mehr über Veröffentlichungs-Einstellungen erfahren</a>',
	'Link to File' => 'Mit Datei verlinken',
	'List [_1] templates' => 'Zeige [_1]-Vorlagen',
	'List all templates' => 'Zeige alle Vorlagen',
	'Manually' => 'Manuell',
	'Module Body' => 'Modul-Code',
	'Module Option Settings' => 'Moduloption-Einstellungen',
	'No caching' => 'Keine Caching',
	'No revision(s) associated with this template' => 'Keine Revision(en) mit dieser Vorlage verknüpft',
	'On a schedule' => 'Zeitgeplant',
	'Output file: <strong>[_1]</strong>' => 'Ausgabedatei: <strong>[_1]</strong>',
	'Process as <strong>[_1]</strong> include' => 'Als <strong>[_1]</strong>-Include verarbeiten',
	'Processing request...' => 'Verarbeite Anfrage...',
	'Restored revision (Date:[_1]).' => 'Revision wiederhergestellt (Datum: [_1])',
	'Save &amp; Publish' => 'Speichern und veröffentlichen',
	'Save Changes (s)' => 'Änderungen speichern (s)',
	'Save and Publish this template (r)' => 'Vorlage speichern und veröffentlichen (r)',
	'Server Side Include' => 'Server Side Include',
	'Statically (default)' => 'Statisch (Standard)',
	'Syntax highlighting Off' => 'Syntax-Highlighting aus',
	'Syntax highlighting On' => 'Syntax-Highlighting an',
	'Template Body' => 'Vorlagen-Code',
	'Template Options' => 'Vorlagenoptionen',
	'Template Tag Docs' => 'Dokumentation der Vorlagenbefehle',
	'Template Type' => 'Vorlagen-Typ',
	'Unrecognized Tags' => 'Nicht erkannte Befehle',
	'Useful Links' => 'Nützliche Links',
	'Via Publish Queue' => 'Im Hintergrund',
	'View Published Template' => 'Veröffentlichte Vorlage ansehen',
	'View revisions of this template' => 'Revisionen dieser Vorlage anzeigen',
	'You have successfully recovered your saved [_1].' => 'Gespeicherte Fassung erfolgreich wiederhergestellt.',
	'You have unsaved changes to this template that will be lost.' => 'Es liegen nicht gespeicherte Vorlagenänderungen, die verloren gehen werden.',
	'You must set the Template Name.' => 'Bitte geben Sie einen Vorlagennamen ein.',
	'You must set the template Output File.' => 'Bitte geben Sie Namen für die Ausgabedatei ein.',
	'Your [_1] has been published.' => '[_1] wurde veröffentlicht.',
	'create' => 'anlegen',
	'hours' => 'Stunden',
	'minutes' => 'Minuten',

## tmpl/cms/edit_website.tmpl
	'Create Website (s)' => 'Website anlegen (s)',
	'Create Website' => 'Website anlegen',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Geben Sie die gewünschte Adresse (URL) Ihrere Website ohne Dateinamen ein, z.B. http://beispiel.de/',
	'Name your website. The website name can be changed at any time.' => 'Wählen Sie einen Namen für Ihre Website. Sie können den Name auch später noch jederzeit ändern.',
	'Please enter a valid URL.' => 'Bitte geben Sie eine gültige Adresse ein.',
	'Please enter a valid site path.' => 'Bitte geben Sie einen gültigen Site-Pfad ein.',
	'Select the theme you wish to use for this website.' => 'Wählen Sie das Thema, das Sie für diese Website verwenden möchten.',
	'This field is required.' => 'Feld erforderlich.',
	'Website Theme' => 'Website-Thema',
	'You did not select a timezone.' => 'Bitte wählen Sie einen Zeitzone',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Geben Sie den Pfad an, unter dem die Startseiten-Datei abgelegt werden soll. Optimal ist eine Angabe in absoluter Form, also unter Linux mit '/' oder unter Windows mit 'C:\' am Anfang, aber eine relative Angabe ist auch möglich. Beispiel: /home/melody/public_html/ oder C:\www\public_htm},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => 'Verfügbare Widgets',
	'Create Widget Set' => 'Widgetgruppe anlegen',
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
	'A description for this theme.' => 'Eine Beschreibung dieses Themas',
	'A version number for this theme.' => 'Die Versionsnummer dieses Themas.',
	'Additional assets to be included in the theme.' => 'Zu diesem Thema gehörende Assets',
	'Author link' => 'Autoren-Link',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Basisnamen müssen mit einem Buchstaben anfangen und dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Destination' => 'Ziel',
	'Export [_1] Themes' => '[_1]-Themen exportieren',
	'Select How to get theme.' => 'Bezugsmethode wählen',
	'Setting for [_1]' => 'Einstellungen für [_1]',
	'The author of this theme.' => 'Der Name des Autors dieses Themas',
	'The name of your theme.' => 'Der Name Ihres Themas',
	'Theme package have been saved.' => 'Themenpaket gespeichert.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Versionsnamen dürfen nur Buchstaben, Zahlen, Binde- und Unterstriche enthalten.',
	'Version' => 'Version',
	'You must set Theme Name.' => 'Bitte geben Sie einen Namen für das Thema ein.',
	'_THEME_AUTHOR' => 'Autor',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Das Thema kann nicht mit diesem Basisnamen installiert, da dieser bereits vorhanden und geschützt ist.},
	q{The author's website.} => q{Die Website des Autors.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Verwenden Sie bitte nur Buchstaben, Zahlen, Bindestriche oder Unterstriche (a-z, A-Z, 0-9, &#8222;-&#8220; oder &#8222;_&#8220;).},

## tmpl/cms/import.tmpl
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Apply this formatting if text format is not set on each entry.' => 'Diese Formatierung verwenden wenn Format nicht in jedem Eintrag einzeln angegeben',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Type versucht automatisch die korrekte Zeichenkodierung auszuwählen. Sollte das fehlschlagen, können Sie sie auch explizit angeben.',
	'Default category for entries (optional)' => 'Standard-Kategorie für Einträge (optional)',
	'Default password for new users:' => 'Standard-Passwort für neue Benutzer:',
	'Enter a default password for new users.' => 'Geben Sie ein Standard-Passwort für neue Benutzer ein.',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Wenn Sie mit ursprünglichen Benutzernamen importieren und einer oder mehrere der Benutzer in dieser Movable Type-Installation noch kein Konto haben, werden entsprechende Benutzerkonten automatisch angelegt. Für diese Konten müssen Sie ein Standardpasswort vergeben.',
	'Import Entries (s)' => 'Einträge importieren (s)',
	'Import File Encoding' => 'Zeichenkodierung der Importdatei',
	'Import [_1] Entries' => '[_1] Einträge importieren',
	'Import as me' => 'Einträge unter meinem Namen importieren',
	'Importing from' => 'Importieren aus',
	'Ownership of imported entries' => 'Besitzer importierter Einträge',
	'Preserve original user' => 'Einträge unter ursprünglichen Namen importieren',
	'Select a category' => 'Kategorie auswählen...',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Mit der Import/Export-Funktion können Sie Einträge aus anderen Movable Type-Installationen oder aus anderen Weblog-Systemen übernehmen. Bestehende Einträge können in einem Austauschformat gesichert werden.',
	'Upload import file (optional)' => 'Import-Datei hochladen (optional)',
	'You can specify a default category for imported entries which have none assigned.' => 'Standardkdategorie für importierte Einträge ohne Kategorie',
	'You must select a blog to import.' => 'Wählen Sie, in welches Blog importiert werden soll',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Alle importierten Einträge werden Ihnen zugewiesen werden. Wenn Sie möchten, daß die Einträge ihren ursprünglichen Benutzern zugewiesen bleiben, lassen Sie den Import von Ihren Administrator durchführen. Dann werden etwaige erforderliche, aber noch fehlende Benutzerkonten automatisch angelegt.',
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{Wenn Sie eine auf Ihrem Computer gespeicherte Importdatei verwenden wollen, laden Sie diese hier hoch. Alternativ verwendet Movable Type automatisch die Importdatei, die es im &#8222;import&#8220;-Unterordner Ihres Movable Type-Verzeichnis findet.},

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => 'Standard-Eintragsstatus (optional)',
	'End title HTML (optional)' => 'HTML-Code am Überschriftenende (optional)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Wenn Sie aus einem Weblog-System importieren, das kein eigenes Feld für Überschriften hat, können Sie hier angeben, welche HTML-Ausdrücke den Anfang und das Ende von Überschriften markieren.',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Wenn Sie aus einem Weblog-System importieren, das in seiner Exportdatei den Eintragsstatus nicht vermerkt, können Sie hier angeben, welcher Status den importierten Einträgen zugewiesen werden soll.',
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
	'Italic' => 'Kursiv',
	'Left Align Item' => 'Linksbündig',
	'Left Align Text' => 'Linksbündiger Text',
	'Numbered List' => 'Nummerierte Liste',
	'Right Align Item' => 'Rechtsbündig',
	'Right Align Text' => 'Rechtsbündiger Text',
	'Text Color' => 'Textfarbe',
	'Underline' => 'Unterstreichen',
	'WYSIWYG Mode' => 'Grafischer Editor',

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'Nein',
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Eine Datei namens &#8222;[_1]&#8220; ist bereits vorhanden. Möchten Sie sie überschreiben?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'Asset fehlt',
	'Delete selected assets (x)' => 'Gewählte Assets löschen (x)',
	'No thumbnail image' => 'Kein Vorschaubild',

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
	'[_1] - [_2] of [_3]' => '[_1]-[_2] von [_3]',
	'label' => 'Bezeichnung',

## tmpl/cms/include/async_asset_upload.tmpl
	'Cancelled: [_1]' => 'Abgebrochen: [_1]',
	'Choose file to upload or drag file.' => 'Hochzuladende Datei hierher ziehen oder Datei auswählen.',
	'Choose files to upload or drag files.' => 'Hochzuladende Dateien hierher ziehen oder Dateien auswählen.',
	'Drag and drop here' => 'Hierhin ziehen und ablegen',
	'Operation for a file exists' => 'Vorgang bei bereits vorhandenen Dateien',
	'The file you tried to upload is too large: [_1]' => 'Die gewählte Datei ist zu groß: [_1]',
	'Upload Options' => 'Hochlade-Optionen',
	'Upload new asset' => 'Neues Asset hochladen',
	'Upload new image' => 'Neues Bild hochladen',
	'[_1] is not a valid [_2] file.' => '[_1] ist keine gültige [_2]-Datei',

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => 'Gewählte Benutzerkonten deaktivieren (d)',
	'Enable selected users (e)' => 'Gewählte Benutzerkonten aktivieren (e)',
	'_NO_SUPERUSER_DISABLE' => 'Sie können Ihr eigenes Benutzerkonto nicht deaktivieren, da Sie Verwalter dieser Movable Type-Installation sind.',
	'user' => 'Benutzer',
	'users' => 'Benutzer',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Alle Daten wurden erfolgreich gesichert!',
	'Backup Files' => 'Backup-Dateien',
	'Download This File' => 'Diese Datei herunterladen',
	'Download: [_1]' => 'Herunterladen: [_1]',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'Der Download der Sicherungsdatei wird in einigen Sekunden automatisch beginnen. Sollte das nicht der Fall sein, klicken Sie <a href="javascript:(void)" onclick="submit_form()">hier</a> um den Download manuell zu starten. Pro Sitzung kann eine Sicherungsdatei nur einmal heruntergeladen werden.',
	'_BACKUP_TEMPDIR_WARNING' => 'Gewünschte Daten erfolgreich im Ordner [_1] gesichert. Bitte laden Sie die angegebenen Dateien <strong>sofort</strong> aus [_1] herunter und <strong>löschen</strong> Sie sie unmittelbar danach aus dem Ordner, da sie sensible Informationen enthalten.',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Erstelle Sicherung',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'[_1] and [_2]' => '[_1] und [_2]',
	'_FILTER_DATE_DAYS' => '[_1] Tage',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'__INTEGER_FILTER_EQUAL' => 'ist',
	'__INTEGER_FILTER_NOT_EQUAL' => 'ist nicht',
	'__STRING_FILTER_EQUAL' => 'ist',
	'contains' => 'enthält',
	'does not contain' => 'enthält nicht',
	'ends with' => 'endet auf',
	'is after now' => 'ist nach jetzt',
	'is after' => 'ist nach',
	'is before now' => 'ist vor jetzt',
	'is before' => 'ist vor',
	'is between' => 'ist zwischen',
	'is greater than or equal to' => 'ist größer als oder gleich',
	'is greater than' => 'ist größer als',
	'is less than or equal to' => 'ist kleiner als oder gleich',
	'is less than' => 'ist kleiner als',
	'is within the last' => 'ist in den letzten',
	'starts with' => 'beginnt mit',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Markierte [_1] löschen (x)',
	'Some templates were not refreshed.' => 'Einige Vorlagen wurden nicht zurückgesetzt.',
	'[_1] Name' => '[_1] Name',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Unterkategorie hinzufügen',
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

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Alle Rechte vorbehalten.',

## tmpl/cms/include/display_options.tmpl
	'Compact' => 'Kompakt',
	'Display Options' => 'Anzeigeoptionen',
	'Expanded' => 'Erweitert',
	'Save display options' => 'Anzeigeoptionen speichern',
	'[quant,_1,row,rows]' => '[quant,_1,Zeile,Zeilen]',

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]">Create an entry</a> now.' => 'Jetzt <a href="[_1]">einen Eintrag schreiben</a>.',
	'Created' => 'Angelegt',
	'Last Modified' => 'Zuletzt geändert',
	'No entries could be found.' => 'Keine Einträge gefunden.',
	'No pages could be found. <a href="[_1]">Create a page</a> now.' => 'Keine Seiten gefunden. Jetzt <a href="[_1]">eine Seite anlegen</a>.',
	'Republish selected [_1] (r)' => 'Gewählte [_1] erneut veröffentlchen (r)',
	'View entry' => 'Eintrag ansehen',
	'View page' => 'Seite ansehen',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Passwort für Webdienste wählen',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> Version [_2]',
	'Forums' => 'Foren',
	'MovableType.org' => 'MovableType.org',
	'Send Us Feedback' => 'Feedback senden',
	'Support' => 'Support',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Das ist eine Beta-Version von Movable Type. Der Einsatz als Produktivsystem wird nicht empfohlen.',
	'Wiki' => 'Wiki',
	'Your Dashboard' => 'Ihre Übersichtsseite',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'with' => 'mit',
	q{_LOCALE_CALENDAR_HEADER_} => q{'So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'},

## tmpl/cms/include/header.tmpl
	'Help' => 'Hilfe',
	'Search (q)' => 'Suche (q)',
	'Select an action' => 'Aktion wählen',
	'View Site' => 'Ansehen',
	'You have <strong>[quant,_1,message,messages]</strong> from the system.' => 'Sie haben <strong>[quant,_1,Nachricht,Nachrichten]</strong> vom System.',
	'from Revision History' => 'aus der Revisionshistorie',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Diese Website wurde bei der Aktualisierung der Movable Type-Installation automatisch angelegt. Wurzelverzeichnis und Adresse wurden nicht dabei festgelegt, damit die Pfade der mit früheren Movable-Type-Versionen erstellten Blogs gültig bleiben. Sie können in den vorhandenen Blogs wie gewohnt Einträge veröffentlichen, nicht aber die Website selbst veröffentlichen, solange die genannten Felder noch leer sind.},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Veröffentlichen Sie Ihre Site</a>, um die Änderungen wirksam werden zu lassen.',
	'All data imported successfully!' => 'Alle Daten erfolgreich importiert!',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => 'Lege Benutzerkonten für jeden Benutzer des [_1] an...',
	'Importing entries into [_1]' => 'Importiere Einträge...',
	'Importing...' => 'Importieren...',
	q{Importing entries as user '[_1]'} => q{Importiere Einträge als Benutzer &#8222;[_1]&#8220;...},

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Weitere Aktionen...',
	'Plugin Actions' => 'Plugin-Aktionen',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => 'Berechtigungen verwalten',
	'Users for [_1]' => 'Benutzer für [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => 'Gehe zu [_1]',
	'OK (s)' => 'OK (s)',
	'Sorry, there is no data for this object set.' => 'Keine Daten für diese Objekte vorhanden.',
	'Sorry, there were no results for your search. Please try searching again.' => 'Keine Treffer. Bitte suchen Sie erneut.',
	'Step [_1] of [_2]' => 'Schritt [_1] von [_2]',

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP: [_1]',
	'No log records could be found.' => 'Keine Protokolleinträge gefunden.',
	'_LOG_TABLE_BY' => 'Von',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Die [_1] gewählten wirklich aus dieser [_2] entfernen?',
	'Are you sure you want to remove the selected user from this [_1]?' => 'Die gewählten Benutzerkonten wirklich aus [_1] entfernen?',
	'Remove selected user(s) (r)' => 'Gewählte(n) Benutzer entfernen (r)',
	'Remove this role' => 'Rolle entfernen',
	'Trusted commenter' => 'Vertrauter Kommentarautor',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Hinzugefügt am',
	'Save changes' => 'Änderungen speichern',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'TrackBack bearbeiten',
	'Go to the source entry of this TrackBack' => 'Eintrag, auf den sich das TrackBack bezieht, aufrufen',
	'Publish selected [_1] (p)' => 'Markierte [_1] veröffentlichen (p)',
	'View the [_1] for this TrackBack' => '[_1] zu diesem TrackBack ansehen',

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
	'Select another blog...' => 'Anderes Blog wählen',
	'Select another website...' => 'Andere Website wählen...',
	'User Dashboard' => 'Benutzer-Übersichtsseite',

## tmpl/cms/include/template_table.tmpl
	'Archive Path' => 'Archivpfad',
	'Cached' => 'Gecacht',
	'Create Archive Template:' => 'Archiv-Vorlage anlegen:',
	'Create index template' => 'Indexvorlage anlegen',
	'Create template module' => 'Vorlagenmodul anlegen',
	'Dynamic' => 'Dynamisch',
	'Linked Template' => 'Verlinkte Vorlage',
	'Manual' => 'Manuell',
	'Publish Queue' => 'Im Hintergrund',
	'Publish selected templates (a)' => 'Gewählte Vorlagen veröffentlichen (a)',
	'SSI' => 'SSI',
	'Static' => 'Statisch',
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
	'Enter your LDAP password.' => 'Geben Sie Ihr LDAP-Passwort ein.',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Legen Sie nun ein Administratoren-Konto für Ihr System an. Movable Type wird daraufhin Ihre Datenbank initialisieren.',
	'Select a password for your account.' => 'Passwort dieses Benutzerkontos',
	'System Email' => 'System- E-Mail-Adresse',
	'The display name is required.' => 'Anzeigename erforderlich',
	'The e-mail address is required.' => 'Bitte geben Sie Ihre E-Mail-Adresse an.',
	'The initial account name is required.' => 'Benutzername erforderlich',
	'The name used by this user to login.' => 'Anmeldename dieses Benutzerkontos',
	'The name used when published.' => 'Anzeigename (für Veröffentlichung)',
	'The user&rsquo;s email address.' => 'E-Mail-Adresse dieses Benutzers',
	'The user&rsquo;s preferred language.' => 'Gewünschte Spracheinstellung',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Die vorhandene Perl-Version ([_1]) ist nicht aktuell genug ([_2] oder höher erforderlich).',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Um fortfahren zu können, müssen Sie sich gegenüber Ihrem LDAP-Server authentifizieren',
	'Use this as system email address' => 'Diese Adresse als System-E-Mail-Adresse verwenden',
	'View MT-Check (x)' => 'MT-Check anzeigen (x)',
	'Welcome to Movable Type' => 'Willkommen zu Movable Type',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Wir empfehlen dringend, die Perl-Installation mindestens auf Version [_1] zu aktualisieren. Movable Type läuft zwar möglicherweise auch mit der vorhandenen Perl-Version, es handelt sich aber um eine <strong>nicht getestete und nicht unterstützte Umgebung</strong>.',
	'Your LDAP username.' => 'Ihr LDAP-Benutzername.',

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
	'Manage [_1]' => '[_1] verwalten',
	'Rename' => 'Umbenennen',
	'Top Level' => 'Hauptebene',
	'[_1] label' => 'Bezeichnung',
	q{[_1] '[_2]' already exists.} => q{[_1] &#8222;[_2]&#8220; bereits vorhanden.},

## tmpl/cms/list_common.tmpl
	'100 rows' => '100 Zeilen',
	'200 rows' => '200 Zeilen',
	'25 rows' => '25 Zeilen',
	'50 rows' => '50 Zeilen',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'All [_1] items are selected' => 'Alle [_1] Elemente ausgewählt',
	'Built in Filters' => 'Eingebaute Filter',
	'Column' => 'Spalte',
	'Communication Error (HTTP status code: [_1]. Message: [_2])' => 'Kommunikationsfehler (HTTP-Fehler [_1]: [_2])',
	'Filter Label' => 'Filter-Bezeichnung',
	'Filter:' => 'Filter:',
	'Label "[_1]" is already in use.' => 'Bezeichnung "[_1]" bereits vorhanden.',
	'My Filters' => 'Meine Filter',
	'Remove Filter' => 'Aufheben',
	'Remove item' => 'Element entfernen',
	'Save As Filter' => 'Als Filter speichern',
	'Save As' => 'Speichern als',
	'Save Filter' => 'Filter speichern',
	'Select Filter Item...' => 'Filterelement wählen...',
	'Select Filter' => 'Filter wählen',
	'Select Filter...' => 'Filter wählen...',
	'Select all [_1] items' => 'Alle [_1] Elemente auswählen',
	'Unknown Filter' => 'Unbekannter Filter',
	'[_1] - Filter [_2]' => '[_1]-Filter [_2]',
	'[_1] Filter Items have errors' => '[_1] Filterelemente fehlerhaft',
	'act upon' => 'reagieren',
	q{Are you sure you want to remove the filter '[_1]'?} => q{Filter &#8222;[_1]&#8220; wirklich entfernen?},

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Eintragsfeed',
	'Pages Feed' => 'Seitenfeed',
	'Quickfilters' => 'Schnellfilter',
	'Recent Users...' => 'Aktuelle Benutzer...',
	'Remove filter' => 'aufheben',
	'Select A User:' => 'Benutzerkonto wählen: ',
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
	'Manage Global Templates' => 'Gobale Vorlagen verwalten',
	'Manage [_1] Templates' => '[_1]-Vorlagen verwalten',
	'Publishing Settings' => 'Veröffentlichungs-Einstellungen',
	'Selected template(s) has been copied.' => 'Die gewählte(n) Vorlage(n) wurden kopiert.',
	'Show All Templates' => 'Alle Vorlagen anzeigen',
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
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Teile dieses Themas können nicht auf die Website angewendet werden. [_1] Elemente werden übersprungen.',
	'Reapply' => 'Erneut anwenden',
	'Theme Errors' => 'Themen-Fehler',
	'Theme Information' => 'Themen-Infos',
	'Theme Warnings' => 'Themen-Warnungen',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] angewendet (<a href="[_2]">[quant,_3,Warnung,Warnungen]</a>). ',
	'Theme [_1] has been applied.' => 'Thema [_1] angewendet.',
	'Theme [_1] has been uninstalled.' => 'Thema [_1] deinstalliert.',
	'Themes in Use' => 'Verwendete Themen',
	'This theme cannot be applied to the website due to [_1] errors' => 'Dieses Thema kann wegen [_1]Fehlern nicht auf die Website angewendet werden.',
	'Uninstall' => 'Deinstallieren',
	'Warnings' => 'Warnungen',
	'[_1] Themes' => '[_1]-Themen',
	'[quant,_1,warning,warnings]' => '[quant,_1,Warnung,Warnungen]',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',

## tmpl/cms/list_widget.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Name der Widgetgruppe&quot;$&gt;</strong>',
	'Create widget template' => 'Widgetvorlage anlegen',
	'Delete selected Widget Sets (x)' => 'Gewählte Widget-Gruppen löschen (x)',
	'Helpful Tips' => 'Nützliche Hinweise',
	'Manage Global Widgets' => 'Globale Widgets verwalten',
	'Manage [_1] Widgets' => '[_1]-Widgets verwalten',
	'No widget sets could be found.' => 'Keine Widgetgruppen gefunden.',
	'To add a widget set to your templates, use the following syntax:' => 'Um eine Widgetgruppe in eine Vorlage einzubinden, verwenden Sie folgenden Code:',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Widget-Gruppe(n) erfolgreich gelöscht.',
	'Your changes to the widget set have been saved.' => 'Änderungen gespeichert.',

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
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]'>activity log</a> for more details.} => q{Einige ([_1]) der gewählten Benutzerkonten konnten nicht reaktiviert werden, da sie ungültige Parameter enthalten. Nähere Informationen finden Sie im <a href='[_2]'>Aktivitätsprotokoll</a>.},
	q{You have successfully synchronized users' information with the external directory.} => q{Benutzerinformationen erfolgreich mit externem Verzeichnis synchronisiert.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => 'Ungültige IP-Adresse.',
	'You have added [_1] to your list of banned IP addresses.' => 'Sie haben [_1] zur Liste mit gesperrten IP-Adressen hinzugefügt.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Sie haben die gewählten IP-Adressen erfolgreich aus der Liste entfernt.',

## tmpl/cms/listing/blog_list_header.tmpl
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Wichtig: Bereits hochgeladene Assets müssen manuell in das neue Verzeichnis übertragen werden. Um sicher zu gehen, daß dadurch keine Veweise ungültig werden, belassen Sie danach die Originaldateien an ihrem ursprünglichen Ort.',
	'You have successfully deleted the blog from the website. The files still exist in the site path. Please delete files if not needed.' => 'Das Blog wurde erfolgreich aus der Website gelöscht. Die zugehörigen Dateien sind weiterhin vorhanden. Bitte löschen Sie sie, falls sie nicht mehr benötigt werden.',
	'You have successfully deleted the website from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Die Website wurde erfolgreich aus Movable Type gelöscht. Die zugehörigen Dateien sind weiterhin vorhanden. Bitte löschen Sie sie, falls sie nicht mehr benötigt werden.',
	'You have successfully moved selected blogs to another website.' => 'Blogs erfolgreich in andere Website verschoben.',

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'Alle als Spam markierten Kommentare wurden entfernt.',
	'No comments appear to be spam.' => 'Scheinbar ist kein Kommentar Spam.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Nicht authentifizierten Kommentarautoren können weder gesperrt werden noch das Vertrauen ausgesprochen bekommen.',
	'The selected comment(s) has been approved.' => 'Die gewählten Kommentare wurden freigeschaltet.',
	'The selected comment(s) has been deleted from the database.' => 'Die gewählten Kommentar(e) wurden aus der Datenbank gelöscht.',
	'The selected comment(s) has been recovered from spam.' => 'Die gewählten Kommentare wurden aus dem Spam wiederhergestellt',
	'The selected comment(s) has been reported as spam.' => 'Die gewählten Kommentare wurden als Spam gemeldet',
	'The selected comment(s) has been unapproved.' => 'Die gewählten Kommentare sind nicht mehr freigeschaltet',

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => 'Alle Zeiten in GMT',
	'All times are displayed in GMT[_1].' => 'Alle Zeiten in GMT[_1]',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added [_1] to your address book.' => '[_1] zum Adressbuch hinzugefügt.',
	'You have successfully deleted the selected contacts from your address book.' => 'Gewählte Kontakte erfolgreich aus dem Adressbuch gelöscht.',

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
	'Sign In (s)' => 'Anmelden (s)',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Unten können Sie sich erneut anmelden.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ihre Movable Type-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an, um den Vorgang fortzusetzen.',
	'Your Movable Type session has ended.' => 'Ihre Movable Type-Sitzung ist abgelaufen oder Sie haben sich abgemeldet.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Sende Pings...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'Fehlgeschlagene TrackBacks',
	'Successful Trackbacks' => 'Erfolgreiche TrackBacks',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Kopieren Sie diese Adressen im Eintragseditor in das Formularfeld für die zu verschickenden TrackBacks, um es erneut zu versuchen.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Alle Dateien',
	'Index Template: [_1]' => 'Index-Vorlagen: [_1]',
	'Only Indexes' => 'Nur Indizes',
	'Only [_1] Archives' => 'Nur Archiv: [_1]',
	'Publish <em>[_1]</em>' => '<em>[_1]</em> veröffentlichen',
	'Publish [_1]' => 'Veröffentliche [_1]',
	'_REBUILD_PUBLISH' => 'Veröffentlichen',

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => 'Erneut veröffentlichen (s)',
	'Publish Again' => 'Erneut veröffentlichen',
	'Publish time: [_1].' => 'Dauer: [_1]',
	'The files for [_1] have been published.' => 'Dateien für [_1] veröffentlicht.',
	'View this page.' => 'Seite ansehen',
	'View your site.' => 'Site ansehen',
	'Your [_1] archives have been published.' => '[_1]-Archiv veröffentlicht.',
	'Your [_1] templates have been published.' => '[_1]-Vorlagen veröffentlicht.',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1] Content' => 'Vorschau auf [_1]',
	'Re-Edit this entry (e)' => 'Eintrag erneut bearbeiten (e)',
	'Re-Edit this entry' => 'Eintrag erneut bearbeiten',
	'Re-Edit this page (e)' => 'Seite erneut bearbeiten (e)',
	'Re-Edit this page' => 'Seite erneut bearbeiten',
	'Return to the compose screen (e)' => 'Zurück zur Eingabe (e)',
	'Return to the compose screen' => 'Zurück zur Eingabe',
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
	'Template Refresh' => 'Vorlagen zurücksetzen',

## tmpl/cms/restore.tmpl
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Vorhandene globale Vorlagen mit globalen Vorlagen aus der Sicherungsdatei überschreiben',
	'Backup File' => 'Sicherungsdatei',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Anwählen, um auch Dateien mit einer neueren Schemaversionen wiederherstellen zu können. HINWEIS: Nichtbeachtung der Schemaverion kann Ihre Movable Type-Installation dauerhaft beschädigen.',
	'Ignore schema version conflicts' => 'Versionskonflikte ignorieren',
	'Overwrite global templates.' => 'Globale Vorlagen überschreiben',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'XML::SAX und/oder Abhängigkeiten dieses Perl-Moduls fehlen. Ohne diese Module kann Movable Type das System nicht wiederherstellen.',
	'Restore (r)' => 'Wiederherstellen (r)',
	'Restore from a Backup' => 'System aus Sicherheitskopie wiederherstellen',
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{Befindet sich die Sicherungsdatei nicht auf dem Server, können Sie sie hier hochladen. Andersfalls prüft Movable Type automatisch das Verzeichnis &#8222;import&#8220; Ihrer Movable Type-Installation auf gültige Sicherungsdateien. },

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Movable Type wiederherstellen',

## tmpl/cms/search_replace.tmpl
	'Case Sensitive' => 'Groß/Kleinschreibung beachten',
	'Date Range' => 'Zeitraum eingrenzen',
	'Limited Fields' => 'Felder eingrenzen',
	'Regex Match' => 'Reguläre Ausdrücke verwenden',
	'Replace Checked' => 'Gewählte ersetzen',
	'Replace With' => 'Ersetzen durch',
	'Reported as Spam?' => 'Als Spam gemeldet?',
	'Search Again' => 'Erneut suchen',
	'Search For' => 'Suchen nach',
	'Show all matches' => 'Zeige alle Treffer',
	'Showing first [_1] results.' => 'Zeige die ersten [_1] Treffer.',
	'Submit search (s)' => 'Suchen (s)',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,Element,Elemente] erfolgreich ersetzt.',
	'You must select one or more item to replace.' => 'Wählen Sie mindestens ein Element aus, das ersetzt werden soll.',
	'[quant,_1,result,results] found' => '[quant,_1,Treffer,Treffer] gefunden',
	'_DATE_FROM' => 'Von',
	'_DATE_TO' => 'Bis',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Erstellen Sie Ihre erste Website',
	'Finish install (s)' => 'Installation abschließen (s)',
	'Finish install' => 'Installation abschließen',
	'My First Website' => 'Meine erste Website',
	'Select the theme you wish to use for this new website.' => 'Wählen Sie das Thema, das Sie für die neue Website verwenden möchten.',
	'Support directory does not exists or not writable by the web server. Change the ownership or permissions on this directory' => 'Das Support-Verzeichnis fehlt oder kann vom Server nicht beschrieben werden. Bitte vergeben Sie entsprechende Zugriffsrechte.',
	'The publishing path is required.' => 'Pfadangabe erforderlich.',
	'The timezone is required.' => 'Zeitzone erforderlich.',
	'The website URL is required.' => 'Bitte geben Sie die gewünschte URL der Website ein.',
	'The website name is required.' => 'Bitte geben Sie den gewünschten Namen der Website ein.',
	'Your website URL is not valid.' => 'Die angegebene URL ist nicht gültig.',
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{Geben Sie die gewünschte URL und den gewünschten Pfad im Dateisystem Ihres Servers an, unter denen Movable Type Ihre Website veröffentlichen soll.},
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{Das Wurzelverzeichnis der Website ist das Verzeichnis auf Ihrem Webserver, in dem Movable Type die Dateien Ihrer Website ablegt. Der Webserver muss daher über Schreibrechte für dieses Verzeichnis verfügen.},

## tmpl/cms/system_check.tmpl
	'Memcache Server is [_1].' => 'Der Memcache-Server ist [_1].',
	'Memcache Status' => 'Memcache-Status',
	'Memcache is [_1].' => 'Memcache ist [_1].',
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

## tmpl/cms/widget/blog_stats.tmpl
	'April' => 'April',
	'Aug.' => 'August',
	'Dec.' => 'Dezember',
	'Error retrieving recent entries.' => 'Fehler beim Einlesen der aktuellen Einträge.',
	'Feb.' => 'Februar',
	'Jan.' => 'Januar',
	'July.' => 'Juli',
	'June' => 'Juni',
	'Loading recent entries...' => 'Lade aktuelle Einträge...',
	'March' => 'März',
	'May' => 'Mai',
	'Nov.' => 'November',
	'Oct.' => 'Oktober',
	'Sept.' => 'September',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	q{You have <a href='[_3]'>[quant,_1,comment,comments] from [_2]</a>} => q{Sie haben <a href='[_3]'>[quant,_1,Kommentar,Kommentare] von [_2]</a>},
	q{You have <a href='[_3]'>[quant,_1,entry,entries] from [_2]</a>} => q{Sie haben <a href='[_3]'>[quant,_1,Eintrag,Einträge] von [_2]</a>},

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Aktuelle Kommentare',
	'No comments available.' => 'Keine Kommentare vorhanden.',
	'View all comments' => 'Alle Kommentare',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] zu [_4]',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Aktuelle Einträge',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'In diesem Blog wurden noch keine Einträge angelegt. <a href="[_1]">Jetzt Eintrag anlegen</a>',
	'View all entries' => 'Alle Einträge',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,Eintrag,Einträge] getaggt mit &#8222;[_2]&#8221;',

## tmpl/cms/widget/custom_message.tmpl
	'Change this message.' => 'Diese Nachricht ändern.',
	'Edit this message.' => 'Diese Nachricht bearbeiten.',
	'If you need assistance, try:' => 'Falls Sie Hilfe benötigen, stehen folgende Möglichkeiten zur Verfügung:',
	'Movable Type Community Forums' => 'Movable Type Community-Foren',
	'Movable Type Technical Support' => 'Movable Type Technischer Support',
	'Movable Type User Manual' => 'Movable Type Benutzerhandbuch',
	'This is you' => 'Das sind Sie',
	'Welcome to [_1].' => 'Willkommen zu [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Sie können Ihr Blog vom links befindlichen Menü aus verwalten.',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Create a new' => 'Neu anlegen',
	'No blogs could be found.' => 'Keine Blogs gefunden.',
	'No website could be found. [_1]' => 'Keine Website gefunden. [_1]',
	'Your recent websites and blogs' => 'Ihre aktuellen Websites und Blogs',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Neues',
	'No Movable Type news available.' => 'Es liegen keine Movable Type-Nachrichten vor.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Blog Preferences' => 'Blog-Einstellungen',
	'Handy Shortcuts' => 'Schnellzugriff',
	'Import Content' => 'Importieren',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Nachricht vom System',

## tmpl/cms/widget/personal_stats.tmpl
	'<a href="[_1]">[quant,_2,comment,comments]</a>' => '<a href="[_1]">[quant,_2,Kommentar,Kommentare]</a>',
	'<a href="[_1]">[quant,_2,draft,drafts]</a>' => '<a href="[_1]">[quant,_2,Entwurf,Entwürfe]</a>',
	'<a href="[_1]">[quant,_2,entry,entries]</a>' => '<a href="[_1]">[quant,_2,Eintrag,Einträge]</a>',
	'<a href="[_1]">[quant,_2,page,pages]</a>' => '<a href="[_1]">[quant,_2,Seite,Seiten]</a>',
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Ihr <a href="[_1]">letzter Eintrag</a> war [_2] in <a href="[_3]">[_4]</a>',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Ihr letzter Eintrag war [_1] auf <a href="[_2]">[_3]</a>.',
	'[quant,_1,comment,comments]' => '[quant,_1,Kommentar,Kommentare]',
	'[quant,_1,draft,drafts]' => '[quant,_1,Entwurf,Entwürfe]',
	'[quant,_1,entry,entries]' => '[quant,_1,Eintrag,Einträge]',
	'[quant,_1,page,pages]' => '[quant,_1,Seite,Seiten]',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Keine Blogs gefunden. [_1]',

## tmpl/cms/widget/recent_websites.tmpl
	'[quant,_1,blog,blogs]' => '[quant,_1,Blog,Blogs]',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Statistik-Einstellungen',
	'Stats for [_1]' => 'Statistik für [_1]',

## tmpl/comment/auth_aim.tmpl
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Mit Ihrem AIM- oder AOL-Bildschirmnamen anmelden. Ihr Bildschirmname wird öffentlich angezeigt.',
	'Your AIM or AOL Screen Name' => 'Ihr AIM- oder AOL-Bildschirmname',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Bei Movable Type mit Ihrem[_1]-Konto[_2] anmelden',
	'Sign in using your Gmail account' => 'Mit Ihrem Gmail-Konto anmelden',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Ihre Hatena-ID',

## tmpl/comment/auth_livejournal.tmpl
	'Learn more about LiveJournal.' => 'Mehr über LiveJournal erfahren',
	'Your LiveJournal Username' => 'Ihr LiveJournal-Benutzername',

## tmpl/comment/auth_openid.tmpl
	'Learn more about OpenID.' => 'Mehr über OpenID erfahren',
	'OpenID URL' => 'OpenID-URL',
	'Sign in with one of your existing third party OpenID accounts.' => 'Mit einer Ihrer vorhandenen OpenID-Kennungen anmelden',
	'http://www.openid.net/' => 'http://www.openid.net/',

## tmpl/comment/auth_typepad.tmpl
	'Sign in or register with TypePad.' => 'Anmelden oder bei TypePad registrieren',
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad ist ein kostenloses und offenes Identitäts-System, mit dem Sie Kommentare auf Weblogs verfassen und sich bei Websites anmelden können. Melden Sie sich kostenlos an.',

## tmpl/comment/auth_vox.tmpl
	'Learn more about Vox.' => 'Mehr über Vox erfahren',
	'Your Vox Blog URL' => 'Ihre Vox-Blog-URL',

## tmpl/comment/auth_wordpress.tmpl
	'Sign in using your WordPress.com username.' => 'Mit Ihrem Wordpress.com-Benutzernamen anmelden',
	'Your Wordpress.com Username' => 'Ihr Wordpress.com-Benutzername',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Aktivieren Sie jetzt OpenID für Ihr Yahoo!-Benutzerkonto',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'OpenID für Ihr Yahoo! Japan-Konto jetzt aktivieren',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Zurück (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Noch nicht Mitglied? <a href="[_1]">Jetzt anmelden</a>!',
	'Sign in to comment' => 'Anmelden zum Kommentieren',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Ihr Profil',

## tmpl/comment/register.tmpl
	'Create an account' => 'Konto anlegen',
	'Register' => 'Registrieren',

## tmpl/comment/signup_thanks.tmpl
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Bevor Sie kommentieren können, müssen Sie Ihre Registrierung noch bestätigen. Dazu haben wir Ihnen eine E-Mail an [_1] geschickt.',
	'Return to the original entry.' => 'Zurück zum ursprünglichen Eintrag',
	'Return to the original page.' => 'Zurück zur ursprünglichen Seite',
	'Thanks for signing up' => 'Vielen Dank für Ihre Anmeldung',

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
	'From this blog' => 'Aus diesem Blog',
	'More like this' => 'Ähnliche Einträge',
	'On this day' => 'An diesem Tag',
	'On this entry' => 'Zu diesem Eintrag',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'Von diesem Autoren',

## tmpl/feeds/feed_ping.tmpl
	'By source URL' => 'Nach URL der Quelle',
	'By source blog' => 'Nach Quelle',
	'By source title' => 'Nach Name der Quelle',
	'Source blog' => 'Quelle',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Dieser Link ist ungültig. Bitte abonnieren Sie Ihren Aktivitäts-Feed erneut.',

## tmpl/wizard/blog.tmpl
	'My First Blog' => 'Mein erstes Blog',
	'Publishing Path' => 'Veröffentlichungspfad',
	'Setup Your First Blog' => 'Richten Sie Ihr erstes Blog ein',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{Damit Ihr Blog veröffentlicht werden kann, geben Sie bitte die Web-Adresse (URL), unter der der Blog erscheinen soll, und den Pfad im Dateisystem, unter dem Movable Type die Dateien dieses Blog ablegen soll, an.},
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{Der Veröffentlichungspfad ist der Pfad auf Ihrem Webserver, in dem Movable Type die Dateien dieses Blogs ablegt.},

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDir ist erforderlich.',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'Konfigurierung des temporären Verzeichnisses',
	'The physical path for temporary directory.' => 'Pfad Ihres temporären Verzeichnisses',
	'You should configure you temporary directory settings.' => 'Hier legen Sie fest, in welchem Verzeichnis temporäre Dateien gespeichert werden.',
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
	'Show Advanced Configuration Options' => 'Erweiterte Optionen anzeigen',
	'Show Current Settings' => 'Einstellungen anzeigen',
	'Test Connection' => 'Verbindung testen',
	'You may proceed to the next step.' => 'Sie können mit dem nächsten Schritt fortfahren.',
	'You must set your Database Path.' => 'Pfad zur Datenbank erforderlich',
	'You must set your Database Server.' => 'Geben Sie Ihren Datenbankserver an.',
	'You must set your Username.' => 'Geben Sie Ihren Benutzernamen an.',
	'Your database configuration is complete.' => 'Ihre Datenbankkonfigurierung ist abgeschlossen.',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',

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
	'The physical file path for your Sendmail binary.' => 'Pfad zu Sendmail',
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
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Einige optionale Perl-Module wurden nicht gefunden. Die Installation kann ohne diese Module fortgesetzt werden. Sie können jederzeit bei Bedarf nachinstalliert werden. &#8222;Erneut versuchen&#8220; wiederholt die Modulsuche.},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Die folgenden Pakete sind nicht vorhanden, zur Ausführung von Movable Type aber erforderlich. Bitte installieren Sie sie und klicken dann auf &#8222;Erneut versuchen&#8220;.},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Die folgenden Perl-Module sind zur Herstellung einer Datenbankverbindung erforderlich (Movable Type speichert Ihre Daten in einer Datenbank). Bitte installieren Sie die hier genannten Pakete und klicken Sie danach auf &#8222;Erneut versuchen&#8220;.},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Es ist bereits eine Konfigurationsdatei (mt-config.cgi) vorhanden. Sie können sich daher sofort <a href="[_1]">bei Movable Type anmelden</a>.',
	'Begin' => 'Anfangen',
	'Configuration File Exists' => 'Es ist bereits eine Konfigurationsdatei vorhanden',
	'Configure Static Web Path' => 'Statischen Web-Pfad konfigurieren',
	'Default language.' => 'Standardsprache',
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
