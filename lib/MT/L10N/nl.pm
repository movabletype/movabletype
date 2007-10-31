# Copyright 2003-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package MT::L10N::nl;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type - systeemcontrole',
	'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Deze pagina geeft u informatie over de configuratie van uw systeem en gaat na of u alle vereiste onderdelen hebt om Movable Type uit te kunnen voeren.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). While Movable Type may run, it is an <strong>untested and unsupported</strong> environment.  We <strong>strongly recommend</strong> upgrading to at least Perl [_2].' => 'De versie van Perl geïnstalleerd op uw server ([_1]) is lager dan de minimaal ondersteunde versie ([_2]).  Hoewel Movable Type misschien wel werkt, is dit een <strong>niet geteste en niet ondersteunde</strong> omgeving.  We <strong>raden ten stelligste aan</strong> om een upgrade uit te voeren minstens tot Perl [_2]', # Translate - New
	'System Information' => 'Systeeminformatie',
	'Current working directory:' => 'Huidige werkmap:',
	'MT home directory:' => 'MT hoofdmap:',
	'Operating system:' => 'Besturingssysteem:',
	'Perl version:' => 'Perl-versie:',
	'Perl include path:' => 'Perl include-pad:',
	'Web server:' => 'Webserver:',
	'[_1] [_2] Modules:' => '[_1] [_2] Modules:',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Volgende modules zijn <strong>optioneel</strong>. Als deze modules niet op uw server geïnstalleerd zijn, moet u ze enkel installeren als u de functionaliteit nodig heeft die door deze modules wordt toegevoegd.',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Sommige van de onderstaande modules zijn vereist om bepaalde opties voor gegevensopslag in Movable Type te kunnen gebruiken.  Om het systeem te kunnen draaien, moet op uw server DBI en minstens één van de andere modules geïnstalleerd zijn.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Ofwel is [_1] niet op uw server geïnstalleerd, ofwel is de geïnstalleerde versie te oud, of [_1] vereist een andere module die niet is geïnstalleerd.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Op uw server is [_1] niet geïnstalleerd, of [_1] vereist een andere module die niet is geïnstalleerd.',
	'Please consult the installation instructions for help in installing [_1].' => 'Gelieve de installatieinstructies te raadplegen voor hulp bij het installeren van [_1]',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Van de DBD::mysql versie die bij u is geïnstalleerd is geweten dat ze niet compatibel is met Movable Type.  Gelieve de huidige release te installeren van CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'De $mod is goed geïnstalleerd, maar vereist een bijgewerkte DBI module. Zie ook de opmerking hierboven over vereisten voor de DBI module.',
	'Your server has [_1] installed (version [_2]).' => 'Op uw server is [_1] geïnstalleerd (versie [_2]).',
	'Movable Type System Check Successful' => 'De systeemcontrole van Movable Type is geslaagd',
	'You\'re ready to go!' => 'U kunt nu beginnen!',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle vereiste modules zijn op uw server geïnstalleerd; u hoeft geen verdere modules te installeren. Ga verder met de volgende stappen in de installatie.',
	'CGI is required for all Movable Type application functionality.' => 'CGI is vereist voor alle toepassingsfuncties van Movable Type.',
	'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template is vereist voor alle toepassingsfuncties van Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size is vereist voor het opladen van bestanden (om de grootte van de op te laden afbeeldingen te bepalen in vele verschillende indelingen).',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec is vereist voor padbewerking bij verschillende besturingssystemen.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie is vereist voor verificatie van cookies.',
	'DBI is required to store data in database.' => 'DBI is vereist om gegevens te kunnen opslaan in een database', # Translate - New
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist als u de MySQL database-backend wenst te gebruiken.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist als u de PostgreSQL database-backend wenst te gebruiken.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI en DBD::SQLite zijn vereist als u de SQLite database-backend wenst te gebruiken.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI en DBD::SQLite2 zijn vereist als u de SQLite 2.x database-backend wenst te gebruiken.',
	'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI en DBD::Oracle zijn vereist als u het Oracle database-backend wenst te gebruiken.',
	'DBI and DBD::ODBC are required if you want to use the Microsoft SQL Server database backend.' => 'DBI en DBD::ODBC zijn vereist als u het Microsoft SQL Server database-backend wenst te gebruiken.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entities is vereist om bepaalde karakters te kunnen encoderen, maar deze optie kan uigeschakeld worden met de NoHTMLEntities parameter in het configuratiebestand', # Translate - New
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent is optioneel; het is vereist als u het TrackBack-systeem, de ping weblogs.com of de ping MT Recent bijgewerkt wenst te gebruiken.',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite is optioneel; het is vereist als u de MT XML-RPC-serverimplementatie wenst te gebruiken.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp is optioneel; het is vereist als u bestaande bestanden wilt overschrijven bij het opladen.',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick is optioneel; het is vereist als u miniatuurweergaven van geüploade bestanden wilt kunnen maken.',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable is optioneel; het is vereist voor bepaalde MT-plug-ins van derden.',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA is optioneel; als het is geïnstalleerd, worden registratieaanmeldingen voor opmerkingen versneld.',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 is vereist om het registreren van bezoekers in te schakelen.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom is vereist om de Atom API te kunnen gebruiken.',
	'Net::LDAP is required in order to use the LDAP Authentication.' => 'Net::LDAP zijn vereist als u LDAP authenticatie wenst te gebruiken.',
	'IO::Socket::SSL is required in order to use SSL/TLS connection with the LDAP Authentication.' => 'IO::Socket::SSL is vereist om SSL/TLS verbindingen te kunnen gebruiken met LDAP authenticatie',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached en de memcached server/daemon zijn vereist om memcached as caching mechanisme te kunnen gebruiken met Movable Type.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar is vereist om archiefbestanden te kunnen aanmaken bij backup/restore operaties.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip is vereist om bestanden te kunnen comprimeren bij backup/restore operaties.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip is vereist om bestanden te kunnen decomprimeren bij backup/restore operaties.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip is vereist om bestanden te archiveren bij backup/restore operaties.',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX en/of de bestanden waarvan deze module afhankelijk is, zijn nogid om backups terug te kunnen zetten.',
	'Checking for' => 'Bezig te controleren op',
	'Installed' => 'Geïnstalleerd',
	'Data Storage' => 'gegevensopslag',
	'Required' => 'vereiste',
	'Optional' => 'optionele',

## default_templates/entry_metadata.mtml
	'Posted by [_1] on [_2]' => 'Gepubliceerd door [_1] op [_2]',
	'Posted on [_1]' => 'Gepubliceerd op [_1]',
	'Permalink' => 'Permalink',
	'Comments ([_1])' => 'Reacties ([_1])',
	'TrackBacks ([_1])' => 'TrackBacks ([_1])',

## default_templates/comment_preview.mtml
	'Comment on [_1]' => 'Reactie op [_1]', # Translate - New
	'Header' => 'Hoofding', # Translate - New
	'Previewing your Comment' => 'U ziet een voorbeeld van uw reactie',
	'Comment Detail' => 'Details reactie',
	'Comments' => 'Reacties',

## default_templates/header.mtml
	'[_1]: Search Results' => '[_1]: Zoekresultaten', # Translate - New
	'[_1] - [_2]' => '[_1] - [_2]', # Translate - New
	'[_1]: [_2]' => '[_1]: [_2]', # Translate - New

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Pagina niet gevonden',

## default_templates/entry.mtml
	'Entry Detail' => 'Berichtdetails', # Translate - New
	'TrackBacks' => 'TrackBacks',

## default_templates/search_results.mtml
	'Search Results' => 'Zoekresultaten',
	'Search this site' => 'Deze website doorzoeken',
	'Search' => 'Zoek',
	'Match case' => 'Kapitalisering moet overeen komen',
	'Regex search' => 'Zoeken met reguliere expressies',
	'Matching entries matching &ldquo;[_1]&rdquo; from [_2]' => 'Berichten die overeenkomen met &ldquo;[_1]&rdquo; van [_2]', # Translate - New
	'Entries tagged with &ldquo;[_1]&rdquo; from [_2]' => 'Berichten getagd als &ldquo;[_1]&rdquo; van [_2]', # Translate - New
	'Entry Summary' => 'Samenvatting bericht', # Translate - New
	'Entries matching &ldquo;[_1]&rdquo;' => 'Berichten die overeenkomen met &ldquo;[_1]&rdquo;', # Translate - New
	'Entries tagged with &ldquo;[_1]&rdquo;' => 'Berichten getagd als &ldquo;[_1]&rdquo;', # Translate - New
	'No pages were found containing &ldquo;[_1]&rdquo;.' => 'Er werden geen berichten gevonden met &ldquo;[_1]&rdquo; in.', # Translate - New
	'Instructions' => 'Gebruiksaanwijzing',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een exacte uitdrukking te zoeken, gelieve aanhalingstekens rond uw zoekopdracht te zetten.',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'De zoekfunctie ondersteunt eveneens de sleutelwoorden AND, OR en NOT om booleaanse expressies mee op te stellen:', # Translate - New
	'personal OR publishing' => 'persoonlijk OR publicatie',
	'publishing NOT personal' => 'publiceren NOT persoonlijk',

## default_templates/archive_index.mtml
	'Archives' => 'Archieven',
	'Monthly Archives' => 'Maandelijkse archieven', # Translate - New
	'Categories' => 'Categorieën',
	'Author Archives' => 'Auteursarchieven', # Translate - New
	'Category Monthly Archives' => 'Categoriearchieven per maand', # Translate - New
	'Author Monthly Archives' => 'Auteursarchieven per maand', # Translate - New

## default_templates/sidebar.mtml
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged &ldquo;<$MTSearchString$>&ldquo;.' => 'Als u een RSS lezer gebruikt, kunt u zich inschrijven op een feed met alle toekomstige berichten getagd als &ldquo;<$MTSearchString$>&ldquo;.', # Translate - New
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching &ldquo;<$MTSearchString$>&ldquo;.' => 'Als u een RSS lezer gebruikt, kunt u zich inschrijven op een feed met alle toekomstige berichten die &ldquo;<$MTSearchString$>&ldquo; bevatten.', # Translate - New
	'Feed Subscription' => 'Feed inschrijving',
	'(<a href="[_1]">What is this?</a>)' => '(<a href="[_1]">Wat is dit?</a>)', # Translate - New
	'Subscribe to feed' => 'Inschrijven op feed',
	'Tags' => 'Tags',
	'Other tags used on this blog:' => 'Andere tags gebruikt op deze blog', # Translate - New
	'[_1] ([_2])' => '[_1] ([_2])', # Translate - New
	'Search this blog:' => 'Deze weblog doorzoeken:',
	'About This Post' => 'Over dit bericht', # Translate - New
	'About This Archive' => 'Over dit archief', # Translate - New
	'About Archives' => 'Over archieven', # Translate - New
	'This page contains links to all the archived content.' => 'Deze pagina bevat een link naar alle gearchiveerde inhoud', # Translate - New
	'This page contains a single entry by [_1] posted on <em>[_2]</em>.' => 'Deze pagina bevat één bericht door [_1] gepubliceerd op <em>[_2]</em>', # Translate - New
	'<a href="[_1]">[_2]</a> was the previous post in this blog.' => '<a href="[_1]">[_2]</a> was het vorige bericht op deze weblog', # Translate - New
	'<a href="[_1]">[_2]</a> is the next post in this blog.' => '<a href="[_1]">[_2]</a> is het volgende bericht op deze weblog', # Translate - New
	'This page is a archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Deze pagina is een archief met berichten in de categorie <strong>[_1]</strong> op <strong>[_2]</strong>.', # Translate - New
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is het vorige archief.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is het volgende archief.',
	'This page is a archive of recent entries in the <strong>[_1]</strong> category.' => 'Deze pagina is een archief van recente berichten in de categorie <strong>[_1]</strong>.', # Translate - New
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is de vorige categorie.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is de volgende categorie.',
	'This page is a archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong> op <strong>[_2]</strong>', # Translate - New
	'This page is a archive of recent entries written by <strong>[_1]</strong>.' => 'Deze pagina is een archief van recente berichten geschreven door <strong>[_1]</strong>.', # Translate - New
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Deze pagina is een archief van berichten op <strong>[_2]</strong> gerangschikt van nieuw naar oud', # Translate - New
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Ontdek recentere inhoud op de <a href="[_1]">hoofdindexpagina</a>.', # Translate - New
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Ontdek recentere inhoud op de <a href="[_1]">hoofdindexpagina</a of kijk in de <a href="[_2]">archievens</a> om alle inhoud te vinden.', # Translate - New
	'[_1]: Monthly Archives' => '[_1]: Maandelijkse archieven', # Translate - New
	'Recent Posts' => 'Recente berichten',
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">Archieven</a>', # Translate - New
	'Subscribe to this blog\'s feed' => 'Inschrijven op de feed van deze weblog',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Deze weblog valt onder een <a href="[_1]">Creative Commons Licentie</a>.', # Translate - New
	'Powered by Movable Type [_1]' => 'Aangedreven door Movable Type [_1]', # Translate - New

## default_templates/comment_form.mtml
	'Post a comment' => 'Reageer',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Als u hier nog nooit gereageerd heeft, kan het zijn dat de eigenaar van deze site eerst goedkeuring moet geven voordat uw reactie verschijnt. Eerder zal uw reactie niet zichtbaar zijn onder het bericht. Bedankt voor uw geduld.)',
	'Name' => 'Naam',
	'Email Address' => 'E-mailadres',
	'URL' => 'URL',
	'Remember personal info?' => 'Persoonijke gegevens onthouden?',
	'(You may use HTML tags for style)' => '(U mag HTML tags gebruiken voor de stijl)',
	'Preview' => 'Voorbeeld',
	'Post' => 'Publiceren',
	'Cancel' => 'Annuleren',

## default_templates/tags.mtml

## default_templates/main_index.mtml

## default_templates/comment_error.mtml
	'Comment Submission Error' => 'Fout bij indienen reactie',
	'Your comment submission failed for the following reasons:' => 'Het indienen van uw reactie mislukte omwille van volgende redenen:',
	'Return to the <a href="[_1]">original entry</a>.' => 'Ga terug naar het <a href="[_1]">oorspronkelijke bericht</a>.', # Translate - New

## default_templates/entry_listing.mtml
	'[_1] Archives' => '[_1] Archieven', # Translate - New
	'Recently in <em>[_1]</em> Category' => 'Recent in de categorie <em>[_1]</em>', # Translate - New
	'Recently by <em>[_1]</em>' => 'Recent door <em>[_1]</em>', # Translate - New

## default_templates/rss.mtml
	'Copyright [_1]' => 'Copyright [_1]', # Translate - New

## default_templates/javascript.mtml
	'Thanks for signing in,' => 'Bedankt om uzelf aan te melden,',
	'. Now you can comment.' => '. Nu kunt u reageren.',
	'sign out' => 'afmelden',
	'You do not have permission to comment on this blog.' => 'U heeft geen permissie om reacties achter te laten op deze weblog', # Translate - New
	'Sign in</a> to comment on this post.' => 'Meld u aan</a> om te reageren op dit bericht.', # Translate - New
	'Sign in</a> to comment on this post,' => 'Meld u aan</a> om te reageren op dit bericht,', # Translate - New
	'or ' => 'of', # Translate - New
	'comment anonymously' => 'reageer anoniem', # Translate - New

## default_templates/entry_detail.mtml
	'Entry Metadata' => 'Metadata bericht', # Translate - New

## default_templates/categories.mtml

## default_templates/comment_pending.mtml
	'Comment Pending' => 'Hangende reactie',
	'Thank you for commenting.' => 'Bedankt voor uw reactie.',
	'Your comment has been received and held for approval by the blog owner.' => 'Uw reactie is ontvangen en zal worden bewaard tot de eigenaar van deze weblog goedkeuring geeft voor publicatie.',

## default_templates/trackbacks.mtml
	'[_1] TrackBacks' => '[_1] TrackBacks', # Translate - New
	'Listed below are links to blogs that reference this post: <a href="[_1]">[_2]</a>.' => 'Hieronder vindt u links naar blogs die verwijzen naar dit bericht: <a href="[_1]">[_2]</a>.', # Translate - New
	'TrackBack URL for this entry: <span id="trackbacks-link">[_1]</span>' => 'TrackBack URL voor dit bericht: <span id="trackbacks-link">[_1]</span>', # Translate - New
	'&raquo; <a rel="nofollow" href="[_1]">[_2]</a> from [_3]' => '&raquo; <a rel="nofollow" href="[_1]">[_2]</a> van [_3]', # Translate - New
	'[_1] <a rel="nofollow" href="[_2]">Read More</a>' => '[_1] <a rel="nofollow" href="[_2]">Meer lezen</a>', # Translate - New
	'Tracked on <a href="[_1]">[_2]</a>' => 'Getracked op <a href="[_1]">[_2]</a>', # Translate - New

## default_templates/footer.mtml
	'Sidebar' => 'Zijkolom', # Translate - New

## default_templates/comment_detail.mtml
	'[_1] [_2] said:' => '[_1] [_2] zei:', # Translate - New
	'<a href="[_1]" title="Permalink to this comment">[_2]</a>' => '<a href="[_1]" title="Permalink naar deze reactie">[_2]</a>', # Translate - New

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]">[_2]</a>.' => 'Lees de rest van <a href="[_1]">[_2]</a>.', # Translate - New

## default_templates/page.mtml

## default_templates/comments.mtml
	'Comment Form' => 'Reactieformulier', # Translate - New
	'[_1] Comments' => '[_1] reacties', # Translate - New

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Sjabloon \'[_1]\' laden mislukt: [_2]',
	'Rebuild' => 'Opnieuw opbouwen',
	'Uppercase text' => 'Tekst in hoofdletters', # Translate - New
	'Lowercase text' => 'Tekst in kleine letters', # Translate - New
	'My Text Format' => 'Mijn tekstformaat', # Translate - New

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Ongeldig timestamp formaat',
	'No web services password assigned.  Please see your user profile to set it.' => 'Geen web services wachtwoord ingesteld.  Ga naar uw gebruikersprofiel om het in te stellen.',
	'Failed login attempt by disabled user \'[_1]\'' => 'Mislukte poging tot aanmelden door uitgeschakelde gebruiker \'[_1]\'',
	'No blog_id' => 'Geen blog_id',
	'Invalid blog ID \'[_1]\'' => 'Ongeldig blog ID \'[_1]\'',
	'Invalid login' => 'Ongeldige gebruikersnaam',
	'No publishing privileges' => 'Geen publicatierechten',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Waarde voor \'mt_[_1]\' moet 0 of 1 zijn (was \'[_2]\')',
	'PreSave failed [_1]' => 'PreSave mislukt [_1]',
	'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) voegde bericht #[_3] toe',
	'No entry_id' => 'Geen entry_id',
	'Invalid entry ID \'[_1]\'' => 'Ongeldig bericht-ID \'[_1]\'',
	'Not privileged to edit entry' => 'Geen rechten om bericht te bewerken',
	'User \'[_1]\' (user #[_2]) edited entry #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) bewerkte bericht #[_3]',
	'Not privileged to delete entry' => 'Geen rechten om bericht te verwijderen',
	'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Bericht \'[_1]\' (bericht #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) via xml-rpc',
	'Not privileged to get entry' => 'Geen rechten om bericht op te halen',
	'User does not have privileges' => 'Gebruiker heeft geen rechten',
	'Not privileged to set entry categories' => 'Geen rechten om berichtcategorieën in te stellen',
	'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
	'Publish failed: [_1]' => 'Publicatie mislukt: [_1]',
	'Not privileged to upload files' => 'Geen rechten om bestenden op te laden',
	'No filename provided' => 'Geen bestandsnaam opgegeven',
	'Invalid filename \'[_1]\'' => 'Ongeldige bestandsnaam \'[_1]\'',
	'Error making path \'[_1]\': [_2]' => 'Fout bij aanmaken pad \'[_1]\': [_2]',
	'Error writing uploaded file: [_1]' => 'Fout bij het schrijven van opgeladen bestand: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Sjabloonmethodes zijn niet geïmplementeerd wegens het verschil tussen de Blogger API en de Movable Type API.',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm
	'Can\'t open \'[_1]\': [_2]' => 'Kan \'[_1]\' niet openen: [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Geen blog',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'U moet een wachtwoord opgeven als u nieuwe gebruikers gaat aanmaken voor elke gebruiker die in uw weblog voorkomt.', # Translate - New
	'Need either ImportAs or ParentAuthor' => 'ImportAs ofwel ParentAuthor vereist',
	'Importing entries from file \'[_1]\'' => 'Berichten worden ingevoerd uit bestand  \'[_1]\'',
	'Creating new user (\'[_1]\')...' => 'Nieuwe gebruiker (\'[_1]\') wordt aangemaakt...',
	'ok' => 'ok', # Translate - New
	'failed' => 'mislukt', # Translate - New
	'Saving user failed: [_1]' => 'Gebruiker opslaan mislukt: [_1]',
	'Assigning permissions for new user...' => 'Permissies worden toegekend aan nieuwe gebruiker...',
	'Saving permission failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
	'Creating new category (\'[_1]\')...' => 'Nieuwe categorie wordt aangemaakt (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Categorie opslaan mislukt: [_1]',
	'Invalid status value \'[_1]\'' => 'Ongeldige statuswaarde \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Ongeldige instelling voor het toelaten van pings \'[_1]\'',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Kan geen bestaand bericht vinden met tijdstip \'[_1]\'... reacties worden overgeslagen, verder naar volgende bericht.', # Translate - New
	'Importing into existing entry [_1] (\'[_2]\')' => 'Aan het importeren in bestaand bericht [_1] (\'[_2]\')', # Translate - New
	'Saving entry (\'[_1]\')...' => 'Bericht aan het opslaan (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])', # Translate - New
	'Saving entry failed: [_1]' => 'Bericht opslaan mislukt: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
	'Entry has no MT::Trackback object!' => 'Bericht heeft geen MT::Trackback object!',
	'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Export mislukt bij bericht \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ongeldig datumformaat \'[_1]\'; dit moet \'MM/DD/JJJJ HH:MM:SS AM|PM\' zijn (AM|PM is optioneel)',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',
	'You need to configure CaptchaSourceImagebase.' => 'U moet CaptchaSourceImagebase nog configureren.',
	'Image creation failed.' => 'Afbeelding aanmaken mislukt.',
	'Image error: [_1]' => 'Afbeelding fout: [_1]',

## lib/MT/Import.pm
	'Can\'t rewind' => 'Kan niet terugspoelen',
	'Can\'t open directory \'[_1]\': [_2]' => 'Kan map \'[_1]\' niet openen: [_2]',
	'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
	'Couldn\'t resolve import format [_1]' => 'Kon importformaat niet onderscheiden [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Een ander systeem (Movable Type formaat)', # Translate - New

## lib/MT/Comment.pm
	'Comment' => 'Reactie',
	'Load of entry \'[_1]\' failed: [_2]' => 'Laden van bericht \'[_1]\' mislukt: [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',

## lib/MT/App.pm
	'First Weblog' => 'Eerste weblog',
	'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fout bij het laden van weblog #[_1] bij provisioneren van gebruiker.  Kijk uw NewUserTemplateBlogId instelling na.',
	'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Fout bij het aanmaken van een weblog voor nieuwe gebruiker \'[_1]\' met blog #[_2] als voorbeeld',
	'Error creating directory [_1] for blog #[_2].' => 'Fout bij het aanmaken van map [_1] voor blog #[_2].',
	'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Fout bij aanmaken van weblog voor nieuwe gebruiker \'[_1] (ID: [_2])\'.',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' voor gebruiker \'[_3] (ID: [_4])\' werd aangemaakt.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => '
    Fout bij het toekennen van weblogadministrator rechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'. Er werd geen gepaste weblog administrator rol gevonden.',
	'The login could not be confirmed because of a database error ([_1])' => 'Het aanmelden kon niet worden bevestigd wegens een databaseprobleem ([_1])',
	'Invalid login.' => 'Ongeldige gebruikersnaam.',
	'Failed login attempt by unknown user \'[_1]\'' => 'Mislukte poging tot aanmelden door onbekende gebruiker \'[_1]\'',
	'This account has been disabled. Please see your system administrator for access.' => 'Deze account werd uitgeschakeld.  Contacteer uw systeembeheerder om weer toegang te krijgen.',
	'This account has been deleted. Please see your system administrator for access.' => 'Deze account werd verwijderd.  Contacteer uw systeembeheerder om weer toegang te krijgen.',
	'User cannot be created: [_1].' => 'Gebruiker kan niet worden aangemaakt: [_1].',
	'User \'[_1]\' has been created.' => 'Gebruiker \'[_1]\' is aangemaakt',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Gebruiker \'[_1]\' (ID:[_2]) met succes aangemeld',
	'Invalid login attempt from user \'[_1]\'' => 'Ongeldige poging tot aanmelden van gebruiker \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Gebruiker \'[_1]\' (ID:[_2]) werd afgemeld',
	'Close' => 'Sluiten',
	'Go Back' => 'Ga terug',
	'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
	'Unknown action [_1]' => 'Onbekende actie [_1]',
	'Permission denied.' => 'Toestemming geweigerd.',
	'Warnings and Log Messages' => 'Waarschuwingen en logberichten',
	'http://www.movabletype.com/' => 'http://www.movabletype.com/',

## lib/MT/Page.pm
	'Page' => 'Pagina',
	'Pages' => 'Pagina\'s',
	'Folder' => 'Map',
	'Load of blog failed: [_1]' => 'Laden van blog mislukt: [_1]',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Geen WeblogsPingURL opgegeven in het configuratiebestand', # Translate - New
	'No MTPingURL defined in the configuration file' => 'Geen MTPingURL opgegeven in het configuratiebestand', # Translate - New
	'HTTP error: [_1]' => 'HTTP fout: [_1]',
	'Ping error: [_1]' => 'Ping fout: [_1]',

## lib/MT/Core.pm
	'System Administrator' => 'Systeembeheerder',
	'Create Blogs' => 'Blogs aanmaken', # Translate - New
	'Manage Plugins' => 'Plugins beheren', # Translate - New
	'View System Activity Log' => 'Systeemactiviteitlog bekijken', # Translate - New
	'Blog Administrator' => 'Blogadministrator',
	'Configure Blog' => 'Blog configureren', # Translate - New
	'Set Publishing Paths' => 'Publicatiepaden instellen', # Translate - New
	'Manage Categories' => 'Categorieën beheren',
	'Manage Tags' => 'Tags beheren',
	'Manage Notification List' => 'Notificatielijst beheren',
	'View Activity Log' => 'Activiteitlog bekijken',
	'Create Entries' => 'Berichten aanmaken',
	'Publish Post' => 'Bericht publiceren', # Translate - New
	'Send Notifications' => 'Notificaties verzenden',
	'Edit All Entries' => 'Alle berichten bewerken',
	'Manage Pages' => 'Pagina\'s beheren', # Translate - New
	'Rebuild Files' => 'Bestanden opnieuw opbouwen',
	'Manage Templates' => 'Sjablonen beheren',
	'Upload File' => 'Opladen',
	'Save Image Defaults' => 'Standaardinstellingen afbeeldingen opslaan', # Translate - New
	'Manage Assets' => 'Mediabestanden beheren', # Translate - New
	'Post Comments' => 'Reacties publiceren', # Translate - New
	'Manage Feedback' => 'Feedback beheren', # Translate - New
	'MySQL Database' => 'MySQL databank', # Translate - New
	'PostgreSQL Database' => 'PostgreSQL databank', # Translate - New
	'SQLite Database' => 'SQLite databank', # Translate - New
	'SQLite Database (v2)' => 'SQLite databank (v2)', # Translate - New
	'Convert Line Breaks' => 'Regeleindes omzetten',
	'Rich Text' => 'Rich text', # Translate - New
	'weblogs.com' => 'weblogs.com', # Translate - New
	'technorati.com' => 'technorati.com', # Translate - New
	'google.com' => 'google.com', # Translate - New
	'<MTEntries>' => '<MTEntries>', # Translate - New
	'Publish Future Posts' => 'Geplande berichten publiceren', # Translate - New
	'Junk Folder Expiration' => 'Vervaldatum spam-map', # Translate - New
	'Remove Temporary Files' => 'Tijdelijke bestanden verwijderen', # Translate - New

## lib/MT/Asset/Image.pm
	'Image' => 'Afbeelding',
	'Images' => 'Afbeeldingen',
	'Actual Dimensions' => 'Echte afmetingen',
	'[_1] wide, [_2] high' => '[_1] breed, [_2] hoog',
	'Error scaling image: [_1]' => 'Fout bij het schalen van de afbeelding: [_1]',
	'Error creating thumbnail file: [_1]' => 'Fout bij het aanmaken van een thumbnail-bestand: [_1]',
	'Can\'t load image #[_1]' => 'Kan afbeelding niet laden #[_1]',
	'View image' => 'Afbeelding bekijken',
	'Permission denied setting image defaults for blog #[_1]' => 'Permissie geweigerd om de standaardinstellingen voor afbeeldingen te wijzigen voor blog #[_1]',
	'Thumbnail failed: [_1]' => 'Verkleinde afbeelding mislukt: [_1]',
	'Invalid basename \'[_1]\'' => 'Ongeldige basisnaam \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Fout bij schrijven naar \'[_1]\': [_2]',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Er worden [_1] records gebackupt:',
	'[_1] records backed up...' => '[_1] records gebackupt...',
	'[_1] records backed up.' => '[_1] records gebackupt.',
	'There were no [_1] records to be backed up.' => 'Er waren geen [_1] records om te backuppen.',
	'No manifest file could be found in your import directory [_1].' => 'Er werd geen manifest-bestand gevonden in de importdirectory [_1].',
	'Can\'t open [_1].' => 'Kan [_1] niet openen.',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-bestand [_1] was geen geldig Movable Type backup manifest-bestand.',
	'Manifest file: [_1]' => 'Manifestbestand: [_1]', # Translate - New
	'Path was not found for the file ([_1]).' => 'Geen pad gevonden voor het bestadn ([_1]).', # Translate - New
	'[_1] is not writable.' => '[_1] is niet beschrijfbaar.',
	'Copying [_1] to [_2]...' => 'Bezig [_1] te copiëren naar [_2]...',
	'Failed: ' => 'Mislukt: ',
	'Done.' => 'Klaar.',
	'ID for the file was not set.' => 'ID van het bestand was niet ingesteld.', # Translate - New
	'The file ([_1]) was not restored.' => 'Het bestand ([_1]) werd niet teruggezet.', # Translate - New
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Pad voor bestand \'[_1]\' (ID:[_2]) wordt aangepast...', # Translate - New

## lib/MT/BackupRestore/ManifestFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Het opgeladen bestand was geen geldig Movable Type backup manifest bestand.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Het opgeladen bestand werd gebackupt vanuit Movable Type met een nieuwere schemaversie ([_1]) dan die van dit systeem ([_2]).  Het is niet veilig dit bestand terug te zetten op deze versie van Movable Type.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] is geen item dat door Movable Type teruggezet moet worden.',
	'[_1] records restored.' => '[_1] records teruggezet.',
	'Restoring [_1] records:' => '[_1] records aan het terugzetten:',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Een gebruiker met dezelfde naam \'[_1]\' werd gevonden (ID:[_2]).  Restore verving deze gebruiker door de data uit de backup.',
	'Tag \'[_1]\' exists in the system.' => 'Tag \'[_1]\' bestaat in het systeem.', # Translate - New
	'Trackback for entry (ID: [_1]) already exists in the system.' => 'TrackBack voor bericht (ID: [_1]) bestaat al in het systeem.', # Translate - New
	'Trackback for category (ID: [_1]) already exists in the system.' => 'Trackback voor categorie (ID: [_1]) bestaat al in het systeem.', # Translate - New
	'[_1] records restored...' => '[_1] records teruggezet...',

## lib/MT/Folder.pm
	'Folders' => 'Mappen',

## lib/MT/DefaultTemplates.pm
	'Main Index' => 'Hoofdindex',
	'Archive Index' => 'Archiefindex', # Translate - New
	'Base Stylesheet' => 'Basisstylesheet', # Translate - New
	'Theme Stylesheet' => 'Themastylesheet', # Translate - New
	'JavaScript' => 'JavaScript', # Translate - New
	'RSD' => 'RSD',
	'Atom' => 'Atom', # Translate - New
	'RSS' => 'RSS', # Translate - New
	'Entry' => 'Bericht',
	'Entry Listing' => 'Overzicht berichten', # Translate - New
	'Comment Error' => 'Reactie fout', # Translate - New
	'Shown when a comment submission cannot be validated.' => 'Getoond wanneer een reactie niet kan worden gevalideerd.', # Translate - New
	'Shown when a comment is moderated or reported as spam.' => 'Getoond wanneer een reactie gemodereerd wordt of als spam wordt aangemerkt.', # Translate - New
	'Comment Preview' => 'Voorbeeld reactie', # Translate - New
	'Shown when a commenter previews their comment.' => 'Getoond wanneer een reageerder een voorbeeld wil zien van zijn reactie.', # Translate - New
	'Dynamic Error' => 'Dynamische fout', # Translate - New
	'Shown when an error is encountered on a dynamic blog page.' => 'Getoond wanneer er zich een fout voordoet op een dynamische blogpagina', # Translate - New
	'Popup Image' => 'Pop-up afbeelding',
	'Shown when a visitor clicks a popup-linked image.' => 'Getoond wanneer een bezoeker op een afbeelding klikt waar een popup-versie aan verbonden is.', # Translate - New
	'Shown when a visitor searches the weblog.' => 'Getoond wanneer een bezoeker de zoekfunctie gebruikt om de weblog te doorzoeken.', # Translate - New
	'Footer' => 'Voettekst', # Translate - New

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] vanwege regel [_4][_5]', # Translate - New
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] vanwege test [_4]', # Translate - New

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Aanmaken van een lockfile mislukt om systeemtaken uit te kunnen voeren. Kijk naof uw TempDir locatie ([_1]) beschrijfbaar is.',
	'Error during task \'[_1]\': [_2]' => 'Fout tijdens taak \'[_1]\': [_2]',
	'Scheduled Tasks Update' => 'Update van geplande taken',
	'The following tasks were run:' => 'Volgende taken moesten uitgevoerd worden:',

## lib/MT/AtomServer.pm

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'Aan dit object is reeds een score toegekend.',
	'Can not set score to the object \'[_1]\'(ID: [_2])' => 'Kan de score aan dit object niet toekennen \'[_1]\'(ID: [_2])', # Translate - New

