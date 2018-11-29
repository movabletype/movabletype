# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
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
	'Category' => 'Categorie',
	'Category Yearly' => 'per categorie per jaar',
	'Category Monthly' => 'per categorie per maand',
	'Category Daily' => 'per categorie per dag',
	'Category Weekly' => 'per categorie per week',
	'CONTENTTYPE_ADV' => 'InhoudsType',
	'CONTENTTYPE-DAILY_ADV' => 'InhoudsType per dag',
	'CONTENTTYPE-WEEKLY_ADV' => 'InhoudsType per week',
	'CONTENTTYPE-MONTHLY_ADV' => 'InhoudsType per maand',
	'CONTENTTYPE-YEARLY_ADV' => 'InhoudsType per jaar',
	'CONTENTTYPE-AUTHOR_ADV' => 'InhoudsType Auteur',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'InhoudsType Auteur per jaar',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'InhoudsType Auteur per maand',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'InhoudsType Auteur per dag',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'InhoudsType Auteur per week',
	'CONTENTTYPE-CATEGORY_ADV' => 'InhoudsType Categorie',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'InhoudsType Categorie per jaar',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'InhoudsType Categorie per maand',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'InhoudsType Categorie per dag',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'InhoudsType Categorie per week',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'Archieftype niet gevonden - [_1]', # Translate - New

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Geen auteur beschikbaar',

## php/lib/block.mtauthorhasentry.php

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'U gebruikte een [_1] tag zonder een datum in context te brengen',

## php/lib/block.mtcategorysets.php
	'No Category Set could be found.' => 'Er werd geen categorieset gevonden.',
	'No Content Type could be found.' => 'Er kon geen inhoudstype worden gevonden',

## php/lib/block.mtcontentauthoruserpicasset.php
	'You used an \'[_1]\' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an \'MTContents\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een inhoudsveld; Misschien plaatste u deze per ongeluk buiten een \'MTContents\' container tag?',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found.' => 'Er werd geen inhoudsveld gevonden.',
	'No Content Field Type could be found.' => 'Er kon geen inhoudsveldtype worden gevonden.',

## php/lib/block.mtcontentfields.php

## php/lib/block.mtcontents.php

## php/lib/block.mtentries.php

## php/lib/block.mthasplugin.php
	'name is required.' => 'naam is verplicht.',

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

## php/lib/block.mttags.php
	'content_type modifier cannot be used with type "[_1]".' => 'content_type modifier kan niet gebruikt worden met type "[_1]".',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Typ de tekens die u ziet in de afbeelding hierboven.',

## php/lib/content_field_type_lib.php
	'No Label (ID:[_1])' => 'Geen Label (ID:[_1])',
	'No category_set setting in content field type.' => 'Geen category_set instelling in inhoudsveldtype.',

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

## php/lib/function.mtsetvar.php

## php/lib/function.mtsitecontentcount.php

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
	'HTML::Entities is required by CGI.pm' => 'HTML::Entities is vereist door CGI.pm',
	'DBI is required to work with most supported databases.' => 'DBI is vereist om te kunnen werken met de meeste ondersteunde databases.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist om gebruikt te kunnen maken van een MySQL database backend.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist om gebruikt te kunnen maken van een PostgreSQL database backend.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI en DBD::SQLite zijn vereist om gebruikt te kunnen maken van een SQLite database backend.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI en DBD::SQLite2 zijn vereist om gebruikt te kunnen maken van een SQLite2 database backend.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA is vereist voor geavanceerde bescherming van gebruikerswachtwoorden.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Deze module en de modules die ervan afhangen zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Deze module en de modules waar deze van afhangt zijn vereist om Movable Type te kunnen gebruiken onder psgi.',
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
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL is vereist voor alle SSL/TLS verbindingen, zoals Google Analytics site statistieken of SMTP Auth over SSL/TLS.',
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
	'_POWERED_BY' => 'Aangedreven  door<br /><a href="https://www.movabletype.org/"><$MTProductName$></a>',
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
	'1 Comment' => '1 reactie',
	'# Comments' => '# reacties',
	'No Comments' => 'Geen reacties',
	'1 TrackBack' => '1 Trackback',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Geen TrackBacks',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',
	'Comments' => 'Reacties',

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
	'Mail Footer' => 'Footer voor e-mail',

## default_templates/lockout-user.mtml
	'This email is to notify you that a Movable Type user account has been locked out.' => 'Dit is een bericht om u te melden dat een Movable Type gebruikersaccount geblokkeerd werd.',
	'Username: [_1]' => 'Gebruikersnaam: [_1]',
	'Display Name: [_1]' => 'Getoonde naam: [_1]',
	'Email: [_1]' => 'E-mail: [_1]',
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
	'_MTCOM_URL' => 'https://www.movabletype.com/',

## default_templates/recent_assets.mtml

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Er werd een aanvraag ingediend om uw Movable Type wachtwoord te veranderen.  Om dit proces af te ronden moet u op onderstaande link klikken en vervolgens een nieuw wachtwoord kiezen.',
	'If you did not request this change, you can safely ignore this email.' => 'Als u deze wijziging niet heeft aangevraagd, kunt u deze e-mail gerust negeren.',

## default_templates/search.mtml
	'Search' => 'Zoek',

## default_templates/search_results.mtml
	'Search Results' => 'Zoekresultaten',
	'Results matching &ldquo;[_1]&rdquo;' => 'Resultaten die overeenkomen met &ldquo;[_1]&rdquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Resultaten getagd als &ldquo;[_1]&rdquo;',
	'Previous' => 'Vorige',
	'Next' => 'Volgende',
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

## lib/MT/AccessToken.pm
	'AccessToken' => 'AccessToken',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Er deed zich een fout voor bij het aanmaken van de activiteitenfeed: [_1].',
	'No permissions.' => 'Geen permissies.',
	'[_1] Entries' => '[_1] berichten',
	'All Entries' => 'Alle berichten',
	'[_1] Activity' => '[_1] acties',
	'All Activity' => 'Alle acties',
	'Invalid request.' => 'Ongeldig verzoek.',
	'Movable Type System Activity' => 'Movable Type systeemactiviteit',
	'Movable Type Debug Activity' => 'Movable Type debugactiviteit',
	'[_1] Pages' => '[_1] pagina\'s',
	'All Pages' => 'Alle pagina\'s',
	'[_1] "[_2]" Content Data' => '[_1] "[_2]" inhoudsgegevens',
	'All "[_1]" Content Data' => 'Alle "[_1]" inhoudsgegevens',

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Sommige websites werden niet verwijderd.  U moet de blogs onder de website eerst verwijderen.',

## lib/MT/App/CMS.pm
	'[_1]\'s Group' => 'Groep van [_1]',
	'Invalid request' => 'Ongeldig verzoek',
	'Add a user to this [_1]' => 'Gebruiker toevoegen aan deze [_1]',
	'Are you sure you want to reset the activity log?' => 'Bent u zeker dat u het activiteitenlog wil leegmaken?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'U staat op het punt e-mails te versturen waarmee de geselecteerde gebruikers hun wachtwoord kunnen aanpassen. Bent u zeker?',
	'_WARNING_DELETE_USER_EUM' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker tot \'wees\' maakt.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies verwijderen.  Bent u zeker dat u deze gebruiker(s) wenst te verwijderen?\nGebruikers die nog bestaan in de externe directory zullen zichzelf weer kunnen aanmaken.',
	'_WARNING_DELETE_USER' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen alternatief al zijn permissies te verwijderen.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Deze actie zal de sjablonen van de geselecteerde blog(s) terugzetten naar de fabrieksinstellingen. Bent u zeker dat u de sjabonen van de geselecteerde blog(s) wenst te verversen?',
	'Are you sure you want to delete the selected group(s)?' => 'Bent u zeker dat u de geselecteerde groep(en) wenst te verwijderen?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Bent u zeker dat u de geselecteerde leden of het geselcteerde lid wenst te verwijderen uit de groep?',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'Groups ([_1])' => 'Groepen ([_1])',
	'Failed login attempt by user who does not have sign in permission. \'[_1]\' (ID:[_2])' => 'Mislukte aanmeldpoging van gebruiker die geen toestemming heeft om aan te melden. \'[_1]\' (ID:[_2])',
	'Invalid login.' => 'Ongeldige aanmeldgegevens.',
	'Cannot load blog (ID:[_1])' => 'Kan blog niet laden (ID:[_1])',
	'No such blog [_1]' => 'Geen blog [_1]',
	'Invalid parameter' => 'Ongeldige parameter',
	'Edit Template' => 'Sjabloon bewerken',
	'Back' => 'Terug',
	'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
	'entry' => 'bericht',
	'content data' => 'inhoudsgegevens',
	'None' => 'Geen',
	'Error during publishing: [_1]' => 'Fout tijdens publiceren: [_1]',
	'Movable Type News' => 'Movable Type-nieuws',
	'Notification Dashboard' => 'Meldingendashboard',
	'Site Stats' => 'Sitestatistieken',
	'Updates' => 'Updates',
	'Activity Log' => 'Activiteitenlog',
	'Site List' => 'Lijst websites',
	'Site List for Mobile' => 'Lijst websites voor mobiel gebruik', # Translate - New
	'Refresh Templates' => 'Sjablonen verversen',
	'Use Publishing Profile' => 'Publicatieprofiel gebruiken',
	'Create Role' => 'Rol aanmaken',
	'Grant Permission' => 'Permissie toekennen',
	'Clear Activity Log' => 'Activiteitenlog leegmaken',
	'Download Log (CSV)' => 'Log downloaden (CSV)',
	'Add IP Address' => 'IP Adres toevoegen',
	'Add Contact' => 'Contact toevoegen',
	'Download Address Book (CSV)' => 'Adresboek downloaden (CSV)',
	'Add user to group' => 'Gebruiker toevoegen aan een groep',
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
	'Recover Password(s)' => 'Wachtwoord(en) terugvinden',
	'Enable' => 'Inschakelen',
	'Disable' => 'Uitschakelen',
	'Unlock' => 'Deblokkeer',
	'Remove' => 'Verwijder',
	'Refresh Template(s)' => 'Sjablo(o)n(en) verversen',
	'Move child site(s) ' => 'Verplaats deelsite(s)',
	'Clone Child Site' => 'Kloon deelsite',
	'Publish Template(s)' => 'Sjablo(o)n(en) publiceren',
	'Clone Template(s)' => 'Sjablo(o)n(en) klonen',
	'Revoke Permission' => 'Permissie intrekken',
	'Rebuild' => 'Herpubliceren',
	'View Site' => 'Site bekijken',
	'Profile' => 'Profiel',
	'Documentation' => 'Documentatie',
	'Sign out' => 'Afmelden',
	'Sites' => 'Sites',
	'Content Data' => 'Inhoudsgegevens',
	'Entries' => 'Berichten',
	'Pages' => 'Pagina\'s',
	'Category Sets' => 'Categoriesets',
	'Assets' => 'Mediabestanden',
	'Content Types' => 'Inhoudstypes',
	'Groups' => 'Groepen',
	'Feedbacks' => 'Reacties',
	'Roles' => 'Rollen',
	'Design' => 'Design',
	'Filters' => 'Filters',
	'Settings' => 'Instellingen',
	'Tools' => 'Gereedschappen',
	'Manage' => 'Beheren',
	'New' => 'Nieuw',
	'Manage Members' => 'Leden beheren',
	'Associations' => 'Associaties',
	'Import' => 'Import',
	'Export' => 'Export',
	'Folders' => 'Mappen',
	'Upload' => 'Opladen',
	'Themes' => 'Thema\'s',
	'General' => 'Algemeen',
	'Compose' => 'Opstellen',
	'Feedback' => 'Feedback',
	'Web Services' => 'Webservices',
	'Plugins' => 'Plugins',
	'Rebuild Trigger' => 'Herpublicatievoorwaarde',
	'IP Banning' => 'IP Blokkering',
	'User' => 'Gebruiker',
	'Search & Replace' => 'Zoeken & vervangen',
	'Import Sites' => 'Sites importeren',
	'Export Sites' => 'Sites exporteren',
	'Export Site' => 'Site exporteren',
	'Export Theme' => 'Thema exporteren',
	'Address Book' => 'Adresboek',
	'Asset' => 'Mediabestand',
	'Website' => 'Website',
	'Blog' => 'Blog',
	'Permissions' => 'Permissies',

## lib/MT/App.pm
	'Problem with this request: corrupt character data for character set [_1]' => 'ï¾ƒã�¤ï½¨Probleem met dit verzoek: corrupte karakterdata voor karakterset [_1]',
	'Cannot load blog #[_1]' => 'Kan blog niet laden #[_1]',
	'Internal Error: Login user is not initialized.' => 'Interne fout: login gebruiker is niet geïnitialiseerd.',
	'The login could not be confirmed because of a database error ([_1])' => 'Aanmelding kon niet worden bevestigd wegens een databasefout ([_1])',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Het spijt ons, maar u heeft geen toestemming om toegang te krijgen op blogs of websites van deze installatie.  Als u meent dat dit een fout is, gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'Cannot load blog #[_1].' => 'Kan blog niet laden #[_1].',
	'Failed login attempt by unknown user \'[_1]\'' => 'Mislukte aanmeldpoging door onbekende gebruiker \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Mislukte aanmeldpoding door gedeactiveerde gebruiker \'[_1]\'',
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
	'Passwords do not match.' => 'Wachtwoorden komen niet overeen',
	'URL is invalid.' => 'URL is ongeldig',
	'User requires display name.' => 'Gebruiker heeft getoonde naam nodig.',
	'[_1] contains an invalid character: [_2]' => '[_1] bevat een ongeldig karakter: [_2]',
	'Display Name' => 'Getoonde naam',
	'Email Address is invalid.' => 'Email adres is ongeldig',
	'Email Address' => 'Email adres',
	'Email Address is required for password reset.' => 'Email adres is vereist om wachtwoord opnieuw te kunnen instellen',
	'User requires username.' => 'Gebruiker heeft gebruikersnaam nodig.',
	'Username' => 'Gebruikersnaam',
	'A user with the same name already exists.' => 'Er bestaat al een gebruiker met die naam.',
	'Text entered was wrong.  Try again.' => 'Ingevulde tekst was fout.  Probeer opnieuw.',
	'An error occurred while trying to process signup: [_1]' => 'Er deed zich een fout voor bij het verwerken van de registratie: [_1]',
	'New Comment Added to \'[_1]\'' => 'Nieuwe reactie achtergelaten op \'[_1]\'',
	'System Email Address is not configured.' => 'Systeem e-mail adres is niet ingesteld.',
	'Unknown error occurred.' => 'Er deed zich een onbekende fout voor.',
	'Close' => 'Sluiten',
	'Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive \'[_1]\': [_2]' => 'Openen monitoringbestand aangegeven via de IISFastCGIMonitoringFilePath directief mislukt \'[_1]\': [_2]',
	'Failed to open pid file [_1]: [_2]' => 'Openen pid bestand mislukt [_1]: [_2]',
	'Failed to send reboot signal: [_1]' => 'Sturen van reboot signaal mislukt: [_1]',
	'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
	'Unknown action [_1]' => 'Onbekende actie [_1]',
	'Warnings and Log Messages' => 'Waarschuwingen en logberichten',
	'Removed [_1].' => '[_1] verwijderd.',
	'Cannot load entry #[_1].' => 'Kan bericht niet laden #[_1].',
	'You did not have permission for this action.' => 'U had geen permissie voor deze actie',

## lib/MT/App/Search/ContentData.pm
	'Invalid archive type' => 'Ongelidg archieftype',
	'Invalid value: [_1]' => 'Ongeldige waarde: [_1]',
	'Invalid query: [_1]' => 'Ongeldige zoekopdracht: [_1]',
	'Invalid SearchContentTypes "[_1]": [_2]' => 'Ongeldige SearchContentTypes "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'Ongeldig SearchContentTypes: [_1]',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Ongeldig type: [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Cachen van zoekresultaten mislukt.  [_1] is niet beschikbaar: [_2]',
	'Invalid format: [_1]' => 'Ongeldig formaat: [_1]',
	'Unsupported type: [_1]' => 'Niet ondersteund type: [_1]',
	'No column was specified to search for [_1].' => 'Geen kolom opgegeven om op te zoeken [_1].',
	'Search: query for \'[_1]\'' => 'Zoeken: zoekopdracht voor \'[_1]\'',
	'No alternate template is specified for template \'[_1]\'' => 'Geen alternatief sjabloon opgegeven voor sjabloon \'[_1]\'',
	'Opening local file \'[_1]\' failed: [_2]' => 'Lokaal bestand \'[_1]\' openen mislukt: [_2]',
	'No such template' => 'Geen sjabloon gevonden',
	'template_id cannot refer to a global template' => 'template_id mag niet verwijzen naar een globaal sjabloon',
	'Output file cannot be of the type asp or php' => 'Uitvoerbestand mag niet van het type asp of php zijn',
	'You must pass a valid archive_type with the template_id' => 'U moet een geldig archieftype doorgeven via het template_id',
	'Template must be archive listing for non-Index archive types' => 'Sjabloon moet archiefoverzicht zijn voor niet-index archieftypes',
	'Filename extension cannot be asp or php for these archives' => 'Bestandsnaamextensie mag niet asp of php zijn voor deze archieven',
	'Template must be a main_index for Index archive type' => 'Sjabloon moet een main_index zijn voor het Index archieftype',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'De zoekopdracht die u uitvoerde is over de tijdslimiet gegaan.  Gelieve uw zoekopdracht te vereenvoudigen en opnieuw te proberen.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch werkt met MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Kon niet aanmelden met de opgegeven gegevens: [_1].',
	'Both passwords must match.' => 'Beide wachtwoorden moeten overeen komen.',
	'You must supply a password.' => 'U moet een wachtwoord opgeven.',
	'Invalid email address \'[_1]\'' => 'Ongeldig email adres \'[_1]\'',
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
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Deze module is vereist als u de MT XML-RPC server implementatie wenst te gebruiken.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Deze module is vereist als u bestaande bestanden wenst te kunnen overschrijven bij het opladen.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Deze module is vereist als u graag thumbnailveries van opgeladen bestanden wenst te kunnen aanmaken.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Deze module is vereist als u NetPBM wenst te gebruiken als driver voor afbeeldingen met MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Deze module is vereist door bepaalde MT plugins beschikbaar bij derden.',
	'This module accelerates comment registration sign-ins.' => 'Deze module versnelt aanmeldingen om te kunnen reageren.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File is vereist als u reageerders wenst te laten aanmelden via Yahoo! Japan met OpenID.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Deze module is vereist om registratie van reageerders in te schakelen.  Ook vereist om mail te versturen via een SMTP server.',
	'This module enables the use of the Atom API.' => 'Deze module maakt het mogelijk de Atom API te gebruiken.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Deze module is vereist om memcached te kunnen gebruiken als cachemechanisme voor Movable Type',
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
	'DAILY_ADV' => 'per dag',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/dd/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'MONTHLY_ADV' => 'per maand',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'yyyy/mm/content-basename.html' => 'jjjj/mm/basisnaam-inhoud.html',
	'yyyy/mm/content_basename.html' => 'jjjj/mm/basisnaam_inhoud.html',
	'yyyy/mm/content-basename/index.html' => 'jjjj/mm/basisnaam-inhoud/index.html',
	'yyyy/mm/content_basename/index.html' => 'jjjj/mm/basisnaam_inhoud/index.html',
	'yyyy/mm/dd/content-basename.html' => 'jjjj/mm/dd/basisnaam-inhoud.html',
	'yyyy/mm/dd/content_basename.html' => 'jjjj/mm/dd/basisnaam_inhoud.html',
	'yyyy/mm/dd/content-basename/index.html' => 'jjjj/mm/basisnaam-inhoud/index.html',
	'yyyy/mm/dd/content_basename/index.html' => 'jjjj/mm/basisnaam_inhoud/index.html',
	'author/author-basename/content-basename/index.html' => 'auteur/auteur-basisnaam/inhoud-basisnaam/index.html',
	'author/author_basename/content_basename/index.html' => 'auteur/auteur_basisnaam/inhoud_basisnaam/index.html',
	'author/author-basename/content-basename.html' => 'auteur/auteur-basisnaam/inhoud-basisnaam.html',
	'author/author_basename/content_basename.html' => 'auteur/auteur_basisnaam/inhoud_basisnaam.html',
	'category/sub-category/content-basename.html' => 'categorie/sub-categorie/basisnaam-inhoud.html',
	'category/sub-category/content-basename/index.html' => 'categorie/sub-categorie/basisnaam-inhoud/index.html',
	'category/sub_category/content_basename.html' => 'categorie/sub_categorie/basisnaam_inhoud.html',
	'category/sub_category/content_basename/index.html' => 'categorie/sub_categorie/basisnaam_inhoud/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'WEEKLY_ADV' => 'per week',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/dag-week/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'YEARLY_ADV' => 'per jaar',
	'yyyy/index.html' => 'jjjj/index.html',

## lib/MT/ArchiveType/Daily.pm

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

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'per pagina',
	'folder-path/page-basename.html' => 'map-pad/basisnaam-pagina.html',
	'folder-path/page-basename/index.html' => 'map-pad/basisnaam-pagina/index.html',
	'folder_path/page_basename.html' => 'map_pad/basisnaam_pagina.html',
	'folder_path/page_basename/index.html' => 'map_pad/basisnaam_pagina/index.html',

## lib/MT/ArchiveType/Weekly.pm

## lib/MT/ArchiveType/Yearly.pm

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
	'Assets in [_1] field of [_2] \'[_4]\' (ID:[_3])' => 'Mediabestanden in [_1] veld van [_2] \'[_4]\' (ID:[_3])',
	'No Label' => 'Geen label',
	'Content Field ( id: [_1] ) does not exists.' => 'Inhoudsveld ( id: [_1] ) bestaat niet.',
	'Content Data ( id: [_1] ) does not exists.' => 'Inhoudsgegevens ( id: [_1] ) bestaat niet.',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'Inhoudstype van inhoudsgegevens ( id: [_1] ) bestaat niet.',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Kon mediabestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Description' => 'Beschrijving',
	'Name' => 'Naam',
	'URL' => 'URL',
	'Location' => 'Locatie',
	'Could not create asset cache path: [_1]' => 'Kon cachepad voor mediabestand niet aanmaken [_1]',
	'string(255)' => 'string(255)',
	'Label' => 'Naam',
	'Type' => 'Type',
	'Filename' => 'Bestandsnaam',
	'File Extension' => 'Bestandsextensie',
	'Pixel Width' => 'Breedte in pixels',
	'Pixel Height' => 'Hoogte in pixels',
	'Except Userpic' => 'Uitgezonderd gebruikersafbeelding',
	'Author Status' => 'Status auteur',
	'Missing File' => 'Ontbrekend bestand',
	'Content Field' => 'Inhoudsveld',
	'Assets of this website' => 'Mediabestanden van deze website',

## lib/MT/Asset/Video.pm
	'Videos' => 'Video\'s',

## lib/MT/Association.pm
	'Association' => 'Associatie',
	'Permissions of group: [_1]' => 'Permissies van groep: [_1]',
	'Group' => 'Groep',
	'Permissions with role: [_1]' => 'Permissies met rol: [_1]',
	'User is [_1]' => 'Gebruiker is [_1]',
	'Permissions for [_1]' => 'Permissies voor [_1]',
	'association' => 'associatie',
	'associations' => 'associaties',
	'User/Group' => 'Gebruiker/groep',
	'User/Group Name' => 'Naam gebruiker/groep',
	'Role' => 'Rol',
	'Role Name' => 'Naam rol',
	'Role Detail' => 'Details rol',
	'Site Name' => 'Sitenaam',
	'Permissions for Users' => 'Permissies voor gebruikers',
	'Permissions for Groups' => 'Permissies voor groepen',

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
	'Failed to verify the current password.' => 'Verificatie van het huidige wachtwoord mislukt.',
	'Password contains invalid character.' => 'Wachtwoord bevat ongeldig karakter.',
	'Missing required module' => 'Vereiste module ontbreekt',

## lib/MT/Author.pm
	'Users' => 'Gebruikers',
	'Active' => 'Actief',
	'Pending' => 'In afwachting',
	'Not Locked Out' => 'Niet geblokkeerd',
	'Locked Out' => 'Geblokkeerd',
	'MT Users' => 'MT gebruikers',
	'Commenters' => 'Reageerders',
	'Registered User' => 'Geregistreerde gebruiker',
	'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden opgeslagen: [_1]',
	'Userpic' => 'Foto gebruiker',
	'User Info' => 'Gebruikersinformatie',
	'__ENTRY_COUNT' => 'Berichten',
	'Content Data Count' => 'Aantal inhoudsgegevens',
	'Created by' => 'Aangemaakt door',
	'Status' => 'Status',
	'Website URL' => 'URL website',
	'Privilege' => 'Privilege',
	'Lockout' => 'Blokkering',
	'Enabled Users' => 'Ingeschakelde gebruikers',
	'Disabled Users' => 'Uitgeschakelde gebruikers',
	'Pending Users' => 'Te keuren gebruikers',
	'Locked out Users' => 'Geblokkeerde gebruikers',
	'MT Native Users' => 'Lokale MT gebruikers',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Foute AuthenticationModule configuratie \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Foute AuthenticationModule configuratie',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'Het bestand dat werd geupload was geen geldig Movable Type manifest exportbestand.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'Het export manifestbestand dat werd geupload werd aangemaakt met Movable Type maar de schemaversie ([_1]) verschilt van die gebruikt op dit systeem ([_2]). Dit exportbestand is niet geschikt voor deze versie van Movable Type.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] is geen onderwerp om te importeren in Movable Type.',
	'[_1] records imported.' => '[_1] records geïmporteerd',
	'Importing [_1] records:' => 'Bezig [_1] records te importeren:',
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Een gebruiker met dezelfde naam als de huidige gebruiker ([_1]) werd gevonden in het exportbestand.  Deze gebruiker wordt overgeslagen.',
	'A user with the same name \'[_1]\' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.' => 'Een gebruiker met dezelfde naam \'[_1]\' werd gevonden in het exportbestand (ID:[_2]).  Tijdens het importeren werd deze gebruiker overschreven met de gegevens uit het importbestand.',
	'Invalid serializer version was specified.' => 'Ongeldige serialisatieverie opgegeven.',
	'Tag \'[_1]\' exists in the system.' => 'Tag \'[_1]\' bestaat in het systeem.',
	'[_1] records imported...' => '[_1] records geïmporteerd...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'De rol \'[_1]\' werd hernoemd naar \'[_2]\' omdat een rol met die naam al bestond.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => 'De instellingen op systeemniveau voor plugin \'[_1]\' bestaan al.  Record wordt overgeslagen.',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Kan het gevraagde bestand niet importeren omdat hiervoor de Digest::SHA Perl module vereist is.  Contacteer uw Movable Type systeembeheerder.',
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'Kan het gevraagde bestand niet importeren omdat er geen site werd gevonden in het bestaande Movable Type systeem of in de exportgegevens.  Er moet eerst een site aangemaakt worden.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "Kan bestand niet schrijven.  Schijf vol.",
	'Exporting [_1] records:' => 'Bezig [_1] records te exporteren:',
	'[_1] records exported...' => '[_1] recordt geëxporteerd...',
	'[_1] records exported.' => '[_1] records geëxporteerd.',
	'There were no [_1] records to be exported.' => 'Er waren geen [_1] records om te exporteren.',
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
	'Importing asset associations ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren...',
	'Importing asset associations in entry ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren voor bericht... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'Bezig mediabestandsassociaties te importeren voor pagina... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'Bezig inhoudsgegevens te importeren... ( [_1] )',
	'Rebuilding permissions ... ( [_1] )' => 'Bezig permissies opnieuw op te bouwen ... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'Bezig url van de mediabestanden te importeren ( [_1] )...',
	'Importing url of the assets in entry ( [_1] )...' => 'Bezig de mediabestanden te importeren in bericht ( [_1] )...',
	'Importing url of the assets in page ( [_1] )...' => 'Bezig de mediabestanden te importeren in pagina ( [_1] )...',
	'ID for the file was not set.' => 'ID van het bestand was niet ingesteld.',
	'The file ([_1]) was not imported.' => 'Het bestand ([_]) werd niet geïmporteerd.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Pad voor bestand \'[_1]\' (ID:[_2]) wordt aangepast...',
	'failed' => 'mislukt',
	'ok' => 'ok',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Blog.pm
	'Child Site' => 'Subsite',
	'Child Sites' => 'Subsites',
	'*Site/Child Site deleted*' => 'Site/subsite verwijderd',
	'First Blog' => 'Eerste weblog',
	'No default templates were found.' => 'Er werden geen standaardsjablonen gevonden.',
	'archive_type is needed in Archive Mapping \'[_1]\'' => 'archive_type vereist in archiefmapping \'[_|]\'',
	'Invalid archive_type \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ongeldig archive_type \'[_1]\' in archiefmapping \'[_2]\'',
	'Invalid datetime_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ongeldig datetime_veld \'[_1]\' in archiefmapping \'[_2]\'',
	'Invalid category_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'Ongeldig category_field \'[_1]\' in archiefmapping \'[_2]\'',
	'category_field is required in Archive Mapping \'[_1]\'' => 'category_field is vereist in archiefmapping \'[_1]\'',
	'Clone of [_1]' => 'Kloon van [_1]',
	'Cloned child site... new id is [_1].' => 'Subsite gekloond... nieuw id is [_1]',
	'Cloning permissions for blog:' => 'Permissies worden gekloond voor blog:',
	'[_1] records processed...' => '[_1] items verwerkt...',
	'[_1] records processed.' => '[_1] items verwerkt.',
	'Cloning associations for blog:' => 'Associaties worden gekloond voor blog:',
	'Cloning entries and pages for blog...' => 'Berichten en pagina\'s worden gekloond voor blog...',
	'Cloning categories for blog...' => 'Categorieën worden gekloond voor blog...',
	'Cloning entry placements for blog...' => 'Berichtcategorieën wordt gekloond voor blog...',
	'Cloning entry tags for blog...' => 'Berichttags worden gekloond voor blog...',
	'Cloning templates for blog...' => 'Sjablonen worden gekloond voor blog...',
	'Cloning template maps for blog...' => 'Sjabloonkoppelingen worden gekloond voor blog...',
	'Failed to load theme [_1]: [_2]' => 'Laden van thema [_1] mislukt: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Toepassen van thema [_1] mislukt: [_2]',
	'__PAGE_COUNT' => 'Pagina\'s',
	'__ASSET_COUNT' => 'Mediabestanden',
	'Content Type' => 'Inhoudstype',
	'Content Type Count' => 'Aantal inhoudstypes',
	'Parent Site' => 'Hoofdsite',
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

## lib/MT/CategorySet.pm
	'Category Set' => 'Categorieset',
	'name "[_1]" is already used.' => 'naam "[_1]" is reeds gebruikt.',
	'Category Count' => 'Aantal categorieën',
	'Category Label' => 'Categorielabel',
	'Content Type Name' => 'Naam inhoudstype',

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
	'Upload Asset' => 'Mediabestand uploaden',
	'Invalid Request.' => 'Ongeldig verzoek.',
	'Permission denied.' => 'Toestemming geweigerd.',
	'File with name \'[_1]\' already exists. Upload has been cancelled.' => 'Bestand met de naam \'[_1]\' bestaat al. Upload geannuleerd.',
	'Cannot load file #[_1].' => 'Kan bestand niet laden #[_1].',
	'No permissions' => 'Geen permissies',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Bestand \'[_1]\' opgeladen door \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bestand \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Untitled' => 'Zonder titel',
	'Site' => 'Site',
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

