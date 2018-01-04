# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::nl;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/archive_lib.php
	'Individual' => 'per bericht',
	'Page' => 'Pagina',
	'Yearly' => 'per jaar',
	'Monthly' => 'per maand',
	'Daily' => 'per dag',
	'Weekly' => 'per week',
	'Author' => 'Auteur',
	'(Display Name not set)' => '(Getoonde naam niet ingesteld)',
	'Author Yearly' => 'per auteur per jaar',
	'Author Monthly' => 'per auteur per maand',
	'Author Daily' => 'per auteur per dag',
	'Author Weekly' => 'per auteur per week',
	'Category Yearly' => 'per categorie per jaar',
	'Category Monthly' => 'per categorie per maand',
	'Category Daily' => 'per categorie per dag',
	'Category Weekly' => 'per categorie per week',
	'Category' => 'Categorie',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Geen auteur beschikbaar',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'U gebruikte een [_1] tag zonder een datum in context te brengen',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig "name" attribuut',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] is illegaal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig name attribuut',
	'\'[_1]\' is not a hash.' => '\'[_1]\' is geen hash.',
	'Invalid index.' => 'Ongeldige index.',
	'\'[_1]\' is not an array.' => '\'[_1]\' is geen array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' is geen geldige functie.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Typ de tekens die u ziet in de afbeelding hierboven.',

## php/lib/function.mtassettype.php
	'image' => 'afbeelding',
	'Image' => 'Afbeelding',
	'file' => 'bestand',
	'File' => 'Bestand',
	'audio' => 'audio',
	'Audio' => 'Audio',
	'video' => 'video',
	'Video' => 'Video',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonieme',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'De \'[_1]\' tag is verouderd.  Gelieve de \'[_2]\' tag te gebruiken ter vervanging.',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antwoorden',

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Bericht',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => '\'parent\' modifier kan niet worden gebruikt met \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Wachtwoord moet langer zijn dan [_1] karakters',
	'Password should not include your Username' => 'Wachtwoord mag gebruikersnaam niet bevatten',
	'Password should include letters and numbers' => 'Wachtwoorden moeten zowel letters als cijfers bevatten',
	'Password should include lowercase and uppercase letters' => 'Wachtwoord moet zowel grote als kleine letters bevatten',
	'Password should contain symbols such as #!$%' => 'Wachtwoord moet ook symbolen bevatten zoals #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'U gebruikte een [_1] tag zonder geldig [_2] attribuut.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'minimale lengte van [_1]',
	', uppercase and lowercase letters' => ', hoofdletters en kleine letters',
	', letters and numbers' => ', letters en cijfers',
	', symbols (such as #!$%)' => ', symbolen (zoals #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'TypePad authenticatie is niet ingeschakeld voor deze blog.  MTRemoteSignInLink kan niet gebruikt worden.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Ongeldige [_1] parameter',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' is geen geldige functie voor een hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' is geen geldige functie voor een array.',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Wanneer de exclude_blogs en include_blogs attributen samen worden gebruikt dan kunnen dezelfde blog ID\'s niet als parameters gebruikt worden in beide attributen.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'gebruikersafbeelding-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Pagina niet gevonden - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type Systeemcontrole',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'U heeft geprobeerd een optie te gebruiken waar u niet voldoende rechten voor heeft.  Als u gelooft dat u deze boodschap onterecht te zien krijgt, contacteer dan uw systeembeheerder.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Het MT-Check rapport is uitgeschakeld wanneer Movable Type een geldig configuratiebestand (mt-config.cgi) heeft',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Het script mt-check.cgi geeft u informatie over de configuratie van uw systeem en controleert of u alle benodigde componenten heeft om Movable Type te kunnen draaien.},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'De versie van Perl die op uw server geïnstalleerd is ([_1]) is lager dan de minimum versie die ondersteund wordt ([_2]).  Gelieve te upgraden naar minstens Perl [_2].',
	'System Information' => 'Systeeminformatie',
	'Movable Type version:' => 'Movable Type versie:',
	'Current working directory:' => 'Huidige werkmap:',
	'MT home directory:' => 'MT hoofdmap:',
	'Operating system:' => 'Operating systeem:',
	'Perl version:' => 'Perl versie:',
	'Perl include path:' => 'Perl include pad:',
	'Web server:' => 'Webserver:',
	'(Probably) running under cgiwrap or suexec' => '(Waarschijnlijk) uitgevoerd onder cgiwrap of suexec',
	'[_1] [_2] Modules' => '[_1] [_2] modules',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'Volgende modules zijn <strong>optioneel</strong>.  Als deze modules niet op uw server geïnstalleerd zijn dan moet u ze enkel installeren als u de functionaliteit nodig heeft die ze toevoegen.',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'Volgende modules zijn vereist door de databases waar Movable Type mee gebruikt kan worden.  Op uw server moet DBI en minstens één van de gerelateerde modules geïnstalleerd zijn om de applicatie te doen werken.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Ofwel is [_1] niet geïnstalleerd op uw server, ofwel is de geïnstalleerde versie te oud, of [_1] vereist een andere module die niet geïnstalleerd is.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => '[_1] is niet geïnstalleerd op uw server of [_1] vereist een andere module die niet is geïnstalleerd.',
	'Please consult the installation instructions for help in installing [_1].' => 'Gelieve de installatiehandleiding te raadplegen voor hulp met de installatie van [_1]',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'Van de versie van DBD::mysql die op uw server geïnstalleerd is, is geweten dat ze niet compatibel is met Movable Type.  Gelieve de meest recent beschikbare versie te installeren.',
	'The $mod is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => 'De $mod is correct geïnstalleerd maar vereist een bijgewerkte DBI module.  Zie ook de opmerking hierboven over vereisten voor de DBI module.',
	'Your server has [_1] installed (version [_2]).' => '[_1] is op uw server geïnstalleerd (versie [_2]).',
	'Movable Type System Check Successful' => 'Movable Type Systeemcontrole met succes afgerond',
	q{You're ready to go!} => q{Klaar om van start te gaan!},
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle vereiste modules zijn geïnstalleerd op de server; u moet geen bijkomende modules installeren.  Ga verder met de installatie-instructies.',
	'CGI is required for all Movable Type application functionality.' => 'CGI is vereist voor alle functionaliteit van Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size is vereist om bestanden te kunnen uploaden (om het formaat van verschillende soorten afbeeldingsbestanden te kunnen bepalen).',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec is vereist om te kunnen werken met padinformatie in bestandssystemen op alle ondersteunde operating systemen.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie is vereist om authenticatie via cookies te kunnen gebruiken.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent is vereist om Movable Type configuratiebestanden te kunnen maken tijdens het gebruik van de installatiewizard.',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util is vereist om de Movable Type applicatie te kunnen initialiseren.',
	'DBI is required to work with most supported databases.' => 'DBI is vereist om te kunnen werken met de meeste ondersteunde databases.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist om gebruikt te kunnen maken van een MySQL database backend.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist om gebruikt te kunnen maken van een PostgreSQL database backend.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI en DBD::SQLite zijn vereist om gebruikt te kunnen maken van een SQLite database backend.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI en DBD::SQLite2 zijn vereist om gebruikt te kunnen maken van een SQLite2 database backend.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA is vereist voor geavanceerde bescherming van gebruikerswachtwoorden.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Deze module en de modules die ervan afhangen zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Deze module en de modules waar deze van afhangt zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities is vereist om sommige karakters te kunnen encoderen, maar deze optie kan uitgeschakeld worden met de NoHTMLEntities optie in het configuratiebestand.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser is optioneel: Het is nodig als u het TrackBack systeem wenst te gebruiken of pings wenst te sturen naar weblogs.com of MT recent bijgewerkte sites.',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Lite is optioneel; Het is vereist als u de MT XML-RPC server implementatie wenst te gebruiken.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp is optioneel; Het is vereist als u bestaande bestanden wenst te kunnen overschrijven bij uploads.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List::Util is optioneel; Het is vereist als u de publicatiewachtrij-functie wenst te gebruiken.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1] is optioneel; Het is één van de modules voor afbeeldingsbewerking die u kunt gebruiken om thumbnails te maken van geuploade afbeeldingen.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Run is optioneel; Het is veriest als u NetPBM wenst te gebruiken als de afbeeldingsbewerker voor Movable Type',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable is optioneel; Het is vereist door bepaalde Movable Type plugins ontwikkeld door derden.',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA is optioneel; Als het is geïnstalleerd dan verloopt registratie van reageerders iets sneller.',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support. Also this module is required for Google Analytics site statistics.' => 'Deze module en de vereisten ervan zijn vereist om het mogelijk te maken dat reageerdeers zich kunnen aanmelden via OpenID providers zoals AOL en Yahoo! die ondersteuning voor SSL vereisen.  Deze module is ook vereist om sitestatistieken te genereren via Google Analytics.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File is vereist als u wenst dat reageerders zich kunnen aanmelden met OpenID via Yahoo! Japan.',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 is vereist om het registreren van reageerders in te schakelen en om mail te kunnen versturen via een SMTP server.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom is vereist om de Atom API te kunnen gebruiken.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached en een memcached server zijn vereist om het cachen in het geheugen van objecten mogelijk te maken voor de servers waarop Movable Type draait.',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar is vereist om bestanden te kunnen manipuleren tijdens backup en restore operaties.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip is vereist om bestanden te kunnen comprimeren tijdens backupoperaties',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress:Gunzip is vereist om bestanden te kunnen decomprimeren tijdens restore-operaties.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip is vereist om bestanden te kunnen manipuleren tijdens backup en restore operaties.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX en de modules die er van afhangen zijn vereist om een backup te kunnen terugzetten die werd gemaakt tijdens een backup/restore operatie.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 en de daarvoor benodigde bestanden zijn vereist om reageerders te kunnen toestaan zich aan te melden via OpenID providers, waaronder LiveJournal.',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP is vereist om mail te kunnen versturen via een SMTP server.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Deze modules en de modules waar deze van afhangt zijn vereist om CRM-MD5, DIGEST-MD5 of LOGIN SASL te ondersteunen.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL is vereist voor alle SSL/TLS verbindingen, zoals Google Analytics site statistieken of SMTP Auth over SSL/TLS.', # Translate - New
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay is vereist om SMTP Auth te kunnen gebruiken over een SSL verbinding of om het te kunnen gebruiken met een STARTTLS commando.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Deze module wordt gebruikt in een testattribuut voor de MTIf conditionele tag.',
	'This module is used by the Markdown text filter.' => 'Deze module is vereist voor de Markdown tekstfilter.',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Deze module is vereist door mt-search.cgi als u Movable Type draait op een versie van Perl ouder dan 5.8.',
	'This module required for action streams.' => 'Deze module is vereist voor action streams.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] is optioneel; Het is één van de modules die nodig zijn om een backup terug te zetten tijdens een backup/restore operatie',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Deze module is vereist om statistieken over de site te kunnen weergeven uit Google Analytics en om SSL certificaten te kunnen controleren.',
	'This module is required for executing run-periodic-tasks.' => 'Deze module is vereist om run-periodic-tasks te kunnen uitvoeren.',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] is optioneel; Het is een beter, sneller en lichter alternatief voor YAML::Tiny bij het behandelen van YAML bestanden.',
	'The [_1] database driver is required to use [_2].' => 'De [_1] databasedriver is vereist om [_2] te kunnen gebruiken.',
	'DBI is required to store data in database.' => 'DBI is vereist om gegevens te kunnen opslaan in een database',
	'Checking for' => 'Controleren op',
	'Installed' => 'Geïnstalleerd',
	'Data Storage' => 'Gegevensopslag',
	'Required' => 'Vereist',
	'Optional' => 'Optioneel',
	'Details' => 'Details',
	'unknown' => 'onbekend',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Over dit bericht',
	'About this Archive' => 'Over dit archief',
	'About Archives' => 'Over archieven',
	'This page contains links to all of the archived content.' => 'Deze pagina bevat links naar alle gearchiveerde inhoud.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Deze pagina bevat één bericht door [_1] gepubliceerd op <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze weblog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze weblog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Dese pagina is een archief van de berichten in de <strong>[_1]</strong> categorie van <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is het vorige archief.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is het volgende archief.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Deze pagina is een archief van recente berichten in de <strong>[_1]</strong> categorie.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is de vorige categorie.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is de volgende categorie.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong> op <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Deze pagina is een archief van berichten op <strong>[_2]</strong> gerangschikt van nieuw naar oud',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'De nieuwste berichten zijn te vinden op de <a href="[_1]">hoofdpagina</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'De nieuwste berichten zijn te vinden op de <a href="[_1]">hoofdpagina</a> of kijk in de <a href="[_2]">archieven</a> om alle berichten te zien.',

## default_templates/archive_index.mtml
	'HTML Head' => 'HTML Head',
	'Archives' => 'Archieven',
	'Banner Header' => 'Banner hoofding',
	'Monthly Archives' => 'Archief per maand',
	'Categories' => 'Categorieën',
	'Author Archives' => 'Archief per auteur',
	'Category Monthly Archives' => 'Archief per categorie per maand',
	'Author Monthly Archives' => 'Archief per auteur per maand',
	'Sidebar' => 'Zijkolom',
	'Banner Footer' => 'Banner voettekst',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'Dit is een lijst met widgets die andere inhoud weergeven afhankelijk van het soort archief waarin ze worden geincludeerd.  Meer info: [_1]',
	'Current Category Monthly Archives' => 'Archieven van de huidige categorie per maand',
	'Category Archives' => 'Archieven per categorie',

## default_templates/author_archive_list.mtml
	'Authors' => 'Auteurs',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Aangedreven  door<br /><a href="http://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Deze weblog valt onder een <a href="[_1]">Creative Commons Licentie</a>.',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Maandkalender met links naar de berichten van alle dagen',
	'Sunday' => 'Zondag',
	'Sun' => 'Zon',
	'Monday' => 'Maandag',
	'Mon' => 'Maa',
	'Tuesday' => 'Dinsdag',
	'Tue' => 'Din',
	'Wednesday' => 'Woensdag',
	'Wed' => 'Woe',
	'Thursday' => 'Donderdag',
	'Thu' => 'Don',
	'Friday' => 'Vrijdag',
	'Fri' => 'Vri',
	'Saturday' => 'Zaterdag',
	'Sat' => 'Zat',

## default_templates/category_archive_list.mtml

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Archieven van [_1]',
	'Recently in <em>[_1]</em> Category' => 'Recent in de categorie <em>[_1]</em>',
	'Entry Summary' => 'Samenvatting bericht',
	'Main Index' => 'Hoofdindex',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] reageerde op <a href="[_2]">reactie van [_3]</a>',

## default_templates/commenter_confirm.mtml
	'Thank you for registering an account to comment on [_1].' => 'Bedankt om een account aan te maken om te kunnen reageren op [_1].',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Voor uw eigen veiligheid en om fraude tegen te gaan, vragen we u om uw account en email adres te bevestigen vooraleer verder te gaan.  Zodra uw account bevestigd is, kunt u meteen reageren op [_1].',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'Om uw account te bevestigen moet u op volgende URL klikken of hem in uw webbrowser knippen en plakken.',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Als u deze account niet heeft aangevraagd, of als u niet de bedoeling had te registreren om te kunnen reageren op [_1] dan hoeft u verder niets te doen.},
	'Sincerely,' => 'Hoogachtend,',
	'Mail Footer' => 'Footer voor e-mail',

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Deze email dient om u te melden dat een nieuwe gebruiker zich met succes heeft aangemeld op de blog '[_1]'.  Hier is wat meer informatie over deze nieuwe gebruiker.},
	'New User Information:' => 'Info nieuwe gebruiker:',
	'Username: [_1]' => 'Gebruikersnaam: [_1]',
	'Full Name: [_1]' => 'Volledige naam: [_1]',
	'Email: [_1]' => 'E-mail: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Om deze gebruiker te bekijken of te bewerken, klik op deze link of plak de URL in een webbrowser:',

## default_templates/comment_listing.mtml
	'Comment Detail' => 'Details reactie',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'U ziet een voorbeeld van uw reactie',
	'Leave a comment' => 'Laat een reactie achter',
	'Name' => 'Naam',
	'Email Address' => 'E-mailadres',
	'URL' => 'URL',
	'Replying to comment from [_1]' => 'Antwoord op reactie van [_1]',
	'Comments' => 'Reacties',
	'(You may use HTML tags for style)' => '(u kunt HTML tags gebruiken voor de lay-out)',
	'Preview' => 'Voorbeeld',
	'Submit' => 'Invoeren',
	'Cancel' => 'Annuleren',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Bevestiging...',
	'Your comment has been submitted!' => 'Uw reactie werd ontvangen!',
	'Thank you for commenting.' => 'Bedankt voor uw reactie.',
	'Your comment has been received and held for review by a blog administrator.' => 'Uw reactie werd ontvangen en wordt bewaard tot ze kan worden beoordeeld door een blog administrator.',
	'Comment Submission Error' => 'Fout bij indienen reactie',
	'Your comment submission failed for the following reasons: [_1]' => 'Het indienen van uw reactie mislukte wegens deze redenen: [_1]',
	'Back' => 'Terug',
	'Return to the <a href="[_1]">original entry</a>.' => 'Ga terug naar het <a href="[_1]">oorspronkelijke bericht</a>.',

## default_templates/comments.mtml
	'1 Comment' => '1 reactie',
	'# Comments' => '# reacties',
	'No Comments' => 'Geen reacties',
	'Previous' => 'Vorige',
	'Next' => 'Volgende',
	'The data is modified by the paginate script' => 'De gegevens zijn aangepast door het paginatiescript',
	'Remember personal info?' => 'Persoonijke gegevens onthouden?',

## default_templates/comment_throttle.mtml
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Als dit een vergissing was dan kunt u het IP adres deblokkeren en de bezoeker toelaten om het opnieuw toe te voegen door u aan te melden bij uw Movable Type installatie.  Ga vervolgens naar Blog Config - IP Blokkering en verwijder het IP adres [_1] uit de lijst van geblokkeerde adressen.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Een bezoeker van uw weblog [_1] is automatisch uitgesloten omdat dez meer dan het toegestane aantal reacties heeft gepubliceerd in de laatste [_2] seconden.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Dit werd gedaan om te voorkomen dat een kwaadaardig script uw weblog zou overspoelen met reacties. Het geblokkeerde IP adres is',

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: Maandelijkse archieven',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archieven per auteur per jaar',
	'Author Weekly Archives' => 'Archieven per auteur per week',
	'Author Daily Archives' => 'Archieven per auteur per dag',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archieven per categorie per jaar',
	'Category Weekly Archives' => 'Archieven per categorie per week',
	'Category Daily Archives' => 'Archieven per categorie per dag',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Pagina niet gevonden',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Door [_1] op [_2]',
	'1 TrackBack' => '1 Trackback',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Geen TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '<a href="[_1]" rel="bookmark">[_2]</a> verder lezen.',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Aangedreven door Movable Type [_1]',

## default_templates/javascript.mtml
	'moments ago' => 'ogenblikken geleden',
	'[quant,_1,hour,hours] ago' => '[quant,_1,uur,uur] geleden',
	'[quant,_1,minute,minutes] ago' => '[quant,_1,minuut,minuten] geleden',
	'[quant,_1,day,days] ago' => '[quant,_1,dag,dagen] geleden',
	'Edit' => 'Bewerken',
	'Your session has expired. Please sign in again to comment.' => 'Uw sessie is verlopen.  Gelieve opnieuw aan te melden om te kunnen reageren.',
	'Signing in...' => 'Aanmelden...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'U heeft geen permissie om te reageren op deze weblog. ([_1]afmelden[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Bedankt om u aan te melden, __NAME__. ([_1]afmelden[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Meld u aan[_2] om te reageren.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Meld u aan[_2] om te reageren, of reageer anoniem.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Als antwoord op <a href="[_1]" onclick="[_2]">reactie van [_3]</a>',
	'The sign-in attempt was not successful; Please try again.' => 'Aanmeldingspoging mislukt; Gelieve opnieuw te proberen.',

## default_templates/lockout-ip.mtml
	'This email is to notify you that an IP address has been locked out.' => 'Dit is een bericht om u te melden dat een IP adres geblokkeerd werd.',
	'IP Address: [_1]' => 'IP Adres: [_1]',
	'Recovery: [_1]' => 'Herstel: [_1]',

## default_templates/lockout-user.mtml
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Dit is een bericht om u te melden dat een Movable Type gebruikersaccount geblokkeerd werd.',
	'Display Name: [_1]' => 'Getoonde naam: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Als u deze gebruiker weer wil laten participeren, klik dan onderstaande link.',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'Dit is een speciale set widgets die enkel op de hoofdpagina (of "Hoofdindex") verschijnen.  Meer info: [_1]',
	'Recent Comments' => 'Recente reacties',
	'Recent Entries' => 'Recente berichten',
	'Recent Assets' => 'Recente mediabestanden',
	'Tag Cloud' => 'Tagwolk',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Selecteer een maand...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archieven</a> [_1]',

## default_templates/monthly_entry_listing.mtml

## default_templates/new-comment.mtml
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Een niet goedgekeurde reactie werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).  U moet deze reactie eerst goedkeuren voor ze op uw site verschijnt.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Een niet goedgekeurde reactie werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).  U moet deze reactie eerst goedkeuren voor ze op uw site verschijnt.},
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Een nieuwe reactie werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Een nieuwe reactie werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).},
	'Commenter name: [_1]' => 'Naam reageerder: [_1]',
	'Commenter email address: [_1]' => 'E-mail adres reageerder: [_1]',
	'Commenter URL: [_1]' => 'URL reageerder: [_1]',
	'Commenter IP address: [_1]' => 'IP adres reageerder: [_1]',
	'Approve comment:' => 'Reactie goedkeuren',
	'View comment:' => 'Reactie bekijken:',
	'Edit comment:' => 'Reactie bewerken:',
	'Report the comment as spam:' => 'Reactie als spam melden:',

## default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op categorie #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op categorie #[_2] ([_3]).},
	'Excerpt' => 'Uittreksel',
	'Title' => 'Titel',
	'Blog' => 'Blog',
	'IP address' => 'IP adres',
	'Approve TrackBack' => 'TrackBack goedkeuren',
	'View TrackBack' => 'TrackBack bekijken',
	'Report TrackBack as spam' => 'TrackBack melden als spam',
	'Edit TrackBack' => 'TrackBack bewerken',

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Een [lc,_3] getiteld '[_1]' is gepubliceerd op [_2].},
	'View entry:' => 'Bekijk bericht:',
	'View page:' => 'Bekijk pagina:',
	'[_1] Title: [_2]' => '[_1] titel: [_2]',
	'Publish Date: [_1]' => 'Publicatiedatum: [_1]',
	'Message from Sender:' => 'Boodschap van afzender:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'U ontvangt dit bericht omdat u ofwel gekozen hebt om notificaties over nieuw inhoud op [_1] te ontvangen, of de auteur van het bericht dacht dat u misschien wel geïnteresseerd zou zijn.  Als u deze berichten niet langer wenst te ontvangen, gelieve deze persoon te contacteren:',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] hier geaccepteerd',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	'Learn more about OpenID' => 'Meer weten over OpenID',

## default_templates/page.mtml

## default_templates/pages_list.mtml
	q{Pages} => q{Pagina's},

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/',

## default_templates/recent_assets.mtml

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="volledige reactie op: [_4]">meer lezen</a>',

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Er werd een aanvraag ingediend om uw Movable Type wachtwoord te veranderen.  Om dit proces af te ronden moet u op onderstaande link klikken en vervolgens een nieuw wachtwoord kiezen.',
	'If you did not request this change, you can safely ignore this email.' => 'Als u deze wijziging niet heeft aangevraagd, kunt u deze e-mail gerust negeren.',

## default_templates/search.mtml
	'Search' => 'Zoek',
	'Case sensitive' => 'Hoofdlettergevoelig',
	'Regex search' => 'Zoeken met reguliere expressies',

## default_templates/search_results.mtml
	'Search Results' => 'Zoekresultaten',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultaten die overeenkomen met &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultaten getagd als &ldquo;[_1]&rdquo;',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Geen resultaten gevonden met &ldquo;[_1]&rdquo;',
	'Instructions' => 'Gebruiksaanwijzing',
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een exacte uitdrukking te zoeken, gelieve aanhalingstekens rond uw zoekopdracht te zetten:',
	'movable type' => 'movable type',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'De zoekmachine ondersteunt eveneens de booleaanse operatoren AND, OR en NOT:',
	'personal OR publishing' => 'persoonlijk OR publicatie',
	'publishing NOT personal' => 'publiceren NOT persoonlijk',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'layout twee kolommen - Zijkolom',
	'3-column layout - Primary Sidebar' => 'layout drie kolommen - Primaire zijkolom',
	'3-column layout - Secondary Sidebar' => 'layout drie kolommen - Secundaire zijkolom',

## default_templates/signin.mtml
	'Sign In' => 'Aanmelden',
	'You are signed in as ' => 'U bent aangemeld als',
	'sign out' => 'afmelden',
	'You do not have permission to sign in to this blog.' => 'U heeft geen toestemming om aan te melden op deze weblog',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'Inschrijven op feed',
	q{Subscribe to this blog's feed} => q{Inschrijven op de feed van deze weblog},
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Inschrijven op een feed met alle toekomstige berichten getagd als &ldquo;[_1]&ldquo;',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Inschrijven op een feed met alle toekomstige berichten die overeen komen met &ldquo;[_1]&ldquo;',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Feed met resultaten getagd als &ldquo;[_1]&ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Feed met resultaten die overeen komen met &ldquo;[_1]&ldquo;',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{Zoek op <a href='http://www.technorati.com/'>Technorati</a>},
	'this blog' => 'deze weblog',
	'all blogs' => 'alle blogs',
	'Blogs that link here' => 'Blogs die hierheen linken',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'TrackBack URL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> van [_3] op <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Meer lezen</a>',

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Er deed zich een fout voor bij het aanmaken van de activiteitenfeed: [_1].',
	'Invalid request.' => 'Ongeldig verzoek.',
	'No permissions.' => 'Geen permissies.',
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Alle TrackBacks',
	'[_1] Comments' => '[_1] reacties',
	'All Comments' => 'Alle reacties',
	'[_1] Entries' => '[_1] berichten',
	'All Entries' => 'Alle berichten',
	'[_1] Activity' => '[_1] acties',
	'All Activity' => 'Alle acties',
	'Movable Type System Activity' => 'Movable Type systeemactiviteit',
	'Movable Type Debug Activity' => 'Movable Type debugactiviteit',
	'[_1] Pages' => '[_1] pagina\'s',
	'All Pages' => 'Alle pagina\'s',

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Sommige websites werden niet verwijderd.  U moet de blogs onder de website eerst verwijderen.',

## lib/MT/App/CMS.pm
	'Invalid request' => 'Ongeldig verzoek',
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Bent u zeker dat u alle trackbacks die als spam aangemerkt staan wenst te verwijderen?',
	'Are you sure you want to remove all comments reported as spam?' => 'Bent u zeker dat u alle reacties die als spam aangemerkt staan wenst te verwijderen?',
	'Add a user to this [_1]' => 'Gebruiker toevoegen aan deze [_1]',
	'Are you sure you want to reset the activity log?' => 'Bent u zeker dat u het activiteitenlog wil leegmaken?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'U staat op het punt e-mails te versturen waarmee de geselecteerde gebruikers hun wachtwoord kunnen aanpassen. Bent u zeker?',
	'_WARNING_DELETE_USER_EUM' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker tot \'wees\' maakt.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies verwijderen.  Bent u zeker dat u deze gebruiker(s) wenst te verwijderen?\nGebruikers die nog bestaan in de externe directory zullen zichzelf weer kunnen aanmaken.',
	'_WARNING_DELETE_USER' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies te verwijderen.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Deze actie zal de sjablonen van de geselecteerde blog(s) terugzetten naar de fabrieksinstellingen. Bent u zeker dat u de sjabonen van de geselecteerde blog(s) wenst te verversen?',
	'You are not authorized to log in to this blog.' => 'U hebt geen toestemming op u aan te melden op deze weblog.',
	'No such blog [_1]' => 'Geen blog [_1]',
	'Invalid parameter' => 'Ongeldige parameter',
	'Edit Template' => 'Sjabloon bewerken',
	'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
	'entry' => 'bericht',
	'None' => 'Geen',
	'Error during publishing: [_1]' => 'Fout tijdens publiceren: [_1]',
	'The support directory is not writable.' => 'Support map is niet beschrijfbaar',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type was niet in staat om te schrijven in de \'support\' map.  Gelieve een map aan te maken in deze locatie: [_1] en er genoeg permissies aan toe te kennen zodat de webserver er in kan schrijven.',
	'Please contact your Movable Type system administrator.' => 'Neem contact op met uw Movable Type syteembeheerder.',
	'ImageDriver is not configured.' => 'ImageDriver is niet geconfigureerd',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Een toolkit om afbeeldingen te bewerken, iets wat meestal via de ImageDriver configuratie-directief wordt ingesteld, is niet aanwezig op uw server of verkeerd geconfigureerd.  Zo\'n toolkit is nodig om gebruikersafbeeldingen te kunnen herschalen e.d.  Gelieve Image::Magick, NetPBM, GD, of Imager te installeren op de server en stel dan de ImageDriver directief overeenkomstig in.',
	'System Email Address is not configured.' => 'Systeem e-mail adres is niet ingesteld.',
	'The System Email Address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>' => 'Het systeem email adres wordt gebruikt in de \'From:\' header van elke mail verzonden door Movable Type.  Mails kunnen verstuurd worden om wachtwoorden terug te vinden, reageerders te registreren, te informeren over nieuwe reacties of trackbacks, in geval van het blokkeren van een gebruiker of IP en in een paar andere gevallen.  Gelieve uw <a href="[_1]">instellingen</a> te bevestigen.',
	'Cannot verify SSL certificate.' => 'Kan SSL certificaat niet verifiëren.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Gelieve de Mozilla::CA module te installeren.  De regel "SSLVerifyNone 1" aan mt-config.cgi toevoegen kan deze waarschuwing verbergen maar wordt niet aangeraden',
	'Can verify SSL certificate, but verification is disabled.' => 'Kan SSL certificaat controleren maar verificatie is uitgeschakeld.',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'U verwijdert best de regel "SSLVerifyNone 1" uit mt-config.cgi.',
	'Personal Stats' => 'Persoonlijke statistieken',
	'Movable Type News' => 'Movable Type-nieuws',
	'Websites' => 'Websites',
	'Blogs' => 'Blogs',
	'Websites and Blogs' => 'Websites en blogs',
	'Notification Dashboard' => 'Meldingendashboard',
	'Site Stats' => 'Sitestatistieken',
	'Blog Stats' => 'Blogstatistieken',
	'Entries' => 'Berichten',
	'Refresh Templates' => 'Sjablonen verversen',
	'Use Publishing Profile' => 'Publicatieprofiel gebruiken',
	'Delete all Spam trackbacks' => 'Alle spam-TrackBacks verwijderen',
	'Delete all Spam comments' => 'Alle spamreacties verwijderen.',
	'Create Role' => 'Rol aanmaken',
	'Grant Permission' => 'Permissie toekennen',
	'Clear Activity Log' => 'Activiteitenlog leegmaken',
	'Download Log (CSV)' => 'Log downloaden (CSV)',
	'Add IP Address' => 'IP Adres toevoegen',
	'Add Contact' => 'Contact toevoegen',
	'Download Address Book (CSV)' => 'Adresboek downloaden (CSV)',
	'Unpublish Entries' => 'Publicatie ongedaan maken',
	'Add Tags...' => 'Tags toevoegen',
	'Tags to add to selected entries' => 'Tags toe te voegen aan geselecteerde berichten',
	'Remove Tags...' => 'Tags verwijderen',
	'Tags to remove from selected entries' => 'Tags te verwijderen van geselecteerde berichten',
	'Batch Edit Entries' => 'Berichten bewerken in bulk',
	'Publish' => 'Publiceren',
	'Delete' => 'Verwijderen',
	'Unpublish Pages' => 'Pagina\'s off-line halen',
	'Tags to add to selected pages' => 'Tags om toe te voegen aan geselecteerde pagina\'s',
	'Tags to remove from selected pages' => 'Tags om te verwijderen van geselecteerde pagina\'s',
	'Batch Edit Pages' => 'Pagina\'s bewerken in bulk',
	'Tags to add to selected assets' => 'Tags om toe te voegen aan de geselecteerde mediabestanden',
	'Tags to remove from selected assets' => 'Tags om te verwijderen van de geselecteerde mediabestanden',
	'Mark as Spam' => 'Markeren als spam',
	'Remove Spam status' => 'Spamstatus verwijderen',
	'Unpublish TrackBack(s)' => 'Publicatie ongedaan maken',
	'Unpublish Comment(s)' => 'Publicatie ongedaan maken',
	'Trust Commenter(s)' => 'Reageerder(s) vertrouwen',
	'Untrust Commenter(s)' => 'Reageerder(s) niet meer vertrouwen',
	'Ban Commenter(s)' => 'Reageerder(s) verbannen',
	'Unban Commenter(s)' => 'Verbanning opheffen',
	'Recover Password(s)' => 'Wachtwoord(en) terugvinden',
	'Enable' => 'Inschakelen',
	'Disable' => 'Uitschakelen',
	'Unlock' => 'Deblokkeer',
	'Remove' => 'Verwijder',
	'Refresh Template(s)' => 'Sjablo(o)n(en) verversen',
	'Move blog(s) ' => 'Blog(s) verhuizen',
	'Clone Blog' => 'Kloon blog',
	'Publish Template(s)' => 'Sjablo(o)n(en) publiceren',
	'Clone Template(s)' => 'Sjablo(o)n(en) klonen',
	'Revoke Permission' => 'Permissie intrekken',
	'Pages' => 'Pagina\'s',
	'Assets' => 'Mediabestanden',
	'Commenters' => 'Reageerders',
	'Design' => 'Design',
	'Listing Filters' => 'Lijstfilters',
	'Settings' => 'Instellingen',
	'Tools' => 'Gereedschappen',
	'Manage' => 'Beheren',
	'New' => 'Nieuw',
	'Folders' => 'Mappen',
	'TrackBacks' => 'TrackBacks',
	'Templates' => 'Sjablonen',
	'Widgets' => 'Widgets',
	'Themes' => 'Thema\'s',
	'General' => 'Algemeen',
	'Compose' => 'Opstellen',
	'Feedback' => 'Feedback',
	'Registration' => 'Registratie',
	'Web Services' => 'Webservices',
	'IP Banning' => 'IP-verbanning',
	'User' => 'Gebruiker',
	'Roles' => 'Rollen',
	'Permissions' => 'Permissies',
	'Search &amp; Replace' => 'Zoeken en vervangen',
	'Plugins' => 'Plugins',
	'Import Entries' => 'Berichten importeren',
	'Export Entries' => 'Berichten exporteren',
	'Export Theme' => 'Thema exporteren',
	'Backup' => 'Backup',
	'Restore' => 'Restore',
	'Address Book' => 'Adresboek',
	'Activity Log' => 'Activiteitenlog',
	'Asset' => 'Mediabestand',
	'Website' => 'Website',
	'Profile' => 'Profiel',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fout bij het toekennen van reactierechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'.  Er werd geen geschikte reageerder-rol gevonden.',
	'Cannot load blog #[_1].' => 'Kan blog #[_1] niet laden',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ongeldige aanmeldpoging van een reageerder [_1] op blog [_2](ID: [_3]) waar geenMovable Type native authenticatie is toegelaten.',
	'Invalid login.' => 'Ongeldige gebruikersnaam.',
	'Invalid login' => 'Ongeldige gebruikersnaam',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'U bent met succes aangemeld, maar registratie is niet toegestaan op dit moment.  Gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'You need to sign up first.' => 'U moet zich eerst registreren',
	'The login could not be confirmed because of a database error ([_1])' => 'Het aanmelden kon niet worden bevestigd wegens een databaseprobleem ([_1])',
	'Permission denied.' => 'Toestemming geweigerd.',
	'Login failed: permission denied for user \'[_1]\'' => 'Aanmelden mislukt: permissie geweigerd aan gebruiker \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Aanmelden mislukt: fout in wachtwoord van gebruiker \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Mislukte poging tot aanmelden door uitgeschakelde gebruiker \'[_1]\'',
	'Failed login attempt by unknown user \'[_1]\'' => 'Mislukte poging tot aanmelden door onbekende gebruiker \'[_1]\'',
	'Signing up is not allowed.' => 'Registreren is niet toegestaan.',
	'Movable Type Account Confirmation' => 'Movable Type accountbevestiging',
	'Your confirmation has expired. Please register again.' => 'Uw bevestigingsperiode is afgelopen.  Gelieve opnieuw te registreren.',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Terugkeren naar de oorspronkelijke pagina.</a>',
	'Your confirmation have expired. Please register again.' => 'Uw bevestiging is verlopen.  Gelieve opnieuw te registeren.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Reageerder \'[_1]\' (ID:[_2]) heeft zich met succes geregistreerd.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden om te reageren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] registreerde zich op blog \'[_2]\'',
	'No id' => 'Geen id',
	'No such comment' => 'Reactie niet gevonden',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
	'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
	'No entry_id' => 'Geen entry_id',
	'No such entry \'[_1]\'.' => 'Geen bericht \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'U heeft in een korte periode te veel reacties achtergelaten.  Gelieve over enige tijd opnieuw te proberen.',
	'Comments are not allowed on this entry.' => 'Reacties op dit bericht zijn niet toegelaten.',
	'Comment text is required.' => 'Tekst van de reactie is verplicht.',
	'An error occurred: [_1]' => 'Er deed zich een probleem voor: [_1]',
	'Registration is required.' => 'Registratie is verplicht.',
	'Name and E-mail address are required.' => 'Naam en e-mail adres zijn vereist',
	'Invalid email address \'[_1]\'' => 'Ongeldig e-mail adres \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'Ongeldige URL \'[_1]\'',
	'Text entered was wrong.  Try again.' => 'De ingevoerde tekst was verkeerd.  Probeer opnieuw.',
	'Comment save failed with [_1]' => 'Opslaan van reactie mislukt met [_1]',
	'Comment on "[_1]" by [_2].' => 'Reactie op "[_1]" door [_2].',
	'Publishing failed: [_1]' => 'Publicatie mislukt: [_1]',
	'Cannot load template' => 'Kan sjabloon niet laden',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Mislukte poging om een reactie achter te laten van op registratie wachtende gebruiker \'[_1]\'',
	'Registered User' => 'Geregistreerde gebruiker',
	'Cannot load entry #[_1].' => 'Kan bericht #[_1] niet laden.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'U probeert om te leiden naar externe bronnen.  Als u de site vertrouwt, klik dan op de link: [_1]',
	'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
	'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
	'Invalid entry ID provided' => 'Ongeldig berichtID opgegeven',
	'For improved security, please change your password' => 'Gelieve uw wachtwoord te veranderen voor verhoogde veiligheid',
	'All required fields must be populated.' => 'Alle vereiste velden moeten worden ingevuld.',
	'[_1] contains an invalid character: [_2]' => '[_1] bevat een ongeldig karakter: [_2]',
	'Display Name' => 'Getoonde naam',
	'Passwords do not match.' => 'Wachtwoorden komen niet overeen.',
	'Failed to verify the current password.' => 'Bevestigen huidig wachtwoord mislukt.',
	'Email Address is invalid.' => 'E-mail adres is ongeldig.',
	'URL is invalid.' => 'URL is ongeldig.',
	'Commenter profile has successfully been updated.' => 'Reageerdersprofiel is met succes bijgewerkt.',
	'Commenter profile could not be updated: [_1]' => 'Reageerdersprofiel kon niet worden bijgewerkt: [_1]',

## lib/MT/App.pm
	'Problem with this request: corrupt character data for character set [_1]' => '¨Probleem met dit verzoek: corrupte karakterdata voor karakterset [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Fout bij het laden van website #[_1]',
	'First Weblog' => 'Eerste weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fout bij het laden van blog #[_1] tijdens gebruikersprovisie.  Controleer uw NewUserTemplateBlogId instelling.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Fout bij het aanmaken van een blog voor nieuwe gebruiker \'[_1]\' met blog #[_1] als sjabloonblog.',
	'Error provisioning blog for new user \'[_1]\' (ID: [_2]).' => 'Fout bij het aanmaken van een blog voor nieuwe gebruiker \'[_1]\' (ID: [_2]).',
	'Blog \'[_1]\' (ID: [_2]) for user \'[_3]\' (ID: [_4]) has been created.' => 'Blog \'[_1]\' (ID: [_2]) voor gebruiker \'[_3]\' (ID: [_4]) werd aangemaakt.',
	'Error assigning blog administration rights to user \'[_1]\' (ID: [_2]) for blog \'[_3]\' (ID: [_4]). No suitable blog administrator role was found.' => 'Fout bij het toekennen van blog administratierechten aan gebruiker \'[_1]\' (ID: [_2]) op blog \'[_3]\' (ID: [_4]).  Er werd geen geschikte blog administrator rol gevonden.',
	'Internal Error: Login user is not initialized.' => 'Interne fout: login gebruiker is niet geïnitialiseerd.',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Het spijt ons, maar u heeft geen toestemming om toegang te krijgen op blogs of websites van deze installatie.  Als u meent dat dit een fout is, gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Deze account werd gedeactiveerd.  Contacteer uw Movable Type systeembeheerder om toegang te krijgen.',
	'Failed login attempt by pending user \'[_1]\'' => 'Mislukte poging tot aanmelden van een gebruiker \'[_1]\' die nog gekeurd moet worden',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Deze account werd verwijderd.  Contacteer uw Movable Type systeembeheerder om toegang te krijgen.',
	'User cannot be created: [_1].' => 'Gebruiker kan niet worden aangemaakt: [_1].',
	'User \'[_1]\' has been created.' => 'Gebruiker \'[_1]\' is aangemaakt',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Onze verontschuldigingen, maar u heeft geen permissies om toegang te krijgen tot blogs of websites op deze installatie.  Als u dit bericht ten onrechte te zien krijgt, gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Gebruiker \'[_1]\' (ID:[_2]) met succes aangemeld',
	'Invalid login attempt from user \'[_1]\'' => 'Ongeldige poging tot aanmelden van gebruiker \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Gebruiker \'[_1]\' (ID:[_2]) werd afgemeld',
	'User requires password.' => 'Gebruiker heeft wachtwoord nodig.',
	'User requires display name.' => 'Gebruiker heeft getoonde naam nodig.',
	'Email Address is required for password reset.' => 'E-mail adres is vereist om wachtwoord opnieuw te kunnen instellen',
	'User requires username.' => 'Gebruiker heeft gebruikersnaam nodig.',
	'Username' => 'Gebruikersnaam',
	'A user with the same name already exists.' => 'Er bestaat al een gebruiker met die naam.',
	'An error occurred while trying to process signup: [_1]' => 'Er deed zich een fout voor bij het verwerken van de registratie: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nieuwe reactie achtergelaten op \'[_1]\'',
	'Close' => 'Sluiten',
	'Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive \'[_1]\': [_2]' => 'Openen monitoringbestand aangegeven via de IISFastCGIMonitoringFilePath directief mislukt \'[_1]\': [_2]',
	'Failed to open pid file [_1]: [_2]' => 'Openen pid bestand mislukt [_1]: [_2]',
	'Failed to send reboot signal: [_1]' => 'Sturen van reboot signaal mislukt: [_1]',
	'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
	'Unknown action [_1]' => 'Onbekende actie [_1]',
	'Warnings and Log Messages' => 'Waarschuwingen en logberichten',
	'Removed [_1].' => '[_1] verwijderd.',
	'You did not have permission for this action.' => 'U had geen permissie voor deze actie',

## lib/MT/App/Search/Legacy.pm
	'A search is in progress. Please wait until it is completed and try again.' => 'Een zoekopdracht is nog bezig.  Gelieve te wachten tot deze afgelopen is en probeer opnieuw.',
	'Search failed. Invalid pattern given: [_1]' => 'Zoeken mislukt. Ongeldig patroon opgegeven: [_1]',
	'Search failed: [_1]' => 'Zoeken mislukt: [_1]',
	'No alternate template is specified for template \'[_1]\'' => 'Geen alternatief sjabloon opgegeven voor sjabloon \'[_1]\'',
	'File not found: [_1]' => 'Bestand niet gevonden: [_1]',
	'Opening local file \'[_1]\' failed: [_2]' => 'Lokaal bestand \'[_1]\' openen mislukt: [_2]',
	'Publishing results failed: [_1]' => 'Publiceren van resultaten mislukt: [_1]',
	'Search: query for \'[_1]\'' => 'Zoeken: zoekopdracht voor \'[_1]\'',
	'Search: new comment search' => 'Zoeken: opnieuw zoeken in de reacties',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Ongeldig type: [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Cachen van zoekresultaten mislukt.  [_1] is niet beschikbaar: [_2]',
	'Invalid format: [_1]' => 'Ongeldig formaat: [_1]',
	'Unsupported type: [_1]' => 'Niet ondersteund type: [_1]',
	'Invalid query: [_1]' => 'Ongeldige zoekopdracht: [_1]',
	'Invalid archive type' => 'Ongelidg archieftype',
	'Invalid value: [_1]' => 'Ongeldige waarde: [_1]',
	'No column was specified to search for [_1].' => 'Geen kolom opgegeven om op te zoeken [_1].',
	'No such template' => 'Geen sjabloon gevonden',
	'template_id cannot refer to a global template' => 'template_id mag niet verwijzen naar een globaal sjabloon',
	'Output file cannot be of the type asp or php' => 'Uitvoerbestand mag niet van het type asp of php zijn',
	'You must pass a valid archive_type with the template_id' => 'U moet een geldig archieftype doorgeven via het template_id',
	'Template must be an entry_listing for non-Index archive types' => 'Sjabloon moet een entry_listing zijn voor niet-Index archieftypes',
	'Filename extension cannot be asp or php for these archives' => 'Bestandsnaamextensie mag niet asp of php zijn voor deze archieven',
	'Template must be a main_index for Index archive type' => 'Sjabloon moet een main_index zijn voor het Index archieftype',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'De zoekopdracht die u uitvoerde is over de tijdslimiet gegaan.  Gelieve uw zoekopdracht te vereenvoudigen en opnieuw te proberen.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch werkt met MT::App::Search.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'Ongeldig bericht-ID \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'U moet een pingsjabloon definiëren om pings te kunnen tonen.',
	'Trackback pings must use HTTP POST' => 'Trackback pings moeten HTTP POST gebruiken',
	'TrackBack ID (tb_id) is required.' => 'TrackBack ID (tb_id) is vereist.',
	'Invalid TrackBack ID \'[_1]\'' => 'Ongeldig TrackBack-ID \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'U heeft geen toestemming om TrackBack pings te versturen.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'U stuurt te veel TrackBack pings achter elkaar.  Gelieve later opnieuw te proberen.',
	'You need to provide a Source URL (url).' => 'U moet een Source URL (url) opgeven.',
	'This TrackBack item is disabled.' => 'Dit TrackBack item is uitgeschakeld.',
	'This TrackBack item is protected by a passphrase.' => 'Dit TrackBack item is beschermd door een wachtwoord.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack op "[_1]" van "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack op categorie \'[_1]\' (ID:[_2]).',
	'Cannot create RSS feed \'[_1]\': ' => 'Kan RSS feed \'[_1]\' niet aanmaken: ',
	'New TrackBack ping to \'[_1]\'' => 'Nieuwe TrackBack ping op \'[_1]\'',
	'New TrackBack ping to category \'[_1]\'' => 'Nieuwe TrackBack ping op categorie \'[_1]\'',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Kon niet aanmelden met de opgegeven gegevens: [_1].',
	'Both passwords must match.' => 'Beide wachtwoorden moeten overeen komen.',
	'You must supply a password.' => 'U moet een wachtwoord opgeven.',
	'The \'Website Root\' provided below is not allowed' => 'De \'Website Root\' die werd opgegeven hieronder is niet toegestaan',
	'The \'Website Root\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'De \'Website Root\' die werd opgegeven hieronder is niet beschrijfbaar door de webserver.  Verander de eigenaar of de permissies op deze map en klik dan opnieuw op de knop om de installatie af te werken.',
	'Invalid session.' => 'Ongeldige sessie.',
	'Invalid parameter.' => 'Ongeldige parameters',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Geen permissies.  Gelieve uw Movable Type administrator te contacteren voor hulp met het upgraden van Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type is bijgewerkt tot versie [_1]',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'De [_1] driver is vereist om [_2] te kunnen gebruiken.',
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Er deed zich een probleem voor bij het verbinden met de database.  Controleer de instellingen en probeer opnieuw.',
	'Please select a database from the list of available databases and try again.' => 'Gelieve een database te selecteren uit de lijst met beschikbare databases en probeer opnieuw.',
	'SMTP Server' => 'SMTP server',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test e-mail van de Movable Type Configuratiewizard',
	'This is the test email sent by your new installation of Movable Type.' => 'Dit is de test e-mail verstuurd door uw nieuwe installatie van Movable Type.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP is vereist om mail te kunnen versturen via een SMTP server.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Deze module is vereist als u speciale karacters wenst te encoderen, maar deze optie kan worden uitgeschakeld door de NoHTMLEntities optie te gebruiken in mt-config.cgi',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Deze module is vereist als u de MT XML-RPC server implementatie wenst te gebruiken.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Deze module is vereist als u bestaande bestanden wenst te kunnen overschrijven bij het opladen.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Deze module is vereist als u graag thumbnailveries van opgeladen bestanden wenst te kunnen aanmaken.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Deze module is vereist als u NetPBM wenst te gebruiken als driver voor afbeeldingen met MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Deze module is vereist door bepaalde MT plugins beschikbaar bij derden.',
	'This module accelerates comment registration sign-ins.' => 'Deze module versnelt aanmeldingen om te kunnen reageren.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.' => 'Cache::File is vereist als u reageerders wenst toe te staan zich aan te melden met de OpenID van Yahoo! Japan.',
	'This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.' => 'Deze module is vereist als u registratie wenst in te schakelen voor reacties en ook om mail te kunnen versturen via een SMTP server.',
	'This module enables the use of the Atom API.' => 'Deze module maakt het mogelijk de Atom API te gebruiken.',
	'This module is required in order to use memcached as caching mechanism used by Movable Type.' => 'Deze module is vereist om memcached als cachemechanisme voor Movable Type te kunnen gebruiken.',
	'This module is required in order to archive files in backup/restore operation.' => 'Deze module is vereist om bestanden te archiveren bij backup/restore operaties.',
	'This module is required in order to compress files in backup/restore operation.' => 'Deze module is vereist om bestanden te comprimeren bij backup/restore operaties.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Deze module is vereist om bestanden te decomprimeren bij backup/restore operaties.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Deze module en de modules waar ze van afhangt zijn vereisten om te kunen restoren uit een backup.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Deze module en de modules waar ze van afhangt zijn nodig om reageerders zichzelf te laten authenticeren via OpenID providers waaronder LiveJournal.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Deze module wordt vereist door mt-search.cgi als u Movable Type draait op een Perl versie ouder dan 5.8',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX is optioneel; Het is één van de vereiste modules om een backup terug te zetten die aangemaakt werd bij een backup/restore operatie.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck is optioneel; Het is een beter, sneller en lichter alternatief voor YAML::Tiny bij het behandelen van YAML bestanden.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Deze module is vereist om bestande te kunnen opladen (om het formaat van afbeeldingen in vele verschillende formaten te kunnen bepalen).',
	'This module is required for cookie authentication.' => 'Deze module is vereist voor cookie-authenticatie.',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'per auteur per dag',
	'author/author-basename/yyyy/mm/dd/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/dd/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'per auteur per maand',
	'author/author-basename/yyyy/mm/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'per auteur',
	'author/author-basename/index.html' => 'auteur/auteur-basisnaam/index.html',
	'author/author_basename/index.html' => 'auteur/auteur_basisnaam/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'per auteur per week',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'auteur/auteur-basisnaam/yyyy/mm/dag-week/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'auteur/auteur_basisnaam/yyyy/mm/dag-week/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'per auteur per jaar',
	'author/author-basename/yyyy/index.html' => 'auteur/auteur-basisnaam/yyyy/index.html',
	'author/author_basename/yyyy/index.html' => 'auteur/auteur_basisnaam/yyyy/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'per categorie per dag',
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sub-categorie/jjjj/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sub_categorie/jjjj/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'per categorie per maand',
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sub-categorie/jjjj/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sub_categorie/jjjj/mm/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'per categorie',
	'category/sub-category/index.html' => 'categorie/sub-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sub_categorie/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'per categorie per week',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sub-categorie/jjjj/mm/dag-week/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sub_categorie/jjjj/mm/dag-week/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'per categorie per jaar',
	'category/sub-category/yyyy/index.html' => 'categorie/sub-categorie/jjjj/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sub_categorie/jjjj/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'per dag',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/dd/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'per bericht',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/basisnaam-bericht.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/basisnaam_bericht.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/basisnaam-bericht/index.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/basisnaam_bericht/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/dd/basisnaam-bericht.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/dd/basisnaam_bericht.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/dd/basisnaam-bericht/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/dd/basisnaam_bericht/index.html',
	'category/sub-category/entry-basename.html' => 'categorie/sub-categorie/basisnaam-bericht.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sub-categorie/basisnaam-bericht/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sub_categorie/basisnaam_bericht.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sub_categorie/basisnaam_bericht/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'per maand',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'per pagina',
	'folder-path/page-basename.html' => 'map-pad/basisnaam-pagina.html',
	'folder-path/page-basename/index.html' => 'map-pad/basisnaam-pagina/index.html',
	'folder_path/page_basename.html' => 'map_pad/basisnaam_pagina.html',
	'folder_path/page_basename/index.html' => 'map_pad/basisnaam_pagina/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'per week',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/dag-week/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'per jaar',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Afbeeldingen',
	'Actual Dimensions' => 'Echte afmetingen',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	'Error cropping image: [_1]' => 'Fout bij het bijsnijden van de afbeelding: [_1]',
	'Error scaling image: [_1]' => 'Fout bij het schalen van de afbeelding: [_1]',
	'Error converting image: [_1]' => 'Fout bij conversie afbeelding: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fout bij het aanmaken van een thumbnail-bestand: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Cannot load image #[_1]' => 'Kan afbeelding niet laden #[_1]',
	'View image' => 'Afbeelding bekijken',
	'Permission denied setting image defaults for blog #[_1]' => 'Permissie geweigerd om de standaardinstellingen voor afbeeldingen te wijzigen voor blog #[_1]',
	'Thumbnail image for [_1]' => 'Miniatuurweergave voor [_1]',
	'Saving [_1] failed: [_2]' => 'Opslaan van [_1] mislukt: [_2]',
	'Invalid basename \'[_1]\'' => 'Ongeldige basisnaam \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Fout bij schrijven naar \'[_1]\': [_2]',
	'Popup page for [_1]' => 'Popup pagina voor [_1]',
	'Scaling image failed: Invalid parameter.' => 'Schalen van de afbeelding mislukt: ongeldige parameter.',
	'Cropping image failed: Invalid parameter.' => 'Bijsnijden van de afbeelding mislukt: ongeldige parameter.',
	'Rotating image failed: Invalid parameter.' => 'Draaien van de afbeelding mislukt: ongeldige parameter.',
	'Writing metadata failed: [_1]' => 'Schrijven van metadata mislukt: [_1]',
	'Error writing metadata to \'[_1]\': [_2]' => 'Fout bij schrijven van metadata naar  \'[_1]\': [_2]',
	'Extracting image metadata failed: [_1]' => 'Extractie van metadata uit de afbeelding mislukt: [_1]',
	'Writing image metadata failed: [_1]' => 'Schrijven van metadata van de afbeelding mislukt: [_1]',

## lib/MT/Asset.pm
	'Deleted' => 'Verwijderd',
	'Enabled' => 'Ingeschakeld',
	'Disabled' => 'Uitgeschakeld',
	'missing' => 'ontbrekend',
	'extant' => 'bestaand',
	'Assets with Missing File' => 'Mediabestanden met ontbrekend bestand',
	'Assets with Extant File' => 'Mediabestanden met bestaand bestand',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Kon mediabestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Description' => 'Beschrijving',
	'Location' => 'Locatie',
	'Could not create asset cache path: [_1]' => 'Kon cachepad voor mediabestand niet aanmaken [_1]',
	'string(255)' => 'string(255)',
	'Label' => 'Naam',
	'Type' => 'Type',
	'Filename' => 'Bestandsnaam',
	'File Extension' => 'Bestandsextensie',
	'Pixel width' => 'Breedte in pixels',
	'Pixel height' => 'Hoogte in pixels',
	'Except Userpic' => 'Uitgezonderd gebruikersafbeelding',
	'Author Status' => 'Status auteur',
	'Missing File' => 'Ontbrekend bestand',
	'Assets of this website' => 'Mediabestanden van deze website',

## lib/MT/Asset/Video.pm
	'Videos' => 'Video\'s',

## lib/MT/Association.pm
	'Association' => 'Associatie',
	'Associations' => 'Associaties',
	'Permissions with role: [_1]' => 'Permissies met rol: [_1]',
	'Permissions for [_1]' => 'Permissies voor [_1]',
	'association' => 'associatie',
	'associations' => 'associaties',
	'User Name' => 'Gebruikersnaam',
	'Role' => 'Rol',
	'Role Name' => 'Naam rol',
	'Role Detail' => 'Details rol',
	'Website/Blog Name' => 'Website/Blognaam',
	'__WEBSITE_BLOG_NAME' => 'Website/Blognaam',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: Berichten',
	'Invalid blog ID \'[_1]\'' => 'Ongeldig blog ID \'[_1]\'',
	'PreSave failed [_1]' => 'PreSave mislukt [_1]',
	'Removing stats cache failed.' => 'Verwijderen statistiekencache mislukt.',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) voegde [lc,_4] #[_3] toe',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) bewerkte [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Bericht \'[_1]\' ([lc,_5] #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) via de ATOM API',
	'\'[_1]\' is not allowed to upload by system settings.: [_2]' => '\'[_1]\' heeft volgens systeeminstellingen geen toelating om te uploaden.: [_2]',
	'Invalid image file format.' => 'Ongeldig afbeeldingsbestandsformaat',
	'Cannot make path \'[_1]\': [_2]' => 'Kan pad \'[_1]\' niet aanmaken: [_2]',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Perl module Image::Size is vereist om de hoogte en breedte te kunnen bepalen van geuploade bestanden.',

## lib/MT/Auth/MT.pm
	'Missing required module' => 'Ontbrekende vereiste module',

## lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'Kon de sessie niet opslaan',
	'Could not load Net::OpenID::Consumer.' => 'Kon Net::OpenID::Consumer niet laden.',
	'The address entered does not appear to be an OpenID endpoint.' => 'Het adres dat werd ingevuld lijkt geen OpenID endpoint te zijn.',
	'The text entered does not appear to be a valid web address.' => 'De ingevulde tekst lijkt geen geldig webadres te zijn.',
	'Unable to connect to [_1]: [_2]' => 'Kon niet verbinden met [_1]: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'Kon de opgegeven OpenID niet verifiëren: [_1]',

## lib/MT/Author.pm
	'Users' => 'Gebruikers',
	'Active' => 'Actief',
	'Pending' => 'In afwachting',
	'Not Locked Out' => 'Niet geblokkeerd',
	'Locked Out' => 'Geblokkeerd',
	'__COMMENTER_APPROVED' => 'Goedgekeurd',
	'Banned' => 'Uitgesloten',
	'MT Users' => 'MT gebruikers',
	'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden opgeslagen: [_1]',
	'Userpic' => 'Foto gebruiker',
	'User Info' => 'Gebruikersinformatie',
	'__ENTRY_COUNT' => 'Berichten',
	'__COMMENT_COUNT' => 'Reacties',
	'Created by' => 'Aangemaakt door',
	'Status' => 'Status',
	'Website URL' => 'URL website',
	'Privilege' => 'Privilege',
	'Lockout' => 'Blokkering',
	'Enabled Users' => 'Ingeschakelde gebruikers',
	'Disabled Users' => 'Uitgeschakelde gebruikers',
	'Pending Users' => 'Te keuren gebruikers',
	'Locked out Users' => 'Geblokkeerde gebruikers',
	'Enabled Commenters' => 'Actieve reageerders',
	'Disabled Commenters' => 'Gedesactiveerde reageerders',
	'Pending Commenters' => 'Reageerders in aanvraag',
	'MT Native Users' => 'Lokale MT gebruikers',
	'Externally Authenticated Commenters' => 'Extern geauthenticeerde reageerders',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Foute AuthenticationModule configuratie \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Foute AuthenticationModule configuratie',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'Aanmelden vereist een beveiligde handtekening.',
	'The sign-in validation failed.' => 'Validatie van het aanmelden mislukt.',
	'This weblog requires commenters to pass an email address. If you would like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Deze blog vereist dat reageerders een email adres achterlaten.  Als u dit wenst te doen, kunt u opnieuw aanmelden en de authenticatieservice toestemming geven om uw email adres te delen.',
	'Could not get public key from the URL provided.' => 'Kon de publieke sleutel niet uit de ingevulde URL afleiden.',
	'No public key could be found to validate registration.' => 'Er kon geen publieke sleutel gevonden worden om de registratie te valideren.',
	'TypePad signature verification returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypePad signatuurverificatie retourneerde [_1] in [_2] seconden bij het verifiëren van [_3] met [_4].',
	'VALID' => 'GELDIG',
	'INVALID' => 'ONGELDIG',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct.' => 'De TypePad signatuur is verlopen ([_1] seconden oud).  Controleer of de klok op uw server juist staat.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'The uploaded file was not a valid Movable Type backup manifest file.' => 'Het bestand dat werd geupload is geen geldig Movable Type manifest bestand.',
	'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.' => 'Het manifestbestand dat werd geupload werd aangemaakt met Movable Type, maar de schemaversie ([_1]) is anders dan die op dit systeem wordt gebruikt ([_2]).',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] is geen item dat door Movable Type teruggezet moet worden.',
	'[_1] records restored.' => '[_1] records teruggezet.',
	'Restoring [_1] records:' => '[_1] records aan het terugzetten:',
	'A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.' => 'Een gebruiker met dezelfde naam als de huidige gebruiker ([_1]) werd gevonden in de backup.  Dit record wordt overgeslagen.',
	'A user with the same name \'[_1]\' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.' => 'Een gebruiker met dezelfde naam \'[_1]\' werd gevonden in de backup (ID:[_2]).  Restore verving de gegevens van deze gebruiker met die uit de backup.',
	'Invalid serializer version was specified.' => 'Ongeldige serialisatieverie opgegeven.',
	'Tag \'[_1]\' exists in the system.' => 'Tag \'[_1]\' bestaat in het systeem.',
	'[_1] records restored...' => '[_1] records teruggezet...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'De rol \'[_1]\' werd hernoemd naar \'[_2]\' omdat een rol met die naam al bestond.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => 'De instellingen op systeemniveau voor plugin \'[_1]\' bestaan al.  Record wordt overgeslagen.',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot restore requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Kan dit bestand niet terugzetten omdat hiervoor de Digest::SHA Perl module vereist is.  Neem contact op met uw Movable Type systeembeheerder.',
	'Cannot restore requested file because a website was not found in either the existing Movable Type system or the backup data. A website must be created first.' => 'Kan het gevraagde bestand niet terugzetten omdat er geen website gevonden werd in het bestaande Movable Type systeem of in de backup gegevens.  Gelieve eerst een website aan te maken.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "
Kan bestand niet schrijven.  Schijf vol.",
	'Backing up [_1] records:' => 'Er worden [_1] records gebackupt:',
	'[_1] records backed up...' => '[_1] records gebackupt...',
	'[_1] records backed up.' => '[_1] records gebackupt.',
	'There were no [_1] records to be backed up.' => 'Er waren geen [_1] records om te backuppen.',
	'Cannot open directory \'[_1]\': [_2]' => 'Kan map \'[_1]\' niet openen: [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Er werd geen manifest-bestand gevonden in de importdirectory [_1].',
	'Cannot open [_1].' => 'Kan [_1] niet openen.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-bestand [_1] was geen geldig Movable Type backup manifest-bestand.',
	'Manifest file: [_1]' => 'Manifestbestand: [_1]',
	'Path was not found for the file, [_1].' => 'Pad niet gevonden voor bestand, [_1]',
	'[_1] is not writable.' => '[_1] is niet beschrijfbaar.',
	'Error making path \'[_1]\': [_2]' => 'Fout bij aanmaken pad \'[_1]\': [_2]',
	'Copying [_1] to [_2]...' => 'Bezig [_1] te copiëren naar [_2]...',
	'Failed: ' => 'Mislukt: ',
	'Done.' => 'Klaar.',
	'Restoring asset associations ... ( [_1] )' => 'Associaties met mediabestanden aan het terugzetten ... ( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'Associaties met mediabestanden aan het terugzetten in bericht ... ( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'Associaties met mediabestanden aan het terugzetten in pagina... ( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'URL van de mediabestanden aan het terugzetten ( [_1] )...',
	'Restoring url of the assets in entry ( [_1] )...' => 'URL van de mediabestanden aan het terugzetten in bercht ( [_1] )...',
	'Restoring url of the assets in page ( [_1] )...' => 'URL van de mediabestanden aan het terugzetten in pagina ( [_1] )...',
	'ID for the file was not set.' => 'ID van het bestand was niet ingesteld.',
	'The file ([_1]) was not restored.' => 'Het bestand ([_1]) werd niet teruggezet.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Pad voor bestand \'[_1]\' (ID:[_2]) wordt aangepast...',
	'failed' => 'mislukt',
	'ok' => 'ok',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Blog.pm
	'*Website/Blog deleted*' => '*Website/Blog verwijderd*',
	'First Blog' => 'Eerste weblog',
	'No default templates were found.' => 'Er werden geen standaardsjablonen gevonden.',
	'Clone of [_1]' => 'Kloon van [_1]',
	'Cloned blog... new id is [_1].' => 'Blog gekloond... nieuw ID is [_1]',
	'Cloning permissions for blog:' => 'Permissies worden gekloond voor blog:',
	'[_1] records processed...' => '[_1] items verwerkt...',
	'[_1] records processed.' => '[_1] items verwerkt.',
	'Cloning associations for blog:' => 'Associaties worden gekloond voor blog:',
	'Cloning entries and pages for blog...' => 'Berichten en pagina\'s worden gekloond voor blog...',
	'Cloning categories for blog...' => 'Categorieën worden gekloond voor blog...',
	'Cloning entry placements for blog...' => 'Berichtcategorieën wordt gekloond voor blog...',
	'Cloning comments for blog...' => 'Reacties worden gekloond voor blog...',
	'Cloning entry tags for blog...' => 'Berichttags worden gekloond voor blog...',
	'Cloning TrackBacks for blog...' => 'Trackbacks worden gekloond voor blog...',
	'Cloning TrackBack pings for blog...' => 'TrackBack pings worden gekloond voor blog...',
	'Cloning templates for blog...' => 'Sjablonen worden gekloond voor blog...',
	'Cloning template maps for blog...' => 'Sjabloonkoppelingen worden gekloond voor blog...',
	'Failed to load theme [_1]: [_2]' => 'Laden van thema [_1] mislukt: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Toepassen van thema [_1] mislukt: [_2]',
	'__PAGE_COUNT' => 'Pagina\'s',
	'__ASSET_COUNT' => 'Mediabestanden',
	'Members' => 'Leden',
	'Theme' => 'Thema',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Er deed zich een fout voor: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> op regel [_2] is niet herkend',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> zonder </[_1]> op regel #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> zonder </[_1]> op regel [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> zonder </[_1]> op regel [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Fout in <mt[_1]> tag: [_2]',
	'Unknown tag found: [_1]' => 'Onbekende tag gevonden: [_1]',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,bericht,berichten,Geen berichten]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,pagina,pagina\'s,geen pagina\'s]',
	'Categories must exist within the same blog' => 'Categorieën moeten bestaan binnen dezelfde blog',
	'Category loop detected' => 'Categorielus gedetecteerd',
	'string(100) not null' => 'string(100) not null',
	'Basename' => 'Basisnaam',
	'Parent' => 'Ouder',

## lib/MT/CMS/AddressBook.pm
	'No entry ID was provided' => 'Geen bericht ID opgegeven',
	'No such entry \'[_1]\'' => 'Geen bericht \'[_1]\'',
	'No valid recipients were found for the entry notification.' => 'Geen geldige ontvangers gevonden voor notificatie bericht.',
	'[_1] Update: [_2]' => '[_1] update: [_2]',
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Fout bij versturen mail ([_1]): een andere MailTransfer instelling proberen?',
	'Please select a blog.' => 'Gelieve een blog te selecteren.',
	'The text you entered is not a valid email address.' => 'De tekst die u invul is geen geldig email adres.',
	'The text you entered is not a valid URL.' => 'De tekst die u invulde is geen geldige URL.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Het e-mail adres dat u opgaf staat al op de notificatielijst van deze weblog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonnee \'[_1]\' (ID:[_2]) verwijderd uit adresboek door \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(gebruiker verwijderd)',
	'Files' => 'Bestanden',
	'Extension changed from [_1] to [_2]' => 'Extensie veranderd van [_1] in [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Aanmaken thumbnailbestand mislukt omdat [_1] dit afbeeldingstype niet aankan.',
	'Upload File' => 'Opladen',
	'Invalid Request.' => 'Ongeldig verzoek.',
	'File with name \'[_1]\' already exists. Upload has been cancelled.' => 'Bestand met de naam \'[_1]\' bestaat al. Upload geannuleerd.',
	'Cannot load file #[_1].' => 'Kan bestand niet laden #[_1].',
	'No permissions' => 'Geen permissies',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Bestand \'[_1]\' opgeladen door \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bestand \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Untitled' => 'Zonder titel',
	'Archive Root' => 'Archiefroot',
	'Site Root' => 'Siteroot',
	'basename of user' => 'basisnaam van gebruiker',
	'<[_1] Root>' => '<[_1] Root>',
	'<[_1] Root>/[_2]' => '<[_1] Root>/[_2]',
	'Archive' => 'Archief',
	'Custom...' => 'Gepersonaliseerd...',
	'Please select a file to upload.' => 'Gelieve een bestand te selecteren om te uploaden.',
	'Invalid filename \'[_1]\'' => 'Ongeldige bestandsnaam \'[_1]\'',
	'Please select an audio file to upload.' => 'Gelieve een audiobestand te selecteren om te uploaden.',
	'Please select an image to upload.' => 'Gelieve een afbeelding te selecteren om te uploaden.',
	'Please select a video to upload.' => 'Gelieve een videobestand te selecteren om te uploaden.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type kon niet schrijven naar de "Upload bestemming".  Controleer of de webserver schrijfrechten heeft op deze map.',
	'Invalid extra path \'[_1]\'' => 'Ongeldig extra pad \'[_1]\'',
	'Invalid temp file name \'[_1]\'' => 'Ongeldige naam voor temp bestand \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Fout bij openen van \'[_1]\': [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Fout bij wissen van \'[_1]\': [_2]',
	'File with name \'[_1]\' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)' => 'Bestand met de naam \'[_1]\' bestaat al.  (Installeer de File::Temp perl module als u bestaande geuploade bestanden wenst te kunnen overschrijven.)',
	'Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently \'[_1]\'. ' => 'Fout bij aanmaken tijdelijk bestand; De webserver zou moeten kunnen schrijven naar deze map.  Controleer de TempDir instelling in uw configuratiebestand, het is momenteel \'[_1]\'.',
	'unassigned' => 'niet toegewezen',
	'File with name \'[_1]\' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]' => 'Bestand met de naam \'[_1]\' bestaat al; Probeerde een tijdelijk bestand te schrijven maar de webserver kon het niet openen: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Kon geen upload pad \'[_1]\' aanmaken: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Fout bij schrijven van upload naar \'[_1]\': [_2]',
	'Uploaded file is not an image.' => 'Geupload bestand is geen afbeelding.',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Kan geen bestaand bestand overschrijven met een bestand van een ander type.  Origineel: [_1] Geupload: [_2]',
	'File with name \'[_1]\' already exists.' => 'Bestand met de naam \'[_1]\' bestaat al.',
	'Cannot load asset #[_1].' => 'Kan mediabestand #[_1] niet laden.',
	'Save failed: [_1]' => 'Opslaan mislukt: [_1]',
	'Saving object failed: [_1]' => 'Object opslaan mislukt: [_1]',
	'Transforming image failed: [_1]' => 'Transformeren afbeelding mislukt: [_1]',
	'Cannot load asset #[_1]' => 'Kan mediabestand #[_1] niet laden',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'U vulde geen IP adres in om te verbannen.',
	'The IP you entered is already banned for this blog.' => 'Het IP adres dat u opgaf is al verbannen van deze weblog.',

## lib/MT/CMS/Blog.pm
	q{Cloning blog '[_1]'...} => q{Bezit blog '[_1]' te klonen...},
	'Error' => 'Fout',
	'Finished!' => 'Klaar!',
	'General Settings' => 'Algemene instellingen',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Deze instellingen worden overroepen door een instelling het het MT configuratiebestand: [_1].  Verwijder de waarde uit het configuratiebestand om deze hier te kunnen beheren.',
	'Plugin Settings' => 'Instellingen plugins',
	'New Blog' => 'Nieuwe blog',
	'Cannot load template #[_1].' => 'Kan sjabloon #[_1] niet laden.',
	'index template \'[_1]\'' => 'indexsjabloon \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'Publish Site' => 'Site publiceren',
	'Invalid blog' => 'Ongeldige blog',
	'Select Blog' => 'Selecteer blog',
	'Selected Blog' => 'Geselecteerde blog',
	'Type a blog name to filter the choices below.' => 'Typ de naam van een weblog in om de onderstaande keuzes te filteren.',
	'Blog Name' => 'Blognaam',
	'The \'[_1]\' provided below is not writable by the web server. Change the directory ownership or permissions and try again.' => 'De \'[_1]\' die hieronder is opgegeven is niet beschrijfbaar door de webserver.  Wijzig de eigenaar van de map of de permissies en probeer opnieuw.',
	'Blog Root' => 'Blogroot',
	'Website Root' => 'Website root',
	'Saving permissions failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
	'[_1] changed from [_2] to [_3]' => '[_1] veranderd van [_2] naar [_3]',
	'Saved [_1] Changes' => '[_1] wijzigingen opgeslagen',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) aangemaakt door \'[_4]\'',
	'You did not specify a blog name.' => 'U gaf geen weblognaam op.',
	'Site URL must be an absolute URL.' => 'Site URL moet eenn absolute URL zijn.',
	'Archive URL must be an absolute URL.' => 'Archief URL moet een absolute URL zijn.',
	'You did not specify an Archive Root.' => 'U gaf geen archiefroot op.',
	'The number of revisions to store must be a positive integer.' => 'Het aantal revisies dat moet worden bewaard moet een positieve integer zijn.',
	'Please choose a preferred archive type.' => 'Gelieve een voorkeursarchieftype te kiezen.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Saving blog failed: [_1]' => 'Blog opslaan mislukt: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kan niet schrijven in de sjablooncache map. Gelieve de permissies na te kijken van de map met de naam <code>[_1]</code> onder de map van uw weblog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kon geen map maken om uw dynamische sjablonen in te cachen. U moet een map aanmaken met de naam <code>[_1]</code> onder de map van uw weblog.',
	'No blog was selected to clone.' => 'U selecteerde geen blog om te klonen.',
	'This action can only be run on a single blog at a time.' => 'Deze actie kan maar op één blog tegelijk worden uitgevoerd.',
	'Invalid blog_id' => 'Ongeldig blog_id',
	'This action cannot clone website.' => 'Deze actie kan geen website klonen.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Berichten moeten worden gekloond als reacties en trackbacs gekloond worden',
	'Entries must be cloned if comments are cloned' => 'Berichten moeten worden gekloond als reacties gekloond worden',
	'Entries must be cloned if trackbacks are cloned' => 'Berichten moeten worden gekloond als trackbacks gekloond worden',
	'\'[_1]\' (ID:[_2]) has been copied as \'[_3]\' (ID:[_4]) by \'[_5]\' (ID:[_6]).' => '\'[_1]\' (ID:[_2]) werd gekopiëerd als \'[_3]\' (ID:[_4]) door \'[_5]\' (ID:[_6]).', # Translate - New

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => 'De [_1] moet nog een naam krijgen!',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Kon [_1] niet bijwerken: Sommige [_2] werden gewijzigd sinds u deze pagina opende.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Probeerde [_1]([_2]) bij te werken, maar het object werd niet gevonden.',
	'[_1] order has been edited by \'[_2]\'.' => '_1] volgorde werd aangepast door \'[_2]\'.', # Translate - New
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Uw wijzigingen werden aangebracht ([_1] toegevoegd, [_2] aangepast en [_3] verwijderd). <a href="#" onclick="[_4]" class="mt-rebuild">Publiceer uw site</a> om deze wijzigingen zichtbaar te maken.',
	'Add a [_1]' => 'Voeg een [_1] toe',
	'No label' => 'Geen label',
	'The category name cannot be blank.' => 'De naam van de categorie mag niet leeg zijn.',
	'Permission denied: [_1]' => 'Toestemming geweigerd: [_1]',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met de naam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Categoriebasisnaam \'[_1]\' conflicteert met de basisnaam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke basisnaam hebben.',
	'The name \'[_1]\' is too long!' => 'De naam \'[_1]\' is te lang!',
	'Category \'[_1]\' created by \'[_2]\'.' => 'Categorie \'[_1]\' aangemaakt door \'[_2]\'.', # Translate - New
	'Category \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) bewerkt door \'[_3]\'', # Translate - New
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Reactie bewerken',
	'(untitled)' => '(geen titel)',
	'No such commenter [_1].' => 'Geen reageerder [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status VERTROUWD.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' verbande reageerder \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' maakte de verbanning van reageerder \'[_2]\' ongedaan.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status NIET VERTROUWD.',
	'The parent comment id was not specified.' => 'Het ID van de ouder van de reactie werd niet opgegeven.',
	'The parent comment was not found.' => 'De ouder-reactie werd niet gevonden.',
	'You cannot reply to unapproved comment.' => 'U kunt niet antwoorden op een niet-gekeurde reactie.',
	'You cannot create a comment for an unpublished entry.' => 'U kunt geen reactie aanmaken op een ongepubliceerd bericht.',
	'You cannot reply to unpublished comment.' => 'U kunt niet reageren op een niet gepubliceerde reactie.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Reactie (ID:[_1]) door \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
	'You do not have permission to approve this trackback.' => 'U heeft geen permissie om deze trackback goed te keuren.',
	'The entry corresponding to this comment is missing.' => 'Het bericht waarbij deze reactie hoort, ontbreekt.',
	'You do not have permission to approve this comment.' => 'U heeft geen permissie om deze reactie goed te keuren.',
	'Orphaned comment' => 'Verweesde reactie',

## lib/MT/CMS/Common.pm
	'Invalid type [_1]' => 'Ongeldig type [_1]',
	'The Template Name and Output File fields are required.' => 'De velden sjabloonnaam en uitvoerbestand zijn verplicht.',
	'Invalid ID [_1]' => 'Ongeldig ID [_1]',
	'The blog root directory must be within [_1].' => 'De hoofdmap van de blog moet onder [_1] zitten.',
	'The website root directory must be within [_1].' => 'De hoofdmap van de website moet onder [_1] zitten.',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' bewerkte het sjabloon \'[_2]\' op blog \'[_3]\'',
	'\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' bewerkte het globale sjabloon \'[_2]\'',
	'Load failed: [_1]' => 'Laden mislukt: [_1]',
	'(no reason given)' => '(geen reden vermeld)',
	'Error occurred during permission check: [_1]' => 'Er deed zich een fout voor bij het controleren van de permissies: [_1]',
	'Invalid filter: [_1]' => 'Ongeldige filter: [_1]',
	'New Filter' => 'Nieuwe Filter',
	'__SELECT_FILTER_VERB' => 'is gelijk aan',
	'All [_1]' => 'Alle [_1]',
	'[_1] Feed' => '[_1] Feed',
	'Unknown list type' => 'Onbekend type lijst',
	'Invalid filter terms: [_1]' => 'Ongeldige filtertermen: [_1]',
	'An error occurred while counting objects: [_1]' => 'Er deed zich een fout voor bij het tellen van de objecten: [_1]',
	'An error occurred while loading objects: [_1]' => 'Er deed zich een fout voor bij het laden van de objecten: [_1]',
	'Removing tag failed: [_1]' => 'Tag verwijderen mislukt: [_1]',
	'Removing [_1] failed: [_2]' => 'Verwijderen van [_1] mislukt: [_2]',
	'System templates cannot be deleted.' => 'Systeemsjablonen kunnen niet worden verwijderd.',
	'The selected [_1] has been deleted from the database.' => 'Geselecteerde [_1] werd verwijderd uit de database.',
	'Saving snapshot failed: [_1]' => 'Snapshot opslaan mislukt: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog does not have a parent website.' => 'Fout: Deze blog heeft geen moederwebsite.',
	'Not configured' => 'Niet geconfigureerd',
	'Page Views' => 'pageviews',

## lib/MT/CMS/Entry.pm
	'*User deleted*' => '*Gebruiker verwijderd*',
	'New Entry' => 'Nieuw bericht',
	'New Page' => 'Nieuwe pagina',
	'Tag' => 'Tag',
	'Entry Status' => 'Status bericht',
	'Cannot load template.' => 'Kan sjabloon niet laden.',
	'Publish error: [_1]' => 'Publicatiefout: [_1]',
	'Unable to create preview files in this location: [_1]' => 'Kan geen voorbeeldbestanden aanmaken in deze locatie: [_1]',
	'New [_1]' => 'Nieuwe [_1]',
	'No such [_1].' => 'Geen [_1].',
	'This basename has already been used. You should use an unique basename.' => 'Deze basisnaam werd al gebruikt.  U moet een unieke basisnaam kiezen.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is nog geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren voor deze zijn ingesteld.',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; \'Gepubliceerd op\' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be real dates.' => 'Ongeldige datum \'[_1]\'; \'Gepubliceerd op\' datums moeten echte datums zijn.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be real dates.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten echte datums zijn.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be dates in the future.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten in de toekomst liggen.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be later than the corresponding \'Published on\' date.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten later zijn dan de corresponderende \'Gepubliceerd op\' datum.',
	'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; [_2] datums moeten volgend formaat hebben JJJJ-MM-DD UU:MM:SS.',
	'Invalid date \'[_1]\'; [_2] dates should be real dates.' => 'Ongeldige datum \'[_1]\'; [_2] datums moeten echte datums zijn.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be earlier than the corresponding \'Unpublished on\' date \'[_2]\'.' => 'Ongeldige datum \'[_1]\; Publicatiedatums moeten vallen voor de corresponderende \'Einddatum\' \'[_2]\'.',
	'authored on' => 'geschreven op',
	'modified on' => 'gewijzigd op',
	'Saving entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opslaan mislukt: [_2]',
	'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt en status aangepast van [_4] naar [_5] door gebruiker \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt door gebruiker \'[_4]\'',
	'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' mislukt: [_2]',
	'(user deleted - ID:[_1])' => '(gebruiker verwijderd - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost op [_2]</a> - Sleep deze link naar de werkbalk van uw browser en klik er op wanneer u een site bezoekt waar u over wil bloggen.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) toegevoegd door gebruiker \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) verwijderd door \'[_4]\'',
	'Need a status to update entries' => 'Status vereist om berichten bij te werken',
	'Need entries to update status' => 'Berichten nodig om status bij te werken',
	'One of the entries ([_1]) did not exist' => 'Een van de berichten ([_1]) bestond niet',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) status veranderd van [_4] naar [_5]',

## lib/MT/CMS/Export.pm
	'Loading blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_1]',
	'You do not have export permissions' => 'U heeft geen exportpermissies',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: Label is required.' => 'Filter opslaan mislukt: Label is vereist',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Filter opslaan mislukt: Label "[_1]" bestaat al.',
	'No such filter' => 'Onbestaande filter',
	'Permission denied' => 'Toestemming geweigerd',
	'Failed to save filter: [_1]' => 'Filter opslaan mislukt: [_1]',
	'Failed to delete filter(s): [_1]' => 'Filter(s) verwijderen mislukt: [_1]',
	'Removed [_1] filters successfully.' => 'Met succes [_1] filters verwijderd.',
	'[_1] ( created by [_2] )' => '[_1] ( aangemaakt door [_2] )',
	'(Legacy) ' => '(Verouderd)',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'De map \'[_1]\' conflicteert met een andere map. Mappen met dezelfde ouder moeten een unieke basisnaam hebben.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Map \'[_1]\' aangemaakt door \'[_2]\'',
	'Folder \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) bewerkt door \'[_3]\'', # Translate - New
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Importeren/exporteren',
	'You do not have import permission' => 'U heeft geen import-permissie',
	'You do not have permission to create users' => 'U heeft geen permissie om gebruikers aan te maken',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker die in uw weblog voorkomt.',
	'Importer type [_1] was not found.' => 'Importeertype [_1] niet gevonden.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Alle feedback',
	'Publishing' => 'Publicatie',
	'System Activity Feed' => 'Systeemactiviteit-feed',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Activiteitenlog van blog \'[_1]\' (ID:[_2]) leeggemaakt door \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Activiteitenlog leeggemaakt door \'[_1]\'',

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Fout bij opslaan plugin-instellingen: [_1]',
	'Plugin Set: [_1]' => 'Pluginset: [_1]',
	'Individual Plugins' => 'Individuele plugins',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Er werden geen [_1] gevonden die overeenkomen met de opgegeven criteria.',
	'Entry Body' => 'Berichttekst',
	'Extended Entry' => 'Uitgebreid bericht',
	'Keywords' => 'Trefwoorden',
	'Comment Text' => 'Tekst reactie',
	'IP Address' => 'IP adres',
	'Source URL' => 'Bron URL',
	'Page Body' => 'Romp van de pagina',
	'Extended Page' => 'Uitgebreide pagina',
	'Template Name' => 'Sjabloonnaam',
	'Text' => 'Tekst',
	'Linked Filename' => 'Naam gelinkt bestand',
	'Output Filename' => 'Naam uitvoerbestand',
	'Log Message' => 'Logbericht',
	'Site URL' => 'URL van de site',
	'Search & Replace' => 'Zoeken & vervangen',
	'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
	'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
	'Searched for: \'[_1]\' Replaced with: \'[_2]\'' => 'Gezocht naar: \'[_1]\' Vervangen door: \'[_2]\'',
	'[_1] \'[_2]\' (ID:[_3]) updated by user \'[_4]\' using Search & Replace.' => '[_1] \'[_2]\' (ID:[_3]) bijgewerkt door gebruiker \'[_4]\' via zoeken & vervangen.',

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Een nieuwe naam voor de tag moet worden opgegeven.',
	'No such tag' => 'Onbekende tag',
	'The tag was successfully renamed' => 'De tag werd met succes hernoemd',
	'Error saving entry: [_1]' => 'Fout bij opslaan bericht: [_1]',
	'Successfully added [_1] tags for [_2] entries.' => 'Voegde met succes [_1] tags toe voor [_2] berichten.',
	'Error saving file: [_1]' => 'Fout bij opslaan bestand: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',

## lib/MT/CMS/Template.pm
	'index' => 'index',
	'archive' => 'archief',
	'module' => 'module',
	'widget' => 'widget',
	'email' => 'e-mail',
	'backup' => 'backup',
	'system' => 'systeem',
	'One or more errors were found in this template.' => 'Er werden één of meer fouten gevonden in dit sjabloon.',
	'Unknown blog' => 'Onbekende blog',
	'One or more errors were found in the included template module ([_1]).' => 'Eén of meer fouten gevonden in de geïncludeerde sjabloonmodule ([_1]).',
	'Global Template' => 'Globaal sjabloon',
	'Invalid Blog' => 'Ongeldige blog',
	'Global' => 'Globaal',
	'You must specify a template type when creating a template' => 'U moet een sjabloontype opgeven bij het aanmaken van een sjabloon.',
	'Entry or Page' => 'Bericht of pagina',
	'New Template' => 'Nieuwe sjabloon',
	'No Name' => 'Geen naam',
	'Index Templates' => 'Indexsjablonen',
	'Archive Templates' => 'Archiefsjablonen',
	'Template Modules' => 'Sjabloonmodules',
	'System Templates' => 'Systeemsjablonen',
	'Email Templates' => 'E-mail sjablonen',
	'Template Backups' => 'Sjabloonbackups',
	'Cannot locate host template to preview module/widget.' => 'Kan geen gastsjabloon vinden om voorbeeld van module/widget in te bekijken.',
	'Cannot preview without a template map!' => 'Kan geen voorbeeld bekijken zonder sjabloonkoppeling',
	'Unable to create preview file in this location: [_1]' => 'Kon geen voorbeeldbestand maken op deze locatie: [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'staaltje, bericht, voorbeeld',
	'Populating blog with default templates failed: [_1]' => 'Inrichten van blog met standaard sjablonen mislukt: [_1]',
	'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
	'Cannot load templatemap' => 'Kan sjabloonmap niet laden',
	'Saving map failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'You should not be able to enter zero (0) as the time.' => 'Het mag niet mogelijk zijn om (0) in te vullen als de tijd.',
	'You must select at least one event checkbox.' => 'U moet minstens één gebeurtenis-vakje aankruisen.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Orphaned' => 'Verweesd',
	'Global Templates' => 'Globale sjablonen',
	' (Backup from [_1])' => ' (Backup van [_1])',
	'Error creating new template: ' => 'Fout bij aanmaken nieuw sjabloon: ',
	'Template Referesh' => 'Sjablonen verversen',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Sjabloon \'[_1]\' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Bezig sjabloon <strong>[_3]</strong> te verversen met <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Sjabloon \'[_1]\' wordt overgeslagen omdat het niet is veranderd.',
	'Copy of [_1]' => 'Kopie van [_1]',
	'Cannot publish a global template.' => 'Kan globaal sjabloon niet publiceren.',
	'Widget Template' => 'Widgetsjabloon',
	'Widget Templates' => 'Widgetsjablonen',
	'template' => 'sjabloon',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Thema niet gevonden',
	'Failed to uninstall theme' => 'Thema de-installeren mislukt',
	'Failed to uninstall theme: [_1]' => 'Thema de-installeren mislukt: [_1]',
	'Theme from [_1]' => 'Thema van [_1]',
	'Install into themes directory' => 'Installeren in thema-map',
	'Download [_1] archive' => 'Download [_1] archief',
	'Failed to load theme export template for [_1]: [_2]' => 'Laden exportsjabloon voor [_1] mislukt: [_2]',
	'Failed to save theme export info: [_1]' => 'Opslaan exportinfo van het thema mislukt: [_1]',
	'Themes directory [_1] is not writable.' => 'Themadirectory [_1] is niet beschrijfbaar.',
	'All themes directories are not writable.' => 'Alle themadirectories zijn niet beschrijfbaar.',
	'Error occurred during exporting [_1]: [_2]' => 'Fout bij het exporteren van [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Fout tijdens het finaliseren van [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Fout bij het publiceren van thema: [_1]',
	'Themes Directory [_1] is not writable.' => 'Themadirectory [_1] is niet beschrijfbaar.',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Wachtwoord terugvinden',
	'Email address is required for password reset.' => 'E-mail adres is vereist om wachtwoord opnieuw te kunnen instellen',
	'Invalid email address' => 'Ongeldig email adres',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Fout bij versturen e-mail ([_1]); Gelieve het probleem op te lossen en probeer dan opnieuw om uw wachtwoord te herstellen.',
	'Password reset token not found' => 'Wachtwoord reset token niet gevonden',
	'Email address not found' => 'E-mail adres niet gevonden',
	'User not found' => 'Gebruiker niet gevonden',
	'Your request to change your password has expired.' => 'Uw verzoek om uw wachtwoord aan te passen is verlopen',
	'Invalid password reset request' => 'Ongeldig verzoek om wachtwoord te veranderen',
	'Please confirm your new password' => 'Gelieve uw nieuwe wachtwoord te bevestigen',
	'Passwords do not match' => 'Wachtwoorden komen niet overeen',
	'That action ([_1]) is apparently not implemented!' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd!',
	'Error occurred while attempting to [_1]: [_2]' => 'Er deed zich een fout voor bij het [_1]: [_2]',
	'Please enter a valid email address.' => 'Gelieve een geldig e-mail adres op te geven.',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Er is geen systeem e-mailadres ingesteld.  Stel dit eerst in, sla het op en probeer dan de test e-mail opnieuw.',
	'Test email from Movable Type' => 'Test e-mail van Movable Type',
	'This is the test email sent by Movable Type.' => 'Dit is de test e-mail verstuurd door Movable Type.',
	'Test e-mail was successfully sent to [_1]' => 'De test e-mail werd met succes verzonden naar [_1]',
	'E-mail was not properly sent. [_1]' => 'E-mail werd niet goed verzonden. [_1]',
	'Email address is [_1]' => 'E-mail adres is [_1]',
	'Debug mode is [_1]' => 'Debug modus is [_1]',
	'Performance logging is on' => 'Performantielogging staat aan',
	'Performance logging is off' => 'Performantielogging staat uit',
	'Performance log path is [_1]' => 'Performantielogpad is [_1]',
	'Performance log threshold is [_1]' => 'Performantielogdrempel is [_1]',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'Ongeldig sitepad.  Het sitepad moet geldig en absoluut zijn, niet relatief',
	'Prohibit comments is on' => 'Reacties verbieden staat aan',
	'Prohibit comments is off' => 'Reacties verbieden staat uit',
	'Prohibit trackbacks is on' => 'Trackbacks verbieden staat aan',
	'Prohibit trackbacks is off' => 'Trackbacks verbieden staat uit',
	'Prohibit notification pings is on' => 'Notificaties verbieden staat aan',
	'Prohibit notification pings is off' => 'Notificaties verbieden staat uit',
	'Outbound trackback limit is [_1]' => 'Limiet voor uitgaande trackbacks is [_1]',
	'Any site' => 'Eender welke site',
	'Only to blogs within this system' => 'Enkel naar blogs binnen dit systeem',
	'[_1] is [_2]' => '[_1] is [_2]',
	'none' => 'geen',
	'Changing image quality is [_1]' => 'Aanpassen afbeeldingskwaliteit is [_]', # Translate - New
	'Image quality(JPEG) is [_1]' => 'Afbeeldingskwaliteit (JPEG) is [_1]',
	'Image quality(PNG) is [_1]' => 'Afbeeldingskwaliteit (PNG) is [_1]',
	'System Settings Changes Took Place' => 'Wijzigingen werden aangebracht aan de systeeminstellingen',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Ongeldige poging om wachtwoord opnieuw in te stellen; Kan het wachtwoord niet terughalen in deze configuratie',
	'Invalid author_id' => 'Ongeldig author_id',
	'Backup & Restore' => 'Backup & Restore',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om backups te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om restore-operaties te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken',
	'[_1] is not a number.' => '[_1] is geen getal.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Bestand [_1] copiëren naar [_2] mislukt: [_3]',
	'Specified file was not found.' => 'Het opgegeven bestand werd niet gevonden.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] downloadde met succes backupbestand ([_2])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => 'Een aantal van de mediabestanden konden niet teruggezet worden.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Gelieve xml, tar.gz, zip, of manifest te gebruiken als bestandsextensies.',
	'Unknown file format' => 'Onbekend bestandsformaat',
	'Some objects were not restored because their parent objects were not restored.' => 'Sommige objecten werden niet teruggezet omdat hun ouder-objecten niet werden teruggezet.',
	'Detailed information is in the activity log.' => 'Gedetailleerde informatie is terug te vinden in het activiteitenlog.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] heeft de terugzet-operatie van meerdere bestanden voortijdig afgebroken.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het aanpassen...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het verwijderen...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Archiefpad aan het aanpassen voor blog \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Archiefpad aan het verwijderen voor blog \'[_1]\' (ID:[_2])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Bestandspad aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing URL for FileInfo record (ID:[_1])...' => 'URL aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Bestandslocatie voor mediabestand \'[_1]\' (ID:[_2]) wordt aangepast...',
	'Could not remove backup file [_1] from the filesystem: [_2]' => 'Kon backup bestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Some of the backup files could not be removed.' => 'Enkele backup bestanden konden niet worden verwijderd.',
	'Please upload [_1] in this page.' => 'Gelieve [_1] te uploaden op deze pagina.',
	'File was not uploaded.' => 'Bestand werd niet opgeladen.',
	'Restoring a file failed: ' => 'Terugzetten van een bestand mislukt: ',
	'Some of the files were not restored correctly.' => 'Een aantal bestanden werden niet correct teruggezet.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Objecten werden met succes teruggezet in het Movable Type systeem door gebruiker \'[_1]\'',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ongeldige poging het wachtwoord terug te vinden; kan geen wachtwoorden terugvinden in deze configuratie',
	'Cannot recover password in this configuration' => 'Kan geen wachtwoorden terugvinden in deze configuratie',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Ongeldige gebruikersnaam \'[_1]\' bij poging tot terugvinden wachtwoord',
	'User name or password hint is incorrect.' => 'Gebruikersnaam of wachtwoordhint niet correct.',
	'User has not set pasword hint; Cannot recover password' => 'Gebruiker heeft geen wachtwoordhint ingesteld; Kan wachtwoord niet recupereren',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Ongeldige poging om wachtwoord te recupereren (gebruikte hint \'[_1]\')',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) heeft geen e-mail adres',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Een verzoek om het wachtwoord re resetten is naar [_3] gestuurd voor gebruiker \'[_1]\' (gebruiker #[_2]).',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the activity log.' => 'Sommige objecten werden niet gerecupereerd omdat hun ouder-objecten niet werden teruggezet.  Gedetailleerde informatie is te vinden in het activiteitenlog.',
	'[_1] is not a directory.' => '[_1] is geen map.',
	'Error occurred during restore process.' => 'Er deed zich een fout voor bij het terugzetten.',
	'Some of files could not be restored.' => 'Een aantal bestanden konden niet worden teruggezet.',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Het opgeladen bestand was geen geldig Movable Type backup manifest bestand.',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'Manifestbestand \'[_1]\' is te groot.  Gelieve de map \'import\' te gebruiken om de gegevens terug te zetten.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) werden met succes gebackupt door gebruiker \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type systeem werd met succes gebackupt door gebruiker \'[_1]\'',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Een aantal [_1] werden niet teruggezet omdat hun ouderobjecten niet werden teruggezet.',
	'Recipients for lockout notification' => 'Ontvangers voor blokkeringsnotificaties',
	'User lockout limit' => 'Blokkeringslimiet gebruiker',
	'User lockout interval' => 'Blokkeringsinterval gebruiker',
	'IP address lockout limit' => 'Blokkeringslimiet IP adres',
	'IP address lockout interval' => 'Blokkeringsinterval IP adres',
	'Lockout IP address whitelist' => 'Niet blokkkeerbare IP adressen',

## lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Categorie zonder label)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van categorie \'[_4]\'',
	'(Untitled entry)' => '(Bericht zonder titel)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
	'No Excerpt' => 'Geen uittreksel',
	'No Title' => 'Geen titel',
	'Orphaned TrackBack' => 'Verweesde TrackBack',
	'category' => 'categorie',

## lib/MT/CMS/User.pm
	'Create User' => 'Gebruiker aanmaken',
	'Cannot load role #[_1].' => 'Kan rol #[_1] niet laden.',
	'Role name cannot be blank.' => 'Naam van de rol mag niet leeg zijn.',
	'Another role already exists by that name.' => 'Er bestaat al een rol met die naam.',
	'You cannot define a role without permissions.' => 'U kunt geen rol definiëren zonder permissies.',
	'Invalid type' => 'Ongeldig type',
	'User \'[_1]\' (ID:[_2]) could not be re-enabled by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) kon niet opnieuw geactiveerd worden door \'[_3]\'',
	'Invalid ID given for personal blog theme.' => 'Ongeldig ID opgegeven voor persoonlijk blogthema.',
	'Invalid ID given for personal blog clone location ID.' => 'Ongeldig ID opgegeven als locatie ID van kloon van persoonlijke blog',
	'Minimum password length must be an integer and greater than zero.' => 'Minimale wachtwoordlengte moet een geheel getal groter dan nul zijn.',
	'If personal blog is set, the personal blog location are required.' => 'Als een persoonlijke blog is ingesteld, dan is de locatie van de persoonlijke blog vereist.',
	'Select a entry author' => 'Selecteer een berichtauteur',
	'Select a page author' => 'Selecteer een pagina-auteur',
	'Selected author' => 'Selecteer auteur',
	'Type a username to filter the choices below.' => 'Tik een gebruikersnaam in om de keuzes hieronder te filteren.',
	'Select a System Administrator' => 'Selecteer een systeembeheerder',
	'Selected System Administrator' => 'Geselecteerde systeembeheerder',
	'System Administrator' => 'Systeembeheerder',
	'(newly created user)' => '(nieuw aangemaakte gebruiker)',
	'Select Website' => 'Selecteer website',
	'Website Name' => 'Naam website',
	'Websites Selected' => 'Geselecteerde websites',
	'Select Blogs' => 'Selecteer blogs',
	'Blogs Selected' => 'Geselecteerde blogs',
	'Select Users' => 'Gebruikers selecteren',
	'Users Selected' => 'Gebruikers geselecteerd',
	'Select Roles' => 'Selecteer rollen',
	'Roles Selected' => 'Geselecteerde rollen',
	'Grant Permissions' => 'Permissies toekennen',
	'You cannot delete your own association.' => 'U kunt uw eigen associatie niet verwijderen.',
	'[_1]\'s Associations' => 'Associaties van [_1]',
	'You cannot delete your own user record.' => 'U kunt uw eigen gebruikersgegevens niet verwijderen.',
	'You have no permission to delete the user [_1].' => 'U heeft geen rechten om gebruiker [_1] te verwijderen.',
	'User requires username' => 'Gebruiker vereist gebruikersnaam',
	'User requires display name' => 'Gebruiker heeft een getoonde naam nodig',
	'User requires password' => 'Gebruiker vereist wachtwoord',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'represents a user who will be created afterwards' => 'stelt een gebruiker voor die later zal worden aangemaakt',

## lib/MT/CMS/Website.pm
	'New Website' => 'Nieuwe website',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Website \'[_1]\' (ID: [_2]) verwijderd door \'[_3]\'',
	'Selected Website' => 'Geselecteerde website',
	'Type a website name to filter the choices below.' => 'Tik de naam van een website in om de keuzes hieronder te filteren.',
	'Cannot load website #[_1].' => 'Kan website #[_1] niet laden',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) verplaatst van \'[_3]\' naar \'[_4]\' door \'[_5]\'',

## lib/MT/Comment.pm
	'Comment' => 'Reactie',
	'Search for other comments from anonymous commenters' => 'Zoeken naar andere reacties van anonieme reageerders',
	'__ANONYMOUS_COMMENTER' => 'Anoniem',
	'Search for other comments from this deleted commenter' => 'Zoeken naar andere reacties van deze verwijderde reageerder',
	'(Deleted)' => '(Verwijderd)',
	'Edit this [_1] commenter.' => 'Bewerk deze [_1] reageerder',
	'Comments on [_1]: [_2]' => 'Reacties op [_1]: [_2]',
	'Approved' => 'Goedgekeurd',
	'Unapproved' => 'Niet gekeurd',
	'Not spam' => 'Geen spam',
	'Reported as spam' => 'Gerapporteerd als spam',
	'All comments by [_1] \'[_2]\'' => 'Alle reacties van [_1] \'[_2]\'',
	'Commenter' => 'Reageerder',
	'Loading entry \'[_1]\' failed: [_2]' => 'Laden van bericht \'[_1]\' mislukt: [_2]',
	'Entry/Page' => 'Bericht/pagina',
	'Comments on My Entries/Pages' => 'Reacties op mijn berichten/pagina\'s',
	'Commenter Status' => 'Status reageerder',
	'Comments in This Website' => 'Reacties op deze website',
	'Non-spam comments' => 'Non-spam reacties',
	'Non-spam comments on this website' => 'Non-spam reacties op deze website',
	'Pending comments' => 'Te modereren reacties',
	'Published comments' => 'Gepubliceerde reacties',
	'Comments on my entries/pages' => 'Reacties op mijn berichten/pagina\'s',
	'Comments in the last 7 days' => 'Reacties in de afgelopen 7 dagen',
	'Spam comments' => 'Spamreacties',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'gebruikt: [_1], zou moeten gebruiken: [_2]',
	'uses [_1]' => 'gebruikt [_1]',
	'No executable code' => 'Geen uitvoerbare code',
	'Publish-option name must not contain special characters' => 'Naam voor publicatie-optie mag geen speciale karakters bevatten',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Sjabloon \'[_1]\' laden mislukt: [_2]',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias voor [_1] zit in een lus in de configuratie',
	'Error opening file \'[_1]\': [_2]' => 'Fout bij openen bestand \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Configuratie-directief [_1] zonder waarde in [_2] lijn [_3]',
	'No such config variable \'[_1]\'' => 'Onbekende configuratievariabele \'[_1]\'',

## lib/MT/Config.pm
	'Configuration' => 'Configuratie',

## lib/MT/Core.pm
	'This is often \'localhost\'.' => 'Dit is vaak \'localhost\'.',
	'The physical file path for your SQLite database. ' => 'Het fysieke bestandspad voor uw SQLite database',
	'[_1] in [_2]: [_3]' => '[_1] in [_2]: [_3]',
	'option is required' => 'optie is vereist',
	'Days must be a number.' => 'Dagen moet een getal zijn.',
	'Invalid date.' => 'Ongeldige datum.',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] tussen [_3] en [_4]',
	'[_1] [_2] since [_3]' => '[_1] [_2] sinds [_3]',
	'[_1] [_2] or before [_3]' => '[_1] [_2] of voor [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] deze [_3] dagen',
	'[_1] [_2] future' => '[_1] [_2] toekomst',
	'[_1] [_2] past' => '[_1] [_2] verleden',
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Label' => 'Geen label',
	'(system)' => '(systeem)',
	'My [_1]' => 'Mijn  [_1]',
	'[_1] of this Website' => '[_1] van deze website',
	'IP Banlist is disabled by system configuration.' => 'IP banlijst is uitgeschakeld in de systeemconfiguratie',
	'Address Book is disabled by system configuration.' => 'Adresboek is uitgeschakeld in de systeemconfiguratie',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Fout bij het aanmaken van de map voor de performantielogbestanden, [_1].  Gelieve de permissies aan te passen zodat deze map beschrijfbaar is of geef een alternatief pad op via de PerformanceLoggingPath configuratiedirectief. [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Fout bij het aanmaken van performantielogs: PerformanceLogginPath instelling moet een pad naar een map zijn, geen bestand. [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Fout bij het aanmaken van performantielogs: PerformanceLoggingPath map bestaat maar is niet beschrijfbaar. [_1]',
	'MySQL Database (Recommended)' => 'MySQL database (aangeraden)',
	'PostgreSQL Database' => 'PostgreSQL databank',
	'SQLite Database' => 'SQLite databank',
	'SQLite Database (v2)' => 'SQLite databank (v2)',
	'Database Server' => 'Databaseserver',
	'Database Name' => 'Databasenaam',
	'Password' => 'Wachtwoord',
	'Database Path' => 'Databasepad',
	'Database Port' => 'Databasepoort',
	'Database Socket' => 'Databasesocket',
	'ID' => 'ID',
	'Date Created' => 'Datum aangemaakt',
	'Date Modified' => 'Datum gewijzigd',
	'Author Name' => 'Auteursnaam',
	'Legacy Quick Filter' => 'Verouderde snelfilter',
	'My Items' => 'Mijn items',
	'Log' => 'Log',
	'Activity Feed' => 'Activiteit-feed',
	'Folder' => 'Map',
	'Trackback' => 'TrackBack',
	'Manage Commenters' => 'Reageerders beheren',
	'Member' => 'Lid',
	'Permission' => 'Permissie',
	'IP addresses' => 'IP adressen',
	'IP Banning Settings' => 'IP-verbanningsinstellingen',
	'Contact' => 'Contact',
	'Manage Address Book' => 'Adresboek beheren',
	'Filter' => 'Filter',
	'Convert Line Breaks' => 'Regeleindes omzetten',
	'Rich Text' => 'Rich text',
	'Movable Type Default' => 'Movable Type standaardinstelling',
	'weblogs.com' => 'weblogs.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'Klassieke weblog',
	'Publishes content.' => 'Publiceert inhoud.',
	'Synchronizes content to other server(s).' => 'Synchroniseert inhoud naar andere server(s).',
	'Refreshes object summaries.' => 'Ververst objectsamenvattingen.',
	'Adds Summarize workers to queue.' => 'Voegt samenvattingswerkers toe aan de wachtrij',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Lijst berichten',
	'Blog URL' => 'Blog-URL',
	'Blog ID' => 'Blog ID',
	'Entry Excerpt' => 'Berichtuittreksel',
	'Entry Link' => 'Link bericht',
	'Entry Extended Text' => 'Uitgebreide tekst bericht',
	'Entry Title' => 'Berichttitel',
	'If Block' => 'If blok',
	'If/Else Block' => 'If/Else blok',
	'Include Template Module' => 'Sjabloonmodule includeren',
	'Include Template File' => 'Sjabloonbestand includeren',
	'Get Variable' => 'Haal variabele op',
	'Set Variable' => 'Stel variabele in',
	'Set Variable Block' => 'Stel variabel blok in',
	'Widget Set' => 'Widgetset',
	'Publish Scheduled Entries' => 'Publicatie geplande berichten',
	'Unpublish Past Entries' => 'Publicatie oude berichten ongedaan maken',
	'Add Summary Watcher to queue' => 'Samenvattings-waakhond toevoegen aan de wachtrij',
	'Junk Folder Expiration' => 'Vervaldatum spam-map',
	'Remove Temporary Files' => 'Tijdelijke bestanden verwijderen',
	'Purge Stale Session Records' => 'Verlopen sessiegegevens verwijderen',
	'Purge Stale DataAPI Session Records' => 'Verlopen DataAPI sessiegegevens verwijderen',
	'Remove expired lockout data' => 'Verlopen blokkeringsgegevens verwijderen',
	'Purge Unused FileInfo Records' => 'Ongebruikte FileInfo records verwijderen',
	'Remove Compiled Template Files' => 'Gecompileerde sjabloonbestanden verwijderen', # Translate - New
	'Manage Website' => 'Website beheren',
	'Manage Blog' => 'Blog beheren',
	'Manage Website with Blogs' => 'Website met blogs beheren',
	'Post Comments' => 'Reacties publiceren',
	'Create Entries' => 'Berichten aanmaken',
	'Edit All Entries' => 'Alle berichten bewerken',
	'Manage Assets' => 'Mediabestanden beheren',
	'Manage Categories' => 'Categorieën beheren',
	'Change Settings' => 'Instellingen aanpassen',
	'Manage Tags' => 'Tags beheren',
	'Manage Templates' => 'Sjablonen beheren',
	'Manage Feedback' => 'Feedback beheren',
	'Manage Pages' => 'Pagina\'s beheren',
	'Manage Users' => 'Gebruikers beheren',
	'Manage Themes' => 'Thema\'s beheren',
	'Publish Entries' => 'Berichten publiceren',
	'Save Image Defaults' => 'Standaardinstellingen afbeeldingen opslaan',
	'Send Notifications' => 'Notificaties verzenden',
	'Set Publishing Paths' => 'Publicatiepaden instellen',
	'View Activity Log' => 'Activiteitenlog bekijken',
	'Create Blogs' => 'Blogs aanmaken',
	'Create Websites' => 'Websites aanmaken',
	'Manage Plugins' => 'Plugins beheren',
	'View System Activity Log' => 'Systeemactiviteitlog bekijken',

## lib/MT/DataAPI/Callback/Blog.pm
	'A parameter "[_1]" is required.' => 'Eeen "[_1]" parameter is vereist',
	'The website root directory must be an absolute path: [_1]' => 'De hoofdmap van de website moet een absoluut pad zijn: [_1]',
	'Invalid theme_id: [_1]' => 'Ongeldig theme_id: [_1]',
	'Cannot apply website theme to blog: [_1]' => 'Kan website-thema niet op blog toepassen: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'The label \'[_1]\' is too long.' => 'Het label \'[_1]\' is te lang.',
	'Parent [_1] (ID:[_2]) not found.' => 'Moeder [_1] (ID:[_2]) niet gevonden.',

## lib/MT/DataAPI/Callback/Entry.pm

## lib/MT/DataAPI/Callback/Log.pm
	'A paramter "[_1]" is required.' => 'Een "[_1]" parameter is vereist.',
	'author_id (ID:[_1]) is invalid.' => 'author_id (ID:[_1]) is ongeldig.',
	'Log (ID:[_1]) deleted by \'[_2]\'' => 'Log (ID:[_1]) verwijderd door \'[_2]\'',

## lib/MT/DataAPI/Callback/Role.pm

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Ongeldige tagnaam: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Ongeldig archieftype: [_1]',

## lib/MT/DataAPI/Callback/Template.pm

## lib/MT/DataAPI/Callback/User.pm
	'Invalid language: [_1]' => 'Ongeldige taal: [_1]',
	'Invalid dateFormat: [_1]' => 'Ongeldig dateFormat: [_1]',
	'Invalid textFormat: [_1]' => 'Ongeldig textFormat: [_1]',

## lib/MT/DataAPI/Callback/Widget.pm

## lib/MT/DataAPI/Callback/WidgetSet.pm

## lib/MT/DataAPI/Endpoint/Auth.pm

## lib/MT/DataAPI/Endpoint/Comment.pm

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Ongeldige dateFrom parameter [_1]',
	'Invalid dateTo parameter: [_1]' => 'Ongeldige dateTo parameter: [_1]',

## lib/MT/DataAPI/Endpoint/Entry.pm

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'The asset does not support generating a thumbnail file.' => 'Dit mediabestand ondersteunt het aanmaken van een thumbnailbestand niet.',
	'Invalid width: [_1]' => 'Ongeldige breedte: [_1]',
	'Invalid height: [_1]' => 'Ongeldige hoogte: [_1]',
	'Invalid scale: [_1]' => 'Ongeldige schaal: [_1]',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Er deed zich een fout voor tijdens het backup-proces: [_1]',
	'Invalid backup_what: [_1]' => 'Ongeldige backup_what: [_1]',
	'Invalid backup_archive_format: [_1]' => 'Ongeldige backup_archive_format: [_1]',
	'Invalid limit_size: [_1]' => 'Ongeldige limit_size: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Er deed zich een fout voor tijdens het restore-proces: [_1].  Kijk het activiteitenlog na voor meer details.',
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Verwijder de bestanden die u heeft teruggezet uit de map \'import\', om te vermijden dat ze opnieuw worden teruggezet wanneer u ooit het restore-proces opnieuw uitvoert.',

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Kan geen blog aanmaken onder blog (ID: [_1])',
	'Either parameter of "url" or "subdomain" is required.' => 'Of "url" of "subdomein" parameter vereist.',
	'Site not found' => 'Site niet gevonden',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Website "[_1]" (ID: [_2]) niet verwijderd.  U moet eerst de blogs onder de website verwijderen.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'U moet de "password" parameter opgeven als u nieuwe gebruikers wenst aan te maken voor elke gebruiker die aan uw blog vastzit.',
	'Invalid import_type: [_1]' => 'Ongeldig import_type: [_1]',
	'Invalid encoding: [_1]' => 'Ongeldige encodering: [_1]',
	'Invalid convert_breaks: [_1]' => 'Ongeldige convert_breaks: [_1]',
	'Invalid default_cat_id: [_1]' => 'Ongeldige default_cat_id: [_1]',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Verwijder zeker de bestanden waaruit u gegevens importeerde uit de \'import\' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.',
	'A resource "[_1_]" is required.' => 'Een bron "[_1]" is vereist.',
	'Could not found archive template for [_1].' => 'Kon archiefsjabloon niet vinden voor [_1].',
	'Preview data not found.' => 'Gegevens voor voorbeeld niet gevonden.',

## lib/MT/DataAPI/Endpoint/v2/Folder.pm

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Logbericht',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	'\'folder\' parameter is invalid.' => '\'folder\' parameter is ongeldig.',

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Granting permission failed: [_1]' => 'Permissie verlenen mislukt: [_1]',
	'Role not found' => 'Rol niet gevonden',
	'Revoking permission failed: [_1]' => 'Permissie afnemen mislukt: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/Role.pm

## lib/MT/DataAPI/Endpoint/v2/Search.pm

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Kan privé-tag verbonden met objecten op systeemniveau niet verwijderen.',
	'Cannot delete private tag in system scope.' => 'Kan privé-tag op systeemniveau niet verwijderen.',
	'Tag not found' => 'Tag niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Sjabloon "[_1]" is geen archiefsjabloon.',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'Template not found' => 'Sjabloon niet gevonden',
	'Cannot delete [_1] template.' => 'Kan [_1] sjabloon niet verwijderen.',
	'Cannot publish [_1] template.' => 'Kan [_1] sjabloon niet publiceren.',
	'A parameter "refresh_type" is invalid: [_1]' => 'De parameter "refresh_type" is ongeldig: [_1]',
	'Cannot clone [_1] template.' => 'Kan sjabloon [_1] niet klonen.',
	'A resource "template" is required.' => 'Een "sjabloon" bron is vereist.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Cannot apply website theme to blog.' => 'Kan website-thema niet toepassen op blog.',
	'Changing site theme failed: [_1]' => 'Aanpassen site-thema mislukt: [_1]',
	'Applying theme failed: [_1]' => 'Toepassen van thema mislukt: [_1]',
	'Cannot uninstall this theme.' => 'Dit thema kan niet gedeïnstalleerd worden.',
	'Cannot uninstall theme because the theme is in use.' => 'Kan thema niet deïnstalleren omdat het nog gebruikt wordt.',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id kan enkel letters, cijfers en het minteken of liggend streepje bevatten.  Het theme_id moet beginnen met een letter.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version kan enkel letters, cijfers en het minteken of liggend streepje bevatten.',
	'Cannot install new theme with existing (and protected) theme\'s basename: [_1]' => 'Kan geen nieuw theme installeren met dezelfde basisnaam als een bestaand (en beschermd) thema: [_1]',
	'Export theme folder already exists \'[_1]\'. You can overwrite an existing theme with \'overwrite_yes=1\' parameter, or change the Basename.' => 'Map voor exporteren thema bestaat al \'[_1]\'.  U kunt een bestaand thema overschrijven met de \'overwrite_yes=1\' parameter of u kunt de basisnaam aanpassen.',
	'Unknown archiver type : $arctype' => 'Onbekend archiveringstype : $arctype',

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'Het opgegeven email adres is niet uniek.  Gelieve uw gebruikersnaam in te vullen bij de "name" parameter.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Er is een e-mail met een link om uw wachtwoord aan te passen doorgestuurd naar uw e-mail adres ([_1]).',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Widget not found' => 'Widget niet gevonden',
	'Removing Widget failed: [_1]' => 'Widget verwijderen mislukt: [_1]',
	'Widgetset not found' => 'Widgetset niet gevonden',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Een bron "widgetset" is vereist.',
	'Removing Widgetset failed: [_1]' => 'Widget set verwijderen mislukt: [_1]',

## lib/MT/DataAPI/Endpoint/v3/Asset.pm

## lib/MT/DataAPI/Endpoint/v3/Auth.pm

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kan "[_1]" niet parsen als een IS0 8601 datetime',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Archiefindex',
	'Stylesheet' => 'Stylesheet',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Feed - Recente berichten',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Maandoverzicht berichten',
	'Category Entry Listing' => 'Categorie-overzicht berichten',
	'Comment Listing' => 'Overzicht reacties',
	'Improved listing of comments.' => 'Verbeterde weergave van reacties.',
	'Comment Response' => 'Bevestiging reactie',
	'Displays error, pending or confirmation message for comments.' => 'Toont foutboodschappen, bevestigingen en \'even geduld\' berichten voor reacties.',
	'Comment Preview' => 'Voorbeeld reactie',
	'Displays preview of comment.' => 'Toont voorbeeld van reactie.',
	'Dynamic Error' => 'Dynamische fout',
	'Displays errors for dynamically-published templates.' => 'Geeft fouten weer voor dynamisch gepubliceerde sjablonen.',
	'Popup Image' => 'Pop-up afbeelding',
	'Displays image when user clicks a popup-linked image.' => 'Toont afbeelding wanneer de gebruiker op een afbeelding klikt die in een popup verschijnt.',
	'Displays results of a search.' => 'Toont zoekresultaten',
	'About This Page' => 'Over deze pagina',
	'Archive Widgets Group' => 'Archiefwidgetsgroep',
	'Current Author Monthly Archives' => 'Archieven per maand van de huidige auteur',
	'Calendar' => 'Kalender',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Hoofdpaginawidgetsgroep',
	'Monthly Archives Dropdown' => 'Uitklapmenu archieven per maand',
	'Page Listing' => 'Overzicht pagina\'s',
	'Powered By' => 'Aangedreven door',
	'Syndication' => 'Syndicatie',
	'Technorati Search' => 'Technorati zoekformulier',
	'Date-Based Author Archives' => 'Datum-gebaseerde auteursactieven',
	'Date-Based Category Archives' => 'Datum-gebaseerde categorie-archieven',
	'OpenID Accepted' => 'OpenID welkom',
	'Comment throttle' => 'Beperking reacties',
	'Commenter Confirm' => 'Bevestiging reageerder',
	'Commenter Notify' => 'Notificatie reageerder',
	'New Comment' => 'Nieuwe reactie',
	'New Ping' => 'Nieuwe ping',
	'Entry Notify' => 'Notificatie bericht',
	'User Lockout' => 'Blokkering gebruiker',
	'IP Address Lockout' => 'Blokkering IP adres',

## lib/MT/Entry.pm
	'View [_1]' => '[_1] bekijken',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) bestaat niet.',
	'Entries from category: [_1]' => 'Berichten in categorie: [_1]',
	'NONE' => 'GEEN',
	'Draft' => 'Klad',
	'Published' => 'Gepubliceerd',
	'Reviewing' => 'Nakijken',
	'Scheduled' => 'Gepland',
	'Junk' => 'Spam',
	'Unpublished (End)' => 'Publicatie ongedaan gemaakt (einde)',
	'Entries by [_1]' => 'Berichten door [_1]',
	'record does not exist.' => 'record bestaat niet.',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Ongeldige argumenten. Ze moeten allemaal als MT::Category objecten opgeslagen zijn.',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Ongeldige argumenten. Ze moeten allemaal als MT::Asset objecten opgeslagen zijn.',
	'Review' => 'Na te kijken',
	'Future' => 'Toekomstig',
	'Spam' => 'Spam',
	'Accept Comments' => 'Reacties aanvaarden',
	'Body' => 'Romp',
	'Extended' => 'Uitgebreid',
	'Format' => 'Formaat',
	'Accept Trackbacks' => 'TrackBacks aanvaarden',
	'Publish Date' => 'Datum publicatie',
	'Unpublish Date' => 'Einddatum publicatie',
	'Link' => 'Link',
	'Primary Category' => 'Hoofdcategorie',
	'-' => '-',
	'__PING_COUNT' => 'Trackbacks',
	'Date Commented' => 'Datum gereageerd',
	'Author ID' => 'ID auteur',
	'My Entries' => 'Mijn berichten',
	'Entries in This Website' => 'Berichten in deze website',
	'Published Entries' => 'Gepubliceerde berichten',
	'Draft Entries' => 'Kladberichten',
	'Unpublished Entries' => 'Niet gepubliceerde berichten',
	'Scheduled Entries' => 'Geplande berichten',
	'Entries with Comments Within the Last 7 Days' => 'Berichten met reacties in de laatste zeven dagen',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV verbinding mislukt: [_1]',
	'DAV open failed: [_1]' => 'DAV open mislukt: [_1]',
	'DAV get failed: [_1]' => 'DAV get mislukt: [_1]',
	'DAV put failed: [_1]' => 'DAV put mislukt: [_1]',
	'Deleting \'[_1]\' failed: [_2]' => 'Verwijderen van \'[_1]\' mislukt: [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'Aanmaken van pad \'[_1]\' mislukt: [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Herbenoemen van \'[_1]\' naar \'[_2]\' mislukt: [_3]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP verbinding mislukt: [_1]',
	'SFTP get failed: [_1]' => 'SFTP get mislukt: [_1]',
	'SFTP put failed: [_1]' => 'SFTP put mislukt: [_1]',

## lib/MT/Filter.pm
	'Filters' => 'Filters',
	'Invalid filter type [_1]:[_2]' => 'Ongeldig filtertype [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Ongeldige sorteersleutel [_1]:[_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms" en "editable_filters" kunnen niet op hetzelfde moment opgegeven worden.',
	'System Object' => 'Systeemobject',

## lib/MT/Folder.pm

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'Kan GD niet laden: [_1]',
	'Unsupported image file type: [_1]' => 'Niet ondersteund afbeeldingsformaat: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Bestand \'[_1]\' lezen mislukt: [_2]',
	'Reading image failed: [_1]' => 'Afbeelding lezen mislukt: [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'Draaien (graden: [_1]) wordt niet ondersteund',

## lib/MT/Image/ImageMagick.pm
	'Cannot load Image::Magick: [_1]' => 'Kan Image::Magick niet laden: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Dimensies aanpassen naar [_1]x[_2] mislukt: [_3]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Bijsnijden van [_1]x[_2] vierkand naar [_3],[_4] mislukt: [_5]',
	'Flip horizontal failed: [_1]' => 'Horizontaal draaien mislukt: [_1]',
	'Flip vertical failed: [_1]' => 'Verticaal draaien mislukt: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'Roteren (graden: [_1]) mislukt: [_2]',
	'Converting image to [_1] failed: [_2]' => 'Converteren van afbeelding naar [_1] mislukt: [_2]',
	'Outputting image failed: [_1]' => 'Uitvoer van afbeelding mislukt: [_1]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Kan Imager niet laden: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'Kan IPC::Run niet laden: [_1]',
	'Reading alpha channel of image failed: [_1]' => 'Lezen alfakanaal van de afbeelding mislukt: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Bijsnijden naar [_1]x[_2] mislukt: [_3]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'U hebt geen geldig pad naar de NetPBM tools op uw machine.',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => 'Ongeldige driver voor afbeeldingen  [_1]',
	'Saving [_1] failed: Invalid image file format.' => 'Opslaan van [_1] mislukt: Ongeldig afbeeldingsbestandsformaat',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Bestandsgroote is groter dan maximum toegestaan: [_1] > [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Geen blog',
	'Need either ImportAs or ParentAuthor' => 'ImportAs ofwel ParentAuthor vereist',
	'Creating new user (\'[_1]\')...' => 'Nieuwe gebruiker (\'[_1]\') wordt aangemaakt...',
	'Saving user failed: [_1]' => 'Gebruiker opslaan mislukt: [_1]',
	'Creating new category (\'[_1]\')...' => 'Nieuwe categorie wordt aangemaakt (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Categorie opslaan mislukt: [_1]',
	'Invalid status value \'[_1]\'' => 'Ongeldige statuswaarde \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Ongeldige instelling voor het toelaten van pings \'[_1]\'',
	'Cannot find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Kan geen bestaand bericht vinden met tijdstip \'[_1]\'... reacties worden overgeslagen, verder naar volgende bericht.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Aan het importeren in bestaand bericht [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Bericht aan het opslaan (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Bericht opslaan mislukt: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
	'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Export mislukt bij bericht \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ongeldig datumformaat \'[_1]\'; dit moet \'MM/DD/JJJJ HH:MM:SS AM|PM\' zijn (AM|PM is optioneel)',

## lib/MT/Import.pm
	'Cannot rewind' => 'Kan niet terugspoelen',
	'Cannot open \'[_1]\': [_2]' => 'Kan \'[_1]\' niet openen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
	'Importing entries from file \'[_1]\'' => 'Berichten worden ingevoerd uit bestand  \'[_1]\'',
	'Could not resolve import format [_1]' => 'Kon importformaat niet bepalen [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Een ander systeem (Movable Type formaat)',

## lib/MT/IPBanList.pm
	'IP Ban' => 'IP ban',
	'IP Bans' => 'IP bans',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Handeling: Verworpen (score onder drempel)',
	'Action: Published (default action)' => 'Handeling: Gepubliceerd (standaardhandeling)',
	'Junk Filter [_1] died with: [_2]' => 'Spamfilter [_1] liep vast met: [_2]',
	'Unnamed Junk Filter' => 'Naamloze spamfilter',
	'Composite score: [_1]' => 'Samengestelde score: [_1]',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'Kan lijsteigenschap [_1] niet initialiseren. [_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Kon auto list eigenschap niet initialiseren [_1].[_2]: Kan definitie van kolom [_3] niet vinden.',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Kon auto list eigenschap niet initialiseren [_1].[_2]: kolomtype niet ondersteund.',

## lib/MT/Lockout.pm
	'Cannot find author for id \'[_1]\'' => 'Kan geen auteur vinden voor id \'[_1]\'',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Gebruiker werd geblokkeerd.  IP adres: [_1], Gebruikersnaam: [_2]',
	'User Was Locked Out' => 'Gebruiker werd geblokkeerd',
	'Error sending mail: [_1]' => 'Fout bij versturen mail: [_1]',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IP adres werd geblokkeerd.  IP adres: [_1], Gebruikersnaam: [_2]',
	'IP Address Was Locked Out' => 'IP adres werd geblokkeerd.',
	'User has been unlocked. Username: [_1]' => 'Gebruiker werd gedeblokkeerd.  Gebruikersnaam: [_1]',

## lib/MT/Log.pm
	'Log messages' => 'Logberichten',
	'Security' => 'Beveiliging',
	'Warning' => 'Waarschuwing',
	'Information' => 'Informatie',
	'Debug' => 'Debug',
	'Security or error' => 'Beveiliging of fout',
	'Security/error/warning' => 'Beveiliging/fout/waarschuwing',
	'Not debug' => 'Debug niet',
	'Debug/error' => 'Debug/fout',
	'Showing only ID: [_1]' => 'Enkel ID wordt weergegeven: [_1]',
	'Page # [_1] not found.' => 'Pagina # [_1] niet gevonden.',
	'Entry # [_1] not found.' => 'Bericht # [_1] niet gevonden.',
	'Comment # [_1] not found.' => 'Reactie # [_1] niet gevonden.',
	'TrackBack # [_1] not found.' => 'TrackBack # [_1] niet gevonden.',
	'blog' => 'blog',
	'website' => 'website',
	'search' => 'zoek',
	'author' => 'auteur',
	'ping' => 'ping',
	'theme' => 'thema',
	'folder' => 'map',
	'plugin' => 'plugin',
	'page' => 'pagina',
	'Message' => 'Boodschap',
	'By' => 'Door',
	'Class' => 'Klasse',
	'Level' => 'Niveau',
	'Metadata' => 'Metadata',
	'Logs on This Website' => 'Logs op deze website',
	'Show only errors' => 'Enkel fouten tonen',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Onbekende MailTransfer methode \'[_1]\'',
	'Username and password is required for SMTP authentication.' => 'Gebruikersnaam en wachtwoord zijn vereist voor SMTP authenticatie.',
	'Error connecting to SMTP server [_1]:[_2]' => 'Fout bij verbinden met SMTP server [_1]:[_2]',
	'Authentication failure: [_1]' => 'Fout bij authenticatie: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'U heeft geen geldig pad naar sendmail op uw machine.  Misschien moet u proberen om SMTP te gebruiken?',
	'Exec of sendmail failed: [_1]' => 'Exec van sendmail mislukt: [_1]',
	'Following required module(s) were not found: ([_1])' => 'Volgende vereiste module(s) niet gevonden: ([_1])',

## lib/MT/Notification.pm
	'Contacts' => 'Contacten',
	'Click to edit contact' => 'Klik om contact te bewerken',
	'Save Changes' => 'Wijzigingen opslaan',
	'Save' => 'Opslaan',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Assetplaatsing',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'Objectscore',
	'Object Scores' => 'Objectscores',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Tagplaatsing',
	'Tag Placements' => 'Tagplaatsingen',

## lib/MT/Page.pm
	'Pages in folder: [_1]' => 'Pagina\'s in map: [_1]',
	'Loading blog failed: [_1]' => 'Laden van blog mislukt: [_1]',
	'(root)' => '(root)',
	'My Pages' => 'Mijn pagina\'s',
	'Pages in This Website' => 'Pagina\'s op deze website',
	'Published Pages' => 'Gepubliceerde pagina\'s',
	'Draft Pages' => 'Kladpagina\'s',
	'Unpublished Pages' => 'Niet gepubliceerde pagina\'s',
	'Scheduled Pages' => 'Geplande pagina\'s',
	'Pages with comments in the last 7 days' => 'Pagina\'s waarop in de laatste zeven dagen gereageerd werd',

## lib/MT/Permission.pm

## lib/MT/Placement.pm
	'Category Placement' => 'Categorieplaatsing',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Plugindata',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] vanwege regel [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] vanwege test [_4]',

## lib/MT/Plugin.pm
	'My Text Format' => 'Mijn tekstformaat',

## lib/MT.pm
	'Powered by [_1]' => 'Aangedreven door [_1]',
	'Version [_1]' => 'Versie [_1]',
	'http://www.movabletype.com/' => 'http://www.movabletype.com',
	'Hello, world' => 'Hello, world',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Message: [_1]' => 'Bericht: [_1]',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Als het aanwezig is, dan moet het derde argument bij add_callback een object van het type MT::Component of MT::Plugin zijn',
	'Fourth argument to add_callback must be a CODE reference.' => 'Vierde argument van add_callback moet een CODE referentie zijn.',
	'Two plugins are in conflict' => 'Twee plugins zijn in conflict',
	'Invalid priority level [_1] at add_callback' => 'Ongeldig prioriteitsniveau [_1] in add_callback',
	'Internal callback' => 'Interne callback',
	'Unnamed plugin' => 'Naamloze plugin',
	'[_1] died with: [_2]' => '[_1] faalde met volgende boorschap: [_2]',
	'Bad LocalLib config ([_1]): [_2]' => 'Fout in LocalLib configuratie ([_1]): [_2]',
	'Bad ObjectDriver config' => 'Fout in ObjectDriver configuratie',
	'Bad CGIPath config' => 'Fout in CGIPath configuratie',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Ontbrekend configuratiebestand.  Misschien vergat u mt-config.cgi-original te hernoemen naar mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Plugin fout: [_1] [_2]',
	'Loading of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',
	'Loading template \'[_1]\' failed.' => 'Laden van sjabloon \'[_1]\' mislukt.',
	'Error while creating email: [_1]' => 'Fout bij het aanmaken van email: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'De perl module die vereist is voor authenticatie van reageerders via OpenID (Digest::SHA1) ontbreekt.',
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Een Perl module vereist voor authenticatie van reageerders via Google ID ontbreekt: [_1]',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'Wordpress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Movable Type standaard',

## lib/MT/Revisable/Local.pm

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Foute RevisioningDriver configuratie \'[_1]\': [_2]',
	'Revision not found: [_1]' => 'Revisie niet gevonden: [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Dit zijn verschillende objecttypes, er worden twee [_1] verwacht',
	'Did not get two [_1]' => 'Kreeg geen twee [_1]',
	'Unknown method [_1]' => 'Onbekende methode [_1]',
	'Revision Number' => 'Revisienummer',

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => 'Actief',
	'__ROLE_INACTIVE' => 'Gedeactiveerd',
	'Website Administrator' => 'Websitebeheerder',
	'Can administer the website.' => 'Kan de website beheren',
	'Blog Administrator' => 'Blogadministrator',
	'Can administer the blog.' => 'Kan deze weblog beheren',
	'Editor' => 'Redacteur',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kan bestanden uploaden, alle berichten (categorieën), pagina\'s (mappen), tags bewerken en de site publiceren.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kan berichten aanmaken, eigen berichten bewerken, bestanden uploaden en publiceren.',
	'Designer' => 'Designer',
	'Can edit, manage, and publish blog templates and themes.' => 'Kan blogsjablonen en thema\'s bewerken, beheren en publiceren.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish blog templates.' => 'Kan pagina\'s beheren, bestanden uploaden en blogsjablonen publiceren.',
	'Contributor' => 'Redactielid',
	'Can create entries, edit their own entries, and comment.' => 'Kan berichten aanmaken, eigen berichten bewerken en reageren.',
	'Moderator' => 'Moderator',
	'Can comment and manage feedback.' => 'Kan reageren en feedback beheren',
	'Can comment.' => 'Kan reageren.',
	'__ROLE_STATUS' => 'Status',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Object moet eerst worden opgeslagen',
	'Already scored for this object.' => 'Aan dit object is reeds een score toegekend.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Kon score niet instellen voor object \'[_1]\'(ID: [_2])',

## lib/MT/Session.pm
	'Session' => 'Sessie',

## lib/MT/Tag.pm
	'Private' => 'Privé',
	'Not Private' => 'Niet privé',
	'Tag must have a valid name' => 'Tag moet een geldige naam hebben',
	'This tag is referenced by others.' => 'Deze tag is gerefereerd door anderen.',
	'Tags with Entries' => 'Tags met berichten',
	'Tags with Pages' => 'Tags met pagina\'s',
	'Tags with Assets' => 'Tags met mediabestanden',

## lib/MT/TaskMgr.pm
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Bekomen van een lock om systeemtaken uit te kunnen voeren mislukt. Kijk na of uw TempDir locatie ([_1]) beschrijfbaar is.',
	'Error during task \'[_1]\': [_2]' => 'Fout tijdens taak \'[_1]\': [_2]',
	'Scheduled Tasks Update' => 'Update van geplande taken',
	'The following tasks were run:' => 'Volgende taken moesten uitgevoerd worden:',

## lib/MT/TBPing.pm
	'TrackBack' => 'TrackBack',
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping van: [_2] - [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks op [_1]: [_2]',
	'Trackback Text' => 'TrackBack tekst',
	'Target' => 'Doel',
	'From' => 'Van',
	'Source Site' => 'Bronsite',
	'Source Title' => 'Brontitel',
	'Trackbacks on My Entries/Pages' => 'TrackBacks op mijn berichten/pagina\'s',
	'Non-spam trackbacks' => 'Non-spam TrackBacks',
	'Non-spam trackbacks on this website' => 'Non-spam TrackBacks op deze website',
	'Pending trackbacks' => 'TrackBacks in de wachtrij',
	'Published trackbacks' => 'Gepubliceerde TrackBacks',
	'Trackbacks on my entries/pages' => 'TrackBacks op mijn berichten/pagina\'s',
	'Trackbacks in the last 7 days' => 'TrackBacks in de afgelopen 7 dagen',
	'Spam trackbacks' => 'Spam TrackBacks',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Alles over mij',
	'Remove this widget' => 'Verwijder dit widget',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publiceer[_2] uw [_3] om deze wijzigingen zichtbaar te maken.',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiceer[_2] uw site om deze wijzigingen zichtbaar te maken.',
	'Actions' => 'Acties',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
	'Division by zero.' => 'Deling door nul.',
	'[_1] is not a hash.' => '[_1] is geen hash.',
	'blog(s)' => 'blog(s)',
	'website(s)' => 'website(s)',
	'No [_1] could be found.' => '[_1] werden niet gevonden',
	'records' => 'records',
	'No template to include was specified' => 'Geen sjabloon opgegeven om te includeren',
	'Recursion attempt on [_1]: [_2]' => 'Recursiepoging op [_1]: [_2]',
	'Cannot find included template [_1] \'[_2]\'' => 'Kan geincludeerd sjabloon niet vinden: [_1] \'[_2]\'',
	'Error in [_1] [_2]: [_3]' => 'Fout in [_1] [_2]: [_3]',
	'Writing to \'[_1]\' failed: [_2]' => 'Schrijven naar \'[_1]\' mislukt: [_2]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'Includeren van bestanden is uitgeschakeld via de "AllowFileInclude" configuratiedirectief.',
	'Cannot find blog for id \'[_1]' => 'Kan geen blog vinden met id \'[_1]',
	'Cannot find included file \'[_1]\'' => 'Kan geïncludeerd bestand \'[_1]\' niet vinden',
	'Error opening included file \'[_1]\': [_2]' => 'Fout bij het openen van geïncludeerd bestand \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Recursiepoging op bestand: [_1]',
	'Cannot load user.' => 'Kan gebruiker niet laden.',
	'Cannot find template \'[_1]\'' => 'Kan sjabloon \'[_1]\' niet vinden',
	'Cannot find entry \'[_1]\'' => 'Kan bericht \'[_1]\' niet vinden',
	'Unspecified archive template' => 'Niet gespecifiëerd archiefsjabloon',
	'Error in file template: [_1]' => 'Fout in bestandssjabloon: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'Het attribuut exclude_blogs kan niet \'[_1]\' als waarde hebben.',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wanneer het ID van een blog zowel bij include_blogs als exclude_blogs staat, wordt de blog in kwestie uitgesloten.',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => 'U gebruikten een \'[_1]\' tag buiten de context van een auteur; Misschien plaatste u de tag per ongeluk buiten een \'MTAuthors\' container tag?',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; Misschien plaatste u die tag per ongeluk buiten een \'MTEntries\' container tag?',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van de website; Misschien plaatste u die tag per ongeluk buiten een \'MTWebsites\' container tag?',
	'You used an \'[_1]\' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?' => 'U gebruikte een \'[_1]\' tag in de context van een blog die geen deel uitmaakt van een website; Misschien is er een probleem met de gegevens van deze blog?',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van de blog; Misschien plaatste u die tag per ongeluk buiten een \'MTBlogs\' container tag?',
	'You used an \'[_1]\' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an \'MTComments\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een reactie; Misschien plaatste u die tag per ongeluik buiten een \'MTComments\' container tag?',
	'You used an \'[_1]\' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an \'MTPings\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een ping; Mogelijk plaatste u die per ongeluk buiten een \'MTPings\' container tag?',
	'You used an \'[_1]\' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an \'MTAssets\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een mediabestand; Misschien plaatste u dit per ongeluk buiten een \'MTAssets\' container tag?',
	'You used an \'[_1]\' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a \'MTPages\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een pagina; Misschien plaatste u dit per ongeluk buiten een \'MTPages\' container tag?',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Archiefkoppeling',
	'Archive Mappings' => 'Archiefkoppelingen',

## lib/MT/Template.pm
	'Template' => 'Sjabloon',
	'Template load error: [_1]' => 'Fout bij laden sjabloon: [_1]',
	'Tried to load the template file from outside of the include path \'[_1]\'' => 'Poging het sjabloonbestand te laden van buiten het include pad  \'[_1]\'',
	'Error reading file \'[_1]\': [_2]' => 'Fout bij het lezen van bestand \'[_1]\': [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Publicatiefout in sjabloon \'[_1]\': [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',
	'Template name must be unique within this [_1].' => 'Sjabloonnaam moet uniek zijn binnen deze [_1].',
	'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Gelinkt bestand \'[_1]\' openen mislukt: [_2]',
	'Index' => 'Index',
	'Category Archive' => 'Archief per categorie',
	'Ping Listing' => 'Overzicht pings',
	'Comment Error' => 'Reactie fout',
	'Comment Pending' => 'Reactie wordt behandeld',
	'Uploaded Image' => 'Opgeladen afbeelding',
	'Module' => 'Module',
	'Widget' => 'Widget',
	'Output File' => 'Uitvoerbestand',
	'Template Text' => 'Sjabloontekst',
	'Rebuild with Indexes' => 'Herpubliceren met indexen',
	'Dynamicity' => 'Dynamiciteit',
	'Build Type' => 'Bouwtype',
	'Interval' => 'Interval',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Group iterator mislukt.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kan enkel worden gebruikt met dagelijkse, wekelijkse of maandelijkse archieven.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'U gebruikte een [_1] tag om te linken naar \'[_2]\' archieven, maar dat type archieven wordt niet gepubliceerd.',
	'You used an [_1] tag outside of the proper context.' => 'U gebruikte een [_1] tag buiten de juiste context.',
	'Could not determine entry' => 'Kon bericht niet bepalen',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',
	'No such user \'[_1]\'' => 'Geen gebruiker \'[_1]\'',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Er staat een fout in uw \'[_2]\' attribuut: [_1]',
	'[_1] must be a number.' => '[_1] moet een getal zijn.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'Het \'[_2]\' attribuut accepteert alleen een geheel getal: [_1]',
	'You used an [_1] without a author context set up.' => 'U gebruikte een [_1] zonder een auteurscontext op te zetten.',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Ongeldig weeks_start_with formaat: moet Sun|Mon|Tue|Wed|Thu|Fri|Sat zijn',
	'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
	'No such category \'[_1]\'' => 'Geen categorie \'[_1]\'',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] moet gebruikt worden in een [_2] context',
	'Cannot find package [_1]: [_2]' => 'Kan package [_1] niet vinden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fout bij sorteren [_2]: [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => 'Kan sort_by en sort_method niet samen gebruiken in [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] kan niet gebruikt worden zonder dat er archieven per categorie worden gepubliceerd.',
	'[_1] used outside of [_2]' => '[_1] gebruikt buiten [_2]',

## lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Deze \'[_1]\' tag word niet meer gebruikt.  Gelieve \'[_2]\' te gebruiken.',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'De MTCommentFields tag is niet langer beschikbaar.  Gelieve in de plaats de [_1] sjabloonmodule te includeren.',
	'Comment Form' => 'Reactieformulier',
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'TypePad authenticatie is niet ingeschakeld op deze blog.  MTRemoteSignInLink kan niet gebruikt worden.',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Om registratie van reageerders mogelijk te maken, moet u een TypePad token in uw weblogconfiguratie of gebruikersprofiel invoeren.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',
	'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'naam is verplicht.',
	'Specified WidgetSet \'[_1]\' not found.' => 'Opgegeven widgetset \'[_1]\' niet gevonden.',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> moet gebruikt worden in een categorie, of met het \'category\' attribuute van de tag.',

## lib/MT/Template/Tags/Tag.pm

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => '[_1] hoofdcategoriën en [_2] subcategorieën.',
	'[_1] top level and [_2] sub folders.' => '[_1] hoofdmappen en [_2] submappen.',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Component \'[_1]\' niet gevonden.',
	'Internal error: the importer is not found.' => 'Interne fout: de importer werd niet gevonden.',
	'Compatibility error occurred while applying \'[_1]\': [_2].' => 'Er deed zich een compatibiliteitsprobleem voor bij het toepassen van \'[_1]\': [_2].',
	'An Error occurred while applying \'[_1]\': [_2].' => 'Er deed zich een fout voor bij het toepassen van \'[_1]\': [_2].',
	'Fatal error occurred while applying \'[_1]\': [_2].' => 'Er deed zich een fatale fout voor bij het toepassen van \'[_1]\': [_2].',
	'Importer for \'[_1]\' is too old.' => 'Importeerder voor \'[_1]\' is te oud.',
	'Theme element \'[_1]\' is too old for this environment.' => 'Thema element \'[_1]\' is te oud voor deze omgeving.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1] pagina\'s',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Thema [_1] laden mislukt.',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Er deed zich een fatale fout voor bij het toepassen van element [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Er deed zich een fout voor bij het toepassen van element [_1]: [_2].',
	'Failed to copy file [_1]:[_2]' => 'Kopiëren van bestand [_1] mislukt: [_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Component \'[_1]\' versie [_2] of hoger is nodig om dit thema te kunnen gebruiken maar is niet geïnstalleerd.',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Component \'[_1]\' versie [_2] of hoger is nodig om dit thema te kunnen gebruiken maar de geïnstalleerde versie is [_3]',
	'Element \'[_1]\' cannot be applied because [_2]' => 'Element \'[_1]\' kan niet worden toegepast omdat [_2]',
	'There was an error scaling image [_1].' => 'Er deed zich een fout voor bij het schalen van de afbeelding [_1].',
	'There was an error converting image [_1].' => 'Er deed zich een fout voor bij het converteren van de afbeelding [_1].',
	'There was an error creating thumbnail file [_1].' => 'Er deed zich een fout voor bij het aanmaken van thumbnail bestand [_1].',
	'Default Prefs' => 'Standaardvoorkeuren',
	'Template Set' => 'Set sjablonen',
	'Static Files' => 'Statische bestanden',
	'Default Pages' => 'Standaardpagina\'s',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'dit element kan niet toegepast worden op een non-blog opbject.',
	'Failed to save blog object: [_1]' => 'Opslaan blogobject mislukt: [_1]',
	'default settings for [_1]' => 'standaardinstellingen voor [_1]',
	'default settings' => 'standaardinstellingen',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Een set sjabonen met [quant,_1,sjabloon,sjablonen], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets]',
	'Widget Sets' => 'Widgetsets',
	'Failed to make templates directory: [_1]' => 'Aanmaken map voor sjablonen mislukt: [_1]',
	'Failed to publish template file: [_1]' => 'Publicatie sjabloonbestand mislukt: [_1]',
	'exported_template set' => 'geëxporteerde sjabloonset',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Jobfout',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Job exitstatus',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Jobfunctie',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Job',

## lib/MT/Trackback.pm

## lib/MT/Upgrade/Core.pm
	'Upgrading asset path information...' => 'Bezig padinformatie van mediabestanden bij te werken...',
	'Creating initial website and user records...' => 'Initiële website en gebruikers aanmaken...',
	'Error saving record: [_1].' => 'Fout bij opslaan gegevens: [_1].',
	'Error creating role record: [_1].' => 'Fout bij aanmaken record voor rol: [_1].',
	'First Website' => 'Eerste website',
	'Creating new template: \'[_1]\'.' => 'Nieuw sjabloon wordt aangemaakt: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Bezig met sjablonen aan archieftypes toe te wijzen...',
	'Expiring cached MT News widget...' => 'Gecached MT Nieuws Widget aan het verversen...',
	'Error loading class: [_1].' => 'Fout bij het laden van klasse: [_1].',
	'Assigning custom dynamic template settings...' => 'Aangepaste instellingen voor dynamische sjablonen worden toegewezen...',
	'Assigning user types...' => 'Gebruikertypes worden toegewezen...',
	'Assigning category parent fields...' => 'Velden van hoofdcategorieën worden toegewezen...',
	'Assigning template build dynamic settings...' => 'Instellingen voor dynamische sjabloonopbouw worden toegewezen...',
	'Assigning visible status for comments...' => 'Status zichtbaarheid van reacties wordt toegekend...',
	'Assigning visible status for TrackBacks...' => 'Zichtbaarheidsstatus van TrackBacks wordt toegekend...',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Ongeldige upgrade-functie: [_1].',
	'Error loading class [_1].' => 'Fout bij het laden van klasse [_1].',
	'Upgrading table for [_1] records...' => 'Tabel aan het upgraden voor [_1] records...',
	'Upgrading database from version [_1].' => 'Database wordt bijgewerkt van versie [_1].',
	'Database has been upgraded to version [_1].' => 'Database is bijgewerkt naar versie [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Gebruiker \'[_1]\' deed een upgrade van de database naar versie [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' met succes bijgewerkt naar versie [_2] (schema versie [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' deed een upgrade van plugin \'[_2]\' naar versie [_3] (schema versie [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Plugin \'[_1]\' met succes geïnstalleerd.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' installeerde plugin \'[_2]\', versie [_3] (schema versie [_4]).',
	'Assigning entry comment and TrackBack counts...' => 'Tellingen aantal reacties en TrackBacks bericht aan het toekennen...',
	'Error saving [_1] record # [_3]: [_2]...' => 'Fout bij opslaan [_1] record # [_3]: [_2]...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Bezig sjabloonkoppelingen aan te maken...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2].',
	'Creating entry category placements...' => 'Bezig berichten in categoriën te plaatsen...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Categorieplaatsingen worden bijgewerkt...',
	'Assigning comment/moderation settings...' => 'Instellingen voor reacties/moderatie worden toegewezen...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => 'Gepersonaliseerd ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Deze rol werd aangemaakt door Movable Type tijdens de upgrade.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Dynamisch site bootstrapper indexsjabloon wordt verwijderd...',
	'Creating configuration record.' => 'Configuratiegegevens aan het aanmaken.',
	'Setting your permissions to administrator.' => 'Uw permissies worden ingesteld als administrator...',
	'Setting blog basename limits...' => 'Basisnaamlimieten blog worden ingesteld...',
	'Setting default blog file extension...' => 'Standaard blogbestand extensie wordt ingesteld...',
	'Updating comment status flags...' => 'Statusvelden van reacties worden bijgewerkt...',
	'Updating commenter records...' => 'Info over reageerders wordt bijgewerkt...',
	'Assigning blog administration permissions...' => 'Blog administrator permissies worden toegekend...',
	'Setting blog allow pings status...' => 'Status voor toelaten van pings per blog wordt ingesteld...',
	'Updating blog comment email requirements...' => 'Vereisten voor e-mail bij reacties op de weblog worden bijgewerkt...',
	'Assigning entry basenames for old entries...' => 'Basisnamen voor oude berichten worden toegekend...',
	'Updating user web services passwords...' => 'Web service wachtwoorden van de gebruiker worden bijgewerkt...',
	'Updating blog old archive link status...' => 'Status van oude archieflinks van blog wordt bijgewerkt...',
	'Updating entry week numbers...' => 'Weeknummers van berichten worden bijgewerkt...',
	'Updating user permissions for editing tags...' => 'Gebruikerspermissies voor het bewerken van tags worden bijgewerkt...',
	'Setting new entry defaults for blogs...' => 'Standaardinstellingen voor nieuwe blogs aan het vastleggen...',
	'Migrating any "tag" categories to new tags...' => 'Alle "tag" categorieën worden naar nieuwe tags gemigreerd...',
	'Assigning basename for categories...' => 'Basisnaam voor categorieën wordt toegekend...',
	'Assigning user status...' => 'Gebruikersstatus wordt toegekend...',
	'Migrating permissions to roles...' => 'Permissies aan het migreren naar rollen...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Reactie geplaatst',
	'Your comment has been posted!' => 'Uw reactie is geplaatst!',
	'Your comment submission failed for the following reasons:' => 'Het indienen van uw reactie mislukte omwille van volgende redenen:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating permission records to new structure...' => 'Permissies worden gemigreerd naar de nieuwe structuur...',
	'Migrating role records to new structure...' => 'Rollen worden gemigreerd naar de nieuwe structuur',
	'Migrating system level permissions to new structure...' => 'Systeempermissies worden gemigreerd naar de nieuwe structuur...',
	'Updating system search template records...' => 'Systeemzoeksjablonen worden bijgewerkt...',
	'Renaming PHP plugin file names...' => 'PHP plugin bestandsnamen aan het aanpassen...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fout bij het aanpassen van de bestandsnamen van PHP bestanden.  Kijk in het activiteitenlog voor details.',
	'Cannot rename in [_1]: [_2].' => 'Kan naam niet aanpassen in [_1]: [_2]',
	'Migrating Nofollow plugin settings...' => 'Nofollow plugin instellingen worden gemigreerd',
	'Removing unnecessary indexes...' => 'Onnodige indexen worden verwijderd...',
	'Moving metadata storage for categories...' => 'Metadata opslag voor categoriën wordt verplaatst...',
	'Upgrading metadata storage for [_1]' => 'Metadata opslag voor [_1] wordt bijgewerkt',
	'Updating password recover email template...' => 'Sjabloon wachtwoordrecuperatie e-mail wordt bijgewerkt...',
	'Assigning junk status for comments...' => 'Spamstatus wordt aan reacties toegewezen...',
	'Assigning junk status for TrackBacks...' => 'Spamstatus wordt toegekend aan TrackBacks...',
	'Populating authored and published dates for entries...' => 'Bezig creatie- en publicatiedatums voor berichten in te stellen...',
	'Updating widget template records...' => 'Bezig widgetsjablooninformatie bij te werken...',
	'Classifying category records...' => 'Categorieën aan het klasseren...',
	'Classifying entry records...' => 'Berichten aan het klasseren...',
	'Merging comment system templates...' => 'Bezig reactiesysteemsjabonen samen te voegen...',
	'Populating default file template for templatemaps...' => 'Bezig standaard sjabloonbestand voor sjabloonmappings in te stellen...',
	'Removing unused template maps...' => 'Bezig ongebruikte sjabloon-mappings te verwijderen...',
	'Assigning user authentication type...' => 'Gebruikersauthenticatietype aan het toekennen...',
	'Adding new feature widget to dashboard...' => 'Nieuw widget wordt aan dashbord toegevoegd...',
	'Moving OpenID usernames to external_id fields...' => 'OpenID gebruikersnamen aan het verplaatsen naar external_id velden...',
	'Assigning blog template set...' => 'Blog sjabloonset aan het toekennen...',
	'Assigning blog page layout...' => 'Blog pagina layout aan het toekennen...',
	'Assigning author basename...' => 'Basisnaam auteur aan het toekennen...',
	'Assigning embedded flag to asset placements...' => 'Markering voor inbedding van mediabestanden aan het toekennen...',
	'Updating template build types...' => 'Publicatietype sjablonen bij aan het werken...',
	'Replacing file formats to use CategoryLabel tag...' => 'Bestandsformaten aan het vervangen om CategoryLabel tag te gebruiken...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Generieke website aan het invullen voor huidige blogs...',
	'Generic Website' => 'Generieke website',
	'Migrating [_1]([_2]).' => 'Migratie van [_1]([_2]).',
	'Granting new role to system administrator...' => 'Niewe rol aan het geven aan systeembeheerder...',
	'Updating existing role name...' => 'Bestaande rolnamen aan het bijwerken...',
	'_WEBMASTER_MT4' => 'Webmaster',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Nieuwe rollen aan het invullen voor website...',
	'Can manage pages, Upload files and publish blog templates.' => 'Kan pagina\'s beheren, bestanden uploaden en blogsjablonen publiceren.',
	'Designer (MT4)' => 'Designer (MT4)',
	'Populating new role for theme...' => 'Nieuwe rol aan het invullen voor thema...',
	'Can edit, manage and publish blog templates and themes.' => 'Kan sjablonen en thema\'s van een blog bewerken, beheren en publiceren.',
	'Assigning new system privilege for system administrator...' => 'Nieuwe systeemprivileges aan het toekennen aan systeembeheerder...',
	'Assigning to  [_1]...' => 'Toe aan het kennen aan [_1]...',
	'Migrating mtview.php to MT5 style...' => 'Bezig mtview.php te migreren naar de MT5 versie...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Bezig DefaultSiteURL/DefaultSiteRoot te migreren naar de website...',
	'New user\'s website' => 'Website nieuwe gebruiker',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Bezig bestaande [quant,_1,blog,blogs] te migreren naar websites (met kinderen)...',
	'Error loading role: [_1].' => 'Fout bij laden rollen: [_1].',
	'New WebSite [_1]' => 'Nieuwe website [_1]',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Er deed zich een fout voor bij het aanmaken van een website tijdens de upgrade: [_1]',
	'Generated a website [_1]' => 'Website [_1] aangemaakt',
	'An error occurred during migrating a blog\'s site_url: [_1]' => 'Er deed zich een fout voor bij het migreren van de site_url van een blog: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Blog [_1] ([_2]) werd verplaatst tot onder website [_3]',
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'Technorati update-ping service aan het verwijderen van [_1] (ID:[_2]).',
	'Recovering type of author...' => 'Type auteur wordt opgehaald...',
	'Merging dashboard settings...' => 'Bezig dashboard-instellingen samen te voegen...',
	'Classifying blogs...' => 'Blogs aan het classificeren...',
	'Rebuilding permissions...' => 'Permissies opnieuw aan het opbouwen...',
	'Assigning ID of author for entries...' => 'ID van auteur wordt toegekend aan berichten...',
	'Removing widget from dashboard...' => 'Widget wordt verwijderd van dashboard...',
	'Ordering Categories and Folders of Blogs...' => 'Bezig categorieën en mappen van blogs te sorteren...',
	'Ordering Folders of Websites...' => 'Bezig mappen van websites te sorteren...',
	'Setting the \'created by\' ID for any user for whom this field is not defined...' => 'Bezig het \'created by\' ID in te stellen voor elke gebruiker waarvoor dit veld niet gedefiniëerd is...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Bezig een taal in te stellen voor elke blog om het juiste weergaveformaat voor datums te helpen kiezen...',
	'Adding notification dashboard widget...' => 'Bezig notificatiedashboardwidget toe te voegen',

## lib/MT/Upgrade/v6.pm
	'Fixing TheSchwartz::Error table...' => 'Bezig TheSchwartz::Error tabel te repareren...',
	'Migrating current blog to a website...' => 'Bezig huidige blog te migreren naar een website...',
	'Migrating the record for recently accessed blogs...' => 'Bezig de gegevens over recent gebruikte blogs te migreren...',
	'Adding Website Administrator role...' => 'Bezig Website Administrator rol toe te voegen...',
	'Migrating "This is you" dashboard widget...' => 'Bezig "Dit bent u" dashboard widget te migreren...',
	'Adding "Site stats" dashboard widget...' => 'Bezig "Sitestatistieken" dashboard widget te migreren...',
	'Reordering dashboard widgets...' => 'Bezig dashboardwidgets te herschikken...',

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Type moet worden opgegeven',
	'Registry could not be loaded' => 'Registry kon niet worden geladen',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Type moet tgz zijn.',
	'Could not read from filehandle.' => 'Kon filehandle niet lezen.',
	'File [_1] is not a tgz file.' => 'Bestand [_1] is geen tgz bestand.',
	'File [_1] exists; could not overwrite.' => 'Bestand [_1] bestaat; kon niet worden overschreven.',
	'Cannot extract from the object' => 'Kan extractie uit object niet uitvoeren',
	'Cannot write to the object' => 'Kan niet schrijven naar het object',
	'Both data and file name must be specified.' => 'Zowel data gen bestandsnaam moeten worden opgegeven.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Type moet zip zijn.',
	'File [_1] is not a zip file.' => 'Bestand [_1] is geen zip bestand.',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Standaard CAPTCHA provider van Movable Type vereist Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'U moet CaptchaSourceImageBase nog configureren.',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',
	'Image creation failed.' => 'Afbeelding aanmaken mislukt.',
	'Image error: [_1]' => 'Afbeelding fout: [_1]',

## lib/MT/Util.pm
	'moments from now' => 'ogenblikken in de toekomst',
	'[quant,_1,hour,hours] from now' => 'over [quant,_1,uur,uur]',
	'[quant,_1,minute,minutes] from now' => 'over [quant,_1,minuut,minuten]',
	'[quant,_1,day,days] from now' => 'over [quant,_1,dag,dagen]',
	'less than 1 minute from now' => 'binnen minder dan 1 minuut',
	'less than 1 minute ago' => 'minder dan 1 minuut geleden',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'over [quant,_1,uur,uur] en [quant,_2,minuut,minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,uur,uur], [quant,_2,minuut,minuten] geleden',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'over [quant,_1,dag,dagen] en [quant,_2,uur,uur]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,dag,dagen] en [quant,_2,uur,uur] geleden',
	'[quant,_1,second,seconds] from now' => 'over [quant,_1,seconde,seconden]',
	'[quant,_1,second,seconds]' => '[quant,_1,seconde,seconden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'over [quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minuut,minuten]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten]',
	'[quant,_1,hour,hours]' => '[quant,_1,uur,uren]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,dag,dagen], [quant,_2,uur,uren]',
	'[quant,_1,day,days]' => '[quant,_1,dag,dagen]',
	'Invalid domain: \'[_1]\'' => 'Ongeldig domein: \'[_1]\'',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archieftype \'[_1]\' is geen gekozen archieftype',
	'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is vereist',
	'You did not set your blog publishing path' => 'U stelde geen blogpublicatiepad in',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Hetzelfde archiefbestand bestaat al. U moet de basisnaam of het archiefpad wijzigen. ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Er deed zich een fout voor bij het publiceren van [_1] \'[_2]\': [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Er deed zich een fout voor bij het publiceren van datum-gebaseerd archief \'[_1]\': [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Tijdelijk bestand \'[_1]\' van naam veranderen mislukt: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Blog, BlogID of Template parameter moet opgegeven zijn.',
	'Template \'[_1]\' does not have an Output File.' => 'Sjabloon \'[_1]\' heeft geen uitvoerbestand.',
	'Scheduled publishing.' => 'Geplande berichten.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Er deed zich een fout voor bij het publiceren van van geplande berichten: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Er deed zich een fout voor bij het ongedaan maken van de publicatie van oude berichten: [_1]',

## lib/MT/Website.pm
	'__BLOG_COUNT' => 'Blogs',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'Achtergrondpublicatie voltooid',
	'Published: [_1]' => 'Gepubliceerd:',
	'Error rebuilding file [_1]:[_2]' => 'Fout bij rebuilden bestand [_1]: [_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- set afgerond ([quant,_1,bestand,bestanden] in [_2] seconden)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "Fout bij het rsyncen van bestanden in [_1]:
",
	'Done Synchornizing Files' => 'Bestanden synchroniseren afgelopen',
	'Done syncing files to [_1] ([_2])' => 'Klaar met synchroniseren van bestanden naar [_1] ([_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Geen WeblogsPingURL opgegeven in het configuratiebestand',
	'No MTPingURL defined in the configuration file' => 'Geen MTPingURL opgegeven in het configuratiebestand',
	'HTTP error: [_1]' => 'HTTP fout: [_1]',
	'Ping error: [_1]' => 'Ping fout: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ongeldig timestamp formaat',
	'No web services password assigned.  Please see your user profile to set it.' => 'Geen web services wachtwoord ingesteld.  Ga naar uw gebruikersprofiel om het in te stellen.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Gevraagde permalink \'[_1]\' is niet beschikbaar voor deze pagina',
	'Saving folder failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'No blog_id' => 'Geen blog_id',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Waarde voor \'mt_[_1]\' moet 0 of 1 zijn (was \'[_2]\')',
	'Not allowed to edit entry' => 'Geen toestemming om bericht te bewerken',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Bericht \'[_1]\' ([lc,_5] #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) via xml-rpc',
	'Not allowed to get entry' => 'Geen toestemming om het bericht op te halen',
	'Not allowed to set entry categories' => 'Geen toestemming om de categorieën van het bericht in te stellen',
	'Not allowed to upload files' => 'Geen toestemming om bestanden te uploaden',
	'No filename provided' => 'Geen bestandsnaam opgegeven',
	'Error writing uploaded file: [_1]' => 'Fout bij het schrijven van opgeladen bestand: [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Perl module Image::Size is nodig om de breedte en hoogte van opgeladen afbeeldingen te bepalen.',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Sjabloonmethodes zijn niet geïmplementeerd wegens het verschil tussen de Blogger API en de Movable Type API.',

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => 'Doorgaan',
	'You have unsaved changes to this page that will be lost.' => 'U heeft niet opgeslagen veranderingen op deze pagina die verloren zullen geen.',

## mt-static/chart-api/deps/raphael-min.js
	'+e.x+' => '+e.x+',

## mt-static/chart-api/mtchart.js

## mt-static/chart-api/mtchart.min.js

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Ongeldige waarde',
	'You have an error in your input.' => 'Er staat een fout in uw invoer.',
	'Invalid date format' => 'Ongeldig datumformaat',
	'Invalid URL' => 'Ongeldige URL',
	'This field is required' => 'Dit veld is verplicht',
	'This field must be an integer' => 'Dit veld moet een integer bevatten',
	'This field must be a number' => 'Dit veld moet een getal bevatten',

## mt-static/jquery/jquery.mt.min.js

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Geen voorbeeld beschikbaar',
	'Dimensions' => 'Dimensies',
	'File Name' => 'Bestandsnaam',

## mt-static/js/dialog.js
	'(None)' => '(Geen)',

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
	'+e(n.x,r)++e(n.y,r)+' => '+e(n.x,r)++e(n.y,r)+', # Translate - New
	',i(r.textLeft,2)," ",i(r.textTop,2),' => ',i(r.textLeft,2)," ",i(r.textTop,2),', # Translate - New

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titel:',
	'Description:' => 'Beschrijving:',
	'Author:' => 'Auteur:',
	'Tags:' => 'Tags:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a valid path.' => 'U moet een geldig pad instellen.',
	'You must set a path begining with %s or %a.' => 'U moet een pad instellen dat begint met %s of %a', # Translate - New

## mt-static/mt.js
	'delete' => 'verwijderen',
	'remove' => 'verwijderen',
	'enable' => 'activeren',
	'disable' => 'desactiveren',
	'publish' => 'publiceren',
	'unlock' => 'deblokkeren',
	'You did not select any [_1] to [_2].' => 'U selecteerde geen [_1] om te [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Opgelet: [_1] echt [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Bent u zeker dat u deze [_1] geselecteerde [_2] wenst te [_3]?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Bent u zeker dat u deze rol wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rol geassocieerd zijn.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Bent u zeker dat u deze [_1] rollen wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rollen geassocieerd zijn.',
	'You did not select any [_1] [_2].' => 'U selecteerde geen [_1] [_2]',
	'You can only act upon a minimum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren om minimaal [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren op maximum [_1] [_2].',
	'You must select an action.' => 'U moet een handeling selecteren',
	'to mark as spam' => 'om als spam aan te merken',
	'to remove spam status' => 'om spamstatus van te verwijderen',
	'Enter email address:' => 'Voer e-mail adres in:',
	'Enter URL:' => 'Voer URL in:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen over alle weblogs?',
	'Loading...' => 'Laden...',
	'First' => 'Eerste',
	'Prev' => 'Vorige',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] van [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',
	'Last' => 'Laatste',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Standaardtekst invoegen',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Standaardtekst',
	'Select Boilerplate' => 'Standaardtekst selecteren',

## mt-static/plugins/Loupe/js/vendor.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Volledig scherm',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Bold (Ctrl+B)' => 'Vet (Ctrl+B)',
	'Italic (Ctrl+I)' => 'Schuin (Ctrl+I)',
	'Underline (Ctrl+U)' => 'Onderlijnen (Ctrl+U)',
	'Strikethrough' => 'Doorstrepen',
	'Block Quotation' => 'Citaat',
	'Unordered List' => 'Ongeordende lijst',
	'Ordered List' => 'Genummerde lijst',
	'Horizontal Line' => 'Horizontale lijn',
	'Insert/Edit Link' => 'Link invoegen/bewerken',
	'Unlink' => 'Link verwijderen',
	'Undo (Ctrl+Z)' => 'Ongedaan maken (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'Herhalen (Ctrl+Y)',
	'Select Text Color' => 'Tekstkleur kiezen',
	'Select Background Color' => 'Achtergrondkleur kiezen',
	'Remove Formatting' => 'Formattering verwijderen',
	'Align Left' => 'Links uitlijnen',
	'Align Center' => 'Centreren',
	'Align Right' => 'Rechts uitlijnen',
	'Indent' => 'Inspringen',
	'Outdent' => 'Uitspringen',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/core.js
	'Class Name' => 'naam klasse',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'HTML invoegen',
	'Source' => 'Bron',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Insert Link' => 'Link invoegen',
	'Insert Image Asset' => 'Afbeeldingsbestand invoegen',
	'Insert Asset Link' => 'Bestandslink invoegen',
	'Toggle Fullscreen Mode' => 'Volledig scherm in/uitschakelen',
	'Toggle HTML Edit Mode' => 'HTML modus in/uitschakelen',
	'Strong Emphasis' => 'Sterke nadruk',
	'Emphasis' => 'Nadruk',
	'List Item' => 'Lijstelement',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',
	'paste.plaintext_mode' => 'paste.plaintext_mode',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'waarde',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/comments.mtml

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

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Traditioneel, klassiek blogdesign, met een ruime selectie aan stijlen en keuze tussen 2 en 3 koloms layout.  Geschikt voor standaard blogpublicatietoepassingen.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze website.',
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze website.',

## themes/classic_website/templates/archive_index.mtml

## themes/classic_website/templates/archive_widgets_group.mtml

## themes/classic_website/templates/author_archive_list.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml

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
	q{Subscribe to this website's feed} => q{Inschrijven op de feed van deze website},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Maak een blogportaal dat de inhoud van verschillende blogs samenbrengt in één website.',
	'Classic Website' => 'Klassieke website',

## themes/eiger/templates/banner_footer.mtml
	'Navigation' => 'Navigatie',
	'This blog is licensed under a <a rel="license" href="[_1]">Creative Commons License</a>.' => 'Deze weblog valt onder een <a rel="license" href="[_1]">Creative Commons Licentie</a>.',

## themes/eiger/templates/category_archive_list.mtml

## themes/eiger/templates/category_entry_listing.mtml
	'Home' => 'Hoofdpagina',
	'Pagination' => 'Paginering',
	'Related Contents (Blog)' => 'Gerelateerde inhoud (Blog)',

## themes/eiger/templates/comment_detail.mtml

## themes/eiger/templates/comment_form.mtml
	'Post a Comment' => 'Reageren',
	'Reply to comment' => 'Antwoorden op een reactie',

## themes/eiger/templates/comment_preview.mtml

## themes/eiger/templates/comment_response.mtml
	'Your comment has been received and held for approval by the blog owner.' => 'Uw reactie werd ontvangen en zal door de eigenaar van de blog worden gekeurd voor publicatie.',

## themes/eiger/templates/comments.mtml

## themes/eiger/templates/dynamic_error.mtml
	'Related Contents (Index)' => 'Gerelateerde inhoud (Index)',

## themes/eiger/templates/entries_list.mtml
	'Read more' => 'Meer lezen',

## themes/eiger/templates/entry.mtml
	'Posted on' => 'Gepubliceerd op',
	'Previous entry' => 'Vorig bericht',
	'Next entry' => 'Volgend bericht',
	'Zenback' => 'Zenback',

## themes/eiger/templates/entry_summary.mtml

## themes/eiger/templates/index_page.mtml
	'Main Image' => 'Hoofdafbeelding',

## themes/eiger/templates/javascript.mtml
	'The sign-in attempt was not successful; please try again.' => 'Aanmeldingspoging mislukt; gelieve opnieuw te proberen.',

## themes/eiger/templates/javascript_theme.mtml
	'Menu' => 'Menu',

## themes/eiger/templates/main_index.mtml

## themes/eiger/templates/navigation.mtml
	'About' => 'Over',

## themes/eiger/templates/page.mtml

## themes/eiger/templates/pages_list.mtml

## themes/eiger/templates/pagination.mtml
	'Older entries' => 'Oudere berichten',
	'Newer entries' => 'Nieuwere berichten',

## themes/eiger/templates/recent_entries.mtml

## themes/eiger/templates/sample_widget_01.mtml
	'Sample Widget' => 'Voorbeeldwidget',
	'This is sample widget' => 'Dit is een voorbeeldwidget',

## themes/eiger/templates/sample_widget_02.mtml
	'Advertisement' => 'Advertentie',

## themes/eiger/templates/sample_widget_03.mtml
	'Banner' => 'Banner',

## themes/eiger/templates/sample_widget_04.mtml
	'Links' => 'Links',
	'Link Text' => 'Linktekst',

## themes/eiger/templates/search.mtml

## themes/eiger/templates/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een exacte uitdrukking te zoeken, gelieve aanhalingstekens rond uw zoekopdracht te zetten.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'De zoekfunctie ondersteunt eveneens de sleutelwoorden AND, OR en NOT om booleaanse expressies mee op te stellen:',

## themes/eiger/templates/styles.mtml
	'for Comments, Trackbacks' => 'voor reacties, TrackBacks',
	'Sample Style' => 'Voorbeeldstijl',
	'Category Label' => 'Categorielabel',

## themes/eiger/templates/syndication.mtml

## themes/eiger/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> - [_3]</a>' => '<a href="[_1]">[_2]</a> - [_3]</a>',

## themes/eiger/templates/yearly_archive_dropdown.mtml
	'Select a Year...' => 'Selecteer een jaar...',

## themes/eiger/templates/yearly_archive_list.mtml

## themes/eiger/templates/yearly_entry_listing.mtml

## themes/eiger/templates/zenback.mtml
	'Please paste the Zenback script code here' => 'Gelieve de Zenback script code hier in te plakken',

## themes/eiger/theme.yaml
	'_THEME_DESCRIPTION' => '"Eiger" is een personaliseerbaar Responsive Web Design thema, ontworpen voor blogs en bedrijfswebsites.  Naast ondersteuning voor weergave op meerdere toestellen via Media Query (CSS), maakt Movable Type het makkelijk om de navigatie en afbeeldingen zoals logo, headers of banners aan te passen.',
	'_ABOUT_PAGE_TITLE' => 'Over pagina',
	'_ABOUT_PAGE_BODY' => '|
                 <p>Dit is een voorbeeld van een "over" pagina. (Meestal bevat een "overt" pagina informatie over het individu of bedrijf achter de site.)</p>
                 <p>Als de <code>@ABOUT_PAGE</code> tag gebruikt wordt op een pagina dan zal de "over" pagina toegevoegd worden aan de navigatie bovenaan en onderaan de site.</p>',
	'_SAMPLE_PAGE_TITLE' => 'Voorbeeldpagina',
	'_SAMPLE_PAGE_BODY' => '|
                 <p>Dit is een voorbeeld van een pagina.</p>
                 <p>Als de <code>@ADD_TO_SITE_NAV</code> tag gebruikt wordt op een pagina dan zal deze pagina toegevoegd worden aan de navigatielijst bovenaan en onderaan de site.</p>',
	'Eiger' => 'Eiger',
	'Blog Index' => 'Blog index',
	'Index Page' => 'Indexpagina',
	'Stylesheet for IE (8 or lower)' => 'Stylesheet voor IE (8 of lager)',
	'JavaScript - Theme' => 'JavaScript - Thema',
	'Yearly Entry Listing' => 'Overzicht berichten per jaar',
	'Displays errors for dynamically published templates.' => 'Fouten weergeven voor dynamisch gepubliceerde sjablonen',
	'Yearly Archives Dropdown' => 'Uitklapmenu archieven per jaar',
	'Yearly Archives' => 'Archieven per jaar',
	'Sample Widget 01' => 'Voorbeeldwidget 01',
	'Sample Widget 02' => 'Voorbeeldwidget 02',
	'Sample Widget 03' => 'Voorbeeldwidget 03',
	'Sample Widget 04' => 'Voorbeeldwidget 04',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Related Content' => 'Gerelateerde inhoud',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Voorbeeld reactie bekijken',

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
	'Subscribe' => 'Inschrijven',

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
	q{Pico is a microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Pico is een microblogthema, ontworpen om eenvoudig veel updates aan te kunnen.  Om meer focus te richten op de inhoud staan de 'zijkolommen' onderaan de lijst met berichten.},
	'Pico' => 'Pico',
	'Pico Styles' => 'Pico stijlen',
	'A collection of styles compatible with Pico themes.' => 'Een collectie stijlen die compatibel zijn met het Pico thema.',

## themes/rainier/templates/banner_footer.mtml

## themes/rainier/templates/category_archive_list.mtml

## themes/rainier/templates/category_entry_listing.mtml
	'Related Contents' => 'Gerelateerde inhoud',

## themes/rainier/templates/comment_detail.mtml

## themes/rainier/templates/comment_form.mtml

## themes/rainier/templates/comment_preview.mtml

## themes/rainier/templates/comment_response.mtml

## themes/rainier/templates/comments.mtml

## themes/rainier/templates/dynamic_error.mtml

## themes/rainier/templates/entry.mtml
	'Posted on [_1]' => 'Gepubliceerd op [_1]',
	'by [_1]' => 'door [_1]',
	'in [_1]' => 'in [_1]',

## themes/rainier/templates/entry_summary.mtml
	'Continue reading' => 'Verder lezen',

## themes/rainier/templates/javascript.mtml

## themes/rainier/templates/javascript_theme.mtml

## themes/rainier/templates/main_index.mtml

## themes/rainier/templates/monthly_archive_dropdown.mtml

## themes/rainier/templates/monthly_archive_list.mtml

## themes/rainier/templates/monthly_entry_listing.mtml

## themes/rainier/templates/navigation.mtml

## themes/rainier/templates/page.mtml
	'Last update' => 'Laatste update',

## themes/rainier/templates/pages_list.mtml

## themes/rainier/templates/pagination.mtml

## themes/rainier/templates/recent_comments.mtml
	'__VIEW_COMMENT' => '[_1] op <a href="[_2]" title="volledige reactie op: [_3]">[_3]</a>',

## themes/rainier/templates/recent_entries.mtml

## themes/rainier/templates/search.mtml

## themes/rainier/templates/search_results.mtml

## themes/rainier/templates/syndication.mtml

## themes/rainier/templates/tag_cloud.mtml

## themes/rainier/templates/trackbacks.mtml

## themes/rainier/templates/zenback.mtml
	'Please paste Zenback script code here.' => 'Gelieve de Zenback script code hier in te plakken.',

## themes/rainier/theme.yaml
	'__DESCRIPTION' => '"Rainier" is een aanpasbaar Responsive Web Design thema, ontworpen voor blogs.  Naast ondersteuning voor weergave op meerdere toestellen via Media Query (CSS) biedt het ook Movable Type functies aan om makkelijk navigatie- en afbeeldingselementen zoals logos en hoofdingen aan te passen',
	'About Page' => 'Over mezelf pagina',
	'_ABOUT_PAGE_BODY' => '|
                 <p>Dit is een voorbeeld van een "over" pagina. (Meestal bevat een "overt" pagina informatie over het individu of bedrijf achter de site.)</p>
                 <p>Als de <code>@ABOUT_PAGE</code> tag gebruikt wordt op een pagina dan zal de "over" pagina toegevoegd worden aan de navigatie bovenaan en onderaan de site.</p>',
	'Example page' => 'Voorbeeldpagina',
	'_SAMPLE_PAGE_BODY' => '|
                 <p>Dit is een voorbeeld van een pagina.</p>
                 <p>Als de <code>@ADD_TO_SITE_NAV</code> tag gebruikt wordt op een pagina dan zal deze pagina toegevoegd worden aan de navigatielijst bovenaan en onderaan de site.</p>',
	'Rainier' => 'Rainier',
	'Styles for Rainier' => 'Stijlen voor Rainier',
	'A collection of styles compatible with Rainier themes.' => 'Een verzameling stijlen compatibel met Rainier thema\'s',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Zoeken naar reacties vanaf:',
	'the beginning' => 'het begin',
	'one week ago' => 'één week geleden',
	'two weeks ago' => 'twee weken geleden',
	'one month ago' => 'één maand geleden',
	'two months ago' => 'twee maanden geleden',
	'three months ago' => 'drie maanden geleden',
	'four months ago' => 'vier maanden geleden',
	'five months ago' => 'vijf maanden geleden',
	'six months ago' => 'zes maanden geleden',
	'one year ago' => 'één jaar geleden',
	'Find new comments' => 'Nieuwe reacties zoeken',
	'Posted in [_1] on [_2]' => 'Gepubliceerd in [_1] op [_2]',
	'No results found' => 'Geen resultaten gevonden',
	'No new comments were found in the specified interval.' => 'Geen nieuwe reacties gevonden in het opgegeven interval.',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Selecteer het tijdsinterval waarin u wenst te zoeken en klik dan op 'Nieuwe reacties zoeken'},

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'ZOEKFEED AUTODISCOVERY LINK DIE ENKEL GEPUBLICEERD WORDT ALS EEN ZOEKOPDRACHT IS UITGEVOERD',
	'Blog Search Results' => 'Blog zoekresultaten',
	'Blog search' => 'Blog doorzoeken',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'GEWONE ZOEKOPDRACHTEN KRIJGEN HET ZOEKFORMULIER TE ZIEN',
	'Search this site' => 'Deze website doorzoeken',
	'Match case' => 'Kapitalisering moet overeen komen',
	'SEARCH RESULTS DISPLAY' => 'ZOEKRESULTATENSCHERM',
	'Matching entries from [_1]' => 'Gevonden berichten op [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Berichten op [_1] getagd met '[_2]'},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Gepubliceerd <MTIfNonEmpty tag="EntryAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	'Showing the first [_1] results.' => 'De eerste [_1] resultaten worden getoond.',
	'NO RESULTS FOUND MESSAGE' => 'GEEN RESULTATEN GEVONDEN BOODSCHAP',
	q{Entries matching '[_1]'} => q{Berichten met '[_1]' in},
	q{Entries tagged with '[_1]'} => q{Berichten getagd met '[_1]'},
	q{No pages were found containing '[_1]'.} => q{Er werden geen berichten gevonden met '[_1]' in.},
	'END OF ALPHA SEARCH RESULTS DIV' => 'EINDE VAN ALPHA ZOEKRESULTATEN DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGIN VAN BETA ZIJKOLOM OM ZOEKINFORMATIE IN TE TONEN',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'STEL VARIABELEN IN VOOR ZOEK vs TAG informatie',
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met de tag '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met '[_1]' in.},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ZOEK/TAG FEED INSCHRIJVINGSINFORMATIE',
	'Feed Subscription' => 'Feed inschrijving',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Wat is dit?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG OPSOMMING ENKEL VOOR TAG ZOEKEN',
	'Other Tags' => 'Andere tags',
	'END OF PAGE BODY' => 'EINDE VAN PAGINA BODY',
	'END OF CONTAINER' => 'EINDE VAN CONTAINER',

## search_templates/results_feed_rss2.tmpl
	'Search Results for [_1]' => 'Zoekresultaten voor [_1]',

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Nieuw mediabestand uploaden',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Mediabestand uploaden',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => 'Backup maken van [_1]',
	'What to Backup' => 'Wat moet gebackupt worden',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Deze optie zal een backup maken van gebruikers, rollen, associaties, blogs, berichten, categorieën, sjablonen en tags.',
	'Everything' => 'Alles',
	'Reset' => 'Leegmaken',
	'Choose websites...' => 'Websites kiezen...',
	'Archive Format' => 'Archiefformaat',
	'The type of archive format to use.' => 'Soort archiefformaat om te gebruiken',
	q{Don't compress} => q{Niet comprimeren},
	'Target File Size' => 'Grootte doelbestand',
	'Approximate file size per backup file.' => 'Bestandsgrootte bij benadering per backupbestand',
	'No size limit' => 'Geen beperking op bestandsgrootte',
	'Make Backup (b)' => 'Backup maken (b)',
	'Make Backup' => 'Backup maken',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Instellingen voor opstellen',
	'Your preferences have been saved.' => 'Uw voorkeuren zijn opgeslagen',
	'Publishing Defaults' => 'Standaardinstellingen publicatie',
	'Listing Default' => 'Standaard lijstweergave',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Selecteer het aantal dagen waarvoor of het exacte aantal berichten dat u op de voorpagina van uw weblog wenst te tonen.',
	'Days' => 'Dagen',
	'Posts' => 'Berichten',
	'Order' => 'Volgorde',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u uw berichten wenst te tonen in opklimmende (oudste bovenaan) of dalende (nieuwste bovenaan) volgorde.',
	'Ascending' => 'Oplopend',
	'Descending' => 'Aflopend',
	'Excerpt Length' => 'Lengte uittreksel',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Vul het aantal woorden in dat moet verschijnen in automatisch gegenereerde uittreksels.',
	'Date Language' => 'Datumtaal',
	'Select the language in which you would like dates on your blog displayed.' => 'Selecteer de taal waarin u de datums op uw blogs wilt weergeven.',
	'Czech' => 'Tsjechisch',
	'Danish' => 'Deens',
	'Dutch' => 'Nederlands',
	'English' => 'Engels',
	'Estonian' => 'Estlands',
	'French' => 'Frans',
	'German' => 'Duits',
	'Icelandic' => 'IJslands',
	'Italian' => 'Italiaans',
	'Japanese' => 'Japans',
	'Norwegian' => 'Noors',
	'Polish' => 'Pools',
	'Portuguese' => 'Portugees',
	'Slovak' => 'Slowaaks',
	'Slovenian' => 'Sloveens',
	'Spanish' => 'Spaans',
	'Suomi' => 'Fins',
	'Swedish' => 'Zweeds',
	'Basename Length' => 'Lengte basisnaam',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Bepaalt de standaardlengte van automatisch gegenereerde basisnamen.  Het bereik van deze instelling is tussen 15 en 250.',
	'Compose Defaults' => 'Instellingen voor opstellen',
	'Specifies the default Post Status when creating a new entry.' => 'Bepaalt de standaard status van nieuw aangemaakte berichten.',
	'Unpublished' => 'Ongepubliceerd',
	'Text Formatting' => 'Tekstopmaak',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Bepaalt de standaard tekstopmaak voor het aanmaken van een nieuw bericht.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Bepaalt de standaardinstelling voor het aanvaarden van nieuwe reacties bij nieuwe berichten.',
	'Setting Ignored' => 'Instelling genegeerd',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties zijn uitgeschakeld op blog- of systeemniveau.',
	'Note: This option is currently ignored since comments are disabled either website or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties zijn uitgeschakeld op website- of systeemniveau',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Bepaalt de standaardinstelling voor het aanvaarden van nieuwe TrackBacks bij nieuwe berichten.',
	'Accept TrackBacks' => 'TrackBacks aanvaarden',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat TrackBacks zijn uitgeschakeld op blog- of systeemniveau.',
	'Note: This option is currently ignored since TrackBacks are disabled either website or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat TrackBacks zijn uitgeschakeld op website- of systeemniveau.',
	'Entry Fields' => 'Berichtvelden',
	'_USAGE_ENTRYPREFS' => 'Selecteer de velden die getoond moeten worden in het scherm om berichten te bewerken.',
	'Page Fields' => 'Paginavelden',
	'WYSIWYG Editor Setting' => 'Instellingen WYSIWYG Editor',
	'Content CSS' => 'Inhoud CSS',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'Inhoud CSS zal toegepast worden als de editor het ondersteunt.  U kunt een CSS bestand opgeven via de URL of met de {{theme_static}} plaatsvervanger. Voorbeeld: {{theme_static}}path/to/cssfile.css',
	'Punctuation Replacement Setting' => 'Instelling plaatsing leestekens',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Vervang UTF-8 karakters die vaak worden gebruikt door tekstverwerkers door hun meer gestandaardiseerde web-equivalenten.',
	'Punctuation Replacement' => 'Vervanging leestekens',
	'No substitution' => 'Geen vervanging',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Karakter entiteiten (&amp#8221;, &amp#8220;, etc.)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{ASCII equivalenten (&quot;, ', ..., -, --)},
	'Replace Fields' => 'Velden vervangen',
	'Image default insertion options' => 'Standaardinstellingen vor invoegen afbeeldingen',
	'Use thumbnail' => 'Thumbnail gebruiken',
	'width:' => 'breedte:',
	'pixels' => 'pixels',
	'Alignment' => 'Uitlijning',
	'Left' => 'Links',
	'Center' => 'Centreren',
	'Right' => 'Rechts',
	'Link to popup window' => 'Link naar popup venster',
	'Link image to full-size version in a popup window.' => 'Link naar oorspronkelijke afbeelding in popup venster.',
	'Save changes to these settings (s)' => 'Wijzigingen aan deze instellingen opslaan (s)',
	'The range for Basename Length is 15 to 250.' => 'Basisnamen kunnen van 15 tot 250 karakters lang zijn.',
	'You must set valid default thumbnail width.' => 'U moet een geldige standaardbreedte voor thumbnails opgeven.',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Feedback instellingen',
	'Spam Settings' => 'Spaminstellingen',
	'Automatic Deletion' => 'Automatisch verwijderen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam feedback automatisch verwijderen na de tijdsduur die hieronder staat.',
	'Delete Spam After' => 'Spam verwijderen na',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Als een item langer dan dit aantal dagen als spam is gemarkeerd, wordt het automatisch gewist.',
	'days' => 'dagen',
	'Spam Score Threshold' => 'Spamscoredrempel',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Reacties en TrackBacks ontvangen een spamscoren tussen -10 (helemaal zeker spam) en +10 (helemaal zeker geen spam).  Feedback met een score die lager is dan de drempel hierboven zal als spam gemarkeerd worden.',
	'Less Aggressive' => 'Minder aggressief',
	'Decrease' => 'Verlaag',
	'Increase' => 'Verhoog',
	'More Aggressive' => 'Aggressiever',
	q{Apply 'nofollow' to URLs} => q{Toepassen van 'nofollow' op URLs},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Indien ingeschakeld krijgen alle URLs in reacties en TrackBacks automatisch de 'nofollow' linkrelatie.},
	q{'nofollow' exception for trusted commenters} => q{'nofollow' uitzondering voor vertrouwde reageerders},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{Voeg het 'nofollow' attribuut niet toe wanneer een reactie afkomstig is van een vertrouwde reageerder.},
	'Comment Settings' => 'Instellingen voor reacties',
	'Note: Commenting is currently disabled at the system level.' => 'Opmerking: reacties zijn momenteel uitgeschakeld op het systeemniveau.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Authenticatie van reacties is niet beschikbaar omdat minstens één van de vereiste Perl modules, MIME::Base64 en LWP::UserAgent, niet geïnstalleerd is.  Installeer de ontbrekende modules en herlaad deze pagina om authenticatie van reacties te configureren.',
	'Accept comments according to the policies shown below.' => 'Reacties aanvaarden volgens de regels hieronder.',
	'Setup Registration' => 'Registratie instellen',
	'Commenting Policy' => 'Reactiebeleid',
	'Immediately approve comments from' => 'Onmiddellijk reacties goedkeuren van',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Instellen wat er moet gebeuren met reacties nadat ze zijn ingevoerd.  Niet gekeurde reacties worden bewaard voor latere moderatie.',
	'No one' => 'Niemand',
	'Trusted commenters only' => 'Enkel vertrouwde reageerders',
	'Any authenticated commenters' => 'Elke geauthenticeerde reageerder',
	'Anyone' => 'Iedereen',
	'Allow HTML' => 'HTML toestaan',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Laat reageerders een beperkte set HTML tags gebruiken in hun reacties.  Alle andere HTML zal worden verwijderd.',
	'Limit HTML Tags' => 'HTML tags beperken',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Geef de lijst met HTML tags op die u wenst toe te laten in reacties.',
	'Use defaults' => 'Standaardwaarden gebruiken',
	'([_1])' => '([_1])',
	'Use my settings' => 'Mijn instellingen gebruiken',
	'E-mail Notification' => 'E-mail notificatie',
	'Specify when Movable Type should notify you of new comments.' => 'Geef op in welke gevallen Movable Type u op de hoogte moet brengen van nieuwe reacties.',
	'On' => 'Aan',
	'Only when attention is required' => 'Alleen wanneer er aandacht is vereist',
	'Off' => 'Uit',
	'Comment Display Settings' => 'Weergave-instellingen reacties',
	'Comment Order' => 'Volgorde reacties',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u reacties wenst te tonen in opgaande (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
	q{Auto-Link URLs} => q{Automatisch URL's omzetten in links},
	'Transform URLs in comment text into HTML links.' => 'URLs in reacties transformeren in HTML links.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Geeft weer welke tekstopmaakoptie moet worden gebruikt voor de opmaak van reacties van bezoekers.',
	'CAPTCHA Provider' => 'CAPTCHA dienstverlener',
	'No CAPTCHA provider available' => 'Geen CAPTCHA provider beschikbaar',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Geen CAPTCHA provider beschikbaar in dit systeem.  Gelieve te controleren of Image::Magick geïnstalleerd is en of de CaptchaSourceImageBase configuratiedirectief naar een geldige captcha-source map verwijst in de 'mt-static/images' map.},
	'Use Comment Confirmation Page' => 'Pagina voor bevestigen reacties gebruiken',
	'Use comment confirmation page' => 'Pagina voor bevestigen reacties gebruiken',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{De browser van elke reageerder zal worden doorgestuurd naar een bevestigingspagina nadat hun reactie werd geaccepteerd.},
	'Trackback Settings' => 'TrackBack instellingen',
	'Note: TrackBacks are currently disabled at the system level.' => 'Opmerking: TrackBacks zijn momenteel uitgeschakeld op systeemniveau.',
	'Accept TrackBacks from any source.' => 'TrackBacks accepteren uit elke bron',
	'TrackBack Policy' => 'TrackBack beleid',
	'Moderation' => 'Moderatie',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks modereren voor ze gepubliceerd worden.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Geef op of Movable Type u op de hoogte moet brengen van nieuwe TrackBacks.',
	'TrackBack Options' => 'TrackBack opties',
	'TrackBack Auto-Discovery' => 'Automatisch TrackBacks ontdekken',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Indien auto-discoveryh ingeschakeld is dan zullen alle HTML links in nieuwe berichten worden gevolgd en de gepaste sites zullen automatisch een TrackBack ping ontvangen.',
	'Enable External TrackBack Auto-Discovery' => 'Externe automatische TrackBack-ontdekking inschakelen',
	'Setting Notice' => 'Opmerking bij deze instelling',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Noot: deze optie kan beïnvloed worden op systeemniveau omdat uitgaande pings daar beperkt kunnen worden.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Noot: deze optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau zijn uitgeschakeld.',
	'Enable Internal TrackBack Auto-Discovery' => 'Interne automatische TrackBack-ontdekking inschakelen',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => '[_1] plugin instellingen',
	'Plugin System' => 'Plugin systeem',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin functionaliteit in- of uitschakelen voor de hele Movable Type installatie.',
	'Disable plugin functionality' => 'Plugin functionaliteit uitschakelen',
	'Disable Plugins' => 'Plugins uitschakelen',
	'Enable plugin functionality' => 'Plugin functionaliteit inschakelen',
	'Enable Plugins' => 'Plugins inschakelen',
	'_PLUGIN_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	'Find Plugins' => 'Plugins vinden',
	'Your plugin settings have been saved.' => 'Uw plugin-instellingen zijn opgeslagen.',
	'Your plugin settings have been reset.' => 'Uw plugin-instellingen zijn teruggezet op de standaardwaarden.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl gebruikt, moet u de webserver opnieuw opstarten om het effect van deze wijzigingen te zien.},
	'Your plugins have been reconfigured.' => 'Uw plugins zijn opnieuw geconfigureerd.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{    Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl draait, moet u uw webserver opnieuw starten om de wijzigingen van kracht te maken.},
	'Are you sure you want to reset the settings for this plugin?' => 'Bent u zeker dat u de instellingen voor deze plugin wil terugzetten naar de standaardwaarden?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Ben u zeker dat u plugins wenst uit te schakelen voor de hele Movable Type installatie?',
	'Are you sure you want to disable this plugin?' => 'Bent u zeker dat u deze plugin wenst uit te schakelen?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Bent u zeker dat u plugins wenst in te schakelen voor de hele Movable Type installatie? (Dit zal de instellingen van de plugins herstellen die van kracht waren voor alle plugins werden uitgeschakeld.)',
	'Are you sure you want to enable this plugin?' => 'Bent u zeker dat u deze plugin wenst in te schakelen?',
	'Settings for [_1]' => 'Instellingen voor [_1]',
	'Failed to Load' => 'Laden mislukt',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Deze plugin is niet bijgewerkt om Movable Type [_1] te ondersteunen.  Om die reden kan het zijn dat hij niet helemaal werkt.',
	'Plugin error:' => 'Pluginfout:',
	'Info' => 'Info',
	'Resources' => 'Bronnen',
	'Run [_1]' => '[_1] uitvoeren',
	'Documentation for [_1]' => 'Documentatie voor [_1]',
	'Documentation' => 'Documentatie',
	'More about [_1]' => 'Meer over [_1]',
	'Plugin Home' => 'Homepage van deze plugin',
	'Author of [_1]' => 'Auteur van [_1]',
	'Tag Attributes:' => 'Tag attributen:',
	'Text Filters' => 'Tekstfilters',
	'Junk Filters:' => 'Spamfilters:',
	'Reset to Defaults' => 'Terugzetten naar standaardwaarden',
	'No plugins with blog-level configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd die configuratie-opties hebben op weblogniveau.',
	'No plugins with configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd met configuratie-opties.',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Fout: Movable Type kon geen map aanmaken om uw [_1] in te publiceren.  Als u deze map zelf aanmaakt, zorg er dan voor dat de webserver er schrijfpermissies op heeft.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'Fout: Movable Type kon geen map aanmaken om uw dynamische sjablonen in te cachen.  U moet een map aanmaken met de naam <code>[_1]</code> in de map van uw site.',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Fout: Movable Type kon niet schrijven in de map om dynamische sjablonen in te cachen.  Controleer de schrijfpermissies van de map met de naam <code>[_1]</code> in de map van uw site.',
	'[_1] Settings' => 'Instellingen [_1]',
	'Name your blog. The name can be changed at any time.' => 'Geef uw blog een naam.  De naam kan op elk moment worden gewijzigd.',
	'Enter a description for your blog.' => 'Geef een beschrijving op voor uw weblog.',
	'Time Zone' => 'Tijdzone',
	'Select your time zone from the pulldown menu.' => 'Selecteer uw tijdzone in het uitklapmenu',
	'Time zone not selected' => 'Geen tijdzone geselecteerd',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nieuw-Zeeland - zomertijd)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale datumgrens - Oost)',
	'UTC+11' => 'UTC+11',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Oost-Australische tijd)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Centraal-Australische tijd)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japanse tijd)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chinese kusttijd)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (West-Australische tijd)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Noord-Sumatra)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Russische Federatie Zone 5)',
	'UTC+5.5 (Indian)' => 'UTC+5,5 (Indische tijd)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Russische Federatie Zone 4)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Russische Federatie Zone 3)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Tijd in Bagdad/Moskau)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Oost-Europese tijd)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Centraal-Europese tijd)',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universeel Gecoördineerde Tijd)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (West-Afrika-tijd)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Azorentijd)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantische tijd)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Newfoundland)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantische tijd)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Oostkust tijd)',
	'UTC-6 (Central Time)' => 'UTC-6 (Central tijd)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Mountain tijd)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Westkust tijd)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska tijd)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Aleutianen-Hawaïaanse tijd)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Nome tijd)',
	'Language' => 'Taal',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Als u een andere taal kiest dan de standaard taal die op systeemniveau staat ingesteld, dan moet u mogelijk de namen van bepaalde modules aanpassen in bepaalde sjablonen om andere globale modules te kunnen includeren.',
	'License' => 'Licentie',
	'Your blog is currently licensed under:' => 'Uw weblog valt momenteel onder deze licentie:',
	'Your website is currently licensed under:' => 'Uw website valt momenteel onder deze licentie:',
	'Change license' => 'Licentie aanpassen',
	'Remove license' => 'Licentie verwijderen',
	'Your blog does not have an explicit Creative Commons license.' => 'Uw weblog heeft geen expliciete Creative Commons licentie',
	'Your website does not have an explicit Creative Commons license.' => 'Uw website heeft geen expliciete Creative Commons licentie',
	'Select a license' => 'Selecteer een licentie',
	'Publishing Paths' => 'Publicatiepaden',
	'[_1] URL' => '[_1] URL',
	'Use subdomain' => 'Subdomein gebruiken',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => 'Waarschuwing: de [_1] URL aanpassen kan er toe leiden dat alle links in uw [_1] niet meer werken.',
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{De URL van uw blog.  Bestandsnaam weglaten (m.a.w. index.html).  Eindigen met '/'. Voorbeeld: http://www.voorbeeld.com/blog/},
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{De URL van uw website.  Bestandsnaam weglaten (m.a.w. index.html).  Eindigen met '/'. Voorbeeld: http://www.voorbeeld.com/},
	'[_1] Root' => '[_1] Root',
	'Use absolute path' => 'Absoluut pad gebruiken',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Waarschuwing: de root van uw [_1] aanpassen vereist het volledig opnieuw publiceren van uw [_1].',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	'Advanced Archive Publishing' => 'Geavanceerde archiefpublicatie',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Selecteer deze optie alleen als u uw archieven buiten de root van uw site wenst te publiceren.',
	'Publish archives outside of [_1] Root' => 'Archieven publiceren buiten [_1] root.',
	'Archive URL' => 'Archief-URL',
	'Warning: Changing the archive URL can result in breaking all links in your [_1].' => 'Waarschuwing: de archief-URL veranderen kan resulteren in het breken van alle links in uw [_1].',
	'The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'De URL van de archiefsectie van uw blog.  Voorbeeld: http://www.voorbeeld.com/blog/archief/',
	'The URL of the archives section of your website. Example: http://www.example.com/archives/' => 'De URL van de archiefsectie van uw website.  Voorbeeld: http://www.voorbeeld.com/archief/',
	'Warning: Changing the archive path can result in breaking all links in your [_1].' => 'Waarschuwing: het archiefpad veranderen kan resulteren in het breken van alle links in uw [_1].',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden.  Gelieve niet af te sluiten met '/' of '\'. Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	'Dynamic Publishing Options' => 'Opties dynamische publicatie',
	'Enable dynamic cache' => 'Dynamische cache inschakelen',
	'Enable conditional retrieval' => 'Conditioneel ophalen mogelijk maken',
	'Archive Settings' => 'Archiefinstellingen',
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{Voer de bestandsextensie voor het archief in. Dit kan zijn in de vorm van 'html', 'shtml', 'php', enz. Opmerking: voer het eerste punt niet in ('.').},
	'Preferred Archive' => 'Voorkeursarchief',
	'Choose archive type' => 'Kies archieftype',
	'No archives are active' => 'Geen archieven actief',
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive types used in this blog's archive templates.} => q{Gebruikt om URL's (permalinks) te genereren voor de gearchiveerde berichten van deze blog.  Kies één van de archieftypes gebruikt in de archiefsjablonen van deze blog. },
	q{Used to generate URLs (permalinks) for this website's archived entries. Choose one of the archive types used in this website's archive templates.} => q{Gebruikt om URL's (permalinks) te genereren voor de gearchiveerde berichten van deze website.  Kies één van de archieftypes gebruikt in de archiefsjablonen van deze website. },
	'Publish With No Entries' => 'Publiceren zonder berichten',
	'Publish category archive without entries' => 'Categorie-archief zonder berichten publiceren?',
	'Module Settings' => 'Instellingen module',
	'Server Side Includes' => 'Server Side Includes',
	'None (disabled)' => 'Geen (uitgeschakeld)',
	'PHP Includes' => 'PHP Includes',
	'Apache Server-Side Includes' => 'Apache Server-Side Includes',
	'Active Server Page Includes' => 'Active Server Page Includes',
	'Java Server Page Includes' => 'Java Server Page Includes',
	'Module Caching' => 'Modulecaching',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Maak het mogelijk om correct geconfigureerde modules gecached te laten worden om zo de publicatiesnelheid te verhogen.',
	'Revision History' => 'Revisie-geschiedenis',
	'Note: Revision History is currently disabled at the system level.' => 'Opmerking: revisiegeschiedenis is momenteel uitgeschakeld op systeemniveau',
	'Revision history' => 'Revisiegeschiedenis',
	'Enable revision history' => 'Revisiegeschiedenis inschakelen',
	'Number of revisions per entry/page' => 'Aantal revisies per bericht/pagina',
	'Number of revisions per template' => 'Aantal revisies per sjabloon',
	'Upload' => 'Opladen',
	'Upload Destination' => 'Uploadbestemming',
	'Allow to change at upload' => 'Toestaan om te wijzigen bij upload',
	'Rename filename' => 'Bestandsnaam veranderen',
	'Rename non-ascii filename automatically' => 'Automatisch niet-ascii bestandsnaam aanpassen.',
	'Operation if a file exists' => 'Actie als bestand al bestaat',
	'Upload and rename' => 'Uploaden en naam aanpassen',
	'Overwrite existing file' => 'Bestaand bestand overschrijven',
	'Cancel upload' => 'Upload annuleren',
	'Normalize orientation' => 'Oriëntatie normaliseren',
	'Enable orientation normalization' => 'Normalisatie oriëntatie inschakelen',
	'You must set your Blog Name.' => 'U moet uw blognaam instellen.',
	'You did not select a time zone.' => 'U selecteerde geen tijdzone',
	'You must set a valid URL.' => 'U moet een geldige URL instellen.',
	'You must set your Local file Path.' => 'U moet uw lokaal bestandspad instellen.',
	'You must set a valid Local file Path.' => 'U moet een geldig lokaal bestandspad instellen.',
	'Website root must be under [_1]' => 'Websiteroot moet vallen onder [_1]',
	'Blog root must be under [_1]' => 'Hoofdmap van de blog moet vallen onder [_1]',
	'You must set a valid Archive URL.' => 'U moet een geldige archief URL instellen.',
	'You must set your Local Archive Path.' => 'U moet uw lokaal archiefpad instellen.',
	'You must set a valid Local Archive Path.' => 'U moet een geldig lokaal archiefpad instellen.',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Registratie-instellingen',
	'Your blog preferences have been saved.' => 'Uw blogvoorkeuren zijn opgeslagen.',
	'Your website preferences have been saved.' => 'Uw websitevoorkeuren zijn opgeslagen.',
	'User Registration' => 'Gebruikersregistratie',
	'Allow registration for this website.' => 'Registratie toestaan op deze website',
	'Registration Not Enabled' => 'Registratie niet ingeschakeld',
	'Note: Registration is currently disabled at the system level.' => 'Opmerking: Registratie is momenteel uitgeschakeld op systeemniveau',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Laat bezoekers to zich te registreren als lid van deze website via één van de hieronder geselecteerde authenticatiemethodes.',
	'New Created User' => 'Nieuw aangemaakte gebruiker',
	'Select a role that you want assigned to users that are created in the future.' => 'Selecteer een rol die u automatisch wenst toe te kennen aan gebruikers die in de toekomst worden aangemaakt.',
	'(No role selected)' => '(Geen rol geselecteerd)',
	'Select roles' => 'Selecteer rollen',
	'Authentication Methods' => 'Methodes voor authenticatie',
	'Please select authentication methods to accept comments.' => 'Gelieve een authenticatiemethode te selecteren om reacties te kunnen ontvangen.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Eén of meer perl modules om deze authenticatiemethode te kunnen gebruiken ontbreken mogelijk.',

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => 'Uw instellingen zijn opgeslagen.',
	'Imager does not support ImageQualityPng.' => 'Imager ondersteunt ImageQualityPng niet.',
	'A test mail was sent.' => 'Een testmail werd verstuurd',
	'One or more of your websites or blogs are not following the base site path (value of BaseSitePath) restriction.' => 'Eén of meer van uw websites of blogs volgen de site basispad restrictie niet (waarde van BaseSitePath).',
	'(None selected)' => '(Geen geselecteerd)',
	'System Email Address' => 'Systeememailadres',
	'Send Test Mail' => 'Testmail versturen',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Dit email adres word gebruikt in de 'From:' header van elke email die door Movable Type wordt verzonden.  Email kan verstuurd worden om een wachtwoord terug te krijgen, een reageerder te registreren, notificaties te verzenden van reacties of TrackBacks, blokkeringen van gebruikers of IP adressen en in nog een paar andere gevallen.},
	'Debug Mode' => 'Debug modus',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Waardes buiten nul zorgen ervoor dat er bijkomende diagnostische informatie wordt weergegeven om problemen te helpen oplossen met uw Movable Type installatie.  Meer informatie is beschikbaar in de <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">documentatie van de debugmodus</a>.',
	'Performance Logging' => 'Performantielogging',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Loggen van performantie inschakelen, dit zal alle gebeurtenissen in het systeem rapporteren die langer duren dan het aantal seconden ingesteld in de logdrempel.',
	'Turn on performance logging' => 'Loggen van performantie inschakelen',
	'Log Path' => 'Logpad',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'De map in uw bestandssysteem waar performantielogs weggeschreven worden.  De webserver moet schrijfpermissies hebben in deze map.',
	'Logging Threshold' => 'Logdrempel',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Tijdslimiet voor niet gelogde gebeurtenissen, in seconden. Elke gebeurtenis die langer duurt dan deze hoeveelheid tijd zal worden gerapporteerd.',
	q{Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.} => q{Schakel deze instelling in om Movable Type de wijzigingen te laten bijhouden die gebruikers aanbrengen aan berichten, pagina's en sjablonen.},
	'Track revision history' => 'Revisiegeschiedenis bijhouden',
	'Site Path Limitation' => 'Sitepad beperking',
	'Base Site Path' => 'Basissitepad',
	'Allow sites to be placed only under this directory' => 'Accepteer enkel sites die in deze map geplaatst worden',
	'System-wide Feedback Controls' => 'Systeeminstellingen voor feedback',
	'Prohibit Comments' => 'Reacties verbieden',
	'This will override all individual blog settings.' => 'Deze instelling zal van toepassing zijn over alle instellingen op individuele blogs heen.',
	'Disable comments for all websites and blogs.' => 'Reacties uitschakelen voor alle websites en blogs.',
	'Prohibit TrackBacks' => 'Trackbacks verbieden',
	'Disable receipt of TrackBacks for all websites and blogs.' => 'Ontvangen van TrackBacks uitschakelen voor alle websites en blogs.',
	'Outbound Notifications' => 'Uitgaande notificaties',
	'Prohibit Notification Pings' => 'Notificatiepings verbieden',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Schakel het sturen van automatische notificatiepings uit bij het aanmaken van een bericht op eender welke blog in het systeem.',
	'Disable notification pings for all websites and blogs.' => 'Notificaties uitschakelen voor alle websites en blogs.',
	'Send Outbound TrackBacks to' => 'Uitgaande TrackBacks sturen naar',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Verstuur geen uitgaande TrackBacks en maak geen gebruik van TrackBack auto-discovery als het de bedoeling is uw installatie privé te houden.',
	'(No Outbound TrackBacks)' => '(Geen uitgaande TrackBacks)',
	'Only to websites on the following domains:' => 'Enkel naar websites onder volgende domeinen:',
	'Lockout Settings' => 'Instellingen blokkering',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{De systeembeheerders die op de hoogte gebracht moeten worden als een gebruiker of IP adres geblokkeerd wordt.  Indien geen administrators geselecteerd zijn, worden de berichten naar eht 'Systeem e-mail adres' gestuurd.},
	'Clear' => 'Leegmaken',
	'Select' => 'Selecteren',
	'User lockout policy' => 'Beleid blokkering gebruikers',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Een Movable Type gebruiker zal geblokkeerd worden als hij of zij [_1] (of meer) keer een fout wachtwoord invoert binnen [_2] seconden.',
	'IP address lockout policy' => 'Beleid blokkering IP adressen',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'Een IP adres zal geblokkeerd worden als meer dan [_1] foutieve aanmeldpogingen worden ondernomen binnen de [_2] seconden vanop hetzelfde IP adres.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Volgende IP adressen staan echter op de 'witte lijst' en zullen nooit geblokkeerd worden:},
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'De lijst met IP adressen.  Als een extern IP adres in deze lijst staat, dan zullen mislukte aanmeldpogingen niet worden geregistreerd.  Meerdere IP adressen kunnen worden opgegeven, van elkaar gescheiden met een komma of een nieuwe regel.',
	'Image Quality Settings' => 'Kwaliteitsinstellingen afbeelding',
	'Changing image quality' => 'Afbeeldingskwaliteit aan het aanpassen', # Translate - New
	'Enable image quality changing.' => 'Aanpassen afbeeldingskwaliteit inschakelen.', # Translate - New
	'Image quality(JPEG)' => 'Afbeeldingskwaliteit (JPEG)',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 75.' => 'Afbeeldingskwaliteit van geuploade JPEG afbeelding en thumbnail versie.  Deze waarde kan ingesteld worden als een geheel getal tussen 0 en 100.  Standaardwaarde is 75.',
	'Image quality(PNG)' => 'Afbeeldingskwaliteit (PNG)',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'Afbeeldingskwaliteit van geuploade PNG afbeelding en thumbnail versie.  Deze waarde kan ingesteld worden als een geheel getal tussen 0 en 9.  Standaardwaarde is 7.',
	'Send Mail To' => 'Mail verzenden naar',
	'The email address that should receive a test email from Movable Type.' => 'Het e-mail adres dat een test e-mail moet ontvangen van Movable Type.',
	'Send' => 'Versturen',
	'You must set a valid absolute Path.' => 'U moet een absoluut pad instellen.',
	'You must set an integer value between 0 and 100.' => 'U moet een geheel getal instellen tussen 0 en 100.',
	'You must set an integer value between 0 and 9.' => 'U moet een geheel getal instellen tussen 0 en 9',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Instellingen gebruiker',
	'(No website selected)' => '(Geen website geselecteerd)',
	'Select website' => 'Selecteer website',
	'Allow Registration' => 'Registratie toestaan',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Selecteer een systeembeheerder die op de hoogte gebracht moet worden wanneer nieuwe reageerders zich met succes registreren.',
	'Allow commenters to register on this system.' => 'Toestaan dat reageerders zich registreren op dit systeem.',
	'Notify the following system administrators when a commenter registers:' => 'De systeembeheerder op de hoogte brengen wanneer een reageerder zich registreert:',
	'Select system administrators' => 'Systeembeheerder kiezen',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Opmerking: systeem e-mail adres is niet ingesteld onder Systeem > Algemene Instellingen.  E-mails zullen niet worden verstuurd.',
	'Password Validation' => 'Validering wachtwoord',
	'Options' => 'Opties',
	'Should contain uppercase and lowercase letters.' => 'Moet hoofdletters en kleine letters bevatten',
	'Should contain letters and numbers.' => 'Moet letters en cijfers bevatten',
	'Should contain special characters.' => 'Moet speciale karakters bevatten',
	'Minimun Length' => 'Minimale lengte',
	'This field must be a positive integer.' => 'Dit veld moet een positief geheel getal zijn.',
	'New User Defaults' => 'Standaardinstellingen nieuwe gebruikers',
	'Personal Blog' => 'Persoonlijke blog',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Laat het systeem automatisch een nieuwe persoonlijke blog aanmaken telkens een gebruiker wordt aangemaakt.  De gebruiker zal de rol blog adminstrator krijgen op deze blog.',
	'Automatically create a new blog for each new user.' => 'Automatisch nieuwe blog aanmaken voor elke nieuwe gebruiker.',
	'Personal Blog Location' => 'Locatie persoonlijke blog',
	'Select a website you wish to use as the location of new personal blogs.' => 'Selecteer een website die u wenst te gebruiken als locatie voor nieuwe persoonlijke blogs.',
	'Change website' => 'Website aanpassen',
	'Personal Blog Theme' => 'Thema persoonlijke blog',
	'Select the theme that should be used for new personal blogs.' => 'Selecteer het thema dat gebruikt moet worden voor nieuwe peroonlike blogs.',
	'(No theme selected)' => '(Geen thema geselecteerd)',
	'Change theme' => 'Thema wijzigen',
	'Select theme' => 'Thema selecteren',
	'Default User Language' => 'Standaard taal',
	'Choose the default language to apply to all new users.' => 'Kies de standaard taal die toegepast zal worden voor alle nieuwe gebruikers',
	'Default Time Zone' => 'Standaard tijdzone',
	'Default Tag Delimiter' => 'Standaard tagscheidingsteken',
	'Define the default delimiter for entering tags.' => 'Stel het standaard teken in om tags van elkaar te onderscheiden bij het invoeren.',
	'Comma' => 'Komma',
	'Space' => 'Spatie',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Instellingen webservices',
	'Data API Settings' => 'Data API instellingen',
	'Data API' => 'Data API',
	'Enable Data API in this site.' => 'Data API inschakelen voor deze site.',
	'Enable Data API in system scope.' => 'Data API inschakelen op systeemniveau.',
	'External Notifications' => 'Externe notificaties',
	'Notify ping services of website updates' => 'Ping services op de hoogte brengen van updates aan uw website',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Wanneer deze website wordt bijgewerkt zal Movable Type automatisch de geselecteerde sites op de hoogte brengen.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => '
	Noot: deze optie wordt momenteel genegeerd omdat uitgaande notificatiepings zijn uitgeschakeld op systeemniveau.',
	'Others:' => 'Andere:',
	q{(Separate URLs with a carriage return.)} => q{(URL's van elkaar scheiden met een carriage return.)},

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Dashboard',
	'System Overview' => 'Systeemoverzicht',
	'Select a Widget...' => 'Selecteer een widget...',
	'Add' => 'Toevoegen',
	'Your Dashboard has been updated.' => 'Uw dashboard is bijgewerkt.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Bevestig publicatieconfiguratie',
	'Site Path' => 'Sitepad',
	'Parent Website' => 'Moederwebsite',
	'Please choose parent website.' => 'Gelieve de moederwebsite te kiezen',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{Vul de nieuwe URL in van uw publieke blog.  Eindig met '/'/.  Voorbeeld: http://www.voorbeeld.com},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul het pad in waar het hoofdindexbestand van uw blog gepubliceerd zal worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul het nieuwe pad in waar uw hoofdindexbestanden zich zullen bevinden.  Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Vul de nieuwe URL in van de archiefsectie van uw blog.  Voorbeeld: http://www.example.com/blog/archives/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	'Continue (s)' => 'Doorgaan (s)',
	'Back (b)' => 'Terug (b)',
	'You must set a valid Site URL.' => 'U moet een geldige URL instellen voor uw site.',
	'You must set a valid local site path.' => 'U moet een geldig lokaal site-pad instellen.',
	'You must select a parent website.' => 'U moet een moederwebsite selecteren',

## tmpl/cms/dialog/asset_edit.tmpl
	'Your edited image has been saved.' => 'U bewerkte afbeelding werd opgeslagen.',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'De metadata kan niet worden bijgewerkt omdat de metadata van deze afbeelding fouten lijkt te bevatten.',
	'Error creating thumbnail file.' => 'Fout bij aanmaken thumbnailbestand.',
	'File Size' => 'Bestandsgrootte',
	'Edit Image' => 'Afbeelding bewerken',
	'Save changes to this asset (s)' => 'Wijzigingen aan dit mediabestand opslaan (s)',
	'Close (x)' => 'Sluiten (x)',
	'Your changes have been saved.' => 'Uw wijzigingen zijn opgeslagen.',
	'An error occurred.' => 'Er deed zich een fout voor.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u de afbeelding wenst te bewerken?',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u deze dialoog wenst te sluiten?',

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Image' => 'Afbeelding invoegen',
	'Insert Asset' => 'Mediabestand invoegen',
	'Upload New File' => 'Nieuw bestand opladen',
	'Upload New Image' => 'Nieuwe afbeelding opladen',
	'Asset Name' => 'Naam mediabestand',
	'Size' => 'Grootte',
	'Next (s)' => 'Volgende (s)',
	'Insert (s)' => 'Invoegen (s)',
	'Insert' => 'Invoegen',
	'Cancel (x)' => 'Annuleren (x)',
	'No assets could be found.' => 'Kon geen mediabestand vinden',

## tmpl/cms/dialog/asset_modal.tmpl
	'Library' => 'Bibliotheek',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Afbeelding tonen in bericht/pagina',
	'Remember these settings' => 'Deze instellingen onthouden',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Bestandsopties',
	'Create entry using this uploaded file' => 'Bericht aanmaken met dit opgeladen bestand',
	'Create a new entry using this uploaded file.' => 'Maak een nieuw bericht aan met dit opgeladen bestand',
	'Finish (s)' => 'Klaar (s)',
	'Finish' => 'Klaar',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'U moet uw weblog configureren.',
	'Your blog has not been published.' => 'Uw blog is nog niet gepubliceerd.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'Blog details',
	'This is set to the same URL as the original blog.' => 'Dit wordt ingesteld op dezelfde URL als de originele blog.',
	'This will overwrite the original blog.' => 'Dit zal de originele blog overschrijven',
	'Exclusions' => 'Uitzonderingen',
	q{Exclude Entries/Pages} => q{Berichten en pagina's uitsluiten},
	'Exclude Comments' => 'Reacties uitsluiten',
	'Exclude Trackbacks' => 'TrackBacks uitsluiten',
	'Exclude Categories/Folders' => 'Categorieën en mappen uitsluiten',
	'Clone' => 'Kloon',
	'Publish archives outside of Blog Root' => 'Archieven buiten de siteroot publiceren',
	'Warning: Changing the archive URL can result in breaking all links in your blog.' => 'Waarschuwing: het aanpassen van de archief-URL kan ervoor zorgen dat alle links in uw weblog niet meer werken.',
	'Warning: Changing the archive path can result in breaking all links in your blog.' => 'Waarschuwing: het aanpassen van het archiefpad kan ervoor zorgen dat alle links in uw weblog niet meer werken.',
	'Mark the settings that you want cloning to skip' => 'Markeer de items die het kloonproces moet overslaan',
	q{Entries/Pages} => q{Berichten/pagina's},
	'Categories/Folders' => 'Categorieën/mappen',
	'Confirm' => 'Bevestigen',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'Op [_1] reageerde [_2] op [_3]',
	'Your reply:' => 'Uw antwoord:',
	'Submit reply (s)' => 'Antwoord ingeven (s)',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Er bestaan geen rollen in deze installatie.[_1]Maak een rol aan</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Er bestaan geen groepen in deze installatie.[_1]Maak een groep aan</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Er bestaan geen gebruikers in deze installatie.[_1]Maak een gebruiker aan</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Er bestaan geen blogs in deze installatie.[_1]Maak een blog aan</a>',

## tmpl/cms/dialog/edit_image.tmpl
	'W:' => 'B:',
	'H:' => 'H:',
	'Apply' => 'Toepassen',
	'Keep aspect ratio' => 'Verhouding behouden',
	'Remove All metadata' => 'Alle metadata verwijderen',
	'Remove GPS metadata' => 'GPS metadata verwijderen',
	'Rotate right' => 'Rechts draaien',
	'Rotate left' => 'Links draaien',
	'Flip horizontal' => 'Horizontaal spiegelen',
	'Flip vertical' => 'Verticaal spiegelen',
	'Crop' => 'Bijsnijden',
	'Undo' => 'Ongedaan maken',
	'Redo' => 'Herhalen',
	'Save (s)' => 'Opslaan (s)',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Er zijn niet opgeslagen wijzigingen aan deze afbeelding die verloren zullen gaan.  Bent u zeker dat u deze dialoog wil sluiten?',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Notificatie versturen',
	'You must specify at least one recipient.' => 'U moet minstens één ontvanger opgeven.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{De naam, titel en link van uw [_1] zullen verstuurd worden in de notificatie.  U kunt bijkomend een boodschap toevoegen, een uittreksel meesturen of zelfs de hele romp van de tekst.},
	'Recipients' => 'Ontvangers',
	q{Enter email addresses on separate lines or separated by commas.} => q{Vul e-mail adressen in op afzonderlijke regels of gescheiden door komma's.},
	'All addresses from Address Book' => 'Alle adressen uit het adresboek',
	'Optional Message' => 'Optionele boodschap',
	'Optional Content' => 'Optionele inhoud',
	'(Body will be sent without any text formatting applied.)' => '(Romp van de tekst zal verstuurd worden zonder enige tekstformattering.)',
	'Send notification (s)' => 'Notificaties versturen (s)',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Selecteer de revisie om de waarden in het bewerkingsscherm mee te vullen.',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Waarschuwing: u moet geuploade mediabestanden met de hand naar het nieuwe pad kopiëren.  Het is eveneens aan te raden de bestanden in het oude pad niet te verwijderen om gebroken links te vermijden.',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Insert Options' => 'Invoegopties',
	'Display [_1] in entry/page' => 'Weergeven van [_1] in bericht/pagina.',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Wachtwoord wijzigen',
	'Enter the new password.' => 'Vul het nieuwe wachtwoord in',
	'New Password' => 'Nieuw wachtwoord',
	'Confirm New Password' => 'Nieuw wachtwoord bevestigen',
	'Change' => 'Wijzig',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Publicatieprofiel',
	'Choose the profile that best matches the requirements for this blog.' => 'Kies het publicatieprofiel dat het beste overeenkomt met de noden van deze blog.',
	'Static Publishing' => 'Statisch publiceren',
	'Immediately publish all templates statically.' => 'Alle sjablonen onmiddellijk statisch publiceren',
	'Background Publishing' => 'Pubiceren in de achtergrond',
	'All templates published statically via Publish Que.' => 'Alle sjablonen statisch publiceren via de publicatiewachtrij',
	'High Priority Static Publishing' => 'Statisch publiceren met hoge prioriteit',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Onmiddellijk hoofdindesjabloon, berichtarchieven en pagina-archieven statisch publiceren.  Gebruik de publicatiewachtrij om alle andere sjablonen statisch te publiceren.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Onmiddellijk hoofdindexsjablonen en pagina-archieven statisch publiceren.  Gebruik de publicatiewachtrij om alle andere sjablonen statisch te publiceren.',
	'Dynamic Publishing' => 'Dynamisch publiceren',
	'Publish all templates dynamically.' => 'Alle sjablonen dynamisch publiceren.',
	'Dynamic Archives Only' => 'Enkel archieven dynamisch',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Alle archiefsjablonen dynamisch publiceren.  Alle andere sjablonen statisch publiceren.',
	'This new publishing profile will update your publishing settings.' => 'Dit nieuwe publicatieprofiel zal uw publicatie-instellingen bijwerken.',
	'Are you sure you wish to continue?' => 'Bent u zeker dat verder u wenst te gaan?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'Wachtwoord opnieuw instellen',
	'The email address provided is not unique.  Please enter your username.' => 'Het opgegeven e-mail adres is niet uniek.  Gelieve uw gebruikersnaam op te geven.',
	'Back (x)' => 'Terug (x)',
	'Sign in to Movable Type (s)' => 'Aanmelden op Movable Tpe (s)',
	'Sign in to Movable Type' => 'Aanmelden op Movable Type',
	'Reset (s)' => 'Reset (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Globale sjablonen verversen',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Kan sjabloonset niet vinden.  Gelieve een [_1]thema[_2] toe te passen om uw sjablonen te vernieuwen.',
	'Revert modifications of theme templates' => 'Wijzignen aan themasjablonen ongedaan maken',
	'Reset to theme defaults' => 'Terugkeren naar standaardinstellingen',
	q{Deletes all existing templates and install the selected theme's default.} => q{Verwijdert alle bestaande sjablonen en installeert de standaardinstellingen van het geselecteerde thema.},
	'Refresh global templates' => 'Globale sjablonen verversen',
	'Reset to factory defaults' => 'Terug naar fabrieksinstellingen',
	q{Deletes all existing templates and installs factory default template set.} => q{Verwijdert alle bestaande sjablonen en installeert de standaard sjabloonset uit de 'fabrieksinstellingen'.},
	'Updates current templates while retaining any user-created templates.' => 'Ververst de huidige sjabonen maar bewaart sjablonen aangemaakt door gebruikers.',
	'Make backups of existing templates first' => 'Eerst backups nemen van bestaande sjablonen',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'U heeft gevraagd om <strong>de huidige sjabloonset te verversen</strong>.  Deze actie zal:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'U heeft gevraagd om <strong>de huidige set sjabonen te verversen</strong>.  Deze actie zal:',
	'make backups of your templates that can be accessed through your backup filter' => 'backups maken van uw sjabonen, die toegankelijk zijn via de backup filter',
	'potentially install new templates' => 'potentiëel nieuwe sjablonen installeren',
	'overwrite some existing templates with new template code' => 'enkele bestaande sjablonen overschrijven met nieuwe sjablooncode',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'U heeft gevraagd om <strong>een nieuwe sjabloonset toe te passen</strong>. Deze actie zal:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'U heeft gevraagd om <strong>de standaard globale sjablonen terug te zetten</strong>. Deze actie zal:',
	'delete all of the templates in your blog' => 'alle sjablonen in uw blog verwijderen',
	'install new templates from the selected template set' => 'nieuwe sjablonen installeren uit de geselecteerde sjabloonset',
	'delete all of your global templates' => 'al uw globale sjablonen verwijderen',
	'install new templates from the default global templates' => 'nieuwe sjablonen installeren uit de standaard globale sjablonen',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Er deed zich een fout voor tijdens het terugzetten: [_1] Gelieve uw restore-bestand na te kijken.',
	'View Activity Log (v)' => 'Activiteitenlog bekijken (v)',
	'All data restored successfully!' => 'Alle gegevens met succes teruggezet!',
	'Close (s)' => 'Sluiten (s)',
	'Next Page' => 'Volgende pagina',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Deze pagina zal binnen drie seconden doorverwijzen naar een andere pagina. [_1]Stop de doorverwijzing[_2]',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Terug aan het zetten...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Terugzetten: meerdere bestanden',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'De procedure nu stopzetten zal wees-objecten achterlaten.  Bent u zeker dat u de restore-operatie wenst te annuleren.',
	'Please upload the file [_1]' => 'Gelieve bestand [_1] te uploaden',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant website permission to user' => 'Websitepermissie toekennen aan gebruiker',
	'Grant blog permission to user' => 'Blogpermissie toekennen aan gebruiker',
	'Grant website permission to group' => 'Websitepermissie toekennen aan groep',
	'Grant blog permission to group' => 'Blogpermissie toekennen aan groep',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Selecteer thema voor persoonlijke blog',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Mediabestand bewerken',
	'Stats' => 'Statistieken',
	'[_1] - Created by [_2]' => '[_1] - aangemaakt door [_2]',
	'[_1] - Modified by [_2]' => '[_1] - aangepast door [_2]',
	'Appears in...' => 'Komt voor in...',
	'This asset has been used by other users.' => 'Dit mediabestand werd ook gebruikt door andere gebruikers.',
	'Related Assets' => 'Gerelateerde mediabestanden',
	'[_1] is missing' => '[_1] ontbreekt',
	'Embed Asset' => 'Mediabestand embedden',
	'You must specify a name for the asset.' => 'U moet een naam opgeven voor het mediabestand.',
	'You have unsaved changes to this asset that will be lost.' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Profiel bewerken',
	'This profile has been updated.' => 'Dit profiel werd bijgewerkt.',
	'A new password has been generated and sent to the email address [_1].' => 'Een nieuw wachtwoord werd gegenerereerd en is verzonden naar het e-mail adres [_1].',
	'This profile has been unlocked.' => 'Dit profiel werd gedeblokkeerd',
	'This user was classified as pending.' => 'Deze gebruiker werd geclassificeerd als in aanvraag',
	'This user was classified as disabled.' => 'Deze gebruiker werd geclassificeerd als gedeactiveerd',
	'This user was locked out.' => 'Deze gebruiker werd geblokkeerd',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Als u deze gebruiker wenst te deblokkeren, klik dan op de 'Deblokkeren' link. <a href="[_1]">Deblokkeren</a>},
	'User properties' => 'Eigenschappen gebruiker',
	'Your web services password is currently' => 'Uw huidig webservices wachtwoord is',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'U staat op het punt het wachtwoord voor \"[_1]\" opnieuw in te stellen.  Een nieuw wachtwoord zal willekeurig worden aangemaakt en zal rechtstreeks naar het e-mail adres van deze gebruiker ([_2]) worden gestuurd.\n\nWenst u verder te gaan?',
	'Error occurred while removing userpic.' => 'Er deed zich een fout voor bij het verwijderen van de gebruikersafbeelding',
	'_USER_STATUS_CAPTION' => 'status',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Status van de gebruiker in het systeem.  Een gebruiker uitschakelen voorkomt dat deze persoon het systeem nog gebruikt maar bewaart zijn inhoud en geschiedenis.',
	'_USER_ENABLED' => 'Ingeschakeld',
	'_USER_PENDING' => 'Te keuren',
	'_USER_DISABLED' => 'Uitgeschakeld',
	'The username used to login.' => 'Gebruikersnaam om mee aan te melden',
	'External user ID' => 'Extern user ID',
	'The name displayed when content from this user is published.' => 'De naam die getoond wordt wanneer inhoud van deze gebruiker wordt gepubliceerd.',
	'The email address associated with this user.' => 'Het e-mail adres gekoppeld aan deze gebruiker',
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{De website van deze gebruiker (m.a.w. http://www.mijnsite.com).  Als de website URL en getoonde naam velden allebei ingevuld zijn, dan zal Movable Type standaard berichten en reacties publiceren met onderschriften gelinkt naar deze URL.},
	'The image associated with this user.' => 'De afbeelding verbonden aan deze gebruiker',
	'Select Userpic' => 'Selecteer foto gebruiker',
	'Remove Userpic' => 'Verwijder foto gebruiker',
	'Current Password' => 'Huidig wachtwoord',
	'Existing password required to create a new password.' => 'Bestaand wachtwoord vereist om een nieuw wachtwoord aan te maken',
	'Initial Password' => 'Initiëel wachtwoord',
	'Enter preferred password.' => 'Gekozen wachtwoord invoeren',
	'Confirm Password' => 'Wachtwoord bevestigen',
	'Repeat the password for confirmation.' => 'Herhaal het wachtwoord ter bevestiging.',
	'Password recovery word/phrase' => 'Woord/uitdrukking om wachtwoord terug te vinden',
	'This word or phrase is not used in the password recovery.' => 'Dit woord of deze uitdrukking wordt niet gebruikt in het woord of de uitdrukking voor het terugvinden van het wachtwoord.',
	'Preferences' => 'Voorkeuren',
	'Display language for the Movable Type interface.' => 'Getoonde taal van de Movable Type interface.',
	'Text Format' => 'Tekstformaat',
	q{Default text formatting filter when creating new entries and new pages.} => q{Standaard tekstformatteringsfilter bij het aanmaken van berichten en pagina's},
	'(Use Website/Blog Default)' => '(Standaard van blog/website gebruiken)',
	'Date Format' => 'Datumformaat',
	'Default date formatting in the Movable Type interface.' => 'Standaard datumformattering in de Movable Type interface.',
	'Relative' => 'Relatief',
	'Full' => 'Volledig',
	'Tag Delimiter' => 'Scheidingsteken tags',
	'Preferred method of separating tags.' => 'Voorkeursmethode om tags van elkaar te scheiden',
	'Web Services Password' => 'Webservices wachtwoord',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Voor gebruik door activiteiten-feeds en met XML-RPC en Atom-gebaseerde cliënten.',
	'Reveal' => 'Onthul',
	'System Permissions' => 'Systeempermissies',
	'Create personal blog for user' => 'Persoonlijke blog aanmaken voor gebruiker',
	'Create User (s)' => 'Gebruiker aanmaken (s)',
	'Save changes to this author (s)' => 'Wijzigingen aan deze auteur opslaan (s)',
	'_USAGE_PASSWORD_RESET' => 'Hieronder kunt u een nieuw wachtwoord laten instellen voor deze gebruiker.  Als u ervoor kiest om dit te doen, zal een willekeurig gegenereerd wachtwoord worden aangemaakt en rechtstreeks naar volgend e-mail adres worden verstuurd: [_1].',
	'Initiate Password Recovery' => 'Procedure starten om wachtwoord terug te halen',

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Blog aanmaken',
	'Your blog configuration has been saved.' => 'Uw blogconfiguratie is opgeslagen',
	'Blog Theme' => 'Blogthema',
	'Select the theme you wish to use for this blog.' => 'Selecteer het thema dat u wenst te gebruiken op deze blog.',
	'Name your blog. The blog name can be changed at any time.' => 'Geef uw blog een naam.  De blognaam kan op elk moment aangepast worden.',
	'Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Vul de URL in van uw blog.  Laat de bestandsnaam (bv. index.html) vallen.  Voorbeeld: http://www.voorbeeld.com/blog/',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden zich zullen bevinden. Een absoluut pad (beginnend met \'/\' onder Linux of \'C:\' onder Windows) verdient de voorkeur. Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden zich zullen bevinden.  Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'Selecteer uw tijdzone in de keuzelijst.',
	'Create Blog (s)' => 'Blog aanmaken (s)',
	'You must set your Local Site Path.' => 'U dient het lokale pad van uw site in te stellen.',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Categorie bewerken',
	'Useful links' => 'Nuttige links',
	'Manage entries in this category' => 'Berichten beheren in deze categorie',
	'You must specify a label for the category.' => 'U moet een label opgeven voor de categorie.',
	'You must specify a basename for the category.' => 'U moet een basisnaam opgeven voor de categorie.',
	'Please enter a valid basename.' => 'Gelieve een geldige basisnaam in te vullen.',
	'_CATEGORY_BASENAME' => 'Basename',
	'This is the basename assigned to your category.' => 'Dit is de basisnaam toegekend aan uw categorie',
	q{Warning: Changing this category's basename may break inbound links.} => q{Waarschuwing: de basisnaam van deze categorie veranderen kan inkomende links verbreken.},
	'Inbound TrackBacks' => 'Inkomende TrackBacks',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Indien ingeschakeld, zullen TrackBacks voor deze categorie worden aanvaard uit elke bron.',
	'View TrackBacks' => 'TrackBacks bekijken',
	'TrackBack URL for this category' => 'TrackBack URL voor deze categorie',
	'_USAGE_CATEGORY_PING_URL' => 'Dit is de URL die anderen zullen gebruiken om TrackBacks naar uw weblog te sturen.  Als u wenst dat eender wie een TrackBack naar uw weblog kan sturen indien ze een bericht hebben dat specifiek is aan deze categrie, maak deze URL dan bekend.  Als u wenst dat bekenden TrackBacks kunnen sturen, bezorg hen dan deze URL.  Om een lijst van binnengekomen TrackBacks aan uw hoofdindexsjabloon teo te voegen, kijk in de documentatie en zoek naar sjabloontags die te maken hebben met TrackBacks.',
	'Passphrase Protection' => 'Wachtwoordbeveiliging',
	'Outbound TrackBacks' => 'Uitgaande TrackBacks',
	q{Trackback URLs} => q{TrackBack URL's},
	q{Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)} => q{Vul de URL(s) in van de websites waar u een TrackBack naartoe wenst te sturen elke keer u een bericht aanmaakt in deze categorie.  (Splits URL's van elkaar met een carriage return.)},
	'Save changes to this category (s)' => 'Wijzigingen aan deze categorie opslaan (s)',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Details reageerder',
	'The commenter has been trusted.' => 'Deze reageerder wordt vertrouwd.',
	'The commenter has been banned.' => 'Deze reageerder is verbannen.',
	'Comments from [_1]' => 'Reacties van [_1]',
	'commenter' => 'reageerder',
	'commenters' => 'reageerders',
	'to act upon' => 'om de handeling op uit te voeren',
	'Trust user (t)' => 'Gebruiker vertrouwen (t)',
	'Trust' => 'Vertrouwen',
	'Untrust user (t)' => 'Gebruiker niet meer vertrouwen (r)',
	'Untrust' => 'Niet vetrouwen',
	'Ban user (b)' => 'Gebruiker verbannen (b)',
	'Ban' => 'Verban',
	'Unban user (b)' => 'Ban op gebruiker opheffen',
	'Unban' => 'Ban opheffen',
	'The Name of the commenter' => 'Naam van de reageerder',
	'View all comments with this name' => 'Alle reacties met deze naam bekijken',
	'Identity' => 'Identiteit',
	'The Identity of the commenter' => 'De identiteit van de reageerder',
	'View' => 'Bekijken',
	'The Email Address of the commenter' => 'Het e-mail adres van de reageerder',
	'Withheld' => 'Niet onthuld',
	'View all comments with this email address' => 'Alle reacties met dit e-mail adres bekijken',
	'The Website URL of the commenter' => 'De website URL van de reageerder',
	'The trusted status of the commenter' => 'De vertrouwd/niet-vertrouwd status van de reageerder',
	'Trusted' => 'Vertrouwde',
	'Authenticated' => 'Bevestigd',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'De reactie is goedgekeurd.',
	'This comment was classified as spam.' => 'Deze reactie werd geclassificeerd als spam',
	'Total Feedback Rating: [_1]' => 'Totale feedbackscore: [_1]',
	'Test' => 'Test',
	'Score' => 'Score',
	'Results' => 'Resultaten',
	'Save changes to this comment (s)' => 'Wijzigingen aan deze reactie opslaan (s)',
	'comment' => 'reactie',
	'comments' => 'reacties',
	'Delete this comment (x)' => 'Deze reactie verwijderen (x)',
	'Manage Comments' => 'Reacties beheren',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'Bekijk [_1] reactie achtergelaten op',
	'Reply to this comment' => 'Antwoorden op deze reactie',
	'Update the status of this comment' => 'Status van dit bericht bijwerken',
	'Reported as Spam' => 'Gerapporteerd als spam',
	'View all comments with this status' => 'Alle reacties met deze status bekijken',
	'The name of the person who posted the comment' => 'De naam van de persoon die deze reactie',
	'View all comments by this commenter' => 'Alle reacties van deze reageerder bekijken',
	'View this commenter detail' => 'Details over deze reageerder bekijken',
	'(Trusted)' => '(Vertrouwd)',
	'Untrust Commenter' => 'Wantrouw reageerder',
	'Ban Commenter' => 'Verban reageerder',
	'(Banned)' => '(uitgesloten)',
	'Trust Commenter' => 'Vertrouw reageerder',
	'Unban Commenter' => 'Ontban reageerder',
	'(Pending)' => '(wacht op moderatie)',
	'Email address of commenter' => 'E-mail adres reageerder',
	'Unavailable for OpenID user' => 'Niet beschikbaar voor OpenID gebruiker',
	'Email' => 'E-mail',
	'URL of commenter' => 'URL van de reageerder',
	'No url in profile' => 'Geen URL in profiel',
	'View all comments with this URL' => 'Alle reacties met deze URL bekijken',
	'[_1] this comment was made on' => '[_1] waarop deze reactie werd achtergelaten',
	'[_1] no longer exists' => '[_1] bestaat niet meer',
	'View all comments on this [_1]' => 'Alle reacties bekijken op [_1]',
	'Date' => 'Datum',
	'Date this comment was made' => 'Datum van deze reactie',
	'View all comments created on this day' => 'Alle reacties van die dag bekijken',
	'IP Address of the commenter' => 'IP adres van de reageerder',
	'View all comments from this IP Address' => 'Alle reacties van dit IP-adres bekijken',
	'Fulltext of the comment entry' => 'Volledige tekst van de reactie',
	'Responses to this comment' => 'Antwoorden op dit bericht',

## tmpl/cms/edit_entry_batch.tmpl
	q{Batch Edit Pages} => q{Pagina's bewerken in bulk},
	'Save these [_1] (s)' => 'Deze [_1] opslaan (s)',
	'Published Date' => 'Publicatiedatum',
	'Unpublished (Draft)' => 'Niet gepubliceerd (klad)',
	'Unpublished (Review)' => 'Niet gepubliceerd (na te kijken)',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Pagina bewerken',
	'Create Page' => 'Pagina aanmaken',
	'Add new folder parent' => 'Nieuwe bovenliggende map toevoegen',
	q{Manage Pages} => q{Pagina's beheren},
	'Preview this page (v)' => 'Voorbeeld pagina bekijken (v)',
	'Delete this page (x)' => 'Pagina verwijderen (x)',
	'View Page' => 'Pagina bekijken',
	'Edit Entry' => 'Bericht bewerken',
	'Create Entry' => 'Nieuw bericht opstellen',
	'Category Name' => 'Naam categorie',
	'Add new category parent' => 'Nieuwe bovenliggende categorie toevoegen',
	'Manage Entries' => 'Berichten beheren',
	'Preview this entry (v)' => 'Voorbeeld bericht bekijken (v)',
	'Delete this entry (x)' => 'Bericht verwijderen (x)',
	'View Entry' => 'Bericht bekijken',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Een veiligheidskopie van dit bericht werd automatisch opgeslagen [_2]. <a href="[_1]">Automatisch opgeslagen inhoud terughalen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Een veiligheidskopie van deze pagina werd automatisch opgeslagen [_2]. <a href="[_1]">Automatisch opgeslagen inhoud terughalen</a>',
	'This entry has been saved.' => 'Dit bericht werd opgeslagen',
	'This page has been saved.' => 'Deze pagina werd opgeslagen',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Eén of meer problemen deden zich voor bij het versturen van update pings of TrackBacks.',
	'_USAGE_VIEW_LOG' => 'Controleer het <a href=\"[_1]\">Activiteitenlog</a> op deze fout.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Uw voorkeuren zijn opgeslagen en het formulier hieronder is aangepast.',
	'Your changes to the comment have been saved.' => 'Uw wijzigingen aan de reactie zijn opgeslagen.',
	'Your notification has been sent.' => 'Uw notificatie is verzonden.',
	'You have successfully recovered your saved entry.' => 'Veiligheidskopie van opgeslagen bericht met succes teruggehaald.',
	'You have successfully recovered your saved page.' => 'Veiligheidskopie van opgeslagen pagina met succes teruggehaald.',
	'An error occurred while trying to recover your saved entry.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen bericht.',
	'An error occurred while trying to recover your saved page.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen pagina.',
	'You have successfully deleted the checked comment(s).' => 'Verwijdering van de geselecteerde reactie(s) is geslaagd.',
	'You have successfully deleted the checked TrackBack(s).' => 'U heeft de geselecteerde TrackBack(s) met succes verwijderd.',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Teruggeplaatste revisie (Datum:[_1]).  De huidige status is: [_1]',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Sommige tags in de revisie konden niet worden geladen omdat ze werden verwijderd.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Sommige [_1] in de revisie konden niet worden geladen omdat ze werden verwijderd.',
	'This post was held for review, due to spam filtering.' => 'Dit bericht werd in de moderatiewachtrij geplaatst door de spamfilter.',
	'This post was classified as spam.' => 'Dit bericht werd geclassificeerd als spam.',
	'Add folder' => 'Map toevoegen',
	'Change Folder' => 'Map wijzigen',
	'Unpublished (Spam)' => 'Niet gepubliceerd (spam)',
	'Revision: <strong>[_1]</strong>' => 'Revisie: <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Revisies bekijken van [_1]',
	'View revisions' => 'Revisies bekijken',
	'No revision(s) associated with this [_1]' => 'Geen revisies geassociëerd met [_1]',
	'[_1] - Published by [_2]' => '[_1] - gepubliceerd door [_2]',
	'[_1] - Edited by [_2]' => '[_1] - bewerkt door [_2]',
	'Publish this [_1]' => 'Publiceer [_1]',
	'Draft this [_1]' => 'Maak [_1] klad',
	'Schedule' => 'Plannen',
	'Update' => 'Bijwerken',
	'Update this [_1]' => 'Werk [_1] bij',
	'Unpublish this [_1]' => 'Maak publicatie van [_1] ongedaan',
	'Save this [_1]' => '[_1] bewaren',
	'You must configure this blog before you can publish this entry.' => 'U moet deze weblog configureren voor u dit bericht kunt publiceren.',
	'You must configure this blog before you can publish this page.' => 'U moet deze weblog configureren voor u deze pagina kunt publiceren.',
	'Publish On' => 'Publiceren op',
	'@' => '@',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Waarschuwing: de basisnaam van het bericht met de hand aanpassen kan een conflict met een ander bericht veroorzaken.',
	q{Warning: Changing this entry's basename may break inbound links.} => q{Waarschuwing: de basisnaam van het bericht aanpassen kan inkomende links breken.},
	'Change note' => 'Notitie wijzigen',
	'Add category' => 'Categorie toevoegen',
	'edit' => 'bewerken',
	'close' => 'Sluiten',
	'Accept' => 'Aanvaarden',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Eerder verzonden TrackBacks bekijken',
	'Outbound TrackBack URLs' => 'Uitgaande TrackBack URLs',
	'[_1] Assets' => '[_1] mediabestanden',
	'Remove this asset.' => 'Dit mediabestand verwijderen.',
	'No assets' => 'Geen mediabestanden',
	'You have unsaved changes to this entry that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit bericht die verloren zullen gaan.',
	'Enter the link address:' => 'Vul het adres van de link in:',
	'Enter the text to link to:' => 'Vul de tekst van de link in:',
	'Converting to rich text may result in changes to your current document.' => 'Converteren naar Rich Text kan wijzigingen aan uw document tot gevolg hebben.',
	'Make primary' => 'Maak dit een hoofdcategorie',
	'Fields' => 'Velden',
	'Reset display options to blog defaults' => 'Opties schermindeling terugzetten naar blogstandaard',
	'Reset defaults' => 'Standaardinstellingen terugzetten',
	'Permalink:' => 'Permalink:',
	'Share' => 'Delen',
	'Format:' => 'Formaat:',
	q{(comma-delimited list)} => q{(lijst gescheiden met komma's)},
	'(space-delimited list)' => '(lijst gescheiden met spaties)',
	q{(delimited by '[_1]')} => q{(gescheiden door '[_1]')},
	'Not specified' => 'Niet opgegeven',
	'None selected' => 'Geen geselecteerd',
	'Auto-saving...' => 'Auto-opslaan...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Laatste auto-opslag om [_1]:[_2]:[_3]',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Map bewerken',
	'Manage Folders' => 'Mappen beheren',
	q{Manage pages in this folder} => q{Pagina's in deze map beheren},
	'You must specify a label for the folder.' => 'U moet een naam opgeven voor de map',
	'Path' => 'Pad',
	'Save changes to this folder (s)' => 'Wijzigingen aan deze map opslaan (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'TrackBack bewerken',
	'The TrackBack has been approved.' => 'De TrackBack is goedgekeurd.',
	'This trackback was classified as spam.' => 'Deze TrackBack werd geclassificeerd als spam.',
	'Save changes to this TrackBack (s)' => 'Wijzigingen aan deze TrackBack opslaan (s)',
	'Delete this TrackBack (x)' => 'Deze TrackBack verwijderen (x)',
	'Manage TrackBacks' => 'TrackBacks beheren',
	'Update the status of this TrackBack' => 'Status van deze TrackBack bijwerken',
	'View all TrackBacks with this status' => 'Alle TrackBacks met deze status bekijken',
	'Search for other TrackBacks from this site' => 'Andere TrackBacks van deze site zoeken',
	'Search for other TrackBacks with this title' => 'Andere TrackBacks met deze titel zoeken',
	'Search for other TrackBacks with this status' => 'Andere TrackBacks met deze status zoeken',
	'Target [_1]' => 'Doel [_1]',
	'Entry no longer exists' => 'Bericht bestaat niet meer',
	'No title' => 'Geen titel',
	'View all TrackBacks on this entry' => 'Alle TrackBacks op dit bericht bekijken',
	'Target Category' => 'Doelcategorie',
	'Category no longer exists' => 'Categorie bestaat niet meer',
	'View all TrackBacks on this category' => 'Alle TrackBacks op deze categorie bekijken',
	'View all TrackBacks created on this day' => 'Bekijk alle TrackBacks aangemaakt op deze dag',
	'View all TrackBacks from this IP address' => 'Alle TrackBacks van dit IP adres bekijken',
	'TrackBack Text' => 'TrackBack-tekst',
	'Excerpt of the TrackBack entry' => 'Uittreksel van het TrackBackbericht',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Rol bewerken',
	'Association (1)' => 'Associatie (1)',
	'Associations ([_1])' => 'Associaties ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'U heeft de rechten van deze rol aangepast.  Hierdoor is gewijzigd wat gebruikers kunnen doen die met deze rol zijn geassocieerd.  Als u dat verkiest, kunt u deze rol ook opslaan met een andere naam.  In het andere geval moet u er zich van bewust zijn welke wijzigingen er gebeuren bij gebruikers met deze rol.',
	'Role Details' => 'Rol details',
	'System' => 'Systeem',
	'Privileges' => 'Privileges',
	'Administration' => 'Administratie',
	'Authoring and Publishing' => 'Schrijven en publiceren',
	'Designing' => 'Ontwerpen',
	'Commenting' => 'Reageren',
	'Duplicate Roles' => 'Dubbele rollen',
	'These roles have the same privileges as this role' => 'Deze rollen hebben dezelfde rechten als deze rol',
	'Save changes to this role (s)' => 'Wijzigingen aan deze rol opslaan (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Widget bewerken',
	'Create Widget' => 'Widget aanmaken',
	'Create Template' => 'Sjabloon aanmaken',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => '[_1] werd automatisch opgeslagen [_3]. <a href="[_2]">Automatisch opgeslagen versie terughalen</a>',
	'You have successfully recovered your saved [_1].' => '[_1] met succes teruggehaald.',
	'An error occurred while trying to recover your saved [_1].' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen [_1]',
	'Restored revision (Date:[_1]).' => 'Revisie teruggezet (Datum:[_1]).',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publiceer</a> dit sjabloon.',
	'Your [_1] has been published.' => 'Uw [_1] is opnieuw gepubliceerd.',
	'View revisions of this template' => 'Revisies bekijken van dit sjabloon',
	'No revision(s) associated with this template' => 'Geen revisie(s) geassocieerd met dit sjabloon',
	'Useful Links' => 'Nuttige links',
	'List [_1] templates' => 'Toon [_1] sjablonen',
	'Module Option Settings' => 'Instellingen opties module',
	'List all templates' => 'Alle sjablonen tonen',
	'View Published Template' => 'Gepubliceerd sjabloon bekijken',
	'Included Templates' => 'Geïncludeerde sjablonen',
	'create' => 'aanmaken',
	'Template Tag Docs' => 'Sjabloontagdocumentatie',
	'Unrecognized Tags' => 'Niet herkende tags',
	'Save Changes (s)' => 'Wijzigingen opslaan (s)',
	'Save and Publish this template (r)' => 'Dit sjabloon opslaan en publiceren (r)',
	'Save &amp; Publish' => 'Opslaan &amp; publiceren',
	'You have unsaved changes to this template that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit sjabloon die verloren zullen gaan.',
	'You must set the Template Name.' => 'U moet de naam van het sjabloon instellen',
	'You must set the template Output File.' => 'U moet het uitvoerbestand van het sjabloon instellen.',
	'Processing request...' => 'Verzoek verwerken...',
	'Error occurred while updating archive maps.' => 'Er deed zich teen fout voor bij het bijwerken van de archiefkoppelingen.',
	'Archive map has been successfully updated.' => 'Archiefkoppelingen zijn met succes bijgewerkt.',
	'Are you sure you want to remove this template map?' => 'Bent u zeker dat u deze sjabloonmapping wenst te verwijderen?',
	'Module Body' => 'Moduletekst',
	'Template Body' => 'Sjabloontekst',
	'Syntax highlighting On' => 'Syntaxismarkering aan',
	'Syntax highlighting Off' => 'Syntaxismarkering uit',
	'Template Options' => 'Sjabloonopties',
	'Output file: <strong>[_1]</strong>' => 'Uitvoerbestand: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Ingeschakelde mappings: [_1]',
	'Template Type' => 'Sjabloontype',
	'Custom Index Template' => 'Gepersonaliseerd indexsjabloon',
	'Link to File' => 'Koppelen aan bestand',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Meer lezen over <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publicatie-instellingen</a>',
	'Create Archive Mapping' => 'Nieuwe archiefkoppeling aanmaken',
	'Statically (default)' => 'Statisch (standaard)',
	'Via Publish Queue' => 'Via publicatiewachtrij',
	'On a schedule' => 'Gepland',
	': every ' => ': elke ',
	'minutes' => 'minuten',
	'hours' => 'uren',
	'Dynamically' => 'Dynamisch',
	'Manually' => 'Handmatig',
	'Do Not Publish' => 'Niet publiceren',
	'Server Side Include' => 'Server Side Include',
	'Process as <strong>[_1]</strong> include' => 'Behandel als <strong>[_1]</strong> include',
	'Include cache path' => 'Cachepad voor includes',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Uitgeschakeld (<a href="[_1]">publicatie-instellingen aanpassen</a>)',
	'No caching' => 'Geen caching',
	'Expire after' => 'Verloopt na',
	'Expire upon creation or modification of:' => 'Verloop bij het aanmaken of aanpassen van:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'Website aanmaken',
	'Website Theme' => 'Thema website',
	'Select the theme you wish to use for this website.' => 'Selecteer het thema dat u wenst te gebruiken voor deze website',
	'Name your website. The website name can be changed at any time.' => 'Geef uw website een naam.  De naam van de website kan op elk moment aangepast worden.',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Vul de URL in van uw website.  Laat de bestandsnaam (bv. index.html) weg.  Voorbeeld: http://www.voorbeeld.com',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Vul het pad in waar uw hoofdindexbestand zich zal bevinden.  Een absoluut pad (beginnend met '/' voor Linux of 'C:\' voor Windows) verdient de voorkeur, maar u kunt ook een pad gebruiker relatief aan de Movable Type map.  Voorbeeld: /home/melody/public_html/ of C:\www\public_html},
	'Create Website (s)' => 'Website aanmaken (s)',
	'This field is required.' => 'Dit veld is verplicht',
	'Please enter a valid URL.' => 'Gelieve een geldige URL in te vullen.',
	'Please enter a valid site path.' => 'Gelieve een geldig sitepad in te vullen.',
	'You did not select a timezone.' => 'U hebt geen tijdzone geselecteerd.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Widgetset bewerken',
	'Create Widget Set' => 'Widgetset aanmaken',
	'Widget Set Name' => 'Naam widgetset',
	'Save changes to this widget set (s)' => 'Wijzignen aan deze widgetset opslaan (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Klik en sleep de widgets die in deze widgetset horen in de kolom 'Geïnstalleerde widgets'.},
	'Available Widgets' => 'Beschikbare widgets',
	'Installed Widgets' => 'Geïnstalleerde widgets',
	'You must set Widget Set Name.' => 'U moet een naam instellen voor de widgetset.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Er deed zich een probleem voor',

## tmpl/cms/export_theme.tmpl
	q{Export [_1] Themes} => q{[_1] thema's exporteren},
	'Theme package have been saved.' => 'Themapakket werd opgeslagen.',
	'The name of your theme.' => 'De naam van uw thema.',
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Gebruik enkel letters, cijfers, streepjes of underscores (a-z, A-Z, 0-9, '-' of '_').},
	'Version' => 'Versie',
	'A version number for this theme.' => 'Versienummer voor dit thema.',
	'A description for this theme.' => 'Beschrijving van dit thema',
	'_THEME_AUTHOR' => 'Maker',
	'The author of this theme.' => 'De auteur van dit thema',
	'Author link' => 'Link auteur',
	q{The author's website.} => q{De website van de auteur},
	'Additional assets to be included in the theme.' => 'Bijkomende mediabestanden die in het thema opgenomen moeten worden.',
	'Destination' => 'Bestemming',
	'Select How to get theme.' => 'Selecteer hoe het thema verkregen kan worden.',
	'Setting for [_1]' => 'Instelling voor [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'De basisnaam mag enkel letters, cijfers, mintekens en underscores bevatten.  De basisnaam moet met een letter beginnen.',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Kan geen nieuw thema installeren met bestaande (en beschermde) basisnaam van thema.},
	'You must set Theme Name.' => 'U moet de naam van het thema instellen.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Themaversie mag enkel letters, cijfers, mintekens en underscores bevatten.',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exporteer [_1] berichten',
	'[_1] to Export' => '[_1] te exporteren',
	'_USAGE_EXPORT_1' => 'Exporteer de berichten, reacties en TrackBacks van een blog.  Een export kan niet beschouwd worden als een <em>volledige</em> backup van een blog.',
	'Export [_1]' => 'Exporteer [_1]',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'Start-HTML titel (optioneel)',
	'End title HTML (optional)' => 'Eind-HTML titel (optioneel-',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Als de software waaruit u importeert geen titelveld heeft, kunt u deze instelling gebruiken om aan te geven hoe een titel te herkennen in de tekst van een bericht.',
	'Default entry status (optional)' => 'Standaardstatus berichten (optioneel)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Als de software waaruit u importeert geen status opgeeft voor de berichten in het importbestand, kunt u hiermee een standaardstatus instellen om te gebruiken bij het importeren.',
	'Select an entry status' => 'Selecteer een berichtstatus',

## tmpl/cms/import.tmpl
	'Import [_1] Entries' => 'Importeer [_1] berichten',
	'You must select a blog to import.' => 'U moet een blog selecteren om te importeren.',
	'Enter a default password for new users.' => 'Vul een standaardwachtwoord in voor nieuwe gebruikers.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Importeer weblogberichten in Movable Type uit andere Movable Type installaties of zelfs andere blogsystemen, of exporteer uw berichten om een backup of kopie te maken.',
	'Import data into' => 'Importeer data naar',
	'Select a blog to import.' => 'Kies een blog om te importeren',
	'Select blog' => 'Selecteer blog',
	'Importing from' => 'Aan het importeren uit',
	'Ownership of imported entries' => 'Eigenaarschap van geïmporteerde berichten',
	'Import as me' => 'Importeer als mezelf',
	'Preserve original user' => 'Oorspronkelijke gebruiker bewaren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Als u ervoor kiest om het eigenaarschap van de geïmporteerde berichten te bewaren en als één of meer van die gebruikers nog moeten aangemaakt worden in deze installatie, moet u een standaard wachtwoord opgeven voor die nieuwe accounts.',
	'Default password for new users:' => 'Standaard wachtwoord voor nieuwe gebruikers:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'U zal eigenaar worden van alle geïmporteerde berichten.  Als u wenst dat de oorspronkelijke gebruiker eigenaar blijft, moet u uw MT systeembeheerder contacteren om de import te doen zodat nieuwe gebruikers aangemaakt kunnen worden indien nodig.',
	'Upload import file (optional)' => 'Importbestand opladen (optioneel)',
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{Als uw importbestand zich nog op uw eigen computer bevindt, kunt u het hier opladen.  In het andere geval zal Movable Type automatisch kijken in de 'import' map van uw Movable Type map.},
	'Apply this formatting if text format is not set on each entry.' => 'Pas deze tekstformattering toe indien het tekstformaat niet is ingesteld op een bericht.',
	'Import File Encoding' => 'Encodering importbestand',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Standaard zal Movable Type proberen om automatisch de karakter encodering van het importbestand te bepalen.  Mocht u echter problemen ondervinden, kunt u het ook uitdrukkelijk instellen.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Standaardcategorie voor berichten (optioneel)',
	'You can specify a default category for imported entries which have none assigned.' => 'U kunt een standaardcategorie instellen voor geïmporteerde berichten waar er nog geen aan is toegewezen.',
	'Select a category' => 'Categorie selecteren',
	'Import Entries (s)' => 'Berichten importeren (s)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Reacties toestaan van anonieme of niet aangemelde gebruikers.',
	'Require name and E-mail Address for Anonymous Comments' => 'E-mail adres vereisen voor anonieme reacties',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Indien ingeschakeld moeten bezoekers een geldig e-mail adres opgeven wanneer ze reageren.',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Kleiner tekstformaat',
	'Increase Text Size' => 'Groter tekstformaat',
	'Bold' => 'Vet',
	'Italic' => 'Cursief',
	'Underline' => 'Onderstrepen',
	'Text Color' => 'Tekstkleur',
	'Email Link' => 'E-mail link',
	'Begin Blockquote' => 'Begin citaat',
	'End Blockquote' => 'Einde citaat',
	'Bulleted List' => 'Ongeordende lijst',
	'Numbered List' => 'Genummerde lijst',
	'Left Align Item' => 'Item links uitlijnen',
	'Center Item' => 'Centreer item',
	'Right Align Item' => 'Item rechts uitlijnen',
	'Left Align Text' => 'Tekst links uitlijnen',
	'Center Text' => 'Tekst centreren',
	'Right Align Text' => 'Tekst rechts uitlijnen',
	'Insert File' => 'Bestand invoegen',
	'Check Spelling' => 'Spelling nakijken',
	'WYSIWYG Mode' => 'WYSIWYG modus',
	'HTML Mode' => 'HTML modus',

## tmpl/cms/include/archive_maps.tmpl

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Er bestaat reeds een bestand net de naam '[_1]'. Wilt u dit bestand overschrijven?},
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	'No' => 'Nee',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Geselecteerde media verwijderen (x)',
	'Website/Blog' => 'Website/Blog',
	'Created By' => 'Aangemaakt door',
	'Created On' => 'Aangemaakt',
	'Asset Missing' => 'Ontbrekend mediabestand',
	'No thumbnail image' => 'Geen thumbnail',

## tmpl/cms/include/asset_upload.tmpl
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Voor u een bestand kunt uploaden, moet u eerst uw [_1] publiceren.  [_2]Configureer de publicatiepaden van uw [_1][_3] en herpubliceer uw [_1].},
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Uw systeem of [_1] beheerder moet de [_1] publiceren voor u bestanden kunt uploaden.  Gelieve de beheerder van uw systeem of [_1] te contacteren.',
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Kan niet schrijven naar '[_1]'.  Afbeelding uploaden is mogelijk, maar thumbnail kan niet worden aangemaakt.},
	q{Asset file('[_1]') has been uploaded.} => q{Mediabestand ('[_1]') geupload.},
	'Select File to Upload' => 'Selecteer bestand om te uploaden',
	'_USAGE_UPLOAD' => 'U kunt het bestand opladen naar een submap van het geselecteerde pad.  De submap zal worden aangemaakt als die nog niet bestaat.',
	'Choose Folder' => 'Kies map',
	'Upload (s)' => 'Opladen (s)',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] bevat een karakter dat niet geldig is wanneer het gebruikt word in de naam van een map: [_2]',

## tmpl/cms/include/async_asset_list.tmpl
	'Asset Type: ' => 'Type mediabestand:',
	'All Types' => 'Alle types',
	'label' => 'naam',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] van [_3]',

## tmpl/cms/include/async_asset_upload.tmpl
	'Upload new image' => 'Nieuwe afbeelding upladen', # Translate - Case
	'Upload new asset' => 'Nieuw mediabestand uploaden', # Translate - Case
	'Choose files to upload or drag files.' => 'Kies bestanden om te uploaden of sleep ze hierheen', # Translate - New
	'Choose file to upload or drag file.' => 'Kies bestand om te uploaden of sleep het hierheen', # Translate - New
	'Upload Options' => 'Upload opties',
	'Operation for a file exists' => 'Actie als een bestand al bestaat',
	'Drag and drop here' => 'Klik en sleep hierheen', # Translate - New
	'Cancelled: [_1]' => 'Geannuleerd: [_1]',
	'The file you tried to upload is too large: [_1]' => 'Het bestand dat u probeerde te uploaden is te groot: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] is geen geldig [_2] bestand.',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => 'Geselecteerde gebruikers activeren (E)',
	'_USER_ENABLE' => 'Activeren',
	'Disable selected users (d)' => 'Geselecteerde gebruikers desactiveren (D)',
	'_USER_DISABLE' => 'Desactiveren',
	'user' => 'gebruiker',
	'users' => 'gebruikers',
	'_NO_SUPERUSER_DISABLE' => 'Omdat u een systeembeheerder bent in het Movable Type systeem, kunt u zichzelf niet desactiveren.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Alle gegevens zijn met succes opgeslagen!',
	'_BACKUP_TEMPDIR_WARNING' => 'Gevraagde gegevens zijn met succes gebackupt in de map [_1].  Gelieve bovenstaande bestanden te downloaden en vervolgens <strong>onmiddellijk te verwijderen</strong> uit [_1] omdat backupbestanden vertrouwelijke informatie bevatten.',
	'Backup Files' => 'Backup bestanden',
	'Download This File' => 'Dit bestand downloaden',
	'Download: [_1]' => 'Download: [_1]',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{Het downloaden van het backup-bestand zal over een paar seconden automatisch beginnen.  Als dit niet het geval is om wat voor reden dan ook, klik dan <a href='#' onclick='submit_form()'>hier</a> om de download met de hand in gang te zetten.  Merk op dat u het backupbestand slechts één keer kunt downloaden gedurende een sessie.},

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Backup maken van Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'bevat',
	'does not contain' => 'bevat niet',
	'__STRING_FILTER_EQUAL' => 'is gelijk aan',
	'starts with' => 'begint met',
	'ends with' => 'eindigt op',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'__INTEGER_FILTER_EQUAL' => 'is gelijk aan',
	'__INTEGER_FILTER_NOT_EQUAL' => 'is niet gelijk aan',
	'is greater than' => 'is groter dan',
	'is greater than or equal to' => 'is groter dan of gelijk aan',
	'is less than' => 'is minder dan',
	'is less than or equal to' => 'is minder dan of gelijk aan',
	'is between' => 'is tussen',
	'is within the last' => 'valt binnen de laatste',
	'is before' => 'valt voor',
	'is after' => 'valt na',
	'is after now' => 'valt in de toekomst',
	'is before now' => 'valt in het verleden',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'[_1] and [_2]' => '[_1] en [_2]',
	'_FILTER_DATE_DAYS' => '[_1] dagen',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => 'Sommige sjablonen werden niet ververst.',
	'Delete selected [_1] (x)' => 'Geselecteerde [_1] verwijderen (x)',
	'[_1] Name' => 'Naam [_1]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Subcategorie toevoegen',
	'Add sub folder' => 'Submap toevoegen',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Laatste reactie',
	'Edit this commenter' => 'Deze reageerder bewerken',
	'View this commenter&rsquo;s profile' => 'Bekijk het profiel van deze reageerder',

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => 'Geselecteerde reacties publiceren (a)',
	'Delete selected comments (x)' => 'Geselecteerde reacties verwijderen (x)',
	'Edit this comment' => 'Deze reactie bewerken',
	'([quant,_1,reply,replies])' => '([quant,_1,antwoord,antwoorden])',
	'Blocked' => 'Geblokkeerd',
	'Edit this [_1] commenter' => '[_1] reageerder bewerken',
	'Search for comments by this commenter' => 'Zoek naar reacties door deze reageerder',
	'View this entry' => 'Dit bericht bekijken',
	'View this page' => 'Deze pagina bekijken',
	'Search for all comments from this IP address' => 'Zoek naar alle reacties van dit IP adres',
	'to republish' => 'om opnieuw te publiceren',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. All Rights Reserved.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Werkbalk verbergen',
	'Hide &raquo;' => 'Verberg &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Sleutel',
	'Value' => 'Waarde',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variabele',
	'No COOKIE data' => 'Geen COOKIE gegevens',
	'Input Parameters' => 'Invoerparameters',
	'No Input Parameters' => 'Geen invoerparameters',

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Weergave-opties',
	'_DISPLAY_OPTIONS_SHOW' => 'Toon',
	'[quant,_1,row,rows]' => '[quant,_1,rij,rijen]',
	'Compact' => 'Compact',
	'Expanded' => 'Uitgebreid',
	'Save display options' => 'Opties schermindeling opslaan',

## tmpl/cms/include/entry_table.tmpl
	'Republish selected [_1] (r)' => 'Geselecteerde [_1] opnieuw publiceren (r)',
	'Last Modified' => 'Laatst aangepast',
	'Created' => 'Aangemaakt',
	'View entry' => 'Bericht bekijken',
	'View page' => 'Pagina bekijken',
	'No entries could be found.' => 'Geen berichten gevonden.',
	'<a href="[_1]">Create an entry</a> now.' => 'Nu <a href="[_1]">een bericht aanmaken</a>.',
	q{No pages could be found. <a href="[_1]">Create a page</a> now.} => q{Er werden geen pagina's gevonden. Nu <a href="[_1]">een pagina aanmaken</a>.},

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Webservices wachtwoord instellen',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Dit is een betaversie van Movable Type, niet aangeraden voor productiegebruik.',
	'http://www.movabletype.org' => 'http://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'Support' => 'Ondersteuning',
	'http://forums.movabletype.org/' => 'http://forums.movabletype.org/',
	'Forums' => 'Forums',
	'Send Us Feedback' => 'Stuur ons feedback',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versie [_2]',
	'with' => 'met',
	q{_LOCALE_CALENDAR_HEADER_} => q{'Z', 'M', 'D', 'W', 'D', 'V', 'Z'},
	'Your Dashboard' => 'Uw dashboard',

## tmpl/cms/include/header.tmpl
	'Help' => 'Hulp',
	'Sign out' => 'Afmelden',
	'View Site' => 'Site bekijken',
	'Search (q)' => 'Zoeken (q)',
	'Search [_1]' => 'Doorzoek [_1]',
	'Create New' => 'Nieuwe aanmaken',
	'Select an action' => 'Selecteer een actie',
	'You have <strong>[quant,_1,message,messages]</strong> from the system.' => 'U heeft <strong>[quant,_1,bericht,berichten]</strong> van het systeem.',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Deze website werd aangemaakt tijdens de upgrade van een vorige versie van Movable Type.  'Site Root' en 'Site URL' werden met opzet leeg gelaten om 'Publicatiepaden' compatibiliteit te behouden voor blogs die aangemaakt werden in de vorige versie.  U kunt berichten plaatsen en publiceren op de bestaande blogs, maar u kunt deze website zelf niet publiceren omwille van de blanco 'Site Root' en 'Site URL'.},
	'from Revision History' => 'Revisiegeschiedenis',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Alle gegevens werden met succes geïmporteerd!',
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publiceer uw site</a> om de wijzigingen zichtbaar te maken.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Verwijder zeker de bestanden waaruit u gegevens importeerde uit de 'import' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.},

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importeren...',
	'Importing entries into [_1]' => 'Berichten worden geïmporteerd in de [_1]',
	q{Importing entries as user '[_1]'} => q{Berichten worden geïmporteerd als gebruiker '[_1]'},
	'Creating new users for each user found in the [_1]' => 'Nieuwe gebruikers worden aangemaakt voor elke gebruiker gevonden in de [_1]',

## tmpl/cms/include/insert_options_image.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Meer mogelijkheden...',
	'Plugin Actions' => 'Plugin-mogelijkheden',
	'Go' => 'Ga',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => 'Permissies beheren',
	'Users for [_1]' => 'Gebruikers voor [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Stap [_1] van [_2]',
	'Go to [_1]' => 'Ga naar [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Sorry, er waren geen resultaten voor uw zoekopdracht. Probeer opnieuw te zoeken.',
	'Sorry, there is no data for this object set.' => 'Sorry, er zijn geen gegevens ingesteld voor dit object.',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Mij onthouden?',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Er konden geen logberichten worden gevonden.',
	'_LOG_TABLE_BY' => 'Door',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this [_1]?' => 'Bent u zeker dat u de geselecteerde gebruiker wenst te verwijderen van deze [_1]?',
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Bent u zeker dat u de [_1] geselecteerde gebruikers wenst te verwijderen van deze [_2]?',
	'Remove selected user(s) (r)' => 'Geselecteerde gebruiker(s) verwijderen (r)',
	'Trusted commenter' => 'Vertrouwde reageerder',
	'Remove this role' => 'Verwijder deze rol',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Toegevoegd',
	'Save changes' => 'Wijzigingen opslaan',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Geselecteerde [_1] publiceren (p)',
	'Edit this TrackBack' => 'Deze TrackBack bewerken',
	'Go to the source entry of this TrackBack' => 'Ga naar het bronbericht van deze TrackBack',
	'View the [_1] for this TrackBack' => 'De [_1] bekijken voor deze TrackBack',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Geen revisies gevonden.',
	'_REVISION_DATE_' => 'Datum',
	'Note' => 'Noot',
	'Saved By' => 'Opgeslagen door',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz boodschap',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'Dashboard gebruiker',
	'Select another website...' => 'Selecteer een andere website...',
	'(on [_1])' => '(op [_1])',
	'Select another blog...' => 'Selecteer een andere blog...',
	'Create Blog (on [_1])' => 'Blog aanmaken (op [_1])',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Archiefsjabloon aanmaken:',
	'Entry Listing' => 'Overzicht berichten',
	'Create template module' => 'Sjabloonmodule aanmaken',
	'Create index template' => 'Indexsjabloon aanmaken',
	'Publish selected templates (a)' => 'Geselecteerde sjablonen publiceren (a)',
	'Archive Path' => 'Archiefpad',
	'SSI' => 'SSI',
	'Cached' => 'Gecached',
	'Linked Template' => 'Gelinkt sjabloon',
	'Manual' => 'Handmatig',
	'Dynamic' => 'Dynamisch',
	'Publish Queue' => 'Publicatiewachtrij',
	'Static' => 'Statisch',
	'templates' => 'sjablonen',
	'to publish' => 'om te publiceren',

## tmpl/cms/include/theme_exporters/category.tmpl

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Naam map',
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'In de opgegeven mappen zullen bestanden van volgende types opgenomen worden in het thema [_1].  Andere bestanden zullen worden genegeerd.',
	'Specify directories' => 'Mappen opgeven',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Som mappen op (één per regel) onder de Site Root map die de statische bestanden zullen bevatten die opgenomen moeten worden in het thema.  Vaak gebruikte mappen zijn: css, images, js, etc.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'Widgetsets',
	'modules' => 'modules',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] zijn opgenomen',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Welkom bij Movable Type',
	'Create Your Account' => 'Maak uw account aan',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'De versie van Perl die op uw server is geïnstalleerd ([_1]) is lager dan de ondersteunde minimale versie ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Hoewel Movable Type er misschien op draait, is het een <strong>ongetesten en niet ondersteunde omgeving</strong>.  We raden ten zeerste aan om minstens te upgraden tot Perl [_1].',
	'Do you want to proceed with the installation anyway?' => 'Wenst u toch door te gaan met de installatie?',
	'View MT-Check (x)' => 'Bekijk MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Gelieve een administrator account aan te maken voor uw systeem.  Zodra dit gebeurd is, zal Movable Type de database initialiseren.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Om verder te gaan moet u zich aanmelden bij uw LDAP server.',
	'The name used by this user to login.' => 'De naam gebruikt door deze gebruiker om zich aan te melden.',
	'The name used when published.' => 'De naam gebruikt bij het publiceren',
	'The user&rsquo;s email address.' => 'E-mail adres van de gebruiker.',
	'System Email' => 'Systeem e-mail',
	'Use this as system email address' => 'Dit ook als systeem e-mail adres gebruiken',
	'The user&rsquo;s preferred language.' => 'Voorkeurstaal van de gebruiker.',
	'Select a password for your account.' => 'Kies een wachtwoord voor uw account.',
	'Your LDAP username.' => 'Uw LDAP gebruikersnaam.',
	'Enter your LDAP password.' => 'Geef uw LDAP wachtwoord op.',
	'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
	'The display name is required.' => 'Getoonde naam is vereist.',
	'The e-mail address is required.' => 'Het e-mail adres is vereist.',

## tmpl/cms/list_category.tmpl
	'Manage [_1]' => '[_1] beheren',
	'Top Level' => 'Topniveau',
	'[_1] label' => '[_1] label',
	'Change and move' => 'Wijzig en verplaats',
	'Rename' => 'Naam wijzigen',
	'Label is required.' => 'Label is verplicht',
	'Label is too long.' => 'Label is te lang',
	'Duplicated label on this level.' => 'Dubbel gebruik van een label op dit niveau.',
	'Basename is required.' => 'Basisnaam is verplicht.',
	'Invalid Basename.' => 'Ongeldige basisnaam.',
	'Duplicated basename on this level.' => 'Dubbel gebruik van basisnaam op dit niveau.',
	'Add child [_1]' => 'Kind toevoegen [_1]',
	'Remove [_1]' => 'Verwijder [_1]',
	'[_1] \'[_2]\' already exists.' => '[_1] \'[_2]\' bestaat al.',
	'Are you sure you want to remove [_1] [_2]?' => 'Bent u zeker dat u [_1] [_2] wenst te verwijderen?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => 'Bent u zeker dat u [_1] [_2] met [_3] sub [_4] wenst te verwijderen?',
	'Alert' => 'Alarm',

## tmpl/cms/list_common.tmpl
	'25 rows' => '25 rijen',
	'50 rows' => '50 rijen',
	'100 rows' => '100 rijen',
	'200 rows' => '2000 rijen',
	'Column' => 'Kolom',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Filter:' => 'Filter:',
	'Select Filter...' => 'Selecteer filter...',
	'Remove Filter' => 'Filter verwijderen',
	'Select Filter Item...' => 'Selecteer filteritem',
	'Save As' => 'Opslaan als',
	'Filter Label' => 'Filterlabel',
	'My Filters' => 'Mijn filters',
	'Built in Filters' => 'Ingebouwde filters',
	'Remove item' => 'Item verwijderen',
	'Unknown Filter' => 'Onbekende filter',
	'act upon' => 'actie uitvoeren op',
	'Are you sure you want to remove the filter \'[_1]\'?' => 'Bent u zeker dat u de filter \'[_1]\' wenst te verwijderen?',
	'Label "[_1]" is already in use.' => 'Label "[_1]" is al in gebruik',
	'Communication Error (HTTP status code: [_1]. Message: [_2])' => 'Communicatiefout (HTTP status code: [_1]. Bericht ([_2])',
	'Select all [_1] items' => 'Selecteer alle [_1] items',
	'All [_1] items are selected' => 'Alle [_1] items zijn geselecteerd',
	'[_1] Filter Items have errors' => '[_1] Filteritems hebben fouten',
	'[_1] - Filter [_2]' => '[_1] - Filter [_2]',
	'Save Filter' => 'Filter opslaan',
	'Save As Filter' => 'Opslaan als filter',
	'Select Filter' => 'Selecteer filter',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Berichtenfeed',
	q{Pages Feed} => q{Feed pagina's},
	'The entry has been deleted from the database.' => 'Dit bericht werd verwijderd uit de database',
	'The page has been deleted from the database.' => 'Deze pagina werd verwijderd uit de database',
	'Quickfilters' => 'Snelfilters',
	'[_1] (Disabled)' => '[_1] (Uitgeschakeld)',
	'Showing only: [_1]' => 'Enkel: [_1]',
	'Remove filter' => 'Filter verwijderen',
	'change' => 'wijzig',
	'[_1] where [_2] is [_3]' => '[_1] waar [_2] gelijk is aan [_3]',
	'Show only entries where' => 'Toon enkel berichten waar',
	q{Show only pages where} => q{Toon enkel pagina's waar},
	'status' => 'status',
	'tag (exact match)' => 'tag (exacte overeenkomst)',
	'tag (fuzzy match)' => 'tag (fuzzy overeenkomst)',
	'asset' => 'mediabestand',
	'is' => 'gelijk is aan',
	'published' => 'gepubliceerd',
	'unpublished' => 'ongepubliceerd',
	'review' => 'na te kijken',
	'scheduled' => 'gepland',
	'spam' => 'spam',
	'Select A User:' => 'Selecteer een gebruiker:',
	'User Search...' => 'Zoeken naar gebruiker...',
	'Recent Users...' => 'Recente gebruikers...',
	'Select...' => 'Selecteer...',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'U heeft met suuces de mediabestand(en) verwijderd.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Kan niet schrijven naar '[_1]'. Thumbnails van items kunnen mogelijk niet worden weergegeven.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => 'De gekozen permissie(s) zijn met succes ingetrokken.',
	'You have successfully granted the given permission(s).' => 'De gekozen permissie(s) zijn met succes toegekend.',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes uitgeschakeld.',
	'You have successfully enabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes ingeschakeld.',
	'You have successfully unlocked the selected user(s).' => 'Geselecteerde gebruiker(s) met succes gedeblokkeerd.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'U heeft met succes de gebruiker(s) verwijderd uit het Movable Type systeem.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'De verwijderde gebruiker(s) blijven bestaan in de externe directory. Om die reden zullen ze zich nog steeds kunnen aanmelden op Movable Type Advanced.',
	q{You have successfully synchronized users' information with the external directory.} => q{U heeft met succes de gebruikersgegevens gesynchroniseerd met de externe directory.},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Een aantal ([_1]) van de geselecteerde gebruiker(s) konden niet opniew worden ingeschakeld omdat ze niet meer werden gevonden in de externe directory.',
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]'>activity log</a> for more details.} => q{Sommige ([_1]) van de geselecteerde gebruikers konden niet opnieuw geactiveerd worden omdat ze ongeldige instelling(en) hadden. Kijk in het <a href='[_2]'>activiteitenlog</a> voor meer details.},
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Er deed zich een fout voor tijdens de synchronisatie.  Kijk in het <a href='[_1]'>activiteitenlog</a> voor gedetailleerde informatie.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => 'U hebt [_1] toegevoegd aan uw lijst met uitgesloten IP adressen.',
	'You have successfully deleted the selected IP addresses from the list.' => 'U hebt de geselecteerde IP adressen uit de lijst is verwijderd.',
	'Invalid IP address.' => 'Ongeldig IP adres',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the website from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes de website verwijderd uit het Movable Type systeem.  De bestanden ervan bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als u ze niet meer nodig heeft.',
	'You have successfully deleted the blog from the website. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes de blog verwijderd uit de website. De bestanden ervan bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als u ze niet meer nodig heeft.',
	'You have successfully refreshed your templates.' => 'U heeft met succes uw sjablonen ververst.',
	'You have successfully moved selected blogs to another website.' => 'U heeft de geselecteerde blogs met succes verplaatst naar een andere website.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Waarschuwing: u moet mediabestanden die werden geupload met de hand naar de nieuwe locatie verhuizen.  Overweeg ook om op de oorspronkelijke locatie kopieën te bewaren om zo gebroken links te vermijden.',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'De geselecteerde reactie(s) zijn goedgekeurd.',
	'All comments reported as spam have been removed.' => 'Alle reaactie die aangemerkt waren als spam zijn verwijderd.',
	'The selected comment(s) has been unapproved.' => 'De geselecteerde reactie(s) zijn niet langer goedgekeurd.',
	'The selected comment(s) has been reported as spam.' => 'De geselecteerde reactie(s) zijn als spam gerapporteerd.',
	'The selected comment(s) has been recovered from spam.' => 'De geselecteerde reactie(s) zijn teruggehaald uit de spam-map',
	'The selected comment(s) has been deleted from the database.' => 'Geselecteerde reactie(en) zijn uit de database verwijderd.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Eén of meer reacties die u selecteerde werd ingegeven door een niet geauthenticeerde reageerder. Deze reageerders kunnen niet verbannen of vertrouwd worden.',
	'No comments appear to be spam.' => 'Er lijken geen spamreacties te zijn',

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Alle tijdstippen worden getoond in GMT[_1].',
	'All times are displayed in GMT.' => 'Alle tijdstippen worden getoond in GMT.',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added [_1] to your address book.' => 'U heeft [_1] toegevoegd aan uw adresboek.',
	'You have successfully deleted the selected contacts from your address book.' => 'U heeft met succes de geselecteerde contacten verwijderd uit uw adresboek.',

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => 'De geselecteerde TrackBack(s) zijn goedgekeurd',
	'All TrackBacks reported as spam have been removed.' => 'Alle TrackBacks gerapporteerd als spam zijn verwijderd',
	'The selected TrackBack(s) has been unapproved.' => 'De geselecteerde TrackBack(s) zijn niet langer goedgekeurd',
	'The selected TrackBack(s) has been reported as spam.' => 'De geselecteerde TrackBack(s) zijn gerapporteerd als spam',
	'The selected TrackBack(s) has been recovered from spam.' => 'De geselecteerde TrackBack(s) zijn teruggehaald uit de spam-map',
	'The selected TrackBack(s) has been deleted from the database.' => 'De geselecteerde TrackBack(s) zijn uit de database verwijderd.',
	'No TrackBacks appeared to be spam.' => 'Geen enkele TrackBack leek spam te zijn.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'De rol(len) zijn met succes verwijderd.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'Uw tag-wijzigingen en toevoegingen zijn uitgevoerd.',
	'You have successfully deleted the selected tags.' => 'U hebt met succes de geselecteerde tags verwijderd.',
	'Specify new name of the tag.' => 'Geef een nieuwe naam op voor de tag',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'De tag \'[_2]\' bestaat al.  Zeker dat u \'[_1]\' en \'[_2]\' wenst samen te voegen over alle blogs?',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => 'Beheer [_1] sjablonen',
	'Manage Global Templates' => 'Globale sjablonen beheren',
	'Show All Templates' => 'Alle sjablonen tonen',
	'Publishing Settings' => 'Publicatie-instellingen',
	'You have successfully deleted the checked template(s).' => 'Verwijdering van geselecteerde sjabloon/sjablonen is geslaagd.',
	'Your templates have been published.' => 'Uw sjablonen werden gepubliceerd.',
	'Selected template(s) has been copied.' => 'Geselecteerde sjablo(o)n(en) gekopiëerd.',

## tmpl/cms/list_theme.tmpl
	q{[_1] Themes} => q{[_1] thema's},
	q{All Themes} => q{Alle thema's},
	'_THEME_DIRECTORY_URL' => 'http://plugins.movabletype.org/',
	q{Find Themes} => q{Thema's zoeken},
	'Theme [_1] has been uninstalled.' => 'Thema [_1] werd gedesinstalleerd.',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] werd toegepast (<a href="[_2]">[quant,_3,waarschuwing,waarschuwingen]</a>).',
	'Theme [_1] has been applied.' => 'Thema [_1] werd toegepast.',
	'Failed' => 'Mislukt',
	'[quant,_1,warning,warnings]' => '[quant,_1,waarschuwing,waarschuwingen]',
	'Reapply' => 'Opnieuw toepassen',
	'Uninstall' => 'Desinstalleren',
	'Author: ' => 'Auteur:',
	'This theme cannot be applied to the website due to [_1] errors' => 'Dit thema kan niet worden toegepast op deze website wegens [_1] fouten',
	'Errors' => 'Fouten',
	'Warnings' => 'Waarschuwingen',
	'Theme Errors' => 'Thema fouten',
	'Theme Warnings' => 'Thema waarschuwingen',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Delen van dit thema kunnen niet worden toegepast op de website.  [_1] elementen zullen worden overgeslagen.',
	'Theme Information' => 'Thema informatie',
	q{No themes are installed.} => q{Geen thema's geïnstalleerd},
	'Current Theme' => 'Huidig thema',
	q{Themes in Use} => q{Thema's in gebruik},
	q{Available Themes} => q{Beschikbare thema's},

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => 'Beheer [_1] widgets',
	'Manage Global Widgets' => 'Globale widgets beheren',
	'Delete selected Widget Sets (x)' => 'Geselecteerde widgetsets verwijderen (x)',
	'Helpful Tips' => 'Nuttige tips',
	'To add a widget set to your templates, use the following syntax:' => 'Om een widgetset aan uw sjablonen toe te voegen, gebruikt u volgende syntax:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Naam van de widgetset&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Uw wijzigingen aan de widgetset werden opgeslagen.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'U heeft met succes de geselecteerde widgetset(s) van uw weblog verwijderd.',
	'No widget sets could be found.' => 'Er werden geen widgetsets gevonden.',
	'Create widget template' => 'Widgetsjabloon aanmaken',

## tmpl/cms/login.tmpl
	'Sign in' => 'Aanmelden',
	'Your Movable Type session has ended.' => 'Uw Movable Type sessie is beëindigd.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Uw Movable Type sessie is beëindigd.  Als u zich opnieuw wenst aan te melden, dan kan dat hieronder.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Uw Movable Type sessie is beëindigd. Gelieve u opnieuw aan te melden om deze handeling voort te zetten.',
	'Sign In (s)' => 'Aanmelden (s)',
	'Forgot your password?' => 'Uw wachtwoord vergeten?',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Bezig met pingen van sites...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'Gelukte TrackBacks',
	'Failed Trackbacks' => 'Mislukte TrackBacks',
	q{To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.} => q{Om opnieuw te proberen: zet deze TrackBacks in het veld voor uitgaande TrackBack URL's van uw bericht.},

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Publiceer [_1]',
	'Publish <em>[_1]</em>' => 'Publiceer <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Publiceren',
	'All Files' => 'Alle bestanden',
	'Index Template: [_1]' => 'Indexsjabloon: [_1]',
	'Only Indexes' => 'Alleen indexen',
	'Only [_1] Archives' => 'Alleen archieven [_1]',
	'Publish (s)' => 'Publiceer (s)',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succes',
	'The files for [_1] have been published.' => 'De bestanden voor [_1] werden gepubliceerd.',
	'Your [_1] archives have been published.' => 'Uw [_1] archieven zijn gepubliceerd.',
	'Your [_1] templates have been published.' => 'Uw [_1] sjablonen zijn gepubliceerd.',
	'Publish time: [_1].' => 'Publicatietijd: [_1].',
	'View your site.' => 'Uw site bekijken.',
	'View this page.' => 'Deze pagina bekijken.',
	'Publish Again (s)' => 'Opnieuw pubiceren (s)',
	'Publish Again' => 'Opnieuw publiceren',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1] Content' => 'Voorbeeld [_1] inhoud bekijken',
	'Return to the compose screen' => 'Terugkeren naar het opstelscherm',
	'Return to the compose screen (e)' => 'Terugkeren naar het opstelscherm (r)',
	'Save this entry' => 'Dit bericht opslaan',
	'Save this entry (s)' => 'Dit bericht opslaan (s)',
	'Re-Edit this entry' => 'Dit bericht opnieuw bewerken',
	'Re-Edit this entry (e)' => 'Dit bericht opnieuw bewerken (e)',
	'Save this page' => 'Deze pagina opslaan',
	'Save this page (s)' => 'Deze pagina opslaan (s)',
	'Re-Edit this page' => 'Deze pagina opnieuw bewerken',
	'Re-Edit this page (e)' => 'Deze pagina opnieuw bewerken (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'Dit bericht publiceren',
	'Publish this entry (s)' => 'Dit bericht publiceren (s)',
	'Publish this page' => 'Deze pagina publiceren',
	'Publish this page (s)' => 'Deze pagina publiceren (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van het bericht met de titel &ldquo;[_1]&rdquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van de pagina met de titel &ldquo;[_1]&rdquo;',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'U bekijkt een voorbeeld van het sjabloon met de naam &ldquo;[_1]&rdquo;',
	'(Publish time: [_1] seconds)' => '(Publicatietijd: [_1] seconden)',
	'Save this template (s)' => 'Dit sjabloon opslaan (s)',
	'Save this template' => 'Dit sjabloon opslaan',
	'Re-Edit this template (e)' => 'Dit sjabloon opnieuw bewerken (e)',
	'Re-Edit this template' => 'Dit sjabloon opnieuw bewerken',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'Er zijn geen categorieën in deze blog.  Voorbeeld van categorie-archiefsjaboon is beperkt beschikbaar met weergave van een virtuele categorie.  Er kan geen normale, non-voorbeeld uitvoer gegenereerd worden met dit sjabloon tenzij minstens één categorie aangemaakt wordt.',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publiceren...',
	'Publishing [_1]...' => '[_1] wordt gepubliceerd...',
	'Publishing <em>[_1]</em>...' => 'Bezig <em>[_1]</em> te publiceren...',
	'Publishing [_1] [_2]...' => '[_1] [_2] wordt gepubliceerd...',
	'Publishing [_1] dynamic links...' => 'Bezig [_1] dynamische links te publiceren...',
	'Publishing [_1] archives...' => 'Bezig archieven [_1] te publiceren...',
	'Publishing [_1] templates...' => 'Bezig [_1] sjablonen te publiceren...',
	'Complete [_1]%' => 'Voor [_1]% compleet',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Blokkering opgeheven',
	q{User '[_1]' has been unlocked.} => q{Gebruiker '[_1]' werd gedeblokkeerd.},

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Wachtwoorden terugvinden',
	'No users were selected to process.' => 'Er werden geen gebruikers geselecteerd om te verwerken.',
	'Return' => 'Terug',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Sjabloonverversing',
	'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
	'Return to templates' => 'Terugkeren naar sjablonen',

## tmpl/cms/restore_end.tmpl
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Verwijder de bestanden die u heeft teruggezet uit de map 'import', om te vermijden dat ze opnieuw worden teruggezet wanneer u ooit het restore-proces opnieuw uitvoert.},

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Movable Type terugzetten',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Terugzetten uit een backup',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Perl module XML::SAX en/of een aantal van de vereisten ervoor ontbreekt.  Movable Type kan het systeem niet terugzetten zonder deze modules.',
	'Backup File' => 'Bestand backuppen',
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{Als uw backup-bestand zich op een andere computer bevindt, kunt u het hier uploaden.  Anders zal Movable Type automatisch in de 'import' map kijken in uw Movable Type map.},
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Kruis dit aan en ook bestanden die gebackupt zijn van nieuwere versies van Movable Type kunnen teruggezet worden op dit systeem.  Opmerking: de schemaversie negeren kan Movable Type permanent beschadigen.',
	'Ignore schema version conflicts' => 'Negeer schemaversieconflicten',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Toestaan dat bestaande globale sjablonen worden overschreven door globale sjablonen in het backupbestand.',
	'Overwrite global templates.' => 'Globale sjablonen overschrijven.',
	'Restore (r)' => 'Terugzetten (r)',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'U moet één of meer items selecteren om te vervangen.',
	'Search Again' => 'Opnieuw zoeken',
	'Case Sensitive' => 'Hoofdlettergevoelig',
	'Regex Match' => 'Regex-overeenkomst',
	'Limited Fields' => 'Beperkte velden',
	'Date Range' => 'Bereik wissen',
	'Reported as Spam?' => 'Rapporteren als spam?',
	'_DATE_FROM' => 'Van',
	'_DATE_TO' => 'Tot',
	'Submit search (s)' => 'Zoekopdracht ingeven (s)',
	'Search For' => 'Zoeken naar',
	'Replace With' => 'Vervangen door',
	'Replace Checked' => 'Aangekruiste items vervangen',
	'Successfully replaced [quant,_1,record,records].' => 'Met succes [quant,_1,record,records] vervangen.',
	'Showing first [_1] results.' => 'Eerste [_1] resultaten worden getoond.',
	'Show all matches' => 'Alle overeenkomsten worden getoond',
	'[quant,_1,result,results] found' => '[quant,_1,resultaat,resultaten] found',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Eerste website aanmaken',
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{Om uw website te kunnen publiceren, moet u Movable Type voorzien van de URL van uw website en het pad waar de bestanden ervan moeten worden gepubliceerd.},
	'Support directory does not exists or not writable by the web server. Change the ownership or permissions on this directory' => 'Support map bestaat niet of is niet beschrijfbaar door de webserver.  Wijzig de eigenaar of permissies van deze map.',
	'My First Website' => 'Mijn eerste website',
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{De 'Website Root' is de map in het bestandssysteem van uw webserver waar Movable Type de bestanden zal publiceren voor uw website.  De webserver moet schrijftoegang hebben tot deze map.},
	'Select the theme you wish to use for this new website.' => 'Selecteer het thema dat u wenst te gebruiken op deze nieuwe website.',
	'Finish install (s)' => 'Installatie afronden (s)',
	'Finish install' => 'Installatie afronden',
	'The website name is required.' => 'De naam van de website is vereist.',
	'The website URL is required.' => 'De URL van de website is vereist.',
	'Your website URL is not valid.' => 'De URL van uw website is ongeldig.',
	'The publishing path is required.' => 'Het publicatiepad is vereist',
	'The timezone is required.' => 'De tijdzone is vereist',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Totaal aantal gebruikers',
	'Memcache Status' => 'Memcache Status',
	'configured' => 'geconfigureerd',
	'disabled' => 'uitgeschakeld',
	'Memcache is [_1].' => 'Memcache is [_1].',
	'available' => 'beschikbaar',
	'unavailable' => 'niet beschikbaar',
	'Memcache Server is [_1].' => 'Memcache server is [_1].',
	'Server Model' => 'Servertype',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type kon het script met de naam 'mt-check.cgi' niet vinden.  Om dit probleem op te lossen moet u controleren of het script mt-check.cgi bestaat en of de CheckScript configuratieparameter (indien nodig) er correct naar verwijst.},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Exportmap voor thema bestaat al '[_1]'.  U kunt een bestaand thema overschrijven, of annuleren om de naam van de map aan te passen.},
	'Overwrite' => 'Overschrijven',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Database wordt geïnitialiseerd...',
	'Upgrading database...' => 'Database wordt bijgewerkt...',
	'Error during installation:' => 'Fout tijdens installatie:',
	'Error during upgrade:' => 'Fout tijdens upgrade:',
	'Return to Movable Type (s)' => 'Terugkeren naar Movable Type (s)',
	'Return to Movable Type' => 'Terugkeren naar Movable Type',
	'Your database is already current.' => 'Uw database is reeds up-to-date.',
	'Installation complete!' => 'Installatie voltooid!',
	'Upgrade complete!' => 'Upgrade voltooid!',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Tijd voor een upgrade!',
	'Upgrade Check' => 'Upgrade-controle',
	'Do you want to proceed with the upgrade anyway?' => 'Wenst u toch door te gaan met de upgrade?',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Er is een nieuwe versie van Movable Type geïnstalleerd.  Er moeten een aantal dingen gebeuren om uw database bij te werken.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{De Movable Type Upgrade Gids kan <a href='[_1]' target='_blank'>hier</a> worden gevonden.},
	'In addition, the following Movable Type components require upgrading or installation:' => 'Bovendien hebben volgende Movable Type componenten een upgrade nodig of moeten ze geïnstalleerd worden:',
	'The following Movable Type components require upgrading or installation:' => 'Volgende Movable Type componenten hebben een upgrade nodig of moeten geïnstalleerd worden:',
	'Begin Upgrade' => 'Begin de upgrade',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Proficiat, u heeft met succes een upgrade uitgevoerd aan Movable Type [_1].',
	'Your Movable Type installation is already up to date.' => 'Uw Movable Type installation is al up-to-date.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Het activiteitlog is leeggemaakt.',
	'System Activity Log' => 'Systeemactiviteitenlog',
	'Filtered' => 'Gefilterde',
	'Filtered Activity Feed' => 'Gefilterde activiteitenfeed',
	'Download Filtered Log (CSV)' => 'Gefilterde log downloaden',
	'Showing all log records' => 'Alle logberichten worden getoond',
	'Showing log records where' => 'Alleen logberichten worden getoond waar',
	'Show log records where' => 'Toon logberichten waar',
	'level' => 'niveau',
	'classification' => 'classificatie',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Foutenlog van de Schwartz',
	'Showing all Schwartz errors' => 'Alle Schwartz fouten worden getoond',

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Recentste reacties',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] op [_4]',
	'View all comments' => 'Alle reacties bekijken',
	'No comments available.' => 'Geen reacties beschikbaar',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Recentste berichten',
	'Posted by [_1] [_2] in [_3]' => 'Gepubliceerd door [_1] [_2] op [_3]',
	'Posted by [_1] [_2]' => 'Gepubliceerd door [_1] [_2]',
	'Tagged: [_1]' => 'Getagd: [_1]',
	'View all entries' => 'Alle berichten bekijken',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'Er werden nog geen berichten aangemaakt in deze blog <a href="[_1]">Bericht aanmaken</a>',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,bericht,berichten] getagd &ldquo;[_2]&rdquo;',
	'No entries available.' => 'Geen berichten beschikbaar',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Fout bij het ophalen van recente berichten.',
	'Loading recent entries...' => 'Recente berichten aan het laden...',
	'Jan.' => 'Jan.',
	'Feb.' => 'Feb.',
	'March' => 'Maart',
	'April' => 'April',
	'May' => 'Mei',
	'June' => 'Juni',
	'July.' => 'Juli',
	'Aug.' => 'Aug.',
	'Sept.' => 'Sept.',
	'Oct.' => 'Okt.',
	'Nov.' => 'Nov.',
	'Dec.' => 'Dec.',
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] - [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'U heeft <a href=\'[_3]\'>[quant,_1,reactie,reacties] van [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'U heeft <a href=\'[_3]\'>[quant,_1,bericht,berichten] van [_2]</a>',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'Dit bent u',
	'Welcome to [_1].' => 'Welkom bij [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'U kunt uw blog beheren door een optie te selecteren uit het menu aan de linkerkant.',
	'If you need assistance, try:' => 'Als u hulp nodig hebt, probeer:',
	'Movable Type User Manual' => 'Gebruikershandleiding van Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Movable Type technische ondersteuning',
	'Movable Type Community Forums' => 'Movable Type community forums',
	'Change this message.' => 'Dit bericht wijzigen.',
	'Edit this message.' => 'Dit bericht wijzigen.',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Iw recente websites en blogs',
	'No website could be found. [_1]' => 'Geen website gevonden. [_1]',
	'Create a new' => 'Aanmaken',
	'No blogs could be found.' => 'Geen blog gevonden.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Nieuws',
	'No Movable Type news available.' => 'Geen Movable Type nieuws beschikbaar.',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Handige snelkoppelingen',
	'Import Content' => 'Inhoud importeren',
	'Blog Preferences' => 'Blogvoorkeuren',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Berichten van het systeem',

## tmpl/cms/widget/personal_stats.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Uw <a href="[_1]">laatste bericht</a> was [_2] op <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Uw laatste bericht was [_1] in <a href="[_2]">[_3]</a>.',
	'<a href="[_1]">[quant,_2,entry,entries]</a>' => '<a href="[_1]">[quant,_2,bericht,berichten]</a>',
	'[quant,_1,entry,entries]' => '[quant,_1,bericht,berichten]',
	q{<a href="[_1]">[quant,_2,page,pages]</a>} => q{<a href="[_1]">[quant,_2,pagina,pagina's]</a>},
	q{[quant,_1,page,pages]} => q{[quant,_1,pagina,pagina's]},
	'<a href="[_1]">[quant,_2,comment,comments]</a>' => '<a href="[_1]">[quant,_2,reactie,reacties]</a>',
	'[quant,_1,comment,comments]' => '[quant,_1,reactie,reacties]',
	'<a href="[_1]">[quant,_2,draft,drafts]</a>' => '<a href="[_1]">[quant,_2,kladbericht,kladberichten]</a>',
	'[quant,_1,draft,drafts]' => '[quant,_1,kladbericht,kladberichten]',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Geen blogs gevonden. [_1]',

## tmpl/cms/widget/recent_websites.tmpl
	'[quant,_1,blog,blogs]' => '[quant,_1,blog,blogs]',

## tmpl/cms/widget/site_stats.tmpl
	'Stats for [_1]' => 'Statistieken voor [_1]',
	'Statistics Settings' => 'Instellingen voor statistieken',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Uw AIM of AOL gebruikersnaam',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Meld u aan met uw AIM of AOL gebruikernaam.  Deze zal publiek te zien zijn.',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Aanmelden met uw Gmail account',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Aanmelden bij Movable Type met uw[_1] Account[_2]',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Uw Hatena ID',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Uw LiveJournal gebruikersnaam',
	'Learn more about LiveJournal.' => 'Meer weten over LiveJournal.',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'OpenID URL',
	'Sign in with one of your existing third party OpenID accounts.' => 'Aanmelden met een bestaande OpenID account.',
	'http://www.openid.net/' => 'http://www.openid.net/',
	'Learn more about OpenID.' => 'Meer weten over OpenID.',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad is een gratis, open systeem dat u een centrale identiteit geeft om reacties mee achter te laten op weblogs en om u mee aan te melden op andere websites.  U kunt zich er gratis registreren.',
	'Sign in or register with TypePad.' => 'Aanmelden of registreren met TypePad',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'URL van uw Vox blog',
	'Learn more about Vox.' => 'Meer weten over Vox.',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Uw Wordpress.com gebruikersnaam',
	'Sign in using your WordPress.com username.' => 'Meld u aan met uw Wordpress.com gebruikersnaam',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'OpenID nu inschakelen voor uw Yahoo! Japan account',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Nu OpenID inschakelen voor uw Yahoo! account',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Terug (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Aanmelden om te reageren',
	'Sign in using' => 'Aanmelden met',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Nog geen lid? <a href="[_1]">Registreer nu</a>!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Uw profiel',
	'Your login name.' => 'Uw gebruikersnaam.',
	'The name appears on your comment.' => 'Deze naam verschijnt onder uw reactie',
	'Your email address.' => 'Uw e-mail adres.',
	'Select a password for yourself.' => 'Kies een wachtwoord voor uzelf.',
	'The URL of your website. (Optional)' => 'De URL van uw website. (Optioneel)',
	'Return to the <a href="[_1]">original page</a>.' => 'Keer terug naar de <a href="[_1]">oorspronkelijke pagina</a>.',

## tmpl/comment/register.tmpl
	'Create an account' => 'Maak een account aan',
	'Register' => 'Registreer',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Bedankt om te registreren',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Voordat u een reactie kunt achterlaten, moet u eerst het registratieproces doorlopen door uw account te bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Om de registratieprocedure te voltooien moet u eerst uw account bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Om uw account te bestigen en activeren, gelieve in uw inbox te kijken en op de link te klikken in de e-mail die u net is toegestuurd.',
	'Return to the original entry.' => 'Terugkeren naar oorspronkelijk bericht',
	'Return to the original page.' => 'Terugkeren naar oorspronkelijke pagina',

## tmpl/comment/signup.tmpl
	'Password Confirm' => 'Wachtwoord bevestigen',

## tmpl/data_api/include/login_mt.tmpl

## tmpl/data_api/login.tmpl

## tmpl/error.tmpl
	'Missing Configuration File' => 'Ontbrekend configuratiebestand',
	'_ERROR_CONFIG_FILE' => 'Uw Movable Type configuratiebestand ontbreekt of kan niet gelezen worden. Gelieve het deel <a href=\"#\">Installation and Configuration</a> van de handleiding van Movable Type te raadplegen voor meer informatie.',
	'Database Connection Error' => 'Databaseverbindingsfout',
	'_ERROR_DATABASE_CONNECTION' => 'Uw database instellingen zijn ofwel ongeldig ofwel ontbreken ze in uw Movable Type configuratiebestand. Bekijk het deel <a href=\"#\">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',
	'CGI Path Configuration Required' => 'CGI-pad configuratie vereist',
	'_ERROR_CGI_PATH' => 'Uw CGIPath configuratieinstelling is ofwel ongeldig ofwel ontbreekt ze in uw Movable Type configuratiebestand. Bekijk het deel <a href=\"#\">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type activiteitlog',

## tmpl/feeds/feed_comment.tmpl
	'Unpublish' => 'Publicatie ongedaan maken',
	'More like this' => 'Meer zoals dit',
	'From this blog' => 'Van deze blog',
	'On this entry' => 'Op dit bericht',
	'By commenter identity' => 'Volgens identiteit reageerders',
	'By commenter name' => 'Volgens naam reageerders',
	'By commenter email' => 'Volgens e-mail reageerders',
	'By commenter URL' => 'Volgens URL reageerders',
	'On this day' => 'Op deze dag',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'Van deze auteur',

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Bronblog',
	'By source blog' => 'Volgens bronblog',
	'By source title' => 'Volgens titel bron',
	'By source URL' => 'Volgens URL bron',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Maak uw eerste blog aan',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{Om uw blog goed te kunnen publiceren, moet u aan Movable Type de URL van uw weblog en het pad op het bestandssysteem opgeven waar de bestanden gepubliceerd moeten worden.},
	'My First Blog' => 'Mijn eerste weblog',
	'Publishing Path' => 'Publicatiepad',
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{Uw 'publicatiepad' is het pad op het bestandsysteem van uw webserver waar Movable Type alle bestanden zal publiceren van uw weblog.  Uw webserver moet schrijfrechten hebben op deze map. },

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Tijdelijke map configuratie',
	'You should configure you temporary directory settings.' => 'U moet uw instellingen configureren voor de tijdelijke map.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Uw TempDir is met succes ingesteld.  Klik op 'Doorgaan' hieronder om verder te gaan met de configuratie.},
	'[_1] could not be found.' => '[_1] kon niet worden gevonden.',
	'TempDir is required.' => 'TempDir is vereist.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Het fysieke pad naar de tijdelijke map.',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Configuratiebestand',
	'The [_1] configuration file cannot be located.' => 'Het configuratiebestand [_1] kan niet worden gevonden',
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Gelieve de configuratietekst hieronder te gebruiken om een bestand mee aan te maken genaamd 'mt-config.cgi' in de hoofdmap van [_1] (dezelfde map waar u ook mt.cgi in aantreft).},
	'The wizard was unable to save the [_1] configuration file.' => 'De wizard kon het [_1] configuratiebestand niet opslaan.',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Kijk na of uw [_1] hoofdmap (de map die mt.cgi bevat) beschrijfbaar is door uw webserver en klik dan op 'Opnieuw'.},
	q{Congratulations! You've successfully configured [_1].} => q{Proficiat! U heeft met succes [_1] geconfigureerd.},
	'Show the mt-config.cgi file generated by the wizard' => 'Toon het mt-config.cgi bestand dat door de wizard is aangemaakt',
	'The mt-config.cgi file has been created manually.' => 'Het mt-config.cgi bestand werd met de hand aangemaakt.',
	'Retry' => 'Opnieuw',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Database configuratie',
	'Your database configuration is complete.' => 'Uw databaseconfiguratie is voltooid.',
	'You may proceed to the next step.' => 'U kunt verder gaan naar de volgende stap.',
	'Show Current Settings' => 'Huidige instellingen tonen',
	'Please enter the parameters necessary for connecting to your database.' => 'Gelieve de parameters in te vullen die nodig zijn om met uw database te verbinden.',
	'Database Type' => 'Databasetype',
	'Select One...' => 'Selecteer er één...',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Staat uw gewenste database er niet bij?  Kijk bij de <a href="[_1]" target="_blank">Movable Type systeemcontrole</a> of er bijkomende modules nodig zijn.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => '<a href="javascript:void(0)" onclick="[_1]">Klik hier om dit scherm te vernieuwen</a> zodra de installatie voltooid is.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Meer weten over: <a href="[_1]" target="_blank">Database instellen</a>',
	'Show Advanced Configuration Options' => 'Geavanceerde configuratieopties tonen',
	'Test Connection' => 'Verbinding testen',
	'You must set your Database Path.' => 'U moet uw databasepad instellen.',
	'You must set your Username.' => 'U moet uw gebruikersnaam instellen.',
	'You must set your Database Server.' => 'U moet uw database server instellen.',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'E-mail instellingen',
	'Your mail configuration is complete.' => 'Uw mailconfiguratie is volledig',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Controleer uw e-mail om te bevestigen of uw een testmail van Movable Type heeft ontvangen en ga dan verder naar de volgende stap.',
	'Show current mail settings' => 'Toon alle huidige mailinstellingen',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Movable Type zal af en toe e-mail versturen om gebruikers op de hoogte te brengen van nieuwe reacties en andere gebeurtenissen.  Om deze e-mails goed te kunnen versturen, moet u Movable Type vertellen hoe ze verstuurd moeten worden.',
	'An error occurred while attempting to send mail: ' => 'Er deed zich een fout voor toen er werd geprobeerd e-mail te verzenden: ',
	'Send mail via:' => 'Stuur mail via:',
	'Sendmail Path' => 'Sendmail pad',
	'The physical file path for your Sendmail binary.' => 'Het fysieke bestandspad van uw Sendmail binary',
	'Outbound Mail Server (SMTP)' => 'Uitgaande mailserver (SMTP)',
	'Address of your SMTP Server.' => 'Adres van uw SMTP server.',
	'Port number for Outbound Mail Server' => 'Poortnummer voor uitgaande mail server',
	'Port number of your SMTP Server.' => 'Poortnummer van uw SMTP server.',
	'Use SMTP Auth' => 'Gebruik SMTP Auth',
	'SMTP Auth Username' => 'SMTP Auth gebruikersnaam',
	'Username for your SMTP Server.' => 'Gebruikersnaam voor uw SMTP server.',
	'SMTP Auth Password' => 'SMTP Auth wachtwoord',
	'Password for your SMTP Server.' => 'Wachtwoord voor uw SMTP server.',
	'SSL Connection' => 'SSL verbinding',
	'Cannot use [_1].' => 'Kan [_1] niet gebruiken.',
	'Do not use SSL' => 'SSL niet gebruiken',
	'Use SSL' => 'SSL gebruiken',
	'Use STARTTLS' => 'STARTTLS gebruiken',
	'Send Test Email' => 'Verstuur testbericht',
	'Mail address to which test email should be sent' => 'E-mail adres om testbericht naartoe te sturen',
	'Skip' => 'Overslaan',
	'You must set the SMTP server port number.' => 'U moet het poortnummer van de SMTP server instellen.',
	'This field must be an integer.' => 'Dit veld moet een getal bevatten.',
	'You must set the system email address.' => 'U moet het systeem-emailadres nog instellen.',
	'You must set the Sendmail path.' => 'U moet het Sendmail pad nog instellen.',
	'You must set the SMTP server address.' => 'U moet het SMTP server adres nog instellen.',
	'You must set a username for the SMTP server.' => 'U moet een gebruikersnaam instellen voor de SMTP server.',
	'You must set a password for the SMTP server.' => 'U moet een wachtwoord instellen voor de SMTP server.',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Controle systeemvereisten',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Volgende Perl modules zijn vereist om een databaseconnectie te kunnen maken.  Movable Type heeft een database nodig om de gegevens van uw weblog in op te slaan.  Gelieve één van de packages hieronder te installeren om verder te kunnen gaan.  Wanneer u klaar bent, klik dan op de knop 'Opnieuw'.},
	'All required Perl modules were found.' => 'Alle vereiste Perl modules werden gevonden',
	'You are ready to proceed with the installation of Movable Type.' => 'U bent klaar om verder te gaan met de installatie van Movable Type',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Een aantal optionele Perl modules kon niet worden gevonden. <a href="javascript:void(0)" onclick="[_1]">Toon lijst optionele modules</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Eén of meer Perl modules vereist door Movable Type werden niet gevonden.',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{De onderstaande Perl modules zijn nodig voor de werking van Movable Type.  Eens uw systeem aan deze voorwaarden voldoet, klik op de 'Opnieuw' knop om opnieuw te testen of deze modules geïnstalleerd zijn.},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Een aantal optionele Perl modules konden niet worden gevonden.  U kunt verder gaan zonder deze optionele modules te installeren.  Ze kunnen op gelijk welk moment geïnstalleerd worden indien ze nodig zijn.  Klik op 'Opnieuw' om opnieuw te testen of de modules aanwezig zijn.},
	'Missing Database Modules' => 'Ontbrekende databasemodules',
	'Missing Optional Modules' => 'Ontbrekende optionele modules',
	'Missing Required Modules' => 'Ontbrekende vereiste modules',
	'Minimal version requirement: [_1]' => 'Minimale versievereisten: [_1]',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html',
	'Learn more about installing Perl modules.' => 'Meer weten over het installeren van Perl modules',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Op uw server zijn alle vereiste modules geïnstalleerd; u hoeft geen bijkomende modules te installeren.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Configuratiebestand bestaat',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type vereist dat JavaScript ingeschakeld is in uw browser.  Gelieve het in te schakelen en herlaad deze pagina om opnieuw te proberen.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Deze wizard zal u helpen met het configureren van de basisinstellingen om Movable Type te doen werken.',
	'Default language.' => 'Standaard taal',
	'Configure Static Web Path' => 'Statisch webpad instellen',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Fout: '[_1]' werd niet gevonden.</strong>  Gelieve eerst uw statische bestanden in de map te plaatsen of pas de instelling aan als deze niet juist is.},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type wordt geleverd met een map genaamd [_1] die een aantal belangrijke bestanden bevat zoals afbeeldingen, javascript bestanden en stylesheets.',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{De map [_1] bevindt zich in de hoofdmap van Movable Type waar ook dit wizard script zich bevindt, maar door de configuratie van uw webserver is de [_1] map niet toegankelijk op deze locatie en moet deze dus verplaatst worden naar een locatie die toegankelijk is vanop het web (m.a.w. uw document root map).},
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Deze map is ofwel van naam veranderd of is verplaatst naar een locatie buiten de Movable Type map.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Zodra de [_1] map verplaatst is naar een web-toegankelijke plaats, geef dan de locatie ervan hieronder op.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Dit URL pad kan in de vorm zijn van [_1] of eenvoudigweg [_2]',
	'This path must be in the form of [_1]' => 'Dit pad moet deze vorm hebben [_1]',
	'Static web path' => 'Pad voor statische bestanden',
	'Static file path' => 'Statisch bestandspad',
	'Begin' => 'Start!',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Er bestaat al een configuratiebestand (mt-config.cgi), U kunt <a href="[_1]">aanmelden</a> bij Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Om een nieuw configuratiebestand aan te maken met de Wizard moet u het huidige configuratiebestand verwijderen en deze pagina vernieuwen.',

## addons/Commercial.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',
	q{Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.} => q{Professioneel ontworpen, goed gestructureerd en makkelijk aan te passen website.  U kunt de standaardpagina's, voettekst en navigatie makkelijk personaliseren.},
	'_PWT_ABOUT_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
',
	'_PWT_CONTACT_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>

<p>We horen graag van u! Stuur ons mail via email (at) domeinnaam.com</p>
',
	'Welcome to our new website!' => 'Welkom op onze nieuwe website!',
	'_PWT_HOME_BODY' => '
<p><strong>Vervang deze voorbeeldtekst door uw eigen inhoud.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'Maak een blog aan als deel van een websitestructuur.  Dit werkt het beste met het Professional Website thema...',
	'Unknown Type' => 'Onbekend type',
	'Unknown Object' => 'Onbekend object',
	'Not Required' => 'Niet verplicht',
	'Are you sure you want to delete the selected CustomFields?' => 'Bent u zeker dat u de geselecteerde Extra Velden wenst te verwijderen?',
	'Photo' => 'Foto',
	'Embed' => 'Embed',
	'Custom Fields' => 'Extra velden',
	'Field' => 'Veld',
	'Template tag' => 'Sjabloontag',
	'Updating Universal Template Set to Professional Website set...' => 'Universele sjabloonset bij aan het werken tot Professionele Website sjabloonset...',
	'Migrating CustomFields type...' => 'Bezig CustomFields type te migreren...',
	'Converting CustomField type...' => 'Bezig CustomFields types te converteren...',
	'Professional Styles' => 'Professionele stijlen',
	'A collection of styles compatible with Professional themes.' => 'Een verzameling stijlen compatibel met Professionele thema\'s',
	'Professional Website' => 'Professionele Website',
	'Header' => 'Hoofding',
	'Footer' => 'Voettekst',
	'Entry Detail' => 'Berichtdetails',
	'Entry Metadata' => 'Metadata bericht',
	'Page Detail' => 'Pagina detail',
	'Footer Links' => 'Links in voettekst',
	'Powered By (Footer)' => 'Aangedreven door (voettekst)',
	'Recent Entries Expanded' => 'Recent aangepaste berichten',
	'Main Sidebar' => 'Primaire zijkolom',
	'Blog Activity' => 'Blogactiviteit',
	'Professional Blog' => 'Professionele blog',
	'Blog Archives' => 'Blogarchieven',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => 'Tonen',
	'Date & Time' => 'Datum en tijd',
	'Date Only' => 'Enkel datum',
	'Time Only' => 'Enkel tijd',
	q{Please enter all allowable options for this field as a comma delimited list} => q{Gelieve alle toegestane waarden voor dit veld in te vullen als een lijst gescheiden door komma's},
	'Exclude Custom Fields' => 'Extra velden negeren',
	'[_1] Fields' => 'Velden bij [_1]',
	'Edit Field' => 'Veld bewerken',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; datums moeten in het formaat YYYY-MM-DD HH:MM:SS staan.',
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ongeldige datum \'[_1]\'; datums moeten echte datums zijn.',
	'Please enter valid URL for the URL field: [_1]' => 'Gelieve een geldige URL in te vullen in het URL veld: [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Gelieve een waarde in te vullen voor het verplichte \'[_1]\' veld.',
	'Please ensure all required fields have been filled in.' => 'Kijk na of alle verplichte velden ingevuld zijn.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Sjabloontag \'[_1]\' is een ongeldige tagnaam.',
	'The template tag \'[_1]\' is already in use.' => 'De sjabloontag \'[_1]\' is al in gebruik.',
	'blog and the system' => 'blog en het systeem',
	'website and the system' => 'website en het systeem',
	'The basename \'[_1]\' is already in use. It must be unique within this [_2].' => 'De basisnaam \'[_1]\' is al in gebruik.  Hij moet uniek zijn binnen deze [_2].',
	'You must select other type if object is the comment.' => 'U moet een ander type selecteren als het object de reactie is.',
	'type' => 'type',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Pas de formulieren en velden aan voor berichten, pagina\'s, mappen, categoriën en gebruikers aan en sla exact die informatie op die u nodig heeft.',
	' ' => ' ',
	'Single-Line Text' => 'Een regel tekst',
	'Multi-Line Text' => 'Meerdere regels tekst',
	'Checkbox' => 'Checkbox',
	'Date and Time' => 'Datum en tijd',
	'Drop Down Menu' => 'Uitklapmenu',
	'Radio Buttons' => 'Radiobuttons',
	'Embed Object' => 'Embedded object',
	'Post Type' => 'Type bericht',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'Custom Fields data opgeslagen in MT::PluginData aan het terugzetten...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'Mediabestand-associaties aan het terugzetten die werden gevonden in gepersonaliseerde velden ( [_1] ) ...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'URL van de mediabestand aan het terugzetten geassocieerd via gepersonaliseerde velden ( [_1] )',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'The type "[_1]" is invalid.' => 'Het type "]_1]" is ongeldig.',
	'The systemObject "[_1]" is invalid.' => 'Het systemObject "[_1]" is ongeldig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => 'Gelieve een geldige optie in te vullen voor het [_1] veld: [_2]', # Translate - New

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Ongeldige includeShared parameter opgegeven: [_1]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'The template tag \'[_1]\' is already in use in the system level' => 'De sjabloontag \'[_1]\' is al in gebruik op systeemniveau',
	'The template tag \'[_1]\' is already in use in [_2]' => 'De sjabloontag \'[_1]\' wordt al gebruikt in [_2]',
	'The template tag \'[_1]\' is already in use in this blog' => 'De sjabloontag \'[_1]\' wordt al gebruikt op deze blog',
	'The \'[_1]\' of the template tag \'[_2]\' that is already in use in [_3] is [_4].' => 'De \'[_1]\' van de sjabloontag \'[_2]\' die al gebruikt wordt in [_3] is [_4].',
	'_CF_BASENAME' => 'Basename',
	'__CF_REQUIRED_VALUE__' => 'Waarde',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Bent u zeker dat u een \'[_1]\' tag gebruikte in de juiste context?  We vonden geen [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'U gebruikte een \'[_1]\' tag buiten de correcte context;',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => '[_1] gepersonaliseerde velden',
	'a field on this blog' => 'een veld op deze weblog',
	'a field on system wide' => 'een veld op systeemniveau',
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflict van [_1] "[_2]" met [_3]',
	'Template Tag' => 'Sjabloontag',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Metadata opslag voor pagina\'s word verplaatst...',
	'Removing CustomFields display-order from plugin data...' => 'Bezig volgorde hoe Extra Velden getoond worden te verwijderen uit plugin gegevens...',
	'Removing unlinked CustomFields...' => 'Niet gelinkte Extra Velden aan het verwijderen...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Bezig velden te klonen voor blog:',

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
	'Recently by <em>[_1]</em>' => 'Recent door <em>[_1]</em>',

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
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] reageerde op [_3]</a>: [_4]',

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
	'Entries ([_1]) Comments ([_2])' => 'Berichten ([_1]) Reacties ([_2])',

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
	'on [_1]' => 'op [_1]',
	'By [_1] | Comments ([_2])' => 'Door [_1] | Reacties ([_2])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => 'Kies [_1]',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Deze velden tonen',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'Gegevens zijn opgeslagen in de gepersonaliseerde velden.',
	'Save changes to blog (s)' => 'Wijzigingen aan blog opslaan (s)',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'Geen gepersonaliseerde velden gevonden. Nu <a href="[_1]">een veld aanmaken</a>.',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Gepersonaliseerd veld bewerken',
	'Create Custom Field' => 'Gepersonaliseerd veld aanmeken',
	'The selected field(s) has been deleted from the database.' => 'Geselecteerd(e) veld(en) verwijderd uit de database.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'U moet gegevens invullen in de vereiste velden die hieronder aangegeven zijn voor het gepersonaliseerde veld aangemaakt kan worden.',
	'You must save this custom field before setting a default value.' => 'U moet het gepersonaliseerde veld opslaan voor u een standaardwaarde kunt instellen.',
	'Choose the system object where this custom field should appear.' => 'Kies het systeemobject waarbij het gepersonaliseerde veld moet verschijnen.',
	'Required?' => 'Verplicht?',
	'Is data entry required in this custom field?' => 'Moeten er gegevens ingevuld worden in dit gepersonaliseerde veld?',
	'Must the user enter data into this custom field before the object may be saved?' => 'Moet de gebruiker gegevens invullen in dit gepersonaliseerde veld voor het object opgeslagen kan worden?',
	'Default' => 'Standaard',
	'The basename must be unique within this [_1].' => 'De basisnaam moet uniek zijn binnen deze [_1]',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Waarschuwing: het aanpassen van de basisnaam van deze tag vereist mogelijk aanpassingen aan bestaande sjablonen.},
	'Example Template Code' => 'Voorbeeldsjablooncode',
	'Show In These [_1]' => 'Tonen in deze [_1]',
	'Save this field (s)' => 'Dit veld opslaan (s)',
	'field' => 'veld',
	'fields' => 'velden',
	'Delete this field (x)' => 'Dit veld verwijderen (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Object',

## addons/Commercial.pack/tmpl/listing/field_list_header.tmpl

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'open',
	'click-down and drag to move this field' => 'klik en sleep om dit veld te verplaatsen',
	'click to %toggle% this box' => 'klik om dit vakje te %schakelen%',
	'use the arrow keys to move this box' => 'gebruik de pijltjestoetsen om dit vakje te verplaatsen',
	', or press the enter key to %toggle% it' => ', of druk op de enter-toets om het te %schakelen%',

## addons/Community.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'Verhoog de betrokkenheid van uw lezers - voeg opties toe aan uw website die het makkelijker maken voor uw lezers om betrokken te zijn bij uw inhoud en bedrijf.',
	'Create forums where users can post topics and responses to topics.' => 'Maak forums aan waar gebruikers onderwerpen kunnen aanmaken en antwoorden kunnen publiceren.',
	'Users followed by [_1]' => 'Gebruikers gevolgd door [_1]',
	'Users following [_1]' => 'Gebruikers die [_1] volgen',
	'Community' => 'Gemeenschap',
	'Sanitize' => 'Schoonmaakfilter',
	'Followed by' => 'Gevolgd door',
	'Followers' => 'Volgers',
	'Following' => 'Volgt',
	'Pending Entries' => 'Berichten in wachtrij',
	'Spam Entries' => 'Spamberichten',
	'Recently Scored' => 'Recent beoordeeld',
	'Recent Submissions' => 'Recente inzendingen',
	'Most Popular Entries' => 'Populairste berichten',
	'Registrations' => 'Registraties',
	'Login Form' => 'Aanmeldformulier',
	'Registration Form' => 'Registratieformulier',
	'Registration Confirmation' => 'Registratiebevestiging',
	'Profile View' => 'Profiel bekijken',
	'Profile Edit Form' => 'Bewerkingsformulier profiel',
	'Profile Feed' => 'Profielfeed',
	'New Password Form' => 'Formulier nieuw wachtwoord',
	'New Password Reset Form' => 'Formulier nieuw wachtwoord resetten',
	'Form Field' => 'Veld in formulier',
	'Status Message' => 'Statusboodschap',
	'Simple Header' => 'Eenvoudige hoofding',
	'Simple Footer' => 'Eenvoudige voettekst',
	'Header' => 'Hoofding',
	'Footer' => 'Voettekst',
	'GlobalJavaScript' => 'GlobaalJavaScript',
	'Email verification' => 'E-mail verificatie',
	'Registration notification' => 'Registratienotificatie',
	'New entry notification' => 'Notificatie nieuw bericht',
	'Community Styles' => 'Community stijlen',
	'A collection of styles compatible with Community themes.' => 'Een collectie stijlen compatibel met de Community thema\'s',
	'Community Blog' => 'Community-blog',
	'Atom ' => 'Atom',
	'Entry Response' => 'Antwoord op bericht',
	'Displays error, pending or confirmation message when submitting an entry.' => 'Toont foutboodschappen, \'even geduld\' berichten of bevestigingen bij het indienen van een bericht.',
	'Entry Detail' => 'Berichtdetails',
	'Entry Metadata' => 'Metadata bericht',
	'Page Detail' => 'Pagina detail',
	'Entry Form' => 'Berichtenformulier',
	'Content Navigation' => 'Navigatie inhoud',
	'Activity Widgets' => 'Activiteit widgets',
	'Archive Widgets' => 'Archiefwidgets',
	'Community Forum' => 'Community forum',
	'Entry Feed' => 'Berichtenfeed',
	'Displays error, pending or confirmation message when submitting a entry.' => 'Toont foutboodschappen, \'even geduld\' berichten of bevestigingen bij het indienen van een bericht.',
	'Popular Entry' => 'Populair bericht',
	'Entry Table' => 'Berichttabel',
	'Content Header' => 'Hoofding inhoud',
	'Category Groups' => 'Categoriegroepen',
	'Default Widgets' => 'Standaardwidgets',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'Geen sjabloon gedefiniëerd voor het aanmeldformulier',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'Voor u kunt aanmelden, moet u eerst uw e-mail adres bevestigen. <a href="[_1]">Klik hier</a> om de verificatiemail opnieuw te versturen.',
	'You are trying to redirect to external resources: [_1]' => 'U probeert te verwijzen naar externe bronnen: [_1]',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Authenticatie is geslaagd, maar nieuwe registraties zijn niet toegestaan.  Neem contact op met de systeembeheerder.',
	'(No email address)' => '(Geen e-mail adres)',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Gebruiker \'[_1]\' (ID:[_2]) werd met succes geregistreerd.',
	'Thanks for the confirmation.  Please sign in.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden.',
	'[_1] registered to Movable Type.' => '[_1] geregistreerd bij Movable Type',
	'Login required' => 'Aanmelden vereist',
	'Title or Content is required.' => 'Titel of inhoud is vereist.',
	'Publish failed: [_1]' => 'Publicatie mislukt: [_1]',
	'System template entry_response not found in blog: [_1]' => 'Systeemsjabloon entry_response niet gevonden voor blog: [_1]',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'Nieuw bericht \'[_1]\' toegevoegd aan de blog \'[_2]\'',
	'Unknown user' => 'Onbekende gebruiker',
	'All required fields must have valid values.' => 'Alle vereiste velden moeten geldige waarden bevatten.',
	'Recent Entries from [_1]' => 'Recente berichten van [_1]',
	'Responses to Comments from [_1]' => 'Antwoorden op reacties van [_1]',
	'Actions from [_1]' => 'Acties van [_1]',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type kno niet schrijven naar de "Upload bestemming".  Gelieve te controleren dat deze map beschrijfbaar is voor de webserver.',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => 'U gebruikte een \'[_1]\' tag buiten een MTIfEntryRecommended blok; misschien heeft u die daar per ongeluk geplaatst?',
	'Click here to recommend' => 'Klik hier om aan te raden',
	'Click here to follow' => 'Hier klikken om te volgen',
	'Click here to leave' => 'Hier klikken om niet meer te volgen',

## addons/Community.pack/lib/MT/Community/Upgrade.pm
	'Removing Profile Error global system template...' => 'Bezig globaal systeemsjabloon "Profielfout" te verwijderen...',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/templates/blog/about_this_page.mtml
	'This page contains a single entry by <a href="[_1]">[_2]</a> published on <em>[_3]</em>.' => 'Deze pagina bevat één bericht door <a href="[_1]">[_2]</a> gepubliceerd op <em>[_3]</em>.',

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Dit is een set widgets die andere inhoud tonen gebaseerd op het archieftype waarin ze voorkomen.  Meer info: [_1]',

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => 'Reactie op [_1]',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => 'De gegevans in #comments-content zullen worden vervangen door een aantal calls naar het paginerings-script',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'Hoofdpagina blog',

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/entry_create.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'Om een bericht te kunnen aanmaken op deze weblog moet u zich eerst registreren.',
	q{You don't have permission to post.} => q{U heeft geen permissie om een bericht te publiceren.},
	'Sign in to create an entry.' => 'Meld u aan om een bericht te kunnen schrijven.',
	'Select Category...' => 'Selecteer categorie...',

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Recent door <em>[_1]</em>',

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => 'Stem',
	'Votes' => 'Stemmen',

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => 'Bedankt om uw bericht in te sturen.',
	'Entry Pending' => 'Goed te keuren bericht',
	'Your entry has been received and held for approval by the blog owner.' => 'Uw bericht is ontvagen en wordt bewaard tot de blog-eigenaar het goedkeurt.',
	'Entry Posted' => 'Bericht gepubliceerd',
	'Your entry has been posted.' => 'Uw bericht is gepubliceerd.',
	'Your entry has been received.' => 'Uw bericht is ontvangen.',
	q{Return to the <a href="[_1]">blog's main index</a>.} => q{Terugkeren naar de <a href="[_1]">hoofdpagina van de blog</a>.},

## addons/Community.pack/templates/blog/entry_summary.mtml

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Dit is een gepersonaliseerde set widgets die enkel op de hoofpagina (of "hoofdindex") verschijnen.  Meer info: [_1]',

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] reageerde op [_3]</a>: [_4]',

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
	'Forum Groups' => 'Forum groepen',
	'Last Topic: [_1] by [_2] on [_3]' => 'Laatste onderwerp: [_1] door [_2] op [_3]',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => 'Wees de eerste om <a href="[_1]">een onderwerp te starten in dit forum</a>',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1] gaf antwoord op <a href="[_2]">[_3]</a>',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => 'Antwoord toevoegen',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => 'Antwoorden op [_1]',
	'Previewing your Reply' => 'Voorbeeld van antwoord aan het bekijken',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => 'Antwoord ingediend',
	'Your reply has been accepted.' => 'Uw antwoord werd aanvaard.',
	'Thank you for replying.' => 'Bedankt om te antwoorden.',
	'Your reply has been received and held for approval by the forum administrator.' => 'Uw antwoord werd ontvangen en wacht op goedkeuring van de forumadministrator.',
	'Reply Submission Error' => 'Fout bij indienen antwoord',
	'Your reply submission failed for the following reasons: [_1]' => 'Het indienen van uw antwoord mislukte wegens: [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => 'Terugkeren naar <a href="[_1]">het oorspronkelijke onderwerp</a>.',

## addons/Community.pack/templates/forum/comments.mtml
	'1 Reply' => '1 Antwoord',
	'# Replies' => '# Antwoorden',
	'No Replies' => 'Geen antwoorden',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'Onderwerp beginnen',

## addons/Community.pack/templates/forum/content_nav.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'Begin een onderwerp',

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'Onderwerp',
	'Select Forum...' => 'Selecteer forum...',
	'Forum' => 'Forum',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => 'Populaire onderwerpen',
	'Last Reply' => 'Laatste antwoord',
	'Permalink to this Reply' => 'Permanente link naar dit antwoord',
	'By [_1]' => 'Door [_1]',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => 'Bedankt om een nieuw onderwerp te publiceren in de forums.',
	'Topic Pending' => 'Onderwerp wacht op goedkeuring',
	'The topic you posted has been received and held for approval by the forum administrators.' => 'Het onderwerp dat u instuurde werd ontvangen en wordt bewaard tot de administratoren van het forum goedkeuren.',
	'Topic Posted' => 'Onderwerp gepubliceerd',
	'The topic you posted has been received and published. Thank you for your submission.' => 'Het onderwerp dat u instuurde werd ontvangen en gepubliceerd.  Bedankt voor uw bijdrage.',
	q{Return to the <a href="[_1]">forum's homepage</a>.} => q{Terugkeren naar de <a href="[_1]">hoofdpagina van het forum</a>.},

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => 'Recente onderwerpen',
	'Replies' => 'Antwoorden',
	'Closed' => 'Gesloten',
	'Post the first topic in this forum.' => 'Plaats het eerste onderwerp in dit forum',

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'Bedankt om u aan te melden,',
	'. Now you can reply to this topic.' => '. Nu kunt u antwoorden op dit onderwerp.',
	'You do not have permission to comment on this blog.' => 'U heeft geen toestemming om reacties achter te laten op deze weblog',
	' to reply to this topic.' => ' om te antwoorden op dit onderwerp.',
	' to reply to this topic,' => ' om te antwoorden op dit onderwerp,',
	'or ' => 'of ',
	'reply anonymously.' => ' reageer anoniem.',

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => 'Forum hoofdpagina',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => 'Onderwerpen die overeen komen met &ldquo;[_1]&rdquo;',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'Onderwerpen getagd als &ldquo;[_1]&rdquo;',
	'Topics' => 'Onderwerpen',

## addons/Community.pack/templates/forum/sidebar.mtml

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'Alle forums',
	'[_1] Forum' => 'Forum [_1]',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you for registering an account to [_1].' => 'Bedankt om een account te registreren op [_1]',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'Voor uw eigen veiligheid en om fraude te voorkomen, vragen we om uw account en e-mail adres te bevestigen vooraleer verder te gaan.  Zodra u bevestigd heeft, kunt u onmiddellijk aanmelden bij [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Om uw account te bevestigen moet u op deze link klikken of de URL in uw webbrowser plakken:',
	q{If you did not make this request, or you don't want to register for an account to [_1], then no further action is required.} => q{Als u hier niet zelf om gevraagd heeft, of u wenst geen account te registreren op [_1], dan is er niets dat u verder hoeft te doen.},
	'Thank you very much for your understanding.' => 'Wij danken u voor uw begrip.',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'Blogbeschrijving',

## addons/Community.pack/templates/global/javascript.mtml

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => 'Aangemeld als <a href="[_1]">[_2]</a>',
	'Logout' => 'Afmelden',
	'Hello [_1]' => 'Hallo [_1]',
	'Forgot Password' => 'Wachtwoord vergeten',
	'Sign up' => 'Registreer',

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'Nog geen lid?&nbsp;&nbsp;<a href="[_1]">Registreer</a>!',

## addons/Community.pack/templates/global/navigation.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	q{A new entry '[_1]([_2])' has been posted on your blog [_3].} => q{Een nieuw bericht  '[_1]([_2])' werd gepubliceerd op uw blog [_3].},
	'Author name: [_1]' => 'Auteursnaam: [_1]',
	'Author nickname: [_1]' => 'Bijnaam auteur: [_1]',
	'Title: [_1]' => 'Titel: [_1]',
	'Edit entry:' => 'Bewerk bericht:',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Go Back (x)' => 'Ga terug (x)',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => 'Ga <a href="[_1]">terug naar de vorige pagina</a> of <a href="[_2]">bekijk uw profiel</a>.',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => 'Publiceerde [_1] op [_2]',
	'Commented on [_1] in [_2]' => 'Reageerde op [_1] op [_2]',
	'Voted on [_1] in [_2]' => 'Stemde op [_1] op [_2]',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1] stemde op <a href="[_2]">[_3]</a> op [_4]',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'Gebruikersprofiel',
	'Recent Actions from [_1]' => 'Recente acties van [_1]',
	'You are following [_1].' => 'U volgt [_1].',
	'Unfollow' => 'Niet langer volgen',
	'Follow' => 'Volgen',
	'You are followed by [_1].' => 'U wordt gevolgd door [_1].',
	'You are not followed by [_1].' => 'U wordt niet gevolgd door [_1].',
	'Website:' => 'Website:',
	'Recent Actions' => 'Recente acties',
	'Comment Threads' => 'Reactie threads',
	'Commented on [_1]' => 'Reageerde op [_1]',
	'Favorited [_1] on [_2]' => 'Maakte [_1] favoriet op [_2]',
	'No recent actions.' => 'Geen recente acties.',
	'[_1] commented on ' => '[_1] reageerde op ',
	'No responses to comments.' => 'Geen antwoorden op reacties.',
	'Not following anyone' => 'Volgt niemand',
	'Not being followed' => 'Wordt niet gevolgd',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => 'Authenticatiemail verzonden',
	'Profile Created' => 'Profiel aangemaakt',

## addons/Community.pack/templates/global/register_form.mtml

## addons/Community.pack/templates/global/register_notification_email.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{Deze e-mail dient om u te melden dat een nieuwe gebruiker zich met succes registreerde op blog '[_1]'.  Hieronder leest u nuttige informatie over deze gebruiker.},

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => 'U bent aangemeld als <a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => 'U bent aangemeld als [_1]',
	'Edit profile' => 'Profiel bewerken',
	'Not a member? <a href="[_1]">Register</a>' => 'Nog geen lid? <a href="[_1]">Registreer nu</a>',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'Community instellingen',
	'Anonymous Recommendation' => 'Anonieme aanbevelingen',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'Kruis dit vakje aan om anonieme gebruikers (gebruikers die niet zijn aangemeld) toe te laten discussies aan te raden.  Het IP adres van de gebruiker wordt gebruikt om gebruikers uit elkaar te houden.',
	'Allow anonymous user to recommend' => 'Anonieme gebruikers toelaten aanbevelingen te doen',
	'Junk Filter' => 'Junk Filter',
	'If enabled, all moderated entries will be filtered by Junk Filter.' => 'Indien ingeschakeld zullen alle gemodereerde berichten gefilterd worden door Junk Filter',
	'Save changes to blog (s)' => 'Wijzigingen aan blog opslaan (s)',

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => 'Recent geregistreerd',
	'default userpic' => 'standaardfoto gebruiker',
	'You have [quant,_1,registration,registrations] from [_2]' => 'U heeft [quant,_1,registratie,registraties] op [_2]',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => 'Er zijn geen populaire berichten.',

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => 'Er zijn geen recente favoriete berichten.',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Enterprise.pack/app-cms.yaml
	'Groups ([_1])' => 'Groepen ([_1])',
	'Are you sure you want to delete the selected group(s)?' => 'Bent u zeker dat u de geselecteerde groep(en) wenst te verwijderen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Bent u zeker dat u de geselecteerde leden of het geselcteerde lid wenst te verwijderen uit de groep?',
	'[_1]\'s Group' => 'Groep van [_1]',
	'Groups' => 'Groepen',
	'Manage Member' => 'Lid beheren',
	'Bulk Author Export' => 'Auteurs exporteren in bulk',
	'Bulk Author Import' => 'Auteurs importeren in bulk',
	'Synchronize Users' => 'Gebruikers synchroniseren',
	'Synchronize Groups' => 'Groepen synchroniseren',
	'Add user to group' => 'Gebruiker toevoegen aan een groep',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Deze module is vereist als u LDAP authenticatie wenst te gebruiken.',

## addons/Enterprise.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',
	'Permissions of group: [_1]' => 'Permissies van groep: [_1]',
	'Group' => 'Groep',
	'Groups associated with author: [_1]' => 'Groepen geassocieerd met auteur: [_1]',
	'Inactive' => 'Inactief',
	'Members of group: [_1]' => 'Leden van groep: [_1]',
	'Advanced Pack' => 'Advanced pack',
	'User/Group' => 'Gebruiker/groep',
	'User/Group Name' => 'Naam gebruiker/groep',
	'__GROUP_MEMBER_COUNT' => 'Leden',
	'My Groups' => 'Mijn groepen',
	'Group Name' => 'Groepsnaam',
	'Manage Group Members' => 'Groepsleden beheren',
	'Group Members' => 'Groepsleden',
	'Group Member' => 'Groepslid',
	'Permissions for Users' => 'Permissies voor gebruikers',
	'Permissions for Groups' => 'Permissies voor groepen',
	'Active Groups' => 'Actieve groepen',
	'Disabled Groups' => 'Gedeactiveerde groepen',
	'Oracle Database (Recommended)' => 'Oracle database (aangeradenà',
	'Microsoft SQL Server Database' => 'Microsoft SQL Server database',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Microsoft SQL Server Database met UTF-8 ondersteuning (aangeraden)',
	'Publish Charset' => 'Karakterset voor publicatie',
	'ODBC Driver' => 'ODBC Driver',
	'External Directory Synchronization' => 'Externe directory-synchronisatie',
	'Populating author\'s external ID to have lower case user name...' => 'Extern ID van auteur aan het bevolken zodat de gebruikersnaam in kleine letters staat...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'Cannot connect to LDAP server.' => 'Kan geen verbinding maken met de LDAP server.',
	'User [_1]([_2]) not found.' => 'Gebruker [_1]([_2]) niet gevonden.',
	'User \'[_1]\' cannot be updated.' => 'Gebruiker \'[_1]\' kan niet worden bijgewerkt.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Gebruiker \'[_1]\' bijgewerkt met LDAP login ID.',
	'LDAP user [_1] not found.' => 'LDAP gebruiker [_1] niet gevonden.',
	'User [_1] cannot be updated.' => 'Gebruiker [_1] kan niet worden bijgewerkt.',
	'User cannot be updated: [_1].' => 'Gebruiker kan niet worden bijgewerkt: [_1].',
	'Failed login attempt by user \'[_1]\' who was deleted from LDAP.' => 'Mislukte aanmeldpoging van gebruiker \'[_1]\' die werd verwijderd uit LDAP.',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Gebruiker \'[_1]\' bijgewerkt met LDAP loginnaam \'[_2]\'.',
	'Failed login attempt by user \'[_1]\'. A user with that username already exists in the system with a different UUID.' => 'Mislukte aanmeldpoging van gebruiker \'[_1]\'.  Een gebruiker met die gebruikersnaam bestaat al in het systeem met een andere UUID.',
	'User \'[_1]\' account is disabled.' => 'Account van gebruiker \'[_1]\' is niet actief.',
	'LDAP users synchronization interrupted.' => 'LDAP gebruikerssynchronisatie onderbroken',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Laden van MT::LDAP;;Multi mislukt: [_1]',
	'External user synchronization failed.' => 'Externe gebruikerssynchronisatie mislukt.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Een poging om alle systeembeheerders in het systeem uit te schakelen werd ondernomen.  Synchronisatie van gebruikers werd onderbroken.',
	'Information about the following users was modified:' => 'Informatie over volgende gebruikers werd bijgewerkt:',
	'The following users were disabled:' => 'Deze gebruikers werden gedesactiveerd:',
	'LDAP users synchronized.' => 'LDAP gebruikers gesynchroniseerd',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'Synchronisatie van groepen kan niet worden uitgevoerd zonder dat LDAPGroupIdAttribute en/of LDAPGroupNameAttribute ingesteld zijn.',
	'Primary group members cannot be synchronized with Active Directory.' => 'Primaire groepsleden kunen niet gesynchroniseerd worden met Active Directory.',
	'Cannot synchronize LDAP groups members.' => 'Kan LDAP groepsleden niet synchroniseren.',
	'User filter was not built: [_1]' => 'Gebruikersfilter werd niet opgebouwd: [_1]',
	'LDAP groups synchronized with existing groups.' => 'LDAP groepen zijn gesynchroniseerd met bestaande groepen.',
	'Information about the following groups was modified:' => 'Informatie over volgend groepen werd bijgewerkt:',
	'No LDAP group was found using the filter provided.' => 'Geen LDAP groep gevonden met de opgegeven filter.',
	'The filter used to search for groups was: \'[_1]\'. Search base was: \'[_2]\'' => 'De filter die gebruikt werd om groepen te zoeken was: \'[_1]\'.  Zoekbasis was: \'[_1]\'.',
	'(none)' => '(Geen)',
	'The following groups were deleted:' => 'Volgende groepen werden verwijderd:',
	'Failed to create a new group: [_1]' => 'Nieuwe groep aanmaken mislukt: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => '´[_1] directief moet ingesteld zijn om leden van een LDAP groep te synchroniseren naar Movable Type Advanced',
	'Cannot get group \'[_1]\' (#[_2]) entry and its all member attributes from external directory.' => 'Kan geen informatie over groep \'[_1]\' (#[_2]) en bijhorende attributen ophalen uit externe directory.',
	'Cannot get member entries of group \'[_1]\' (#[_2]) from external directory.' => 'Kan geen informatie over leden van greop \'[_1]\' (#[_2]) ophalen uit externe directory.',
	'Members removed: ' => 'Leden verwijderd:',
	'Members added: ' => 'Leden toegevoegd:',
	'Memberships in the group \'[_2]\' (#[_3]) were changed as a result of synchronizing with the external directory.' => 'Lidmaatschappen in de groep \'[_2]\' (#[_3]) werden aangepast als resultaat van de synchronisatie met de externe directory',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'LDAPUserGroupMemberAttribute moet ingesteld zijn om synchronisatie van groepsleden mogelijk te maken.',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Laden van MT::LDAP mislukt: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => 'Formatteringsfout op regel [_1]: [_2]',
	'Invalid command: [_1]' => 'Ongeldig commando: [_1]',
	'Invalid number of columns for [_1]' => 'Ongeldig aantal kolommen voor [_1]',
	'Invalid user name: [_1]' => 'Ongeldige gebruikersnaam: [_1]',
	'Invalid display name: [_1]' => 'Ongeldige getoonde naam: [_1]',
	'Invalid email address: [_1]' => 'Ongeldig e-mail adres: [_1]',
	'Invalid password: [_1]' => 'Ongeldig wachtwoord: [_1]',
	'\'Personal Blog Location\' setting is required to create new user blogs.' => '\'Locatie persoonlijke blog\' instelling is vereist om nieuwe gebruikersblogs aan te maken.',
	'Invalid weblog name: [_1]' => 'Ongeldige weblognaam: [_1]',
	'Invalid blog URL: [_1]' => 'Ongeldige blog URL: [_1]',
	'Invalid site root: [_1]' => 'Ongeldige siteroot: [_1]',
	'Invalid timezone: [_1]' => 'Ongeldige tijdzone: [_1]',
	'Invalid theme ID: [_1]' => 'Ongeldig thema ID: [_1]',
	'A theme \'[_1]\' was not found.' => 'Geen \'[_1]\'thema gevonden.',
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Een gebruiker met dezelfde naam werd gevonden.  De registratie werd niet uitgevoerd: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Blog voor gebruiker \'[_1]\' kon niet worden aangemaakt.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Blog \'[_1]\' voor gebruiker \'[_2]\' werd aangemaakt.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'Fout bij toekennen ven weblog administratierechten aan gebruiker \'[_1] (ID: [_2])\' voor weblog \'[_3] (ID: [_4])\'.  Er werd geen geschikte administrator rol gevonden in het systeem.',
	'Permission granted to user \'[_1]\'' => 'Permissie toegekend aan gebruiker \{[_1]\'',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => 'Gebruiker  \'[_1]\' bestaat al.  De update werd niet doorgevoerd: [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'Gebruiker  \'[_1]\' niet gevonden.  De update werd niet doorgevoerd.',
	'User \'[_1]\' has been updated.' => 'Gebruiker \'[_1]\' is bijgewerkt.',
	'User \'[_1]\' was found, but the deletion was not processed' => 'Gebruiker  \'[_1]\' werd gevonden maar de verwijdering werd niet uitgevoerd.',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'Gebruiker  \'[_1]\' werd niet gevonden.  De verwijdering werd niet uitgevoerd.',
	'User \'[_1]\' has been deleted.' => 'Gebruiker \'[_1]\' werd verwijderd.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced probeerde net uw account uit te schakelen tijdens synchronisatie met de externe directory.  Er moet een fout zitten in de instellingen voor extern gebruikersbeheer.  Gelieve uw configuratie bij te stellen voor u verder gaat.',
	'Each group must have a name.' => 'Elke groep moet een naam hebben',
	'Search Users' => 'Gebruikers zoeken',
	'Select Groups' => 'Selecteer groepen',
	'Groups Selected' => 'Geselecteerde groepen',
	'Search Groups' => 'Groepen zoeken',
	'Add Users to Groups' => 'Gebruikers toevoegen aan groepen',
	'Invalid group' => 'Ongeldige groep',
	'Add Users to Group [_1]' => 'Voeg gebruikers toe aan groep [_1]',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd uit groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
	'Group load failed: [_1]' => 'Laden groep mislukt: [_1]',
	'User load failed: [_1]' => 'Laden gebruiker mislukt: [_1]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) toegevoegd aan groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
	'Users & Groups' => 'Gebruikers & Groepen',
	'Group Profile' => 'Groepsprofiel',
	'Author load failed: [_1]' => 'Laden auteur mislukt: [_1]',
	'Invalid user' => 'Ongeldige gebruiker',
	'Assign User [_1] to Groups' => 'Gebruiker [_1] toewijzen aan groepen',
	'Type a group name to filter the choices below.' => 'Tik een groepsnaam in om de onderstaande keuzes te filteren',
	'Bulk import cannot be used under external user management.' => 'Bulk import kan niet worden gebruikt onder extern gebruikersbeheer.',
	'Bulk management' => 'Bulkbeheer',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Er werden geen records gevonden in het bestand.  Kijk na of het bestand CRLF gebruiker als einde-regel karakters.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Gebruiker,Gebruikers] geregistreerd, [quant,_2,gebruiker,gebruikers] bijgewerkt, [quant,_3,gebruiker,gebruikers] verwijderd.',
	'Bulk author export cannot be used under external user management.' => 'Bulk export van auteurs kan niet gebruikt worden onder extern gebruikersbeheer.',
	'A user cannot change his/her own username in this environment.' => 'Een gebruiker kan zijn/haar gebruikersnaam niet aanpassen in deze omgeving',
	'An error occurred when enabling this user.' => 'Er deed zich een fout voor bij het activeren van deze gebruiker.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Een parameter "[_1]" is ongeldig.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Groep aanmaken mislukt: ExternalGroupManagement is ingeschakeld.',
	'Cannot add member to inactive group.' => 'Kan geen lid toevoegen aan inactieve groep.',
	'Adding member to group failed: [_1]' => 'Lid toevoegen aan groep mislukt: [_1]',
	'Removing member from group failed: [_1]' => 'Lid verwijderen uit groep mislukt: [_1]',
	'Group not found' => 'Groep niet gevonden',
	'Member not found' => 'Lid niet gevonden',
	'A resource "member" is required.' => 'Een bron ("member") is vereist.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => 'Associatie niet gevonden',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Binaire data aan het fixen voor opslag in Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Login',
	'Found' => 'Gevonden',
	'Not Found' => 'Niet gevonden',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ongeldig LDAPAuthURL schema: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Probleem bij connecteren naar LDAP server [_1]: [_2]',
	'Entry not found in LDAP: [_1]' => 'Item niet gevonden in LDAP: [_1]',
	'Binding to LDAP server failed: [_1]' => 'Binden aan LDAP server mislukt: [_1]',
	'User not found in LDAP: [_1]' => 'Gebruiker niet gevonden in LDAP: [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'Meer dan één gebruiker met dezelfde naam gevonden in LDAP: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] wordt niet ondersteund in deze versie van de MS SQL Server Driver',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Deze versie van de UMSSQLServer driver vereist DBD::ODBC versie 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Deze verie van de UMSSQLServer driver vereist DBD::ODBC gecompileerd met Unicode ondersteuning.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Gebruikers beheren in bulk',
	'_USAGE_AUTHORS_2' => 'U kunt gebruikers aanmaken, bewerken en verwijderen in bulk door een CSV-geformatteerd bestand te uploaden dat de juiste instructies en relevante gegevens bevat.',
	q{New user blog would be created on '[_1]'.} => q{Nieuwe gebruikersblog zou aangemaakt worden onder '[_1]'.},
	'[_1] Edit</a>' => '[_1] bewerken</a>',
	q{You must set 'Personal Blog Location' to create a new blog for each new user.} => q{U moet de 'Persoonlijke blog locatie' instellen om een nieuwe blog aan te maken voor elke nieuwe gebruiker.},
	'[_1] Setting</a>' => '[_1] instelling</a>',
	'Upload source file' => 'Bronbestand uploaden',
	'Specify the CSV-formatted source file for upload' => 'Geef het CSV-geformatteerde bronbestand op dat moet worden geupload',
	'Source File Encoding' => 'Encodering bronbestand',
	'Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.' => 'Movable Type zal proberen automatisch de encodering van uw importbestand te detecteren.  Als u echter fouten opmerkt of problemen ondervindt, kunt u de karacterencodering ook expliciet instellen.',
	'Upload (u)' => 'Uploaden (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'Authentication Configuration' => 'Authenticatieconfiguratie',
	'You must set your Authentication URL.' => 'U moet uw AuthenticatieURL instellen.',
	'You must set your Group search base.' => 'U moet uw Group search base instellen.',
	'You must set your UserID attribute.' => 'U moet uw UserID attribuut instellen.',
	'You must set your email attribute.' => 'U moet uw email attribuut instellen.',
	'You must set your user fullname attribute.' => 'U moet uw user fullname attribuut instellen.',
	'You must set your user member attribute.' => 'U moet uw user member attribuut instellen.',
	'You must set your GroupID attribute.' => 'U moet uw GroupID attribuut instellen.',
	'You must set your group name attribute.' => 'U moet uw group name attribuut instellen.',
	'You must set your group fullname attribute.' => 'U moet uw fullname attribuut instellen.',
	'You must set your group member attribute.' => 'U moet uw group member attribuut instellen.',
	'An error occurred while attempting to connect to the LDAP server: ' => 'Er deed zich een fout voor bij het verbinden met de LDAP server: ',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'U kunt uw LDAP instellingen van hieruit configureren als uw LDAP-gebaseerde authenticatie wenst te gebruiken.',
	'Your configuration was successful.' => 'Configuratie is geslaagd.',
	q{Click 'Continue' below to configure the External User Management settings.} => q{Klik hieronder op 'Doorgaan' om de instellingen voor extern gebruikersbeheer te configureren.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Klik hieronder op 'Doorgaan' om uw LDAP attribute mappings in te stellen.},
	'Your LDAP configuration is complete.' => 'Uw LDAP configuratie is voltooid.',
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Om naar het einde van de configuratiewizard te gaan, klik hieronder op 'Doorgaan'.},
	'Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'Kan Net:LDAP niet vinden. Net::LDAP is vereist om LDAP authenticatie te kunnen gebruiken.',
	'Use LDAP' => 'LDAP gebruiken',
	'Authentication URL' => 'Authenticatie URL',
	'The URL to access for LDAP authentication.' => 'De URL te gebruiken om toegang te krijgen tot LDAP authenticatie',
	'Authentication DN' => 'Authenticatie DN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'Een optionele DN die wordt gebruikt om aan de LDAP directory te binden wanneer er naar een gebruiker wordt gezocht.',
	'Authentication password' => 'Authenticatiewachtwoord',
	'Used for setting the password of the LDAP DN.' => 'Gebruikt om het wachtwoord in te stellen van de LDAP DN',
	'SASL Mechanism' => 'SASL mechanisme',
	'The name of the SASL Mechanism used for both binding and authentication.' => 'De naam van het SASL Mechanisme gebruikt voor binding en authenticatie.',
	'Test Username' => 'Test gebruikersnaam',
	'Test Password' => 'Test wachtwoord',
	'Enable External User Management' => 'Extern gebruikersbeheer inschakelen',
	'Synchronization Frequency' => 'Synchronisatiefrequentie',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'Synchronisatiefrequentie in minuten. (Standaard is 60 minuten)',
	'15 Minutes' => '15 minuten',
	'30 Minutes' => '30 minuten',
	'60 Minutes' => '60 minuten',
	'90 Minutes' => '90 minuten',
	'Group Search Base Attribute' => 'Group search basisattribuut',
	'Group Filter Attribute' => 'Group filter attribuut',
	'Search Results (max 10 entries)' => 'Zoekresultaten (max. 10 items)',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'Er werden geen groepen gevonden met deze instellingen',
	'Attribute mapping' => 'Attribuutmapping',
	'LDAP Server' => 'LDAP server',
	'Other' => 'Andere',
	'User ID Attribute' => 'User ID attribuut',
	'Email Attribute' => 'Email attribuut',
	'User Fullname Attribute' => 'User fullname attribuut',
	'User Member Attribute' => 'User member attribuut',
	'GroupID Attribute' => 'GroupID attribuut',
	'Group Name Attribute' => 'Group name attribuut',
	'Group Fullname Attribute' => 'Group fullname attribuut',
	'Group Member Attribute' => 'Group member attribuut',
	'Search Result (max 10 entries)' => 'Zoekresultaat (max. 10 items)',
	'Group Fullname' => 'Volledige naam groep',
	'(and [_1] more members)' => '(en nog [_1] leden)',
	'No groups could be found.' => 'Er werden geen groepen gevonden',
	'User Fullname' => 'Volledige naam gebruiker',
	'(and [_1] more groups)' => '(en nog [_1] groepen)',
	'No users could be found.' => 'Er werden geen gebruikers gevonden',
	'Test connection to LDAP' => 'Verbinding met LDAP testen',
	'Test search' => 'Zoektest',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Alle gebruikers met succes bijgewerkt.',
	'An error occurred during the update process. Please check your CSV file.' => 'Er deed zich een fout voor tijdens het updateproces.  Gelieve uw CSV bestand na te kijken.',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Enterprise.pack/tmpl/dialog/dialog_select_group_user.tmpl

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'U moet een paar groepen aanmaken.',
	q{Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Click here</a> to create a group.} => q{Voor u dit kunt doen, moet u eerst een paar groepen aanmaken. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Klik hier</a> om een groep aan te maken.},

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'Groep bewerken',
	'Create Group' => 'Groep aanmaken',
	'This group profile has been updated.' => 'Dit groepsprofiel werd bijgewerkt.',
	'This group was classified as pending.' => 'Deze groep werd geclassificeerd als in aanvraag.',
	'This group was classified as disabled.' => 'Deze groep werd geclassificeerd als gedeactiveerd.',
	'Member ([_1])' => 'Lid ([_1])',
	'Members ([_1])' => 'Leden ([_1])',
	'Permission ([_1])' => 'Permissie ([_1])',
	'Permissions ([_1])' => 'Permissies ([_1])',
	'LDAP Group ID' => 'LDAP Group ID',
	'The LDAP directory ID for this group.' => 'Het LDAP directory ID van deze groep',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'Status van deze groep in het systeem.  Een groep deactiveren ontzegt de leden ervan toegang tot het systeem maar behoudt hun inhoud en geschiedenis.',
	'The name used for identifying this group.' => 'De naam gebruikt om deze groep mee aan te duiden.',
	'The display name for this group.' => 'De getoonde naam van deze groep.',
	'The description for this group.' => 'De beschrijving van deze groep.',
	'Save changes to this field (s)' => 'De wijzigingen aan dit veld opslaan (s)',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'Enable selected group (e)' => 'De geselecteerde groep activeren (e)',
	'Disable selected group (d)' => 'De geselecteerde groep deactiveren (d)',
	'group' => 'groep',
	'groups' => 'groepen',
	'Remove selected group (d)' => 'De geselecteerde groep verwijderen (d)',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'Gebruikers &amp; groepen voor [_1]',

## addons/Enterprise.pack/tmpl/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => 'U deactiveerde met succes de geselecteerde groep(en).',
	'You successfully enabled the selected group(s).' => 'U activeerde met succes de geselecteerde groep(en).',
	'You successfully deleted the groups from the Movable Type system.' => 'U verwijderde met succes de groepen uit het Movable Type systeem.',
	q{You successfully synchronized the groups' information with the external directory.} => q{U synchroniseerde met succes de groepsinformatie met de externe directory.},

## addons/Enterprise.pack/tmpl/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'U verwijderde met succes de gebruikers.',
	'You successfully added new users to this group.' => 'U voegde met succes nieuwe gebruikers toe aan deze groep.',
	q{You successfully synchronized users' information with the external directory.} => q{U synchroniseerde met succes informatie over gebruikers met de externe directory.},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Sommige ([_1]) van de geselecteerde gebruikers konden niet gereactiveerd worden omdat ze niet langer gevonden worden in LDAP.',
	'You successfully removed the users from this group.' => 'U verwijderde met succes de gebruikers uit de groep.',

## addons/Sync.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',
	'Migrated sync setting' => 'Synchronisatie-instellingen gemigreerd',
	'Sync' => 'Synchronisatie',
	'Sync Name' => 'Synchronisatie naam',
	'Sync Datetime' => 'Synchronisatie datum en tijd',
	'Manage Sync Settings' => 'Synchronisatie instellingen beheren',
	'Sync Setting' => 'Synchronsatie instelling',
	'Sync Settings' => 'Synchronisatie instellingen',
	'Create new sync setting' => 'Nieuwe synchronisatie instelling aanmaken',
	'Contents Sync' => 'Synchronisatie inhoud',
	'Remove sync PID files' => 'PID bestanden synchronisatie verwijderen', # Translate - New
	'Updating MT::SyncSetting table...' => 'Bezig MT::SyncSetting tabel bij te werken...',
	'Migrating settings of contents sync on website...' => 'Bezig instellingen van inhoudssynchronisatie op website te migreren...',
	'Migrating settings of contents sync on blog...' => 'Bezig instellingen van inhoudssynchronisatie op blog te migreren..',
	'Re-creating job of contents sync...' => 'Inhoudsssynchronisatie job opnieuw aan het aanmaken...',

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'Geen toegang tot externe map \'[_1]\'',
	'Deleting file \'[_1]\' failed.' => 'Verwijderen bestand \'[_1]\' mislukt.',
	'Deleting path \'[_1]\' failed.' => 'Verwijderen pad \'[_1]\' mislukt.',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Er bestaat een bestand of map waarvan de naam eindigt op een punt(.) of een blanco extansie. Kan deze bestanden niet synchroniseren.: "[_1]"', # Translate - New
	'Unable to write temporary file ([_1]): [_2]' => 'Schrijven naar tijdelijk bestand mislukt ([_1]): [_2]',
	'Unable to get size of temporary file ([_1]): [_2]' => 'Kon grootte van tijdelijk bestand niet vinden ([_1]): [_2]', # Translate - New
	'FTP reconnection was failed. ([_1])' => 'FTP verbinding mislukt. ([_])', # Translate - New
	'FTP connection lost.' => 'FTP verbinding verbroken.', # Translate - New
	'FTP connection timeout.' => 'FTP verbinding te lang inactief.', # Translate - New
	'Unable to write remote files. Please check activity log for more details.: [_1]' => 'Schrijven van externe bestanden mislukt.  Kijk het activiteitenlog na voor meer details: [_1]',
	'Unable to write remote files ([_1]): [_2]' => 'Kon geen externe bestanden schrijven ([_1]): [_2]',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Failed to remove sync list. (ID:\'[_1]\')' => 'Verwijderen sychronisatielijst mislukt. (ID:\'[_1]\')',
	'Failed to update sync list. (ID:\'[_1]\')' => 'Bijwerken synchronisatielijst mislukt. (ID:\'[_1]\')',
	'Failed to create sync list.' => 'Aanmaken synchronisatielijst mislukt.',
	'Failed to save sync list. (ID:\'[_1]\')' => 'Opslaan synchronisatielijst mislukt. (ID:\'[_1]\')',
	'Error switching directory.' => 'Fout bij wisselen van map.',
	'Synchronization with an external server has been successfully finished.' => 'Synchronisatie naar externe server met succes afgerond.',
	'Failed to sync with an external server.' => 'Synchronisatie naar externe server mislukt.',

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Temp Directory [_1] is not writable.' => 'Tijdelijke map [_1] niet beschrijfbaar.',
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Fout tijdens rsync: commando (exitcode [_1]): [_2]',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Bestandslijst synchronisatie',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Instellingen synchronisatie',

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	'Sync setting # [_1] not found.' => 'Synchronisatie instelling # [_1] niet gevonden.',
	'This sync setting is being processed already.' => 'Deze synchronisatie-instelling wordt al behandeld momenteel.',
	'Unknown error occurred.' => 'Er deed zich een onbekende fout voor.',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'Deze mail is om u te melden dat synchronisatie met een externe server met succes werd afgerond.',
	'Saving sync settings failed: [_1]' => 'Opslaan instelling voor synchronisatie mislukt: [_1]',
	'Failed to remove temporary directory: [_1]' => 'Verwijderen van tijdelijke map mislukt: [_1]',
	'Failed to remove pid file.' => 'Verwijderen van pid bestand mislukt.',
	'This email is to notify you that failed to sync with an external server.' => 'Deze mail is om u te melden dat synchronisatie met een externe server mislukt is.',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Copied [_1]' => '[_1] gekopiëerd',
	'The sync setting with the same name already exists.' => 'Een synchronisatie instelling met dezelfde naam bestaat al.',
	'Reached the upper limit of the parallel execution.' => 'Maximumlimiet voor uitvoering in paralel bereikt.', # Translate - New
	'Process ID can\'t be acquired.' => 'Kan proces ID niet vinden.', # Translate - New
	'An error occurred while attempting to connect to the FTP server \'[_1]\': [_2]' => 'Er deed zich een fout voor bij het verbinden met de FTP server \'[_1]\': [_2]',
	'An error occurred while attempting to retrieve the current directory from \'[_1]\'' => 'Er deed zich een fout voor bij het ophalen van de huidige map van \'[_1]\'',
	'An error occurred while attempting to retrieve the list of directories from \'[_1]\'' => 'Er deed zich een fout voor bij het ophalen van de lijst van mappen van \'[_1]\'',

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Bezig alle inhoudssynchronisatie-jobs te verwijderen...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Settings' => 'Instellingen synchronisatie inhoud',
	'Contents sync settings has been saved.' => 'De instellingen voor synchronisatie van inhoud zijn opgeslagen.',
	'The sync settings has been copied but not saved yet.' => 'De synchronisatie instellingen zijn gekopiëerd maar nog niet opgeslagen.',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Eén of meer sjablonen staan ingesteld om dynamisch gepubliceerd te worden. Dynamisch publiceren werkt mogelijk niet op de bestemmings-server.',
	'Run synchronization now' => 'Nu synchroniseren',
	'Copy this sync setting' => 'Deze synchronisatie instelling kopiëren',
	'Sync Date' => 'Synchronisatiedatum',
	'Recipient for Notification' => 'Ontvanger van berichten',
	'Receive only error notification' => 'Enkel foutmeldingen ontvangen',
	'Destinations' => 'Bestemmingen',
	'Add destination' => 'Bestemming toevoegen',
	'Sync Type' => 'Synchronisatietype',
	'Sync type not selected' => 'Synchronisatietype niet geselecteerd',
	'FTP' => 'FTP',
	'Rsync' => 'Rsync',
	'FTP Server' => 'FTP Server',
	'Port' => 'Poort',
	'SSL' => 'SSL',
	'Enable SSL' => 'SSL inschakelen',
	'Net::FTPSSL is not available.' => 'Net::FTPSSL is niet beschikbaar',
	'Start Directory' => 'Beginmap',
	'Rsync Destination' => 'Rsync bestemming',
	'Sync Type *' => 'Synchronisatietype *',
	'Please select a sync type.' => 'Gelieve een synchronisatietype in te stellen.',
	'Are you sure you want to run synchronization?' => 'Bent u zeker dat u synchronisatie wenst uit te voeren?',
	'Sync all files' => 'Alle bestanden synchroniseren',
	'Sync name is required.' => 'Synchroniatienaam is vereist.',
	'Sync name should be shorter than [_1] characters.' => 'Synchronisatienaam moet korter dan [_1] karakters zijn.',
	'The sync date must be in the future.' => 'De synchronisatiedatum moet in de toekomst liggen.',
	'Invalid time.' => 'Ongeldig tijdstip;',
	'You must make one or more destination settings.' => 'U moet één of meer bestemmingen instellen.',
	'Are you sure you want to remove this settings?' => 'Bent u zeker dat u deze instellingen wil verwijderen?',

## addons/Sync.pack/tmpl/dialog/contents_sync_now.tmpl
	'Sync Now!' => 'Nu synchroniseren!',
	'Preparing...' => 'Voorbereiding...',
	'Synchronizing...' => 'Synchroniseren...',
	'Finish!' => 'Klaar!',
	'The synchronization was interrupted. Unable to resume.' => 'De synchronisatie werd onderbroken.  Hervatten niet mogelijk.',

## plugins/FacebookCommenters/config.yaml
	'Provides commenter registration through Facebook Connect.' => 'Voegt registratie van reageerders toe via Facebook Connect.',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Facebook Reageerders plugin instellen',
	'Authentication failure: [_1], reason:[_2]' => 'Authenticatie mislukt: [_1], reden: [_2]',
	'Failed to created commenter.' => 'Aanmaken reageerder mislukt.',
	'Failed to create a session.' => 'Aanmaken sessie mislukt.',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Facebook Commenters vereist dat ofwel Crypt::SSLeay of IO::Socket::SSL geïnstalleerd zijn om met Facebook te kunnen communiceren.',
	'Please enter your Facebook App key and secret.' => 'Gelieve uw Facebook App key en secret in te vullen.',
	'Could not verify this app with Facebook: [_1]' => 'Kon deze app niet verifiëren bij Facebook: [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook App ID' => 'Facebook applicatiesleutel',
	'The key for the Facebook application associated with your blog.' => 'De sleutel voor de Facebook-applicatie geassocieerd met uw blog.',
	'Edit Facebook App' => 'Facebook app bewerken',
	'Create Facebook App' => 'Facebook app aanmaken',
	'Facebook Application Secret' => 'Facebook applicatiegeheim',
	'The secret for the Facebook application associated with your blog.' => 'Het geheim voor de Facebook-applicatie geassocieerd met uw blog.',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Er deed zich een fout voor bij het verwerken van [_1].  De vorige versie van de feed werd gebruikt.  Een HTTP status van [_2] werd teruggezonden.',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Er deed zich een fout voor bij het verwerken van [_1].  De vorige versie van de feed was niet beschikbaar.  Een HTTP status van [_2] werd teruggezonden.',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' is een verplicht argument van [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] werd niet gebruikt in de juiste context.',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Lite maakt het mogelijk feeds te herpubliceren op uw blog.  Meer doen met feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgraden naar Feeds.App</a>.',
	'Create a Feed Widget' => 'Feedwidget aanmaken',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widgetmaker',
	'Configure feed widget settings' => 'Feedwidget instellingen configureren',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Vul een titel in voor uw widget.  Deze titel zal ook getoond worden als de titel van de feed wanneer die op uw gepubliceerde weblog verschijnt.',
	'[_1] Feed Widget' => '[_1] feedwidget',
	'Select the maximum number of entries to display.' => 'Selecteer het maximum aantal berichten om te tonen.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Alle',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => 'Er werden geen feeds gevonden worden met [_1]',
	q{An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">here</a> for more detail and please try again.} => q{Er deed zich een fout voor bij het verwerken van [_1]. Kijk dit <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">hier</a> na voor meer details en probeer opnieuw.},
	'A widget named <strong>[_1]</strong> has been created.' => 'Een widget met de naam <strong>[_1]</strong> is aangemaakt',
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> or the following MTInclude tag:} => q{U kunt nu dit widget <a href="javascript:void(0)" onclick="closeDialog('[_2]')">&ldquo;[_1]&rdquo; bewerken</a> of includeren in uw blog met behulp van <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> of volgende MTInclude tag:},
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:} => q{U kunt nu dit widget <a href="javascript:void(0)" onclick="closeDialog('[_2]')">&ldquo;[_1]&rdquo; bewerken</a> of includeren in uw weblog met behulp van volgende MTInclude tag:},
	'Create Another' => 'Maak er nog één aan',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'Meerdere feeds gevonden',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => 'Selecteer de feed die u wenst te gebruiken. <em>Feeds.App Lite ondersteunt RSS 1.0, 2.0 en Atom feeds met uitsluitend tekst.</em>',
	'URI' => 'URI',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'U moet een feed of site-URL ingeven om verder te gaan',
	'Create a widget from a feed' => 'Maak een widget van een feed',
	'Feed or Site URL' => 'URL van feed of site',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Vul de URL in van een feed, of de URL van een site met een feed..',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Standaardtekst beheren.',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'De "Standaardtekst invoegen" knop toevoegen aan TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Selecteer een standaardtekst.',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => 'Bent u zeker dat u de geselecteerde standaardtekst wenst te verwijderen?',
	'My Boilerplate' => 'Mijn standaardteksten',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'De standaardtekst \'[_1]\' wordt al gebruikt op deze site.',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => 'Standaardteksten',
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Standaardtekst \'[_1]\' wordt al gebruikt op deze blog.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Standaardtekst bewerken',
	'Create Boilerplate' => 'Standaardtekst aanmaken',
	'This boilerplate has been saved.' => 'Deze standaardtekst werd opgeslagen.',
	'Save changes to this boilerplate (s)' => 'Wijzigingen aan deze standaardtekst opslaan (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Standaardtekst '[_1]' wordt al gebruikt op deze blog.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'De standaardtekst werd verwijderd uit de database.',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Sitestatistieken plugin gebruik makend van Google Analytics',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Een Perl module vereist voor het gebruik van de Google Analytics API ontbreekt: [_1]',
	'You did not specify a client ID.' => 'U gaf geen client ID op.',
	'You did not specify a code.' => 'U gaf geen code op.',
	'The name of the profile' => 'Naam van het profiel',
	'The web property ID of the profile' => 'De web property ID van het ID',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van het token: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Er deed zich een fout voor bij het verversen van het toegangstoken: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de accounts: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van de profielen: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Er deed zich een fout voor bij het ophalen van statistiekgegevens: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'API fout',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Selecteer profiel',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2 instellingen',
	'This [_2] is using the settings of [_1].' => 'Deze [_2] gebruikt de instellingen van [_1].',
	'Other Google account' => 'Andere Google account',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Maak een Client ID voor webapplicaties aan van een OAuth2 applicatie met deze redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> vooraleer een profiel te selecteren. }, # Translate - New
	'Redirect URI of the OAuth2 application' => 'Redirect URI van de OAuth2 applicatie',
	'Client ID of the OAuth2 application' => 'Client ID van de OAuth2 applicatie',
	'Client secret of the OAuth2 application' => 'Client secret van de OAuth2 applicatie',
	'Google Analytics profile' => 'Google Analytics profiel',
	'Select Google Analytics profile' => 'Selecteer Google Analytics profiel',
	'(No profile selected)' => '(geen profiel geselecteerd)',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Client ID of client secret voor Google Analytics werd aangepast, maar profiel werd niet bijgewerkt.  Bent u zeker dat u deze instellingen wenst op te slaan?',

## plugins/Loupe/lib/Loupe/App.pm
	'Loupe settings has been successfully. You can send invitation email to users via <a href="[_1]">Loupe Plugin Settings</a>.' => 'Instellen van Loupe voltooid.  U kunt uitnodigingsmails sturen naar gebruikers via de <a href="[_1]">Loupe Plugin instellingen</a>.',
	'Error saving Loupe settings: [_1]' => 'Fout bij opslaan Loupe instellingen:',
	'Send invitation email' => 'Uitnodigingsmail sturen',
	'Could not send a invitation mail because Loupe is not enabled.' => 'Kon geen uitnodiging mailen omdat Loupe niet is ingeschakeld.',
	'Welcome to Loupe' => 'Welkom bij Loupe',

## plugins/Loupe/lib/Loupe/Mail.pm
	'Loupe invitation mail has been sent to [_3] for user \'[_1]\' (user #[_2]).' => 'Loupe uitnodiging werd gemaild naar [_3] voor gebruiker \'[_1]\' (gebruiker #[_2]).',

## plugins/Loupe/lib/Loupe.pm
	'Loupe\'s HTML file name must not be blank.' => 'Naam HTML bestand voor Loupe mag niet leeg zijn.',
	'The URL should not include any directory name: [_1]' => 'De URL mag geen mapnaam bevatten: [_1]',
	'Could not create Loupe directory: [_1]' => 'Kon Loupe map niet aanmaken: [_1]',
	'Loupe HTML file has been created: [_1]' => 'Loupe HTML bestand werd aangemaakt: [_1]',
	'Could not create Loupe HTML file: [_1]' => 'Kon Loupe HTML bestand niet aanmaken: [_1]',
	'Loupe HTML file has been deleted: [_1]' => 'Loupe HTML bestand werd verwijderd: [_1]',
	'Could not delete Loupe HTML file: [_1]' => 'Kon Loupe HTML bestand niet verwijderen: [_1]',

## plugins/Loupe/lib/Loupe/Upgrade.pm
	'Adding Loupe dashboard widget...' => 'Bezig dashboardwidget voor Loupe toe te voegen...',

## plugins/Loupe/Loupe.pl
	q{Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics.} => q{Loupe is een mobiel-vriendelijke, alternatieve console voor Movable Type waarmee gebruikers berichten en reacties kunnen modereren, foto's kunnen uploaden en website en blogstatistieken kunnen bekijken.},

## plugins/Loupe/tmpl/dialog/welcome_mail_result.tmpl
	'Send Loupe welcome email' => 'Loupe welkomstmail versturen',

## plugins/Loupe/tmpl/system_config.tmpl
	'Enable Loupe' => 'Loupe inschakelen',
	q{The URL of Loupe's HTML file.} => q{De URL van het HTML bestand van Loupe.},

## plugins/Loupe/tmpl/welcome_mail_html.tmpl
	'Your MT blog status at a glance' => 'De status van uw MT blog in een oogopslag',
	'Dear [_1], ' => 'Beste [_1]',
	'With Loupe, you can check the status of your blog without having to sign in to your Movable Type account.' => 'Met Loupe kunt u de staus van uw blog zien zonder u te moeten aanmelden met uw Movable Type account.',
	'View Access Analysis' => 'Toegangsanalyse bekijken',
	'Approve Entries' => 'Berichten goedkeuren',
	'Reply to Comments' => 'Antwoorden op reacties',
	'Loupe is best used with a smartphone (iPhone or Android 4.0 or higher)' => 'Loupe werkt best op een smartphone (iPhone of Android 4.0 of hoger)',
	'Try Loupe' => 'Probeer Loupe',
	'Perfect for Mini-tasking' => 'Perfect voor Mini-tasking',
	'_LOUPE_BRIEF' => '"Welke berichten van mij zijn het populairste op dit moment?" "Moet ik nog berichten of reacties goedkeuren?" "Ik moet dringend antwoorden op deze reactie..." Al dit soort mini-takkjes kunnen nu rechtstreeks op de smartphone gedaan worden. Loupe werd speciaal ontworpen om snel en makkelijk je blog te kunnen checken.',
	'Use Loupe to help manage your Movable Type blogs no matter where you are!' => 'Gebruik Loupe om u te helpen uw Movable Type blogs te beheren waar u ook bent',
	'Social Media' => 'Sociale Media',
	'https://twitter.com/movabletype' => 'https://twitter.com/movabletype',
	'Contact Us' => 'Contacteer ons',
	'http://www.movabletype.org/' => 'http://www.movabletype.org/',
	'http://plugins.movabletype.org' => 'http://plugins.movabletype.org',

## plugins/Loupe/tmpl/welcome_mail_plain.tmpl
	'Loupe is ready for use!' => 'Loupe is klaar voor gebruik!',

## plugins/Loupe/tmpl/widget/welcome_to_loupe.tmpl
	q{Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">See more details.</a>} => q{Loupe is een mobiel-vriendelijke alternatieve console voor Movable Type waarmee gebruikers berichten en reacties kunnen goedkeuren, foto's kunnen uploaden en website- en blogstatistieken mee kunnen bekijken. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">Meer details lezen.</a>},
	'Loupe can be used without complex configuration, you can get started immediately.' => 'Loupe kan gebruikt worden zonder complexe instellingen, u kunt onmiddelijk beginnen.',
	'Configure Loupe' => 'Loupe configureren',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Een plugin om gewone tekst naar HTML te formatteren',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown met SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Vertaalt op eenvoudige menier gewone punctuatie in 'slimme' typografische punctuatie.},

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'mixi meldde dat het aanmelden mislukte.  Probeer opnieuw.',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'Laat reageerders zich aanmelden op Movable Type met hun eigen mixi gebruikersnaam en wachtwoord via OpenID.',
	'mixi' => 'mixi',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'Er werd reeds een mixi ID geregistreerd voor deze blog.  Als u de mixi ID voor de blog wenst aan te passen, <a href="[_1]">klik dan hier</a> om u aan te melden met uw mixi account.  Als u alle mixi gebruikers toestemming wenst te geven op uw blog te reageren (en niet enkel uw eigen mixi gebruikers), klik dan op de resetknop om deze instelling te verwijderen.',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'Als u reacties wenst te beperken tot uw eigen mixi gebruikers, <a href="[_1]">klik dan hier</a> om u aan te melden met uw mixi account.',

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'MultiBlog trigger voor blog #[_1] aan het terugzetten...',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog tags mogen niet genest zijn.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Onbekende "mode" attribuutwaarde: [_1].  Geldige waarden zijn "loop" en "context".',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'Met MultiBlog kunt u inhoud van andere blogs publiceren en kunt u onderlinge publicatieregels en toegangsbeheer regelen.',
	'MultiBlog' => 'MultiBlog',
	'Create Trigger' => 'Nieuwe trigger aanmaken',
	'Search Weblogs' => 'Doorzoek weblogs',
	'When this' => 'indien dit',
	'(All blogs in this website)' => '(Alle blogs onder deze website)',
	'Select to apply this trigger to all blogs in this website.' => 'Kiezen om deze trigger toe te passen op alle blogs op deze website.',
	'(All websites and blogs in this system)' => '(Alle websites en blogs in dit systeem)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Selecteer dit om deze trigger toe te passen op alle websites en blogs in dit systeem',
	'saves an entry/page' => 'een bericht/pagina opslaat',
	'publishes an entry/page' => 'een bericht/pagina publiceert',
	'unpublishes an entry/page' => 'een bericht/pagina ontpubliceert',
	'publishes a comment' => 'een reactie publiceert',
	'publishes a TrackBack' => 'een TrackBack publiceert',
	'rebuild indexes.' => 'indexen opnieuw opbouwt.',
	'rebuild indexes and send pings.' => 'indexen opnieuw opbouwt en pings verstuurt.',
	'Updating the MultiBlog trigger cache...' => 'Bezig de trigger cache van MultiBlog bij te werken',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Wanneer',
	'Trigger' => 'Trigger',
	'Action' => 'Actie',
	'Content Privacy' => 'Privacy inhoud',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Geef aan of andere blogs op deze installatie inhoud van deze blog mogen publiceren.  Deze instelling krijgt voorrang op het standaard aggregatiebeleid op systeemniveau wat u kunt terugvinden in het configuratiescherm voor MultiBlog op systeemniveau.',
	'Use system default' => 'Standaard systeeminstelling gebruiken',
	'Allow' => 'Toestaan',
	'Disallow' => 'Verbieden',
	'MTMultiBlog tag default arguments' => 'MTMultiBlog tag standaard argumenten',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Maakt het mogelijk om de MTMultiBlog tag te gebruiken zonder include_blogs/exclude_blogs attributen.  Toegestane waarden zijn BlogID's gescheden door komma's of 'all' (enkel bij include_blogs).},
	'Include blogs' => 'Includeer blogs',
	'Exclude blogs' => 'Excludeer blogs',
	'Rebuild Triggers' => 'Rebuild-triggers',
	'Create Rebuild Trigger' => 'Rebuild-trigger aanmaken',
	'You have not defined any rebuild triggers.' => 'U heeft nog geen rebuild-triggers gedefiniëerd',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Multiblogtrigger aanmaken',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Standaard aggregatiebeleid voor het systeem',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard toegestaan zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te beperken.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard verboden zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te verlenen.',

## plugins/SmartphoneOption/config.yaml
	'Provides an iPhone, iPad and Android touch-friendly UI for Movable Type. Once enabled, navigate to your MT installation from your mobile to use this interface.' => 'Voegt een Movable Type gebruikersinterface toe geschikt voor aanraakschermen op iPhone, iPad en Android toestellen. Zodra deze plugin is ingeschakelt, navigeert u eenvoudigweg met uw mobiele toestel naar uw MT installatie om deze interface te gebruiken.',
	'iPhone' => 'iPhone',
	'iPad' => 'iPad',
	'Android' => 'Android',
	'Desktop' => 'Bureaublad',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Entry.pm
	'Re-Edit' => 'Opnieuw bewerken',
	'Re-Edit (e)' => 'Opnieuw bewerken (e)',
	'Rich Text(HTML mode)' => 'Rich Text(HTML modus)',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Listing.pm
	'All' => 'Alle',
	'Filters which you created from PC.' => 'Filters aangemaakt op de PC.',

## plugins/SmartphoneOption/lib/Smartphone/CMS.pm
	'This function is not supported by [_1].' => 'Deze functie wordt niet ondersteund door [_1].',
	'This function is not supported by your browser.' => 'Deze functie wordt niet ondersteund door uw browser.',
	'Mobile Dashboard' => 'Mobiel dashboard',
	'Rich text editor is not supported by your browser. Continue with  HTML editor ?' => 'De rich text tekstbewerker wordt niet ondersteund door uw browser.  Doorgaan met de HTML editor?',
	'Syntax highlight is not supported by your browser. Disable to continue ?' => 'Automatisch markeren syntaxis wordt niet ondersteund door uw browser.  Uitschakelen om verder te gaan?',
	'[_1] View' => '[_1] overzicht',

## plugins/SmartphoneOption/lib/Smartphone/CMS/Search.pm

## plugins/SmartphoneOption/smartphone.yaml
	'to [_1]' => 'naar [_1]',
	'Smartphone Main' => 'Smartphone Hoofd',
	'Smartphone Sub' => 'Smartphone Sub',

## plugins/SmartphoneOption/tmpl/cms/dialog/select_formatted_text.tmpl
	'No boilerplate could be found.' => 'Kon geen standaardtekst vinden.',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Resolutie van IP adres mislukt voor bron URL [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'In moderatie: IP van domein komt niet overeen met IP van ping voor bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domein IO komt niet overeen met ping IP van bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
	'No links are present in feedback' => 'Geen links aanwezig in feedback',
	'Number of links exceed junk limit ([_1])' => 'Aantal links hoger dan spamlimiet ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Aantal links hoger dan moderatielimiet ([_1])',
	'Link was previously published (comment id [_1]).' => 'Link werd eerder al gepubliceerd (reactie id [_1])',
	'Link was previously published (TrackBack id [_1]).' => 'Link werd eerder al gepubliceerd (TrackBack id [_1])',
	'E-mail was previously published (comment id [_1]).' => 'E-mail werd eerder al gepubliceerd (reactie id [_1])',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Woordfilter overeenkomst op \'[_1]\': \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Te modereren wegens woordfilter overeenkomst op \'[_1]\': \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'domein \'[_1]\' gevonden op service [_2].',
	'[_1] found on service [_2]' => '[_1] gevonden op service [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup module om zwarte lijsten te gebruiken om feedback mee te filteren.',
	'SpamLookup IP Lookup' => 'SpamLookup IP opzoeken',
	'SpamLookup Domain Lookup' => 'SpamLookup domein opzoeken',
	'SpamLookup TrackBack Origin' => 'SpamLookup TrackBack origine',
	'Despam Comments' => 'Filter spam uit reacties',
	'Despam TrackBacks' => 'Filter spam uit TrackBacks',
	'Despam' => 'Filter spam',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module om feedback als spam te merken of te modereren gebaseerd op linkfilters.',
	'SpamLookup Link Filter' => 'SpamLookup linkfilter',
	'SpamLookup Link Memory' => 'SpamLookup linkgeheugen',
	'SpamLookup Email Memory' => 'SpamLookup e-mail geheugen',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module voor het modereren en aanmerken als spam van feedback door sleutelwoord-filters',
	'SpamLookup Keyword Filter' => 'SpamLookup sleutelwoord-filter',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups houden het bron IP adres en de URL in het oog van alle binnenkomende feedback.  Als een reactie of TrackBack afkomstig is van een IP adres op de zwarte lijst of een domein bevat dat op de zwarte lijst staat, dan kan het worden tegengehouden voor moderatie of een score ontvangen als junk en in de spam-map worden geplaatst.  Bovendien kunnen geavanceerde opzoekingen gedaan worden op de brondata van een TrackBack.},
	'IP Address Lookups' => 'Opzoeken IP adressen',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback modereren van IP adressen op de zwarte lijst',
	'Junk feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst een spamscore toekennen',
	'Adjust scoring' => 'Score bijwerken',
	'Score weight:' => 'Scoregewicht',
	'Less' => 'Minder',
	'More' => 'Meer',
	'block' => 'blokkeer',
	'IP Blacklist Services' => 'IP zwarte lijst diensten',
	'Domain Name Lookups' => 'Opzoeken domeinnamen',
	'Moderate feedback containing blacklisted domains' => 'Modereer feedback die domeinen bevat die op de zwarte lijst staan',
	'Junk feedback containing blacklisted domains' => 'Ken een spamscore to aan feedback die domeinen bevat die op de zwarte lijst staan ',
	'Domain Blacklist Services' => 'Domein zwarte lijst diensten',
	'Advanced TrackBack Lookups' => 'Geavanceerde TrackBack opzoekingen',
	'Moderate TrackBacks from suspicious sources' => 'Modereer TrackBacks uit verdachte bronnen',
	'Junk TrackBacks from suspicious sources' => 'Ken een spamscore toe aan TrackBacks uit verdachte bronnen',
	'Lookup Whitelist' => 'Witte lijst voor opzoekingen',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Om te voorkomen dat bepaalde IP adressen of domeinen opgezocht worden, gelieve ze hier op te sommen, één per lijn.',

## plugins/spamlookup/tmpl/url_config.tmpl
	q{Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)} => q{Linkfilters houden het aantal hyperlinks in binnenkomende feedback in de gaten.  Feedback met veel links in kan tegengehouden worden voor moderatie of kan een spamscore krijgen.  Langs de andere kant kan feedback die geen links bevat of enkel verwijst naar eerder gepubliceerde URL's een positieve score krijgen. (Deze optie enkel inschakelen indien uw site reeds spam-vrij is).},
	'Link Limits' => 'Linklimieten',
	'Credit feedback rating when no hyperlinks are present' => 'Ken extra score toe indien geen hyperlinks aanwezig',
	'Moderate when more than' => 'Modereer indien er meer dan',
	'link(s) are given' => 'link(s) voorkomen',
	'Junk when more than' => 'Ken een spamscore toe indien er meer dan',
	'Link Memory' => 'Linkgeheugen',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Ken een positieve score toe indien het &quot;URL&quot; element in de feedback al eens eerder gepubliceerd werd',
	'Only applied when no other links are present in message of feedback.' => 'Enkel toegepast indien er geen andere links in het bericht van de feedback staan',
	q{Exclude URLs from comments published within last [_1] days.} => q{URL's uitsluiten van reacties gepubliceerd in de laastste [_1] dagen.},
	'Email Memory' => 'E-mail geheugen',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Ken een positieve score toe indien er eerder gepubliceerde reacties gevonden worden met hetzelfde e-mail adres',
	'Exclude Email addresses from comments published within last [_1] days.' => 'E-mail adressen uitsluiten van reacties gepubliceerd in de laatste [_1] dagen.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Binnenkomende feedback kan onderzocht worden op specifieke sleutelwoorden, domeinnamen en patronen.  Feedback waar deze in gevonden worden kan worden tegengehouden voor moderatie of een spamscore krijgen.  Bovendien kunnen spamscores voor overeenkomsten gepersonaliseerd worden.',
	'Keywords to Moderate' => 'Sleutelwoorden om te modereren',
	'Keywords to Junk' => 'Sleutelwoorden om een spamscore toe te kennen',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher geeft u de optie om makkelijk stijlen te bekijken en daarna toe te passen op uw blog in een paar klikken. ',
	'MT 4 Style Library' => 'MT 4 Stijlenbibliotheek',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Een verzameling stijlen compatibel met de standaardsjablonen van Movable Type 4.',
	'Styles' => 'Stijlen',
	'Moving current style to blog_meta for website...' => 'Bezig huidige stijl te verhuizen naar blog_meta voor website...',
	'Moving current style to blog_meta for blog...' => 'Bezig huidige stijl te verhuizen naar blog_meta voor blog...',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Uw mt-static map kon niet worden gevonden.  Gelieve \'StaticFilePath\' te configureren om verder te gaan.',
	'Permission Denied.' => 'Toestemming geweigerd.',
	'Successfully applied new theme selection.' => 'Nieuwe thema-selectie met succes toegepast.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'Ongeldige URL: [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Kon map [_1] niet aanmaken - Controleer of uw \'themes\' map beschrijfbaar is voor de webserver.',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'Laden van de StyleCatcher bibliotheem mislukt: [_1]',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
	'(Untitled)' => '(geen titel)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Selecteer een [_1] stijl',
	'3-Columns, Wide, Thin, Thin' => '3-kolommen, breed, smal, smal',
	'3-Columns, Thin, Wide, Thin' => '3-kolommen, smal, breed, smal',
	'3-Columns, Thin, Thin, Wide' => '3-kolommen, smal, smal, breed',
	'2-Columns, Thin, Wide' => '2-kolommen, smal, breed',
	'2-Columns, Wide, Thin' => '2-kolommen, breed, smal',
	'2-Columns, Wide, Medium' => '2-kolommen, breed, medium',
	'2-Columns, Medium, Wide' => '2-kolommen, medium, breed',
	'1-Column, Wide, Bottom' => '1 kolom, breed, onderschrift',
	'None available' => 'Geen beschikbaar',
	'Applying...' => 'Wordt toegepast...',
	'Apply Design' => 'Design toepassen',
	'Error applying theme: ' => 'Fout bij toepassen thema:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Het geselecteerde thema is toegepast, maar omdat u een andere lay-out heeft gekozen, moet u eerst uw weblog opnieuw publiceren om de nieuwe lay-out zichtbaar te maken.',
	'The selected theme has been applied!' => 'Het geselecteerde thema is toegepast',
	q{Error loading themes! -- [_1]} => q{Fout bij het laden van thema's! -- [_1]},
	'Stylesheet or Repository URL' => 'Stylesheet of bibliotheek URL',
	'Stylesheet or Repository URL:' => 'Stylesheet of bibliotheek URL:',
	'Download Styles' => 'Stijlen downloaden',
	'Current theme for your weblog' => 'Huidig thema van uw weblog',
	'Current Style' => 'Huidige stijl',
	q{Locally saved themes} => q{Lokaal opgeslagen thema's},
	'Saved Styles' => 'Opgeslagen stijlen',
	'Default Styles' => 'Standaard stijlen',
	q{Single themes from the web} => q{Losse thema's van het web},
	'More Styles' => 'Meer stijlen',
	'Selected Design' => 'Geselecteerde designs',
	'Layout' => 'Lay-out',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Een mensvriendelijke tekstgenerator',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Standaard WYSIWYG editor.',
	'TinyMCE' => 'TinyMCE',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager versie 1.1: Deze versie van de plugin dient om data van de oudere versie van Widget Manager die met Movable Type werd meegeleverd over te zetten naar de kern van Movable Type.  Er zitten geen andere opties in.  Deze plugin kan zonder problemen verwijderd worden na de installatie/upgrade van Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Opslag voor widget manager [_2] aan het verhuizen...',
	'Failed.' => 'Mislukt.',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Importeer RSS geëxporteerd uit WordPress in MT.',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => '"WP attachments downloaden via HTTP."',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Bestand is niet in WXR formaat.',
	'Creating new tag (\'[_1]\')...' => 'Nieuwe tag aan het aanmaken (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'Tag opslaan mislukt: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Dubbel mediabestand (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving asset (\'[_1]\')...' => 'Bezig met opslaan mediabestand (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' en mediabestand zal getagd worden als (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Dubbel bericht (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving page (\'[_1]\')...' => 'Pagina aan het opslaan (\'[_1]\')...',
	'Entry has no MT::Trackback object!' => 'Bericht heeft geen MT::Trackback object!',
	'Assigning permissions for new user...' => 'Permissies worden toegekend aan nieuwe gebruiker...',
	'Saving permission failed: [_1]' => 'Permissies opslaan mislukt: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{\n	Voor u WordPress berichten importeert in Movable Type, raden we aan om eerst <a href='[_1]'>de publicatiepaden van uw weblog in te stellen</a>.},
	'Upload path for this WordPress blog' => 'Uploadpad voor deze WordPress blog',
	'Replace with' => 'Vervangen door',
	'Download attachments' => 'Attachments downloaden',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Vereist het gebruik van een cronjob om attachments van een WordPress blog te downloaden op de achtergrond.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Attachments (afbeeldingen en bestanden) downloaden van de geïmporteerde WordPress blog.',

);

## New words: 194

1;