## lib/MT/BulkCreation.pm
	'Format error at line [_1]: [_2]' => 'Fout formaat op regel [_1]: [_2]',
	'Invalid command: [_1]' => 'Ongeldig commando: [_1]',
	'Invalid number of columns for [_1]' => 'Ongeldig aantal kolommen voor [_1]',
	'Invalid user name: [_1]' => 'Ongeldige gebruikersnaam: [_1]',
	'Invalid display name: [_1]' => 'Ongeldige getoonde naam: [_1]',
	'Invalid email address: [_1]' => 'Ongeldig e-mail adres: [_1]',
	'Invalid language: [_1]' => 'Ongeldige taal: [_1]',
	'Invalid password: [_1]' => 'Ongeldig wachtwoord: [_1]',
	'Invalid password recovery phrase: [_1]' => 'Ongeldig woord/zin om wachtwoord terug te vinden: [_1]',
	'Invalid weblog name: [_1]' => 'Ongeldige weblognaam: [_1]',
	'Invalid weblog description: [_1]' => 'Ongeldige weblogomschrijving: [_1]',
	'Invalid site url: [_1]' => 'Ongeldige site-url: [_1]',
	'Invalid site root: [_1]' => 'Onngeldige hoofdmap site: [_1]',
	'Invalid timezone: [_1]' => 'Ongeldige tijdzone: [_1]',
	'Invalid new user name: [_1]' => 'Ongeldige nieuwe gebruikersnaam: [_1]',
	'A user with the same name was found.  Register was not processed: [_1]' => 'Er werd een gebruiker met dezelfde naam gevonden.  Registratie werd niet verwerkt: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'Blog voor gebruiker \'[_1]\' kan niet worden aangemaakt.',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'Blog \'[_1]\' voor gebruiker \'[_2]\' is aangemaakt.',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => '
    Fout bij het toekennen van weblogadministrator rechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'. Er werd geen gepaste weblog administrator rol gevonden.',
	'Permission granted to user \'[_1]\'' => 'Permissie gegeven aan gebruiker \'[_1]\'',
	'User \'[_1]\' already exists. Update was not processed: [_2]' => 'Gebruiker \'[_1]\' bestaat al.  Update werd niet verwerkt: [_2]',
	'User cannot be updated: [_1].' => 'Gebruiker kan niet worden bijgewerkt: [_1].',
	'User \'[_1]\' not found.  Update was not processed.' => 'Gebruiker \'[_1]\' niet gevonden.  Update werd niet verwerkt.',
	'User \'[_1]\' has been updated.' => 'Gebruiker \'[_1]\' is bijgewerkt.',
	'User \'[_1]\' was found, but delete was not processed' => 'Gebruiker \'[_1]\' werd gevonden, maar verwijdering werd niet verwerkt',
	'User \'[_1]\' not found.  Delete was not processed.' => 'Gebruiker \'[_1]\' werd niet gevonden. Verwijdering werd niet verwerkt.',
	'User \'[_1]\' has been deleted.' => 'Gebruiker \'[_1]\' werd verwijderd.',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'gebruikt: [_1], zou moeten gebruiken: [_2]',
	'uses [_1]' => 'gebruikt [_1]',
	'No executable code' => 'Geen uitvoerbare code',
	'Rebuild-option name must not contain special characters' => 'Naam van de herbouwoptie mag geen speciale karakters bevatten',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden weggeschreven: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'all\' for a value.' => 'Het attribuut exclude_blogs kan niet \'all\' hebben als waarde.',

## lib/MT/Template/ContextHandlers.pm
	'[_1]Republish[_2] your site to see these changes take effect.' => '[_1]Herpubliceer[_2] uw site om de wijzigingen toe te passen op uw site.', # Translate - New
	'Plugin Actions' => 'Plugin-mogelijkheden',
	'Warning' => 'Waarschuwing',
	'Now you can comment.' => 'Nu kunt u reageren.',
	'Yes' => 'Ja',
	'No' => 'Nee',
	'You are not signed in. You need to be registered to comment on this site.' => 'U bent niet aangemeld.  U moet geregistreerd zijn om te kunnen reageren op deze website.',
	'Sign in' => 'Aanmelden',
	'If you have a TypeKey identity, you can ' => 'Als u een TypeKey identiteit heeft, kunt u ',
	'sign in' => 'zich aanmelden',
	'to use it here.' => 'om ze hier te gebruiken.',
	'Remember me?' => 'Mij onthouden?',
	'No [_1] could be found.' => 'Er werden geen [_1] gevonden', # Translate - New
	'Recursion attempt on [_1]: [_2]' => 'Recursiepoging op [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Kan geincludeerd sjabloon niet vinden: [_1] \'[_2]\'',
	'Can\'t find blog for id \'[_1]' => 'Kan geen blog vinden met id \'[_1]',
	'Can\'t find included file \'[_1]\'' => 'Kan geïncludeerd bestand \'[_1]\' niet vinden',
	'Error opening included file \'[_1]\': [_2]' => 'Fout bij het openen van geïncludeerd bestand \'[_1]\': [_2]',
	'Recursion attempt on file: [_1]' => 'Recursiepoging op bestand: [_1]',
	'Unspecified archive template' => 'Niet gespecifiëerd archiefsjabloon',
	'Error in file template: [_1]' => 'Fout in bestandssjabloon: [_1]',
	'Can\'t load template' => 'Kan sjabloon niet laden',
	'Can\'t find template \'[_1]\'' => 'Kan sjabloon \'[_1]\' niet vinden',
	'Can\'t find entry \'[_1]\'' => 'Kan bericht \'[_1]\' niet vinden',
	'[_1] [_2]' => '[_1] [_2]',
	'You used a [_1] tag without any arguments.' => 'U gebruikte een [_1] tag zonder argumenten.',
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Er staat een fout in uw \'[_2]\' attribuut: [_1]',
	'You have an error in your \'tag\' attribute: [_1]' => 'Er zit een fout in uw \'tag\' attribuut: [_1]',
	'No such user \'[_1]\'' => 'Geen gebruiker \'[_1]\'',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; misschien plaatste u die tag per ongeluk buiten een \'MTEntries\' container?',
	'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'U gebruikte een [_1] tag om te linken naar \'[_2]\' archieven, maar dat type archieven wordt niet gepubliceerd.',
	'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.',
	'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Om registratie van reacties in te schakelen, moet u een TypeKey token toevoegen in de configuratie van uw weblog of in uw gebruikersprofiel.',
	'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een reactie; misschien plaatste u die tag per ongeluik buiten een \'MTComments\' container?',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kan enkel worden gebruikt met dagelijkse, wekelijkse of maandelijkse archieven.',
	'Group iterator failed.' => 'Group iterator mislukt.',
	'You used an [_1] tag outside of the proper context.' => 'U gebruikte een [_1] tag buiten de juiste context.',
	'Could not determine entry' => 'Kon bericht niet bepalen',
	'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
	'No such category \'[_1]\'' => 'Geen categorie \'[_1]\'',
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> moet gebruikt worden in een categorie, of met het \'category\' attribuute van de tag.',
	'You failed to specify the label attribute for the [_1] tag.' => 'U gaf geen label attribuut op voor de [_1] tag.',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een ping;  mogelijk plaatste u die per ongeluk buiten een \'MTPings\' container?',
	'[_1] used outside of [_2]' => '[_1] gebruikt buiten [_2]', # Translate - New
	'MT[_1] must be used in a [_2] context' => 'MT[_1] moet gebruikt worden in een [_2] context',
	'Cannot find package [_1]: [_2]' => 'Kan package [_1] niet vinden: [_2]',
	'Error sorting [_2]: [_1]' => 'Fout bij sorteren [_2]: [_1]',
	'Edit' => 'Bewerken',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een mediabestand; misschien plaatste u dit per ongeluk buiten een \'MTAssets\' container?', # Translate - New
	'You used an \'[_1]\' tag outside of the context of an page; perhaps you mistakenly placed it outside of an \'MTPages\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een pagina; misschien plaatste u dit per ongeluk buiten een \'MTPages\' container?', # Translate - New
	'You used an [_1] without a author context set up.' => 'U gebruikte een [_1] zonder een auteurscontext op te zetten.',
	'Can\'t load blog.' => 'Kan blog niet laden.',
	'Can\'t load user.' => 'Kan gebruiker niet laden.',

## lib/MT/Image.pm
	'Can\'t load Image::Magick: [_1]' => 'Kan Image::Magick niet laden: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Bestand \'[_1]\' lezen mislukt: [_2]',
	'Reading image failed: [_1]' => 'Afbeelding lezen mislukt: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Dimensies aanpassen naar [_1]x[_2] mislukt: [_3]',
	'Can\'t load IPC::Run: [_1]' => 'Kan IPC::Run niet laden: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'U hebt geen geldig pad naar de NetPBM tools op uw machine.',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Alias voor [_1] zit in een lus in de configuratie',
	'Error opening file \'[_1]\': [_2]' => 'Fout bij openen bestand \'[_1]\': [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Configuratie-directief [_1] zonder waarde in [_2] lijn [_3]',
	'No such config variable \'[_1]\'' => 'Onbekende configuratievariabele \'[_1]\'',

## lib/MT/Log.pm
	'System' => 'Systeem',
	'Page # [_1] not found.' => 'Pagina # [_1] niet gevonden.',
	'Entries' => 'Berichten',
	'Entry # [_1] not found.' => 'Bericht # [_1] niet gevonden.',
	'Comment # [_1] not found.' => 'Reactie # [_1] niet gevonden.',
	'TrackBack # [_1] not found.' => 'TrackBack # [_1] niet gevonden.',

## lib/MT/Auth/OpenID.pm
	'Could not discover claimed identity: [_1]' => 'Kon geclaimde identiteit niet ontdekken: [_1]',
	'Couldn\'t save the session' => 'Kon de sessie niet opslaan',

## lib/MT/Auth/MT.pm
	'Passwords do not match.' => 'Wachtwoorden komen niet overeen.',
	'Failed to verify current password.' => 'Verificatie huidig wachtwoord mislukt.',
	'Password hint is required.' => 'Wachtwoordhint is vereist.',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'Aanmelden vereist een beveiligde handtekening.',
	'The sign-in validation failed.' => 'Validatie van het aanmelden mislukt.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.  Als u dat wenst kunt u zich opnieuw aanmelden en de authenticatiedienst toestemming verlenen om uw e-mail adres door te geven.',
	'This weblog requires commenters to pass an email address' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.',
	'Couldn\'t get public key from url provided' => 'Kon geen publieke sleutel vinden via de opgegeven url',
	'No public key could be found to validate registration.' => 'Er kon geen publieke sleutel gevonden worden om de registratie te valideren.',
	'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey signatuurverificatie gaf [_1] terug in [_2] seconden bij het verifiëren van [_3] met [_4]',
	'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'De TypeKey signatuur is vervallen ([_1] seconden oud). Controleer of de klok van uw server juist staat',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Onbekende MailTransfer methode \'[_1]\'',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Het versturen van e-mail via SMTP vereist dat op uw server Mail::Sendmail is geïnstalleerd: [_1]',
	'Error sending mail: [_1]' => 'Fout bij versturen mail: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'U heeft geen geldig pad naar sendmail op uw machine.  Misschien moet u proberen om SMTP te gebruiken?',
	'Exec of sendmail failed: [_1]' => 'Exec van sendmail mislukt: [_1]',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Handeling: Verworpen (score onder drempel)',
	'Action: Published (default action)' => 'Handeling: Gepubliceerd (standaardhandeling)',
	'Junk Filter [_1] died with: [_2]' => 'Spamfilter [_1] liep vast met: [_2]',
	'Unnamed Junk Filter' => 'Naamloze spamfilter',
	'Composite score: [_1]' => 'Samengestelde score: [_1]',

## lib/MT/TBPing.pm
	'TrackBack' => 'TrackBack',

## lib/MT/Util.pm
	'moments from now' => 'ogenblikken in de toekomst', # Translate - New
	'moments ago' => 'ogenblikken geleden', # Translate - New
	'[quant,_1,hour] from now' => '[quant,_1,uur,uren] in de toekomst',
	'[quant,_1,hour] ago' => '[quant,_1,uur,uren] geleden',
	'[quant,_1,minute] from now' => '[quant,_1,minuut,minuten] in de toekomst',
	'[quant,_1,minute] ago' => '[quant,_1,minuut,minuten] geleden',
	'[quant,_1,day] from now' => '[quant,_1,dag,dagen] in de toekomst',
	'[quant,_1,day] ago' => '[quant,_1,dag,dagen] geleden',
	'less than 1 minute from now' => 'minder dan 1 minuut in de toekomst', # Translate - Case
	'less than 1 minute ago' => 'minder dan 1 minuut geleden', # Translate - Case
	'[quant,_1,hour], [quant,_2,minute] from now' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten] in de toekomst',
	'[quant,_1,hour], [quant,_2,minute] ago' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten] geleden',
	'[quant,_1,day], [quant,_2,hour] from now' => '[quant,_1,dag,dagen], [quant,_2,uur,uren] in de toekomst',
	'[quant,_1,day], [quant,_2,hour] ago' => '[quant,_1,dag,dagen], [quant,_2,uur,uren] geleden',

## lib/MT/WeblogPublisher.pm
	'yyyy/index.html' => 'jjjj/index.html',
	'yyyy/mm/index.html' => 'jjjj/mm/index.html',
	'yyyy/mm/day-week/index.html' => 'jjjj/mm/dag-week/index.html',
	'yyyy/mm/entry_basename.html' => 'jjjj/mm/basisnaam_bericht.html',
	'yyyy/mm/entry-basename.html' => 'jjjj/mm/basisnaam-bericht.html',
	'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/basisnaam_bericht/index.html',
	'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/basisnaam-bericht/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/dd/basisnaam_bericht.html',
	'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/dd/basisnaam-bericht.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/dd/basisnaam_bericht/index.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/dd/basisnaam-bericht/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sub_categorie/basisnaam_bericht.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sub_categorie/basisnaam_bericht/index.html',
	'category/sub-category/entry-basename.html' => 'categorie/sub-categorie/basisnaam-bericht.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sub-categorie/basisnaam-bericht/index.html',
	'folder_path/page_basename.html' => 'map_pad/basisnaam_pagina.html',
	'folder_path/page_basename/index.html' => 'map_pad/basisnaam_pagina/index.html',
	'folder-path/page-basename.html' => 'map-pad/basisnaam-pagina.html',
	'folder-path/page-basename/index.html' => 'map-pad/basisnaam-pagina/index.html',
	'folder/sub_folder/index.html' => 'map/sub_map/index.html',
	'folder/sub-folder/index.html' => 'map/sub-map/index.html',
	'yyyy/mm/dd/index.html' => 'jjjj/mm/dd/index.html',
	'category/sub_category/index.html' => 'categorie/sub_categorie/index.html',
	'category/sub-category/index.html' => 'categorie/sub-categorie/index.html',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Archieftype \'[_1]\' is geen gekozen archieftype',
	'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is vereist',
	'You did not set your weblog Archive Path' => 'Uw stelde geen weblogarchief-pad in',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Hetzelfde archiefbestand bestaat al. U moet de basisnaam of het archiefpad wijzigen. ([_1])',
	'Building category \'[_1]\' failed: [_2]' => 'Categorie \'[_1]\' opbouwen mislukt: [_2]',
	'Building entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opbouwen mislukt: [_2]',
	'Building date-based archive \'[_1]\' failed: [_2]' => 'Datum-gebaseerd archief \'[_1]\' opbouwen mislukt: [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'Schrijven naar \'[_1]\' mislukt: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Tijdelijk bestand \'[_1]\' van naam veranderen mislukt: [_2]',
	'You did not set your weblog Site Root' => 'U stelde geen site root in voor uw weblog',
	'Template \'[_1]\' does not have an Output File.' => 'Sjabloon \'[_1]\' heeft geen uitvoerbestand.',
	'An error occurred while rebuilding to publish scheduled entries: [_1]' => 'Er deed zich een fout voor bij het opnieuw opbouwen van geplande berichten: [_1]',
	'YEARLY_ADV' => 'Jaarlijks',
	'MONTHLY_ADV' => 'Maandelijks',
	'CATEGORY_ADV' => 'Categorie',
	'PAGE_ADV' => 'Pagina',
	'INDIVIDUAL_ADV' => 'Individueel',
	'DAILY_ADV' => 'Dagelijks',
	'WEEKLY_ADV' => 'Wekelijks',

## lib/MT/Asset.pm
	'File' => 'Bestand',
	'Files' => 'Bestanden',
	'Description' => 'Beschrijving',
	'Location' => 'Locatie',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fout bij het toekennen van reactierechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'.  Er werd geen geschikte reageerder-rol gevonden.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ongeldige aanmeldpoging van een reageerder [_1] op blog [_2](ID: [_3]) waar geenMovable Type native authenticatie is toegelaten.',
	'Login failed: permission denied for user \'[_1]\'' => 'Aanmelden mislukt: permissie geweigerd aan gebruiker \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Aanmelden mislukt: fout in wachtwoord van gebruiker \'[_1]\'',
	'Signing up is not allowed.' => 'Registreren is niet toegestaan.',
	'User requires username.' => 'Gebruiker heeft gebruikersnaam nodig.',
	'User requires display name.' => 'Gebruiker heeft getoonde naam nodig.',
	'A user with the same name already exists.' => 'Er bestaat al een gebruiker met die naam.',
	'User requires password.' => 'Gebruiker heeft wachtwoord nodig.',
	'User requires password recovery word/phrase.' => 'Gebruiker heeft woord/zin om het wachtwoord terug te vinden nodig.',
	'Email Address is invalid.' => 'E-mail adres is ongeldig.',
	'Email Address is required for password recovery.' => 'E-mail adres is vereist om het wachtwoord te kunnen terugvinden.',
	'URL is invalid.' => 'URL is ongeldig.',
	'Text entered was wrong.  Try again.' => 'De ingevoerde tekst was verkeerd.  Probeer opnieuw.',
	'Something wrong happened when trying to process signup: [_1]' => 'Er ging iets mis bij het verwerken van de registratie: [_1]',
	'Movable Type Account Confirmation' => 'Movable Type accountbevestiging',
	'System Email Address is not configured.' => 'Systeem e-mail adres is niet ingesteld.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Reageerder \'[_1]\' (ID:[_2]) heeft zich met succes geregistreerd.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden om te reageren.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] geregistreerd op blog \'[_2]\'',
	'No id' => 'Geen id',
	'No such comment' => 'Reactie niet gevonden',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
	'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
	'_THROTTLED_COMMENT_EMAIL' => 'Een bezoeker van uw weblog [_1] is automatisch uitgesloten omdat dez meer dan het toegestane aantal reacties heeft gepubliceerd in de laatste [_2] seconden. Dit wordt gedaan om te voorkomen dat kwaadwillige scripts uw weblog met reacties overstelpen. Het uitgesloten IP-adres is

    [_3]

Als dit een fout was, kunt u het IP-adres ontgrendelen en de bezoeker toestaan opnieuw te publiceren door u aan te melden bij uw Movable Type-installatie, naar Weblogconfiguratie - IP uitsluiten te gaan en het IP-adres [_4] te verwijderen uit de lijst van uitgesloten adressen.',
	'Invalid request' => 'Ongeldig verzoek',
	'No such entry \'[_1]\'.' => 'Geen bericht \'[_1]\'.',
	'You are not allowed to add comments.' => 'U heeft geen toestemming om reacties toe te voegen.',
	'_THROTTLED_COMMENT' => 'In een poging om de publicatie van kwaadaardige reacties door beledigende gebruikers tegen te gaan, heb ik een functie ingeschakeld die vereist dat degene die weblogreacties verstuurt even wacht alvorens weer een publicatie te kunnen sturen. Probeer uw reactie na korte tijd nogmaals te publiceren. Hartelijk dank voor uw geduld.',
	'Comments are not allowed on this entry.' => 'Reacties op dit bericht zijn niet toegelaten.',
	'Comment text is required.' => 'Tekst van de reactie is verplicht.',
	'An error occurred: [_1]' => 'Er deed zich een probleem voor: [_1]',
	'Registration is required.' => 'Registratie is verplicht.',
	'Name and email address are required.' => 'Naam en e-mail adres zijn verplicht.',
	'Invalid email address \'[_1]\'' => 'Ongeldig e-mail adres \'[_1]\'',
	'Invalid URL \'[_1]\'' => 'Ongeldige URL \'[_1]\'',
	'Comment save failed with [_1]' => 'Opslaan van reactie mislukt met [_1]',
	'Comment on "[_1]" by [_2].' => 'Reactie op "[_1]" door [_2].',
	'Commenter save failed with [_1]' => 'Opslaan reageerder mislukt met [_1]',
	'Rebuild failed: [_1]' => 'Opnieuw opbouwen mislukt: [_1]',
	'You must define a Comment Pending template.' => 'U moet een sjabloon definiëren voor reacties die nog goedgekeurd moeten worden.',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Mislukte poging om een reactie achter te laten van op registratie wachtende gebruiker \'[_1]\'',
	'Registered User' => 'Geregistreerde gebruiker',
	'New Comment Added to \'[_1]\'' => 'Nieuwe reactie achtergelaten op \'[_1]\'',
	'The sign-in attempt was not successful; please try again.' => 'Aanmeldingspoging mislukt; gelieve opnieuw te proberen.',
	'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'De validering bij het aanmelden is mislukt. Gelieve u ervan te vergewissen dat uw weblog goed is ingesteld en probeer opnieuw.',
	'No such entry ID \'[_1]\'' => 'Geen bericht-ID \'[_1]\'',
	'You must define an Individual template in order to display dynamic comments.' => 'U moet een Individueel sjabloon definiëren om dynamische reacties te kunnen tonen.',
	'You must define a Comment Listing template in order to display dynamic comments.' => 'U moet een dynamisch sjabloon voor de lijst met reacties instellen om reacties dynamisch te kunnen tonen.',
	'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
	'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
	'You must define a Comment Error template.' => 'U moet een sjabloon definiëren voor foutboodschappen.',
	'You must define a Comment Preview template.' => 'U moet een sjabloon definiëren voor het bekijken van voorbeelden van reacties.',
	'Invalid commenter ID' => 'Ongeldig reageerder-ID',
	'No entry ID provided' => 'Geen bericht-ID opgegeven',
	'Permission denied' => 'Permissie geweigerd',
	'All required fields must have valid values.' => 'Alle vereiste velden moeten geldige waarden bevatten.',
	'Commenter profile has successfully been updated.' => 'Reageerdersprofiel is met succes bijgewerkt.',
	'Commenter profile could not be updated: [_1]' => 'Reageerdersprofiel kon niet worden bijgewerkt: [_1]',
	'You can\'t reply to unpublished comment.' => 'U kunt niet reageren op een niet gepubliceerde reactie.',
	'Your session has been ended.  Cancel the dialog and login again.' => 'Uw sessie is beëindigd.  Annuleer de dialoog en meld opnieuw aan.',
	'Invalid request.' => 'Ongeldig verzoek.',

## lib/MT/App/Wizard.pm
	'The [_1] database driver is required to use [_2].' => 'De [_1] databasedriver is vereist om [_2] te kunnen gebruiken.',
	'The [_1] driver is required to use [_2].' => 'De [_1] driver is vereist om [_2] te kunnen gebruiken.',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Er deed zich een fout voor bij het verbinen met de database.  Controleer de instellingen en probeer opnieuw.',
	'SMTP Server' => 'SMTP server',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test e-mail van de Movable Type Configuratiewizard',
	'This is the test email sent by your new installation of Movable Type.' => 'Dit is de test e-mail verstuurd door uw nieuwe installatie van Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Deze module is vereist als u speciale karacters wenst te encoderen, maar deze optie kan worden uitgeschakeld door de NoHTMLEntities optie te gebruiken in mt-config.cgi', # Translate - New
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Deze module is vereist als u het TrackBack systeem, de ping naar weblogs.com of de MT Recent Bijgewerkt ping wenst te gebruiken.', # Translate - New
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'Deze module is vereist als u de MT XML-RPC serverimplementatie wenst te gebruiken.', # Translate - New
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Deze module is vereist als u bestaande bestanden wenst te kunnen overschrijven bij het opladen.', # Translate - New
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Deze module is vereist als u graag thumbnailveries van opgeladen bestanden wenst te kunnen aanmaken.', # Translate - New
	'This module is required by certain MT plugins available from third parties.' => 'Deze module is vereist door bepaalde MT plugins beschikbaar bij derden.', # Translate - New
	'This module accelerates comment registration sign-ins.' => 'Deze module versnelt aanmeldingen om te kunnen reageren.', # Translate - New
	'This module is needed to enable comment registration.' => 'Deze module is vereist om registraties bij reacties mogelijk te maken.', # Translate - New
	'This module enables the use of the Atom API.' => 'Deze module maakt het mogelijk de Atom API te gebruiken.', # Translate - New
	'This module is required in order to archive files in backup/restore operation.' => 'Deze module is vereist om bestanden te archiveren bij backup/restore operaties.', # Translate - New
	'This module is required in order to compress files in backup/restore operation.' => 'Deze module is vereist om bestanden te comprimeren bij backup/restore operaties.', # Translate - New
	'This module is required in order to decompress files in backup/restore operation.' => 'Deze module is vereist om bestanden te decomprimeren bij backup/restore operaties.', # Translate - New
	'This module and its dependencies are required in order to restore from a backup.' => 'Deze module en z\'n vereisten zijn vereist om te kunen restoren uit een backup.', # Translate - New
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Deze module is vereist om bestande te kunnen opladen (om het formaat van afbeeldingen in vele verschillende formaten te kunnen bepalen).', # Translate - New
	'This module is required for cookie authentication.' => 'Deze module is vereist voor cookie-authenticatie.', # Translate - New

## lib/MT/App/Upgrader.pm
	'Failed to authenticate using given credentials: [_1].' => 'Authenticatie met de opgegeven aanmeldgegevens mislukt: [_1].',
	'You failed to validate your password.' => 'Het valideren van uw wachtwoord is mislukt.',
	'You failed to supply a password.' => 'U gaf geen wachtwoord op.',
	'The e-mail address is required.' => 'Het e-mail adres is vereist.',
	'Invalid session.' => 'Ongeldige sessie.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Geen permissies.  Gelieve uw administrator te contacteren om Movable Type te upgraden.',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Gelieve een geldig e-mail adres op te geven.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Ontbrekende parameter: blog_id. Gelieve de handleiding te raadplegen om waarschuwingen te configureren.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Er werd een ongeldige redirect parameter opgegeven. De eigenaar van de weblog moet een pad opgeven dat overeenkomt met het domein van de weblog.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Het e-mail adres \'[_1]\' zit reeds in de notificatielijst voor deze weblog.',
	'Please verify your email to subscribe' => 'Gelieve uw e-mail adres te verifiëren voor inschrijving',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'Er is een e-mail verstuurd naar [_1].  Om uw inschrijving te vervolledigen, 
    gelieve de link te volgen die in die e-mail staat.  Dit om te bevestigen dat
    het opgegeven e-mail adres correct is en aan u toebehoort.',
	'The address [_1] was not subscribed.' => 'Het adres [_1] werd niet ingeschreven.',
	'The address [_1] has been unsubscribed.' => 'Het adres [_1] werd uitgeschreven.',

