package MT::L10N::nl;
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
    'Movable Type System Check' => 'Movable Type - systeemcontrole',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Deze pagina geeft u informatie over de configuratie van uw systeem en gaat na of u alle vereiste onderdelen hebt om Movable Type uit te kunnen voeren.',
    'System Information:' => 'Systeeminformatie:',
    'Current working directory:' => 'Huidige werkmap:',
    'MT home directory:' => 'MT hoofdmap:',
    'Operating system:' => 'Besturingssysteem:',
    'Perl version:' => 'Perl-versie:',
    'Perl include path:' => 'Perl include-pad:',
    'Web server:' => 'Webserver:',
    '(Probably) Running under cgiwrap or suexec' => 'Wordt (mogelijk) uitgevoerd onder cgiwrap of suexec',
    'Checking for [_1] Modules:' => 'Bezig te controleren op [_1] modules:',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'Enkele van de onderstaande modules zijn vereist door de verschillende opties voor gegevensopslag in Movable Type. Om het systeem te kunnen draaien, moet op uw server minstens DBI en één andere module geïnstalleerd zijn.',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Ofwel is [_1] niet op uw server geïnstalleerd, ofwel is de geïnstalleerde versie te oud, of [_1] vereist een andere module die niet is geïnstalleerd.',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'Op uw server is [_1] niet geïnstalleerd, of [_1] vereist een andere module die niet is geïnstalleerd.',
    'Please consult the installation instructions for help in installing [_1].' => 'Gelieve de installatieinstructies te raadplegen voor hulp bij het installeren van [_1]',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Van de DBD::mysql versie die bij u is geïnstalleerd is geweten dat ze niet compatibel is met Movable Type.  Gelieve de huidige release te installeren van CPAN.',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => 'De $mod is goed geïnstalleerd, maar vereist een bijgewerkte DBI module. Zie ook de opmerking hierboven over vereisten voor de DBI module.',
    'Your server has [_1] installed (version [_2]).' => 'Op uw server is [_1] geïnstalleerd (versie [_2]).',
    'Movable Type System Check Successful' => 'De systeemcontrole van Movable Type is geslaagd',
    'You\'re ready to go!' => 'U kunt nu beginnen!',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'Alle vereiste modules zijn op uw server geïnstalleerd; u hoeft geen verdere modules te installeren. Ga verder met de volgende stappen in de installatie.',

    ## ./search_templates/default.tmpl
    'Search Results' => 'Zoekresultaten',
    'Search this site:' => 'Zoeken op deze site:',
    'Search' => 'Zoek',
    'Match case' => 'Kleine letters en hoofdletters moeten overeen komen',
    'Regex search' => 'Zoeken met reguliere expressies',
    'Search Results from' => 'Zoekresultaten van',
    'Posted in [_1] on [_2]' => 'Gepubliceerd in [_1] op [_2]',
    'Searched for' => 'Gezocht naar',
    'No pages were found containing "[_1]".' => 'Er werden geen pagina\'s gevonden met "[_1]" er in.',
    'Instructions' => 'Gebruiksaanwijzing',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Normaal kijkt deze zoekmachine naar alle woorden in eender welke volgorde.  Om naar een exacte uitdrukking te zoeken, moet u ze tussen aanhalingstekens te plaatsen:',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'De zoekmachine ondersteunt ook AND, OR, en NOT sleutelwoorden om booleaanse expressies mee aan te geven:',
    'personal OR publishing' => 'persoonlijk OR publicatie',
    'publishing NOT personal' => 'publiceren NOT persoonlijk',

    ## ./search_templates/comments.tmpl
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
    'Posted in ' => 'Gepubliceerd in ',
    'on' => 'op',
    'No results found' => 'Geen resultaten gevonden',
    'No new comments were found in the specified interval.' => 'Geen nieuwe reacties gevonden in het opgegeven interval.',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Selecteer het tijdsinterval waarin u wenst te zoeken en klik dan op \'Nieuwe reacties zoeken\'',

    ## ./tools/l10n/trans.pl

    ## ./tools/l10n/diff.pl

    ## ./tools/l10n/wrap.pl

    ## ./default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'Fout bij indienen reactie',
    'Your comment submission failed for the following reasons:' => 'Het indienen van uw reactie mislukte omwille van volgende redenen:',

    ## ./default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'Pagina niet gevonden',

    ## ./default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': Discussie over [_1]',
    'Trackbacks: [_1]' => 'Trackbacks: [_1]', # Translate
    'TrackBack' => 'TrackBack', # Translate
    'TrackBack URL for this entry:' => 'TrackBack URL van dit bericht:',
    'Listed below are links to weblogs that reference' => 'Hieronder ziet u de weblogs die verwijzen naar',
    'from' => 'van',
    'Read More' => 'Meer lezen',
    'Tracked on [_1]' => 'Getracked op [_1]',
    'Search this blog:' => 'Deze weblog doorzoeken:',
    'Recent Posts' => 'Recente berichten',
    'Subscribe to this blog\'s feed' => 'Inschrijven op de feed van deze weblog',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate
    'What is this?' => 'Wat is dit?',
    'Creative Commons License' => 'Creative Commons Licentie',
    'This weblog is licensed under a' => 'Deze weblog valt onder een licentie van het type',

    ## ./default_templates/individual_entry_archive.tmpl
    'Main' => 'Hoofdpagina',
    'Posted by [_1] on [_2]' => 'Gepubliceerd door [_1] om [_2]',
    'Permalink' => 'Permalink', # Translate
    'Tracked on' => 'Getracked op',
    'Comments' => 'Reacties',
    'Posted by:' => 'Geplaatst door:',
    'Post a comment' => 'Reageer',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Als u hier nog nooit gereageerd heeft, kan het zijn dat de eigenaar van deze site eerst goedkeuring moet geven voordat uw reactie verschijnt. Eerder zal uw reactie niet zichtbaar zijn onder het bericht. Bedankt voor uw geduld.)',
    'Name:' => 'Naam:',
    'Email Address:' => 'E-mailadres:',
    'URL:' => 'URL:', # Translate
    'Remember personal info?' => 'Persoonijke gegevens onthouden?',
    'Comments:' => 'Reacties:',
    '(you may use HTML tags for style)' => '(u kunt HTML tags gebruiken voor de opmaak)',
    'Preview' => 'Voorbeeld',
    'Post' => 'Publiceren',

    ## ./default_templates/main_index.tmpl
    'Continue reading' => 'Verder lezen',
    'Posted by [_1] at [_2]' => 'Gepubliceerd door [_1] om [_2]',
    'TrackBacks' => 'TrackBacks', # Translate
    'Categories' => 'Categorieën',
    'Archives' => 'Archieven',

    ## ./default_templates/dynamic_site_bootstrapper.tmpl

    ## ./default_templates/datebased_archive.tmpl
    'Posted by' => 'Gepubliceerd door',
    'at' => 'om',

    ## ./default_templates/uploaded_image_popup_template.tmpl

    ## ./default_templates/category_archive.tmpl

    ## ./default_templates/search_results_template.tmpl

    ## ./default_templates/master_archive_index.tmpl
    ': Archives' => ': Archieven',

    ## ./default_templates/atom_index.tmpl

    ## ./default_templates/rsd.tmpl

    ## ./default_templates/stylesheet.tmpl

    ## ./default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'Bedankt om uzelf aan te melden,',
    '. Now you can comment. ' => '. Nu kunt u reageren. ',
    'sign out' => 'afmelden',
    'You are not signed in. You need to be registered to comment on this site.' => 'U bent niet aangemeld.  U moet geregistreerd zijn om te kunnen reageren op deze website.',
    'Sign in' => 'Aanmelden',
    'If you have a TypeKey identity, you can' => 'Als u een TypeKey identiteit heeft, kunt u',
    'sign in' => 'zich aanmelden',
    'to use it here.' => 'om ze hier te gebruiken.',

    ## ./default_templates/comment_preview_template.tmpl
    'Comment on' => 'Reageer op',
    'Previewing your Comment' => 'U ziet een voorbeeld van uw reactie',
    'Anonymous' => 'Anoniem',
    'Cancel' => 'Annuleren',

    ## ./default_templates/rss_20_index.tmpl

    ## ./default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'Hangende reactie',
    'Thank you for commenting.' => 'Bedankt voor uw reactie.',
    'Your comment has been received and held for approval by the blog owner.' => 'Uw reactie is ontvangen en zal worden bewaard tot de eigenaar van deze weblog goedkeuring geeft voor publicatie.',
    'Return to the original entry' => 'Terugkeren naar het oorspronkelijke bericht',

    ## ./lib/MT/default-templates.pl

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => 'Voegt een \'nofollow\' relatie toe aan hyperlinks van reacties en TrackBacks om spam te verminderen.',
    'Restrict:' => 'Beperken:',
    'Don\'t add nofollow to links in comments by authenticated commenters' => 'Geen nofollow links toevoegen aan links in reacties van geauthenticeerde reageerders',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Maak een backup van en zet bestaande sjablonen terug naar de standaardsjablonen van Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Backup nemen en sjablonen herstellen',
    'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
    'Return' => 'Terug',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module voor het modereren en verwerpen van feedback door middel van sleutelwoord-filters.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup module voor het gebruik van blacklist-opzoekingsdiensten om feedback te filteren.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Link', # Translate
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module voor het verwerpen en modereren van feedback gebaseerd op linkfilters.',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Linkfilters houden het aantal links in de gaten in binnenkomende feedback.  Feedback met buitengewoon veel links kan worden tegengehouden voor moderatie of als junk worden aangemerkt.  Aan de andere kant kan feedback die geen links bevat of enkel verwijst naar eerder gepubliceerde URLs positief beoordeeld worden. (Schakel deze optie in wanneer u er zeker van bent dat uw site al spamvrij is.).)',
    'Link Limits:' => 'Linkbeperking:',
    'Credit feedback rating when no hyperlinks are present' => 'Ken positieve score toe aan feedback wanneer er geen hyperlinks aanwezig zijn',
    'Adjust scoring' => 'Score aanpassen',
    'Score weight:' => 'Scoregewicht:',
    'Less' => 'Minder',
    'Decrease' => 'Verlaag',
    'Increase' => 'Verhoog',
    'More' => 'Meer',
    'Moderate when more than' => 'Modereer indien meer dan',
    'link(s) are given' => 'link(s) aanwezig zijn',
    'Junk when more than' => 'Verwerp indien meer dan',
    'Link Memory:' => 'Linkgeheugen:',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Ken feedback een positieve score toe indien een &quot;URL&quot; element van de feedback al eerder gepubliceerd werd',
    'Only applied when no other links are present in message of feedback.' => 'Enkel toegepast wanneer geen andere links aanwezig zijn in het bericht van de feedback.',
    'Email Memory:' => 'E-mailgeheugen:',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Ken feedback een positive score toe indien eerder gepubliceerde reacties gevonden worden die overeenkomen qua e-mail adres',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => '
