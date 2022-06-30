# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::nl;
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
	'Are you sure you want to delete the selected CustomFields?' => 'Bent u zeker dat u de geselecteerde Extra Velden wenst te verwijderen?',
	'Child Site' => 'Subsite',
	'No Name' => 'Geen naam',
	'Required' => 'Vereist',
	'Site' => 'Site',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Create Custom Field' => 'Gepersonaliseerd veld aanmeken',
	'Custom Fields' => 'Extra velden',
	'Movable Type' => 'Movable Type',
	'Permission denied.' => 'Toestemming geweigerd.',
	'Please ensure all required fields have been filled in.' => 'Kijk na of alle verplichte velden ingevuld zijn.',
	'Please enter valid URL for the URL field: [_1]' => 'Gelieve een geldige URL in te vullen in het URL veld: [_1]',
	'Saving permissions failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
	'View image' => 'Afbeelding bekijken',
	'You must select other type if object is the comment.' => 'U moet een ander type selecteren als het object de reactie is.',
	'blog and the system' => 'blog en het systeem',
	'blog' => 'blog',
	'type' => 'type',
	'website and the system' => 'website en het systeem',
	'website' => 'website',
	q{Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.} => q{Pas de formulieren en velden aan voor berichten, pagina's, mappen, categoriÃ«n en gebruikers aan en sla exact die informatie op die u nodig heeft.},
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ongeldige datum '[_1]'; datums moeten in het formaat YYYY-MM-DD HH:MM:SS staan.},
	q{Please enter some value for required '[_1]' field.} => q{Gelieve een waarde in te vullen voor het verplichte '[_1]' veld.},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{De basisnaam '[_1]' is al in gebruik.  Hij moet uniek zijn binnen deze [_2].},
	q{The template tag '[_1]' is already in use.} => q{De sjabloontag '[_1]' is al in gebruik.},
	q{The template tag '[_1]' is an invalid tag name.} => q{Sjabloontag '[_1]' is een ongeldige tagnaam.},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) toegevoegd door gebruiker '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) verwijderd door '[_4]'},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => 'Klaar.',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Bezig koppelingen met mediabestanden te importeren gevonden in gepersonaliseerde velden ( [_1] )...',
	'Importing custom fields data stored in MT::PluginData...' => 'Bezig gegevens voor gepersonaliseerde velden te importeren die opgeslagen is in MT::PluginData...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Bezig url van de mediabestanden te importeren gevonden in gepersonaliseerde velden ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Gelieve een geldige optie in te vullen voor het [_1] veld: [_2]',
	q{Invalid date '[_1]'; dates should be real dates.} => q{Ongeldige datum '[_1]'; datums moeten echte datums zijn.},

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => 'Eeen "[_1]" parameter is vereist',
	'The systemObject "[_1]" is invalid.' => 'Het systemObject "[_1]" is ongeldig.',
	'The type "[_1]" is invalid.' => 'Het type "]_1]" is ongeldig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Ongeldige includeShared parameter opgegeven: [_1]',
	'Removing [_1] failed: [_2]' => 'Verwijderen van [_1] mislukt: [_2]',
	'Saving [_1] failed: [_2]' => 'Opslaan van [_1] mislukt: [_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'Veld',
	'Fields' => 'Velden',
	'System Object' => 'Systeemobject',
	'Type' => 'Type',
	'_CF_BASENAME' => 'Basename',
	'__CF_REQUIRED_VALUE__' => 'Waarde',
	q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{De '[_1]' van de sjabloontag '[_2]' die al gebruikt wordt in [_3] is [_4].},
	q{The template tag '[_1]' is already in use in [_2]} => q{De sjabloontag '[_1]' wordt al gebruikt in [_2]},
	q{The template tag '[_1]' is already in use in the system level} => q{De sjabloontag '[_1]' is al in gebruik op systeemniveau},
	q{The template tag '[_1]' is already in use in this blog} => q{De sjabloontag '[_1]' wordt al gebruikt op deze blog},

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	q{Are you sure you have used a '[_1]' tag in the correct context? We could not find the [_2]} => q{Bent u zeker dat u een '[_1]' tag gebruikte in de juiste context?  We vonden geen [_2]},
	q{You used an '[_1]' tag outside of the context of the correct content; } => q{U gebruikte een '[_1]' tag buiten de correcte context;},

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflict van [_1] "[_2]" met [_3]',
	'a field on system wide' => 'een veld op systeemniveau',
	'a field on this blog' => 'een veld op deze weblog',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Bezig velden te klonen voor blog:',
	'[_1] records processed.' => '[_1] items verwerkt.',
	'[_1] records processed...' => '[_1] items verwerkt...',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Laden van MT::LDAP mislukt: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Een gebruiker met dezelfde naam werd gevonden.  De registratie werd niet uitgevoerd: [_1]',
	'Formatting error at line [_1]: [_2]' => 'Formatteringsfout op regel [_1]: [_2]',
	'Invalid command: [_1]' => 'Ongeldig commando: [_1]',
	'Invalid display name: [_1]' => 'Ongeldige getoonde naam: [_1]',
	'Invalid email address: [_1]' => 'Ongeldig email adres: [_1]',
	'Invalid language: [_1]' => 'Ongeldige taal: [_1]',
	'Invalid number of columns for [_1]' => 'Ongeldig aantal kolommen voor [_1]',
	'Invalid password: [_1]' => 'Ongeldig wachtwoord: [_1]',
	'Invalid user name: [_1]' => 'Ongeldige gebruikersnaam: [_1]',
	'User cannot be created: [_1].' => 'Gebruiker kan niet worden aangemaakt: [_1].',
	'User cannot be updated: [_1].' => 'Gebruiker kan niet worden bijgewerkt: [_1].',
	q{Permission granted to user '[_1]'} => q{Permissie toegekend aan gebruiker '[_1]'},
	q{User '[_1]' already exists. The update was not processed: [_2]} => q{Gebruiker  '[_1]' bestaat al.  De update werd niet doorgevoerd: [_2]},
	q{User '[_1]' has been created.} => q{Gebruiker '[_1]' is aangemaakt},
	q{User '[_1]' has been deleted.} => q{Gebruiker '[_1]' werd verwijderd.},
	q{User '[_1]' has been updated.} => q{Gebruiker '[_1]' is bijgewerkt.},
	q{User '[_1]' not found.  The deletion was not processed.} => q{Gebruiker  '[_1]' werd niet gevonden.  De verwijdering werd niet uitgevoerd.},
	q{User '[_1]' not found.  The update was not processed.} => q{Gebruiker  '[_1]' niet gevonden.  De update werd niet doorgevoerd.},
	q{User '[_1]' was found, but the deletion was not processed} => q{Gebruiker  '[_1]' werd gevonden maar de verwijdering werd niet uitgevoerd.},

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'(no reason given)' => '(geen reden vermeld)',
	'A user cannot change his/her own username in this environment.' => 'Een gebruiker kan zijn/haar gebruikersnaam niet aanpassen in deze omgeving',
	'An error occurred when enabling this user.' => 'Er deed zich een fout voor bij het activeren van deze gebruiker.',
	'Bulk author export cannot be used under external user management.' => 'Bulk export van auteurs kan niet gebruikt worden onder extern gebruikersbeheer.',
	'Bulk import cannot be used under external user management.' => 'Bulk import kan niet worden gebruikt onder extern gebruikersbeheer.',
	'Bulk management' => 'Bulkbeheer',
	'Cannot rewind' => 'Kan niet terugspoelen',
	'Load failed: [_1]' => 'Laden mislukt: [_1]',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Er werden geen records gevonden in het bestand.  Kijk na of het bestand CRLF gebruiker als einde-regel karakters.',
	'Please select a file to upload.' => 'Gelieve een bestand te selecteren om te uploaden.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Gebruiker,Gebruikers] geregistreerd, [quant,_2,gebruiker,gebruikers] bijgewerkt, [quant,_3,gebruiker,gebruikers] verwijderd.',
	'Users & Groups' => 'Gebruikers & Groepen',
	'Users' => 'Gebruikers',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'Synchronisatie van groepen kan niet worden uitgevoerd zonder dat LDAPGroupIdAttribute en/of LDAPGroupNameAttribute ingesteld zijn.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Een poging om alle systeembeheerders in het systeem uit te schakelen werd ondernomen.  Synchronisatie van gebruikers werd onderbroken.',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Binaire data aan het fixen voor opslag in Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => 'Gevonden',
	'Login' => 'Login',
	'Not Found' => 'Niet gevonden',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Binding to LDAP server failed: [_1]' => 'Binden aan LDAP server mislukt: [_1]',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Ofwel is [_1] niet geïnstalleerd op uw server, ofwel is de geïnstalleerde versie te oud, of [_1] vereist een andere module die niet geïnstalleerd is.',
	'Entry not found in LDAP: [_1]' => 'Item niet gevonden in LDAP: [_1]',
	'Error connecting to LDAP server [_1]: [_2]' => 'Probleem bij connecteren naar LDAP server [_1]: [_2]',
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ongeldig LDAPAuthURL schema: [_1].',
	'More than one user with the same name found in LDAP: [_1]' => 'Meer dan één gebruiker met dezelfde naam gevonden in LDAP: [_1]',
	'User not found in LDAP: [_1]' => 'Gebruiker niet gevonden in LDAP: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] wordt niet ondersteund in deze versie van de MS SQL Server Driver',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Deze verie van de UMSSQLServer driver vereist DBD::ODBC gecompileerd met Unicode ondersteuning.',
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Deze versie van de UMSSQLServer driver vereist DBD::ODBC versie 1.14.',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'Kan sjabloon niet laden.',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Fout bij verzenden mail ([_1]); probeer een andere MailTransfer instelling?',
	q{Cannot find author for id '[_1]'} => q{Kan geen auteur vinden voor id '[_1]'},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Fout tijdens rsync: commando (exitcode [_1]): [_2]',
	'Failed to remove "[_1]": [_2]' => 'Verwijderen van "[_1]" mislukt: [_2]',
	'Incomplete file copy to Temp Directory.' => 'Onvolledige bestandskopie naar de tijdelijke map',
	'Temp Directory [_1] is not writable.' => 'Tijdelijke map [_1] niet beschrijfbaar.',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Bestandslijst synchronisatie',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*User deleted*' => '*Gebruiker verwijderd*',
	'Are you sure you want to reset the sync log?' => 'Zeker dat u het sync log wil leegmaken?',
	'FTP' => 'FTP',
	'Invalid parameter.' => 'Ongeldige parameters',
	'Rsync' => 'Rsync',
	'Showing only ID: [_1]' => 'Enkel ID wordt weergegeven: [_1]',
	'Sync Name' => 'Synchronisatie naam',
	'Sync Result' => 'Sync resulaat',
	'Sync Type' => 'Synchronisatietype',
	'Trigger' => 'Trigger',
	'[_1] in [_2]: [_3]' => '[_1] in [_2]: [_3]',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Instellingen synchronisatie',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '', # Translate - New

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Create Sync Setting' => 'Sync instelling aanmaken',
	'Deleting sync file list failed "[_1]": [_2]' => 'Verwijderen sync bestandenlijst mislukt "[_1]": [_2]',
	'Invalid request.' => 'Ongeldig verzoek.',
	'Permission denied: [_1]' => 'Toestemming geweigerd: [_1]',
	'Save failed: [_1]' => 'Opslaan mislukt: [_1]',
	'Sync Settings' => 'Synchronisatie instellingen',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => 'De vorige lijst met synchronisatiebestanden werd leeggemaakt. [_1] door [_2].',
	'The sync setting with the same name already exists.' => 'Een synchronisatie instelling met dezelfde naam bestaat al.',
	'[_1] (copy)' => '', # Translate - New
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{Er deed zich een fout voor bij het verbinden met de FTP server '[_1]': [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{}, # Translate - New
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{}, # Translate - New
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{}, # Translate - New
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{Sync instelling '[_1]' (ID: [_2]) verwijderd door [_3].},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{Sync instelling '[_1]' (ID: [_2]) bewerkt door [_3].},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Bezig alle inhoudssynchronisatie-jobs te verwijderen...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Are you sure you want to remove this settings?' => 'Bent u zeker dat u deze instellingen wil verwijderen?',
	'Invalid date.' => 'Ongeldige datum.',
	'Invalid time.' => 'Ongeldig tijdstip;',
	'Sync name is required.' => 'Synchroniatienaam is vereist.',
	'Sync name should be shorter than [_1] characters.' => 'Synchronisatienaam moet korter dan [_1] karakters zijn.',
	'The sync date must be in the future.' => 'De synchronisatiedatum moet in de toekomst liggen.',
	'You must make one or more destination settings.' => 'U moet één of meer bestemmingen instellen.',

## default_templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is het volgende archief.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is de volgende categorie.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze weblog.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is het vorige archief.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is de vorige categorie.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze weblog.',
	'About Archives' => 'Over archieven',
	'About this Archive' => 'Over dit archief',
	'About this Entry' => 'Over dit bericht',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'De nieuwste berichten zijn te vinden op de <a href="[_1]">hoofdpagina</a> of kijk in de <a href="[_2]">archieven</a> om alle berichten te zien.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'De nieuwste berichten zijn te vinden op de <a href="[_1]">hoofdpagina</a>.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Deze pagina bevat één bericht door [_1] gepubliceerd op <em>[_2]</em>.',
	'This page contains links to all of the archived content.' => 'Deze pagina bevat links naar alle gearchiveerde inhoud.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Deze pagina is een archief van berichten op <strong>[_2]</strong> gerangschikt van nieuw naar oud',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Dese pagina is een archief van de berichten in de <strong>[_1]</strong> categorie van <strong>[_2]</strong>.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Deze pagina is een archief van recente berichten in de <strong>[_1]</strong> categorie.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong> op <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong>.',

## default_templates/archive_index.mtml
	'Archives' => 'Archieven',
	'Author Archives' => 'Archief per auteur',
	'Author Monthly Archives' => 'Archief per auteur per maand',
	'Banner Footer' => 'Banner voettekst',
	'Banner Header' => 'Banner hoofding',
	'Categories' => 'Categorieën',
	'Category Monthly Archives' => 'Archief per categorie per maand',
	'HTML Head' => 'HTML Head',
	'Monthly Archives' => 'Archief per maand',
	'Sidebar' => 'Zijkolom',

## default_templates/archive_widgets_group.mtml
	'Category Archives' => 'Archieven per categorie',
	'Current Category Monthly Archives' => 'Archieven van de huidige categorie per maand',
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Dit is een lijst met widgets die andere inhoud weergeven afhankelijk van het soort archief waarin ze worden geincludeerd.  Meer info: [_1]',

## default_templates/author_archive_list.mtml
	'Authors' => 'Auteurs',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Deze weblog valt onder een <a href="[_1]">Creative Commons Licentie</a>.',
	'_POWERED_BY' => 'Aangedreven  door<br /><a href="https://www.movabletype.org/"><$MTProductName$></a>',

## default_templates/calendar.mtml
	'Fri' => 'Vri',
	'Friday' => 'Vrijdag',
	'Mon' => 'Maa',
	'Monday' => 'Maandag',
	'Monthly calendar with links to daily posts' => 'Maandkalender met links naar de berichten van alle dagen',
	'Sat' => 'Zat',
	'Saturday' => 'Zaterdag',
	'Sun' => 'Zon',
	'Sunday' => 'Zondag',
	'Thu' => 'Don',
	'Thursday' => 'Donderdag',
	'Tue' => 'Din',
	'Tuesday' => 'Dinsdag',
	'Wed' => 'Woe',
	'Wednesday' => 'Woensdag',

## default_templates/category_entry_listing.mtml
	'Entry Summary' => 'Samenvatting bericht',
	'Main Index' => 'Hoofdindex',
	'Recently in <em>[_1]</em> Category' => 'Recent in de categorie <em>[_1]</em>',
	'[_1] Archives' => 'Archieven van [_1]',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Maandelijkse archieven',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Daily Archives' => 'Archieven per auteur per dag',
	'Author Weekly Archives' => 'Archieven per auteur per week',
	'Author Yearly Archives' => 'Archieven per auteur per jaar',

## default_templates/date_based_category_archives.mtml
	'Category Daily Archives' => 'Archieven per categorie per dag',
	'Category Weekly Archives' => 'Archieven per categorie per week',
	'Category Yearly Archives' => 'Archieven per categorie per jaar',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Pagina niet gevonden',

## default_templates/entry.mtml
	'# Comments' => '# reacties',
	'# TrackBacks' => '# TrackBacks',
	'1 Comment' => '1 reactie',
	'1 TrackBack' => '1 Trackback',
	'By [_1] on [_2]' => 'Door [_1] op [_2]',
	'Comments' => 'Reacties',
	'No Comments' => 'Geen reacties',
	'No TrackBacks' => 'Geen TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '<a href="[_1]" rel="bookmark">[_2]</a> verder lezen.',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Aangedreven door Movable Type [_1]',

## default_templates/javascript.mtml
	'Edit' => 'Bewerken',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Als antwoord op <a href="[_1]" onclick="[_2]">reactie van [_3]</a>',
	'Signing in...' => 'Aanmelden...',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Bedankt om u aan te melden, __NAME__. ([_1]afmelden[_2])',
	'The sign-in attempt was not successful; Please try again.' => 'Aanmeldingspoging mislukt; Gelieve opnieuw te proberen.',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'U heeft geen permissie om te reageren op deze weblog. ([_1]afmelden[_2])',
	'Your session has expired. Please sign in again to comment.' => 'Uw sessie is verlopen.  Gelieve opnieuw aan te melden om te kunnen reageren.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Meld u aan[_2] om te reageren, of reageer anoniem.',
	'[_1]Sign in[_2] to comment.' => '[_1]Meld u aan[_2] om te reageren.',
	'[quant,_1,day,days] ago' => '[quant,_1,dag,dagen] geleden',
	'[quant,_1,hour,hours] ago' => '[quant,_1,uur,uur] geleden',
	'[quant,_1,minute,minutes] ago' => '[quant,_1,minuut,minuten] geleden',
	'moments ago' => 'ogenblikken geleden',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'IP Adres: [_1]',
	'Mail Footer' => 'Footer voor e-mail',
	'Recovery: [_1]' => 'Herstel: [_1]',
	'This email is to notify you that an IP address has been locked out.' => 'Dit is een bericht om u te melden dat een IP adres geblokkeerd werd.',

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => 'Getoonde naam: [_1]',
	'Email: [_1]' => 'E-mail: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Als u deze gebruiker weer wil laten participeren, klik dan onderstaande link.',
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Dit is een bericht om u te melden dat een Movable Type gebruikersaccount geblokkeerd werd.',
	'Username: [_1]' => 'Gebruikersnaam: [_1]',

## default_templates/main_index_widgets_group.mtml
	'Recent Assets' => 'Recente mediabestanden',
	'Recent Comments' => 'Recente reacties',
	'Recent Entries' => 'Recente berichten',
	'Tag Cloud' => 'Tagwolk',
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Dit is een speciale set widgets die enkel op de hoofdpagina (of "Hoofdindex") verschijnen.  Meer info: [_1]',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Selecteer een maand...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archieven</a> [_1]',

## default_templates/notify-entry.mtml
	'Message from Sender:' => 'Boodschap van afzender:',
	'Publish Date: [_1]' => 'Publicatiedatum: [_1]',
	'View entry:' => 'Bekijk bericht:',
	'View page:' => 'Bekijk pagina:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'U ontvangt dit bericht omdat u ofwel gekozen hebt om notificaties over nieuw inhoud op [_1] te ontvangen, of de auteur van het bericht dacht dat u misschien wel geïnteresseerd zou zijn.  Als u deze berichten niet langer wenst te ontvangen, gelieve deze persoon te contacteren:',
	'[_1] Title: [_2]' => '[_1] titel: [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Een [lc,_3] getiteld '[_1]' is gepubliceerd op [_2].},

## default_templates/openid.mtml
	'Learn more about OpenID' => 'Meer weten over OpenID',
	'[_1] accepted here' => '[_1] hier geaccepteerd',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',

## default_templates/pages_list.mtml
	q{Pages} => q{Pagina's},

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'https://www.movabletype.com/',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Er werd een aanvraag ingediend om uw Movable Type wachtwoord te veranderen.  Om dit proces af te ronden moet u op onderstaande link klikken en vervolgens een nieuw wachtwoord kiezen.',
	'If you did not request this change, you can safely ignore this email.' => 'Als u deze wijziging niet heeft aangevraagd, kunt u deze e-mail gerust negeren.',

## default_templates/search.mtml
	'Search' => 'Zoek',

## default_templates/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een exacte uitdrukking te zoeken, gelieve aanhalingstekens rond uw zoekopdracht te zetten:',
	'Instructions' => 'Gebruiksaanwijzing',
	'Next' => 'Volgende',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Geen resultaten gevonden met &ldquo;[_1]&rdquo;',
	'Previous' => 'Vorige',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultaten die overeenkomen met &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultaten getagd als &ldquo;[_1]&rdquo;',
	'Search Results' => 'Zoekresultaten',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'De zoekmachine ondersteunt eveneens de booleaanse operatoren AND, OR en NOT:',
	'movable type' => 'movable type',
	'personal OR publishing' => 'persoonlijk OR publicatie',
	'publishing NOT personal' => 'publiceren NOT persoonlijk',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'layout twee kolommen - Zijkolom',
	'3-column layout - Primary Sidebar' => 'layout drie kolommen - Primaire zijkolom',
	'3-column layout - Secondary Sidebar' => 'layout drie kolommen - Secundaire zijkolom',

## default_templates/signin.mtml
	'Sign In' => 'Aanmelden',
	'You are signed in as ' => 'U bent aangemeld als',
	'You do not have permission to sign in to this blog.' => 'U heeft geen toestemming om aan te melden op deze weblog',
	'sign out' => 'afmelden',

## default_templates/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feed met resultaten die overeen komen met &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed met resultaten getagd als &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Inschrijven op een feed met alle toekomstige berichten die overeen komen met &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Inschrijven op een feed met alle toekomstige berichten getagd als &ldquo;[_1]&ldquo;',
	'Subscribe to feed' => 'Inschrijven op feed',
	q{Subscribe to this blog's feed} => q{Inschrijven op de feed van deze weblog},

## lib/MT.pm
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'Er deed zich een fout voor: [_1]',
	'Bad CGIPath config' => 'Fout in CGIPath configuratie',
	'Bad LocalLib config ([_1]): [_2]' => 'Fout in LocalLib configuratie ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Fout in ObjectDriver configuratie',
	'Error while creating email: [_1]' => 'Fout bij het aanmaken van email: [_1]',
	'Fourth argument to add_callback must be a CODE reference.' => 'Vierde argument van add_callback moet een CODE referentie zijn.',
	'Google' => 'Google',
	'Hatena' => 'Hatena',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Hello, world' => 'Hello, world',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Als het aanwezig is, dan moet het derde argument bij add_callback een object van het type MT::Component of MT::Plugin zijn',
	'Internal callback' => 'Interne callback',
	'Invalid priority level [_1] at add_callback' => 'Ongeldig prioriteitsniveau [_1] in add_callback',
	'LiveJournal' => 'LiveJournal',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Ontbrekend configuratiebestand.  Misschien vergat u mt-config.cgi-original te hernoemen naar mt-config.cgi?',
	'Movable Type default' => 'Movable Type standaard',
	'OpenID' => 'OpenID',
	'Plugin error: [_1] [_2]' => 'Plugin fout: [_1] [_2]',
	'Powered by [_1]' => 'Aangedreven door [_1]',
	'Two plugins are in conflict' => 'Twee plugins zijn in conflict',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => 'Naamloze plugin',
	'Version [_1]' => 'Versie [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'Wordpress.com',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1] faalde met volgende boorschap: [_2]',
	'https://www.movabletype.com/' => 'https://www.movabletype.com',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'livedoor' => 'livedoor',
	q{Loading template '[_1]' failed.} => q{Laden van sjabloon '[_1]' mislukt.},

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App.pm
	'(Display Name not set)' => '(Getoonde naam niet ingesteld)',
	'A user with the same name already exists.' => 'Er bestaat al een gebruiker met die naam.',
	'An error occurred while trying to process signup: [_1]' => 'Er deed zich een fout voor bij het verwerken van de registratie: [_1]',
	'Back' => 'Terug',
	'Cannot load blog #[_1]' => 'Kan blog niet laden #[_1]',
	'Cannot load blog #[_1].' => 'Kan blog niet laden #[_1].',
	'Cannot load entry #[_1].' => 'Kan bericht niet laden #[_1].',
	'Cannot load site #[_1].' => 'Kan site niet laden #[_1].',
	'Close' => 'Sluiten',
	'Display Name' => 'Getoonde naam',
	'Email Address is invalid.' => 'Email adres is ongeldig',
	'Email Address is required for password reset.' => 'Email adres is vereist om wachtwoord opnieuw te kunnen instellen',
	'Email Address' => 'Email adres',
	'Error sending mail: [_1]' => 'Fout bij versturen mail: [_1]',
	'Failed login attempt by anonymous user' => '', # Translate - New
	'Failed to open pid file [_1]: [_2]' => 'Openen pid bestand mislukt [_1]: [_2]',
	'Failed to send reboot signal: [_1]' => 'Sturen van reboot signaal mislukt: [_1]',
	'Internal Error: Login user is not initialized.' => 'Interne fout: login gebruiker is niet geïnitialiseerd.',
	'Invalid login.' => 'Ongeldige aanmeldgegevens.',
	'Invalid request' => 'Ongeldig verzoek',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Onze verontschuldigingen, maar u heeft geen permissies om toegang te krijgen tot blogs of websites op deze installatie.  Als u dit bericht ten onrechte te zien krijgt, gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'Password should be longer than [_1] characters' => 'Wachtwoord moet langer zijn dan [_1] karakters',
	'Password should contain symbols such as #!$%' => 'Wachtwoord moet ook symbolen bevatten zoals #!$%',
	'Password should include letters and numbers' => 'Wachtwoorden moeten zowel letters als cijfers bevatten',
	'Password should include lowercase and uppercase letters' => 'Wachtwoord moet zowel grote als kleine letters bevatten',
	'Password should not include your Username' => 'Wachtwoord mag gebruikersnaam niet bevatten',
	'Passwords do not match.' => 'Wachtwoorden komen niet overeen',
	'Problem with this request: corrupt character data for character set [_1]' => 'Probleem met dit verzoek: corrupte karakterdata voor karakterset [_1]',
	'Removed [_1].' => '[_1] verwijderd.',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Het spijt ons, maar u heeft geen toestemming om toegang te krijgen op blogs of websites van deze installatie.  Als u meent dat dit een fout is, gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'System Email Address is not configured.' => 'Systeem e-mail adres is niet ingesteld.',
	'Text entered was wrong.  Try again.' => 'Ingevulde tekst was fout.  Probeer opnieuw.',
	'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
	'The login could not be confirmed because of a database error ([_1])' => 'Aanmelding kon niet worden bevestigd wegens een databasefout ([_1])',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Deze account werd verwijderd.  Contacteer uw Movable Type systeembeheerder om toegang te krijgen.',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Deze account werd gedeactiveerd.  Contacteer uw Movable Type systeembeheerder om toegang te krijgen.',
	'URL is invalid.' => 'URL is ongeldig',
	'Unknown action [_1]' => 'Onbekende actie [_1]',
	'Unknown error occurred.' => 'Er deed zich een onbekende fout voor.',
	'User requires display name.' => 'Gebruiker heeft getoonde naam nodig.',
	'User requires password.' => 'Gebruiker heeft wachtwoord nodig.',
	'User requires username.' => 'Gebruiker heeft gebruikersnaam nodig.',
	'Username' => 'Gebruikersnaam',
	'Warnings and Log Messages' => 'Waarschuwingen en logberichten',
	'You did not have permission for this action.' => 'U had geen permissie voor deze actie',
	'[_1] contains an invalid character: [_2]' => '[_1] bevat een ongeldig karakter: [_2]',
	q{Failed login attempt by deleted user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by disabled user '[_1]'} => q{Mislukte aanmeldpoding door gedeactiveerde gebruiker '[_1]'},
	q{Failed login attempt by locked-out user '[_1]'} => q{}, # Translate - New
	q{Failed login attempt by pending user '[_1]'} => q{Mislukte poging tot aanmelden van een gebruiker '[_1]' die nog gekeurd moet worden},
	q{Failed login attempt by unknown user '[_1]'} => q{Mislukte aanmeldpoging door onbekende gebruiker '[_1]'},
	q{Failed login attempt by user '[_1]'} => q{}, # Translate - New
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{Openen monitoringbestand aangegeven via de IISFastCGIMonitoringFilePath directief mislukt '[_1]': [_2]},
	q{Invalid login attempt from user '[_1]'} => q{Ongeldige poging tot aanmelden van gebruiker '[_1]'},
	q{New Comment Added to '[_1]'} => q{Nieuwe reactie achtergelaten op '[_1]'},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{Gebruiker '[_1]' (ID:[_2]) met succes aangemeld},
	q{User '[_1]' (ID:[_2]) logged out} => q{Gebruiker '[_1]' (ID:[_2]) werd afgemeld},

## lib/MT/App/ActivityFeeds.pm
	'All "[_1]" Content Data' => 'Alle "[_1]" inhoudsgegevens',
	'All Activity' => 'Alle acties',
	'All Entries' => 'Alle berichten',
	'An error occurred while generating the activity feed: [_1].' => 'Er deed zich een fout voor bij het aanmaken van de activiteitenfeed: [_1].',
	'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
	'Movable Type Debug Activity' => 'Movable Type debugactiviteit',
	'Movable Type System Activity' => 'Movable Type systeemactiviteit',
	'No permissions.' => 'Geen permissies.',
	'[_1] "[_2]" Content Data' => '[_1] "[_2]" inhoudsgegevens',
	'[_1] Activity' => '[_1] acties',
	'[_1] Entries' => '[_1] berichten',
	q{All Pages} => q{Alle pagina's},
	q{[_1] Pages} => q{[_1] pagina's},

## lib/MT/App/CMS.pm
	'Activity Log' => 'Activiteitenlog',
	'Add Contact' => 'Contact toevoegen',
	'Add IP Address' => 'IP Adres toevoegen',
	'Add Tags...' => 'Tags toevoegen',
	'Add a user to this [_1]' => 'Gebruiker toevoegen aan deze [_1]',
	'Add user to group' => 'Gebruiker toevoegen aan een groep',
	'Address Book' => 'Adresboek',
	'Are you sure you want to delete the selected group(s)?' => 'Bent u zeker dat u de geselecteerde groep(en) wenst te verwijderen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Bent u zeker dat u de geselecteerde leden of het geselcteerde lid wenst te verwijderen uit de groep?',
	'Are you sure you want to reset the activity log?' => 'Bent u zeker dat u het activiteitenlog wil leegmaken?',
	'Asset' => 'Mediabestand',
	'Assets' => 'Mediabestanden',
	'Associations' => 'Associaties',
	'Batch Edit Entries' => 'Berichten bewerken in bulk',
	'Blog' => 'Blog',
	'Cannot load blog (ID:[_1])' => 'Kan blog niet laden (ID:[_1])',
	'Category Sets' => 'Categoriesets',
	'Clear Activity Log' => 'Activiteitenlog leegmaken',
	'Clone Child Site' => 'Kloon deelsite',
	'Clone Template(s)' => 'Sjablo(o)n(en) klonen',
	'Compose' => 'Opstellen',
	'Content Data' => 'Inhoudsgegevens',
	'Content Types' => 'Inhoudstypes',
	'Create Role' => 'Rol aanmaken',
	'Delete' => 'Verwijderen',
	'Design' => 'Design',
	'Disable' => 'Uitschakelen',
	'Documentation' => 'Documentatie',
	'Download Address Book (CSV)' => 'Adresboek downloaden (CSV)',
	'Download Log (CSV)' => 'Log downloaden (CSV)',
	'Edit Template' => 'Sjabloon bewerken',
	'Enable' => 'Inschakelen',
	'Entries' => 'Berichten',
	'Entry' => 'Bericht',
	'Error during publishing: [_1]' => 'Fout tijdens publiceren: [_1]',
	'Export Site' => 'Site exporteren',
	'Export Sites' => 'Sites exporteren',
	'Export Theme' => 'Thema exporteren',
	'Export' => 'Export',
	'Feedback' => 'Feedback',
	'Feedbacks' => 'Reacties',
	'Filters' => 'Filters',
	'Folders' => 'Mappen',
	'General' => 'Algemeen',
	'Grant Permission' => 'Permissie toekennen',
	'Groups ([_1])' => 'Groepen ([_1])',
	'Groups' => 'Groepen',
	'IP Banning' => 'IP Blokkering',
	'Import Sites' => 'Sites importeren',
	'Import' => 'Import',
	'Invalid parameter' => 'Ongeldige parameter',
	'Manage Members' => 'Leden beheren',
	'Manage' => 'Beheren',
	'Movable Type News' => 'Movable Type-nieuws',
	'Move child site(s) ' => 'Verplaats deelsite(s)',
	'New' => 'Nieuw',
	'No such blog [_1]' => 'Geen blog [_1]',
	'None' => 'Geen',
	'Notification Dashboard' => 'Meldingendashboard',
	'Page' => 'pagina',
	'Permissions' => 'Permissies',
	'Plugins' => 'Plugins',
	'Profile' => 'Profiel',
	'Publish Template(s)' => 'Sjablo(o)n(en) publiceren',
	'Publish' => 'Publiceren',
	'Rebuild Trigger' => 'Herpublicatievoorwaarde',
	'Rebuild' => 'Herpubliceren',
	'Recover Password(s)' => 'Wachtwoord(en) terugvinden',
	'Refresh Template(s)' => 'Sjablo(o)n(en) verversen',
	'Refresh Templates' => 'Sjablonen verversen',
	'Remove Tags...' => 'Tags verwijderen',
	'Remove' => 'Verwijder',
	'Revoke Permission' => 'Permissie intrekken',
	'Roles' => 'Rollen',
	'Search & Replace' => 'Zoeken & vervangen',
	'Settings' => 'Instellingen',
	'Sign out' => 'Afmelden',
	'Site List for Mobile' => 'Lijst websites voor mobiel gebruik',
	'Site List' => 'Lijst websites',
	'Site Stats' => 'Sitestatistieken',
	'Sites' => 'Sites',
	'System Information' => 'Systeeminformatie',
	'Tags to add to selected assets' => 'Tags om toe te voegen aan de geselecteerde mediabestanden',
	'Tags to add to selected entries' => 'Tags toe te voegen aan geselecteerde berichten',
	'Tags to remove from selected assets' => 'Tags om te verwijderen van de geselecteerde mediabestanden',
	'Tags to remove from selected entries' => 'Tags te verwijderen van geselecteerde berichten',
	'Tools' => 'Gereedschappen',
	'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
	'Unlock' => 'Deblokkeer',
	'Unpublish Entries' => 'Publicatie ongedaan maken',
	'Updates' => 'Updates',
	'Upload' => 'Opladen',
	'Use Publishing Profile' => 'Publicatieprofiel gebruiken',
	'User' => 'Gebruiker',
	'View Site' => 'Site bekijken',
	'Web Services' => 'Webservices',
	'Website' => 'Website',
	'_WARNING_PASSWORD_RESET_MULTI' => 'U staat op het punt e-mails te versturen waarmee de geselecteerde gebruikers hun wachtwoord kunnen aanpassen. Bent u zeker?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Deze actie zal de sjablonen van de geselecteerde blog(s) terugzetten naar de fabrieksinstellingen. Bent u zeker dat u de sjabonen van de geselecteerde blog(s) wenst te verversen?',
	'content data' => 'inhoudsgegevens',
	'entry' => 'bericht',
	q{Batch Edit Pages} => q{Pagina's bewerken in bulk},
	q{Failed login attempt by user who does not have sign in permission. '[_1]' (ID:[_2])} => q{Mislukte aanmeldpoging van gebruiker die geen toestemming heeft om aan te melden. '[_1]' (ID:[_2])},
	q{Tags to add to selected pages} => q{Tags om toe te voegen aan geselecteerde pagina's},
	q{Tags to remove from selected pages} => q{Tags om te verwijderen van geselecteerde pagina's},
	q{Themes} => q{Thema's},
	q{Unpublish Pages} => q{Pagina's off-line halen},
	q{[_1]'s Group} => q{Groep van [_1]},
	q{_WARNING_DELETE_USER_EUM} => q{Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker tot 'wees' maakt.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies verwijderen.  Bent u zeker dat u deze gebruiker(s) wenst te verwijderen?\nGebruikers die nog bestaan in de externe directory zullen zichzelf weer kunnen aanmaken.},
	q{_WARNING_DELETE_USER} => q{Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in 'wezen' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies te verwijderen.  Bent u zeker dat u deze gebruiker wenst te verwijderen?},

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Sommige websites werden niet verwijderd.  U moet de blogs onder de website eerst verwijderen.',

## lib/MT/App/DataAPI.pm
	'[_1] must be a number.' => '[_1] moet een getal zijn.',
	'[_1] must be an integer and between [_2] and [_3].' => '[_1] moet een integer zijn tussen [_2] en [_3].',

## lib/MT/App/Search.pm
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Cachen van zoekresultaten mislukt.  [_1] is niet beschikbaar: [_2]',
	'Filename extension cannot be asp or php for these archives' => 'Bestandsnaamextensie mag niet asp of php zijn voor deze archieven',
	'Invalid [_1] parameter.' => 'Ongeldige [_1] parameter',
	'Invalid archive type' => 'Ongelidg archieftype',
	'Invalid format: [_1]' => 'Ongeldig formaat: [_1]',
	'Invalid query: [_1]' => 'Ongeldige zoekopdracht: [_1]',
	'Invalid type: [_1]' => 'Ongeldig type: [_1]',
	'Invalid value: [_1]' => 'Ongeldige waarde: [_1]',
	'No column was specified to search for [_1].' => 'Geen kolom opgegeven om op te zoeken [_1].',
	'No such template' => 'Geen sjabloon gevonden',
	'Output file cannot be of the type asp or php' => 'Uitvoerbestand mag niet van het type asp of php zijn',
	'Template must be a main_index for Index archive type' => 'Sjabloon moet een main_index zijn voor het Index archieftype',
	'Template must be archive listing for non-Index archive types' => 'Sjabloon moet archiefoverzicht zijn voor niet-index archieftypes',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'De zoekopdracht die u uitvoerde is over de tijdslimiet gegaan.  Gelieve uw zoekopdracht te vereenvoudigen en opnieuw te proberen.',
	'Unsupported type: [_1]' => 'Niet ondersteund type: [_1]',
	'You must pass a valid archive_type with the template_id' => 'U moet een geldig archieftype doorgeven via het template_id',
	'template_id cannot refer to a global template' => 'template_id mag niet verwijzen naar een globaal sjabloon',
	q{No alternate template is specified for template '[_1]'} => q{Geen alternatief sjabloon opgegeven voor sjabloon '[_1]'},
	q{Opening local file '[_1]' failed: [_2]} => q{Lokaal bestand '[_1]' openen mislukt: [_2]},
	q{Search: query for '[_1]'} => q{Zoeken: zoekopdracht voor '[_1]'},

## lib/MT/App/Search/ContentData.pm
	'Invalid SearchContentTypes "[_1]": [_2]' => 'Ongeldige SearchContentTypes "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'Ongeldig SearchContentTypes: [_1]',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch werkt met MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'Beide wachtwoorden moeten overeen komen.',
	'Could not authenticate using the credentials provided: [_1].' => 'Kon niet aanmelden met de opgegeven gegevens: [_1].',
	'Invalid session.' => 'Ongeldige sessie.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type is bijgewerkt tot versie [_1]',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Geen permissies.  Gelieve uw Movable Type administrator te contacteren voor hulp met het upgraden van Movable Type.',
	'You must supply a password.' => 'U moet een wachtwoord opgeven.',
	q{Invalid email address '[_1]'} => q{Ongeldig email adres '[_1]'},
	q{The 'Website Root' provided below is not allowed} => q{De 'Website Root' die werd opgegeven hieronder is niet toegestaan},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{De 'Website Root' die werd opgegeven hieronder is niet beschrijfbaar door de webserver.  Verander de eigenaar of de permissies op deze map en klik dan opnieuw op de knop om de installatie af te werken.},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Er deed zich een probleem voor bij het verbinden met de database.  Controleer de instellingen en probeer opnieuw.',
	'CGI is required for all Movable Type application functionality.' => 'CGI is vereist voor alle functionaliteit van Movable Type.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File is vereist als u reageerders wenst te laten aanmelden via Yahoo! Japan met OpenID.',
	'DBI is required to work with most supported databases.' => 'DBI is vereist om te kunnen werken met de meeste ondersteunde databases.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA is vereist voor geavanceerde bescherming van gebruikerswachtwoorden.',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec is vereist om te kunnen werken met padinformatie in bestandssystemen op alle ondersteunde operating systemen.',
	'HTML::Entities is required by CGI.pm' => 'HTML::Entities is vereist door CGI.pm',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser is optioneel: Het is nodig als u het TrackBack systeem wenst te gebruiken of pings wenst te sturen naar weblogs.com of MT recent bijgewerkte sites.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL is vereist voor alle SSL/TLS verbindingen, zoals Google Analytics site statistieken of SMTP Auth over SSL/TLS.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent is vereist om Movable Type configuratiebestanden te kunnen maken tijdens het gebruik van de installatiewizard.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List::Util is optioneel; Het is vereist als u de publicatiewachtrij-functie wenst te gebruiken.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP is vereist om mail te kunnen versturen via een SMTP server.',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay is vereist om SMTP Auth te kunnen gebruiken over een SSL verbinding of om het te kunnen gebruiken met een STARTTLS commando.',
	'Please select a database from the list of available databases and try again.' => 'Gelieve een database te selecteren uit de lijst met beschikbare databases en probeer opnieuw.',
	'SMTP Server' => 'SMTP server',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util is vereist om de Movable Type applicatie te kunnen initialiseren.',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test e-mail van de Movable Type Configuratiewizard',
	'The [_1] database driver is required to use [_2].' => 'De [_1] databasedriver is vereist om [_2] te kunnen gebruiken.',
	'The [_1] driver is required to use [_2].' => 'De [_1] driver is vereist om [_2] te kunnen gebruiken.',
	'This is the test email sent by your new installation of Movable Type.' => 'Dit is de test e-mail verstuurd door uw nieuwe installatie van Movable Type.',
	'This module accelerates comment registration sign-ins.' => 'Deze module versnelt aanmeldingen om te kunnen reageren.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Deze module en de modules waar ze van afhangt zijn nodig om reageerders zichzelf te laten authenticeren via OpenID providers waaronder LiveJournal.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Deze module en de modules waar ze van afhangt zijn vereisten om te kunen restoren uit een backup.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Deze modules en de modules waar deze van afhangt zijn vereist om CRM-MD5, DIGEST-MD5 of LOGIN SASL te ondersteunen.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Deze module en de modules waar deze van afhangt zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
	'This module enables the use of the Atom API.' => 'Deze module maakt het mogelijk de Atom API te gebruiken.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Deze module is vereist als u de MT XML-RPC server implementatie wenst te gebruiken.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Deze module is vereist als u graag thumbnailveries van opgeladen bestanden wenst te kunnen aanmaken.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Deze module is vereist als u bestaande bestanden wenst te kunnen overschrijven bij het opladen.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Deze module is vereist als u NetPBM wenst te gebruiken als driver voor afbeeldingen met MT.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Deze module is vereist om registratie van reageerders in te schakelen.  Ook vereist om mail te versturen via een SMTP server.',
	'This module is required by certain MT plugins available from third parties.' => 'Deze module is vereist door bepaalde MT plugins beschikbaar bij derden.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Deze module wordt vereist door mt-search.cgi als u Movable Type draait op een Perl versie ouder dan 5.8',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Deze module is vereist om statistieken over de site te kunnen weergeven uit Google Analytics en om SSL certificaten te kunnen controleren.',
	'This module is required for XML-RPC API.' => 'Deze module is vereist voor XML-RPC API.',
	'This module is required for cookie authentication.' => 'Deze module is vereist voor cookie-authenticatie.',
	'This module is required for executing run-periodic-tasks.' => 'Deze module is vereist om run-periodic-tasks te kunnen uitvoeren.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Deze module is vereist om bestande te kunnen opladen (om het formaat van afbeeldingen in vele verschillende formaten te kunnen bepalen).',
	'This module is required in order to archive files in backup/restore operation.' => 'Deze module is vereist om bestanden te archiveren bij backup/restore operaties.',
	'This module is required in order to compress files in backup/restore operation.' => 'Deze module is vereist om bestanden te comprimeren bij backup/restore operaties.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Deze module is vereist om bestanden te decomprimeren bij backup/restore operaties.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Deze module is vereist om memcached te kunnen gebruiken als cachemechanisme voor Movable Type',
	'This module is used by the Markdown text filter.' => 'Deze module is vereist voor de Markdown tekstfilter.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Deze module wordt gebruikt in een testattribuut voor de MTIf conditionele tag.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck is optioneel; Het is een beter, sneller en lichter alternatief voor YAML::Tiny bij het behandelen van YAML bestanden.',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'Auteur',
	'author/author-basename/index.html' => 'auteur/auteur-basisnaam/index.html',
	'author/author_basename/index.html' => 'auteur/auteur_basisnaam/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'per auteur per dag',
	'author/author-basename/yyyy/mm/dd/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/dd/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'per auteur per maand',
	'author/author-basename/yyyy/mm/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'per auteur per week',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/dag-week/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/dag-week/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'per auteur per jaar',
	'author/author-basename/yyyy/index.html' => 'auteur/auteur-basisnaam/yyyy/index.html',
	'author/author_basename/yyyy/index.html' => 'auteur/auteur_basisnaam/yyyy/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'Categorie',
	'category/sub-category/index.html' => 'categorie/sub-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sub_categorie/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'per categorie per dag',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sub-categorie/jjjj/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sub_categorie/jjjj/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'per categorie per maand',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sub-categorie/jjjj/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sub_categorie/jjjj/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'per categorie per week',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sub-categorie/jjjj/mm/dag-week/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sub_categorie/jjjj/mm/dag-week/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'per categorie per jaar',
	'category/sub-category/yyyy/index.html' => 'categorie/sub-categorie/jjjj/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sub_categorie/jjjj/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'CONTENTTYPE_ADV' => 'InhoudsType',
	'author/author-basename/content-basename.html' => 'auteur/auteur-basisnaam/inhoud-basisnaam.html',
	'author/author-basename/content-basename/index.html' => 'auteur/auteur-basisnaam/inhoud-basisnaam/index.html',
	'author/author_basename/content_basename.html' => 'auteur/auteur_basisnaam/inhoud_basisnaam.html',
	'author/author_basename/content_basename/index.html' => 'auteur/auteur_basisnaam/inhoud_basisnaam/index.html',
	'category/sub-category/content-basename.html' => 'categorie/sub-categorie/basisnaam-inhoud.html',
	'category/sub-category/content-basename/index.html' => 'categorie/sub-categorie/basisnaam-inhoud/index.html',
	'category/sub_category/content_basename.html' => 'categorie/sub_categorie/basisnaam_inhoud.html',
	'category/sub_category/content_basename/index.html' => 'categorie/sub_categorie/basisnaam_inhoud/index.html',
	'yyyy/mm/content-basename.html' => 'jjjj/mm/basisnaam-inhoud.html',
	'yyyy/mm/content-basename/index.html' => 'jjjj/mm/basisnaam-inhoud/index.html',
	'yyyy/mm/content_basename.html' => 'jjjj/mm/basisnaam_inhoud.html',
	'yyyy/mm/content_basename/index.html' => 'jjjj/mm/basisnaam_inhoud/index.html',
	'yyyy/mm/dd/content-basename.html' => 'jjjj/mm/dd/basisnaam-inhoud.html',
	'yyyy/mm/dd/content-basename/index.html' => 'jjjj/mm/basisnaam-inhoud/index.html',
	'yyyy/mm/dd/content_basename.html' => 'jjjj/mm/dd/basisnaam_inhoud.html',
	'yyyy/mm/dd/content_basename/index.html' => 'jjjj/mm/basisnaam_inhoud/index.html',

## lib/MT/ArchiveType/ContentTypeAuthor.pm
	'CONTENTTYPE-AUTHOR_ADV' => 'InhoudsType Auteur',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'InhoudsType Auteur per dag',

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'InhoudsType Auteur per maand',

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'InhoudsType Auteur per week',

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'InhoudsType Auteur per jaar',

## lib/MT/ArchiveType/ContentTypeCategory.pm
	'CONTENTTYPE-CATEGORY_ADV' => 'InhoudsType Categorie',

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'InhoudsType Categorie per dag',

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'InhoudsType Categorie per maand',

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'InhoudsType Categorie per week',

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'InhoudsType Categorie per jaar',

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'CONTENTTYPE-DAILY_ADV' => 'InhoudsType per dag',
	'DAILY_ADV' => 'per dag',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/dd/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'CONTENTTYPE-MONTHLY_ADV' => 'InhoudsType per maand',
	'MONTHLY_ADV' => 'per maand',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'CONTENTTYPE-WEEKLY_ADV' => 'InhoudsType per week',
	'WEEKLY_ADV' => 'per week',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/dag-week/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'CONTENTTYPE-YEARLY_ADV' => 'InhoudsType per jaar',
	'YEARLY_ADV' => 'per jaar',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'per bericht',
	'category/sub-category/entry-basename.html' => 'categorie/sub-categorie/basisnaam-bericht.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sub-categorie/basisnaam-bericht/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sub_categorie/basisnaam_bericht.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sub_categorie/basisnaam_bericht/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/dd/basisnaam-bericht.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/dd/basisnaam-bericht/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/dd/basisnaam_bericht.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/dd/basisnaam_bericht/index.html',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/basisnaam-bericht.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/basisnaam-bericht/index.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/basisnaam_bericht.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/basisnaam_bericht/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'Pagina',
	'folder-path/page-basename.html' => 'map-pad/basisnaam-pagina.html',
	'folder-path/page-basename/index.html' => 'map-pad/basisnaam-pagina/index.html',
	'folder_path/page_basename.html' => 'map_pad/basisnaam_pagina.html',
	'folder_path/page_basename/index.html' => 'map_pad/basisnaam_pagina/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'Mediabestanden van deze website',
	'Assets with Extant File' => 'Mediabestanden met bestaand bestand',
	'Assets with Missing File' => 'Mediabestanden met ontbrekend bestand',
	'Audio' => 'Audio',
	'Author Status' => 'Status auteur',
	'Content Data ( id: [_1] ) does not exists.' => 'Inhoudsgegevens ( id: [_1] ) bestaat niet.',
	'Content Field ( id: [_1] ) does not exists.' => 'Inhoudsveld ( id: [_1] ) bestaat niet.',
	'Content Field' => 'Inhoudsveld',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'Inhoudstype van inhoudsgegevens ( id: [_1] ) bestaat niet.',
	'Could not create asset cache path: [_1]' => 'Kon cachepad voor mediabestand niet aanmaken [_1]',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Kon mediabestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Deleted' => 'Verwijderd',
	'Description' => 'Beschrijving',
	'Disabled' => 'Uitgeschakeld',
	'Enabled' => 'Ingeschakeld',
	'Except Userpic' => 'Uitgezonderd gebruikersafbeelding',
	'File Extension' => 'Bestandsextensie',
	'File' => 'Bestand',
	'Filename' => 'Bestandsnaam',
	'Image' => 'Afbeelding',
	'Label' => 'Naam',
	'Location' => 'Locatie',
	'Missing File' => 'Ontbrekend bestand',
	'Name' => 'Naam',
	'No Label' => 'Geen label',
	'Pixel Height' => 'Hoogte in pixels',
	'Pixel Width' => 'Breedte in pixels',
	'URL' => 'URL',
	'Video' => 'Video',
	'extant' => 'bestaand',
	'missing' => 'ontbrekend',
	q{Assets in [_1] field of [_2] '[_4]' (ID:[_3])} => q{Mediabestanden in [_1] veld van [_2] '[_4]' (ID:[_3])},

## lib/MT/Asset/Audio.pm
	'audio' => 'audio',

## lib/MT/Asset/Image.pm
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Actual Dimensions' => 'Echte afmetingen',
	'Cannot load image #[_1]' => 'Kan afbeelding niet laden #[_1]',
	'Cropping image failed: Invalid parameter.' => 'Bijsnijden van de afbeelding mislukt: ongeldige parameter.',
	'Error converting image: [_1]' => 'Fout bij conversie afbeelding: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fout bij het aanmaken van een thumbnail-bestand: [_1]',
	'Error cropping image: [_1]' => 'Fout bij het bijsnijden van de afbeelding: [_1]',
	'Error scaling image: [_1]' => 'Fout bij het schalen van de afbeelding: [_1]',
	'Extracting image metadata failed: [_1]' => 'Extractie van metadata uit de afbeelding mislukt: [_1]',
	'Images' => 'Afbeeldingen',
	'Popup page for [_1]' => 'Popup pagina voor [_1]',
	'Rotating image failed: Invalid parameter.' => 'Draaien van de afbeelding mislukt: ongeldige parameter.',
	'Scaling image failed: Invalid parameter.' => 'Schalen van de afbeelding mislukt: ongeldige parameter.',
	'Thumbnail image for [_1]' => 'Miniatuurweergave voor [_1]',
	'Writing image metadata failed: [_1]' => 'Schrijven van metadata van de afbeelding mislukt: [_1]',
	'Writing metadata failed: [_1]' => 'Schrijven van metadata mislukt: [_1]',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	q{Error writing metadata to '[_1]': [_2]} => q{Fout bij schrijven van metadata naar  '[_1]': [_2]},
	q{Error writing to '[_1]': [_2]} => q{Fout bij schrijven naar '[_1]': [_2]},
	q{Invalid basename '[_1]'} => q{Ongeldige basisnaam '[_1]'},

## lib/MT/Asset/Video.pm
	'video' => 'video',
	q{Videos} => q{Video's},

## lib/MT/Association.pm
	'Association' => 'Associatie',
	'Group' => 'Groep',
	'Permissions for Groups' => 'Permissies voor groepen',
	'Permissions for Users' => 'Permissies voor gebruikers',
	'Permissions for [_1]' => 'Permissies voor [_1]',
	'Permissions of group: [_1]' => 'Permissies van groep: [_1]',
	'Permissions with role: [_1]' => 'Permissies met rol: [_1]',
	'Role Detail' => 'Details rol',
	'Role Name' => 'Naam rol',
	'Role' => 'Rol',
	'Site Name' => 'Sitenaam',
	'User is [_1]' => 'Gebruiker is [_1]',
	'User/Group Name' => 'Naam gebruiker/groep',
	'User/Group' => 'Gebruiker/groep',
	'association' => 'associatie',
	'associations' => 'associaties',

## lib/MT/AtomServer.pm
	'Invalid image file format.' => 'Ongeldig afbeeldingsbestandsformaat',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Perl module Image::Size is vereist om de hoogte en breedte te kunnen bepalen van geuploade bestanden.',
	'PreSave failed [_1]' => 'PreSave mislukt [_1]',
	'Removing stats cache failed.' => 'Verwijderen statistiekencache mislukt.',
	'[_1]: Entries' => '[_1]: Berichten',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]' heeft volgens systeeminstellingen geen toelating om te uploaden.: [_2]},
	q{Cannot make path '[_1]': [_2]} => q{Kan pad '[_1]' niet aanmaken: [_2]},
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{Bericht '[_1]' ([lc,_5] #[_2]) verwijderd door '[_3]' (gebruiker #[_4]) via de ATOM API},
	q{Invalid blog ID '[_1]'} => q{Ongeldig blog ID '[_1]'},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{Gebruiker '[_1]' (gebruiker #[_2]) voegde [lc,_4] #[_3] toe},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{Gebruiker '[_1]' (gebruiker #[_2]) bewerkte [lc,_4] #[_3]},

## lib/MT/Auth.pm
	'Bad AuthenticationModule config' => 'Foute AuthenticationModule configuratie',
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{Foute AuthenticationModule configuratie '[_1]': [_2]},

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => 'Verificatie van het huidige wachtwoord mislukt.',
	'Missing required module' => 'Vereiste module ontbreekt',
	'Password contains invalid character.' => 'Wachtwoord bevat ongeldig karakter.',

## lib/MT/Author.pm
	'Active' => 'Actief',
	'Commenters' => 'Reageerders',
	'Content Data Count' => 'Aantal inhoudsgegevens',
	'Created by' => 'Aangemaakt door',
	'Disabled Users' => 'Uitgeschakelde gebruikers',
	'Enabled Users' => 'Ingeschakelde gebruikers',
	'Locked Out' => 'Geblokkeerd',
	'Locked out Users' => 'Geblokkeerde gebruikers',
	'Lockout' => 'Blokkering',
	'MT Native Users' => 'Lokale MT gebruikers',
	'MT Users' => 'MT gebruikers',
	'Not Locked Out' => 'Niet geblokkeerd',
	'Pending Users' => 'Te keuren gebruikers',
	'Pending' => 'In afwachting',
	'Privilege' => 'Privilege',
	'Registered User' => 'Geregistreerde gebruiker',
	'Status' => 'Status',
	'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden opgeslagen: [_1]',
	'User Info' => 'Gebruikersinformatie',
	'Userpic' => 'Foto gebruiker',
	'Website URL' => 'URL website',
	'__ENTRY_COUNT' => 'Berichten',
	'userpic-[_1]-%wx%h%x' => 'gebruikersafbeelding-[_1]-%wx%h%x',

## lib/MT/BackupRestore.pm
	'Cannot open [_1].' => 'Kan [_1] niet openen.',
	'Copying [_1] to [_2]...' => 'Bezig [_1] te copiëren naar [_2]...',
	'Exporting [_1] records:' => 'Bezig [_1] records te exporteren:',
	'Failed: ' => 'Mislukt: ',
	'ID for the file was not set.' => 'ID van het bestand was niet ingesteld.',
	'Importing asset associations ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren...',
	'Importing asset associations in entry ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren voor bericht... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren voor pagina... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'Bezig inhoudsgegevens te importeren... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'Bezig url van de mediabestanden te importeren ( [_1] )...',
	'Importing url of the assets in entry ( [_1] )...' => 'Bezig de mediabestanden te importeren in bericht ( [_1] )...',
	'Importing url of the assets in page ( [_1] )...' => 'Bezig de mediabestanden te importeren in pagina ( [_1] )...',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-bestand [_1] was geen geldig Movable Type backup manifest-bestand.',
	'Manifest file: [_1]' => 'Manifestbestand: [_1]',
	'No manifest file could be found in your import directory [_1].' => 'Er werd geen manifest-bestand gevonden in de importdirectory [_1].',
	'Path was not found for the file, [_1].' => 'Pad niet gevonden voor bestand, [_1]',
	'Rebuilding permissions ... ( [_1] )' => 'Bezig permissies opnieuw op te bouwen ... ( [_1] )',
	'The file ([_1]) was not imported.' => 'Het bestand ([_]) werd niet geïmporteerd.',
	'There were no [_1] records to be exported.' => 'Er waren geen [_1] records om te exporteren.',
	'[_1] is not writable.' => '[_1] is niet beschrijfbaar.',
	'[_1] records exported.' => '[_1] records geëxporteerd.',
	'[_1] records exported...' => '[_1] recordt geëxporteerd...',
	'failed' => 'mislukt',
	'ok' => 'ok',
	qq{\nCannot write file. Disk full.} => qq{Kan bestand niet schrijven.  Schijf vol.},
	q{Cannot open directory '[_1]': [_2]} => q{Kan map '[_1]' niet openen: [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{Pad voor bestand '[_1]' (ID:[_2]) wordt aangepast...},
	q{Error making path '[_1]': [_2]} => q{Fout bij aanmaken pad '[_1]': [_2]},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Een gebruiker met dezelfde naam als de huidige gebruiker ([_1]) werd gevonden in het exportbestand.  Deze gebruiker wordt overgeslagen.',
	'Importing [_1] records:' => 'Bezig [_1] records te importeren:',
	'Invalid serializer version was specified.' => 'Ongeldige serialisatieverie opgegeven.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'Het export manifestbestand dat werd geupload werd aangemaakt met Movable Type maar de schemaversie ([_1]) verschilt van die gebruikt op dit systeem ([_2]). Dit exportbestand is niet geschikt voor deze versie van Movable Type.',
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'Het bestand dat werd geupload was geen geldig Movable Type manifest exportbestand.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] is geen onderwerp om te importeren in Movable Type.',
	'[_1] records imported.' => '[_1] records geïmporteerd',
	'[_1] records imported...' => '[_1] records geïmporteerd...',
	q{A user with the same name '[_1]' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.} => q{Een gebruiker met dezelfde naam '[_1]' werd gevonden in het exportbestand (ID:[_2]).  Tijdens het importeren werd deze gebruiker overschreven met de gegevens uit het importbestand.},
	q{Tag '[_1]' exists in the system.} => q{Tag '[_1]' bestaat in het systeem.},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{De rol '[_1]' werd hernoemd naar '[_2]' omdat een rol met die naam al bestond.},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{De instellingen op systeemniveau voor plugin '[_1]' bestaan al.  Record wordt overgeslagen.},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'Kan het gevraagde bestand niet importeren omdat er geen site werd gevonden in het bestaande Movable Type systeem of in de exportgegevens.  Er moet eerst een site aangemaakt worden.',
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Kan het gevraagde bestand niet importeren omdat hiervoor de Digest::SHA Perl module vereist is.  Contacteer uw Movable Type systeembeheerder.',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Blog.pm
	'*Site/Child Site deleted*' => 'Site/subsite verwijderd',
	'Child Sites' => 'Subsites',
	'Clone of [_1]' => 'Kloon van [_1]',
	'Cloned child site... new id is [_1].' => 'Subsite gekloond... nieuw id is [_1]',
	'Cloning associations for blog:' => 'Associaties worden gekloond voor blog:',
	'Cloning categories for blog...' => 'Categorieën worden gekloond voor blog...',
	'Cloning entry placements for blog...' => 'Berichtcategorieën wordt gekloond voor blog...',
	'Cloning entry tags for blog...' => 'Berichttags worden gekloond voor blog...',
	'Cloning permissions for blog:' => 'Permissies worden gekloond voor blog:',
	'Cloning template maps for blog...' => 'Sjabloonkoppelingen worden gekloond voor blog...',
	'Cloning templates for blog...' => 'Sjablonen worden gekloond voor blog...',
	'Content Type Count' => 'Aantal inhoudstypes',
	'Content Type' => 'Inhoudstype',
	'Failed to apply theme [_1]: [_2]' => 'Toepassen van thema [_1] mislukt: [_2]',
	'Failed to load theme [_1]: [_2]' => 'Laden van thema [_1] mislukt: [_2]',
	'First Blog' => 'Eerste weblog',
	'No default templates were found.' => 'Er werden geen standaardsjablonen gevonden.',
	'Parent Site' => 'Hoofdsite',
	'Theme' => 'Thema',
	'__ASSET_COUNT' => 'Mediabestanden',
	q{Cloning entries and pages for blog...} => q{Berichten en pagina's worden gekloond voor blog...},
	q{Invalid archive_type '[_1]' in Archive Mapping '[_2]'} => q{Ongeldig archive_type '[_1]' in archiefmapping '[_2]'},
	q{Invalid category_field '[_1]' in Archive Mapping '[_2]'} => q{Ongeldig category_field '[_1]' in archiefmapping '[_2]'},
	q{Invalid datetime_field '[_1]' in Archive Mapping '[_2]'} => q{Ongeldig datetime_veld '[_1]' in archiefmapping '[_2]'},
	q{__PAGE_COUNT} => q{Pagina's},
	q{archive_type is needed in Archive Mapping '[_1]'} => q{archive_type vereist in archiefmapping '[_|]'},
	q{category_field is required in Archive Mapping '[_1]'} => q{category_field is vereist in archiefmapping '[_1]'},

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Er deed zich een fout voor: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> op regel [_2] is niet herkend',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> zonder </[_1]> op regel #',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> zonder </[_1]> op regel [_2]',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> zonder </[_1]> op regel [_2].',
	'Error in <mt[_1]> tag: [_2]' => 'Fout in <mt[_1]> tag: [_2]',
	'Unknown tag found: [_1]' => 'Onbekende tag gevonden: [_1]',

## lib/MT/CMS/AddressBook.pm
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Fout bij versturen mail ([_1]): een andere MailTransfer instelling proberen?',
	'No entry ID was provided' => 'Geen bericht ID opgegeven',
	'No valid recipients were found for the entry notification.' => 'Geen geldige ontvangers gevonden voor notificatie bericht.',
	'Please select a blog.' => 'Gelieve een blog te selecteren.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Het e-mail adres dat u opgaf staat al op de notificatielijst van deze weblog.',
	'The text you entered is not a valid URL.' => 'De tekst die u invulde is geen geldige URL.',
	'The text you entered is not a valid email address.' => 'De tekst die u invul is geen geldig email adres.',
	'[_1] Update: [_2]' => '[_1] update: [_2]',
	q{No such entry '[_1]'} => q{Geen bericht '[_1]'},
	q{Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'} => q{Abonnee '[_1]' (ID:[_2]) verwijderd uit adresboek door '[_3]'},

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(gebruiker verwijderd)',
	'<[_1] Root>' => '<[_1] Root>',
	'<[_1] Root>/[_2]' => '<[_1] Root>/[_2]',
	'Archive' => 'Archief',
	'Cannot load asset #[_1]' => 'Kan mediabestand #[_1] niet laden',
	'Cannot load asset #[_1].' => 'Kan mediabestand #[_1] niet laden.',
	'Cannot load file #[_1].' => 'Kan bestand niet laden #[_1].',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Kan geen bestaand bestand overschrijven met een bestand van een ander type.  Origineel: [_1] Geupload: [_2]',
	'Custom...' => 'Gepersonaliseerd...',
	'Extension changed from [_1] to [_2]' => 'Extensie veranderd van [_1] in [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Aanmaken thumbnailbestand mislukt omdat [_1] dit afbeeldingstype niet aankan.',
	'Files' => 'Bestanden',
	'Invalid Request.' => 'Ongeldig verzoek.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type kon niet schrijven naar de "Upload bestemming".  Controleer of de webserver schrijfrechten heeft op deze map.',
	'No permissions' => 'Geen permissies',
	'Please select a video to upload.' => 'Gelieve een videobestand te selecteren om te uploaden.',
	'Please select an audio file to upload.' => 'Gelieve een audiobestand te selecteren om te uploaden.',
	'Please select an image to upload.' => 'Gelieve een afbeelding te selecteren om te uploaden.',
	'Saving object failed: [_1]' => 'Object opslaan mislukt: [_1]',
	'Transforming image failed: [_1]' => 'Transformeren afbeelding mislukt: [_1]',
	'Untitled' => 'Zonder titel',
	'Upload Asset' => 'Mediabestand uploaden',
	'Uploaded file is not an image.' => 'Geupload bestand is geen afbeelding.',
	'basename of user' => 'basisnaam van gebruiker',
	'none' => 'geen',
	'unassigned' => 'niet toegewezen',
	q{Could not create upload path '[_1]': [_2]} => q{Kon geen upload pad '[_1]' aanmaken: [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{Fout bij aanmaken tijdelijk bestand; De webserver zou moeten kunnen schrijven naar deze map.  Controleer de TempDir instelling in uw configuratiebestand, het is momenteel '[_1]'.},
	q{Error deleting '[_1]': [_2]} => q{Fout bij wissen van '[_1]': [_2]},
	q{Error opening '[_1]': [_2]} => q{Fout bij openen van '[_1]': [_2]},
	q{Error writing upload to '[_1]': [_2]} => q{Fout bij schrijven van upload naar '[_1]': [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Bestand '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{File '[_1]' uploaded by '[_2]'} => q{Bestand '[_1]' opgeladen door '[_2]'},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{Bestand met de naam '[_1]' bestaat al.  (Installeer de File::Temp perl module als u bestaande geuploade bestanden wenst te kunnen overschrijven.)},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{Bestand met de naam '[_1]' bestaat al. Upload geannuleerd.},
	q{File with name '[_1]' already exists.} => q{Bestand met de naam '[_1]' bestaat al.},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{Bestand met de naam '[_1]' bestaat al; Probeerde een tijdelijk bestand te schrijven maar de webserver kon het niet openen: [_2]},
	q{Invalid extra path '[_1]'} => q{Ongeldig extra pad '[_1]'},
	q{Invalid filename '[_1]'} => q{Ongeldige bestandsnaam '[_1]'},
	q{Invalid temp file name '[_1]'} => q{Ongeldige naam voor temp bestand '[_1]'},

## lib/MT/CMS/Blog.pm
	'(no name)' => '(geen naam)',
	'Archive URL must be an absolute URL.' => 'Archief URL moet een absolute URL zijn.',
	'Blog Root' => 'Blogroot',
	'Cannot load content data #[_1].' => 'Kon inhoudsgegevens niet laden #[_1].',
	'Cannot load template #[_1].' => 'Kan sjabloon #[_1] niet laden.',
	'Compose Settings' => 'Instellingen voor opstellen',
	'Create Child Site' => 'Subsite aanmaken',
	'Enter a site name to filter the choices below.' => 'Vul de naam van een site in om de keuzes hieronder te filteren.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Berichten moeten worden gekloond als reacties en trackbacs gekloond worden',
	'Entries must be cloned if comments are cloned' => 'Berichten moeten worden gekloond als reacties gekloond worden',
	'Entries must be cloned if trackbacks are cloned' => 'Berichten moeten worden gekloond als trackbacks gekloond worden',
	'Error' => 'Fout',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kan niet schrijven in de sjablooncache map. Gelieve de permissies na te kijken van de map met de naam <code>[_1]</code> onder de map van uw weblog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kon geen map maken om uw dynamische sjablonen in te cachen. U moet een map aanmaken met de naam <code>[_1]</code> onder de map van uw weblog.',
	'Feedback Settings' => 'Feedback instellingen',
	'Finished!' => 'Klaar!',
	'General Settings' => 'Algemene instellingen',
	'Invalid blog_id' => 'Ongeldig blog_id',
	'No blog was selected to clone.' => 'U selecteerde geen blog om te klonen.',
	'Please choose a preferred archive type.' => 'Gelieve een voorkeursarchieftype te kiezen.',
	'Plugin Settings' => 'Instellingen plugins',
	'Publish Site' => 'Site publiceren',
	'Registration Settings' => 'Registratie-instellingen',
	'Saved [_1] Changes' => '[_1] wijzigingen opgeslagen',
	'Saving blog failed: [_1]' => 'Blog opslaan mislukt: [_1]',
	'Select Child Site' => 'Selecteer subsite',
	'Selected Child Site' => 'Geselecteerde subsite',
	'Site URL must be an absolute URL.' => 'Site URL moet eenn absolute URL zijn.',
	'The number of revisions to store must be a positive integer.' => 'Het aantal revisies dat moet worden bewaard moet een positieve integer zijn.',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Deze instellingen worden overroepen door een instelling het het MT configuratiebestand: [_1].  Verwijder de waarde uit het configuratiebestand om deze hier te kunnen beheren.',
	'This action can only be run on a single blog at a time.' => 'Deze actie kan maar op één blog tegelijk worden uitgevoerd.',
	'This action cannot clone website.' => 'Deze actie kan geen website klonen.',
	'Website Root' => 'Website root',
	'You did not specify a blog name.' => 'U gaf geen weblognaam op.',
	'You did not specify an Archive Root.' => 'U gaf geen archiefroot op.',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'[_1] changed from [_2] to [_3]' => '[_1] veranderd van [_2] naar [_3]',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{'[_1]' (ID:[_2]) werd gekopiëerd als '[_3]' (ID:[_4]) door '[_5]' (ID:[_6]).},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Blog '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{Cloning child site '[_1]'...} => q{Bezig subsite '[_1]' te klonen...},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{De '[_1]' die hieronder is opgegeven is niet beschrijfbaar door de webserver.  Wijzig de eigenaar van de map of de permissies en probeer opnieuw.},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_1] '[_2]' (ID:[_3]) aangemaakt door '[_4]'},
	q{[_1] '[_2]'} => q{[_1] '[_2]'},
	q{index template '[_1]'} => q{indexsjabloon '[_1]'},

## lib/MT/CMS/Category.pm
	'Category Set' => 'Categorieset',
	'Create Category Set' => 'Categoriesete aanmaken',
	'Create [_1]' => '[_1] aanmaken',
	'Edit [_1]' => '[_1] bewerken',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Kon [_1] niet bijwerken: Sommige [_2] werden gewijzigd sinds u deze pagina opende.',
	'Invalid category_set_id: [_1]' => 'Ongeldige category_set_id: [_1]',
	'Manage [_1]' => '[_1] beheren',
	'The [_1] must be given a name!' => 'De [_1] moet nog een naam krijgen!',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Probeerde [_1]([_2]) bij te werken, maar het object werd niet gevonden.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Uw wijzigingen werden aangebracht ([_1] toegevoegd, [_2] aangepast en [_3] verwijderd). <a href="#" onclick="[_4]" class="mt-rebuild">Publiceer uw site</a> om deze wijzigingen zichtbaar te maken.',
	'category_set' => 'Categorieset',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Categorie '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{Categorie '[_1]' (ID:[_2]) bewerkt door '[_3]'},
	q{Category '[_1]' created by '[_2]'.} => q{Categorie '[_1]' aangemaakt door '[_2]'.},
	q{Category Set '[_1]' (ID:[_2]) edited by '[_3]'} => q{Categorieset '[_1]' (ID:[_2]) bewerkt door '[_3]'},
	q{Category Set '[_1]' created by '[_2]'.} => q{Categorieset '[_1]' aangemaakt door '[_2]'.},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{Categoriebasisnaam '[_1]' conflicteert met de basisnaam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke basisnaam hebben.},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Categorienaam '[_1]' conflicteert met een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{Categorienaam '[_1]' conflicteert met de naam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.},
	q{The name '[_1]' is too long!} => q{De naam '[_1]' is te lang!},
	q{[_1] order has been edited by '[_2]'.} => q{_1] volgorde werd aangepast door '[_2]'.},

## lib/MT/CMS/CategorySet.pm
	q{Category Set '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Categorieset '[_1]' (ID:[_2]) verwijderd door '[_3]'},

## lib/MT/CMS/Common.pm
	'All [_1]' => 'Alle [_1]',
	'An error occurred while counting objects: [_1]' => 'Er deed zich een fout voor bij het tellen van de objecten: [_1]',
	'An error occurred while loading objects: [_1]' => 'Er deed zich een fout voor bij het laden van de objecten: [_1]',
	'Error occurred during permission check: [_1]' => 'Er deed zich een fout voor bij het controleren van de permissies: [_1]',
	'Invalid ID [_1]' => 'Ongeldig ID [_1]',
	'Invalid filter terms: [_1]' => 'Ongeldige filtertermen: [_1]',
	'Invalid filter: [_1]' => 'Ongeldige filter: [_1]',
	'Invalid type [_1]' => 'Ongeldig type [_1]',
	'New Filter' => 'Nieuwe Filter',
	'Removing tag failed: [_1]' => 'Tag verwijderen mislukt: [_1]',
	'Saving snapshot failed: [_1]' => 'Snapshot opslaan mislukt: [_1]',
	'System templates cannot be deleted.' => 'Systeemsjablonen kunnen niet worden verwijderd.',
	'The Template Name and Output File fields are required.' => 'De velden sjabloonnaam en uitvoerbestand zijn verplicht.',
	'The blog root directory must be within [_1].' => 'De hoofdmap van de blog moet onder [_1] zitten.',
	'The selected [_1] has been deleted from the database.' => 'Geselecteerde [_1] werd verwijderd uit de database.',
	'The website root directory must be within [_1].' => 'De hoofdmap van de website moet onder [_1] zitten.',
	'Unknown list type' => 'Onbekend type lijst',
	'Web Services Settings' => 'Instellingen webservices',
	'[_1] Feed' => '[_1] Feed',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => '[_1] beschadigde revisies van [_2] (id: [_3]) zijn verwijderd.',
	'__SELECT_FILTER_VERB' => 'is gelijk aan',
	q{'[_1]' edited the global template '[_2]'} => q{'[_1]' bewerkte het globale sjabloon '[_2]'},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{'[_1]' bewerkte het sjabloon '[_2]' op blog '[_3]'},

## lib/MT/CMS/ContentData.pm
	'(No Label)' => '(Geen label)',
	'(untitled)' => '(zonder titel)',
	'Cannot load content field (UniqueID:[_1]).' => 'Kan inhoudsveld niet laden (UniqueID:[_1])',
	'Cannot load content_type #[_1]' => 'Kan content_type #[_1] niet laden',
	'Create new [_1]' => 'Nieuwe [_1] aanmaken',
	'Need a status to update content data' => 'Status vereist om inhoudsgegevens bij te werken',
	'Need content data to update status' => 'Inhoudsgegevens vereist om status bij te werken',
	'New [_1]' => 'Nieuwe [_1]',
	'No Label (ID:[_1])' => 'Geen Label (ID:[_1])',
	'One of the content data ([_1]) did not exist' => 'Bepaalde inhoudsgegevens ([_1]) bestonden nog niet',
	'Publish error: [_1]' => 'Publicatiefout: [_1]',
	'The value of [_1] is automatically used as a data label.' => 'De waarde van [_1] wordt automatisch gebruikt als datalabel.',
	'Unable to create preview files in this location: [_1]' => 'Kan geen voorbeeldbestanden aanmaken in deze locatie: [_1]',
	'Unpublish Contents' => 'Publicatie inhoud ongedaan maken',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is nog geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren voor deze zijn ingesteld.',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => '[_1] (ID:[_2]) status aangepast van [_3] naar [_4]',
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ongeldige datum '[_1]'; 'Gepubliceerd op' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ongeldige datum '[_1]'; 'Publicatie ongedaan op' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{Ongeldige datum '[_1]'; 'Publicatie ongedaan op' datums moeten in de toekomst liggen.},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{Ongeldige datum '[_1]'; 'Publicatie ongedaan op' datums moeten later zijn dan de corresponderende 'Gepubliceerd op' datum.},
	q{New [_1] '[_4]' (ID:[_2]) added by user '[_3]'} => q{Nieuwe [_1] '[_4]' (ID:[_2]) toegevoegd door gebruiker '[_3]'},
	q{[_1] '[_4]' (ID:[_2]) deleted by '[_3]'} => q{[_1] '[_4]' (ID:[_2]) verwijderd door '[_3]'},
	q{[_1] '[_4]' (ID:[_2]) edited by user '[_3]'} => q{[_1] '[_4]' (ID:[_2]) bewerkt door gebruiker '[_3]'},
	q{[_1] '[_6]' (ID:[_2]) edited and its status changed from [_3] to [_4] by user '[_5]'} => q{[_1] '[_6]' (ID:[_2]) bewerkt en status aangepast van [_3] naar [_4] door gebruiker '[_5]'},

## lib/MT/CMS/ContentType.pm
	'Cannot load content field data (ID: [_1])' => 'Kan gegevens inhoudsveld niet laden (ID: [_1])',
	'Cannot load content type #[_1]' => 'Kan inhoudstype niet laden #[_1]',
	'Content Type Boilerplates' => 'Standaardteksten inhoudstypes',
	'Create Content Type' => 'Inhoudstype aanmaken',
	'Create new content type' => 'Nieuw inhoudstype aanmaken',
	'Manage Content Type Boilerplates' => 'Standaardteksten inhoudstypes beheren',
	'Saving content field failed: [_1]' => 'Inhoudsveld opslaan mislukt: [_1]',
	'Saving content type failed: [_1]' => 'Inhoudstype opslaan mislukt: [_1]',
	'Some content fields were deleted: ([_1])' => 'Een aantal inhoudsvelden werden verwijderd: ([_1])',
	'The content type name is required.' => 'Naam vereist voor inhoudstype',
	'The content type name must be shorter than 255 characters.' => 'De naam voor het inhoudstype moet korter zijn dan 255 karakters.',
	'content_type' => 'Inhoudstype',
	q{A content field '[_1]' ([_2]) was added} => q{Een inhoudsveld '[_1]' ([_2]) werd toegevoegd},
	q{A content field options of '[_1]' ([_2]) was changed} => q{Opties van inhoudsveld '[_1]' ([_2]) werden angepast},
	q{A description for content field of '[_1]' should be shorter than 255 characters.} => q{Een beschrijving voor inhoudsvel van '[_1]' moet korter zijn dan 255 karakters.},
	q{A label for content field of '[_1]' is required.} => q{Een label is vereist voor inhoudsveld van '[_1]'.},
	q{A label for content field of '[_1]' should be shorter than 255 characters.} => q{Een label voor inhoudsveld van '[_1]' moet korter zijn dan 255 karakters.},
	q{Content Type '[_1]' (ID:[_2]) added by user '[_3]'} => q{Inhoudstype '[_1]' (ID:[_2]) toegevoegd door gebruiker '[_3]'},
	q{Content Type '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Inhoudstype '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{Content Type '[_1]' (ID:[_2]) edited by user '[_3]'} => q{Inhoudstype '[_1]' (ID:[_2]) bewerkt door gebruiker '[_3]'},
	q{Field '[_1]' and '[_2]' must not coexist within the same content type.} => q{}, # Translate - New
	q{Field '[_1]' must be unique in this content type.} => q{}, # Translate - New
	q{Name '[_1]' is already used.} => q{Naam '[_1]' is reeds in gebruik.},

## lib/MT/CMS/Dashboard.pm
	'Can verify SSL certificate, but verification is disabled.' => 'Kan SSL certificaat controleren maar verificatie is uitgeschakeld.',
	'Cannot verify SSL certificate.' => 'Kan SSL certificaat niet verifiëren.',
	'Error: This child site does not have a parent site.' => 'Fout: deze subsite heeft geen hoofdsite.',
	'ImageDriver is not configured.' => 'ImageDriver is niet geconfigureerd',
	'Not configured' => 'Niet geconfigureerd',
	'Page Views' => 'pageviews',
	'Please contact your Movable Type system administrator.' => 'Neem contact op met uw Movable Type syteembeheerder.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Gelieve de Mozilla::CA module te installeren.  De regel "SSLVerifyNone 1" aan mt-config.cgi toevoegen kan deze waarschuwing verbergen maar wordt niet aangeraden',
	'System' => 'Systeem',
	'The support directory is not writable.' => 'Support map is niet beschrijfbaar',
	'Unknown Content Type' => 'Onbekend inhoudstype',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'U verwijdert best de regel "SSLVerifyNone 1" uit mt-config.cgi.',
	q{An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.} => q{Een toolkit om afbeeldingen te bewerken, iets wat meestal via de ImageDriver configuratie-directief wordt ingesteld, is niet aanwezig op uw server of verkeerd geconfigureerd.  Zo'n toolkit is nodig om gebruikersafbeeldingen te kunnen herschalen e.d.  Gelieve Graphics::Magick, Image::Magick, NetPBM, GD, of Imager te installeren op de server en stel dan de ImageDriver directief overeenkomstig in.},
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type was niet in staat om te schrijven in de 'support' map.  Gelieve een map aan te maken in deze locatie: [_1] en er genoeg permissies aan toe te kennen zodat de webserver er in kan schrijven.},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{Het systeem email adres wordt gebruikt in de 'From:' header van elke mail verzonden door Movable Type.  Mails kunnen verstuurd worden om wachtwoorden terug te vinden, reageerders te registreren, te informeren over nieuwe reacties of trackbacks, in geval van het blokkeren van een gebruiker of IP en in een paar andere gevallen.  Gelieve uw <a href="[_1]">instellingen</a> te bevestigen.},

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(gebruiker verwijderd - ID:[_1])',
	'/' => '/',
	'Need a status to update entries' => 'Status vereist om berichten bij te werken',
	'Need entries to update status' => 'Berichten nodig om status bij te werken',
	'New Entry' => 'Nieuw bericht',
	'New Page' => 'Nieuwe pagina',
	'No such [_1].' => 'Geen [_1].',
	'One of the entries ([_1]) did not exist' => 'Een van de berichten ([_1]) bestond niet',
	'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
	'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
	'This basename has already been used. You should use an unique basename.' => 'Deze basisnaam werd al gebruikt.  U moet een unieke basisnaam kiezen.',
	'authored on' => 'geschreven op',
	'modified on' => 'gewijzigd op',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">QuickPost op [_2]</a> - Sleep deze link naar de werkbalk van uw browser en klik er op wanneer u een site bezoekt waar u over wil bloggen.},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{Ongeldige datum '[_1]\; Publicatiedatums moeten vallen voor de corresponderende 'Einddatum' '[_2]'.},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ongeldige datum '[_1]'; [_2] datums moeten volgend formaat hebben JJJJ-MM-DD UU:MM:SS.},
	q{Saving entry '[_1]' failed: [_2]} => q{Bericht '[_1]' opslaan mislukt: [_2]},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_1] '[_2]' (ID:[_3]) bewerkt en status aangepast van [_4] naar [_5] door gebruiker '[_6]'},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_1] '[_2]' (ID:[_3]) bewerkt door gebruiker '[_4]'},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{[_1] '[_2]' (ID:[_3]) status veranderd van [_4] naar [_5]},

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Berichten site exporteren',
	'Please select a site.' => 'Gelieve een site te selecteren.',
	'You do not have export permissions' => 'U heeft geen exportpermissies',
	q{Loading site '[_1]' failed: [_2]} => q{Laden van site '[_1]' mislukt: [_2]},

## lib/MT/CMS/Filter.pm
	'(Legacy) ' => '(Verouderd)',
	'Failed to delete filter(s): [_1]' => 'Filter(s) verwijderen mislukt: [_1]',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Filter opslaan mislukt: Label "[_1]" bestaat al.',
	'Failed to save filter: Label is required.' => 'Filter opslaan mislukt: Label is vereist',
	'Failed to save filter: [_1]' => 'Filter opslaan mislukt: [_1]',
	'No such filter' => 'Onbestaande filter',
	'Permission denied' => 'Toestemming geweigerd',
	'Removed [_1] filters successfully.' => 'Met succes [_1] filters verwijderd.',
	'[_1] ( created by [_2] )' => '[_1] ( aangemaakt door [_2] )',

## lib/MT/CMS/Folder.pm
	q{Folder '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Map '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{Folder '[_1]' (ID:[_2]) edited by '[_3]'} => q{Map '[_1]' (ID:[_2]) bewerkt door '[_3]'},
	q{Folder '[_1]' created by '[_2]'} => q{Map '[_1]' aangemaakt door '[_2]'},
	q{The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.} => q{De map '[_1]' conflicteert met een andere map. Mappen met dezelfde ouder moeten een unieke basisnaam hebben.},

## lib/MT/CMS/Group.pm
	'Add Users to Groups' => 'Gebruikers toevoegen aan groepen',
	'Author load failed: [_1]' => 'Laden auteur mislukt: [_1]',
	'Create Group' => 'Groep aanmaken',
	'Each group must have a name.' => 'Elke groep moet een naam hebben',
	'Group Name' => 'Groepsnaam',
	'Group load failed: [_1]' => 'Laden groep mislukt: [_1]',
	'Groups Selected' => 'Geselecteerde groepen',
	'Search Groups' => 'Groepen zoeken',
	'Search Users' => 'Gebruikers zoeken',
	'Select Groups' => 'Selecteer groepen',
	'Select Users' => 'Gebruikers selecteren',
	'User load failed: [_1]' => 'Laden gebruiker mislukt: [_1]',
	'Users Selected' => 'Gebruikers geselecteerd',
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{Gebruiker '[_1]' (ID:[_2]) verwijderd uit groep '[_3]' (ID:[_4]) door '[_5]'},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{Gebruiker '[_1]' (ID:[_2]) toegevoegd aan groep '[_3]' (ID:[_4]) door '[_5]'},

## lib/MT/CMS/Import.pm
	'Import Site Entries' => 'Berichten site importeren',
	'Importer type [_1] was not found.' => 'Importeertype [_1] niet gevonden.',
	'You do not have import permission' => 'U heeft geen import-permissie',
	'You do not have permission to create users' => 'U heeft geen permissie om gebruikers aan te maken',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker vernoemd in uw site.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Alle feedback',
	'Publishing' => 'Publicatie',
	'System Activity Feed' => 'Systeemactiviteit-feed',
	q{Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{Activiteitenlog van blog '[_1]' (ID:[_2]) leeggemaakt door '[_3]'},
	q{Activity log reset by '[_1]'} => q{Activiteitenlog leeggemaakt door '[_1]'},

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Fout bij opslaan plugin-instellingen: [_1]',
	'Individual Plugins' => 'Individuele plugins',
	'Plugin Set: [_1]' => 'Pluginset: [_1]',
	'Plugin' => 'Plugin',
	'Plugins are disabled by [_1]' => '', # Translate - New
	'Plugins are enabled by [_1]' => '', # Translate - New
	q{Plugin '[_1]' is disabled by [_2]} => q{}, # Translate - New
	q{Plugin '[_1]' is enabled by [_2]} => q{}, # Translate - New

## lib/MT/CMS/RebuildTrigger.pm
	'(All child sites in this site)' => '(Alle subsites onder deze site)',
	'(All sites and child sites in this system)' => '(Alle sites en subsites in dit systeem)',
	'Comment' => 'Reactie',
	'Create Rebuild Trigger' => 'Rebuild-trigger aanmaken',
	'Entry/Page' => 'Bericht/pagina',
	'Format Error: Trigger data include illegal characters.' => 'Formaatfout: Triggergegevens bevatten illegale tekens.',
	'Save' => 'Opslaan',
	'Search Content Type' => 'Inhoudstype zoeken',
	'Search Sites and Child Sites' => 'Sites en subsites doorzoeken',
	'Select Content Type' => 'Selecteer inhoudstype',
	'Select Site' => 'Selecteer site',
	'Select to apply this trigger to all child sites in this site.' => 'Selecteer dit om deze trigger toe te passen voor alle subsites onder deze site.',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Selecteer dit om deze trigger toe te passen op alle sites en subsites in dit systeem.',
	'TrackBack' => 'TrackBack',
	'__UNPUBLISHED' => 'Publicatie ongedaan maken',
	'rebuild indexes and send pings.' => 'indexen opnieuw opbouwt en pings verstuurt.',
	'rebuild indexes.' => 'indexen opnieuw opbouwt.',
	q{Format Error: Comma-separated-values contains wrong number of fields.} => q{Door komma's gescheiden waarden bevat een verkeerd aantal velden.},

## lib/MT/CMS/Search.pm
	'"[_1]" field is required.' => '"[_1]" veld is vereist',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" is ongeldig voor "[_2]" veld van "[_3]" (ID:[_4]): [_5]',
	'Basename' => 'Basisnaam',
	'Data Label' => 'Data label',
	'Entry Body' => 'Berichttekst',
	'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
	'Excerpt' => 'Uittreksel',
	'Extended Entry' => 'Uitgebreid bericht',
	'Extended Page' => 'Uitgebreide pagina',
	'IP Address' => 'IP adres',
	'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
	'Keywords' => 'Trefwoorden',
	'Linked Filename' => 'Naam gelinkt bestand',
	'Log Message' => 'Logbericht',
	'No [_1] were found that match the given criteria.' => 'Er werden geen [_1] gevonden die overeenkomen met de opgegeven criteria.',
	'Output Filename' => 'Naam uitvoerbestand',
	'Page Body' => 'Romp van de pagina',
	'Site Root' => 'Siteroot',
	'Site URL' => 'URL van de site',
	'Template Name' => 'Sjabloonnaam',
	'Templates' => 'Sjablonen',
	'Text' => 'Tekst',
	'Title' => 'Titel',
	'replace_handler of [_1] field is invalid' => 'replace_handler van [_1] veld is ongeldig',
	'ss_validator of [_1] field is invalid' => 'ss_validator van [_1] veld is ongeldig',
	q{Searched for: '[_1]' Replaced with: '[_2]'} => q{Gezocht naar: '[_1]' Vervangen door: '[_2]'},
	q{[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.} => q{[_1] '[_2]' (ID:[_3]) bijgewerkt door gebruiker '[_4]' via zoeken & vervangen.},

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Een nieuwe naam voor de tag moet worden opgegeven.',
	'Error saving entry: [_1]' => 'Fout bij opslaan bericht: [_1]',
	'Error saving file: [_1]' => 'Fout bij opslaan bestand: [_1]',
	'No such tag' => 'Onbekende tag',
	'Successfully added [_1] tags for [_2] entries.' => 'Voegde met succes [_1] tags toe voor [_2] berichten.',
	'The tag was successfully renamed' => 'De tag werd met succes hernoemd',
	q{Tag '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Tag '[_1]' (ID:[_2]) verwijderd door '[_3]'},

## lib/MT/CMS/Template.pm
	' (Backup from [_1])' => ' (Backup van [_1])',
	'Archive Templates' => 'Archiefsjablonen',
	'Cannot load templatemap' => 'Kan sjabloonmap niet laden',
	'Cannot locate host template to preview module/widget.' => 'Kan geen gastsjabloon vinden om voorbeeld van module/widget in te bekijken.',
	'Cannot preview without a template map!' => 'Kan geen voorbeeld bekijken zonder sjabloonkoppeling',
	'Cannot publish a global template.' => 'Kan globaal sjabloon niet publiceren.',
	'Content Type Archive' => 'Inhoudstypesjabloon',
	'Content Type Templates' => 'Inhoudstypesjablonen',
	'Copy of [_1]' => 'Kopie van [_1]',
	'Create Template' => 'Sjabloon aanmaken',
	'Create Widget Set' => 'Widgetset aanmaken',
	'Create Widget' => 'Widget aanmaken',
	'Email Templates' => 'E-mail sjablonen',
	'Entry or Page' => 'Bericht of pagina',
	'Error creating new template: ' => 'Fout bij aanmaken nieuw sjabloon: ',
	'Global Template' => 'Globaal sjabloon',
	'Global Templates' => 'Globale sjablonen',
	'Global' => 'Globaal',
	'Index Templates' => 'Indexsjablonen',
	'Invalid Blog' => 'Ongeldige blog',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'Lorem ipsum' => 'Lorem ipsum',
	'One or more errors were found in the included template module ([_1]).' => 'Eén of meer fouten gevonden in de geïncludeerde sjabloonmodule ([_1]).',
	'One or more errors were found in this template.' => 'Er werden één of meer fouten gevonden in dit sjabloon.',
	'Orphaned' => 'Verweesd',
	'Preview' => 'Voorbeeld',
	'Published Date' => 'Publicatiedatum',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Bezig sjabloon <strong>[_3]</strong> te verversen met <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
	'Saving map failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
	'System Templates' => 'Systeemsjablonen',
	'Template Backups' => 'Sjabloonbackups',
	'Template Modules' => 'Sjabloonmodules',
	'Template Refresh' => 'Sjabloonverversing',
	'Unable to create preview file in this location: [_1]' => 'Kon geen voorbeeldbestand maken op deze locatie: [_1]',
	'Unknown blog' => 'Onbekende blog',
	'Widget Template' => 'Widgetsjabloon',
	'Widget Templates' => 'Widgetsjablonen',
	'You must select at least one event checkbox.' => 'U moet minstens één gebeurtenis-vakje aankruisen.',
	'You must specify a template type when creating a template' => 'U moet een sjabloontype opgeven bij het aanmaken van een sjabloon.',
	'You should not be able to enter zero (0) as the time.' => 'Het mag niet mogelijk zijn om (0) in te vullen als de tijd.',
	'archive' => 'archief',
	'backup' => 'backup',
	'content type' => 'inhoudstype',
	'email' => 'e-mail',
	'index' => 'index',
	'module' => 'module',
	'sample, entry, preview' => 'staaltje, bericht, voorbeeld',
	'system' => 'systeem',
	'template' => 'sjabloon',
	'widget' => 'widget',
	q{Skipping template '[_1]' since it appears to be a custom template.} => q{Sjabloon '[_1]' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.},
	q{Skipping template '[_1]' since it has not been changed.} => q{Sjabloon '[_1]' wordt overgeslagen omdat het niet is veranderd.},
	q{Template '[_1]' (ID:[_2]) created by '[_3]'} => q{Sjabloon '[_1]' (ID:[_2]) aangemaakt door '[_3]'},
	q{Template '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Sjabloon '[_1]' (ID:[_2]) verwijderd door '[_3]'},

## lib/MT/CMS/Theme.pm
	'All themes directories are not writable.' => 'Alle themadirectories zijn niet beschrijfbaar.',
	'Download [_1] archive' => 'Download [_1] archief',
	'Error occurred during exporting [_1]: [_2]' => 'Fout bij het exporteren van [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Fout tijdens het finaliseren van [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Fout bij het publiceren van thema: [_1]',
	'Failed to load theme export template for [_1]: [_2]' => 'Laden exportsjabloon voor [_1] mislukt: [_2]',
	'Failed to save theme export info: [_1]' => 'Opslaan exportinfo van het thema mislukt: [_1]',
	'Failed to uninstall theme' => 'Thema de-installeren mislukt',
	'Failed to uninstall theme: [_1]' => 'Thema de-installeren mislukt: [_1]',
	'Install into themes directory' => 'Installeren in thema-map',
	'Theme from [_1]' => 'Thema van [_1]',
	'Theme not found' => 'Thema niet gevonden',
	'Themes Directory [_1] is not writable.' => 'Themadirectory [_1] is niet beschrijfbaar.',
	'Themes directory [_1] is not writable.' => 'Themadirectory [_1] is niet beschrijfbaar.',
	q{Export Themes} => q{Thema's exporteren},

## lib/MT/CMS/Tools.pm
	'Any site' => 'Eender welke site',
	'Cannot recover password in this configuration' => 'Kan geen wachtwoorden terugvinden in deze configuratie',
	'Changing URL for FileInfo record (ID:[_1])...' => 'URL aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Bestandspad aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing image quality is [_1]' => 'Aanpassen afbeeldingskwaliteit is [_]',
	'Copying file [_1] to [_2] failed: [_3]' => 'Bestand [_1] copiëren naar [_2] mislukt: [_3]',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'Kon exportbestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Debug mode is [_1]' => 'Debug modus is [_1]',
	'Detailed information is in the activity log.' => 'Gedetailleerde informatie is terug te vinden in het activiteitenlog.',
	'E-mail was not properly sent. [_1]' => 'E-mail werd niet goed verzonden. [_1]',
	'Email address is [_1]' => 'E-mail adres is [_1]',
	'Email address is required for password reset.' => 'E-mail adres is vereist om wachtwoord opnieuw te kunnen instellen',
	'Email address not found' => 'E-mail adres niet gevonden',
	'Error occurred during import process.' => 'Er deed zich een fout voor tijdens het importproces.',
	'Error occurred while attempting to [_1]: [_2]' => 'Er deed zich een fout voor bij het [_1]: [_2]',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Fout bij versturen e-mail ([_1]); Gelieve het probleem op te lossen en probeer dan opnieuw om uw wachtwoord te herstellen.',
	'File was not uploaded.' => 'Bestand werd niet opgeladen.',
	'IP address lockout interval' => 'Blokkeringsinterval IP adres',
	'IP address lockout limit' => 'Blokkeringslimiet IP adres',
	'Image quality(JPEG) is [_1]' => 'Afbeeldingskwaliteit (JPEG) is [_1]',
	'Image quality(PNG) is [_1]' => 'Afbeeldingskwaliteit (PNG) is [_1]',
	'Importing a file failed: ' => 'Importeren van een bestand mislukt: ',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'Ongeldig sitepad.  Het sitepad moet geldig en absoluut zijn, niet relatief',
	'Invalid author_id' => 'Ongeldig author_id',
	'Invalid email address' => 'Ongeldig email adres',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Ongeldige poging om wachtwoord opnieuw in te stellen; Kan het wachtwoord niet terughalen in deze configuratie',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ongeldige poging het wachtwoord terug te vinden; kan geen wachtwoorden terugvinden in deze configuratie',
	'Invalid password reset request' => 'Ongeldig verzoek om wachtwoord te veranderen',
	'Lockout IP address whitelist' => 'Niet blokkkeerbare IP adressen',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'Manifestbestand [_1] was geen geldig door Movable Type geëxporteerd manifestbestand.',
	'Only to blogs within this system' => 'Enkel naar blogs binnen dit systeem',
	'Outbound trackback limit is [_1]' => 'Limiet voor uitgaande trackbacks is [_1]',
	'Password Recovery' => 'Wachtwoord terugvinden',
	'Password reset token not found' => 'Wachtwoord reset token niet gevonden',
	'Passwords do not match' => 'Wachtwoorden komen niet overeen',
	'Performance log path is [_1]' => 'Performantielogpad is [_1]',
	'Performance log threshold is [_1]' => 'Performantielogdrempel is [_1]',
	'Performance logging is off' => 'Performantielogging staat uit',
	'Performance logging is on' => 'Performantielogging staat aan',
	'Please confirm your new password' => 'Gelieve uw nieuwe wachtwoord te bevestigen',
	'Please enter a valid email address.' => 'Gelieve een geldig e-mail adres op te geven.',
	'Please upload [_1] in this page.' => 'Gelieve [_1] te uploaden op deze pagina.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Gelieve xml, tar.gz, zip, of manifest te gebruiken als bestandsextensies.',
	'Prohibit comments is off' => 'Reacties verbieden staat uit',
	'Prohibit comments is on' => 'Reacties verbieden staat aan',
	'Prohibit notification pings is off' => 'Notificaties verbieden staat uit',
	'Prohibit notification pings is on' => 'Notificaties verbieden staat aan',
	'Prohibit trackbacks is off' => 'Trackbacks verbieden staat uit',
	'Prohibit trackbacks is on' => 'Trackbacks verbieden staat aan',
	'Recipients for lockout notification' => 'Ontvangers voor blokkeringsnotificaties',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Sommige [_1] werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Sommige objecten werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.  Meer details in het activiteitenlog.',
	'Some objects were not imported because their parent objects were not imported.' => 'Sommige objecten werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.',
	'Some of files could not be imported.' => 'Sommige bestanden konden niet worden geïmporteerd.',
	'Some of the actual files for assets could not be imported.' => 'Enkele van de eigenlijke mediabestanden konden niet worden geïmporteerd.',
	'Some of the exported files could not be removed.' => 'Sommige van de geëxporteerde bestanden konden niet worden verwijderd.',
	'Some of the files were not imported correctly.' => 'Een aantal bestanden werden niet correct geïmporteerd.',
	'Specified file was not found.' => 'Het opgegeven bestand werd niet gevonden.',
	'Started importing sites' => '', # Translate - New
	'Started importing sites: [_1]' => '', # Translate - New
	'System Settings Changes Took Place' => 'Wijzigingen werden aangebracht aan de systeeminstellingen',
	'Temporary directory needs to be writable for export to work correctly.  Please check (Export)TempDir configuration directive.' => 'Tijdelijke map moet beschrijfbaar zijn om export correct te laten werken.  Kijk de (Export)TempDir configuratiedirectief na.',
	'Temporary directory needs to be writable for import to work correctly.  Please check (Export)TempDir configuration directive.' => 'Tijdelijke map moet beschrijfbaar zijn om import correct te laten werken.  Kijk de (Export)TempDir configuratiedirectief na.',
	'Test e-mail was successfully sent to [_1]' => 'De test e-mail werd met succes verzonden naar [_1]',
	'Test email from Movable Type' => 'Test e-mail van Movable Type',
	'That action ([_1]) is apparently not implemented!' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd!',
	'This is the test email sent by Movable Type.' => 'Dit is de test e-mail verstuurd door Movable Type.',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'Geupload bestand was geen geldig uit Movable Type geëxporteerd manifestbestand.',
	'User lockout interval' => 'Blokkeringsinterval gebruiker',
	'User lockout limit' => 'Blokkeringslimiet gebruiker',
	'User not found' => 'Gebruiker niet gevonden',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Er is geen systeem e-mailadres ingesteld.  Stel dit eerst in, sla het op en probeer dan de test e-mail opnieuw.',
	'Your request to change your password has expired.' => 'Uw verzoek om uw wachtwoord aan te passen is verlopen',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] heeft de operatie om meerdere bestanden te importeren voortijdig afgebroken.',
	'[_1] is [_2]' => '[_1] is [_2]',
	'[_1] is not a directory.' => '[_1] is geen map.',
	'[_1] is not a number.' => '[_1] is geen getal.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] exportbestand met succes gedownload ([_2)])',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{Een verzoek om het wachtwoord re resetten is naar [_3] gestuurd voor gebruiker '[_1]' (gebruiker #[_2]).},
	q{Changing Archive Path for the site '[_1]' (ID:[_2])...} => q{Bezig archiefpad aan te passen voor de site '[_1]' (ID:[_2])...},
	q{Changing Site Path for the site '[_1]' (ID:[_2])...} => q{Bezig sitepad aan te passen voor de site '[_1]' (ID:[_2])...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{Bestandslocatie voor mediabestand '[_1]' (ID:[_2]) wordt aangepast...},
	q{Manifest file '[_1]' is too large. Please use import directory for importing.} => q{Manifestbestand '[_1]' is te groot.  Gelieve de import map te gebruiken om te importeren.},
	q{Movable Type system was successfully exported by user '[_1]'} => q{Movable Type systeem werd met succes geëxporteerd door gebruiker '[_1]'},
	q{Removing Archive Path for the site '[_1]' (ID:[_2])...} => q{Bezig archiefpad te verwijderen voor de site '[_1]' (ID:[_2])...},
	q{Removing Site Path for the site '[_1]' (ID:[_2])...} => q{Bezig sitepad te verwijderen voor de site '[_1]' (ID:[_2])...},
	q{Site(s) (ID:[_1]) was/were successfully exported by user '[_2]'} => q{Site(s) (ID:[_1]) werd(en) met succes geëxporteerd door gebruiker '[_2]'},
	q{Successfully imported objects to Movable Type system by user '[_1]'} => q{Objecten werden met succes geïmporteerd in het Movable Type systeem door gebruiker '[_1]'},
	q{User '[_1]' (user #[_2]) does not have email address} => q{Gebruiker '[_1]' (gebruiker #[_2]) heeft geen e-mail adres},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(nieuw aangemaakte gebruiker)',
	'Another role already exists by that name.' => 'Er bestaat al een rol met die naam.',
	'Cannot load role #[_1].' => 'Kan rol #[_1] niet laden.',
	'Create User' => 'Gebruiker aanmaken',
	'For improved security, please change your password' => 'Gelieve uw wachtwoord te veranderen voor verhoogde veiligheid',
	'Grant Permissions' => 'Permissies toekennen',
	'Groups/Users Selected' => 'Geselecteerde groepen/gebruikers',
	'Invalid ID given for personal blog clone location ID.' => 'Ongeldig ID opgegeven als locatie ID van kloon van persoonlijke blog',
	'Invalid ID given for personal blog theme.' => 'Ongeldig ID opgegeven voor persoonlijk blogthema.',
	'Invalid type' => 'Ongeldig type',
	'Minimum password length must be an integer and greater than zero.' => 'Minimale wachtwoordlengte moet een geheel getal groter dan nul zijn.',
	'Role name cannot be blank.' => 'Naam van de rol mag niet leeg zijn.',
	'Roles Selected' => 'Geselecteerde rollen',
	'Select Groups And Users' => 'Selecteer groepen en gebruikers',
	'Select Roles' => 'Selecteer rollen',
	'Select a System Administrator' => 'Selecteer een systeembeheerder',
	'Select a entry author' => 'Selecteer een berichtauteur',
	'Select a page author' => 'Selecteer een pagina-auteur',
	'Selected System Administrator' => 'Geselecteerde systeembeheerder',
	'Selected author' => 'Selecteer auteur',
	'Sites Selected' => 'Geselecteerde sites',
	'System Administrator' => 'Systeembeheerder',
	'Type a username to filter the choices below.' => 'Tik een gebruikersnaam in om de keuzes hieronder te filteren.',
	'User Settings' => 'Instellingen gebruiker',
	'User requires display name' => 'Gebruiker heeft een getoonde naam nodig',
	'User requires password' => 'Gebruiker vereist wachtwoord',
	'User requires username' => 'Gebruiker vereist gebruikersnaam',
	'You cannot define a role without permissions.' => 'U kunt geen rol definiëren zonder permissies.',
	'You cannot delete your own association.' => 'U kunt uw eigen associatie niet verwijderen.',
	'You have no permission to delete the user [_1].' => 'U heeft geen rechten om gebruiker [_1] te verwijderen.',
	'represents a user who will be created afterwards' => 'stelt een gebruiker voor die later zal worden aangemaakt',
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{Gebruiker '[_1]' (ID:[_2]) kon niet opnieuw geactiveerd worden door '[_3]'},
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{Gebruiker '[_1]' (ID:[_2]) aangemaakt door '[_3]'},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Gebruiker '[_1]' (ID:[_2]) verwijderd door '[_3]'},
	q{[_1]'s Associations} => q{Associaties van [_1]},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'Kan website #[_1] niet laden',
	'Create Site' => 'Site aanmaken',
	'Selected Site' => 'Geselecteerde site',
	'This action cannot move a top-level site.' => 'Deze actie kan geen site verplaatsen op het hoogste niveau.',
	'Type a site name to filter the choices below.' => 'Tik de naam van een site in om de opties hieronder te filteren.',
	'Type a website name to filter the choices below.' => 'Tik de naam van een website in om de keuzes hieronder te filteren.',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{Blog '[_1]' (ID:[_2]) verplaatst van '[_3]' naar '[_4]' door '[_5]'},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{Website '[_1]' (ID: [_2]) verwijderd door '[_3]'},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Categorieën moeten bestaan binnen dezelfde blog',
	'Category loop detected' => 'Categorielus gedetecteerd',
	'Category' => 'Categorie',
	'Parent' => 'Ouder',
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,bericht,berichten,Geen berichten]',
	q{[quant,_1,page,pages,No pages]} => q{[quant,_1,pagina,pagina's,geen pagina's]},

## lib/MT/CategorySet.pm
	'Category Count' => 'Aantal categorieën',
	'Category Label' => 'Categorielabel',
	'Content Type Name' => 'Naam inhoudstype',
	'name "[_1]" is already used.' => 'naam "[_1]" is reeds gebruikt.',
	'name is required.' => 'naam is verplicht.',

## lib/MT/Comment.pm
	q{Loading blog '[_1]' failed: [_2]} => q{Laden van blog '[_1]' mislukt: [_1]},
	q{Loading entry '[_1]' failed: [_2]} => q{Laden van bericht '[_1]' mislukt: [_2]},

## lib/MT/Compat/v3.pm
	'No executable code' => 'Geen uitvoerbare code',
	'Publish-option name must not contain special characters' => 'Naam voor publicatie-optie mag geen speciale karakters bevatten',
	'uses [_1]' => 'gebruikt [_1]',
	'uses: [_1], should use: [_2]' => 'gebruikt: [_1], zou moeten gebruiken: [_2]',

## lib/MT/Component.pm
	q{Loading template '[_1]' failed: [_2]} => q{Sjabloon '[_1]' laden mislukt: [_2]},

## lib/MT/Config.pm
	'Configuration' => 'Configuratie',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias voor [_1] zit in een lus in de configuratie',
	'Config directive [_1] without value at [_2] line [_3]' => 'Configuratie-directief [_1] zonder waarde in [_2] lijn [_3]',
	q{Error opening file '[_1]': [_2]} => q{Fout bij openen bestand '[_1]': [_2]},
	q{No such config variable '[_1]'} => q{Onbekende configuratievariabele '[_1]'},

## lib/MT/ContentData.pm
	'(No label)' => '(geen label)',
	'Author' => 'auteur',
	'Cannot load content field #[_1]' => 'Kan inhoudsveld niet laden #[_1]',
	'Contents by [_1]' => 'Inhoud door [_1]',
	'Identifier' => 'Identificatie',
	'Invalid content type' => 'Ongeldig inhoudstype',
	'Link' => 'Link',
	'No Content Type could be found.' => 'Er kon geen inhoudstype worden gevonden',
	'Publish Date' => 'Datum publicatie',
	'Removing content field indexes failed: [_1]' => 'Verwijderen indexen inhoudstypes mislukt: [_1]',
	'Removing object assets failed: [_1]' => 'Verwijderen mediabestandsobjecten mislukt: [_1]',
	'Removing object categories failed: [_1]' => 'Verwijderen objectcategorieën mislukt: [_1]',
	'Removing object tags failed: [_1]' => 'Verwijderen objecttags mislukt: [_1]',
	'Saving content field index failed: [_1]' => 'Opslaan inhoudstype index mislukt: [_1]',
	'Saving object asset failed: [_1]' => 'Opslaan mediabestandsobject mislukt: [_1]',
	'Saving object category failed: [_1]' => 'Opslaan objectcategorie mislukt: [_1]',
	'Saving object tag failed: [_1]' => 'Opslaan objecttag mislukt: [_1]',
	'Tags fields' => 'Tags velden',
	'Unpublish Date' => 'Einddatum publicatie',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) bestaat niet.',
	'basename is too long.' => '', # Translate - New
	'record does not exist.' => 'record bestaat niet.',

## lib/MT/ContentField.pm
	'Cannot load content field data_type [_1]' => '', # Translate - New
	'Content Fields' => 'Inhoudsvelden',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Inhoudsveld index',
	'Content Field Indexes' => 'Inhoudsveld indexen',

## lib/MT/ContentFieldType.pm
	'Audio Asset' => 'Audiobestand',
	'Checkboxes' => 'Aankruisvakjes',
	'Date and Time' => 'Datum en tijd',
	'Date' => 'Datum',
	'Embedded Text' => 'Ingebedde tekst',
	'Image Asset' => 'Afbeeldingsbestand',
	'Multi Line Text' => 'Meerdere regels tekst',
	'Number' => 'Getal',
	'Radio Button' => 'Radioknop',
	'Select Box' => 'Selectievak',
	'Single Line Text' => 'Eén regel tekst',
	'Table' => 'Tabel',
	'Text Display Area' => '', # Translate - New
	'Time' => 'Tijd',
	'Video Asset' => 'Videobestand',
	'__LIST_FIELD_LABEL' => 'Lijst',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Alle [_1] mediabestanden weergeven',
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.} => q{Een maximum selectienummer voor '[_1]' ([_2]) moet een positief geheel getal zijn groter of gelijk aan 1.},
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.} => q{Een maximum selectienummer voor '[_1]' ([_2]) moet een positief geheel getal zijn groter of gelijk aan het minimum selectienummer.},
	q{A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.} => q{Een minimum selectienummer voor '[_1]' ([_2]) moet een positief geheel getal zijn groter of gelijk aan 0.},
	q{You must select or upload correct assets for field '[_1]' that has asset type '[_2]'.} => q{U moet de juiste soort mediabestanden uploaden voor veld '[_1]' met mediabestandstype '[_2]'.},

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'Ongeldige categorie IDs: [_1] in "[_2]" veld.',
	'No category_set setting in content field type.' => 'Geen category_set instelling in inhoudsveldtype.',
	'The source category set is not found in this site.' => 'De broncategorieset werd niet gevonden in deze site.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'Er is geen categorieset die geselecteerd kan worden.  Gelieve een categorieset aan te maken als u het Categoriën veldtype wil gebruiken.',
	'You must select a source category set.' => 'U moet een cagtegorieset selecteren als bron.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'A label for each value is required.' => 'Voor elke waarde is een label vereist.',
	'A value for each label is required.' => 'Voor elk label is een waarde vereist.',
	'You must enter at least one label-value pair.' => 'U moet minstens één label-waarde paar invullen.',

## lib/MT/ContentFieldType/Common.pm
	'"[_1]" field value must be greater than or equal to [_2]' => 'Waarde "[_1]" veld moet groter of gelijk zijn aan [_2].',
	'"[_1]" field value must be less than or equal to [_2].' => 'Waarde "[_1]" veld moet kleiner dan of gelijk zijn aan [_2].',
	'In [_1] column, [_2] [_3]' => 'In [_1] kolom, [_2] [_3]',
	'Invalid [_1] in "[_2]" field.' => 'Ongeldige [_1] in "[_2]" veld.',
	'Invalid values in "[_1]" field: [_2]' => 'Ongeldige waardes in het "[_1]" veld.',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Slechts 1 [_1] kan geselecteerd worden in het "[_2]" veld.',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '[_1] meer dan of gelijk aan [_2] moet geselectdeerd worden in "[_3]" veld.',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '[_1] minder dan of gelijk aan [_2] moet geselectdeerd worden in "[_3]" veld.',
	'is not selected' => 'is niet geselecteerd',
	'is selected' => 'is geselecteerd',

## lib/MT/ContentFieldType/ContentType.pm
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'Ongeldige inhoudsgegevens IDs: [_1] in "[_2]" veld.',
	'No Label (ID:[_1]' => 'Geen label (ID:[_1])',
	'The source Content Type is not found in this site.' => 'Het broninhoudstype werd niet gevonden in deze site.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'Er is geen inhoudstype dat geselecteerd kan worden.  Gelieve een nieuw inhoudstype aan te maken als u het inhoudstype veld wenst te gebruiken.',
	'You must select a source content type.' => 'U moet een inhoudstype opgeven als bron.',

## lib/MT/ContentFieldType/Date.pm
	q{Invalid date '[_1]'; An initial date value must be in the format YYYY-MM-DD.} => q{Ongeldige datum '[_1]'; Een initiõ�¼„e datumwaarde moet in het formaat JJJJ-MM-DD staan.},

## lib/MT/ContentFieldType/DateTime.pm
	q{Invalid date '[_1]'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.} => q{Ongeldige datum '[_1]'; Een initiõ�¼„e datum/tijd waarde moet in het formaat JJJJ-MM-DD UU:MM:SS staan.},

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value has invalid precision.' => 'Waarde "[_1]" heeft een ongeldige preciesie',
	'"[_1]" field value must be a number.' => 'Waarde "[_1]" veld moet een getal zijn.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'Maximumwaarde moet een geheel getal zijn tussen [_1] en [_2]',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'Een maximum waarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om een decimale waarde te kunnen gebruiken.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'Minimumwaarde moet een geheel getal zijn tussen [_1] en [_2]',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'Minimumwaarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om decimale waarde te kunnen gebruiken.',
	'An initial value must be an integer and between [_1] and [_2]' => 'Een beginwaarde moet een geheel getal zijn tussen [_1] en [_2]',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'Een beginwaarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om een decimale waarde te kunnen gebruiken.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'Aantal cijfers achter de komma moet een positief geheel getal zijn tussen 0 en [_1].',
	'Number of decimal places must be a positive integer.' => 'Aantal cijfers achter de komma moet een positief geheel getal zijn.',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Een label van waardes is vereist.',
	'A value of values is required.' => 'Een waarde van waardes is vereist.',

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => '"[_1]" veld is te lang',
	'"[_1]" field is too short.' => '"[_1]" veld is te kort',
	q{A maximum length number for '[_1]' ([_2]) must be a positive integer between 1 and [_3].} => q{Een maximale lengte voor '[_1]' ([_2]) moet een positief geheel getal zijn tussen 1 en [_3].},
	q{A minimum length number for '[_1]' ([_2]) must be a positive integer between 0 and [_3].} => q{Een minimale lengte voor '[_1]' ([_2]) moet een positief geheel getal zijn tussen 0 en [_3].},
	q{An initial value for '[_1]' ([_2]) must be shorter than [_3] characters} => q{Een beginwaarde voor '[_1]' ([_2]) moet korter zijn dan [_3] karakters},

## lib/MT/ContentFieldType/Table.pm
	q{Initial number of columns for '[_1]' ([_2]) must be a positive integer.} => q{Initiëel aantal kolommen voor '[_1]' ([_2]) moet een positief geheel getal zijn.},
	q{Initial number of rows for '[_1]' ([_2]) must be a positive integer.} => q{Initiëel aantal rijen voor '[_1]' ([_2]) moet een positief geheel getal zijn.},

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tag "[_1]": [_2]' => 'Kan tag "[_1]" niet aanmaken: [_2]',
	'Cannot create tags [_1] in "[_2]" field.' => 'Kan tags [_1] niet aanmaken in "[_2]" veld.',
	q{An initial value for '[_1]' ([_2]) must be an shorter than 255 characters} => q{Een beginwaarde voor '[_1]' ([_2]) moet korter zijn dan 255 karakters.},

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	q{Invalid time '[_1]'; An initial time value be in the format HH:MM:SS.} => q{Ongeldige tijdsaanduiding '[_1]'; Een beginwaarde voor de tijd moet volgend formaat hebben UU:MM:SS.},

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'Ongeldige URL in "[_1]" veld.',
	q{An initial value for '[_1]' ([_2]) must be shorter than 2000 characters} => q{Een beginwaarde voor '[_1]' ([_2]) moet korter zijn dan 2000 karakters},

## lib/MT/ContentPublisher.pm
	'An error occurred while publishing scheduled contents: [_1]' => 'Er deed zich een fout voor bij het publiceren van geplande inhoud: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Er deed zich een fout voor bij het ontpubliceren van oude inhoud: [_1]',
	'Cannot load catetory. (ID: [_1]' => 'Kan categorie niet laden. (ID: [_1])',
	'Scheduled publishing.' => 'Geplande berichten.',
	'You did not set your site publishing path' => 'U stelde geen blogpublicatiepad in',
	'[_1] archive type requires [_2] parameter' => 'Archieftype [_1] vereist een [_2] parameter',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{Er deed zich een fout voor bij het publiceren van [_1] '[_2]': [_3]},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{Er deed zich een fout voor bij het publiceren van datum-gebaseerd archief '[_1]': [_2]},
	q{Archive type '[_1]' is not a chosen archive type} => q{Archieftype '[_1]' is geen gekozen archieftype},
	q{Load of blog '[_1]' failed: [_2]} => q{Laden van blog '[_1]' mislukt: [_2]},
	q{Load of blog '[_1]' failed} => q{Laden van blog '[_1]' mislukt},
	q{Loading of blog '[_1]' failed: [_2]} => q{Laden van blog '[_1]' mislukt: [_2]},
	q{Parameter '[_1]' is invalid} => q{Parameter '[_1]' is ongeldig},
	q{Parameter '[_1]' is required} => q{Parameter '[_1]' is vereist},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{Tijdelijk bestand '[_1]' van naam veranderen mislukt: [_2]},
	q{Writing to '[_1]' failed: [_2]} => q{Schrijven naar '[_1]' mislukt: [_2]},

## lib/MT/ContentType.pm
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (Site: "[_2]" ID: [_3])',
	'Content Data # [_1] not found.' => 'Inhoudsgegevens # [_1] niet gevonden.',
	'Create Content Data' => 'Inhoudsgegevens aanmaken',
	'Edit All Content Data' => 'Alle inhoudsgegevens bewerken',
	'Manage Content Data' => 'Inhoudsgegevens beheren',
	'Publish Content Data' => 'Inhoudsgegevens publiceren',
	'Tags with [_1]' => 'Tags met [_1]',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'Kan geen unieke ID aanmaken',

## lib/MT/Core.pm
	'(system)' => '(systeem)',
	'*Website/Blog deleted*' => '*Website/Blog verwijderd*',
	'Activity Feed' => 'Activiteit-feed',
	'Add Summary Watcher to queue' => 'Samenvattings-waakhond toevoegen aan de wachtrij',
	'Address Book is disabled by system configuration.' => 'Adresboek is uitgeschakeld in de systeemconfiguratie',
	'Adds Summarize workers to queue.' => 'Voegt samenvattingswerkers toe aan de wachtrij',
	'Blog ID' => 'Blog ID',
	'Blog Name' => 'Blognaam',
	'Blog URL' => 'Blog-URL',
	'Change Settings' => 'Instellingen aanpassen',
	'Classic Blog' => 'Klassieke weblog',
	'Contact' => 'Contact',
	'Convert Line Breaks' => 'Regeleindes omzetten',
	'Create Child Sites' => 'Subsites aanmaken',
	'Create Entries' => 'Berichten aanmaken',
	'Create Sites' => 'Sites aanmaken',
	'Create Websites' => 'Websites aanmaken',
	'Database Name' => 'Databasenaam',
	'Database Path' => 'Databasepad',
	'Database Port' => 'Databasepoort',
	'Database Server' => 'Databaseserver',
	'Database Socket' => 'Databasesocket',
	'Date Created' => 'Datum aangemaakt',
	'Date Modified' => 'Datum gewijzigd',
	'Days must be a number.' => 'Dagen moet een getal zijn.',
	'Edit All Entries' => 'Alle berichten bewerken',
	'Entries List' => 'Lijst berichten',
	'Entry Excerpt' => 'Berichtuittreksel',
	'Entry Extended Text' => 'Uitgebreide tekst bericht',
	'Entry Link' => 'Link bericht',
	'Entry Title' => 'Berichttitel',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Fout bij het aanmaken van de map voor de performantielogbestanden, [_1].  Gelieve de permissies aan te passen zodat deze map beschrijfbaar is of geef een alternatief pad op via de PerformanceLoggingPath configuratiedirectief. [_2]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Fout bij het aanmaken van performantielogs: PerformanceLoggingPath map bestaat maar is niet beschrijfbaar. [_1]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Fout bij het aanmaken van performantielogs: PerformanceLogginPath instelling moet een pad naar een map zijn, geen bestand. [_1]',
	'Filter' => 'Filter',
	'Folder' => 'Map',
	'Get Variable' => 'Haal variabele op',
	'Group Member' => 'Groepslid',
	'Group Members' => 'Groepsleden',
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => 'IP banlijst is uitgeschakeld in de systeemconfiguratie',
	'IP Banning Settings' => 'IP-verbanningsinstellingen',
	'IP address' => 'IP adres',
	'IP addresses' => 'IP adressen',
	'If Block' => 'If blok',
	'If/Else Block' => 'If/Else blok',
	'Include Template File' => 'Sjabloonbestand includeren',
	'Include Template Module' => 'Sjabloonmodule includeren',
	'Junk Folder Expiration' => 'Vervaldatum spam-map',
	'Legacy Quick Filter' => 'Verouderde snelfilter',
	'Log' => 'Log',
	'Manage Address Book' => 'Adresboek beheren',
	'Manage All Content Data' => 'Alle inhoudsgegevens beheren',
	'Manage Assets' => 'Mediabestanden beheren',
	'Manage Blog' => 'Blog beheren',
	'Manage Categories' => 'Categorieën beheren',
	'Manage Category Set' => 'Categorieset beheren',
	'Manage Content Type' => 'Inhoudstype beheren',
	'Manage Content Types' => 'Inhoudstypes beheren',
	'Manage Feedback' => 'Feedback beheren',
	'Manage Group Members' => 'Groepsleden beheren',
	'Manage Plugins' => 'Plugins beheren',
	'Manage Sites' => 'Sites beheren',
	'Manage Tags' => 'Tags beheren',
	'Manage Templates' => 'Sjablonen beheren',
	'Manage Users & Groups' => 'Gebruikers en groepen beheren',
	'Manage Users' => 'Gebruikers beheren',
	'Manage Website with Blogs' => 'Website met blogs beheren',
	'Manage Website' => 'Website beheren',
	'Member' => 'Lid',
	'Members' => 'Leden',
	'Movable Type Default' => 'Movable Type standaardinstelling',
	'My Items' => 'Mijn items',
	'My [_1]' => 'Mijn  [_1]',
	'MySQL Database (Recommended)' => 'MySQL database (aangeraden)',
	'No Title' => 'Geen titel',
	'No label' => 'Geen label',
	'Password' => 'Wachtwoord',
	'Permission' => 'Permissie',
	'Post Comments' => 'Reacties publiceren',
	'PostgreSQL Database' => 'PostgreSQL databank',
	'Publish Entries' => 'Berichten publiceren',
	'Publish Scheduled Contents' => 'Geplande inhoud publiceren',
	'Publish Scheduled Entries' => 'Publicatie geplande berichten',
	'Publishes content.' => 'Publiceert inhoud.',
	'Purge Stale DataAPI Session Records' => 'Verlopen DataAPI sessiegegevens verwijderen',
	'Purge Stale Session Records' => 'Verlopen sessiegegevens verwijderen',
	'Purge Unused FileInfo Records' => 'Ongebruikte FileInfo records verwijderen',
	'Refreshes object summaries.' => 'Ververst objectsamenvattingen.',
	'Remove Compiled Template Files' => 'Gecompileerde sjabloonbestanden verwijderen',
	'Remove Temporary Files' => 'Tijdelijke bestanden verwijderen',
	'Remove expired lockout data' => 'Verlopen blokkeringsgegevens verwijderen',
	'Rich Text' => 'Rich text',
	'SQLite Database (v2)' => 'SQLite databank (v2)',
	'SQLite Database' => 'SQLite databank',
	'Send Notifications' => 'Notificaties verzenden',
	'Set Publishing Paths' => 'Publicatiepaden instellen',
	'Set Variable Block' => 'Stel variabel blok in',
	'Set Variable' => 'Stel variabele in',
	'Sign In(CMS)' => 'Aanmelden(CMS)',
	'Sign In(Data API)' => 'Aanmelden(Data API)',
	'Synchronizes content to other server(s).' => 'Synchroniseert inhoud naar andere server(s).',
	'Tag' => 'Tag',
	'The physical file path for your SQLite database. ' => 'Het fysieke bestandspad voor uw SQLite database',
	'Unpublish Past Contents' => 'Oude inhoud ontpubliceren',
	'Unpublish Past Entries' => 'Publicatie oude berichten ongedaan maken',
	'Upload File' => 'Opladen',
	'View Activity Log' => 'Activiteitenlog bekijken',
	'View System Activity Log' => 'Systeemactiviteitlog bekijken',
	'Widget Set' => 'Widgetset',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] tussen [_3] en [_4]',
	'[_1] [_2] future' => '[_1] [_2] toekomst',
	'[_1] [_2] or before [_3]' => '[_1] [_2] of voor [_3]',
	'[_1] [_2] past' => '[_1] [_2] verleden',
	'[_1] [_2] since [_3]' => '[_1] [_2] sinds [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] deze [_3] dagen',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'[_1] of this Site' => '[_1] van deze site',
	'option is required' => 'optie is vereist',
	'tar.gz' => 'tar.gz',
	'zip' => 'zip',
	q{Manage Pages} => q{Pagina's beheren},
	q{Manage Themes} => q{Thema's beheren},
	q{This is often 'localhost'.} => q{Dit is vaak 'localhost'.},

## lib/MT/DataAPI/Callback/Blog.pm
	'Cannot apply website theme to blog: [_1]' => 'Kan website-thema niet op blog toepassen: [_1]',
	'Invalid theme_id: [_1]' => 'Ongeldig theme_id: [_1]',
	'The website root directory must be an absolute path: [_1]' => 'De hoofdmap van de website moet een absoluut pad zijn: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'Parent [_1] (ID:[_2]) not found.' => 'Moeder [_1] (ID:[_2]) niet gevonden.',
	q{The label '[_1]' is too long.} => q{Het label '[_1]' is te lang.},

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => 'Naam "[_1]" wordt al gebruikt in dezelfde site.',

## lib/MT/DataAPI/Callback/ContentData.pm
	'"[_1]" is required.' => '', # Translate - New
	'There is an invalid field data: [_1]' => 'Er zijn ongeldige gegevens in het veld: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'Een parameter "[_1]" is ongeldig: [_2]',
	'Invalid option key(s): [_1]' => 'Ongeldige optiesleutel(s): [_1]',
	'Invalid option(s): [_1]' => 'Ongeldige optie(s): [_1]',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler van type [_1]" is ongeldig',

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Een parameter "[_1]" is ongeldig.',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'author_id (ID:[_1]) is ongeldig.',
	'log' => 'Log',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{Log (ID:[_1]) verwijderd door '[_2]'},

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Ongeldige tagnaam: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Ongeldig archieftype: [_1]',

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => 'Ongeldig dateFormat: [_1]',
	'Invalid textFormat: [_1]' => 'Ongeldig textFormat: [_1]',

## lib/MT/DataAPI/Endpoint/Auth.pm
	q{Failed login attempt by user who does not have sign in permission via data api. '[_1]' (ID:[_2])} => q{Mislukte aanmeldpoging van gebruiker zonder toestemming om aan te melden via de data api. '[_1]' (ID:[_2])},
	q{User '[_1]' (ID:[_2]) logged in successfully via data api.} => q{Gebruiker '[_1]' (ID:[_2]) met succes aangemeld via de data api.},

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Ongeldige dateFrom parameter [_1]',
	'Invalid dateTo parameter: [_1]' => 'Ongeldige dateTo parameter: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'Invalid height: [_1]' => 'Ongeldige hoogte: [_1]',
	'Invalid scale: [_1]' => 'Ongeldige schaal: [_1]',
	'Invalid width: [_1]' => 'Ongeldige breedte: [_1]',
	'The asset does not support generating a thumbnail file.' => 'Dit mediabestand ondersteunt het aanmaken van een thumbnailbestand niet.',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Er deed zich een fout voor tijdens het backup-proces: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Er deed zich een fout voor tijdens het restore-proces: [_1].  Kijk het activiteitenlog na voor meer details.',
	'Invalid backup_archive_format: [_1]' => 'Ongeldige backup_archive_format: [_1]',
	'Invalid backup_what: [_1]' => 'Ongeldige backup_what: [_1]',
	'Invalid limit_size: [_1]' => 'Ongeldige limit_size: [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om backups te kunnen doen.  Gelieve de (Export)TempDir configuratiedirectief na te kijken.',
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Verwijder de bestanden die u heeft teruggezet uit de map 'import', om te vermijden dat ze opnieuw worden teruggezet wanneer u ooit het restore-proces opnieuw uitvoert.},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Kan geen blog aanmaken onder blog (ID: [_1])',
	'Either parameter of "url" or "subdomain" is required.' => 'Of "url" of "subdomein" parameter vereist.',
	'Site not found' => 'Site niet gevonden',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Website "[_1]" (ID: [_2]) niet verwijderd.  U moet eerst de blogs onder de website verwijderen.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'Loading object failed: [_1]' => 'Laden object mislukt: [_1]',
	'[_1] not found' => '[_1] niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1]" is required.' => 'Een bron "[_1]" is vereist.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',
	'Could not found archive template for [_1].' => 'Kon archiefsjabloon niet vinden voor [_1].',
	'Invalid convert_breaks: [_1]' => 'Ongeldige convert_breaks: [_1]',
	'Invalid default_cat_id: [_1]' => 'Ongeldige default_cat_id: [_1]',
	'Invalid encoding: [_1]' => 'Ongeldige encodering: [_1]',
	'Invalid import_type: [_1]' => 'Ongeldig import_type: [_1]',
	'Preview data not found.' => 'Gegevens voor voorbeeld niet gevonden.',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'U moet de "password" parameter opgeven als u nieuwe gebruikers wenst aan te maken voor elke gebruiker die aan uw blog vastzit.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Verwijder zeker de bestanden waaruit u gegevens importeerde uit de 'import' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.},

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => 'Een bron ("member") is vereist.',
	'Adding member to group failed: [_1]' => 'Lid toevoegen aan groep mislukt: [_1]',
	'Cannot add member to inactive group.' => 'Kan geen lid toevoegen aan inactieve groep.',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Groep aanmaken mislukt: ExternalGroupManagement is ingeschakeld.',
	'Group not found' => 'Groep niet gevonden',
	'Member not found' => 'Lid niet gevonden',
	'Removing member from group failed: [_1]' => 'Lid verwijderen uit groep mislukt: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Logbericht',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{'folder' parameter is ongeldig.},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Associatie niet gevonden',
	'Granting permission failed: [_1]' => 'Permissie verlenen mislukt: [_1]',
	'Revoking permission failed: [_1]' => 'Permissie afnemen mislukt: [_1]',
	'Role not found' => 'Rol niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Kan privé-tag verbonden met objecten op systeemniveau niet verwijderen.',
	'Cannot delete private tag in system scope.' => 'Kan privé-tag op systeemniveau niet verwijderen.',
	'Tag not found' => 'Tag niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'A parameter "refresh_type" is invalid: [_1]' => 'De parameter "refresh_type" is ongeldig: [_1]',
	'A resource "template" is required.' => 'Een "sjabloon" bron is vereist.',
	'Cannot clone [_1] template.' => 'Kan sjabloon [_1] niet klonen.',
	'Cannot delete [_1] template.' => 'Kan [_1] sjabloon niet verwijderen.',
	'Cannot get [_1] template.' => '', # Translate - New
	'Cannot preview [_1] template.' => '', # Translate - New
	'Cannot publish [_1] template.' => 'Kan [_1] sjabloon niet publiceren.',
	'Cannot refresh [_1] template.' => '', # Translate - New
	'Cannot update [_1] template.' => '', # Translate - New
	'Template not found' => 'Sjabloon niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Sjabloon "[_1]" is geen archiefsjabloon.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Applying theme failed: [_1]' => 'Toepassen van thema mislukt: [_1]',
	'Cannot apply website theme to blog.' => 'Kan website-thema niet toepassen op blog.',
	'Cannot uninstall theme because the theme is in use.' => 'Kan thema niet deïnstalleren omdat het nog gebruikt wordt.',
	'Cannot uninstall this theme.' => 'Dit thema kan niet gedeïnstalleerd worden.',
	'Changing site theme failed: [_1]' => 'Aanpassen site-thema mislukt: [_1]',
	'Unknown archiver type: [_1]' => 'Onbekend archieftype: [_1]',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id kan enkel letters, cijfers en het minteken of liggend streepje bevatten.  Het theme_id moet beginnen met een letter.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version kan enkel letters, cijfers en het minteken of liggend streepje bevatten.',
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{Kan geen nieuw theme installeren met dezelfde basisnaam als een bestaand (en beschermd) thema: [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{Map voor exporteren thema bestaat al '[_1]'.  U kunt een bestaand thema overschrijven met de 'overwrite_yes=1' parameter of u kunt de basisnaam aanpassen.},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Er is een e-mail met een link om uw wachtwoord aan te passen doorgestuurd naar uw e-mail adres ([_1]).',
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'Het opgegeven email adres is niet uniek.  Gelieve uw gebruikersnaam in te vullen bij de "name" parameter.',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Removing Widget failed: [_1]' => 'Widget verwijderen mislukt: [_1]',
	'Widget not found' => 'Widget niet gevonden',
	'Widgetset not found' => 'Widgetset niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Een bron "widgetset" is vereist.',
	'Removing Widgetset failed: [_1]' => 'Widget set verwijderen mislukt: [_1]',

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is invalid.' => 'De parameter "content_fields" is ongeldig.',
	'A parameter "content_fields" is required.' => 'De parameter "content_fields" is vereist.',

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kan "[_1]" niet parsen als een IS0 8601 datetime',

## lib/MT/DefaultTemplates.pm
	'About This Page' => 'Over deze pagina',
	'Archive Index' => 'Archiefindex',
	'Archive Widgets Group' => 'Archiefwidgetsgroep',
	'Blog Index' => 'Blog index',
	'Calendar' => 'Kalender',
	'Category Entry Listing' => 'Categorie-overzicht berichten',
	'Comment Form' => 'Reactieformulier',
	'Creative Commons' => 'Creative Commons',
	'Current Author Monthly Archives' => 'Archieven per maand van de huidige auteur',
	'Date-Based Author Archives' => 'Datum-gebaseerde auteursactieven',
	'Date-Based Category Archives' => 'Datum-gebaseerde categorie-archieven',
	'Displays errors for dynamically-published templates.' => 'Geeft fouten weer voor dynamisch gepubliceerde sjablonen.',
	'Displays image when user clicks a popup-linked image.' => 'Toont afbeelding wanneer de gebruiker op een afbeelding klikt die in een popup verschijnt.',
	'Displays results of a search.' => 'Toont zoekresultaten',
	'Dynamic Error' => 'Dynamische fout',
	'Entry Notify' => 'Notificatie bericht',
	'Feed - Recent Entries' => 'Feed - Recente berichten',
	'Home Page Widgets Group' => 'Hoofdpaginawidgetsgroep',
	'IP Address Lockout' => 'Blokkering IP adres',
	'JavaScript' => 'JavaScript',
	'Monthly Archives Dropdown' => 'Uitklapmenu archieven per maand',
	'Monthly Entry Listing' => 'Maandoverzicht berichten',
	'Navigation' => 'Navigatie',
	'OpenID Accepted' => 'OpenID welkom',
	'Popup Image' => 'Pop-up afbeelding',
	'Powered By' => 'Aangedreven door',
	'RSD' => 'RSD',
	'Search Results for Content Data' => 'Zoekresultaten voor inhoudsgegevens',
	'Stylesheet' => 'Stylesheet',
	'Syndication' => 'Syndicatie',
	'User Lockout' => 'Blokkering gebruiker',
	q{Page Listing} => q{Overzicht pagina's},

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'Reacties aanvaarden',
	'Accept Trackbacks' => 'TrackBacks aanvaarden',
	'Author ID' => 'ID auteur',
	'Body' => 'Romp',
	'Draft Entries' => 'Kladberichten',
	'Draft' => 'Klad',
	'Entries by [_1]' => 'Berichten door [_1]',
	'Entries from category: [_1]' => 'Berichten in categorie: [_1]',
	'Entries in This Site' => 'Berichten in deze website',
	'Extended' => 'Uitgebreid',
	'Format' => 'Formaat',
	'Future' => 'Toekomstig',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Ongeldige argumenten. Ze moeten allemaal als MT::Asset objecten opgeslagen zijn.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Ongeldige argumenten. Ze moeten allemaal als MT::Category objecten opgeslagen zijn.',
	'Junk' => 'Spam',
	'My Entries' => 'Mijn berichten',
	'NONE' => 'GEEN',
	'Primary Category' => 'Hoofdcategorie',
	'Published Entries' => 'Gepubliceerde berichten',
	'Published' => 'Gepubliceerd',
	'Review' => 'Na te kijken',
	'Reviewing' => 'Nakijken',
	'Scheduled Entries' => 'Geplande berichten',
	'Scheduled' => 'Gepland',
	'Spam' => 'Spam',
	'Unpublished (End)' => 'Publicatie ongedaan gemaakt (einde)',
	'Unpublished Entries' => 'Niet gepubliceerde berichten',
	'View [_1]' => '[_1] bekijken',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV verbinding mislukt: [_1]',
	'DAV get failed: [_1]' => 'DAV get mislukt: [_1]',
	'DAV open failed: [_1]' => 'DAV open mislukt: [_1]',
	'DAV put failed: [_1]' => 'DAV put mislukt: [_1]',
	q{Creating path '[_1]' failed: [_2]} => q{Aanmaken van pad '[_1]' mislukt: [_2]},
	q{Deleting '[_1]' failed: [_2]} => q{Verwijderen van '[_1]' mislukt: [_2]},
	q{Renaming '[_1]' to '[_2]' failed: [_3]} => q{Herbenoemen van '[_1]' naar '[_2]' mislukt: [_3]},

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP verbinding mislukt: [_1]',
	'SFTP get failed: [_1]' => 'SFTP get mislukt: [_1]',
	'SFTP put failed: [_1]' => 'SFTP put mislukt: [_1]',

## lib/MT/Filter.pm
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms" en "editable_filters" kunnen niet op hetzelfde moment opgegeven worden.',
	'Invalid filter type [_1]:[_2]' => 'Ongeldig filtertype [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Ongeldige sorteersleutel [_1]:[_2]',

## lib/MT/Group.pm
	'Active Groups' => 'Actieve groepen',
	'Disabled Groups' => 'Gedeactiveerde groepen',
	'Email' => 'E-mail',
	'Groups associated with author: [_1]' => 'Groepen geassocieerd met auteur: [_1]',
	'Inactive' => 'Inactief',
	'Members of group: [_1]' => 'Leden van groep: [_1]',
	'My Groups' => 'Mijn groepen',
	'__COMMENT_COUNT' => 'Reacties',
	'__GROUP_MEMBER_COUNT' => 'Leden',

## lib/MT/IPBanList.pm
	'IP Ban' => 'IP ban',
	'IP Bans' => 'IP bans',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Bestandsgroote is groter dan maximum toegestaan: [_1] > [_2]',
	'Invalid Image Driver [_1]' => 'Ongeldige driver voor afbeeldingen  [_1]',
	'Saving [_1] failed: Invalid image file format.' => 'Opslaan van [_1] mislukt: Ongeldig afbeeldingsbestandsformaat',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'Kan GD niet laden: [_1]',
	'Reading image failed: [_1]' => 'Afbeelding lezen mislukt: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'Draaien (graden: [_1]) wordt niet ondersteund',
	'Unsupported image file type: [_1]' => 'Niet ondersteund afbeeldingsformaat: [_1]',
	q{Reading file '[_1]' failed: [_2]} => q{Bestand '[_1]' lezen mislukt: [_2]},

## lib/MT/Image/ImageMagick.pm
	'Cannot load [_1]: [_2]' => '', # Translate - New
	'Converting image to [_1] failed: [_2]' => 'Converteren van afbeelding naar [_1] mislukt: [_2]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Bijsnijden van [_1]x[_2] vierkand naar [_3],[_4] mislukt: [_5]',
	'Flip horizontal failed: [_1]' => 'Horizontaal draaien mislukt: [_1]',
	'Flip vertical failed: [_1]' => 'Verticaal draaien mislukt: [_1]',
	'Outputting image failed: [_1]' => 'Uitvoer van afbeelding mislukt: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Roteren (graden: [_1]) mislukt: [_2]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Dimensies aanpassen naar [_1]x[_2] mislukt: [_3]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Kan Imager niet laden: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'Kan IPC::Run niet laden: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Bijsnijden naar [_1]x[_2] mislukt: [_3]',
	'Reading alpha channel of image failed: [_1]' => 'Lezen alfakanaal van de afbeelding mislukt: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'U hebt geen geldig pad naar de NetPBM tools op uw machine.',

## lib/MT/Import.pm
	'Another system (Movable Type format)' => 'Een ander systeem (Movable Type formaat)',
	'Could not resolve import format [_1]' => 'Kon importformaat niet bepalen [_1]',
	'File not found: [_1]' => 'Bestand niet gevonden: [_1]',
	'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
	q{Cannot open '[_1]': [_2]} => q{Kan '[_1]' niet openen: [_2]},
	q{Importing entries from file '[_1]'} => q{Berichten worden ingevoerd uit bestand  '[_1]'},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => 'ImportAs ofwel ParentAuthor vereist',
	'No Blog' => 'Geen blog',
	'Saving category failed: [_1]' => 'Categorie opslaan mislukt: [_1]',
	'Saving entry failed: [_1]' => 'Bericht opslaan mislukt: [_1]',
	'Saving user failed: [_1]' => 'Gebruiker opslaan mislukt: [_1]',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker die in uw weblog voorkomt.',
	'ok (ID [_1])' => 'ok (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{Kan geen bestaand bericht vinden met tijdstip '[_1]'... reacties worden overgeslagen, verder naar volgende bericht.},
	q{Creating new category ('[_1]')...} => q{Nieuwe categorie wordt aangemaakt ('[_1]')...},
	q{Creating new user ('[_1]')...} => q{Nieuwe gebruiker ('[_1]') wordt aangemaakt...},
	q{Export failed on entry '[_1]': [_2]} => q{Export mislukt bij bericht '[_1]': [_2]},
	q{Importing into existing entry [_1] ('[_2]')} => q{Aan het importeren in bestaand bericht [_1] ('[_2]')},
	q{Invalid allow pings value '[_1]'} => q{Ongeldige instelling voor het toelaten van pings '[_1]'},
	q{Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)} => q{Ongeldig datumformaat '[_1]'; dit moet 'MM/DD/JJJJ HH:MM:SS AM|PM' zijn (AM|PM is optioneel)},
	q{Invalid status value '[_1]'} => q{Ongeldige statuswaarde '[_1]'},
	q{Saving entry ('[_1]')...} => q{Bericht aan het opslaan ('[_1]')...},

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Handeling: Verworpen (score onder drempel)',
	'Action: Published (default action)' => 'Handeling: Gepubliceerd (standaardhandeling)',
	'Composite score: [_1]' => 'Samengestelde score: [_1]',
	'Junk Filter [_1] died with: [_2]' => 'Spamfilter [_1] liep vast met: [_2]',
	'Unnamed Junk Filter' => 'Naamloze spamfilter',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'Kan lijsteigenschap [_1] niet initialiseren. [_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Kon auto list eigenschap niet initialiseren [_1].[_2]: Kan definitie van kolom [_3] niet vinden.',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Kon auto list eigenschap niet initialiseren [_1].[_2]: kolomtype niet ondersteund.',
	'[_1] (id:[_2])' => '[_1] (id:[_2])',

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'IP adres werd geblokkeerd.',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IP adres werd geblokkeerd.  IP adres: [_1], Gebruikersnaam: [_2]',
	'User Was Locked Out' => 'Gebruiker werd geblokkeerd',
	'User has been unlocked. Username: [_1]' => 'Gebruiker werd gedeblokkeerd.  Gebruikersnaam: [_1]',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Gebruiker werd geblokkeerd.  IP adres: [_1], Gebruikersnaam: [_2]',

## lib/MT/Log.pm
	'By' => 'Door',
	'Class' => 'Klasse',
	'Comment # [_1] not found.' => 'Reactie # [_1] niet gevonden.',
	'Debug' => 'Debug',
	'Debug/error' => 'Debug/fout',
	'Entry # [_1] not found.' => 'Bericht # [_1] niet gevonden.',
	'Information' => 'Informatie',
	'Level' => 'Niveau',
	'Log messages' => 'Logberichten',
	'Logs on This Site' => 'Logs op deze website',
	'Message' => 'Boodschap',
	'Metadata' => 'Metadata',
	'Not debug' => 'Debug niet',
	'Notice' => 'Belangrijke informatie',
	'Page # [_1] not found.' => 'Pagina # [_1] niet gevonden.',
	'Security or error' => 'Beveiliging of fout',
	'Security' => 'Beveiliging',
	'Security/error/warning' => 'Beveiliging/fout/waarschuwing',
	'Show only errors' => 'Enkel fouten tonen',
	'TrackBack # [_1] not found.' => 'TrackBack # [_1] niet gevonden.',
	'TrackBacks' => 'TrackBacks',
	'Warning' => 'Waarschuwing',
	'author' => 'auteur',
	'folder' => 'map',
	'page' => 'pagina',
	'ping' => 'ping',
	'plugin' => 'plugin',
	'search' => 'zoek',
	'theme' => 'thema',

## lib/MT/Mail.pm
	'Authentication failure: [_1]' => 'Fout bij authenticatie: [_1]',
	'Error connecting to SMTP server [_1]:[_2]' => 'Fout bij verbinden met SMTP server [_1]:[_2]',
	'Exec of sendmail failed: [_1]' => 'Exec van sendmail mislukt: [_1]',
	'Following required module(s) were not found: ([_1])' => 'Volgende vereiste module(s) niet gevonden: ([_1])',
	'Username and password is required for SMTP authentication.' => 'Gebruikersnaam en wachtwoord zijn vereist voor SMTP authenticatie.',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'U heeft geen geldig pad naar sendmail op uw machine.  Misschien moet u proberen om SMTP te gebruiken?',
	q{Unknown MailTransfer method '[_1]'} => q{Onbekende MailTransfer methode '[_1]'},

## lib/MT/Notification.pm
	'Cancel' => 'Annuleren',
	'Click to edit contact' => 'Klik om contact te bewerken',
	'Contacts' => 'Contacten',
	'Save Changes' => 'Wijzigingen opslaan',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Assetplaatsing',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Categorieplaatsing',
	'Category Placements' => 'Categorieplaatsingen',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Objectscore',
	'Object Scores' => 'Objectscores',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Tagplaatsing',
	'Tag Placements' => 'Tagplaatsingen',

## lib/MT/Page.pm
	'(root)' => '(root)',
	'Loading blog failed: [_1]' => 'Laden van blog mislukt: [_1]',
	q{Draft Pages} => q{Kladpagina's},
	q{My Pages} => q{Mijn pagina's},
	q{Pages in This Site} => q{Pagina's op deze website},
	q{Pages in folder: [_1]} => q{Pagina's in map: [_1]},
	q{Published Pages} => q{Gepubliceerde pagina's},
	q{Scheduled Pages} => q{Geplande pagina's},
	q{Unpublished Pages} => q{Niet gepubliceerde pagina's},

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
	'My Text Format' => 'Mijn tekstformaat',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] vanwege regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] vanwege test [_4]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugindata',

## lib/MT/RebuildTrigger.pm
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Rebuild trigger voor inhoudstype #[_1] aan het terugzetten...',
	'Restoring rebuild trigger for blog #[_1]...' => 'Rebuild trigger voor blog #[_1] aan het terugzetten...',

## lib/MT/Revisable.pm
	'Did not get two [_1]' => 'Kreeg geen twee [_1]',
	'Revision Number' => 'Revisienummer',
	'Revision not found: [_1]' => 'Revisie niet gevonden: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Dit zijn verschillende objecttypes, er worden twee [_1] verwacht',
	'Unknown method [_1]' => 'Onbekende methode [_1]',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{Foute RevisioningDriver configuratie '[_1]': [_2]},

## lib/MT/Role.pm
	'Can administer the site.' => 'Kan de site beheren',
	'Can create entries, edit their own entries, and comment.' => 'Kan berichten aanmaken, eigen berichten bewerken en reageren.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kan berichten aanmaken, eigen berichten bewerken, bestanden uploaden en publiceren.',
	'Can manage content types, content data and category sets.' => 'Kan inhoudstypes, inhoudsgegevesn en categoriesets beheren.',
	'Content Designer' => 'Inhoudsontwerper',
	'Contributor' => 'Redactielid',
	'Designer' => 'Designer',
	'Editor' => 'Redacteur',
	'Site Administrator' => 'Sitebeheerder',
	'Webmaster' => 'Webmaster',
	'__ROLE_ACTIVE' => 'Actief',
	'__ROLE_INACTIVE' => 'Gedeactiveerd',
	'__ROLE_STATUS' => 'Status',
	q{Can edit, manage, and publish blog templates and themes.} => q{Kan blogsjablonen en thema's bewerken, beheren en publiceren.},
	q{Can manage pages, upload files and publish site/child site templates.} => q{Kan pagina's beheren, bestanden uploaden en sjablonen van (sub)sites publiceren.},
	q{Can upload files, edit all entries(categories), pages(folders), tags and publish the site.} => q{Kan bestanden uploaden, alle berichten (categorieën), pagina's (mappen), tags bewerken en de site publiceren.},

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Aan dit object is reeds een score toegekend.',
	'Object must be saved first.' => 'Object moet eerst worden opgeslagen',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{Kon score niet instellen voor object '[_1]'(ID: [_2])},

## lib/MT/Session.pm
	'Session' => 'Sessie',

## lib/MT/Tag.pm
	'Not Private' => 'Niet privé',
	'Private' => 'Privé',
	'Tag must have a valid name' => 'Tag moet een geldige naam hebben',
	'Tags with Assets' => 'Tags met mediabestanden',
	'Tags with Entries' => 'Tags met berichten',
	'This tag is referenced by others.' => 'Deze tag is gerefereerd door anderen.',
	q{Tags with Pages} => q{Tags met pagina's},

## lib/MT/TaskMgr.pm
	'Scheduled Tasks Update' => 'Update van geplande taken',
	'The following tasks were run:' => 'Volgende taken moesten uitgevoerd worden:',
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Bekomen van een lock om systeemtaken uit te kunnen voeren mislukt. Kijk na of uw TempDir locatie ([_1]) beschrijfbaar is.',
	q{Error during task '[_1]': [_2]} => q{Fout tijdens taak '[_1]': [_2]},

## lib/MT/Template.pm
	'Build Type' => 'Bouwtype',
	'Category Archive' => 'Archief per categorie',
	'Comment Error' => 'Reactie fout',
	'Comment Listing' => 'Overzicht reacties',
	'Comment Pending' => 'Reactie wordt behandeld',
	'Comment Preview' => 'Voorbeeld reactie',
	'Content Type is required.' => 'Inhoudstype is vereist.',
	'Dynamicity' => 'Dynamiciteit',
	'Index' => 'Index',
	'Individual' => '', # Translate - New
	'Interval' => 'Interval',
	'Module' => 'Module',
	'Output File' => 'Uitvoerbestand',
	'Ping Listing' => 'Overzicht pings',
	'Rebuild with Indexes' => 'Herpubliceren met indexen',
	'Template Text' => 'Sjabloontekst',
	'Template load error: [_1]' => 'Fout bij laden sjabloon: [_1]',
	'Template name must be unique within this [_1].' => 'Sjabloonnaam moet uniek zijn binnen deze [_1].',
	'Template' => 'Sjabloon',
	'Uploaded Image' => 'Opgeladen afbeelding',
	'Widget' => 'Widget',
	'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
	q{Error reading file '[_1]': [_2]} => q{Fout bij het lezen van bestand '[_1]': [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{Gelinkt bestand '[_1]' openen mislukt: [_2]},
	q{Publish error in template '[_1]': [_2]} => q{Publicatiefout in sjabloon '[_1]': [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{Poging het sjabloonbestand te laden van buiten het include pad  '[_1]'},

## lib/MT/Template/Context.pm
	'No Category Set could be found.' => 'Er werd geen categorieset gevonden.',
	'No Content Field could be found.' => 'Er werd geen inhoudsveld gevonden.',
	'No Content Field could be found: "[_1]"' => '', # Translate - New
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wanneer het ID van een blog zowel bij include_blogs als exclude_blogs staat, wordt de blog in kwestie uitgesloten.',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{Het attribuut exclude_blogs kan niet '[_1]' als waarde hebben.},
	q{You have an error in your '[_2]' attribute: [_1]} => q{Er staat een fout in uw '[_2]' attribuut: [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{U gebruikte een '[_1]' tag in de context van een blog die geen deel uitmaakt van een website; Misschien is er een probleem met de gegevens van deze blog?},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{U gebruikten een '[_1]' tag buiten de context van een auteur; Misschien plaatste u de tag per ongeluk buiten een 'MTAuthors' container tag?},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een reactie; Misschien plaatste u die tag per ongeluik buiten een 'MTComments' container tag?},
	q{You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een inhoudsveld; Misschien plaatste u deze per ongeluk buiten een 'MTContents' container tag?},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een pagina; Misschien plaatste u dit per ongeluk buiten een 'MTPages' container tag?},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een ping; Mogelijk plaatste u die per ongeluk buiten een 'MTPings' container tag?},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een mediabestand; Misschien plaatste u dit per ongeluk buiten een 'MTAssets' container tag?},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van een bericht; Misschien plaatste u die tag per ongeluk buiten een 'MTEntries' container tag?},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van de blog; Misschien plaatste u die tag per ongeluk buiten een 'MTBlogs' container tag?},
	q{You used an '[_1]' tag outside of the context of the site;} => q{U gebruikte een '[_1]' tag buiten de context van de site;},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{U gebruikte een '[_1]' tag buiten de context van de website; Misschien plaatste u die tag per ongeluk buiten een 'MTWebsites' container tag?},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => ', letters en cijfers',
	', symbols (such as #!$%)' => ', symbolen (zoals #!$%)',
	', uppercase and lowercase letters' => ', hoofdletters en kleine letters',
	'Actions' => 'Acties',
	'All About Me' => 'Alles over mij',
	'Cannot load template' => 'Kan sjabloon niet laden',
	'Cannot load user.' => 'Kan gebruiker niet laden.',
	'Choose the display options for this content field in the listing screen.' => 'Kies de weergave-opties voor dit inhoudsveld in het overzichtsscherm.',
	'Default' => 'Standaard',
	'Display Options' => 'Weergave-opties',
	'Division by zero.' => 'Deling door nul.',
	'Error in [_1] [_2]: [_3]' => 'Fout in [_1] [_2]: [_3]',
	'Error in file template: [_1]' => 'Fout in bestandssjabloon: [_1]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'Includeren van bestanden is uitgeschakeld via de "AllowFileInclude" configuratiedirectief.',
	'Force' => 'Forceer',
	'Invalid index.' => 'Ongeldige index.',
	'Is this field required?' => 'Is dit veld verplicht in te vullen?',
	'No [_1] could be found.' => '[_1] werden niet gevonden',
	'No template to include was specified' => 'Geen sjabloon opgegeven om te includeren',
	'Optional' => 'Optioneel',
	'Recursion attempt on [_1]: [_2]' => 'Recursiepoging op [_1]: [_2]',
	'Recursion attempt on file: [_1]' => 'Recursiepoging op bestand: [_1]',
	'The entered message is displayed as a input field hint.' => 'De ingevulde boodschap wordt getoond als hint bij het invoerveld.',
	'Unspecified archive template' => 'Niet gespecifiëerd archiefsjabloon',
	'You used a [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig name attribuut',
	'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
	'You used an [_1] tag without a valid [_2] attribute.' => 'U gebruikte een [_1] tag zonder geldig [_2] attribuut.',
	'[_1] [_2]' => '[_1] [_2]',
	'[_1] is not a hash.' => '[_1] is geen hash.',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publiceer[_2] uw [_3] om deze wijzigingen zichtbaar te maken.',
	'[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.' => '', # Translate - New
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiceer[_2] uw site om deze wijzigingen zichtbaar te maken.',
	'blog(s)' => 'blog(s)',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'id attribute is required' => 'id attribuut is vereist',
	'minimum length of [_1]' => 'minimale lengte van [_1]',
	'records' => 'records',
	'website(s)' => 'website(s)',
	q{'[_1]' is not a hash.} => q{'[_1]' is geen hash.},
	q{'[_1]' is not a valid function for a hash.} => q{'[_1]' is geen geldige functie voor een hash.},
	q{'[_1]' is not a valid function for an array.} => q{'[_1]' is geen geldige functie voor een array.},
	q{'[_1]' is not a valid function.} => q{'[_1]' is geen geldige functie.},
	q{'[_1]' is not an array.} => q{'[_1]' is geen array.},
	q{'parent' modifier cannot be used with '[_1]'} => q{'parent' modifier kan niet worden gebruikt met '[_1]'},
	q{Cannot find blog for id '[_1]} => q{Kan geen blog vinden met id '[_1]},
	q{Cannot find entry '[_1]'} => q{Kan bericht '[_1]' niet vinden},
	q{Cannot find included file '[_1]'} => q{Kan geïncludeerd bestand '[_1]' niet vinden},
	q{Cannot find included template [_1] '[_2]'} => q{Kan geincludeerd sjabloon niet vinden: [_1] '[_2]'},
	q{Cannot find template '[_1]'} => q{Kan sjabloon '[_1]' niet vinden},
	q{Error opening included file '[_1]': [_2]} => q{Fout bij het openen van geïncludeerd bestand '[_1]': [_2]},

## lib/MT/Template/Tags/Archive.pm
	'Could not determine content' => 'Kon de inhoud niet bepalen',
	'Could not determine entry' => 'Kon bericht niet bepalen',
	'Group iterator failed.' => 'Group iterator mislukt.',
	'You used an [_1] tag outside of the proper context.' => 'U gebruikte een [_1] tag buiten de juiste context.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kan enkel worden gebruikt met dagelijkse, wekelijkse of maandelijkse archieven.',
	q{You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.} => q{U gebruikte een [_1] tag om te linken naar '[_2]' archieven, maar dat type archieven wordt niet gepubliceerd.},

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',
	q{No such user '[_1]'} => q{Geen gebruiker '[_1]'},

## lib/MT/Template/Tags/Author.pm
	'You used an [_1] without a author context set up.' => 'U gebruikte een [_1] zonder een auteurscontext op te zetten.',
	q{The '[_2]' attribute will only accept an integer: [_1]} => q{Het '[_2]' attribuut accepteert alleen een geheel getal: [_1]},

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Onbekende "mode" attribuutwaarde: [_1].  Geldige waarden zijn "loop" en "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Ongeldig weeks_start_with formaat: moet Sun|Mon|Tue|Wed|Thu|Fri|Sat zijn',
	q{No such category '[_1]'} => q{Geen categorie '[_1]'},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => 'Kan package [_1] niet vinden: [_2]',
	'Cannot use sort_by and sort_method together in [_1]' => 'Kan sort_by en sort_method niet samen gebruiken in [_1]',
	'Error sorting [_2]: [_1]' => 'Fout bij sorteren [_2]: [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1] moet gebruikt worden in een [_2] context',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] kan niet gebruikt worden zonder een [_2] archief te publiceren',
	'[_1] used outside of [_2]' => '[_1] gebruikt buiten [_2]',

## lib/MT/Template/Tags/ContentType.pm
	'Content Type was not found. Blog ID: [_1]' => 'Inhoudstype werd niet gevonden.  Blog ID: [_1]',
	'Invalid field_value_handler of [_1].' => 'Ongeldige field_valule_handler van [_1].',
	'Invalid tag_handler of [_1].' => 'Ongeldige tag_handler van [_1]',
	'No Content Field Type could be found.' => 'Er kon geen inhoudsveldtype worden gevonden.',

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',
	'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',

## lib/MT/Template/Tags/Misc.pm
	q{Specified WidgetSet '[_1]' not found.} => q{Opgegeven widgetset '[_1]' niet gevonden.},

## lib/MT/Template/Tags/Tag.pm
	'content_type modifier cannot be used with type "[_1]".' => 'content_type modifier kan niet gebruikt worden met type "[_1]".',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Archiefkoppeling',
	'Archive Mappings' => 'Archiefkoppelingen',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Jobfout',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Job exitstatus',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Jobfunctie',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Job',

## lib/MT/Theme.pm
	'A fatal error occurred while applying element [_1]: [_2].' => 'Er deed zich een fatale fout voor bij het toepassen van element [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Er deed zich een fout voor bij het toepassen van element [_1]: [_2].',
	'Default Content Data' => 'Standaard inhoudsgegevens',
	'Default Prefs' => 'Standaardvoorkeuren',
	'Failed to copy file [_1]:[_2]' => 'Kopiëren van bestand [_1] mislukt: [_2]',
	'Failed to load theme [_1].' => 'Thema [_1] laden mislukt.',
	'Static Files' => 'Statische bestanden',
	'Template Set' => 'Set sjablonen',
	'There was an error converting image [_1].' => 'Er deed zich een fout voor bij het converteren van de afbeelding [_1].',
	'There was an error creating thumbnail file [_1].' => 'Er deed zich een fout voor bij het aanmaken van thumbnail bestand [_1].',
	'There was an error scaling image [_1].' => 'Er deed zich een fout voor bij het schalen van de afbeelding [_1].',
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but is not installed.} => q{Component '[_1]' versie [_2] of hoger is nodig om dit thema te kunnen gebruiken maar is niet geïnstalleerd.},
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but the installed version is [_3].} => q{Component '[_1]' versie [_2] of hoger is nodig om dit thema te kunnen gebruiken maar de geïnstalleerde versie is [_3]},
	q{Default Pages} => q{Standaardpagina's},
	q{Element '[_1]' cannot be applied because [_2]} => q{Element '[_1]' kan niet worden toegepast omdat [_2]},

## lib/MT/Theme/Category.pm
	'Failed to save category_order: [_1]' => 'Opslaan van category_order mislukt: [_1]',
	'Failed to save folder_order: [_1]' => 'Opslaan van folder_order mislukt: [_1]',
	'[_1] top level and [_2] sub categories.' => '[_1] hoofdcategoriën en [_2] subcategorieën.',
	'[_1] top level and [_2] sub folders.' => '[_1] hoofdmappen en [_2] submappen.',

## lib/MT/Theme/CategorySet.pm
	'[_1] category sets.' => '[_1] categoriesets.',

## lib/MT/Theme/ContentData.pm
	'Failed to find content type: [_1]' => 'Kon inhoudstype niet vinden: [_1]',
	'Invalid theme_data_import_handler of [_1].' => 'Ongeldige theme_data_import_handler van [_1].',
	'[_1] content data.' => '[_1] inhoudsgegevens.',

## lib/MT/Theme/ContentType.pm
	'Invalid theme_import_handler of [_1].' => 'Ongeldige theme_import_handler van [_1].',
	'[_1] content types.' => '[_1] inhoudstypes.',
	'some content field in this theme has invalid type.' => 'een inhoudsveld in dit thema heeft een ongeldig type.',
	'some content type in this theme have been installed already.' => 'een inhoudstype in dit thema is reeds geïnstalleerd.',

## lib/MT/Theme/Element.pm
	'Internal error: the importer is not found.' => 'Interne fout: de importer werd niet gevonden.',
	q{An Error occurred while applying '[_1]': [_2].} => q{Er deed zich een fout voor bij het toepassen van '[_1]': [_2].},
	q{Compatibility error occurred while applying '[_1]': [_2].} => q{Er deed zich een compatibiliteitsprobleem voor bij het toepassen van '[_1]': [_2].},
	q{Component '[_1]' is not found.} => q{Component '[_1]' niet gevonden.},
	q{Fatal error occurred while applying '[_1]': [_2].} => q{Er deed zich een fatale fout voor bij het toepassen van '[_1]': [_2].},
	q{Importer for '[_1]' is too old.} => q{Importeerder voor '[_1]' is te oud.},
	q{Theme element '[_1]' is too old for this environment.} => q{Thema element '[_1]' is te oud voor deze omgeving.},

## lib/MT/Theme/Entry.pm
	q{[_1] pages} => q{[_1] pagina's},

## lib/MT/Theme/Pref.pm
	'Failed to save blog object: [_1]' => 'Opslaan blogobject mislukt: [_1]',
	'default settings for [_1]' => 'standaardinstellingen voor [_1]',
	'default settings' => 'standaardinstellingen',
	'this element cannot apply for non blog object.' => 'dit element kan niet toegepast worden op een non-blog opbject.',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Een set sjabonen met [quant,_1,sjabloon,sjablonen], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets]',
	'Failed to make templates directory: [_1]' => 'Aanmaken map voor sjablonen mislukt: [_1]',
	'Failed to publish template file: [_1]' => 'Publicatie sjabloonbestand mislukt: [_1]',
	'Widget Sets' => 'Widgetsets',
	'exported_template set' => 'geëxporteerde sjabloonset',

## lib/MT/Upgrade.pm
	'Database has been upgraded to version [_1].' => 'Database is bijgewerkt naar versie [_1].',
	'Error loading class [_1].' => 'Fout bij het laden van klasse [_1].',
	'Error loading class: [_1].' => 'Fout bij het laden van klasse: [_1].',
	'Error saving [_1] record # [_3]: [_2]...' => 'Fout bij opslaan [_1] record # [_3]: [_2]...',
	'Invalid upgrade function: [_1].' => 'Ongeldige upgrade-functie: [_1].',
	'Upgrading database from version [_1].' => 'Database wordt bijgewerkt van versie [_1].',
	'Upgrading table for [_1] records...' => 'Tabel aan het upgraden voor [_1] records...',
	q{Plugin '[_1]' installed successfully.} => q{Plugin '[_1]' met succes geïnstalleerd.},
	q{Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).} => q{Plugin '[_1]' met succes bijgewerkt naar versie [_2] (schema versie [_3]).},
	q{User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).} => q{Gebruiker '[_1]' installeerde plugin '[_2]', versie [_3] (schema versie [_4]).},
	q{User '[_1]' upgraded database to version [_2]} => q{Gebruiker '[_1]' deed een upgrade van de database naar versie [_2]},
	q{User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).} => q{Gebruiker '[_1]' deed een upgrade van plugin '[_2]' naar versie [_3] (schema versie [_4]).},

## lib/MT/Upgrade/Core.pm
	'Assigning category parent fields...' => 'Velden van hoofdcategorieën worden toegewezen...',
	'Assigning custom dynamic template settings...' => 'Aangepaste instellingen voor dynamische sjablonen worden toegewezen...',
	'Assigning template build dynamic settings...' => 'Instellingen voor dynamische sjabloonopbouw worden toegewezen...',
	'Assigning user types...' => 'Gebruikertypes worden toegewezen...',
	'Assigning visible status for TrackBacks...' => 'Zichtbaarheidsstatus van TrackBacks wordt toegekend...',
	'Assigning visible status for comments...' => 'Status zichtbaarheid van reacties wordt toegekend...',
	'Creating initial user records...' => 'Bezig initiële gebruikersrecords aan te maken...',
	'Error creating role record: [_1].' => 'Fout bij aanmaken record voor rol: [_1].',
	'Error saving record: [_1].' => 'Fout bij opslaan gegevens: [_1].',
	'Expiring cached MT News widget...' => 'Gecached MT Nieuws Widget aan het verversen...',
	'Mapping templates to blog archive types...' => 'Bezig met sjablonen aan archieftypes toe te wijzen...',
	'Upgrading asset path information...' => 'Bezig padinformatie van mediabestanden bij te werken...',
	q{Creating new template: '[_1]'.} => q{Nieuw sjabloon wordt aangemaakt: '[_1]'.},

## lib/MT/Upgrade/v1.pm
	'Creating entry category placements...' => 'Bezig berichten in categoriën te plaatsen...',
	'Creating template maps...' => 'Bezig sjabloonkoppelingen aan te maken...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2].',

## lib/MT/Upgrade/v2.pm
	'Assigning comment/moderation settings...' => 'Instellingen voor reacties/moderatie worden toegewezen...',
	'Updating category placements...' => 'Categorieplaatsingen worden bijgewerkt...',

## lib/MT/Upgrade/v3.pm
	'Assigning basename for categories...' => 'Basisnaam voor categorieën wordt toegekend...',
	'Assigning blog administration permissions...' => 'Blog administrator permissies worden toegekend...',
	'Assigning entry basenames for old entries...' => 'Basisnamen voor oude berichten worden toegekend...',
	'Assigning user status...' => 'Gebruikersstatus wordt toegekend...',
	'Creating configuration record.' => 'Configuratiegegevens aan het aanmaken.',
	'Custom ([_1])' => 'Gepersonaliseerd ([_1])',
	'Migrating any "tag" categories to new tags...' => 'Alle "tag" categorieën worden naar nieuwe tags gemigreerd...',
	'Migrating permissions to roles...' => 'Permissies aan het migreren naar rollen...',
	'Removing Dynamic Site Bootstrapper index template...' => 'Dynamisch site bootstrapper indexsjabloon wordt verwijderd...',
	'Setting blog allow pings status...' => 'Status voor toelaten van pings per blog wordt ingesteld...',
	'Setting blog basename limits...' => 'Basisnaamlimieten blog worden ingesteld...',
	'Setting default blog file extension...' => 'Standaard blogbestand extensie wordt ingesteld...',
	'Setting new entry defaults for blogs...' => 'Standaardinstellingen voor nieuwe blogs aan het vastleggen...',
	'Setting your permissions to administrator.' => 'Uw permissies worden ingesteld als administrator...',
	'This role was generated by Movable Type upon upgrade.' => 'Deze rol werd aangemaakt door Movable Type tijdens de upgrade.',
	'Updating blog comment email requirements...' => 'Vereisten voor e-mail bij reacties op de weblog worden bijgewerkt...',
	'Updating blog old archive link status...' => 'Status van oude archieflinks van blog wordt bijgewerkt...',
	'Updating comment status flags...' => 'Statusvelden van reacties worden bijgewerkt...',
	'Updating commenter records...' => 'Info over reageerders wordt bijgewerkt...',
	'Updating entry week numbers...' => 'Weeknummers van berichten worden bijgewerkt...',
	'Updating user permissions for editing tags...' => 'Gebruikerspermissies voor het bewerken van tags worden bijgewerkt...',
	'Updating user web services passwords...' => 'Web service wachtwoorden van de gebruiker worden bijgewerkt...',

## lib/MT/Upgrade/v4.pm
	'Adding new feature widget to dashboard...' => 'Nieuw widget wordt aan dashbord toegevoegd...',
	'Assigning author basename...' => 'Basisnaam auteur aan het toekennen...',
	'Assigning blog page layout...' => 'Blog pagina layout aan het toekennen...',
	'Assigning blog template set...' => 'Blog sjabloonset aan het toekennen...',
	'Assigning embedded flag to asset placements...' => 'Markering voor inbedding van mediabestanden aan het toekennen...',
	'Assigning entry comment and TrackBack counts...' => 'Tellingen aantal reacties en TrackBacks bericht aan het toekennen...',
	'Assigning junk status for TrackBacks...' => 'Spamstatus wordt toegekend aan TrackBacks...',
	'Assigning junk status for comments...' => 'Spamstatus wordt aan reacties toegewezen...',
	'Assigning user authentication type...' => 'Gebruikersauthenticatietype aan het toekennen...',
	'Cannot rename in [_1]: [_2].' => 'Kan naam niet aanpassen in [_1]: [_2]',
	'Classifying category records...' => 'Categorieën aan het klasseren...',
	'Classifying entry records...' => 'Berichten aan het klasseren...',
	'Comment Posted' => 'Reactie geplaatst',
	'Comment Response' => 'Bevestiging reactie',
	'Comment Submission Error' => 'Fout bij indienen reactie',
	'Confirmation...' => 'Bevestiging...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fout bij het aanpassen van de bestandsnamen van PHP bestanden.  Kijk in het activiteitenlog voor details.',
	'Merging comment system templates...' => 'Bezig reactiesysteemsjabonen samen te voegen...',
	'Migrating Nofollow plugin settings...' => 'Nofollow plugin instellingen worden gemigreerd',
	'Migrating permission records to new structure...' => 'Permissies worden gemigreerd naar de nieuwe structuur...',
	'Migrating role records to new structure...' => 'Rollen worden gemigreerd naar de nieuwe structuur',
	'Migrating system level permissions to new structure...' => 'Systeempermissies worden gemigreerd naar de nieuwe structuur...',
	'Moving OpenID usernames to external_id fields...' => 'OpenID gebruikersnamen aan het verplaatsen naar external_id velden...',
	'Moving metadata storage for categories...' => 'Metadata opslag voor categoriën wordt verplaatst...',
	'Populating authored and published dates for entries...' => 'Bezig creatie- en publicatiedatums voor berichten in te stellen...',
	'Populating default file template for templatemaps...' => 'Bezig standaard sjabloonbestand voor sjabloonmappings in te stellen...',
	'Removing unnecessary indexes...' => 'Onnodige indexen worden verwijderd...',
	'Removing unused template maps...' => 'Bezig ongebruikte sjabloon-mappings te verwijderen...',
	'Renaming PHP plugin file names...' => 'PHP plugin bestandsnamen aan het aanpassen...',
	'Replacing file formats to use CategoryLabel tag...' => 'Bestandsformaten aan het vervangen om CategoryLabel tag te gebruiken...',
	'Return to the <a href="[_1]">original entry</a>.' => 'Ga terug naar het <a href="[_1]">oorspronkelijke bericht</a>.',
	'Thank you for commenting.' => 'Bedankt voor uw reactie.',
	'Updating password recover email template...' => 'Sjabloon wachtwoordrecuperatie e-mail wordt bijgewerkt...',
	'Updating system search template records...' => 'Systeemzoeksjablonen worden bijgewerkt...',
	'Updating template build types...' => 'Publicatietype sjablonen bij aan het werken...',
	'Updating widget template records...' => 'Bezig widgetsjablooninformatie bij te werken...',
	'Upgrading metadata storage for [_1]' => 'Metadata opslag voor [_1] wordt bijgewerkt',
	'Your comment has been posted!' => 'Uw reactie is geplaatst!',
	'Your comment has been received and held for review by a blog administrator.' => 'Uw reactie werd ontvangen en wordt bewaard tot ze kan worden beoordeeld door een blog administrator.',
	'Your comment submission failed for the following reasons:' => 'Het indienen van uw reactie mislukte omwille van volgende redenen:',
	'[_1]: [_2]' => '[_1]: [_2]',

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => 'Bezig notificatiedashboardwidget toe te voegen',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Er deed zich een fout voor bij het aanmaken van een website tijdens de upgrade: [_1]',
	'Assigning ID of author for entries...' => 'ID van auteur wordt toegekend aan berichten...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Bezig een taal in te stellen voor elke blog om het juiste weergaveformaat voor datums te helpen kiezen...',
	'Assigning new system privilege for system administrator...' => 'Nieuwe systeemprivileges aan het toekennen aan systeembeheerder...',
	'Assigning to  [_1]...' => 'Toe aan het kennen aan [_1]...',
	'Can administer the website.' => 'Kan de website beheren',
	'Classifying blogs...' => 'Blogs aan het classificeren...',
	'Designer (MT4)' => 'Designer (MT4)',
	'Error loading role: [_1].' => 'Fout bij laden rollen: [_1].',
	'Generated a website [_1]' => 'Website [_1] aangemaakt',
	'Generic Website' => 'Generieke website',
	'Granting new role to system administrator...' => 'Niewe rol aan het geven aan systeembeheerder...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Bezig DefaultSiteURL/DefaultSiteRoot te migreren naar de website...',
	'Migrating [_1]([_2]).' => 'Migratie van [_1]([_2]).',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Bezig bestaande [quant,_1,blog,blogs] te migreren naar websites (met kinderen)...',
	'Migrating mtview.php to MT5 style...' => 'Bezig mtview.php te migreren naar de MT5 versie...',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Blog [_1] ([_2]) werd verplaatst tot onder website [_3]',
	'New WebSite [_1]' => 'Nieuwe website [_1]',
	'Ordering Categories and Folders of Blogs...' => 'Bezig categorieën en mappen van blogs te sorteren...',
	'Ordering Folders of Websites...' => 'Bezig mappen van websites te sorteren...',
	'Populating generic website for current blogs...' => 'Generieke website aan het invullen voor huidige blogs...',
	'Populating new role for theme...' => 'Nieuwe rol aan het invullen voor thema...',
	'Populating new role for website...' => 'Nieuwe rollen aan het invullen voor website...',
	'Rebuilding permissions...' => 'Permissies opnieuw aan het opbouwen...',
	'Recovering type of author...' => 'Type auteur wordt opgehaald...',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Technorati update-ping service aan het verwijderen van [_1] (ID:[_2]).',
	'Removing widget from dashboard...' => 'Widget wordt verwijderd van dashboard...',
	'Updating existing role name...' => 'Bestaande rolnamen aan het bijwerken...',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Website Administrator' => 'Websitebeheerder',
	'_WEBMASTER_MT4' => 'Webmaster',
	q{An error occurred during migrating a blog's site_url: [_1]} => q{Er deed zich een fout voor bij het migreren van de site_url van een blog: [_1]},
	q{Can edit, manage and publish blog templates and themes.} => q{Kan sjablonen en thema's van een blog bewerken, beheren en publiceren.},
	q{Can manage pages, Upload files and publish blog templates.} => q{Kan pagina's beheren, bestanden uploaden en blogsjablonen publiceren.},
	q{New user's website} => q{Website nieuwe gebruiker},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{Bezig het 'created by' ID in te stellen voor elke gebruiker waarvoor dit veld niet gedefiniëerd is...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => 'Bezig "Sitestatistieken" dashboard widget te migreren...',
	'Adding Website Administrator role...' => 'Bezig Website Administrator rol toe te voegen...',
	'Fixing TheSchwartz::Error table...' => 'Bezig TheSchwartz::Error tabel te repareren...',
	'Migrating current blog to a website...' => 'Bezig huidige blog te migreren naar een website...',
	'Migrating the record for recently accessed blogs...' => 'Bezig de gegevens over recent gebruikte blogs te migreren...',
	'Rebuilding permission records...' => 'Bezig permissierecords opnieuw aan te maken...',
	'Reordering dashboard widgets...' => 'Bezig dashboardwidgets te herschikken...',

## lib/MT/Upgrade/v7.pm
	'Adding site list dashboard widget for mobile...' => '', # Translate - New
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Ken een Site Administrator rol toe aan een websitebeheerder met blogs...',
	'Assign a Site Administrator Role for Manage Website...' => 'Ken een Site Administrator rol toe aen een websitebeheerder',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Bezig de Subsite Administrator rol te veranderen aan de Site Administrator rol.',
	'Child Site Administrator' => 'Subsite Administrator',
	'Cleaning up content field indexes...' => 'Bezig content field indexes op te schonen...',
	'Cleaning up objectasset records for content data...' => 'Bezig objectasset records voor inhoudsgegevens op te schonen...',
	'Cleaning up objectcategory records for content data...' => 'Bezig objectcategory records voor inhoudsgegevens op te schonen...',
	'Cleaning up objecttag records for content data...' => 'Bezig objecttag records voor inhoudsgegevesn op te schonen...',
	'Create a new role for creating a child site...' => 'Bezig nieuwe rol aan te maken om subsites aan te maken...',
	'Create new role: [_1]...' => 'Nieuwe rol aanmaken: [_1]...',
	'Error removing record (ID:[_1]): [_2].' => 'Fout bij verwijderen record (ID:[_1]): [_2].',
	'Error removing records: [_1]' => 'Fout bij verwijderen records: [_1]',
	'Error saving record (ID:[_1]): [_2].' => 'Fout bij opslaan record (ID:[_1]): [_2].',
	'Error saving record: [_1]' => 'Fout bij oplsaan record: [_1]',
	'Migrating Max Length option of Single Line Text fields...' => 'Bezig de opties voor maximale lengte van enkellijnstekstvelden te migreren...',
	'Migrating MultiBlog settings...' => 'Bezig met migratie MultiBlog instellingen...',
	'Migrating create child site permissions...' => 'Bezig permissies te migreren om subsites aan te maken...',
	'Migrating data column of MT::ContentData...' => 'Bezig met migratie van data kolom van MT::ContentData...',
	'Migrating fields column of MT::ContentType...' => 'Bezig met migratie van fields kolom van MT::ContentType...',
	'MultiBlog migration for site(ID:[_1]) is skipped due to the data breakage.' => '', # Translate - New
	'MultiBlog migration is skipped due to the data breakage.' => '', # Translate - New
	'Rebuilding Content Type count of Category Sets...' => 'Bezig telling van inhoudstypes van categoriesets opnieuw te publiceren...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van embedded_text veld...',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van multi_line_text veld...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van number veld...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van single_line_text veld...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van tables veld...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van url veld...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Bezig MT::Permission records opnieuw op te bouwen (verwijdering van edit_categories)...',
	'Rebuilding content field permissions...' => 'Bezig permissies voor inhoudsvelden opnieuw op te bouwen...',
	'Rebuilding object assets...' => 'Bezig objectmediabestanden opnieuw op te bouwen...',
	'Rebuilding object categories...' => 'Bezig objectcategoriën opnieuw op te bouwen...',
	'Rebuilding object tags...' => 'Bezig objecttags opnieuw op te bouwen...',
	'Remove SQLSetNames...' => '', # Translate - New
	'Reorder DEBUG level' => '', # Translate - New
	'Reorder SECURITY level' => '', # Translate - New
	'Reorder WARNING level' => '', # Translate - New
	'Reset default dashboard widgets...' => 'Standaard dashboard widgets terugzetten...',
	'Some MultiBlog migrations for site(ID:[_1]) are skipped due to the data breakage.' => '', # Translate - New
	'Truncating values of value_varchar column...' => 'Bezig waarden van value_varchar kolom in te korten...',
	'add administer_site permission for Blog Administrator...' => 'voeg admininister_site permissie toe aan Blog Administrator...',
	'change [_1] to [_2]' => 'wijzig [_1] naar [_2]',

## lib/MT/Util.pm
	'[quant,_1,day,days] from now' => 'over [quant,_1,dag,dagen]',
	'[quant,_1,day,days]' => '[quant,_1,dag,dagen]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,dag,dagen] en [quant,_2,uur,uur] geleden',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'over [quant,_1,dag,dagen] en [quant,_2,uur,uur]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,dag,dagen], [quant,_2,uur,uren]',
	'[quant,_1,hour,hours] from now' => 'over [quant,_1,uur,uur]',
	'[quant,_1,hour,hours]' => '[quant,_1,uur,uren]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,uur,uur], [quant,_2,minuut,minuten] geleden',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'over [quant,_1,uur,uur] en [quant,_2,minuut,minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten]',
	'[quant,_1,minute,minutes] from now' => 'over [quant,_1,minuut,minuten]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minuut,minuten]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'over [quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
	'[quant,_1,second,seconds] from now' => 'over [quant,_1,seconde,seconden]',
	'[quant,_1,second,seconds]' => '[quant,_1,seconde,seconden]',
	'less than 1 minute ago' => 'minder dan 1 minuut geleden',
	'less than 1 minute from now' => 'binnen minder dan 1 minuut',
	'moments from now' => 'ogenblikken in de toekomst',
	q{Invalid domain: '[_1]'} => q{Ongeldig domein: '[_1]'},

## lib/MT/Util/Archive.pm
	'Registry could not be loaded' => 'Registry kon niet worden geladen',
	'Type must be specified' => 'Type moet worden opgegeven',

## lib/MT/Util/Archive/BinTgz.pm
	'Both data and file name must be specified.' => 'Zowel data gen bestandsnaam moeten worden opgegeven.',
	'Cannot extract from the object' => 'Kan extractie uit object niet uitvoeren',
	'Cannot find external archiver: [_1]' => '', # Translate - New
	'Cannot write to the object' => 'Kan niet schrijven naar het object',
	'Failed to create an archive [_1]: [_2]' => '', # Translate - New
	'File [_1] exists; could not overwrite.' => 'Bestand [_1] bestaat; kon niet worden overschreven.',
	'Type must be tgz.' => 'Type moet tgz zijn.',
	'[_1] in the archive contains ..' => '[_1] in het archief bevat ..',
	'[_1] in the archive is an absolute path' => '[_1] in het archief is een absoluut pad',
	'[_1] in the archive is not a regular file' => '[_1] in het archief is geen gewoon bestand',

## lib/MT/Util/Archive/BinZip.pm
	'Failed to rename an archive [_1]: [_2]' => '', # Translate - New
	'Type must be zip' => 'Type moet zip zijn.',

## lib/MT/Util/Archive/Tgz.pm
	'Could not read from filehandle.' => 'Kon filehandle niet lezen.',
	'File [_1] is not a tgz file.' => 'Bestand [_1] is geen tgz bestand.',

## lib/MT/Util/Archive/Zip.pm
	'File [_1] is not a zip file.' => 'Bestand [_1] is geen zip bestand.',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Image creation failed.' => 'Afbeelding aanmaken mislukt.',
	'Image error: [_1]' => 'Afbeelding fout: [_1]',
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Standaard CAPTCHA provider van Movable Type vereist Image::Magick.',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',
	'You need to configure CaptchaSourceImageBase.' => 'U moet CaptchaSourceImageBase nog configureren.',

## lib/MT/Util/Log.pm
	'Cannot load Log module: [_1]' => 'Kan logmodule niet laden: [_1]',
	'Logger configuration for Log module [_1] seems problematic' => '', # Translate - New
	'Unknown Logger Level: [_1]' => 'Onbekend logniveau: [_1]',

## lib/MT/Util/YAML.pm
	'Cannot load YAML module: [_1]' => 'Kan YAML module niet laden:',
	'Invalid YAML module' => 'Ongeldige YAML module',

## lib/MT/WeblogPublisher.pm
	'An error occurred while publishing scheduled entries: [_1]' => 'Er deed zich een fout voor bij het publiceren van van geplande berichten: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Er deed zich een fout voor bij het ongedaan maken van de publicatie van oude berichten: [_1]',
	'Blog, BlogID or Template param must be specified.' => 'Blog, BlogID of Template parameter moet opgegeven zijn.',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Hetzelfde archiefbestand bestaat al. U moet de basisnaam of het archiefpad wijzigen. ([_1])',
	'unpublish' => 'Publicatie ongedaan maken',
	q{Template '[_1]' does not have an Output File.} => q{Sjabloon '[_1]' heeft geen uitvoerbestand.},

## lib/MT/Website.pm
	'Child Site Count' => 'Aantal subsites',
	'First Website' => 'Eerste website',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- set afgerond ([quant,_1,bestand,bestanden] in [_2] seconden)',
	'Background Publishing Done' => 'Achtergrondpublicatie voltooid',
	'Error rebuilding file [_1]:[_2]' => 'Fout bij rebuilden bestand [_1]: [_2]',
	'Published: [_1]' => 'Gepubliceerd:',

## lib/MT/Worker/Sync.pm
	'Done Synchronizing Files' => 'Synchroniseren bestanden voltooid',
	'Done syncing files to [_1] ([_2])' => 'Klaar met synchroniseren van bestanden naar [_1] ([_2])',
	qq{Error during rsync of files in [_1]:\n} => qq{Fout bij het rsyncen van bestanden in [_1]:\n},

## lib/MT/XMLRPCServer.pm
	'Error writing uploaded file: [_1]' => 'Fout bij het schrijven van opgeladen bestand: [_1]',
	'Invalid login' => 'Ongeldige gebruikersnaam',
	'Invalid timestamp format' => 'Ongeldig timestamp formaat',
	'No blog_id' => 'Geen blog_id',
	'No entry_id' => 'Geen entry_id',
	'No filename provided' => 'Geen bestandsnaam opgegeven',
	'No web services password assigned.  Please see your user profile to set it.' => 'Geen web services wachtwoord ingesteld.  Ga naar uw gebruikersprofiel om het in te stellen.',
	'Not allowed to edit entry' => 'Geen toestemming om bericht te bewerken',
	'Not allowed to get entry' => 'Geen toestemming om het bericht op te halen',
	'Not allowed to set entry categories' => 'Geen toestemming om de categorieën van het bericht in te stellen',
	'Not allowed to upload files' => 'Geen toestemming om bestanden te uploaden',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Perl module Image::Size is nodig om de breedte en hoogte van opgeladen afbeeldingen te bepalen.',
	'Publishing failed: [_1]' => 'Publicatie mislukt: [_1]',
	'Saving folder failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Sjabloonmethodes zijn niet geïmplementeerd wegens het verschil tussen de Blogger API en de Movable Type API.',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{Bericht '[_1]' ([lc,_5] #[_2]) verwijderd door '[_3]' (gebruiker #[_4]) via xml-rpc},
	q{Invalid entry ID '[_1]'} => q{Ongeldig entry ID '[_1]'},
	q{Requested permalink '[_1]' is not available for this page} => q{Gevraagde permalink '[_1]' is niet beschikbaar voor deze pagina},
	q{Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')} => q{Waarde voor 'mt_[_1]' moet 0 of 1 zijn (was '[_2]')},

## mt-check.cgi
	'(Probably) running under cgiwrap or suexec' => '(Waarschijnlijk) uitgevoerd onder cgiwrap of suexec',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar is vereist om bestanden te kunnen manipuleren tijdens backup en restore operaties.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip is vereist om bestanden te kunnen manipuleren tijdens backup en restore operaties.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie is vereist om authenticatie via cookies te kunnen gebruiken.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File is vereist als u wenst dat reageerders zich kunnen aanmelden met OpenID via Yahoo! Japan.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached en een memcached server zijn vereist om het cachen in het geheugen van objecten mogelijk te maken voor de servers waarop Movable Type draait.',
	'Checking for' => 'Controleren op',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA is optioneel; Als het is geïnstalleerd dan verloopt registratie van reageerders iets sneller.',
	'Current working directory:' => 'Huidige werkmap:',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist om gebruikt te kunnen maken van een PostgreSQL database backend.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI en DBD::SQLite zijn vereist om gebruikt te kunnen maken van een SQLite database backend.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI en DBD::SQLite2 zijn vereist om gebruikt te kunnen maken van een SQLite2 database backend.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist om gebruikt te kunnen maken van een MySQL database backend.',
	'DBI is required to store data in database.' => 'DBI is vereist om gegevens te kunnen opslaan in een database',
	'Data Storage' => 'Gegevensopslag',
	'Details' => 'Details',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 en de daarvoor benodigde bestanden zijn vereist om reageerders te kunnen toestaan zich aan te melden via OpenID providers, waaronder LiveJournal.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp is optioneel; Het is vereist als u bestaande bestanden wenst te kunnen overschrijven bij uploads.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip is vereist om bestanden te kunnen comprimeren tijdens backupoperaties',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress:Gunzip is vereist om bestanden te kunnen decomprimeren tijdens restore-operaties.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Run is optioneel; Het is veriest als u NetPBM wenst te gebruiken als de afbeeldingsbewerker voor Movable Type',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size is vereist om bestanden te kunnen uploaden (om het formaat van verschillende soorten afbeeldingsbestanden te kunnen bepalen).',
	'Installed' => 'Geïnstalleerd',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 is vereist om het registreren van reageerders in te schakelen en om mail te kunnen versturen via een SMTP server.',
	'MT home directory:' => 'MT hoofdmap:',
	'Movable Type System Check Successful' => 'Movable Type Systeemcontrole met succes afgerond',
	'Movable Type System Check' => 'Movable Type Systeemcontrole',
	'Movable Type version:' => 'Movable Type versie:',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP is vereist om mail te kunnen versturen via een SMTP server.',
	'Operating system:' => 'Operating systeem:',
	'Perl include path:' => 'Perl include pad:',
	'Perl version:' => 'Perl versie:',
	'Please consult the installation instructions for help in installing [_1].' => 'Gelieve de installatiehandleiding te raadplegen voor hulp met de installatie van [_1]',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Lite is optioneel; Het is vereist als u de MT XML-RPC server implementatie wenst te gebruiken.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable is optioneel; Het is vereist door bepaalde Movable Type plugins ontwikkeld door derden.',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'Van de versie van DBD::mysql die op uw server geïnstalleerd is, is geweten dat ze niet compatibel is met Movable Type.  Gelieve de meest recent beschikbare versie te installeren.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Het MT-Check rapport is uitgeschakeld wanneer Movable Type een geldig configuratiebestand (mt-config.cgi) heeft',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => 'De [_1] is correct geïnstalleerd maar vereist een bijgewerkte DBI module.  Zie ook de opmerking hierboven over vereisten voor de DBI module.',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Volgende modules zijn <strong>optioneel</strong>.  Als deze modules niet op uw server geïnstalleerd zijn dan moet u ze enkel installeren als u de functionaliteit nodig heeft die ze toevoegen.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Volgende modules zijn vereist door de databases waar Movable Type mee gebruikt kan worden.  Op uw server moet DBI en minstens één van de gerelateerde modules geïnstalleerd zijn om de applicatie te doen werken.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'De versie van Perl die op uw server geïnstalleerd is ([_1]) is lager dan de minimum versie die ondersteund wordt ([_2]).  Gelieve te upgraden naar minstens Perl [_2].',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Deze module en de modules die ervan afhangen zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Deze module is vereist door mt-search.cgi als u Movable Type draait op een versie van Perl ouder dan 5.8.',
	'This module required for action streams.' => '', # Translate - New
	'Web server:' => 'Webserver:',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom is vereist om de Atom API te kunnen gebruiken.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX en de modules die er van afhangen zijn vereist om een backup te kunnen terugzetten die werd gemaakt tijdens een backup/restore operatie.',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'U heeft geprobeerd een optie te gebruiken waar u niet voldoende rechten voor heeft.  Als u gelooft dat u deze boodschap onterecht te zien krijgt, contacteer dan uw systeembeheerder.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] is niet geïnstalleerd op uw server of [_1] vereist een andere module die niet is geïnstalleerd.',
	'Your server has [_1] installed (version [_2]).' => '[_1] is op uw server geïnstalleerd (versie [_2]).',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle vereiste modules zijn geïnstalleerd op de server; u moet geen bijkomende modules installeren.  Ga verder met de installatie-instructies.',
	'[_1] [_2] Modules' => '[_1] [_2] modules',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] is optioneel; Het is een beter, sneller en lichter alternatief voor YAML::Tiny bij het behandelen van YAML bestanden.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1] is optioneel; Het is één van de modules voor afbeeldingsbewerking die u kunt gebruiken om thumbnails te maken van geuploade afbeeldingen.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] is optioneel; Het is één van de modules die nodig zijn om een backup terug te zetten tijdens een backup/restore operatie',
	'unknown' => 'onbekend',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Het script mt-check.cgi geeft u informatie over de configuratie van uw systeem en controleert of u alle benodigde componenten heeft om Movable Type te kunnen draaien.},
	q{You're ready to go!} => q{Klaar om van start te gaan!},

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => 'Doorgaan',
	'You have unsaved changes to this page that will be lost.' => 'U heeft niet opgeslagen veranderingen op deze pagina die verloren zullen geen.',

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'Ongeldige URL',
	'Invalid date format' => 'Ongeldig datumformaat',
	'Invalid time format' => 'Ongeldig tijdsformaat',
	'Invalid value' => 'Ongeldige waarde',
	'Only 1 option can be selected' => 'Slechts één optie kan worden geselecteerd',
	'Options greater than or equal to [_1] must be selected' => 'Opties groter dan of gelijk aan [_1] moeten geselecteerd worden',
	'Options less than or equal to [_1] must be selected' => 'Opties kleiner dan of gelijk aan [_1] moeten geselecteerd worden',
	'Please input [_1] characters or more' => 'Gelieve [_1] of meer karakters in te voeren',
	'Please select one of these options' => 'Gelieve één van deze opties te selecteren',
	'This field is required' => 'Dit veld is verplicht',
	'This field must be a number' => 'Dit veld moet een getal bevatten',
	'This field must be a signed integer' => 'Dit veld moet een signed integer zijn',
	'This field must be a signed number' => 'Dit veld moet een postitief of negatief getal bevatten',
	'This field must be an integer' => 'Dit veld moet een integer bevatten',
	'You have an error in your input.' => 'Er staat een fout in uw invoer.',

## mt-static/js/assetdetail.js
	'Dimensions' => 'Dimensies',
	'File Name' => 'Bestandsnaam',
	'No Preview Available.' => 'Geen voorbeeld beschikbaar',

## mt-static/js/contenttype/tag/content-field.tag
	'ContentField' => 'ContentField',
	'Move' => 'Verplaats',

## mt-static/js/contenttype/tag/content-fields.tag
	'Allow users to change the display and sort of fields by display option' => 'Gebruikers toestaan om de volgorde en weergave van velden te veranderen via de weergaveopties',
	'Data Label Field' => 'Datalabel veld',
	'Drag and drop area' => 'Klik-en-sleep gebied',
	'Please add a content field.' => 'Gelieve een inhoudsveld toe te voegen.',
	'Show input field to enter data label' => 'Invoerveld tonen om datalabel in te vullen',
	'Unique ID' => 'Unieke ID',
	'close' => 'Sluiten',

## mt-static/js/dialog.js
	'(None)' => '(Geen)',

## mt-static/js/listing/list_data.js
	'Unknown Filter' => '', # Translate - New
	'[_1] - Filter [_2]' => '[_1] - Filter [_2]',

## mt-static/js/listing/listing.js
	'Are you sure you want to [_2] this [_1]?' => 'Opgelet: [_1] echt [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Bent u zeker dat u deze [_1] geselecteerde [_2] wenst te [_3]?',
	'Label "[_1]" is already in use.' => 'Label "[_1]" is al in gebruik',
	'One or more fields in the filter item are not filled in properly.' => '', # Translate - New
	'You can only act upon a maximum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren op maximum [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren om minimaal [_1] [_2].',
	'You did not select any [_1] to [_2].' => 'U selecteerde geen [_1] om te [_2].',
	'act upon' => 'actie uitvoeren op',
	q{Are you sure you want to remove filter '[_1]'?} => q{Bent u zeker dat u de filter '[_1]' wenst te verwijderen?},

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'[_1] rows' => '[_1] rijen',
	'Show' => 'Tonen',

## mt-static/js/listing/tag/display-options.tag
	'Column' => 'Kolom',
	'Reset defaults' => 'Standaardinstellingen terugzetten',
	'User Display Option is disabled now.' => 'Gebruikersweergaveopties zijn nu uitgeschakeld',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Plugin Actions' => 'Plugin-mogelijkheden',
	'Select action' => 'Selecteer actie',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Meer mogelijkheden...',

## mt-static/js/listing/tag/list-filter.tag
	'Add' => 'Toevoegen',
	'Apply' => 'Toepassen',
	'Built in Filters' => 'Ingebouwde filters',
	'Create New' => 'Nieuwe aanmaken',
	'Filter Label' => 'Filterlabel',
	'Filter:' => 'Filter:',
	'My Filters' => 'Mijn filters',
	'Reset Filter' => 'Filter leegmaken',
	'Save As' => 'Opslaan als',
	'Select Filter Item...' => 'Selecteer filteritem',
	'Select Filter' => 'Selecteer filter',
	'rename' => 'naam wijzigen',

## mt-static/js/listing/tag/list-table.tag
	'All [_1] items are selected' => 'Alle [_1] items zijn geselecteerd',
	'All' => 'Alle',
	'Loading...' => 'Laden...',
	'Select All' => 'Alles selecteren',
	'Select all [_1] items' => 'Selecteer alle [_1] items',
	'Select' => 'Selecteren',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] van [_3]',

## mt-static/js/mt/util.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Bent u zeker dat u deze [_1] rollen wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rollen geassocieerd zijn.',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Bent u zeker dat u deze rol wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rol geassocieerd zijn.',
	'You did not select any [_1] [_2].' => 'U selecteerde geen [_1] [_2]',
	'You must select an action.' => 'U moet een handeling selecteren',
	'delete' => 'verwijderen',

## mt-static/js/tc/mixer/display.js
	'Author:' => 'Auteur:',
	'Description:' => 'Beschrijving:',
	'Tags:' => 'Tags:',
	'Title:' => 'Titel:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a path beginning with %s or %a.' => 'U moet een pad instellen dat begint met %s of %a.',
	'You must set a valid path.' => 'U moet een geldig pad instellen.',

## mt-static/mt.js
	'Enter URL:' => 'Voer URL in:',
	'Enter email address:' => 'Voer e-mail adres in:',
	'Same name tag already exists.' => 'Zelfde naamtag bestaat al.',
	'disable' => 'desactiveren',
	'enable' => 'activeren',
	'publish' => 'publiceren',
	'remove' => 'verwijderen',
	'to mark as spam' => 'om als spam aan te merken',
	'to remove spam status' => 'om spamstatus van te verwijderen',
	'unlock' => 'deblokkeren',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{De tag '[_2]' bestaat al.  Bent u zeker dat u '[_1]' met '[_2]' wenst samen te voegen over alle weblogs?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{De tag '[_2]' bestaat al.  Bent u zeker dat u '[_1]' met '[_2]' wenst samen te voegen?},

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1] blok bewerken',

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Insluitcode',
	'Please enter the embed code here.' => 'Gelieve de insluitcode hier in te geven.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading Level' => 'Hoofdingsniveau',
	'Heading' => 'Hoofding',
	'Please enter the Header Text here.' => 'Vul hier de tekst voor de hoofding in.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale lijn',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js
	'image' => 'afbeelding',

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Tekst',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Selecteer een blok',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Standaardtekst invoegen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'U heeft niet opgeslagen wijzigingen.  Bent u zeker dat u weg wenst te navigeren?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'waarde',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%H:%M:%S' => '%H:%M:%S',
	'%Y-%m-%d' => '%Y-%m-%d',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Align Center' => 'Centreren',
	'Align Left' => 'Links uitlijnen',
	'Align Right' => 'Rechts uitlijnen',
	'Block Quotation' => 'Citaat',
	'Bold (Ctrl+B)' => 'Vet (Ctrl+B)',
	'Class Name' => 'naam klasse',
	'Emphasis' => 'Nadruk',
	'Horizontal Line' => 'Horizontale lijn',
	'Indent' => 'Inspringen',
	'Insert Asset Link' => 'Bestandslink invoegen',
	'Insert HTML' => 'HTML invoegen',
	'Insert Image Asset' => 'Afbeeldingsbestand invoegen',
	'Insert Link' => 'Link invoegen',
	'Insert/Edit Link' => 'Link invoegen/bewerken',
	'Italic (Ctrl+I)' => 'Schuin (Ctrl+I)',
	'List Item' => 'Lijstelement',
	'Ordered List' => 'Genummerde lijst',
	'Outdent' => 'Uitspringen',
	'Redo (Ctrl+Y)' => 'Herhalen (Ctrl+Y)',
	'Remove Formatting' => 'Formattering verwijderen',
	'Select Background Color' => 'Achtergrondkleur kiezen',
	'Select Text Color' => 'Tekstkleur kiezen',
	'Strikethrough' => 'Doorstrepen',
	'Strong Emphasis' => 'Sterke nadruk',
	'Toggle Fullscreen Mode' => 'Volledig scherm in/uitschakelen',
	'Toggle HTML Edit Mode' => 'HTML modus in/uitschakelen',
	'Underline (Ctrl+U)' => 'Onderlijnen (Ctrl+U)',
	'Undo (Ctrl+Z)' => 'Ongedaan maken (Ctrl+Z)',
	'Unlink' => 'Link verwijderen',
	'Unordered List' => 'Ongeordende lijst',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Volledig scherm',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Copy column' => '', # Translate - New
	'Cut column' => '', # Translate - New
	'Horizontal align' => '', # Translate - New
	'Paste column after' => '', # Translate - New
	'Paste column before' => '', # Translate - New
	'Vertical align' => '', # Translate - New

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'Archieftype niet gevonden - [_1]',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Geen auteur beschikbaar',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'U gebruikte een [_1] tag zonder een datum in context te brengen',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found: \"[_1]\"' => '', # Translate - New

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig "name" attribuut',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] is illegaal.',

## php/lib/captcha_lib.php
	'Type the characters shown in the picture above.' => 'Typ de tekens die u ziet in de afbeelding hierboven.',

## php/lib/function.mtassettype.php
	'file' => 'bestand',

## php/lib/mtdb.base.php
	q{When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.} => q{Wanneer de exclude_blogs en include_blogs attributen samen worden gebruikt dan kunnen dezelfde blog ID's niet als parameters gebruikt worden in beide attributen.},

## php/mt.php
	'Page not found - [_1]' => 'Pagina niet gevonden - [_1]',

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'[_1] - [_2] of [_3]' => '[_1] - [_2] van [_3]',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl
	'Cancelled: [_1]' => 'Geannuleerd: [_1]',
	'The file you tried to upload is too large: [_1]' => 'Het bestand dat u probeerde te uploaden is te groot: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] is geen geldig [_2] bestand.',

## plugins/Comments/lib/Comments.pm
	'(Deleted)' => '(Verwijderd)',
	'Approved' => 'Goedgekeurd',
	'Banned' => 'Uitgesloten',
	'Can comment and manage feedback.' => 'Kan reageren en feedback beheren',
	'Can comment.' => 'Kan reageren.',
	'Commenter' => 'Reageerder',
	'Comments on [_1]: [_2]' => 'Reacties op [_1]: [_2]',
	'Edit this [_1] commenter.' => 'Bewerk deze [_1] reageerder',
	'Moderator' => 'Moderator',
	'Not spam' => 'Geen spam',
	'Reply' => 'Antwoorden',
	'Reported as spam' => 'Gerapporteerd als spam',
	'Search for other comments from anonymous commenters' => 'Zoeken naar andere reacties van anonieme reageerders',
	'Search for other comments from this deleted commenter' => 'Zoeken naar andere reacties van deze verwijderde reageerder',
	'Unapproved' => 'Niet gekeurd',
	'__ANONYMOUS_COMMENTER' => 'Anoniem',
	'__COMMENTER_APPROVED' => 'Goedgekeurd',
	q{All comments by [_1] '[_2]'} => q{Alle reacties van [_1] '[_2]'},

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'All Comments' => 'Alle reacties',
	'[_1] Comments' => '[_1] reacties',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'Bent u zeker dat u alle reacties die als spam aangemerkt staan wenst te verwijderen?',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Reacties worden gekloond voor blog...',

## plugins/Comments/lib/Comments/Import.pm
	'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
	q{Creating new comment (from '[_1]')...} => q{Nieuwe reactie aan het aanmaken (van '[_1]')...},

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Bezig initiõ�¼„e rollen aan te maken voor reacties...',

## plugins/Comments/lib/MT/App/Comments.pm
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Terugkeren naar de oorspronkelijke pagina.</a>',
	'All required fields must be populated.' => 'Alle vereiste velden moeten worden ingevuld.',
	'Comment on "[_1]" by [_2].' => 'Reactie op "[_1]" door [_2].',
	'Comment save failed with [_1]' => 'Opslaan van reactie mislukt met [_1]',
	'Comment text is required.' => 'Tekst van de reactie is verplicht.',
	'Commenter profile could not be updated: [_1]' => 'Reageerdersprofiel kon niet worden bijgewerkt: [_1]',
	'Commenter profile has successfully been updated.' => 'Reageerdersprofiel is met succes bijgewerkt.',
	'Comments are not allowed on this entry.' => 'Reacties op dit bericht zijn niet toegelaten.',
	'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ongeldige aanmeldpoging van een reageerder [_1] op blog [_2](ID: [_3]) waar geenMovable Type native authenticatie is toegelaten.',
	'Invalid entry ID provided' => 'Ongeldig berichtID opgegeven',
	'Movable Type Account Confirmation' => 'Movable Type accountbevestiging',
	'Name and E-mail address are required.' => 'Naam en e-mail adres zijn vereist',
	'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
	'No id' => 'Geen id',
	'No such comment' => 'Reactie niet gevonden',
	'Registration is required.' => 'Registratie is verplicht.',
	'Signing up is not allowed.' => 'Registreren is niet toegestaan.',
	'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'U bent met succes aangemeld, maar registratie is niet toegestaan op dit moment.  Gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden om te reageren.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'U probeert om te leiden naar externe bronnen.  Als u de site vertrouwt, klik dan op de link: [_1]',
	'You need to sign up first.' => 'U moet zich eerst registreren',
	'Your confirmation has expired. Please register again.' => 'Uw bevestigingsperiode is afgelopen.  Gelieve opnieuw te registreren.',
	'_THROTTLED_COMMENT' => 'U heeft in een korte periode te veel reacties achtergelaten.  Gelieve over enige tijd opnieuw te proberen.',
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{Reageerder '[_1]' (ID:[_2]) heeft zich met succes geregistreerd.},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{Fout bij het toekennen van reactierechten aan gebruiker '[_1] (ID: [_2])' op weblog '[_3] (ID: [_4])'.  Er werd geen geschikte reageerder-rol gevonden.},
	q{Failed comment attempt by pending registrant '[_1]'} => q{Mislukte poging om een reactie achter te laten van op registratie wachtende gebruiker '[_1]'},
	q{Invalid URL '[_1]'} => q{Ongeldige URL '[_1]'},
	q{Login failed: password was wrong for user '[_1]'} => q{Aanmelden mislukt: fout in wachtwoord van gebruiker '[_1]'},
	q{Login failed: permission denied for user '[_1]'} => q{Aanmelden mislukt: permissie geweigerd aan gebruiker '[_1]'},
	q{No such entry '[_1]'.} => q{Geen bericht '[_1]'.},
	q{[_1] registered to the blog '[_2]'} => q{[_1] registreerde zich op blog '[_2]'},

## plugins/Comments/lib/MT/CMS/Comment.pm
	'Commenter Details' => 'Details reageerder',
	'Edit Comment' => 'Reactie bewerken',
	'No such commenter [_1].' => 'Geen reageerder [_1].',
	'Orphaned comment' => 'Verweesde reactie',
	'The entry corresponding to this comment is missing.' => 'Het bericht dat bij deze reactie hoort, ontbreekt.',
	'The parent comment id was not specified.' => 'Het ID van de ouder van de reactie werd niet opgegeven.',
	'The parent comment was not found.' => 'De ouder-reactie werd niet gevonden.',
	'You cannot create a comment for an unpublished entry.' => 'U kunt geen reactie aanmaken op een ongepubliceerd bericht.',
	'You cannot reply to unapproved comment.' => 'U kunt niet antwoorden op een niet-gekeurde reactie.',
	'You cannot reply to unpublished comment.' => 'U kunt niet reageren op een niet gepubliceerde reactie.',
	'You do not have permission to approve this comment.' => 'U heeft geen permissie om deze reactie goed te keuren.',
	'You do not have permission to approve this trackback.' => 'U heeft geen permissies om deze trackback goed te keuren.',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Reactie (ID:[_1]) door '[_2]' verwijderd door '[_3]' van bericht '[_4]'},
	q{User '[_1]' banned commenter '[_2]'.} => q{Gebruiker '[_1]' verbande reageerder '[_2]'.},
	q{User '[_1]' trusted commenter '[_2]'.} => q{Gebruiker '[_1]' gaf reageerder '[_2]' de status VERTROUWD.},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{Gebruiker '[_1]' maakte de verbanning van reageerder '[_2]' ongedaan.},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{Gebruiker '[_1]' gaf reageerder '[_2]' de status NIET VERTROUWD.},

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'Anonymous' => 'Anonieme',
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'De MTCommentFields tag is niet langer beschikbaar.  Gelieve in de plaats de [_1] sjabloonmodule te includeren.',

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{Deze '[_1]' tag word niet meer gebruikt.  Gelieve '[_2]' te gebruiken.},

## plugins/Comments/php/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{De '[_1]' tag is verouderd.  Gelieve de '[_2]' tag te gebruiken ter vervanging.},

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'The login could not be confirmed because of no/invalid blog_id' => 'Aanmelding kon niet worden bevestigd wegens geen/ongeldig blog_id',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Bent u zeker dat u de geselecteerde standaardtekst wenst te verwijderen?',
	'Boilerplates' => 'Standaardteksten',
	'Create Boilerplate' => 'Standaardtekst aanmaken',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{De standaardtekst '[_1]' wordt al gebruikt op deze site.},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplate' => 'Standaardtekst',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Standaardtekst '[_1]' wordt al gebruikt op deze blog.},

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Een Perl module vereist voor het gebruik van de Google Analytics API ontbreekt: [_1]',
	'The name of the profile' => 'Naam van het profiel',
	'The web property ID of the profile' => 'De web property ID van het ID',
	'You did not specify a client ID.' => 'U gaf geen client ID op.',
	'You did not specify a code.' => 'U gaf geen code op.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting accounts: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de accounts: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de profielen: [_1]: [_2]',
	'An error occurred when getting token: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van het token: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Er deed zich een fout voor bij het verversen van het toegangstoken: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van statistiekgegevens: [_1]: [_2]',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Een Perl module vereist voor authenticatie van reageerders via Google ID ontbreekt: [_1]',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Kon Net::OpenID::Consumer niet laden.',
	'Could not save the session' => 'Kon de sessie niet opslaan',
	'Could not verify the OpenID provided: [_1]' => 'Kon de opgegeven OpenID niet verifiÃ«ren: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'De perl module die vereist is voor authenticatie van reageerders via OpenID (Digest::SHA1) ontbreekt.',
	'The address entered does not appear to be an OpenID endpoint.' => 'Het adres dat werd ingevuld lijkt geen OpenID endpoint te zijn.',
	'The text entered does not appear to be a valid web address.' => 'De ingevulde tekst lijkt geen geldig webadres te zijn.',
	'Unable to connect to [_1]: [_2]' => 'Kon niet verbinden met [_1]: [_2]',

## plugins/Textile/textile2.pl
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',

## plugins/Trackback/lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'Dit TrackBack item is uitgeschakeld.',
	'This TrackBack item is protected by a passphrase.' => 'Dit TrackBack item is beschermd door een wachtwoord.',
	'TrackBack ID (tb_id) is required.' => 'TrackBack ID (tb_id) is vereist.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack op "[_1]" van "[_2]".',
	'Trackback pings must use HTTP POST' => 'Trackback pings moeten HTTP POST gebruiken',
	'You are not allowed to send TrackBack pings.' => 'U heeft geen toestemming om TrackBack pings te versturen.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'U stuurt te veel TrackBack pings achter elkaar.  Gelieve la
ter opnieuw te proberen.',
	'You must define a Ping template in order to display pings.' => 'U moet een pingsjabloon definiÃ«ren om pings te kunnen tonen.',
	'You need to provide a Source URL (url).' => 'U moet een Source URL (url) opgeven.',
	q{Cannot create RSS feed '[_1]': } => q{Kan RSS feed '[_1]' niet aanmaken: },
	q{Invalid TrackBack ID '[_1]'} => q{Ongeldig TrackBack-ID '[_1]'},
	q{New TrackBack ping to '[_1]'} => q{Nieuwe TrackBack ping op '[_1]'},
	q{New TrackBack ping to category '[_1]'} => q{Nieuwe TrackBack ping op categorie '[_1]'},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{TrackBack op categorie '[_1]' (ID:[_2]).},

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Categorie zonder label)',
	'(Untitled entry)' => '(Bericht zonder titel)',
	'Edit TrackBack' => 'TrackBack bewerken',
	'No Excerpt' => 'Geen uittreksel',
	'Orphaned TrackBack' => 'Verweesde TrackBack',
	'category' => 'categorie',
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{Ping (ID:[_1]) van '[_2]' verwijderd door '[_3]' van categorie '[_4]'},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{Ping (ID:[_1]) van '[_2]' verwijderd door '[_3]' van bericht '[_4]'},

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$> moet gebruikt worden in een categorie, of met het 'category' attribuute van de tag.},

## plugins/Trackback/lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'HTTP fout: [_1]',
	'No MTPingURL defined in the configuration file' => 'Geen MTPingURL opgegeven in het configuratiebestand',
	'No WeblogsPingURL defined in the configuration file' => 'Geen WeblogsPingURL opgegeven in het configuratiebestand',
	'Ping error: [_1]' => 'Ping fout: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping van: [_2] - [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks op [_1]: [_2]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'All TrackBacks' => 'Alle TrackBacks',
	'[_1] TrackBacks' => '[_1] TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Bent u zeker dat u alle trackbacks die als spam aangemerkt staan wenst te verwijderen?',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBack pings for blog...' => 'TrackBack pings worden gekloond voor blog...',
	'Cloning TrackBacks for blog...' => 'Trackbacks worden gekloond voor blog...',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	q{Ping '[_1]' failed: [_2]} => q{Ping '[_1]' mislukt: [_2]},

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'Bron URL',

## plugins/Trackback/lib/Trackback/Import.pm
	'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
	q{Creating new ping ('[_1]')...} => q{Nieuwe ping aan het aanmaken ('[_1]')...},

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'Archive Root' => 'Archiefroot',
	'No Site' => 'Geen site',

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => 'Mislukt.',
	'Moving storage of Widget Manager [_2]...' => 'Opslag voor widget manager [_2] aan het verhuizen...',

## plugins/spamlookup/lib/spamlookup.pm
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domein IO komt niet overeen met ping IP van bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
	'E-mail was previously published (comment id [_1]).' => 'E-mail werd eerder al gepubliceerd (reactie id [_1])',
	'Failed to resolve IP address for source URL [_1]' => 'Resolutie van IP adres mislukt voor bron URL [_1]',
	'Link was previously published (TrackBack id [_1]).' => 'Link werd eerder al gepubliceerd (TrackBack id [_1])',
	'Link was previously published (comment id [_1]).' => 'Link werd eerder al gepubliceerd (reactie id [_1])',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'In moderatie: IP van domein komt niet overeen met IP van ping voor bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
	'No links are present in feedback' => 'Geen links aanwezig in feedback',
	'Number of links exceed junk limit ([_1])' => 'Aantal links hoger dan spamlimiet ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Aantal links hoger dan moderatielimiet ([_1])',
	'[_1] found on service [_2]' => '[_1] gevonden op service [_2]',
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{Te modereren wegens woordfilter overeenkomst op '[_1]': '[_2]'.},
	q{Word Filter match on '[_1]': '[_2]'.} => q{Woordfilter overeenkomst op '[_1]': '[_2]'.},
	q{domain '[_1]' found on service [_2]} => q{domein '[_1]' gevonden op service [_2].},

## search_templates/comments.tmpl
	'Find new comments' => 'Nieuwe reacties zoeken',
	'No new comments were found in the specified interval.' => 'Geen nieuwe reacties gevonden in het opgegeven interval.',
	'No results found' => 'Geen resultaten gevonden',
	'Posted in [_1] on [_2]' => 'Gepubliceerd in [_1] op [_2]',
	'Search for new comments from:' => 'Zoeken naar reacties vanaf:',
	'five months ago' => 'vijf maanden geleden',
	'four months ago' => 'vier maanden geleden',
	'one month ago' => 'één maand geleden',
	'one week ago' => 'één week geleden',
	'one year ago' => 'één jaar geleden',
	'six months ago' => 'zes maanden geleden',
	'the beginning' => 'het begin',
	'three months ago' => 'drie maanden geleden',
	'two months ago' => 'twee maanden geleden',
	'two weeks ago' => 'twee weken geleden',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Selecteer het tijdsinterval waarin u wenst te zoeken en klik dan op 'Nieuwe reacties zoeken'},

## search_templates/content_data_default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGIN VAN BETA ZIJKOLOM OM ZOEKINFORMATIE IN TE TONEN',
	'END OF ALPHA SEARCH RESULTS DIV' => 'EINDE VAN ALPHA ZOEKRESULTATEN DIV',
	'END OF CONTAINER' => 'EINDE VAN CONTAINER',
	'END OF PAGE BODY' => 'EINDE VAN PAGINA BODY',
	'Feed Subscription' => 'Feed inschrijving',
	'Matching content data from [_1]' => 'Overeenkomende inhoudsgegevens van [_1]',
	'NO RESULTS FOUND MESSAGE' => 'GEEN RESULTATEN GEVONDEN BOODSCHAP',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publiceerde <MTIfNonEmpty tag="ContentAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'ZOEKFEED AUTODISCOVERY LINK DIE ENKEL GEPUBLICEERD WORDT ALS EEN ZOEKOPDRACHT IS UITGEVOERD',
	'SEARCH RESULTS DISPLAY' => 'ZOEKRESULTATENSCHERM',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ZOEK/TAG FEED INSCHRIJVINGSINFORMATIE',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'STEL VARIABELEN IN VOOR ZOEK vs TAG informatie',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'GEWONE ZOEKOPDRACHTEN KRIJGEN HET ZOEKFORMULIER TE ZIEN',
	'Search this site' => 'Deze website doorzoeken',
	'Showing the first [_1] results.' => 'De eerste [_1] resultaten worden getoond.',
	'Site Search Results' => 'Zoekresultaten site',
	'Site search' => 'Site doorzoeken',
	'What is this?' => 'Wat is dit?',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{Content Data matching '[_1]'} => q{Inhoudsgegevens die overeen komen met '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Inhoudsgegevens getagd met '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Als u een RSS lezer gebruikt dan kunt u inschrijven op een feed met alle inhoudsgegevens die in de toekomst overeen komen met '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Als u een RSS lezer gebruikt dan kunt u inschrijven op een feed met alle inhoudsgegevens die in de toekomst getagd worden met '[_1]'},
	q{No pages were found containing '[_1]'.} => q{Er werden geen berichten gevonden met '[_1]' in.},

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Zoekresultaten voor [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Blog zoekresultaten',
	'Blog search' => 'Blog doorzoeken',
	'Match case' => 'Kapitalisering moet overeen komen',
	'Matching entries from [_1]' => 'Gevonden berichten op [_1]',
	'Other Tags' => 'Andere tags',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Gepubliceerd <MTIfNonEmpty tag="EntryAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	'Regex search' => 'Zoeken met reguliere expressies',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG OPSOMMING ENKEL VOOR TAG ZOEKEN',
	q{Entries from [_1] tagged with '[_2]'} => q{Berichten op [_1] getagd met '[_2]'},
	q{Entries matching '[_1]'} => q{Berichten met '[_1]' in},
	q{Entries tagged with '[_1]'} => q{Berichten getagd met '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met '[_1]' in.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met de tag '[_1]'.},

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] reageerde op <a href="[_2]">reactie van [_3]</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Details reactie',

## themes/classic_blog/templates/comment_preview.mtml
	'(You may use HTML tags for style)' => '(u kunt HTML tags gebruiken voor de lay-out)',
	'Leave a comment' => 'Laat een reactie achter',
	'Previewing your Comment' => 'U ziet een voorbeeld van uw reactie',
	'Replying to comment from [_1]' => 'Antwoord op reactie van [_1]',
	'Submit' => 'Invoeren',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'Uw reactie werd ontvangen!',
	'Your comment submission failed for the following reasons: [_1]' => 'Het indienen van uw reactie mislukte wegens deze redenen: [_1]',

## themes/classic_blog/templates/comments.mtml
	'Remember personal info?' => 'Persoonijke gegevens onthouden?',
	'The data is modified by the paginate script' => 'De gegevens zijn aangepast door het paginatiescript',

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="volledige reactie op: [_4]">meer lezen</a>',

## themes/classic_blog/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> van [_3] op <a href="[_4]">[_5]</a>',
	'TrackBack URL: [_1]' => 'TrackBack URL: [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Meer lezen</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Traditioneel, klassiek blogdesign, met een ruime selectie aan stijlen en keuze tussen 2 en 3 koloms layout.  Geschikt voor standaard blogpublicatietoepassingen.',
	'Displays preview of comment.' => 'Toont voorbeeld van reactie.',
	'Displays results of a search for content data.' => 'Toont resultaten van een zoekopdracht naar inhoudsgegevens.',
	'Improved listing of comments.' => 'Verbeterde weergave van reacties.',
	q{Displays error, pending or confirmation message for comments.} => q{Toont foutboodschappen, bevestigingen en 'even geduld' berichten voor reacties.},

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze website.',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze website.',

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'Blogs',

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Inschrijven op de feed van deze website},

## themes/classic_website/theme.yaml
	'Classic Website' => 'Klassieke website',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Maak een blogportaal dat de inhoud van verschillende blogs samenbrengt in één website.',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Nieuw mediabestand uploaden',

## tmpl/cms/backup.tmpl
	'Archive Format' => 'Archiefformaat',
	'Choose sites...' => 'Sites kiezen...',
	'Everything' => 'Alles',
	'Export (e)' => 'Export (e)',
	'No size limit' => 'Geen beperking op bestandsgrootte',
	'Reset' => 'Leegmaken',
	'Target File Size' => 'Grootte doelbestand',
	'What to Export' => 'Wat te exporteren',
	q{Don't compress} => q{Niet comprimeren},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'TrackBacks aanvaarden',
	'Alignment' => 'Uitlijning',
	'Ascending' => 'Oplopend',
	'Basename Length' => 'Lengte basisnaam',
	'Center' => 'Centreren',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Karakter entiteiten (&amp#8221;, &amp#8220;, etc.)',
	'Compose Defaults' => 'Instellingen voor opstellen',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'Inhoud CSS zal toegepast worden als de editor het ondersteunt.  U kunt een CSS bestand opgeven via de URL of met de {{theme_static}} plaatsvervanger. Voorbeeld: {{theme_static}}path/to/cssfile.css',
	'Content CSS' => 'Inhoud CSS',
	'Czech' => 'Tsjechisch',
	'Danish' => 'Deens',
	'Date Language' => 'Datumtaal',
	'Days' => 'Dagen',
	'Descending' => 'Aflopend',
	'Display in popup' => '', # Translate - New
	'Display on the same screen' => '', # Translate - New
	'Dutch' => 'Nederlands',
	'English' => 'Engels',
	'Entry Fields' => 'Berichtvelden',
	'Estonian' => 'Estlands',
	'Excerpt Length' => 'Lengte uittreksel',
	'French' => 'Frans',
	'German' => 'Duits',
	'Icelandic' => 'IJslands',
	'Image default insertion options' => 'Standaardinstellingen vor invoegen afbeeldingen',
	'Italian' => 'Italiaans',
	'Japanese' => 'Japans',
	'Left' => 'Links',
	'Link from image' => '', # Translate - New
	'Link to original image' => '', # Translate - New
	'Listing Default' => 'Standaard lijstweergave',
	'No substitution' => 'Geen vervanging',
	'Norwegian' => 'Noors',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat trackbacks uitgeschakeld zijn ofwel voor de subsite of in heel het systeem.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de site of in heel het systeem.',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de subsite of in heel het systeem.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de site of in heel het systeem.',
	'Order' => 'Volgorde',
	'Page Fields' => 'Paginavelden',
	'Polish' => 'Pools',
	'Portuguese' => 'Portugees',
	'Posts' => 'Berichten',
	'Publishing Defaults' => 'Standaardinstellingen publicatie',
	'Punctuation Replacement Setting' => 'Instelling plaatsing leestekens',
	'Punctuation Replacement' => 'Vervanging leestekens',
	'Replace Fields' => 'Velden vervangen',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Vervang UTF-8 karakters die vaak worden gebruikt door tekstverwerkers door hun meer gestandaardiseerde web-equivalenten.',
	'Right' => 'Rechts',
	'Save changes to these settings (s)' => 'Wijzigingen aan deze instellingen opslaan (s)',
	'Setting Ignored' => 'Instelling genegeerd',
	'Slovak' => 'Slowaaks',
	'Slovenian' => 'Sloveens',
	'Spanish' => 'Spaans',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Bepaalt de standaard tekstopmaak voor het aanmaken van een nieuw bericht.',
	'Suomi' => 'Fins',
	'Swedish' => 'Zweeds',
	'Text Formatting' => 'Tekstopmaak',
	'The range for Basename Length is 15 to 250.' => 'Basisnamen kunnen van 15 tot 250 karakters lang zijn.',
	'Unpublished' => 'Ongepubliceerd',
	'Use thumbnail' => 'Thumbnail gebruiken',
	'WYSIWYG Editor Setting' => 'Instellingen WYSIWYG Editor',
	'You must set valid default thumbnail width.' => 'U moet een geldige standaardbreedte voor thumbnails opgeven.',
	'Your preferences have been saved.' => 'Uw voorkeuren zijn opgeslagen',
	'pixels' => 'pixels',
	'width:' => 'breedte:',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{ASCII equivalenten (&quot;, ', ..., -, --)},

## tmpl/cms/cfg_feedback.tmpl
	'([_1])' => '([_1])',
	'Accept TrackBacks from any source.' => 'TrackBacks accepteren uit elke bron',
	'Accept comments according to the policies shown below.' => 'Reacties aanvaarden volgens de regels hieronder.',
	'Allow HTML' => 'HTML toestaan',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Laat reageerders een beperkte set HTML tags gebruiken in hun reacties.  Alle andere HTML zal worden verwijderd.',
	'Any authenticated commenters' => 'Elke geauthenticeerde reageerder',
	'Anyone' => 'Iedereen',
	'Automatic Deletion' => 'Automatisch verwijderen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam feedback automatisch verwijderen na de tijdsduur die hieronder staat.',
	'CAPTCHA Provider' => 'CAPTCHA dienstverlener',
	'Comment Display Settings' => 'Weergave-instellingen reacties',
	'Comment Order' => 'Volgorde reacties',
	'Comment Settings' => 'Instellingen voor reacties',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Authenticatie van reacties is niet beschikbaar omdat minstens één van de vereiste Perl modules, MIME::Base64 en LWP::UserAgent, niet geïnstalleerd is.  Installeer de ontbrekende modules en herlaad deze pagina om authenticatie van reacties te configureren.',
	'Commenting Policy' => 'Reactiebeleid',
	'Delete Spam After' => 'Spam verwijderen na',
	'E-mail Notification' => 'E-mail notificatie',
	'Enable External TrackBack Auto-Discovery' => 'Externe automatische TrackBack-ontdekking inschakelen',
	'Enable Internal TrackBack Auto-Discovery' => 'Interne automatische TrackBack-ontdekking inschakelen',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks modereren voor ze gepubliceerd worden.',
	'Immediately approve comments from' => 'Onmiddellijk reacties goedkeuren van',
	'Limit HTML Tags' => 'HTML tags beperken',
	'Moderation' => 'Moderatie',
	'No CAPTCHA provider available' => 'Geen CAPTCHA provider beschikbaar',
	'No one' => 'Niemand',
	'Note: Commenting is currently disabled at the system level.' => 'Opmerking: reacties zijn momenteel uitgeschakeld op het systeemniveau.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Noot: deze optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau zijn uitgeschakeld.',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Noot: deze optie kan beïnvloed worden op systeemniveau omdat uitgaande pings daar beperkt kunnen worden.',
	'Note: TrackBacks are currently disabled at the system level.' => 'Opmerking: TrackBacks zijn momenteel uitgeschakeld op systeemniveau.',
	'Off' => 'Uit',
	'On' => 'Aan',
	'Only when attention is required' => 'Alleen wanneer er aandacht is vereist',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u reacties wenst te tonen in opgaande (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
	'Setting Notice' => 'Opmerking bij deze instelling',
	'Setup Registration' => 'Registratie instellen',
	'Spam Score Threshold' => 'Spamscoredrempel',
	'Spam Settings' => 'Spaminstellingen',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Deze waarde kan tussen de -10 en +10 liggen.  Hoe groter de waarde is, hoe groter de kans dat het spamdetectie framework een reactie of trackback als spam zal aanmerken.',
	'TrackBack Auto-Discovery' => 'Automatisch TrackBacks ontdekken',
	'TrackBack Options' => 'TrackBack opties',
	'TrackBack Policy' => 'TrackBack beleid',
	'Trackback Settings' => 'TrackBack instellingen',
	'Transform URLs in comment text into HTML links.' => 'URLs in reacties transformeren in HTML links.',
	'Trusted commenters only' => 'Enkel vertrouwde reageerders',
	'Use Comment Confirmation Page' => 'Pagina voor bevestigen reacties gebruiken',
	'Use defaults' => 'Standaardwaarden gebruiken',
	'Use my settings' => 'Mijn instellingen gebruiken',
	'days' => 'dagen',
	q{'nofollow' exception for trusted commenters} => q{'nofollow' uitzondering voor vertrouwde reageerders},
	q{Apply 'nofollow' to URLs} => q{Toepassen van 'nofollow' op URLs},
	q{Auto-Link URLs} => q{Automatisch URL's omzetten in links},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{Voeg het 'nofollow' attribuut niet toe wanneer een reactie afkomstig is van een vertrouwde reageerder.},
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{De browser van elke reageerder zal worden doorgestuurd naar een bevestigingspagina nadat hun reactie werd geaccepteerd.},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Indien ingeschakeld krijgen alle URLs in reacties en TrackBacks automatisch de 'nofollow' linkrelatie.},
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Geen CAPTCHA provider beschikbaar in dit systeem.  Gelieve te controleren of Image::Magick geïnstalleerd is en of de CaptchaSourceImageBase configuratiedirectief naar een geldige captcha-source map verwijst in de 'mt-static/images' map.},

## tmpl/cms/cfg_plugin.tmpl
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Ben u zeker dat u plugins wenst uit te schakelen voor de hele Movable Type installatie?',
	'Are you sure you want to disable this plugin?' => 'Bent u zeker dat u deze plugin wenst uit te schakelen?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Bent u zeker dat u plugins wenst in te schakelen voor de hele Movable Type installatie? (Dit zal de instellingen van de plugins herstellen die van kracht waren voor alle plugins werden uitgeschakeld.)',
	'Are you sure you want to enable this plugin?' => 'Bent u zeker dat u deze plugin wenst in te schakelen?',
	'Are you sure you want to reset the settings for this plugin?' => 'Bent u zeker dat u de instellingen voor deze plugin wil terugzetten naar de standaardwaarden?',
	'Author of [_1]' => 'Auteur van [_1]',
	'Disable Plugins' => 'Plugins uitschakelen',
	'Disable plugin functionality' => 'Plugin functionaliteit uitschakelen',
	'Documentation for [_1]' => 'Documentatie voor [_1]',
	'Enable Plugins' => 'Plugins inschakelen',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin functionaliteit in- of uitschakelen voor de hele Movable Type installatie.',
	'Enable plugin functionality' => 'Plugin functionaliteit inschakelen',
	'Failed to Load' => 'Laden mislukt',
	'Failed to load' => 'Laden mislukt',
	'Find Plugins' => 'Plugins vinden',
	'Info' => 'Info',
	'Junk Filters:' => 'Spamfilters:',
	'More about [_1]' => 'Meer over [_1]',
	'No plugins with blog-level configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd die configuratie-opties hebben op weblogniveau.',
	'No plugins with configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd met configuratie-opties.',
	'Plugin Home' => 'Homepage van deze plugin',
	'Plugin System' => 'Plugin systeem',
	'Plugin error:' => 'Pluginfout:',
	'Reset to Defaults' => 'Terugzetten naar standaardwaarden',
	'Resources' => 'Bronnen',
	'Run [_1]' => '[_1] uitvoeren',
	'Tag Attributes:' => 'Tag attributen:',
	'Text Filters' => 'Tekstfilters',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Deze plugin is niet bijgewerkt om Movable Type [_1] te ondersteunen.  Om die reden kan het zijn dat hij niet helemaal werkt.',
	'Your plugin settings have been reset.' => 'Uw plugin-instellingen zijn teruggezet op de standaardwaarden.',
	'Your plugin settings have been saved.' => 'Uw plugin-instellingen zijn opgeslagen.',
	'Your plugins have been reconfigured.' => 'Uw plugins zijn opnieuw geconfigureerd.',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl gebruikt, moet u de webserver opnieuw opstarten om het effect van deze wijzigingen te zien.},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{    Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl draait, moet u uw webserver opnieuw starten om de wijzigingen van kracht te maken.},

## tmpl/cms/cfg_prefs.tmpl
	'Active Server Page Includes' => 'Active Server Page Includes',
	'Advanced Archive Publishing' => 'Geavanceerde archiefpublicatie',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Maak het mogelijk om correct geconfigureerde modules gecached te laten worden om zo de publicatiesnelheid te verhogen.',
	'Allow to change at upload' => 'Toestaan om te wijzigen bij upload',
	'Apache Server-Side Includes' => 'Apache Server-Side Includes',
	'Archive Settings' => 'Archiefinstellingen',
	'Archive URL' => 'Archief-URL',
	'Cancel upload' => 'Upload annuleren',
	'Change license' => 'Licentie aanpassen',
	'Choose archive type' => 'Kies archieftype',
	'Dynamic Publishing Options' => 'Opties dynamische publicatie',
	'Enable conditional retrieval' => 'Conditioneel ophalen mogelijk maken',
	'Enable dynamic cache' => 'Dynamische cache inschakelen',
	'Enable orientation normalization' => 'Normalisatie oriëntatie inschakelen',
	'Enable revision history' => 'Revisiegeschiedenis inschakelen',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Fout: Movable Type kon niet schrijven in de map om dynamische sjablonen in te cachen.  Controleer de schrijfpermissies van de map met de naam <code>[_1]</code> in de map van uw site.',
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Fout: Movable Type kon geen map aanmaken om uw [_1] in te publiceren.  Als u deze map zelf aanmaakt, zorg er dan voor dat de webserver er schrijfpermissies op heeft.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Fout: Movable Type kon geen map aanmaken om uw dynamische sjablonen in te cachen.  U moet een map aanmaken met de naam <code>[_1]</code> in de map van uw site.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Als u een andere taal kiest dan de standaard taal die op systeemniveau staat ingesteld, dan moet u mogelijk de namen van bepaalde modules aanpassen in bepaalde sjablonen om andere globale modules te kunnen includeren.',
	'Java Server Page Includes' => 'Java Server Page Includes',
	'Language' => 'Taal',
	'License' => 'Licentie',
	'Module Caching' => 'Modulecaching',
	'Module Settings' => 'Instellingen module',
	'No archives are active' => 'Geen archieven actief',
	'None (disabled)' => 'Geen (uitgeschakeld)',
	'Normalize orientation' => 'Oriëntatie normaliseren',
	'Note: Revision History is currently disabled at the system level.' => 'Opmerking: revisiegeschiedenis is momenteel uitgeschakeld op systeemniveau',
	'Number of revisions per content data' => 'Aantal reviesies per inhoudsgegeven',
	'Number of revisions per entry/page' => 'Aantal revisies per bericht/pagina',
	'Number of revisions per template' => 'Aantal revisies per sjabloon',
	'Operation if a file exists' => 'Actie als bestand al bestaat',
	'Overwrite existing file' => 'Bestaand bestand overschrijven',
	'PHP Includes' => 'PHP Includes',
	'Preferred Archive' => 'Voorkeursarchief',
	'Publish With No Entries' => 'Publiceren zonder berichten',
	'Publish archives outside of Site Root' => 'Archieven buiten de siteroot publiceren',
	'Publish category archive without entries' => 'Categorie-archief zonder berichten publiceren?',
	'Publishing Paths' => 'Publicatiepaden',
	'Remove license' => 'Licentie verwijderen',
	'Rename filename' => 'Bestandsnaam veranderen',
	'Rename non-ascii filename automatically' => 'Automatisch niet-ascii bestandsnaam aanpassen.',
	'Revision History' => 'Revisie-geschiedenis',
	'Revision history' => 'Revisiegeschiedenis',
	'Select a license' => 'Selecteer een licentie',
	'Server Side Includes' => 'Server Side Includes',
	'Site root must be under [_1]' => 'Siteroot moet vallen onder [_1]',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'De URL van de archiefsectie van uw subsite. Voorbeeld: http://www.voorbeeld.com/blog/archief/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'De URL van de archiefsectie van uw site. Voorbeeld: http://www.voorbeeld.com/archief/',
	'Time Zone' => 'Tijdzone',
	'Time zone not selected' => 'Geen tijdzone geselecteerd',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universeel Gecoördineerde Tijd)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Centraal-Europese tijd)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Oost-Australische tijd)',
	'UTC+11' => 'UTC+11',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale datumgrens - Oost)',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nieuw-Zeeland - zomertijd)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Oost-Europese tijd)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Tijd in Bagdad/Moskau)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Russische Federatie Zone 3)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Russische Federatie Zone 4)',
	'UTC+5.5 (Indian)' => 'UTC+5,5 (Indische tijd)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Russische Federatie Zone 5)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Noord-Sumatra)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (West-Australische tijd)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chinese kusttijd)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japanse tijd)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Centraal-Australische tijd)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (West-Afrika-tijd)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Aleutianen-Hawaïaanse tijd)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Nome tijd)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Azorentijd)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantische tijd)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Newfoundland)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantische tijd)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Oostkust tijd)',
	'UTC-6 (Central Time)' => 'UTC-6 (Central tijd)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Mountain tijd)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Westkust tijd)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska tijd)',
	'Upload Destination' => 'Uploadbestemming',
	'Upload and rename' => 'Uploaden en naam aanpassen',
	'Use absolute path' => 'Absoluut pad gebruiken',
	'Use subdomain' => 'Subdomein gebruiken',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '', # Translate - New
	'You did not select a time zone.' => 'U selecteerde geen tijdzone',
	'You must set a valid Archive URL.' => 'U moet een geldige archief URL instellen.',
	'You must set a valid Local Archive Path.' => 'U moet een geldig lokaal archiefpad instellen.',
	'You must set a valid Local file Path.' => 'U moet een geldig lokaal bestandspad instellen.',
	'You must set a valid URL.' => 'U moet een geldige URL instellen.',
	'You must set your Child Site Name.' => 'U moet de naam van uw subsite instellen.',
	'You must set your Local Archive Path.' => 'U moet uw lokaal archiefpad instellen.',
	'You must set your Local file Path.' => 'U moet uw lokaal bestandspad instellen.',
	'You must set your Site Name.' => 'U moet de naam van uw site instellen.',
	'Your child site does not have an explicit Creative Commons license.' => 'Uw subsite heeft geen expliciete Creative Commons licentie.',
	'Your child site is currently licensed under:' => 'Uw subsite heeft momenteel volgende licentie:',
	'Your site does not have an explicit Creative Commons license.' => 'Uw site heeft geen expliciete Creative Commons licentie.',
	'Your site is currently licensed under:' => 'Uw site heeft momenteel volgende licentie:',
	'[_1] Settings' => 'Instellingen [_1]',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{De URL van uw subsite.  Laat de bestandsnaam weg (m.a.w. index.html). Sluit af met '/'. Voorbeeld: http://www.voorbeeld.com/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{De URL van uw site.  Laat de bestandsnaam weg (m.a.w. index.html). Sluit af met '/'. Voorbeeld: http://www.voorbeeld.com/},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden.  Gelieve niet af te sluiten met '/' of '\'. Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html/blog of C:\www\public_html\blog},
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Wordt gebruikt om de URL's (permalinks) van de gearchiveerde berichten van deze subsite te genereren.  Kies één van de archieftypes die worden gebruikt in de archiefsjablonen van deze subsite.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Wordt gebruikt om de URL's (permalinks) van de gearchiveerde berichten van deze site te genereren.  Kies één van de archieftypes die worden gebruikt in de archiefsjablonen van deze site.},

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Action' => 'Actie',
	'Allow' => 'Toestaan',
	'Config Rebuild Trigger' => 'Configuratie rebuild trigger',
	'Content Privacy' => 'Privacy inhoud',
	'Cross-site aggregation will be allowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to restrict access to their content by other sites.' => '', # Translate - New
	'Cross-site aggregation will be disallowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to allow access to their content by other sites.' => '', # Translate - New
	'Data' => 'Data',
	'Default system aggregation policy' => 'Standaard aggregatiebeleid voor het systeem',
	'Disallow' => 'Verbieden',
	'Exclude sites/child sites' => 'Exclusief sites/subsites',
	'Include sites/child sites' => 'Inclusief sites/subsites',
	'MTMultiBlog tag default arguments' => 'MTMultiBlog tag standaard argumenten',
	'Rebuild Trigger settings have been saved.' => 'Instellingen rebuild trigger opgeslagen.',
	'Rebuild Triggers' => 'Rebuild-triggers',
	'Site/Child Site' => 'Site/subsite',
	'Use system default' => 'Standaard systeeminstelling gebruiken',
	'When' => 'Wanneer',
	'You have not defined any rebuild triggers.' => 'U heeft nog geen rebuild-triggers gedefiniëerd',
	q{Enables use of the MTSites tag without include_sites/exclude_sites attributes. Comma-separated SiteIDs or 'all' (include_sites only) are acceptable values.} => q{}, # Translate - New

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(Geen rol geselecteerd)',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'Bezoekers toestaan zicht te registreren als lid van deze site met één van de authenticatiemethodes hieronder geselecteerd.',
	'Authentication Methods' => 'Methodes voor authenticatie',
	'New Created User' => 'Nieuw aangemaakte gebruiker',
	'Note: Registration is currently disabled at the system level.' => 'Opmerking: Registratie is momenteel uitgeschakeld op systeemniveau',
	'One or more Perl modules may be missing to use this authentication method.' => 'Eén of meer perl modules om deze authenticatiemethode te kunnen gebruiken ontbreken mogelijk.',
	'Please select authentication methods to accept comments.' => 'Gelieve een authenticatiemethode te selecteren om reacties te kunnen ontvangen.',
	'Registration Not Enabled' => 'Registratie niet ingeschakeld',
	'Select a role that you want assigned to users that are created in the future.' => 'Selecteer een rol die u automatisch wenst toe te kennen aan gebruikers die in de toekomst worden aangemaakt.',
	'Select roles' => 'Selecteer rollen',
	'User Registration' => 'Gebruikersregistratie',
	'Your site preferences have been saved.' => 'Voorkeuren site opgeslagen.',

## tmpl/cms/cfg_system_general.tmpl
	'(No Outbound TrackBacks)' => '(Geen uitgaande TrackBacks)',
	'(None selected)' => '(Geen geselecteerd)',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Een Movable Type gebruiker zal geblokkeerd worden als hij of zij [_1] (of meer) keer een fout wachtwoord invoert binnen [_2] seconden.',
	'A test mail was sent.' => 'Een testmail werd verstuurd',
	'Allow sites to be placed only under this directory' => 'Accepteer enkel sites die in deze map geplaatst worden',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'Een IP adres zal geblokkeerd worden als meer dan [_1] foutieve aanmeldpogingen worden ondernomen binnen de [_2] seconden vanop hetzelfde IP adres.',
	'Base Site Path' => 'Basissitepad',
	'Changing image quality' => 'Afbeeldingskwaliteit aan het aanpassen',
	'Clear' => 'Leegmaken',
	'Debug Mode' => 'Debug modus',
	'Disable comments for all sites and child sites.' => 'Reacties uitschakelen voor alle sites en subsites.',
	'Disable notification pings for all sites and child sites.' => 'Notificaties uitschakelen voor alle sites en subsites.',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Ontvangst van trackbacks uitschakelen voor alle sites en subsites.',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Verstuur geen uitgaande TrackBacks en maak geen gebruik van TrackBack auto-discovery als het de bedoeling is uw installatie privé te houden.',
	'Enable image quality changing.' => 'Aanpassen afbeeldingskwaliteit inschakelen.',
	'IP address lockout policy' => 'Beleid blokkering IP adressen',
	'Image Quality Settings' => 'Kwaliteitsinstellingen afbeelding',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 85.' => 'Afbeeldingskwaliteit van geuploade JPEG afbeelding en thumbnail versie.  Deze waarde kan ingesteld worden als een geheel getal tussen 0 en 100.  Standaardwaarde is 85.',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'Afbeeldingskwaliteit van geuploade PNG afbeelding en thumbnail versie.  Deze waarde kan ingesteld worden als een geheel getal tussen 0 en 9.  Standaardwaarde is 7.',
	'Image quality(JPEG)' => 'Afbeeldingskwaliteit (JPEG)',
	'Image quality(PNG)' => 'Afbeeldingskwaliteit (PNG)',
	'Imager does not support ImageQualityPng.' => 'Imager ondersteunt ImageQualityPng niet.',
	'Lockout Settings' => 'Instellingen blokkering',
	'Log Path' => 'Logpad',
	'Logging Threshold' => 'Logdrempel',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Eén of meerdere van uw sites of subsites volgen de basispad restrictie (waarde van BaseSitePath) niet.',
	'Only to child sites within this system' => 'Enkel naar subsites in dit systeem',
	'Only to sites on the following domains:' => 'Enkel naar sites onder volgende domeinen:',
	'Outbound Notifications' => 'Uitgaande notificaties',
	'Performance Logging' => 'Performantielogging',
	'Prohibit Comments' => 'Reacties verbieden',
	'Prohibit Notification Pings' => 'Notificatiepings verbieden',
	'Prohibit TrackBacks' => 'Trackbacks verbieden',
	'Send Mail To' => 'Mail verzenden naar',
	'Send Outbound TrackBacks to' => 'Uitgaande TrackBacks sturen naar',
	'Send Test Mail' => 'Testmail versturen',
	'Send' => 'Versturen',
	'Site Path Limitation' => 'Sitepad beperking',
	'System Email Address' => 'Systeememailadres',
	'System-wide Feedback Controls' => 'Systeeminstellingen voor feedback',
	'The email address that should receive a test email from Movable Type.' => 'Het e-mail adres dat een test e-mail moet ontvangen van Movable Type.',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'De map in uw bestandssysteem waar performantielogs weggeschreven worden.  De webserver moet schrijfpermissies hebben in deze map.',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'De lijst met IP adressen.  Als een extern IP adres in deze lijst staat, dan zullen mislukte aanmeldpogingen niet worden geregistreerd.  Meerdere IP adressen kunnen worden opgegeven, van elkaar gescheiden met een komma of een nieuwe regel.',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Tijdslimiet voor niet gelogde gebeurtenissen, in seconden. Elke gebeurtenis die langer duurt dan deze hoeveelheid tijd zal worden gerapporteerd.',
	'Track revision history' => 'Revisiegeschiedenis bijhouden',
	'Turn on performance logging' => 'Loggen van performantie inschakelen',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Loggen van performantie inschakelen, dit zal alle gebeurtenissen in het systeem rapporteren die langer duren dan het aantal seconden ingesteld in de logdrempel.',
	'User lockout policy' => 'Beleid blokkering gebruikers',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Waarden anders dan nul bieden bijkomende diagnostische informatie om problemen op te lossen met uw Movable Type installatie.  Meer informatie is beschikbaar in de <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentatie</a>.',
	'You must set a valid absolute Path.' => 'U moet een absoluut pad instellen.',
	'You must set an integer value between 0 and 100.' => 'U moet een geheel getal instellen tussen 0 en 100.',
	'You must set an integer value between 0 and 9.' => 'U moet een geheel getal instellen tussen 0 en 9',
	'Your settings have been saved.' => 'Uw instellingen zijn opgeslagen.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Volgende IP adressen staan echter op de 'witte lijst' en zullen nooit geblokkeerd worden:},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{De systeembeheerders die op de hoogte gebracht moeten worden als een gebruiker of IP adres geblokkeerd wordt.  Indien geen administrators geselecteerd zijn, worden de berichten naar eht 'Systeem e-mail adres' gestuurd.},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Dit email adres word gebruikt in de 'From:' header van elke email die door Movable Type wordt verzonden.  Email kan verstuurd worden om een wachtwoord terug te krijgen, een reageerder te registreren, notificaties te verzenden van reacties of TrackBacks, blokkeringen van gebruikers of IP adressen en in nog een paar andere gevallen.},

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => 'Registratie toestaan',
	'Allow commenters to register on this system.' => 'Toestaan dat reageerders zich registreren op dit systeem.',
	'Comma' => 'Komma',
	'Default Tag Delimiter' => 'Standaard tagscheidingsteken',
	'Default Time Zone' => 'Standaard tijdzone',
	'Default User Language' => 'Standaard taal',
	'Minimum Length' => 'Minimale lengte',
	'New User Defaults' => 'Standaardinstellingen nieuwe gebruikers',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Opmerking: systeem e-mail adres is niet ingesteld onder Systeem > Algemene Instellingen.  E-mails zullen niet worden verstuurd.',
	'Notify the following system administrators when a commenter registers:' => 'De systeembeheerder op de hoogte brengen wanneer een reageerder zich registreert:',
	'Options' => 'Opties',
	'Password Validation' => 'Validering wachtwoord',
	'Select system administrators' => 'Systeembeheerder kiezen',
	'Should contain letters and numbers.' => 'Moet letters en cijfers bevatten',
	'Should contain special characters.' => 'Moet speciale karakters bevatten',
	'Should contain uppercase and lowercase letters.' => 'Moet hoofdletters en kleine letters bevatten',
	'Space' => 'Spatie',
	'This field must be a positive integer.' => 'Dit veld moet een positief geheel getal zijn.',

## tmpl/cms/cfg_web_services.tmpl
	'Data API Settings' => 'Data API instellingen',
	'Data API' => 'Data API',
	'Enable Data API in system scope.' => 'Data API inschakelen op systeemniveau.',
	'Enable Data API in this site.' => 'Data API inschakelen voor deze site.',
	'External Notifications' => 'Externe notificaties',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => '
	Noot: deze optie wordt momenteel genegeerd omdat uitgaande notificatiepings zijn uitgeschakeld op systeemniveau.',
	'Notify ping services of [_1] updates' => 'Ping services op de hoogte brengen van [_1] updates',
	'Others:' => 'Andere:',
	q{(Separate URLs with a carriage return.)} => q{(URL's van elkaar scheiden met een carriage return.)},

## tmpl/cms/content_data/select_list.tmpl
	'No Content Type.' => 'Geen inhoudstype.',
	'Select List Content Type' => 'Selecteer lijst inhoudstype',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to select multiple assets?' => 'Gebruikers toestaan meerdere mediabestanden te selecteren?',
	'Allow users to upload a new asset?' => 'Gebruikers toestaan nieuwe mediabestanden te uploaden?',
	'Maximum number of selections' => 'Maximum aantal selecties',
	'Minimum number of selections' => 'Minimum aantal selecties',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to upload a new audio asset?' => 'Gebruikers toestaan een nieuw audiobestand te uploaden?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => 'Gebruikers toestaan meerdere afbeeldingsbestanden te selecteren?',
	'Allow users to upload a new image asset?' => 'Gebruikers toestaan nieuwe afbeeldingsbestanden te uploaden?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => 'Gebruikers toestaan meerdere videobestanden te selecteren?',
	'Allow users to upload a new video asset?' => 'Gebruikers toestaan nieuwe videobestanden te uploaden?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to create new categories?' => 'Gebruikers toestaan nieuwe categorieën aan te maken?',
	'Allow users to select multiple categories?' => 'Gebruikers toestaan meerdere categorieën te selecteren?',
	'Source Category Set' => 'Broncategorieset',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Selected' => 'Geselecteerd',
	'Value' => 'Waarde',
	'Values' => 'Waarden',
	'add' => 'toevoegen',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => 'Gebruikers toestaan meerdere waarden te selecteren?',
	'Source Content Type' => 'Broninhoudstype',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'Er is geen inhoudstype dat kan worden geselecteerd.  Gelieve een inhoudstype aan te maken als u het inhoudstype veldtype wenst te gebruiken.',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Beginwaarde',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Beginwaarde (datum)',
	'Initial Value (Time)' => 'Beginwaarde (tijd)',

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => 'Invoerformaat',
	'Use all rich text decoration buttons' => '', # Translate - New

## tmpl/cms/content_field_type_options/number.tmpl
	'Max Value' => 'Max waarde',
	'Min Value' => 'Min waarde',
	'Number of decimal places' => 'Aantal decimalen',

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Max Length' => 'Max lengte',
	'Min Length' => 'Min lengte',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Allow users to increase/decrease cols?' => 'Gebruikers toestaan het aantal kolommen te verhogen/verlagen?',
	'Allow users to increase/decrease rows?' => 'Gebruikers toestaan het aantal rijen te verhogen/verlagen?',
	'Initial Cols' => 'Initiëel aantal kolommen',
	'Initial Rows' => 'Initiëel aantal rijen',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to create new tags?' => 'Gebruikers toestaan om nieuwe tags aan te maken?',
	'Allow users to input multiple values?' => 'Gebruikers toestaan meerdere waarden in te voeren?',

## tmpl/cms/content_field_type_options/text_label.tmpl
	'This block is only visible in the administration screen for comments.' => '', # Translate - New
	'__TEXT_LABEL_TEXT' => '', # Translate - New

## tmpl/cms/dashboard/dashboard.tmpl
	'Dashboard' => 'Dashboard',
	'Select a Widget...' => 'Selecteer een widget...',
	'System Overview' => 'Systeemoverzicht',
	'Your Dashboard has been updated.' => 'Uw dashboard is bijgewerkt.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => 'Terug (b)',
	'Confirm Publishing Configuration' => 'Bevestig publicatieconfiguratie',
	'Continue (s)' => 'Doorgaan (s)',
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Vul de nieuwe URL in van de archiefsectie van uw subsite.  Voorbeeld: http://www.voorbeeld.com/blog/archieven/',
	'Please choose parent site.' => 'Gelieve een hoofdsite te kiezen.',
	'Site Path' => 'Sitepad',
	'You must select a parent site.' => 'U moet een hoofdsite selecteren',
	'You must set a valid Site URL.' => 'U moet een geldige URL instellen voor uw site.',
	'You must set a valid local site path.' => 'U moet een geldig lokaal site-pad instellen.',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Vul de nieuwe URL in van uw publieke subsite.  Eindig met '/'/. Voorbeeld: http://www.voorbeeld.com/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul het pad in waar het hoofdindexbestand van uw blog gepubliceerd zal worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul het nieuwe pad in waar uw hoofdindexbestanden zich zullen bevinden.  Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},

## tmpl/cms/dialog/asset_edit.tmpl
	'An error occurred.' => 'Er deed zich een fout voor.',
	'Close (x)' => 'Sluiten (x)',
	'Edit Asset' => 'Mediabestand bewerken',
	'Edit Image' => 'Afbeelding bewerken',
	'Error creating thumbnail file.' => 'Fout bij aanmaken thumbnailbestand.',
	'File Size' => 'Bestandsgrootte',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'De metadata kan niet worden bijgewerkt omdat de metadata van deze afbeelding fouten lijkt te bevatten.',
	'Save changes to this asset (s)' => 'Wijzigingen aan dit mediabestand opslaan (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u deze dialoog wenst te sluiten?',
	'Your changes have been saved.' => 'Uw wijzigingen zijn opgeslagen.',
	'Your edited image has been saved.' => 'U bewerkte afbeelding werd opgeslagen.',

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Mediabestanden toevoegen',
	'Cancel (x)' => 'Annuleren (x)',
	'Choose Asset' => 'Mediabestanden kiezen',
	'Insert (s)' => 'Invoegen (s)',
	'Insert' => 'Invoegen',
	'Library' => 'Bibliotheek',
	'Next (s)' => 'Volgende (s)',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'Maak een nieuw bericht aan met dit opgeladen bestand',
	'Create entry using this uploaded file' => 'Bericht aanmaken met dit opgeladen bestand',
	'File Options' => 'Bestandsopties',
	'Finish (s)' => 'Klaar (s)',
	'Finish' => 'Klaar',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'U moet uw weblog configureren.',
	'Your blog has not been published.' => 'Uw blog is nog niet gepubliceerd.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Categories/Folders' => 'Categorieën/mappen',
	'Child Site Details' => 'Details subsite',
	'Clone' => 'Kloon',
	'Confirm' => 'Bevestigen',
	'Exclude Categories/Folders' => 'Categorieën en mappen uitsluiten',
	'Exclude Comments' => 'Reacties uitsluiten',
	'Exclude Trackbacks' => 'TrackBacks uitsluiten',
	'Exclusions' => 'Uitzonderingen',
	'This is set to the same URL as the original child site.' => 'Dit wordt ingesteld als dezelfde URL als de oorspronkelijke subsite',
	'This will overwrite the original child site.' => 'Dit zal de oorspronkelijke subsite overschrijven',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => 'Waarschuwing: de archief URL veranderen kan er toe leiden dat alle links in uw subsite niet meer werken.',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Waarschuwing: het archiefpad veranderen kan er toe leiden dat alle links in uw subsite niet meer werken.',
	q{Entries/Pages} => q{Berichten/pagina's},
	q{Exclude Entries/Pages} => q{Berichten en pagina's uitsluiten},

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'Op [_1] reageerde [_2] op [_3]',
	'Reply to comment' => 'Antwoorden op een reactie',
	'Submit reply (s)' => 'Antwoord ingeven (s)',
	'Your reply:' => 'Uw antwoord:',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => '[_1] toevoegen',
	'Choose [_1]' => 'Kies [_1]',
	'Create and Insert' => 'Aanmaken en invoegen',

## tmpl/cms/dialog/create_association.tmpl
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Er bestaan geen blogs in deze installatie.[_1]Maak een blog aan</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Er bestaan geen groepen in deze installatie.[_1]Maak een groep aan</a>',
	'No roles exist in this installation. [_1]Create a role</a>' => 'Er bestaan geen rollen in deze installatie.[_1]Maak een rol aan</a>',
	'No sites exist in this installation. [_1]Create a site</a>' => 'Er bestaan geen sites in deze installatie.[_1]Maak een site aan</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Er bestaan geen gebruikers in deze installatie.[_1]Maak een gebruiker aan</a>',
	'all' => 'alle',

## tmpl/cms/dialog/create_trigger.tmpl
	'Event' => 'Gebeurtenis',
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'ALS <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> wordt <span class="badge source-trigger-badge">Getriggerd</span>, <span class="badge destination-action-badge">Actie</span> in <span class="badge destination-site-badge">Site</span>',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',
	'Object Name' => 'Objectnaam',
	'Select Trigger Action' => 'Selecteer triggeractie',
	'Select Trigger Event' => 'Selecteer triggergebeurtenis',
	'Select Trigger Object' => 'Selecteer triggerobject',

## tmpl/cms/dialog/edit_image.tmpl
	'Crop' => 'Bijsnijden',
	'Flip horizontal' => 'Horizontaal spiegelen',
	'Flip vertical' => 'Verticaal spiegelen',
	'Height' => 'Hoogte',
	'Keep aspect ratio' => 'Verhouding behouden',
	'Redo' => 'Herhalen',
	'Remove All metadata' => 'Alle metadata verwijderen',
	'Remove GPS metadata' => 'GPS metadata verwijderen',
	'Rotate left' => 'Links draaien',
	'Rotate right' => 'Rechts draaien',
	'Save (s)' => 'Opslaan (s)',
	'Undo' => 'Ongedaan maken',
	'Width' => 'Breedte',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Er zijn niet opgeslagen wijzigingen aan deze afbeelding die verloren zullen gaan.  Bent u zeker dat u deze dialoog wil sluiten?',

## tmpl/cms/dialog/entry_notify.tmpl
	'(Body will be sent without any text formatting applied.)' => '(Romp van de tekst zal verstuurd worden zonder enige tekstformattering.)',
	'All addresses from Address Book' => 'Alle adressen uit het adresboek',
	'Optional Content' => 'Optionele inhoud',
	'Optional Message' => 'Optionele boodschap',
	'Recipients' => 'Ontvangers',
	'Send a Notification' => 'Notificatie versturen',
	'Send notification (s)' => 'Notificaties versturen (s)',
	'You must specify at least one recipient.' => 'U moet minstens één ontvanger opgeven.',
	q{Enter email addresses on separate lines or separated by commas.} => q{Vul e-mail adressen in op afzonderlijke regels of gescheiden door komma's.},
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{De naam, titel en link van uw [_1] zullen verstuurd worden in de notificatie.  U kunt bijkomend een boodschap toevoegen, een uittreksel meesturen of zelfs de hele romp van de tekst.},

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Selecteer de revisie om de waarden in het bewerkingsscherm mee te vullen.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Waarschuwing: u moet geuploade mediabestanden met de hand naar het nieuwe pad kopiëren.  Het is eveneens aan te raden de bestanden in het oude pad niet te verwijderen om gebroken links te vermijden.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Display [_1]' => 'Geef [_1] weer',
	'Insert Options' => 'Invoegopties',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Wachtwoord wijzigen',
	'Change' => 'Wijzig',
	'Confirm New Password' => 'Nieuw wachtwoord bevestigen',
	'Enter the new password.' => 'Vul het nieuwe wachtwoord in',
	'New Password' => 'Nieuw wachtwoord',
	'The password for the user \'[_1]\' has been recovered.' => '', # Translate - New

## tmpl/cms/dialog/publishing_profile.tmpl
	'All templates published statically via Publish Queue.' => 'Alle sjablonen worden statisch gepubliceerd via de publicatiewachtrij.',
	'Are you sure you wish to continue?' => 'Bent u zeker dat verder u wenst te gaan?',
	'Background Publishing' => 'Pubiceren in de achtergrond',
	'Choose the profile that best matches the requirements for this [_1].' => 'Kies het profiel dat het beste overeen komt met de vereisten voor deze [_1].',
	'Dynamic Archives Only' => 'Enkel archieven dynamisch',
	'Dynamic Publishing' => 'Dynamisch publiceren',
	'Execute' => '', # Translate - New
	'High Priority Static Publishing' => 'Statisch publiceren met hoge prioriteit',
	'Immediately publish Main Index and Feed template, Entry archives, Page archives and ContentType archives statically. Use Publish Queue to publish all other templates statically.' => '', # Translate - New
	'Immediately publish all templates statically.' => 'Alle sjablonen onmiddellijk statisch publiceren',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle archiefsjablonen dynamisch publiceren.  Alle andere sjablonen statisch publiceren.',
	'Publish all templates dynamically.' => 'Alle sjablonen dynamisch publiceren.',
	'Publishing Profile' => 'Publicatieprofiel',
	'Static Publishing' => 'Statisch publiceren',
	'This new publishing profile will update your publishing settings.' => 'Dit nieuwe publicatieprofiel zal uw publicatie-instellingen bijwerken.',
	'child site' => 'subsite',
	'site' => 'site',

## tmpl/cms/dialog/recover.tmpl
	'Back (x)' => 'Terug (x)',
	'Reset (s)' => 'Reset (s)',
	'Reset Password' => 'Wachtwoord opnieuw instellen',
	'Sign in to Movable Type (s)' => 'Aanmelden op Movable Tpe (s)',
	'Sign in to Movable Type' => 'Aanmelden op Movable Type',
	'The email address provided is not unique.  Please enter your username.' => 'Het opgegeven e-mail adres is niet uniek.  Gelieve uw gebruikersnaam op te geven.',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Kan sjabloonset niet vinden.  Gelieve een [_1]thema[_2] toe te passen om uw sjablonen te vernieuwen.',
	'Make backups of existing templates first' => 'Eerst backups nemen van bestaande sjablonen',
	'Refresh Global Templates' => 'Globale sjablonen verversen',
	'Refresh global templates' => 'Globale sjablonen verversen',
	'Reset to factory defaults' => 'Terug naar fabrieksinstellingen',
	'Reset to theme defaults' => 'Terugkeren naar standaardinstellingen',
	'Revert modifications of theme templates' => 'Wijzignen aan themasjablonen ongedaan maken',
	'Updates current templates while retaining any user-created templates.' => 'Ververst de huidige sjabonen maar bewaart sjablonen aangemaakt door gebruikers.',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'U heeft gevraagd om <strong>een nieuwe sjabloonset toe te passen</strong>. Deze actie zal:',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'U heeft gevraagd om <strong>de huidige sjabloonset te verversen</strong>.  Deze actie zal:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'U heeft gevraagd om <strong>de huidige set sjabonen te verversen</strong>.  Deze actie zal:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'U heeft gevraagd om <strong>de standaard globale sjablonen terug te zetten</strong>. Deze actie zal:',
	'delete all of the templates in your blog' => 'alle sjablonen in uw blog verwijderen',
	'delete all of your global templates' => 'al uw globale sjablonen verwijderen',
	'install new templates from the default global templates' => 'nieuwe sjablonen installeren uit de standaard globale sjablonen',
	'install new templates from the selected template set' => 'nieuwe sjablonen installeren uit de geselecteerde sjabloonset',
	'make backups of your templates that can be accessed through your backup filter' => 'backups maken van uw sjabonen, die toegankelijk zijn via de backup filter',
	'overwrite some existing templates with new template code' => 'enkele bestaande sjablonen overschrijven met nieuwe sjablooncode',
	'potentially install new templates' => 'potentiëel nieuwe sjablonen installeren',
	q{Deletes all existing templates and install the selected theme's default.} => q{Verwijdert alle bestaande sjablonen en installeert de standaardinstellingen van het geselecteerde thema.},
	q{Deletes all existing templates and installs factory default template set.} => q{Verwijdert alle bestaande sjablonen en installeert de standaard sjabloonset uit de 'fabrieksinstellingen'.},

## tmpl/cms/dialog/restore_end.tmpl
	'All data imported successfully!' => 'Alle gegevens werden met succes geïmporteerd!',
	'An error occurred during the import process: [_1] Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1] Gelieve het importbestand te controleren.',
	'Close (s)' => 'Sluiten (s)',
	'Next Page' => 'Volgende pagina',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Deze pagina zal binnen drie seconden doorverwijzen naar een andere pagina. [_1]Stop de doorverwijzing[_2]',
	'View Activity Log (v)' => 'Activiteitenlog bekijken (v)',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importeren...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'De procedure nu stopzetten zal wees-objecten achterlaten.  Bent u zeker dat u de restore-operatie wenst te annuleren.',
	'Please upload the file [_1]' => 'Gelieve bestand [_1] te uploaden',
	'Restore: Multiple Files' => 'Terugzetten: meerdere bestanden',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to group' => 'Geef site permissies aan groep',
	'Grant site permission to user' => 'Geef site permissies aan gebruiker',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => 'Komt voor in...',
	'Embed Asset' => 'Mediabestand embedden',
	'Prev' => 'Vorige',
	'Related Assets' => 'Gerelateerde mediabestanden',
	'Stats' => 'Statistieken',
	'This asset has been used by other users.' => 'Dit mediabestand werd ook gebruikt door andere gebruikers.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u de afbeelding wenst te bewerken?',
	'You have unsaved changes to this asset that will be lost.' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.',
	'You must specify a name for the asset.' => 'U moet een naam opgeven voor het mediabestand.',
	'[_1] - Created by [_2]' => '[_1] - aangemaakt door [_2]',
	'[_1] - Modified by [_2]' => '[_1] - aangepast door [_2]',
	'[_1] is missing' => '[_1] ontbreekt',

## tmpl/cms/edit_author.tmpl
	'(Use Site Default)' => '(Standaardinstelling site gebruiken)',
	'A new password has been generated and sent to the email address [_1].' => 'Een nieuw wachtwoord werd gegenerereerd en is verzonden naar het e-mail adres [_1].',
	'Confirm Password' => 'Wachtwoord bevestigen',
	'Create User (s)' => 'Gebruiker aanmaken (s)',
	'Current Password' => 'Huidig wachtwoord',
	'Date Format' => 'Datumformaat',
	'Default date formatting in the Movable Type interface.' => 'Standaard datumformattering in de Movable Type interface.',
	'Display language for the Movable Type interface.' => 'Getoonde taal van de Movable Type interface.',
	'Edit Profile' => 'Profiel bewerken',
	'Enter preferred password.' => 'Gekozen wachtwoord invoeren',
	'Error occurred while removing userpic.' => 'Er deed zich een fout voor bij het verwijderen van de gebruikersafbeelding',
	'External user ID' => 'Extern user ID',
	'Full' => 'Volledig',
	'Initial Password' => 'Initiëel wachtwoord',
	'Initiate Password Recovery' => 'Procedure starten om wachtwoord terug te halen',
	'Password recovery word/phrase' => 'Woord/uitdrukking om wachtwoord terug te vinden',
	'Preferences' => 'Voorkeuren',
	'Preferred method of separating tags.' => 'Voorkeursmethode om tags van elkaar te scheiden',
	'Relative' => 'Relatief',
	'Remove Userpic' => 'Verwijder foto gebruiker',
	'Reveal' => 'Onthul',
	'Save changes to this author (s)' => 'Wijzigingen aan deze auteur opslaan (s)',
	'Select Userpic' => 'Selecteer foto gebruiker',
	'System Permissions' => 'Systeempermissies',
	'Tag Delimiter' => 'Scheidingsteken tags',
	'Text Format' => 'Tekstformaat',
	'The name displayed when content from this user is published.' => 'De naam die getoond wordt wanneer inhoud van deze gebruiker wordt gepubliceerd.',
	'This profile has been unlocked.' => 'Dit profiel werd gedeblokkeerd',
	'This profile has been updated.' => 'Dit profiel werd bijgewerkt.',
	'This user was classified as disabled.' => 'Deze gebruiker werd geclassificeerd als gedeactiveerd',
	'This user was classified as pending.' => 'Deze gebruiker werd geclassificeerd als in aanvraag',
	'This user was locked out.' => 'Deze gebruiker werd geblokkeerd',
	'User properties' => 'Eigenschappen gebruiker',
	'Web Services Password' => 'Webservices wachtwoord',
	'You must use half-width character for password.' => 'U moet karakters van halve breedte gebruiken voor het wachtwoord.',
	'Your web services password is currently' => 'Uw huidig webservices wachtwoord is',
	'_USAGE_PASSWORD_RESET' => 'Hieronder kunt u een nieuw wachtwoord laten instellen voor deze gebruiker.  Als u ervoor kiest om dit te doen, zal een willekeurig gegenereerd wachtwoord worden aangemaakt en rechtstreeks naar volgend e-mail adres worden verstuurd: [_1].',
	'_USER_DISABLED' => 'Uitgeschakeld',
	'_USER_ENABLED' => 'Ingeschakeld',
	'_USER_PENDING' => 'Te keuren',
	'_USER_STATUS_CAPTION' => 'status',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'U staat op het punt het wachtwoord voor \"[_1]\" opnieuw in te stellen.  Een nieuw wachtwoord zal willekeurig worden aangemaakt en zal rechtstreeks naar het e-mail adres van deze gebruiker ([_2]) worden gestuurd.\n\nWenst u verder te gaan?',
	q{Default text formatting filter when creating new entries and new pages.} => q{Standaard tekstformatteringsfilter bij het aanmaken van berichten en pagina's},
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Als u deze gebruiker wenst te deblokkeren, klik dan op de 'Deblokkeren' link. <a href="[_1]">Deblokkeren</a>},
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{De website van deze gebruiker (m.a.w. http://www.mijnsite.com).  Als de website URL en getoonde naam velden allebei ingevuld zijn, dan zal Movable Type standaard berichten en reacties publiceren met onderschriften gelinkt naar deze URL.},

## tmpl/cms/edit_blog.tmpl
	'Create Child Site (s)' => 'Subsite aanmaken (s)',
	'Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Vul de URL in van uw subsite.  Laat de bestandsnaam vallen (b.v. index.hmtl).  Voorbeeld: http://www.voorbeeld.com/blog/',
	'Name your child site. The site name can be changed at any time.' => 'Geef uw subsite een naam.  De naam van de site kan op elk moment worden veranderd.',
	'Select the theme you wish to use for this child site.' => 'Selecteer het thema dat u wenst te gebruiken voor deze subsite.',
	'Select your timezone from the pulldown menu.' => 'Selecteer uw tijdzone in de keuzelijst.',
	'Site Theme' => 'Sitethema',
	'You must set your Local Site Path.' => 'U dient het lokale pad van uw site in te stellen.',
	'Your child site configuration has been saved.' => 'Instellingen voor uw subsite zijn opgeslagen.',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden zich zullen bevinden. Een absoluut pad (beginnend met \'/\' onder Linux of \'C:\' onder Windows) verdient de voorkeur. Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden zich zullen bevinden.  Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Allow pings' => 'Pings toestaan',
	'Edit Category' => 'Categorie bewerken',
	'Inbound TrackBacks' => 'Inkomende TrackBacks',
	'Manage entries in this category' => 'Berichten beheren in deze categorie',
	'Outbound TrackBacks' => 'Uitgaande TrackBacks',
	'Passphrase Protection' => 'Wachtwoordbeveiliging',
	'Please enter a valid basename.' => 'Gelieve een geldige basisnaam in te vullen.',
	'Save changes to this category (s)' => 'Wijzigingen aan deze categorie opslaan (s)',
	'This is the basename assigned to your category.' => 'Dit is de basisnaam toegekend aan uw categorie',
	'TrackBack URL for this category' => 'TrackBack URL voor deze categorie',
	'Useful links' => 'Nuttige links',
	'View TrackBacks' => 'TrackBacks bekijken',
	'You must specify a basename for the category.' => 'U moet een basisnaam opgeven voor de categorie.',
	'You must specify a label for the category.' => 'U moet een label opgeven voor de categorie.',
	'_CATEGORY_BASENAME' => 'Basename',
	q{Trackback URLs} => q{TrackBack URL's},
	q{Warning: Changing this category's basename may break inbound links.} => q{Waarschuwing: de basisnaam van deze categorie veranderen kan inkomende links verbreken.},

## tmpl/cms/edit_comment.tmpl
	'Ban Commenter' => 'Verban reageerder',
	'Comment Text' => 'Tekst reactie',
	'Commenter Status' => 'Status reageerder',
	'Delete this comment (x)' => 'Deze reactie verwijderen (x)',
	'Manage Comments' => 'Reacties beheren',
	'No url in profile' => 'Geen URL in profiel',
	'Reply to this comment' => 'Antwoorden op deze reactie',
	'Reported as Spam' => 'Gerapporteerd als spam',
	'Responses to this comment' => 'Antwoorden op dit bericht',
	'Results' => 'Resultaten',
	'Save changes to this comment (s)' => 'Wijzigingen aan deze reactie opslaan (s)',
	'Score' => 'Score',
	'Test' => 'Test',
	'The comment has been approved.' => 'De reactie is goedgekeurd.',
	'This comment was classified as spam.' => 'Deze reactie werd geclassificeerd als spam',
	'Total Feedback Rating: [_1]' => 'Totale feedbackscore: [_1]',
	'Trust Commenter' => 'Vertrouw reageerder',
	'Trusted' => 'Vertrouwde',
	'Unavailable for OpenID user' => 'Niet beschikbaar voor OpenID gebruiker',
	'Unban Commenter' => 'Ontban reageerder',
	'Untrust Commenter' => 'Wantrouw reageerder',
	'View [_1] comment was left on' => 'Bekijk [_1] reactie achtergelaten op',
	'View all comments by this commenter' => 'Alle reacties van deze reageerder bekijken',
	'View all comments created on this day' => 'Alle reacties van die dag bekijken',
	'View all comments from this IP Address' => 'Alle reacties van dit IP-adres bekijken',
	'View all comments on this [_1]' => 'Alle reacties bekijken op [_1]',
	'View all comments with this URL' => 'Alle reacties met deze URL bekijken',
	'View all comments with this email address' => 'Alle reacties met dit e-mail adres bekijken',
	'View all comments with this status' => 'Alle reacties met deze status bekijken',
	'View this commenter detail' => 'Details over deze reageerder bekijken',
	'[_1] no longer exists' => '[_1] bestaat niet meer',
	'_external_link_target' => '_blank',
	'comment' => 'reactie',
	'comments' => 'reacties',

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => 'Bevestigd',
	'Ban user (b)' => 'Gebruiker verbannen (b)',
	'Ban' => 'Verban',
	'Comments from [_1]' => 'Reacties van [_1]',
	'Identity' => 'Identiteit',
	'The commenter has been banned.' => 'Deze reageerder is verbannen.',
	'The commenter has been trusted.' => 'Deze reageerder wordt vertrouwd.',
	'Trust user (t)' => 'Gebruiker vertrouwen (t)',
	'Trust' => 'Vertrouwen',
	'Unban user (b)' => 'Ban op gebruiker opheffen',
	'Unban' => 'Ban opheffen',
	'Untrust user (t)' => 'Gebruiker niet meer vertrouwen (r)',
	'Untrust' => 'Niet vetrouwen',
	'View all comments with this name' => 'Alle reacties met deze naam bekijken',
	'View' => 'Bekijken',
	'Withheld' => 'Niet onthuld',
	'commenter' => 'reageerder',
	'commenters' => 'reageerders',
	'to act upon' => 'om de handeling op uit te voeren',

## tmpl/cms/edit_content_data.tmpl
	'(Max length: [_1])' => '(Max lengte: [_1])',
	'(Max select: [_1])' => '(Max selectie: [_1])',
	'(Max tags: [_1])' => '(Max tags: [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max: [_1] / Aantal decimalen: [_2])',
	'(Max: [_1])' => '(Max: [_1])',
	'(Min length: [_1] / Max length: [_2])' => '(Min lengte: [_1] / Max lengte: [_2])',
	'(Min length: [_1])' => '(Min lengte: [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(Min selectie: [_1] / Max selectie: [_2])',
	'(Min select: [_1])' => '(Min selectie: [_1])',
	'(Min tags: [_1] / Max tags: [_2])' => '(Min tags: [_1] / Max tags: [_2])',
	'(Min tags: [_1])' => '(Min tags: [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min: [_1] / Max: [_2] / Aantal decimalen: [_3])',
	'(Min: [_1] / Max: [_2])' => '(Min: [_1] / Max: [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min: [_1] / Aantal decimalen: [_2])',
	'(Min: [_1])' => '(Min: [_1])',
	'(Number of decimal places: [_1])' => '(Aantal decimalen: [_1])',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Nog een [_2] aanmaken?</a>',
	'@' => '@',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van deze inhoudsgegevens werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'An error occurred while trying to recover your saved content data.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen inhoudsgegevens.',
	'Auto-saving...' => 'Auto-opslaan...',
	'Change note' => 'Notitie wijzigen',
	'Draft this [_1]' => 'Maak [_1] klad',
	'Enter a label to identify this data' => 'Voer een label in om deze gegevens te identificeren',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Laatste auto-opslag om [_1]:[_2]:[_3]',
	'No revision(s) associated with this [_1]' => 'Geen revisies geassociëerd met [_1]',
	'Not specified' => 'Niet opgegeven',
	'One tag only' => 'Slechts één tag',
	'Permalink:' => 'Permalink:',
	'Publish On' => 'Publiceren op',
	'Publish this [_1]' => 'Publiceer [_1]',
	'Published Time' => 'Publicatietijd',
	'Revision: <strong>[_1]</strong>' => 'Revisie: <strong>[_1]</strong>',
	'Save this [_1]' => '[_1] bewaren',
	'Schedule' => 'Plannen',
	'This [_1] has been saved.' => 'Deze [_1] werd opgeslagen',
	'Unpublish this [_1]' => 'Maak publicatie van [_1] ongedaan',
	'Unpublished (Draft)' => 'Niet gepubliceerd (klad)',
	'Unpublished (Review)' => 'Niet gepubliceerd (na te kijken)',
	'Unpublished (Spam)' => 'Niet gepubliceerd (spam)',
	'Unpublished Date' => 'Einddatum publicatie',
	'Unpublished Time' => 'Ontpublicatietijd',
	'Update this [_1]' => 'Werk [_1] bij',
	'Update' => 'Bijwerken',
	'View revisions of this [_1]' => 'Revisies bekijken van [_1]',
	'View revisions' => 'Revisies bekijken',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Waarschuwing: als u de basisnaam met de hand instelt dan kan deze in conflict komen met andere inhoudsgegevens.',
	'You have successfully recovered your saved content data.' => 'U heb met succes uw opgeslagen inhoudsgegevens teruggehaald.',
	'You must configure this site before you can publish this content data.' => '', # Translate - New
	q{Warning: Changing this content data's basename may break inbound links.} => q{Waarschuwing: de basisnaam van deze inhoudsgegevens veranderen kan inkomende links breken.},

## tmpl/cms/edit_content_type.tmpl
	'1 or more label-value pairs are required' => '1 of meer label-waarde paren zijn vereist',
	'Available Content Fields' => 'Beschikbare inhoudsvelden',
	'Contents type settings has been saved.' => 'Instellingen inhoudstype zijn opgeslagen.',
	'Edit Content Type' => 'Inhoudstype aanpassen',
	'Reason' => 'Reden',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'Sommige inhoudsvelden werden niet verwijderd.  U moet eerst de archiefmappingen voor het inhoudsveld verwijderen.',
	'This field must be unique in this content type' => 'Dit veld moet uniek zijn binnen dit inhoudstype',
	'Unavailable Content Fields' => 'Niet beschikbare inhoudsvelden',

## tmpl/cms/edit_entry.tmpl
	'(space-delimited list)' => '(lijst gescheiden met spaties)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van dit bericht werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van deze pagina werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>',
	'Accept' => 'Aanvaarden',
	'Add Entry Asset' => 'Mediabestand toevoegen',
	'Add category' => 'Categorie toevoegen',
	'Add new category parent' => 'Nieuwe bovenliggende categorie toevoegen',
	'Add new folder parent' => 'Nieuwe bovenliggende map toevoegen',
	'An error occurred while trying to recover your saved entry.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen bericht.',
	'An error occurred while trying to recover your saved page.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen pagina.',
	'Category Name' => 'Naam categorie',
	'Change Folder' => 'Map wijzigen',
	'Converting to rich text may result in changes to your current document.' => 'Converteren naar Rich Text kan wijzigingen aan uw document tot gevolg hebben.',
	'Create Entry' => 'Nieuw bericht opstellen',
	'Create Page' => 'Pagina aanmaken',
	'Delete this entry (x)' => 'Bericht verwijderen (x)',
	'Delete this page (x)' => 'Pagina verwijderen (x)',
	'Draggable' => 'Sleepbaar',
	'Edit Entry' => 'Bericht bewerken',
	'Edit Page' => 'Pagina bewerken',
	'Enter the link address:' => 'Vul het adres van de link in:',
	'Enter the text to link to:' => 'Vul de tekst van de link in:',
	'Format:' => 'Formaat:',
	'Make primary' => 'Maak dit een hoofdcategorie',
	'Manage Entries' => 'Berichten beheren',
	'No assets' => 'Geen mediabestanden',
	'None selected' => 'Geen geselecteerd',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Eén of meer problemen deden zich voor bij het versturen van update pings of TrackBacks.',
	'Outbound TrackBack URLs' => 'Uitgaande TrackBack URLs',
	'Preview this entry (v)' => 'Voorbeeld bericht bekijken (v)',
	'Preview this page (v)' => 'Voorbeeld pagina bekijken (v)',
	'Reset display options to blog defaults' => 'Opties schermindeling terugzetten naar blogstandaard',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Teruggeplaatste revisie (Datum:[_1]).  De huidige status is: [_1]',
	'Selected Categories' => '', # Translate - New
	'Share' => 'Delen',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Sommige [_1] in de revisie konden niet worden geladen omdat ze werden verwijderd.',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Sommige tags in de revisie konden niet worden geladen omdat ze werden verwijderd.',
	'This entry has been saved.' => 'Dit bericht werd opgeslagen',
	'This page has been saved.' => 'Deze pagina werd opgeslagen',
	'This post was classified as spam.' => 'Dit bericht werd geclassificeerd als spam.',
	'This post was held for review, due to spam filtering.' => 'Dit bericht werd in de moderatiewachtrij geplaatst door de spamfilter.',
	'View Entry' => 'Bericht bekijken',
	'View Page' => 'Pagina bekijken',
	'View Previously Sent TrackBacks' => 'Eerder verzonden TrackBacks bekijken',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Waarschuwing: de basisnaam van het bericht met de hand aanpassen kan een conflict met een ander bericht veroorzaken.',
	'You have successfully deleted the checked TrackBack(s).' => 'U heeft de geselecteerde TrackBack(s) met succes verwijderd.',
	'You have successfully deleted the checked comment(s).' => 'Verwijdering van de geselecteerde reactie(s) is geslaagd.',
	'You have successfully recovered your saved entry.' => 'Veiligheidskopie van opgeslagen bericht met succes teruggehaald.',
	'You have successfully recovered your saved page.' => 'Veiligheidskopie van opgeslagen pagina met succes teruggehaald.',
	'You have unsaved changes to this entry that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit bericht die verloren zullen gaan.',
	'You must configure this site before you can publish this entry.' => '', # Translate - New
	'You must configure this site before you can publish this page.' => '', # Translate - New
	'Your changes to the comment have been saved.' => 'Uw wijzigingen aan de reactie zijn opgeslagen.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Uw voorkeuren zijn opgeslagen en het formulier hieronder is aangepast.',
	'Your notification has been sent.' => 'Uw notificatie is verzonden.',
	'[_1] Assets' => '[_1] mediabestanden',
	'_USAGE_VIEW_LOG' => 'Controleer het <a href=\"[_1]\">Activiteitenlog</a> op deze fout.',
	'edit' => 'bewerken',
	q{(comma-delimited list)} => q{(lijst gescheiden met komma's)},
	q{(delimited by '[_1]')} => q{(gescheiden door '[_1]')},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Waarschuwing: de basisnaam van het bericht aanpassen kan inkomende links breken.},

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Deze [_1] opslaan (s)',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Map bewerken',
	'Manage Folders' => 'Mappen beheren',
	'Path' => 'Pad',
	'Save changes to this folder (s)' => 'Wijzigingen aan deze map opslaan (s)',
	'You must specify a label for the folder.' => 'U moet een naam opgeven voor de map',
	q{Manage pages in this folder} => q{Pagina's in deze map beheren},

## tmpl/cms/edit_group.tmpl
	'Created By' => 'Aangemaakt door',
	'Created On' => 'Aangemaakt',
	'Edit Group' => 'Groep bewerken',
	'LDAP Group ID' => 'LDAP Group ID',
	'Member ([_1])' => 'Lid ([_1])',
	'Members ([_1])' => 'Leden ([_1])',
	'Permission ([_1])' => 'Permissie ([_1])',
	'Permissions ([_1])' => 'Permissies ([_1])',
	'Save changes to this field (s)' => 'De wijzigingen aan dit veld opslaan (s)',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'Status van deze groep in het systeem.  Een groep deactiveren ontzegt de leden ervan toegang tot het systeem maar behoudt hun inhoud en geschiedenis.',
	'The LDAP directory ID for this group.' => 'Het LDAP directory ID van deze groep',
	'The description for this group.' => 'De beschrijving van deze groep.',
	'The display name for this group.' => 'De getoonde naam van deze groep.',
	'The name used for identifying this group.' => 'De naam gebruikt om deze groep mee aan te duiden.',
	'This group profile has been updated.' => 'Dit groepsprofiel werd bijgewerkt.',
	'This group was classified as disabled.' => 'Deze groep werd geclassificeerd als gedeactiveerd.',
	'This group was classified as pending.' => 'Deze groep werd geclassificeerd als in aanvraag.',

## tmpl/cms/edit_ping.tmpl
	'Category no longer exists' => 'Categorie bestaat niet meer',
	'Delete this TrackBack (x)' => 'Deze TrackBack verwijderen (x)',
	'Edit Trackback' => 'TrackBack bewerken',
	'Entry no longer exists' => 'Bericht bestaat niet meer',
	'Manage TrackBacks' => 'TrackBacks beheren',
	'No title' => 'Geen titel',
	'Save changes to this TrackBack (s)' => 'Wijzigingen aan deze TrackBack opslaan (s)',
	'Search for other TrackBacks from this site' => 'Andere TrackBacks van deze site zoeken',
	'Search for other TrackBacks with this status' => 'Andere TrackBacks met deze status zoeken',
	'Search for other TrackBacks with this title' => 'Andere TrackBacks met deze titel zoeken',
	'Source Site' => 'Bronsite',
	'Source Title' => 'Brontitel',
	'Target Category' => 'Doelcategorie',
	'Target [_1]' => 'Doel [_1]',
	'The TrackBack has been approved.' => 'De TrackBack is goedgekeurd.',
	'This trackback was classified as spam.' => 'Deze TrackBack werd geclassificeerd als spam.',
	'TrackBack Text' => 'TrackBack-tekst',
	'View all TrackBacks created on this day' => 'Bekijk alle TrackBacks aangemaakt op deze dag',
	'View all TrackBacks from this IP address' => 'Alle TrackBacks van dit IP adres bekijken',
	'View all TrackBacks on this category' => 'Alle TrackBacks op deze categorie bekijken',
	'View all TrackBacks on this entry' => 'Alle TrackBacks op dit bericht bekijken',
	'View all TrackBacks with this status' => 'Alle TrackBacks met deze status bekijken',

## tmpl/cms/edit_role.tmpl
	'Administration' => 'Administratie',
	'Association (1)' => 'Associatie (1)',
	'Associations ([_1])' => 'Associaties ([_1])',
	'Authoring and Publishing' => 'Schrijven en publiceren',
	'Check All' => '', # Translate - New
	'Commenting' => 'Reageren',
	'Content Field Privileges' => '', # Translate - New
	'Content Type Privileges' => 'Privileges inhoudstypes',
	'Designing' => 'Ontwerpen',
	'Duplicate Roles' => 'Dubbele rollen',
	'Edit Role' => 'Rol bewerken',
	'Privileges' => 'Privileges',
	'Role Details' => 'Rol details',
	'Save changes to this role (s)' => 'Wijzigingen aan deze rol opslaan (s)',
	'Uncheck All' => '', # Translate - New
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'U heeft de rechten van deze rol aangepast.  Hierdoor is gewijzigd wat gebruikers kunnen doen die met deze rol zijn geassocieerd.  Als u dat verkiest, kunt u deze rol ook opslaan met een andere naam.  In het andere geval moet u er zich van bewust zijn welke wijzigingen er gebeuren bij gebruikers met deze rol.',

## tmpl/cms/edit_template.tmpl
	': every ' => ': elke ',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publiceer</a> dit sjabloon.',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen verise van deze [_1] werd automatisch opgeslagen [_3]. <a href="[_2]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'An error occurred while trying to recover your saved [_1].' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen [_1]',
	'Archive map has been successfully updated.' => 'Archiefkoppelingen zijn met succes bijgewerkt.',
	'Are you sure you want to remove this template map?' => 'Bent u zeker dat u deze sjabloonmapping wenst te verwijderen?',
	'Category Field' => 'Categorieveld',
	'Code Highlight' => 'Gemarkeerde code',
	'Content field' => 'Inhoudsveld',
	'Copy Unique ID' => 'Copiëer uniek ID',
	'Create Archive Mapping' => 'Nieuwe archiefkoppeling aanmaken',
	'Create Content Type Archive Template' => 'Inhoudstypearchiefsjabloon aanmaken',
	'Create Content Type Listing Archive Template' => 'Inhoudstypelijstarchiefsjabloon aanmaken',
	'Create Entry Archive Template' => 'Berichtenarchiefsjabloon aanmaken',
	'Create Entry Listing Archive Template' => 'Berichtenlijstarchiefsjabloon aanmaken',
	'Create Index Template' => 'Indexsjabloon aanmaken',
	'Create Page Archive Template' => 'Pagina-archiefsjabloon aanmaken',
	'Create Template Module' => 'Sjabloonmodule aanmaken',
	'Create a new Content Type?' => 'Nieuw inhoudstype aanmaken?',
	'Custom Index Template' => 'Gepersonaliseerd indexsjabloon',
	'Date & Time Field' => 'Datum & -tijdveld',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Uitgeschakeld (<a href="[_1]">publicatie-instellingen aanpassen</a>)',
	'Do Not Publish' => 'Niet publiceren',
	'Dynamically' => 'Dynamisch',
	'Edit Widget' => 'Widget bewerken',
	'Error occurred while updating archive maps.' => 'Er deed zich teen fout voor bij het bijwerken van de archiefkoppelingen.',
	'Expire after' => 'Verloopt na',
	'Expire upon creation or modification of:' => 'Verloop bij het aanmaken of aanpassen van:',
	'Include cache path' => 'Cachepad voor includes',
	'Included Templates' => 'Geïncludeerde sjablonen',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Meer lezen over <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publicatie-instellingen</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => 'Meer leren over <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Padspecificaties voor archiefbestand</a>',
	'Link to File' => 'Koppelen aan bestand',
	'List [_1] templates' => 'Toon [_1] sjablonen',
	'List all templates' => 'Alle sjablonen tonen',
	'Manually' => 'Handmatig',
	'Module Body' => 'Moduletekst',
	'Module Option Settings' => 'Instellingen opties module',
	'New Template' => 'Nieuwe sjabloon',
	'No caching' => 'Geen caching',
	'No revision(s) associated with this template' => 'Geen revisie(s) geassocieerd met dit sjabloon',
	'On a schedule' => 'Gepland',
	'Process as <strong>[_1]</strong> include' => 'Behandel als <strong>[_1]</strong> include',
	'Processing request...' => 'Verzoek verwerken...',
	'Restored revision (Date:[_1]).' => 'Revisie teruggezet (Datum:[_1]).',
	'Save &amp; Publish' => 'Opslaan &amp; publiceren',
	'Save Changes (s)' => 'Wijzigingen opslaan (s)',
	'Save and Publish this template (r)' => 'Dit sjabloon opslaan en publiceren (r)',
	'Select Content Field' => 'Selecteer inhoudsveld',
	'Server Side Include' => 'Server Side Include',
	'Statically (default)' => 'Statisch (standaard)',
	'Template Body' => 'Sjabloontekst',
	'Template Type' => 'Sjabloontype',
	'Useful Links' => 'Nuttige links',
	'Via Publish Queue' => 'Via publicatiewachtrij',
	'View Published Template' => 'Gepubliceerd sjabloon bekijken',
	'View revisions of this template' => 'Revisies bekijken van dit sjabloon',
	'You have successfully recovered your saved [_1].' => '[_1] met succes teruggehaald.',
	'You have unsaved changes to this template that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit sjabloon die verloren zullen gaan.',
	'You must select the Content Type.' => 'U moet het inhoudstype selecteren.',
	'You must set the Template Name.' => 'U moet de naam van het sjabloon instellen',
	'You must set the template Output File.' => 'U moet het uitvoerbestand van het sjabloon instellen.',
	'Your [_1] has been published.' => 'Uw [_1] is opnieuw gepubliceerd.',
	'create' => 'aanmaken',
	'hours' => 'uren',
	'minutes' => 'minuten',

## tmpl/cms/edit_website.tmpl
	'Create Site (s)' => 'Site aanmaken (s)',
	'Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Geef de URL op van uw site.  Laat de bestandsnaam vallen (b.v. index.html).  Voorbeeld: http://www.voorbeeld.com',
	'Name your site. The site name can be changed at any time.' => 'Geef uw site een naam.  De naam van de site kan op elk moment worden veranderd.',
	'Please enter a valid URL.' => 'Gelieve een geldige URL in te vullen.',
	'Please enter a valid site path.' => 'Gelieve een geldig sitepad in te vullen.',
	'Select the theme you wish to use for this site.' => 'Selecteer het thema dat u wenst te gebruiken voor deze site.',
	'This field is required.' => 'Dit veld is verplicht',
	'You did not select a timezone.' => 'U hebt geen tijdzone geselecteerd.',
	'Your site configuration has been saved.' => 'De instellingen van uw site zijn opgeslagen.',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Vul het pad in waar uw hoofdindexbestand zich zal bevinden.  Een absoluut pad (beginnend met '/' voor Linux of 'C:\' voor Windows) verdient de voorkeur, maar u kunt ook een pad gebruiker relatief aan de Movable Type map.  Voorbeeld: /home/melody/public_html/ of C:\www\public_html},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => 'Beschikbare widgets',
	'Edit Widget Set' => 'Widgetset bewerken',
	'Installed Widgets' => 'Geïnstalleerde widgets',
	'Save changes to this widget set (s)' => 'Wijzignen aan deze widgetset opslaan (s)',
	'Widget Set Name' => 'Naam widgetset',
	'You must set Widget Set Name.' => 'U moet een naam instellen voor de widgetset.',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Klik en sleep de widgets die in deze widgetset horen in de kolom 'Geïnstalleerde widgets'.},

## tmpl/cms/error.tmpl
	'An error occurred' => 'Er deed zich een probleem voor',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exporteer [_1] berichten',
	'Export [_1]' => 'Exporteer [_1]',
	'[_1] to Export' => '[_1] te exporteren',
	'_USAGE_EXPORT_1' => 'Exporteer de berichten, reacties en TrackBacks van een blog.  Een export kan niet beschouwd worden als een <em>volledige</em> backup van een blog.',

## tmpl/cms/export_theme.tmpl
	'Author link' => 'Link auteur',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'De basisnaam mag enkel letters, cijfers, mintekens en underscores bevatten.  De basisnaam moet met een letter beginnen.',
	'Destination' => 'Bestemming',
	'Setting for [_1]' => 'Instelling voor [_1]',
	'Theme package have been saved.' => 'Themapakket werd opgeslagen.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Themaversie mag enkel letters, cijfers, mintekens en underscores bevatten.',
	'Version' => 'Versie',
	'You must set Theme Name.' => 'U moet de naam van het thema instellen.',
	'_THEME_AUTHOR' => 'Maker',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Kan geen nieuw thema installeren met bestaande (en beschermde) basisnaam van thema.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Gebruik enkel letters, cijfers, streepjes of underscores (a-z, A-Z, 0-9, '-' of '_').},

## tmpl/cms/field_html/field_html_asset.tmpl
	'Assets greater than or equal to [_1] must be selected' => 'Een aantal mediabestanden groter dan of gelijk aan [_1] moet worden geselecteerd',
	'Assets less than or equal to [_1] must be selected' => 'Een aantal mediabestanden kleiner dan of gelijk aan [_1] moet worden geselecteerd',
	'No Asset' => 'Geen mediabestand',
	'No Assets' => 'Geen mediabestanden',
	'Only 1 asset can be selected' => 'Slechts één mediabestand kan worden geselecteerd',

## tmpl/cms/field_html/field_html_categories.tmpl
	'Add sub category' => 'Subcategorie toevoegen',
	'This field is disabled because valid Category Set is not selected in this field.' => 'Dit veld is uitgeschakeld omdat er geen geldige categorieset werd geselecteerd in dit veld.',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No [_1]' => 'Geen [_1]',
	'No field data.' => 'Geen veldgegevens.',
	'Only 1 [_1] can be selected' => 'Slechts één [_1] kan worden geselecteerd',
	'This field is disabled because valid Content Type is not selected in this field.' => 'Dit veld is uitgeschakeld omdat er geen geldig inhoudstype werd geselecteerd in dit veld.',
	'[_1] greater than or equal to [_2] must be selected' => '[_1] groter dan of gelijk aan [_2] moet worden geselecteerd',
	'[_1] less than or equal to [_2] must be selected' => '[_1] kleiner dan of gelijk aan [_2] moet worden geselecteerd',

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'Niet geselecteerd',

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
	'Apply this formatting if text format is not set on each entry.' => 'Pas deze tekstformattering toe indien het tekstformaat niet is ingesteld op een bericht.',
	'Default category for entries (optional)' => 'Standaardcategorie voor berichten (optioneel)',
	'Default password for new users:' => 'Standaard wachtwoord voor nieuwe gebruikers:',
	'Enter a default password for new users.' => 'Vul een standaardwachtwoord in voor nieuwe gebruikers.',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Als u ervoor kiest om het eigenaarschap van de geïmporteerde berichten te bewaren en als één of meer van die gebruikers nog moeten aangemaakt worden in deze installatie, moet u een standaard wachtwoord opgeven voor die nieuwe accounts.',
	'Import Entries (s)' => 'Berichten importeren (s)',
	'Import Entries' => 'Berichten importeren',
	'Import File Encoding' => 'Encodering importbestand',
	'Import [_1] Entries' => 'Importeer [_1] berichten',
	'Import as me' => 'Importeer als mezelf',
	'Importing from' => 'Aan het importeren uit',
	'Ownership of imported entries' => 'Eigenaarschap van geïmporteerde berichten',
	'Preserve original user' => 'Oorspronkelijke gebruiker bewaren',
	'Select a category' => 'Categorie selecteren',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Berichten overzetten naar Movable Type vanuit andere Movable Type installatie of zelfs andere blogsoftware of berichten exporteren om een backup of kopie te maken.',
	'Upload import file (optional)' => 'Importbestand opladen (optioneel)',
	'You must select a site to import.' => 'U moet een site kiezen om te importeren.',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'U zal eigenaar worden van alle geïmporteerde berichten.  Als u wenst dat de oorspronkelijke gebruiker eigenaar blijft, moet u uw MT systeembeheerder contacteren om de import te doen zodat nieuwe gebruikers aangemaakt kunnen worden indien nodig.',

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => 'Standaardstatus berichten (optioneel)',
	'End title HTML (optional)' => 'Eind-HTML titel (optioneel-',
	'Select an entry status' => 'Selecteer een berichtstatus',
	'Start title HTML (optional)' => 'Start-HTML titel (optioneel)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Reacties toestaan van anonieme of niet aangemelde gebruikers.',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Indien ingeschakeld moeten bezoekers een geldig e-mail adres opgeven wanneer ze reageren.',
	'Require name and E-mail Address for Anonymous Comments' => 'E-mail adres vereisen voor anonieme reacties',

## tmpl/cms/include/archetype_editor.tmpl
	'Begin Blockquote' => 'Begin citaat',
	'Bold' => 'Vet',
	'Bulleted List' => 'Ongeordende lijst',
	'Center Item' => 'Centreer item',
	'Center Text' => 'Tekst centreren',
	'Check Spelling' => 'Spelling nakijken',
	'Decrease Text Size' => 'Kleiner tekstformaat',
	'Email Link' => 'E-mail link',
	'End Blockquote' => 'Einde citaat',
	'HTML Mode' => 'HTML modus',
	'Increase Text Size' => 'Groter tekstformaat',
	'Insert File' => 'Bestand invoegen',
	'Insert Image' => 'Afbeelding invoegen',
	'Italic' => 'Cursief',
	'Left Align Item' => 'Item links uitlijnen',
	'Left Align Text' => 'Tekst links uitlijnen',
	'Numbered List' => 'Genummerde lijst',
	'Right Align Item' => 'Item rechts uitlijnen',
	'Right Align Text' => 'Tekst rechts uitlijnen',
	'Text Color' => 'Tekstkleur',
	'Underline' => 'Onderstrepen',
	'WYSIWYG Mode' => 'WYSIWYG modus',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Inklappen',
	'Preferred' => '', # Translate - New

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'Nee',
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Er bestaat reeds een bestand net de naam '[_1]'. Wilt u dit bestand overschrijven?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'Ontbrekend mediabestand',
	'Delete selected assets (x)' => 'Geselecteerde media verwijderen (x)',
	'No thumbnail image' => 'Geen thumbnail',
	'Size' => 'Grootte',

## tmpl/cms/include/asset_upload.tmpl
	'Choose Folder' => 'Kies map',
	'Select File to Upload' => 'Selecteer bestand om te uploaden',
	'Upload (s)' => 'Opladen (s)',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Uw systeem of [_1] beheerder moet de [_1] publiceren voor u bestanden kunt uploaden.  Gelieve de beheerder van uw systeem of [_1] te contacteren.',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] bevat een karakter dat niet geldig is wanneer het gebruikt word in de naam van een map: [_2]',
	'_USAGE_UPLOAD' => 'U kunt het bestand opladen naar een submap van het geselecteerde pad.  De submap zal worden aangemaakt als die nog niet bestaat.',
	q{Asset file('[_1]') has been uploaded.} => q{Mediabestand ('[_1]') geupload.},
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Voor u een bestand kunt uploaden, moet u eerst uw [_1] publiceren.  [_2]Configureer de publicatiepaden van uw [_1][_3] en herpubliceer uw [_1].},
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Kan niet schrijven naar '[_1]'.  Afbeelding uploaden is mogelijk, maar thumbnail kan niet worden aangemaakt.},

## tmpl/cms/include/async_asset_list.tmpl
	'All Types' => 'Alle types',
	'Asset Type: ' => 'Type mediabestand:',
	'label' => 'naam',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose file to upload or drag file.' => 'Kies bestand om te uploaden of sleep het hierheen',
	'Choose file to upload.' => 'Kies bestand op te uploaden.',
	'Choose files to upload or drag files.' => 'Kies bestanden om te uploaden of sleep ze hierheen',
	'Choose files to upload.' => 'Kies bestanden om te uploaden.',
	'Drag and drop here' => 'Klik en sleep hierheen',
	'Operation for a file exists' => 'Actie als een bestand al bestaat',
	'Upload Options' => 'Upload opties',
	'Upload Settings' => 'Instellingen voor uploaden',

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => 'Geselecteerde gebruikers desactiveren (D)',
	'Enable selected users (e)' => 'Geselecteerde gebruikers activeren (E)',
	'_NO_SUPERUSER_DISABLE' => 'Omdat u een systeembeheerder bent in het Movable Type systeem, kunt u zichzelf niet desactiveren.',
	'_USER_DISABLE' => 'Desactiveren',
	'_USER_ENABLE' => 'Activeren',
	'user' => 'gebruiker',
	'users' => 'gebruikers',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => 'Alle gegevens met succes geëxporteerd!',
	'An error occurred during the export process: [_1]' => 'Er deed zich een fout voor tijdens het exportproces: [_1]',
	'Download This File' => 'Dit bestand downloaden',
	'Download: [_1]' => 'Download: [_1]',
	'Export Files' => 'Exportbestanden',
	'_BACKUP_TEMPDIR_WARNING' => 'Gevraagde gegevens zijn met succes gebackupt in de map [_1].  Gelieve bovenstaande bestanden te downloaden en vervolgens <strong>onmiddellijk te verwijderen</strong> uit [_1] omdat backupbestanden vertrouwelijke informatie bevatten.',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{Het downloaden van het backup-bestand zal over een paar seconden automatisch beginnen.  Als dit niet het geval is om wat voor reden dan ook, klik dan <a href='#' onclick='submit_form()'>hier</a> om de download met de hand in gang te zetten.  Merk op dat u het backupbestand slechts één keer kunt downloaden gedurende een sessie.},

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Movable Type exporteren',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'[_1] and [_2]' => '[_1] en [_2]',
	'[_1] hours' => '[_1] uren',
	'_FILTER_DATE_DAYS' => '[_1] dagen',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'__INTEGER_FILTER_EQUAL' => 'is gelijk aan',
	'__INTEGER_FILTER_NOT_EQUAL' => 'is niet gelijk aan',
	'__STRING_FILTER_EQUAL' => 'is gelijk aan',
	'__TIME_FILTER_HOURS' => 'valt binnen de laatste',
	'contains' => 'bevat',
	'does not contain' => 'bevat niet',
	'ends with' => 'eindigt op',
	'is after now' => 'valt in de toekomst',
	'is after' => 'valt na',
	'is before now' => 'valt in het verleden',
	'is before' => 'valt voor',
	'is between' => 'is tussen',
	'is blank' => 'is blanco',
	'is greater than or equal to' => 'is groter dan of gelijk aan',
	'is greater than' => 'is groter dan',
	'is less than or equal to' => 'is minder dan of gelijk aan',
	'is less than' => 'is minder dan',
	'is not blank' => 'is niet blanco',
	'is within the last' => 'valt binnen de laatste',
	'starts with' => 'begint met',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => 'Geselecteerde [_1] verwijderen (x)',
	'Some sites were not deleted. You need to delete child sites under the site first.' => 'Sommige sites werden niet verwijderd.  U moet de subsites onder de site eerst verwijderen.',
	'Some templates were not refreshed.' => 'Sommige sjablonen werden niet ververst.',
	'[_1] Name' => 'Naam [_1]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'Submap toevoegen',

## tmpl/cms/include/comment_table.tmpl
	'([quant,_1,reply,replies])' => '([quant,_1,antwoord,antwoorden])',
	'Blocked' => 'Geblokkeerd',
	'Delete selected comments (x)' => 'Geselecteerde reacties verwijderen (x)',
	'Edit this [_1] commenter' => '[_1] reageerder bewerken',
	'Edit this comment' => 'Deze reactie bewerken',
	'Publish selected comments (a)' => 'Geselecteerde reacties publiceren (a)',
	'Search for all comments from this IP address' => 'Zoek naar alle reacties van dit IP adres',
	'Search for comments by this commenter' => 'Zoek naar reacties door deze reageerder',
	'View this entry' => 'Dit bericht bekijken',
	'View this page' => 'Deze pagina bekijken',
	'to republish' => 'om opnieuw te publiceren',

## tmpl/cms/include/commenter_table.tmpl
	'Edit this commenter' => 'Deze reageerder bewerken',
	'Last Commented' => 'Laatste reactie',
	'View this commenter&rsquo;s profile' => 'Bekijk het profiel van deze reageerder',

## tmpl/cms/include/content_data_table.tmpl
	'Created' => 'Aangemaakt',
	'Republish selected [_1] (r)' => 'Geselecteerde [_1] opnieuw publiceren (r)',
	'Unpublish' => 'Publicatie ongedaan maken',
	'View Content Data' => 'Inhoudsgegevens bekijken',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Alle rechten voorbehouden.',

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => 'Nu <a href="[_1]" class="alert-link">een bericht aanmaken</a>.',
	'Last Modified' => 'Laatst aangepast',
	'No entries could be found.' => 'Geen berichten gevonden.',
	'View entry' => 'Bericht bekijken',
	'View page' => 'Pagina bekijken',
	q{No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.} => q{Er werden geen pagina's gevonden. Nu <a href="[_1]" class="alert-link">een pagina aanmaken</a>.},

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Webservices wachtwoord instellen',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'BETA' => 'BETA',
	'DEVELOPER PREVIEW' => 'DEVELOPER PREVIEW',
	'Forums' => 'Forums',
	'MovableType.org' => 'MovableType.org',
	'Send Us Feedback' => 'Stuur ons feedback',
	'Support' => 'Ondersteuning',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Dit is een alfaversie van Movable Type die niet wordt aangeraden voor gebruik in productie.',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Dit is een betaversie van Movable Type, niet aangeraden voor productiegebruik.',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org',
	'https://www.movabletype.org' => 'https://www.movabletype.org',
	'with' => 'met',

## tmpl/cms/include/group_table.tmpl
	'Disable selected group (d)' => 'De geselecteerde groep deactiveren (d)',
	'Enable selected group (e)' => 'De geselecteerde groep activeren (e)',
	'Remove selected group (d)' => 'De geselecteerde groep verwijderen (d)',
	'group' => 'groep',
	'groups' => 'groepen',

## tmpl/cms/include/header.tmpl
	'Help' => 'Hulp',
	'Search (q)' => 'Zoeken (q)',
	'Search [_1]' => 'Doorzoek [_1]',
	'Select an action' => 'Selecteer een actie',
	'from Revision History' => 'Revisiegeschiedenis',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Deze website werd aangemaakt tijdens de upgrade van een vorige versie van Movable Type.  'Site Root' en 'Site URL' werden met opzet leeg gelaten om 'Publicatiepaden' compatibiliteit te behouden voor blogs die aangemaakt werden in de vorige versie.  U kunt berichten plaatsen en publiceren op de bestaande blogs, maar u kunt deze website zelf niet publiceren omwille van de blanco 'Site Root' en 'Site URL'.},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publiceer uw site</a> om de wijzigingen zichtbaar te maken.',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => 'Nieuwe gebruikers worden aangemaakt voor elke gebruiker gevonden in de [_1]',
	'Importing entries into [_1]' => 'Berichten worden geïmporteerd in de [_1]',
	q{Importing entries as user '[_1]'} => q{Berichten worden geïmporteerd als gebruiker '[_1]'},

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Ga',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => 'Ga naar [_1]',
	'Sorry, there is no data for this object set.' => 'Sorry, er zijn geen gegevens ingesteld voor dit object.',
	'Sorry, there were no results for your search. Please try searching again.' => 'Sorry, er waren geen resultaten voor uw zoekopdracht. Probeer opnieuw te zoeken.',
	'Step [_1] of [_2]' => 'Stap [_1] van [_2]',

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP: [_1]',
	'No log records could be found.' => 'Er konden geen logberichten worden gevonden.',
	'_LOG_TABLE_BY' => 'Door',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Mij onthouden?',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Bent u zeker dat u de [_1] geselecteerde gebruikers wenst te verwijderen van deze [_2]?',
	'Are you sure you want to remove the selected user from this [_1]?' => 'Bent u zeker dat u de geselecteerde gebruiker wenst te verwijderen van deze [_1]?',
	'Remove selected user(s) (r)' => 'Geselecteerde gebruiker(s) verwijderen (r)',
	'Remove this role' => 'Verwijder deze rol',

## tmpl/cms/include/mobile_global_menu.tmpl
	'PC View' => 'PC uitzicht',
	'Select another child site...' => 'Selecteer een andere subsite...',
	'Select another site...' => 'Selecteer een andere site...',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Toegevoegd',
	'Save changes' => 'Wijzigingen opslaan',

## tmpl/cms/include/old_footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versie [_2]',
	'Wiki' => 'Wiki',
	'Your Dashboard' => 'Uw dashboard',
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	q{_LOCALE_CALENDAR_HEADER_} => q{'Z', 'M', 'D', 'W', 'D', 'V', 'Z'},

## tmpl/cms/include/pagination.tmpl
	'First' => 'Eerste',
	'Last' => 'Laatste',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'Deze TrackBack bewerken',
	'From' => 'Van',
	'Go to the source entry of this TrackBack' => 'Ga naar het bronbericht van deze TrackBack',
	'Moderated' => 'Gemodereerd',
	'Publish selected [_1] (p)' => 'Geselecteerde [_1] publiceren (p)',
	'Target' => 'Doel',
	'View the [_1] for this TrackBack' => 'De [_1] bekijken voor deze TrackBack',

## tmpl/cms/include/primary_navigation.tmpl
	'Close Site Menu' => 'Site menu sluiten',
	'Open Panel' => 'Paneel openen',
	'Open Site Menu' => 'Site menu openen',

## tmpl/cms/include/revision_table.tmpl
	'*Deleted due to data breakage*' => '*Verwijderd wegens gegevensbreuk*',
	'No revisions could be found.' => 'Geen revisies gevonden.',
	'Note' => 'Noot',
	'Saved By' => 'Opgeslagen door',
	'_REVISION_DATE_' => 'Datum',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz boodschap',

## tmpl/cms/include/scope_selector.tmpl
	'(on [_1])' => '(op [_1])',
	'Create Blog (on [_1])' => 'Blog aanmaken (op [_1])',
	'Create Website' => 'Website aanmaken',
	'Select another blog...' => 'Selecteer een andere blog...',
	'Select another website...' => 'Selecteer een andere website...',
	'User Dashboard' => 'Dashboard gebruiker',
	'Websites' => 'Websites',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Edited by [_2]' => '[_1] - bewerkt door [_2]',
	'[_1] - Published by [_2]' => '[_1] - gepubliceerd door [_2]',

## tmpl/cms/include/template_table.tmpl
	'Archive Path' => 'Archiefpad',
	'Cached' => 'Gecached',
	'Create Archive Template:' => 'Archiefsjabloon aanmaken:',
	'Dynamic' => 'Dynamisch',
	'Manual' => 'Handmatig',
	'No content type could be found.' => 'Er werd geen inhoudstype gevonden.',
	'Publish Queue' => 'Publicatiewachtrij',
	'Publish selected templates (a)' => 'Geselecteerde sjablonen publiceren (a)',
	'SSI' => 'SSI',
	'Static' => 'Statisch',
	'Uncached' => 'Zonder cache',
	'templates' => 'sjablonen',
	'to publish' => 'om te publiceren',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>',
	'Folder Name' => 'Naam map',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'In de opgegeven mappen zullen bestanden van volgende types opgenomen worden in het thema [_1].  Andere bestanden zullen worden genegeerd.',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Som mappen op (één per regel) onder de Site Root map die de statische bestanden zullen bevatten die opgenomen moeten worden in het thema.  Vaak gebruikte mappen zijn: css, images, js, etc.',
	'Specify directories' => 'Mappen opgeven',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] zijn opgenomen',
	'modules' => 'modules',
	'widget sets' => 'Widgetsets',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'Maak uw account aan',
	'Do you want to proceed with the installation anyway?' => 'Wenst u toch door te gaan met de installatie?',
	'Finish install (s)' => 'Installatie afronden (s)',
	'Finish install' => 'Installatie afronden',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Gelieve een administrator account aan te maken voor uw systeem.  Zodra dit gebeurd is, zal Movable Type de database initialiseren.',
	'Select a password for your account.' => 'Kies een wachtwoord voor uw account.',
	'System Email' => 'Systeem e-mail',
	'The display name is required.' => 'Getoonde naam is vereist.',
	'The e-mail address is required.' => 'Het e-mail adres is vereist.',
	'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'De versie van Perl die op uw server is geïnstalleerd ([_1]) is lager dan de ondersteunde minimale versie ([_2]).',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Om verder te gaan moet u zich aanmelden bij uw LDAP server.',
	'Use this as system email address' => 'Dit ook als systeem e-mail adres gebruiken',
	'View MT-Check (x)' => 'Bekijk MT-Check (x)',
	'Welcome to Movable Type' => 'Welkom bij Movable Type',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Hoewel Movable Type er misschien op draait, is het een <strong>ongetesten en niet ondersteunde omgeving</strong>.  We raden ten zeerste aan om minstens te upgraden tot Perl [_1].',

## tmpl/cms/layout/dashboard.tmpl
	'Reload' => 'Herladen',
	'reload' => 'herladen',

## tmpl/cms/list_category.tmpl
	'Add child [_1]' => 'Kind toevoegen [_1]',
	'Alert' => 'Alarm',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => 'Bent u zeker dat u [_1] [_2] met [_3] sub [_4] wenst te verwijderen?',
	'Are you sure you want to remove [_1] [_2]?' => 'Bent u zeker dat u [_1] [_2] wenst te verwijderen?',
	'Basename is required.' => 'Basisnaam is verplicht.',
	'Change and move' => 'Wijzig en verplaats',
	'Duplicated basename on this level.' => 'Dubbel gebruik van basisnaam op dit niveau.',
	'Duplicated label on this level.' => 'Dubbel gebruik van een label op dit niveau.',
	'Invalid Basename.' => 'Ongeldige basisnaam.',
	'Label is required.' => 'Label is verplicht',
	'Label is too long.' => 'Label is te lang',
	'Remove [_1]' => 'Verwijder [_1]',
	'Rename' => 'Naam wijzigen',
	'Top Level' => 'Topniveau',
	'[_1] label' => '[_1] label',
	q{[_1] '[_2]' already exists.} => q{[_1] '[_2]' bestaat al.},

## tmpl/cms/list_common.tmpl
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Feed' => 'Feed',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Berichtenfeed',
	'Quickfilters' => 'Snelfilters',
	'Recent Users...' => 'Recente gebruikers...',
	'Remove filter' => 'Filter verwijderen',
	'Select A User:' => 'Selecteer een gebruiker:',
	'Select...' => 'Selecteer...',
	'Show only entries where' => 'Toon enkel berichten waar',
	'Showing only: [_1]' => 'Enkel: [_1]',
	'The entry has been deleted from the database.' => 'Dit bericht werd verwijderd uit de database',
	'The page has been deleted from the database.' => 'Deze pagina werd verwijderd uit de database',
	'User Search...' => 'Zoeken naar gebruiker...',
	'[_1] (Disabled)' => '[_1] (Uitgeschakeld)',
	'[_1] where [_2] is [_3]' => '[_1] waar [_2] gelijk is aan [_3]',
	'asset' => 'mediabestand',
	'change' => 'wijzig',
	'is' => 'gelijk is aan',
	'published' => 'gepubliceerd',
	'review' => 'na te kijken',
	'scheduled' => 'gepland',
	'spam' => 'spam',
	'status' => 'status',
	'tag (exact match)' => 'tag (exacte overeenkomst)',
	'tag (fuzzy match)' => 'tag (fuzzy overeenkomst)',
	'unpublished' => 'ongepubliceerd',
	q{Pages Feed} => q{Feed pagina's},
	q{Show only pages where} => q{Toon enkel pagina's waar},

## tmpl/cms/list_template.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Naam van de widgetset&quot;$&gt;</strong>',
	'Content Type Listing Archive' => 'Inhoudstypelijstarchief',
	'Content type Templates' => 'Inhoudstypesjablonen',
	'Create new template (c)' => 'Nieuw sjabloon aanmaken (c)',
	'Create' => 'aanmaken',
	'Delete selected Widget Sets (x)' => 'Geselecteerde widgetsets verwijderen (x)',
	'Entry Archive' => 'Berichtarchief',
	'Entry Listing Archive' => 'Berichtenlijstarchief',
	'Helpful Tips' => 'Nuttige tips',
	'No widget sets could be found.' => 'Er werden geen widgetsets gevonden.',
	'Page Archive' => 'Pagina-archief',
	'Publishing Settings' => 'Publicatie-instellingen',
	'Select template type' => 'Selecteer sjabloontype',
	'Selected template(s) has been copied.' => 'Geselecteerde sjablo(o)n(en) gekopiëerd.',
	'Show All Templates' => 'Alle sjablonen tonen',
	'Template Module' => 'Sjabloonmodule',
	'To add a widget set to your templates, use the following syntax:' => 'Om een widgetset aan uw sjablonen toe te voegen, gebruikt u volgende syntax:',
	'You have successfully deleted the checked template(s).' => 'Verwijdering van geselecteerde sjabloon/sjablonen is geslaagd.',
	'You have successfully refreshed your templates.' => 'U heeft met succes uw sjablonen ververst.',
	'Your templates have been published.' => 'Uw sjablonen werden gepubliceerd.',

## tmpl/cms/list_theme.tmpl
	'Author: ' => 'Auteur:',
	'Current Theme' => 'Huidig thema',
	'Errors' => 'Fouten',
	'Failed' => 'Mislukt',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Delen van dit thema kunnen niet worden toegepast op de subsite. [_1] zullen worden overgeslagen.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Delen van dit thema kunnen niet worden toegepast op de site. [_1] zullen worden overgeslagen.',
	'Reapply' => 'Opnieuw toepassen',
	'Theme Errors' => 'Thema fouten',
	'Theme Information' => 'Thema informatie',
	'Theme Warnings' => 'Thema waarschuwingen',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] werd toegepast (<a href="[_2]" class="alert-link">[quant,_3,waarschuwing,waarschuwingen]</a>).',
	'Theme [_1] has been applied.' => 'Thema [_1] werd toegepast.',
	'Theme [_1] has been uninstalled.' => 'Thema [_1] werd gedesinstalleerd.',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Dit thema kan niet worden toegepast op de subsite vanwege [_1] fouten',
	'This theme cannot be applied to the site due to [_1] errors' => 'Dit thema kan niet worden toegepast op de site vanwege [_1] fouten',
	'Uninstall' => 'Desinstalleren',
	'Warnings' => 'Waarschuwingen',
	'[quant,_1,warning,warnings]' => '[quant,_1,waarschuwing,waarschuwingen]',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{All Themes} => q{Alle thema's},
	q{Available Themes} => q{Beschikbare thema's},
	q{Find Themes} => q{Thema's zoeken},
	q{No themes are installed.} => q{Geen thema's geïnstalleerd},
	q{Themes in Use} => q{Thema's in gebruik},

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'U heeft met suuces de mediabestand(en) verwijderd.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Kan niet schrijven naar '[_1]'. Thumbnails van items kunnen mogelijk niet worden weergegeven.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully granted the given permission(s).' => 'De gekozen permissie(s) zijn met succes toegekend.',
	'You have successfully revoked the given permission(s).' => 'De gekozen permissie(s) zijn met succes ingetrokken.',

## tmpl/cms/listing/author_list_header.tmpl
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Een aantal ([_1]) van de geselecteerde gebruiker(s) konden niet opniew worden ingeschakeld omdat ze niet meer werden gevonden in de externe directory.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'De verwijderde gebruiker(s) blijven bestaan in de externe directory. Om die reden zullen ze zich nog steeds kunnen aanmelden op Movable Type Advanced.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'U heeft met succes de gebruiker(s) verwijderd uit het Movable Type systeem.',
	'You have successfully disabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes uitgeschakeld.',
	'You have successfully enabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes ingeschakeld.',
	'You have successfully unlocked the selected user(s).' => 'Geselecteerde gebruiker(s) met succes gedeblokkeerd.',
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Er deed zich een fout voor tijdens synchronisatie.  Kijk in het <a href='[_2]' class="alert-link">activiteitenlog</a> voor meer details.},
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Sommige ([_1]) van de geselecteerde gebruiker(s) konden niet opnieuw ingeschakeld worden omdat ze één (of meer) ongeldige parameter hadden. Kijk in het <a href='[_2]' class="alert-link">activiteitenlog</a> voor meer details.},
	q{You have successfully synchronized users' information with the external directory.} => q{U heeft met succes de gebruikersgegevens gesynchroniseerd met de externe directory.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => 'Ongeldig IP adres',
	'The IP you entered is already banned for this site.' => 'Het IP dat u heeft ingevuld is reeds uitgesloten voor deze site.',
	'You have added [_1] to your list of banned IP addresses.' => 'U hebt [_1] toegevoegd aan uw lijst met uitgesloten IP adressen.',
	'You have successfully deleted the selected IP addresses from the list.' => 'U hebt de geselecteerde IP adressen uit de lijst is verwijderd.',

## tmpl/cms/listing/blog_list_header.tmpl
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Waarschuwing: u moet mediabestanden die werden geupload met de hand naar de nieuwe locatie verhuizen.  Overweeg ook om op de oorspronkelijke locatie kopieën te bewaren om zo gebroken links te vermijden.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes deze subsite verwijderd uit het Movable Type systeem.  De bestanden bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als ze niet meer nodig zijn.',
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes deze site verwijderd uit het Movable Type systeem.  De bestanden bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als ze niet meer nodig zijn.',
	'You have successfully moved selected child sites to another site.' => 'U heeft met succes de geselecteerde subsites verplaatst naar een andere site.',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => 'Sommige categoriesets werden niet verwijderd.  U moet eerst de categorievelden verwijderen uit de categorieset.',

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'Alle reaactie die aangemerkt waren als spam zijn verwijderd.',
	'No comments appear to be spam.' => 'Er lijken geen spamreacties te zijn',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Eén of meer reacties die u selecteerde werd ingegeven door een niet geauthenticeerde reageerder. Deze reageerders kunnen niet verbannen of vertrouwd worden.',
	'The selected comment(s) has been approved.' => 'De geselecteerde reactie(s) zijn goedgekeurd.',
	'The selected comment(s) has been deleted from the database.' => 'Geselecteerde reactie(en) zijn uit de database verwijderd.',
	'The selected comment(s) has been recovered from spam.' => 'De geselecteerde reactie(s) zijn teruggehaald uit de spam-map',
	'The selected comment(s) has been reported as spam.' => 'De geselecteerde reactie(s) zijn als spam gerapporteerd.',
	'The selected comment(s) has been unapproved.' => 'De geselecteerde reactie(s) zijn niet langer goedgekeurd.',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'De inhoudsgegevens werden verwijderd uit de database.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'Sommige inhoudstypes werden niet verwijderd.  U moet de archiefsjablonen of inhoudstypevelden eerst verwijderen uit het inhoudstype.',
	'The content type has been deleted from the database.' => 'Het inhoudstype werd verwijderd uit de database.',

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'U verwijderde met succes de groepen uit het Movable Type systeem.',
	'You successfully disabled the selected group(s).' => 'U deactiveerde met succes de geselecteerde groep(en).',
	'You successfully enabled the selected group(s).' => 'U activeerde met succes de geselecteerde groep(en).',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Er deed zich een fout voor tijdens de synchronisatie.  Kijk in het <a href='[_1]'>activiteitenlog</a> voor gedetailleerde informatie.},
	q{You successfully synchronized the groups' information with the external directory.} => q{U synchroniseerde met succes de groepsinformatie met de externe directory.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Sommige ([_1]) van de geselecteerde gebruikers konden niet gereactiveerd worden omdat ze niet langer gevonden worden in LDAP.',
	'You successfully added new users to this group.' => 'U voegde met succes nieuwe gebruikers toe aan deze groep.',
	'You successfully deleted the users.' => 'U verwijderde met succes de gebruikers.',
	'You successfully removed the users from this group.' => 'U verwijderde met succes de gebruikers uit de groep.',
	q{You successfully synchronized users' information with the external directory.} => q{U synchroniseerde met succes informatie over gebruikers met de externe directory.},

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => 'Alle tijdstippen worden getoond in GMT.',
	'All times are displayed in GMT[_1].' => 'Alle tijdstippen worden getoond in GMT[_1].',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added new contact to your address book.' => 'U heeft een nieuw contact aan uw adressenboek toegevoegd.',
	'You have successfully deleted the selected contacts from your address book.' => 'U heeft met succes de geselecteerde contacten verwijderd uit uw adresboek.',
	'You have updated your contact in your address book.' => 'U heeft uw contact in het adressenboek bijgewerkt.',

## tmpl/cms/listing/ping_list_header.tmpl
	'All TrackBacks reported as spam have been removed.' => 'Alle TrackBacks gerapporteerd als spam zijn verwijderd',
	'No TrackBacks appeared to be spam.' => 'Geen enkele TrackBack leek spam te zijn.',
	'The selected TrackBack(s) has been approved.' => 'De geselecteerde TrackBack(s) zijn goedgekeurd',
	'The selected TrackBack(s) has been deleted from the database.' => 'De geselecteerde TrackBack(s) zijn uit de database verwijderd.',
	'The selected TrackBack(s) has been recovered from spam.' => 'De geselecteerde TrackBack(s) zijn teruggehaald uit de spam-map',
	'The selected TrackBack(s) has been reported as spam.' => 'De geselecteerde TrackBack(s) zijn gerapporteerd als spam',
	'The selected TrackBack(s) has been unapproved.' => 'De geselecteerde TrackBack(s) zijn niet langer goedgekeurd',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'De rol(len) zijn met succes verwijderd.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Specify new name of the tag.' => 'Geef een nieuwe naam op voor de tag',
	'You have successfully deleted the selected tags.' => 'U hebt met succes de geselecteerde tags verwijderd.',
	'Your tag changes and additions have been made.' => 'Uw tag-wijzigingen en toevoegingen zijn uitgevoerd.',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all blogs?} => q{De tag '[_2]' bestaat al.  Zeker dat u '[_1]' en '[_2]' wenst samen te voegen over alle blogs?},

## tmpl/cms/login.tmpl
	'Forgot your password?' => 'Uw wachtwoord vergeten?',
	'Sign In (s)' => 'Aanmelden (s)',
	'Sign in' => 'Aanmelden',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Uw Movable Type sessie is beëxndigd.  Als u zich opnieuw wenst aan te melden, dan kan dat hieronder.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Uw Movable Type sessie is beëxndigd. Gelieve u opnieuw aan te melden om deze handeling voort te zetten.',
	'Your Movable Type session has ended.' => 'Uw Movable Type sessie is beëxndigd.',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Nog niet geïmplementeerd.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Bezig met pingen van sites...',
	'Trackback' => 'TrackBack',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'Mislukte TrackBacks',
	'Successful Trackbacks' => 'Gelukte TrackBacks',
	q{To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.} => q{Om opnieuw te proberen: zet deze TrackBacks in het veld voor uitgaande TrackBack URL's van uw bericht.},

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Alle bestanden',
	'Index Template: [_1]' => 'Indexsjabloon: [_1]',
	'Only Indexes' => 'Alleen indexen',
	'Only [_1] Archives' => 'Alleen archieven [_1]',
	'Publish (s)' => 'Publiceer (s)',
	'Publish <em>[_1]</em>' => 'Publiceer <em>[_1]</em>',
	'Publish [_1]' => 'Publiceer [_1]',
	'_REBUILD_PUBLISH' => 'Publiceren',

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => 'Opnieuw pubiceren (s)',
	'Publish Again' => 'Opnieuw publiceren',
	'Publish time: [_1].' => 'Publicatietijd: [_1].',
	'Success' => 'Succes',
	'The files for [_1] have been published.' => 'De bestanden voor [_1] werden gepubliceerd.',
	'View this page.' => 'Deze pagina bekijken.',
	'View your site.' => 'Uw site bekijken.',
	'Your [_1] archives have been published.' => 'Uw [_1] archieven zijn gepubliceerd.',
	'Your [_1] templates have been published.' => 'Uw [_1] sjablonen zijn gepubliceerd.',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Voorbeeld [_1] inhoud bekijken',
	'Re-Edit this [_1] (e)' => 'Deze [_1] opnieuw bewerken (e)',
	'Re-Edit this [_1]' => 'Deze [_1] opnieuw bewerken',
	'Return to the compose screen (e)' => 'Terugkeren naar het opstelscherm (r)',
	'Return to the compose screen' => 'Terugkeren naar het opstelscherm',
	'Save this [_1] (s)' => 'Sla deze [_1] op (s)',

## tmpl/cms/preview_content_data_strip.tmpl
	'Publish this [_1] (s)' => 'Publiceer deze [_1] (s)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'U bekijkt een voorbeeld van &ldquo;[_1]&rdquo; inhoudsgegevens getiteld &ldquo;[_2]&rdquo;',

## tmpl/cms/preview_entry.tmpl
	'Re-Edit this entry (e)' => 'Dit bericht opnieuw bewerken (e)',
	'Re-Edit this entry' => 'Dit bericht opnieuw bewerken',
	'Re-Edit this page (e)' => 'Deze pagina opnieuw bewerken (e)',
	'Re-Edit this page' => 'Deze pagina opnieuw bewerken',
	'Save this entry (s)' => 'Dit bericht opslaan (s)',
	'Save this entry' => 'Dit bericht opslaan',
	'Save this page (s)' => 'Deze pagina opslaan (s)',
	'Save this page' => 'Deze pagina opslaan',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry (s)' => 'Dit bericht publiceren (s)',
	'Publish this entry' => 'Dit bericht publiceren',
	'Publish this page (s)' => 'Deze pagina publiceren (s)',
	'Publish this page' => 'Deze pagina publiceren',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van het bericht met de titel &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van de pagina met de titel &ldquo;[_1]&rdquo;',

## tmpl/cms/preview_template_strip.tmpl
	'(Publish time: [_1] seconds)' => '(Publicatietijd: [_1] seconden)',
	'Re-Edit this template (e)' => 'Dit sjabloon opnieuw bewerken (e)',
	'Re-Edit this template' => 'Dit sjabloon opnieuw bewerken',
	'Save this template (s)' => 'Dit sjabloon opslaan (s)',
	'Save this template' => 'Dit sjabloon opslaan',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'Er zijn geen categorieën in deze blog.  Voorbeeld van categorie-archiefsjaboon is beperkt beschikbaar met weergave van een virtuele categorie.  Er kan geen normale, non-voorbeeld uitvoer gegenereerd worden met dit sjabloon tenzij minstens één categorie aangemaakt wordt.',
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van het sjabloon met de naam &ldquo;[_1]&rdquo;',

## tmpl/cms/rebuilding.tmpl
	'Complete [_1]%' => 'Voor [_1]% compleet',
	'Publishing <em>[_1]</em>...' => 'Bezig <em>[_1]</em> te publiceren...',
	'Publishing [_1] [_2]...' => '[_1] [_2] wordt gepubliceerd...',
	'Publishing [_1] archives...' => 'Bezig archieven [_1] te publiceren...',
	'Publishing [_1] dynamic links...' => 'Bezig [_1] dynamische links te publiceren...',
	'Publishing [_1] templates...' => 'Bezig [_1] sjablonen te publiceren...',
	'Publishing [_1]...' => '[_1] wordt gepubliceerd...',
	'Publishing...' => 'Publiceren...',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Blokkering opgeheven',
	q{User '[_1]' has been unlocked.} => q{Gebruiker '[_1]' werd gedeblokkeerd.},

## tmpl/cms/recover_password_result.tmpl
	'No users were selected to process.' => 'Er werden geen gebruikers geselecteerd om te verwerken.',
	'Recover Passwords' => 'Wachtwoorden terugvinden',
	'Return' => 'Terug',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
	'Return to templates' => 'Terugkeren naar sjablonen',

## tmpl/cms/restore.tmpl
	'Exported File' => 'Exportbestand',
	'Import (i)' => 'Importeren (i)',
	'Import from Exported file' => 'Importeren uit een exportbestand',
	'Overwrite global templates.' => 'Globale sjablonen overschrijven.',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Perl module XML::SAX en/of een aantal van de vereisten ervoor ontbreekt.  Movable Type kan het systeem niet terugzetten zonder deze modules.',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'Er deed zich een fout voor tijdens het importproces: [_1] Controleer het activiteitenlog voor meer details.',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Movable Type importeren',

## tmpl/cms/search_replace.tmpl
	'(search only)' => '(enkel zoeken)',
	'Case Sensitive' => 'Hoofdlettergevoelig',
	'Date Range' => 'Bereik wissen',
	'Date/Time Range' => 'Datum/tijd bereik',
	'Limited Fields' => 'Beperkte velden',
	'Regex Match' => 'Regex-overeenkomst',
	'Replace Checked' => 'Aangekruiste items vervangen',
	'Replace With' => 'Vervangen door',
	'Reported as Spam?' => 'Rapporteren als spam?',
	'Search &amp; Replace' => 'Zoeken en vervangen',
	'Search Again' => 'Opnieuw zoeken',
	'Search For' => 'Zoeken naar',
	'Show all matches' => 'Alle overeenkomsten worden getoond',
	'Showing first [_1] results.' => 'Eerste [_1] resultaten worden getoond.',
	'Submit search (s)' => 'Zoekopdracht ingeven (s)',
	'Successfully replaced [quant,_1,record,records].' => 'Met succes [quant,_1,record,records] vervangen.',
	'You must select one or more items to replace.' => 'U moet één of meer items selecteren om te vervangen.',
	'[quant,_1,result,results] found' => '[quant,_1,resultaat,resultaten] found',
	'_DATE_FROM' => 'Van',
	'_DATE_TO' => 'Tot',
	'_TIME_FROM' => 'Van',
	'_TIME_TO' => 'Tot',

## tmpl/cms/system_check.tmpl
	'Memcached Server is [_1].' => 'Memcached server is [_1].',
	'Memcached Status' => 'Memcached status',
	'Memcached is [_1].' => 'Memcached is [_1]',
	'Server Model' => 'Servertype',
	'Total Users' => 'Totaal aantal gebruikers',
	'available' => 'beschikbaar',
	'configured' => 'geconfigureerd',
	'disabled' => 'uitgeschakeld',
	'unavailable' => 'niet beschikbaar',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type kon het script met de naam 'mt-check.cgi' niet vinden.  Om dit probleem op te lossen moet u controleren of het script mt-check.cgi bestaat en of de CheckScript configuratieparameter (indien nodig) er correct naar verwijst.},

## tmpl/cms/theme_export_replace.tmpl
	'Overwrite' => 'Overschrijven',
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Exportmap voor thema bestaat al '[_1]'.  U kunt een bestaand thema overschrijven, of annuleren om de naam van de map aan te passen.},

## tmpl/cms/upgrade.tmpl
	'Begin Upgrade' => 'Begin de upgrade',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Proficiat, u heeft met succes een upgrade uitgevoerd aan Movable Type [_1].',
	'Do you want to proceed with the upgrade anyway?' => 'Wenst u toch door te gaan met de upgrade?',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Bovendien hebben volgende Movable Type componenten een upgrade nodig of moeten ze geïnstalleerd worden:',
	'Return to Movable Type' => 'Terugkeren naar Movable Type',
	'The following Movable Type components require upgrading or installation:' => 'Volgende Movable Type componenten hebben een upgrade nodig of moeten geïnstalleerd worden:',
	'Time to Upgrade!' => 'Tijd voor een upgrade!',
	'Upgrade Check' => 'Upgrade-controle',
	'Your Movable Type installation is already up to date.' => 'Uw Movable Type installation is al up-to-date.',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Er is een nieuwe versie van Movable Type geïnstalleerd.  Er moeten een aantal dingen gebeuren om uw database bij te werken.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{De Movable Type Upgrade Gids kan <a href='[_1]' target='_blank'>hier</a> worden gevonden.},

## tmpl/cms/upgrade_runner.tmpl
	'Error during installation:' => 'Fout tijdens installatie:',
	'Error during upgrade:' => 'Fout tijdens upgrade:',
	'Initializing database...' => 'Database wordt geïnitialiseerd...',
	'Installation complete!' => 'Installatie voltooid!',
	'Return to Movable Type (s)' => 'Terugkeren naar Movable Type (s)',
	'Upgrade complete!' => 'Upgrade voltooid!',
	'Upgrading database...' => 'Database wordt bijgewerkt...',
	'Your database is already current.' => 'Uw database is reeds up-to-date.',

## tmpl/cms/view_log.tmpl
	'Download Filtered Log (CSV)' => 'Gefilterde log downloaden',
	'Filtered Activity Feed' => 'Gefilterde activiteitenfeed',
	'Filtered' => 'Gefilterde',
	'Show log records where' => 'Toon logberichten waar',
	'Showing all log records' => 'Alle logberichten worden getoond',
	'Showing log records where' => 'Alleen logberichten worden getoond waar',
	'System Activity Log' => 'Systeemactiviteitenlog',
	'The activity log has been reset.' => 'Het activiteitlog is leeggemaakt.',
	'classification' => 'classificatie',
	'level' => 'niveau',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Foutenlog van de Schwartz',
	'Showing all Schwartz errors' => 'Alle Schwartz fouten worden getoond',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Nieuws',
	'No Movable Type news available.' => 'Geen Movable Type nieuws beschikbaar.',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Berichten van het systeem',
	'warning' => 'waarschuwing',

## tmpl/cms/widget/site_list.tmpl
	'Recent Posts' => 'Recente berichten',
	'Setting' => 'Instelling',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Instellingen voor statistieken',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Actieve gebruikers',

## tmpl/cms/widget/updates.tmpl
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Beschikbare updates (Ver. [_1]) gevonden.  Zie <a href="[_2]" target="_blank">nieuws</a> voor details.',
	'Available updates ([_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => '', # Translate - New
	'Movable Type is up to date.' => 'Movable Type is bijgewerkt tot de laatste versie.',
	'Update check failed. Please check server network settings.' => 'Update check mislukt.  Kijk de netwerkinstellingen op de server na.',
	'Update check is disabled.' => 'Update check is uitgeschakeld.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Terug (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Nog geen lid? <a href="[_1]">Registreer nu</a>!',
	'Sign in to comment' => 'Aanmelden om te reageren',
	'Sign in using' => 'Aanmelden met',

## tmpl/comment/profile.tmpl
	'Return to the <a href="[_1]">original page</a>.' => 'Keer terug naar de <a href="[_1]">oorspronkelijke pagina</a>.',
	'Select a password for yourself.' => 'Kies een wachtwoord voor uzelf.',
	'Your Profile' => 'Uw profiel',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Maak een account aan',
	'Password Confirm' => 'Wachtwoord bevestigen',
	'Register' => 'Registreer',

## tmpl/comment/signup_thanks.tmpl
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Voordat u een reactie kunt achterlaten, moet u eerst het registratieproces doorlopen door uw account te bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'Return to the original entry.' => 'Terugkeren naar oorspronkelijk bericht',
	'Return to the original page.' => 'Terugkeren naar oorspronkelijke pagina',
	'Thanks for signing up' => 'Bedankt om te registreren',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Om de registratieprocedure te voltooien moet u eerst uw account bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Om uw account te bestigen en activeren, gelieve in uw inbox te kijken en op de link te klikken in de e-mail die u net is toegestuurd.',

## tmpl/error.tmpl
	'CGI Path Configuration Required' => 'CGI-pad configuratie vereist',
	'Database Connection Error' => 'Databaseverbindingsfout',
	'Missing Configuration File' => 'Ontbrekend configuratiebestand',
	'_ERROR_CGI_PATH' => 'Uw CGIPath configuratieinstelling is ofwel ongeldig ofwel ontbreekt ze in uw Movable Type configuratiebestand. Bekijk het deel <a href=\"#\">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',
	'_ERROR_CONFIG_FILE' => 'Uw Movable Type configuratiebestand ontbreekt of kan niet gelezen worden. Gelieve het deel <a href=\"#\">Installation and Configuration</a> van de handleiding van Movable Type te raadplegen voor meer informatie.',
	'_ERROR_DATABASE_CONNECTION' => 'Uw database instellingen zijn ofwel ongeldig ofwel ontbreken ze in uw Movable Type configuratiebestand. Bekijk het deel <a href=\"#\">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type activiteitlog',

## tmpl/feeds/feed_comment.tmpl
	'By commenter URL' => 'Volgens URL reageerders',
	'By commenter email' => 'Volgens e-mail reageerders',
	'By commenter identity' => 'Volgens identiteit reageerders',
	'By commenter name' => 'Volgens naam reageerders',
	'From this [_1]' => 'Van deze [_1]',
	'More like this' => 'Meer zoals dit',
	'On this day' => 'Op deze dag',
	'On this entry' => 'Op dit bericht',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'Van deze auteur',

## tmpl/feeds/feed_ping.tmpl
	'By source URL' => 'Volgens URL bron',
	'By source blog' => 'Volgens bronblog',
	'By source title' => 'Volgens titel bron',
	'Source [_1]' => 'Bron [_1]',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDir is vereist.',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'Tijdelijke map configuratie',
	'You should configure your temporary directory settings.' => 'U moet de instellingen voor uw tijdelijke map configureren.',
	'[_1] could not be found.' => '[_1] kon niet worden gevonden.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Uw TempDir is met succes ingesteld.  Klik op 'Doorgaan' hieronder om verder te gaan met de configuratie.},

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Configuratiebestand',
	'Retry' => 'Opnieuw',
	'Show the mt-config.cgi file generated by the wizard' => 'Toon het mt-config.cgi bestand dat door de wizard is aangemaakt',
	'The [_1] configuration file cannot be located.' => 'Het configuratiebestand [_1] kan niet worden gevonden',
	'The mt-config.cgi file has been created manually.' => 'Het mt-config.cgi bestand werd met de hand aangemaakt.',
	'The wizard was unable to save the [_1] configuration file.' => 'De wizard kon het [_1] configuratiebestand niet opslaan.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Kijk na of uw [_1] hoofdmap (de map die mt.cgi bevat) beschrijfbaar is door uw webserver en klik dan op 'Opnieuw'.},
	q{Congratulations! You've successfully configured [_1].} => q{Proficiat! U heeft met succes [_1] geconfigureerd.},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Gelieve de configuratietekst hieronder te gebruiken om een bestand mee aan te maken genaamd 'mt-config.cgi' in de hoofdmap van [_1] (dezelfde map waar u ook mt.cgi in aantreft).},

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Database configuratie',
	'Database Type' => 'Databasetype',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Staat uw gewenste database er niet bij?  Kijk bij de <a href="[_1]" target="_blank">Movable Type systeemcontrole</a> of er bijkomende modules nodig zijn.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => '<a href="javascript:void(0)" onclick="[_1]">Klik hier om dit scherm te vernieuwen</a> zodra de installatie voltooid is.',
	'Please enter the parameters necessary for connecting to your database.' => 'Gelieve de parameters in te vullen die nodig zijn om met uw database te verbinden.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Meer weten over: <a href="[_1]" target="_blank">Database instellen</a>',
	'Select One...' => 'Selecteer er één...',
	'Show Advanced Configuration Options' => 'Geavanceerde configuratieopties tonen',
	'Show Current Settings' => 'Huidige instellingen tonen',
	'Test Connection' => 'Verbinding testen',
	'You may proceed to the next step.' => 'U kunt verder gaan naar de volgende stap.',
	'You must set your Database Path.' => 'U moet uw databasepad instellen.',
	'You must set your Database Server.' => 'U moet uw database server instellen.',
	'You must set your Username.' => 'U moet uw gebruikersnaam instellen.',
	'Your database configuration is complete.' => 'Uw databaseconfiguratie is voltooid.',
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',

## tmpl/wizard/optional.tmpl
	'Address of your SMTP Server.' => 'Adres van uw SMTP server.',
	'An error occurred while attempting to send mail: ' => 'Er deed zich een fout voor toen er werd geprobeerd e-mail te verzenden: ',
	'Cannot use [_1].' => 'Kan [_1] niet gebruiken.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Controleer uw e-mail om te bevestigen of uw een testmail van Movable Type heeft ontvangen en ga dan verder naar de volgende stap.',
	'Do not use SSL' => 'SSL niet gebruiken',
	'Mail Configuration' => 'E-mail instellingen',
	'Mail address to which test email should be sent' => 'E-mail adres om testbericht naartoe te sturen',
	'Outbound Mail Server (SMTP)' => 'Uitgaande mailserver (SMTP)',
	'Password for your SMTP Server.' => 'Wachtwoord voor uw SMTP server.',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Movable Type zal af en toe e-mail versturen om gebruikers op de hoogte te brengen van nieuwe reacties en andere gebeurtenissen.  Om deze e-mails goed te kunnen versturen, moet u Movable Type vertellen hoe ze verstuurd moeten worden.',
	'Port number for Outbound Mail Server' => 'Poortnummer voor uitgaande mail server',
	'Port number of your SMTP Server.' => 'Poortnummer van uw SMTP server.',
	'SMTP Auth Password' => 'SMTP Auth wachtwoord',
	'SMTP Auth Username' => 'SMTP Auth gebruikersnaam',
	'SSL Connection' => 'SSL verbinding',
	'Send Test Email' => 'Verstuur testbericht',
	'Send mail via:' => 'Stuur mail via:',
	'Sendmail Path' => 'Sendmail pad',
	'Show current mail settings' => 'Toon alle huidige mailinstellingen',
	'Skip' => 'Overslaan',
	'This field must be an integer.' => 'Dit veld moet een getal bevatten.',
	'Use SMTP Auth' => 'Gebruik SMTP Auth',
	'Use SSL' => 'SSL gebruiken',
	'Use STARTTLS' => 'STARTTLS gebruiken',
	'Username for your SMTP Server.' => 'Gebruikersnaam voor uw SMTP server.',
	'You must set a password for the SMTP server.' => 'U moet een wachtwoord instellen voor de SMTP server.',
	'You must set a username for the SMTP server.' => 'U moet een gebruikersnaam instellen voor de SMTP server.',
	'You must set the SMTP server address.' => 'U moet het SMTP server adres nog instellen.',
	'You must set the SMTP server port number.' => 'U moet het poortnummer van de SMTP server instellen.',
	'You must set the Sendmail path.' => 'U moet het Sendmail pad nog instellen.',
	'You must set the system email address.' => 'U moet het systeem-emailadres nog instellen.',
	'Your mail configuration is complete.' => 'Uw mailconfiguratie is volledig',

## tmpl/wizard/packages.tmpl
	'All required Perl modules were found.' => 'Alle vereiste Perl modules werden gevonden',
	'Learn more about installing Perl modules.' => 'Meer weten over het installeren van Perl modules',
	'Minimal version requirement: [_1]' => 'Minimale versievereisten: [_1]',
	'Missing Database Modules' => 'Ontbrekende databasemodules',
	'Missing Optional Modules' => 'Ontbrekende optionele modules',
	'Missing Required Modules' => 'Ontbrekende vereiste modules',
	'One or more Perl modules required by Movable Type could not be found.' => 'Eén of meer Perl modules vereist door Movable Type werden niet gevonden.',
	'Requirements Check' => 'Controle systeemvereisten',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Een aantal optionele Perl modules kon niet worden gevonden. <a href="javascript:void(0)" onclick="[_1]">Toon lijst optionele modules</a>',
	'You are ready to proceed with the installation of Movable Type.' => 'U bent klaar om verder te gaan met de installatie van Movable Type',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Op uw server zijn alle vereiste modules geïnstalleerd; u hoeft geen bijkomende modules te installeren.',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Een aantal optionele Perl modules konden niet worden gevonden.  U kunt verder gaan zonder deze optionele modules te installeren.  Ze kunnen op gelijk welk moment geïnstalleerd worden indien ze nodig zijn.  Klik op 'Opnieuw' om opnieuw te testen of de modules aanwezig zijn.},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{De onderstaande Perl modules zijn nodig voor de werking van Movable Type.  Eens uw systeem aan deze voorwaarden voldoet, klik op de 'Opnieuw' knop om opnieuw te testen of deze modules geïnstalleerd zijn.},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{De volgende Perl modules zijn vereist om een databaseverbinding te kunnen maken.  Movable Type heeft een database nodig om de gegevens op te slaan van uw sites en subsites. Gelieve één van de opgesomde paketten te installeren om verder te gaan.  Als u gereed bent, klilk dan op de knop 'Opnieuw proberen'.},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Er bestaat al een configuratiebestand (mt-config.cgi), U kunt <a href="[_1]">aanmelden</a> bij Movable Type.',
	'Begin' => 'Start!',
	'Configuration File Exists' => 'Configuratiebestand bestaat',
	'Configure Static Web Path' => 'Statisch webpad instellen',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type vereist dat JavaScript ingeschakeld is in uw browser.  Gelieve het in te schakelen en herlaad deze pagina om opnieuw te proberen.',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type wordt geleverd met een map genaamd [_1] die een aantal belangrijke bestanden bevat zoals afbeeldingen, javascript bestanden en stylesheets.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Zodra de [_1] map verplaatst is naar een web-toegankelijke plaats, geef dan de locatie ervan hieronder op.',
	'Static file path' => 'Statisch bestandspad',
	'Static web path' => 'Pad voor statische bestanden',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Dit URL pad kan in de vorm zijn van [_1] of eenvoudigweg [_2]',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Deze map is ofwel van naam veranderd of is verplaatst naar een locatie buiten de Movable Type map.',
	'This path must be in the form of [_1]' => 'Dit pad moet deze vorm hebben [_1]',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Deze wizard zal u helpen met het configureren van de basisinstellingen om Movable Type te doen werken.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Om een nieuw configuratiebestand aan te maken met de Wizard moet u het huidige configuratiebestand verwijderen en deze pagina vernieuwen.',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Fout: '[_1]' werd niet gevonden.</strong>  Gelieve eerst uw statische bestanden in de map te plaatsen of pas de instelling aan als deze niet juist is.},
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{De map [_1] bevindt zich in de hoofdmap van Movable Type waar ook dit wizard script zich bevindt, maar door de configuratie van uw webserver is de [_1] map niet toegankelijk op deze locatie en moet deze dus verplaatst worden naar een locatie die toegankelijk is vanop het web (m.a.w. uw document root map).},
);

1;