## lib/MT/App/CMS.pm
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => 'quant,_1,entry,entries] getagd &ldquo;[_2]&rdquo;', # Translate - New
	'Posted by [_1] [_2] in [_3]' => 'Gepubliceerd door [_1] [_2] op [_3]', # Translate - New
	'Posted by [_1] [_2]' => 'Gepubliceerd door [_1] [_2]', # Translate - New
	'Tagged: [_1]' => 'Getagd: [_1]', # Translate - New
	'View all entries tagged &ldquo;[_1]&rdquo;' => 'Alle berichten bekijken getagd als &ldquo;[_1]&rdquo;', # Translate - New
	'No entries available.' => 'Geen berichten beschikbaar', # Translate - New
	'_WARNING_PASSWORD_RESET_MULTI' => 'U staat op het punt het wachtwoord opnieuw in te stellen voor de geselecteerde gebruikers.  Nieuwe wachtwoorden zullen willekeurig worden gegenereerd en rechtstreeks naar hun e-mail adres worden verzonden.\n\nWenst u verder te gaan?',
	'_WARNING_DELETE_USER_EUM' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen om al zijn permissies te verwijderen als alternatief.  Bent u zeker dat u deze gebruiker(s) wenst te verwijderen?\nGebruikers die nog bestaan in de externe directory zullen zichzelf weer kunnen aanmaken.',
	'_WARNING_DELETE_USER' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen om al zijn permissies te verwijderen als alternatief.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
	'Entries posted between [_1] and [_2]' => 'Berichten gepubliceerd tussen [_1] en [_2]', # Translate - New
	'Entries posted since [_1]' => 'Berichten gepubliceerd sinds [_1]', # Translate - New
	'Entries posted on or before [_1]' => 'Berichten gepubliceerd op of voor [_1]', # Translate - New
	'All comments by [_1] \'[_2]\'' => 'Alle reacties van [_1] \'[_2]\'',
	'Commenter' => 'Bezoeker',
	'Author' => 'Auteur',
	'All comments for [_1] \'[_2]\'' => 'Alle reacties op [_1] \'[_2]\'',
	'Comments posted between [_1] and [_2]' => 'Reacties gepubliceerd tussen [_1] en [_2]', # Translate - New
	'Comments posted since [_1]' => 'Reacties gepubliceerd sinds [_1]', # Translate - New
	'Comments posted on or before [_1]' => 'Reacties gepubliceerd op of voor [_1]', # Translate - New
	'Invalid blog' => 'Ongeldige blog',
	'Password Recovery' => 'Wachtwoord terugvinden',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Ongeldige poging het wachtwoord terug te vinden; kan geen wachtwoorden terugvinden in deze configuratie',
	'Invalid author_id' => 'Ongeldig author_id',
	'Can\'t recover password in this configuration' => 'Kan geen wachtwoorden terugvinden in deze configuratie',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Ongeldige gebruikersnaam \'[_1]\' bij poging tot terugvinden wachtwoord',
	'User name or birthplace is incorrect.' => 'Naam van de gebruiker of geboorteplaats is niet correct.',
	'User has not set birthplace; cannot recover password' => 'Gebruiker heeft geen geboorteplaats ingesteld; kan het wachtwoord niet terugvinden',
	'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Ongeldige poging om wachtwoord terug te vinden (gebruikte geboorteplaats \'[_1]\')',
	'User does not have email address' => 'Gebruiker heeft geen e-mail adres',
	'Password was reset for user \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Wachtwoord werd opnieuw ingesteld voor gebruiker \'[_1]\' (gebruiker #[_2]). Wachtwoord werd naar dit e-mail adres verstuurd: [_3]',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Fout bij verzenden van e-mail ([_1]);  gelieve het probleem op te lossen en probeer dan opnieuw om uw wachtwoord terug te vinden.',
	'(newly created user)' => '(nieuw aangemaakte gebruiker)',
	'Search Files' => 'Bestanden zoeken',
	'Invalid group id' => 'Ongeldig groeps-id',
	'Users & Groups' => 'Gebruikers & Groepen',
	'Group Roles' => 'Rollen groep',
	'Invalid user id' => 'Ongeldig user-id',
	'User Roles' => 'Rollen gebruiker',
	'Roles' => 'Rollen',
	'Group Associations' => 'Groepsassociaties',
	'User Associations' => 'Gebruikersassociaties',
	'Role Users & Groups' => 'Gebruikers & Groepen met deze rol',
	'Associations' => 'Associaties',
	'(Custom)' => '(Gepersonaliseerd)',
	'(user deleted)' => '(gebruiker verwijderd)',
	'Invalid type' => 'Ongeldig type',
	'No such tag' => 'Onbekende tag',
	'None' => 'Geen',
	'You are not authorized to log in to this blog.' => 'U hebt geen toestemming op u aan te melden op deze weblog.',
	'No such blog [_1]' => 'Geen blog [_1]',
	'Blogs' => 'Blogs',
	'Blog Activity Feed' => 'Blogactiviteitsfeed',
	'Users' => 'Gebruikers',
	'Group Members' => 'Groepsleden',
	'QuickPost' => 'QuickPost',
	'All Feedback' => 'Alle feedback',
	'Activity Log' => 'Activiteitlog',
	'System Activity Feed' => 'Systeemactiviteit-feed',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Activiteitlog van blog \'[_1]\' (ID:[_2]) leeggemaakt door \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Activiteitlog leeggemaakt door \'[_1]\'',
	'No blog ID' => 'Geen blog-ID',
	'You do not have import permissions' => 'U heeft geen importpermissies',
	'Default' => 'Standaard',
	'Import/Export' => 'Importeren/exporteren',
	'Invalid parameter' => 'Ongeldige parameter',
	'Permission denied: [_1]' => 'Toestemming geweigerd: [_1]',
	'Load failed: [_1]' => 'Laden mislukt: [_1]',
	'(no reason given)' => '(geen reden vermeld)',
	'(untitled)' => '(geen titel)',
	'Templates' => 'Sjablonen',
	'An error was found in this template: [_1]' => 'Er werd een fout gevonden in dit sjabloon: [_1]', # Translate - New
	'General Settings' => 'Algemene instellingen',
	'Publishing Settings' => 'Publicatie-instellingen',
	'Plugin Settings' => 'Instellingen plugins',
	'Settings' => 'Instellingen',
	'Edit TrackBack' => 'TrackBack bewerken',
	'Edit Comment' => 'Reactie bewerken',
	'Authenticated Commenters' => 'Geauthenticeerde reageerders',
	'Commenter Details' => 'Details reageerder',
	'New Entry' => 'Nieuw bericht',
	'New Page' => 'Nieuwe pagina',
	'Create template requires type' => 'Sjabloon aanmaken vereist type',
	'Archive' => 'Archief', # Translate - New
	'Entry or Page' => 'Bericht of pagina', # Translate - New
	'New Template' => 'Nieuwe sjabloon',
	'New Blog' => 'Nieuwe blog',
	'Create New User' => 'Nieuwe account aanmaken',
	'User requires username' => 'Gebruiker vereist gebruikersnaam',
	'User requires password' => 'Gebruiker vereist wachtwoord',
	'User requires password recovery word/phrase' => 'Gebruiker heeft een woord/uitdrukking nodig om het wachtwoord te kunnen terugvinden',
	'Email Address is required for password recovery' => 'E-mail adres is vereist voor het terugvinden van een wachtwoord',
	'The value you entered was not a valid email address' => 'Wat u invulde was geen geldig e-mail adres',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Het e-mail adres dat u opgaf staat al op de notificatielijst van deze weblog.',
	'You did not enter an IP address to ban.' => 'U vulde geen IP adres in om te verbannen.',
	'The IP you entered is already banned for this blog.' => 'Het IP adres dat u opgaf is al verbannen van deze weblog.',
	'You did not specify a blog name.' => 'U gaf geen weblognaam op.',
	'Site URL must be an absolute URL.' => 'Site URL moet eenn absolute URL zijn.',
	'Archive URL must be an absolute URL.' => 'Archief URL moet een absolute URL zijn.',
	'The name \'[_1]\' is too long!' => 'De naam \'[_1]\' is te lang!',
	'A user can\'t change his/her own username in this environment.' => 'Een gebruiker kan zijn/haar gebruikersnaam niet aanpassen in deze omgeving',
	'An errror occurred when enabling this user.' => 'Er deed zich een fout voor bij het inschakelen van deze gebruiker.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Map \'[_1]\' aangemaakt door \'[_2]\'',
	'Category \'[_1]\' created by \'[_2]\'' => 'Categorie \'[_1]\' aangemaakt door \'[_2]\'',
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'De map \'[_1]\' conflicteert met een andere map. Mappen met dezelfde ouder moeten een unieke basisnaam hebben.',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Categoriebasisnaam \'[_1]\' conflicteert met een andere categoriewith another category. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke basisnaam hebben.',
	'Saving permissions failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
	'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
	'You cannot delete your own association.' => 'U kunt uw eigen associatie niet verwijderen.',
	'You cannot delete your own user record.' => 'U kunt uw eigen gebruikersgegevens niet verwijderen.',
	'You have no permission to delete the user [_1].' => 'U heeft geen rechten om gebruiker [_1] te verwijderen.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Ontvanger \'[_1]\' (ID:[_2]) verwijderd uit de notificatielijst door \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Reactie (ID:[_1]) door \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
	'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Pagina \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bericht \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'(Unlabeled category)' => '(Categorie zonder label)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van categorie \'[_4]\'',
	'(Untitled entry)' => '(Bericht zonder titel)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Bestand \'[_1]\' opgeladen door \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bestand \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
	'Permisison denied.' => 'Toestemming geweigerd.',
	'The Template Name and Output File fields are required.' => 'De velden sjabloonnaam en uitvoerbestand zijn verplicht.',
	'Invalid type [_1]' => 'Ongeldig type [_1]',
	'Save failed: [_1]' => 'Opslaan mislukt: [_1]',
	'Saving object failed: [_1]' => 'Object opslaan mislukt: [_1]',
	'No Name' => 'Geen naam',
	'Notification List' => 'Notificatie-lijst',
	'IP Banning' => 'IP-verbanning',
	'Can\'t delete that way' => 'Kan niet wissen op die manier',
	'Removing tag failed: [_1]' => 'Tag verwijderen mislukt: [_1]',
	'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'U kunt deze categorie niet verwijderen want ze heeft subcategorieën.  Verplaats of verwijder eerst de subcategorieën als u deze wenst te verwijderen.',
	'Loading MT::LDAP failed: [_1].' => 'Laden van MT::LDAP mislukt: [_1]',
	'Removing [_1] failed: [_2]' => 'Verwijderen van [_1] mislukt: [_2]',
	'System templates can not be deleted.' => 'Systeemsjablonen kunnen niet worden verwijderd.',
	'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
	'Can\'t load file #[_1].' => 'Kan bestand niet laden #[_1].',
	'No such commenter [_1].' => 'Geen reageerder [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status VERTROUWD.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' verbande reageerder \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' maakte de verbanning van reageerder \'[_2]\' ongedaan.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status NIET VERTROUWD.',
	'Need a status to update entries' => 'Status vereist om berichten bij te werken',
	'Need entries to update status' => 'Berichten nodig om status bij te werken',
	'One of the entries ([_1]) did not actually exist' => 'Een van de berichten ([_1]) bestond niet',
	'Entry \'[_1]\' (ID:[_2]) status changed from [_3] to [_4]' => 'Status van bericht \'[_1]\' (ID:[_2]) aangepast van [_3] naar [_4]',
	'You don\'t have permission to approve this comment.' => 'U heeft geen toestemming om deze reactie goed te keuren.',
	'Comment on missing entry!' => 'Reactie op ontbrekend bericht!',
	'Commenters' => 'Registratie',
	'Orphaned comment' => 'Verweesde reactie',
	'Comments Activity Feed' => 'Activiteitenfeed reacties', # Translate - New
	'Orphaned' => 'Verweesd',
	'Plugin Set: [_1]' => 'Pluginset: [_1]',
	'Plugins' => 'Plugins',
	'<strong>[_1]</strong> is &quot;[_2]&quot;' => '<strong>[_1]</strong> is &quot;[_2]&quot;',
	'TrackBack Activity Feed' => 'TrackBackactiviteit-feed',
	'No Excerpt' => 'Geen uittreksel',
	'No Title' => 'Geen titel',
	'Orphaned TrackBack' => 'Verweesde TrackBack',
	'category' => 'categorie',
	'Category' => 'Categorie',
	'Tag' => 'Tag',
	'User' => 'Gebruiker',
	'Entry Status' => 'Status bericht',
	'[_1] Feed' => '[_1] Feed',
	'(user deleted - ID:[_1])' => '(gebruiker verwijderd - ID:[_1])',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; publicatiedatums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ongeldige datum \'[_1]\'; berichtdatums moeten echte datums zijn.',
	'Saving entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opslaan mislukt: [_2]',
	'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
	'Entry \'[_1]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => 'Bericht \'[_1]\' (ID:[_2]) aangepast en status gewijzigd van [_3] naar [_4] door gebruiker \'[_5]\'',
	'Entry \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Bericht \'[_1]\' (ID:[_2]) aangepast door gebruiker \'[_3]\'',
	'No such [_1].' => 'Geen [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Dezelfde basisnaam is al in gebruik.  U gebruikt best een unieke basisnaam.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is nog geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren voor deze zijn ingesteld.',
	'Saving [_1] failed: [_2]' => 'Opslaan van [_1] mislukt: [_2]',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) toegevoegd door gebruiker \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt en status aangepast van [_4] naar [_5] door gebruiker \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt door gebruiker \'[_4]\'',
	'The [_1] must be given a name!' => 'De [_1] moet nog een naam krijgen!',
	'Saving blog failed: [_1]' => 'Blog opslaan mislukt: [_1]',
	'Invalid ID given for personal blog clone source ID.' => 'Ongeldig ID opgegeven als kloonbron voor een persoonlijke weblog.',
	'If personal blog is set, the default site URL and root are required.' => 'Als persoonlijke weblog is ingesteld, dan zijn de standaard URL en hoofdmap van de site vereist.',
	'Feedback Settings' => 'Feedback instellingen',
	'Build error: [_1]' => 'Opbouwfout: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Kon geen voorbeeldbestand maken op deze locatie: [_1]', # Translate - New
	'New [_1]' => 'Nieuwe [_1]',
	'Rebuild Site' => 'Site herbouwen',
	'index template \'[_1]\'' => 'indexsjabloon \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'No permissions' => 'Geen permissies',
	'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' mislukt: [_2]',
	'Create New Role' => 'Nieuwe rol aanmaken',
	'Role name cannot be blank.' => 'Naam van de rol mag niet leeg zijn.',
	'Another role already exists by that name.' => 'Er bestaat al een rol met die naam.',
	'You cannot define a role without permissions.' => 'U kunt geen rol definiëren zonder permissies.',
	'No such entry \'[_1]\'' => 'Geen bericht \'[_1]\'',
	'No email address for user \'[_1]\'' => 'Geen e-mail adres voor gebruiker \'[_1]\'',
	'No valid recipients found for the entry notification.' => 'Geen geldige ontvangers gevonden om op de hoogte te brengen van dit bericht.',
	'[_1] Update: [_2]' => '[_1] update: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Fout bij verzenden mail ([_1]); een andere MailTransfer instelling proberen?',
	'Archive Root' => 'Archiefroot',
	'Site Root' => 'Siteroot',
	'Can\'t load blog #[_1].' => 'Kan blog niet laden #[_1].',
	'You did not choose a file to upload.' => 'U selecteerde geen bestand om op te laden.',
	'Before you can upload a file, you need to publish your blog.' => 'Voor u een bestand kunt opladen, moet u eerst uw weblog publiceren.',
	'Invalid extra path \'[_1]\'' => 'Ongeldig extra pad \'[_1]\'',
	'Can\'t make path \'[_1]\': [_2]' => 'Kan pad \'[_1]\' niet aanmaken: [_2]',
	'Invalid temp file name \'[_1]\'' => 'Ongeldige naam voor temp bestand \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Fout bij openen van \'[_1]\': [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Fout bij wissen van \'[_1]\': [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Bestand met de naam \'[_1]\' bestaat al. (Installeer File::Temp als u bestaande bestanden wenst te kunnen overschrijven.)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Fout bij het aanmaken van een tijdelijk bestand; controleer de TempDir instelling in uw configuratiebestand (momenteel \'[_1]\'), deze locatie zou beschrijfbaar moeten zijn door de webserver.', # Translate - New
	'unassigned' => 'niet toegewezen',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Bestand met de naam \'[_1]\' bestaat al; Poging tot schrijven naar tijdelijk bestand ondernomen, openen mislukt: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Fout bij schrijven van upload naar \'[_1]\': [_2]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Perl module Image::Size is nodig om de breedte en hoogte van opgeladen afbeeldingen te bepalen.',
	'Search & Replace' => 'Zoeken & vervangen',
	'Assets' => 'Mediabestanden',
	'Logs' => 'Logs',
	'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
	'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
	'Saving object failed: [_2]' => 'Object opslaan mislukt: [_2]',
	'You do not have export permissions' => 'U heeft geen exportpermissies',
	'You do not have permission to create users' => 'U heeft geen permissie om gebruikers aan te maken',
	'Importer type [_1] was not found.' => 'Importeertype [_1] niet gevonden.',
	'Saving map failed: [_1]' => 'Map opslaan mislukt: [_1]',
	'Add a [_1]' => 'Voeg een [_1] toe',
	'No label' => 'Geen label',
	'Category name cannot be blank.' => 'Categorienaam kan niet leeg zijn.',
	'Populating blog with default templates failed: [_1]' => 'Inrichten van blog met standaard sjablonen mislukt: [_1]',
	'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kan niet schrijven in de sjablooncache map. Gelieve de permissies na te kijken van de map met de naam <code>[_1]</code> onder de map van uw weblog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kon geen map maken om uw dynamische sjablonen in te cachen. U moet een map aanmaken met de naam <code>[_1]</code> onder de map van uw weblog.',
	'That action ([_1]) is apparently not implemented!' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd!',
	'entry' => 'bericht',
	'Error saving entry: [_1]' => 'Fout bij opslaan bericht: [_1]',
	'Select Blog' => 'Selecteer blog',
	'Selected Blog' => 'Geselecteerde blog',
	'Type a blog name to filter the choices below.' => 'Typ de naam van een weblog in om de onderstaande keuzes te filteren.',
	'Blog Name' => 'Blognaam',
	'Select a System Administrator' => 'Selecteer een systeembeheerder',
	'Selected System Administrator' => 'Geselecteerde systeembeheerder',
	'Type a username to filter the choices below.' => 'Tik een gebruikersnaam in om de keuzes hieronder te filteren.',
	'Error saving file: [_1]' => 'Fout bij opslaan bestand: [_1]',
	'represents a user who will be created afterwards' => 'stelt een gebruiker voor die later zal worden aangemaakt',
	'Select Blogs' => 'Selecteer blogs',
	'Blogs Selected' => 'Geselecteerde blogs',
	'Select Users' => 'Gebruikers selecteren',
	'Username' => 'Gebruikersnaam',
	'Users Selected' => 'Gebruikers geselecteerd',
	'Select Groups' => 'Selecteer groepen',
	'Group Name' => 'Groepsnaam',
	'Groups Selected' => 'Geselecteerde groepen',
	'Type a group name to filter the choices below.' => 'Tik een groepsnaam in om de keuzes hieronder te filteren.',
	'Select Roles' => 'Selecteer rollen',
	'Role Name' => 'Naam rol',
	'Roles Selected' => 'Geselecteerde rollen',
	'' => '', # Translate - New
	'Create an Association' => 'Maak een associatie aan',
	'Backup' => 'Backup',
	'Backup & Restore' => 'Backup & Restore',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om backups te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om restore-operaties te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) werden met succes gebackupt door gebruiker \'[_2]\'',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type systeem werd met succes gebackupt door gebruiker \'[_1]\'',
	'You must select what you want to backup.' => 'U moet selecteren wat u wenst te backuppen.',
	'[_1] is not a number.' => '[_1] is geen getal.',
	'Choose blogs to backup.' => 'Kies blogs om te backuppen.',
	'Archive::Tar is required to archive in tar.gz format.' => 'Archive::Tar is vereist voor een archief in tar.gz formaat.',
	'IO::Compress::Gzip is required to archive in tar.gz format.' => 'IO::Compress::Gzip is vereist voor een archief in tar.gz formaat.',
	'Archive::Zip is required to archive in zip format.' => 'Archive::Zip is vereist om te archiveren in zip formaat.',
	'Specified file was not found.' => 'Het opgegeven bestand werd niet gevonden.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] downloadde met succes backupbestand ([_2])',
	'Restore' => 'Restore',
	'Required modules (Archive::Tar and/or IO::Uncompress::Gunzip) are missing.' => 'Vereiste modules (Archive::Tar en/of IO::Uncompress::Gunzip) ontbreken.',
	'Uploaded file was invalid: [_1]' => 'Opgeladen bestand was niet geldig: [_1]',
	'Required module (Archive::Zip) is missing.' => 'Vereiste module (Archive::Zip) ontbreekt.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Gelieve xml, tar.gz, zip, of manifest te gebruiken als bestandsextensies.',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Een aantal [_1] werden niet teruggezet omdat hun ouderobjecten niet werden teruggezet.',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">activity log</a>.' => 'Sommige objecten werden niet teruggezet omdat hun ouder-objecten niet werden teruggezet.  Meer details zijn te vinden in het <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">activiteitenlog</a>.', # Translate - New
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Objecten werden met succes teruggezet in het Movable Type systeem door gebruiker \'[_1]\'',
	'[_1] is not a directory.' => '[_1] is geen map.',
	'Error occured during restore process.' => 'Er deed zich een fout voor tijdens het restore-proces.',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of files could not be restored.' => 'Een aantal bestanden konden niet worden teruggezet.',
	'Please upload [_1] in this page.' => 'Gelieve [_1] op te laden op deze pagina.',
	'File was not uploaded.' => 'Bestand werd niet opgeladen.',
	'Restoring a file failed: ' => 'Terugzetten van een bestand mislukt: ',
	'Some objects were not restored because their parent objects were not restored.' => 'Sommige objecten werden niet teruggezet omdat hun ouder-objecten niet werden teruggezet.',
	'Some of the files were not restored correctly.' => 'Een aantal bestanden werden niet correct teruggezet.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Gedetailleerde informatie is terug te vinden in het <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activiteitenlog</a>.', # Translate - New
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] heeft de terugzet-operatie van meerdere bestanden voortijdig afgebroken.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het aanpassen...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het verwijderen...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Archiefpad aan het aanpassen voor blog \'[_1]\' (ID:[_2])...', # Translate - New
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Archiefpad aan het verwijderen voor blog \'[_1]\' (ID:[_2])...', # Translate - New
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Bestandslocatie voor mediabestand \'[_1]\' (ID:[_2]) wordt aangepast...',
	'Some of the actual files for assets could not be restored.' => 'Een aantal van de mediabestanden konden niet teruggezet worden.',
	'Parent comment id was not specified.' => 'ID van ouder-reactie werd niet opgegeven.',
	'Parent comment was not found.' => 'Ouder-reactie werd niet gevonden.',
	'You can\'t reply to unapproved comment.' => 'U kunt niet antwoorden op een niet-gekeurde reactie.',
	'entries' => 'berichten',
	'Publish Entries' => 'Berichten publiceren',
	'Unpublish Entries' => 'Publicatie ongedaan maken',
	'Add Tags...' => 'Tags toevoegen',
	'Tags to add to selected entries' => 'Tags toe te voegen aan geselecteerde berichten',
	'Remove Tags...' => 'Tags verwijderen',
	'Tags to remove from selected entries' => 'Tags te verwijderen van geselecteerde berichten',
	'Batch Edit Entries' => 'Berichten bewerken in bulk', # Translate - New
	'Publish Pages' => 'Gepubliceerde pagina\'s', # Translate - New
	'Unpublish Pages' => 'Niet gepubliceerde pagina\'s', # Translate - New
	'Tags to add to selected pages' => 'Tags om toe te voegen aan geselecteerde pagina\'s', # Translate - New
	'Tags to remove from selected pages' => 'Tags om te verwijderen van geselecteerde pagina\'s', # Translate - New
	'Batch Edit Pages' => 'Pagina\'s bewerken in bulk', # Translate - New
	'Tags to add to selected assets' => 'Tags om toe te voegen aan de geselecteerde mediabestanden', # Translate - New
	'Tags to remove from selected assets' => 'Tags om te verwijderen van de geselecteerde mediabestanden', # Translate - New
	'Unpublish TrackBack(s)' => 'Publicatie ongedaan maken',
	'Unpublish Comment(s)' => 'Publicatie ongedaan maken',
	'Trust Commenter(s)' => 'Reageerder(s) vertrouwen',
	'Untrust Commenter(s)' => 'Reageerder(s) niet meer vertrouwen',
	'Ban Commenter(s)' => 'Reageerder(s) verbannen',
	'Unban Commenter(s)' => 'Verbanning opheffen',
	'Recover Password(s)' => 'Wachtwoord(en) terugvinden',
	'Delete' => 'Verwijderen',
	'Published entries' => 'Gepubliceerde berichten', # Translate - New
	'Unpublished entries' => 'Niet gepubliceerde berichten', # Translate - New
	'Scheduled entries' => 'Geplande berichten', # Translate - New
	'My entries' => 'Mijn berichten', # Translate - New
	'Entries with comments in the last 7 days' => 'Berichten met reacties in de laatste 7 dagen', # Translate - New
	'All Non-Spam Comments' => 'Alle non-spam reacties', # Translate - New
	'Comments on my posts' => 'Reacties op mijn berichten', # Translate - New
	'Comments marked as spam' => 'Reacties gemarkeerd als spam', # Translate - New
	'Unpublished comments' => 'Ongepubliceerde reacties', # Translate - New
	'Published comments' => 'Gepubliceerde reacties', # Translate - New
	'My comments' => 'Mijn reacties', # Translate - New
	'All comments in the last 7 days' => 'Alle reacties in de laatste 7 dagen', # Translate - New
	'All comments in the last 24 hours' => 'Alle reacties in de laatste 24 uur', # Translate - New
	'Create' => 'Aanmaken',
	'Manage' => 'Beheren', # Translate - New
	'Design' => '', # Translate - New
	'Preferences' => 'Voorkeuren',
	'Admin' => 'Admin', # Translate - New
	'Styles' => 'Stijlen', # Translate - New
	'Blog Settings' => 'Bloginstellingen', # Translate - New
	'Members' => 'Leden',
	'Notifications' => 'Notificaties',
	'Tools' => 'Gereedschappen', # Translate - New
	'/' => '/', # Translate - New
	'<' => '<', # Translate - New

## lib/MT/App/Viewer.pm
	'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'Dit is een experimentele optie; schakel SafeMode uit in (mt.cfg) om er gebruik van te maken.',
	'Not allowed to view blog [_1]' => 'Geen toestemming om blog [_1] te bekijken',
	'Loading blog with ID [_1] failed' => 'Laden van blog met ID [_1] mislukt',
	'Can\'t load \'[_1]\' template.' => 'Kan sjabloon \'[_1]\' niet laden.',
	'Building template failed: [_1]' => 'Opbouwen van sjabloon mislukt: [_1]',
	'Invalid date spec' => 'Ongeldige date spec',
	'Can\'t load template [_1]' => 'Kan sjabloon [_1] niet laden',
	'Building archive failed: [_1]' => 'Opbouwen van archief mislukt: [_1]',
	'Invalid entry ID [_1]' => 'Ongeldige entry ID [_1]',
	'Entry [_1] is not published' => 'Bericht [_1] is ongepubliceerd',
	'Invalid category ID \'[_1]\'' => 'Ongeldig categorie-ID \'[_1]\'',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Er deed zich een fout voor bij het aanmaken van de activiteitenfeed: [_1].',
	'No permissions.' => 'Geen permissies.',
	'[_1] Weblog TrackBacks' => '[_1] Weblog TrackBacks',
	'All Weblog TrackBacks' => 'Alle Weblog TrackBacks',
	'[_1] Weblog Comments' => '[_1] Weblogreacties',
	'All Weblog Comments' => 'Alle Weblogreacties',
	'[_1] Weblog Entries' => '[_1] Weblogberichten',
	'All Weblog Entries' => 'Alle weblogberichten',
	'[_1] Weblog Activity' => '[_1] Weblogactiviteit',
	'All Weblog Activity' => 'Alle weblogactiviteit',
	'Movable Type System Activity' => 'Movable Type systeemactiviteit',
	'Movable Type Debug Activity' => 'Movable Type debugactiviteit',

## lib/MT/App/Search.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'U bent momenteel al een zoekactie aan het uitvoeren.  Gelieve te wachten tot uw zoekopdracht voltooid is.',
	'Search failed. Invalid pattern given: [_1]' => 'Zoeken mislukt. Ongeldig patroon opgegeven: [_1]',
	'Search failed: [_1]' => 'Zoeken mislukt: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'Er is geen alternatief sjabloon opgegeven voor sjabloon \'[_1]\'',
	'Opening local file \'[_1]\' failed: [_2]' => 'Lokaal bestand \'[_1]\' openen mislukt: [_2]',
	'Building results failed: [_1]' => 'Resultaten opbouwen mislukt: [_1]',
	'Search: query for \'[_1]\'' => 'Zoeken: zoekopdracht voor \'[_1]\'',
	'Search: new comment search' => 'Zoeken: opnieuw zoeken in de reacties',

## lib/MT/App/Trackback.pm
	'You must define a Ping template in order to display pings.' => 'U moet een pingsjabloon definiëren om pings te kunnen tonen.',
	'Trackback pings must use HTTP POST' => 'Trackback pings moeten HTTP POST gebruiken',
	'Need a TrackBack ID (tb_id).' => 'TrackBack ID vereist (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'Ongeldig TrackBack-ID \'[_1]\'',
	'You are not allowed to send TrackBack pings.' => 'U heeft geen toestemming om TrackBack pings te versturen.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'U bent te snel TrackBacks aan het pingen. Probeer het later opnieuw.',
	'Need a Source URL (url).' => 'Bron-URL vereist (url).',
	'This TrackBack item is disabled.' => 'Dit TrackBack item is uitgeschakeld.',
	'This TrackBack item is protected by a passphrase.' => 'Dit TrackBack item is beschermd door een wachtwoord.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack op "[_1]" van "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack op categorie \'[_1]\' (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'Kan RSS feed \'[_1]\' niet aanmaken: ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'Nieuwe TrackBack ping naar bericht [_1] ([_2])',
	'New TrackBack Ping to Category [_1] ([_2])' => 'Nieuwe TrackBack ping naar categorie [_1] ([_2])',

## lib/MT/FileMgr/Local.pm
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Herbenoemen van \'[_1]\' naar \'[_2]\' mislukt: [_3]',
	'Deleting \'[_1]\' failed: [_2]' => 'Verwijderen van \'[_1]\' mislukt: [_2]',

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTP verbinding mislukt: [_1]',
	'SFTP get failed: [_1]' => 'SFTP get mislukt: [_1]',
	'SFTP put failed: [_1]' => 'SFTP put mislukt: [_1]',
	'Creating path \'[_1]\' failed: [_2]' => 'Aanmaken van pad \'[_1]\' mislukt: [_2]',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV verbinding mislukt: [_1]',
	'DAV open failed: [_1]' => 'DAV open mislukt: [_1]',
	'DAV get failed: [_1]' => 'DAV get mislukt: [_1]',
	'DAV put failed: [_1]' => 'DAV put mislukt: [_1]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Er deed zich een fout voor: [_1]',

## lib/MT/Blog.pm
	'First Blog' => 'Eerste weblog',
	'No default templates were found.' => 'Er werden geen standaardsjablonen gevonden.',
	'Cloned blog... new id is [_1].' => 'Blog gekloond... nieuw ID is [_1]',
	'Cloning permissions for blog:' => 'Permissies worden gekloond voor blog:',
	'[_1] records processed...' => '[_1] items verwerkt...',
	'[_1] records processed.' => '[_1] items verwerkt.',
	'Cloning associations for blog:' => 'Associaties worden gekloond voor blog:',
	'Cloning entries for blog...' => 'Berichten worden gekloond voor blog...',
	'Cloning categories for blog...' => 'Categorieën worden gekloond voor blog...',
	'Cloning entry placements for blog...' => 'Berichtcategorieën wordt gekloond voor blog...',
	'Cloning comments for blog...' => 'Reacties worden gekloond voor blog...',
	'Cloning entry tags for blog...' => 'Berichttags worden gekloond voor blog...',
	'Cloning TrackBacks for blog...' => 'Trackbacks worden gekloond voor blog...',
	'Cloning TrackBack pings for blog...' => 'TrackBack pings worden gekloond voor blog...',
	'Cloning templates for blog...' => 'Sjablonen worden gekloond voor blog...',
	'Cloning template maps for blog...' => 'Sjabloonkoppelingen worden gekloond voor blog...',

## lib/MT/Upgrade.pm
	'Migrating Nofollow plugin settings...' => 'Nofollow plugin instellingen worden gemigreerd', # Translate - New
	'Updating system search template records...' => 'Systeemzoeksjablonen worden bijgewerkt...', # Translate - New
	'Custom ([_1])' => 'Gepersonaliseerd ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'Deze rol werd aangemaakt door Movable Type tijdens de upgrade.',
	'Migrating permission records to new structure...' => 'Permissies worden gemigreerd naar de nieuwe structuur...', # Translate - New
	'Migrating role records to new structure...' => 'Rollen worden gemigreerd naar de nieuwe structuur', # Translate - New
	'Migrating system level permissions to new structure...' => 'Systeempermissies worden gemigreerd naar de nieuwe structuur...', # Translate - New
	'Invalid upgrade function: [_1].' => 'Ongeldige upgrade-functie: [_1].',
	'Error loading class [_1].' => 'Fout bij het laden van klasse [_1].', # Translate - New
	'Creating initial blog and user records...' => 'Initiële blog en gebruiker worden aangemaakt...', # Translate - New
	'Error saving record: [_1].' => 'Fout bij opslaan gegevens: [_1].',
	'Removing Dynamic Site Bootstrapper index template...' => 'Dynamisch site bootstrapper indexsjabloon wordt verwijderd...', # Translate - New
	'Fixing binary data for Microsoft SQL Server storage...' => 'Binaire data aan het fixen voor opslag in Microsoft SQL Server...', # Translate - New
	'Creating new template: \'[_1]\'.' => 'Nieuw sjabloon wordt aangemaakt: \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Bezig met sjablonen aan archieftypes toe te wijzen...',
	'Renaming php plugin file names...' => 'Php plugin bestandsnamen aan het aanpassen...', # Translate - New
	'Error opening directory: [_1].' => 'Fout bij het openen van map: [_1]', # Translate - New
	'Error rename php files. Please check the Activity Log' => 'Fout bij het aanpassen van de naam van php bestanden.  Gelieve het activiteitenlog na te kijken', # Translate - New
	'Cannot rename in [_1]: [_2].' => 'Kan naam niet aanpassen in [_1]: [_2]', # Translate - New
	'Upgrading table for [_1]' => 'Bezig tabel te upgraden voor [_1]',
	'Upgrading database from version [_1].' => 'Database wordt bijgewerkt van versie [_1].',
	'Database has been upgraded to version [_1].' => 'Database is bijgewerkt naar versie [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Gebruiker \'[_1]\' deed een upgrade van de database naar versie [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema versie [_3]).' => '', # Translate - New
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' deed een upgrade van plugin \'[_2]\' naar versie [_3] (schema versie [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Plugin \'[_1]\' met succes geïnstalleerd.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' installeerde plugin \'[_2]\', versie [_3] (schema versie [_4]).',
	'Setting your permissions to administrator.' => 'Bezig uw permissies als administrator in te stellen.',
	'Creating configuration record.' => 'Configuratiegegevens aan het aanmaken.',
	'Creating template maps...' => 'Bezig sjabloonkoppelingen aan te maken...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2].',
	'Error loading class: [_1].' => 'Fout bij het laden van klasse: [_1].',
	'Creating entry category placements...' => 'Bezig berichten in categoriën te plaatsen...',
	'Updating category placements...' => 'Categorieplaatsingen worden bijgewerkt...',
	'Assigning comment/moderation settings...' => 'Instellingen voor reacties/moderatie worden toegewezen...',
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
	'Setting new entry defaults for blogs...' => 'Standaardinstellingen voor nieuwe blogs aan het vastleggen...', # Translate - New
	'Migrating any "tag" categories to new tags...' => 'Alle "tag" categorieën worden naar nieuwe tags gemigreerd...',
	'Assigning custom dynamic template settings...' => 'Aangepaste instellingen voor dynamische sjablonen worden toegewezen...',
	'Assigning user types...' => 'Gebruikertypes worden toegewezen...',
	'Assigning category parent fields...' => 'Velden van hoofdcategorieën worden toegewezen...',
	'Assigning template build dynamic settings...' => 'Instellingen voor dynamische sjabloonopbouw worden toegewezen...',
	'Assigning visible status for comments...' => 'Status zichtbaarheid van reacties wordt toegekend...',
	'Assigning junk status for comments...' => 'Spamstatus wordt aan reacties toegewezen...',
	'Assigning visible status for TrackBacks...' => 'Zichtbaarheidsstatus van TrackBacks wordt toegekend...',
	'Assigning junk status for TrackBacks...' => 'Spamstatus wordt toegekend aan TrackBacks...',
	'Assigning basename for categories...' => 'Basisnaam voor categorieën wordt toegekend...',
	'Assigning user status...' => 'Gebruikersstatus wordt toegekend...',
	'Migrating permissions to roles...' => 'Permissies aan het migreren naar rollen...',
	'Populating authored and published dates for entries...' => 'Bezig creatie- en publicatiedatums voor berichten in te stellen...', # Translate - New

## lib/MT/Plugin.pm

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Foute AuthenticationModule configuratie \'[_1]\': [_2]',
	'Bad AuthenticationModule config' => 'Foute AuthenticationModule configuratie',

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'Tag moet een geldige naam hebben',
	'This tag is referenced by others.' => 'Deze tag is gerefereerd door anderen.',

## lib/MT/Builder.pm
	'<[_1]> at line # is unrecognized.' => '<[_1]> op regel # is niet herkend', # Translate - New
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> op regel [_2] is niet herkend', # Translate - New
	'<[_1]> with no </[_1]> on line #' => '<[_1]> zonder </[_1]> op regel #', # Translate - New
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> zonder </[_1]> op regel [_2]', # Translate - New
	'Error in <mt:[_1]> tag: [_2]' => 'Fout in <mt:[_1]> tag: [_2]',
	'No handler exists for tag [_1]' => 'Er bestaat geen handler voor tag [_1]',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'Categorieën moeten bestaan binnen dezelfde blog',
	'Category loop detected' => 'Categorielus gedetecteerd',

## lib/MT/Template.pm
	'File not found: [_1]' => 'Bestand niet gevonden: [_1]',
	'Parse error in template \'[_1]\': [_2]' => 'Ontleedfout in sjabloon \'[_1]\': [_2]',
	'Build error in template \'[_1]\': [_2]' => 'Opbouwfout in sjabloon \'[_1]\': [_2]',
	'Template with the same name already exists in this blog.' => 'Er bestaat al een sjabloon met dezelfde naam in deze weblog.',
	'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Gelinkt bestand \'[_1]\' openen mislukt: [_2]',

## lib/MT/Entry.pm

## lib/MT.pm
	'Powered by [_1]' => 'Aangedreven door [_1]',
	'Version [_1]' => 'Versie [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',
	'OpenID URL' => 'OpenID URL', # Translate - New
	'OpenID is an open and decentralized single sign-on identity system.' => 'OpenID is een open en gedecentraliseerd single sign-on identiteitssysteem.', # Translate - New
	'Sign In' => 'Aanmelden', # Translate - Case
	'Learn more about OpenID.' => 'Meer weten over OpenID.', # Translate - New
	'Your LiveJournal Username' => 'Uw LiveJournal gebruikersnaam', # Translate - New
	'Sign in using your LiveJournal username.' => 'Aanmelden met uw LiveJournal gebruikersnaam.', # Translate - New
	'Learn more about LiveJournal.' => 'Meer weten over LiveJournal.', # Translate - New
	'Your Vox Blog URL' => 'URL van uw Vox blog', # Translate - New
	'Sign in using your Vox blog URL' => 'Aanmelden met de URL van uw Vox blog', # Translate - New
	'Learn more about Vox.' => 'Meer weten over Vox.', # Translate - New
	'TypeKey is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypeKey is een gratis, open systtem dat uw een centrale identiteit verschaft om te reageren op weblogs en om u mee aan te melden op andere websites.  U kunt hier gratis registreren.', # Translate - New
	'Sign in or register with TypeKey.' => 'Aanmelden of registreren via TypeKey', # Translate - New
	'Hello, world' => 'Hello, world',
	'Hello, [_1]' => 'Hallo, [_1]',
	'Message: [_1]' => 'Bericht: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Indien aanwezig, moet het derde argument van add_callback een object zijn van het type MT::Component of MT::Plugin', # Translate - New
	'4th argument to add_callback must be a CODE reference.' => '4th argument van add_callback moet een CODE referentie zijn.',
	'Two plugins are in conflict' => 'Twee plugins zijn in conflict',
	'Invalid priority level [_1] at add_callback' => 'Ongeldig prioriteitsniveau [_1] in add_callback',
	'Unnamed plugin' => 'Naamloze plugin',
	'[_1] died with: [_2]' => '[_1] faalde met volgende boorschap: [_2]',
	'Bad ObjectDriver config' => 'Fout in ObjectDriver configuratie',
	'Bad CGIPath config' => 'Fout in CGIPath configuratie',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Ontbrekend configuratiebestand.  Misschien vergat u mt-config.cgi-original te hernoemen naar mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Plugin fout: [_1] [_2]',
	'OpenID' => 'OpenID', # Translate - New
	'LiveJournal' => 'LiveJournal', # Translate - New
	'Vox' => 'Vox', # Translate - New
	'TypeKey' => 'TypeKey', # Translate - New
	'Movable Type default' => 'Standaard Movable Type', # Translate - New
	'Wiki' => 'Wiki', # Translate - New