Opzoekingen houden IP adressen van oorsprong en hyperlinks in de gaten van alle binnenkomende feedback.  Als een reactie of een TrackBack binnenkomt van een IP dat op de zwarte lijst staat of een domein bevat dat op de zwarte lijst voorkomt, kan het worden tegengehouden voor moderatie of als spam worden aangemerkt en in de spam-map van de weblog worden geplaatst.  Bijkomend kunnen er nog geavandceerde opzoekingen gebeuren op de brongegevens van een TrackBack.',
    'IP Address Lookups:' => 'Opzoekingen op IP adres:',
    'Off' => 'Uit',
    'Moderate feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst modereren',
    'Junk feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst verwerpen',
    'block' => 'tegenhouden',
    'none' => 'geen',
    'IP Blacklist Services:' => 'Zwarte lijsten IP adressen:',
    'Domain Name Lookups:' => 'Opzoekingen op domeinnaam:',
    'Moderate feedback containing blacklisted domains' => 'Feedback van domeinen op de zwarte lijst modereren',
    'Junk feedback containing blacklisted domains' => 'Feedback van domeinen op de zwarte lijst verwerpen',
    'Domain Blacklist Services:' => 'Zwarte lijsten domeinnamen:',
    'Advanced TrackBack Lookups:' => 'Geavanceerde opzoekingen van TrackBacks:',
    'Moderate TrackBacks from suspicious sources' => 'TrackBacks uit verdachte bronnen modereren',
    'Junk TrackBacks from suspicious sources' => 'TrackBacks uit verdachte bronnen verwerpen',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Om het opzoeken van bepaalde IP adressen of domeinen te voorkomen, gelieve ze hieronder in te vullen.  Zet elk item op een aparte lijn.',
    'Lookup Whitelist:' => 'Witte lijst opzoekingen:',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Binnenkomende feedback kan in de gaten worden gehouden voor specifieke sleutelwoorden, domeinnamen of patronen.  Overeenkomsten kunnen worden tegengehouden voor moderatie of als spam worden aangemerkt. Bijkomend kan de spamscore voor deze overeenkomsten worden gepersonaliseerd.',
    'Keywords to Moderate:' => 'Sleutelwoorden om te modereren:',
    'Keywords to Junk:' => 'Sleutelwoorden om te verwerpen:',

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Ontbrekend configuratiebestand',
    'Database Connection Error' => 'Databaseverbindingsfout',
    'CGI Path Configuration Required' => 'CGI-pad configuratie vereist',
    'An error occurred' => 'Er deed zich een probleem voor',

    ## ./tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Welkom in Movable Type!',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'Voor u kunt beginnen te bloggen, moet u eerst uw installatie vervolledigen door uw database te initialiseren.',
    'You will need to select a username and password for the administrator account.' => 'U moet een gebruikersnaam en wachtwoord kiezen voor de administrator-account.',
    'To proceed, you must authenticate properly with your LDAP server.' => 'Om verder te gaan, moet u de juiste autenticatie hebben bij uw LDAP server.',
    'Title' => 'Titel',
    'Username:' => 'Gebruikersnaam:',
    'The name used by this author to login.' => 'De naam gebruikt door deze auteur om zich aan te melden.',
    'Email:' => 'E-mail:',
    'The author\'s email address.' => 'Het e-mail adres van de auteur.',
    'Password:' => 'Wachtwoord:',
    'Select a password for your account.' => 'Kies een wachtwoord voor uw account.',
    'Password Confirm:' => 'Wachtwoordbevestiging:',
    'Repeat the password for confirmation.' => 'Herhaal het wachtwoord ter bevestiging.',
    'Your LDAP username.' => 'Uw LDAP gebruikersnaam.',
    'Enter your LDAP password.' => 'Geef uw LDAP wachtwoord in.',
    'Finish Install' => 'Installatie vervolledigen',

    ## ./tmpl/cms/notification_actions.tmpl
    'Delete' => 'Verwijderen',
    'notification address' => 'notificatie-adres',
    'notification addresses' => 'notificatie-adressen',
    'Delete selected notification addresses (d)' => 'Geselecteerde notificatie-adressen verwijderen (d)',

    ## ./tmpl/cms/list_template.tmpl
    'Index Templates' => 'Index van sjablonen',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'Indexsjablonen produceren unieke pagina\'s en kunnen gebruikt worden om Movable Type gegevens te publiceren of bestanden met eender welk soort inhoud.  Deze sjablonen worden meestal automatisch opnieuw opgebouwd wanneer berichten, reacties en TrackBacks worden opgeslagen.',
    'Archive Templates' => 'Archiefsjablonen',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'Archiefsjablonen worden gebruikt om meerdere pagina\'s van hetzelfde archieftype mee te produceren.  U kunt er nieuwe aanmaken en ze dan koppelen aan archieftypes op het scherm voor de publicatie-instellingen van deze weblog.',
    'System Templates' => 'Systeemsjablonen',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Systeemsjablonen bepalen de lay-out en stijl van een klein aantal dynamische pagina\'s die een specifieke systeemfunctie vervullen in Movable Type.',
    'Template Modules' => 'Sjabloonmodules',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'Sjabloonmodules zijn mini-sjablonen die op zichzelf niets produceren, maar die opgenomen kunnen worden in andere sjablonen.  Ze zijn uitstekend voor vaak voorkomende inhoud (bijvoorbeeld paginahoofdingen, navigatiebalken, copyrightboodschappen...) en kunnen sjabloontags of zelfs enkel statische tekst bevatten.',
    'You have successfully deleted the checked template(s).' => 'Verwijdering van geselecteerde sjabloon/sjablonen is geslaagd.',
    'Your settings have been saved.' => 'Uw instellingen zijn opgeslagen.',
    'Indexes' => 'Indexen',
    'System' => 'Systeem',
    'Modules' => 'Modules', # Translate
    'Go to Publishing Settings' => 'Ga naar publicatie-instellingen',
    'Create new index template' => 'Nieuw indexsjabloon aanmaken',
    'Create New Index Template' => 'Nieuw indexsjabloon aanmaken',
    'Create new archive template' => 'Nieuw archiefsjabloon aanmaken',
    'Create New Archive Template' => 'Nieuw archiefsjabloon aanmaken',
    'Create new template module' => 'Nieuwe sjabloonmodule aanmaken',
    'Create New Template Module' => 'Nieuwe sjabloonmodule aanmaken',
    'Template Name' => 'Sjabloonnaam',
    'Output File' => 'Uitvoerbestand',
    'Dynamic' => 'Dynamisch',
    'Linked' => 'Gelinkt',
    'Built w/Indexes' => 'Gebouwd met indexen',
    'Yes' => 'Ja',
    'No' => 'Nee',
    'No index templates could be found.' => 'Er werden geen indexsjablonen gevonden.',
    'No archive templates could be found.' => 'Er werden geen archiefsjablonen gevonden.',
    'Description' => 'Beschrijving',
    'No template modules could be found.' => 'Er werden geen sjabloonmodules gevonden.',
    'Plugin Actions' => 'Plugin-handelingen',

    ## ./tmpl/cms/list_commenters.tmpl
    'Authenticated Commenters' => 'Geauthenticeerde reageerders',
    'The selected commenter(s) has been given trusted status.' => 'De geselecteerde reageerder(s) hebben de status \'vertrouwd\' gekregen.',
    'Trusted status has been removed from the selected commenter(s).' => 'De status van \'vertrouwd\' is van de geselecteerde reageerder(s) afgenomen.',
    'The selected commenter(s) have been blocked from commenting.' => 'De geselecteerde reageerder(s) is de mogelijkheid om te reageren afgenomen.',
    'The selected commenter(s) have been unbanned.' => 'De geselecteerde reageerder(s) mogen terug reageren.',
    'Go to Comment Listing' => 'Ga naar het overzicht van de reacties',
    'Quickfilter:' => 'Snelfilter:',
    'Show unpublished comments.' => 'Ongepubliceerde reacties tonen.',
    'Reset' => 'Leegmaken',
    'Filter:' => 'Filter:', # Translate
    'Showing all commenters.' => 'Alle reageerders worden getoond.',
    'Showing only commenters whose [_1] is [_2].' => 'Enkel reageerders waarbij [_1] gelijk is aan [_2] worden getoond.',
    'Show' => 'Toon',
    'all' => 'alle',
    'only' => 'enkel',
    'commenters.' => 'reageerders.',
    'commenters where' => 'reageerders met',
    'status' => 'status', # Translate
    'commenter' => 'reageerder',
    'is' => 'gelijk aan',
    'trusted' => 'vertrouwd',
    'untrusted' => 'niet vertrouwd',
    'banned' => 'verbannen',
    'unauthenticated' => 'niet geauthenticeerd',
    'authenticated' => 'geauthenticeerd',
    '.' => '.', # Translate
    'Filter' => 'Filter', # Translate
    'No commenters could be found.' => 'Er werden geen reageerders gevonden.',

    ## ./tmpl/cms/upload_confirm.tmpl
    'Upload File' => 'Opladen',
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => 'Er bestaat reeds een bestand net de naam \'[_1]\'. Wilt u dit bestand overschrijven?',

    ## ./tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'Deze HTML in uw bericht kopiëren en plakken.',
    'Close' => 'Sluiten',
    'Upload Another' => 'Meer opladen',

    ## ./tmpl/cms/copyright.tmpl

    ## ./tmpl/cms/rebuilt.tmpl
    'Rebuild' => 'Opnieuw opbouwen',
    'All of your files have been rebuilt.' => 'Al uw bestanden zijn opnieuw opgebouwd.',
    'Your [_1] has been rebuilt.' => 'Uw [_1] is opnieuw gebouwd.',
    'Your [_1] pages have been rebuilt.' => 'Uw [_1] pagina\'s zijn opnieuw opgebouwd.',
    'View your site' => 'Uw site bekijken',
    'View this page' => 'Deze pagina bekijken',
    'Rebuild Again' => 'Nogmaals opnieuw opbouwen',

    ## ./tmpl/cms/commenter_actions.tmpl
    'Trust' => 'Vertrouw',
    'commenters' => 'reageerders',
    'to act upon' => 'om de handeling op uit te voeren',
    'Trust commenter' => 'Reageerder vertrouwen',
    'Untrust' => 'Wantrouw',
    'Untrust commenter' => 'Reageerder wantrouwen',
    'Ban' => 'Verban',
    'Ban commenter' => 'Reageerder verbannen',
    'Unban' => 'Ontbannen',
    'Unban commenter' => 'Reageerder ontbannen',
    'Trust selected commenters' => 'Geselecteerde reageerders vertrouwen',
    'Ban selected commenters' => 'Geselecteerde reageerders verbannen',

    ## ./tmpl/cms/author_table.tmpl
    'Username' => 'Gebruikersnaam',
    'Name' => 'Naam',
    'Email' => 'E-mail',
    'URL' => 'URL', # Translate
    'Link' => 'Link', # Translate

    ## ./tmpl/cms/ping_actions.tmpl
    'to publish' => 'om te publiceren',
    'Publish' => 'Publiceren',
    'Publish selected TrackBacks (p)' => 'Geselecteerde TrackBacks publiceren (p)',
    'Delete selected TrackBacks (d)' => 'Geselecteerde TrackBacks verwijderen (d)',
    'Junk' => 'Verwerpen',
    'Junk selected TrackBacks (j)' => 'Geselecteerde TrackBacks verwerpen (j)',
    'Not Junk' => 'Niet verwerpen',
    'Recover selected TrackBacks (j)' => 'Geselecteerde TrackBacks niet langer markeren als verworpen (j)',
    'Are you sure you want to remove all junk TrackBacks?' => 'Bent u zeker dat u alle spam TrackBacks wenst te verwijderen?',
    'Empty Junk Folder' => 'Spam-map leegmaken',
    'Deletes all junk TrackBacks' => 'Verwijdert alle spam TrackBacks',
    'Ban This IP' => 'Dit IP-adres verbannen',

    ## ./tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => 'Uw nieuwe bericht is opgeslagen op [_1]',
    ', and it has been posted to your site' => 'en is op uw site gepubliceerd',
    '. ' => '. ', # Translate
    'Edit this entry' => 'Dit bericht bewerken',

    ## ./tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'Movable Type-nieuws',
    'System Shortcuts' => 'Systeem-snelkoppelingen',
    'Weblogs' => 'Weblogs', # Translate
    'Concise listing of weblogs.' => 'Kort weblog-lijstje.',
    'Authors' => 'Auteurs',
    'Create, manage, set permissions.' => 'Permissies aanmaken, beheren, instellen.',
    'Plugins' => 'Plugins', # Translate
    'What\'s installed, access to more.' => 'Wat is er geïnstalleerd, toegang tot meer.',
    'Entries' => 'Berichten',
    'Multi-weblog entry listing.' => 'Multi-weblog berichten-overzicht.',
    'Tags' => 'Tags', # Translate
    'Multi-weblog tag listing.' => 'Multi-weblog tag overzicht.',
    'Multi-weblog comment listing.' => 'Multi-weblog reactie-overzicht.',
    'Multi-weblog TrackBack listing.' => 'Multi-weblog TrackBack-overzicht.',
    'Settings' => 'Instellingen',
    'System-wide configuration.' => 'Configuratie over heel het systeem.',
    'Search &amp; Replace' => 'Zoeken en vervangen',
    'Find everything. Replace anything.' => 'Alles zoeken. Alles vervangen.',
    'Activity Log' => 'Activiteitenlog',
    'What\'s been happening.' => 'Wat is er recent gebeurd.',
    'Status &amp; Info' => 'Status &amp; info',
    'Server status and information.' => 'Server status en informatie.',
    'QuickPost' => 'QuickPost', # Translate
    'Set Up A QuickPost Bookmarklet' => 'Een QuickPost bookmarklet instellen',
    'Enable one-click publishing.' => 'Eén-klik publicatie inschakelen.',
    'My Weblogs' => 'Mijn weblogs',
    'Warning' => 'Waarschuwing',
    'Important:' => 'Belangrijk:',
    'Configure this weblog.' => 'Deze weblog configureren',
    'Create New Entry' => 'Nieuw bericht opstellen',
    'Create a new entry' => 'Nieuw bericht aanmaken',
    'Create a new entry on this weblog' => 'Nieuw bericht aanmaken op deze weblog',
    'Templates' => 'Sjablonen',
    '_external_link_target' => '_extern_link_doel',
    'View Site' => 'Site bekijken',
    'Show Display Options' => 'Toon opties voor schermindeling',
    'Display Options' => 'Opties voor schermindeling',
    'Sort By:' => 'Sorteren op:',
    'Weblog Name' => 'Weblognaam',
    'Creation Order' => 'Volgorde aanmaken',
    'Last Updated' => 'Laatst bijgewerkt',
    'Order:' => 'Volgorde:',
    'Ascending' => 'Oplopend',
    'Descending' => 'Aflopend',
    'View:' => 'Overzicht:',
    'Compact' => 'Compact', # Translate
    'Expanded' => 'Uitgebreid',
    'Save' => 'Opslaan',

    ## ./tmpl/cms/upload_complete.tmpl
    'Your file has been uploaded. Size: [quant,_1,byte].' => 'Opladen van uw bestand is voltooid.  Grootte: [quant,_1,byte].',
    'Create a new entry using this uploaded file' => 'Bericht aanmaken met dit opgeladen bestand',
    'Show me the HTML' => 'Toon me de HTML',
    'Image Thumbnail' => 'Miniatuurweergave afbeelding',
    'Create a thumbnail for this image' => 'Miniatuurweergave van deze afbeelding aanmaken',
    'Width:' => 'Breedte:',
    'Pixels' => 'Pixels', # Translate
    'Percent' => 'Procent',
    'Height:' => 'Hoogte:',
    'Constrain proportions' => 'Proporties beperken',
    'Would you like this file to be a:' => 'Wilt u dat dit bestand van het volgende type is:',
    'Popup Image' => 'Pop-up afbeelding',
    'Embedded Image' => 'Ingesloten afbeelding',

    ## ./tmpl/cms/feed_link.tmpl
    'Activity Feed' => 'Activiteit-feed',
    'Activity Feed (Disabled)' => 'Activiteit-feed (uitgeschakeld)',
    'Disabled' => 'Uitgeschakeld',
    'Set Web Services Password' => 'Webservices wachtwoord instellen',

    ## ./tmpl/cms/edit_author.tmpl
    'Your API Password is currently' => 'Momenteel is uw API wachtwoord',
    'Author Profile' => 'Auteursprofiel',
    'Create New Author' => 'Nieuwe account aanmaken',
    'Your profile has been updated.' => 'Update van uw profiel is voltooid. ',
    'Permissions' => 'Permissies',
    'Weblog Associations' => 'Weblog-associaties',
    'General Permissions' => 'Algemene permissies',
    'System Administrator' => 'Systeembeheerder',
    'Create Weblogs' => 'Weblogs aanmaken',
    'View Activity Log' => 'Activiteitenlog bekijken',
    'Profile' => 'Profiel',
    'Username (*):' => 'Gebruikersnaam (*):',
    'Display Name:' => 'Getoonde naam:',
    'The author\'s published name.' => 'De gepubliceerde naam van de auteur.',
    'Email Address (*):' => 'E-mail adres (*):',
    'Website URL:' => 'URL website:',
    'The URL of this author\'s website. (Optional)' => 'De URL van de website van deze auteur (optioneel)',
    'Language:' => 'Taal:',
    'The author\'s preferred language.' => 'De voorkeurstaal van deze auteur.',
    'Password' => 'Wachtwoord',
    'Current Password:' => 'Huidig wachtwoord:',
    'Enter the existing password to change it.' => 'Vul het huidige wachtwoord in om het te veranderen.',
    'New Password:' => 'Nieuw wachtwoord:',
    'Initial Password (*):' => 'Initiëel wachtwoord (*):',
    'Select a password for the author.' => 'Kies een wachtwoord voor de auteur.',
    'Password hint (*):' => 'Wachtwoordhint (*):',
    'For password recovery.' => 'Om wachtwoorden te kunnen terugvinden.',
    'API Password:' => 'API wachtwoord:',
    'Reveal' => 'Onthul',
    'For use with XML-RPC and Atom-enabled clients.' => 'Voor gebruik met XML-RPC en cliënten uitgerust met Atom.',
    'Password hint:' => 'Wachtwoordhint:',
    'Save Changes' => 'Wijzigingen opslaan',
    'Save this author (s)' => 'Deze auteur(s) opslaan',

    ## ./tmpl/cms/edit_template.tmpl
    'Edit Template' => 'Sjabloon bewerken',
    'Your template changes have been saved.' => 'De wijzigingen aan uw sjabloon zijn opgeslagen.',
    'Rebuild this template' => 'Dit sjabloon opnieuw opbouwen',
    'Build Options' => 'Bouwopties',
    'Enable dynamic building for this template' => 'Dynamisch opbouwen inschakelen voor dit sjabloon',
    'Rebuild this template automatically when rebuilding index templates' => 'Dit sjabloon automatisch opnieuw opbouwen bij opnieuw opbouwen van indexsjablonen',
    'Comment Listing Template' => 'Sjabloon lijst met reacties',
    'Comment Preview Template' => 'Sjabloon voorbeeld van reactie',
    'Comment Error Template' => 'Sjabloon fout met reactie ',
    'Comment Pending Template' => 'Sjabloon reacties die wachten op goedkeuring',
    'Commenter Registration Template' => 'Sjabloon bezoekersregistratie',
    'TrackBack Listing Template' => 'Sjabloon TrackBack-lijst',
    'Uploaded Image Popup Template' => 'Sjabloon pop-up van geüploade afbeelding',
    'Dynamic Pages Error Template' => 'Sjabloon fout met dynamische pagina\'s',
    'Link this template to a file' => 'Dit sjabloon aan een bestand koppelen',
    'Module Body' => 'Moduletekst',
    'Template Body' => 'Sjabloontekst',
    'Save this template (s)' => 'Dit sjabloon opslaan (s)',
    'Save and Rebuild' => 'Opslaan en opnieuw opbouwen',
    'Save and rebuild this template (r)' => 'Dit sjabloon opslaan en opnieuw opbouwen (r)',

    ## ./tmpl/cms/cfg_system_feedback.tmpl
    'System-wide' => 'In het hele systeem',
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => '
    Via dit scherm kunt u de instellingen voor feedback en uitgaande TrackBacks beheren voor heel de installatie.  Deze instellingen gelden boven gelijkaardige instellingen voor individuele weblogs.',
    'Your feedback preferences have been saved.' => 'Uw voorkeuren voor feedback zijn opgeslagen.',
    'Feedback Master Switch' => 'Feedback hoofdschakelaar',
    'Disable Comments' => 'Reacties uitschakelen',
    'Stop accepting comments on all weblogs' => 'Stop reacties te aanvaarden op alle weblogs',
    'This will override all individual weblog comment settings.' => 'Dit geldt boven alle instellingen voor reacties van alle individuele weblogs.',
    'Disable TrackBacks' => 'TrackBacks uitschakelen',
    'Stop accepting TrackBacks on all weblogs' => 'Stop TrackBacks te aanvaarden op alle weblogs',
    'This will override all individual weblog TrackBack settings.' => 'Dit geldt boven alle instellingen voor TrackBacks van alle individuele weblogs.',
    'Outbound TrackBack Control' => 'Uitgaand TrackBack beheer',
    'Allow outbound TrackBacks to:' => 'Laat uitgaande TrackBacks toe naar:',
    'Any site' => 'Elke site',
    'No site' => 'Geen enkele site',
    '(Disable all outbound TrackBacks.)' => '(Alle uitgaande TrackBacks uitschakelen.)',
    'Only the weblogs on this installation' => 'Enkel de weblogs op deze installatie',
    'Only the sites on the following domains:' => 'Enkel de sites binnen volgende domeinen:',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'Deze optie maakt het mogelijk om uitgaande TrackBacks en TrackBack auto-discovery te beperken met als doel om uw installatie privé te houden.',
    'Save changes (s)' => 'Wijziging(en) opslaan',

    ## ./tmpl/cms/entry_actions.tmpl
    'Save these entries (s)' => 'Deze berichten opslaan (s)',
    'Save this entry (s)' => 'Dit bericht opslaan (s)',
    'Preview this entry (p)' => 'Voorbeeld bekijken van dit bericht (p)',
    'entry' => 'bericht',
    'entries' => 'berichten',
    'Delete this entry (d)' => 'Dit bericht verwijderen (d)',
    'to rebuild' => 'om opnieuw op te bouwen',
    'Rebuild selected entries (r)' => 'Geselecteerde berichten opnieuw opbouwen (r)',
    'Delete selected entries (d)' => 'Geselecteerde berichten verwijderen (d)',

    ## ./tmpl/cms/edit_comment.tmpl
    'Edit Comment' => 'Reactie bewerken',
    'Your changes have been saved.' => 'Uw wijzigingen zijn opgeslagen.',
    'The comment has been approved.' => 'De reactie werd goedgekeurd.',
    'Previous' => 'Vorige',
    'List &amp; Edit Comments' => 'Reacties weergeven en bewerken',
    'Next' => 'Volgende',
    'View Entry' => 'Bericht bekijken',
    'Pending Approval' => 'In afwachting van goedkeuring',
    'Junked Comment' => 'Verworpen reactie',
    'Status:' => 'Status:', # Translate
    'Published' => 'Gepubliceerd',
    'Unpublished' => 'Ongepubliceerd',
    'View all comments with this status' => 'Alle reacties met deze status bekijken',
    'Commenter:' => 'Reageerder:',
    'Trusted' => 'Vertrouwd',
    '(Trusted)' => '(Vertrouwd)',
    'Ban&nbsp;Commenter' => 'Reageerder&nbsp;uitsluiten',
    'Untrust&nbsp;Commenter' => 'Reageerder&nbsp;niet&bsp;vertrouwen',
    'Banned' => 'Uitgesloten',
    '(Banned)' => '(uitgesloten)',
    'Trust&nbsp;Commenter' => 'Reageerder&nbsp;vertrouwen',
    'Unban&nbsp;Commenter' => 'Verbanning&nbsp;reageerder&nbsp;ongedaan&nbsp;maken',
    'Pending' => 'In afwachting',
    'View all comments by this commenter' => 'Alle reacties van deze reageerder bekijken',
    'None given' => 'Niet opgegeven',
    'View all comments with this email address' => 'Alle reacties met dit e-mail adres bekijken',
    'View all comments with this URL' => 'Alle reacties met deze URL bekijken',
    'Entry:' => 'Bericht:',
    'Entry no longer exists' => 'Bericht bestaat niet meer',
    'No title' => 'Geen titel',
    'View all comments on this entry' => 'Bekijk alle reacties op dit bericht',
    'Date:' => 'Datum:',
    'View all comments posted on this day' => 'Alle reacties bekijken die deze dag geplaatst zijn',
    'IP:' => 'IP:', # Translate
    'View all comments from this IP address' => 'Alle reacties van dit IP-adres bekijken',
    'Save this comment (s)' => 'Deze reactie(s) opslaan',
    'comment' => 'reactie',
    'comments' => 'reacties',
    'Delete this comment (d)' => 'Deze reactie(s) verwijderen',
    'Final Feedback Rating' => 'Uiteindelijke feedback-beoordeling',
    'Test' => 'Test', # Translate
    'Score' => 'Score', # Translate
    'Results' => 'Resultaten',

    ## ./tmpl/cms/author_actions.tmpl
    'author' => 'auteur',
    'authors' => 'auteurs',
    'Delete selected authors (d)' => 'Geselecteerde auteur(s) verwijderen',

    ## ./tmpl/cms/bm_entry.tmpl
    'Select' => 'Selecteren',
    'Add new category...' => 'Nieuwe categorie toevoegen...',
    'You must choose a weblog in which to post the new entry.' => 'U moet een weblog kiezen waar u het nieuwe bericht op wilt publiceren.',
    'Select a weblog for this post:' => 'Selecteer een weblog om dit op te publiceren:',
    'Select a weblog' => 'Selecteer een weblog',
    'Primary Category' => 'Hoofdcategorie',
    'Assign Multiple Categories' => 'Meerdere categorieën toewijzen',
    'Post Status' => 'Publicatiestatus',
    'Entry Body' => 'Berichttekst',
    'Bold' => 'Vet',
    'Italic' => 'Cursief',
    'Underline' => 'Onderstrepen',
    'Insert Link' => 'Link invoegen',
    'Insert Email Link' => 'E-mail link invoegen',
    'Quote' => 'Citaat',
    'Extended Entry' => 'Uitgebreid bericht',
    'Excerpt' => 'Uittreksel',
    'Keywords' => 'Trefwoorden',
    'Send an outbound TrackBack:' => 'Uitgaande TrackBack versturen:',
    'Select an entry to send an outbound TrackBack:' => 'Selecteer een bericht om een uitgaande TrackBack naar te versturen:',
    'None' => 'Geen',
    'Text Formatting' => 'Tekstopmaak',
    'Accept' => 'Aanvaarden',
    'Basename' => 'Basisnaam',
    'Unlock this entry\'s output filename for editing' => 'Maak de naam van het uitvoerbestand van dit bericht bewerkbaar',
    'Warning: If you set the basename manually, it may conflict with another entry.' => 'Waarschuwing: de basisnaam van het bericht met de hand aanpassen kan een conflict met een ander bericht veroorzaken.',
    'Warning: Changing this entry\'s basename may break inbound links.' => 'Waarschuwing: de basisnaam van het bericht aanpassen kan inkomende links breken.',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'U heeft toestemming om berichten aan te maken op geen enkele weblog op deze installatie.  Gelieve uw systeembeheerder te contacteren om toegang te krijgen.',

    ## ./tmpl/cms/tag_table.tmpl
    'Date' => 'Datum',
    'IP Address' => 'IP-adres',
    'Log Message' => 'Logbericht',

    ## ./tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => 'Geselecteerde reacties publiceren (p)',
    'Delete selected comments (d)' => 'Geselecteerde reacties verwijderen (d)',
    'Junk selected comments (j)' => 'Geselecteerde reacties verwerpen (j)',
    'Recover selected comments (j)' => 'Geselecteerde reacties niet langer als spam markeren (j)',
    'Are you sure you want to remove all junk comments?' => 'Bent u zeker dat u alle spam-reacties wenst te verwijderen?',
    'Deletes all junk comments' => 'Verwijdert alle spam-reacties',

    ## ./tmpl/cms/import_start.tmpl
    'Importing...' => 'Importeren...',
    'Importing entries into blog' => 'Berichten worden geïmporteerd in de blog',
    'Importing entries as author \'[_1]\'' => 'Berichten worden geïmporteerd als auteur \'[_1]\'',
    'Creating new authors for each author found in the blog' => 'Nieuwe auteurs worden aangemaakt voor elke auteur gevonden in de weblog',

    ## ./tmpl/cms/edit_author_bulk.tmpl
    'File From Your Computer:' => 'Bestand vanop uw computer:',
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'Als u een bestand naar uw server wilt opladen, klikt u op de knop \'Browse\' om het bestand te vinden op uw harde schijf.',
    'Encoding:' => 'Encodering:',
    'Choose an encoding method name of the file.' => 'Kies de encoderingsmethode van het bestand.',
    'Upload' => 'Opladen',

    ## ./tmpl/cms/cfg_entries.tmpl
    'New Entry Default Settings' => 'Standaard instellingen nieuw bericht',
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'Met dit scherm kunt u de standaardinstellingen voor nieuwe berichten bepalen, net als de instellingen voor publiciteit en de interface voor beheer op afstand.',
    'General' => 'Algemeen',
    'New Entry Defaults' => 'Standaardinstellingen nieuw bericht',
    'Feedback' => 'Feedback', # Translate
    'Publishing' => 'Publicatie',
    'IP Banning' => 'IP-verbanning',
    'Your blog preferences have been saved.' => 'Uw blogvoorkeuren zijn opgeslagen.',
    'Default Settings for New Entries' => 'Standaard instellingen voor nieuwe berichten',
    'Specifies the default Post Status when creating a new entry.' => 'Geeft de standaard publicatiestatus aan van een nieuw bericht.',
    'Specifies the default Text Formatting option when creating a new entry.' => 'Geeft de standaard tekstopmaak aan voor het aanmaken van een nieuw bericht.',
    'Accept Comments' => 'Reacties aanvaarden',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'Bepaalt de standaardinstelling voor het aanvaarden van nieuwe reacties bij nieuwe berichten.',
    'Setting Ignored' => 'Instelling genegeerd',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat reacties over heel het systeem of weblog-specifiek zijn uitgeschakeld.',
    'Accept TrackBacks:' => 'TrackBacks aanvaarden:',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Geeft de standaard instelling aan voor het aanvaarden van nieuwe trackbacks bij een nieuw bericht.',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => 'Opmerking: deze optie wordt momenteel genegeerd omdat TrackBacks over heel het systeem of weblog-specifiek zijn uitgeschakeld.',
    'Basename Length:' => 'Lengte basisnaam:',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Bepaalt de standaardlengte van automatisch gegenereerde basisnamen.  Het bereik van deze instelling is tussen 15 en 250.',
    'Publicity/Remote Interfaces' => 'Publiciteit/interfaces op afstand',
    'Notify the following sites upon weblog updates:' => 'Volgende sites op de hoogte brengen bij updates van weblog:',
    'Others:' => 'Andere:',
    '(Separate URLs with a carriage return.)' => '(URL\'s van elkaar scheiden met een carriage return.)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'Telkens deze weblog wordt bijgewerkt zal Movable Type automatisch de geselecteerde sites op de hoogte brengen.',
    'Setting Notice' => 'Opmerking bij deze instelling',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => 'Opmerking: Bovenstaande optie kan beïnvloed zijn omdat uitgaande pings op systeemniveau beperkt zijn.',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Opmerking: Deze optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau zijn uitgeschakeld.',
    'Recently Updated Key:' => 'Code \'Recent bijgewerkt\':',
    'If you have received a recently updated key (by virtue of your purchase or donation), enter it here.' => 'Als u een \'Recent bijgewerkt\'-code hebt ontvangen (door uw aanschaf of donatie), voer deze dan hier in.',
    'TrackBack Auto-Discovery' => 'Automatisch TrackBacks ontdekken',
    'Enable External TrackBack Auto-Discovery' => 'Externe automatische TrackBack-ontdekking inschakelen',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => 'Opmerking: bovenstaande optie wordt momenteel genegeerd omdat uitgaande pings op systeemniveau uitgeschakeld zijn.',
    'Enable Internal TrackBack Auto-Discovery' => 'Interne automatische TrackBack-ontdekking inschakelen',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => 'Als u automatisch ontdekken inschakelt, dan zullen telkens u een nieuw bericht schrijft alle externe links er worden uitgehaald om de passende sites TrackBacks te sturen.',

    ## ./tmpl/cms/list_tags.tmpl
    'Your tag changes and additions have been made.' => 'Uw tag-wijzigingen en toevoegingen zijn uitgevoerd.',
    'You have successfully deleted the selected tags.' => 'U hebt met succes de geselecteerde tags verwijderd.',
    'Tag Name' => 'Tag-naam',
    'Click to edit tag name' => 'Klik om de naam van de tag te wijzigen',
    'Rename' => 'Naam wijzigen',
    'Show all entries with this tag' => 'Toon alle berichten met deze tag',
    '[quant,_1,entry,entries]' => '[quant,_1,bericht,berichten]',
    'tag' => 'tag', # Translate
    'tags' => 'tags', # Translate
    'Delete selected tags (d)' => 'Geselecteerde tags verwijderen (d)',
    'No tags could be found.' => 'Er werden geen tags gevonden.',

    ## ./tmpl/cms/log_table.tmpl

    ## ./tmpl/cms/comment_table.tmpl
    'Status' => 'Status', # Translate
    'Comment' => 'Reactie',
    'Commenter' => 'Bezoeker',
    'Weblog' => 'Weblog', # Translate
    'Entry' => 'Bericht',
    'IP' => 'IP', # Translate
    'Only show published comments' => 'Enkel gepubliceerde reacties tonen',
    'Only show pending comments' => 'Enkel hangende reacties tonen',
    'Edit this comment' => 'Deze reactie bewerken',
    'Edit this commenter' => 'Deze reageerder bewerken',
    'Blocked' => 'Geblokkeerd',
    'Authenticated' => 'Bevestigd',
    'Search for comments by this commenter' => 'Zoek naar reacties door deze reageerder',
    'Show all comments on this entry' => 'Toon alle reacties op dit bericht',
    'Search for all comments from this IP address' => 'Zoek naar alle reacties van dit IP adres',

    ## ./tmpl/cms/template_actions.tmpl
    'template' => 'sjabloon',
    'templates' => 'sjablonen',

    ## ./tmpl/cms/list_author.tmpl
    'Open power-editing mode' => 'Modus geavanceerd bewerken openen',
    'You have successfully deleted the authors from the Movable Type system.' => 'U hebt de auteurs uit het Movable Type-systeem verwijderd.',
    'Download CSV' => 'CSV downloaden',
    'Download a CSV file of this data.' => 'CSV bestand met deze gegevens downloaden.',
    'Created By' => 'Aangemaakt door',
    'Last Entry' => 'Laatste bericht',

    ## ./tmpl/cms/list_entry.tmpl
    'Your entry has been deleted from the database.' => 'Uw bericht is uit de database verwijderd.',
    'Show unpublished entries.' => 'Ongepubliceerde berichten tonen.',
    '(Showing all entries)' => '(Alle berichten worden getoond)',
    'Showing only entries where [_1] is [_2].' => 'Enkel berichten waarbij [_1] gelijk is aan [_2] worden getoond.',
    'entries.' => 'berichten.',
    'entries where' => 'berichten met',
    'category' => 'categorie',
    'published' => 'gepubliceerd',
    'unpublished' => 'ongepubliceerd',
    'scheduled' => 'gepland',
    'No entries could be found.' => 'Er werden geen berichten gevonden.',

    ## ./tmpl/cms/import.tmpl
    'Import / Export' => 'Import/export',
    'Transfer weblog entries into Movable Type from other blogging tools or export your entries to create a backup or copy.' => 'Voeg weblogberichten in Movable Type in vanuit andere weblogsystemen en -diensten of exporteer uw berichten om een backup of kopie te maken.',
    'Import Entries' => 'Berichten importeren',
    'Export Entries' => 'Berichten exporteren',
    'Import entries as me' => 'Berichten importeren als mezelf',
    'Password (required if creating new authors):' => 'Wachtwoord (vereist voor het aanmaken van nieuwe auteurs):',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => 'U zult als auteur worden beschouwd van alle geïmporteerde berichten.  Indien u wenst dat de oorspronkelijke auteurs het auteurschap bewaren, dan moet u uw MT systeembeheerder contacteren om de import uit te voeren zodat nieuwe auteurs automatisch kunnen worden aangemaakt indien nodig.',
    'Default category for entries (optional):' => 'Standaardcategorie voor berichten (optioneel):',
    'Select a category' => 'Categorie selecteren',
    'Default post status for entries (optional):' => 'Standaardpublicatiestatus voor berichten (optioneel):',
    'Select a post status' => 'Publicatiestatus selecteren',
    'Start title HTML (optional):' => 'HTML om titel mee te starten (optioneel):',
    'End title HTML (optional):' => 'HTML om titel mee af te sluiten(optioneel):',
    'File From Your Computer (optional):' => 'Bestand van uw computer (optioneel):',
    'Encoding (optional):' => 'Encodering (optioneel):',
    'Export Entries From [_1]' => 'Berichten exporteren van [_1]',
    'Export Entries to Tangent' => 'Berichten exporteren naar Tangent',

    ## ./tmpl/cms/pending_commenter.tmpl

    ## ./tmpl/cms/bookmarklets.tmpl
    'Add QuickPost to Windows right-click menu' => 'QuickPost toevoegen aan het Windows-menu dat verschijnt als u op de rechtermuisknop klikt',
    'Configure QuickPost' => 'QuickPost instellen',
    'Include:' => 'Opnemen:',
    'TrackBack Items' => 'TrackBack items',
    'Category' => 'categorie',
    'Allow Comments' => 'Reacties toestaan',
    'Allow TrackBacks' => 'TrackBacks toestaan',
    'Create' => 'Aanmaken',

    ## ./tmpl/cms/footer.tmpl

    ## ./tmpl/cms/upload.tmpl
    'Choose a File' => 'Kies een bestand',
    'File:' => 'Bestand:',
    'Choose a Destination' => 'Kies een bestemming',
    'Upload Into:' => 'Opladen naar:',
    '(Optional)' => '(optioneel)',
    'Local Archive Path' => 'Pad van lokale archivering',
    'Local Site Path' => 'Pad van lokale site',

    ## ./tmpl/cms/edit_commenter.tmpl
    'Commenter Details' => 'Details reageerder',
    'The commenter has been trusted.' => 'Deze reageerder wordt vertrouwd.',
    'The commenter has been banned.' => 'Deze reageerder is verbannen.',
    'Junk Comments' => 'Verworpen reacties',
    'View all comments with this name' => 'Alle reacties met deze naam bekijken',
    'Identity:' => 'Identiteit:',
    'Withheld' => 'Niet onthuld',
    'View all comments with this URL address' => 'Alle reacties met deze URL bekijken',
    'View all commenters with this status' => 'Alle reageerders met deze status bekijken',

    ## ./tmpl/cms/blog-left-nav.tmpl
    'Posting' => 'Bericht',
    'New Entry' => 'Nieuw bericht',
    'List Entries' => 'Berichten weergeven',
    'Community' => 'Gemeenschap',
    'List Comments' => 'Reacties weergeven',
    'List Commenters' => 'Reageerders tonen',
    'Commenters' => 'Registratie',
    'List TrackBacks' => 'TrackBacks tonen',
    'Edit Notification List' => 'Notificatielijst bewerken',
    'Notifications' => 'Notificaties',
    'Configure' => 'Configureren',
    'List &amp; Edit Templates' => 'Sjablonen weergeven en bewerken',
    'Edit Categories' => 'Categorieën bewerken',
    'Edit Tags' => 'Tags bewerken',
    'Edit Weblog Configuration' => 'Weblogconfiguratie bewerken',
    'Utilities' => 'Hulpmiddelen',
    'Import &amp; Export Entries' => 'Berichten importeren en exporteren',
    'Rebuild Site' => 'Site herbouwen',

    ## ./tmpl/cms/entry_prefs.tmpl
    'Your entry screen preferences have been saved.' => 'Uw schermvoorkeuren voor uw bericht zijn opgeslagen.',
    'Field Configuration' => 'Veldconfiguratie',
    '(Help?)' => '(Hulp?)',
    'Basic' => 'Eenvoudig',
    'Advanced' => 'Geavanceerd',
    'Custom: show the following fields:' => 'Aangepast: de volgende velden tonen:',
    'Editable Authored On Date' => 'Bewerkbare schrijfdatum',
    'Outbound TrackBack URLs' => 'Uitgaande TrackBack URLs',
    'Button Bar Position' => 'Plaats knoppenbalk',
    'Top of the page' => 'Bovenaan de pagina',
    'Bottom of the page' => 'Onderaan de pagina',
    'Top and bottom of the page' => 'Bovenaan en onderaan de pagina',

    ## ./tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Tijd voor een upgrade!',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Er is een nieuwe versie van Movable Type geïnstalleerd.  Er moeten een aantal dingen gebeuren om uw database bij te werken.',
    'Begin Upgrade' => 'Begin de upgrade',

    ## ./tmpl/cms/edit_placements.tmpl
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'Update van de secundaire categorieën voor dit bericht is voltooid. U moet het bericht waaraan wijzigingen zijn aangebracht OPSLAAN om ze weer te geven op uw site.',
    'Categories in your weblog:' => 'Categorieën in uw weblog:',
    'Secondary categories:' => 'Secundaire categorieën:',
    'Assign &gt;&gt;' => 'Toewijzen &gt;&gt;',
    '&lt;&lt; Remove' => '&lt;&lt; Verwijderen',

    ## ./tmpl/cms/junk_results.tmpl
    'Find Junk' => 'Verworpen items zoeken',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => 'Volgende items zouden wel eens spam kunnen zijn.  Verwijder de kruisjes in de vakjes naast de items die GEEN spam zijn en klik op SPAM om verder te gaan.',
    'To return to the comment list without junking any items, click CANCEL.' => 'Om terug te keren naar de lijst van de reacties zonder items te verwerpen, .',
    'Approved' => 'Goedgekeurd',
    'Registered Commenter' => 'Geregistreerde bezoeker',
    'Return to comment list' => 'Terugkeren naar de lijst van de reacties',

    ## ./tmpl/cms/commenter_table.tmpl
    'Identity' => 'Identiteit',
    'Most Recent Comment' => 'Recentste reactie',
    'Only show trusted commenters' => 'Enkel vertrouwde reageerders tonen',
    'Only show banned commenters' => 'Enkel verbannen reageerders tonen',
    'Only show neutral commenters' => 'Enkel neutrale reageerders tonen',
    'View this commenter\'s profile' => 'Profiel van deze reageerder bekijken',

    ## ./tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => 'U moet één of meer items selecteren om te vervangen.',
    'Search Again' => 'Opnieuw zoeken',
    'Search:' => 'Zoeken:',
    'Replace:' => 'Vervangen:',
    'Replace Checked' => 'Aangekruiste items vervangen',
    'Case Sensitive' => 'Hoofdlettergevoelig',
    'Regex Match' => 'Regex-overeenkomst',
    'Limited Fields' => 'Beperkte velden',
    'Date Range' => 'Bereik wissen',
    'Is Junk?' => 'Verwerpen?',
    'Search Fields:' => 'Zoekvelden:',
    'Comment Text' => 'Tekst reactie',
    'E-mail Address' => 'E-mail adres',
    'Email Address' => 'E-mailadres',
    'Source URL' => 'Bron URL',
    'Blog Name' => 'Blognaam',
    'Text' => 'Tekst',
    'Output Filename' => 'Naam uitvoerbestand',
    'Linked Filename' => 'Naam gelinkt bestand',
    'Date Range:' => 'Datumbereik:',
    'From:' => 'Van:',
    'To:' => 'Aan:',
    'Replaced [_1] records successfully.' => 'Met succes [_1] items vervangen.',
    'No entries were found that match the given criteria.' => 'Er werden geen berichten gevonden die overeenkwamen met de opgegeven criteria.',
    'No comments were found that match the given criteria.' => 'Er werden geen reacties gevonden die overeenkwamen met de opgegeven criteria.',
    'No TrackBacks were found that match the given criteria.' => 'Er werden geen TrackBacks gevonden die overeenkwamen met de opgegeven criteria.',
    'No commenters were found that match the given criteria.' => 'Er werden geen reageerders gevonden die overeenkwamen met de opgegeven criteria.',
    'No templates were found that match the given criteria.' => 'Er werden geen sjablonen gevonden die overeenkwamen met de opgegeven criteria.',
    'No log messages were found that match the given criteria.' => 'Er werden geen logberichten gevonden die overeenkwamen met de opgegeven criteria.',
    'No Author were found that match the given criteria.' => 'Er werden geen auteurs gevonden die overeenkwamen met de gegeven criteria.',
    'Showing first [_1] results.' => 'Eerste [_1] resultaten worden getoond.',
    'Show all matches' => 'Alle overeenkomsten worden getoond',
    '[_1] result(s) found.' => '[_1] resulta(a)t(en) gevonden.',

    ## ./tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Bouw uw website opnieuw op als u de wijzigingen op uw publieke site wilt kunnen zien.',
    'Rebuild my site' => 'Mijn site opnieuw opbouwen',

    ## ./tmpl/cms/edit_blog.tmpl
    'You must set your Local Site Path.' => 'U dient uw lokale site-pad in te stellen.',
    'You must set your Site URL.' => 'U dient de URL van uw website in te stellen.',
    'You did not select a timezone.' => 'U hebt geen tijdzone geselecteerd.',
    'New Weblog Settings' => 'Instellingen nieuwe weblog',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'In dit scherm kunt u de basisgegevens invoeren die nodig zijn om een nieuwe weblog aan te maken;  Eens u op de \'opslaan\' knop heeft gedrukt, zal de weblog worden aangemaakt en kunt u verder gaan met de instellingen ervan te personaliseren of er berichten op te plaatsen.',
    'Your weblog configuration has been saved.' => 'Uw weblogconfiguratie is opgeslagen.',
    'Weblog Name:' => 'Weblognaam:',
    'Name your weblog. The weblog name can be changed at any time.' => 'Geef uw weblog een naam. De weblognaam kan op elk moment worden gewijzigd.',
    'Site URL:' => 'URL van website:',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'Voer de URL in van uw publieke website. Geef er geen bestandsnaam bij op (d.w.z. index.html weglatenom).',
    'Example:' => 'Voorbeeld:',
    'Site root:' => 'Hoofdmap van de site:',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Voer het pad in waarin uw hoofdindexbestand zich zal bevinden. Een absoluut pad (beginnend met \'/\') heeft de voorkeur, maar u kunt ook een pad kiezen relatief aan de Movable Type-directory.',
    'Timezone:' => 'Tijdzone:',
    'Time zone not selected' => 'Geen tijdzone geselecteerd',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nieuw-Zeeland - zomertijd)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (Internationale datumgrens - Oost)',
    'UTC+11' => 'UTC+11', # Translate
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
    'Select your timezone from the pulldown menu.' => 'Selecteer uw tijdzone in de keuzelijst.',

    ## ./tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => 'Selecteer wat u opnieuw wilt bouwen (druk op de knop \'Annuleren\' als u geen enkel bestand opnieuw wilt bouwen):',
    'Rebuild All Files' => 'Alle bestanden opnieuw opbouwen',
    'Index Template: [_1]' => 'Indexsjabloon: [_1]',
    'Rebuild Indexes Only' => 'Alleen indexen opnieuw opbouwen',
    'Rebuild [_1] Archives Only' => 'Alleen [_1] archieven opnieuw opbouwen',
    'Rebuild (r)' => 'Opnieuw opbouwen (r)',

    ## ./tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'Activiteitenlog leegmaken',

    ## ./tmpl/cms/ping_table.tmpl
    'From' => 'Van',
    'Target' => 'Doel',
    'Only show published TrackBacks' => 'Enkel gepubliceerde TrackBacks tonen',
    'Only show pending TrackBacks' => 'Enkel hangende TrackBacks tonen',
    'Edit this TrackBack' => 'Deze TrackBack bewerken',
    'Edit TrackBack' => 'TrackBack bewerken',
    'Go to the source entry of this TrackBack' => 'Ga naar het bronbericht van deze TrackBack',
    'View the [_1] for this TrackBack' => 'De [_1] bekijken voor deze TrackBack',

    ## ./tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'De TrackBack is goedgekeurd.',
    'List &amp; Edit TrackBacks' => 'TrackBacks tonen &amp; bewerken',
    'Junked TrackBack' => 'Verworpen TrackBack',
    'View all TrackBacks with this status' => 'Alle TrackBacks met deze status bekijken',
    'Source Site:' => 'Bronsite:',
    'Search for other TrackBacks from this site' => 'Andere TrackBacks van deze site zoeken',
    'Source Title:' => 'Brontitel:',
    'Search for other TrackBacks with this title' => 'Andere TrackBacks met deze titel zoeken',
    'Search for other TrackBacks with this status' => 'Andere TrackBacks met deze status zoeken',
    'Target Entry:' => 'Doelbericht:',
    'View all TrackBacks on this entry' => 'Alle TrackBacks op dit bericht bekijken',
    'Target Category:' => 'Doelcategorie:',
    'Category no longer exists' => 'Categorie bestaat niet meer',
    'View all TrackBacks on this category' => 'Alle TrackBacks op deze categorie bekijken',
    'View all TrackBacks posted on this day' => 'Alle TrackBacks die vandaag gestuurd zijn bekijken',
    'View all TrackBacks from this IP address' => 'Alle TrackBacks van dit IP adres bekijken',
    'Save this TrackBack (s)' => 'Deze TrackBack opslaan (s)',
    'Delete this TrackBack (d)' => 'Deze TrackBack verwijderen (d)',

    ## ./tmpl/cms/edit_entry.tmpl
    'Edit Entry' => 'Bericht bewerken',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.' => 'Uw bericht is opgeslagen. U kunt nu wijzigingen aan het bericht zelf aanbrengen, de datum veranderen, reacties bewerken of een notificatie verzenden.',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'Eén of meer problemen deden zich voor bij het versturen van update pings of TrackBacks.',
    'Your customization preferences have been saved, and are visible in the form below.' => 'Uw aanpassingenvoorkeuren zijn opgeslagen en zijn zichtbaar in het formulier hieronder.',
    'Your changes to the comment have been saved.' => 'Uw wijzigingen aan de reactie zijn opgeslagen.',
    'Your notification has been sent.' => 'Uw notificatie is verzonden.',
    'You have successfully deleted the checked comment(s).' => 'Verwijdering van de geselecteerde reactie(s) is geslaagd.',
    'You have successfully deleted the checked TrackBack(s).' => 'U heeft de geselecteerde TrackBack(s) met succes verwijderd.',
    'List &amp; Edit Entries' => 'Berichten weergeven en bewerken',
    'Comments ([_1])' => 'Reacties ([_1])',
    'TrackBacks ([_1])' => 'TrackBacks ([_1])', # Translate
    'Notification' => 'Notificatie',
    'Scheduled' => 'Gepland',
    'Bigger' => 'Groter',
    'Smaller' => 'Kleiner',
    'Authored On' => 'Geschreven op',
    'Accept TrackBacks' => 'TrackBacks aanvaarden',
    'View Previously Sent TrackBacks' => 'Eerder verzonden TrackBacks bekijken',
    'Customize the display of this page.' => 'Weergave van deze pagina aanpassen.',
    'Manage Comments' => 'Reacties beheren',
    'Click on the author\'s name to edit the comment. To delete a comment, check the box to its right and then click the Delete button.' => 'Klik op de auteursnaam om de reactie te bewerken. Als u een reactie wilt verwijderen, kruist u het vakje aan rechts ervan en klikt u vervolgens op de knop \'Verwijderen\'.',
    'No comments exist for this entry.' => 'Er zijn geen reacties op dit bericht.',
    'Manage TrackBacks' => 'TrackBacks beheren',
    'Click on the TrackBack title to view the page. To delete a TrackBack, check the box to its right and then click the Delete button.' => '
    Klik op de titel van de TrackBack om de pagina te bekijken.  Om een TrackBack te verwijderen, kruis het vakje aan rechts ervan en klik dan op de \'Verwijderen\' knop.',
    'No TrackBacks exist for this entry.' => 'Er zijn geen TrackBacks op dit bericht.',
    'Send a Notification' => 'Notificatie verzenden',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.' => 'U kunt een notificatie verzenden naar een groep van uw lezers. Voer het e-mailbericht in dat u wilt invoegen onder de link naar dit weblogbericht. U kan het hierboven getoonde uittreksel of het gehele bericht mee versturen.',
    'Include excerpt' => 'Uittreksel opnemen',
    'Include entire entry body' => 'Gehele bericht opnemen',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.' => 'Opmerking: als u ervoor kiest om het gehele weblogbericht te verzenden, dan wordt alle eventueel inbegrepen HTML mee in de e-mail opgenomen.',
    'Additional notification lists:' => 'Bijkomende notificatielijsten:',
    'Send notification to the above lists only' => 'Stuur enkel notificaties naar de bovenstaande lijsten',
    'Send' => 'Verzenden',

    ## ./tmpl/cms/entry_table.tmpl
    'Author' => 'Auteur',
    'Only show unpublished entries' => 'Enkel ongepubliceerde berichten tonen',
    'Only show published entries' => 'Enkel gepubliceerde berichten tonen',
    'Only show future entries' => 'Enkel toekomstige berichten tonen',
    'Future' => 'Toekomstig',

    ## ./tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => 'Hier is een lijst met TrackBacks die eerder met succes werden verstuurd:',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => 'Hier is een lijst met de vorige TrackBacks die mislukten.  Om ze opnieuw te proberen, neem ze op in de lijst uitgaande TrackBack URLs van uw bericht.:',

    ## ./tmpl/cms/view_log.tmpl
    'The Movable Type activity log contains a record of notable actions in the system.' => 'Het Movable Type activiteitenlog bevat een overzicht van alle belangrijke gebeurtenissen in het systeem.',
    'All times are displayed in GMT[_1].' => 'Alle tijdstippen worden getoond in GMT[_1].',
    'All times are displayed in GMT.' => 'Alle tijdstippen worden getoond in GMT.',
    'The activity log has been reset.' => 'Het activiteitenlog is leeggemaakt.',
    'Show only errors.' => 'Enkel fouten tonen.',
    '(Showing all log records)' => '(Alle logberichten worden getoond)',
    'Showing only log records where' => 'Enkel logberichten worden getoond waarbij',
    'log records.' => 'logberichten.',
    'log records where' => 'logberichten waarbij',
    'level' => 'niveau',
    'classification' => 'classificatie',
    'information' => 'informatie',
    'warnings' => 'waarschuwingen',
    'errors' => 'fouten',
    'security' => 'veiligheid',
    'debug messages' => 'debugberichten',
    'info+warn' => 'info+waaarschuwingen',
    'info+warn+err' => 'info+waarschuwingen+fouten',
    'info+warn+err+security' => 'info+waarschuwingen+fouten+veiligheid',
    'Generate Feed' => 'Feed aanmaken',
    'Generate a feed of this data.' => 'Feed aanmaken van deze gegevens.',
    'No log records could be found.' => 'Er werden geen logberichten gevonden.',

    ## ./tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => '
    Deze domeinnamen werden gevonden in de geselecteerde reacties.  Kruis het vakje rechts ervan aan om reacties en trackbacks die deze URL bevatten in te toekomst te blokkeren.',
    'Block' => 'Blokkeren',

    ## ./tmpl/cms/edit_categories.tmpl
    'Your category changes and additions have been made.' => 'De wijzigingen en toevoegingen aan uw categorieën zijn toegepast.',
    'You have successfully deleted the selected categories.' => 'Verwijderen van de geselecteerde categorieën is geslaagd.',
    'Create new top level category' => 'Categorie van het hoogste niveau aanmaken',
    'Actions' => 'Acties',
    'Create Category' => 'Categorie aanmaken',
    'Top Level' => 'Topniveau',
    'Collapse' => 'Inklappen',
    'Expand' => 'Uitklappen',
    'Create Subcategory' => 'Subcategorie aanmaken',
    'Move Category' => 'Categorie verplaatsen',
    'Move' => 'Schuif',
    '[quant,_1,TrackBack]' => '[quant,_1,TrackBack]', # Translate
    'categories' => 'categorieën',
    'Delete selected categories (d)' => 'Geselecteerde categorieën verwijderen (d)',

    ## ./tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => 'Weet u zeker dat u [quant,_1,auteur] permanent van het systeem wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,comment]?' => 'Weet u zeker dat u [quant,_1,reactie, reacties] wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => 'Went u zeker dat u [quant,_1,TrackBack] wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => 'Weet u zeker dat u [quant,_1,bericht,berichten] wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,template]?' => 'Weet u zeker dat u [quant,_1,sjabloon, sjablonen] wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => 'Weet u zeker dat u [quant,_1,categorie,categorieën] wilt verwijderen? Als u een categorie verwijdert, wordt de toewijzing van berichten naar die categorie ongedaan gemaakt.',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'Weet u zeker dat u [quant,_1,sjabloon] van die bepaalde archieftype(s) wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => 'Weet u zeker dat u [quant,_1,IP-adres,IP-adressen] van uw lijst met uitgesloten IP-adressen wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => 'Weet u zeker dat u [quant,_1,notificatie-adres,notifictatie-adressen] wilt verwijderen? ',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => 'Went u zeker dat u [quant,_1,geblokkeerd item,geblokkeerde items] wilt verwijderen?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => 'Weet u zeker dat u [quant,_1,weblog] wilt verwijderen? Wanneer u een weblog verwijdert, worden alle berichten, reacties, sjablonen, notificaties en auteurspermissies die bij de weblog horen tevens verwijderd. Verzeker u dat u dit wilt, aangezien deze actie permanent is.',

    ## ./tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'Bezig met pingen van sites...',

    ## ./tmpl/cms/edit_permissions.tmpl
    'Author Permissions' => 'Auteurspermissies',
    'Your changes to [_1]\'s permissions have been saved.' => 'Uw wijzigingen aan de permissies van [_1] zijn opgeslagen.',
    '[_1] has been successfully added to [_2].' => '[_1] is toegevoegd als auteur van [_2].',
    'User can create weblogs' => 'Gebruiker mag weblogs aanmaken',
    'User can view activity log' => 'Gebruiker kan activiteitenlog bekijken',
    'Check All' => 'Alles aanvinken',
    'Uncheck All' => 'Alles uitvinken',
    'Weblog:' => 'Weblog:', # Translate
    'Unheck All' => 'Alles uitvinken',
    'Add user to an additional weblog:' => 'Gebruiker aan een extra weblog toevoegen:',
    'Add' => 'Toevoegen',
    'Save permissions for this author (s)' => 'Permissies opslaan voor deze auteur(s)',

    ## ./tmpl/cms/notification_table.tmpl
    'Date Added' => 'Toegevoegd op',

    ## ./tmpl/cms/list_notification.tmpl
    'Below is the list of people who wish to be notified when you post to your site. To delete an address, check the Delete box and press the Delete button.' => 'Hieronder vindt u een lijst met de personen die automatisch notificatie willen ontvangen wanneer u iets publiceert op uw site. Kruis het vakje \'Verwijderen\' aan en druk op de knop \'Verwijderen\' als u een adres wilt verwijderen.',
    'You have [quant,_1,user,users,no users] in your notification list.' => 'U hebt [quant,_1,gebruiker,gebruikers,geen gebruikers] aan uw notificatielijst toegevoegd.',
    'You have added [_1] to your notification list.' => 'U hebt [_1] aan uw notificatielijst toegevoegd.',
    'You have successfully deleted the selected notifications from your notification list.' => 'U hebt de geselecteerde notificaties uit uw notificatielijst verwijderd.',
    'Create New Notification' => 'Nieuwe notificatie aanmaken',
    'URL (Optional):' => 'URL (optioneel):',
    'Add Recipient' => 'Ontvanger toevoegen',
    'No notifications could be found.' => 'Er werden geen notificaties gevonden.',

    ## ./tmpl/cms/cfg_prefs.tmpl
    'General Settings' => 'Algemene instellingen',
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'Via dit scherm kunt u uw algemene webloginstellingen beheren, de standaardinstellingen voor het tonen van weblogs en instellingen voor diensten van derden.',
    'Weblog Settings' => 'Webloginstellingen',
    'Description:' => 'Beschrijving:',
    'Enter a description for your weblog.' => 'Geef uw weblog een beschrijving.',
    'Default Weblog Display Settings' => 'Standaardinstellingen voor het tonen van de weblog',
    'Entries to Display:' => 'Aantal berichten te tonen:',
    'Days' => 'Dagen',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'Selecteer het aantal dagen waarvoor berichten moeten worden getoond op uw weblog, of het exacte aantal berichten.',
    'Entry Order:' => 'Volgorde berichten:',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u uw berichten wilt weergeven in oplopende (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
    'Comment Order:' => 'Volgorde reacties:',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Selecteer of u reacties van bezoekers wilt weergeven in oplopende (oudste bovenaan) of aflopende (nieuwste bovenaan) volgorde.',
    'Excerpt Length:' => 'Lengte uittreksels:',
    'Enter the number of words that should appear in an auto-generated excerpt.' => 'Vul het aantal woorden in dat moet verschijnen in automatisch gegenereerde uittreksels.',
    'Date Language:' => 'Taal om datums in te tonen:',
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
    'Select the language in which you would like dates on your blog displayed.' => 'Selecteer de taal waarin u de datums op uw blogs wilt weergeven.',
    'Limit HTML Tags:' => 'HTML tags beperken:',
    'Use defaults' => 'Standaardwaarden gebruiken',
    '([_1])' => '([_1])', # Translate
    'Use my settings' => 'Mijn instellingen gebruiken',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'Geeft een lijst met HTML-tags op die standaard zijn toegestaan wanneer een HTML-string wordt schoongemaakt (bijv. een reactie).',
    'Third-Party Services' => 'Diensten van derden',
    'Creative Commons License:' => 'Creative Commons licentie:',
    'Your weblog is currently licensed under:' => 'Uw weblog valt momenteel onder de volgende licentie:',
    'Change your license' => 'Uw licentie wijzigen',
    'Remove this license' => 'Deze licentie verwijderen',
    'Your weblog does not have an explicit Creative Commons license.' => 'Uw weblog heeft geen uitdrukkelijke Creative Commons licentie.',
    'Create a license now' => 'Maak nu een licentie aan',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'Selecteer een Creative Commons licentie voor de berichten op uw blog (optioneel).',
    'Be sure that you understand these licenses before applying them to your own work.' => 'Zorg dat u deze licenties begrijpt voordat u ze op uw eigen werk toepast.',
    'Read more.' => 'Lees verder.',
    'Google API Key:' => 'Google API-code:',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Als u een Google API-functie wilt gebruiken, hebt u een Google API-code nodig. Plak deze hier.',

    ## ./tmpl/cms/edit_category.tmpl
    'Edit Category' => 'Categorie bewerken',
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'Gebruik deze pagina om de attributen van de categorie [_1] te bewerken. U kunt een beschrijving instellen voor uw categorie die u wilt gebruiken op uw publieke pagina\'s, alsmede de TrackBack-opties voor deze categorie configureren.',
    'Your category changes have been made.' => 'Uw categoriewijzigingen zijn gemaakt.',
    'Details' => 'Details', # Translate
    'Label' => 'Etiket',
    'Unlock this category\'s output filename for editing' => 'Maak het uitvoerbestand van deze categorie bewerkbaar',
    'Warning: Changing this category\'s basename may break inbound links.' => 'Waarschuwing: de basisnaam van deze categorie veranderen kan inkomende links verbreken.',
    'Save this category (s)' => 'Deze categorie opslaan (s)',
    'Inbound TrackBacks' => 'Inkomende TrackBacks',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'Indien ingeschakeld, zullen TrackBacks voor deze categorie worden aanvaard uit elke bron.',
    'TrackBack URL for this category' => 'TrackBack URL voor deze categorie',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'Dit is de URL die anderen zullen gebruiken om TrackBacks naar uw weblog te sturen.  Indien u wenst dat iedereen een TrackBack naar uw weblog kan sturen wanneer ze een bericht hebben dat specifiek over deze categorie gaat, maak dan deze URL publiek bekend.  Indie u enkel aan een selecte groep mensen wenst toelating te geven om TrackBacks te sturen, stuur hen dan privé deze URL.  Om een lijst van binnenkomende TrackBacks op te nemen in uw hoofdindexsjabloon, gelieve de documentatie te raadplegen voor tags die te maken hebben met TrackBacks.',
    'Passphrase Protection' => 'Wachtwoordbeveiliging',
    'Optional.' => 'Optioneel.',
    'Outbound TrackBacks' => 'Uitgaande TrackBacks',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'Voer de URL(s) in van de websites waar u een TrackBack naartoe wenst te sturen telkens u een bericht publiceert in deze categorie. (Afzonderlijke URLs op nieuwe regels.)',

    ## ./tmpl/cms/pager.tmpl
    'Show:' => 'Toon:',
    '[quant,_1,row]' => '[quant,_1,rij,rijen]',
    'all rows' => 'alle rijen',
    'Another amount...' => 'Ander aantal...',
    'Actions:' => 'Acties:',
    'Below' => 'Onder',
    'Above' => 'Boven',
    'Both' => 'Allebei',
    'Date Display:' => 'Datumopmaak:',
    'Relative' => 'Relatief',
    'Full' => 'Volledig',
    'Newer' => 'Nieuwer',
    'Showing:' => 'Getoond:',
    'of' => 'van',
    'Older' => 'Ouder',

    ## ./tmpl/cms/template_table.tmpl

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => 'Dit bericht opnieuw bewerken',
    'Save this entry' => 'Dit bericht opslaan',

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/category_add.tmpl
    'Add A Category' => 'Een categorie toevoegen',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'Om nieuwe categorie toe te voegen, geeft u een titel op in het onderstaande veld, selecteert u een overkoepelende categorie en klikt u op de knop \'Toevoegen\'.',
    'Category Title:' => 'Titel van de categorie:',
    'Parent Category:' => 'Overkoepelende categorie:',

    ## ./tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => 'IP-verbanningsinstellingen',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'Via dit scherm kunt u reacties en TrackBacks van specifieke IP-adressen weren.',
    'You have banned [quant,_1,address,addresses].' => 'U heeft [quant,_1,adres,adressen] verbannen.',
    'You have added [_1] to your list of banned IP addresses.' => 'U hebt [_1] toegevoegd aan uw lijst met uitgesloten IP-adressen.',
    'You have successfully deleted the selected IP addresses from the list.' => 'U hebt de geselecteerde IP-adressen uit de lijst is verwijderd.',
    'Ban New IP Address' => 'Nieuw IP-adres verbannen',
    'IP Address:' => 'IP-adres:',
    'Ban IP Address' => 'IP-adres verbannen',
    'Date Banned' => 'Verbanningsdatum',
    'IP address' => 'IP address', # Translate
    'IP addresses' => 'IP-addressen',

    ## ./tmpl/cms/list_ping.tmpl
    'The selected TrackBack(s) has been published.' => 'De geselecteerde TrackBack(s) zijn gepubliceerd.',
    'All junked TrackBacks have been removed.' => 'Alle als spam gemarkeerde TrackBacks zijn verwijderd.',
    'The selected TrackBack(s) has been unpublished.' => 'De geselecteerde TrackBack(s) zijn niet langer gepubliceerd.',
    'The selected TrackBack(s) has been junked.' => 'De geselecteerde TrackBack(s) zijn verworpen.',
    'The selected TrackBack(s) has been unjunked.' => 'De geselecteerde TrackBack(s) zijn niet langer als verworpen gemarkeerd.',
    'The selected TrackBack(s) has been deleted from the database.' => 'De geselecteerde TrackBack(s) zijn uit de database verwijderd.',
    'No TrackBacks appeared to be junk.' => 'Geen verworpen TrackBacks gevonden.',
    'Junk TrackBacks' => 'Verworpen TrackBacks',
    'Show unpublished TrackBacks.' => 'Ongepubliceerde TrackBacks tonen.',
    '(Showing all TrackBacks)' => '(Alle TrackBacks worden getoond)',
    'Showing only TrackBacks where [_1] is [_2].' => 'Enkel TrackBacks waarbij [_1] gelijk is aan [_2] worden getoond.',
    'TrackBacks.' => 'TrackBacks.', # Translate
    'TrackBacks where' => 'TrackBacks met',
    'No TrackBacks could be found.' => 'Er werden geen TrackBacks gevonden.',
    'No junk TrackBacks could be found.' => 'Er werden geen als spam gemarkeerde TrackBacks gevonden.',

    ## ./tmpl/cms/edit_profile.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'Uw wachtwoord is veranderd en het nieuwe wachtwoord is naar uw e-mailadres ([_1]) gestuurd.',
    'Password Recovery' => 'Wachtwoordherstel',

    ## ./tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'Bent u zeker dat u de instellingen voor deze plugin wil terugzetten naar de standaardwaarden?',
    'Disable plugin system?' => 'Plugin-systeem uitschakelen?',
    'Disable this plugin?' => 'Deze plugin uitschakelen?',
    'Enable plugin system?' => 'Plugin-systeem inschakelen?',
    'Enable this plugin?' => 'Deze plugin inschakelen?',
    'Plugin Settings' => 'Instellingen plugins',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'Via dit scherm kunt u de instellingen per weblog beheren van alle configureerbare plugins die u heeft geïnstalleerd.',
    'Your plugin settings have been saved.' => 'Uw plugin-instellingen zijn opgeslagen.',
    'Your plugin settings have been reset.' => 'Uw plugin-instellingen zijn teruggezet op de standaardwaarden.',
    'Your plugins have been reconfigured.' => 'Uw plugins zijn opnieuw geconfigureerd.',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => '
    Uw plugins zijn opnieuw geconfigureerd.  Omdat u mod_perl draait, moet u uw webserver opnieuw starten om de wijzigingen van kracht te maken.',
    'Registered Plugins' => 'Geregistreerde plugins',
    'Disable Plugins' => 'Plugins uitschakelen',
    'Enable Plugins' => 'Plugins inschakelen',
    'Error' => 'Fout',
    'Failed to Load' => 'Laden mislukt',
    'Disable' => 'Uitschakelen',
    'Enabled' => 'Ingeschakeld',
    'Enable' => 'Inschakelen',
    'Documentation for [_1]' => 'Documentatie voor [_1]',
    'Documentation' => 'Documentatie',
    'Author of [_1]' => 'Auteur van [_1]',
    'More about [_1]' => 'Meer over [_1]',
    'Support' => 'Ondersteuning',
    'Plugin Home' => 'Homepage van deze plugin',
    'Resources' => 'Bronnen',
    'Show Resources' => 'Bronnen weergeven',
    'More Settings' => 'Meer instellingen',
    'Show Settings' => 'Instellingen tonen',
    'Settings for [_1]' => 'Instellingen voor [_1]',
    'Version' => 'Versie',
    'Resources Provided by [_1]' => 'Bronnen voorzien door [_1]',
    'Tag Attributes' => 'Eigenschappen tag',
    'Text Filters' => 'Tekstfilters',
    'Junk Filters' => 'Spamfilters',
    '[_1] Settings' => '[_1] instellingen',
    'Reset to Defaults' => 'Terugzetten naar standaardwaarden',
    'Plugin error:' => 'Pluginfout:',
    'No plugins with weblog-level configuration settings are installed.' => 'Er zijn geen plugins geïnstalleerd die configuratie-opties hebben op weblogniveau.',

    ## ./tmpl/cms/error.tmpl
    'An error occurred:' => 'Er deed zich een fout voor:',
    'Go Back' => 'Ga terug',

    ## ./tmpl/cms/recover.tmpl
    'Enter your Movable Type username:' => 'Voer uw Movable Type-gebruikersnaam in:',
    'Enter your password hint:' => 'Voor uw wachtwoord-hint in:',
    'Recover' => 'Herstel',

    ## ./tmpl/cms/cfg_entries_edit_page.tmpl
    'Entry Page Default Settings' => 'Standaardinstellingen voor berichtenpagina',

    ## ./tmpl/cms/list_comment.tmpl
    'The selected comment(s) has been published.' => 'De geselecteerde reactie(s) zijn gepubliceerd.',
    'All junked comments have been removed.' => 'Alle als spam gemarkeerde reacties zijn verwijderd.',
    'The selected comment(s) has been unpublished.' => 'De geselecteerde reactie(s) zijn niet langer gepubliceerd.',
    'The selected comment(s) has been junked.' => 'De geselecteerde reactie(s) zijn verworpen.',
    'The selected comment(s) has been unjunked.' => 'De geselecteerde reactie(s) zijn niet langer als verworpen gemarkeerd.',
    'The selected comment(s) has been deleted from the database.' => 'Geselecteerde reactie(en) zijn uit de database verwijderd.',
    'One or more comments you selected were submitted by an unauthenticated visitor. These commenters cannot be assigned trust (or marked as untrusted) without proper authentication.' => 'Eén of meer van de reacties die u selecteerde werden achtergelaten door een niet geauthenticeerde bezoeker.  Deze reageerders kunnen niet als \'vertrouwd\' (of \'niet vertrouwd\') worden gemarkeerd zonder geldige authenticatie..',
    'No comments appeared to be junk.' => 'Er zijn geen reacties verworpen.',
    'Go to Commenter Listing' => 'Ga naar overzicht reageerders',
    '(Showing all comments)' => '(Alle reacties worden getoond)',
    'Showing only comments where [_1] is [_2].' => 'Enkel reacties waarbij [_1] gelijk is aan [_2] worden getoond.',
    'comments.' => 'reacties.',
    'comments where' => 'reacties met',
    'No comments could be found.' => 'Er werden geen reacties gevonden.',
    'No junk comments could be found.' => 'Er werden geen verworpen reacties gevonden.',

    ## ./tmpl/cms/footer-popup.tmpl

    ## ./tmpl/cms/system_info.tmpl
    'System Status and Information' => 'Systeemtatus en informatie',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'Deze pagina zal binnenkort informatie bevatten over de beschikbaarheid op de serveromgeving van vereiste perl-modules, geïnstalleerde plugins en andere nuttige informatie die kan dienen bij het makkelijker debuggen bij vragen om technische ondersteuning',

    ## ./tmpl/cms/import_end.tmpl
    'All data imported successfully! Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Alle gegevens met succes geïmporteerd! Vergeet niet om de bestanden die u importeerde te verwijderen uit de \'import\' map, zodat als/wanneer u het importproces nogmaals doet lopen deze bestanden niet nogmaals worden geïmporteerd.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',

    ## ./tmpl/cms/cfg_feedback.tmpl
    'Feedback Settings' => 'Feedback instellingen',
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => ' Via dit scherm kunt u de instellingen voor feedback op deze weblog beheren, inclusief reacties en TrackBacks.',
    'Rebuild indexes' => 'Indexen herbouwen',
    'Note: Commenting is currently disabled at the system level.' => 'Opmerking: reacties zijn momenteel uitgeschakeld op het systeemniveau.',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => 'Reactie-authenticatie is niet beschikbaar omdat één van de benodigde modules, MIME::Base64 of LWP::UserAgent niet is geïnstalleerd.  Praat met uw host om de module te doen installeren.',
    'Accept comments from' => 'Reacties aanvaarden van',
    'Anyone' => 'Iedereen',
    'Authenticated commenters only' => 'Enkel geauthenticeerde reageerders',
    'No one' => 'Niemand',
    'Specify from whom Movable Type shall accept comments on this weblog.' => 'Geef aan van wie Movable Type reacties op deze weblog zal aanvaarden.',
    'Authentication Status' => 'Authenticatiestatus',
    'Authentication Enabled' => 'Authenthicatie ingeschakeld',
    'Authentication is enabled.' => 'Authenticatie is ingeschakeld.',
    'Clear Authentication Token' => 'Authenticatietoken leegmaken',
    'Authentication Token:' => 'Authenticatietoken:',
    'Authentication Token Removed' => 'Authenticatietoken verwijderd',
    'Please click the Save Changes button below to disable authentication.' => 'Gelieve op de knop \'Wijzigingen opslaan\' te drukken om authenticatie uit te schakelen.',
    'Authentication Not Enabled' => 'Authenticatie is niet ingeschakeld',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => 'Opmerking: u heeft ervoor gekozen om enkel reacties te aanvaarden van geauthenticeerde reageerders, maar authenticatie is niet ingeschakeld.  Om geauthenticeerde reacties te kunnen ontvangen, moet u authenticatie inschakelen.',
    'Authentication is not enabled.' => 'Authenticatie is niet ingeschakeld.',
    'Setup Authentication' => 'Authenticatie inschakelen',
    'Or, manually enter token:' => 'Of, manueel token ingeven:',
    'Authentication Token Inserted' => 'Authenticatietoken ingevoerd',
    'Please click the Save Changes button below to enable authentication.' => 'Gelieve op de knop \'Wijzigingen opslaan\' te drukken om authenticatie in te schakelen.',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'Leg een link tussen uw weblog een een authenticatieservice.  U kunt hiervoor TypeKey gebruiken (een gratis dienst, standaard beschikbaar) of een andere, compatibele service.',
    'Require E-mail Address' => 'E-mail adres vereisen',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Indien ingeschakeld moeten bezoekers een geldig e-mail adres opgeven wanneer ze reageren.',
    'Immediately publish comments from' => 'Onmiddellijk reacties publiceren van',
    'Trusted commenters only' => 'Enkel vertrouwde reageerders',
    'Any authenticated commenters' => 'Elke geauthenticeerde reageerder',
    'Specify what should happen to non-junk comments after submission.' => 'Geef aan wat er moet gebeuren met reacties die niet automatisch verworpen werden na het indienen.',
    'Unpublished comments are held for moderation.' => 'Ongepubliceerde reacties worden bewaard voor moderatie.',
    'E-mail Notification' => 'E-mail notificatie',
    'On' => 'Aan',
    'Only when attention is required' => 'Alleen wanneer er aandacht is vereist',
    'Specify when Movable Type should notify you of new comments if at all.' => 'Geef aan wanneer Movable Type u op de hoogte moet brengen van reacties, indien gewenst.',
    'Allow HTML' => 'HTML toestaan',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'Indien ingeschakeld zullen gebruikers een beperkte set HTML tags kunnen gebruiken in hun reacties.  Indien niet zal alle HTML verwijderd worden.',
    'Auto-Link URLs' => 'Automatisch URL\'s omzetten in links',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => 'Indien ingeschakeld zullen alle URLs die nog geen link zijn automatisch omgezet worden in links naar die URL.',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Geeft weer welke tekstopmaakoptie moet worden gebruikt voor de opmaak van reacties van bezoekers.',
    'Note: TrackBacks are currently disabled at the system level.' => 'Opmerking: TrackBacks zijn momenteel uitgeschakeld op systeemniveau.',
    'If enabled, TrackBacks will be accepted from any source.' => 'Indien ingeschakeld zullen TrackBacks worden aanvaard van eender welke bron.',
    'Moderation' => 'Moderatie',
    'Hold all TrackBacks for approval before they\'re published.' => 'Alle TrackBacks tegenhouden om goedgekeurd te worden voor ze worden gepubliceerd.',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'Geef aan wanneer Movable Type u op de hoogte moet brengen van nieuwe TrackBacks, indien gewenst.',
    'Junk Score Threshold' => 'Drempel voor verwerping',
    'Less Aggressive' => 'Minder aggressief',
    'More Aggressive' => 'Aggressiever',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => 'Reacties en TrackBacks ontvangen een spamscore tussen -10 (complete rotzooi) en +10 (geldig bericht).  Feedback met een score die lager is dan de getoonde drempel wordt aangemerkt als verworpen.',
    'Auto-Delete Junk' => 'Automatisch verworpen items verwijderen',
    'If enabled, junk feedback will be automatically erased after a number of days.' => 'Indien ingeschakeld zal verworpen feedback automatisch worden verwijderd na een aantal dagen.',
    'Delete Junk After' => 'Verworpen items verwijderen na',
    'days' => 'dagen',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => 'Indien een item dit aantal dagen als verworpen gemarkeerd is gebleven wordt het automatisch verwijderd.',

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => '[_1] wordt opnieuw opgebouwd',
    'Rebuilding [_1] pages [_2]' => 'Opnieuw opbouwen van [_1] pagina\'s [_2]',
    'Rebuilding [_1] dynamic links' => 'Dynamische [_1] links worden opnieuw opgebouwd',
    'Rebuilding [_1] pages' => 'Opnieuw opbouwen [_1] pagina\'s',

    ## ./tmpl/cms/create_author_bulk_start.tmpl
    'Creating...' => 'Aan het aanmaken...',
    'Creating authors' => 'Auteurs worden aangemaakt',
    'Creating new authors by reading the uploaded CSV file' => 'Nieuwe auteurs worden aangemaakt door het opgeladen CSV bestand in te lezen',

    ## ./tmpl/cms/blog_actions.tmpl
    'weblog' => 'weblog', # Translate
    'weblogs' => 'weblogs', # Translate
    'Delete selected weblogs (d)' => 'Geselecteerde weblog(s) verwijderen',

    ## ./tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'Lijst weblogs',
    'List Authors' => 'Lijst auteurs',
    'List Plugins' => 'Lijst plugins',
    'Aggregate' => 'Inhoudelijk',
    'List Tags' => 'Tags oplijsten',
    'Edit System Settings' => 'Systeeminstellingen bewerken',
    'Show Activity Log' => 'Activiteitenlog bekijken',

    ## ./tmpl/cms/menu.tmpl
    'Five Most Recent Entries' => 'Vijf laatste berichten',
    'View all Entries' => 'Alle berichten bekijken',
    'Five Most Recent Comments' => 'Vijf laatste reacties',
    'View all Comments' => 'Alle reacties bekijken',
    'Five Most Recent TrackBacks' => 'Vijf laatste TrackBacks',
    'View all TrackBacks' => 'Alle TrackBacks bekijken',
    'Welcome to [_1].' => 'Welkom bij [_1].',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => 'U kunt publiceren naar uw weblog en uw weblog beheren door een optie te kiezen uit het menu links naast deze boodschap.',
    'If you need assistance, try:' => 'Als u hulp nodig hebt, probeer:',
    'Movable Type User Manual' => 'Gebruikershandleiding van Movable Type',
    'Movable Type Technical Support' => 'Movable Type technische ondersteuning',
    'Movable Type Support Forum' => 'Ondersteuningsforum van Movable Type',
    'This welcome message is configurable.' => 'Dit welkomstbericht is configureerbaar.',
    'Change this message.' => 'Dit bericht wijzigen.',

    ## ./tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'Installatie voltooid.',
    'Upgrade complete.' => 'Upgrade voltooid.',
    'Initializing database...' => 'Database wordt geïnitialiseerd...',
    'Upgrading database...' => 'Database wordt bijgewerkt...',
    'Starting installation...' => 'Instalatie gaat van start...',
    'Starting upgrade...' => 'Upgrade gaat van start...',
    'Error during installation:' => 'Fout tijdens installatie:',
    'Error during upgrade:' => 'Fout tijdens upgrade:',
    'Installation complete!' => 'Installatie voltooid!',
    'Upgrade complete!' => 'Upgrade voltooid!',
    'Login to Movable Type' => 'Aanmelden op Movable Type',
    'Return to Movable Type' => 'Terugkeren naar Movable Type',
    'Your database is already current.' => 'Uw database is reeds up-to-date.',

    ## ./tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'Uw Movable Type-sessie is beëindigd. Als u zich opnieuw wilt aanmelden, dan kunt u dat hieronder doen.',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'Uw Movable Type sessie is verlopen.  Gelieve opnieuw aan te melden om verder te gaan met deze handeling.',
    'Remember me?' => 'Mij onthouden?',
    'Log In' => 'Aanmelden',
    'Forgot your password?' => 'Uw wachtwoord vergeten?',

    ## ./tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'Bent u zeker dat u deze weblog wenst te verwijderen?',
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'Hieronder ziet u een lijst van alle weblogs in het systeem met koppelingen naar de hoofdpagina en individuele instellingen van elk ervan.  U kunt ook weblogs aanmaken of wissen vanop dit scherm.',
    'You have successfully deleted the blogs from the Movable Type system.' => 'U heeft met succes de blogs verwijderd uit het Movable Type systeem.',
    'Create New Weblog' => 'Nieuwe weblog aanmaken',
    'No weblogs could be found.' => 'Er werden geen weblogs gevonden.',

    ## ./tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'Bent u zeker dat u deze sjabloonkoppeling wenst te verwijderen?',
    'Publishing Settings' => 'Publicatie-instellingen',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'Via dit scherm kunt u de publicatiepaden en -voorkeuren van deze weblog beheren, net als de instellingen voor archiefkoppelingen.',
    'Go to Templates Listing' => 'Ga naar sjabloonoverzicht',
    'Go to Template Listing' => 'Ga naar sjabloonoverzicht',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'Fout: Movable Type kon geen map aanmaken om uw weblog te publiceren.  Als u deze map met de hand aanmaakt, ken dan voldoende permissies toe zodat Movable Type toelating heeft om bestanden aan te maken erin.',
    'Your weblog\'s archive configuration has been saved.' => 'De archiefconfiguratie van uw weblog is opgeslagen.',
    'You may need to update your templates to account for your new archive configuration.' => 'Mogelijk moet u uw sjablonen bijwerken om rekening te houden met uw nieuwe archiefconfiguratie.',
    'You have successfully added a new archive-template association.' => 'U hebt een nieuwe koppeling tussen een archief en een sjabloon toegevoegd.',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'Het kan zijn dat u uw \'Hoofdarchiefindex\' sjabloon moet bijwerken om rekening te houden met uw nieuwe archiefconfiguratie.',
    'The selected archive-template associations have been deleted.' => 'De geselecteerde koppelingen tussen een archief en een sjabloon zijn verwijderd.',
    'Publishing Paths' => 'Publicatiepaden',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'Voer de URL in van uw website. Zorg dat er geen bestandsnaam in staat (m.a.w. laat index.html vallen).',
    'Site Root:' => 'Site-root:',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'Voer het pad in waar uw indexbestanden zullen worden gepubliceerd.  Een absoluut pad (beginnend met \'/\') verdient de voorkeur, maar u kunt ook een pad gebruiken relatief aan de Movable Type map.',
    'Advanced Archive Publishing:' => 'Geavanceerde archiefpublicatie:',
    'Publish archives to alternate root path' => 'Archieven publiceren op een alternatief root-pad.',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'Selecteer deze optie alleen als u uw archieven buiten de root van uw site wenst te publiceren.',
    'Archive URL:' => 'Archief-URL:',
    'Enter the URL of the archives section of your website.' => 'Voer de URL in van de archiefsectie van uw website.',
    'Archive Root:' => 'Archief-root:',
    'Enter the path where your archive files will be published.' => 'Voer het pad in waar uw archiefbestanden gepubliceerd moeten worden.',
    'Publishing Preferences' => 'Publicatievoorkeuren',
    'Preferred Archive Type:' => 'Voorkeursarchieftype:',
    'No Archives' => 'Geen archieven',
    'Individual' => 'individuele',
    'Daily' => 'dagelijkse',
    'Weekly' => 'wekelijkse',
    'Monthly' => 'maandelijkse',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'Als u een link naar een gearchiveerde bericht wilt maken&#8212; voor een permalink, bijvoorbeeld&#8212;dan moet u een link naar een bepaald archiveringstype maken, zelfs als u meerdere archieftypes hebt gekozen.',
    'File Extension for Archive Files:' => 'Bestandsextensie voor archiefbestanden:',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'Voer de bestandsextensie voor het archief in. Dit kan zijn in de vorm van \'html\', \'shtml\', \'php\', enz. Opmerking: voer het eerste punt niet in (\'.\').',
    'Dynamic Publishing:' => 'Dynamisch publiceren:',
    'Build all templates statically' => 'Alle sjablonen statisch bouwen',
    'Build only Archive Templates dynamically' => 'Enkel archiefsjablonen dynamisch bouwen',
    'Set each template\'s Build Options separately' => 'Bouwopties voor elk sjabloon apart instellen',
    'Archive Mapping' => 'Archiefkoppeling',
    'This advanced feature allows you to map any archive template to multiple archive types. For example, you may want to create two different views of your monthly archives: one in which the entries for a particular month are presented as a list, and the other representing the entries in a calendar view of that month.' => 'Deze geavanceerde mogelijkheid laat u toe om eender welk archiefsjabloon te koppelen aan meerdere archieftypes.  U wenst misschien twee verschillende versies maken van uw maandelijks archief: één met de berichten van een bepaalde maand getoond als een lijst en een andere die alles in een kalenderformaat toont.',
    'Create New Archive Mapping' => 'Nieuwe archiefkoppeling aanmaken',
    'Archive Type:' => 'Archieftype:',
    'INDIVIDUAL_ADV' => 'Individueel',
    'DAILY_ADV' => 'Dagelijks',
    'WEEKLY_ADV' => 'Wekelijks',
    'MONTHLY_ADV' => 'Maandelijks',
    'CATEGORY_ADV' => 'Categorie',
    'Template:' => 'Sjabloon:',
    'Archive Types' => 'Archieftypes',
    'Template' => 'Sjabloon',
    'Archive File Path' => 'Archiefbestandspad',
    'Preferred' => 'Voorkeur',
    'Custom...' => 'Gepersonaliseerd...',
    'archive map' => 'archiefkoppeling',
    'archive maps' => 'archiefkoppelingen',

    ## ./tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'Meer handelingen...',
    'Go' => 'Ga',
    'No actions' => 'Geen handelingen',

    ## ./tmpl/cms/recover_password_result.tmpl
    'Recover Password' => 'Wachtwoord terugvinden',

    ## ./tmpl/cms/create_author_bulk_end.tmpl
    'All authors created successfully!' => 'Alle auteurs met succes aangemaakt!',
    'An error occurred during the creation process. Please check your CSV file.' => 'Er deed zich een fout voor bij het aanmaakproces.  Gelieve uw CSV bestand na te kijken.',

    ## ./tmpl/cms/admin_essential_links_en_US.tmpl
    'Essential Links' => 'Essentiële links',
    'System Information' => 'Systeeminformatie',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.com/t/account', # Translate
    'Your Account' => 'Uw account',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate
    'Movable Type Home' => 'Movable Type hoofdpagina',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/', # Translate
    'Plugin Directory' => 'Plugin-bibliotheek',
    'https://secure.sixapart.com/t/help?__mode=kb' => 'https://secure.sixapart.com/t/help?__mode=kb', # Translate
    'Knowledge Base' => 'Kennisdatabank',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate
    'Support and Documentation' => 'Ondersteuning en documentatie',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/', # Translate
    'Professional Network' => 'Professional Network', # Translate

    ## ./tmpl/feeds/feed_entry.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'Edit' => 'Bewerken',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'Movable Type Activity Log' => 'Movable Type activiteitenlog',
    'Movable Type System Activity' => 'Movable Type systeemactiviteit',
    'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

    ## ./tmpl/feeds/error.tmpl

    ## ./tmpl/feeds/feed_ping.tmpl

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
    'Approve this TrackBack:' => 'Deze TrackBack goedkeuren:',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).',
    'View this TrackBack:' => 'Deze TrackBack bekijken:',
    'Edit this TrackBack:' => 'Deze this TrackBack bewerken:',
    'Title:' => 'Titel:',
    'Excerpt:' => 'Uittreksel:',

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/notify-entry.tmpl
    '[_1] Update: [_2]' => '[_1] update: [_2]',
    '(This entry is unpublished.)' => '(Dit bericht is nog niet gepubliceerd.)',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Een niet gekeurde reactie is binnengekomen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze reactie eerst goedkeuren voor ze op uw site verschijnt.',
    'Approve this comment:' => 'Deze reactie goedkeuren:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe reactie is gepubliceerd op uw blog [_1], op bericht #[_2] ([_3]).',
    'View this comment:' => 'Deze reactie bekijken:',
    'Edit this comment:' => 'Deze reactie bewerken:',

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Aangedreven door Movable Type',
    'Version [_1]' => 'Versie [_1]',

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Bedankt om u in te schrijven voor notificaties over updates van [_1].  Volg onderstaande link om uw inschrijving te bevestigen:',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Indien de link niet klikbaar is, kopiëer en plak hem dan gewoon in uw browser.',

    ## Other phrases, with English translations.
    'WEEKLY_ADV' => 'Wekelijks',
    'Unpublish Comment(s)' => 'Publicatie ongedaan maken',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Getoond wanneer een reactie gemodereerd of als spam aangemerkt is',
    '_USAGE_ENTRY_LIST_OVERVIEW' => '_USAGE_ENTRY_LIST_OVERVIEW', # Translate
    'RSS 1.0 Index' => 'RSS 1.0 index',
    'Manage Categories' => 'Categorieën beheren',
    '_USAGE_BOOKMARKLET_4' => 'Na het installeren van QuickPost, kunt u publiceren vanaf elke locatie op het web. Als u een pagina bekijkt waarover u een bericht wilt schrijven, klikt u op \'QuickPost\' in uw werkbalk \'Favorieten\' om een pop-upvenster te openen met een speciaal Movable Type-bewerkingsvenster. In dit venster kunt u een weblog selecteren waar u het bericht op wilt publiceren en vervolgens uw bericht invoeren en publiceren.',
    '_USAGE_ARCHIVING_2' => 'Als u meerdere sjablonen koppelt aan een bepaald archieftype - of zelfs als u er slechts een koppelt - dan kunt u het uitvoerpad aanpassen voor de archiefbestanden met behulp van Sjablonen archiefbestanden.',
    'UTC+11' => 'UTC+11', # Translate
    'View Activity Log For This Weblog' => 'Activiteitenlog van deze weblog bekijken',
    'DAILY_ADV' => 'Dagelijks',
    '_USAGE_PERMISSIONS_3' => 'U kunt op twee manieren auteurs bewerken en toegangsprivileges toestaan/weigeren. Selecteer voor snelle toegang een gebruiker uit het menu hieronder en selecteer \'Bewerken\'. Als alternatief kunt u door de volledige lijst met auteurs bladeren en van daaruit een persoon selecteren die u wilt bewerken of verwijderen.',
    '_NOTIFY_REQUIRE_CONFIRMATION' => '_NOTIFY_REQUIRE_CONFIRMATION', # Translate
    '_USAGE_NOTIFICATIONS' => 'Hieronder staat een lijst met personen die op de hoogte willen worden wanneer u iets publiceert op uw site. Als u een nieuwe gebruiker wilt toevoegen, voer dan het e-mailadres in het formulier hieronder in. Het URL-veld is optioneel. Als u een gebruiker wilt verwijderen, kruis dan het vak \'Verwijderen\' aan in de tabel hieronder en druk vervolgens op de knop \'Verwijderen\'.',
    'Manage Notification List' => 'Notificatielijst beheren',
    'Individual' => 'individuele',
    '_USAGE_COMMENTERS_LIST' => 'Hier is de lijst met bezoekers die reacties achterlieten op [_1].',
    'RSS 2.0 Index' => 'RSS 2.0 index',
    '_USAGE_BANLIST' => 'Hieronder is de lijst met IP-adressen die u hebt uitgesloten van de publicatie van reacties op uw site of het versturen van TrackBack-pings naar uw site. Als u een nieuw IP-adres wilt toevoegen, voer dan het adres in het formulier hieronder in. Als u een uitgesloten IP-adres wilt verwijderen, kruis dan het vak \'Verwijderen\' aan in de tabel hieronder en druk vervolgens op de knop \'Verwijderen\'.',
    '_ERROR_DATABASE_CONNECTION' => 'Uw database instellingen zijn ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Bekijk het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',
    'Configure Weblog' => 'Weblog configureren',
    '_INDEX_INTRO' => '_INDEX_INTRO', # Translate
    '_USAGE_FEEDBACK_PREFS' => 'In dit schem kunt u de manieren instellen waarop lezers feedback kunnen geven op uw weblog.',
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Hier is de lijst met reacties op alle weblogs. U kunt alle willekeurige reacties bewerken door te klikken op de tekst van de reactie. Klik om de berichten te filteren op een van de waarden die in de lijst worden weergegeven.',
    '_USAGE_NEW_AUTHOR' => 'In dit scherm kunt u een nieuwe auteur aanmaken en hem toegang geven tot bepaalde weblogs in het systeem.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Met dit nieuwe wachtwoord moet u zich op Movable Type kunnen aanmelden. Zodra u zich hebt aangemeld, kunt u uw wachtwoord veranderen in iets dat u goed kunt onthouden.',
    '_USAGE_COMMENT' => 'Bewerk het geselecteerde document. Druk op OPSLAAN zodra u klaar bent. U moet opnieuw opbouwen om deze veranderingen van kracht te maken.',
    '_USAGE_FORGOT_PASSWORD_1' => 'U hebt het herstel van uw Movable Type-wachtwoord aangevraagd. Uw wachtwoord is in het systeem gewijzigd; hier is het nieuwe wachtwoord:',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => '_USAGE_COMMENTS_LIST_OVERVIEW', # Translate
    '_USAGE_EXPORT_2' => 'Als u uw berichten wilt exporteren, klikt u op de link hieronder ("Berichten exporteren van [_1]").  Als u de geëxporteerde gegevens in een bestand wilt opslaan, kunt u de toets <code>optie</code> op de Macintosh, of de toets <code>Shift</code> op een PC indrukken terwijl u op de link klikt. Als alternatief kunt u alle gegevens selecteren en ze vervolgens in een ander document kopiëren. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exporteren vanuit Internet Explorer?</a>)',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Getoond wanneer een bezoeker op een afbeelding klikt die met een popup is verbonden',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Hier is de lijst met pings op alle weblogs.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Getoond wanneer er zich een fout voordoet op een dynamisch gegenereerde pagina',
    'Publish Entries' => 'Berichten publiceren',
    'Date-Based Archive' => 'Archief gebaseerd op datum',
    'Unban Commenter(s)' => 'Verbanning opheffen',
    'Individual Entry Archive' => 'Archief voor individuele berichten',
    'Daily' => 'dagelijkse',
    '_USAGE_PING_LIST_OVERVIEW' => '_USAGE_PING_LIST_OVERVIEW', # Translate
    'Unpublish Entries' => 'Publicatie ongedaan maken',
    '_USAGE_UPLOAD' => 'U kunt het bestand hierboven opladen naar het lokale pad van uw site <a href="javascript:alert(\'[_1]\')">(?)</a> of het lokale archiefpad <a href="javascript:alert(\'[_2]\')">(?)</a>. U kunt ook het bestand opladen in elke directory onder deze directories, door het pad op te geven in de tekstvakken rechts (<i>afbeeldingen</i>, bijvoorbeeld). Als de directory niet bestaat, wordt deze aangemaakt.',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">OPNIEUW OPBOUWEN</a> om de wijzigingen weer te geven op uw publieke site.',
    'Blog Administrator' => 'Blogadministrator',
    'CATEGORY_ADV' => 'Categorie',
    'Dynamic Site Bootstrapper' => 'Voorbeeld dynamische site',
    '_USAGE_PLUGINS' => 'Dit is een lijst van alle plugins die momenteel in Movable Type geregistreerd zijn.',
    '_USAGE_COMMENTS_LIST_BLOG' => '_USAGE_COMMENTS_LIST_BLOG', # Translate
    'Category Archive' => 'Archief per categorie',
    '_USAGE_PERMISSIONS_2' => 'Als u permissies voor een andere gebruiker wilt bewerken, selecteert u een nieuwe gebruiker uit het uitklapmenu en klikt u op \'Bewerken\'.',
    '_USAGE_EXPORT_1' => 'Het exporteren van uw berichten vanuit Movable Type maakt het mogelijk om <b>persoonlijke back-ups</b> van uw blogberichten te bewaren. Het formaat van de geëxporteerde gegevens is geschikt om weer in het systeem geïmporteerd te worden m.b.v. de importfunctie (hierboven); dus kunt u, behalve het exporteren van uw berichten voor backup-doeleinden, deze functie ook gebruiken om <b>de inhoud te verplaatsen naar verschillende blogs</b>.',
    'Untrust Commenter(s)' => 'Reageerder(s) niet meer vertrouwen',
    '_SYSTEM_TEMPLATE_PINGS' => 'Getoond wanneer TrackBack popups (afgeraden) zijn ingeschakeld.',
    'Entry Creation' => 'Berichten aanmaken',
    '_USAGE_PROFILE' => 'Bewerk hier uw auteursprofiel. Als u uw gebruikersnaam of wachtwoord wijzigt, worden uw aanmeldingsgegevens automatisch bijgewerkt. Met andere woorden, u hoeft zich niet opnieuw aan te melden.',
    'Category' => 'categorie',
    'Atom Index' => 'Atom index',
    '_USAGE_PLACEMENTS' => 'Gebruik de velden hieronder om de secundaire categorieën te beheren waaraan dit bericht is toegewezen. De lijst aan de linkerkant bevat de categorieën waaraan dit bericht nog niet is toegewezen als primaire of secundaire categorie; de lijst aan de rechterkant bestaat uit de secundaire categorieën waaraan dit bericht is toegewezen.',
    '_USAGE_ENTRYPREFS' => 'De veldconfiguratie bepaalt welke velden verschijnen op de schermen voor nieuwe en bewerkte berichten. U kunt een bestaande configuratie selecteren (Eenvoudig of Geavanceerd) of uw schermen aanpassen door op Aanpassen te klikken en vervolgens de velden te selecteren die u wilt weergeven.',
    '_THROTTLED_COMMENT_EMAIL' => 'Een bezoeker van uw weblog [_1] is automatisch uitgesloten omdat dez meer dan het toegestane aantal reacties heeft gepubliceerd in de laatste [_2] seconden. Dit wordt gedaan om te voorkomen dat kwaadwillige scripts uw weblog met reacties overstelpen. Het uitgesloten IP-adres is

    [_3]