## lib/MT/CMS/Blog.pm
	q{Cloning child site '[_1]'...} => q{Bezig subsite '[_1]' te klonen...},
	'Error' => 'Fout',
	'Finished!' => 'Klaar!',
	'General Settings' => 'Algemene instellingen',
	'Compose Settings' => 'Instellingen voor opstellen',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Deze instellingen worden overroepen door een instelling het het MT configuratiebestand: [_1].  Verwijder de waarde uit het configuratiebestand om deze hier te kunnen beheren.',
	'Feedback Settings' => 'Feedback instellingen',
	'Plugin Settings' => 'Instellingen plugins',
	'Registration Settings' => 'Registratie-instellingen',
	'Create Child Site' => 'Subsite aanmaken',
	'Cannot load template #[_1].' => 'Kan sjabloon #[_1] niet laden.',
	'Cannot load content data #[_1].' => 'Kon inhoudsgegevens niet laden #[_1].',
	'index template \'[_1]\'' => 'indexsjabloon \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'(no name)' => '(geen naam)',
	'Publish Site' => 'Site publiceren',
	'Select Child Site' => 'Selecteer subsite',
	'Selected Child Site' => 'Geselecteerde subsite',
	'Enter a site name to filter the choices below.' => 'Vul de naam van een site in om de keuzes hieronder te filteren.',
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
	'\'[_1]\' (ID:[_2]) has been copied as \'[_3]\' (ID:[_4]) by \'[_5]\' (ID:[_6]).' => '\'[_1]\' (ID:[_2]) werd gekopiëerd als \'[_3]\' (ID:[_4]) door \'[_5]\' (ID:[_6]).',

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => 'De [_1] moet nog een naam krijgen!',
	'Invalid category_set_id: [_1]' => 'Ongeldige category_set_id: [_1]',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Kon [_1] niet bijwerken: Sommige [_2] werden gewijzigd sinds u deze pagina opende.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Probeerde [_1]([_2]) bij te werken, maar het object werd niet gevonden.',
	'[_1] order has been edited by \'[_2]\'.' => '_1] volgorde werd aangepast door \'[_2]\'.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Uw wijzigingen werden aangebracht ([_1] toegevoegd, [_2] aangepast en [_3] verwijderd). <a href="#" onclick="[_4]" class="mt-rebuild">Publiceer uw site</a> om deze wijzigingen zichtbaar te maken.',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met de naam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Categoriebasisnaam \'[_1]\' conflicteert met de basisnaam van een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke basisnaam hebben.',
	'The name \'[_1]\' is too long!' => 'De naam \'[_1]\' is te lang!',
	'Category \'[_1]\' created by \'[_2]\'.' => 'Categorie \'[_1]\' aangemaakt door \'[_2]\'.',
	'Category \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) bewerkt door \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.',
	'Edit [_1]' => '[_1] bewerken',
	'Create [_1]' => '[_1] aanmaken',
	'Manage [_1]' => '[_1] beheren',
	'Create Category Set' => 'Categoriesete aanmaken',

## lib/MT/CMS/CategorySet.pm

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
	'Web Services Settings' => 'Instellingen webservices',
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
	'Permission denied: [_1]' => 'Toestemming geweigerd: [_1]',
	'Saving snapshot failed: [_1]' => 'Snapshot opslaan mislukt: [_1]',

## lib/MT/CMS/ContentData.pm
	'Cannot load content field (UniqueID:[_1]).' => 'Kan inhoudsveld niet laden (UniqueID:[_1])',
	'The value of [_1] is automatically used as a data label.' => 'De waarde van [_1] wordt automatisch gebruikt als datalabel.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is nog geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren voor deze zijn ingesteld.',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; \'Gepubliceerd op\' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be dates in the future.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten in de toekomst liggen.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be later than the corresponding \'Published on\' date.' => 'Ongeldige datum \'[_1]\'; \'Publicatie ongedaan op\' datums moeten later zijn dan de corresponderende \'Gepubliceerd op\' datum.',
	'Cannot load content_type #[_1]' => 'Kan content_type #[_1] niet laden',
	'New [_1] \'[_4]\' (ID:[_2]) added by user \'[_3]\'' => 'Nieuwe [_1] \'[_4]\' (ID:[_2]) toegevoegd door gebruiker \'[_3]\'',
	'[_1] \'[_5]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => '[_1] \'[_5]\' (ID:[_2]) bewerkt en status aangepast van [_3] naar [_4] door gebruiker \'[_5]\'',
	'[_1] \'[_4]\' (ID:[_2]) edited by user \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) bewerkt door gebruiker \'[_3]\'',
	'[_1] \'[_4]\' (ID:[_2]) deleted by \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Create new [_1]' => 'Nieuwe [_1] aanmaken',
	'Cannot load template.' => 'Kan sjabloon niet laden.',
	'Publish error: [_1]' => 'Publicatiefout: [_1]',
	'Unable to create preview files in this location: [_1]' => 'Kan geen voorbeeldbestanden aanmaken in deze locatie: [_1]',
	'(untitled)' => '(zonder titel)',
	'New [_1]' => 'Nieuwe [_1]',
	'Need a status to update content data' => 'Status vereist om inhoudsgegevens bij te werken',
	'Need content data to update status' => 'Inhoudsgegevens vereist om status bij te werken',
	'One of the content data ([_1]) did not exist' => 'Bepaalde inhoudsgegevens ([_1]) bestonden nog niet',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => '[_1] (ID:[_2]) status aangepast van [_3] naar [_4]',
	'(No Label)' => '(Geen label)',
	'Unpublish Contents' => 'Publicatie inhoud ongedaan maken',

## lib/MT/CMS/ContentType.pm
	'Create Content Type' => 'Inhoudstype aanmaken',
	'Cannot load content type #[_1]' => 'Kan inhoudstype niet laden #[_1]',
	'The content type name is required.' => 'Naam vereist voor inhoudstype',
	'The content type name must be shorter than 255 characters.' => 'De naam voor het inhoudstype moet korter zijn dan 255 karakters.',
	'Name \'[_1]\' is already used.' => 'Naam \'[_1]\' is reeds in gebruik.',
	'Cannot load content field data (ID: [_1])' => 'Kan gegevens inhoudsveld niet laden (ID: [_1])',
	'Saving content field failed: [_1]' => 'Inhoudsveld opslaan mislukt: [_1]',
	'Saving content type failed: [_1]' => 'Inhoudstype opslaan mislukt: [_1]',
	'A label for content field of \'[_1]\' is required.' => 'Een label is vereist voor inhoudsveld van \'[_1]\'.',
	'A label for content field of \'[_1]\' should be shorter than 255 characters.' => 'Een label voor inhoudsveld van \'[_1]\' moet korter zijn dan 255 karakters.',
	'A description for content field of \'[_1]\' should be shorter than 255 characters.' => 'Een beschrijving voor inhoudsvel van \'[_1]\' moet korter zijn dan 255 karakters.',
	'*User deleted*' => '*Gebruiker verwijderd*',
	'Content Type Boilerplates' => 'Standaardteksten inhoudstypes',
	'Manage Content Type Boilerplates' => 'Standaardteksten inhoudstypes beheren',
	'Content Type \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Inhoudstype \'[_1]\' (ID:[_2]) toegevoegd door gebruiker \'[_3]\'',
	'A content field \'[_1]\' ([_2]) was added' => 'Een inhoudsveld \'[_1]\' ([_2]) werd toegevoegd',
	'A content field options of \'[_1]\' ([_2]) was changed' => 'Opties van inhoudsveld \'[_1]\' ([_2]) werden angepast',
	'Some content fields were deleted: ([_1])' => 'Een aantal inhoudsvelden werden verwijderd: ([_1])',
	'Content Type \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Inhoudstype \'[_1]\' (ID:[_2]) bewerkt door gebruiker \'[_3]\'',
	'Content Type \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Inhoudstype \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Create new content type' => 'Nieuw inhoudstype aanmaken',

## lib/MT/CMS/Dashboard.pm
	'Error: This child site does not have a parent site.' => 'Fout: deze subsite heeft geen hoofdsite.',
	'Not configured' => 'Niet geconfigureerd',
	'Please contact your Movable Type system administrator.' => 'Neem contact op met uw Movable Type syteembeheerder.',
	'The support directory is not writable.' => 'Support map is niet beschrijfbaar',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type was niet in staat om te schrijven in de \'support\' map.  Gelieve een map aan te maken in deze locatie: [_1] en er genoeg permissies aan toe te kennen zodat de webserver er in kan schrijven.',
	'ImageDriver is not configured.' => 'ImageDriver is niet geconfigureerd',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Een toolkit om afbeeldingen te bewerken, iets wat meestal via de ImageDriver configuratie-directief wordt ingesteld, is niet aanwezig op uw server of verkeerd geconfigureerd.  Zo\'n toolkit is nodig om gebruikersafbeeldingen te kunnen herschalen e.d.  Gelieve Image::Magick, NetPBM, GD, of Imager te installeren op de server en stel dan de ImageDriver directief overeenkomstig in.',
	'The System Email Address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>' => 'Het systeem email adres wordt gebruikt in de \'From:\' header van elke mail verzonden door Movable Type.  Mails kunnen verstuurd worden om wachtwoorden terug te vinden, reageerders te registreren, te informeren over nieuwe reacties of trackbacks, in geval van het blokkeren van een gebruiker of IP en in een paar andere gevallen.  Gelieve uw <a href="[_1]">instellingen</a> te bevestigen.',
	'Cannot verify SSL certificate.' => 'Kan SSL certificaat niet verifiëren.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Gelieve de Mozilla::CA module te installeren.  De regel "SSLVerifyNone 1" aan mt-config.cgi toevoegen kan deze waarschuwing verbergen maar wordt niet aangeraden',
	'Can verify SSL certificate, but verification is disabled.' => 'Kan SSL certificaat controleren maar verificatie is uitgeschakeld.',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'U verwijdert best de regel "SSLVerifyNone 1" uit mt-config.cgi.',
	'System' => 'Systeem',
	'Unknown Content Type' => 'Onbekend inhoudstype',
	'Page Views' => 'pageviews',

## lib/MT/CMS/Debug.pm

## lib/MT/CMS/Entry.pm
	'New Entry' => 'Nieuw bericht',
	'New Page' => 'Nieuwe pagina',
	'No such [_1].' => 'Geen [_1].',
	'This basename has already been used. You should use an unique basename.' => 'Deze basisnaam werd al gebruikt.  U moet een unieke basisnaam kiezen.',
	'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; [_2] datums moeten volgend formaat hebben JJJJ-MM-DD UU:MM:SS.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be earlier than the corresponding \'Unpublished on\' date \'[_2]\'.' => 'Ongeldige datum \'[_1]\; Publicatiedatums moeten vallen voor de corresponderende \'Einddatum\' \'[_2]\'.',
	'authored on' => 'geschreven op',
	'modified on' => 'gewijzigd op',
	'Saving entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opslaan mislukt: [_2]',
	'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt en status aangepast van [_4] naar [_5] door gebruiker \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt door gebruiker \'[_4]\'',
	'(user deleted - ID:[_1])' => '(gebruiker verwijderd - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">QuickPost op [_2]</a> - Sleep deze link naar de werkbalk van uw browser en klik er op wanneer u een site bezoekt waar u over wil bloggen.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) toegevoegd door gebruiker \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) verwijderd door \'[_4]\'',
	'Need a status to update entries' => 'Status vereist om berichten bij te werken',
	'Need entries to update status' => 'Berichten nodig om status bij te werken',
	'One of the entries ([_1]) did not exist' => 'Een van de berichten ([_1]) bestond niet',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) status veranderd van [_4] naar [_5]',
	'/' => '/',

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Berichten site exporteren',
	'Please select a site.' => 'Gelieve een site te selecteren.',
	'Loading site \'[_1]\' failed: [_2]' => 'Laden van site \'[_1]\' mislukt: [_2]',
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
	'Folder \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) bewerkt door \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',

## lib/MT/CMS/Group.pm
	'Each group must have a name.' => 'Elke groep moet een naam hebben',
	'Select Users' => 'Gebruikers selecteren',
	'Users Selected' => 'Gebruikers geselecteerd',
	'Search Users' => 'Gebruikers zoeken',
	'Select Groups' => 'Selecteer groepen',
	'Group Name' => 'Groepsnaam',
	'Groups Selected' => 'Geselecteerde groepen',
	'Search Groups' => 'Groepen zoeken',
	'Add Users to Groups' => 'Gebruikers toevoegen aan groepen',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd uit groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
	'Group load failed: [_1]' => 'Laden groep mislukt: [_1]',
	'User load failed: [_1]' => 'Laden gebruiker mislukt: [_1]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) toegevoegd aan groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
	'Create Group' => 'Groep aanmaken',
	'Author load failed: [_1]' => 'Laden auteur mislukt: [_1]',

## lib/MT/CMS/Import.pm
	'Cannot load site #[_1].' => 'Kan site niet laden #[_1].',
	'Import Site Entries' => 'Berichten site importeren',
	'You do not have import permission' => 'U heeft geen import-permissie',
	'You do not have permission to create users' => 'U heeft geen permissie om gebruikers aan te maken',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker vernoemd in uw site.',
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
	'Plugin' => 'Plugin',

## lib/MT/CMS/RebuildTrigger.pm
	'Select Site' => 'Selecteer site',
	'Select Content Type' => 'Selecteer inhoudstype',
	'Create Rebuild Trigger' => 'Rebuild-trigger aanmaken',
	'Search Sites and Child Sites' => 'Sites en subsites doorzoeken',
	'Search Content Type' => 'Inhoudstype zoeken',
	'(All child sites in this site)' => '(Alle subsites onder deze site)',
	'Select to apply this trigger to all child sites in this site.' => 'Selecteer dit om deze trigger toe te passen voor alle subsites onder deze site.',
	'(All sites and child sites in this system)' => '(Alle sites en subsites in dit systeem)',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Selecteer dit om deze trigger toe te passen op alle sites en subsites in dit systeem.',
	'Entry or Page' => 'Bericht of pagina',
	'Comment' => 'Reactie',
	'Trackback' => 'TrackBack',
	'saves an entry/page' => 'een bericht/pagina opslaat',
	'Entry/Page' => 'Bericht/pagina',
	'Save' => 'Opslaan',
	'publishes an entry/page' => 'een bericht/pagina publiceert',
	'unpublishes an entry/page' => 'een bericht/pagina ontpubliceert',
	'Unpublish' => 'Publicatie ongedaan maken',
	'saves a content' => 'inhoud opslaat',
	'publishes a content' => 'inhoud publiceert',
	'unpublishes a content' => 'publicatie inhoud ongedaan maakt',
	'publishes a comment' => 'een reactie publiceert',
	'publishes a TrackBack' => 'een TrackBack publiceert',
	'TrackBack' => 'TrackBack',
	'rebuild indexes.' => 'indexen opnieuw opbouwt.',
	'rebuild indexes and send pings.' => 'indexen opnieuw opbouwt en pings verstuurt.',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Er werden geen [_1] gevonden die overeenkomen met de opgegeven criteria.',
	'Data Label' => 'Data label',
	'Title' => 'Titel',
	'Entry Body' => 'Berichttekst',
	'Extended Entry' => 'Uitgebreid bericht',
	'Keywords' => 'Trefwoorden',
	'Excerpt' => 'Uittreksel',
	'Page Body' => 'Romp van de pagina',
	'Extended Page' => 'Uitgebreide pagina',
	'Template Name' => 'Sjabloonnaam',
	'Text' => 'Tekst',
	'Linked Filename' => 'Naam gelinkt bestand',
	'Output Filename' => 'Naam uitvoerbestand',
	'IP Address' => 'IP adres',
	'Log Message' => 'Logbericht',
	'Site URL' => 'URL van de site',
	'Site Root' => 'Siteroot',
	'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
	'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
	'replace_handler of [_1] field is invalid' => 'replace_handler van [_1] veld is ongeldig',
	'"[_1]" field is required.' => '"[_1]" veld is vereist',
	'ss_validator of [_1] field is invalid' => 'ss_validator van [_1] veld is ongeldig',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" is ongeldig voor "[_2]" veld van "[_3]" (ID:[_4]): [_5]',
	'Searched for: \'[_1]\' Replaced with: \'[_2]\'' => 'Gezocht naar: \'[_1]\' Vervangen door: \'[_2]\'',
	'[_1] \'[_2]\' (ID:[_3]) updated by user \'[_4]\' using Search & Replace.' => '[_1] \'[_2]\' (ID:[_3]) bijgewerkt door gebruiker \'[_4]\' via zoeken & vervangen.',
	'Templates' => 'Sjablonen',

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
	'contnt type' => 'inhoudstype',
	'Content Type Archive' => 'Inhoudstypesjabloon',
	'Create Widget' => 'Widget aanmaken',
	'Create Template' => 'Sjabloon aanmaken',
	'No Name' => 'Geen naam',
	'Index Templates' => 'Indexsjablonen',
	'Archive Templates' => 'Archiefsjablonen',
	'Content Type Templates' => 'Inhoudstypesjablonen',
	'Template Modules' => 'Sjabloonmodules',
	'System Templates' => 'Systeemsjablonen',
	'Email Templates' => 'E-mail sjablonen',
	'Template Backups' => 'Sjabloonbackups',
	'Widget Template' => 'Widgetsjabloon',
	'Widget Templates' => 'Widgetsjablonen',
	'Cannot locate host template to preview module/widget.' => 'Kan geen gastsjabloon vinden om voorbeeld van module/widget in te bekijken.',
	'Cannot preview without a template map!' => 'Kan geen voorbeeld bekijken zonder sjabloonkoppeling',
	'Preview' => 'Voorbeeld',
	'Unable to create preview file in this location: [_1]' => 'Kon geen voorbeeldbestand maken op deze locatie: [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'staaltje, bericht, voorbeeld',
	'Published Date' => 'Publicatiedatum',
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
	'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
	'Template Refresh' => 'Sjabloonverversing',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Sjabloon \'[_1]\' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Bezig sjabloon <strong>[_3]</strong> te verversen met <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Sjabloon \'[_1]\' wordt overgeslagen omdat het niet is veranderd.',
	'Copy of [_1]' => 'Kopie van [_1]',
	'Cannot publish a global template.' => 'Kan globaal sjabloon niet publiceren.',
	'Create Widget Set' => 'Widgetset aanmaken',
	'template' => 'sjabloon',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Thema niet gevonden',
	'Failed to uninstall theme' => 'Thema de-installeren mislukt',
	'Failed to uninstall theme: [_1]' => 'Thema de-installeren mislukt: [_1]',
	'Theme from [_1]' => 'Thema van [_1]',
	'Install into themes directory' => 'Installeren in thema-map',
	'Download [_1] archive' => 'Download [_1] archief',
	'Export Themes' => 'Thema\'s exporteren',
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
	'Changing image quality is [_1]' => 'Aanpassen afbeeldingskwaliteit is [_]',
	'Image quality(JPEG) is [_1]' => 'Afbeeldingskwaliteit (JPEG) is [_1]',
	'Image quality(PNG) is [_1]' => 'Afbeeldingskwaliteit (PNG) is [_1]',
	'System Settings Changes Took Place' => 'Wijzigingen werden aangebracht aan de systeeminstellingen',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Ongeldige poging om wachtwoord opnieuw in te stellen; Kan het wachtwoord niet terughalen in deze configuratie',
	'Invalid author_id' => 'Ongeldig author_id',
	'Temporary directory needs to be writable for export to work correctly.  Please check TempDir configuration directive.' => 'Tijdelijke map moet beschrijfbaar zijn om export correct te laten werken.  Kijk de TempDir configuratiedirectief na.',
	'Temporary directory needs to be writable for import to work correctly.  Please check TempDir configuration directive.' => 'Tijdelijke map moet beschrijfbaar zijn om import correct te laten werken.  Kijk de TempDir configuratiedirectief na.',
	'[_1] is not a number.' => '[_1] is geen getal.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Bestand [_1] copiëren naar [_2] mislukt: [_3]',
	'Specified file was not found.' => 'Het opgegeven bestand werd niet gevonden.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] exportbestand met succes gedownload ([_2)])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be imported.' => 'Enkele van de eigenlijke mediabestanden konden niet worden geïmporteerd.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Gelieve xml, tar.gz, zip, of manifest te gebruiken als bestandsextensies.',
	'Some objects were not imported because their parent objects were not imported.' => 'Sommige objecten werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.',
	'Detailed information is in the activity log.' => 'Gedetailleerde informatie is terug te vinden in het activiteitenlog.',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] heeft de operatie om meerdere bestanden te importeren voortijdig afgebroken.',
	'Changing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Bezig sitepad aan te passen voor de site \'[_1]\' (ID:[_2])...',
	'Removing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Bezig sitepad te verwijderen voor de site \'[_1]\' (ID:[_2])...',
	'Changing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Bezig archiefpad aan te passen voor de site \'[_1]\' (ID:[_2])...',
	'Removing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Bezig archiefpad te verwijderen voor de site \'[_1]\' (ID:[_2])...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Bestandspad aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing URL for FileInfo record (ID:[_1])...' => 'URL aan het aanpassen voor FileInfo record (ID:[_1])...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Bestandslocatie voor mediabestand \'[_1]\' (ID:[_2]) wordt aangepast...',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'Manifestbestand [_1] was geen geldig door Movable Type geëxporteerd manifestbestand.',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'Kon exportbestand [_1] niet verwijderen uit het bestandssysteem: [_2]',
	'Some of the exported files could not be removed.' => 'Sommige van de geëxporteerde bestanden konden niet worden verwijderd.',
	'Please upload [_1] in this page.' => 'Gelieve [_1] te uploaden op deze pagina.',
	'File was not uploaded.' => 'Bestand werd niet opgeladen.',
	'Importing a file failed: ' => 'Importeren van een bestand mislukt: ',
	'Some of the files were not imported correctly.' => 'Een aantal bestanden werden niet correct geïmporteerd.',
	'Successfully imported objects to Movable Type system by user \'[_1]\'' => 'Objecten werden met succes geïmporteerd in het Movable Type systeem door gebruiker \'[_1]\'',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Ongeldige poging het wachtwoord terug te vinden; kan geen wachtwoorden terugvinden in deze configuratie',
	'Cannot recover password in this configuration' => 'Kan geen wachtwoorden terugvinden in deze configuratie',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) heeft geen e-mail adres',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Een verzoek om het wachtwoord re resetten is naar [_3] gestuurd voor gebruiker \'[_1]\' (gebruiker #[_2]).',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Sommige objecten werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.  Meer details in het activiteitenlog.',
	'[_1] is not a directory.' => '[_1] is geen map.',
	'Error occurred during import process.' => 'Er deed zich een fout voor tijdens het importproces.',
	'Some of files could not be imported.' => 'Sommige bestanden konden niet worden geïmporteerd.',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'Geupload bestand was geen geldig uit Movable Type geëxporteerd manifestbestand.',
	'Manifest file \'[_1]\' is too large. Please use import directory for importing.' => 'Manifestbestand \'[_1]\' is te groot.  Gelieve de import map te gebruiken om te importeren.',
	'Site(s) (ID:[_1]) was/were successfully exported by user \'[_2]\'' => 'Site(s) (ID:[_1]) werd(en) met succes geëxporteerd door gebruiker \'[_2]\'',
	'Movable Type system was successfully exported by user \'[_1]\'' => 'Movable Type systeem werd met succes geëxporteerd door gebruiker \'[_1]\'',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Sommige [_1] werden niet geïmporteerd omdat de objecten waar ze van afhingen niet werden geïmporteerd.',
	'Recipients for lockout notification' => 'Ontvangers voor blokkeringsnotificaties',
	'User lockout limit' => 'Blokkeringslimiet gebruiker',
	'User lockout interval' => 'Blokkeringsinterval gebruiker',
	'IP address lockout limit' => 'Blokkeringslimiet IP adres',
	'IP address lockout interval' => 'Blokkeringsinterval IP adres',
	'Lockout IP address whitelist' => 'Niet blokkkeerbare IP adressen',

## lib/MT/CMS/User.pm
	'For improved security, please change your password' => 'Gelieve uw wachtwoord te veranderen voor verhoogde veiligheid',
	'Create User' => 'Gebruiker aanmaken',
	'Cannot load role #[_1].' => 'Kan rol #[_1] niet laden.',
	'Role name cannot be blank.' => 'Naam van de rol mag niet leeg zijn.',
	'Another role already exists by that name.' => 'Er bestaat al een rol met die naam.',
	'You cannot define a role without permissions.' => 'U kunt geen rol definiëren zonder permissies.',
	'Invalid type' => 'Ongeldig type',
	'User \'[_1]\' (ID:[_2]) could not be re-enabled by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) kon niet opnieuw geactiveerd worden door \'[_3]\'',
	'User Settings' => 'Instellingen gebruiker',
	'Invalid ID given for personal blog theme.' => 'Ongeldig ID opgegeven voor persoonlijk blogthema.',
	'Invalid ID given for personal blog clone location ID.' => 'Ongeldig ID opgegeven als locatie ID van kloon van persoonlijke blog',
	'Minimum password length must be an integer and greater than zero.' => 'Minimale wachtwoordlengte moet een geheel getal groter dan nul zijn.',
	'Select a entry author' => 'Selecteer een berichtauteur',
	'Select a page author' => 'Selecteer een pagina-auteur',
	'Selected author' => 'Selecteer auteur',
	'Type a username to filter the choices below.' => 'Tik een gebruikersnaam in om de keuzes hieronder te filteren.',
	'Select a System Administrator' => 'Selecteer een systeembeheerder',
	'Selected System Administrator' => 'Geselecteerde systeembeheerder',
	'System Administrator' => 'Systeembeheerder',
	'(newly created user)' => '(nieuw aangemaakte gebruiker)',
	'Sites Selected' => 'Geselecteerde sites',
	'Select Roles' => 'Selecteer rollen',
	'Roles Selected' => 'Geselecteerde rollen',
	'Grant Permissions' => 'Permissies toekennen',
	'Select Groups And Users' => 'Selecteer groepen en gebruikers',
	'Groups/Users Selected' => 'Geselecteerde groepen/gebruikers',
	'You cannot delete your own association.' => 'U kunt uw eigen associatie niet verwijderen.',
	'[_1]\'s Associations' => 'Associaties van [_1]',
	'You have no permission to delete the user [_1].' => 'U heeft geen rechten om gebruiker [_1] te verwijderen.',
	'User requires username' => 'Gebruiker vereist gebruikersnaam',
	'User requires display name' => 'Gebruiker heeft een getoonde naam nodig',
	'User requires password' => 'Gebruiker vereist wachtwoord',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'represents a user who will be created afterwards' => 'stelt een gebruiker voor die later zal worden aangemaakt',

## lib/MT/CMS/Website.pm
	'Create Site' => 'Site aanmaken',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Website \'[_1]\' (ID: [_2]) verwijderd door \'[_3]\'',
	'Selected Site' => 'Geselecteerde site',
	'Type a website name to filter the choices below.' => 'Tik de naam van een website in om de keuzes hieronder te filteren.',
	'This action cannot move a top-level site.' => 'Deze actie kan geen site verplaatsen op het hoogste niveau.',
	'Type a site name to filter the choices below.' => 'Tik de naam van een site in om de opties hieronder te filteren.',
	'Cannot load website #[_1].' => 'Kan website #[_1] niet laden',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) verplaatst van \'[_3]\' naar \'[_4]\' door \'[_5]\'',

## lib/MT/Comment.pm
	'Loading entry \'[_1]\' failed: [_2]' => 'Laden van bericht \'[_1]\' mislukt: [_2]',
	'Loading blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_1]',

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

## lib/MT/ContentData.pm
	'Invalid content type' => 'Ongeldig inhoudstype',
	'Saving content field index failed: [_1]' => 'Opslaan inhoudstype index mislukt: [_1]',
	'Removing content field indexes failed: [_1]' => 'Verwijderen indexen inhoudstypes mislukt: [_1]',
	'Saving object asset failed: [_1]' => 'Opslaan mediabestandsobject mislukt: [_1]',
	'Removing object assets failed: [_1]' => 'Verwijderen mediabestandsobjecten mislukt: [_1]',
	'Saving object tag failed: [_1]' => 'Opslaan objecttag mislukt: [_1]',
	'Removing object tags failed: [_1]' => 'Verwijderen objecttags mislukt: [_1]',
	'Saving object category failed: [_1]' => 'Opslaan objectcategorie mislukt: [_1]',
	'Removing object categories failed: [_1]' => 'Verwijderen objectcategorieën mislukt: [_1]',
	'record does not exist.' => 'record bestaat niet.',
	'Cannot load content field #[_1]' => 'Kan inhoudsveld niet laden #[_1]',
	'Publish Date' => 'Datum publicatie',
	'Unpublish Date' => 'Einddatum publicatie',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) bestaat niet.',
	'Contents by [_1]' => 'Inhoud door [_1]',
	'Tags fields' => 'Tags velden',
	'(No label)' => '(geen label)',
	'Identifier' => 'Identificatie',
	'Link' => 'Link',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Inhoudsveld index',
	'Content Field Indexes' => 'Inhoudsveld indexen',

## lib/MT/ContentField.pm
	'Content Fields' => 'Inhoudsvelden',
	'Edit [_1] field' => '[_1] veld bewerken',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Alle [_1] mediabestanden weergeven',
	'You must select or upload correct assets for field \'[_1]\' that has asset type \'[_2]\'.' => 'U moet de juiste soort mediabestanden uploaden voor veld \'[_1]\' met mediabestandstype \'[_2]\'.',
	'A minimum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 0.' => 'Een minimum selectienummer voor \'[_1]\' ([_2]) moet een positief geheel getal zijn groter of gelijk aan 0.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 1.' => 'Een maximum selectienummer voor \'[_1]\' ([_2]) moet een positief geheel getal zijn groter of gelijk aan 1.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to the minimum selection number.' => 'Een maximum selectienummer voor \'[_1]\' ([_2]) moet een positief geheel getal zijn groter of gelijk aan het minimum selectienummer.',

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'Ongeldige categorie IDs: [_1] in "[_2]" veld.',
	'You must select a source category set.' => 'U moet een cagtegorieset selecteren als bron.',
	'The source category set is not found in this site.' => 'De broncategorieset werd niet gevonden in deze site.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'Er is geen categorieset die geselecteerd kan worden.  Gelieve een categorieset aan te maken als u het Categoriën veldtype wil gebruiken.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'You must enter at least one label-value pair.' => 'U moet minstens één label-waarde paar invullen.',
	'A label for each value is required.' => 'Voor elke waarde is een label vereist.',
	'A value for each label is required.' => 'Voor elk label is een waarde vereist.',

## lib/MT/ContentFieldType/Common.pm
	'is selected' => 'is geselecteerd',
	'is not selected' => 'is niet geselecteerd',
	'In [_1] column, [_2] [_3]' => 'In [_1] kolom, [_2] [_3]',
	'Invalid [_1] in "[_2]" field.' => 'Ongeldige [_1] in "[_2]" veld.',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '[_1] minder dan of gelijk aan [_2] moet geselectdeerd worden in "[_3]" veld.',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '[_1] meer dan of gelijk aan [_2] moet geselectdeerd worden in "[_3]" veld.',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Slechts 1 [_1] kan geselecteerd worden in het "[_2]" veld.',
	'Invalid values in "[_1]" field: [_2]' => 'Ongeldige waardes in het "[_1]" veld.',
	'"[_1]" field value must be less than or equal to [_2].' => 'Waarde "[_1]" veld moet kleiner dan of gelijk zijn aan [_2].',
	'"[_1]" field value must be greater than or equal to [_2]' => 'Waarde "[_1]" veld moet groter of gelijk zijn aan [_2].',

## lib/MT/ContentFieldType/ContentType.pm
	'No Label (ID:[_1]' => 'Geen label (ID:[_1])',
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'Ongeldige inhoudsgegevens IDs: [_1] in "[_2]" veld.',
	'You must select a source content type.' => 'U moet een inhoudstype opgeven als bron.',
	'The source Content Type is not found in this site.' => 'Het broninhoudstype werd niet gevonden in deze site.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'Er is geen inhoudstype dat geselecteerd kan worden.  Gelieve een nieuw inhoudstype aan te maken als u het inhoudstype veld wenst te gebruiken.',

## lib/MT/ContentFieldType/Date.pm
	'Invalid date \'[_1]\'; An initial date value must be in the format YYYY-MM-DD.' => 'Ongeldige datum \'[_1]\'; Een initiõ�¼„e datumwaarde moet in het formaat JJJJ-MM-DD staan.',

## lib/MT/ContentFieldType/DateTime.pm
	'Invalid date \'[_1]\'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; Een initiõ�¼„e datum/tijd waarde moet in het formaat JJJJ-MM-DD UU:MM:SS staan.',

## lib/MT/ContentFieldType/MultiLineText.pm

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value must be a number.' => 'Waarde "[_1]" veld moet een getal zijn.',
	'"[_1]" field value has invalid precision.' => 'Waarde "[_1]" heeft een ongeldige preciesie',
	'Number of decimal places must be a positive integer.' => 'Aantal cijfers achter de komma moet een positief geheel getal zijn.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'Aantal cijfers achter de komma moet een positief geheel getal zijn tussen 0 en [_1].',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'Minimumwaarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om decimale waarde te kunnen gebruiken.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'Minimumwaarde moet een geheel getal zijn tussen [_1] en [_2]',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'Een maximum waarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om een decimale waarde te kunnen gebruiken.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'Maximumwaarde moet een geheel getal zijn tussen [_1] en [_2]',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'Een beginwaarde moet een geheel getal zijn of ingesteld zijn met een aantal cijfers achter de komma om een decimale waarde te kunnen gebruiken.',
	'An initial value must be an integer and between [_1] and [_2]' => 'Een beginwaarde moet een geheel getal zijn tussen [_1] en [_2]',