## lib/MT.pm.pre

## mt-static/js/edit.js
	'Enter email address:' => 'Voer e-mail adres in:',

## mt-static/js/dialog.js
	'(None)' => '(Geen)',

## mt-static/js/assetdetail.js
	'No Preview Available' => 'Geen voorbeeld beschikbaar', # Translate - New
	'Click to see uploaded file.' => 'Klik om het opgeladen bestand te bekijken', # Translate - New

## mt-static/mt.js
	'to delete' => 'om te verwijderen',
	'to remove' => 'om te verwijderen',
	'to enable' => 'om in te schakelen',
	'to disable' => 'om uit te schakelen',
	'delete' => 'wissen',
	'remove' => 'verwijderen',
	'You did not select any [_1] to [_2].' => 'U selecteerde geen [_1] om te [_2].',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Bent u zeker dat u deze rol wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rol geassocieerd zijn.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Bent u zeker dat u deze [_1] rollen wenst te verwijderen?  Door dit te doen worden de permissies weggenomen van gebruikers en groepen die momenteel met deze rollen geassocieerd zijn.',
	'Are you sure you want to [_2] this [_1]?' => 'Bent u zeker dat u deze [_1] wenst te [_2]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Bent u zeker dat u deze [_1] geselecteerde [_2] wenst te [_3]?',
	'You did not select any [_1] to remove.' => 'U selecteerde geen [_1] om te verwijderen.',
	'Are you sure you want to remove this [_1] from this group?' => 'Bent u zeker dat u deze [_1] uit deze groep wenst te verwijderen?',
	'Are you sure you want to remove the [_1] selected [_2] from this group?' => 'Bent u zeker dat u de [_1] geselecteerde [_2] uit deze groep wenst te verwijderen?',
	'Are you sure you want to remove this [_1]?' => 'Bent u zeker dat u deze [_1] wenst te verwijderen?',
	'Are you sure you want to remove the [_1] selected [_2]?' => 'Bent u zeker dat u de [_1] geselecteerde [_2] wenst te verwijderen?',
	'enable' => 'inschakelen',
	'disable' => 'uitschakelen',
	'You did not select any [_1] [_2].' => 'U selecteerde geen [_1] [_2]',
	'You can only act upon a minimum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren om minimaal [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'U kunt enkel een handeling uitvoeren op maximum [_1] [_2].',
	'You must select an action.' => 'U moet een handeling selecteren',
	'to mark as junk' => 'om als verworpen te markeren',
	'to remove "junk" status' => 'om niet langer als "verworpen" te markeren',
	'Enter URL:' => 'Voer URL in:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen over alle weblogs?',
	'Loading...' => 'Laden...',
	'Showing: [_1] &ndash; [_2] of [_3]' => 'Getoond: [_1] &ndash; [_2] van [_3]',
	'Showing: [_1] &ndash; [_2]' => 'Getoond: [_1] &ndash; [_2]',
	' [_1]Republish[_2] your site to see these changes take effect.' => ' [_1]Herpubliceer[_2] uw site om de wijzigingen zichtbaar te maken.', # Translate - New

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]', # Translate - New

## php/lib/function.mtcommentfields.php

## php/lib/block.mtentries.php

## php/lib/function.mtremotesigninlink.php

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php

## plugins/GoogleSearch/tmpl/config.tmpl
	'Google API Key' => 'Google API sleutel', # Translate - New
	'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Als u een Google API-functie wenst te gebruiken, hebt u een Google API-code nodig. Plak deze hier.',

## plugins/GoogleSearch/GoogleSearch.pl
	'You used [_1] without a query.' => 'U gebruikte [_1] zonder query.',
	'You need a Google API key to use [_1]' => 'U heeft een Google API key nodig om [_1] te gebruiken',
	'You used a non-existent property from the result structure.' => 'U gebruikte een onbestaande eigenschap van de resultaatstructuur.',

## plugins/feeds-app-lite/tmpl/header.tmpl
	'Main Menu' => 'Hoofdmenu',
	'System Overview' => 'Systeemoverzicht',
	'Help' => 'Hulp',
	'Welcome' => 'Welkom',
	'Logout' => 'Afmelden',
	'Search (q)' => 'Zoeken (q)',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widgetmaker',
	'Feed Configuration' => 'Feed-configuratie',
	'Feed URL' => 'Feed-URL',
	'Title' => 'Titel',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Vul een titel in voor uw widget.  Deze titel zal ook getoond worden als de titel van de feed wanneer die op uw gepubliceerde weblog verschijnt.',
	'Display' => 'Toon',
	'Select the maximum number of entries to display.' => 'Selecteer het maximum aantal berichten om te tonen.',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'Alle',
	'Save' => 'Opslaan',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Er werden meerdere feeds gevonden.  Selecteer de feed die u wenst te gebruiken.  Feeds.App Lite ondersteunt RSS 1.0, 2.0 en Atom feeds die alleen uit tekst bestaan.',
	'Type' => 'Type',
	'URI' => 'URI',
	'Continue' => 'Doorgaan',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite maakt modules aan die feedgegevens bevatten.  Eens u het gebruikt heeft om deze modules aan te maken, kunt u ze daarna gebruiken in uw weblogsjablonen.',
	'You must enter an address to proceed' => 'U moet een adres invullen om verder te kunnen gaan',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Vul de URL in van een feed, of de URL van een site met een feed..',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1].' => 'Er konden geen feeds gevonden worden met [_1].',
	'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Er deed zich een fout voor bij het verwerken van [_1]. Kijk <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">hier</a> voor meer details en probeer eventueel opnieuw.',
	'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Gefeliciteerd! Er is een sjabloonmodule van het type Widget aangemaakt met de naam <strong>[_1]</strong> die u verder kunt <a href="[_2]">bewerken</a> om te veranderen hoe het er komt uit te zien.',
	'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Dit kan worden opgenomen in uw gepubliceerde weblog via de <a href="[_1]">WidgetManager</a> of deze MTInclude tag',
	'It can be included onto your published blog using this MTInclude tag' => 'Dit kan worden opgenomen in uw gepubliceerde weblog door deze MTInclude tag te gebruiken',
	'Create Another' => 'Maak er nog één aan',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite helpt u om feeds te herpubliceren op uw weblogs.  Wenst u meer te doen met feeds in Movable Type?',
	'Upgrade to Feeds.App' => 'Upgraden naar Feeds.App',
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' is een verplicht argument van [_2]',
	'MT[_1] was not used in the proper context.' => 'MT[_1] werd niet gebruikt in de juiste context.',

## plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => 'Er deed zich een fout voor bij het verwerken van [_1].  De vorige versie van de feed werd gebruikt.  Een HTTP status van [_2] werd teruggezonden.', # Translate - New
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => 'Er deed zich een fout voor bij het verwerken van [_1].  De vorige versie van de feed was niet beschikbaar.  Een HTTP status van [_2] werd teruggezonden.', # Translate - New

## plugins/Textile/textile2.pl
	'Textile 2' => 'Textile 2', # Translate - New

## plugins/Markdown/SmartyPants.pl
	'Markdown With SmartyPants' => 'Markdown met SmartyPants', # Translate - New

## plugins/Markdown/Markdown.pl
	'Markdown' => 'Markdown', # Translate - New

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend you to <a href=\'[_1]\'>configure your weblog\'s publishing paths</a> first.' => 'Voordat u uw WordPress berichten importeert in Movable Type, raden wij aan om eerst <a href=\'[_1]\'>de publicatiepaden van uw weblog in te stellen</a>.', # Translate - New
	'Upload path for this WordPress blog' => 'Oplaadpad voor deze WordPress blog', # Translate - New
	'Replace with' => 'Vervangen door', # Translate - New