Als dit een fout was, kunt u het IP-adres ontgrendelen en de bezoeker toestaan opnieuw te publiceren door u aan te melden bij uw Movable Type-installatie, naar Weblogconfiguratie - IP uitsluiten te gaan en het IP-adres [_4] te verwijderen uit de lijst van uitgesloten adressen.',
    'Stylesheet' => 'Stylesheet', # Translate
    'RSD' => 'RSD', # Translate
    'MONTHLY_ADV' => 'Maandelijks',
    'Trust Commenter(s)' => 'Reageerder(s) vertrouwen',
    'Manage Tags' => 'Tags beheren',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Getoond wanneer een reageerder een voorbeeld van zijn reactie bekijkt',
    '_THROTTLED_COMMENT' => 'In een poging om de publicatie van kwaadaardige reacties door beledigende gebruikers tegen te gaan, heb ik een functie ingeschakeld die vereist dat degene die weblogreacties verstuurt even wacht alvorens weer een publicatie te kunnen sturen. Probeer uw reactie na korte tijd nogmaals te publiceren. Hartelijk dank voor uw geduld.',
    'Manage Templates' => 'Sjablonen beheren',
    '_USAGE_BOOKMARKLET_3' => 'Als u het Movable Type QuickPost-bookmark wilt installeren, sleept u de volgende link naar de werkbalk Favorieten in het menu van uw browser.',
    '_USAGE_SEARCH' => 'U kunt \'zoeken en vervangen\' gebruiken om al uw berichten te doorzoeken of om alle gevallen waar een bepaald woord/zin/teken voorkomt te vervangen door iets anders. BELANGRIJK: wees voorzichtig bij het uitvoeren van een vervanging, omdat <b>ongedaan maken</b> niet mogelijk is. Als u vervangingen aanbrengt in een groot aantal berichten, dan is het wellicht veilig om eerst de functie \'Import/Export\' te gebruiken om een veiligheidskopie van uw berichten te maken.',
    '_external_link_target' => '_extern_link_doel',
    '_USAGE_BOOKMARKLET_2' => 'De manier waarop QuickPost van Movable Type gestructureerd is, maakt het mogelijk om de lay-out en velden van uw QuickPost-pagina aan te passen. U wilt misschien de mogelijkheid toevoegen om uittreksels toe te voegen via het . Standaard heeft een QuickPost-venster altijd een uitklapmenu met de weblogs waarop u kunt publiceren; een uitklapmenu om de publicatiestatus van het nieuwe bericht te selecteren (\'Concept\' of \'Publiceren\'); een tekstvak voor de titel van het bericht; en een tekstvak voor de tekst van het bericht.',
    '_USAGE_PERMISSIONS_1' => 'U bewerkt de permissies van <b>[_1]</b>. Hieronder vindt u een lijst met blogs waar u de auteurs van mag bewerken; voor elke blog in de lijst kunt u permissies toewijzen aan <b>[_1]</b> door de vakjes met de permissies aan te kruisen die u wilt verstrekken.',
    '_AUTO' => '1',
    'Add/Manage Categories' => 'Categorieën toevoegen/beheren',
    '_USAGE_LIST_POWER' => 'Hier is de lijst met berichten op [_1] in batchbewerkingsmodus. In het onderstaande formulier kunt u de waarden voor alle weergegeven berichten wijzigen; druk na het maken van de gewenste aanpassingen, op de knop \'Opslaan\'. De standaard besturingelementen voor Berichten weergeven en bewerken (filters, pagineren) werken in batchmodus op de manier die u gewend bent.',
    '_ERROR_CONFIG_FILE' => 'Uw Movable Type configuratiebestand ontbreekt of kan niet gelezen worden. Gelieve het deel <a href="#">Installation and Configuration</a> van de handleiding van Movable Type te raadplegen voor meer informatie.',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.movabletype.org/sitenl/">Movable Type <$MTVersion$></a>',
    '_USAGE_PING_LIST_BLOG' => '_USAGE_PING_LIST_BLOG', # Translate
    'Monthly' => 'maandelijkse',
    '_USAGE_ARCHIVING_1' => 'Selecteer de veelvuldigheid/soorten van archivering die u op uw site wenst. Voor elk archiveringstype dat u kiest, kunt u meerdere archiefsjablonen toewijzen die u op dat bepaalde type wilt toepassen Stel dat u  twee verschillende weergaven wilt aanmaken van uw maandelijkse archieven: een pagina met alle berichten voor een bepaalde maand en de andere met een kalenderoverzicht voor die maand.',
    'Ban Commenter(s)' => 'Reageerder(s) verbannen',
    '_USAGE_VIEW_LOG' => 'Controleer voor deze fout de <a href="#" onclick="doViewLog()">Activiteitenlog</a>.',
    '_USAGE_PERMISSIONS_4' => 'Elke blog mag meerdere auteurs hebben. Als u een auteur wilt toevoegen, voer dan de gebruikersinformatie in het formulier hieronder in. Selecteer vervolgens de blogs waarvoor de auteur bepaalde permissies zal krijgen. Zodra u op \'Opslaan\' drukt en de gebruiker in het systeem aanwezig is, kunt u de permissies van de auteur bewerken.',
    '_USAGE_AUTHORS_1' => '_USAGE_AUTHORS_1', # Translate
    '_USAGE_BOOKMARKLET_1' => 'Door QuickPost te installeren op uw browser kunt u berichten met één klik toevoegen aan uw weblog zonder langs de hoofdinterface van Movable Type te moeten gaan.',
    '_USAGE_ARCHIVING_3' => 'Selecteer het archiveringstype waaraan u een nieuw archiefsjabloon wilt toevoegen. Selecteer vervolgens de sjabloon die u aan het betreffende archiveringstype wilt koppelen.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE', # Translate
    'UTC+10' => 'UTC+10', # Translate
    '_USAGE_TAGS' => '_USAGE_TAGS', # Translate
    'INDIVIDUAL_ADV' => 'Individueel',
    '_USAGE_BOOKMARKLET_5' => 'Als alternatief kunt u, als u Internet Explorer onder Windows gebruikt, een \'QuickPost\'-optie installeren in het Windows-menu dat verschijnt wanneer u met de rechtermuisknop klikt in Explorer. Klik op de link hieronder en accepteer de vraag van de browser om het bestand te \'Openen\'. Vervolgens sluit en herstart u uw browser om de link toe te voegen aan het menu dat verschijnt wanneer u met de rechtermuisknop klikt in uw browser.',
    '_ERROR_CGI_PATH' => 'Uw CGIPath configuratieinstelling is ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Gelieve het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding te raadplegen voor meer informatie.',
    '_USAGE_IMPORT' => 'Gebruik de importfunctie om berichten te importeren uit een ander weblog content-management systeem (bijvoorbeeld Blogger of Greymatter). De handleiding bevat uitgebreide instructies over het importeren van oudere berichten via deze weg; met het formulier hieronder kunt u een verzameling berichten importeren nadat u ze hebt geëxporteerd uit het andere CMS en de geëxporteerde bestanden op de juiste plaats hebt gezet, zodat Movable Type ze kan vinden. Raadpleeg de handleiding voordat u dit formulier gebruikt, zodat u er zeker van bent dat u alle opties begrijpt.',
    'Main Index' => 'Hoofdindex',
    '_USAGE_CATEGORIES' => 'Gebruik categorieën om uw berichten te groeperen zodat u er makkelijker naar kunt verwijzen, ze eenvoudiger kunt archiveren en blogs beter kunt weergeven.  U kunt een categorie toewijzen aan een bepaald bericht tijdens het aanmaken of bewerken van berichten. Als u een bestaande categorie wilt bewerken, klikt u op de titel van de categorie. Als u een subcategorie wilt aanmaken, klikt u op de desbetreffende knop "Aanmaken." Als u een subcategorie wilt verplaatsen, klikt u op de desbetreffende knop "Schuif."',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Getoond wanneer reactie-popups (afgeraden) zijn ingeschakeld.',
    '_USAGE_AUTHORS_2' => '_USAGE_AUTHORS_2', # Translate
    '_USAGE_ENTRY_LIST_BLOG' => '_USAGE_ENTRY_LIST_BLOG', # Translate
    'Master Archive Index' => 'Hoofdarchiefindex',
    'Weekly' => 'wekelijkse',
    'Unpublish TrackBack(s)' => 'Publicatie ongedaan maken',
    '_USAGE_EXPORT_3' => 'Door te klikken op de link hieronder worden al uw huidige weblog-berichten naar de Tangent-server geëxporteerd. Dit is normaliter een eenmalige push van uw berichten, die u moet uitvoeren nadat u de extra\'s voor Tangent hebt geïnstalleerd voor Movable Type, maar het mogelijk om dit te doen wanneer u dit wilt.',
    'Send Notifications' => 'Notificaties verzenden',
    'Edit All Entries' => 'Alle berichten bewerken',
    '_USAGE_PREFS' => 'Dit scherm biedt u de mogelijkheid om verschillende opties in te stellen met betrekking tot uw blog, uw archieven, uw reacties en uw publiciteits en notificatie-instellingen. Bij het aanmaken van een nieuwe blog zijn deze instellingen op redelijke standaardwaarden ingesteld.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Getoond wanneer een ingediende reactie niet gevalideerd kan worden.',
    'Rebuild Files' => 'Bestanden opnieuw opbouwen',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI is vereist voor alle toepassingsfuncties van Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template is vereist voor alle toepassingsfuncties van Movable Type.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size is vereist voor het opladen van bestanden (om de grootte van de op te laden afbeeldingen te bepalen in vele verschillende indelingen).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec is vereist voor padbewerking bij verschillende besturingssystemen.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie is vereist voor verificatie van cookies.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI is vereist als u een van de SQL database drivers wilt gebruiken.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist als u de MySQL-database-backend wilt gebruiken.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist als u de PostgreSQL-database-backend wilt gebruiken.',
    'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI en DBD::Oracle zijn vereist als u de Oracle-database-backend wilt gebruiken.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities is vereist om bepaalde tekens te coderen, maar deze functie kan worden uitgeschakeld met de optie NoHTMLEntities in mt.cfg.',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgent is optioneel; het is vereist als u het TrackBack-systeem, de ping weblogs.com of de ping MT Recent bijgewerkt wilt gebruiken.',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Lite is optioneel; het is vereist als u de MT XML-RPC-serverimplementatie wilt gebruiken.',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp is optioneel; het is vereist als u bestaande bestanden wilt overschrijven bij het opladen.',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magick is optioneel; het is vereist als u miniatuurweergaven van geüploade bestanden wilt kunnen maken.',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storable is optioneel; het is vereist voor bepaalde MT-plug-ins van derden.',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA is optioneel; als het is geïnstalleerd, worden registratieaanmeldingen voor opmerkingen versneld.',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64 is vereist om het registreren van bezoekers in te schakelen.',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atom is vereist om de Atom API te kunnen gebruiken.',
    'Data Storage' => 'gegevensopslag',
    'Required' => 'vereiste',
    'Optional' => 'optionele',

    ## ./extlib/JSON.pm

    ## ./extlib/DateTimePP.pm

    ## ./extlib/DateTime.pm

    ## ./extlib/URI.pm

    ## ./extlib/DateTimePPExtra.pm

    ## ./extlib/CGI.pm

    ## ./extlib/LWP.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

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

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/File/Spec.pm

    ## ./extlib/File/Spec/VMS.pm

    ## ./extlib/File/Spec/Functions.pm

    ## ./extlib/File/Spec/Mac.pm

    ## ./extlib/File/Spec/Win32.pm

    ## ./extlib/File/Spec/OS2.pm

    ## ./extlib/File/Spec/Unix.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/Math/BigInt/Calc.pm

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

    ## ./extlib/Locale/Maketext.pm

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

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/_segment.pm

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

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Atom.pm

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

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Switch.pm

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

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./tools/Html.pm

    ## ./tools/Backup.pm

    ## ./tools/sample.pm

    ## ./tools/cwapi.pm

    ## ./lib/MT.pm
    'Message: [_1]' => 'Bericht: [_1]',
    '[_1] died with: [_2]' => '[_1] ging dood met: [_2]',
    '[_1] returned error: [_2]' => '[_1] gaf fout terug: [_2]',
    'Callback died: [_1]' => 'Callback ging dood: [_1]',
    'Plugin error: [_1] [_2]' => 'Pluginfout: [_1] [_2]',

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/TaskMgr.pm
    'Error during task \'[_1]\': [_2]' => 'Fout tijdens taak \'[_1]\': [_2]',
    'Task Update' => 'Taak-update',

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/TagMap.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Categorieën moeten bestaan binnen dezelfde blog',
    'Category loop detected' => 'Categorielus gedetecteerd',

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Er deed zich een fout voor: [_1]',

    ## ./lib/MT/ConfigMgr.pm
    'Error opening file \'[_1]\': [_2]' => 'Bestand \'[_1]\' openen mislukt: [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Configuratiedirectief [_1] zonder waarde in [_2] lijn [_3]',
    'No such config variable \'[_1]\'' => 'Geen config variabele \'[_1]\'',

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Kan Image::Magick niet laden: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Bestand \'[_1]\' lezen mislukt: [_2]',
    'Reading image failed: [_1]' => 'Afbeelding lezen mislukt: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'Dimensies aanpassen naar [_1]x[_2] mislukt: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Kan IPC::Run niet laden: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'U hebt geen geldig pad naar de NetPBM tools op uw machine.',

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Upgrade.pm
    'Running [_1]' => '[_1] wordt uitgevoerd',
    'Invalid upgrade function: [_1].' => 'Ongeldige upgrade-functie: [_1].',
    'Error loading class: [_1].' => 'Fout bij het laden van klasse: [_1].',
    'Creating initial weblog and author records...' => 'Initiële weblog en auteur worden aangemaakt...',
    'Error saving record: [_1].' => 'Fout bij opslaan gegevens: [_1].',
    'First Weblog' => 'Eerste weblog',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'Kan de lijst met standaardsjablonen niet vinden: waar is \'default-templates.pl\'? Fout: [_1]',
    'Creating new template: \'[_1]\'.' => 'Nieuw sjabloon wordt aangemaakt: \'[_1]\'.',
    'Mapping templates to blog archive types...' => 'Bezig met sjablonen aan archieftypes toe te wijzen...',
    'Upgrading table for [_1]' => 'Bezig tabel te upgraden voor [_1]',
    'Executing SQL: [_1];' => 'SQL wordt uitgevoerd: [_1];',
    'Error during upgrade: [_1]' => 'Fout tijdens upgrade: [_1]',
    'Upgrading database from version [_1].' => 'Database wordt bijgewerkt van versie [_1].',
    'Database has been upgraded to version [_1].' => 'Database is bijgewerkt naar versie [_1].',
    'Setting your permissions to administrator.' => 'Bezig uw permissies als administrator in te stellen.',
    'Creating configuration record.' => 'Configuratiegegevens aan het aanmaken.',
    'Creating template maps...' => 'Bezig sjabloonkoppelingen aan te maken...',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2] ([_3]).',
    'Mapping template ID [_1] to [_2].' => 'Sjabloon ID [_1] wordt gekoppeld aan [_2].',

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => 'Kan niet-REAGEERDER autheur niet goedkeuren/verbannen',
    'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden weggeschreven: [_1]',

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Geen WeblogsPingURL ingesteld in mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Geen MTPingURL ingesteld in mt.cfg',
    'HTTP error: [_1]' => 'HTTP fout: [_1]',
    'Ping error: [_1]' => 'Ping fout: [_1]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/TBPing.pm
    'Load of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',

    ## ./lib/MT/Blog.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '&lt;MT[_1]> zonder &lt;/MT[_1]>',
    'Error in &lt;MT[_1]> tag: [_2]' => 'Fout in &lt;MT[_1]> tag: [_2]',

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => '4de argument van add_callback moet een perl CODE referentie zijn',

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Tag moet een geldige naam hebben',
    'This tag is referenced by others.' => 'Deze tag is gerefereerd door anderen.',

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/App.pm
    'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Gebruiker \'[_1]\' (gebruikersnummer [_2]) heeft zich aangemeld',
    'Invalid login attempt from user \'[_1]\'' => 'Ongeldige aanmeldingspoging van gebruiker \'[_1]\'',
    'Invalid login.' => 'Ongeldige gebruikersnaam.',
    'User \'[_1]\' (user #[_2]) logged out' => 'Gebruiker \'[_1]\' (gebruikersnummer [_2]) heeft zich afgemeld',
    'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
    'Unknown action [_1]' => 'Onbekende actie [_1]',
    'Loading template \'[_1]\' failed: [_2]' => 'Sjabloon \'[_1]\' laden mislukt: [_2]',

    ## ./lib/MT/Log.pm
    'Entry # [_1] not found.' => 'Bericht # [_1] niet gevonden.',
    'Junk Log (Score: [_1])' => 'Spamlog (score: [_1])',
    'Comment # [_1] not found.' => 'Reactie # [_1] niet gevonden.',
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] niet gevonden.',

    ## ./lib/MT/BulkCreation.pm
    'Format error at line [_1]: [_2]' => 'Formatteringsfout op lijn [_1]: [_2]',
    'Invalid command: [_1]' => 'Ongeldig commando: [_1]',
    'Invalid number of columns for [_1]' => 'Ongeldig aantal kolommen voor [_1]',
    'Invalid user name: [_1]' => 'Ongeldige gebruikersnaam: [_1]',
    'Invalid display name: [_1]' => 'Ongeldige getoonde naam: [_1]',
    'Invalid email address: [_1]' => 'Ongeldig e-mail adres: [_1]',
    'Invalid language: [_1]' => 'Ongeldige taal: [_1]',
    'Invalid password: [_1]' => 'Ongeldig wachtwoord: [_1]',
    'Invalid password hint: [_1]' => 'Ongeldige wachtwoordhint: [_1]',
    'Invalid weblog name: [_1]' => 'Ongeldige weblognaam: [_1]',
    'Invalid weblog description: [_1]' => 'Ongeldige weblogbeschrijving: [_1]',
    'Invalid site url: [_1]' => 'Ongeldige site-url: [_1]',
    'Invalid site root: [_1]' => 'Ongeldige siteroot: [_1]',
    'Invalid timezone: [_1]' => 'Ongeldige tijdzone: [_1]',
    'Invalid new user name: [_1]' => 'Ongeldige nieuwe gebruikersnaam: [_1]',
    'author with the same name found.  register was not processed: [_1]' => 'auteur met dezelfde naam gevonden.  registratie werd niet doorgevoerd: [_1]',
    'author can not be created: [_1].' => 'auteur kan niet worden aangemaakt: [_1].',
    'author [_1] is created.' => 'auteur [_1] is aangemaakt.',
    'author [_1] is created' => 'auteur [_1] is aangemaakt',
    'blog with the same name found.  blog was not created: [_1]' => 'blog met dezelfde naam gevonden.  blog werd niet aangemaakt: [_1]',
    'blog for author [_1] can not be created.' => 'blog voor auteur [_1] kan niet worden aangemaakt.',
    'blog [_1] for author [_2] is created.' => 'blog [_1] voor auteur [_2] is aangemaakt.',
    'permission cannot be granted to author [_1].' => 'permissie kan niet worden toegekend aan auteur [_1].',
    'permission granted to [_1]' => 'permissie toegekend aan [_1]',
    'author whose name is [_1] is found.  update was not processed: [_2]' => 'geen auteur gevonden met de naam [_1].  update werd niet doorgevoerd: [_2]',
    'author can not be updated: [_1].' => 'auteur kan niet worden bijgewerkt: [_1].',
    'author [_1] not found.  update was not processed' => 'auteur [_1] niet gevonden.  update werd niet doorgevoerd',
    'author [_1] is updated.' => 'auteur [_1] is bijgewerkt.',
    'author [_1] was found, but delete was not processed' => 'auteur [_1] werd gevonden, maar opdracht tot verwijdering werd niet doorgevoerd',
    'author [_1] not found.  delete was not processed' => 'auteur [_1] niet gevonden.  verwijdering werd niet doorgevoerd',
    'author [_1] is deleted.' => 'auteur [_1] is verwijderd.',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/AtomServer.pm
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) voegde bericht #[_3] toe',

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Laden van blog mislukt: [_1]',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/Config.pm

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'Ontleedfout in sjabloon \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Opbouwfout in sjabloon \'[_1]\': [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Gelinkt bestand \'[_1]\' openen mislukt: [_2]',

    ## ./lib/MT/ImportExport.pm
    'No Stream' => 'No Stream', # Translate
    'No Blog' => 'No Blog', # Translate
    'Can\'t rewind' => 'Can\'t rewind', # Translate
    'Can\'t open \'[_1]\': [_2]' => 'Kan \'[_1]\' niet openen: [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'Kan map \'[_1]\' niet openen: [_2]',
    'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
    'Importing entries from file \'[_1]\'' => 'Berichten worden ingevoerd uit bestand  \'[_1]\'',
    'You need to provide a password if you are going to\n' => 'U moet een paswoord opgeven als u van plan bent om\n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ofwel ParentAuthor vereist',
    'Creating new author (\'[_1]\')...' => 'Nieuwe auteur (\'[_1]\') wordt aangemaakt...',
    'ok\n' => 'ok\n', # Translate
    'failed\n' => 'mislukt\n',
    'Saving author failed: [_1]' => 'Auteur opslaan mislukt: [_1]',
    'Assigning permissions for new author...' => 'Permissies worden toegekend aan nieuwe auteur...',
    'Saving permission failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
    'Creating new category (\'[_1]\')...' => 'Nieuwe categorie wordt aangemaakt (\'[_1]\')...',
    'Saving category failed: [_1]' => 'Categorie opslaan mislukt: [_1]',
    'Invalid status value \'[_1]\'' => 'Ongeldige statuswaarde \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Ongeldige instelling voor het toelaten van pings \'[_1]\'',
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Kan geen bestaand bericht vinden op tijdstip \'[_1]\'... Reacties worden overgeslagen en er wordt verder gegaan met het volgende bericht.\n',
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Aan het importeren in bestaand bericht [_1] (\'[_2]\')\n',
    'Saving entry (\'[_1]\')...' => 'Bericht aan het opslaan (\'[_1]\')...',
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate
    'Saving entry failed: [_1]' => 'Bericht opslaan mislukt: [_1]',
    'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
    'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
    'Entry has no MT::Trackback object!' => 'Bericht heeft geen MT::Trackback object!',
    'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
    'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Export mislukt bij bericht \'[_1]\': [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Ongeldig datumformaat \'[_1]\'; dit moet zijn ',

    ## ./lib/MT/Util.pm
    'Less than 1 minute from now' => 'Minder dan 1 minuut in de toekomst',
    'Less than 1 minute ago' => 'Minder dan 1 minuut geleden',
    '[quant,_1,hour], [quant,_2,minute] from now' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten] in de toekomst',
    '[quant,_1,hour], [quant,_2,minute] ago' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten] geleden',
    '[quant,_1,hour] from now' => '[quant,_1,uur,uren] in de toekomst',
    '[quant,_1,hour] ago' => '[quant,_1,uur,uren] geleden',
    '[quant,_1,minute] from now' => '[quant,_1,minuut,minuten] in de toekomst',
    '[quant,_1,minute] ago' => '[quant,_1,minuut,minuten] geleden',
    '[quant,_1,day], [quant,_2,hour] from now' => '[quant,_1,dag,dagen], [quant,_2,uur,uren] in de toekomst',
    '[quant,_1,day], [quant,_2,hour] ago' => '[quant,_1,dag,dagen], [quant,_2,uur,uren] geleden',
    '[quant,_1,day] from now' => '[quant,_1,dag,dagen] in de toekomst',
    '[quant,_1,day] ago' => '[quant,_1,dag,dagen] geleden',
    'Invalid Archive Type setting \'[_1]\'' => 'Ongeldige archieftype-instelling  \'[_1]\'',

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Handeling: Verworpen (score onder drempel)',
    'Action: Published (default action)' => 'Handeling: Gepubliceerd (standaardhandeling)',
    'Junk Filter [_1] died with: [_2]' => 'Spamfilter [_1] liep vast met: [_2]',
    'Unnamed Junk Filter' => 'Naamloze spamfilter',
    'Composite score: [_1]' => 'Samengestelde score: [_1]',

    ## ./lib/MT/ObjectDriver.pm

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Onbekende MailTransfer methode \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'Mail versturen via SMTP betekent dat het nodig is dat uw server ',
    'Error sending mail: [_1]' => 'Fout bij versturen mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'U hebt geen geldig pad naar sendmail op uw machine. ',
    'Exec of sendmail failed: [_1]' => 'Exec van sendmail mislukt: [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/XMLRPCServer.pm

    ## ./lib/MT/WeblogPublisher.pm
    'Archive type \'[_1]\' is not a chosen archive type' => 'Archieftype \'[_1]\' is geen gekozen archieftype',
    'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is vereist',
    'Building category archives, but no category provided.' => 'Categorie-archieven aan het bouwen, maar geen categorie opgegeven.',
    'You did not set your Local Archive Path' => 'U stelde geen lokaal archiefpad in',
    'Building category \'[_1]\' failed: [_2]' => 'Categorie \'[_1]\' opbouwen mislukt: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opbouwen mislukt: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Datum-gebaseerd archief \'[_1]\' opbouwen mislukt: [_2]',
    'You did not set your Local Site Path' => 'U stelde u lokaal sitepad niet in',
    'Template \'[_1]\' does not have an Output File.' => 'Sjabloon \'[_1]\' heeft geen uitvoerbestand.',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => 'Er deed zich een fout voor tijdens het opnieuw opbouwen om voor de toekomst geplande artikels te publiceren: [_1]',

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Verkeerde AuthenticationModule configuratie \'[_1]\': [_2]',

    ## ./lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'Laden van bericht \'[_1]\' mislukt: [_2]',

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'wegens regel',
    'from test' => 'wegens test',

    ## ./lib/MT/Auth/LDAP.pm
    'Loading Net::LDAP failed: [_1]' => 'Laden van Net::LDAP mislukt: [_1]',
    'LDAP user [_1] not found.' => 'LDAP gebruiker [_1] niet gevonden.',
    'Invalid login attempt from user [_1]: [_2]' => 'Ongeldige aanmeldingspoging van gebruiker [_1]: [_2]',
    'Binding to LDAP server failed: [_1]' => 'Binding met LDAP server mislukt: [_1]',
    'User not found on LDAP: [_1]' => 'Gebruiker niet gevonden op LDAP: [_1]',
    'More than one user with the same name found on LDAP: [_1]' => 'Meer dan één gebruiker met dezelfde naam gevonden op LDAP: [_1]',

    ## ./lib/MT/Auth/MT.pm
    'Passwords do not match.' => 'Wachtwoorden komen niet overeen.',
    'Failed to verify current password.' => 'Verificatie huidig wachtwoord mislukt.',
    'Password hint is required.' => 'Wachtwoordhint is vereist.',

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'Laden van gegevens mislukt met SQL fout [_1]',
    'Count [_1] failed on SQL error [_2]' => 'Count [_1] mislukt met SQL fout [_2]',
    'Prepare failed' => 'Prepare mislukt',
    'Execute failed' => 'Execute mislukt',
    'existence test failed on SQL error [_1]' => 'existence test mislukt met SQL fout [_1]',
    'Insertion test failed on SQL error [_1]' => 'Insertion test mislukt met SQL fout [_1]',
    'Update failed on SQL error [_1]' => 'Update mislukt met SQL fout [_1]',
    'No such object.' => 'Onbekend object.',
    'Remove failed on SQL error [_1]' => 'Remove mislukt met SQL fout [_1]',
    'Remove-all failed on SQL error [_1]' => 'Remove-all mislukt met SQL fout [_1]',

    ## ./lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'Uw DataSource map (\'[_1]\') bestaat niet.',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'Uw DataSource map (\'[_1]\') is niet beschrijfbaar.',
    'Tie \'[_1]\' failed: [_2]' => 'Tie \'[_1]\' mislukt: [_2]',
    'Failed to generate unique ID: [_1]' => 'Uniek ID genereren mislukt: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => 'Unlink van \'[_1]\' mislukt: [_2]',

    ## ./lib/MT/ObjectDriver/DBI/mysql.pm
    'Connection error: [_1]' => 'Verbindingsfout: [_1]',
    'undefined type: [_1]' => 'niet gedefiniëerd type: [_1]',

    ## ./lib/MT/ObjectDriver/DBI/oracle.pm

    ## ./lib/MT/ObjectDriver/DBI/postgres.pm

    ## ./lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'Uw databasebestand (\'[_1]\') is niet beschrijfbaar.',
    'Your database directory (\'[_1]\') is not writable.' => 'Uw database-map (\'[_1]\') is niet beschrijfbaar.',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/DAV.pm

    ## ./lib/MT/FileMgr/Local.pm
    'Opening local file \'[_1]\' failed: [_2]' => 'Lokaal bestand \'[_1]\' openen mislukt: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Herbenoemen van \'[_1]\' naar \'[_2]\' mislukt: [_3]',
    'Deleting \'[_1]\' failed: [_2]' => 'Verwijderen van \'[_1]\' mislukt: [_2]',

    ## ./lib/MT/FileMgr/SFTP.pm

    ## ./lib/MT/Template/Context.pm

    ## ./lib/MT/Template/ContextHandlers.pm
    'Can\'t find included template module \'[_1]\'' => 'Kan de geïncludeerde sjabloonmodule \'[_1]\' niet vinden',
    'Can\'t find included file \'[_1]\'' => 'Kan geïncludeerd bestand \'[_1]\' niet vinden',
    'Error opening included file \'[_1]\': [_2]' => 'Fout bij het openen van geïncludeerd bestand \'[_1]\': [_2]',
    'Unspecified archive template' => 'Niet gespecifiëerd archiefsjabloon',
    'Error in file template: [_1]' => 'Fout in bestandssjabloon: [_1]',
    'Can\'t find template \'[_1]\'' => 'Kan sjabloon \'[_1]\' niet vinden',
    'Can\'t find entry \'[_1]\'' => 'Kan bericht \'[_1]\' niet vinden',
    'You used a [_1] tag without any arguments.' => 'U gebruikte een [_1] tag zonder argumenten.',
    'You have an error in your \'category\' attribute: [_1]' => 'Er zit een fout in uw \'category\' attribuut: [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'Er zit een fout in uw \'tag\' attribuut: [_1]',
    'No such author \'[_1]\'' => 'Geen auteur \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; ',
    'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'U gebruikte een [_1] tag om te linken naar \'[_2]\' archieven, maar dat type archieven wordt niet gepubliceerd.',
    'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',
    'To enable comment registration, you ' => 'Om registratie voor reacties in te schakelen, moet u ',
    '(You may use HTML tags for style)' => '(U mag HTML tags gebruiken voor de stijl)',
    'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een reactie; ',
    'You used an [_1] without a date context set up.' => 'U gebruikte een [_1] zonder dat er een datumcontext ingesteld was.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kan enkel worden gebruikt met dagelijkse, wekelijkse of maandelijkse archieven.',
    'Couldn\'t get daily archive list' => 'Kon geen lijst met archieven per dag vinden',
    'Couldn\'t get monthly archive list' => 'Kon geen lijst met archieven per maand vinden',
    'Couldn\'t get weekly archive list' => 'Kon geen lijst met archieven per week vinden',
    'Unknown archive type [_1] in <MTArchiveList>' => 'Onbekend archieftype [_1] in <MTArchiveList>',
    'Group iterator failed.' => 'Group iterator mislukt.',
    'You used an [_1] tag outside of the proper context.' => 'U gebruikte een [_1] tag buiten de juiste context.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'U gebruikte een [_1] tag buiten een dagelijkse, wekelijkse of maandelijkse ',
    'Could not determine entry' => 'Kon bericht niet bepalen',
    'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
    'No such category \'[_1]\'' => 'Geen categorie \'[_1]\'',
    'You used <$MTCategoryDescription$> outside of the proper context.' => 'U gebruikte <$MTCategoryDescription$> buiten de geschikte context.',
    '[_1] can be used only if you have enabled Category archives.' => '[_1] kan enkel gebruikt worden als u categorie archiven hebt ingeschakeld.',
    '<$MTCategoryTrackbackLink$> must be ' => '<$MTCategoryTrackbackLink$> moet zijn ',
    'You used [_1] without a query.' => 'U gebruikte [_1] zonder een query.',
    'You need a Google API key to use [_1]' => 'u hebt een Google API sleutel nodig om [_1] te gebruiken',
    'You used a non-existent property from the result structure.' => 'U gebruikte een onbestaande eigenschap van de resultaatstructuur..',
    'You used an \'[_1]\' tag outside of the context of ' => 'U gebruikte een \'[_1]\' tag buiten de context van ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse gebruikt buiten MTSubCategories',
    'MT[_1] must be used in a category context' => 'MT[_1] moet gebruikt worden in een categoriecontext',
    'Cannot find sort_method' => 'Kan sort_method niet vinden',
    'Error sorting categories: [_1]' => 'Fout bij het sorteren van categorieën: [_1]',

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Gelieve een geldig e-mail adres op te geven.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Ontbrekende parameter: blog_id. Gelieve de handleiding te raadplegen om waarschuwingen te configureren.',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => 'Notificatie per e-mail is niet geconfigureerd!  De eigenaar van de weblog moet de EmailVerificationSecret configuratievariabele instellen in mt.cfg.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Er werd een ongeldige redirect parameter opgegeven. De eigenaar van de weblog moet een pad opgeven dat overeenkomt met het domein van de weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Het e-mail adres \'[_1]\' zit reeds in de notificatielijst voor deze weblog.',
    'Please verify your email to subscribe' => 'Gelieve uw e-mail adres te verifiëren voor inschrijving',
    'The address [_1] was not subscribed.' => 'Het adres [_1] werd niet ingeschreven.',
    'The address [_1] has been unsubscribed.' => 'Het adres [_1] werd uitgeschreven.',

    ## ./lib/MT/App/Comments.pm
    'No id' => 'Geen id',
    'No such comment' => 'Reactie niet gevonden',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
    'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
    'No entry_id' => 'Geen entry_id',
    'No such entry \'[_1]\'.' => 'Geen bericht \'[_1]\'.',
    'You are not allowed to post comments.' => 'U hebt geen toelating om reacties achter te laten.',
    'Comments are not allowed on this entry.' => 'Reacties op dit bericht zijn niet toegelaten.',
    'Comment text is required.' => 'Tekst van de reactie is verplicht.',
    'Registration is required.' => 'Registratie is verplicht.',
    'Name and email address are required.' => 'Naam en e-mail adres zijn verplicht.',
    'Invalid email address \'[_1]\'' => 'Ongeldig e-mail adres \'[_1]\'',
    'Invalid URL \'[_1]\'' => 'Ongeldige URL \'[_1]\'',
    'Comment save failed with [_1]' => 'Opslaan van reactie mislukt met [_1]',
    'New comment for entry #[_1] \'[_2]\'.' => 'Nieuwe reactie voor bericht #[_1] \'[_2]\'.',
    'Commenter save failed with [_1]' => 'Opslaan reageerder mislukt met [_1]',
    'Rebuild failed: [_1]' => 'Opnieuw opbouwen mislukt: [_1]',
    'New Comment Posted to \'[_1]\'' => 'Nieuwe reactie achtergelaten op \'[_1]\'',
    'The login could not be confirmed because of a database error ([_1])' => 'Het aanmelden kon niet worden bevestigd wegens een databaseprobleem ([_1])',
    'Couldn\'t get public key from url provided' => 'Kon geen publieke sleutel vinden via de opgegeven url',
    'No public key could be found to validate registration.' => 'Er kon geen publieke sleutel gevonden worden om de registratie te valideren.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey signatuurverificatie gaf [_1] terug in [_2] seconden bij het verifiëren van [_3] met [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'De TypeKey signatuur is vervallen ([_1] seconden oud). Controleer of de klok van uw server juist staat',
    'The sign-in validation failed.' => 'Validatie van het aanmelden mislukt.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.  Als u dat wenst kunt u zich opnieuw aanmelden en de authenticatiedienst toestemming verlenen om uw e-mail adres door te geven.',
    'Couldn\'t save the session' => 'Kon de sessie niet opslaan',
    'This weblog requires commenters to pass an email address' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => 'Aanmelding vereist een beveiligde handtekening; afmelden vereist de logout=1 parameter',
    'The sign-in attempt was not successful; please try again.' => 'Aanmeldingspoging mislukt; gelieve opnieuw te proberen.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'De validering bij het aanmelden is mislukt. Gelieve u ervan te vergewissen dat uw weblog goed is ingesteld en probeer opnieuw.',
    'No such entry ID \'[_1]\'' => 'Geen bericht-ID \'[_1]\'',
    'You must define an Individual template in order to ' => 'U moet een individueel sjabloon definiëren om ',
    'You must define a Comment Listing template in order to ' => 'U moet een sjabloon voor een lijst reacties definiëren om ',
    'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
    'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
    'You must define a Comment Pending template.' => 'U moet een sjabloon definiëren voor reacties die nog goedgekeurd moeten worden.',
    'You must define a Comment Error template.' => 'U moet een sjabloon definiëren voor foutboodschappen.',
    'You must define a Comment Preview template.' => 'U moet een sjabloon definiëren voor het bekijken van voorbeelden van reacties.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Bezig met zoeken. Even geduld ',
    'Search failed. Invalid pattern given: [_1]' => 'Zoeken mislukt. Ongeldig patroon opgegeven: [_1]',
    'Search failed: [_1]' => 'Zoeken mislukt: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Er is geen alternatief sjabloon opgegeven voor sjabloon \'[_1]\'',
    'Building results failed: [_1]' => 'Resultaten opbouwen mislukt: [_1]',
    'Search: query for \'[_1]\'' => 'Zoeken: zoekopdracht voor \'[_1]\'',
    'Search: new comment search' => 'Zoeken: opnieuw zoeken in de reacties',

    ## ./lib/MT/App/Trackback.pm
    'Invalid entry ID \'[_1]\'' => 'Ongeldig bericht-ID \'[_1]\'',
    'You must define a Ping template in order to display pings.' => 'U moet een pingsjabloon definiëren om pings te kunnen tonen.',
    'Trackback pings must use HTTP POST' => 'Trackback pings moeten HTTP POST gebruiken',
    'Need a TrackBack ID (tb_id).' => 'TrackBack ID vereist (tb_id).',
    'Invalid TrackBack ID \'[_1]\'' => 'Ongeldig TrackBack-ID \'[_1]\'',
    'You are not allowed to send TrackBack pings.' => 'U heeft geen toestemming om TrackBack pings te versturen.',
    'You are pinging trackbacks too quickly. Please try again later.' => 'U bent te snel TrackBacks aan het pingen. Probeer het later opnieuw.',
    'Need a Source URL (url).' => 'Bron-URL vereist (url).',
    'This TrackBack item is disabled.' => 'Dit TrackBack item is uitgeschakeld.',
    'This TrackBack item is protected by a passphrase.' => 'Dit TrackBack item is beschermd door een wachtwoord.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nieuwe TrackBack voor bericht #[_1] \'[_2]\'.',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nieuwe TrackBack voor categorie #[_1] \'[_2]\'.',
    'Can\'t create RSS feed \'[_1]\': ' => 'Kan RSS feed \'[_1]\' niet aanmaken: ',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'Nieuwe TrackBack ping naar bericht [_1] ([_2])',
    'New TrackBack Ping to Category [_1] ([_2])' => 'Nieuwe TrackBack ping naar categorie [_1] ([_2])',

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
    'Failed to authenticate using given credentials: [_1].' => 'Authenticatie mislukt met volgende credentials: [_1].',
    'You failed to validate your password.' => 'Het valideren van uw wachtwoord is mislukt.',
    'You failed to supply a password.' => 'U gaf geen wachtwoord op.',
    'The e-mail address is required.' => 'Het e-mail adres is vereist.',
    'User [_1] upgraded database to version [_2]' => 'Gebruiker [_1] deed een upgrade van de database naar versie [_2]',
    'Invalid session.' => 'Ongeldige sessie.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Geen permissies.  Gelieve uw administrator te contacteren om Movable Type te upgraden.',

    ## ./lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => 'Dit is een experimentele optie; schakel SafeMode uit in (mt.cfg) om er gebruik van te maken.',
    'No blog_id' => 'Geen blog_id',
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

    ## ./lib/MT/App/CMS.pm
    'No permissions' => 'Geen permissies',
    'Invalid blog' => 'Ongeldige blog',
    'Convert Line Breaks' => 'Regeleindes omzetten',
    'No birthplace, cannot recover password' => 'Geen geboorteplaats, kan wachtwoord niet terugvinden',
    'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Ongeldige poging om het wachtwoord terug te vinden; kan geen wachtwoorden terughalen in deze configuratie',
    'Invalid author_id' => 'Ongeldig author_id',
    'Can\'t recover password in this configuration' => 'Kan geen wachtwoorden terugvinden in deze configuratie',
    'Invalid author name \'[_1]\' in password recovery attempt' => 'Ongeldige auteursnaam \'[_1]\' bij poging om wachtwoord terug te vinden',
    'Author name or birthplace is incorrect.' => 'Auteursnaam of geboorteplaats is niet correct.',
    'Author has not set birthplace; cannot recover password' => 'Auteur heeft geen geboorteplaats ingesteld, kan paswoord niet terugvinden',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'Ongeldige poging om wachtwoord terug te vinden (opgegeven geboorteplaats \'[_1]\')',
    'Author does not have email address' => 'Auteur heeft geen e-mail adres',
    'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => 'Wachtwoord werd opnieuw gezet voor auteur \'[_1]\' (gebruiker #[_2]). Het wachtwoord werd naar volgend e-mail adres gestuurd: [_3]',
    'Error sending mail ([_1]); please fix the problem, then ' => 'Probleem bij het versturen van mail ([_1]); gelieve het probleem op te lossen en ',
    'Invalid type' => 'Ongeldig type',
    'No such tag' => 'Onbekende tag',
    'You are not authorized to log in to this blog.' => 'U hebt geen toestemming op u aan te melden op deze weblog.',
    'No such blog [_1]' => 'Geen blog [_1]',
    'System Overview' => 'Systeemoverzicht',
    'Main Menu' => 'Hoofdmenu',
    'Weblog Activity Feed' => 'Weblogactiviteit-feed',
    '(author deleted)' => '(auteur verwijderd)',
    'Permission denied.' => 'Toestemming geweigerd.',
    'All Feedback' => 'Alle feedback',
    'log records' => 'logberichten',
    'System Activity Feed' => 'Systeemactiviteit-feed',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Applicatielog voor blog \'[_1]\' leeggemaakt door \'[_2]\' (gebruikersnummer [_3])',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Applicatielog leeggemaakt door \'[_1]\' (gebruikersnummer [_2])',
    'Import/Export' => 'Importeren/exporteren',
    'Load failed: [_1]' => 'Laden mislukt: [_1]',
    '(no reason given)' => '(geen reden vermeld)',
    '(untitled)' => '(geen titel)',
    'Create template requires type' => 'Sjabloon aanmaken vereist type',
    'New Template' => 'Nieuwe sjabloon',
    'New Weblog' => 'Nieuwe weblog',
    'Author requires username' => 'Auteur vereist gebruikersnaam',
    'Author requires password' => 'Author vereist wachtwoord',
    'Author requires password hint' => 'Auteur vereist wachtwoordhint',
    'Email Address is required for password recovery' => 'E-mail adres is vereist voor het terugvinden van een wachtwoord',
    'The value you entered was not a valid email address' => 'Wat u invulde was geen geldig e-mail adres',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'Het e-mail adres dat u opgaf staat al op de notificatielijst voor deze weblog.',
    'You did not enter an IP address to ban.' => 'U vulde geen IP adres in om te verbannen.',
    'The IP you entered is already banned for this weblog.' => 'Het IP adres dat u opgaf was al verbannen van deze weblog.',
    'You did not specify a weblog name.' => 'U gaf geen naam van een weblog op.',
    'Site URL must be an absolute URL.' => 'Site URL moet eenn absolute URL zijn.',
    'The name \'[_1]\' is too long!' => 'De naam \'[_1]\' is te lang!',
    'No categories with the same name can have the same parent' => 'Geen twee categorieën met dezelfde naam kunnen dezelfde hoofdcategorie hebben',
    'Saving permissions failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
    'Can\'t find default template list; where is ' => 'Kan de standaard sjabloonlijst niet vinden; waar is ',
    'Populating blog with default templates failed: [_1]' => 'Inrichten van blog met standaard sjablonen mislukt: [_1]',
    'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' aangemaakt door \'[_2]\' (gebruikersnummer [_3])',
    'An author by that name already exists.' => 'Een auteur met die naam bestaat reeds.',
    'Save failed: [_1]' => 'Opslaan mislukt: [_1]',
    'Saving object failed: [_1]' => 'Object opslaan mislukt: [_1]',
    'No Name' => 'Geen naam',
    'Notification List' => 'Notificatie-lijst',
    'email addresses' => 'emailaddressen',
    'Can\'t delete that way' => 'Kan niet wissen op die manier',
    'Your login session has expired.' => 'Uw login-sessie is verlopen.',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => '
    U kunt deze categorie niet verwijderen want ze heeft subcategorieën.  Verplaats of verwijder eerst de subcategorieën als u deze wenst te verwijderen.',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' verwijderd door \'[_2]\' (gebruikersnummer [_3])',
    'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
    'Loading object driver [_1] failed: [_2]' => 'Objectdriver [_1] laden mislukt: [_2]',
    'Invalid filename \'[_1]\'' => 'Ongeldige bestandsnaam \'[_1]\'',
    'Reading \'[_1]\' failed: [_2]' => 'Lezen van \'[_1]\' mislukt: [_2]',
    'Thumbnail failed: [_1]' => 'Verkleinde afbeelding mislukt: [_1]',
    'Error writing to \'[_1]\': [_2]' => 'Fout bij schrijven naar \'[_1]\': [_2]',
    'Invalid basename \'[_1]\'' => 'Ongeldige basisnaam \'[_1]\'',
    'No such commenter [_1].' => 'Geen reageerder [_1].',
    'User \'[_1]\' (#[_2]) approved commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) keurde reageerder \'[_3]\' (#[_4]) goed.',
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) verbande reageerder \'[_3]\' (#[_4]).',
    'User \'[_1]\' (#[_2]) unapproved commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) keurde reageerder \'[_3]\' (#[_4]) af.',
    'Need a status to update entries' => 'Status vereist om berichten bij te werken',
    'Need entries to update status' => 'Berichten nodig om status bij te werken',
    'One of the entries ([_1]) did not actually exist' => 'Een van de berichten ([_1]) bestond niet',
    'Some entries failed to save' => 'Sommige berichten werden niet opgeslagen',
    'You don\'t have permission to approve this TrackBack.' => 'U heeft geen toestemming om deze TrackBack goed te keuren.',
    'Comment on missing entry!' => 'Reactie op ontbrekend bericht!',
    'You don\'t have permission to approve this comment.' => 'U heeft geen toestemming om deze reactie goed te keuren.',
    'Comment Activity Feed' => 'Reactieactiviteit-feed',
    'Orphaned comment' => 'Verweesde reactie',
    'Plugin Set: [_1]' => 'Pluginset: [_1]',
    'TrackBack Activity Feed' => 'TrackBackactiviteit-feed',
    'No Excerpt' => 'Geen uittreksel',
    'No Title' => 'Geen titel',
    'Orphaned TrackBack' => 'Verweesde TrackBack',
    'Tag' => 'Tag', # Translate
    'Entry Activity Feed' => 'Berichtactiviteit-feed',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; publicatiedatums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ongeldige datum \'[_1]\'; berichtdatums moeten echte datums zijn.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opslaan mislukt: [_2]',
    'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
    'No such entry.' => 'Geen bericht.',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren totdat deze zijn ingesteld.',
    'PreSave failed [_1]' => 'PreSave mislukt [_1]',
    'The category must be given a name!' => 'De categorie moet een naam krijgen!',
    'yyyy/mm/entry_basename' => 'jjjj/mm/basisnaam_bericht',
    'yyyy/mm/entry-basename' => 'jjjj/mm/basisnaam-bericht',
    'yyyy/mm/entry_basename/' => 'jjjj/mm/basisnaam_bericht/',
    'yyyy/mm/entry-basename/' => 'jjjj/mm/basisnaam-bericht/',
    'yyyy/mm/dd/entry_basename' => 'jjjj/mm/dd/basisnaam_bericht',
    'yyyy/mm/dd/entry-basename' => 'jjjj/mm/dd/basisnaam-bericht',
    'yyyy/mm/dd/entry_basename/' => 'jjjj/mm/dd/basisnaam_bericht/',
    'yyyy/mm/dd/entry-basename/' => 'jjjj/mm/dd/basisnaam-bericht/',
    'category/sub_category/entry_basename' => 'categorie/sub_categorie/basisnaam_bericht',
    'category/sub_category/entry_basename/' => 'categorie/sub_categorie/basisnaam_bericht/',
    'category/sub-category/entry_basename' => 'categorie/sub-categorie/basisnaam_bericht',
    'category/sub-category/entry-basename' => 'categorie/sub-categorie/basisnaam-bericht',
    'category/sub-category/entry_basename/' => 'categorie/sub-categorie/basisnaam_bericht/',
    'category/sub-category/entry-basename/' => 'categorie/sub-categorie/basisnaam-bericht/',
    'primary_category/entry_basename' => 'hoofd_categorie/basisnaam_bericht',
    'primary_category/entry_basename/' => 'hoofd_categorie/basisnaam_bericht/',
    'primary-category/entry_basename' => 'hoofd-categorie/basisnaam_bericht',
    'primary-category/entry-basename' => 'hoofd-categorie/basisnaam-bericht',
    'primary-category/entry_basename/' => 'hoofd-categorie/basisnaam_bericht/',
    'primary-category/entry-basename/' => 'hoofd-categorie/basisnaam-bericht/',
    'yyyy/mm/' => 'jjjj/mm/',
    'yyyy_mm' => 'jjjj_mm',
    'yyyy/mm/dd/' => 'jjjj/mm/dd/',
    'yyyy_mm_dd' => 'jjjj_mm_dd',
    'yyyy/mm/dd-week/' => 'jjjj/mm/dd-week/',
    'week_yyyy_mm_dd' => 'week_jjjj_mm_dd',
    'category/sub_category/' => 'categorie/sub_categorie/',
    'category/sub-category/' => 'categorie/sub-categorie/',
    'cat_category' => 'cat_categorie',
    'Saving blog failed: [_1]' => 'Blog opslaan mislukt: [_1]',
    'You do not have permission to configure the blog' => 'U heeft geen toestemming om de configuratie van deze blog te wijzigen',
    'Saving map failed: [_1]' => 'Map opslaan mislukt: [_1]',
    'Parse error: [_1]' => 'Ontleedfout: [_1]',
    'Build error: [_1]' => 'Opbouwfout: [_1]',
    'Rebuild-option name must not contain special characters' => 'Naam van de herbouwoptie mag geen speciale karakters bevatten',
    'index template \'[_1]\'' => 'indexsjabloon \'[_1]\'',
    'entry \'[_1]\'' => 'bericht \'[_1]\'',
    'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' mislukt: [_2]',
    'You cannot modify your own permissions.' => 'U kan uw eigen permissies niet veranderen.',
    'You are not allowed to edit the permissions of this author.' => 'U heeft geen toestemming om de permisies van deze auteur te bewerken.',
    'Edit Permissions' => 'Permissies bewerken',
    'Edit Profile' => 'Profiel bewerken',
    'No entry ID provided' => 'Geen bericht-ID opgegeven',
    'No such entry \'[_1]\'' => 'Geen bericht \'[_1]\'',
    'No email address for author \'[_1]\'' => 'Geen e-mail adres voor auteur \'[_1]\'',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Fout bij verzenden mail ([_1]); een andere MailTransfer instelling proberen?',
    'You did not choose a file to upload.' => 'U selecteerde geen bestand om op te laden.',
    'Invalid extra path \'[_1]\'' => 'Ongeldig extra pad \'[_1]\'',
    'Can\'t make path \'[_1]\': [_2]' => 'Kan pad \'[_1]\' niet aanmaken: [_2]',
    'Invalid temp file name \'[_1]\'' => 'Ongeldige naam voor temp bestand \'[_1]\'',
    'Error opening \'[_1]\': [_2]' => 'Fout bij openen van \'[_1]\': [_2]',
    'Error deleting \'[_1]\': [_2]' => 'Fout bij wissen van \'[_1]\': [_2]',
    'File with name \'[_1]\' already exists. (Install ' => 'Bestand met naam \'[_1]\' bestaat al. (Installeer ',
    'Error creating temporary file; please check your TempDir ' => 'Fout bij aanmaken tijdelijk bestand; controleer uw TempDir ',
    'unassigned' => 'niet toegewezen',
    'File with name \'[_1]\' already exists; Tried to write ' => 'Bestand met naam \'[_1]\' bestaat al; Probeerde te schrijven ',
    'Error writing upload to \'[_1]\': [_2]' => 'Fout bij schrijven van upload naar \'[_1]\': [_2]',
    'Perl module Image::Size is required to determine ' => 'Perl module Image::Size is vereist om te bepalen  ',
    'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
    'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
    'Saving object failed: [_2]' => 'Object opslaan mislukt: [_2]',
    'Search & Replace' => 'Zoeken & vervangen',
    'No blog ID' => 'Geen blog-ID',
    'You do not have export permissions' => 'U heeft geen exportpermissies',
    'You do not have import permissions' => 'U heeft geen importpermissies',
    'You do not have permission to create authors' => 'U heeft geen permissie om auteurs aan te maken',
    'Preferences' => 'Voorkeuren',
    'Add a Category' => 'Categorie toevoegen',
    'No label' => 'Geen label',
    'Category name cannot be blank.' => 'Categorienaam kan niet leeg zijn.',
    'That action ([_1]) is apparently not implemented!' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd!',
    'Permission denied' => 'Toestemming geweigerd',

    ## ./lib/MT/App/ActivityFeeds.pm
    'TrackBacks for [_1]' => 'TrackBacks voor [_1]',
    'All TrackBacks' => 'Alle TrackBacks',
    '[_1] Weblog TrackBacks' => '[_1] Weblog TrackBacks', # Translate
    'All Weblog TrackBacks' => 'Alle Weblog TrackBacks',
    'Comments for [_1]' => 'Reacties voor [_1]',
    'All Comments' => 'Alle reacties',
    '[_1] Weblog Comments' => '[_1] Weblogreacties',
    'All Weblog Comments' => 'Alle Weblogreacties',
    'Entries for [_1]' => 'Berichten voor [_1]',
    'All Entries' => 'Alle berichten',
    '[_1] Weblog Entries' => '[_1] Weblogberichten',
    'All Weblog Entries' => 'Alle weblogberichten',
    '[_1] Weblog' => '[_1] Weblog', # Translate
    'All Weblogs' => 'Alle weblogs',
    '[_1] Weblog Activity' => '[_1] Weblogactiviteit',
    'All Weblog Activity' => 'Alle weblogactiviteit',

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'Opzoeken van IP adres voor bron URL [_1] mislukt',
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Gemodereerd: Domein IP komt niet overeen met ping IP voor bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Domein IP komt niet overeen met ping IP voor bron URL [_1]; domein IP: [_2]; ping IP: [_3]',
    'No links are present in feedback' => 'Geen links aanwezig in feedback',
    'Number of links exceed junk limit ([_1])' => 'Aantal links overschreed spam-limiet ([_1])',
    'Number of links exceed moderation limit ([_1])' => 'Aantal links overschreed moderatie-limiet ([_1])',
    'Link was previously published (comment id [_1]).' => 'Link werd eerder al gepubliceerd (reactie id [_1]).',
    'Link was previously published (TrackBack id [_1]).' => 'Link werd eerder al gepubliceerd (TrackBack id [_1]).',
    'E-mail was previously published (comment id [_1]).' => 'E-mail werd eerder al gepubliceerd (reactie id [_1]).',
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Woordfilter overeenkomst op \'[_1]\': \'[_2]\'.',
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Gemodereerd wegens woordfilter overeenkomst op \'[_1]\': \'[_2]\'.',
    'domain \'[_1]\' found on service [_2]' => 'domein \'[_1]\' gevonden op service [_2]',
    '[_1] found on service [_2]' => '[_1] gevonden op service [_2]',

    ## ./plugins/spamlookup/lib/spamlookup/L10N.pm

    ## ./t/Foo.pm

    ## ./t/Bar.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./mt-static/mt.js
    'You did not select any [_1] to delete.' => 'U selecteerde geen [_1] om te verwijderen',
    'Are you sure you want to delete this [_1]?' => 'Bevestiging: [_1] verwijderen?',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Bent u zeker dat u de [_1] geselecteerde [_2] wenst te verwijderen?',
    'to delete' => 'om te verwijderen',
    'You did not select any [_1] [_2].' => 'U selecteerde geen [_1] [_2]',
    'You must select an action.' => 'U moet een handeling selecteren',
    'to mark as junk' => 'om als verworpen te markeren',
    'to remove "junk" status' => 'om niet langer als "verworpen" te markeren',
    'Enter email address:' => 'Voer e-mail adres in:',
    'Enter URL:' => 'Voer URL in:',
);

1;