## lib/MT/ContentFieldType.pm
	'Single Line Text' => 'Eén regel tekst',
	'Multi Line Text' => 'Meerdere regels tekst',
	'Number' => 'Getal',
	'Date and Time' => 'Datum en tijd',
	'Date' => 'Datum',
	'Time' => 'Tijd',
	'Select Box' => 'Selectievak',
	'Radio Button' => 'Radioknop',
	'Checkboxes' => 'Aankruisvakjes',
	'Audio Asset' => 'Audiobestand',
	'Video Asset' => 'Videobestand',
	'Image Asset' => 'Afbeeldingsbestand',
	'Embedded Text' => 'Ingebedde tekst',
	'__LIST_FIELD_LABEL' => 'Lijst', # Translate - New
	'Table' => 'Tabel',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Een label van waardes is vereist.',
	'A value of values is required.' => 'Een waarde van waardes is vereist.',

## lib/MT/ContentFieldType/SelectBox.pm

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => '"[_1]" veld is te lang',
	'"[_1]" field is too short.' => '"[_1]" veld is te kort',
	'A minimum length number for \'[_1]\' ([_2]) must be a positive integer between 0 and [_3].' => 'Een minimale lengte voor \'[_1]\' ([_2]) moet een positief geheel getal zijn tussen 0 en [_3].',
	'A maximum length number for \'[_1]\' ([_2]) must be a positive integer between 1 and [_3].' => 'Een maximale lengte voor \'[_1]\' ([_2]) moet een positief geheel getal zijn tussen 1 en [_3].',
	'An initial value for \'[_1]\' ([_2]) must be shorter than [_3] characters' => 'Een beginwaarde voor \'[_1]\' ([_2]) moet korter zijn dan [_3] karakters',

## lib/MT/ContentFieldType/Table.pm
	'Initial number of rows for \'[_1]\' ([_2]) must be a positive integer.' => 'Initiëel aantal rijen voor \'[_1]\' ([_2]) moet een positief geheel getal zijn.',
	'Initial number of columns for \'[_1]\' ([_2]) must be a positive integer.' => 'Initiëel aantal kolommen voor \'[_1]\' ([_2]) moet een positief geheel getal zijn.',

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tags [_1] in "[_2]" field.' => 'Kan tags [_1] niet aanmaken in "[_2]" veld.',
	'Cannot create tag "[_1]": [_2]' => 'Kan tag "[_1]" niet aanmaken: [_2]',
	'An initial value for \'[_1]\' ([_2]) must be an shorter than 255 characters' => 'Een beginwaarde voor \'[_1]\' ([_2]) moet korter zijn dan 255 karakters.',

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'Invalid time \'[_1]\'; An initial time value be in the format HH:MM:SS.' => 'Ongeldige tijdsaanduiding \'[_1]\'; Een beginwaarde voor de tijd moet volgend formaat hebben UU:MM:SS.',

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'Ongeldige URL in "[_1]" veld.',
	'An initial value for \'[_1]\' ([_2]) must be shorter than 2000 characters' => 'Een beginwaarde voor \'[_1]\' ([_2]) moet korter zijn dan 2000 karakters',

## lib/MT/ContentPublisher.pm
	'Loading of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archieftype \'[_1]\' is geen gekozen archieftype',
	'Load of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',
	'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is vereist',
	'Parameter \'[_1]\' is invalid' => 'Parameter \'[_1]\' is ongeldig',
	'Load of blog \'[_1]\' failed' => 'Laden van blog \'[_1]\' mislukt',
	'[_1] archive type requires [_2] parameter' => 'Archieftype [_1] vereist een [_2] parameter',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Er deed zich een fout voor bij het publiceren van [_1] \'[_2]\': [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Er deed zich een fout voor bij het publiceren van datum-gebaseerd archief \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Schrijven naar \'[_1]\' mislukt: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Tijdelijk bestand \'[_1]\' van naam veranderen mislukt: [_2]',
	'You did not set your blog publishing path' => 'U stelde geen blogpublicatiepad in',
	'Cannot load catetory. (ID: [_1]' => 'Kan categorie niet laden. (ID: [_1])',
	'Scheduled publishing.' => 'Geplande berichten.',
	'An error occurred while publishing scheduled contents: [_1]' => 'Er deed zich een fout voor bij het publiceren van geplande inhoud: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Er deed zich een fout voor bij het ontpubliceren van oude inhoud: [_1]',

## lib/MT/ContentType.pm
	'Manage Content Data' => 'Inhoudsgegevens beheren',
	'Create Content Data' => 'Inhoudsgegevens aanmaken',
	'Publish Content Data' => 'Inhoudsgegevens publiceren',
	'Edit All Content Data' => 'Alle inhoudsgegevens bewerken',
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (Site: "[_2]" ID: [_3])',
	'Content Data # [_1] not found.' => 'Inhoudsgegevens # [_1] niet gevonden.',
	'Tags with [_1]' => 'Tags met [_1]',
	'string(40)' => 'string(40)',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'Kan geen unieke ID aanmaken',

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
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Title' => 'Geen titel',
	'(system)' => '(systeem)',
	'*Website/Blog deleted*' => '*Website/Blog verwijderd*',
	'My [_1]' => 'Mijn  [_1]',
	'[_1] of this Site' => '[_1] van deze site',
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
	'No label' => 'Geen label',
	'Date Created' => 'Datum aangemaakt',
	'Date Modified' => 'Datum gewijzigd',
	'Author Name' => 'Auteursnaam',
	'Tag' => 'Tag',
	'Legacy Quick Filter' => 'Verouderde snelfilter',
	'My Items' => 'Mijn items',
	'Log' => 'Log',
	'Activity Feed' => 'Activiteit-feed',
	'Folder' => 'Map',
	'Member' => 'Lid',
	'Members' => 'Leden',
	'Permission' => 'Permissie',
	'IP address' => 'IP adres',
	'IP addresses' => 'IP adressen',
	'IP Banning Settings' => 'IP-verbanningsinstellingen',
	'Contact' => 'Contact',
	'Manage Address Book' => 'Adresboek beheren',
	'Filter' => 'Filter',
	'Manage Content Type' => 'Inhoudstype beheren',
	'Manage Group Members' => 'Groepsleden beheren',
	'Group Members' => 'Groepsleden',
	'Group Member' => 'Groepslid',
	'Convert Line Breaks' => 'Regeleindes omzetten',
	'Rich Text' => 'Rich text',
	'Movable Type Default' => 'Movable Type standaardinstelling',
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
	'Blog Name' => 'Blognaam',
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
	'Publish Scheduled Contents' => 'Geplande inhoud publiceren',
	'Unpublish Past Contents' => 'Oude inhoud ontpubliceren',
	'Add Summary Watcher to queue' => 'Samenvattings-waakhond toevoegen aan de wachtrij',
	'Junk Folder Expiration' => 'Vervaldatum spam-map',
	'Remove Temporary Files' => 'Tijdelijke bestanden verwijderen',
	'Purge Stale Session Records' => 'Verlopen sessiegegevens verwijderen',
	'Purge Stale DataAPI Session Records' => 'Verlopen DataAPI sessiegegevens verwijderen',
	'Remove expired lockout data' => 'Verlopen blokkeringsgegevens verwijderen',
	'Purge Unused FileInfo Records' => 'Ongebruikte FileInfo records verwijderen',
	'Remove Compiled Template Files' => 'Gecompileerde sjabloonbestanden verwijderen',
	'Manage Sites' => 'Sites beheren',
	'Manage Website' => 'Website beheren',
	'Manage Blog' => 'Blog beheren',
	'Manage Website with Blogs' => 'Website met blogs beheren',
	'Create Sites' => 'Sites aanmaken',
	'Post Comments' => 'Reacties publiceren',
	'Create Entries' => 'Berichten aanmaken',
	'Edit All Entries' => 'Alle berichten bewerken',
	'Manage Assets' => 'Mediabestanden beheren',
	'Manage Categories' => 'Categorieën beheren',
	'Change Settings' => 'Instellingen aanpassen',
	'Manage Tags' => 'Tags beheren',
	'Manage Templates' => 'Sjablonen beheren',
	'Manage Feedback' => 'Feedback beheren',
	'Manage Content Types' => 'Inhoudstypes beheren',
	'Manage Pages' => 'Pagina\'s beheren',
	'Manage Users' => 'Gebruikers beheren',
	'Manage Themes' => 'Thema\'s beheren',
	'Publish Entries' => 'Berichten publiceren',
	'Send Notifications' => 'Notificaties verzenden',
	'Set Publishing Paths' => 'Publicatiepaden instellen',
	'View Activity Log' => 'Activiteitenlog bekijken',
	'Manage Category Set' => 'Categorieset beheren',
	'Upload File' => 'Opladen',
	'Create Child Sites' => 'Subsites aanmaken',
	'Manage Plugins' => 'Plugins beheren',
	'View System Activity Log' => 'Systeemactiviteitlog bekijken',
	'Sign In(CMS)' => 'Aanmelden(CMS)',
	'Sign In(Data API)' => 'Aanmelden(Data API)',
	'Create Websites' => 'Websites aanmaken',
	'Manage Users & Groups' => 'Gebruikers en groepen beheren',

## lib/MT/DataAPI/Callback/Blog.pm
	'A parameter "[_1]" is required.' => 'Eeen "[_1]" parameter is vereist',
	'The website root directory must be an absolute path: [_1]' => 'De hoofdmap van de website moet een absoluut pad zijn: [_1]',
	'Invalid theme_id: [_1]' => 'Ongeldig theme_id: [_1]',
	'Cannot apply website theme to blog: [_1]' => 'Kan website-thema niet op blog toepassen: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'The label \'[_1]\' is too long.' => 'Het label \'[_1]\' is te lang.',
	'Parent [_1] (ID:[_2]) not found.' => 'Moeder [_1] (ID:[_2]) niet gevonden.',

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => 'Naam "[_1]" wordt al gebruikt in dezelfde site.',

## lib/MT/DataAPI/Callback/ContentData.pm
	'There is an invalid field data: [_1]' => 'Er zijn ongeldige gegevens in het veld: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'Een parameter "[_1]" is ongeldig: [_2]',
	'Invalid option key(s): [_1]' => 'Ongeldige optiesleutel(s): [_1]',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler van type [_1]" is ongeldig',
	'Invalid option(s): [_1]' => 'Ongeldige optie(s): [_1]',

## lib/MT/DataAPI/Callback/ContentType.pm

## lib/MT/DataAPI/Callback/Entry.pm

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Een parameter "[_1]" is ongeldig.',

## lib/MT/DataAPI/Callback/Log.pm
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
	'Failed login attempt by user who does not have sign in permission via data api. \'[_1]\' (ID:[_2])' => 'Mislukte aanmeldpoging van gebruiker zonder toestemming om aan te melden via de data api. \'[_1]\' (ID:[_2])',
	'User \'[_1]\' (ID:[_2]) logged in successfully via data api.' => 'Gebruiker \'[_1]\' (ID:[_2]) met succes aangemeld via de data api.',

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
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om backups te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken.',
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
	'[_1] not found' => '[_1] niet gevonden',
	'Loading object failed: [_1]' => 'Laden object mislukt: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'U moet de "password" parameter opgeven als u nieuwe gebruikers wenst aan te maken voor elke gebruiker die aan uw blog vastzit.',
	'Invalid import_type: [_1]' => 'Ongeldig import_type: [_1]',
	'Invalid encoding: [_1]' => 'Ongeldige encodering: [_1]',
	'Invalid convert_breaks: [_1]' => 'Ongeldige convert_breaks: [_1]',
	'Invalid default_cat_id: [_1]' => 'Ongeldige default_cat_id: [_1]',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Verwijder zeker de bestanden waaruit u gegevens importeerde uit de \'import\' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.',
	'A resource "[_1]" is required.' => 'Een bron "[_1]" is vereist.',
	'Could not found archive template for [_1].' => 'Kon archiefsjabloon niet vinden voor [_1].',
	'Preview data not found.' => 'Gegevens voor voorbeeld niet gevonden.',

## lib/MT/DataAPI/Endpoint/v2/Folder.pm

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'Creating group failed: ExternalGroupManagement is enabled.' => 'Groep aanmaken mislukt: ExternalGroupManagement is ingeschakeld.',
	'Cannot add member to inactive group.' => 'Kan geen lid toevoegen aan inactieve groep.',
	'Adding member to group failed: [_1]' => 'Lid toevoegen aan groep mislukt: [_1]',
	'Removing member from group failed: [_1]' => 'Lid verwijderen uit groep mislukt: [_1]',
	'Group not found' => 'Groep niet gevonden',
	'Member not found' => 'Lid niet gevonden',
	'A resource "member" is required.' => 'Een bron ("member") is vereist.',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Logbericht',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	'\'folder\' parameter is invalid.' => '\'folder\' parameter is ongeldig.',

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Granting permission failed: [_1]' => 'Permissie verlenen mislukt: [_1]',
	'Role not found' => 'Rol niet gevonden',
	'Revoking permission failed: [_1]' => 'Permissie afnemen mislukt: [_1]',
	'Association not found' => 'Associatie niet gevonden',

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
	'Unknown archiver type: [_1]' => 'Onbekend archieftype: [_1]',

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

## lib/MT/DataAPI/Endpoint/v4/Category.pm

## lib/MT/DataAPI/Endpoint/v4/CategorySet.pm

## lib/MT/DataAPI/Endpoint/v4/ContentData.pm

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is required.' => 'De parameter "content_fields" is vereist.',
	'A parameter "content_fields" is invalid.' => 'De parameter "content_fields" is ongeldig.',

## lib/MT/DataAPI/Endpoint/v4/ContentType.pm

## lib/MT/DataAPI/Endpoint/v4/Search.pm

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Kan "[_1]" niet parsen als een IS0 8601 datetime',

## lib/MT/DataAPI/Resource/v4/ContentData.pm

## lib/MT/DefaultTemplates.pm
	'Comment Form' => 'Reactieformulier',
	'Navigation' => 'Navigatie',
	'Blog Index' => 'Blog index',
	'Search Results for Content Data' => 'Zoekresultaten voor inhoudsgegevens',
	'Archive Index' => 'Archiefindex',
	'Stylesheet' => 'Stylesheet',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Feed - Recente berichten',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Maandoverzicht berichten',
	'Category Entry Listing' => 'Categorie-overzicht berichten',
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
	'Entry Notify' => 'Notificatie bericht',
	'User Lockout' => 'Blokkering gebruiker',
	'IP Address Lockout' => 'Blokkering IP adres',

## lib/MT/Entry.pm
	'View [_1]' => '[_1] bekijken',
	'Entries from category: [_1]' => 'Berichten in categorie: [_1]',
	'NONE' => 'GEEN',
	'Draft' => 'Klad',
	'Published' => 'Gepubliceerd',
	'Reviewing' => 'Nakijken',
	'Scheduled' => 'Gepland',
	'Junk' => 'Spam',
	'Unpublished (End)' => 'Publicatie ongedaan gemaakt (einde)',
	'Entries by [_1]' => 'Berichten door [_1]',
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
	'Primary Category' => 'Hoofdcategorie',
	'-' => '-',
	'Author ID' => 'ID auteur',
	'My Entries' => 'Mijn berichten',
	'Entries in This Website' => 'Berichten in deze website',
	'Published Entries' => 'Gepubliceerde berichten',
	'Draft Entries' => 'Kladberichten',
	'Unpublished Entries' => 'Niet gepubliceerde berichten',
	'Scheduled Entries' => 'Geplande berichten',

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
	'Invalid filter type [_1]:[_2]' => 'Ongeldig filtertype [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Ongeldige sorteersleutel [_1]:[_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms" en "editable_filters" kunnen niet op hetzelfde moment opgegeven worden.',
	'System Object' => 'Systeemobject',

## lib/MT/Folder.pm

## lib/MT/Group.pm
	'Backing up [_1] records:' => 'Er worden [_1] records gebackupt:',
	'[_1] records backed up.' => '[_1] records gebackupt.',
	'Groups associated with author: [_1]' => 'Groepen geassocieerd met auteur: [_1]',
	'Inactive' => 'Inactief',
	'Members of group: [_1]' => 'Leden van groep: [_1]',
	'__GROUP_MEMBER_COUNT' => 'Leden',
	'My Groups' => 'Mijn groepen',
	'__COMMENT_COUNT' => 'Reacties',
	'Email' => 'E-mail',
	'Active Groups' => 'Actieve groepen',
	'Disabled Groups' => 'Gedeactiveerde groepen',

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
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker die in uw weblog voorkomt.',
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
	'Export failed on entry \'[_1]\': [_2]' => 'Export mislukt bij bericht \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ongeldig datumformaat \'[_1]\'; dit moet \'MM/DD/JJJJ HH:MM:SS AM|PM\' zijn (AM|PM is optioneel)',

## lib/MT/Import.pm
	'Cannot rewind' => 'Kan niet terugspoelen',
	'Cannot open \'[_1]\': [_2]' => 'Kan \'[_1]\' niet openen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
	'Importing entries from file \'[_1]\'' => 'Berichten worden ingevoerd uit bestand  \'[_1]\'',
	'File not found: [_1]' => 'Bestand niet gevonden: [_1]',
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
	'[_1] (id:[_2])' => '[_1] (id:[_2])', # Translate - Case

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
	'TrackBacks' => 'TrackBacks',
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
	'Cancel' => 'Annuleren',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Assetplaatsing',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Categorieplaatsing',
	'Category Placements' => 'Categorieplaatsingen',

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

## lib/MT/Permission.pm

## lib/MT/Placement.pm

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
	'https://www.movabletype.com/' => 'https://www.movabletype.com',
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
	'Loading template \'[_1]\' failed.' => 'Laden van sjabloon \'[_1]\' mislukt.',
	'Error while creating email: [_1]' => 'Fout bij het aanmaken van email: [_1]',
	'An error occurred: [_1]' => 'Er deed zich een fout voor: [_1]',
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

## lib/MT/RebuildTrigger.pm
	'Restoring rebuild trigger for blog #[_1]...' => 'Rebuild trigger voor blog #[_1] aan het terugzetten...',
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Rebuild trigger voor inhoudstype #[_1] aan het terugzetten...',

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
	'Site Administrator' => 'Sitebeheerder',
	'Can administer the site.' => 'Kan de site beheren',
	'Editor' => 'Redacteur',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Kan bestanden uploaden, alle berichten (categorieën), pagina\'s (mappen), tags bewerken en de site publiceren.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Kan berichten aanmaken, eigen berichten bewerken, bestanden uploaden en publiceren.',
	'Designer' => 'Designer',
	'Can edit, manage, and publish blog templates and themes.' => 'Kan blogsjablonen en thema\'s bewerken, beheren en publiceren.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish site/child site templates.' => 'Kan pagina\'s beheren, bestanden uploaden en sjablonen van (sub)sites publiceren.',
	'Contributor' => 'Redactielid',
	'Can create entries, edit their own entries, and comment.' => 'Kan berichten aanmaken, eigen berichten bewerken en reageren.',
	'Content Designer' => 'Inhoudsontwerper',
	'Can manage content types, content data and category sets.' => 'Kan inhoudstypes, inhoudsgegevesn en categoriesets beheren.',
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

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Alles over mij',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publiceer[_2] uw [_3] om deze wijzigingen zichtbaar te maken.',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiceer[_2] uw site om deze wijzigingen zichtbaar te maken.',
	'Actions' => 'Acties',
	'The entered message is displayed as a input field hint.' => 'De ingevulde boodschap wordt getoond als hint bij het invoerveld.',
	'Is this field required?' => 'Is dit veld verplicht in te vullen?',
	'Display Options' => 'Weergave-opties',
	'Choose the display options for this content field in the listing screen.' => 'Kies de weergave-opties voor dit inhoudsveld in het overzichtsscherm.',
	'Force' => 'Forceer',
	'Default' => 'Standaard',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
	'Division by zero.' => 'Deling door nul.',
	'[_1] is not a hash.' => '[_1] is geen hash.',
	'blog(s)' => 'blog(s)',
	'website(s)' => 'website(s)',
	'No [_1] could be found.' => '[_1] werden niet gevonden',
	'records' => 'records',
	'id attribute is required' => 'id attribuut is vereist',
	'No template to include was specified' => 'Geen sjabloon opgegeven om te includeren',
	'Recursion attempt on [_1]: [_2]' => 'Recursiepoging op [_1]: [_2]',
	'Cannot find included template [_1] \'[_2]\'' => 'Kan geincludeerd sjabloon niet vinden: [_1] \'[_2]\'',
	'Error in [_1] [_2]: [_3]' => 'Fout in [_1] [_2]: [_3]',
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
	'Cannot load template' => 'Kan sjabloon niet laden',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'Het attribuut exclude_blogs kan niet \'[_1]\' als waarde hebben.',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Wanneer het ID van een blog zowel bij include_blogs als exclude_blogs staat, wordt de blog in kwestie uitgesloten.',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => 'U gebruikten een \'[_1]\' tag buiten de context van een auteur; Misschien plaatste u de tag per ongeluk buiten een \'MTAuthors\' container tag?',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; Misschien plaatste u die tag per ongeluk buiten een \'MTEntries\' container tag?',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van de website; Misschien plaatste u die tag per ongeluk buiten een \'MTWebsites\' container tag?',
	'You used an \'[_1]\' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?' => 'U gebruikte een \'[_1]\' tag in de context van een blog die geen deel uitmaakt van een website; Misschien is er een probleem met de gegevens van deze blog?',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => 'U gebruikte een \'[_1]\' tag buiten de context van de blog; Misschien plaatste u die tag per ongeluk buiten een \'MTBlogs\' container tag?',
	'You used an \'[_1]\' tag outside of the context of the site;' => 'U gebruikte een \'[_1]\' tag buiten de context van de site;', # Translate - New
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
	'Content Type is required.' => 'Inhoudstype is vereist.',
	'Template name must be unique within this [_1].' => 'Sjabloonnaam moet uniek zijn binnen deze [_1].',
	'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Gelinkt bestand \'[_1]\' openen mislukt: [_2]',
	'Index' => 'Index',
	'Category Archive' => 'Archief per categorie',
	'Comment Listing' => 'Overzicht reacties',
	'Ping Listing' => 'Overzicht pings',
	'Comment Preview' => 'Voorbeeld reactie',
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
	'Could not determine content' => 'Kon de inhoud niet bepalen',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',
	'No such user \'[_1]\'' => 'Geen gebruiker \'[_1]\'',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Er staat een fout in uw \'[_2]\' attribuut: [_1]',
	'[_1] must be a number.' => '[_1] moet een getal zijn.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'Het \'[_2]\' attribuut accepteert alleen een geheel getal: [_1]',
	'You used an [_1] without a author context set up.' => 'U gebruikte een [_1] zonder een auteurscontext op te zetten.',

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Onbekende "mode" attribuutwaarde: [_1].  Geldige waarden zijn "loop" en "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Ongeldig weeks_start_with formaat: moet Sun|Mon|Tue|Wed|Thu|Fri|Sat zijn',
	'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
	'No such category \'[_1]\'' => 'Geen categorie \'[_1]\'',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] moet gebruikt worden in een [_2] context',
	'Cannot find package [_1]: [_2]' => 'Kan package [_1] niet vinden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fout bij sorteren [_2]: [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => 'Kan sort_by en sort_method niet samen gebruiken in [_1]',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] kan niet gebruikt worden zonder een [_2] archief te publiceren',
	'[_1] used outside of [_2]' => '[_1] gebruikt buiten [_2]',

## lib/MT/Template/Tags/ContentType.pm
	'Invalid tag_handler of [_1].' => 'Ongeldige tag_handler van [_1]',
	'Invalid field_value_handler of [_1].' => 'Ongeldige field_valule_handler van [_1].',
	'Content Type was not found. Blog ID: [_1]' => 'Inhoudstype werd niet gevonden.  Blog ID: [_1]',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',
	'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',

## lib/MT/Template/Tags/Misc.pm
	'Specified WidgetSet \'[_1]\' not found.' => 'Opgegeven widgetset \'[_1]\' niet gevonden.',

## lib/MT/Template/Tags/Tag.pm

## lib/MT/Template/Tags/Website.pm

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
	'Default Pages' => 'Standaardpagina\'s',
	'Template Set' => 'Set sjablonen',
	'Default Content Data' => 'Standaard inhoudsgegevens',
	'Static Files' => 'Statische bestanden',

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
	'Creating initial user records...' => 'Bezig initiële gebruikersrecords aan te maken...',
	'Error saving record: [_1].' => 'Fout bij opslaan gegevens: [_1].',
	'Error creating role record: [_1].' => 'Fout bij aanmaken record voor rol: [_1].',
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
	'Confirmation...' => 'Bevestiging...',
	'Your comment has been posted!' => 'Uw reactie is geplaatst!',
	'Thank you for commenting.' => 'Bedankt voor uw reactie.',
	'Your comment has been received and held for review by a blog administrator.' => 'Uw reactie werd ontvangen en wordt bewaard tot ze kan worden beoordeeld door een blog administrator.',
	'Comment Submission Error' => 'Fout bij indienen reactie',
	'Your comment submission failed for the following reasons:' => 'Het indienen van uw reactie mislukte omwille van volgende redenen:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Return to the <a href="[_1]">original entry</a>.' => 'Ga terug naar het <a href="[_1]">oorspronkelijke bericht</a>.',
	'Migrating permission records to new structure...' => 'Permissies worden gemigreerd naar de nieuwe structuur...',
	'Migrating role records to new structure...' => 'Rollen worden gemigreerd naar de nieuwe structuur',
	'Migrating system level permissions to new structure...' => 'Systeempermissies worden gemigreerd naar de nieuwe structuur...',
	'Updating system search template records...' => 'Systeemzoeksjablonen worden bijgewerkt...',
	'Renaming PHP plugin file names...' => 'PHP plugin bestandsnamen aan het aanpassen...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Fout bij het aanpassen van de bestandsnamen van PHP bestanden.  Kijk in het activiteitenlog voor details.',
	'Cannot rename in [_1]: [_2].' => 'Kan naam niet aanpassen in [_1]: [_2]',
	'Migrating Nofollow plugin settings...' => 'Nofollow plugin instellingen worden gemigreerd',
	'Comment Response' => 'Bevestiging reactie',
	'Removing unnecessary indexes...' => 'Onnodige indexen worden verwijderd...',
	'Moving metadata storage for categories...' => 'Metadata opslag voor categoriën wordt verplaatst...',
	'Upgrading metadata storage for [_1]' => 'Metadata opslag voor [_1] wordt bijgewerkt',
	'Assigning entry comment and TrackBack counts...' => 'Tellingen aantal reacties en TrackBacks bericht aan het toekennen...',
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
	'Website Administrator' => 'Websitebeheerder',
	'Can administer the website.' => 'Kan de website beheren',
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
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Technorati update-ping service aan het verwijderen van [_1] (ID:[_2]).',
	'Recovering type of author...' => 'Type auteur wordt opgehaald...',
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
	'Adding "Site stats" dashboard widget...' => 'Bezig "Sitestatistieken" dashboard widget te migreren...',
	'Reordering dashboard widgets...' => 'Bezig dashboardwidgets te herschikken...',
	'Rebuilding permission records...' => 'Bezig permissierecords opnieuw aan te maken...',

## lib/MT/Upgrade/v7.pm
	'Create new role: [_1]...' => 'Nieuwe rol aanmaken: [_1]...',
	'change [_1] to [_2]' => 'wijzig [_1] naar [_2]',
	'Assign a Site Administrator Role for Manage Website...' => 'Ken een Site Administrator rol toe aen een websitebeheerder',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Ken een Site Administrator rol toe aan een websitebeheerder met blogs...',
	'add administer_site permission for Blog Administrator...' => 'voeg admininister_site permissie toe aan Blog Administrator...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Bezig de Subsite Administrator rol te veranderen aan de Site Administrator rol.',
	'Child Site Administrator' => 'Subsite Administrator',
	'Rebuilding object categories...' => 'Bezig objectcategoriën opnieuw op te bouwen...',
	'Error removing records: [_1]' => 'Fout bij verwijderen records: [_1]',
	'Error saving record: [_1]' => 'Fout bij oplsaan record: [_1]',
	'Rebuilding object tags...' => 'Bezig objecttags opnieuw op te bouwen...',
	'Rebuilding object assets...' => 'Bezig objectmediabestanden opnieuw op te bouwen...',
	'Rebuilding content field permissions...' => 'Bezig permissies voor inhoudsvelden opnieuw op te bouwen...',
	'Create a new role for creating a child site...' => 'Bezig nieuwe rol aan te maken om subsites aan te maken...',
	'Migrating create child site permissions...' => 'Bezig permissies te migreren om subsites aan te maken...',
	'Migrating MultiBlog settings...' => 'Bezig met migratie MultiBlog instellingen...',
	'Migrating fields column of MT::ContentType...' => 'Bezig met migratie van fields kolom van MT::ContentType...',
	'Migrating data column of MT::ContentData...' => 'Bezig met migratie van data kolom van MT::ContentData...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van number veld...',
	'Error removing record (ID:[_1]): [_2].' => 'Fout bij verwijderen record (ID:[_1]): [_2].',
	'Error saving record (ID:[_1]): [_2].' => 'Fout bij opslaan record (ID:[_1]): [_2].',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van multi_line_text veld...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van tables veld...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van embedded_text veld...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van url veld...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Bezig met opnieuw opbouwen van MT::ContentFieldIndex van single_line_text veld...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Bezig MT::Permission records opnieuw op te bouwen (verwijdering van edit_categories)...',
	'Cleaning up content field indexes...' => 'Bezig content field indexes op te schonen...',
	'Cleaning up objectasset records for content data...' => 'Bezig objectasset records voor inhoudsgegevens op te schonen...',
	'Cleaning up objectcategory records for content data...' => 'Bezig objectcategory records voor inhoudsgegevens op te schonen...',
	'Cleaning up objecttag records for content data...' => 'Bezig objecttag records voor inhoudsgegevesn op te schonen...',
	'Truncating values of value_varchar column...' => 'Bezig waarden van value_varchar kolom in te korten...',
	'Migrating Max Length option of Single Line Text fields...' => 'Bezig de opties voor maximale lengte van enkellijnstekstvelden te migreren...',
	'Reset default dashboard widgets...' => 'Standaard dashboard widgets terugzetten...',
	'Rebuilding Content Type count of Category Sets...' => 'Bezig telling van inhoudstypes van categoriesets opnieuw te publiceren...', # Translate - New
	'Adding site list dashboard widget for mobile...' => '', # Translate - New

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Type moet worden opgegeven',
	'Registry could not be loaded' => 'Registry kon niet worden geladen',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Type moet tgz zijn.',
	'Could not read from filehandle.' => 'Kon filehandle niet lezen.',
	'File [_1] is not a tgz file.' => 'Bestand [_1] is geen tgz bestand.',
	'File [_1] exists; could not overwrite.' => 'Bestand [_1] bestaat; kon niet worden overschreven.',
	'[_1] in the archive is not a regular file' => '[_1] in het archief is geen gewoon bestand', # Translate - New
	'[_1] in the archive is an absolute path' => '[_1] in het archief is een absoluut pad', # Translate - New
	'[_1] in the archive contains ..' => '[_1] in het archief bevat ..', # Translate - New
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

## lib/MT/Util/Log.pm
	'Unknown Logger Level: [_1]' => 'Onbekend logniveau: [_1]',
	'Invalid Log module' => 'Ongeldige logmodule',
	'Cannot load Log module: [_1]' => 'Kan logmodule niet laden: [_1]',

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

## lib/MT/Util/YAML.pm
	'Invalid YAML module' => 'Ongeldige YAML module',
	'Cannot load YAML module: [_1]' => 'Kan YAML module niet laden:',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Hetzelfde archiefbestand bestaat al. U moet de basisnaam of het archiefpad wijzigen. ([_1])',
	'Blog, BlogID or Template param must be specified.' => 'Blog, BlogID of Template parameter moet opgegeven zijn.',
	'Template \'[_1]\' does not have an Output File.' => 'Sjabloon \'[_1]\' heeft geen uitvoerbestand.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Er deed zich een fout voor bij het publiceren van van geplande berichten: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Er deed zich een fout voor bij het ongedaan maken van de publicatie van oude berichten: [_1]',