## plugins/WXRImporter/WXRImporter.pl
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)', # Translate - New

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Bestand is niet in WXR formaat.',
	'Saving asset (\'[_1]\')...' => 'Bezig met opslaan mediabestand (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' en mediabestand zal getagd worden als (\'[_1]\')...',
	'Saving page (\'[_1]\')...' => 'Pagina aan het opslaan (\'[_1]\')...',

## plugins/TemplateRefresh/tmpl/results.tmpl
	'Backup and Refresh Templates' => 'Backup nemen en sjablonen herstellen',
	'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
	'Return' => 'Terug',

## plugins/TemplateRefresh/TemplateRefresh.pl
	'Error loading default templates.' => 'Fout bij het laden van standaardsjablonen.',
	'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Onvoldoende permissies om de sjabonen te bewerken van weblog \'[_1]\'',
	'Processing templates for weblog \'[_1]\'' => 'Sjablonen voor weblog \'[_1]\' worden verwerkt',
	'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Bezig \'[_3]\ te verversen (met <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>).',
	'Refreshing template \'[_1]\'.' => 'Sjabloon \'[_1]\' wordt ververst.',
	'Error creating new template: ' => 'Fout bij aanmaken nieuw sjabloon: ',
	'Created template \'[_1]\'.' => 'Sjabloon \'[_1]\' aangemaakt.',
	'Insufficient permissions for modifying templates for this weblog.' => 'Onvoldoende permissies voor het bewerken van de sjablonen van deze weblog.',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Sjabloon \'[_1]\' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.',
	'Refresh Template(s)' => 'Sjablo(o)n(en) verversen',

## plugins/ExtensibleArchives/DatebasedCategories.pl
	'CATEGORY-YEARLY_ADV' => 'Categorie per jaar',
	'CATEGORY-MONTHLY_ADV' => 'Categorie per maand',
	'CATEGORY-DAILY_ADV' => 'Categorie per dag',
	'CATEGORY-WEEKLY_ADV' => 'Categorie per week',
	'category/sub_category/yyyy/index.html' => 'categorie/sub_categorie/jjjj/index.html', # Translate - New
	'category/sub-category/yyyy/index.html' => 'categorie/sub-categorie/jjjj/index.html', # Translate - New
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sub_categorie/jjjj/mm/index.html', # Translate - New
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sub-categorie/jjjj/mm/index.html', # Translate - New
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sub_categorie/jjjj/dd/index.html', # Translate - New
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sub-categorie/jjjj/dd/index.html', # Translate - New
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sub_categorie/jjjj/mm/dag-week/index.html', # Translate - New
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sub-categorie/jjjj/mm/dag-week/index.html', # Translate - New

## plugins/ExtensibleArchives/AuthorArchive.pl
	'Author #[_1]' => 'Auteur #[_1]',
	'AUTHOR_ADV' => 'Auteur',
	'Author #[_1]: ' => 'Auteur #[_1]: ',
	'AUTHOR-YEARLY_ADV' => 'Auteur per jaar',
	'AUTHOR-MONTHLY_ADV' => 'Auteur per maand',
	'AUTHOR-WEEKLY_ADV' => 'Auteur per week',
	'AUTHOR-DAILY_ADV' => 'Auteur per dag',
	'author_display_name/index.html' => 'naam_auteur/index.html', # Translate - New
	'author-display-name/index.html' => 'naam-auteur/index.html', # Translate - New
	'author_display_name/yyyy/index.html' => 'naam_auteur/jjjj/index.html', # Translate - New
	'author-display-name/yyyy/index.html' => 'naam-auteur/jjjj/index.html', # Translate - New
	'author_display_name/yyyy/mm/index.html' => 'naam_auteur/jjjj/mm/index.html', # Translate - New
	'author-display-name/yyyy/mm/index.html' => 'naam-auteur/jjjj/mm/index.html', # Translate - New
	'author_display_name/yyyy/mm/day-week/index.html' => 'naam_auteur/jjjj/mm/dag-week/index.html', # Translate - New
	'author-display-name/yyyy/mm/day-week/index.html' => 'naam-auteur/jjjj/mm/dag-week/index.html', # Translate - New
	'author_display_name/yyyy/mm/dd/index.html' => 'naam_auteur/jjjj/mm/dd/index.html', # Translate - New
	'author-display-name/yyyy/mm/dd/index.html' => 'naam-auteur/jjjj/mm/dd/index.html', # Translate - New

## plugins/Cloner/cloner.pl
	'Cloning Weblog' => 'Bezig met klonen van weblog',
	'Error' => 'Fout',
	'Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Klaar! U kunt nu <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">terugkeren naar het weblog overzicht</a> of <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_2]\');\">de hoofdmap en URL van de site instellen</a>', # Translate - New
	'No weblog was selected to clone.' => 'Er werd geen weblog geselecteerd om te klonen.',
	'This action can only be run for a single weblog at a time.' => 'Deze actie kan maar op één weblog per keer uitgevoerd worden.',
	'Invalid blog_id' => 'Ongeldig blog_id',
	'Clone Weblog' => 'Weblog klonen',

## plugins/WidgetManager/tmpl/header.tmpl
	'Movable Type Publishing Platform' => 'Movable Type publicatieplatform',
	'Go to:' => 'Ga naar:',
	'Select a blog' => 'Selecteer een blog',
	'Weblogs' => 'Weblogs',
	'System-wide listing' => 'Overzicht op systeemniveau',

## plugins/WidgetManager/tmpl/edit.tmpl
	'Please use a unique name for this widget manager.' => 'Gelieve een unieke naam te gebruiken voor deze widget manager.',
	'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'U heeft al een widget manager met de naam [_1]. Gelieve een unieke naam te gebruiken voor deze widget manager.',
	'Your changes to the Widget Manager have been saved.' => 'Uw wijzigingen aan de Widget Manager zijn opgeslagen.',
	'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Klik en sleep de widgets die u wenst in de kolom <strong>Geïnstalleerde widgets</strong>.',
	'Installed Widgets' => 'Geïnstalleerde widgets',
	'Available Widgets' => 'Beschikbare widgets',
	'Save Changes' => 'Wijzigingen opslaan',
	'Save changes (s)' => 'Wijziging(en) opslaan',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widgets' => 'Widgets', # Translate - New
	'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'De geselecteerde Widget Manager(s) is met succes verwijderd van uw weblog.',
	'To add a Widget Manager to your templates, use the following syntax:' => 'Om een Widget Manager aan uw sjablonen toe te voegen, moet u volgende syntax gebruiken:',
	'<strong>&lt;$MTWidgetManager name=&quot;Name of the Widget Manager&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetManager name=&quot;Naam van de Widgetmanager&quot;$&gt;</strong>', # Translate - New
	'Add Widget Manager' => 'Voeg Widget Manager toe',
	'Create Widget Manager' => 'Widget Manager aanmaken',
	'Widget Manager' => 'Widget Manager',
	'Widget Managers' => 'Widget Managers',
	'Delete selected Widget Managers (x)' => 'Geselecteerde Widget Managers verwijderen (x)',

## plugins/WidgetManager/WidgetManager.pl
	'Failed to find WidgetManager::Plugin::[_1]' => 'Vinden van WidgetManager::Plugin::[_1] mislukt',

## plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

## plugins/WidgetManager/default_widgets/technorati_search.tmpl
	'Technorati' => 'Technorati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => 'Zoek op <a href=\'http://www.technorati.com/\'>Technorati</a>', # Translate - New
	'this blog' => 'deze weblog',
	'all blogs' => 'alle blogs',
	'Blogs that link here' => 'Blogs die hierheen linken',

## plugins/WidgetManager/default_widgets/calendar.tmpl
	'Monthly calendar with links to each day\'s posts' => 'Maandkalender met links naar de berichten van elke dag',
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

## plugins/WidgetManager/default_widgets/signin.tmpl
	'You are signed in as ' => 'U bent aangemeld als', # Translate - New
	'You do not have permission to sign in to this blog.' => 'U heeft geen toestemming om aan te melden op deze weblog', # Translate - New

## plugins/WidgetManager/default_widgets/category_archive_list.tmpl

## plugins/WidgetManager/default_widgets/recent_comments.tmpl
	'Recent Comments' => 'Recente reacties',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
	'Select a Month...' => 'Selecteer een maand...',

## plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
	'Tag cloud' => 'Tagcloud',

## plugins/WidgetManager/default_widgets/powered_by.tmpl
	'_POWERED_BY' => 'Aangedreven door<br /><a href="http://www.movabletype.org/sitenl/"><$MTProductName$></a>',

## plugins/WidgetManager/default_widgets/creative_commons.tmpl
	'This weblog is licensed under a' => 'Deze weblog valt onder een licentie van het type',
	'Creative Commons License' => 'Creative Commons Licentie',

## plugins/WidgetManager/default_widgets/search.tmpl

## plugins/WidgetManager/default_widgets/recent_posts.tmpl

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => 'Zoekresultaten voor [_1]',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Zoeken naar reacties vanaf:',
	'the beginning' => 'het begin',
	'one week back' => 'een week geleden',
	'two weeks back' => 'twee weken geleden',
	'one month back' => 'een maand geleden',
	'two months back' => 'twee maanden geleden',
	'three months back' => 'drie maanden geleden',
	'four months back' => 'vier maanden geleden',
	'five months back' => 'vijf maanden geleden',
	'six months back' => 'zes maanden geleden',
	'one year back' => 'een jaar geleden',
	'Find new comments' => 'Nieuwe reacties zoeken',
	'Posted in [_1] on [_2]' => 'Gepubliceerd in [_1] op [_2]',
	'No results found' => 'Geen resultaten gevonden',
	'No new comments were found in the specified interval.' => 'Geen nieuwe reacties gevonden in het opgegeven interval.',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Selecteer het tijdsinterval waarin u wenst te zoeken en klik dan op \'Nieuwe reacties zoeken\'',

## search_templates/results_feed_rss2.tmpl

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'AUTODISCOVERY LINK VOOR ZOEKFEED WORDT ENKEL GEPUBLICEERD WANNEER EEN ZOEKOPDRACHT IS UITGEVOERD',
	'Blog Search Results' => 'Blog zoekresultaten',
	'Blog search' => 'Blog doorzoeken',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'GEWONE ZOEKOPDRACHTEN KRIJGEN HET ZOEKFORMULIER TE ZIEN',
	'SEARCH RESULTS DISPLAY' => 'ZOEKRESULTATEN TONEN',
	'Matching entries from [_1]' => 'Gevonden berichten op [_1]',
	'Entries from [_1] tagged with \'[_2]\'' => 'Berichten op [_1] getagd met \'[_2]\'',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Gepubliceerd <MTIfNonEmpty tag="EntryAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]',
	'Showing the first [_1] results.' => 'De eerste [_1] resultaten worden getoond.',
	'NO RESULTS FOUND MESSAGE' => 'GEEN RESULTATEN GEVONDEN BOODSCHAP',
	'Entries matching \'[_1]\'' => 'Berichten met \'[_1]\' in',
	'Entries tagged with \'[_1]\'' => 'Berichten getagd met \'[_1]\'',
	'No pages were found containing \'[_1]\'.' => 'Er werden geen berichten gevonden met \'[_1]\' in.',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een precieze uitdrukking te vinden, moet ze tussen aanhalingstekens geplaatst worden',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'De zoekmachine ondersteunt ook AND, OR en NOT sleutelwoorden om booleaanse expressies mee op te geven',
	'END OF ALPHA SEARCH RESULTS DIV' => 'EINDE VAN ALPHA ZOEKRESULTATEN DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGIN VAN BETA ZIJKOLOM OM ZOEKINFORMATIE IN TE TONEN',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'STEL VARIABELEN IN VOOR ZOEK vs TAG informatie',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met de tag \'[_1]\'.',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met \'[_1]\' in.',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ZOEK/TAG FEED INSCHRIJVINGSINFORMATIE',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	'What is this?' => 'Wat is dit?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG OPSOMMING ENKEL VOOR TAG ZOEKEN',
	'Other Tags' => 'Andere tags',
	'END OF PAGE BODY' => 'EINDE VAN PAGINA BODY',
	'END OF CONTAINER' => 'EINDE VAN CONTAINER',

## tmpl/comment/signup.tmpl
	'Create an account' => 'Maak een account aan', # Translate - New
	'Your login name.' => 'Uw gebruikersnaam.',
	'Display Name' => 'Getoonde naam',
	'The name appears on your comment.' => 'Deze naam verschijnt onder uw reactie', # Translate - New
	'Your email address.' => 'Uw e-mail adres.',
	'Initial Password' => 'Initiëel wachtwoord',
	'Select a password for yourself.' => 'Kies een wachtwoord voor uzelf.',
	'Password Confirm' => 'Wachtwoord bevestigen', # Translate - New
	'Repeat the password for confirmation.' => 'Herhaal het wachtwoord ter bevestiging.',
	'Password recovery word/phrase' => 'Woord/uitdrukking om wachtwoord terug te vinden',
	'This word or phrase will be required to recover the password if you forget it.' => 'Dit woord of deze uitdrukking zal gevraagd worden om uw wachtwoord terug te vinden als u het bent verloren.',
	'Website URL' => 'URL website',
	'The URL of your website. (Optional)' => 'De URL van uw website. (Optioneel)',
	'Enter your login name.' => 'Vul uw gebruikersnaam in', # Translate - New
	'Password' => 'Wachtwoord',
	'Enter your password.' => 'Vul uw wachtwoord in', # Translate - New
	'Register' => 'Registreer',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Aanmelden om te reageren', # Translate - New
	'Forgot your password?' => 'Uw wachtwoord vergeten?',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Uw profiel', # Translate - New
	'New Password' => 'Nieuw wachtwoord', # Translate - New
	'Confirm Password' => 'Wachtwoord bevestigen', # Translate - New
	'Password recovery' => 'Wachtwoord terugvinden', # Translate - Case

## tmpl/comment/error.tmpl
	'An error occurred' => 'Er deed zich een probleem voor',

## tmpl/comment/include/footer.tmpl
	'Sign in using' => 'Aanmelden met', # Translate - New
	'<a href="[_1]">Movable Type</a>' => '<a href="[_1]">Movable Type</a>', # Translate - New

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Bedankt om te registreren', # Translate - New
	'Confirmation email has been sent to' => 'Bevestigingsmail is verstuurd naar', # Translate - New
	'Please check your email and click on the link in the confirmation email to activate your account.' => 'Gelieve uw e-mail te controleren en op de link in de bevestigingsmail te klikken om uw account te activeren.', # Translate - New
	'Return to the original entry' => 'Terugkeren naar het oorspronkelijke bericht',
	'Return to the original page' => 'Terugkeren naar de oorspronkelijke pagina', # Translate - New

## tmpl/comment/register.tmpl

## tmpl/cms/restore_end.tmpl
	'All data restored successfully!' => 'Alle gegevens met succes teruggezet!', # Translate - New
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Verwijder de bestanden die u heeft teruggezet uit de map \'import\', om te vermijden dat ze opnieuw worden teruggezet wanneer u ooit het restore-proces opnieuw uitvoert.', # Translate - New
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Er deed zich een fout voor tijdens het restore-proces: [_1].  Kijk het activiteitenlog na voor meer details.', # Translate - New

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'Start-HTML titel (optioneel)', # Translate - New
	'End title HTML (optional)' => 'Eind-HTML titel (optioneel-', # Translate - New
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Als de software waaruit u importeert geen titelveld heeft, kunt u deze instelling gebruiken om aan te geven hoe een titel te herkennen in de tekst van een bericht.',
	'Default entry status (optional)' => 'Standaardstatus berichten (optioneel)', # Translate - New
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Als de software waaruit u importeert geen status opgeeft voor de berichten in het importbestand, kunt u hiermee een standaardstatus instellen om te gebruiken bij het importeren.', # Translate - New
	'Select an entry status' => 'Selecteer een berichtstatus', # Translate - New
	'Unpublished' => 'Ongepubliceerd',
	'Published' => 'Gepubliceerd',

## tmpl/cms/list_role.tmpl
	'Roles for [_1] in' => 'Rollen voor [1_] in', # Translate - New
	'Roles: System-wide' => 'Rollen: over heel het systeem', # Translate - New
	'_USAGE_ROLES' => 'Hieronder vindt u een lijst van alle rollen die u heeft op uw weblogs.',
	'You have successfully deleted the role(s).' => 'De rol(len) zijn met succes verwijderd.',
	'Delete selected roles (x)' => 'Geselecteerde rollen verwijderen (x)',
	'role' => 'rol',
	'roles' => 'rollen',
	'Grant another role to [_1]' => 'Een andere rol toekennen aan [_1]',
	'_USER_STATUS_CAPTION' => 'status',
	'Role' => 'Rol',
	'In Weblog' => 'Op weblog',
	'Via Group' => 'Via groep',
	'Created By' => 'Aangemaakt door',
	'Role Is Active' => 'Rol is actief',
	'Role Not Being Used' => 'Rol wordt niet gebruikt',
	'Permissions' => 'Permissies',
	'No roles could be found.' => 'Er werden geen rollen gevonden.',

## tmpl/cms/cfg_spam.tmpl
	'Spam Settings' => 'Spaminstellingen', # Translate - New
	'Your spam preferences have been saved.' => 'Uw spamvoorkeuren zijn opgeslagen', # Translate - New
	'Auto-Delete Spam' => 'Spam auto-wissen', # Translate - New
	'If enabled, feedback reported as spam will be automatically erased after a number of days.' => 'Indien ingeschakeld zal alle feedback die als spam is gemarkeerd automatisch verwijderd worden na een aantal dagen.', # Translate - New
	'Spam Score Threshold' => 'Spamscoredrempel', # Translate - New
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Reacties en TrackBacks ontvangen een spamscoren tussen -10 (helemaal zeker spam) en +10 (helemaal zeker geen spam).  Feedback met een score die lager is dan de drempel hierboven zal als spam gemarkeerd worden.', # Translate - New
	'Less Aggressive' => 'Minder aggressief',
	'Decrease' => 'Verlaag',
	'Increase' => 'Verhoog',
	'More Aggressive' => 'Aggressiever',
	'Delete Spam After' => 'Spam verwijderen na', # Translate - New
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Als een item langer dan dit aantal dagen als spam is gemarkeerd, wordt het automatisch gewist.', # Translate - New
	'days' => 'dagen',

## tmpl/cms/menu.tmpl
	'Overview of' => 'Overzicht van', # Translate - New
	'Recent updates to [_1].' => 'Recente wijzigingen aan [_1]', # Translate - New
	'Creating' => 'Bezig aan te maken',
	'Create New Entry' => 'Nieuw bericht opstellen',
	'List Entries' => 'Berichten weergeven',
	'List uploaded files' => 'Opgeladen bestanden weergeven',
	'Community' => 'Gemeenschap',
	'List Comments' => 'Reacties weergeven',
	'List Commenters' => 'Reageerders tonen',
	'List TrackBacks' => 'TrackBacks tonen',
	'Edit Notification List' => 'Notificatielijst bewerken',
	'Configure' => 'Configureren',
	'List Users &amp; Groups' => 'Groepen en gebruikers tonen',
	'Users &amp; Groups' => 'Gebruikers &amp; Groepen',
	'List &amp; Edit Templates' => 'Sjablonen weergeven en bewerken',
	'Edit Categories' => 'Categorieën bewerken',
	'Edit Tags' => 'Tags bewerken',
	'Edit Weblog Configuration' => 'Weblogconfiguratie bewerken',
	'Utilities' => 'Hulpmiddelen',
	'Search &amp; Replace' => 'Zoeken en vervangen',
	'_SEARCH_SIDEBAR' => 'Zoeken',
	'Backup this blog' => 'Maak een backup van deze blog', # Translate - New
	'Import &amp; Export Entries' => 'Berichten importeren en exporteren',
	'Import / Export' => 'Import/export',
	'_external_link_target' => '_extern_link_doel',
	'View Site' => 'Site bekijken',
	'Welcome to [_1].' => 'Welkom bij [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'U kunt uw blog beheren door een optie te selecteren uit het menu aan de linkerkant.', # Translate - New
	'If you need assistance, try:' => 'Als u hulp nodig hebt, probeer:',
	'Movable Type User Manual' => 'Gebruikershandleiding van Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support',
	'Movable Type Technical Support' => 'Movable Type technische ondersteuning',
	'Movable Type Community Forums' => 'Movable Type community forums',
	'Change this message.' => 'Dit bericht wijzigen.',
	'Edit this message.' => 'Dit bericht wijzigen.',
	'Recent Entries' => 'Recente berichten',
	'Scheduled' => 'Gepland',
	'Pending' => 'In afwachting',
	'Anonymous' => 'Anoniem',
	'Recent TrackBacks' => 'Recente TrackBacks',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => 'Voorbeeld [_1]', # Translate - New
	'Re-Edit this [_1]' => 'Bewerkt dit opnieuw [_1]', # Translate - New
	'Re-Edit this [_1] (e)' => 'Bewerk dit opnieuw [_1] (e)', # Translate - New
	'Save this [_1]' => 'Bewaar dit [_1]', # Translate - New
	'Save this [_1] (s)' => 'Bewaar dit [_1] (s)', # Translate - New
	'Cancel (c)' => 'Annuleer (c)', # Translate - New

## tmpl/cms/edit_entry.tmpl
	'Filename' => 'Bestandsnaam',
	'Basename' => 'Basisnaam',
	'Create [_1]' => 'Nieuwe [_1]', # Translate - New
	'Edit [_1]' => 'Bewerk [_1]', # Translate - New
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Een bewaarde versie van [_1] werd automatisch opgeslagen [_3]. <a href="[_2]">automatisch opgeslagen inhoud terughalen</a>', # Translate - New
	'Your [_1] has been saved. You can now make any changes to the [_1] itself, edit the authored-on date, or edit comments.' => 'UW [_1] is opgeslagen. U kunt nu wijzigingen aanbrengen aan de tekst, de datum of de reacties.', # Translate - New
	'Your changes have been saved.' => 'Uw wijzigingen zijn opgeslagen.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Eén of meer problemen deden zich voor bij het versturen van update pings of TrackBacks.',
	'_USAGE_VIEW_LOG' => 'Controleer voor deze fout het <a href="#" onclick="doViewLog()">Activiteitlog</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Uw voorkeuren zijn opgeslagen en het formulier hieronder is aangepast.',
	'Your changes to the comment have been saved.' => 'Uw wijzigingen aan de reactie zijn opgeslagen.',
	'Your notification has been sent.' => 'Uw notificatie is verzonden.',
	'You have successfully recovered your saved [_1].' => 'U heeft met succes uw opgeslagen [_1] teruggehaald', # Translate - New
	'An error occurred while trying to recover your saved [_1].' => 'Er deed zich een fout voor bij het terughalen van uw opgeslagen [_1]', # Translate - New
	'You have successfully deleted the checked comment(s).' => 'Verwijdering van de geselecteerde reactie(s) is geslaagd.',
	'You have successfully deleted the checked TrackBack(s).' => 'U heeft de geselecteerde TrackBack(s) met succes verwijderd.',
	'Summary' => 'Samenvatting', # Translate - New
	'Created [_1] by [_2].' => '[_1] aangemaakt dooor [_2]', # Translate - New
	'Last edited [_1] by [_2].' => 'Laatst bewerkte [_1] door [_2]', # Translate - New
	'Published [_1].' => '[_1] gepubliceerd', # Translate - New
	'This [_1] has received <a href="[_4]">[quant,_2,comment]</a> and [quant,_3,trackback].' => ' Er werden <a href="[_4]">[quant,_2,reactie]</a> en [quant,_3,trackback] ontvangen op [_1].', # Translate - New
	'Display Options' => 'Opties voor schermindeling',
	'Fields' => 'Velden', # Translate - New
	'Body' => 'Romp',
	'Excerpt' => 'Uittreksel',
	'Keywords' => 'Trefwoorden',
	'Publishing' => 'Publicatie',
	'Feedback' => 'Feedback',
	'Actions' => 'Acties',
	'Top' => 'Bovenaan', # Translate - New
	'Both' => 'Allebei',
	'Bottom' => 'Onderaan', # Translate - New
	'OK' => 'OK', # Translate - New
	'Reset' => 'Leegmaken',
	'Your entry screen preferences have been saved.' => 'Uw voorkeuren voor het berichtenscherm zijn opgeslagen.',
	'Are you sure you want to use the Rich Text editor?' => 'Bent u zeker dat u de Rich Text Editor wenst te gebruiken?', # Translate - New
	'You have unsaved changes to your [_1] that will be lost.' => 'Er zijn niet opgeslagen wijzigingen aan uw [_1] die verloren zullen gaan', # Translate - New
	'Publish On' => 'Publiceren op',
	'Publish Date' => 'Publicatiedatum',
	'You must specify at least one recipient.' => 'U moet minstens één ontvanger opgeven.',
	'Remove' => 'Verwijder',
	'Make primary' => 'Maak dit een hoofdcategorie', # Translate - New
	'Add sub category' => 'Subcategorie toevoegen', # Translate - New
	'Add [_1] name' => 'Voeg [_1]naam toe', # Translate - New
	'Add new parent [_1]' => 'Voeg nieuwe ouder[_1] toe', # Translate - New
	'Add new' => 'Nieuw toevogen', # Translate - New
	'Preview this [_1] (v)' => 'Voorbeeld van [1] (v)', # Translate - New
	'Delete this [_1] (v)' => 'Verwijder [_1] (v)', # Translate - New
	'Delete this [_1] (x)' => 'Verwijder [_1] (x)', # Translate - New
	'Share this [_1]' => 'Deel [_1] ', # Translate - New
	'View published [_1]' => 'Bekijk gepubliceerde [_1]', # Translate - New
	'&laquo; Previous' => '&laquo; Vorige', # Translate - New
	'Manage [_1]' => 'Beheer [_1]', # Translate - New
	'Next &raquo;' => 'Volgende &raquo;', # Translate - New
	'Extended' => 'Uitgebreid', # Translate - New
	'Format' => 'Formaat', # Translate - New
	'Decrease Text Size' => 'Kleiner tekstformaat', # Translate - New
	'Increase Text Size' => 'Groter tekstformaat', # Translate - New
	'Bold' => 'Vet',
	'Italic' => 'Cursief',
	'Underline' => 'Onderstrepen',
	'Strikethrough' => 'Doorstrepen', # Translate - New
	'Text Color' => 'Tekstkleur', # Translate - New
	'Link' => 'Link',
	'Email Link' => 'E-mail link', # Translate - New
	'Begin Blockquote' => 'Begin citaat', # Translate - New
	'End Blockquote' => 'Einde citaat', # Translate - New
	'Bulleted List' => 'Ongeordende lijst', # Translate - New
	'Numbered List' => 'Genummerde lijst', # Translate - New
	'Left Align Item' => 'Item links uitlijnen', # Translate - New
	'Center Item' => 'Centreer item', # Translate - New
	'Right Align Item' => 'Item rechts uitlijnen', # Translate - New
	'Left Align Text' => 'Tekst links uitlijnen', # Translate - New
	'Center Text' => 'Tekst centreren', # Translate - New
	'Right Align Text' => 'Tekst rechts uitlijnen', # Translate - New
	'Insert Image' => 'Afbeelding invoegen', # Translate - New
	'Insert File' => 'Bestand invoegen', # Translate - New
	'WYSIWYG Mode' => 'WYSIWYG modus', # Translate - New
	'HTML Mode' => 'HTML modus', # Translate - New
	'Metadata' => 'Metadata', # Translate - New
	'(comma-delimited list)' => '(lijst gescheiden met komma\'s)',
	'(space-delimited list)' => '(lijst gescheiden met spaties)',
	'(delimited by \'[_1]\')' => '(gescheiden door \'[_1]\')',
	'Change [_1]' => 'Wijzig [_1]', # Translate - New
	'Add [_1]' => '[_1] toevoegen', # Translate - New
	'Status' => 'Status',
	'You must configure blog before you can publish this [_1].' => 'U moet uw blog configureren voor u deze [_1] kunt publiceren.', # Translate - New
	'Select entry date' => 'Selecteer berichtdatum', # Translate - New
	'Unlock this entry&rsquo;s output filename for editing' => 'Maak het mogelijk om de uitvoerbestandsnaam te wijzigen', # Translate - New
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Waarschuwing: de basisnaam van het bericht met de hand aanpassen kan een conflict met een ander bericht veroorzaken.',
	'Warning: Changing this entry\'s basename may break inbound links.' => 'Waarschuwing: de basisnaam van het bericht aanpassen kan inkomende links breken.',
	'Accept' => 'Aanvaarden',
	'Comments Accepted' => 'Reacties aanvaard', # Translate - New
	'TrackBacks Accepted' => 'TrackBacks aanvaard', # Translate - New
	'Outbound TrackBack URLs' => 'Uitgaande TrackBack URLs',
	'View Previously Sent TrackBacks' => 'Eerder verzonden TrackBacks bekijken',
	'Auto-saving...' => 'Auto-opslaan...', # Translate - New
	'Last auto-save at [_1]:[_2]:[_3]' => 'Laatste auto-opslag om [_1]:[_2]:[_3]', # Translate - New

## tmpl/cms/system_check.tmpl
	'This screen provides you with information on your system\'s configuration, and shows you which components you are running with Movable Type.' => 'Dit scherm geeft u nformatie over de configuratie van uw systeem en toont u welke componenten u draait met Movable Type.', # Translate - New

## tmpl/cms/import.tmpl
	'Import' => 'Import', # Translate - New
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Importeer weblogberichten in Moveble Type uit andere Movable Type installaties of zelfs andere blogsystemen, of exporteer uw berichten om een backup of kopie te maken.',
	'Importing from' => 'Aan het importeren uit', # Translate - New
	'Ownership of imported entries' => 'Eigenaarschap van geïmporteerde berichten', # Translate - New
	'Import as me' => 'Importeer als mezelf',
	'Preserve original user' => 'Oorspronkelijke gebruiker bewaren',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Als u ervoor kiest om het eigenaarschap van de geïmporteerde berichten te bewaren en als één of meer van die gebruikers nog moeten aangemaakt worden in deze installatie, moet u een standaard wachtwoord opgeven voor die nieuwe accounts.',
	'Default password for new users:' => 'Standaard wachtwoord voor nieuwe gebruikers:',
	'Upload import file (optional)' => 'Importbestand opladen (optioneel)', # Translate - New
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Als uw importbestand zich nog op uw eigen computer bevindt, kunt u het hier opladen.  In het andere geval zal Movable Type automatisch kijken in de \'import\' map van uw Movable Type map.', # Translate - New
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'U zal eigenaar worden van alle geïmporteerde berichten.  Als u wenst dat de oorspronkelijke gebruiker eigenaar blijft, moet u uw MT systeembeheerder contacteren om de import te doen zodat nieuwe gebruikers aangemaakt kunnen worden indien nodig.',
	'More options' => 'Meer opties', # Translate - New
	'Text Formatting' => 'Tekstopmaak',
	'Import File Encoding' => 'Encodering importbestand', # Translate - New
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Standaard zal Movable Type proberen om automatisch de karakter encodering van het importbestand te bepalen.  Mocht u echter problemen ondervinden, kunt u het ook uitdrukkelijk instellen.',
	'<mt:var name="display_name">' => '<mt:var name="display_name">', # Translate - New
	'Default category for entries (optional)' => 'Standaardcategorie voor berichten (optioneel)', # Translate - New
	'You can specify a default category for imported entries which have none assigned.' => 'U kunt een standaardcategorie instellen voor geïmporteerde berichten waar er nog geen aan is toegewezen.',
	'Select a category' => 'Categorie selecteren',
	'Import Entries' => 'Berichten importeren',
	'Import Entries (i)' => 'Berichten importeren (i)',

## tmpl/cms/cfg_system_feedback.tmpl
	'Feedback Settings: System-wide' => 'Feedbackinstellingen: over het hele systeem', # Translate - New
	'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'Via dit scherm kunt u de instellingen voor feedback en uitgaande TrackBacks beheren voor heel de installatie.  Deze instellingen gelden boven gelijkaardige instellingen voor individuele weblogs.',
	'Your feedback preferences have been saved.' => 'Uw voorkeuren voor feedback zijn opgeslagen.',
	'None selected.' => 'Geen geselecteerd.',
	'Feedback Master Switch' => 'Feedback hoofdschakelaar',
	'Disable Comments' => 'Reacties uitschakelen',
	'This will override all individual weblog comment settings.' => 'Dit geldt boven alle instellingen voor reacties van alle individuele weblogs.',
	'Stop accepting comments on all weblogs' => 'Stop reacties te aanvaarden op alle weblogs',
	'Allow Registration' => 'Registratie toestaan', # Translate - New
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Selecteer een systeembeheerder die op de hoogte gebracht moet worden wanneer nieuwe reageerders zich met succes registreren.', # Translate - New
	'Allow commenters to register to Movable Type' => 'Geef reageerders de optie zich te registreren via Movable Type', # Translate - New
	'Notify administrators' => 'Administrators op de hoogte brengen', # Translate - New
	'Select...' => 'Selecteer...',
	'Clear' => 'Leegmaken',
	'System Email Address Not Set' => 'Systeem e-mail adres niet ingesteld', # Translate - New
	'Note: System Email Address is not set.  Emails will not be sent.' => 'Opmerking: systeem e-mail adres is niet ingesteld.  E-mails zullen niet worden verzonden.', # Translate - New
	'Use Comment Confirmation' => 'Reactiebevestiging gebruiken', # Translate - New
	'Use comment confirmation page' => 'Reactiebevestigingspagina gebruiken', # Translate - New
	'CAPTCHA Provider' => 'CAPTCHA leverencier', # Translate - New
	'Disable TrackBacks' => 'TrackBacks uitschakelen',
	'This will override all individual weblog TrackBack settings.' => 'Dit geldt boven alle instellingen voor TrackBacks van alle individuele weblogs.',
	'Stop accepting TrackBacks on all weblogs' => 'Stop TrackBacks te aanvaarden op alle weblogs',
	'Outbound TrackBack Control' => 'Uitgaand TrackBack beheer',
	'Allow outbound Trackbacks to' => 'Uitgaande TrackBacks toestaan naar', # Translate - New
	'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Deze optie maakt het mogelijk om uitgaande TrackBacks en TrackBack auto-discovery te beperken met als doel om uw installatie privé te houden.',
	'Any site' => 'Elke site',
	'No site' => 'Geen enkele site',
	'(Disable all outbound TrackBacks.)' => '(Alle uitgaande TrackBacks uitschakelen.)',
	'Only the weblogs on this installation' => 'Enkel de weblogs op deze installatie',
	'Only the sites on the following domains:' => 'Enkel de sites binnen volgende domeinen:',

## tmpl/cms/edit_template.tmpl
	'Edit Template' => 'Sjabloon bewerken',
	'Create Template' => 'Sjabloon aanmaken', # Translate - New
	'Your template changes have been saved.' => 'De wijzigingen aan uw sjabloon zijn opgeslagen.',
	'Your [_1] has been rebuilt.' => 'Uw [_1] is opnieuw gebouwd.',
	'Useful Links' => 'Nuttige links', # Translate - New
	'View Published Template' => 'Gepubliceerd sjabloon bekijken',
	'List [_1] templates' => 'Toon [_1] sjablonen', # Translate - New
	'Template tag reference' => 'Sjabloontags referentie', # Translate - New
	'Includes and Widgets' => 'Includes en widgets', # Translate - New
	'Unknown' => 'Onbekend', # Translate - New
	'Save (s)' => 'Opslaan (s)', # Translate - New
	'Save this template (s)' => 'Dit sjabloon opslaan (s)',
	'Save and Rebuild this template (r)' => 'Dit sjabloon opslaan en opnieuw opbouwen (r)', # Translate - Case
	'Save and Rebuild' => 'Opslaan en opnieuw opbouwen',
	'Save and rebuild this template (r)' => 'Dit sjabloon opslaan en opnieuw opbouwen (r)',
	'You must set the Template Name.' => 'U moet de naam van het sjabloon instellen', # Translate - New
	'You must set the template Output File.' => 'U moet het uitvoerbestand van het sjabloon instellen.', # Translate - New
	'Please wait...' => 'Even wachten...', # Translate - New
	'Error occurred while updating archive maps.' => 'Er deed zich teen fout voor bij het bijwerken van de archiefkoppelingen.', # Translate - New
	'Archive map has been successfully updated.' => 'Archiefkoppelingen zijn met succes bijgewerkt.', # Translate - New
	'Template Name' => 'Sjabloonnaam',
	'Module Body' => 'Moduletekst',
	'Template Body' => 'Sjabloontekst',
	'Insert...' => 'Invoegen...',
	'Custom Index Template' => 'Gepersonaliseerd indexsjabloon', # Translate - New
	'Output File' => 'Uitvoerbestand',
	'Build Options' => 'Bouwopties',
	'Enable dynamic building for this template' => 'Dynamisch opbouwen inschakelen voor dit sjabloon',
	'Rebuild this template automatically when rebuilding index templates' => 'Dit sjabloon automatisch opnieuw opbouwen bij opnieuw opbouwen van indexsjablonen',
	'Link to File' => 'Koppelen aan bestand', # Translate - New
	'Archive Mapping' => 'Archiefkoppeling',
	'Create New Archive Mapping' => 'Nieuwe archiefkoppeling aanmaken',
	'Archive Type:' => 'Archieftype:',
	'Add' => 'Toevoegen',

## tmpl/cms/edit_comment.tmpl
	'Save this comment (s)' => 'Deze reactie(s) opslaan',
	'comment' => 'reactie',
	'comments' => 'reacties',
	'Delete this comment (x)' => 'Verwijder deze reactie (x)',
	'Ban This IP' => 'Dit IP-adres verbannen',
	'Useful links' => 'Nuttige links', # Translate - New
	'Previous Comment' => 'Vorige reactie', # Translate - New
	'Edit Comments' => 'Reacties bewerken', # Translate - New
	'Next Comment' => 'Volgende reactie', # Translate - New
	'View the entry this comment was left on' => 'Bekijk het bericht waar dit een reactie op was', # Translate - New
	'Pending Approval' => 'In afwachting van goedkeuring',
	'Comment Reported as Spam' => 'Reactie gerapporteerd als spam', # Translate - New
	'Update the status of this comment' => 'Status van dit bericht bijwerken', # Translate - New
	'Approved' => 'Goedgekeurd',
	'Unapproved' => 'Niet gekeurd', # Translate - New
	'Reported as Spam' => 'Gerapporteerd als spam', # Translate - New
	'View all comments with this status' => 'Alle reacties met deze status bekijken',
	'The name of the person who posted the comment' => 'De naam van de persoon die deze reactie', # Translate - New
	'Trusted' => 'Vertrouwd',
	'(Trusted)' => '(Vertrouwd)',
	'Ban&nbsp;Commenter' => 'Reageerder&nbsp;uitsluiten',
	'Untrust&nbsp;Commenter' => 'Reageerder&nbsp;niet&bsp;vertrouwen',
	'Banned' => 'Uitgesloten',
	'(Banned)' => '(uitgesloten)',
	'Trust&nbsp;Commenter' => 'Reageerder&nbsp;vertrouwen',
	'Unban&nbsp;Commenter' => 'Verbanning&nbsp;reageerder&nbsp;ongedaan&nbsp;maken',
	'View all comments by this commenter' => 'Alle reacties van deze reageerder bekijken',
	'Email' => 'E-mail',
	'Email address of commenter' => 'E-mail adres reageerder', # Translate - New
	'None given' => 'Niet opgegeven',
	'View all comments with this email address' => 'Alle reacties met dit e-mail adres bekijken',
	'URL of commenter' => 'URL van de reageerder', # Translate - New
	'View all comments with this URL' => 'Alle reacties met deze URL bekijken',
	'Entry this comment was made on' => 'Bericht waar dit een reactie op was', # Translate - New
	'Entry no longer exists' => 'Bericht bestaat niet meer',
	'View all comments on this entry' => 'Bekijk alle reacties op dit bericht',
	'Date' => 'Datum',
	'Date this comment was made' => 'Datum van deze reactie', # Translate - New
	'View all comments created on this day' => 'Alle reacties van die dag bekijken', # Translate - New
	'IP' => 'IP',
	'IP Address of the commenter' => 'IP adres van de reageerder', # Translate - New
	'View all comments from this IP address' => 'Alle reacties van dit IP-adres bekijken',
	'Comment Text' => 'Tekst reactie',
	'Fulltext of the comment entry' => 'Volledige tekst van de reactie', # Translate - New
	'Responses to this comment' => 'Antwoorden op dit bericht', # Translate - New
	'Final Feedback Rating' => 'Uiteindelijke feedback-beoordeling',
	'Test' => 'Test',
	'Score' => 'Score',
	'Results' => 'Resultaten',

## tmpl/cms/edit_role.tmpl
	'Role Details' => 'Rol details',
	'You have changed the permissions for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'U heeft de permissies van deze rol gewijzigd.  Dit verandert wat gebuikers kunnen doen die met deze rol geassocieerd zijn.  Als u dat wenst, kunt u deze rol ook opslaan met een andere naam. In het andere geval moet u zich bewust zijn van de wijzigingen voor de gebruikers met deze rol.',
	'_USAGE_ROLE_PROFILE' => 'Op dit scherm kunt u een rol en zijn permissies bepalen.',
	'There are [_1] User(s) with this role.' => 'Er zijn [_1] gebruikers met deze rol', # Translate - New
	'Created by' => 'Aangemaakt door',
	'Check All' => 'Alles aanvinken',
	'Uncheck All' => 'Alles uitvinken',
	'Administration' => 'Administratie', # Translate - New
	'Authoring and Publishing' => 'Schrijven en publiceren', # Translate - New
	'Designing' => 'Ontwerpen', # Translate - New
	'File Upload' => 'Bestanden opladen', # Translate - New
	'Commenting' => 'Reageren', # Translate - New
	'Roles with the same permissions' => 'Rollen met dezelfde permissies',
	'Save this role' => 'Deze rol opslaan',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Er deed zich een fout voor tijdens het terugzetten: [_1] Gelieve uw restore-bestand na te kijken.', # Translate - New
	'All of the data have been restored successfully!' => 'Alle gegevens zijn met succes teruggezet', # Translate - New
	'Next Page' => 'Volgende pagina', # Translate - New
	'The page will redirect to a new page in 3 seconds.  Click <a href=\'javascript:void(0)\' onclick=\'return stopTimer()\'>here</a> to stop the timer.' => 'Deze pagina zal automatisch naar een nieuwe pagina doorverwijzen binnen 3 seconden.  Klik <a href=\'javascript:void(0)\' onclick=\'return stopTimer()\'>hier</a> om de teller stop te zetten.', # Translate - New

## tmpl/cms/dialog/grant_role.tmpl
	'You need to create some roles.' => 'U moet een aantal rollen aanmaken.',
	'Before you can do this, you need to create some roles. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a role.' => 'Voor u dit kunt doen, moet u eerst een paar rollen aanmaken.  <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Klik hier</a> om een rol aan te maken.', # Translate - New
	'You need to create some groups.' => 'U moet een aantal groepen aanmaken.',
	'Before you can do this, you need to create some groups. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a group.' => 'Voor u dit kunt doen, moet u eerst een paar groepen aanmaken.  <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Klik hier</a> om een groep aan te maken.', # Translate - New
	'You need to create some users.' => 'U moet een aantal gebruikers aanmaken.',
	'Before you can do this, you need to create some users. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a user.' => 'Voor u dit kunt doen, moet u eerst een paar gebruikers aanmaken.  <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Klik hier</a> om een gebruiker aan te maken.', # Translate - New
	'You need to create some weblogs.' => 'U moet een aantal weblogs aanmaken.',
	'Before you can do this, you need to create some weblogs. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to create a weblog.' => 'Voor u dit kunt doen, moet u eerst een paar weblogs aanmaken.  <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Klik hier</a> om een weblog aan te maken.', # Translate - New

## tmpl/cms/dialog/asset_image_options.tmpl
	'Display Image in Entry' => 'Afbeelding tonen in bericht', # Translate - New
	'Alignment' => 'Uitlijning', # Translate - New
	'Align Image Left' => 'Afbeelding links uitlijnen', # Translate - New
	'Left' => 'Links', # Translate - New
	'Align Image Center' => 'Afbeelding centreren', # Translate - New
	'Center' => 'Centreren', # Translate - New
	'Align Image Right' => 'Afbeelding rechts uitlijnen', # Translate - New
	'Right' => 'Rechts', # Translate - New
	'Create Thumbnail' => 'Thumbnail aanmaken', # Translate - New
	'Width' => 'Breedte', # Translate - New
	'Pixels' => 'Pixels',
	'Link image to full-size version in a popup window.' => 'Afbeelding koppelen aan afbeelding op ware grootte in een popup venster.', # Translate - New
	'Remember these settings' => 'Deze instellingen onthouden', # Translate - New

## tmpl/cms/dialog/upload_complete.tmpl
	'Upload Image' => '', # Translate - New
	'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'Het bestand met de naam \'[_1]\' is opgeladen. Grootte: [quant,_2,byte].',
	'File Options' => 'Bestandsopties', # Translate - New
	'Create a new entry using this uploaded file.' => 'Maak een nieuw bericht aan met dit opgeladen bestand', # Translate - New
	'Finish' => 'Klaar', # Translate - New

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'De procedure nu stopzetten zal wees-objecten achterlaten.  Bent u zeker dat u de restore-operatie wenst te annuleren.', # Translate - New
	'Restore Multiple Files' => 'Meerdere bestanden terugzetten', # Translate - New
	'Restoring' => 'Bezig restore uit te voeren', # Translate - New
	'Please upload the following file' => 'Gelieve volgend bestand op te laden', # Translate - New
	'Upload' => 'Opladen',

## tmpl/cms/dialog/post_comment_end.tmpl
	'Note: Your reply to this comment will be automatically published.' => 'Opmerking: uw antwoord op deze reactei zal onmiddellijk worden gepubliceerd', # Translate - New

## tmpl/cms/dialog/post_comment.tmpl
	'Reply to comment' => 'Reactie beantwoorden', # Translate - New
	'<strong>[_2]</strong> wrote:' => '<strong>[_2]</strong> schreef:', # Translate - New
	'Posted to &ldquo;[_1]&rdquo; on [_2]' => 'Gepubliceerd op &ldquo;[_1]&rdquo; op [_2]', # Translate - New
	'Your reply:' => 'Uw antwoord:', # Translate - New
	'Note: Your reply will be automatically published.' => 'Opmerking: Uw antwoord zal automatisch worden gepubliceerd', # Translate - New

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Restoring [_1]...' => 'Bezig met terugzetten van [_1]...', # Translate - New
	'URL is not valid.' => 'URL is niet geldig.', # Translate - New
	'You can not have spaces in the URL.' => 'Er mogen geen spaties in de URL staan.', # Translate - New
	'You can not have spaces in the path.' => 'Er mogen geen spaties in het pad staan.', # Translate - New
	'Path is not valid.' => 'Pad is ongeldig', # Translate - New
	'New Site Path' => 'Nieuw sitepad', # Translate - New
	'New Site URL' => 'Nieuwe site URL', # Translate - New
	'New Archive Path' => 'Nieuw archiefpad', # Translate - New
	'New Archive URL' => 'Nieuwe archief URL', # Translate - New

## tmpl/cms/dialog/list_assets.tmpl
	'System-wide' => 'In het hele systeem',
	'Select the image you would like to insert, or upload a new one.' => 'Selecteer de afbeelding die u wenst in te voegen of laad een nieuwe op.', # Translate - New
	'Select the file you would like to insert, or upload a new one.' => 'Selecteer het bestand dat u wenst in te voegen of laad er een nieuw op.', # Translate - New
	'Upload New File' => 'Nieuw bestand opladen', # Translate - New
	'Upload New Image' => 'Nieuwe afbeelding opladen', # Translate - New
	'View All' => 'Allen bekijken',
	'Weblog' => 'Weblog',
	'Size' => 'Grootte', # Translate - New
	'View File' => 'Bestand bekijken', # Translate - New
	'Next' => 'Volgende',
	'Insert' => 'Invoegen', # Translate - New
	'No assets could be found.' => 'Kon geen mediabestand vinden', # Translate - New

## tmpl/cms/dialog/restore_start.tmpl

## tmpl/cms/dialog/upload_confirm.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Er bestaat reeds een bestand net de naam \'[_1]\'. Wilt u dit bestand overschrijven?',

## tmpl/cms/dialog/upload.tmpl
	'You need to configure your weblog.' => 'U moet uw weblog nog instellen', # Translate - New
	'Before you can upload a file, you need to publish your weblog. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Click here</a> to configure your weblog\'s publishing paths and rebuild your weblog.' => 'Voor u een bestand kunt opladen, moet u uw weblog publiceren. <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">Klik hier</a> om de publicatiepaden van uw weblog in te stellen en om uw weblog opnieuw op te bouwen', # Translate - New
	'Choose a file from your computer to upload' => 'Kies een bestand op uw computer om op te laden', # Translate - New
	'File to Upload' => 'Bestand om op te laden', # Translate - New
	'Click the button below and select a file on your computer to upload.' => 'Klik op de onderstaande knop en selecteer een bestand op uw computer om op te laden.', # Translate - New
	'Set Upload Path' => 'Pad instellen voor opladen',
	'_USAGE_UPLOAD' => 'U kunt het bestand hierboven opladen naar het lokale pad van uw site <a href="javascript:alert(\'[_1]\')">(?)</a> of het lokale archiefpad <a href="javascript:alert(\'[_2]\')">(?)</a>. U kunt ook het bestand opladen in elke directory onder deze directories, door het pad op te geven in de tekstvakken rechts (<i>afbeeldingen</i>, bijvoorbeeld). Als de directory niet bestaat, wordt deze aangemaakt.',
	'Path' => 'Pad', # Translate - New

## tmpl/cms/install.tmpl
	'Create Your First User' => 'Maak uw eerste gebruiker aan', # Translate - New
	'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
	'Password recovery word/phrase is required.' => 'Woord/uitdrukking om uw wachtwoord terug te vinden is vereist.',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'De versie van Perl die op uw server is geïnstalleerd ([_1]) is lager dan de ondersteunde minimale versie ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Hoewel Movable Type er misschien op draait, is het een <strong>ongetesten en niet ondersteunde omgeving</strong>.  We raden ten zeerste aan om minstens te upgraden tot Perl [_1].',
	'Do you want to proceed with the installation anyway?' => 'Wenst u toch door te gaan met de installatie?',
	'Before you can begin blogging, you must create an administrator account for your system. When you are done, Movable Type will then initialize your database.' => 'Voor u kunt beginnen blogggen, moet u een administrator-account aanmaken voor uw systeem.  Wanneer u klaar bent zal Movable Type uw database initialiseren.', # Translate - New
	'You will need to select a username and password for the administrator account.' => 'U moet een gebruikersnaam en wachtwoord kiezen voor de administrator-account.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Om verder te gaan moet u zich aanmelden bij uw LDAP server.',
	'The name used by this user to login.' => 'De naam gebruikt door deze gebruiker om zich aan te melden.',
	'The user\'s email address.' => 'Het e-mail adres van de gebruiker.',
	'Language' => 'Taal',
	'The user\'s preferred language.' => 'De voorkeurstaal van de gebruiker.',
	'Select a password for your account.' => 'Kies een wachtwoord voor uw account.',
	'This word or phrase will be required to recover your password if you forget it.' => 'Dit woord of deze uitdrukking zal gevraagd worden om uw wachtwoord terug te vinden als u het mocht vergeten.',
	'Your LDAP username.' => 'Uw LDAP gebruikersnaam.',
	'Enter your LDAP password.' => 'Geef uw LDAP wachtwoord op.',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'TrackBack', # Translate - Case
	'Pinging sites...' => 'Bezig met pingen van sites...',

## tmpl/cms/edit_author.tmpl
	'User Profile for [_1]' => 'Gebruikersprofiel voor [_1]', # Translate - New
	'Your Web services password is currently' => 'Uw huidit Web services wachtwoord is',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'U staat op het punt het wachtwoord voor "[_1]" opnieuw in te stellen.  Een nieuw wachtwoord zal willekeurig worden aangemaakt en zal rechtstreeks naar het e-mail adres van deze gebruiker ([_2]) worden gestuurd.\n\nWenst u verder te gaan?',
	'_USAGE_NEW_AUTHOR' => 'In dit scherm kunt u een nieuwe gebruiker aanmaken en hem toegang geven tot bepaalde weblogs in het systeem.',
	'_USAGE_PROFILE' => 'Bewerk hier uw gebruikersprofiel. Als u uw gebruikersnaam of wachtwoord wijzigt, worden uw aanmeldingsgegevens automatisch bijgewerkt. Met andere woorden, u hoeft zich niet opnieuw aan te melden.',
	'_GENL_USAGE_PROFILE' => 'Bewerk hier het profiel van de gebruiker.  Als u de gebruikersnaam of het wachtwoord van de gebruiker aanpast, dan zullen de credentials van de gebruiker automatisch bijgewerkt worden.  Met andere woorden, hij/zij zal zich niet opnieuw moeten aanmelden.',
	'User Pending' => 'Gebruiker hangende', # Translate - New
	'User Disabled' => 'Gebruiker uitgeschakeld',
	'This profile has been updated.' => 'Dit profiel is bijgewerkt geweest.',
	'A new password has been generated and sent to the email address [_1].' => 'Een nieuw wachtwoord werd gegenerereerd en is verzonden naar het e-mail adres [_1].',
	'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise probeerde net uw account uit te schakelen tijdens synchronisatie met de externe directory.  Er moet een fout zitten in de instellingen voor extern gebruikersbeheer.  Gelieve uw configuratie bij te stellen voor u verder gaat.',
	'Profile' => 'Profiel',
	'Personal Weblog' => 'Persoonlijke weblog',
	'Create personal weblog for user' => 'Persoonlijke weblog aanmaken voor gebruiker:',
	'System Permissions' => 'Systeempermissies',
	'Create Weblogs' => 'Weblogs aanmaken',
	'Status of user in the system. Disabling a user removes their access to the system but preserves their content and history.' => 'Status van de gebruiker in het systeem.  Een gebruiker uitschakelen ontzegt hem/haar toegang tot het systeem maar bewaart content en geschiedenis.',
	'_USER_ENABLED' => 'Ingeschakeld',
	'_USER_PENDING' => '_USER_PENDING',
	'_USER_DISABLED' => 'Uitgeschakeld',
	'The username used to login.' => 'Gebruikersnaam om mee aan te melden', # Translate - New
	'User\'s external user ID is <em>[_1]</em>.' => 'Het externe gebruikers-ID van de gebruiker is <em>[_1]</em>.', # Translate - New
	'The name used when published.' => 'De naam gebruikt bij het publiceren', # Translate - New
	'The email address associated with this user.' => 'Het e-mail adres gekoppeld aan deze gebruiker', # Translate - New
	'The URL of the site associated with this user. eg. http://www.movabletype.com/' => 'De URL van de site gekoppeld aan deze gebruiker, bv. http://www.movabletype.com/', # Translate - New
	'Preferred language of this user.' => 'Voorkeurstaal van deze gebruiker', # Translate - New
	'Text Format' => 'Tekstformaat', # Translate - New
	'Preferred text format option.' => 'Voorkeursoptie tekstformaat', # Translate - New
	'(Use Blog Default)' => '(Standaard bloginstelling gebruiken)', # Translate - New
	'Tag Delimiter' => 'Scheidingsteken tags', # Translate - New
	'Preferred method of separating tags.' => 'Voorkeursmethode om tags van elkaar te scheiden', # Translate - New
	'Comma' => 'Komma',
	'Space' => 'Spatie',
	'Web Services Password' => 'Webservices wachtwoord', # Translate - New
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Voor gebruik door activiteiten-feeds en met XML-RPC en Atom-gebaseerde cliënten.',
	'Reveal' => 'Onthul',
	'Current Password' => 'Huidig wachtwoord', # Translate - New
	'Existing password required to create a new password.' => 'Bestaand wachtwoord vereist om een nieuw wachtwoord aan te maken', # Translate - New
	'Enter preferred password.' => 'Gekozen wachtwoord invoeren', # Translate - New
	'Enter the new password.' => 'Vul het nieuwe wachtwoord in', # Translate - New
	'This word or phrase will be required to recover a forgotten password.' => 'Dit woord of deze uitdrukking zal gebruikt worden om een vergeten wachtwoord terug te halen.', # Translate - New
	'Save this user (s)' => 'Deze gebruiker(s) opslaan',
	'_USAGE_PASSWORD_RESET' => 'Hieronder kunt u een nieuw wachtwoord laten instellen voor deze gebruiker.  Als u ervoor kiest om dit te doen, zal een willekeurig gegenereerd wachtwoord worden aangemaakt en rechtstreeks naar volgend e-mail adres worden verstuurd: [_1].',
	'Initiate Password Recovery' => 'Procedure starten om wachtwoord terug te halen', # Translate - New

## tmpl/cms/list_ping.tmpl
	'Manage Trackbacks' => 'TrackBacks beheren', # Translate - Case
	'The selected TrackBack(s) has been approved.' => 'De geselecteerde TrackBack(s) zijn goedgekeurd', # Translate - New
	'All TrackBacks reported as spam have been removed.' => 'Alle TrackBacks gerapporteerd als spam zijn verwijderd', # Translate - New
	'The selected TrackBack(s) has been unapproved.' => 'De geselecteerde TrackBack(s) zijn niet langer goedgekeurd', # Translate - New
	'The selected TrackBack(s) has been reported as spam.' => 'De geselecteerde TrackBack(s) zijn gerapporteerd als spam', # Translate - New
	'The selected TrackBack(s) has been recovered from spam.' => 'De geselecteerde TrackBack(s) zijn teruggehaald uit de spam-map', # Translate - New
	'The selected TrackBack(s) has been deleted from the database.' => 'De geselecteerde TrackBack(s) zijn uit de database verwijderd.',
	'No TrackBacks appeared to be spam.' => 'Geen enkele TrackBack leek spam te zijn.', # Translate - New
	'Quickfilters' => 'Snelfilters', # Translate - New
	'Show unapproved [_1]' => 'Toon niet gekeurde [_1]', # Translate - New
	'[_1] Reported as Spam' => '[_1] gerapporteerd als spam', # Translate - New
	'[_1] (Disabled)' => '[_1] (Uitgeschakeld)', # Translate - New
	'Set Web Services Password' => 'Webservices wachtwoord instellen',
	'All [_1]' => 'Alle [_1]', # Translate - New
	'change' => 'wijzig', # Translate - New
	'[_1] where [_2].' => '[_1] waar [_2]', # Translate - New
	'[_1] where [_2] is [_3]' => '[_1] waar [_2] gelijk is aan [_3]', # Translate - New
	'Remove filter' => 'Filter verwijderen', # Translate - New
	'Show only [_1] where' => 'Toon enkel [_1] waar', # Translate - New
	'status' => 'status',
	'is' => 'gelijk is aan',
	'approved' => 'goedgekeurd', # Translate - Case
	'unapproved' => 'niet goedgekeurd', # Translate - New
	'Filter' => 'Filter',
	'to publish' => 'om te publiceren',
	'Publish' => 'Publiceren',
	'Publish selected TrackBacks (p)' => 'Geselecteerde TrackBacks publiceren (p)',
	'Delete selected TrackBacks (x)' => 'Geselecteerde TrackBacks verwijderen (x)',
	'Report as Spam' => 'Rapporteren als spam', # Translate - New
	'Report selected TrackBacks as spam (j)' => 'Rapporteer geselecteerde TrackBacks als spam (j)', # Translate - New
	'Not Junk' => 'Niet verwerpen',
	'Recover selected TrackBacks (j)' => 'Geselecteerde TrackBacks niet langer markeren als verworpen (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'Bent u zeker dat u alle TrackBacks die als spam zijn gerapporteerd wenst te verwijderen?', # Translate - New
	'Empty Spam Folder' => 'Spam-map leegmaken', # Translate - New
	'Deletes all TrackBacks reported as spam' => 'Verwijdert alle TrackBacks die als spam zijn gerapporteerd', # Translate - New

## tmpl/cms/login.tmpl
	'Signed out' => 'Afmelden', # Translate - New
	'Your Movable Type session has ended.' => 'Uw Movable Type sessie is beëindigd.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Uw Movable Type sessie is beëindigd.  Als u zich opnieuw wenst aan te melden, dan kan dat hieronder.', # Translate - New
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Uw Movable Type sessie is beëindigd. Gelieve u opnieuw aan te melden om deze handeling voort te zetten.', # Translate - New

## tmpl/cms/cfg_archives.tmpl
	'Error: Movable Type was not able to create a directory for publishing your blog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fout: Movable Type kon geen map maken om uw weblog in te publiceren.  Als u deze map zelf aanmaakt, ken er dan genoeg permissies aan toe zodat Movable Type er bestanden in kan aanmaken', # Translate - New
	'Your blog\'s archive configuration has been saved.' => 'De archiefinstellingen van uw weblog zijn opgeslagen.', # Translate - New
	'You have successfully added a new archive-template association.' => 'U hebt een nieuwe koppeling tussen een archief en een sjabloon toegevoegd.',
	'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Het kan zijn dat u uw \'Hoofdarchiefindex\' sjabloon moet bijwerken om rekening te houden met uw nieuwe archiefconfiguratie.',
	'The selected archive-template associations have been deleted.' => 'De geselecteerde koppelingen tussen een archief en een sjabloon zijn verwijderd.',
	'You must set your Local Site Path.' => 'U dient het lokale pad van uw site in te stellen.',
	'You must set a valid Site URL.' => 'U moet een geldige URL instellen voor uw site.',
	'You must set a valid Local Site Path.' => 'U moet een geldig lokaal site-pad instellen.',
	'Publishing Paths' => 'Publicatiepaden',
	'Site URL' => 'URL van de site',
	'The URL of your website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/blog/' => 'De URL van uw website.  Zet er geen bestandsnaam in (m.a.w. laat index.html weg).  Voorbeeld: http://www.voorbeeld.com/blog/', # Translate - New
	'Unlock this blog&rsquo;s site URL for editing' => 'Maak de site URL van deze weblog bewerkbaar', # Translate - New
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => 'Waarschuwing: de site URL aanpassen kan tot gevolg hebben dat alle links naar uw weblog niet langer werken.', # Translate - New
	'The path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/blog' => 'Het pad waar uw indexbestanden gepubliceerd zullen worden.  Een absoluut pad (beginnend met \'/\') verdient de voorkeur, maar u kunt ook een pad ingeven dat relatief is t.o.v. de Movable Type map.  Voorbeeld: /home/melody/public_html/blog', # Translate - New
	'Unlock this blog&rsquo;s site path for editing' => 'Maak het sitepad van deze weblog bewerkbaar', # Translate - New
	'Note: Changing your site root requires a complete rebuild of your site.' => 'Opmerking: het wijzigen van de siteroot vereist het volledig herbouwen van uw site.', # Translate - New
	'Advanced Archive Publishing' => 'Geavanceerde archiefpublicatie', # Translate - New
	'Select this option only if you need to publish your archives outside of your Site Root.' => 'Selecteer deze optie alleen als u uw archieven buiten de root van uw site wenst te publiceren.',
	'Publish archives to alternate root path' => 'Archieven publiceren op een alternatief root-pad.',
	'Archive URL' => 'Archief-URL', # Translate - New
	'Enter the URL of the archives section of your website. Example: http://archives.example.com/' => 'Geef de URL in van het archiefgedeelte van uw website.  Voorbeeld: http://archieven.voorbeeld.com/', # Translate - New
	'Unlock this blog&rsquo;s archive url for editing' => 'Maak de archief-URL van deze weblog bewerkbaar', # Translate - New
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Waarschuwing: het aanpassen van de archief-URL kan ervoor zorgen dat alle links in uw weblog niet meer werken.', # Translate - New
	'Enter the path where your archive files will be published. Example: /home/melody/public_html/archives' => 'Vul het pad in waar uw archiefbestanden gepubliceerd moeten worden.  Voorbeeld: /home/melody/public_html/archieven', # Translate - New
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Waarschuwing: het aanpassen van het archiefpad kan ervoor zorgen dat alle links in uw weblog niet meer werken.', # Translate - New
	'Publishing Options' => 'Publicatie-opties', # Translate - New
	'Preferred Archive Type' => 'Voorkeursarchieftype', # Translate - New
	'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Als u een link naar een gearchiveerde bericht wilt maken&#8212; voor een permalink, bijvoorbeeld&#8212;dan moet u een link naar een bepaald archiveringstype maken, zelfs als u meerdere archieftypes hebt gekozen.',
	'No archives are active' => 'Geen archieven actief', # Translate - New
	'Dynamic Publishing' => 'Dynamisch publiceren', # Translate - New
	'Build all templates statically' => 'Alle sjablonen statisch bouwen',
	'Build only Archive Templates dynamically' => 'Enkel archiefsjablonen dynamisch bouwen',
	'Set each template\'s Build Options separately' => 'Bouwopties voor elk sjabloon apart instellen',
	'Build all templates dynamically' => 'Alle sjablonen dynamisch opbouwen', # Translate - New
	'Enable Dynamic Cache' => 'Dynamische cache inschakelen', # Translate - New
	'Turn on caching.' => 'Caching inschakelen', # Translate - New
	'Enable caching' => 'Caching mogelijk maken', # Translate - New
	'Enable Conditional Retrieval' => 'Conditioneel ophalen mogelijk maken', # Translate - New
	'Turn on conditional retrieval of cached content.' => 'Conditioneel ophalen van inhoud uit de cache inschakelen.', # Translate - New
	'Enable conditional retrieval' => 'Conditioneel ophalen mogelijk maken', # Translate - New
	'File Extension for Archive Files' => 'Bestandsextensie voor archiefbestanden', # Translate - New
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Voer de bestandsextensie voor het archief in. Dit kan zijn in de vorm van \'html\', \'shtml\', \'php\', enz. Opmerking: voer het eerste punt niet in (\'.\').',
	'Archive Types' => 'Archieftypes',
	'Archive types to publish.' => 'Archieftypes om te publiceren', # Translate - New
	'(TemplateMap Not Found)' => '(TemplateMap niet gevonden)', # Translate - New

## tmpl/cms/cfg_prefs.tmpl
	'Your blog preferences have been saved.' => 'Uw blogvoorkeuren zijn opgeslagen.',
	'You must set your Blog Name.' => 'U moet uw blognaam instellen.', # Translate - New
	'You did not select a timezone.' => 'U hebt geen tijdzone geselecteerd.',
	'Name your blog. The blog name can be changed at any time.' => 'Geef uw blog een naam.  De blognaam kan op elk moment aangepast worden.', # Translate - New
	'Enter a description for your blog.' => 'Geef een beschrijving op voor uw weblog.', # Translate - New
	'Timezone' => 'Tijdzone', # Translate - New
	'Select your timezone from the pulldown menu.' => 'Selecteer uw tijdzone in de keuzelijst.',
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
	'User Registration' => 'Gebruikersregistratie', # Translate - New
	'Allow registration for Movable Type.' => 'Laat registratie toe in Movable Type', # Translate - New
	'Registration Not Enabled' => 'Registratie niet ingeschakeld', # Translate - New
	'Note: Registration is currently disabled at the system level.' => 'Opmerking: Registratie is momenteel uitgeschakeld op systeemniveau', # Translate - New
	'Your blog is currently licensed under:' => 'Uw weblog valt momenteel onder deze licentie:', # Translate - New
	'Change your license' => 'Uw licentie wijzigen',
	'Remove this license' => 'Deze licentie verwijderen',
	'Your blog does not have an explicit Creative Commons license.' => 'Uw weblog heeft geen expliciete Creative Commons licentie', # Translate - New
	'Create a license now' => 'Maak nu een licentie aan',
	'Select a Creative Commons license for the entries on your blog (optional).' => 'Selecteer een Creative Commons licentie voor de berichten op uw weblog (optioneel)', # Translate - New
	'Be sure that you understand these licenses before applying them to your own work.' => 'Zorg dat u deze licenties begrijpt voordat u ze op uw eigen werk toepast.',
	'Read more.' => 'Lees verder.',
	'Replace Word Chars' => 'Karakters uit Word vervangen', # Translate - New
	'Replace Fields' => 'Velden vervangen', # Translate - New
	'Extended entry' => 'Uitgebreid bericht', # Translate - Case
	'Smart Replace' => 'Slim vervangen', # Translate - New
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Karakter entiteiten (&amp#8221;, &amp#8220;, etc.)', # Translate - New
	'ASCII equivalents (&quot;, \', ..., -, --)' => 'ASCII equivalenten (&quot;, \', ..., -, --)', # Translate - New

## tmpl/cms/error.tmpl

## tmpl/cms/list_association.tmpl
	'User Associations for [_1]' => 'Gebruikersassociaties voor [_1]', # Translate - New
	'Group Associations for [1]' => 'Groepsassociaties voor [_1]', # Translate - New
	'Users &amp; Groups for [_1]' => 'Gebruikers &amp; Groepen voor [_1]', # Translate - New
	'Users for [_1]' => 'Gebruikers voor [_1]', # Translate - New
	'Remove selected assocations (x)' => 'Geselecteerde associaties verwijderen (x)',
	'association' => 'associatie',
	'associations' => 'associaties',
	'Group Disabled' => 'Groep uitgeschakeld',
	'_USAGE_ASSOCIATIONS' => 'Op dit scherm kunt u associaties zien en er nieuwe aanmaken.',
	'You have successfully removed the association(s).' => 'De associatie(s) zijn met succes verwijderd.',
	'You have successfully created the association(s).' => 'De associatie(s) werden met succes aangemaakt.',
	'Add user to a weblog' => 'Voeg een gebruiker toe aan een weblog',
	'You can not create associations for disabled users.' => 'U kan geen associaties aanmaken voor uitgeschakelde gebruikers.',
	'Add [_1] to a weblog' => 'Voeg [_1] toe aan een weblog',
	'Add group to a weblog' => 'Voeg groep toe aan weblog',
	'You can not create associations for disabled groups.' => 'U kunt geen associaties maken voor uitgeschakelde groepen.',
	'Assign role to a new group' => 'Rol toekennen aan nieuwe greop',
	'Assign Role to Group' => 'Rol toekennen aan groep',
	'Assign role to a new user' => 'Rol toekennen aan nieuwe gebruiker',
	'Assign Role to User' => 'Rol toekennen aan gebruiker',
	'Add a group to this weblog' => 'Voeg een groep toe aan deze weblog',
	'Add a user to this weblog' => 'Voeg een gebruiker toe aan deze weblog',
	'Create a Group Association' => 'Maak een groepsassociatie aan',
	'Create a User Association' => 'Maak een gebruikersassociatie aan',
	'User/Group' => 'Gebruiker/Groep',
	'Created On' => 'Aangemaakt op',
	'No associations could be found.' => 'Er werden geen associaties gevonden.',

## tmpl/cms/list_comment.tmpl
	'The selected comment(s) has been approved.' => 'De geselecteerde reactie(s) zijn goedgekeurd.', # Translate - New
	'All comments reported as spam have been removed.' => 'Alle reaactie die aangemerkt waren als spam zijn verwijderd.', # Translate - New
	'The selected comment(s) has been unapproved.' => 'De geselecteerde reactie(s) zijn niet langer goedgekeurd.', # Translate - New
	'The selected comment(s) has been reported as spam.' => 'De geselecteerde reactie(s) zijn als spam gerapporteerd.', # Translate - New
	'The selected comment(s) has been recovered from spam.' => 'De geselecteerde reactie(s) zijn teruggehaald uit de spam-map', # Translate - New
	'The selected comment(s) has been deleted from the database.' => 'Geselecteerde reactie(en) zijn uit de database verwijderd.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => 'Eén of meer reacties die u selecteerde werd ingegeven door een niet geauthenticeerde reageerder. Deze reageerders kunnen niet verbannen of vertrouwd worden.',
	'No comments appeared to be spam.' => 'Er lijken geen berichten als spam gemarkeerd te zijn', # Translate - New
	'Showing only: [_1]' => 'Enkel: [_1]', # Translate - New
	'[_1] on entries created within the last [_2] days' => '[_1] op berichten aangemaakt in de laatste [_2] dagen', # Translate - New
	'[_1] on entries created more than [_2] days ago' => '[_1] op berichten aangemaakt langer dan [_2] dagen geleden', # Translate - New
	'[_1] where [_2] [_3]' => '[_1] waar [_2] [_3]', # Translate - New
	'Show' => 'Toon',
	'all' => 'alle',
	'only' => 'enkel',
	'[_1] where' => '[_1] waar', # Translate - New
	'entry was created in last' => 'bericht werd aangemaakt in de laatste', # Translate - New
	'entry was created more than' => 'bericht werd aangemaakt meer dan', # Translate - New
	'commenter' => 'reageerder',
	' days.' => ' dagen.', # Translate - New
	' days ago.' => ' dagen geleden.', # Translate - New
	' is approved' => ' is goedgekeurd', # Translate - New
	' is unapproved' => ' is niet gekeurd', # Translate - New
	' is unauthenticated' => ' is niet geauthenticeerd', # Translate - New
	' is authenticated' => ' is geauthenticeerd', # Translate - New
	' is trusted' => ' is vertrouwd', # Translate - New
	'Approve' => 'Goedkeuren', # Translate - New
	'Approve selected comments (p)' => 'Geselecteerde reacties goedkeuren (p)', # Translate - New
	'Delete selected comments (x)' => 'Geselecteerde reacties verwijderen (x)',
	'Report the selected comments as spam (j)' => 'Rapporteer de geselecteerde reacties als spam (j)', # Translate - New
	'Recover from Spam' => 'Terughalen uit de spam-map', # Translate - New
	'Recover selected comments (j)' => 'Geselecteerde reacties niet langer als spam markeren (j)',
	'Are you sure you want to remove all comments reported as spam?' => 'Bent u zeker dat u alle reacties die als spam gemarkeerd zijn wenst te verwijderen?', # Translate - New
	'Deletes all comments reported as spam' => 'Verwijder alle reacties gemarkeerd als spam', # Translate - New

## tmpl/cms/admin.tmpl
	'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'In dit scherm kunt u informatie bekijken over het hele systeem en kunt u vele aspecten ervan beheren over alle weblogs.',
	'List Weblogs' => 'Lijst weblogs',
	'List Users and Groups' => 'Lijst gebruikers en groepen',
	'List Associations and Roles' => 'Lijst associaties en rollen',
	'Privileges' => 'Privileges',
	'List Plugins' => 'Lijst plugins',
	'Aggregate' => 'Inhoudelijk',
	'List Tags' => 'Tags oplijsten',
	'Edit System Settings' => 'Systeeminstellingen bewerken',
	'Show Activity Log' => 'Activiteitlog bekijken',
	'System Stats' => 'Systeemstatistieken',
	'Active Users' => 'Actieve gebruikers',
	'Version' => 'Versie',
	'Essential Links' => 'Essentiële links',
	'Movable Type Home' => 'Movable Type hoofdpagina',
	'Plugin Directory' => 'Plugin-bibliotheek',
	'Support and Documentation' => 'Ondersteuning en documentatie',
	'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account?portal=nl',
	'Your Account' => 'Uw account',
	'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit&portal=nl',
	'Open a Help Ticket' => 'Open een helpticket',
	'Paid License Required' => 'Betaalde licentie vereist',
	'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/',
	'http://www.sixapart.com/movabletype/kb/' => 'http://www.sixapart.com/movabletype/kb/',
	'Knowledge Base' => 'Kennisdatabank',
	'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/',
	'Professional Network' => 'Professional Network',
	'Movable Type News' => 'Movable Type-nieuws',
	'Add blog_id to see additional settings links.' => 'Voeg blog_id toe om links naar bijkomende instellingen te zien.', # Translate - New

## tmpl/cms/rebuilding.tmpl
	'Rebuilding' => 'Opnieuw aan het opbouwen', # Translate - New
	'Rebuilding [_1]' => '[_1] wordt opnieuw opgebouwd',
	'Rebuilding [_1] pages [_2]' => 'Opnieuw opbouwen van [_1] pagina\'s [_2]',
	'Rebuilding [_1] dynamic links' => 'Dynamische [_1] links worden opnieuw opgebouwd',
	'Rebuilding [_1] pages' => 'Opnieuw opbouwen [_1] pagina\'s',

## tmpl/cms/include/template_table.tmpl
	'Dynamic' => 'Dynamisch',
	'Linked' => 'Gelinkt',
	'Built w/Indexes' => 'Gebouwd met indexen',
	'Dymanic Template' => 'Dynamisch sjabloon', # Translate - New
	'Linked Template' => 'Gelinkt sjabloon', # Translate - New
	'Built Template w/Indexes' => 'Sjabloon gebouwd met indexen', # Translate - New

## tmpl/cms/include/typekey.tmpl
	'Your TypeKey API Key is used to access Six Apart services like its free Authentication service.' => 'Uw TypeKey API sleutel wordt gebruikt om toegang te krijgen tot Six Apart services zoals de gratis authenticatiedienst.', # Translate - New
	'TypeKey Enabled' => 'TypeKey ingeschakeld', # Translate - New
	'TypeKey is enabled.' => 'TypeKey is ingeschakeld', # Translate - New
	'Clear TypeKey Token' => 'TypeKey token leegmaken', # Translate - New
	'TypeKey Setup:' => 'TypeKey instellingen:', # Translate - New
	'TypeKey API Key Removed' => 'TypeKey API sleutel verwijderd', # Translate - New
	'Please click the Save Changes button below to disable authentication.' => 'Gelieve op de knop \'Wijzigingen opslaan\' te drukken om authenticatie uit te schakelen.',
	'TypeKey Not Enabled' => 'TypeKey niet ingeschakeld', # Translate - New
	'TypeKey is not enabled.' => 'TypeKey is niet ingeschakeld', # Translate - New
	'Enter API Key:' => 'Voer API sleutel in:', # Translate - New
	'Obtain TypeKey API Key' => 'Verkrijg TypeKey API sleutel', # Translate - New
	'TypeKey API Key Acquired' => 'TypeKey API sleutel verkregen', # Translate - New
	'Please click the Save Changes button below to enable TypeKey.' => 'Gelieve op de knop \'Wijzigingen opslaan\' te klikken om TypeKey in te schakelen.', # Translate - New

## tmpl/cms/include/cfg_entries_edit_page.tmpl
	'Editor Fields' => 'Velden van de tekstbewerker',
	'_USAGE_ENTRYPREFS' => 'Deze instellingen bepalen welke opties verschijnen op de schermen waar men nieuwe en bestaande berichten kan bewerken. U kunt een voorgedefiniëerde configuratie selecteren (Eenvoudig of Alle) of uw persoonlijke voorkeuren instellen door op Aangepast te klikken en vervolgens de opties te selecteren die u wenst weer te geven.',
	'Custom' => 'Aangepast',
	'Action Bar' => 'Actiebalk',
	'Select the location of the entry editor\'s action bar.' => 'Selecteer de locatie voor de actiebalk van de tekstbewerker.',
	'Below' => 'Onder',
	'Above' => 'Boven',

## tmpl/cms/include/archive_maps.tmpl
	'Preferred' => 'Voorkeur',
	'Custom...' => 'Gepersonaliseerd...',

## tmpl/cms/include/pagination.tmpl
	'Previous' => 'Vorige',
	'Newer' => 'Nieuwer',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] van [_3]', # Translate - New
	'Older' => 'Ouder',

## tmpl/cms/include/footer.tmpl
	'Widget Title' => 'Titel widget', # Translate - New
	'Dashboard' => 'Dashboard', # Translate - New
	'Compose Entry' => 'Bericht opstellen', # Translate - New
	'Manage Entries' => 'Berichten beheren', # Translate - New
	'System Settings' => 'Systeeminstellingen', # Translate - New
	'<a href="[_1]">Movable Type</a> version [_2]' => '<a href="[_1]">Movable Type</a> versie [_2]', # Translate - New
	'with' => 'met', # Translate - New

## tmpl/cms/include/login_mt.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Meer mogelijkheden...',
	'to act upon' => 'om de handeling op uit te voeren',
	'Go' => 'Ga',

## tmpl/cms/include/ping_table.tmpl
	'From' => 'Van',
	'Target' => 'Doel',
	'Only show published TrackBacks' => 'Enkel gepubliceerde TrackBacks tonen',
	'Only show pending TrackBacks' => 'Enkel hangende TrackBacks tonen',
	'Edit this TrackBack' => 'Deze TrackBack bewerken',
	'Go to the source entry of this TrackBack' => 'Ga naar het bronbericht van deze TrackBack',
	'View the [_1] for this TrackBack' => 'De [_1] bekijken voor deze TrackBack',
	'Search for all comments from this IP address' => 'Zoek naar alle reacties van dit IP adres',

## tmpl/cms/include/anonymous_comment.tmpl
	'Require E-mail Address for Anonymous Comments' => 'E-mail adres vereisen voor anonieme reacties', # Translate - New
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Indien ingeschakeld moeten bezoekers een geldig e-mail adres opgeven wanneer ze reageren.',

## tmpl/cms/include/header.tmpl
	'Send us your feedback on Movable Type' => 'Stuur ons feedback over Movable Type', # Translate - New
	'Feedback?' => 'Feedback?', # Translate - New
	'Hi [_1]' => 'Hallo [_1]', # Translate - New
	'All blogs' => 'alle blogs', # Translate - Case
	'Select another blog...' => 'Selecteer een andere blog...', # Translate - New
	'Create a new blog' => 'Maak een nieuwe blog aan', # Translate - New
	'Write Entry' => 'Schrijf bericht', # Translate - New
	'Blog Dashboard' => 'Blogdashboard', # Translate - New
	'View' => 'Bekijken', # Translate - New

## tmpl/cms/include/cfg_system_content_nav.tmpl
	'General' => 'Algemeen',

## tmpl/cms/include/tools_content_nav.tmpl
	'Export' => 'Exporteer', # Translate - New

## tmpl/cms/include/blog-left-nav.tmpl
	'Backup this weblog' => 'Maak een backup van deze weblog',

## tmpl/cms/include/entry_table.tmpl
	'Blog' => 'Blog',
	'Only show unpublished [_1]' => 'Enkel niet gepubliceerde [_1] tonen', # Translate - New
	'Only show published [_1]' => 'Enkel gepubliceerde [_1] tonen', # Translate - New
	'Only show scheduled [_1]' => 'Enkel geplande [_1] tonen', # Translate - New
	'View [_1]' => 'Toon [_1]', # Translate - New

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Toegevoegd op',
	'Click to edit notification list item' => 'Klik om een item uit de notificatielijst te bewerken', # Translate - New
	'No notifications could be found.' => 'Er werden geen notificaties gevonden.',

## tmpl/cms/include/display_options.tmpl
	'[quant,_1,row]' => '[quant,_1,rij,rijen]',
	'Compact' => 'Compact',
	'Expanded' => 'Uitgebreid',
	'Date Format' => 'Datumformaat', # Translate - New
	'Relative' => 'Relatief',
	'Full' => 'Volledig',

## tmpl/cms/include/cfg_content_nav.tmpl
	'Spam' => 'Spam', # Translate - New
	'Web Services' => 'Webservices', # Translate - New

## tmpl/cms/include/blog_table.tmpl
	'Weblog Name' => 'Weblognaam',
	'No weblogs could be found.' => 'Er werden geen weblogs gevonden.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Alle gegevens zijn met succes opgeslagen!',
	'Download This File' => 'Dit bestand downloaden',
	'_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING',
	'_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE',
	'An error occurred during the backup process: [_1]' => 'Er deed zich een fout voor tijdens het backup-proces: [_1]',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Importeren...',
	'Importing entries into blog' => 'Berichten worden geïmporteerd in de blog',
	'Importing entries as user \'[_1]\'' => 'Berichten worden geïmporteerd als gebruiker \'[_1]\'',
	'Creating new users for each user found in the blog' => 'Nieuwe gebruikers worden aangemaakt voor elke gebruiker gevonden in de weblog',

## tmpl/cms/include/users_content_nav.tmpl
	'User Profile' => 'Gebruikersprofiel',
	'Groups' => 'Groepen',
	'Group Profile' => 'Groepsprofiel',
	'Details' => 'Details',
	'List Roles' => 'Toon rollen', # Translate - New

## tmpl/cms/include/calendar.tmpl

## tmpl/cms/include/overview-left-nav.tmpl

## tmpl/cms/include/comment_table.tmpl
	'Reply' => 'Antwoord', # Translate - New
	'Only show published comments' => 'Enkel gepubliceerde reacties tonen',
	'Only show pending comments' => 'Enkel hangende reacties tonen',
	'Edit this comment' => 'Deze reactie bewerken',
	'(1 reply)' => '(1 antwoord)', # Translate - New
	'([_1] replies)' => '([_1] antwoorden)', # Translate - New
	'Edit this [_1] commenter' => 'Bewerk deze [_1] reageerder', # Translate - New
	'Search for comments by this commenter' => 'Zoek naar reacties door deze reageerder',
	'View this entry' => 'Dit bericht bekijken',
	'Show all comments on this entry' => 'Toon alle reacties op dit bericht',

## tmpl/cms/include/rebuild_stub.tmpl
	'To see the changes reflected on your public site, you should rebuild your site now.' => 'Bouw uw website opnieuw op als u de wijzigingen op uw publieke site wilt kunnen zien.',
	'Rebuild my site' => 'Mijn site opnieuw opbouwen',

## tmpl/cms/include/chromeless_footer.tmpl

## tmpl/cms/include/backup_start.tmpl
	'Tools: Backup' => 'Gereedschappen: Backup', # Translate - New
	'Backing up Movable Type' => 'Backup maken van Movable Type', # Translate - New

## tmpl/cms/include/commenter_table.tmpl
	'Identity' => 'Identiteit',
	'Last Commented' => 'Laatste reactie', # Translate - New
	'Only show trusted commenters' => 'Enkel vertrouwde reageerders tonen',
	'Only show banned commenters' => 'Enkel verbannen reageerders tonen',
	'Only show neutral commenters' => 'Enkel neutrale reageerders tonen',
	'Authenticated' => 'Bevestigd',
	'Edit this commenter' => 'Deze reageerder bewerken',
	'View this commenter&rsquo;s profile' => 'Bekijk het profiel van deze reageerder', # Translate - New
	'No commenters could be found.' => 'Er werden geen reageerders gevonden.',

## tmpl/cms/include/author_table.tmpl
	'Only show enabled users' => 'Enkel ingeschakelde gebruikers worden getoond',
	'Only show pending users' => 'Enkel hangende gebruikers worden getoond',
	'Only show disabled users' => 'Enkel uitgeschakelde gebruikers worden getoond',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'Activiteit-feed',
	'Disabled' => 'Uitgeschakeld',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Alle gegevens werden met succes geïmporteerd!',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Verwijder zeker de bestanden waaruit u gegevens importeerde uit de \'import\' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-<mt:date format="%Y"> Six Apart. Alle rechten voorbehouden.', # Translate - New

## tmpl/cms/include/log_table.tmpl
	'Log Message' => 'Logbericht',
	'_LOG_TABLE_BY' => '_LOG_TABLE_BY',
	'IP: [_1]' => 'IP: [_1]',
	'[_1]' => '[_1]', # Translate - New
	'No log records could be found.' => 'Er werden geen logberichten gevonden.',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Stap [_1] van [_2]',
	'Go to [_1]' => 'Ga naar [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'Sorry, er waren geen resultaten voor uw zoekopdracht. Probeer opnieuw te zoeken.',
	'Sorry, there is no data for this object set.' => 'Sorry, er zijn geen gegevens ingesteld voor dit object.',
	'Back' => 'Terug',
	'Confirm' => 'Bevestigen',

## tmpl/cms/list_blog.tmpl
	'You have successfully deleted the blogs from the Movable Type system.' => 'U heeft met succes de blogs verwijderd uit het Movable Type systeem.',
	'weblog' => 'weblog',
	'weblogs' => 'weblogs',
	'Delete selected weblogs (x)' => 'Geselecteerde weblogs verwijderen (x)',
	'Are you sure you want to delete this weblog?' => 'Bent u zeker dat u deze weblog wenst te verwijderen?',
	'Create New Weblog' => 'Nieuwe weblog aanmaken',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Tijd voor een upgrade!',
	'Upgrade Check' => 'Upgrade-controle',
	'Do you want to proceed with the upgrade anyway?' => 'Wenst u toch door te gaan met de upgrade?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Er is een nieuwe versie van Movable Type geïnstalleerd.  Er moeten een aantal dingen gebeuren om uw database bij te werken.',
	'In addition, the following Movable Type components require upgrading or installation:' => 'Bovendien hebben volgende Movable Type componenten een upgrade nodig of moeten ze geïnstalleerd worden:', # Translate - New
	'The following Movable Type components require upgrading or installation:' => 'Volgende Movable Type componenten hebben een upgrade nodig of moeten geïnstalleerd worden:', # Translate - New
	'Begin Upgrade' => 'Begin de upgrade',
	'Your Movable Type installation is already up to date.' => 'Uw Movable Type installation is al up-to-date.',
	'Return to Movable Type' => 'Terugkeren naar Movable Type',

## tmpl/cms/list_author.tmpl
	'Users: System-wide' => 'Gebruikers: over heel het systeem', # Translate - New
	'_USAGE_AUTHORS_LDAP' => 'Dit is een lijst met alle gebruikers in het Movable Type systeem.  U kunt de permissies van een gebruiker bewerken door op zijn/haar naam te klikken.  U kunt gebruikers uitschakelen door het vakje naast hun naam aan te kruisen en dan UITSCHAKELEN te kiezen.  Wanneer u dit doet, zal de gebruiker zich niet meer kunnen aanmelden bij Movable Type.',
	'_USAGE_AUTHORS_1' => 'Dit is een lijst met alle gebruikers in het Movable Type systeem. U kunt de permissies van een gebruiker bewerken door op zijn/haar naam te klikken.  U kunt gebruikers permanent wissen door het vakje naast hun naam aan te kruisen en dan op WISSEN te klikken.  OPMERKING: als u een gebruiker enkel wenst te verwijderen van een bepaalde weblog, bewerk dan de permissies van de gebruiker om de auteur te verwijderen; een gebruiker verwijderen met WISSEN zal de gebruiker helemaal verwijderen uit het systeem.  U kunt gebrukersrecords aanmaken, wijzigen en wissen met een CSV-gebaseerd bestand met commando\'s.',
	'You have successfully disabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes uitgeschakeld.',
	'You have successfully enabled the selected user(s).' => 'Geselecteerde gebruiker(s) met succes ingeschakeld.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'U heeft met succes de gebruiker(s) verwijderd uit het Movable Type systeem.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Enterprise.' => 'De verwijderde gebruiker(s) blijven bestaan in de externe directory. Om die reden zullen ze zich nog steeds kunnen aanmelden op Movable Type Enterprise.',
	'You have successfully synchronized users\' information with the external directory.' => 'U heeft met succes de gebruikersgegevens gesynchroniseerd met de externe directory.',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Een aantal ([_1]) van de geselecteerde gebruiker(s) konden niet opniew worden ingeschakeld omdat ze niet meer werden gevonden in de externe directory.',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Er deed zich een fout voor tijdens de synchronisatie.  Kijk in het <a href=\'[_1]\'>activiteitenlog</a> voor gedetailleerde informatie.',
	'Show Enabled Users' => 'Toon ingeschakelde gebruikers', # Translate - New
	'Show Disabled Users' => 'Toon uitgeschakelde gebruikers', # Translate - New
	'Show All Users' => 'Toon alle gebruikers', # Translate - New
	'user' => 'gebruiker',
	'users' => 'gebruikers',
	'_USER_ENABLE' => 'Inschakelen',
	'Enable selected users (e)' => 'Geselecteerde gebruikers inschakelen (E)',
	'_NO_SUPERUSER_DISABLE' => '_NO_SUPERUSER_DISABLE',
	'_USER_DISABLE' => 'Uitschakelen',
	'Disable selected users (d)' => 'Geselecteerde gebruikers uitschakelen (D)',
	'None.' => 'Geen.',
	'(Showing all users.)' => '(Alle gebruikers worden getoond.)',
	'Showing only users whose [_1] is [_2].' => 'Enkel gebruikers worden getoond waarbij [_1] gelijk is aan [_2].',
	'users.' => 'gebruikers.',
	'users where' => 'gebruikers waarbij',
	'enabled' => 'ingeschakeld',
	'disabled' => 'uitgeschakeld',
	'.' => '.',
	'No users could be found.' => 'Er werden geen gebruikers gevonden.',

## tmpl/cms/author_bulk.tmpl
	'Manage Users in bulk' => 'Gebruikers in bulk beheren', # Translate - New
	'_USAGE_AUTHORS_2' => 'U kunt gebruikers registreren, bewerken of verwijderen met een CSV-geformatteerd bestand met commando\'s.',
	'Upload source file' => 'Bronbestand opladen',
	'Specify the CSV-formatted source file for upload' => 'Geef het CSV-geformatteerde bronbestand aan dat moet worden opgeladen', # Translate - New
	'Source File Encoding' => 'Encodering bronbestand', # Translate - New
	'Upload (u)' => 'Opladen (u)',

## tmpl/cms/popup/recover.tmpl
	'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Uw wachtwoord is veranderd en het nieuwe wachtwoord is naar uw e-mailadres ([_1]) gestuurd.',
	'Return to sign in to Movabale Type' => 'Keer terug om u aan te melden op Movable Type', # Translate - New
	'Enter your Movable Type username:' => 'Voer uw Movable Type-gebruikersnaam in:',
	'Enter your password recovery word/phrase:' => 'Voer uw woord/uitdrukking in om uw wachtwoord terug te vinden:',
	'Recover' => 'Terugvinden',

## tmpl/cms/popup/bm_entry.tmpl
	'Select' => 'Selecteren',
	'Add new category...' => 'Nieuwe categorie toevoegen...',
	'You must choose a weblog in which to create the new entry.' => 'U moet een weblog kiezen om het nieuwe bericht op aan te maken', # Translate - New
	'Select a weblog for this entry:' => 'Selecteer een weblog voor dit bericht', # Translate - New
	'Select a weblog' => 'Selecteer een weblog',
	'Assign Multiple Categories' => 'Meerdere categorieën toewijzen',
	'Entry Body' => 'Berichttekst',
	'Insert Link' => 'Link invoegen',
	'Insert Email Link' => 'E-mail link invoegen',
	'Quote' => 'Citaat',
	'Extended Entry' => 'Uitgebreid bericht',
	'Send an outbound TrackBack:' => 'Uitgaande TrackBack versturen:',
	'Select an entry to send an outbound TrackBack:' => 'Selecteer een bericht om een uitgaande TrackBack naar te versturen:',
	'Unlock this entry\'s output filename for editing' => 'Maak de naam van het uitvoerbestand van dit bericht bewerkbaar',
	'Save this entry (s)' => 'Dit bericht opslaan (s)',
	'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'U heeft toestemming om berichten aan te maken op geen enkele weblog op deze installatie.  Gelieve uw systeembeheerder te contacteren om toegang te krijgen.',

## tmpl/cms/popup/show_upload_html.tmpl
	'Copy and paste this HTML into your entry.' => 'Deze HTML in uw bericht kopiëren en plakken.',
	'Upload Another' => 'Meer opladen',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succes', # Translate - New
	'All of your files have been rebuilt.' => 'Al uw bestanden zijn opnieuw opgebouwd.',
	'Your [_1] pages have been rebuilt.' => 'Uw [_1] pagina\'s zijn opnieuw opgebouwd.',
	'View your site' => 'Uw site bekijken',
	'View this page' => 'Deze pagina bekijken',
	'Rebuild Again' => 'Nogmaals opnieuw opbouwen',

## tmpl/cms/popup/bm_posted.tmpl
	'Your new entry has been saved to [_1]' => 'Uw nieuwe bericht is opgeslagen op [_1]',
	', and it has been published to your site' => ', en het is op uw site gepubliceerd', # Translate - New
	'. ' => '. ',
	'Edit this entry' => 'Dit bericht bewerken',

## tmpl/cms/popup/category_add.tmpl
	'Add A [_1]' => 'Voeg een [_1] toe', # Translate - Case
	'To create a new [_1], enter a title in the field below, select a parent [_1], and click the Add button.' => 'Om een nieuwe [_1] aan te maken moet u een titel invullen in het veld hieroonder, een ouder [_1] selecteren en op de knop \'Toevoegen\' klikken.', # Translate - New
	'[_1] Title:' => '[_1] titel:', # Translate - New
	'Parent [_1]:' => 'Ouder [_1]:', # Translate - New
	'Top Level' => 'Topniveau',
	'Save [_1] (s)' => '[_1] opslaan (s)', # Translate - New

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'Alle bestanden', # Translate - New
	'Index Template: [_1]' => 'Indexsjabloon: [_1]',
	'Indexes Only' => 'Enkel indexen', # Translate - New
	'[_1] Archives Only' => 'Enkel [_1] archieven', # Translate - New
	'Rebuild (r)' => 'Opnieuw opbouwen (r)',
	'Select the type of rebuild you would like to perform. Note: This will not rebuild any templates you have chosen to not automatically rebuild with index templates.' => 'Selecteer het soort herbouw-operatie dat u wenst uit te voeren.  Opmerking: dit zal geen sjabonen opnieuw opbouwen waarvan u heeft aangegeven dat ze niet automatisch met indexsjablonen moeten herbouwd worden.',

## tmpl/cms/popup/pinged_urls.tmpl
	'Here is a list of the previous TrackBacks that were successfully sent:' => 'Hier is een lijst met TrackBacks die eerder met succes werden verstuurd:',
	'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Hier is een lijst met de vorige TrackBacks die mislukten.  Om ze opnieuw te proberen, neem ze op in de lijst uitgaande TrackBack URLs van uw bericht.:',

## tmpl/cms/list_entry.tmpl
	'Your [_1] has been deleted from the database.' => 'Uw [_1] is verwijderd uit de database', # Translate - New
	'Go back' => 'Ga terug', # Translate - Case
	'tag (exact match)' => 'tag (exacte overeenkomst)',
	'tag (fuzzy match)' => 'tag (fuzzy overeenkomst)',
	'published' => 'gepubliceerd',
	'unpublished' => 'ongepubliceerd',
	'scheduled' => 'gepland',
	'Select A User:' => 'Selecteer een gebruiker:',
	'User Search...' => 'Zoeken naar gebruiker...',
	'Recent Users...' => 'Recente gebruikers...',
	'Save these [_1] (s)' => 'Sla deze [_1] op (s)', # Translate - New
	'to rebuild' => 'om opnieuw op te bouwen',
	'Rebuild selected [_1] (r)' => 'Geselecteerde [_1] opnieuw opbouwen (r)', # Translate - New
	'Delete selected [_1] (x)' => 'Geselecteerde [_1] verwijderen (x)', # Translate - New
	'page' => 'pagina', # Translate - Case
	'pages' => 'pagina\'s', # Translate - Case
	'Rebuild selected pages (r)' => 'Bouw geselecteerde pagina\'s opnieuw op (r)', # Translate - New
	'Delete selected pages (x)' => 'Verwijder geselecteerde pagina\'s (x)', # Translate - New

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Wachtwoorden terugvinden',
	'No users were selected to process.' => 'Er werden geen gebruikers geselecteerd om te verwerken.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Het activiteitlog is leeggemaakt.',
	'The Movable Type activity log contains a record of notable actions in the system.' => 'Het Movable Type activiteitlog bevat een overzicht van alle belangrijke gebeurtenissen in het systeem.',
	'All times are displayed in GMT[_1].' => 'Alle tijdstippen worden getoond in GMT[_1].',
	'All times are displayed in GMT.' => 'Alle tijdstippen worden getoond in GMT.',
	'Filtered' => 'Gefilterde',
	'Filtered Activity Feed' => 'Gefilterde activiteitenfeed', # Translate - New
	'Download Filtered Log (CSV)' => 'Gefilterde log downloaden', # Translate - New
	'Download Log (CSV)' => 'Log downloaden (CSV)', # Translate - New
	'Clear Activity Log' => 'Activiteitenlog leegmaken',
	'Are you sure you want to reset activity log?' => 'Bent u zeker dat u het activiteitlog wenst leeg te maken?',
	'Showing all log records' => 'Alle logberichten worden getoond', # Translate - New
	'Quickfilter:' => 'Snelfilter:',
	'Show only errors.' => 'Enkel fouten tonen.',
	'Showing only log records where' => 'Enkel logberichten worden getoond waarbij',
	'log records.' => 'logberichten.',
	'log records where' => 'logberichten waarbij',
	'level' => 'niveau',
	'classification' => 'classificatie',
	'Security' => 'Beveiliging',
	'Information' => 'Informatie',
	'Debug' => 'Debug',
	'Security or error' => 'Beveiliging of fout',
	'Security/error/warning' => 'Beveiliging/fout/waarschuwing',
	'Not debug' => 'Debug niet',
	'Debug/error' => 'Debug/fout',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'Uw tag-wijzigingen en toevoegingen zijn uitgevoerd.',
	'You have successfully deleted the selected tags.' => 'U hebt met succes de geselecteerde tags verwijderd.',
	'tag' => 'tag',
	'tags' => 'tags',
	'Delete selected tags (x)' => 'Verwijder de geselecteerde tags (x)',
	'Tag Name' => 'Tag-naam',
	'Click to edit tag name' => 'Klik om de naam van de tag te wijzigen',
	'Rename' => 'Naam wijzigen',
	'Show all entries with this tag' => 'Toon alle berichten met deze tag',
	'[quant,_1,entry,entries]' => '[quant,_1,bericht,berichten]',
	'No tags could be found.' => 'Er werden geen tags gevonden.',
	'An error occurred while testing for the new tag name.' => 'Er deed zich een fout voor bij het testen op de nieuwe tagnaam.',

## tmpl/cms/restore.tmpl
	'Perl module XML::SAX and/or its dependencies are missing - Movable Type can not restore the system without it.' => 'Perl module XML::SAX ontbreekt en/of enkele modules waarvan deze afhankelijk is - Movable Type kan geen restore operatie uitvoeren zonder deze module.', # Translate - New
	'Upload backup file' => 'Backup-bestand opladen', # Translate - New
	'If your backup file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'Als uw backup-bestand zich op uw computer bevindt, kunt u het hier opladen.  In het andere geval zal Movable Type automatisch in de \'omport\' map kijken in uw Movable Type map.', # Translate - New
	'Version verification' => 'Versieverificatie', # Translate - New
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Kruis dit aan en ook bestanden die gebackupt zijn van nieuwere versies van Movable Type kunnen teruggezet worden op dit systeem.  Opmerking: de schemaversie negeren kan Movable Type permanent beschadigen.', # Translate - New
	'Ignore schema version conflict' => 'Negeer schemaversieconflicten', # Translate - New
	'Restore (r)' => 'Terugzetten (r)', # Translate - New

## tmpl/cms/create_author_bulk_start.tmpl
	'Updating...' => 'Bijwerken...',
	'Updating users by reading the uploaded CSV file' => 'Gebruikers worden bijgewerkt aan de hand van het opgeladen CSV bestand',

## tmpl/cms/list_category.tmpl
	'Your [_1] changes and additions have been made.' => 'Uw [_1] wijzigingen en toevoegingen zijn gemaakt.', # Translate - New
	'You have successfully deleted the selected [_1].' => 'U heeft met succes de geselecteerde [_1] verwijderd', # Translate - New
	'Create new top level [_1]' => 'Maak een nieuwe [_1] van topniveau', # Translate - New
	'Collapse' => 'Inklappen',
	'Expand' => 'Uitklappen',
	'Move [_1]' => 'Verplaats [_1]', # Translate - New
	'Move' => 'Verplaatsen',
	'[quant,_1,<mt:var name="entry_label" lower_case="1">,<mt:var name="entry_label_plural" lower_case="1">]' => '[quant,_1,<mt:var name="entry_label" lower_case="1">,<mt:var name="entry_label_plural" lower_case="1">]', # Translate - New
	'[quant,_1,TrackBack]' => '[quant,_1,TrackBack]',

## tmpl/cms/setup_initial_blog.tmpl
	'Create Your First Blog' => 'Maak uw eerste weblog aan', # Translate - New
	'The blog name is required.' => 'De naam van de blog is vereist', # Translate - New
	'The blog url is required.' => 'De url van de blog is vereist', # Translate - New
	'The publishing path is required.' => 'Het publicatiepad is vereist', # Translate - New
	'The timezone is required.' => 'De tijdzone is vereist', # Translate - New
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'Om uw blog goed te kunnen publiceren, moet u aan Movable Type de URL van uw weblog en het pad op het bestandssysteem opgeven waar de bestanden gepubliceerd moeten worden.', # Translate - New
	'My First Blog' => 'Mijn eerste weblog', # Translate - New
	'Blog URL' => 'Blog-URL', # Translate - New
	'Publishing Path' => 'Publicatiepad', # Translate - New
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Uw \'publicatiepad\' is het pad op het bestandsysteem van uw webserver waar Movable Type alle bestanden zal publiceren van uw weblog.  Uw webserver moet schrijfrechten hebben op deze map. ', # Translate - New
	'Finish install' => 'Installatie vervolledigen', # Translate - Case

## tmpl/cms/create_author_bulk_end.tmpl
	'All users updated successfully!' => 'Alle gebruikers met succes bijgewerkt!',
	'An error occurred during the updating process. Please check your CSV file.' => 'Er deed zich een fout voor tijdens het bijwerken.  Gelieve uw CSV bestand na te kijken.',

## tmpl/cms/list_asset.tmpl
	'Manage Files' => 'Bestandsbeheer', # Translate - New
	'You have successfully deleted the file(s).' => 'U heeft met succes de bestand(en) verwijderd', # Translate - New
	'Show Images' => 'Afbeeldingen tonen', # Translate - New
	'Show Files' => 'Bestanden tonen', # Translate - New
	'type' => 'type', # Translate - Case
	'asset' => 'mediabestand', # Translate - New
	'assets' => 'mediabestanden', # Translate - Case
	'Delete selected assets (x)' => 'Geselecteerde mediabestanden verwijderen (x)', # Translate - New

## tmpl/cms/preview_strip.tmpl
	'You are previewing the [_1] titled &ldquo;[_2]&rdquo;' => 'U bekijkt een voorbeeld van de [_1] met de titel &ldquo;[_2]&rdquo;', # Translate - New

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => 'IP-verbanningsinstellingen',
	'You have added [_1] to your list of banned IP addresses.' => 'U hebt [_1] toegevoegd aan uw lijst met uitgesloten IP-adressen.',
	'You have successfully deleted the selected IP addresses from the list.' => 'U hebt de geselecteerde IP-adressen uit de lijst is verwijderd.',
	'Ban New IP Address' => 'Nieuw IP-adres verbannen',
	'IP Address' => 'IP-adres',
	'Ban IP Address' => 'IP-adres verbannen',
	'Date Banned' => 'Verbanningsdatum',
	'IP address' => 'IP-adres',
	'IP addresses' => 'IP-addressen',
	'No banned IPs have been added.' => 'Er werden geen gebande IP adressen toegevoegd', # Translate - New

## tmpl/cms/cfg_trackbacks.tmpl
	'TrackBack Settings' => 'TrackBack instellingen ', # Translate - New
	'Your TrackBack preferences have been saved.' => 'Uw TrackBackvoorkeuren zijn opgeslagen', # Translate - New
	'Note: TrackBacks are currently disabled at the system level.' => 'Opmerking: TrackBacks zijn momenteel uitgeschakeld op systeemniveau.',
	'Accept TrackBacks' => 'TrackBacks aanvaarden',
	'If enabled, TrackBacks will be accepted from any source.' => 'Indien ingeschakeld zullen TrackBacks worden aanvaard van eender welke bron.',
	'TrackBack Policy' => 'TrackBack beleid', # Translate - New
	'Moderation' => 'Moderatie',
	'Hold all TrackBacks for approval before they\'re published.' => 'Alle TrackBacks tegenhouden om goedgekeurd te worden voor ze worden gepubliceerd.',
	'Apply \'nofollow\' to URLs' => '\'nofollow\' toepassen op URL\'s', # Translate - New
	'This preference affects both comments and TrackBacks.' => 'Deze instelling heeft effect op reacties en TrackBacks', # Translate - New
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'Indien ingeschakeld, zullen alle URL\'s in reacties en TrackBacks een \'nofollow\' linkrelatie toegewezen krijgen.', # Translate - New
	'E-mail Notification' => 'E-mail notificatie',
	'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Geef aan wanneer Movable Type u op de hoogte moet brengen van nieuwe TrackBacks, indien gewenst.',
	'On' => 'Aan',
	'Only when attention is required' => 'Alleen wanneer er aandacht is vereist',
	'Off' => 'Uit',
	'Ping Options' => 'Pingopties', # Translate - New
	'TrackBack Auto-Discovery' => 'Automatisch TrackBacks ontdekken',
	'If you turn on auto-discovery, when you write a new entry, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Indien u auto-discovery inschakelt dan zullen telkens u een nieuw bericht schrijft er automatisch TrackBacks worden gestuurd naar de betreffende site voor alle links in uw bericht.', # Translate - New
	'Enable External TrackBack Auto-Discovery' => 'Externe automatische TrackBack-ontdekking inschakelen',
	'Setting Notice' => 'Opmerking bij deze instelling',
	'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Opmerking: Bovenstaande optie kan beïnvloed zijn omdat uitgaande pings op systeemniveau beperkt zijn.',
	'Setting Ignored' => 'Instelling genegeerd',
	'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Opmerking: bovenstaande optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau uitgeschakeld zijn.',
	'Enable Internal TrackBack Auto-Discovery' => 'Interne automatische TrackBack-ontdekking inschakelen',

## tmpl/cms/edit_ping.tmpl
	'The TrackBack has been approved.' => 'De TrackBack is goedgekeurd.',
	'List &amp; Edit TrackBacks' => 'TrackBacks tonen &amp; bewerken',
	'View Entry' => 'Bericht bekijken',
	'TrackBack Marked as Spam' => 'TrackBack gemarkeerd als spam', # Translate - New
	'Junk' => 'Spam',
	'View all TrackBacks with this status' => 'Alle TrackBacks met deze status bekijken',
	'Source Site:' => 'Bronsite:',
	'Search for other TrackBacks from this site' => 'Andere TrackBacks van deze site zoeken',
	'Source Title:' => 'Brontitel:',
	'Search for other TrackBacks with this title' => 'Andere TrackBacks met deze titel zoeken',
	'Search for other TrackBacks with this status' => 'Andere TrackBacks met deze status zoeken',
	'Target Entry:' => 'Doelbericht:',
	'No title' => 'Geen titel',
	'View all TrackBacks on this entry' => 'Alle TrackBacks op dit bericht bekijken',
	'Target Category:' => 'Doelcategorie:',
	'Category no longer exists' => 'Categorie bestaat niet meer',
	'View all TrackBacks on this category' => 'Alle TrackBacks op deze categorie bekijken',
	'View all TrackBacks created on this day' => 'Bekijk alle TrackBacks aangemaakt op deze dag', # Translate - New
	'View all TrackBacks from this IP address' => 'Alle TrackBacks van dit IP adres bekijken',
	'Save this TrackBack (s)' => 'Deze TrackBack opslaan (s)',
	'Delete this TrackBack (x)' => 'Verwijder deze TrackBack (x)',

## tmpl/cms/cfg_plugin.tmpl
	'Plugin Settings: System-wide' => 'Plugin-instellingen: over heel het systeem', # Translate - New
	'Six Apart Plugin Directory' => 'Six Apart Plugin Directory', # Translate - New
	'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Via dit scherm kunt u de instellingen per weblog beheren van alle configureerbare plugins die u heeft geïnstalleerd.',
	'Your plugin settings have been saved.' => 'Uw plugin-instellingen zijn opgeslagen.',
	'Your plugin settings have been reset.' => 'Uw plugin-instellingen zijn teruggezet op de standaardwaarden.',
	'Your plugins have been reconfigured.' => 'Uw plugins zijn opnieuw geconfigureerd.',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => '
    Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl draait, moet u uw webserver opnieuw starten om de wijzigingen van kracht te maken.',
	'_USAGE_PLUGINS' => 'Dit is een lijst van alle plugins die momenteel in Movable Type geregistreerd zijn.',
	'Are you sure you want to reset the settings for this plugin?' => 'Bent u zeker dat u de instellingen voor deze plugin wil terugzetten naar de standaardwaarden?',
	'Disable plugin system?' => 'Plugin-systeem uitschakelen?',
	'Disable this plugin?' => 'Deze plugin uitschakelen?',
	'Enable plugin system?' => 'Plugin-systeem inschakelen?',
	'Enable this plugin?' => 'Deze plugin inschakelen?',
	'Disable Plugins' => 'Plugins uitschakelen',
	'Enable Plugins' => 'Plugins inschakelen',
	'Failed to Load' => 'Laden mislukt',
	'Disable' => 'Uitschakelen',
	'Enabled' => 'Ingeschakeld',
	'Enable' => 'Inschakelen',
	'Documentation for [_1]' => 'Documentatie voor [_1]',
	'Documentation' => 'Documentatie',
	'Author of [_1]' => 'Auteur van [_1]',
	'More about [_1]' => 'Meer over [_1]',
	'Plugin Home' => 'Homepage van deze plugin',
	'Show Resources' => 'Bronnen weergeven',
	'Run [_1]' => '[_1] uitvoeren',
	'Show Settings' => 'Instellingen tonen',
	'Settings for [_1]' => 'Instellingen voor [_1]',
	'Resources Provided by [_1]' => 'Bronnen voorzien door [_1]',
	'Tag Attributes' => 'Eigenschappen tag',
	'Text Filters' => 'Tekstfilters',
	'Junk Filters' => 'Spamfilters',
	'[_1] Settings' => '[_1] instellingen',
	'Reset to Defaults' => 'Terugzetten naar standaardwaarden',
	'Plugin error:' => 'Pluginfout:',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be 100% functional. Furthermore, it will require an upgrade once you have upgraded to the next Movable Type major release (when available).' => 'Deze plugin is niet bijgewerkt om Movable Type [_1] te ondersteunen.  Om die reden kan het zijn dat hij niet voor 100% werkt.  Bovendien zal er een upgrade nodig zijn wanneer u een upgrade uitvoert naar de volgende major versie van Movable Type (wanneer die beschikbaar komt).', # Translate - New
	'No plugins with weblog-level configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd die configuratie-opties hebben op weblogniveau.',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Map bewerken', # Translate - New
	'Use this page to edit the attributes of the folder [_1]. You can set a description for your folder to be used in your public pages, as well as configuring the TrackBack options for this folder.' => 'Gebruik deze pagina om de eigenschappen van de map [_1] te bewerken.  U kunt een beschrijving van de map instellen die gebruikt wordt op publieke pagina\'s en u kunt eveneens de TrackBack opties voor deze map instellen.', # Translate - New
	'Your folder changes have been made.' => 'De wijzigingen aan de map zijn uitgevoerd.', # Translate - New
	'You must specify a label for the folder.' => 'U moet een naam opgeven voor de map', # Translate - New
	'Label' => 'Naam',
	'Save this folder (s)' => 'Deze map opslaan (s)', # Translate - New

## tmpl/cms/bookmarklets.tmpl
	'Configure QuickPost' => 'QuickPost instellen',
	'_USAGE_BOOKMARKLET_1' => 'Door QuickPost te installeren op uw browser kunt u berichten met één klik toevoegen aan uw weblog zonder langs de hoofdinterface van Movable Type te moeten gaan.',
	'_USAGE_BOOKMARKLET_2' => 'De manier waarop QuickPost van Movable Type gestructureerd is, maakt het mogelijk om de lay-out en velden van uw QuickPost-pagina aan te passen. U wilt misschien de mogelijkheid toevoegen om uittreksels toe te voegen via het . Standaard heeft een QuickPost-venster altijd een uitklapmenu met de weblogs waarop u kunt publiceren; een uitklapmenu om de publicatiestatus van het nieuwe bericht te selecteren (\'Concept\' of \'Publiceren\'); een tekstvak voor de titel van het bericht; en een tekstvak voor de tekst van het bericht.',
	'Include:' => 'Opnemen:',
	'TrackBack Items' => 'TrackBack items',
	'Allow Comments' => 'Reacties toestaan',
	'Allow TrackBacks' => 'TrackBacks toestaan',
	'Create QuickPost' => 'QuickPost aanmaken', # Translate - New
	'_USAGE_BOOKMARKLET_3' => 'Als u het Movable Type QuickPost-bookmark wilt installeren, sleept u de volgende link naar de werkbalk Favorieten in het menu van uw browser.',
	'_USAGE_BOOKMARKLET_5' => 'Als alternatief kunt u, als u Internet Explorer onder Windows gebruikt, een \'QuickPost\'-optie installeren in het Windows-menu dat verschijnt wanneer u met de rechtermuisknop klikt in Explorer. Klik op de link hieronder en accepteer de vraag van de browser om het bestand te \'Openen\'. Vervolgens sluit en herstart u uw browser om de link toe te voegen aan het menu dat verschijnt wanneer u met de rechtermuisknop klikt in uw browser.',
	'Add QuickPost to Windows right-click menu' => 'QuickPost toevoegen aan het Windows-menu dat verschijnt als u op de rechtermuisknop klikt',
	'_USAGE_BOOKMARKLET_4' => 'Na het installeren van QuickPost, kunt u publiceren vanaf elke locatie op het web. Als u een pagina bekijkt waarover u een bericht wilt schrijven, klikt u op \'QuickPost\' in uw werkbalk \'Favorieten\' om een pop-upvenster te openen met een speciaal Movable Type-bewerkingsvenster. In dit venster kunt u een weblog selecteren waar u het bericht op wilt publiceren en vervolgens uw bericht invoeren en publiceren.',

## tmpl/cms/backup.tmpl
	'What to backup' => 'Wat moet gebackupt worden?', # Translate - New
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Deze optie zal een backup maken van gebruikers, rollen, associaties, blogs, berichten, categorieën, sjablonen en tags.', # Translate - New
	'Everything' => 'Alles', # Translate - New
	'Choose blogs to backup' => 'Kies de blogs die gebackupt moeten worden', # Translate - New
	'Type of archive format' => 'Type archiefformaat', # Translate - New
	'The type of archive format to use.' => 'Soort archiefformaat om te gebruiken', # Translate - New
	'tar.gz' => 'tar.gz', # Translate - New
	'zip' => 'zuo', # Translate - New
	'Don\'t compress' => 'Niet comprimeren', # Translate - New
	'Number of megabytes per file' => 'Aantal megabyte per bestand', # Translate - New
	'Approximate file size per backup file.' => 'Bestandsgrootte bij benadering per backupbestand', # Translate - New
	'Don\'t Divide' => 'Niet opsplitsen', # Translate - New
	'Make Backup' => 'Backup maken', # Translate - New
	'Make Backup (b)' => 'Backup maken (b)', # Translate - New

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Instellingen webservices', # Translate - New
	'Services' => 'Services', # Translate - New
	'TypeKey Setup' => 'TypeKey instellingen', # Translate - New
	'Recently Updated Key' => 'Recent bijgewerkt sleutel', # Translate - New
	'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Als u een \'Recent bijgewerkt\' sleutel heeft ontvangen (door uw aankoop), vul die dan hier in.',
	'External Notifications' => 'Externe notificaties', # Translate - New
	'Notify the following sites upon blog updates' => 'Breng volgende sites op de hoogte bij updates aan een blog', # Translate - New
	'When this blog is updated, Movable Type will automatically notify the selected sites.' => 'Wanneer deze weblog wordt bijgewerkt, zal Movable Type automatisch de geselecteerde sites op de hoogte brengen.', # Translate - New
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Opmerking: Deze optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau zijn uitgeschakeld.',
	'Others:' => 'Andere:',
	'(Separate URLs with a carriage return.)' => '(URL\'s van elkaar scheiden met een carriage return.)',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Movable Type terugzetten', # Translate - New

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Categorie bewerken',
	'Use this page to edit the attributes of the category <strong>[_1]</strong>. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Gebruik deze pagina om de attributen van de categorie <strong>[_1]</strong> te bewerken.  U kunt een beschrijving instellen voor uw categorie om te gebruiken in uw publieke pagina\'s en ook de TrackBack opties voor deze categorie.', # Translate - New
	'Your category changes have been made.' => 'Uw categoriewijzigingen zijn gemaakt.',
	'You must specify a label for the category.' => 'U moet een label opgeven voor de categorie.',
	'This is the basename assigned to your category.' => 'Dit is de basisnaam toegekend aan uw categorie', # Translate - New
	'Unlock this category&rsquo;s output filename for editing' => 'De basisnaam van deze categorie bewerkbaar maken', # Translate - New
	'Warning: Changing this category\'s basename may break inbound links.' => 'Waarschuwing: de basisnaam van deze categorie veranderen kan inkomende links verbreken.',
	'Inbound TrackBacks' => 'Inkomende TrackBacks',
	'Accept Trackbacks' => 'TrackBacks aanvaarden', # Translate - Case
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Indien ingeschakeld, zullen TrackBacks voor deze categorie worden aanvaard uit elke bron.',
	'View TrackBacks' => 'TrackBacks bekijken', # Translate - New
	'TrackBack URL for this category' => 'TrackBack URL voor deze categorie',
	'_USAGE_CATEGORY_PING_URL' => 'Dit is de URL die anderen zullen gebruiken om TrackBacks naar uw weblog te sturen.  Als u wenst dat eender wie een TrackBack naar uw weblog kan sturen indien ze een bericht hebben dat specifiek is aan deze categrie, maak deze URL dan bekend.  Als u wenst dat bekenden TrackBacks kunnen sturen, bezorg hen dan deze URL.  Om een lijst van binnengekomen TrackBacks aan uw hoofdindexsjabloon teo te voegen, kijk in de documentatie en zoek naar sjabloontags die te maken hebben met TrackBacks.',
	'Passphrase Protection' => 'Wachtwoordbeveiliging',
	'Outbound TrackBacks' => 'Uitgaande TrackBacks',
	'Trackback URLs' => 'TrackBack URL\'s', # Translate - New
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Vul de URL(s) in van de websites waar u een TrackBack naartoe wenst te sturen elke keer u een bericht aanmaakt in deze categorie.  (Splits URL\'s van elkaar met een carriage return.)', # Translate - New
	'View Category Details' => 'Categoriedetails bekijken', # Translate - New

## tmpl/cms/list_notification.tmpl
	'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => 'Hieronder ziet u de notificatielijst voor deze weblog.  Wanneer u met de hand notificaties verstuurd van gepubliceerde berichten, kunt u uit deze lijst kiezen.',
	'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => 'U heeft [quant,_1,gebruiker,gebruikers,geen gebruikers] in uw notificatielijst.  Om een adres te verwijderen, kruis het vakje aan en klik op de knop \'Verwijderen\'.',
	'You have added [_1] to your notification list.' => 'U hebt [_1] aan uw notificatielijst toegevoegd.',
	'You have successfully deleted the selected notifications from your notification list.' => 'U hebt de geselecteerde notificaties uit uw notificatielijst verwijderd.',
	'Download Notifications (CSV)' => 'Notificatielijst downloaden (CSV)', # Translate - New
	'notification address' => 'notificatie-adres',
	'notification addresses' => 'notificatie-adressen',
	'Delete selected notification addresses (x)' => 'Verwijder geselecteerde notificatie-adressen (x)',
	'Create New Notification' => 'Nieuwe notificatie aanmaken',
	'URL (Optional):' => 'URL (optioneel):',
	'Add Recipient' => 'Ontvanger toevoegen',

## tmpl/cms/cfg_system_general.tmpl
	'General Settings: System-wide' => 'Algemene instellingen: over heel het systeem', # Translate - New
	'This screen allows you to set system-wide new user defaults.' => 'Op dit scherm kunt u de standaardinstellingen voor nieuwe gebruikers over het hele systeem instellen.',
	'Your settings have been saved.' => 'Uw instellingen zijn opgeslagen.',
	'You must set a valid Default Site URL.' => 'U moet een geldige standaard hoofd-URL voor de site instellen.',
	'You must set a valid Default Site Root.' => 'U moet een geldige standaard weblogmap voor de site instellen.',
	'System Email Settings' => 'Systeem e-mail instellingen', # Translate - New
	'System Email Address' => 'Systeem e-mailadres', # Translate - New
	'The email address used in the From: header of each email sent from the system.  The address is used in password recovery, commenter registration, comment, trackback notification, entry notification and a few other minor events.' => 'Het e-mail adres gebruikt in de From: hader van elke e-mail verstuurd door het systeem.  Dit adres wordt gebruikt bij het terugvinden van wachtwoorden, registratie van reageerders, trackback- en berichtnotificaties en een aantal andere, minder belangrijke gebeurtenissen.', # Translate - New
	'New User Defaults' => 'Standaardinstellingen nieuwe gebruikers',
	'Personal weblog' => 'Persoonlijke weblog',
	'Check to have the system automatically create a new personal weblog when a user is created in the system. The user will be granted a blog administrator role on the weblog.' => 'Kruis dit aan om het systeem automatisch een nieuwe persoonlijke weblog te laten aanmaken wanneer er een gebruiker wordt aangemaakt in het systeem.  De gebruiker zal de rol van blogadministrator krijgen op de weblog.',
	'Automatically create a new weblog for each new user' => 'Automatisch een nieuwe weblog aanmaken voor elke nieuwe gebruiker',
	'Personal weblog clone source' => 'Kloonbron persoonlijke weblog',
	'Select a weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Selecteer een weblog die u wenst te gebruiken als voorbeeld voor nieuwe persoonlijke weblogs.  De nieuwe weblog zal identiek zijn aan het voorbeeld, met uitzondering van de naam, publicatiepaden en permissies.',
	'Default Site URL' => 'Standaard URL van de site',
	'Define the default site URL for new weblogs. This URL will be appended with a unique identifier for the weblog.' => 'Stel de standaard URL in voor nieuwe weblogs.  Aan deze URL zal een unieke identificatie worden toegevoegd voor de weblog.',
	'Default Site Root' => 'Standaard hoofdmap van de site',
	'Define the default site root for new weblogs. This path will be appended with a unique identifier for the weblog.' => 'Stel de standaard hoofdmap in voor nieuwe weblogs.  Aan dit pad zal een unieke identificatie worden toegevoegd voor de weblog.',
	'Default User Language' => 'Standaard taal',
	'Define the default language to apply to all new users.' => 'Stel de standaard taal in voor nieuwe gebruikers',
	'Default Timezone' => 'Standaard tijdzone', # Translate - New
	'Default Tag Delimiter' => 'Standaard tagscheidingsteken', # Translate - New
	'Define the default delimiter for entering tags.' => 'Stel het standaard teken in om tags van elkaar te onderscheiden bij het invoeren.',

## tmpl/cms/dashboard.tmpl
	'Loading recent entries...' => 'Recente berichten aan het laden...', # Translate - New
	'This is you' => 'Dit bent u', # Translate - New
	'Your <a href="[_1]">last post</a> was [_2].' => 'Uw <a href="[_1]">laatste bericht</a> was [_2].', # Translate - New
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'U heeft <a href="[_1]">[quant,_2,kladbericht, kladberichten]</a>.', # Translate - New
	'You\'ve written <a href=\"[_1]\">[quant,_2,post,posts]</a> with <a href=\"[_3]\">[quant,_4,comment,comments]</a>' => 'U heeft <a href=\"[_1]\">[quant,_2,bericht,berichten]</a> geschreven met <a href=\"[_3]\">[quant,_4,reactie,reacties]</a>', # Translate - New
	'You\'ve written <a href=\"[_1]\">[quant,_2,post,posts]</a>.' => 'U heeft <a href=\"[_1]\">[quant,_2,bericht,berichten]</a> geschreven.', # Translate - New
	'Handy Shortcuts' => 'Handige snelkoppelingen', # Translate - New
	'Trackbacks' => 'TrackBacks', # Translate - Case
	'News' => 'Nieuws', # Translate - New
	'MT News' => 'MT Nieuws', # Translate - New
	'Learning MT' => 'Learning MT', # Translate - New
	'Hacking MT' => 'Hacking MT', # Translate - New
	'Pronet' => 'Pronet', # Translate - New
	'No Movable Type news available.' => 'Geen Movable Type nieuws beschikbaar.', # Translate - New
	'No Learning Movable Type news available.' => 'Geen Learning Movable Type nieuws beschikbaar.', # Translate - New
	'You have attempted to access a page that does not exist. Please navigate to the page you are looking for starting from the dashboard.' => 'U heeft geprobeerd een pagina te bereiken die niet bestaat.  Gelieve te proberen de pagina die u zoekt via het dashboard te bereiken.', # Translate - New
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'U heeft geprobeerd een optie te gebruiken waar u niet voldoende rechten voor heeft.  Als u gelooft dat u deze boodschap onterecht te zien krijgt, contacteer dan uw systeembeheerder.', # Translate - New
	'Movable Type was unable to locate your \'mt-static\' directory. Please configure the \'StaticFilePath\' configuration setting in your mt-config.cgi file, and create a writable \'support\' directory underneath your \'mt-static\' directory.' => 'Movable Type kon uw \'mt-static\' map niet vinden.  Gelieve de \'StaticFilePath\' directief in uw mt-config.cgi file in te stellen en maak een beschrijfbare \'support\' map aan in uw \'mt-static\' map.', # Translate - New
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type was niet in staat om te schrijven in de \'support\' map.  Gelieve een map aan te maken in deze locatie: [_1] en er genoeg permissies aan toe te kennen zodat de webserver er in kan schrijven.', # Translate - New
	'Blog Stats' => 'Blogstatistieken', # Translate - New
	'Most Recent Comments' => 'Recentste reacties', # Translate - New
	'[_1][_2], [_3] on [_4]' => '[_1][_2], [_3] op [_4]', # Translate - New
	'View all comments' => 'Alle reacties bekijken', # Translate - New
	'No comments available.' => 'Geen reacties beschikbaar', # Translate - New
	'Most Recent Entries' => 'Recentste berichten', # Translate - New
	'...' => '...', # Translate - New
	'View all entries' => 'Alle berichten bekijken', # Translate - New
	'You have <a href=\'[_3]\'>[quant,_1,comment] from [_2]</a>' => 'U heeft <a href=\'[_3]\'>[quant,_1,reactie,reacties] van [_2]</a>', # Translate - New
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'u heeft <a href=\'[_3]\'>[quant,_1,bericht,berichten] van [_2]</a>', # Translate - New

## tmpl/cms/cfg_comments.tmpl
	'Comment Settings' => 'Instellingen voor reacties', # Translate - New
	'Your preferences have been saved.' => 'Uw voorkeuren zijn opgeslagen', # Translate - New
	'Note: Commenting is currently disabled at the system level.' => 'Opmerking: reacties zijn momenteel uitgeschakeld op het systeemniveau.',
	'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'Reactie-authenticatie is niet beschikbaar omdat één van de benodigde modules, MIME::Base64 of LWP::UserAgent niet is geïnstalleerd.  Praat met uw host om de module te doen installeren.',
	'Accept Comments' => 'Reacties aanvaarden',
	'Commenting Policy' => 'Reactiebeleid', # Translate - New
	'Allowed Authentication Methods' => 'Toegelaten authenticatiemethodes', # Translate - New
	'Authentication Not Enabled' => 'Authenticatie is niet ingeschakeld',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Opmerking: u heeft ervoor gekozen om enkel reacties te aanvaarden van geauthenticeerde reageerders, maar authenticatie is niet ingeschakeld.  Om geauthenticeerde reacties te kunnen ontvangen, moet u authenticatie inschakelen.',
	'Native' => 'Ingebouwd', # Translate - New
	'Require E-mail Address for Comments via TypeKey' => 'E-mail adres vereisen voor reacties via TypeKey', # Translate - New
	'If enabled, visitors must allow their TypeKey account to share e-mail address when commenting.' => 'Indien ingeschakeld, moeten bezoekers hun TypeKey account toestaan om hun e-mail adres vrij te geven bij het reageren.', # Translate - New
	'Setup other authentication services' => 'Alle authenticatiediensten instellen', # Translate - New
	'Immediately approve comments from' => 'Onmiddellijk reacties goedkeuren van', # Translate - New
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Instellen wat er moet gebeuren met reacties nadat ze zijn ingevoerd.  Niet gekeurde reacties worden bewaard voor latere moderatie.', # Translate - New
	'No one' => 'Niemand',
	'Trusted commenters only' => 'Enkel vertrouwde reageerders',
	'Any authenticated commenters' => 'Elke geauthenticeerde reageerder',
	'Anyone' => 'Iedereen',
	'Allow HTML' => 'HTML toestaan',
	'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Indien ingeschakeld zullen gebruikers een beperkte set HTML tags kunnen gebruiken in hun reacties.  Indien niet zal alle HTML verwijderd worden.',
	'Limit HTML Tags' => 'HTML tags beperken', # Translate - New
	'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Geeft een lijst met HTML-tags op die standaard zijn toegestaan wanneer een HTML-string wordt schoongemaakt (bijv. een reactie).',
	'Use defaults' => 'Standaardwaarden gebruiken',
	'([_1])' => '([_1])',
	'Use my settings' => 'Mijn instellingen gebruiken',
	'Disable \'nofollow\' for trusted commenters' => '\'nofollow\' uitschakelen voor vertrouwde reageerders', # Translate - New
	'If enabled, the \'nofollow\' link relation will not be applied to any comments left by trusted commenters.' => 'Indien ingeschakeld, dan zal de \'nofollow\' linkrelatie niet worden toegepast op links in reacties achtergelaten door vertrouwde reageerders.', # Translate - New
	'Specify when Movable Type should notify you of new comments if at all.' => 'Geef aan wanneer Movable Type u op de hoogte moet brengen van reacties, indien gewenst.',
	'Comment Order' => 'Volgorde reacties', # Translate - New
	'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u reacties van bezoekers wilt weergeven in oplopende (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
	'Ascending' => 'Oplopend',
	'Descending' => 'Aflopend',
	'Auto-Link URLs' => 'Automatisch URL\'s omzetten in links',
	'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Indien ingeschakeld zullen alle URLs die nog geen link zijn automatisch omgezet worden in links naar die URL.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Geeft weer welke tekstopmaakoptie moet worden gebruikt voor de opmaak van reacties van bezoekers.',
	'Use Comment Confirmation Page' => 'Reactiebevestigingspagina gebruiken', # Translate - New

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Blog aanmaken', # Translate - New
	'From this screen you can specify the basic information needed to create a blog.  Once you click the save button, your blog will be created and you can continue to customize its settings and templates, or just simply start creating entries.' => 'Vanop dit scherm kunt u de basisgegevens instellen die nodig zijn om een blog aan te maken.  Zodra u op de knop \'Opslaan\' klikt, zal uw blog worden aangemaakt en kunt u verder gaan met het personaliseren van de instellingen en sjablonen of kunt u meteen beginnen met berichten opstellen.', # Translate - New
	'Your blog configuration has been saved.' => 'Uw blogconfiguratie is opgeslagen', # Translate - New
	'You must set your Weblog Name.' => 'U dient een weblognaam in te stellen.',
	'You must set your Site URL.' => 'U dient de URL van uw site in te stellen.',
	'Your Site URL is not valid.' => 'De URL van uw site is niet geldig.',
	'You can not have spaces in your Site URL.' => 'Er mogen geen spaties in de URL van uw site zitten.',
	'You can not have spaces in your Local Site Path.' => 'Er mogen geen spaties in het locale pad van uw site.',
	'Your Local Site Path is not valid.' => 'Het lokale pad van uw site is niet geldig.',
	'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html). Example: http://www.example.com/weblog/' => 'Vul de URL in van uw publieke website.  Laat de bestandsnaam weg (m.a.w. laat index.html weg).  Voorbeeld: http://www.voorbeeld.com/blog/', # Translate - New
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'Vul het pad in waar uw hoofdindexbestand zich zal bevingen.  Een absoluut pad (dat begint met \'/\') verdient de voorkeur, maar u kunt ook een pad gebruiken relatief aan de Movable Type map.  Voorbeeld: /home/melody/public_html/weblog', # Translate - New

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Database wordt geïnitialiseerd...',
	'Upgrading database...' => 'Database wordt bijgewerkt...',
	'Installation complete.' => 'Installatie voltooid.',
	'Upgrade complete.' => 'Upgrade voltooid.',
	'Starting installation...' => 'Instalatie gaat van start...',
	'Starting upgrade...' => 'Upgrade gaat van start...',
	'Error during installation:' => 'Fout tijdens installatie:',
	'Error during upgrade:' => 'Fout tijdens upgrade:',
	'Installation complete!' => 'Installatie voltooid!',
	'Upgrade complete!' => 'Upgrade voltooid!',
	'Login to Movable Type' => 'Aanmelden op Movable Type',
	'Your database is already current.' => 'Uw database is reeds up-to-date.',

## tmpl/cms/edit_commenter.tmpl
	'The commenter has been trusted.' => 'Deze reageerder wordt vertrouwd.',
	'The commenter has been banned.' => 'Deze reageerder is verbannen.',
	'Comments from [_1]' => 'Reacties van [_1]', # Translate - New
	'Trust' => 'Vertrouw',
	'commenters' => 'reageerders',
	'Trust commenter' => 'Reageerder vertrouwen',
	'Untrust' => 'Wantrouw',
	'Untrust commenter' => 'Reageerder wantrouwen',
	'Ban' => 'Verban',
	'Ban commenter' => 'Reageerder verbannen',
	'Unban' => 'Ontbannen',
	'Unban commenter' => 'Reageerder ontbannen',
	'Trust selected commenters' => 'Geselecteerde reageerders vertrouwen',
	'Ban selected commenters' => 'Geselecteerde reageerders verbannen',
	'The Name of the commenter' => 'Naam van de reageerder', # Translate - New
	'View all comments with this name' => 'Alle reacties met deze naam bekijken',
	'The Identity of the commenter' => 'De identiteit van de reageerder', # Translate - New
	'The Email of the commenter' => 'De e-mail van de reageerder', # Translate - New
	'Withheld' => 'Niet onthuld',
	'The URL of the commenter' => 'De URL van de reageerder', # Translate - New
	'View all comments with this URL address' => 'Alle reacties met deze URL bekijken',
	'The trusted status of the commenter' => 'De vertrouwd/niet-vertrouwd status van de reageerder', # Translate - New
	'View all commenters with this status' => 'Alle reageerders met deze status bekijken',

## tmpl/cms/cfg_entry.tmpl
	'Entry Settings' => 'Berichtinstellingen', # Translate - New
	'Display Settings' => 'Toon instellingen', # Translate - New
	'Entries to Display' => 'Berichten om te tonen', # Translate - New
	'Select the number of days\' entries or the exact number of entries you would like displayed on your blog.' => 'Selecteer het aantal dagen waarvan u berichten wenst te tonen op uw blog, of het exacte aantal berichten.', # Translate - New
	'Days' => 'Dagen',
	'Entry Order' => 'Volgorde berichten', # Translate - New
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u uw berichten wenst te tonen in opklimmende (oudste bovenaan) of dalende (nieuwste bovenaan) volgorde.', # Translate - New
	'Excerpt Length' => 'Lengte uittreksel', # Translate - New
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Vul het aantal woorden in dat moet verschijnen in automatisch gegenereerde uittreksels.',
	'Date Language' => 'Datumtaal', # Translate - New
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
	'Basename Length' => 'Lengte basisnaam', # Translate - New
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Bepaalt de standaardlengte van automatisch gegenereerde basisnamen.  Het bereik van deze instelling is tussen 15 en 250.',
	'New Entry Defaults' => 'Standaardinstellingen nieuw bericht',
	'Specifies the default Entry Status when creating a new entry.' => 'Bepaalt de standaardstatus van een nieuw aangemaakt bericht', # Translate - New
	'Specifies the default Text Formatting option when creating a new entry.' => 'Bepaalt de standaard tekstopmaak voor het aanmaken van een nieuw bericht.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Bepaalt de standaardinstelling voor het aanvaarden van nieuwe reacties bij nieuwe berichten.',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties zijn uitgeschakeld op blog- of systeemniveau.', # Translate - New
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Bepaalt de standaardinstelling voor het aanvaarden van nieuwe TrackBacks bij nieuwe berichten.',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat TrackBacks zijn uitgeschakeld op blog- of systeemniveau.', # Translate - New
	'Default Editor Fields' => 'Standaard velden voor de editor', # Translate - New

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'U moet één of meer items selecteren om te vervangen.',
	'_USAGE_SEARCH' => 'U kunt \'zoeken en vervangen\' gebruiken om al uw berichten te doorzoeken of om alle gevallen waar een bepaald woord/zin/teken voorkomt te vervangen door iets anders. BELANGRIJK: wees voorzichtig bij het uitvoeren van een vervanging, omdat <b>ongedaan maken</b> niet mogelijk is. Als u vervangingen aanbrengt in een groot aantal berichten, dan is het wellicht veilig om eerst de functie \'Import/Export\' te gebruiken om een veiligheidskopie van uw berichten te maken.',
	'Search Again' => 'Opnieuw zoeken',
	'Replace' => 'Vervangen', # Translate - New
	'Replace Checked' => 'Aangekruiste items vervangen',
	'Case Sensitive' => 'Hoofdlettergevoelig',
	'Regex Match' => 'Regex-overeenkomst',
	'Limited Fields' => 'Beperkte velden',
	'Date Range' => 'Bereik wissen',
	'Reported as Spam?' => 'Rapporteren als spam?', # Translate - New
	'Search Fields:' => 'Zoekvelden:',
	'E-mail Address' => 'E-mail adres',
	'Source URL' => 'Bron URL',
	'Page Body' => 'Romp van de pagina', # Translate - New
	'Extended Page' => 'Uitgebreide pagina', # Translate - New
	'Text' => 'Tekst',
	'Output Filename' => 'Naam uitvoerbestand',
	'Linked Filename' => 'Naam gelinkt bestand',
	'To' => 'Naar', # Translate - New
	'Replaced [_1] records successfully.' => 'Met succes [_1] items vervangen.',
	'Showing first [_1] results.' => 'Eerste [_1] resultaten worden getoond.',
	'Show all matches' => 'Alle overeenkomsten worden getoond',
	'[quant,_1,result,results] found' => '[quant,_1,resultaat,resultaten] found', # Translate - New
	'No entries were found that match the given criteria.' => 'Er werden geen berichten gevonden die overeenkwamen met de opgegeven criteria.',
	'No comments were found that match the given criteria.' => 'Er werden geen reacties gevonden die overeenkwamen met de opgegeven criteria.',
	'No TrackBacks were found that match the given criteria.' => 'Er werden geen TrackBacks gevonden die overeenkwamen met de opgegeven criteria.',
	'No commenters were found that match the given criteria.' => 'Er werden geen reageerders gevonden die overeenkwamen met de opgegeven criteria.',
	'No pages were found that match the given criteria.' => 'Er werden geen pagina\'s gevonden die overeen kwamen met de opgegeven criteria', # Translate - New
	'No templates were found that match the given criteria.' => 'Er werden geen sjablonen gevonden die overeenkwamen met de opgegeven criteria.',
	'No log messages were found that match the given criteria.' => 'Er werden geen logberichten gevonden die overeenkwamen met de opgegeven criteria.',
	'No users were found that match the given criteria.' => 'Er werden geen gebruikers gevonden die overeenkwamen met de opgegeven criteria.',
	'No weblogs were found that match the given criteria.' => 'Er werden geen weblogs gevonden die overeenkomen met de opgegeven criteria',

## tmpl/cms/export.tmpl
	'_USAGE_EXPORT_1' => 'Het exporteren van uw berichten vanuit Movable Type maakt het mogelijk om <b>persoonlijke back-ups</b> van uw blogberichten te bewaren. Het formaat van de geëxporteerde gegevens is geschikt om weer in het systeem geïmporteerd te worden m.b.v. de importfunctie (hierboven); dus kunt u, behalve het exporteren van uw berichten voor backup-doeleinden, deze functie ook gebruiken om <b>de inhoud te verplaatsen naar verschillende blogs</b>.',
	'Export Entries From [_1]' => 'Berichten exporteren van [_1]',
	'Export Entries (e)' => 'Berichten exporteren (e)',
	'<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Opmerking:</strong> Het Movable Type exportformaat is niet allesomvattend en is niet geschikt om volledige back-ups mee nemen. Zie de Movable Type handleiding voor alle details.</em>',
	'Export Entries to Tangent' => 'Berichten exporteren naar Tangent',
	'_USAGE_EXPORT_3' => 'Door te klikken op de link hieronder worden al uw huidige weblog-berichten naar de Tangent-server geëxporteerd. Dit is normaliter een eenmalige push van uw berichten, die u moet uitvoeren nadat u de extra\'s voor Tangent hebt geïnstalleerd voor Movable Type, maar het mogelijk om dit te doen wanneer u dit wilt.',

## tmpl/cms/list_commenter.tmpl
	'_USAGE_COMMENTERS_LIST' => 'Hier is de lijst met bezoekers die reacties achterlieten op [_1].',
	'The selected commenter(s) has been given trusted status.' => 'De geselecteerde reageerder(s) hebben de status \'vertrouwd\' gekregen.',
	'Trusted status has been removed from the selected commenter(s).' => 'De status van \'vertrouwd\' is van de geselecteerde reageerder(s) afgenomen.',
	'The selected commenter(s) have been blocked from commenting.' => 'De geselecteerde reageerder(s) is de mogelijkheid om te reageren afgenomen.',
	'The selected commenter(s) have been unbanned.' => 'De geselecteerde reageerder(s) mogen terug reageren.',
	'(Showing all commenters.)' => '(Alle reageerders worden getoond.)',
	'Showing only commenters whose [_1] is [_2].' => 'Enkel reageerders waarbij [_1] gelijk is aan [_2] worden getoond.',
	'Commenter Feed' => 'Reageerders-feed',
	'commenters.' => 'reageerders.',
	'commenters where' => 'reageerders met',
	'trusted' => 'vertrouwd',
	'untrusted' => 'niet vertrouwd',
	'banned' => 'verbannen',
	'unauthenticated' => 'niet geauthenticeerd',
	'authenticated' => 'geauthenticeerd',

## tmpl/cms/list_folder.tmpl

## tmpl/cms/list_template.tmpl
	'Edit Templates' => 'Sjablonen bewerken', # Translate - New
	'Index Templates' => 'Index van sjablonen',
	'Archive Templates' => 'Archiefsjablonen',
	'System Templates' => 'Systeemsjablonen',
	'Template Modules' => 'Sjabloonmodules',
	'Template Widgets' => 'Sjabloonwidgets', # Translate - New
	'Indexes' => 'Indexen',
	'Modules' => 'Modules',
	'Blog Publishing Settings' => 'Blogpublicatie-instellingen', # Translate - New
	'template' => 'sjabloon',
	'templates' => 'sjablonen',
	'You have successfully deleted the checked template(s).' => 'Verwijdering van geselecteerde sjabloon/sjablonen is geslaagd.',
	'New Index Template' => 'Nieuw indexsjabloon', # Translate - New
	'New Archive Template' => 'Nieuw archiefsjabloon', # Translate - New
	'New Template Module' => 'Nieuwe sjabloonmodule', # Translate - New
	'New Template Widget' => 'Nieuw sjabloonwidget', # Translate - New
	'No index templates could be found.' => 'Er werden geen indexsjablonen gevonden.',
	'No archive templates could be found.' => 'Er werden geen archiefsjablonen gevonden.',
	'No template modules could be found.' => 'Er werden geen sjabloonmodules gevonden.',
	'No widgets could be found.' => 'Er werden geen widgets gevonden', # Translate - New

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Tijdelijke map configuratie',
	'You should configure you temporary directory settings.' => 'U moet uw instellingen configureren voor de tijdelijke map.',
	'Your TempDir has been successfully configured. Click \'Continue\' below to configure your mail settings.' => 'Uw TempDir is met succes geconfigureerd.  Klik hieronder op \'Doorgaan\' om uw e-mail instellingen te configureren.',
	'[_1] could not be found.' => '[_1] kon niet worden gevonden.',
	'TempDir is required.' => 'TempDir is vereist.',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'Het fysieke pad naar de tijdelijke map.',

## tmpl/wizard/include/footer.tmpl

## tmpl/wizard/include/header.tmpl
	'Configuration Wizard' => 'Configuratiewizard', # Translate - New

## tmpl/wizard/include/copyright.tmpl

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Maak uw eerste blog aan', # Translate - New

## tmpl/wizard/start.tmpl
	'Welcome to Movable Type' => 'Welkom bij Movable Type', # Translate - New
	'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Uw Movable Type configuratiebestand bestaat al.  De wizard kan niet verder gaan als dit bestand al aanwezig is.',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Movable Type vereist dat JavaScript ingeschakeld is in uw browser.  Gelieve het in te schakelen en herlaad deze pagina om opnieuw te proberen.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Deze wizard zal u helpen met het configureren van de basisinstellingen om Movable Type te doen werken.',
	'Error: \'[_1]\' could not be found.  Please move your static files to the directory first or correct the setting if it is incorrect.' => 'Fout: \'[_1]\' werd niet gevonden.  Gelieve uw statische bestanden eerst naar de map te verplaatsen of verander de instelling indien ze niet correct is.', # Translate - New
	'Configure Static Web Path' => 'Statisch webpad instellen', # Translate - New
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets. (The elements that make this page look so pretty!)' => 'Movable Type komt standaard met een map genaamd [_1] die een aantal belangrijke bestanden bevat zoals afbeeldingen, javascriptbestanden en stylesheets.  (De elementen die deze pagina zo mooi maken!)', # Translate - New
	'The [_1] directory is in the main Movable Type directory which this wizard script is also in, but due to the curent server\'s configuration the [_1] directory is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory, where your published website exists).' => 'De [_1] map bevindt zich in de hoofd Movable Type map waarin ook het wizard script zich bevindt, maar door de huidige configuratie van de server is de [_1] map niet toegankelijk vanop z\'n huidige locatie en moet hij verplaatst worden naar een web-toegankelijke locatie (m.a.w. in uw web document root directory, waar uw gepubliceerde website(s) zich bevinden).', # Translate - New
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Deze map is ofwel van naam veranderd of is verplaatst naar een locatie buiten de Movable Type map.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Zodra de [_1] map verplaatst is naar een web-toegankelijke plaats, geef dan de locatie ervan hieronder op.', # Translate - New
	'This URL path can be in the form of [_1] or simply [_2]' => 'Dit URL pad kan in de vorm zijn van [_1] of eenvoudigweg [_2]', # Translate - New
	'Static web path' => 'Pad voor statische bestanden', # Translate - Case
	'Begin' => 'Start!',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Database configuratie',
	'You must set your Database Path.' => 'U moet uw databasepad instellen.',
	'You must set your Database Name.' => 'U moet de naam van uw database instellen.',
	'You must set your Username.' => 'U moet uw gebruikersnaam instellen.',
	'You must set your Database Server.' => 'U moet uw database server instellen.',
	'Your database configuration is complete.' => 'Uw databaseconfiguratie is voltooid.', # Translate - New
	'You may proceed to the next step.' => 'U kunt verder gaan naar de volgende stap.', # Translate - New
	'Please enter the parameters necessary for connecting to your database.' => 'Gelieve de parameters in te vullen die nodig zijn om met uw database te verbinden.', # Translate - New
	'Show Current Settings' => 'Huidige instellingen tonen', # Translate - New
	'Database Type' => 'Databasetype', # Translate - New
	'Select One...' => 'Selecteer er één...',
	'If your database type is not listed in the menu above, then you need to <a target="help" href="[_1]">install the Perl module necessary to connect to your database</a>.  If this is the case, please check your installation and <a href="#" onclick="[_2]">re-test your installation</a>.' => '
	Als uw databasetype niet voorkomt in het menu hierboven, dan moet u <a target="help" href="[_1]">de Perl module installeren die nodig is om te verbinden met uw databasee</a>.  Indien dit het geval is, gelieve dan uw installatie na te kijken en <a href="#" onclick="[_2]">test uw installatie opnieuw</a>.', # Translate - New
	'Database Path' => 'Databasepad',
	'The physical file path for your SQLite database. ' => 'Het fysieke bestandspad voor uw SQLite database', # Translate - New
	'A default location of \'./db/mt.db\' will store the database file underneath your Movable Type directory.' => 'Een standaardlocatie van \'./db/mt.db\' zal het databasebestadn opslaan onder uw Movable Type map.', # Translate - New
	'Database Server' => 'Databaseserver',
	'This is usually \'localhost\'.' => 'Dit is meestal \'localhost\'.',
	'Database Name' => 'Databasenaam',
	'The name of your SQL database (this database must already exist).' => 'De naam van uw SQL database (deze database moet al bestaan).',
	'The username to login to your SQL database.' => 'De gebruikersnaam om in te loggen op uw SQL database.',
	'The password to login to your SQL database.' => 'Het wachtwoord om in te loggen op uw SQL database.',
	'Show Advanced Configuration Options' => 'Geavanceerde configuratieopties tonen', # Translate - New
	'Database Port' => 'Databasepoort',
	'This can usually be left blank.' => 'Dit kan meestal leeg blijven.',
	'Database Socket' => 'Databasesocket',
	'Publish Charset' => 'Karakterset voor publicatie',
	'MS SQL Server driver must use either Shift_JIS or ISO-8859-1.  MS SQL Server driver does not support UTF-8 or any other character set.' => 'De MS SQL Server driver heeft ofwel Shift_JIS of ISO-8859-1 nodig.  De MS SQL Server driver ondersteunt noch UTF-8 noch een andere karakterset.',
	'Test Connection' => 'Verbinding testen',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'E-mail instellingen',
	'Your mail configuration is complete.' => 'Uw mailconfiguratie is volledig', # Translate - New
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Controleer uw e-mail om te bevestigen of uw een testmail van Movable Type heeft ontvangen en ga dan verder naar de volgende stap.', # Translate - New
	'Show current mail settings' => 'Toon alle huidige mailinstellingen', # Translate - New
	'Periodically Movable Type will send email to inform users of new comments as well as other other events. For these emails to be sent properly, you must instruct Movable Type how to send email.' => 'Movable Type zal af en toe e-mail versturen om gebruikers op de hoogte te brengen van nieuwe reacties en andere gebeurtenissen.  Om deze e-mails goed te kunnen versturen, moet u Movable Type vertellen hoe ze verstuurd moeten worden.', # Translate - New
	'An error occurred while attempting to send mail: ' => 'Er deed zich een fout voor toen er werd geprobeerd e-mail te verzenden: ',
	'Send email via:' => 'Stuur e-mail via', # Translate - New
	'sendmail Path' => 'sendmail pad', # Translate - New
	'The physical file path for your sendmail binary.' => 'Het fysieke bestandspad van uw sendmail binary', # Translate - New
	'Outbound Mail Server (SMTP)' => 'Uitgaande mailserver (SMTP)', # Translate - New
	'Address of your SMTP Server.' => 'Adres van uw SMTP server.', # Translate - New
	'Mail address for test sending' => 'E-mail adres om een testmail te sturen',
	'Send Test Email' => 'Verstuur testbericht',

## tmpl/wizard/complete.tmpl
	'Config File Created' => 'Configuratiebestand aangemaakt', # Translate - New
	'You selected to create the mt-config.cgi file manually, however it could not be found. Please cut and paste the following text into a file called \'mt-config.cgi\' into the root directory of Movable Type (the same directory in which mt.cgi is found).' => 'U koos om het mt-config.cgi bestand met de hand aan te maken, maar het kon echter niet gevonden worden.  Gelieve volgend stuk tekst te knippen en te plakken in een bestand met de naam \'mt-config.cgi\' in de hoofdmap van Movable Type (dezelfde map waarin mt.cgi zich bevindt)', # Translate - New
	'If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Als u de permissies van de map wenst te controleren en daarna opnieuw wenst te proberen, klik dan op de \'Opnieuw\' knop.',
	'We were unable to create your Movable Type configuration file. This is most likely the result of a permissions problem. To resolve this problem you will need to make sure that your Movable Type home directory (the directory that contains mt.cgi) is writable by your web server.' => 'Het was niet mogelijk om uw Movable Type configuratiebestand aan te maken.  Dit lag waarschijnlijk aan een permissieprobleem.  Om dit probleem op te lossen moet u ervoor zorgen dat uw Movable Type hoofdmap (de map waar mt.cgi zich bevindt) beschrijfbaar is door de webserver.', # Translate - New
	'Congratulations! You\'ve successfully configured [_1].' => 'Proficiat! U heeft met succes [_1] geconfigureerd.', # Translate - New
	'Your configuration settings have been written to the file <tt>[_1]</tt>. To reconfigure them, click the \'Back\' button below.' => 'Uw configuratie-instellingen zijn geggeschreven naar het bestand <tt>]_1]</tt>.  Om ze opnieuw in te stellen, klik op de \'Terug\' knop hieronder.', # Translate - New
	'I will create the mt-config.cgi file manually.' => 'Ik zal het mt-config.cgi bestand met de hand aanmaken.', # Translate - New
	'Retry' => 'Opnieuw',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Controle systeemvereisten',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'Volgende Perl modules zijn vereist om een databaseconnectie te kunnen maken.  Movable Type heeft een database nodig om de gegevens van uw weblog in op te slaan.  Gelieve één van de packages hieronder te installeren om verder te kunnen gaan.  Wanneer u klaar bent, klik dan op de knop \'Opnieuw\'.', # Translate - New
	'All required Perl modules were found.' => 'Alle vereiste Perl modules werden gevonden', # Translate - New
	'You are ready to proceed with the installation of Movable Type.' => 'U bent klaar om verder te gaan met de installatie van Movable Type', # Translate - New
	'Note: One or more optional Perl modules could not be found. You may install them now and click \'Retry\' or continue without them. They can be installed at any time if needed.' => 'Opmerking: één of meer optionele Perl modules werden niet gevonden.  U kunt deze nu installeren en dan op \'Opnieuw\' klikken, of verder gaan zonder.  Ze kunnen later op eender welk moment geïnstalleerd worden indien nodig.', # Translate - New
	'<a href="#" onclick="[_1]">Display list of optional modules</a>' => '<a href="#" onclick="[_1]">Toon lijst optionele modules</a>', # Translate - New
	'One or more Perl modules required by Movable Type could not be found.' => 'Eén of meer Perl modules vereist door Movable Type werden niet gevonden.', # Translate - New
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => 'De onderstaande Perl modules zijn nodig voor de werking van Movable Type.  Eens uw systeem aan deze voorwaarden voldoet, klik op de \'Opnieuw\' knop om opnieuw te testen of deze modules geïnstalleerd zijn.',
	'Missing Database Modules' => 'Ontbrekende databasemodules', # Translate - New
	'Missing Optional Modules' => 'Ontbrekende optionele modules', # Translate - New
	'Missing Required Modules' => 'Ontbrekende vereiste modules', # Translate - New
	'Minimal version requirement: [_1]' => 'Minimale versievereisten: [_1]', # Translate - New
	'Learn more about installing Perl modules.' => 'Meer weten over het installeren van Perl modules', # Translate - New
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'Op uw server zijn alle vereiste modules geïnstalleerd; u hoeft geen bijkomende modules te installeren.',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Ontbrekend configuratiebestand',
	'_ERROR_CONFIG_FILE' => 'Uw Movable Type configuratiebestand ontbreekt of kan niet gelezen worden. Gelieve het deel <a href="#">Installation and Configuration</a> van de handleiding van Movable Type te raadplegen voor meer informatie.',
	'Database Connection Error' => 'Databaseverbindingsfout',
	'_ERROR_DATABASE_CONNECTION' => 'Uw database instellingen zijn ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Bekijk het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',
	'CGI Path Configuration Required' => 'CGI-pad configuratie vereist',
	'_ERROR_CGI_PATH' => 'Uw CGIPath configuratieinstelling is ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Gelieve het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding te raadplegen voor meer informatie.',

## tmpl/email/footer-email.tmpl
	'Powered by Movable Type' => 'Aangedreven door Movable Type',

## tmpl/email/commenter_confirm.tmpl
	'Thank you registering for an account to comment on [_1].' => 'Bedankt om een account aan te maken om te kunnen reageren op [_1].',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Voor uw eigen veiligheid en om fraude te vermijden vragen we dat u deze account eerst bevestigt samen met uw e-mail adres.  Eens bevestigd kunt u meteen reageren op [_1].',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Om uw account te bevestigen, moet u op deze link klikken of de URL in uw webbrowser plakken:',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Als u deze account niet heeft aangevraagd, of als u niet wenste te registreren om te kunnen reageren op [_1] dan hoeft u verder niets te doen.',
	'Thank you very much for your understanding.' => 'Wij danken u voor uw begrip.',
	'Sincerely,' => 'Hoogachtend,',

## tmpl/email/verify-subscribe.tmpl
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Bedankt om u in te schrijven voor notificaties over updates van [_1].  Volg onderstaande link om uw inschrijving te bevestigen:',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Indien de link niet klikbaar is, kopiëer en plak hem dan gewoon in uw browser.',

## tmpl/email/recover-password.tmpl
	'_USAGE_FORGOT_PASSWORD_1' => 'U hebt het herstel van uw Movable Type-wachtwoord aangevraagd. Uw wachtwoord is in het systeem gewijzigd; hier is het nieuwe wachtwoord:',
	'_USAGE_FORGOT_PASSWORD_2' => 'Met dit nieuwe wachtwoord moet u zich op Movable Type kunnen aanmelden. Zodra u zich hebt aangemeld, kunt u uw wachtwoord veranderen in iets dat u goed kunt onthouden.',

## tmpl/email/new-ping.tmpl
	'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
	'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
	'Approve this TrackBack' => 'Deze TrackBack goedkeuren',
	'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]).',
	'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).',
	'View this TrackBack' => 'Deze TrackBack bekijken',
	'Report this TrackBack as spam' => 'Deze TrackBack melden als spam',

## tmpl/email/new-comment.tmpl
	'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Een niet gekeurde reactie is binnengekomen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze reactie eerst goedkeuren voor ze op uw site verschijnt.',
	'Approve this comment:' => 'Deze reactie goedkeuren:',
	'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe reactie is gepubliceerd op uw blog [_1], op bericht #[_2] ([_3]).',
	'View this comment' => 'Deze reactie bekijken',
	'Report this comment as spam' => 'Deze reactie melden als spam',

## tmpl/email/notify-entry.tmpl
	'A new post entitled \'[_1]\' has been published to [_2].' => 'Een nieuw bericht getiteld \'[_1]\' is gepubliceerd op [_2].',
	'View post' => 'Bericht bekijken',
	'Post Title' => 'Titel bericht',
	'Message from Sender' => 'Boodschap van de afzender',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'U ontvangt dit bericht omdat u ofwel gekozen hebt om notificaties over nieuw inhoud op [_1] te ontvangen, of de auteur van het bericht dacht dat u misschien wel geïnteresseerd zou zijn.  Als u deze berichten niet langer wenst te ontvangen, gelieve deze persoon te contacteren:',

## tmpl/email/commenter_notify.tmpl
	'This email is to notify you that a new user has successfully registered on the blog \'[_1].\' Listed below you will find some useful information about this new user.' => 'Met dit berichtje laten we u weten dat een nieuwe gebruiker zich heeft geregistreerd op weblog \'[_1].\'.  Hieronder vind u wat nuttige informatie over deze gebruiker.',
	'Full Name' => 'Volledige naam', # Translate - New
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Om deze gebruiker te bekijken of te bewerken, klik op deze link of plak de URL in een webbrowser:',

## tmpl/feeds/login.tmpl
	'Movable Type Activity Log' => 'Movable Type activiteitlog',
	'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

## tmpl/feeds/error.tmpl

## tmpl/feeds/feed_entry.tmpl
	'system' => 'systeem',
	'Untitled' => 'Zonder titel',
	'Unpublish' => 'Publicatie ongedaan maken',
	'More like this' => 'Meer zoals dit',
	'From this blog' => 'Van deze blog',
	'From this author' => 'Van deze auteur',
	'On this day' => 'Op deze dag',

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Bronblog',
	'On this entry' => 'Op dit bericht',
	'By source blog' => 'Volgens bronblog',
	'By source title' => 'Volgens titel bron',
	'By source URL' => 'Volgens URL bron',

## tmpl/feeds/feed_comment.tmpl
	'By commenter identity' => 'Volgens identiteit reageerders',
	'By commenter name' => 'Volgens naam reageerders',
	'By commenter email' => 'Volgens e-mail reageerders',
	'By commenter URL' => 'Volgens URL reageerders',

);

## New words: 6094

1;