## lib/MT/Website.pm
	'First Website' => 'Eerste website',
	'Child Site Count' => 'Aantal subsites',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'Achtergrondpublicatie voltooid',
	'Published: [_1]' => 'Gepubliceerd:',
	'Error rebuilding file [_1]:[_2]' => 'Fout bij rebuilden bestand [_1]: [_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- set afgerond ([quant,_1,bestand,bestanden] in [_2] seconden)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "Fout bij het rsyncen van bestanden in [_1]:
",
	'Done Synchronizing Files' => 'Synchroniseren bestanden voltooid',
	'Done syncing files to [_1] ([_2])' => 'Klaar met synchroniseren van bestanden naar [_1] ([_2])',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ongeldig timestamp formaat',
	'No web services password assigned.  Please see your user profile to set it.' => 'Geen web services wachtwoord ingesteld.  Ga naar uw gebruikersprofiel om het in te stellen.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Gevraagde permalink \'[_1]\' is niet beschikbaar voor deze pagina',
	'Saving folder failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'No blog_id' => 'Geen blog_id',
	'Invalid login' => 'Ongeldige gebruikersnaam',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Waarde voor \'mt_[_1]\' moet 0 of 1 zijn (was \'[_2]\')',
	'No entry_id' => 'Geen entry_id',
	'Invalid entry ID \'[_1]\'' => 'Ongeldig entry ID \'[_1]\'',
	'Not allowed to edit entry' => 'Geen toestemming om bericht te bewerken',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Bericht \'[_1]\' ([lc,_5] #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) via xml-rpc',
	'Not allowed to get entry' => 'Geen toestemming om het bericht op te halen',
	'Not allowed to set entry categories' => 'Geen toestemming om de categorieën van het bericht in te stellen',
	'Publishing failed: [_1]' => 'Publicatie mislukt: [_1]',
	'Not allowed to upload files' => 'Geen toestemming om bestanden te uploaden',
	'No filename provided' => 'Geen bestandsnaam opgegeven',
	'Error writing uploaded file: [_1]' => 'Fout bij het schrijven van opgeladen bestand: [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Perl module Image::Size is nodig om de breedte en hoogte van opgeladen afbeeldingen te bepalen.',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Sjabloonmethodes zijn niet geïmplementeerd wegens het verschil tussen de Blogger API en de Movable Type API.',

## mt-static/addons/Cloud.pack/js/cfg_config_directives.js
	'A configuration directive is required.' => 'Er is een configuratiedirectief vereist.', # Translate - New
	'[_1] cannot be updated.' => '[_1] kan niet bijgewerkt worden', # Translate - New
	'Although [_1] can be updated by Movable Type, it cannot be updated on this screen.' => 'Hoewel Movable Type [_1] kan bijwerken, kan dit niet via dit scherm.', # Translate - New
	'[_1] already exists.' => '[_1] bestaat al.', # Translate - New
	'A configuration value is required.' => 'Een waarde voor deze instelling is nodig.', # Translate - New
	'The HASH type configuration directive should be in the format of "key=value"' => 'Een configuratiedirectief van het type HASH moet volgend formaat hebben "sleutel=waarde"', # Translate - New
	'[_1] for [_2] already exists.' => '[_1] voor [_2] bestaat al.', # Translate - New
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',
	'Are you sure you want to remove [_1]?' => 'Bent u zeker dat u [_1] wenst te verwijderen?', # Translate - New
	'configuration directive' => 'configuratiedirectief', # Translate - New

## mt-static/addons/Cloud.pack/js/cms.js
	'Continue' => 'Doorgaan',
	'You have unsaved changes to this page that will be lost.' => 'U heeft niet opgeslagen veranderingen op deze pagina die verloren zullen geen.',

## mt-static/addons/Sync.pack/js/cms.js

## mt-static/chart-api/deps/raphael-min.js
	'+e.x+' => '+e.x+',

## mt-static/chart-api/mtchart.js

## mt-static/chart-api/mtchart.min.js

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Ongeldige waarde',
	'You have an error in your input.' => 'Er staat een fout in uw invoer.',
	'Options less than or equal to [_1] must be selected' => 'Opties kleiner dan of gelijk aan [_1] moeten geselecteerd worden',
	'Options greater than or equal to [_1] must be selected' => 'Opties groter dan of gelijk aan [_1] moeten geselecteerd worden',
	'Please select one of these options' => 'Gelieve één van deze opties te selecteren',
	'Only 1 option can be selected' => 'Slechts één optie kan worden geselecteerd',
	'Invalid date format' => 'Ongeldig datumformaat',
	'Invalid time format' => 'Ongeldig tijdsformaat',
	'Invalid URL' => 'Ongeldige URL',
	'This field is required' => 'Dit veld is verplicht',
	'This field must be an integer' => 'Dit veld moet een integer bevatten',
	'This field must be a signed integer' => 'Dit veld moet een signed integer zijn',
	'This field must be a number' => 'Dit veld moet een getal bevatten',
	'This field must be a signed number' => 'Dit veld moet een postitief of negatief getal bevatten',
	'Please input [_1] characters or more' => 'Gelieve [_1] of meer karakters in te voeren',

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Geen voorbeeld beschikbaar',
	'Dimensions' => 'Dimensies',
	'File Name' => 'Bestandsnaam',

## mt-static/js/cms.js

## mt-static/js/contenttype/contenttype.js

## mt-static/js/contenttype/tag/content-fields.tag
	'Data Label Field' => 'Datalabel veld',
	'Show input field to enter data label' => 'Invoerveld tonen om datalabel in te vullen',
	'Unique ID' => 'Unieke ID',
	'Allow users to change the display and sort of fields by display option' => 'Gebruikers toestaan om de volgorde en weergave van velden te veranderen via de weergaveopties',
	'close' => 'Sluiten',
	'Drag and drop area' => 'Klik-en-sleep gebied',
	'Please add a content field.' => 'Gelieve een inhoudsveld toe te voegen.',

## mt-static/js/contenttype/tag/content-field.tag
	'Move' => 'Verplaats',
	'ContentField' => 'ContentField',

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
	'+e(n.x,r)++e(n.y,r)+' => '+e(n.x,r)++e(n.y,r)+',
	',i(r.textLeft,2)," ",i(r.textTop,2),' => ',i(r.textLeft,2)," ",i(r.textTop,2),',

## mt-static/js/listing/list_data.js
	'[_1] - Filter [_2]' => '[_1] - Filter [_2]',

## mt-static/js/listing/listing.js
	'act upon' => 'actie uitvoeren op',
	'You did not select any [_1] to [_2].' => 'U selecteerde geen [_1] om te [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren om minimaal [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren op maximum [_1] [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Opgelet: [_1] echt [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Bent u zeker dat u deze [_1] geselecteerde [_2] wenst te [_3]?',
	'Label "[_1]" is already in use.' => 'Label "[_1]" is al in gebruik',
	'Are you sure you want to remove filter \'[_1]\'?' => 'Bent u zeker dat u de filter \'[_1]\' wenst te verwijderen?',

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'Show' => 'Tonen',
	'25 rows' => '25 rijen',
	'50 rows' => '50 rijen',
	'100 rows' => '100 rijen',
	'200 rows' => '2000 rijen',

## mt-static/js/listing/tag/display-options.tag
	'Reset defaults' => 'Standaardinstellingen terugzetten',
	'Column' => 'Kolom',
	'User Display Option is disabled now.' => 'Gebruikersweergaveopties zijn nu uitgeschakeld',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Select action' => 'Selecteer actie', # Translate - New
	'Plugin Actions' => 'Plugin-mogelijkheden',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Meer mogelijkheden...',

## mt-static/js/listing/tag/list-actions.tag

## mt-static/js/listing/tag/list-filter.tag
	'Filter:' => 'Filter:',
	'Reset Filter' => 'Filter leegmaken',
	'Select Filter Item...' => 'Selecteer filteritem',
	'Add' => 'Toevoegen',
	'Select Filter' => 'Selecteer filter',
	'My Filters' => 'Mijn filters',
	'rename' => 'naam wijzigen',
	'Create New' => 'Nieuwe aanmaken',
	'Built in Filters' => 'Ingebouwde filters',
	'Apply' => 'Toepassen',
	'Save As' => 'Opslaan als',
	'Filter Label' => 'Filterlabel',

## mt-static/js/listing/tag/list-pagination-for-mobile.tag

## mt-static/js/listing/tag/list-pagination-for-pc.tag

## mt-static/js/listing/tag/list-table.tag
	'Loading...' => 'Laden...',
	'Select All' => 'Alles selecteren',
	'All' => 'Alle', # Translate - Case
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] van [_3]',
	'Select all [_1] items' => 'Selecteer alle [_1] items',
	'All [_1] items are selected' => 'Alle [_1] items zijn geselecteerd',
	'Select' => 'Selecteren',

## mt-static/js/mt/util.js
	'You did not select any [_1] [_2].' => 'U selecteerde geen [_1] [_2]',
	'delete' => 'verwijderen',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Bent u zeker dat u deze rol wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rol geassocieerd zijn.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Bent u zeker dat u deze [_1] rollen wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rollen geassocieerd zijn.',
	'You must select an action.' => 'U moet een handeling selecteren',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titel:',
	'Description:' => 'Beschrijving:',
	'Author:' => 'Auteur:',
	'Tags:' => 'Tags:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a valid path.' => 'U moet een geldig pad instellen.',
	'You must set a path beginning with %s or %a.' => 'U moet een pad instellen dat begint met %s of %a.',

## mt-static/mt.js
	'remove' => 'verwijderen',
	'enable' => 'activeren',
	'disable' => 'desactiveren',
	'publish' => 'publiceren',
	'unlock' => 'deblokkeren',
	'to mark as spam' => 'om als spam aan te merken',
	'to remove spam status' => 'om spamstatus van te verwijderen',
	'Enter email address:' => 'Voer e-mail adres in:',
	'Enter URL:' => 'Voer URL in:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen over alle weblogs?',
	'Same name tag already exists.' => 'Zelfde naamtag bestaat al.',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1] blok bewerken',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Insluitcode',
	'Please enter the embed code here.' => 'Gelieve de insluitcode hier in te geven.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Hoofding',
	'Heading Level' => 'Hoofdingsniveau',
	'Please enter the Header Text here.' => 'Vul hier de tekst voor de hoofding in.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Horizontale lijn',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Tekst',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Selecteer een blok',

## mt-static/plugins/BlockEditor/lib/js/modal_window.js

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Standaardtekst invoegen',

## mt-static/plugins/Loupe/js/vendor.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'U heeft niet opgeslagen wijzigingen.  Bent u zeker dat u weg wenst te navigeren?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'waarde',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%Y-%m-%d' => '%Y-%m-%d',
	'%H:%M:%S' => '%H:%M:%S',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Volledig scherm',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Class Name' => 'naam klasse',
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
	'Insert Link' => 'Link invoegen',
	'Insert HTML' => 'HTML invoegen',
	'Insert Image Asset' => 'Afbeeldingsbestand invoegen',
	'Insert Asset Link' => 'Bestandslink invoegen',
	'Toggle Fullscreen Mode' => 'Volledig scherm in/uitschakelen',
	'Toggle HTML Edit Mode' => 'HTML modus in/uitschakelen',
	'Strong Emphasis' => 'Sterke nadruk',
	'Emphasis' => 'Nadruk',
	'List Item' => 'Lijstelement',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/plugin.min.js
	'Paste is now in plain text mode. Contents will now be pasted as plain text until you toggle this option off.' => 'Plakken staat nu in enkel tekst modus.  Inhoud zal nu worden geplakt als gewone tekst zonder opmaak tot u deze optie uitschakelt.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.js
	'Error: Form submit field collision.' => 'Fout: botsing bij indienen formulierveld',
	'Error: No form element found.' => 'Fout: geen formulierelement gevonden.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.js
	'Server response wasn\'t proper JSON.' => 'Antwoord van de server was geen geldige JSON.',
	'The spelling service was not found: (' => 'De spellingsservice werd niet gevonden:',
	')' => ')',
	'No misspellings found.' => 'Geen spelfouten gevonden.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.js
	'No templates defined.' => 'Geen sjablonen gedefiniëerd.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/textcolor/plugin.js
	'No color' => 'Geen kleur',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.js
	'Table of Contents' => 'Inhoudstafel',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.js
	'Image uploading...' => 'Afbeelding uploaden...',

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.min.js
	'Your browser doesn\'t support direct access to the clipboard. Please use the Ctrl+X/C/V keyboard shortcuts instead.' => 'Uw browser ondertsteunt geen rechtstreekse toegang tot het klembord.  Gelieve in de plaats hiervan de Ctrl+X/C/V toetsenbordcombinaties te gebruiken.',
	'Rich Text Area. Press ALT-F9 for menu. Press ALT-F10 for toolbar. Press ALT-0 for help' => 'Veld met verrijkte tekstweergave. Druk ALT-F9 voor het menu.  Druk ALT-F10 voor gereedschapsbalk.  Druk ALT-0 voor hulp',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] reageerde op <a href="[_2]">reactie van [_3]</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Details reactie',

## themes/classic_blog/templates/comment_preview.mtml
	'Previewing your Comment' => 'U ziet een voorbeeld van uw reactie',
	'Leave a comment' => 'Laat een reactie achter',
	'Replying to comment from [_1]' => 'Antwoord op reactie van [_1]',
	'(You may use HTML tags for style)' => '(u kunt HTML tags gebruiken voor de lay-out)',
	'Submit' => 'Invoeren',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'Uw reactie werd ontvangen!',
	'Your comment submission failed for the following reasons: [_1]' => 'Het indienen van uw reactie mislukte wegens deze redenen: [_1]',

## themes/classic_blog/templates/comments.mtml
	'The data is modified by the paginate script' => 'De gegevens zijn aangepast door het paginatiescript',
	'Remember personal info?' => 'Persoonijke gegevens onthouden?',

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
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="volledige reactie op: [_4]">meer lezen</a>',

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'TrackBack URL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> van [_3] op <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Meer lezen</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Traditioneel, klassiek blogdesign, met een ruime selectie aan stijlen en keuze tussen 2 en 3 koloms layout.  Geschikt voor standaard blogpublicatietoepassingen.',
	'Improved listing of comments.' => 'Verbeterde weergave van reacties.',
	'Displays preview of comment.' => 'Toont voorbeeld van reactie.',
	'Displays error, pending or confirmation message for comments.' => 'Toont foutboodschappen, bevestigingen en \'even geduld\' berichten voor reacties.',
	'Displays results of a search for content data.' => 'Toont resultaten van een zoekopdracht naar inhoudsgegevens.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze website.',
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze website.',

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
	q{Subscribe to this website's feed} => q{Inschrijven op de feed van deze website},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Maak een blogportaal dat de inhoud van verschillende blogs samenbrengt in één website.',
	'Classic Website' => 'Klassieke website',

## themes/eiger/templates/banner_footer.mtml
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

## themes/mont-blanc/theme.yaml
	'__DESCRIPTION' => '"Rainier" is een aanpasbaar Responsive Web Design thema, ontworpen voor blogs.  Naast ondersteuning voor weergave op meerdere toestellen via Media Query (CSS) biedt het ook Movable Type functies aan om makkelijk navigatie- en afbeeldingselementen zoals logos en hoofdingen aan te passen',
	'Mont-Blanc' => 'Mont-Blanc',
	'Summary' => 'Samenvatting',
	'og:image' => 'og:image',

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

## search_templates/content_data_default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'ZOEKFEED AUTODISCOVERY LINK DIE ENKEL GEPUBLICEERD WORDT ALS EEN ZOEKOPDRACHT IS UITGEVOERD',
	'Site Search Results' => 'Zoekresultaten site',
	'Site search' => 'Site doorzoeken',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'GEWONE ZOEKOPDRACHTEN KRIJGEN HET ZOEKFORMULIER TE ZIEN',
	'Search this site' => 'Deze website doorzoeken',
	'SEARCH RESULTS DISPLAY' => 'ZOEKRESULTATENSCHERM',
	'Matching content data from [_1]' => 'Overeenkomende inhoudsgegevens van [_1]',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publiceerde <MTIfNonEmpty tag="ContentAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	'Showing the first [_1] results.' => 'De eerste [_1] resultaten worden getoond.',
	'NO RESULTS FOUND MESSAGE' => 'GEEN RESULTATEN GEVONDEN BOODSCHAP',
	q{Content Data matching '[_1]'} => q{Inhoudsgegevens die overeen komen met '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Inhoudsgegevens getagd met '[_1]'},
	q{No pages were found containing '[_1]'.} => q{Er werden geen berichten gevonden met '[_1]' in.},
	'END OF ALPHA SEARCH RESULTS DIV' => 'EINDE VAN ALPHA ZOEKRESULTATEN DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGIN VAN BETA ZIJKOLOM OM ZOEKINFORMATIE IN TE TONEN',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'STEL VARIABELEN IN VOOR ZOEK vs TAG informatie',
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Als u een RSS lezer gebruikt dan kunt u inschrijven op een feed met alle inhoudsgegevens die in de toekomst getagd worden met '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Als u een RSS lezer gebruikt dan kunt u inschrijven op een feed met alle inhoudsgegevens die in de toekomst overeen komen met '[_1]'},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ZOEK/TAG FEED INSCHRIJVINGSINFORMATIE',
	'Feed Subscription' => 'Feed inschrijving',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Wat is dit?',
	'END OF PAGE BODY' => 'EINDE VAN PAGINA BODY',
	'END OF CONTAINER' => 'EINDE VAN CONTAINER',

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Zoekresultaten voor [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Blog zoekresultaten',
	'Blog search' => 'Blog doorzoeken',
	'Match case' => 'Kapitalisering moet overeen komen',
	'Regex search' => 'Zoeken met reguliere expressies',
	'Matching entries from [_1]' => 'Gevonden berichten op [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Berichten op [_1] getagd met '[_2]'},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Gepubliceerd <MTIfNonEmpty tag="EntryAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	q{Entries matching '[_1]'} => q{Berichten met '[_1]' in},
	q{Entries tagged with '[_1]'} => q{Berichten getagd met '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met de tag '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met '[_1]' in.},
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG OPSOMMING ENKEL VOOR TAG ZOEKEN',
	'Other Tags' => 'Andere tags',

## search_templates/results_feed_rss2.tmpl

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Nieuw mediabestand uploaden',

## tmpl/cms/asset_upload.tmpl

## tmpl/cms/backup.tmpl
	'What to Export' => 'Wat te exporteren',
	'Everything' => 'Alles',
	'Reset' => 'Leegmaken',
	'Choose sites...' => 'Sites kiezen...',
	'Archive Format' => 'Archiefformaat',
	q{Don't compress} => q{Niet comprimeren},
	'Target File Size' => 'Grootte doelbestand',
	'No size limit' => 'Geen beperking op bestandsgrootte',
	'Export (e)' => 'Export (e)',

## tmpl/cms/cfg_entry.tmpl
	'Your preferences have been saved.' => 'Uw voorkeuren zijn opgeslagen',
	'Publishing Defaults' => 'Standaardinstellingen publicatie',
	'Listing Default' => 'Standaard lijstweergave',
	'Days' => 'Dagen',
	'Posts' => 'Berichten',
	'Order' => 'Volgorde',
	'Ascending' => 'Oplopend',
	'Descending' => 'Aflopend',
	'Excerpt Length' => 'Lengte uittreksel',
	'Date Language' => 'Datumtaal',
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
	'Compose Defaults' => 'Instellingen voor opstellen',
	'Unpublished' => 'Ongepubliceerd',
	'Text Formatting' => 'Tekstopmaak',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Bepaalt de standaard tekstopmaak voor het aanmaken van een nieuw bericht.',
	'Setting Ignored' => 'Instelling genegeerd',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de subsite of in heel het systeem.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de site of in heel het systeem.',
	'Accept TrackBacks' => 'TrackBacks aanvaarden',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat trackbacks uitgeschakeld zijn ofwel voor de subsite of in heel het systeem.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties uitgeschakeld zijn ofwel voor de site of in heel het systeem.',
	'Entry Fields' => 'Berichtvelden',
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
	'Spam Settings' => 'Spaminstellingen',
	'Automatic Deletion' => 'Automatisch verwijderen',
	'Automatically delete spam feedback after the time period shown below.' => 'Spam feedback automatisch verwijderen na de tijdsduur die hieronder staat.',
	'Delete Spam After' => 'Spam verwijderen na',
	'days' => 'dagen',
	'Spam Score Threshold' => 'Spamscoredrempel',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Deze waarde kan tussen de -10 en +10 liggen.  Hoe groter de waarde is, hoe groter de kans dat het spamdetectie framework een reactie of trackback als spam zal aanmerken.',
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
	'No one' => 'Niemand',
	'Trusted commenters only' => 'Enkel vertrouwde reageerders',
	'Any authenticated commenters' => 'Elke geauthenticeerde reageerder',
	'Anyone' => 'Iedereen',
	'Allow HTML' => 'HTML toestaan',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Laat reageerders een beperkte set HTML tags gebruiken in hun reacties.  Alle andere HTML zal worden verwijderd.',
	'Limit HTML Tags' => 'HTML tags beperken',
	'Use defaults' => 'Standaardwaarden gebruiken',
	'([_1])' => '([_1])',
	'Use my settings' => 'Mijn instellingen gebruiken',
	'E-mail Notification' => 'E-mail notificatie',
	'On' => 'Aan',
	'Only when attention is required' => 'Alleen wanneer er aandacht is vereist',
	'Off' => 'Uit',
	'Comment Display Settings' => 'Weergave-instellingen reacties',
	'Comment Order' => 'Volgorde reacties',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u reacties wenst te tonen in opgaande (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
	q{Auto-Link URLs} => q{Automatisch URL's omzetten in links},
	'Transform URLs in comment text into HTML links.' => 'URLs in reacties transformeren in HTML links.',
	'CAPTCHA Provider' => 'CAPTCHA dienstverlener',
	'No CAPTCHA provider available' => 'Geen CAPTCHA provider beschikbaar',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Geen CAPTCHA provider beschikbaar in dit systeem.  Gelieve te controleren of Image::Magick geïnstalleerd is en of de CaptchaSourceImageBase configuratiedirectief naar een geldige captcha-source map verwijst in de 'mt-static/images' map.},
	'Use Comment Confirmation Page' => 'Pagina voor bevestigen reacties gebruiken',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{De browser van elke reageerder zal worden doorgestuurd naar een bevestigingspagina nadat hun reactie werd geaccepteerd.},
	'Trackback Settings' => 'TrackBack instellingen',
	'Note: TrackBacks are currently disabled at the system level.' => 'Opmerking: TrackBacks zijn momenteel uitgeschakeld op systeemniveau.',
	'Accept TrackBacks from any source.' => 'TrackBacks accepteren uit elke bron',
	'TrackBack Policy' => 'TrackBack beleid',
	'Moderation' => 'Moderatie',
	'Hold all TrackBacks for approval before they are published.' => 'Alle TrackBacks modereren voor ze gepubliceerd worden.',
	'TrackBack Options' => 'TrackBack opties',
	'TrackBack Auto-Discovery' => 'Automatisch TrackBacks ontdekken',
	'Enable External TrackBack Auto-Discovery' => 'Externe automatische TrackBack-ontdekking inschakelen',
	'Setting Notice' => 'Opmerking bij deze instelling',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Noot: deze optie kan beïnvloed worden op systeemniveau omdat uitgaande pings daar beperkt kunnen worden.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Noot: deze optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau zijn uitgeschakeld.',
	'Enable Internal TrackBack Auto-Discovery' => 'Interne automatische TrackBack-ontdekking inschakelen',

## tmpl/cms/cfg_plugin.tmpl
	'Plugin System' => 'Plugin systeem',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Plugin functionaliteit in- of uitschakelen voor de hele Movable Type installatie.',
	'Disable plugin functionality' => 'Plugin functionaliteit uitschakelen',
	'Disable Plugins' => 'Plugins uitschakelen',
	'Enable plugin functionality' => 'Plugin functionaliteit inschakelen',
	'Enable Plugins' => 'Plugins inschakelen',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
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
	'Failed to load' => 'Laden mislukt',
	'Failed to Load' => 'Laden mislukt',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Deze plugin is niet bijgewerkt om Movable Type [_1] te ondersteunen.  Om die reden kan het zijn dat hij niet helemaal werkt.',
	'Plugin error:' => 'Pluginfout:',
	'Info' => 'Info',
	'Resources' => 'Bronnen',
	'Run [_1]' => '[_1] uitvoeren',
	'Documentation for [_1]' => 'Documentatie voor [_1]',
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
	'Time Zone' => 'Tijdzone',
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
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Universeel Gecoï¾ƒÎ´ï½¶rdineerde Tijd)',
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
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Aleutianen-Hawaõ‚‡©anse tijd)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Nome tijd)',
	'Language' => 'Taal',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Als u een andere taal kiest dan de standaard taal die op systeemniveau staat ingesteld, dan moet u mogelijk de namen van bepaalde modules aanpassen in bepaalde sjablonen om andere globale modules te kunnen includeren.',
	'License' => 'Licentie',
	'Your child site is currently licensed under:' => 'Uw subsite heeft momenteel volgende licentie:',
	'Your site is currently licensed under:' => 'Uw site heeft momenteel volgende licentie:',
	'Change license' => 'Licentie aanpassen',
	'Remove license' => 'Licentie verwijderen',
	'Your child site does not have an explicit Creative Commons license.' => 'Uw subsite heeft geen expliciete Creative Commons licentie.',
	'Your site does not have an explicit Creative Commons license.' => 'Uw site heeft geen expliciete Creative Commons licentie.',
	'Select a license' => 'Selecteer een licentie',
	'Publishing Paths' => 'Publicatiepaden',
	'Use subdomain' => 'Subdomein gebruiken',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => 'Waarschuwing: de [_1] URL aanpassen kan er toe leiden dat alle links in uw [_1] niet meer werken.',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{De URL van uw subsite.  Laat de bestandsnaam weg (m.a.w. index.html). Sluit af met '/'. Voorbeeld: http://www.voorbeeld.com/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{De URL van uw site.  Laat de bestandsnaam weg (m.a.w. index.html). Sluit af met '/'. Voorbeeld: http://www.voorbeeld.com/},
	'Use absolute path' => 'Absoluut pad gebruiken',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Waarschuwing: de root van uw [_1] aanpassen vereist het volledig opnieuw publiceren van uw [_1].',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	'Advanced Archive Publishing' => 'Geavanceerde archiefpublicatie',
	'Publish archives outside of Site Root' => 'Archieven buiten de siteroot publiceren',
	'Archive URL' => 'Archief-URL',
	'Warning: Changing the archive URL can result in breaking all links in your [_1].' => 'Waarschuwing: de archief-URL veranderen kan resulteren in het breken van alle links in uw [_1].',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'De URL van de archiefsectie van uw subsite. Voorbeeld: http://www.voorbeeld.com/blog/archief/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'De URL van de archiefsectie van uw site. Voorbeeld: http://www.voorbeeld.com/archief/',
	'Archive Root' => 'Archiefroot',
	'Warning: Changing the archive path can result in breaking all links in your [_1].' => 'Waarschuwing: het archiefpad veranderen kan resulteren in het breken van alle links in uw [_1].',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden.  Gelieve niet af te sluiten met '/' of '\'. Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar de indexbestanden van uw archieven gepubliceerd zullen worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	'Dynamic Publishing Options' => 'Opties dynamische publicatie',
	'Enable dynamic cache' => 'Dynamische cache inschakelen',
	'Enable conditional retrieval' => 'Conditioneel ophalen mogelijk maken',
	'Archive Settings' => 'Archiefinstellingen',
	'Preferred Archive' => 'Voorkeursarchief',
	'Choose archive type' => 'Kies archieftype',
	'No archives are active' => 'Geen archieven actief',
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Wordt gebruikt om de URL's (permalinks) van de gearchiveerde berichten van deze subsite te genereren.  Kies één van de archieftypes die worden gebruikt in de archiefsjablonen van deze subsite.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Wordt gebruikt om de URL's (permalinks) van de gearchiveerde berichten van deze site te genereren.  Kies één van de archieftypes die worden gebruikt in de archiefsjablonen van deze site.},
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
	'Number of revisions per content data' => 'Aantal reviesies per inhoudsgegeven',
	'Number of revisions per template' => 'Aantal revisies per sjabloon',
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
	'You must set your Child Site Name.' => 'U moet de naam van uw subsite instellen.',
	'You must set your Site Name.' => 'U moet de naam van uw site instellen.',
	'You did not select a time zone.' => 'U selecteerde geen tijdzone',
	'You must set a valid URL.' => 'U moet een geldige URL instellen.',
	'You must set your Local file Path.' => 'U moet uw lokaal bestandspad instellen.',
	'You must set a valid Local file Path.' => 'U moet een geldig lokaal bestandspad instellen.',
	'Site root must be under [_1]' => 'Siteroot moet vallen onder [_1]',
	'You must set a valid Archive URL.' => 'U moet een geldige archief URL instellen.',
	'You must set your Local Archive Path.' => 'U moet uw lokaal archiefpad instellen.',
	'You must set a valid Local Archive Path.' => 'U moet een geldig lokaal archiefpad instellen.',

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Config Rebuild Trigger' => 'Configuratie rebuild trigger',
	'Rebuild Trigger settings has been saved.' => 'Instellingen rebuild trigger opgeslagen.',
	'Content Privacy' => 'Privacy inhoud',
	'Use system default' => 'Standaard systeeminstelling gebruiken',
	'Allow' => 'Toestaan',
	'Disallow' => 'Verbieden',
	'MTMultiBlog tag default arguments' => 'MTMultiBlog tag standaard argumenten',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Maakt het mogelijk om de MTMultiBlog tag te gebruiken zonder include_blogs/exclude_blogs attributen.  Toegestane waarden zijn BlogID's gescheden door komma's of 'all' (enkel bij include_blogs).},
	'Include sites/child sites' => 'Inclusief sites/subsites',
	'Exclude sites/child sites' => 'Exclusief sites/subsites',
	'Rebuild Triggers' => 'Rebuild-triggers',
	'You have not defined any rebuild triggers.' => 'U heeft nog geen rebuild-triggers gedefiniëerd',
	'When' => 'Wanneer',
	'Site/Child Site' => 'Site/subsite',
	'Data' => 'Data',
	'Trigger' => 'Trigger',
	'Action' => 'Actie',
	'Default system aggregation policy' => 'Standaard aggregatiebeleid voor het systeem',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard toegestaan zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te beperken.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Cross-blog aggregatie zal standaard verboden zijn.  Individuele blgos kunnen via de MultiBlog instellingen op blogniveau worden ingesteld om toegang tot hun inhoud voor andere blogs te verlenen.',

## tmpl/cms/cfg_registration.tmpl
	'Your site preferences have been saved.' => 'Voorkeuren site opgeslagen.',
	'User Registration' => 'Gebruikersregistratie',
	'Registration Not Enabled' => 'Registratie niet ingeschakeld',
	'Note: Registration is currently disabled at the system level.' => 'Opmerking: Registratie is momenteel uitgeschakeld op systeemniveau',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'Bezoekers toestaan zicht te registreren als lid van deze site met één van de authenticatiemethodes hieronder geselecteerd.',
	'New Created User' => 'Nieuw aangemaakte gebruiker',
	'Select a role that you want assigned to users that are created in the future.' => 'Selecteer een rol die u automatisch wenst toe te kennen aan gebruikers die in de toekomst worden aangemaakt.',
	'(No role selected)' => '(Geen rol geselecteerd)',
	'Select roles' => 'Selecteer rollen',
	'Authentication Methods' => 'Methodes voor authenticatie',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'De perl module die vereist is voor authenticatie van reageerders via OpenID (Digest::SHA1) ontbreekt.',
	'Please select authentication methods to accept comments.' => 'Gelieve een authenticatiemethode te selecteren om reacties te kunnen ontvangen.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Eén of meer perl modules om deze authenticatiemethode te kunnen gebruiken ontbreken mogelijk.',

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => 'Uw instellingen zijn opgeslagen.',
	'Imager does not support ImageQualityPng.' => 'Imager ondersteunt ImageQualityPng niet.',
	'A test mail was sent.' => 'Een testmail werd verstuurd',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Eén of meerdere van uw sites of subsites volgen de basispad restrictie (waarde van BaseSitePath) niet.',
	'System Email Address' => 'Systeememailadres',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Dit email adres word gebruikt in de 'From:' header van elke email die door Movable Type wordt verzonden.  Email kan verstuurd worden om een wachtwoord terug te krijgen, een reageerder te registreren, notificaties te verzenden van reacties of TrackBacks, blokkeringen van gebruikers of IP adressen en in nog een paar andere gevallen.},
	'Send Test Mail' => 'Testmail versturen',
	'Debug Mode' => 'Debug modus',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Waarden anders dan nul bieden bijkomende diagnostische informatie om problemen op te lossen met uw Movable Type installatie.  Meer informatie is beschikbaar in de <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentatie</a>.',
	'Performance Logging' => 'Performantielogging',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Loggen van performantie inschakelen, dit zal alle gebeurtenissen in het systeem rapporteren die langer duren dan het aantal seconden ingesteld in de logdrempel.',
	'Turn on performance logging' => 'Loggen van performantie inschakelen',
	'Log Path' => 'Logpad',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'De map in uw bestandssysteem waar performantielogs weggeschreven worden.  De webserver moet schrijfpermissies hebben in deze map.',
	'Logging Threshold' => 'Logdrempel',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Tijdslimiet voor niet gelogde gebeurtenissen, in seconden. Elke gebeurtenis die langer duurt dan deze hoeveelheid tijd zal worden gerapporteerd.',
	'Track revision history' => 'Revisiegeschiedenis bijhouden',
	'Site Path Limitation' => 'Sitepad beperking',
	'Base Site Path' => 'Basissitepad',
	'Allow sites to be placed only under this directory' => 'Accepteer enkel sites die in deze map geplaatst worden',
	'System-wide Feedback Controls' => 'Systeeminstellingen voor feedback',
	'Prohibit Comments' => 'Reacties verbieden',
	'Disable comments for all sites and child sites.' => 'Reacties uitschakelen voor alle sites en subsites.',
	'Prohibit TrackBacks' => 'Trackbacks verbieden',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Ontvangst van trackbacks uitschakelen voor alle sites en subsites.',
	'Outbound Notifications' => 'Uitgaande notificaties',
	'Prohibit Notification Pings' => 'Notificatiepings verbieden',
	'Disable notification pings for all sites and child sites.' => 'Notificaties uitschakelen voor alle sites en subsites.',
	'Send Outbound TrackBacks to' => 'Uitgaande TrackBacks sturen naar',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Verstuur geen uitgaande TrackBacks en maak geen gebruik van TrackBack auto-discovery als het de bedoeling is uw installatie privé te houden.',
	'(No Outbound TrackBacks)' => '(Geen uitgaande TrackBacks)',
	'Only to child sites within this system' => 'Enkel naar subsites in dit systeem',
	'Only to sites on the following domains:' => 'Enkel naar sites onder volgende domeinen:',
	'Lockout Settings' => 'Instellingen blokkering',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{De systeembeheerders die op de hoogte gebracht moeten worden als een gebruiker of IP adres geblokkeerd wordt.  Indien geen administrators geselecteerd zijn, worden de berichten naar eht 'Systeem e-mail adres' gestuurd.},
	'Clear' => 'Leegmaken',
	'(None selected)' => '(Geen geselecteerd)',
	'User lockout policy' => 'Beleid blokkering gebruikers',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'Een Movable Type gebruiker zal geblokkeerd worden als hij of zij [_1] (of meer) keer een fout wachtwoord invoert binnen [_2] seconden.',
	'IP address lockout policy' => 'Beleid blokkering IP adressen',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => 'De lijst met IP adressen.  Als een extern IP adres in deze lijst staat, dan zullen mislukte aanmeldpogingen niet worden geregistreerd.  Meerdere IP adressen kunnen worden opgegeven, van elkaar gescheiden met een komma of een nieuwe regel.',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => 'Een IP adres zal geblokkeerd worden als meer dan [_1] foutieve aanmeldpogingen worden ondernomen binnen de [_2] seconden vanop hetzelfde IP adres.',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Volgende IP adressen staan echter op de 'witte lijst' en zullen nooit geblokkeerd worden:},
	'Image Quality Settings' => 'Kwaliteitsinstellingen afbeelding',
	'Changing image quality' => 'Afbeeldingskwaliteit aan het aanpassen',
	'Enable image quality changing.' => 'Aanpassen afbeeldingskwaliteit inschakelen.',
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
	'Allow Registration' => 'Registratie toestaan',
	'Allow commenters to register on this system.' => 'Toestaan dat reageerders zich registreren op dit systeem.',
	'Notify the following system administrators when a commenter registers:' => 'De systeembeheerder op de hoogte brengen wanneer een reageerder zich registreert:',
	'Select system administrators' => 'Systeembeheerder kiezen',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Opmerking: systeem e-mail adres is niet ingesteld onder Systeem > Algemene Instellingen.  E-mails zullen niet worden verstuurd.',
	'Password Validation' => 'Validering wachtwoord',
	'Options' => 'Opties',
	'Should contain uppercase and lowercase letters.' => 'Moet hoofdletters en kleine letters bevatten',
	'Should contain letters and numbers.' => 'Moet letters en cijfers bevatten',
	'Should contain special characters.' => 'Moet speciale karakters bevatten',
	'Minimum Length' => 'Minimale lengte',
	'This field must be a positive integer.' => 'Dit veld moet een positief geheel getal zijn.',
	'New User Defaults' => 'Standaardinstellingen nieuwe gebruikers',
	'Default User Language' => 'Standaard taal',
	'Default Time Zone' => 'Standaard tijdzone',
	'Default Tag Delimiter' => 'Standaard tagscheidingsteken',
	'Comma' => 'Komma',
	'Space' => 'Spatie',

## tmpl/cms/cfg_web_services.tmpl
	'Data API Settings' => 'Data API instellingen',
	'Data API' => 'Data API',
	'Enable Data API in this site.' => 'Data API inschakelen voor deze site.',
	'Enable Data API in system scope.' => 'Data API inschakelen op systeemniveau.',
	'External Notifications' => 'Externe notificaties',
	'Notify ping services of [_1] updates' => 'Ping services op de hoogte brengen van [_1] updates',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => '
	Noot: deze optie wordt momenteel genegeerd omdat uitgaande notificatiepings zijn uitgeschakeld op systeemniveau.',
	'Others:' => 'Andere:',
	q{(Separate URLs with a carriage return.)} => q{(URL's van elkaar scheiden met een carriage return.)},

## tmpl/cms/content_data/select_edit.tmpl

## tmpl/cms/content_data/select_list.tmpl
	'Select List Content Type' => 'Selecteer lijst inhoudstype',
	'No Content Type.' => 'Geen inhoudstype.',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to select multiple assets?' => 'Gebruikers toestaan meerdere mediabestanden te selecteren?',
	'Minimum number of selections' => 'Minimum aantal selecties',
	'Maximum number of selections' => 'Maximum aantal selecties',
	'Allow users to upload a new audio asset?' => 'Gebruikers toestaan een nieuw audiobestand te uploaden?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => 'Gebruikers toestaan meerdere afbeeldingsbestanden te selecteren?',
	'Allow users to upload a new image asset?' => 'Gebruikers toestaan nieuwe afbeeldingsbestanden te uploaden?',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to upload a new asset?' => 'Gebruikers toestaan nieuwe mediabestanden te uploaden?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => 'Gebruikers toestaan meerdere videobestanden te selecteren?',
	'Allow users to upload a new video asset?' => 'Gebruikers toestaan nieuwe videobestanden te uploaden?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to select multiple categories?' => 'Gebruikers toestaan meerdere categorieën te selecteren?',
	'Allow users to create new categories?' => 'Gebruikers toestaan nieuwe categorieën aan te maken?',
	'Source Category Set' => 'Broncategorieset',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Values' => 'Waarden',
	'Selected' => 'Geselecteerd',
	'Value' => 'Waarde',
	'add' => 'toevoegen',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => 'Gebruikers toestaan meerdere waarden te selecteren?',
	'Source Content Type' => 'Broninhoudstype',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'Er is geen inhoudstype dat kan worden geselecteerd.  Gelieve een inhoudstype aan te maken als u het inhoudstype veldtype wenst te gebruiken.',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Beginwaarde (datum)',
	'Initial Value (Time)' => 'Beginwaarde (tijd)',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Beginwaarde',

## tmpl/cms/content_field_type_options/embedded_text.tmpl

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => 'Invoerformaat',

## tmpl/cms/content_field_type_options/number.tmpl
	'Min Value' => 'Min waarde',
	'Max Value' => 'Max waarde',
	'Number of decimal places' => 'Aantal decimalen',

## tmpl/cms/content_field_type_options/radio_button.tmpl

## tmpl/cms/content_field_type_options/select_box.tmpl

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Min Length' => 'Min lengte',
	'Max Length' => 'Max lengte',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Initial Rows' => 'Initiëel aantal rijen',
	'Initial Cols' => 'Initiëel aantal kolommen',
	'Allow users to increase/decrease rows?' => 'Gebruikers toestaan het aantal rijen te verhogen/verlagen?',
	'Allow users to increase/decrease cols?' => 'Gebruikers toestaan het aantal kolommen te verhogen/verlagen?',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to input multiple values?' => 'Gebruikers toestaan meerdere waarden in te voeren?',
	'Allow users to create new tags?' => 'Gebruikers toestaan om nieuwe tags aan te maken?',

## tmpl/cms/content_field_type_options/time.tmpl

## tmpl/cms/content_field_type_options/url.tmpl

## tmpl/cms/dashboard/dashboard.tmpl
	'System Overview' => 'Systeemoverzicht',
	'Dashboard' => 'Dashboard',
	'Select a Widget...' => 'Selecteer een widget...',
	'Your Dashboard has been updated.' => 'Uw dashboard is bijgewerkt.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Bevestig publicatieconfiguratie',
	'Site Path' => 'Sitepad',
	'Please choose parent site.' => 'Gelieve een hoofdsite te kiezen.',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Vul de nieuwe URL in van uw publieke subsite.  Eindig met '/'/. Voorbeeld: http://www.voorbeeld.com/blog/},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul het pad in waar het hoofdindexbestand van uw blog gepubliceerd zal worden. Een absoluut pad (beginnend met '/' voor Linux of 'C:' voor Windows) geniet de voorkeur. Gelieve niet af te sluiten met '/' of '\'. Voorbeeld /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul het nieuwe pad in waar uw hoofdindexbestanden zich zullen bevinden.  Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Vul de nieuwe URL in van de archiefsectie van uw subsite.  Voorbeeld: http://www.voorbeeld.com/blog/archieven/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Vul de nieuwe URL in van de archiefsectie van uw blog. Een absoluut pad (beginnend met '/' op Linux of 'C:' op Windows) verdient de voorkeur.  Sluit niet af met '/' of '\'. Voorbeeld: /home/mt/public_html of C:\www\public_html},
	'Continue (s)' => 'Doorgaan (s)',
	'Back (b)' => 'Terug (b)',
	'You must set a valid Site URL.' => 'U moet een geldige URL instellen voor uw site.',
	'You must set a valid local site path.' => 'U moet een geldig lokaal site-pad instellen.',
	'You must select a parent site.' => 'U moet een hoofdsite selecteren',

## tmpl/cms/dialog/asset_edit.tmpl
	'Edit Asset' => 'Mediabestand bewerken',
	'Your edited image has been saved.' => 'U bewerkte afbeelding werd opgeslagen.',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => 'De metadata kan niet worden bijgewerkt omdat de metadata van deze afbeelding fouten lijkt te bevatten.',
	'Error creating thumbnail file.' => 'Fout bij aanmaken thumbnailbestand.',
	'File Size' => 'Bestandsgrootte',
	'Edit Image' => 'Afbeelding bewerken',
	'Save changes to this asset (s)' => 'Wijzigingen aan dit mediabestand opslaan (s)',
	'Close (x)' => 'Sluiten (x)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u deze dialoog wenst te sluiten?',
	'Your changes have been saved.' => 'Uw wijzigingen zijn opgeslagen.',
	'An error occurred.' => 'Er deed zich een fout voor.',

## tmpl/cms/dialog/asset_field_insert.tmpl

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Mediabestanden toevoegen',
	'Choose Asset' => 'Mediabestanden kiezen',
	'Library' => 'Bibliotheek',
	'Next (s)' => 'Volgende (s)',
	'Insert (s)' => 'Invoegen (s)',
	'Insert' => 'Invoegen',
	'Cancel (x)' => 'Annuleren (x)',

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
	'Child Site Details' => 'Details subsite',
	'This is set to the same URL as the original child site.' => 'Dit wordt ingesteld als dezelfde URL als de oorspronkelijke subsite',
	'This will overwrite the original child site.' => 'Dit zal de oorspronkelijke subsite overschrijven',
	'Exclusions' => 'Uitzonderingen',
	q{Exclude Entries/Pages} => q{Berichten en pagina's uitsluiten},
	'Exclude Comments' => 'Reacties uitsluiten',
	'Exclude Trackbacks' => 'TrackBacks uitsluiten',
	'Exclude Categories/Folders' => 'Categorieën en mappen uitsluiten',
	'Clone' => 'Kloon',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => 'Waarschuwing: de archief URL veranderen kan er toe leiden dat alle links in uw subsite niet meer werken.',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Waarschuwing: het archiefpad veranderen kan er toe leiden dat alle links in uw subsite niet meer werken.',
	q{Entries/Pages} => q{Berichten/pagina's},
	'Categories/Folders' => 'Categorieën/mappen',
	'Confirm' => 'Bevestigen',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'Op [_1] reageerde [_2] op [_3]',
	'Your reply:' => 'Uw antwoord:',
	'Submit reply (s)' => 'Antwoord ingeven (s)',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => '[_1] toevoegen',
	'Choose [_1]' => 'Kies [_1]',
	'Create and Insert' => 'Aanmaken en invoegen',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'Er bestaan geen rollen in deze installatie.[_1]Maak een rol aan</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'Er bestaan geen groepen in deze installatie.[_1]Maak een groep aan</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'Er bestaan geen gebruikers in deze installatie.[_1]Maak een gebruiker aan</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'Er bestaan geen blogs in deze installatie.[_1]Maak een blog aan</a>',
	'all' => 'alle',

## tmpl/cms/dialog/create_trigger_select_site.tmpl

## tmpl/cms/dialog/create_trigger.tmpl
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'ALS <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> wordt <span class="badge source-trigger-badge">Getriggerd</span>, <span class="badge destination-action-badge">Actie</span> in <span class="badge destination-site-badge">Site</span>',
	'Select Trigger Object' => 'Selecteer triggerobject',
	'Object Name' => 'Objectnaam',
	'Select Trigger Event' => 'Selecteer triggergebeurtenis',
	'Event' => 'Gebeurtenis',
	'Select Trigger Action' => 'Selecteer triggeractie',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',

## tmpl/cms/dialog/dialog_select_group_user.tmpl

## tmpl/cms/dialog/edit_image.tmpl
	'Width' => 'Breedte',
	'Height' => 'Hoogte',
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
	'Display [_1]' => 'Geef [_1] weer',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Wachtwoord wijzigen',
	'Enter the new password.' => 'Vul het nieuwe wachtwoord in',
	'New Password' => 'Nieuw wachtwoord',
	'Confirm New Password' => 'Nieuw wachtwoord bevestigen',
	'Change' => 'Wijzig',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Publicatieprofiel',
	'child site' => 'subsite',
	'site' => 'site',
	'Choose the profile that best matches the requirements for this [_1].' => 'Kies het profiel dat het beste overeen komt met de vereisten voor deze [_1].',
	'Static Publishing' => 'Statisch publiceren',
	'Immediately publish all templates statically.' => 'Alle sjablonen onmiddellijk statisch publiceren',
	'Background Publishing' => 'Pubiceren in de achtergrond',
	'All templates published statically via Publish Queue.' => 'Alle sjablonen worden statisch gepubliceerd via de publicatiewachtrij.',
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
	'An error occurred during the import process: [_1] Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1] Gelieve het importbestand te controleren.',
	'View Activity Log (v)' => 'Activiteitenlog bekijken (v)',
	'All data imported successfully!' => 'Alle gegevens werden met succes geïmporteerd!',
	'Close (s)' => 'Sluiten (s)',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Deze pagina zal binnen drie seconden doorverwijzen naar een andere pagina. [_1]Stop de doorverwijzing[_2]',
	'Next Page' => 'Volgende pagina',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importeren...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Terugzetten: meerdere bestanden',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'De procedure nu stopzetten zal wees-objecten achterlaten.  Bent u zeker dat u de restore-operatie wenst te annuleren.',
	'Please upload the file [_1]' => 'Gelieve bestand [_1] te uploaden',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to user' => 'Geef site permissies aan gebruiker',
	'Grant site permission to group' => 'Geef site permissies aan groep',

## tmpl/cms/dialog/start_create_trigger.tmpl
	'You must select Object Type.' => 'U moet een objecttype kiezen.',
	'You must select Content Type.' => 'U moet een inhoudstype kiezen.',
	'You must select Event.' => 'U moet een gebeurtenis selecteren.',
	'Object Type' => 'Objecttype',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Stats' => 'Statistieken',
	'[_1] - Created by [_2]' => '[_1] - aangemaakt door [_2]',
	'[_1] - Modified by [_2]' => '[_1] - aangepast door [_2]',
	'Appears in...' => 'Komt voor in...',
	'This asset has been used by other users.' => 'Dit mediabestand werd ook gebruikt door andere gebruikers.',
	'Related Assets' => 'Gerelateerde mediabestanden',
	'Prev' => 'Vorige',
	'[_1] is missing' => '[_1] ontbreekt',
	'Embed Asset' => 'Mediabestand embedden',
	'You must specify a name for the asset.' => 'U moet een naam opgeven voor het mediabestand.',
	'You have unsaved changes to this asset that will be lost.' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Er zijn niet opgeslagen wijzigingen aan dit mediabestand die verloren zullen gaan.  Bent u zeker dat u de afbeelding wenst te bewerken?',

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
	'_USER_ENABLED' => 'Ingeschakeld',
	'_USER_PENDING' => 'Te keuren',
	'_USER_DISABLED' => 'Uitgeschakeld',
	'External user ID' => 'Extern user ID',
	'The name displayed when content from this user is published.' => 'De naam die getoond wordt wanneer inhoud van deze gebruiker wordt gepubliceerd.',
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{De website van deze gebruiker (m.a.w. http://www.mijnsite.com).  Als de website URL en getoonde naam velden allebei ingevuld zijn, dan zal Movable Type standaard berichten en reacties publiceren met onderschriften gelinkt naar deze URL.},
	'Select Userpic' => 'Selecteer foto gebruiker',
	'Remove Userpic' => 'Verwijder foto gebruiker',
	'Current Password' => 'Huidig wachtwoord',
	'Initial Password' => 'Initiëel wachtwoord',
	'Enter preferred password.' => 'Gekozen wachtwoord invoeren',
	'Confirm Password' => 'Wachtwoord bevestigen',
	'Password recovery word/phrase' => 'Woord/uitdrukking om wachtwoord terug te vinden',
	'Preferences' => 'Voorkeuren',
	'Display language for the Movable Type interface.' => 'Getoonde taal van de Movable Type interface.',
	'Text Format' => 'Tekstformaat',
	q{Default text formatting filter when creating new entries and new pages.} => q{Standaard tekstformatteringsfilter bij het aanmaken van berichten en pagina's},
	'(Use Site Default)' => '(Standaardinstelling site gebruiken)',
	'Date Format' => 'Datumformaat',
	'Default date formatting in the Movable Type interface.' => 'Standaard datumformattering in de Movable Type interface.',
	'Relative' => 'Relatief',
	'Full' => 'Volledig',
	'Tag Delimiter' => 'Scheidingsteken tags',
	'Preferred method of separating tags.' => 'Voorkeursmethode om tags van elkaar te scheiden',
	'Web Services Password' => 'Webservices wachtwoord',
	'Reveal' => 'Onthul',
	'System Permissions' => 'Systeempermissies',
	'Create User (s)' => 'Gebruiker aanmaken (s)',
	'Save changes to this author (s)' => 'Wijzigingen aan deze auteur opslaan (s)',
	'_USAGE_PASSWORD_RESET' => 'Hieronder kunt u een nieuw wachtwoord laten instellen voor deze gebruiker.  Als u ervoor kiest om dit te doen, zal een willekeurig gegenereerd wachtwoord worden aangemaakt en rechtstreeks naar volgend e-mail adres worden verstuurd: [_1].',
	'Initiate Password Recovery' => 'Procedure starten om wachtwoord terug te halen',
	'You must use half-width character for password.' => 'U moet karakters van halve breedte gebruiken voor het wachtwoord.',

## tmpl/cms/edit_blog.tmpl
	'Your child site configuration has been saved.' => 'Instellingen voor uw subsite zijn opgeslagen.',
	'You must set your Local Site Path.' => 'U dient het lokale pad van uw site in te stellen.',
	'Site Theme' => 'Sitethema',
	'Select the theme you wish to use for this child site.' => 'Selecteer het thema dat u wenst te gebruiken voor deze subsite.',
	'Name your child site. The site name can be changed at any time.' => 'Geef uw subsite een naam.  De naam van de site kan op elk moment worden veranderd.',
	'Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Vul de URL in van uw subsite.  Laat de bestandsnaam vallen (b.v. index.hmtl).  Voorbeeld: http://www.voorbeeld.com/blog/',
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Het pad waar uw indexbestanden zich zullen bevinden. Een absoluut pad (beginnend met \'/\' onder Linux of \'C:\' onder Windows) verdient de voorkeur. Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Het pad waar uw indexbestanden zich zullen bevinden.  Sluit niet af met '/' of '\'.  Voorbeeld: /home/mt/public_html/blog of C:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'Selecteer uw tijdzone in de keuzelijst.',
	'Create Child Site (s)' => 'Subsite aanmaken (s)',

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
	'Allow pings' => 'Pings toestaan',
	'View TrackBacks' => 'TrackBacks bekijken',
	'TrackBack URL for this category' => 'TrackBack URL voor deze categorie',
	'Passphrase Protection' => 'Wachtwoordbeveiliging',
	'Outbound TrackBacks' => 'Uitgaande TrackBacks',
	q{Trackback URLs} => q{TrackBack URL's},
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
	'View all comments with this name' => 'Alle reacties met deze naam bekijken',
	'Identity' => 'Identiteit',
	'View' => 'Bekijken',
	'Withheld' => 'Niet onthuld',
	'View all comments with this email address' => 'Alle reacties met dit e-mail adres bekijken',
	'Trusted' => 'Vertrouwde',
	'Banned' => 'Uitgesloten',
	'Authenticated' => 'Bevestigd',

## tmpl/cms/edit_comment.tmpl
	'Edit Comment' => 'Reactie bewerken',
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
	'Approved' => 'Goedgekeurd',
	'Unapproved' => 'Niet gekeurd',
	'Reported as Spam' => 'Gerapporteerd als spam',
	'View all comments with this status' => 'Alle reacties met deze status bekijken',
	'Commenter' => 'Reageerder',
	'View all comments by this commenter' => 'Alle reacties van deze reageerder bekijken',
	'Commenter Status' => 'Status reageerder',
	'View this commenter detail' => 'Details over deze reageerder bekijken',
	'Untrust Commenter' => 'Wantrouw reageerder',
	'Ban Commenter' => 'Verban reageerder',
	'Trust Commenter' => 'Vertrouw reageerder',
	'Unban Commenter' => 'Ontban reageerder',
	'Unavailable for OpenID user' => 'Niet beschikbaar voor OpenID gebruiker',
	'No url in profile' => 'Geen URL in profiel',
	'View all comments with this URL' => 'Alle reacties met deze URL bekijken',
	'[_1] no longer exists' => '[_1] bestaat niet meer',
	'View all comments on this [_1]' => 'Alle reacties bekijken op [_1]',
	'View all comments created on this day' => 'Alle reacties van die dag bekijken',
	'View all comments from this IP Address' => 'Alle reacties van dit IP-adres bekijken',
	'Comment Text' => 'Tekst reactie',
	'Responses to this comment' => 'Antwoorden op dit bericht',

## tmpl/cms/edit_content_data.tmpl
	'You have successfully recovered your saved content data.' => 'U heb met succes uw opgeslagen inhoudsgegevens teruggehaald.',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van deze inhoudsgegevens werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'An error occurred while trying to recover your saved content data.' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen inhoudsgegevens.',
	'This [_1] has been saved.' => 'Deze [_1] werd opgeslagen',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Nog een [_2] aanmaken?</a>',
	'Revision: <strong>[_1]</strong>' => 'Revisie: <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Revisies bekijken van [_1]',
	'View revisions' => 'Revisies bekijken',
	'No revision(s) associated with this [_1]' => 'Geen revisies geassociëerd met [_1]',
	'Publish this [_1]' => 'Publiceer [_1]',
	'Draft this [_1]' => 'Maak [_1] klad',
	'Schedule' => 'Plannen',
	'Update' => 'Bijwerken',
	'Update this [_1]' => 'Werk [_1] bij',
	'Unpublish this [_1]' => 'Maak publicatie van [_1] ongedaan',
	'Save this [_1]' => '[_1] bewaren',
	'You must configure this blog before you can publish this content data.' => 'U moet deze blog eerst configureren voor u deze inhoudsgegevens kunt publiceren.',
	'Unpublished (Draft)' => 'Niet gepubliceerd (klad)',
	'Unpublished (Review)' => 'Niet gepubliceerd (na te kijken)',
	'Unpublished (Spam)' => 'Niet gepubliceerd (spam)',
	'Publish On' => 'Publiceren op',
	'Published Time' => 'Publicatietijd',
	'Unpublished Date' => 'Einddatum publicatie',
	'Unpublished Time' => 'Ontpublicatietijd',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Waarschuwing: als u de basisnaam met de hand instelt dan kan deze in conflict komen met andere inhoudsgegevens.',
	q{Warning: Changing this content data's basename may break inbound links.} => q{Waarschuwing: de basisnaam van deze inhoudsgegevens veranderen kan inkomende links breken.},
	'Change note' => 'Notitie wijzigen',
	'You must configure this blog before you can publish this entry.' => 'U moet deze weblog configureren voor u dit bericht kunt publiceren.',
	'You must configure this blog before you can publish this page.' => 'U moet deze weblog configureren voor u deze pagina kunt publiceren.',
	'Permalink:' => 'Permalink:',
	'Enter a label to identify this data' => 'Voer een label in om deze gegevens te identificeren',
	'(Min length: [_1] / Max length: [_2])' => '(Min lengte: [_1] / Max lengte: [_2])',
	'(Min length: [_1])' => '(Min lengte: [_1])',
	'(Max length: [_1])' => '(Max lengte: [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min: [_1] / Max: [_2] / Aantal decimalen: [_3])',
	'(Min: [_1] / Max: [_2])' => '(Min: [_1] / Max: [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min: [_1] / Aantal decimalen: [_2])',
	'(Min: [_1])' => '(Min: [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max: [_1] / Aantal decimalen: [_2])',
	'(Max: [_1])' => '(Max: [_1])',
	'(Number of decimal places: [_1])' => '(Aantal decimalen: [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(Min selectie: [_1] / Max selectie: [_2])',
	'(Min select: [_1])' => '(Min selectie: [_1])',
	'(Max select: [_1])' => '(Max selectie: [_1])',
	'(Min tags: [_1] / Max tags: [_2])' => '(Min tags: [_1] / Max tags: [_2])',
	'(Min tags: [_1])' => '(Min tags: [_1])',
	'(Max tags: [_2])' => '(Max tags: [_2])',
	'One tag only' => 'Slechts één tag',
	'@' => '@',
	'Not specified' => 'Niet opgegeven',
	'Auto-saving...' => 'Auto-opslaan...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Laatste auto-opslag om [_1]:[_2]:[_3]',

## tmpl/cms/edit_content_type.tmpl
	'Edit Content Type' => 'Inhoudstype aanpassen',
	'Contents type settings has been saved.' => 'Instellingen inhoudstype zijn opgeslagen.',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'Sommige inhoudsvelden werden niet verwijderd.  U moet eerst de archiefmappingen voor het inhoudsveld verwijderen.',
	'Available Content Fields' => 'Beschikbare inhoudsvelden',
	'Unavailable Content Fields' => 'Niet beschikbare inhoudsvelden',
	'Reason' => 'Reden',
	'1 or more label-value pairs are required' => '1 of meer label-waarde paren zijn vereist',
	'This field must be unique in this content type' => 'Dit veld moet uniek zijn binnen dit inhoudstype',

## tmpl/cms/edit_entry_batch.tmpl
	q{Batch Edit Pages} => q{Pagina's bewerken in bulk},
	'Save these [_1] (s)' => 'Deze [_1] opslaan (s)',

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
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van dit bericht werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen versie van deze pagina werd automatisch opgeslagen [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>',
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
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Waarschuwing: de basisnaam van het bericht met de hand aanpassen kan een conflict met een ander bericht veroorzaken.',
	q{Warning: Changing this entry's basename may break inbound links.} => q{Waarschuwing: de basisnaam van het bericht aanpassen kan inkomende links breken.},
	'Add category' => 'Categorie toevoegen',
	'edit' => 'bewerken',
	'Accept' => 'Aanvaarden',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Eerder verzonden TrackBacks bekijken',
	'Outbound TrackBack URLs' => 'Uitgaande TrackBack URLs',
	'[_1] Assets' => '[_1] mediabestanden',
	'Add Entry Asset' => 'Mediabestand toevoegen',
	'No assets' => 'Geen mediabestanden',
	'You have unsaved changes to this entry that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit bericht die verloren zullen gaan.',
	'Enter the link address:' => 'Vul het adres van de link in:',
	'Enter the text to link to:' => 'Vul de tekst van de link in:',
	'Converting to rich text may result in changes to your current document.' => 'Converteren naar Rich Text kan wijzigingen aan uw document tot gevolg hebben.',
	'Make primary' => 'Maak dit een hoofdcategorie',
	'Fields' => 'Velden',
	'Reset display options to blog defaults' => 'Opties schermindeling terugzetten naar blogstandaard',
	'Draggable' => 'Sleepbaar',
	'Share' => 'Delen',
	'Format:' => 'Formaat:',
	'Rich Text(HTML mode)' => 'Verrijkte tekst (HTML modus)', # Translate - New
	q{(comma-delimited list)} => q{(lijst gescheiden met komma's)},
	'(space-delimited list)' => '(lijst gescheiden met spaties)',
	q{(delimited by '[_1]')} => q{(gescheiden door '[_1]')},
	'None selected' => 'Geen geselecteerd',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Map bewerken',
	'Manage Folders' => 'Mappen beheren',
	q{Manage pages in this folder} => q{Pagina's in deze map beheren},
	'You must specify a label for the folder.' => 'U moet een naam opgeven voor de map',
	'Path' => 'Pad',
	'Save changes to this folder (s)' => 'Wijzigingen aan deze map opslaan (s)',

## tmpl/cms/edit_group.tmpl
	'Edit Group' => 'Groep bewerken',
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
	'Created By' => 'Aangemaakt door',
	'Created On' => 'Aangemaakt',
	'Save changes to this field (s)' => 'De wijzigingen aan dit veld opslaan (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'TrackBack bewerken',
	'The TrackBack has been approved.' => 'De TrackBack is goedgekeurd.',
	'This trackback was classified as spam.' => 'Deze TrackBack werd geclassificeerd als spam.',
	'Save changes to this TrackBack (s)' => 'Wijzigingen aan deze TrackBack opslaan (s)',
	'Delete this TrackBack (x)' => 'Deze TrackBack verwijderen (x)',
	'Manage TrackBacks' => 'TrackBacks beheren',
	'View all TrackBacks with this status' => 'Alle TrackBacks met deze status bekijken',
	'Source Site' => 'Bronsite',
	'Search for other TrackBacks from this site' => 'Andere TrackBacks van deze site zoeken',
	'Source Title' => 'Brontitel',
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

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Rol bewerken',
	'Association (1)' => 'Associatie (1)',
	'Associations ([_1])' => 'Associaties ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'U heeft de rechten van deze rol aangepast.  Hierdoor is gewijzigd wat gebruikers kunnen doen die met deze rol zijn geassocieerd.  Als u dat verkiest, kunt u deze rol ook opslaan met een andere naam.  In het andere geval moet u er zich van bewust zijn welke wijzigingen er gebeuren bij gebruikers met deze rol.',
	'Role Details' => 'Rol details',
	'Privileges' => 'Privileges',
	'Administration' => 'Administratie',
	'Authoring and Publishing' => 'Schrijven en publiceren',
	'Designing' => 'Ontwerpen',
	'Commenting' => 'Reageren',
	'Content Type Privileges' => 'Privileges inhoudstypes',
	'Duplicate Roles' => 'Dubbele rollen',
	'Save changes to this role (s)' => 'Wijzigingen aan deze rol opslaan (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Widget bewerken',
	'Create Index Template' => 'Indexsjabloon aanmaken',
	'Create Entry Archive Template' => 'Berichtenarchiefsjabloon aanmaken',
	'Create Entry Listing Archive Template' => 'Berichtenlijstarchiefsjabloon aanmaken',
	'Create Page Archive Template' => 'Pagina-archiefsjabloon aanmaken',
	'Create Content Type Archive Template' => 'Inhoudstypearchiefsjabloon aanmaken',
	'Create Content Type Listing Archive Template' => 'Inhoudstypelijstarchiefsjabloon aanmaken',
	'Create Template Module' => 'Sjabloonmodule aanmaken',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => 'Een opgeslagen verise van deze [_1] werd automatisch opgeslagen [_3]. <a href="[_2]" class="alert-link">Automatisch opgeslagen inhoud terughalen</a>',
	'You have successfully recovered your saved [_1].' => '[_1] met succes teruggehaald.',
	'An error occurred while trying to recover your saved [_1].' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen [_1]',
	'Restored revision (Date:[_1]).' => 'Revisie teruggezet (Datum:[_1]).',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publiceer</a> dit sjabloon.',
	'Your [_1] has been published.' => 'Uw [_1] is opnieuw gepubliceerd.',
	'New Template' => 'Nieuwe sjabloon',
	'View revisions of this template' => 'Revisies bekijken van dit sjabloon',
	'No revision(s) associated with this template' => 'Geen revisie(s) geassocieerd met dit sjabloon',
	'Useful Links' => 'Nuttige links',
	'List [_1] templates' => 'Toon [_1] sjablonen',
	'List all templates' => 'Alle sjablonen tonen',
	'Module Option Settings' => 'Instellingen opties module',
	'View Published Template' => 'Gepubliceerd sjabloon bekijken',
	'Included Templates' => 'Geïncludeerde sjablonen',
	'create' => 'aanmaken',
	'Copy Unique ID' => 'Copiëer uniek ID',
	'Content field' => 'Inhoudsveld',
	'Select Content Field' => 'Selecteer inhoudsveld',
	'Create a new Content Type?' => 'Nieuw inhoudstype aanmaken?',
	'Save Changes (s)' => 'Wijzigingen opslaan (s)',
	'Save and Publish this template (r)' => 'Dit sjabloon opslaan en publiceren (r)',
	'Save &amp; Publish' => 'Opslaan &amp; publiceren',
	'You have unsaved changes to this template that will be lost.' => 'U heeft niet opgeslagen wijzigingen aan dit sjabloon die verloren zullen gaan.',
	'You must set the Template Name.' => 'U moet de naam van het sjabloon instellen',
	'You must select the Content Type.' => 'U moet het inhoudstype selecteren.',
	'You must set the template Output File.' => 'U moet het uitvoerbestand van het sjabloon instellen.',
	'Module Body' => 'Moduletekst',
	'Template Body' => 'Sjabloontekst',
	'Code Highlight' => 'Gemarkeerde code',
	'Template Type' => 'Sjabloontype',
	'Custom Index Template' => 'Gepersonaliseerd indexsjabloon',
	'Link to File' => 'Koppelen aan bestand',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Meer lezen over <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publicatie-instellingen</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => 'Meer leren over <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Padspecificaties voor archiefbestand</a>',
	'Category Field' => 'Categorieveld',
	'Date & Time Field' => 'Datum & -tijdveld',
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
	'Processing request...' => 'Verzoek verwerken...',
	'Error occurred while updating archive maps.' => 'Er deed zich teen fout voor bij het bijwerken van de archiefkoppelingen.',
	'Archive map has been successfully updated.' => 'Archiefkoppelingen zijn met succes bijgewerkt.',
	'Are you sure you want to remove this template map?' => 'Bent u zeker dat u deze sjabloonmapping wenst te verwijderen?',

## tmpl/cms/edit_website.tmpl
	'Your site configuration has been saved.' => 'De instellingen van uw site zijn opgeslagen.',
	'Select the theme you wish to use for this site.' => 'Selecteer het thema dat u wenst te gebruiken voor deze site.',
	'Name your site. The site name can be changed at any time.' => 'Geef uw site een naam.  De naam van de site kan op elk moment worden veranderd.',
	'Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Geef de URL op van uw site.  Laat de bestandsnaam vallen (b.v. index.html).  Voorbeeld: http://www.voorbeeld.com',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Vul het pad in waar uw hoofdindexbestand zich zal bevinden.  Een absoluut pad (beginnend met '/' voor Linux of 'C:\' voor Windows) verdient de voorkeur, maar u kunt ook een pad gebruiker relatief aan de Movable Type map.  Voorbeeld: /home/melody/public_html/ of C:\www\public_html},
	'Create Site (s)' => 'Site aanmaken (s)',
	'This field is required.' => 'Dit veld is verplicht',
	'Please enter a valid URL.' => 'Gelieve een geldige URL in te vullen.',
	'Please enter a valid site path.' => 'Gelieve een geldig sitepad in te vullen.',
	'You did not select a timezone.' => 'U hebt geen tijdzone geselecteerd.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Widgetset bewerken',
	'Widget Set Name' => 'Naam widgetset',
	'Save changes to this widget set (s)' => 'Wijzignen aan deze widgetset opslaan (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Klik en sleep de widgets die in deze widgetset horen in de kolom 'Geïnstalleerde widgets'.},
	'Available Widgets' => 'Beschikbare widgets',
	'Installed Widgets' => 'Geïnstalleerde widgets',
	'You must set Widget Set Name.' => 'U moet een naam instellen voor de widgetset.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Er deed zich een probleem voor',

## tmpl/cms/export_theme.tmpl
	q{Export Themes} => q{Thema's exporteren},
	'Theme package have been saved.' => 'Themapakket werd opgeslagen.',
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Gebruik enkel letters, cijfers, streepjes of underscores (a-z, A-Z, 0-9, '-' of '_').},
	'Version' => 'Versie',
	'_THEME_AUTHOR' => 'Maker',
	'Author link' => 'Link auteur',
	'Destination' => 'Bestemming',
	'Setting for [_1]' => 'Instelling voor [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'De basisnaam mag enkel letters, cijfers, mintekens en underscores bevatten.  De basisnaam moet met een letter beginnen.',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => 'Kan geen nieuw thema installeren met bestaande (en beschermde) basisnaam van thema.',
	'You must set Theme Name.' => 'U moet de naam van het thema instellen.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Themaversie mag enkel letters, cijfers, mintekens en underscores bevatten.',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exporteer [_1] berichten',
	'[_1] to Export' => '[_1] te exporteren',
	'_USAGE_EXPORT_1' => 'Exporteer de berichten, reacties en TrackBacks van een blog.  Een export kan niet beschouwd worden als een <em>volledige</em> backup van een blog.',
	'Export [_1]' => 'Exporteer [_1]',

## tmpl/cms/field_html/field_html_asset.tmpl
	'No Assets' => 'Geen mediabestanden',
	'No Asset' => 'Geen mediabestand',
	'Assets less than or equal to [_1] must be selected' => 'Een aantal mediabestanden kleiner dan of gelijk aan [_1] moet worden geselecteerd',
	'Assets greater than or equal to [_1] must be selected' => 'Een aantal mediabestanden groter dan of gelijk aan [_1] moet worden geselecteerd',
	'Only 1 asset can be selected' => 'Slechts één mediabestand kan worden geselecteerd',

## tmpl/cms/field_html/field_html_categories.tmpl
	'This field is disabled because valid Category Set is not selected in this field.' => 'Dit veld is uitgeschakeld omdat er geen geldige categorieset werd geselecteerd in dit veld.',
	'Add sub category' => 'Subcategorie toevoegen',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No field data.' => 'Geen veldgegevens.', # Translate - New
	'No [_1]' => 'Geen [_1]',
	'This field is disabled because valid Content Type is not selected in this field.' => 'Dit veld is uitgeschakeld omdat er geen geldig inhoudstype werd geselecteerd in dit veld.',
	'[_1] less than or equal to [_2] must be selected' => '[_1] kleiner dan of gelijk aan [_2] moet worden geselecteerd',
	'[_1] greater than or equal to [_2] must be selected' => '[_1] groter dan of gelijk aan [_2] moet worden geselecteerd',
	'Only 1 [_1] can be selected' => 'Slechts één [_1] kan worden geselecteerd',

## tmpl/cms/field_html/field_html_datetime.tmpl

## tmpl/cms/field_html/field_html_list.tmpl

## tmpl/cms/field_html/field_html_multi_line_text.tmpl

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'Niet geselecteerd',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'Start-HTML titel (optioneel)',
	'End title HTML (optional)' => 'Eind-HTML titel (optioneel-',
	'Default entry status (optional)' => 'Standaardstatus berichten (optioneel)',
	'Select an entry status' => 'Selecteer een berichtstatus',

## tmpl/cms/import.tmpl
	'Import [_1] Entries' => 'Importeer [_1] berichten',
	'You must select a site to import.' => 'U moet een site kiezen om te importeren.',
	'Enter a default password for new users.' => 'Vul een standaardwachtwoord in voor nieuwe gebruikers.',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Berichten overzetten naar Movable Type vanuit andere Movable Type installatie of zelfs andere blogsoftware of berichten exporteren om een backup of kopie te maken.',
	'Import data into' => 'Importeer data naar',
	'Select site' => 'Selecteer site',
	'Importing from' => 'Aan het importeren uit',
	'Ownership of imported entries' => 'Eigenaarschap van geïmporteerde berichten',
	'Import as me' => 'Importeer als mezelf',
	'Preserve original user' => 'Oorspronkelijke gebruiker bewaren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Als u ervoor kiest om het eigenaarschap van de geïmporteerde berichten te bewaren en als één of meer van die gebruikers nog moeten aangemaakt worden in deze installatie, moet u een standaard wachtwoord opgeven voor die nieuwe accounts.',
	'Default password for new users:' => 'Standaard wachtwoord voor nieuwe gebruikers:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'U zal eigenaar worden van alle geïmporteerde berichten.  Als u wenst dat de oorspronkelijke gebruiker eigenaar blijft, moet u uw MT systeembeheerder contacteren om de import te doen zodat nieuwe gebruikers aangemaakt kunnen worden indien nodig.',
	'Upload import file (optional)' => 'Importbestand opladen (optioneel)',
	'Apply this formatting if text format is not set on each entry.' => 'Pas deze tekstformattering toe indien het tekstformaat niet is ingesteld op een bericht.',
	'Import File Encoding' => 'Encodering importbestand',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Standaardcategorie voor berichten (optioneel)',
	'Select a category' => 'Categorie selecteren',
	'Import Entries (s)' => 'Berichten importeren (s)',
	'Import Entries' => 'Berichten importeren',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Reacties toestaan van anonieme of niet aangemelde gebruikers.',
	'Require name and E-mail Address for Anonymous Comments' => 'E-mail adres vereisen voor anonieme reacties',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Indien ingeschakeld moeten bezoekers een geldig e-mail adres opgeven wanneer ze reageren.',

## tmpl/cms/include/archetype_editor_multi.tmpl
	'Decrease Text Size' => 'Kleiner tekstformaat',
	'Increase Text Size' => 'Groter tekstformaat',
	'Bold' => 'Vet',
	'Italic' => 'Cursief',
	'Underline' => 'Onderstrepen',
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
	'Insert Image' => 'Afbeelding invoegen',
	'Insert File' => 'Bestand invoegen',
	'WYSIWYG Mode' => 'WYSIWYG modus',
	'HTML Mode' => 'HTML modus',

## tmpl/cms/include/archetype_editor.tmpl
	'Text Color' => 'Tekstkleur',
	'Check Spelling' => 'Spelling nakijken',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Inklappen',

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Er bestaat reeds een bestand net de naam '[_1]'. Wilt u dit bestand overschrijven?},
	'Yes (s)' => 'Ja (s)',
	'Yes' => 'Ja',
	'No' => 'Nee',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Geselecteerde media verwijderen (x)',
	'Size' => 'Grootte',
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
	'Choose files to upload or drag files.' => 'Kies bestanden om te uploaden of sleep ze hierheen',
	'Choose file to upload or drag file.' => 'Kies bestand om te uploaden of sleep het hierheen',
	'Choose files to upload.' => 'Kies bestanden om te uploaden.', # Translate - New
	'Choose file to upload.' => 'Kies bestand op te uploaden.', # Translate - New
	'Upload Settings' => 'Instellingen voor uploaden', # Translate - New
	'Upload Options' => 'Upload opties',
	'Operation for a file exists' => 'Actie als een bestand al bestaat',
	'Drag and drop here' => 'Klik en sleep hierheen',
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
	'All of the data has been exported successfully!' => 'Alle gegevens met succes geëxporteerd!',
	'_BACKUP_TEMPDIR_WARNING' => 'Gevraagde gegevens zijn met succes gebackupt in de map [_1].  Gelieve bovenstaande bestanden te downloaden en vervolgens <strong>onmiddellijk te verwijderen</strong> uit [_1] omdat backupbestanden vertrouwelijke informatie bevatten.',
	'Export Files' => 'Exportbestanden',
	'Download This File' => 'Dit bestand downloaden',
	'Download: [_1]' => 'Download: [_1]',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{Het downloaden van het backup-bestand zal over een paar seconden automatisch beginnen.  Als dit niet het geval is om wat voor reden dan ook, klik dan <a href='#' onclick='submit_form()'>hier</a> om de download met de hand in gang te zetten.  Merk op dat u het backupbestand slechts één keer kunt downloaden gedurende een sessie.},
	'An error occurred during the export process: [_1]' => 'Er deed zich een fout voor tijdens het exportproces: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Movable Type exporteren',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'bevat',
	'does not contain' => 'bevat niet',
	'__STRING_FILTER_EQUAL' => 'is gelijk aan',
	'starts with' => 'begint met',
	'ends with' => 'eindigt op',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'is blank' => 'is blanco',
	'is not blank' => 'is niet blanco',
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
	'__TIME_FILTER_HOURS' => 'valt binnen de laatste',
	'[_1] hours' => '[_1] uren',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => 'Sommige sjablonen werden niet ververst.',
	'Some sites were not deleted. You need to delete child sites under the site first.' => 'Sommige sites werden niet verwijderd.  U moet de subsites onder de site eerst verwijderen.',
	'Delete selected [_1] (x)' => 'Geselecteerde [_1] verwijderen (x)',
	'[_1] Name' => 'Naam [_1]',

## tmpl/cms/include/breadcrumbs.tmpl

## tmpl/cms/include/category_selector.tmpl
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
	'Reply' => 'Antwoorden',
	'([quant,_1,reply,replies])' => '([quant,_1,antwoord,antwoorden])',
	'Blocked' => 'Geblokkeerd',
	'Edit this [_1] commenter' => '[_1] reageerder bewerken',
	'Search for comments by this commenter' => 'Zoek naar reacties door deze reageerder',
	'Anonymous' => 'Anonieme',
	'View this entry' => 'Dit bericht bekijken',
	'View this page' => 'Deze pagina bekijken',
	'Search for all comments from this IP address' => 'Zoek naar alle reacties van dit IP adres',
	'to republish' => 'om opnieuw te publiceren',

## tmpl/cms/include/content_data_list.tmpl

## tmpl/cms/include/content_data_table.tmpl
	'Republish selected [_1] (r)' => 'Geselecteerde [_1] opnieuw publiceren (r)',
	'Created' => 'Aangemaakt',
	'View Content Data' => 'Inhoudsgegevens bekijken',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Alle rechten voorbehouden.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Werkbalk verbergen',
	'Hide &raquo;' => 'Verberg &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Sleutel',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variabele',
	'No COOKIE data' => 'Geen COOKIE gegevens',
	'Input Parameters' => 'Invoerparameters',
	'No Input Parameters' => 'Geen invoerparameters',

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/debug_toolbar/vcs.tmpl

## tmpl/cms/include/display_options.tmpl

## tmpl/cms/include/entry_table.tmpl
	'Last Modified' => 'Laatst aangepast',
	'View entry' => 'Bericht bekijken',
	'View page' => 'Pagina bekijken',
	'No entries could be found.' => 'Geen berichten gevonden.',
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => 'Nu <a href="[_1]" class="alert-link">een bericht aanmaken</a>.',
	q{No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.} => q{Er werden geen pagina's gevonden. Nu <a href="[_1]" class="alert-link">een pagina aanmaken</a>.},

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Webservices wachtwoord instellen',

## tmpl/cms/include/footer.tmpl
	'DEVELOPER PREVIEW' => 'DEVELOPER PREVIEW',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Dit is een alfaversie van Movable Type die niet wordt aangeraden voor gebruik in productie.',
	'BETA' => 'BETA',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Dit is een betaversie van Movable Type, niet aangeraden voor productiegebruik.',
	'https://www.movabletype.org' => 'https://www.movabletype.org',
	'MovableType.org' => 'MovableType.org',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org',
	'Support' => 'Ondersteuning',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'Forums' => 'Forums',
	'Send Us Feedback' => 'Stuur ons feedback',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'with' => 'met',

## tmpl/cms/include/group_table.tmpl
	'Enable selected group (e)' => 'De geselecteerde groep activeren (e)',
	'Disable selected group (d)' => 'De geselecteerde groep deactiveren (d)',
	'group' => 'groep',
	'groups' => 'groepen',
	'Remove selected group (d)' => 'De geselecteerde groep verwijderen (d)',

## tmpl/cms/include/header.tmpl
	'Help' => 'Hulp',
	'Search (q)' => 'Zoeken (q)',
	'Search [_1]' => 'Doorzoek [_1]',
	'Select an action' => 'Selecteer een actie',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Deze website werd aangemaakt tijdens de upgrade van een vorige versie van Movable Type.  'Site Root' en 'Site URL' werden met opzet leeg gelaten om 'Publicatiepaden' compatibiliteit te behouden voor blogs die aangemaakt werden in de vorige versie.  U kunt berichten plaatsen en publiceren op de bestaande blogs, maar u kunt deze website zelf niet publiceren omwille van de blanco 'Site Root' en 'Site URL'.},
	'from Revision History' => 'Revisiegeschiedenis',

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publiceer uw site</a> om de wijzigingen zichtbaar te maken.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Verwijder zeker de bestanden waaruit u gegevens importeerde uit de 'import' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.},

## tmpl/cms/include/import_start.tmpl
	'Importing entries into [_1]' => 'Berichten worden geïmporteerd in de [_1]',
	q{Importing entries as user '[_1]'} => q{Berichten worden geïmporteerd als gebruiker '[_1]'},
	'Creating new users for each user found in the [_1]' => 'Nieuwe gebruikers worden aangemaakt voor elke gebruiker gevonden in de [_1]',

## tmpl/cms/include/insert_options_image.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Ga',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Stap [_1] van [_2]',
	'Go to [_1]' => 'Ga naar [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Sorry, er waren geen resultaten voor uw zoekopdracht. Probeer opnieuw te zoeken.',
	'Sorry, there is no data for this object set.' => 'Sorry, er zijn geen gegevens ingesteld voor dit object.',

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
	'Remove this role' => 'Verwijder deze rol',

## tmpl/cms/include/mobile_global_menu.tmpl
	'Select another site...' => 'Selecteer een andere site...',
	'Select another child site...' => 'Selecteer een andere subsite...',
	'PC View' => 'PC uitzicht', # Translate - New

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Toegevoegd',
	'Save changes' => 'Wijzigingen opslaan',

## tmpl/cms/include/old_footer.tmpl
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> versie [_2]',
	q{_LOCALE_CALENDAR_HEADER_} => q{'Z', 'M', 'D', 'W', 'D', 'V', 'Z'},
	'Your Dashboard' => 'Uw dashboard',

## tmpl/cms/include/pagination.tmpl
	'First' => 'Eerste',
	'Last' => 'Laatste',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Geselecteerde [_1] publiceren (p)',
	'From' => 'Van',
	'Target' => 'Doel',
	'Moderated' => 'Gemodereerd',
	'Edit this TrackBack' => 'Deze TrackBack bewerken',
	'Go to the source entry of this TrackBack' => 'Ga naar het bronbericht van deze TrackBack',
	'View the [_1] for this TrackBack' => 'De [_1] bekijken voor deze TrackBack',

## tmpl/cms/include/primary_navigation.tmpl
	'Open Panel' => 'Paneel openen',
	'Open Site Menu' => 'Site menu openen',
	'Close Site Menu' => 'Site menu sluiten',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Geen revisies gevonden.',
	'_REVISION_DATE_' => 'Datum',
	'Note' => 'Noot',
	'Saved By' => 'Opgeslagen door',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartz boodschap',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'Dashboard gebruiker',
	'Websites' => 'Websites',
	'Select another website...' => 'Selecteer een andere website...',
	'(on [_1])' => '(op [_1])',
	'Select another blog...' => 'Selecteer een andere blog...',
	'Create Website' => 'Website aanmaken',
	'Create Blog (on [_1])' => 'Blog aanmaken (op [_1])',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Published by [_2]' => '[_1] - gepubliceerd door [_2]',
	'[_1] - Edited by [_2]' => '[_1] - bewerkt door [_2]',

## tmpl/cms/include/template_table.tmpl
	'No content type could be found.' => 'Er werd geen inhoudstype gevonden.',
	'Create Archive Template:' => 'Archiefsjabloon aanmaken:',
	'Publish selected templates (a)' => 'Geselecteerde sjablonen publiceren (a)',
	'Archive Path' => 'Archiefpad',
	'SSI' => 'SSI',
	'Cached' => 'Gecached',
	'Manual' => 'Handmatig',
	'Dynamic' => 'Dynamisch',
	'Publish Queue' => 'Publicatiewachtrij',
	'Static' => 'Statisch',
	'Uncached' => 'Zonder cache',
	'templates' => 'sjablonen',
	'to publish' => 'om te publiceren',

## tmpl/cms/include/theme_exporters/category_set.tmpl

## tmpl/cms/include/theme_exporters/category.tmpl

## tmpl/cms/include/theme_exporters/content_type.tmpl

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
	'System Email' => 'Systeem e-mail',
	'Use this as system email address' => 'Dit ook als systeem e-mail adres gebruiken',
	'Select a password for your account.' => 'Kies een wachtwoord voor uw account.',
	'Finish install (s)' => 'Installatie afronden (s)',
	'Finish install' => 'Installatie afronden',
	'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
	'The display name is required.' => 'Getoonde naam is vereist.',
	'The e-mail address is required.' => 'Het e-mail adres is vereist.',

## tmpl/cms/layout/common/footer.tmpl

## tmpl/cms/layout/dashboard.tmpl
	'reload' => 'herladen',
	'Reload' => 'Herladen',

## tmpl/cms/list_category.tmpl
	'Top Level' => 'Topniveau',
	'[_1] label' => '[_1] label',
	'Alert' => 'Alarm',
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

## tmpl/cms/list_common.tmpl
	'Feed' => 'Feed',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',

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
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Sommige ([_1]) van de geselecteerde gebruiker(s) konden niet opnieuw ingeschakeld worden omdat ze één (of meer) ongeldige parameter hadden. Kijk in het <a href='[_2]' class="alert-link">activiteitenlog</a> voor meer details.},
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Er deed zich een fout voor tijdens synchronisatie.  Kijk in het <a href='[_2]' class="alert-link">activiteitenlog</a> voor meer details.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => 'U hebt [_1] toegevoegd aan uw lijst met uitgesloten IP adressen.',
	'You have successfully deleted the selected IP addresses from the list.' => 'U hebt de geselecteerde IP adressen uit de lijst is verwijderd.',
	'' => '', # Translate - New
	'The IP you entered is already banned for this site.' => 'Het IP dat u heeft ingevuld is reeds uitgesloten voor deze site.', # Translate - New
	'Invalid IP address.' => 'Ongeldig IP adres',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes deze site verwijderd uit het Movable Type systeem.  De bestanden bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als ze niet meer nodig zijn.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'U heeft met succes deze subsite verwijderd uit het Movable Type systeem.  De bestanden bestaan nog in het sitepad.  Gelieve de bestanden te verwijderen als ze niet meer nodig zijn.',
	'You have successfully refreshed your templates.' => 'U heeft met succes uw sjablonen ververst.',
	'You have successfully moved selected child sites to another site.' => 'U heeft met succes de geselecteerde subsites verplaatst naar een andere site.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Waarschuwing: u moet mediabestanden die werden geupload met de hand naar de nieuwe locatie verhuizen.  Overweeg ook om op de oorspronkelijke locatie kopieën te bewaren om zo gebroken links te vermijden.',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => 'Sommige categoriesets werden niet verwijderd.  U moet eerst de categorievelden verwijderen uit de categorieset.',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'De geselecteerde reactie(s) zijn goedgekeurd.',
	'All comments reported as spam have been removed.' => 'Alle reaactie die aangemerkt waren als spam zijn verwijderd.',
	'The selected comment(s) has been unapproved.' => 'De geselecteerde reactie(s) zijn niet langer goedgekeurd.',
	'The selected comment(s) has been reported as spam.' => 'De geselecteerde reactie(s) zijn als spam gerapporteerd.',
	'The selected comment(s) has been recovered from spam.' => 'De geselecteerde reactie(s) zijn teruggehaald uit de spam-map',
	'The selected comment(s) has been deleted from the database.' => 'Geselecteerde reactie(en) zijn uit de database verwijderd.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Eén of meer reacties die u selecteerde werd ingegeven door een niet geauthenticeerde reageerder. Deze reageerders kunnen niet verbannen of vertrouwd worden.',
	'No comments appear to be spam.' => 'Er lijken geen spamreacties te zijn',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'De inhoudsgegevens werden verwijderd uit de database.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'The content type has been deleted from the database.' => 'Het inhoudstype werd verwijderd uit de database.',
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'Sommige inhoudstypes werden niet verwijderd.  U moet de archiefsjablonen of inhoudstypevelden eerst verwijderen uit het inhoudstype.',

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => 'U deactiveerde met succes de geselecteerde groep(en).',
	'You successfully enabled the selected group(s).' => 'U activeerde met succes de geselecteerde groep(en).',
	'You successfully deleted the groups from the Movable Type system.' => 'U verwijderde met succes de groepen uit het Movable Type systeem.',
	q{You successfully synchronized the groups' information with the external directory.} => q{U synchroniseerde met succes de groepsinformatie met de externe directory.},
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Er deed zich een fout voor tijdens de synchronisatie.  Kijk in het <a href='[_1]'>activiteitenlog</a> voor gedetailleerde informatie.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'U verwijderde met succes de gebruikers.',
	'You successfully added new users to this group.' => 'U voegde met succes nieuwe gebruikers toe aan deze groep.',
	q{You successfully synchronized users' information with the external directory.} => q{U synchroniseerde met succes informatie over gebruikers met de externe directory.},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Sommige ([_1]) van de geselecteerde gebruikers konden niet gereactiveerd worden omdat ze niet langer gevonden worden in LDAP.',
	'You successfully removed the users from this group.' => 'U verwijderde met succes de gebruikers uit de groep.',

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Alle tijdstippen worden getoond in GMT[_1].',
	'All times are displayed in GMT.' => 'Alle tijdstippen worden getoond in GMT.',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have updated your contact in your address book.' => 'U heeft uw contact in het adressenboek bijgewerkt.',
	'You have added new contact to your address book.' => 'U heeft een nieuw contact aan uw adressenboek toegevoegd.',
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
	'Show All Templates' => 'Alle sjablonen tonen',
	'Content type Templates' => 'Inhoudstypesjablonen',
	'Publishing Settings' => 'Publicatie-instellingen',
	'Helpful Tips' => 'Nuttige tips',
	'To add a widget set to your templates, use the following syntax:' => 'Om een widgetset aan uw sjablonen toe te voegen, gebruikt u volgende syntax:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Naam van de widgetset&quot;$&gt;</strong>',
	'You have successfully deleted the checked template(s).' => 'Verwijdering van geselecteerde sjabloon/sjablonen is geslaagd.',
	'Your templates have been published.' => 'Uw sjablonen werden gepubliceerd.',
	'Selected template(s) has been copied.' => 'Geselecteerde sjablo(o)n(en) gekopiëerd.',
	'Select template type' => 'Selecteer sjabloontype',
	'Entry Archive' => 'Berichtarchief',
	'Entry Listing Archive' => 'Berichtenlijstarchief',
	'Page Archive' => 'Pagina-archief',
	'Content Type Listing Archive' => 'Inhoudstypelijstarchief',
	'Template Module' => 'Sjabloonmodule',
	'Create new template (c)' => 'Nieuw sjabloon aanmaken (c)',
	'Create' => 'aanmaken',
	'Delete selected Widget Sets (x)' => 'Geselecteerde widgetsets verwijderen (x)',
	'No widget sets could be found.' => 'Er werden geen widgetsets gevonden.',

## tmpl/cms/list_theme.tmpl
	q{All Themes} => q{Alle thema's},
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	q{Find Themes} => q{Thema's zoeken},
	'Theme [_1] has been uninstalled.' => 'Thema [_1] werd gedesinstalleerd.',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'Thema [_1] werd toegepast (<a href="[_2]" class="alert-link">[quant,_3,waarschuwing,waarschuwingen]</a>).',
	'Theme [_1] has been applied.' => 'Thema [_1] werd toegepast.',
	'Failed' => 'Mislukt',
	'[quant,_1,warning,warnings]' => '[quant,_1,waarschuwing,waarschuwingen]',
	'Reapply' => 'Opnieuw toepassen',
	'Uninstall' => 'Desinstalleren',
	'Author: ' => 'Auteur:',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Dit thema kan niet worden toegepast op de subsite vanwege [_1] fouten',
	'This theme cannot be applied to the site due to [_1] errors' => 'Dit thema kan niet worden toegepast op de site vanwege [_1] fouten',
	'Errors' => 'Fouten',
	'Warnings' => 'Waarschuwingen',
	'Theme Errors' => 'Thema fouten',
	'Theme Warnings' => 'Thema waarschuwingen',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Delen van dit thema kunnen niet worden toegepast op de subsite. [_1] zullen worden overgeslagen.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Delen van dit thema kunnen niet worden toegepast op de site. [_1] zullen worden overgeslagen.',
	'Theme Information' => 'Thema informatie',
	q{No themes are installed.} => q{Geen thema's geïnstalleerd},
	'Current Theme' => 'Huidig thema',
	q{Themes in Use} => q{Thema's in gebruik},
	q{Available Themes} => q{Beschikbare thema's},

## tmpl/cms/login.tmpl
	'Sign in' => 'Aanmelden',
	'Your Movable Type session has ended.' => 'Uw Movable Type sessie is beëxndigd.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Uw Movable Type sessie is beëxndigd.  Als u zich opnieuw wenst aan te melden, dan kan dat hieronder.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Uw Movable Type sessie is beëxndigd. Gelieve u opnieuw aan te melden om deze handeling voort te zetten.',
	'Forgot your password?' => 'Uw wachtwoord vergeten?',
	'Sign In (s)' => 'Aanmelden (s)',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Nog niet geïmplementeerd.',

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

## tmpl/cms/preview_content_data_content.tmpl

## tmpl/cms/preview_content_data_strip.tmpl
	'Return to the compose screen' => 'Terugkeren naar het opstelscherm',
	'Return to the compose screen (e)' => 'Terugkeren naar het opstelscherm (r)',
	'Publish this [_1] (s)' => 'Publiceer deze [_1] (s)',
	'Save this [_1] (s)' => 'Sla deze [_1] op (s)',
	'Re-Edit this [_1]' => 'Deze [_1] opnieuw bewerken',
	'Re-Edit this [_1] (e)' => 'Deze [_1] opnieuw bewerken (e)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'U bekijkt een voorbeeld van &ldquo;[_1]&rdquo; inhoudsgegevens getiteld &ldquo;[_2]&rdquo;',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Voorbeeld [_1] inhoud bekijken',

## tmpl/cms/preview_entry.tmpl
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
	'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
	'Return to templates' => 'Terugkeren naar sjablonen',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'Er deed zich een fout voor tijdens het importproces: [_1] Controleer het activiteitenlog voor meer details.',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Movable Type importeren',

## tmpl/cms/restore.tmpl
	'Import from Exported file' => 'Importeren uit een exportbestand',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Perl module XML::SAX en/of een aantal van de vereisten ervoor ontbreekt.  Movable Type kan het systeem niet terugzetten zonder deze modules.',
	'Exported File' => 'Exportbestand',
	'Overwrite global templates.' => 'Globale sjablonen overschrijven.',
	'Import (i)' => 'Importeren (i)',

## tmpl/cms/search_replace.tmpl
	'Search &amp; Replace' => 'Zoeken en vervangen',
	'You must select one or more item to replace.' => 'U moet één of meer items selecteren om te vervangen.',
	'Search Again' => 'Opnieuw zoeken',
	'Case Sensitive' => 'Hoofdlettergevoelig',
	'Regex Match' => 'Regex-overeenkomst',
	'Limited Fields' => 'Beperkte velden',
	'Date/Time Range' => 'Datum/tijd bereik',
	'Date Range' => 'Bereik wissen',
	'Reported as Spam?' => 'Rapporteren als spam?',
	'(search only)' => '(enkel zoeken)',
	'Field' => 'Veld',
	'_DATE_FROM' => 'Van',
	'_DATE_TO' => 'Tot',
	'_TIME_FROM' => 'Van',
	'_TIME_TO' => 'Tot',
	'Submit search (s)' => 'Zoekopdracht ingeven (s)',
	'Search For' => 'Zoeken naar',
	'Replace With' => 'Vervangen door',
	'Replace Checked' => 'Aangekruiste items vervangen',
	'Successfully replaced [quant,_1,record,records].' => 'Met succes [quant,_1,record,records] vervangen.',
	'Showing first [_1] results.' => 'Eerste [_1] resultaten worden getoond.',
	'Show all matches' => 'Alle overeenkomsten worden getoond',
	'[quant,_1,result,results] found' => '[quant,_1,resultaat,resultaten] found',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Totaal aantal gebruikers',
	'Memcached Status' => 'Memcached status',
	'configured' => 'geconfigureerd',
	'disabled' => 'uitgeschakeld',
	'Memcached is [_1].' => 'Memcached is [_1]',
	'available' => 'beschikbaar',
	'unavailable' => 'niet beschikbaar',
	'Memcached Server is [_1].' => 'Memcached server is [_1].',
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

## tmpl/cms/widget/activity_log.tmpl

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Nieuws',
	'No Movable Type news available.' => 'Geen Movable Type nieuws beschikbaar.',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Berichten van het systeem',
	'warning' => 'waarschuwing',

## tmpl/cms/widget/site_list_for_mobile.tmpl

## tmpl/cms/widget/site_list.tmpl
	'Setting' => 'Instelling',
	'List' => 'Lijst',
	'Recent Posts' => 'Recente berichten',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Instellingen voor statistieken',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Actieve gebruikers',

## tmpl/cms/widget/updates.tmpl
	'Update check failed. Please check server network settings.' => 'Update check mislukt.  Kijk de netwerkinstellingen op de server na.',
	'Update check is disabled.' => 'Update check is uitgeschakeld.',
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Beschikbare updates (Ver. [_1]) gevonden.  Zie <a href="[_2]" target="_blank">nieuws</a> voor details.',
	'Movable Type is up to date.' => 'Movable Type is bijgewerkt tot de laatste versie.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Terug (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Aanmelden om te reageren',
	'Sign in using' => 'Aanmelden met',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Nog geen lid? <a href="[_1]">Registreer nu</a>!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Uw profiel',
	'Select a password for yourself.' => 'Kies een wachtwoord voor uzelf.',
	'Return to the <a href="[_1]">original page</a>.' => 'Keer terug naar de <a href="[_1]">oorspronkelijke pagina</a>.',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Bedankt om te registreren',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Voordat u een reactie kunt achterlaten, moet u eerst het registratieproces doorlopen door uw account te bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Om de registratieprocedure te voltooien moet u eerst uw account bevestigen.  Er is een e-mail verstuurd naar [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Om uw account te bestigen en activeren, gelieve in uw inbox te kijken en op de link te klikken in de e-mail die u net is toegestuurd.',
	'Return to the original entry.' => 'Terugkeren naar oorspronkelijk bericht',
	'Return to the original page.' => 'Terugkeren naar oorspronkelijke pagina',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Maak een account aan',
	'Password Confirm' => 'Wachtwoord bevestigen',
	'Register' => 'Registreer',

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
	'More like this' => 'Meer zoals dit',
	'From this [_1]' => 'Van deze [_1]',
	'On this entry' => 'Op dit bericht',
	'By commenter identity' => 'Volgens identiteit reageerders',
	'By commenter name' => 'Volgens naam reageerders',
	'By commenter email' => 'Volgens e-mail reageerders',
	'By commenter URL' => 'Volgens URL reageerders',
	'On this day' => 'Op deze dag',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'Van deze auteur',

## tmpl/feeds/feed_entry.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source [_1]' => 'Bron [_1]',
	'By source blog' => 'Volgens bronblog',
	'By source title' => 'Volgens titel bron',
	'By source URL' => 'Volgens URL bron',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Tijdelijke map configuratie',
	'You should configure your temporary directory settings.' => 'U moet de instellingen voor uw tijdelijke map configureren.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Uw TempDir is met succes ingesteld.  Klik op 'Doorgaan' hieronder om verder te gaan met de configuratie.},
	'[_1] could not be found.' => '[_1] kon niet worden gevonden.',
	'TempDir is required.' => 'TempDir is vereist.',
	'TempDir' => 'TempDir',

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
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{De volgende Perl modules zijn vereist om een databaseverbinding te kunnen maken.  Movable Type heeft een database nodig om de gegevens op te slaan van uw sites en subsites. Gelieve één van de opgesomde paketten te installeren om verder te gaan.  Als u gereed bent, klilk dan op de knop 'Opnieuw proberen'.},
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
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	'Learn more about installing Perl modules.' => 'Meer weten over het installeren van Perl modules',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Op uw server zijn alle vereiste modules geïnstalleerd; u hoeft geen bijkomende modules te installeren.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Configuratiebestand bestaat',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type vereist dat JavaScript ingeschakeld is in uw browser.  Gelieve het in te schakelen en herlaad deze pagina om opnieuw te proberen.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Deze wizard zal u helpen met het configureren van de basisinstellingen om Movable Type te doen werken.',
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

## addons/Cloud.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype',
	'Cloud Services' => 'Clouddiensten', # Translate - New
	'Basic Authentication' => 'Basic authenticatie', # Translate - New
	'Redirect' => 'Doorverwijzing', # Translate - New
	'Auto Update' => 'Automatische Update', # Translate - New
	'FTPS Password' => 'FTPS Wachtwoord', # Translate - New
	'SSL Certificates' => 'SSL Certificaat', # Translate - New
	'IP Restriction' => 'IP Beperking', # Translate - New
	'Full Restore' => 'Volledig Herstel', # Translate - New
	'Config Directives' => 'Configuratiedirectieven', # Translate - New
	'Disk Usage' => 'Schijfgebruik', # Translate - New

## addons/Cloud.pack/lib/Cloud/App/CMS.pm
	'Owner' => 'Eigenaar', # Translate - New
	'Creator' => 'Maker', # Translate - New
	'FTP passowrd for [_1] has successfully been updated.' => 'Het FTP wachtwoord voor [_1] werd met succes bijgewerkt.', # Translate - New
	'Unable to reset [_1] FTPS password.' => 'Kan FTP wachtwoord voor [_1] niet bijwerken.', # Translate - New
	'Failed to update [_1]: some of [_2] were changed after you opened this screen.' => 'Bijwerken van [_1] niet gelukt: enkele [_2] werden gewijzigd sinds u dit scherm opende.', # Translate - New
	'Basic Authentication setting' => 'Instellingen basic authenticatie', # Translate - New
	'Cannot access to this uri: [_1]' => 'Geen toegang tot deze uri: [_1]', # Translate - New
	'Basic authentication for site has successfully been updated.' => 'Basic authenticatie voor deze site werd bijgewerkt.', # Translate - New
	'Unable to update Basic Authentication settings.' => 'Bijwerken basic authenticatie voor deze site niet gelukt.', # Translate - New
	'Administration Screen Setting' => 'Instelling administratiescherm', # Translate - New
	'The URL you specified is not available.' => 'De URL die u opgaf is niet beschikbaar.', # Translate - New
	'Unable to update Admin Screen URL settings.' => 'Bijwerken URL administratiescherm niet gelukt.', # Translate - New
	'The URL for administration screen has successfully been updated.' => 'De URL voor het administratiescherm werd met succes bijgewerkt.', # Translate - New
	'Cannot delete basicauth_admin file.' => 'Kan basicauth_admin bestand niet verwijderen.', # Translate - New
	'Basic authentication for administration screen has successfully been cleared.' => 'Basic authenticatie voor administratiescherm werd met succes leeggemaakt.', # Translate - New
	'User ID is required.' => 'Gebruikers ID is vereist.', # Translate - New
	'Password is required.' => 'Wachtwoord is vereist.', # Translate - New
	'Unable to update basic authentication for administration screen.' => 'Bijwerken basic authenticatie voor administratiescherm mislukt.', # Translate - New
	'Unable to write temporary file.' => 'Onmogelijk tijdelijk bestand te schrijven.', # Translate - New
	'Basic authentication for administration screen has successfully been updated.' => 'Basic authenticatie voor administratiescherm met succes bijgewerkt.', # Translate - New
	'Cannot delete ip_restriction_[_1] file.' => 'Kan ip_restriction_[_1] bestand niet verwijderen.', # Translate - New
	'IP restriction for administration screen has successfully been cleared.' => 'IP restricties voor administratiescherm met succes leeg gemaakt.', # Translate - New
	'[_1] is not a valid IP address.' => '[_1] is geen geldig IP adres.', # Translate - New
	'Unable to write allowed IP addresses file.' => 'Schrijven naar bestand met toegestane IP adressen mislukt.', # Translate - New
	'IP restriction white list for administration screen  has successfully been updated.' => 'IP restricties whitelist voor administratiescherm met succes bijgewerkt.', # Translate - New
	'HTTP Redirect' => 'HTTP omleidingen', # Translate - New
	'HTTP Redirect setting' => 'Instelling voor HTTP omleidingen', # Translate - New
	'HTTP redirect settings has successfully updated.' => 'Instelling voor HTTP omleiding met succes bijgewerkt.', # Translate - New
	'Unable to update HTTP Redirect settings.' => 'Kon instelling voor HTTP omleiding niet bijwerken.', # Translate - New
	'Update SSL Certification' => 'SSL certificaat bijwerken', # Translate - New
	'__SSL_CERT_UPDATE' => 'bijwerken', # Translate - New
	'__SSL_CERT_INSTALL' => 'installeren', # Translate - New
	'Cannot copy default cert file.' => 'Kan standaard cert bestand niet kopiëren.', # Translate - New
	'Unable to create temporary path: [_1]' => 'Kan tijdelijk pad niet aanmaken: [_1]', # Translate - New
	'SSL certification has successfully been updated.' => 'SSL certificaat met succes bijgewerkt.', # Translate - New
	'Unable to update SSL certification.' => 'Kan SSL certificaat niet bijwerken.', # Translate - New
	'Manage Configuration Directives' => 'Configuratiedirectieven beheren', # Translate - New
	'Config Directive' => 'Conf. directief', # Translate - New
	'Movable Type environment settings has successfully been updated.' => 'Omgevingsinstellingen van Movable Type met succes bijgewerkt.', # Translate - New
	'Restoring Backup Data' => 'Backupgegevens aan het terugzetten', # Translate - New
	'backup data' => 'backupgegevens', # Translate - New
	'Invalid backup file name.' => 'Ongeldige bestandsnaam backupbestand.', # Translate - New
	'Cannot copy backup file to workspace.' => 'Kan backupbestand niet kopiëren naar de werkruimte.', # Translate - New
	'Could not save the site settings because the number of domains that have been used exceeds the number of domains which can be available.' => 'Kon website-instellingen niet opslaan omdat het aantal domeinnamen dat werd gebruikt groter is dan het aantal domeinnamen dat beschikbaar kan zijn.', # Translate - New
	'Could not create the site because the number of domains that have been used exceeds the number of domains which can be available.' => 'Kon website niet aanmaken omdat het aantal domeinnamen dat werd gebruikt groter is dan het aantal domeinnamen dat beschikbaar kan zijn.', # Translate - New
	'Auto Update Settings' => 'Instellingen voor automatisch bijwerken', # Translate - New
	'Unable to write AUTOUPDATE file: [_1]' => 'Kon geen AUTOUPDATE bestand schrijven: [_1]', # Translate - New
	'Auto update settings has successfully been updated.' => 'Instellingen voor automatisch bijwerken werden met succes bijgewerkt.', # Translate - New
	'IP Restriction Settings' => 'Instellingen voor IP beperkingen', # Translate - New
	'IP Restriction settings' => 'Instellingen voor IP beperkingen', # Translate - New
	'Domain, Path and IP addresses are required.' => 'Domein, pad en IP adres zijn vereist.', # Translate - New
	'\'[_1]\' does not exist.' => '\'[_1]\' bestaat niet', # Translate - New
	'\'[_1]\' is invalid path.' => '\'[_1]\' is een ongeldig pad', # Translate - New
	'Unable to create acl path: [_1]' => 'Kon acl pad niet aanmaken: [_1]', # Translate - New
	'Cannot write to acl directory: [_1]' => 'Kon niet schrijven naar acl map: [_1]', # Translate - New
	'Cannot write to acl file: [_1]' => 'Kon niet schrijven naar acl bestand: [_1]', # Translate - New
	'IP restriction for site has successfully been updated.' => 'IP beperkingen voor de site werden met succes bijgewerkt.', # Translate - New
	'Cannot apply access restriction settings. Perhaps, the path or IP address you entered is not a valid.' => 'Kan instellingen voor toegangsbeperking niet opslaan.  Misschien is het pad of het IP adres dat u invoerde niet geldig.', # Translate - New
	'Unable to remove acl file.' => 'Kon acl bestand niet verwijderen.', # Translate - New

## addons/Cloud.pack/lib/Cloud/App.pm
	'Your Movable Type will be automatically updated on [_1].' => 'Uw Movable Type zal automatisch worden bijgewerkt op [_1].', # Translate - New
	'New version of Movable Type has been released on [_1].' => 'Nieuwe versie van Movable Type werd uitgebracht op [_1].', # Translate - New
	'Disk usage rate is [_1]%.' => 'Percentage schijfgebruik is [_1]%.', # Translate - New
	'<a href="[_1]">Refresh cached disk usage rate data.</a>' => '<a href="[_1]">Opgeslagen schijfgebruikgegevens vernieuwen.</a>', # Translate - New
	'An error occurred while reading version information.' => 'Er deed zich een fout voor bij het lezen van de versie-informatie.', # Translate - New

## addons/Cloud.pack/lib/Cloud/Template.pm
	'Unify the existence of www. <a href="[_1]">Detail</a>' => 'Unificeer het bestaan van www. <a href="[_1]">Detail</a>', # Translate - New
	'https://www.movabletype.jp/documentation/cloud/guide/multi-domain.html' => 'https://www.movabletype.com/documentation/cloud/guide/multi-domain.html', # Translate - New
	'\'Site Root\' or \'Archive Root\' has been changed. You must move existing contents.' => '\'Website\' root of \'Archief\' root werd aangepast.  U moet bestaande inhoud verhuizen.', # Translate - New

## addons/Cloud.pack/lib/Cloud/Upgrade.pm
	'Disabling any plugins...' => 'Bezig plugins uit te schakelen...', # Translate - New

## addons/Cloud.pack/lib/Cloud/Util.pm
	'Cannot read resource file.' => 'Kan bronbestand niet laden.', # Translate - New
	'Cannot get the resource data.' => 'Kan brongegevens niet verkrijgen.', # Translate - New
	'Unknown CPU type.' => 'Onbekend type CPU', # Translate - New

## addons/Cloud.pack/tmpl/cfg_auto_update.tmpl
	'Auto update setting have been saved.' => 'Instellingen voor automatisch bijwerken werden opgeslagen.', # Translate - New
	'Current installed version of Movable Type is the latest version.' => 'Huidige geïnstalleerde versie van Movable Type is de meest recente.', # Translate - New
	'New version of Movable Type is available.' => 'Nieuwe versie van Movable Type beschikbaar.', # Translate - New
	'Last Update' => 'Laatste update', # Translate - Case
	'Movable Type [_1] on [_2]' => 'Movable Type [_1] op [_2]', # Translate - New
	'Available version' => 'Beschikbare versie', # Translate - New
	'Movable Type [_1] (released on [_2])' => 'Movable Type [_1] (uitgebracht op [_2])', # Translate - New
	'Your Movable Type will be automatically updated on [_1], regardless of your settings.' => 'Uw Movable Type installatie zal automatisch worden bijgewerkt op [_1], zonder rekening te houden met uw instellingen.', # Translate - New
	'Auto update' => 'Automatisch bijwerken', # Translate - New
	'Enable	automatic update of Movable Type' => 'Automatisch bijwerken van Movable Type inschakelen', # Translate - New

## addons/Cloud.pack/tmpl/cfg_basic_authentication.tmpl
	'Manage Basic Authentication' => 'Basic authenticatie beheren.', # Translate - New
	'/path/to/authentication' => '/pad/naar/authenticatie', # Translate - New
	'User ID' => 'Gebruikers ID', # Translate - New
	'URI is required.' => 'URI is vereist.', # Translate - New
	'Invalid URI.' => 'Ongeldige URI', # Translate - New
	'User ID must be with alphabet, number or symbols (excludes back slash) only.' => 'Gebruikers ID mag enkel bestaan uit letters, cijfers of symbolen (uitgezonderd backslash).', # Translate - New
	'Password must be with alphabet, number or symbols (excludes back slash) only.' => 'Wachtwoord ID mag enkel bestaan uit letters, cijfers of symbolen (uitgezonderd backslash).', # Translate - New
	'basic authentication setting' => 'instelling voor basic authenticatie', # Translate - New
	'basic authentication settings' => 'instellingen voor basic authenticatie', # Translate - New

## addons/Cloud.pack/tmpl/cfg_config_directives.tmpl
	'Configuration directive' => 'Configuratiedirectief', # Translate - New
	'Configuration value' => 'Configuratiewaarde', # Translate - New
	'Reference' => 'Referentie', # Translate - New

## addons/Cloud.pack/tmpl/cfg_disk_usage.tmpl
	'User Contents Files' => 'Inhoudsbestanden gebruiker', # Translate - New
	'Buckup Files' => 'Backupbestanden', # Translate - New
	'Free Disk Space' => 'Vrije schijfruimte', # Translate - New
	'User Contents' => 'Inhoud gebruiker', # Translate - New
	'Backup' => 'Backup', # Translate - Case
	'Others' => 'Andere', # Translate - New
	'Free' => 'Vrij', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ftps_password.tmpl
	'Reset FTPS Password' => 'FTPS wachtwoord opnieuw instellen', # Translate - New
	'Please select the account for which you want to reset the password.' => 'Selecteer de account waarvoor u het wachtwoord opnieuw wenst in te stellen.', # Translate - New
	'Owner Password' => 'Wachtwoord gebruiker', # Translate - New
	'Creator Password' => 'Wachtwoord aanmaker', # Translate - New
	'Password has been saved.' => 'Wachtwoord werd opgeslagen.', # Translate - New

## addons/Cloud.pack/tmpl/cfg_http_redirect.tmpl
	'Manage HTTP Redirect' => 'HTTP redirects instellen', # Translate - New
	'/path/of/redirect' => '/pad/naar/redirect', # Translate - New
	'http://example.com or /path/to/redirect' => 'http://voorbeeld.com of /pad/naar/redirect', # Translate - New
	'Redirect URL is required.' => 'Redirect URL is vereist.', # Translate - New
	'Redirect url is same as URI' => 'Redirect url is identiek aan URI', # Translate - New
	'HTTP redirect setting' => 'HTTP redirect instelling', # Translate - New
	'HTTP redirect settings' => 'HTPP redirect instellingen', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ip_restriction.tmpl
	'Administration screen settings have been saved.' => 'Instellingen voor administratiescherm zijn opgeslagen.', # Translate - New
	'Domain name like example.com' => 'Domeinnaam zoals voorbeeld.com', # Translate - New
	'Path begin with / like /path' => 'Pad begint met /, bijvoorbeeld /pad', # Translate - New
	'IP addresses that are allowed to access' => 'IP adressen die toestemming hebben voor toegang', # Translate - New
	'Domain is required.' => 'Domein is vereist.', # Translate - New
	'"[_1]" does not exist.' => '"[_1]" bestaat niet.', # Translate - New
	'Invalid Path.' => 'Ongeldig pad.', # Translate - New
	'This combination of domain and path already exists.' => 'Deze combinatie van domein en pad bestaat al.', # Translate - New
	'IP is required.' => 'IP is vereist.', # Translate - New
	'[_1] is invalid IP Address.' => '[_1] is een ongeldig IP adres.', # Translate - New
	'IP restriction settings' => 'Instellingen voor IP restricties', # Translate - New

## addons/Cloud.pack/tmpl/cfg_security.tmpl
	'Administration screen setting have been saved.' => 'nstellingen voor administratiescherm zijn opgeslagen.', # Translate - New
	'Administration screen url have been reset to default.' => 'URL voor administratiescherm is teruggezet naar de standaardwaarde.', # Translate - New
	'Admin Screen URL' => 'URL voor administratiescherm', # Translate - New
	'Protect administration screen by Basic Authentication' => 'Administratiescherm afschermen met basic authenticatie', # Translate - New
	'Access Restriction' => 'Toegangsrestrictie', # Translate - New
	'Restricts IP addresses that can access to administration screen.' => 'Beperkt welke IP adressen toegang hebben tot het administratiescherm.', # Translate - New
	'Please add the IP address which allows access to the upper list. You can specify multiple IP addresses separated by commas or line breaks. When the current remote IP address  is not contained, it may become impossible to access an administration screen. For details.' => 'Gelieve de IP adressen die toegang moeten krijgen toe te voegen aan bovenstaande lijst.  U kunt meerdere IP adressen invullen gescheiden door komma\'s of line breaks.  Vergeet niet uw huidige IP adres in te geven of het kan zijn dat u toegang verliest tot het administratiescherm.  Voor details.', # Translate - New
	'Your IP address is [_1].' => 'Uw IP adres is [_1].', # Translate - New
	'Restricts IP address that can access to public CGI such as Search and Data API.' => 'Beperkt de IP adressen die toegang hebben tot publieke CGI scripts zoals zoekresultaten en de Data API.', # Translate - New
	'IP address list is required.' => 'Lijst met IP adressen is vereist.', # Translate - New
	'administration screen' => 'administratiescherm', # Translate - New
	' and ' => ' en ', # Translate - New
	'public access CGI' => 'publieke CGI scripts', # Translate - New
	'The remote IP address is not included in the white list ([_1]). Are you sure you want to restrict the current remote IP address?' => 'Uw huidige IP adres is niet inbegrepen in de toegangslijst ([_1]). Bent u zeker dat u geen toegang wenst te geven aan uw huidige IP adres?', # Translate - New
	'Are you sure you want to save restrict access settings?' => 'Bent u zeker dat u de instellingen voor toegangsbeperking wenst op te slaan?', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ssl_certification.tmpl
	'Install SSL Certification' => 'SSL certificaat installeren', # Translate - New
	'SSL certification have been updated.' => 'SSL certificatie werd bijgewerkt.', # Translate - New
	'SSL certification have been reset to default.' => 'SSL certificatie werd teruggezet naar de standaardinstelling.', # Translate - New
	'The current server certification is as follows.' => 'De huidige servercertificatie is als volgt.', # Translate - New
	q{To [_1] the server certificate, please enter the required information in the following fields. To revert back to the initial certificate, please press the 'Remove SSL Certification' button. The passphrase for 'Secret Key' must be released.} => q{Om het servercertificaat te [_1], gelieve de vereiste informatie in te vullen in volgende velden. Om terug te keren naar het originele certificaat klikt u op de knop 'SSL Certificaat Verwijderen'.  Het wachtwoord voor 'Geheime Sleutel' moet worden vrijgegeven.}, # Translate - New
	'Server Certification' => 'Servercertificatie', # Translate - New
	'Secret Key' => 'Geheime Sleutel', # Translate - New
	'Intermediate Certification' => 'Tussentijdse certificatie', # Translate - New
	'Remove SSL Certification' => 'SSL Certificaat Verwijderen', # Translate - New

## addons/Cloud.pack/tmpl/full_restore.tmpl
	'Restoring Full Backup Data' => 'Bezig volledige backupgegevens te herstellen', # Translate - New
	q{Restored backup data from '[_1]' at [_2]} => q{Voledige backup hersteld van '[_1]' om [_2]}, # Translate - New
	'When restoring back-up data, the contents will revert to the point when the back-up data was created. Please note that any changes made to the data, contents, and received comments and trackback after this restoration point will be discarded. Also, while in the process of restoration, any present data will be backed up automatically. After restoration is complete, it is possible to return to the status of the data before restoration was executed.' => 'Wanneer gegevens worden hersteld uit een backup zal alle inhoud teruggezet worden naar het moment waarop de backup werd aangemaakt.  Merk op dat alle wijzigingen die werden gemaakt aan de gegevens, inhoud en ontvangen reacties en trackbacks na dit herstelpunt verloren zullen gaan. Bijkomend zal tijdens het terugzetten een automatische backup worden gemaakt van de huidige gegevens.  Nadat herstel is afgerond is het nog mogelijk om terug te keren naar de status van de gegevens voor het herstel werd uitgevoerd.', # Translate - New
	'Restore' => 'Herstel', # Translate - New
	'Are you sure you want restore from selected backup file?' => 'Bent u zeker dat u wenst te herstellen uit het geselecteerde backupbestand?', # Translate - New

## addons/Commercial.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype',
	q{Professionally designed, well-structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.} => q{Professioneel ontworpen, goed gestructureerde en makkelijk aan te passen website.  U kunt standaarpagina's, voettekst en topnavigatie makkelijk personaliseren.},
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
	'Template tag' => 'Sjabloontag',
	'Updating Universal Template Set to Professional Website set...' => 'Universele sjabloonset bij aan het werken tot Professionele Website sjabloonset...',
	'Migrating CustomFields type...' => 'Bezig CustomFields type te migreren...',
	'Converting CustomField type...' => 'Bezig CustomFields types te converteren...',
	'Professional Styles' => 'Professionele stijlen',
	'A collection of styles compatible with Professional themes.' => 'Een verzameling stijlen compatibel met Professionele thema\'s',
	'Professional Website' => 'Professionele Website',
	'Entry Listing' => 'Overzicht berichten',
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
	'Date & Time' => 'Datum en tijd',
	'Date Only' => 'Enkel datum',
	'Time Only' => 'Enkel tijd',
	q{Please enter all allowable options for this field as a comma delimited list} => q{Gelieve alle toegestane waarden voor dit veld in te vullen als een lijst gescheiden door komma's},
	'Exclude Custom Fields' => 'Extra velden negeren',
	'[_1] Fields' => 'Velden bij [_1]',
	'Create Custom Field' => 'Gepersonaliseerd veld aanmeken',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; datums moeten in het formaat YYYY-MM-DD HH:MM:SS staan.',
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
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Pas de formulieren en velden aan voor berichten, pagina\'s, mappen, categoriÃ«n en gebruikers aan en sla exact die informatie op die u nodig heeft.',
	' ' => ' ',
	'Single-Line Text' => 'Een regel tekst',
	'Multi-Line Text' => 'Meerdere regels tekst',
	'Checkbox' => 'Checkbox',
	'Drop Down Menu' => 'Uitklapmenu',
	'Radio Buttons' => 'Radiobuttons',
	'Embed Object' => 'Embedded object',
	'Post Type' => 'Type bericht',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Importing custom fields data stored in MT::PluginData...' => 'Bezig gegevens voor gepersonaliseerde velden te importeren die opgeslagen is in MT::PluginData...',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Bezig koppelingen met mediabestanden te importeren gevonden in gepersonaliseerde velden ( [_1] )...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Bezig url van de mediabestanden te importeren gevonden in gepersonaliseerde velden ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'The type "[_1]" is invalid.' => 'Het type "]_1]" is ongeldig.',
	'The systemObject "[_1]" is invalid.' => 'Het systemObject "[_1]" is ongeldig.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Ongeldige datum \'[_1]\'; datums moeten echte datums zijn.',
	'Please enter valid option for the [_1] field: [_2]' => 'Gelieve een geldige optie in te vullen voor het [_1] veld: [_2]',

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
	'Case sensitive' => 'Hoofdlettergevoelig',

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Deze velden tonen',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Gepersonaliseerd veld bewerken',
	'The selected field(s) has been deleted from the database.' => 'Geselecteerd(e) veld(en) verwijderd uit de database.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'U moet gegevens invullen in de vereiste velden die hieronder aangegeven zijn voor het gepersonaliseerde veld aangemaakt kan worden.',
	'You must save this custom field before setting a default value.' => 'U moet het gepersonaliseerde veld opslaan voor u een standaardwaarde kunt instellen.',
	'Choose the system object where this custom field should appear.' => 'Kies het systeemobject waarbij het gepersonaliseerde veld moet verschijnen.',
	'Required?' => 'Verplicht?',
	'Must the user enter data into this custom field before the object may be saved?' => 'Moet de gebruiker gegevens invullen in dit gepersonaliseerde veld voor het object opgeslagen kan worden?',
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

## addons/Enterprise.pack/app-cms.yaml
	'Bulk Author Export' => 'Auteurs exporteren in bulk',
	'Bulk Author Import' => 'Auteurs importeren in bulk',
	'Synchronize Users' => 'Gebruikers synchroniseren',
	'Synchronize Groups' => 'Groepen synchroniseren',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Deze module is vereist als u LDAP authenticatie wenst te gebruiken.',

## addons/Enterprise.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype',
	'Advanced Pack' => 'Advanced pack',
	'Oracle Database (Recommended)' => 'Oracle database (aangeradenÃ ',
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
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => 'Â´[_1] directief moet ingesteld zijn om leden van een LDAP groep te synchroniseren naar Movable Type Advanced',
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
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Een gebruiker met dezelfde naam werd gevonden.  De registratie werd niet uitgevoerd: [_1]',
	'Permission granted to user \'[_1]\'' => 'Permissie toegekend aan gebruiker \{[_1]\'',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => 'Gebruiker  \'[_1]\' bestaat al.  De update werd niet doorgevoerd: [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'Gebruiker  \'[_1]\' niet gevonden.  De update werd niet doorgevoerd.',
	'User \'[_1]\' has been updated.' => 'Gebruiker \'[_1]\' is bijgewerkt.',
	'User \'[_1]\' was found, but the deletion was not processed' => 'Gebruiker  \'[_1]\' werd gevonden maar de verwijdering werd niet uitgevoerd.',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'Gebruiker  \'[_1]\' werd niet gevonden.  De verwijdering werd niet uitgevoerd.',
	'User \'[_1]\' has been deleted.' => 'Gebruiker \'[_1]\' werd verwijderd.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Advanced probeerde net uw account uit te schakelen tijdens synchronisatie met de externe directory.  Er moet een fout zitten in de instellingen voor extern gebruikersbeheer.  Gelieve uw configuratie bij te stellen voor u verder gaat.',
	'Bulk import cannot be used under external user management.' => 'Bulk import kan niet worden gebruikt onder extern gebruikersbeheer.',
	'Users & Groups' => 'Gebruikers & Groepen',
	'Bulk management' => 'Bulkbeheer',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Er werden geen records gevonden in het bestand.  Kijk na of het bestand CRLF gebruiker als einde-regel karakters.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '[quant,_1,Gebruiker,Gebruikers] geregistreerd, [quant,_2,gebruiker,gebruikers] bijgewerkt, [quant,_3,gebruiker,gebruikers] verwijderd.',
	'Bulk author export cannot be used under external user management.' => 'Bulk export van auteurs kan niet gebruikt worden onder extern gebruikersbeheer.',
	'A user cannot change his/her own username in this environment.' => 'Een gebruiker kan zijn/haar gebruikersnaam niet aanpassen in deze omgeving',
	'An error occurred when enabling this user.' => 'Er deed zich een fout voor bij het activeren van deze gebruiker.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm

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

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'Ongeldig LDAPAuthURL schema: [_1].',
	'Error connecting to LDAP server [_1]: [_2]' => 'Probleem bij connecteren naar LDAP server [_1]: [_2]',
	'Entry not found in LDAP: [_1]' => 'Item niet gevonden in LDAP: [_1]',
	'Binding to LDAP server failed: [_1]' => 'Binden aan LDAP server mislukt: [_1]',
	'User not found in LDAP: [_1]' => 'Gebruiker niet gevonden in LDAP: [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'Meer dan Ã©Ã©n gebruiker met dezelfde naam gevonden in LDAP: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] wordt niet ondersteund in deze versie van de MS SQL Server Driver',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Deze versie van de UMSSQLServer driver vereist DBD::ODBC versie 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Deze verie van de UMSSQLServer driver vereist DBD::ODBC gecompileerd met Unicode ondersteuning.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Gebruikers beheren in bulk',
	'_USAGE_AUTHORS_2' => 'U kunt gebruikers aanmaken, bewerken en verwijderen in bulk door een CSV-geformatteerd bestand te uploaden dat de juiste instructies en relevante gegevens bevat.',
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

## addons/Sync.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.sixapart.com/movabletype',
	'Migrated sync setting' => 'Synchronisatie-instellingen gemigreerd',
	'Content Delivery' => 'Content delivery',
	'Sync Name' => 'Synchronisatie naam',
	'Sync Datetime' => 'Synchronisatie datum en tijd',
	'Manage Sync Settings' => 'Synchronisatie instellingen beheren',
	'Sync Setting' => 'Synchronsatie instelling',
	'Sync Settings' => 'Synchronisatie instellingen',
	'Create new sync setting' => 'Nieuwe synchronisatie instelling aanmaken',
	'Contents Sync' => 'Synchronisatie inhoud',
	'Remove sync PID files' => 'PID bestanden synchronisatie verwijderen',
	'Updating MT::SyncSetting table...' => 'Bezig MT::SyncSetting tabel bij te werken...',
	'Migrating settings of contents sync on website...' => 'Bezig instellingen van inhoudssynchronisatie op website te migreren...',
	'Migrating settings of contents sync on blog...' => 'Bezig instellingen van inhoudssynchronisatie op blog te migreren..',
	'Re-creating job of contents sync...' => 'Inhoudsssynchronisatie job opnieuw aan het aanmaken...',

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'Geen toegang tot externe map \'[_1]\'',
	'Deleting file \'[_1]\' failed.' => 'Verwijderen bestand \'[_1]\' mislukt.',
	'Deleting path \'[_1]\' failed.' => 'Verwijderen pad \'[_1]\' mislukt.',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Er bestaat een bestand of map waarvan de naam eindigt op een punt(.) of een blanco extansie. Kan deze bestanden niet synchroniseren.: "[_1]"',
	'Unable to write temporary file ([_1]): [_2]' => 'Schrijven naar tijdelijk bestand mislukt ([_1]): [_2]',
	'Unable to get size of temporary file ([_1]): [_2]' => 'Kon grootte van tijdelijk bestand niet vinden ([_1]): [_2]',
	'FTP reconnection was failed. ([_1])' => 'FTP verbinding mislukt. ([_])',
	'FTP connection lost.' => 'FTP verbinding verbroken.',
	'FTP connection timeout.' => 'FTP verbinding te lang inactief.',
	'Unable to write remote files. Please check activity log for more details.: [_1]' => 'Schrijven van externe bestanden mislukt.  Kijk het activiteitenlog na voor meer details: [_1]',
	'Unable to write remote files ([_1]): [_2]' => 'Kon geen externe bestanden schrijven ([_1]): [_2]',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Failed to remove sync list. (ID:\'[_1]\')' => 'Verwijderen sychronisatielijst mislukt. (ID:\'[_1]\')',
	'Failed to update sync list. (ID:\'[_1]\')' => 'Bijwerken synchronisatielijst mislukt. (ID:\'[_1]\')',
	'Failed to create sync list.' => 'Aanmaken synchronisatielijst mislukt.',
	'Failed to save sync list. (ID:\'[_1]\')' => 'Opslaan synchronisatielijst mislukt. (ID:\'[_1]\')',
	'Error switching directory.' => 'Fout bij wisselen van map.',
	'Synchronization([_1]) with an external server([_2]) has been successfully finished.' => 'Synchronisatie ([_1]) met een externe server ([_2]) werd met succes afgerond.',
	'Failed to Synchronization([_1]) with an external server([_2]).' => 'Synchronisatie ([_1]) met een externe server ([_2]) is niet gelukt.',

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Temp Directory [_1] is not writable.' => 'Tijdelijke map [_1] niet beschrijfbaar.',
	'Incomplete file copy to Temp Directory.' => 'Onvolledige bestandskopie naar de tijdelijke map', # Translate - New
	'Failed to remove "[_1]": [_2]' => 'Verwijderen van "[_1]" mislukt: [_2]', # Translate - New
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Fout tijdens rsync: commando (exitcode [_1]): [_2]',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Bestandslijst synchronisatie',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Instellingen synchronisatie',

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	'Sync setting # [_1] not found.' => 'Synchronisatie instelling # [_1] niet gevonden.',
	'This sync setting is being processed already.' => 'Deze synchronisatie-instelling wordt al behandeld momenteel.',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'Deze mail is om u te melden dat synchronisatie met een externe server met succes werd afgerond.',
	'Saving sync settings failed: [_1]' => 'Opslaan instelling voor synchronisatie mislukt: [_1]',
	'Failed to remove temporary directory: [_1]' => 'Verwijderen van tijdelijke map mislukt: [_1]',
	'Failed to remove pid file.' => 'Verwijderen van pid bestand mislukt.',
	'This email is to notify you that failed to sync with an external server.' => 'Deze mail is om u te melden dat synchronisatie met een externe server mislukt is.',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Copied [_1]' => '[_1] gekopiÃ«erd',
	'Create Sync Setting' => 'Sync instelling aanmaken',
	'The sync setting with the same name already exists.' => 'Een synchronisatie instelling met dezelfde naam bestaat al.',
	'Reached the upper limit of the parallel execution.' => 'Maximumlimiet voor uitvoering in paralel bereikt.',
	'Process ID can\'t be acquired.' => 'Kan proces ID niet vinden.',
	'Sync setting \'[_1]\' (ID: [_2]) edited by [_3].' => 'Sync instelling \'[_1]\' (ID: [_2]) bewerkt door [_3].',
	'Sync setting \'[_1]\' (ID: [_2]) deleted by [_3].' => 'Sync instelling \'[_1]\' (ID: [_2]) verwijderd door [_3].',
	'An error occurred while attempting to connect to the FTP server \'[_1]\': [_2]' => 'Er deed zich een fout voor bij het verbinden met de FTP server \'[_1]\': [_2]',
	'An error occurred while attempting to retrieve the current directory from \'[_1]\'' => 'Er deed zich een fout voor bij het ophalen van de huidige map van \'[_1]\'',
	'An error occurred while attempting to retrieve the list of directories from \'[_1]\'' => 'Er deed zich een fout voor bij het ophalen van de lijst van mappen van \'[_1]\'',

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Bezig alle inhoudssynchronisatie-jobs te verwijderen...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Settings' => 'Instellingen synchronisatie inhoud',
	'Contents sync settings has been saved.' => 'De instellingen voor synchronisatie van inhoud zijn opgeslagen.',
	'The sync settings has been copied but not saved yet.' => 'De synchronisatie instellingen zijn gekopiÃ«erd maar nog niet opgeslagen.',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'EÃ©n of meer sjablonen staan ingesteld om dynamisch gepubliceerd te worden. Dynamisch publiceren werkt mogelijk niet op de bestemmings-server.',
	'Run synchronization now' => 'Nu synchroniseren',
	'Copy this sync setting' => 'Deze synchronisatie instelling kopiÃ«ren',
	'Sync Date' => 'Synchronisatiedatum',
	'Recipient for Notification' => 'Ontvanger van berichten',
	'Receive only error notification' => 'Enkel foutmeldingen ontvangen',
	'htaccess' => 'htaccess',
	'Do not send .htaccess and .htpasswd file' => 'Stuur geen .htaccess en .htpasswd bestand',
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
	'Are you sure you want to run synchronization?' => 'Bent u zeker dat u synchronisatie wenst uit te voeren?',
	'Sync all files' => 'Alle bestanden synchroniseren',
	'Please select a sync type.' => 'Gelieve een synchronisatietype in te stellen.',
	'Sync name is required.' => 'Synchroniatienaam is vereist.',
	'Sync name should be shorter than [_1] characters.' => 'Synchronisatienaam moet korter dan [_1] karakters zijn.',
	'The sync date must be in the future.' => 'De synchronisatiedatum moet in de toekomst liggen.',
	'Invalid time.' => 'Ongeldig tijdstip;',
	'You must make one or more destination settings.' => 'U moet Ã©Ã©n of meer bestemmingen instellen.',
	'Are you sure you want to remove this settings?' => 'Bent u zeker dat u deze instellingen wil verwijderen?',

## addons/Sync.pack/tmpl/dialog/contents_sync_now.tmpl
	'Sync Now!' => 'Nu synchroniseren!',
	'Preparing...' => 'Voorbereiding...',
	'Synchronizing...' => 'Synchroniseren...',
	'Finish!' => 'Klaar!',
	'The synchronization was interrupted. Unable to resume.' => 'De synchronisatie werd onderbroken.  Hervatten niet mogelijk.',

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Blok editor.',
	'Block Editor' => 'Blok editor',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => 'Nieuwe afbeelding upladen',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => 'Sorteren', # Translate - New
	'No block in this field.' => 'Geen blok in dit veld', # Translate - New
	'Changing to plain text is not possible to return to the block edit.' => 'Na veranderen naar gewone tekst is het niet mogelijk de inhoud terug te brengen naar blok edit modus.',
	'Changing to block editor is not possible to result return to your current document.' => 'Na veranderen naar de blok editor is niet mogelijk om resultaat terug te brengen naar uw huidige document.',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt',
	'Caption' => 'Onderschrift',

## plugins/Comments/config.yaml
	'Provides Comments.' => 'Levert reacties.',
	'Mark as Spam' => 'Markeren als spam',
	'Remove Spam status' => 'Spamstatus verwijderen',
	'Unpublish Comment(s)' => 'Publicatie ongedaan maken',
	'Trust Commenter(s)' => 'Reageerder(s) vertrouwen',
	'Untrust Commenter(s)' => 'Reageerder(s) niet meer vertrouwen',
	'Ban Commenter(s)' => 'Reageerder(s) verbannen',
	'Unban Commenter(s)' => 'Verbanning opheffen',
	'Registration' => 'Registratie',
	'Manage Commenters' => 'Reageerders beheren',
	'Comment throttle' => 'Beperking reacties',
	'Commenter Confirm' => 'Bevestiging reageerder',
	'Commenter Notify' => 'Notificatie reageerder',
	'New Comment' => 'Nieuwe reactie',

## plugins/Comments/default_templates/comment_detail.mtml

## plugins/Comments/default_templates/commenter_confirm.mtml
	'Thank you for registering an account to comment on [_1].' => 'Bedankt om een account aan te maken om te kunnen reageren op [_1].',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Voor uw eigen veiligheid en om fraude tegen te gaan, vragen we u om uw account en email adres te bevestigen vooraleer verder te gaan.  Zodra uw account bevestigd is, kunt u meteen reageren op [_1].',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'Om uw account te bevestigen moet u op volgende URL klikken of hem in uw webbrowser knippen en plakken.',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Als u deze account niet heeft aangevraagd, of als u niet de bedoeling had te registreren om te kunnen reageren op [_1] dan hoeft u verder niets te doen.},
	'Sincerely,' => 'Hoogachtend,',

## plugins/Comments/default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Deze email dient om u te melden dat een nieuwe gebruiker zich met succes heeft aangemeld op de blog '[_1]'.  Hier is wat meer informatie over deze nieuwe gebruiker.},
	'New User Information:' => 'Info nieuwe gebruiker:',
	'Full Name: [_1]' => 'Volledige naam: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Om deze gebruiker te bekijken of te bewerken, klik op deze link of plak de URL in een webbrowser:',

## plugins/Comments/default_templates/comment_listing.mtml

## plugins/Comments/default_templates/comment_preview.mtml

## plugins/Comments/default_templates/comment_response.mtml

## plugins/Comments/default_templates/comments.mtml

## plugins/Comments/default_templates/comment_throttle.mtml
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Als dit een vergissing was dan kunt u het IP adres deblokkeren en de bezoeker toelaten om het opnieuw toe te voegen door u aan te melden bij uw Movable Type installatie.  Ga vervolgens naar Blog Config - IP Blokkering en verwijder het IP adres [_1] uit de lijst van geblokkeerde adressen.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Een bezoeker van uw weblog [_1] is automatisch uitgesloten omdat dez meer dan het toegestane aantal reacties heeft gepubliceerd in de laatste [_2] seconden.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Dit werd gedaan om te voorkomen dat een kwaadaardig script uw weblog zou overspoelen met reacties. Het geblokkeerde IP adres is',

## plugins/Comments/default_templates/new-comment.mtml
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

## plugins/Comments/default_templates/recent_comments.mtml

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'[_1] Comments' => '[_1] reacties',
	'All Comments' => 'Alle reacties',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'Bent u zeker dat u alle reacties die als spam aangemerkt staan wenst te verwijderen?',
	'Delete all Spam comments' => 'Alle spamreacties verwijderen.',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Reacties worden gekloond voor blog...',

## plugins/Comments/lib/Comments/CMS/Search.pm

## plugins/Comments/lib/Comments/Import.pm
	'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',

## plugins/Comments/lib/Comments.pm
	'Search for other comments from anonymous commenters' => 'Zoeken naar andere reacties van anonieme reageerders',
	'__ANONYMOUS_COMMENTER' => 'Anoniem',
	'Search for other comments from this deleted commenter' => 'Zoeken naar andere reacties van deze verwijderde reageerder',
	'(Deleted)' => '(Verwijderd)',
	'Edit this [_1] commenter.' => 'Bewerk deze [_1] reageerder',
	'Comments on [_1]: [_2]' => 'Reacties op [_1]: [_2]',
	'Not spam' => 'Geen spam',
	'Reported as spam' => 'Gerapporteerd als spam',
	'All comments by [_1] \'[_2]\'' => 'Alle reacties van [_1] \'[_2]\'',
	'__COMMENTER_APPROVED' => 'Goedgekeurd',
	'Moderator' => 'Moderator',
	'Can comment and manage feedback.' => 'Kan reageren en feedback beheren',
	'Can comment.' => 'Kan reageren.',
	'Comments on My Entries/Pages' => 'Reacties op mijn berichten/pagina\'s',
	'Entry/Page Status' => 'Status bericht/pagina',
	'Date Commented' => 'Datum gereageerd',
	'Comments in This Website' => 'Reacties op deze website',
	'Non-spam comments' => 'Non-spam reacties',
	'Non-spam comments on this website' => 'Non-spam reacties op deze website',
	'Pending comments' => 'Te modereren reacties',
	'Published comments' => 'Gepubliceerde reacties',
	'Comments on my entries/pages' => 'Reacties op mijn berichten/pagina\'s',
	'Comments in the last 7 days' => 'Reacties in de afgelopen 7 dagen',
	'Spam comments' => 'Spamreacties',
	'Enabled Commenters' => 'Actieve reageerders',
	'Disabled Commenters' => 'Gedesactiveerde reageerders',
	'Pending Commenters' => 'Reageerders in aanvraag',
	'Externally Authenticated Commenters' => 'Extern geauthenticeerde reageerders',
	'Entries with Comments Within the Last 7 Days' => 'Berichten met reacties in de laatste zeven dagen',
	'Pages with comments in the last 7 days' => 'Pagina\'s waarop in de laatste zeven dagen gereageerd werd',

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Bezig initiõ�¼„e rollen aan te maken voor reacties...',

## plugins/Comments/lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fout bij het toekennen van reactierechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'.  Er werd geen geschikte reageerder-rol gevonden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ongeldige aanmeldpoging van een reageerder [_1] op blog [_2](ID: [_3]) waar geenMovable Type native authenticatie is toegelaten.',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'U bent met succes aangemeld, maar registratie is niet toegestaan op dit moment.  Gelieve contact op te nemen met uw Movable Type systeembeheerder.',
	'You need to sign up first.' => 'U moet zich eerst registreren',
	'Login failed: permission denied for user \'[_1]\'' => 'Aanmelden mislukt: permissie geweigerd aan gebruiker \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Aanmelden mislukt: fout in wachtwoord van gebruiker \'[_1]\'',
	'Signing up is not allowed.' => 'Registreren is niet toegestaan.',
	'Movable Type Account Confirmation' => 'Movable Type accountbevestiging',
	'Your confirmation has expired. Please register again.' => 'Uw bevestigingsperiode is afgelopen.  Gelieve opnieuw te registreren.',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Terugkeren naar de oorspronkelijke pagina.</a>',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Reageerder \'[_1]\' (ID:[_2]) heeft zich met succes geregistreerd.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden om te reageren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] registreerde zich op blog \'[_2]\'',
	'No id' => 'Geen id',
	'No such comment' => 'Reactie niet gevonden',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
	'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
	'No such entry \'[_1]\'.' => 'Geen bericht \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'U heeft in een korte periode te veel reacties achtergelaten.  Gelieve over enige tijd opnieuw te proberen.',
	'Comments are not allowed on this entry.' => 'Reacties op dit bericht zijn niet toegelaten.',
	'Comment text is required.' => 'Tekst van de reactie is verplicht.',
	'Registration is required.' => 'Registratie is verplicht.',
	'Name and E-mail address are required.' => 'Naam en e-mail adres zijn vereist',
	'Invalid URL \'[_1]\'' => 'Ongeldige URL \'[_1]\'',
	'Comment save failed with [_1]' => 'Opslaan van reactie mislukt met [_1]',
	'Comment on "[_1]" by [_2].' => 'Reactie op "[_1]" door [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Mislukte poging om een reactie achter te laten van op registratie wachtende gebruiker \'[_1]\'',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'U probeert om te leiden naar externe bronnen.  Als u de site vertrouwt, klik dan op de link: [_1]',
	'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
	'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
	'Invalid entry ID provided' => 'Ongeldig berichtID opgegeven',
	'All required fields must be populated.' => 'Alle vereiste velden moeten worden ingevuld.',
	'Commenter profile has successfully been updated.' => 'Reageerdersprofiel is met succes bijgewerkt.',
	'Commenter profile could not be updated: [_1]' => 'Reageerdersprofiel kon niet worden bijgewerkt: [_1]',

## plugins/Comments/lib/MT/CMS/Comment.pm
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

## plugins/Comments/lib/MT/DataAPI/Endpoint/Comment.pm

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Deze \'[_1]\' tag word niet meer gebruikt.  Gelieve \'[_2]\' te gebruiken.',

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'De MTCommentFields tag is niet langer beschikbaar.  Gelieve in de plaats de [_1] sjabloonmodule te includeren.',

## plugins/Comments/php/function.mtcommentauthorlink.php

## plugins/Comments/php/function.mtcommentauthor.php

## plugins/Comments/php/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'De \'[_1]\' tag is verouderd.  Gelieve de \'[_2]\' tag te gebruiken ter vervanging.',

## plugins/Comments/php/function.mtcommentreplytolink.php

## plugins/Comments/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Afbeelding foto',

## plugins/Comments/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Originele test',

## plugins/Comments/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/FacebookCommenters/config.yaml
	'Provides commenter registration through Facebook Connect.' => 'Voegt registratie van reageerders toe via Facebook Connect.',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Facebook Reageerders plugin instellen',
	'The login could not be confirmed because of no/invalid blog_id' => 'Aanmelding kon niet worden bevestigd wegens geen/ongeldig blog_id',
	'Authentication failure: [_1], reason:[_2]' => 'Authenticatie mislukt: [_1], reden: [_2]',
	'Failed to created commenter.' => 'Aanmaken reageerder mislukt.',
	'Failed to create a session.' => 'Aanmaken sessie mislukt.',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Facebook Commenters vereist dat ofwel Crypt::SSLeay of IO::Socket::SSL geÏnstalleerd zijn om met Facebook te kunnen communiceren.',
	'Please enter your Facebook App key and secret.' => 'Gelieve uw Facebook App key en secret in te vullen.',
	'Could not verify this app with Facebook: [_1]' => 'Kon deze app niet verifiÃ«ren bij Facebook: [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'OAuth Redirect URL of Facebook Login' => 'OAuth omleidings-URL of Facebook login',
	'Please set this URL to "Valid OAuth redirect URIs" field of Facebook Login.' => 'Gelieve deze URL in te stellen naar de waarde van het "Valid OAuth redirect URIs" veld van Facebook Login.',
	'Facebook App ID' => 'Facebook applicatiesleutel',
	'The key for the Facebook application associated with your blog.' => 'De sleutel voor de Facebook-applicatie geassocieerd met uw blog.',
	'Edit Facebook App' => 'Facebook app bewerken',
	'Create Facebook App' => 'Facebook app aanmaken',
	'Facebook Application Secret' => 'Facebook applicatiegeheim',
	'The secret for the Facebook application associated with your blog.' => 'Het geheim voor de Facebook-applicatie geassocieerd met uw blog.',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Standaardtekst beheren.',
	'Boilerplate' => 'Standaardtekst',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'De "Standaardtekst invoegen" knop toevoegen aan TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Boilerplate' => 'Standaardtekst',
	'Select a Boilerplate' => 'Selecteer een standaardtekst.',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Boilerplates' => 'Standaardteksten',
	'Create Boilerplate' => 'Standaardtekst aanmaken',
	'Are you sure you want to delete the selected boilerplates?' => 'Bent u zeker dat u de geselecteerde standaardtekst wenst te verwijderen?',
	'Boilerplate' => 'Standaardtekst',
	'My Boilerplate' => 'Mijn standaardteksten',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'De standaardtekst \'[_1]\' wordt al gebruikt op deze site.',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Standaardtekst \'[_1]\' wordt al gebruikt op deze blog.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Standaardtekst bewerken',
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
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Maak een Client ID voor webapplicaties aan van een OAuth2 applicatie met deze redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> vooraleer een profiel te selecteren. },
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

## plugins/OpenID/config.yaml
	'Provides OpenID authentication.' => 'Verschaft OpenID authenticatie.',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Een Perl module vereist voor authenticatie van reageerders via Google ID ontbreekt: [_1]',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'Kon de sessie niet opslaan',
	'Could not load Net::OpenID::Consumer.' => 'Kon Net::OpenID::Consumer niet laden.',
	'The address entered does not appear to be an OpenID endpoint.' => 'Het adres dat werd ingevuld lijkt geen OpenID endpoint te zijn.',
	'The text entered does not appear to be a valid web address.' => 'De ingevulde tekst lijkt geen geldig webadres te zijn.',
	'Unable to connect to [_1]: [_2]' => 'Kon niet verbinden met [_1]: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'Kon de opgegeven OpenID niet verifiÃ«ren: [_1]',

## plugins/OpenID/tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Uw AIM of AOL gebruikersnaam',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Meld u aan met uw AIM of AOL gebruikernaam.  Deze zal publiek te zien zijn.',

## plugins/OpenID/tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Aanmelden met uw Gmail account',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Aanmelden bij Movable Type met uw[_1] Account[_2]',

## plugins/OpenID/tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Uw Hatena ID',

## plugins/OpenID/tmpl/comment/auth_livedoor.tmpl

## plugins/OpenID/tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Uw LiveJournal gebruikersnaam',
	'Learn more about LiveJournal.' => 'Meer weten over LiveJournal.',

## plugins/OpenID/tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'OpenID URL',
	'Sign in with one of your existing third party OpenID accounts.' => 'Aanmelden met een bestaande OpenID account.',
	'http://www.openid.net/' => 'http://www.openid.net/',
	'Learn more about OpenID.' => 'Meer weten over OpenID.',

## plugins/OpenID/tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Uw Wordpress.com gebruikersnaam',
	'Sign in using your WordPress.com username.' => 'Meld u aan met uw Wordpress.com gebruikersnaam',

## plugins/OpenID/tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'OpenID nu inschakelen voor uw Yahoo! Japan account',

## plugins/OpenID/tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Nu OpenID inschakelen voor uw Yahoo! account',

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
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups houden de bron IP adressen en hyperlinks van alle binnenkomende feedback in het og.  Als een reactie of TrackBack afkomstig is van een IP adres of domein op de zwarte lijst kan het tegengehouden worden voor moderatie of meteen als rommel worden aangemerkt en in de junk-map worden geplaatst.  Bijkomend kunnen geavanceerde lookups uitgevoerd worden op de brongegevens van trackbacks.},
	'IP Address Lookups' => 'Opzoeken IP adressen',
	'Moderate feedback from blacklisted IP addresses' => 'Feedback modereren van IP adressen op de zwarte lijst',
	'Junk feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst een spamscore toekennen',
	'Adjust scoring' => 'Score bijwerken',
	'Score weight:' => 'Scoregewicht',
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

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Een mensvriendelijke tekstgenerator',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Standaard WYSIWYG editor.',
	'TinyMCE' => 'TinyMCE',

## plugins/Trackback/config.yaml
	'Provides Trackback.' => 'Verschaft trackback.',
	'Mark as Spam' => 'Markeren als spam',
	'Remove Spam status' => 'Spamstatus verwijderen',
	'Unpublish TrackBack(s)' => 'Publicatie ongedaan maken',
	'weblogs.com' => 'weblogs.com',
	'New Ping' => 'Nieuwe ping',

## plugins/Trackback/default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Een niet goedgekeurde TrackBack werd achtergelaten op uw site '[_1]', op categorie #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voor hij op uw site verschijnt.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op bericht #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op pagina #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Een nieuwe TrackBack werd achtergelaten op uw site '[_1]', op categorie #[_2] ([_3]).},
	'Approve TrackBack' => 'TrackBack goedkeuren',
	'View TrackBack' => 'TrackBack bekijken',
	'Report TrackBack as spam' => 'TrackBack melden als spam',
	'Edit TrackBack' => 'TrackBack bewerken',

## plugins/Trackback/default_templates/trackbacks.mtml

## plugins/Trackback/lib/MT/App/Trackback.pm
	'You must define a Ping template in order to display pings.' => 'U moet een pingsjabloon definiÃ«ren om pings te kunnen tonen.',
	'Trackback pings must use HTTP POST' => 'Trackback pings moeten HTTP POST gebruiken',
	'TrackBack ID (tb_id) is required.' => 'TrackBack ID (tb_id) is vereist.',
	'Invalid TrackBack ID \'[_1]\'' => 'Ongeldig TrackBack-ID \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'U heeft geen toestemming om TrackBack pings te versturen.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'U stuurt te veel TrackBack pings achter elkaar.  Gelieve la
ter opnieuw te proberen.',
	'You need to provide a Source URL (url).' => 'U moet een Source URL (url) opgeven.',
	'Invalid URL \'[_1]\'' => 'Ongeldige URL URL \'[_1]\'',
	'This TrackBack item is disabled.' => 'Dit TrackBack item is uitgeschakeld.',
	'This TrackBack item is protected by a passphrase.' => 'Dit TrackBack item is beschermd door een wachtwoord.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack op "[_1]" van "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack op categorie \'[_1]\' (ID:[_2]).',
	'Cannot create RSS feed \'[_1]\': ' => 'Kan RSS feed \'[_1]\' niet aanmaken: ',
	'New TrackBack ping to \'[_1]\'' => 'Nieuwe TrackBack ping op \'[_1]\'',
	'New TrackBack ping to category \'[_1]\'' => 'Nieuwe TrackBack ping op categorie \'[_1]\'',

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Categorie zonder label)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van
 categorie \'[_4]\'',
	'(Untitled entry)' => '(Bericht zonder titel)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van be
richt \'[_4]\'',
	'No Excerpt' => 'Geen uittreksel',
	'Orphaned TrackBack' => 'Verweesde TrackBack',
	'category' => 'categorie',

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> moet gebruikt worden in een categorie, of met het \'category\' attribuute van de tag.',

## plugins/Trackback/lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Geen WeblogsPingURL opgegeven in het configuratiebestand',
	'No MTPingURL defined in the configuration file' => 'Geen MTPingURL opgegeven in het configuratiebestand',
	'HTTP error: [_1]' => 'HTTP fout: [_1]',
	'Ping error: [_1]' => 'Ping fout: [_1]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Alle TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Bent u zeker dat u alle trackbacks die als spam aangemerkt staan wenst te verwijderen?',
	'Delete all Spam trackbacks' => 'Alle spam-TrackBacks verwijderen',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBacks for blog...' => 'Trackbacks worden gekloond voor blog...',
	'Cloning TrackBack pings for blog...' => 'TrackBack pings worden gekloond voor blog...',

## plugins/Trackback/lib/Trackback/CMS/Comment.pm
	'You do not have permission to approve this trackback.' => 'U heeft geen permissies om deze trackback goed te keuren.',
	'The entry corresponding to this comment is missing.' => 'Het bericht dat bij deze reactie hoort, ontbreekt.',
	'You do not have permission to approve this comment.' => 'U heeft geen permissie om deze reactie goed te keuren.',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' mislukt: [_2]',

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'Bron URL',

## plugins/Trackback/lib/Trackback/Import.pm
	'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping van: [_2] - [_3]</a>',
	'Not spam' => 'Geen spam',
	'Reported as spam' => 'Gerapporteerd als spam',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks op [_1]: [_2]',
	'__PING_COUNT' => 'Trackbacks',
	'Trackback Text' => 'TrackBack tekst',
	'Trackbacks on My Entries/Pages' => 'TrackBacks op mijn berichten/pagina\'s',
	'Non-spam trackbacks' => 'Non-spam TrackBacks',
	'Non-spam trackbacks on this website' => 'Non-spam TrackBacks op deze website',
	'Pending trackbacks' => 'TrackBacks in de wachtrij',
	'Published trackbacks' => 'Gepubliceerde TrackBacks',
	'Trackbacks on my entries/pages' => 'TrackBacks op mijn berichten/pagina\'s',
	'Trackbacks in the last 7 days' => 'TrackBacks in de afgelopen 7 dagen',
	'Spam trackbacks' => 'Spam TrackBacks',

## plugins/Trackback/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Afbeelding foto',

## plugins/Trackback/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Originele test',

## plugins/Trackback/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager versie 1.1: Deze versie van de plugin dient om data van de oudere versie van Widget Manager die met Movable Type werd meegeleverd over te zetten naar de kern van Movable Type.  Er zitten geen andere opties in.  Deze plugin kan zonder problemen verwijderd worden na de installatie/upgrade van Movable Type.',
	'Moving storage of Widget Manager [_2]...' => 'Opslag voor widget manager [_2] aan het verhuizen...',
	'Failed.' => 'Mislukt.',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Importeer RSS geÃ«xporteerd uit WordPress in MT.',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => '"WP attachments downloaden via HTTP."',

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'No Site' => 'Geen site',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Bestand is niet in WXR formaat.',
	'Creating new tag (\'[_1]\')...' => 'Nieuwe tag aan het aanmaken (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'Tag opslaan mislukt: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Dubbel mediabestand (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving asset (\'[_1]\')...' => 'Bezig met opslaan mediabestand (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' en mediabestand zal getagd worden als (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Dubbel bericht (\'[_1]\') gevonden.  Wordt overgeslagen.',
	'Saving page (\'[_1]\')...' => 'Pagina aan het opslaan (\'[_1]\')...',
	'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
	'Entry has no MT::Trackback object!' => 'Bericht heeft geen MT::Trackback object!',
	'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
	'Assigning permissions for new user...' => 'Permissies worden toegekend aan nieuwe gebruiker...',
	'Saving permission failed: [_1]' => 'Permissies opslaan mislukt: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{Voor u WordPress berichten importeert in Movable Type raden we aan dat u eerst <a href='[_1]'>de publicatiepaden van uw site configureert</a>.},
	'Upload path for this WordPress blog' => 'Uploadpad voor deze WordPress blog',
	'Replace with' => 'Vervangen door',
	'Download attachments' => 'Attachments downloaden',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Vereist het gebruik van een cronjob om attachments van een WordPress blog te downloaden op de achtergrond.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Attachments (afbeeldingen en bestanden) downloaden van de geÏmporteerde WordPress blog.',

	'Synchronization([_1]) with an external server([_2]) has been successfully started.' => 'Synchronisatie ([_1]) met externe server ([_2]) met succes gestart.', # Translate - New
    'This email is to notify you that synchronization with an external server has been successfully started.' => 'Deze mail dient om u op de hoogte te brengen dat synchronisatie met een externe server met succes is gestart.', # Translate - New
    'Immediate sync job is being registered. This job will be executed in next run-periodic-tasks execution.' => 'Onmiddelijke sync job wordt geregistreerd.  Deze job zal worden uitgevoerd de volgende keer dat run-periodic-tasks wordt uitgevoerd.', # Translate - New
    'Immediate sync job has been registered.' => 'Onmiddelijke sync job wordt geregistreerd.', # Translate - New
    'Register immediate sync job' => 'Onmiddellijke sync job registreren', # Translate - New
    'Are you sure you want to register immediate sync job?' => 'Bent u zeker dat u een onmiddellijke sync job wenst te registreren?', # Translate - New

);

## New words: 1146

1;
