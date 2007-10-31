package MT::L10N::nl;
# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
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

    ## ./mt-check.cgi.pre
    'Movable Type System Check' => 'Movable Type - systeemcontrole',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Deze pagina geeft u informatie over de configuratie van uw systeem en gaat na of u alle vereiste onderdelen hebt om Movable Type uit te kunnen voeren.',
    'System Information' => 'Systeeminformatie',
    'Current working directory:' => 'Huidige werkmap:',
    'MT home directory:' => 'MT hoofdmap:',
    'Operating system:' => 'Besturingssysteem:',
    'Perl version:' => 'Perl-versie:',
    'Perl include path:' => 'Perl include-pad:',
    'Web server:' => 'Webserver:',
    '(Probably) Running under cgiwrap or suexec' => 'Wordt (mogelijk) uitgevoerd onder cgiwrap of suexec',
    '[_1] [_2] Modules:' => '[_1] [_2] Modules:', # Translate - New (4)
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

    ## ./addons/Enterprise.pack/tmpl/cfg_ldap.tmpl

    ## ./addons/Enterprise.pack/tmpl/edit_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group.tmpl

    ## ./addons/Enterprise.pack/tmpl/list_group_member.tmpl
    'member' => 'lid',
    'Remove' => 'Verwijder',
    'Remove selected members ()' => 'Geselecteerde leden verwijderen ()',

    ## ./addons/Enterprise.pack/tmpl/select_groups.tmpl

    ## ./build/exportmt.pl

    ## ./build/template_hash_signatures.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/wrap.pl

    ## ./extras/examples/plugins/BackupRestoreSample/BackupRestoreSample.pl
    'This plugin is to test out the backup restore callback.' => 'Deze plugin dient om de backup/restore callback te testen.', # Translate - New (10)

    ## ./extras/examples/plugins/CommentByGoogleAccount/CommentByGoogleAccount.pl
    'You can allow readers to authenticate themselves via Google Account to comment on posts.' => 'U kunt uw lezers toelaten om zich via hun Google Account te authenticeren om reacties achter te laten.', # Translate - New (14)

    ## ./extras/examples/plugins/CommentByGoogleAccount/tmpl/config.tmpl

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'Allow readers to rate entries, assets, comments and trackbacks.' => 'Laat lezers een score toekennen aan berichten, mediabestanden, reacties en trackbacks.', # Translate - New (9)

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl
    'l10nsample' => 'l10nvoorbeeld',
    'This description can be localized if there is l10n_class set.' => 'Deze beschrijving kan worden gelocaliseerd als l10n_class is ingesteld.',
    'Fumiaki Yoshimatsu' => 'Fumiaki Yoshimatsu', # Translate - Previous (2)

    ## ./extras/examples/plugins/l10nsample/tmpl/view.tmpl
    'This phrase is processed in template.' => 'Deze uitdrukking wordt verwerkt in het sjabloon.',

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/tmpl/mirror.tmpl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl
    'Scores each entry.' => 'Kent een score toe aan elk bericht.', # Translate - New (3)

    ## ./extras/examples/plugins/SimpleScorer/tmpl/scored.tmpl

    ## ./lib/MT/default-templates.pl

    ## ./plugins/Cloner/cloner.pl
    'Clones a weblog and all of its contents.' => 'Maakt een kloon van een weblog en alle inhoud ervan.',
    'Cloning Weblog' => 'Bezig met klonen van weblog',
    'Error' => 'Fout',
    'Close' => 'Sluiten',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'TBD' => 'TBD', # Translate - New (1)

    ## ./plugins/ExtensibleArchives/DatebasedCategories.pl

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?' => 'Feeds.App Lite helpt u om feeds te herpubliceren op uw weblogs.  Wenst u meer te doen met feeds in Movable Type?',
    'Upgrade to Feeds.App' => 'Upgraden naar Feeds.App',

    ## ./plugins/feeds-app-lite/tmpl/config.tmpl
    'Feeds.App Lite Widget Creator' => 'Feeds.App Lite Widgetmaker',
    'Feed Configuration' => 'Feed-configuratie',
    '3' => '3', # Translate - Previous (1)
    '5' => '5', # Translate - Previous (1)
    '10' => '10', # Translate - Previous (1)
    'All' => 'Alle',
    'Save' => 'Opslaan',

    ## ./plugins/feeds-app-lite/tmpl/footer.tmpl

    ## ./plugins/feeds-app-lite/tmpl/header.tmpl
    'Main Menu' => 'Hoofdmenu',
    'System Overview' => 'Systeemoverzicht',
    'Help' => 'Hulp',
    'Welcome' => 'Welkom',
    'Logout' => 'Afmelden',
    'Search' => 'Zoek',
    'Entries' => 'Berichten',
    'Search (q)' => 'Zoeken (q)',

    ## ./plugins/feeds-app-lite/tmpl/msg.tmpl
    'No feeds could be discovered using [_1].' => 'Er konden geen feeds gevonden worden met [_1].',
    'An error occurred processing [_1]. Check <a href=' => 'Er gebeurde een fout tijdens het verwerken van [_1]. Controleer <a href=',
    'It can be included onto your published blog using <a href=' => 'Dit kan worden opgenomen in uw gepubliceerde weblog door gebruik te maken van <a href=',
    'It can be included onto your published blog using this MTInclude tag' => 'Dit kan worden opgenomen in uw gepubliceerde weblog door deze MTInclude tag te gebruiken',
    'Go Back' => 'Ga terug',
    'Create Another' => 'Maak er nog één aan',

    ## ./plugins/feeds-app-lite/tmpl/select.tmpl
    'Multiple feeds were discovered. Select the feed you wish to use. Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.' => 'Er werden meerdere feeds gevonden.  Selecteer de feed die u wenst te gebruiken.  Feeds.App Lite ondersteunt RSS 1.0, 2.0 en Atom feeds die alleen uit tekst bestaan.',
    'Type' => 'Type', # Translate - Previous (1)
    'URI' => 'URI', # Translate - Previous (1)
    'Continue' => 'Doorgaan',

    ## ./plugins/feeds-app-lite/tmpl/start.tmpl
    'Feeds.App Lite creates modules that include feed data. Once you\'ve used it to create those modules, you can then use them in your blog templates.' => 'Feeds.App Lite maakt modules aan die feedgegevens bevatten.  Eens u het gebruikt heeft om deze modules aan te maken, kunt u ze daarna gebruiken in uw weblogsjablonen.',
    'You must enter an address to proceed' => 'U moet een adres invullen om verder te kunnen gaan',
    'Enter the URL of a feed, or the URL of a site that has a feed.' => 'Vul de URL in van een feed, of de URL van een site met een feed..',

    ## ./plugins/GoogleSearch/GoogleSearch.pl

    ## ./plugins/GoogleSearch/tmpl/config.tmpl

    ## ./plugins/Markdown/Markdown.pl

    ## ./plugins/Markdown/SmartyPants.pl

    ## ./plugins/MultiBlog/multiblog.pl
    'MultiBlog allows you to publish templated or raw content from other blogs and define rebuild dependencies and access controls between them.' => 'Met MultiBlog kunt u gesjabloneerde of ruwe inhoud publiceren van andere blogs en kunt u afhankelijkheden instellen voor het herbouwen en de instellingen voor wederzijdse toegang tussen blogs.',

    ## ./plugins/MultiBlog/tmpl/blog_config.tmpl
    'When' => 'Wanneer',
    'Any Weblog' => 'Eender welke weblog',
    'Weblog' => 'Weblog', # Translate - Previous (1)
    'Trigger' => 'Uitvoeren indien',
    'Action' => 'Handeling',
    'Use system default' => 'Standaard systeemwaarde gebruiken',
    'Allow' => 'Toestaan',
    'Disallow' => 'Niet toestaan',
    'Include blogs' => 'Blogs opnemen',
    'Exclude blogs' => 'Blogs uitsluiten',
    'Current Rebuild Triggers:' => 'Huidige triggers voor opnieuw opbouwen:',
    'Create New Rebuild Trigger' => 'Nieuwe trigger voor opnieuw opbouwen aanmaken',
    'You have not defined any rebuild triggers.' => 'U heeft nog geen triggers voor opnieuw opbouwen gedefiniëerd.',

    ## ./plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl

    ## ./plugins/MultiBlog/tmpl/system_config.tmpl
    'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Aggregatie tussen verschillende blogs wordt standaard toegestaan.  Individuele blogs kunnen via de Multiblog instellingen op blogniveau worden ingesteld om geen toegang te verlenen tot hun content aan andere blogs.',
    'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Aggregatie tussen verschillende blogs wordt standaard niet toegestaan.  Individuele blogs kunnen via de Multiblog instellingen op blogniveau worden ingesteld om wel toegang te verlenen tot hun content aan andere blogs.',

    ## ./plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'SpamLookup module voor het gebruik van blacklist-opzoekingsdiensten om feedback te filteren.',

    ## ./plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - Link', # Translate - Previous (2)
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'SpamLookup module voor het verwerpen en modereren van feedback gebaseerd op linkfilters.',

    ## ./plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => 'SpamLookup module voor het modereren en verwerpen van feedback door middel van sleutelwoord-filters.',

    ## ./plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => '
Opzoekingen houden IP adressen van oorsprong en hyperlinks in de gaten van alle binnenkomende feedback.  Als een reactie of een TrackBack binnenkomt van een IP dat op de zwarte lijst staat of een domein bevat dat op de zwarte lijst voorkomt, kan het worden tegengehouden voor moderatie of als spam worden aangemerkt en in de spam-map van de weblog worden geplaatst.  Bijkomend kunnen er nog geavandceerde opzoekingen gebeuren op de brongegevens van een TrackBack.',
    'IP Address Lookups:' => 'Opzoekingen op IP adres:',
    'Off' => 'Uit',
    'Moderate feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst modereren',
    'Junk feedback from blacklisted IP addresses' => 'Feedback van IP adressen op de zwarte lijst verwerpen',
    'Adjust scoring' => 'Score aanpassen',
    'Score weight:' => 'Scoregewicht:',
    'Less' => 'Minder',
    'Decrease' => 'Verlaag',
    'Increase' => 'Verhoog',
    'More' => 'Meer',
    'block' => 'tegenhouden',
    'none' => 'geen',
    'Domain Name Lookups:' => 'Opzoekingen op domeinnaam:',
    'Moderate feedback containing blacklisted domains' => 'Feedback van domeinen op de zwarte lijst modereren',
    'Junk feedback containing blacklisted domains' => 'Feedback van domeinen op de zwarte lijst verwerpen',
    'Moderate TrackBacks from suspicious sources' => 'TrackBacks uit verdachte bronnen modereren',
    'Junk TrackBacks from suspicious sources' => 'TrackBacks uit verdachte bronnen verwerpen',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'Om het opzoeken van bepaalde IP adressen of domeinen te voorkomen, gelieve ze hieronder in te vullen.  Zet elk item op een aparte lijn.',
    'Lookup Whitelist:' => 'Witte lijst opzoekingen:',

    ## ./plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Linkfilters houden het aantal links in de gaten in binnenkomende feedback.  Feedback met buitengewoon veel links kan worden tegengehouden voor moderatie of als junk worden aangemerkt.  Aan de andere kant kan feedback die geen links bevat of enkel verwijst naar eerder gepubliceerde URLs positief beoordeeld worden. (Schakel deze optie in wanneer u er zeker van bent dat uw site al spamvrij is.).)',
    'Credit feedback rating when no hyperlinks are present' => 'Ken positieve score toe aan feedback wanneer er geen hyperlinks aanwezig zijn',
    'Moderate when more than' => 'Modereer indien meer dan',
    'link(s) are given' => 'link(s) aanwezig zijn',
    'Junk when more than' => 'Verwerp indien meer dan',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Ken feedback een positieve score toe indien een &quot;URL&quot; element van de feedback al eerder gepubliceerd werd',
    'Only applied when no other links are present in message of feedback.' => 'Enkel toegepast wanneer geen andere links aanwezig zijn in het bericht van de feedback.',
    'Exclude URLs from comments published within last [_1] days.' => 'URL\'s uitsluiten van reacties geplaatst in de laatste [_1] dagen.',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Ken feedback een positive score toe indien eerder gepubliceerde reacties gevonden worden die overeenkomen qua e-mail adres',
    'Exclude Email addresses from comments published within last [_1] days.' => 'E-mail adressen uitsluiten van reacties geplaatst in de laatste [_1] dagen.',

    ## ./plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Binnenkomende feedback kan in de gaten worden gehouden voor specifieke sleutelwoorden, domeinnamen of patronen.  Overeenkomsten kunnen worden tegengehouden voor moderatie of als spam worden aangemerkt. Bijkomend kan de spamscore voor deze overeenkomsten worden gepersonaliseerd.',

    ## ./plugins/StyleCatcher/stylecatcher.pl
    '<p style=' => '<p style=', # Translate - Previous (3)
    'Theme Root URL:' => 'Themaroot URL:',
    'Theme Root Path:' => 'Themaroot pad:',
    'Style Library URL:' => 'Stijlenbibliotheek URL:',

    ## ./plugins/StyleCatcher/tmpl/footer.tmpl

    ## ./plugins/StyleCatcher/tmpl/gmscript.tmpl

    ## ./plugins/StyleCatcher/tmpl/header.tmpl
    'View Site' => 'Site bekijken',

    ## ./plugins/StyleCatcher/tmpl/view.tmpl
    'Please select a weblog to apply this theme.' => 'Gelieve een weblog te selecteren om dit thema op toe te passen.',
    'Please click on a theme before attempting to apply a new design to your blog.' => 'Gelieve op een thema te klikken voor u een nieuw design instelt voor uw weblog.',
    'Applying...' => 'Wordt toegepast...',
    'Choose this Design' => 'Dit design kiezen',
    'Find Style' => 'Stijl zoeken',
    'Loading...' => 'Laden...',
    'StyleCatcher user script.' => 'StyleCatcher gebruikers script.',
    'Theme or Repository URL:' => 'URL van thema of bibliotheek:',
    'Find Styles' => 'Stijlen zoeken',
    'NOTE:' => 'OPMERKING:',
    'It will take a moment for themes to populate once you click \'Find Style\'.' => 'Het kan even duren voor de lijst met thema\'s is ingeladen nadat u op \'Stijlen zoeken\' heeft geklikt.',
    'Categories' => 'Categorieën',
    'Current theme for your weblog' => 'Huidig thema van uw weblog',
    'Current Theme' => 'Huidig thema',
    'Current themes for your weblogs' => 'Huidige thema\'s voor uw weblogs',
    'Current Themes' => 'Huidige thema\'s',
    'Locally saved themes' => 'Lokaal opgeslagen thema\'s',
    'Saved Themes' => 'Opgeslagen thema\'s',
    'Single themes from the web' => 'Losse thema\'s van het web',
    'More Themes' => 'Meer thema\'s',
    'Templates' => 'Sjablonen',
    'Details' => 'Details', # Translate - Previous (1)
    'Show Details' => 'Details tonen',
    'Hide Details' => 'Details verbergen',
    'Select a Weblog...' => 'Selecteer een weblog...',
    'Apply Selected Design' => 'Geselecteerd design toepassen',
    'You don\'t appear to have any weblogs with a \'styles-site.css\' template that you have rights to edit. Please check your weblog(s) for this template.' => 'Het lijkt er op dat u geen weblogs heeft met een \'styles-site.css\' sjabloon waarvoor u rechten heeft om het te bewerken.  Kijk na of uw weblog(s) dit sjabloon hebben.',

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => 'Maak een backup van en zet bestaande sjablonen terug naar de standaardsjablonen van Movable Type.',

    ## ./plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'Backup nemen en sjablonen herstellen',
    'No templates were selected to process.' => 'Er werden geen sjablonen geselecteerd om te bewerken.',
    'Return' => 'Terug',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Maintain your weblog\'s widget content using a handy drag and drop interface.' => 'Beheer de widgets op uw weblog met een handige klik-en-sleep interface.',

    ## ./plugins/WidgetManager/default_widgets/calendar.tmpl
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

    ## ./plugins/WidgetManager/default_widgets/category_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/copyright.tmpl

    ## ./plugins/WidgetManager/default_widgets/creative_commons.tmpl
    'This weblog is licensed under a' => 'Deze weblog valt onder een licentie van het type',
    'Creative Commons License' => 'Creative Commons Licentie',

    ## ./plugins/WidgetManager/default_widgets/date-based_author_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/date-based_category_archives.tmpl

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
    'Archives' => 'Archieven',
    'Select a Month...' => 'Selecteer een maand...',

    ## ./plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/pages_list.tmpl

    ## ./plugins/WidgetManager/default_widgets/powered_by.tmpl

    ## ./plugins/WidgetManager/default_widgets/recent_comments.tmpl
    'Recent Comments' => 'Recente reacties',

    ## ./plugins/WidgetManager/default_widgets/recent_posts.tmpl
    'Recent Posts' => 'Recente berichten',

    ## ./plugins/WidgetManager/default_widgets/search.tmpl
    'Search this blog:' => 'Deze weblog doorzoeken:',

    ## ./plugins/WidgetManager/default_widgets/signin.tmpl

    ## ./plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl
    'Subscribe to this blog\'s feed' => 'Inschrijven op de feed van deze weblog',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds', # Translate - Previous (6)
    'What is this?' => 'Wat is dit?',

    ## ./plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl
    'Tag cloud' => 'Tagcloud',

    ## ./plugins/WidgetManager/default_widgets/technorati_search.tmpl
    'Technorati' => 'Technorati', # Translate - Previous (1)
    'this blog' => 'deze weblog',
    'all blogs' => 'alle blogs',
    'Blogs that link here' => 'Blogs die hierheen linken',

    ## ./plugins/WidgetManager/tmpl/edit.tmpl
    'Please use a unique name for this widget manager.' => 'Gelieve een unieke naam te gebruiken voor deze widget manager.', # Translate - New (9)
    'You already have a widget manager named [_1]. Please use a unique name for this widget manager.' => 'U heeft al een widget manager met de naam [_1]. Gelieve een unieke naam te gebruiken voor deze widget manager.',
    'Your changes to the Widget Manager have been saved.' => 'Uw wijzigingen aan de Widget Manager zijn opgeslagen.',
    'Installed Widgets' => 'Geïnstalleerde widgets',
    'Available Widgets' => 'Beschikbare widgets',
    'Save Changes' => 'Wijzigingen opslaan',
    'Save changes (s)' => 'Wijziging(en) opslaan',

    ## ./plugins/WidgetManager/tmpl/footer.tmpl

    ## ./plugins/WidgetManager/tmpl/header.tmpl
    'Movable Type Publishing Platform' => 'Movable Type publicatieplatform',
    'Go to:' => 'Ga naar:',
    'Select a blog' => 'Selecteer een blog',
    'Weblogs' => 'Weblogs', # Translate - Previous (1)
    'System-wide listing' => 'Overzicht op systeemniveau',

    ## ./plugins/WidgetManager/tmpl/list.tmpl

    ## ./plugins/WXRImporter/WXRImporter.pl
    'Import WordPress exported RSS into MT.' => 'Importeer RSS geëxporteerd uit WordPress in MT.', # Translate - New (6)

    ## ./plugins/WXRImporter/tmpl/options.tmpl
    'Site Root' => 'Siteroot',
    'Archive Root' => 'Archiefroot',

    ## ./search_templates/comments.tmpl
    'Search Results' => 'Zoekresultaten',
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
    'Instructions' => 'Gebruiksaanwijzing',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => 'Selecteer het tijdsinterval waarin u wenst te zoeken en klik dan op \'Nieuwe reacties zoeken\'',

    ## ./search_templates/default.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'AUTODISCOVERY LINK VOOR ZOEKFEED WORDT ENKEL GEPUBLICEERD WANNEER EEN ZOEKOPDRACHT IS UITGEVOERD',
    'Blog Search Results' => 'Blog zoekresultaten',
    'Blog search' => 'Blog doorzoeken',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'GEWONE ZOEKOPDRACHTEN KRIJGEN HET ZOEKFORMULIER TE ZIEN',
    'Search this site' => 'Deze website doorzoeken',
    'Match case' => 'Kapitalisering moet overeen komen',
    'Regex search' => 'Zoeken met reguliere expressies',
    'SEARCH RESULTS DISPLAY' => 'ZOEKRESULTATEN TONEN',
    'Matching entries from [_1]' => 'Gevonden berichten op [_1]',
    'Entries from [_1] tagged with \'[_2]\'' => 'Berichten op [_1] getagd met \'[_2]\'',
    'Tags' => 'Tags', # Translate - Previous (1)
    'Posted <MTIfNonEmpty tag=' => 'Gepubliceerd <MTIfNonEmpty tag=',
    'Showing the first [_1] results.' => 'De eerste [_1] resultaten worden getoond.',
    'NO RESULTS FOUND MESSAGE' => 'GEEN RESULTATEN GEVONDEN BOODSCHAP',
    'Entries matching \'[_1]\'' => 'Berichten met \'[_1]\' in',
    'Entries tagged with \'[_1]\'' => 'Berichten getagd met \'[_1]\'',
    'No pages were found containing \'[_1]\'.' => 'Er werden geen berichten gevonden met \'[_1]\' in.',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een precieze uitdrukking te vinden, moet ze tussen aanhalingstekens geplaatst worden',
    'movable type' => 'movable type', # Translate - Previous (2)
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'De zoekmachine ondersteunt ook AND, OR en NOT sleutelwoorden om booleaanse expressies mee op te geven',
    'personal OR publishing' => 'persoonlijk OR publicatie',
    'publishing NOT personal' => 'publiceren NOT persoonlijk',
    'END OF ALPHA SEARCH RESULTS DIV' => 'EINDE VAN ALPHA ZOEKRESULTATEN DIV',
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'BEGIN VAN BETA ZIJKOLOM OM ZOEKINFORMATIE IN TE TONEN',
    'SET VARIABLES FOR SEARCH vs TAG information' => 'STEL VARIABELEN IN VOOR ZOEK vs TAG informatie',
    'Subscribe to feed' => 'Inschrijven op feed',
    'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met de tag \'[_1]\'.',
    'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'Als u een RSS lezer gebruikt, kunt u inschrijven op een feed met alle toekomstige berichten met \'[_1]\' in.',
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ZOEK/TAG FEED INSCHRIJVINGSINFORMATIE',
    'Feed Subscription' => 'Feed inschrijving',
    'TAG LISTING FOR TAG SEARCH ONLY' => 'TAG OPSOMMING ENKEL VOOR TAG ZOEKEN',
    'Other Tags' => 'Andere tags',
    'END OF PAGE BODY' => 'EINDE VAN PAGINA BODY',
    'END OF CONTAINER' => 'EINDE VAN CONTAINER',

    ## ./search_templates/results_feed.tmpl
    'Search Results for [_1]' => 'Zoekresultaten voor [_1]',

    ## ./search_templates/results_feed_rss2.tmpl

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/test-common.pl

    ## ./t/test.tmpl

    ## ./t/plugins/testplug.pl

    ## ./tmpl/error.tmpl
    'Missing Configuration File' => 'Ontbrekend configuratiebestand',
    'Database Connection Error' => 'Databaseverbindingsfout',
    'CGI Path Configuration Required' => 'CGI-pad configuratie vereist',
    'An error occurred' => 'Er deed zich een probleem voor',

    ## ./tmpl/cms/admin.tmpl

    ## ./tmpl/cms/author_bulk.tmpl

    ## ./tmpl/cms/backup.tmpl

    ## ./tmpl/cms/bookmarklets.tmpl

    ## ./tmpl/cms/cc_return.tmpl

    ## ./tmpl/cms/cfg_archives.tmpl

    ## ./tmpl/cms/cfg_comments.tmpl

    ## ./tmpl/cms/cfg_entry.tmpl

    ## ./tmpl/cms/cfg_plugin.tmpl

    ## ./tmpl/cms/cfg_prefs.tmpl

    ## ./tmpl/cms/cfg_spam.tmpl

    ## ./tmpl/cms/cfg_system_feedback.tmpl

    ## ./tmpl/cms/cfg_system_general.tmpl

    ## ./tmpl/cms/cfg_trackbacks.tmpl

    ## ./tmpl/cms/cfg_web_services.tmpl

    ## ./tmpl/cms/create_author_bulk_end.tmpl

    ## ./tmpl/cms/create_author_bulk_start.tmpl

    ## ./tmpl/cms/dashboard.tmpl

    ## ./tmpl/cms/dialog_adjust_sitepath.tmpl

    ## ./tmpl/cms/edit_author.tmpl

    ## ./tmpl/cms/edit_blog.tmpl

    ## ./tmpl/cms/edit_category.tmpl

    ## ./tmpl/cms/edit_comment.tmpl

    ## ./tmpl/cms/edit_commenter.tmpl

    ## ./tmpl/cms/edit_entry.tmpl

    ## ./tmpl/cms/edit_folder.tmpl

    ## ./tmpl/cms/edit_ping.tmpl

    ## ./tmpl/cms/edit_role.tmpl

    ## ./tmpl/cms/edit_template.tmpl

    ## ./tmpl/cms/error.tmpl

    ## ./tmpl/cms/export.tmpl

    ## ./tmpl/cms/handshake_return.tmpl

    ## ./tmpl/cms/import.tmpl

    ## ./tmpl/cms/import_others.tmpl

    ## ./tmpl/cms/install.tmpl

    ## ./tmpl/cms/list_asset.tmpl

    ## ./tmpl/cms/list_association.tmpl
    'Remove selected assocations (x)' => 'Geselecteerde associaties verwijderen (x)',
    'association' => 'associatie',
    'associations' => 'associaties',

    ## ./tmpl/cms/list_author.tmpl

    ## ./tmpl/cms/list_banlist.tmpl

    ## ./tmpl/cms/list_blog.tmpl

    ## ./tmpl/cms/list_category.tmpl

    ## ./tmpl/cms/list_comment.tmpl

    ## ./tmpl/cms/list_commenter.tmpl

    ## ./tmpl/cms/list_entry.tmpl

    ## ./tmpl/cms/list_folder.tmpl

    ## ./tmpl/cms/list_notification.tmpl

    ## ./tmpl/cms/list_ping.tmpl

    ## ./tmpl/cms/list_role.tmpl

    ## ./tmpl/cms/list_tag.tmpl
    'Delete' => 'Verwijderen',
    'tag' => 'tag', # Translate - Previous (1)
    'tags' => 'tags', # Translate - Previous (1)
    'Delete selected tags (x)' => 'Verwijder de geselecteerde tags (x)',

    ## ./tmpl/cms/list_template.tmpl
    'template' => 'sjabloon',
    'templates' => 'sjablonen',

    ## ./tmpl/cms/login.tmpl

    ## ./tmpl/cms/menu.tmpl

    ## ./tmpl/cms/pinging.tmpl

    ## ./tmpl/cms/preview_entry.tmpl

    ## ./tmpl/cms/rebuilding.tmpl

    ## ./tmpl/cms/recover_password_result.tmpl

    ## ./tmpl/cms/reload_opener.tmpl

    ## ./tmpl/cms/restore.tmpl

    ## ./tmpl/cms/restore_end.tmpl

    ## ./tmpl/cms/restore_start.tmpl

    ## ./tmpl/cms/search_replace.tmpl

    ## ./tmpl/cms/system_check.tmpl

    ## ./tmpl/cms/upgrade.tmpl

    ## ./tmpl/cms/upgrade_runner.tmpl

    ## ./tmpl/cms/view_log.tmpl
    'Clear Activity Log' => 'Activiteitenlog leegmaken', # Translate - New (3)

    ## ./tmpl/cms/dialog/asset_image_options.tmpl

    ## ./tmpl/cms/dialog/asset_insert.tmpl

    ## ./tmpl/cms/dialog/footer.tmpl

    ## ./tmpl/cms/dialog/grant_role.tmpl

    ## ./tmpl/cms/dialog/header.tmpl

    ## ./tmpl/cms/dialog/list_assets.tmpl

    ## ./tmpl/cms/dialog/post_comment.tmpl

    ## ./tmpl/cms/dialog/post_comment_end.tmpl

    ## ./tmpl/cms/dialog/restore_end.tmpl

    ## ./tmpl/cms/dialog/restore_start.tmpl

    ## ./tmpl/cms/dialog/restore_upload.tmpl

    ## ./tmpl/cms/dialog/select_users.tmpl

    ## ./tmpl/cms/dialog/select_weblog.tmpl

    ## ./tmpl/cms/dialog/upload.tmpl

    ## ./tmpl/cms/dialog/upload_complete.tmpl

    ## ./tmpl/cms/dialog/upload_confirm.tmpl

    ## ./tmpl/cms/include/actions_bar.tmpl

    ## ./tmpl/cms/include/anonymous_comment.tmpl

    ## ./tmpl/cms/include/archive_maps.tmpl

    ## ./tmpl/cms/include/author_table.tmpl
    'Status' => 'Status', # Translate - Previous (1)
    'Username' => 'Gebruikersnaam',
    'Name' => 'Naam',
    'Email' => 'E-mail',
    'URL' => 'URL', # Translate - Previous (1)
    'Only show enabled users' => 'Enkel ingeschakelde gebruikers worden getoond',
    'Only show pending users' => 'Enkel hangende gebruikers worden getoond', # Translate - New (4)
    'Only show disabled users' => 'Enkel uitgeschakelde gebruikers worden getoond',
    'Link' => 'Link', # Translate - Previous (1)

    ## ./tmpl/cms/include/backup_end.tmpl
    'All of the data has been backed up successfully!' => 'Alle gegevens zijn met succes opgeslagen!', # Translate - New (9)
    'Filename' => 'Bestandsnaam', # Translate - New (1)
    '_external_link_target' => '_extern_link_doel',
    'Download This File' => 'Dit bestand downloaden', # Translate - New (3)
    'An error occurred during the backup process: [_1]' => 'Er deed zich een fout voor tijdens het backup-proces: [_1]', # Translate - New (8)

    ## ./tmpl/cms/include/backup_start.tmpl

    ## ./tmpl/cms/include/blog-left-nav.tmpl
    'Creating' => 'Bezig aan te maken', # Translate - New (1)
    'Create New Entry' => 'Nieuw bericht opstellen',
    'New Entry' => 'Nieuw bericht',
    'List Entries' => 'Berichten weergeven',
    'List uploaded files' => 'Opgeladen bestanden weergeven', # Translate - New (3)
    'Assets' => 'Mediabestanden', # Translate - New (1)
    'Community' => 'Gemeenschap',
    'List Comments' => 'Reacties weergeven',
    'Comments' => 'Reacties',
    'List Commenters' => 'Reageerders tonen',
    'Commenters' => 'Registratie',
    'List TrackBacks' => 'TrackBacks tonen',
    'TrackBacks' => 'TrackBacks', # Translate - Previous (1)
    'Edit Notification List' => 'Notificatielijst bewerken',
    'Notifications' => 'Notificaties',
    'Configure' => 'Configureren',
    'List Users &amp; Groups' => 'Groepen en gebruikers tonen',
    'Users &amp; Groups' => 'Gebruikers &amp; Groepen',
    'List &amp; Edit Templates' => 'Sjablonen weergeven en bewerken',
    'Edit Categories' => 'Categorieën bewerken',
    'Edit Tags' => 'Tags bewerken',
    'Edit Weblog Configuration' => 'Weblogconfiguratie bewerken',
    'Settings' => 'Instellingen',
    'Utilities' => 'Hulpmiddelen',
    'Search &amp; Replace' => 'Zoeken en vervangen',
    'Backup this weblog' => 'Maak een backup van deze weblog', # Translate - New (3)
    'Backup' => 'Backup', # Translate - New (1)
    'View Activity Log' => 'Activiteitlog bekijken',
    'Activity Log' => 'Activiteitlog',
    'Import &amp; Export Entries' => 'Berichten importeren en exporteren',
    'Import / Export' => 'Import/export',
    'Rebuild Site' => 'Site herbouwen',

    ## ./tmpl/cms/include/blog_table.tmpl

    ## ./tmpl/cms/include/cfg_content_nav.tmpl

    ## ./tmpl/cms/include/cfg_entries_edit_page.tmpl
    'Default' => 'Standaard', # Translate - New (1)
    'Custom' => 'Aangepast',
    'Title' => 'Titel',
    'Body' => 'Romp', # Translate - New (1)
    'Category' => 'Categorie',
    'Excerpt' => 'Uittreksel',
    'Keywords' => 'Trefwoorden',
    'Publishing' => 'Publicatie',
    'Feedback' => 'Feedback', # Translate - Previous (1)
    'Below' => 'Onder',
    'Above' => 'Boven',
    'Both' => 'Allebei',

    ## ./tmpl/cms/include/cfg_system_content_nav.tmpl

    ## ./tmpl/cms/include/chromeless_footer.tmpl

    ## ./tmpl/cms/include/chromeless_header.tmpl

    ## ./tmpl/cms/include/commenter_table.tmpl

    ## ./tmpl/cms/include/comment_table.tmpl

    ## ./tmpl/cms/include/copyright.tmpl
    'Copyright &copy; 2001-<mt:date format=' => 'Copyright &copy; 2001-<mt:date format=', # Translate - New (7)

    ## ./tmpl/cms/include/display_options.tmpl

    ## ./tmpl/cms/include/entry_table.tmpl

    ## ./tmpl/cms/include/feed_link.tmpl

    ## ./tmpl/cms/include/footer.tmpl

    ## ./tmpl/cms/include/footer_popup.tmpl

    ## ./tmpl/cms/include/header.tmpl

    ## ./tmpl/cms/include/header_popup.tmpl

    ## ./tmpl/cms/include/import_end.tmpl
    'All data imported successfully!' => 'Alle gegevens werden met succes geïmporteerd!',
    'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Verwijder zeker de bestanden waaruit u gegevens importeerde uit de \'import\' folder, zodat wanneer u het import proces ooit opnieuw draait deze bestanden niet nog eens worden geïmporteerd.',
    'An error occurred during the import process: [_1]. Please check your import file.' => 'Er deed zich een fout voor tijdens het importproces: [_1]. Gelieve uw importbestand na te kijken.',

    ## ./tmpl/cms/include/import_start.tmpl
    'Importing entries into blog' => 'Berichten worden geïmporteerd in de blog',
    'Importing entries as user \'[_1]\'' => 'Berichten worden geïmporteerd als gebruiker \'[_1]\'',
    'Creating new users for each user found in the blog' => 'Nieuwe gebruikers worden aangemaakt voor elke gebruiker gevonden in de weblog',

    ## ./tmpl/cms/include/itemset_action_widget.tmpl

    ## ./tmpl/cms/include/listing_panel.tmpl
    'Step [_1] of [_2]' => 'Stap [_1] van [_2]',
    'View All' => 'Allen bekijken',
    'Go to [_1]' => 'Ga naar [_1]',
    'Sorry, there were no results for your search. Please try searching again.' => 'Sorry, er waren geen resultaten voor uw zoekopdracht. Probeer opnieuw te zoeken.',
    'Sorry, there is no data for this object set.' => 'Sorry, er zijn geen gegevens ingesteld voor dit object.',
    'Cancel' => 'Annuleren',
    'Back' => 'Terug',
    'Confirm' => 'Bevestigen',

    ## ./tmpl/cms/include/login_mt.tmpl
    'Remember me?' => 'Mij onthouden?',

    ## ./tmpl/cms/include/log_table.tmpl

    ## ./tmpl/cms/include/notification_table.tmpl

    ## ./tmpl/cms/include/overview-left-nav.tmpl
    'System' => 'Systeem',
    'List Weblogs' => 'Lijst weblogs',
    'List Users and Groups' => 'Lijst gebruikers en groepen',
    'List Associations and Roles' => 'Lijst associaties en rollen',
    'Privileges' => 'Privileges', # Translate - Previous (1)
    'List Plugins' => 'Lijst plugins',
    'Plugins' => 'Plugins', # Translate - Previous (1)
    'Aggregate' => 'Inhoudelijk',
    'List Tags' => 'Tags oplijsten',
    'Edit System Settings' => 'Systeeminstellingen bewerken',
    'Show Activity Log' => 'Activiteitlog bekijken',

    ## ./tmpl/cms/include/pagination.tmpl

    ## ./tmpl/cms/include/ping_table.tmpl

    ## ./tmpl/cms/include/rebuild_stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => 'Bouw uw website opnieuw op als u de wijzigingen op uw publieke site wilt kunnen zien.',
    'Rebuild my site' => 'Mijn site opnieuw opbouwen',

    ## ./tmpl/cms/include/template_table.tmpl

    ## ./tmpl/cms/include/tools_content_nav.tmpl

    ## ./tmpl/cms/include/typekey.tmpl

    ## ./tmpl/cms/include/users_content_nav.tmpl

    ## ./tmpl/cms/popup/bm_entry.tmpl

    ## ./tmpl/cms/popup/bm_posted.tmpl

    ## ./tmpl/cms/popup/category_add.tmpl

    ## ./tmpl/cms/popup/pinged_urls.tmpl

    ## ./tmpl/cms/popup/rebuild_confirm.tmpl

    ## ./tmpl/cms/popup/rebuilt.tmpl

    ## ./tmpl/cms/popup/recover.tmpl

    ## ./tmpl/cms/popup/show_upload_html.tmpl

    ## ./tmpl/comment/error.tmpl

    ## ./tmpl/comment/login.tmpl

    ## ./tmpl/comment/profile.tmpl

    ## ./tmpl/comment/register.tmpl
    'Register' => 'Registreer', # Translate - New (1)

    ## ./tmpl/comment/signup.tmpl

    ## ./tmpl/comment/signup_thanks.tmpl

    ## ./tmpl/comment/include/footer.tmpl

    ## ./tmpl/comment/include/header.tmpl

    ## ./tmpl/email/commenter_confirm.tmpl
    'Thank you registering for an account to comment on [_1].' => 'Bedankt om een account aan te maken om te kunnen reageren op [_1].', # Translate - New (10)
    'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Voor uw eigen veiligheid en om fraude te vermijden vragen we dat u deze account eerst bevestigt samen met uw e-mail adres.  Eens bevestigd kunt u meteen reageren op [_1].', # Translate - New (32)
    'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Om uw account te bevestigen, moet u op deze link klikken of de URL in uw webbrowser plakken:', # Translate - New (18)
    'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'Als u deze account niet heeft aangevraagd, of als u niet wenste te registreren om te kunnen reageren op [_1] dan hoeft u verder niets te doen.', # Translate - New (27)
    'Thank you very much for your understanding.' => 'Wij danken u voor uw begrip.', # Translate - New (7)
    'Sincerely,' => 'Hoogachtend,', # Translate - New (1)

    ## ./tmpl/email/commenter_notify.tmpl
    'This email is to notify you that a new user has successfully registered on the blog \'[_1].\' Listed below you will find some useful information about this new user.' => 'Met dit berichtje laten we u weten dat een nieuwe gebruiker zich heeft geregistreerd op weblog \'[_1].\'.  Hieronder vind u wat nuttige informatie over deze gebruiker.', # Translate - New (29)
    'Username:' => 'Gebruikersnaam:',
    'Full Name:' => 'Volledige naam:', # Translate - New (2)
    'Email:' => 'E-mail:', # Translate - New (1)
    'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Om deze gebruiker te bekijken of te bewerken, klik op deze link of plak de URL in een webbrowser:', # Translate - New (20)

    ## ./tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Aangedreven door Movable Type',
    'Version [_1]' => 'Versie [_1]',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype',

    ## ./tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => 'Een niet gekeurde reactie is binnengekomen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze reactie eerst goedkeuren voor ze op uw site verschijnt.',
    'Approve this comment:' => 'Deze reactie goedkeuren:',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe reactie is gepubliceerd op uw blog [_1], op bericht #[_2] ([_3]).',
    'View this comment' => 'Deze reactie bekijken', # Translate - New (3)
    'Report this comment as spam' => 'Deze reactie melden als spam', # Translate - New (5)
    'Edit this comment' => 'Deze reactie bewerken',
    'IP Address' => 'IP-adres',
    'Email Address' => 'E-mailadres',
    'Comments:' => 'Reacties:',

    ## ./tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]). U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'Een niet gekeurde TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).  U moet deze TrackBack eerst goedkeuren voordat hij op uw site verschijnt.',
    'Approve this TrackBack' => 'Deze TrackBack goedkeuren', # Translate - New (3)
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op bericht #[_2] ([_3]).',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => 'Een nieuwe TrackBack is ontvangen op uw weblog [_1], op categorie #[_2] ([_3]).',
    'View this TrackBack' => 'Deze TrackBack bekijken', # Translate - New (3)
    'Report this TrackBack as spam' => 'Deze TrackBack melden als spam', # Translate - New (5)
    'Edit this TrackBack' => 'Deze TrackBack bewerken',

    ## ./tmpl/email/notify-entry.tmpl
    'A new post entitled \'[_1]\' has been published to [_2].' => 'Een nieuw bericht getiteld \'[_1]\' is gepubliceerd op [_2].', # Translate - New (10)
    'View post' => 'Bericht bekijken', # Translate - New (2)
    'Post Title' => 'Titel bericht', # Translate - New (2)
    'Publish Date' => 'Publicatiedatum', # Translate - New (2)
    'Message from Sender' => 'Boodschap van de afzender', # Translate - New (3)
    'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'U ontvangt dit bericht omdat u ofwel gekozen hebt om notificaties over nieuw inhoud op [_1] te ontvangen, of de auteur van het bericht dacht dat u misschien wel geïnteresseerd zou zijn.  Als u deze berichten niet langer wenst te ontvangen, gelieve deze persoon te contacteren:', # Translate - New (43)

    ## ./tmpl/email/recover-password.tmpl

    ## ./tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Bedankt om u in te schrijven voor notificaties over updates van [_1].  Volg onderstaande link om uw inschrijving te bevestigen:',
    'If the link is not clickable, just copy and paste it into your browser.' => 'Indien de link niet klikbaar is, kopiëer en plak hem dan gewoon in uw browser.',

    ## ./tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Movable Type activiteitlog',
    'Movable Type System Activity' => 'Movable Type systeemactiviteit',

    ## ./tmpl/feeds/feed_chrome.tmpl

    ## ./tmpl/feeds/feed_comment.tmpl
    'system' => 'systeem',
    'Published' => 'Gepubliceerd',
    'Unpublished' => 'Ongepubliceerd',
    'Blog' => 'Blog', # Translate - Previous (1)
    'Entry' => 'Bericht',
    'Untitled' => 'Zonder titel',
    'Commenter' => 'Bezoeker',
    'Actions' => 'Acties',
    'Edit' => 'Bewerken',
    'Unpublish' => 'Publicatie ongedaan maken',
    'Publish' => 'Publiceren',
    'Junk' => 'Spam',
    'More like this' => 'Meer zoals dit',
    'From this blog' => 'Van deze blog',
    'On this entry' => 'Op dit bericht',
    'By commenter identity' => 'Volgens identiteit reageerders',
    'By commenter name' => 'Volgens naam reageerders',
    'By commenter email' => 'Volgens e-mail reageerders',
    'By commenter URL' => 'Volgens URL reageerders',
    'On this day' => 'Op deze dag',

    ## ./tmpl/feeds/feed_entry.tmpl
    'Author' => 'Auteur',
    'From this author' => 'Van deze auteur',

    ## ./tmpl/feeds/feed_ping.tmpl
    'Source blog' => 'Bronblog',
    'By source blog' => 'Volgens bronblog',
    'By source title' => 'Volgens titel bron',
    'By source URL' => 'Volgens URL bron',

    ## ./tmpl/feeds/feed_system.tmpl

    ## ./tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'Deze link is niet geldig. Gelieve opnieuw in te schrijven op uw activiteitenfeed.',

    ## ./tmpl/wizard/blog.tmpl

    ## ./tmpl/wizard/cfg_dir.tmpl

    ## ./tmpl/wizard/complete.tmpl

    ## ./tmpl/wizard/configure.tmpl

    ## ./tmpl/wizard/mt-config.tmpl

    ## ./tmpl/wizard/optional.tmpl

    ## ./tmpl/wizard/packages.tmpl

    ## ./tmpl/wizard/start.tmpl

    ## ./tmpl/wizard/include/copyright.tmpl

    ## ./tmpl/wizard/include/footer.tmpl

    ## ./tmpl/wizard/include/header.tmpl

    ## Other phrases, with English translations.
    'Bad ObjectDriver config' => 'Fout in ObjectDriver configuratie',
    'Two plugins are in conflict' => 'Twee plugins zijn in conflict',
    'RSS 1.0 Index' => 'RSS 1.0 index',
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => 'Reactie \'[_1]\' (#[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) op bericht \'[_5]\' (bericht #[_6])',
    'Create Entries' => 'Berichten aanmaken',
    'Remove Tags...' => 'Tags verwijderen',
    '_BLOG_CONFIG_MODE_BASIC' => 'Basismodus',
    'No weblog was selected to clone.' => 'Er werd geen weblog geselecteerd om te klonen.',
    'Username or password recovery phrase is incorrect.' => 'Woord of uitdrukking om wachtwoord terug te vinden is niet correct.',
    'Comment Pending Message' => 'Boodschap hangende reactie',
    '_NO_SUPERUSER_DISABLE' => '_NO_SUPERUSER_DISABLE', # Translate - Previous (4)
    'YEARLY_ADV' => 'jaarlijks', # Translate - New (2)
    'Invalid attempt to recover password (used recovery phrase \'[_1]\')' => 'Ongeldige poging om een wachtwoord terug te vinden (gebruikte uitdrukking \'[_1]\')',
    'Updating blog old archive link status...' => 'Status van oude archieflinks van blog wordt bijgewerkt...',
    'Movable Type Enterprise has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => 'Movable Type Enterprise probeerde net uw account uit te schakelen tijdens synchronisatie met de externe directory.  Er moet een fout zitten in de instellingen voor extern gebruikersbeheer.  Gelieve uw configuratie bij te stellen voor u verder gaat.',
    'Showing' => 'Getoond',
    '_USAGE_COMMENT' => 'Bewerk het geselecteerde document. Druk op OPSLAAN zodra u klaar bent. U moet opnieuw opbouwen om deze veranderingen van kracht te maken.',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'Geen woord of uitdrukking ingesteld om het wachtwoord terug te vinden.  Contacteer uw systeembeheerder om uw wachtwoord terug te vinden.',
    'Database Path' => 'Databasepad',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen om al zijn permissies te verwijderen als alternatief.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'Er deed zich een fout voor bij het verwerken van [_1]. Kijk <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">hier</a> voor meer details en probeer eventueel opnieuw.',
    'Created template \'[_1]\'.' => 'Sjabloon \'[_1]\' aangemaakt.',
    'View image' => 'Afbeelding bekijken',
    'Date-Based Archive' => 'Archief gebaseerd op datum',
    'Enable External User Management' => 'Extern gebruikersbeheer inschakelen',
    'Assigning visible status for comments...' => 'Status zichtbaarheid van reacties wordt toegekend...',
    'Step 4 of 4' => 'Stap 4 van 4',
    'Designer' => 'Ontwerper',
    'Create a feed widget' => 'Maak een feed-widget aan',
    'Enter the ID of the weblog you wish to use as the source for new personal weblogs. The new weblog will be identical to the source except for the name, publishing paths and permissions.' => 'Geef het ID op van de weblog die u wenst te gebruiken als bron voor nieuwe persoonlijke weblogs.  De nieuwe weblog zal identiek zijn aan de bron, buiten de naam, publicatiepaden en permissies.',
    'Bad CGIPath config' => 'Fout in CGIPath configuratie',
    'Weblog Administrator' => 'Weblogbeheerder',
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'Indien aanwezig moet het derde argument van add_callback een object van het type MT::Plugin zijn',
    '_USAGE_GROUPS_USER' => 'Hieronder vindt u een lijst met alle groepen waarvan de gebruiker lid is.  U kunt de gebruiker uit een groep verwijderen door het vakje naast de groep aan te kruisen en op VERWIJDEREN te klikken.',
    '_WARNING_PASSWORD_RESET_MULTI' => 'U staat op het punt het wachtwoord opnieuw in te stellen voor de geselecteerde gebruikers.  Nieuwe wachtwoorden zullen willekeurig worden gegenereerd en rechtstreeks naar hun e-mail adres worden verzonden.\n\nWenst u verder te gaan?',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'U moet een dynamisch sjabloon voor de lijst met reacties instellen om reacties dynamisch te kunnen tonen.',
    'Assigning blog administration permissions...' => 'Blog administrator permissies worden toegekend...',
    'Invalid LDAPAuthURL scheme: [_1].' => 'Ongeldig LDAPAuthURL schema: [_1].',
    'Can edit all entries/categories/tags on a weblog and rebuild.' => 'Mag alle berichten/categorieën/tags op een weblog bewerken en opnieuw opbouwen.',
    'Category Archive' => 'Archief per categorie',
    'Monitor' => 'Monitor', # Translate - Previous (1)
    'Updating user permissions for editing tags...' => 'Gebruikerspermissies voor het bewerken van tags worden bijgewerkt...',
    '_USAGE_EXPORT_1' => 'Het exporteren van uw berichten vanuit Movable Type maakt het mogelijk om <b>persoonlijke back-ups</b> van uw blogberichten te bewaren. Het formaat van de geëxporteerde gegevens is geschikt om weer in het systeem geïmporteerd te worden m.b.v. de importfunctie (hierboven); dus kunt u, behalve het exporteren van uw berichten voor backup-doeleinden, deze functie ook gebruiken om <b>de inhoud te verplaatsen naar verschillende blogs</b>.',
    'Setting default blog file extension...' => 'Standaard blogbestand extensie wordt ingesteld...',
    'Migrating permissions to roles...' => 'Permissies aan het migreren naar rollen...',
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is de vorige categorie.',
    'Name:' => 'Naam:',
    'Atom Index' => 'Atom index',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' aangemaakt door \'[_2]\' (gebruiker #[_3])',
    'Invalid priority level [_1] at add_callback' => 'Ongeldig prioriteitsniveau [_1] in add_callback',
    'Add Tags...' => 'Tags toevoegen',
    '_THROTTLED_COMMENT_EMAIL' => 'Een bezoeker van uw weblog [_1] is automatisch uitgesloten omdat dez meer dan het toegestane aantal reacties heeft gepubliceerd in de laatste [_2] seconden. Dit wordt gedaan om te voorkomen dat kwaadwillige scripts uw weblog met reacties overstelpen. Het uitgesloten IP-adres is

    [_3]

Als dit een fout was, kunt u het IP-adres ontgrendelen en de bezoeker toestaan opnieuw te publiceren door u aan te melden bij uw Movable Type-installatie, naar Weblogconfiguratie - IP uitsluiten te gaan en het IP-adres [_4] te verwijderen uit de lijst van uitgesloten adressen.',
    'Permission denied for non-superuser' => 'Toestemming geweigerd aan niet-superuser',
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Ping \'[_1]\' (ping #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Categorie \'[_1]\' (categorie #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    'MONTHLY_ADV' => 'Maandelijks',
    '_USER_ENABLED' => 'Ingeschakeld',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Het versturen van e-mail via SMTP vereist dat op uw server Mail::Sendmail is geïnstalleerd: [_1]',
    'Manage Tags' => 'Tags beheren',
    'Taxonomist' => 'Klasseerder',
    '_USAGE_BOOKMARKLET_3' => 'Als u het Movable Type QuickPost-bookmark wilt installeren, sleept u de volgende link naar de werkbalk Favorieten in het menu van uw browser.',
    'Are you sure you want to delete the selected group(s)?' => 'Bent u zeker dat u de geselecteerde groep(en) wenst te verwijderen?',
    'Assigning user status...' => 'Gebruikersstatus wordt toegekend...',
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) ontnam het vertrouwen aan reageerder \'[_3]\' (#[_4]).',
    'Create New User Association' => 'Nieuwe gebruikersassociatie aanmaken',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Bestand met de naam \'[_1]\' bestaat al. (Installeer File::Temp als u bestaande bestanden wenst te kunnen overschrijven.)',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Categorie \'[_1]\' aangemaakt door \'[_2]\' (gebruiker #[_3])',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.' => 'DBI en DBD::SQLite2 zijn vereist als u het SQLite2 database backend wenst te gebruiken.',
    'Are you sure you want to delete the [_1] selected [_2]?' => 'Bent u zeker dat u de [_1] geselecteerde [_2] wenst te verwijderen?',
    '_USAGE_GROUPS_LDAP' => 'Hieronder vindt u een lijst van alle groepen in het Movable Type systeem.  U kunt een groep in- of uitschakelen door het vakje naast de naam aan te kruisen en dan op de knop \'Inschakelen\' of \'Uitschakelen\' te klikken.',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'Nieuwe TrackBack op bericht #[_1] \'[_2]\'.',
    'An error occured during synchronization: [_1]' => 'Er deed zich een fout voor bij synchronisatie: [_1]',
    '4th argument to add_callback must be a CODE reference.' => '4th argument van add_callback moet een CODE referentie zijn.',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Of keer terug naar het <a href="[_1]">Hoofdmenu</a> of het <a href="[_2]">Systeemoverzicht</a>.',
    'Can create entries and edit their own.' => 'Mag berichten aanmaken en eigen berichten bewerken.',
    'Monthly' => 'maandelijkse',
    'Editor' => 'Redacteur',
    'Refreshing template \'[_1]\'.' => 'Sjabloon \'[_1]\' wordt ververst.',
    'Ban Commenter(s)' => 'Reageerder(s) verbannen',
    'Created <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Aangemaakt <MTIfNonEmpty tag="EntryAuthorDisplayName">door [_1] </MTIfNonEmpty>op [_2]', # Translate - New (9)
    'Installation instructions.' => 'Installatie-instructies.',
    'Secretary' => 'Secretaris/secretaresse',
    '_USAGE_ARCHIVING_3' => 'Selecteer het archiveringstype waaraan u een nieuw archiefsjabloon wilt toevoegen. Selecteer vervolgens de sjabloon die u aan het betreffende archiveringstype wilt koppelen.',
    'Hello, world' => 'Hello, world', # Translate - Previous (2)
    'You need to create some users.' => 'U moet een aantal gebruikers aanmaken.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Sjabloon \'[_1]\' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Bovenstaande instellingen zijn weggeschreven naar het bestand <tt>[_1]</tt>.  Als één van deze instellingen niet correct is, kunt u op de knop \'Terug\' klikken om ze opnieuw in te stellen.',
    '_USER_DISABLE' => 'Uitschakelen',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een reactie; misschien plaatste u die tag per ongeluik buiten een \'MTComments\' container?',
    '_ERROR_CGI_PATH' => 'Uw CGIPath configuratieinstelling is ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Gelieve het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding te raadplegen voor meer informatie.',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Onvoldoende permissies om de sjabonen te bewerken van weblog \'[_1]\'',
    'Assigning template build dynamic settings...' => 'Instellingen voor dynamische sjabloonopbouw worden toegewezen...',
    '_USAGE_CATEGORIES' => 'Gebruik categorieën om uw berichten te groeperen zodat u er makkelijker naar kunt verwijzen, ze eenvoudiger kunt archiveren en blogs beter kunt weergeven.  U kunt een categorie toewijzen aan een bepaald bericht tijdens het aanmaken of bewerken van berichten. Als u een bestaande categorie wilt bewerken, klikt u op de titel van de categorie. Als u een subcategorie wilt aanmaken, klikt u op de desbetreffende knop "Aanmaken." Als u een subcategorie wilt verplaatsen, klikt u op de desbetreffende knop "Verplaatsen."',
    '_USAGE_AUTHORS_2' => 'U kunt gebruikers registreren, bewerken of verwijderen met een CSV-geformatteerd bestand met commando\'s.',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) gaf het vertrouwen aan reageerder \'[_3]\' (#[_4]).',
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Tags \'[_1]\' (tags #[_2]) verwijdered door \'[_3]\' (gebruiker #[_4])',
    'URL:' => 'URL:', # Translate - Previous (1)
    'Template \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Sjabloon \'[_1]\' aangemaakt door \'[_2]\' (gebruiker #[_3])',
    'Weekly' => 'wekelijkse',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'Nieuwe TrackBack voor categorie #[_1] \'[_2]\'.',
    'No pages were found containing "[_1]".' => 'Er werden geen pagina\'s gevonden met "[_1]" er in.',
    '. Now you can comment.' => '. Nu kunt u reageren.',
    'Unpublish TrackBack(s)' => 'Publicatie ongedaan maken',
    'You need to provide a password if you are going to\ncreate new users for each user listed in your blog.\n' => 'U moet een wachtwoord opgeven als u\nnieuwe gebruikers gaat aanmaken voor elke gebruiker die in uw weblog voorkomt.\n',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => 'Weblog \'[_1]\' verwijderd door \'[_2]\' (gebruiker #[_3])',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'Het fysieke bestandspad naar uw BerkeleyDB of SQLite database. ',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Er kunnen er nog veel meer gevonden worden op de <a href="[_1]">hoofdindexpagina</a> of door te kijken in de <a href="[_2]">de archieven</a>.',
    '_USAGE_PREFS' => 'Dit scherm biedt u de mogelijkheid om verschillende opties in te stellen met betrekking tot uw blog, uw archieven, uw reacties en uw publiciteits en notificatie-instellingen. Bij het aanmaken van een nieuwe blog zijn deze instellingen op redelijke standaardwaarden ingesteld.',
    'This page contains an archive of all entries published to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'Deze pagina bevat een archief met alle berichten gepubliceerd op [_1] in de categorie <strong>[_2]</strong>.  Ze zijn gerangschikt van oud naar nieuw.', # Translate - New (24)
    'WEEKLY_ADV' => 'Wekelijks',
    'Other...' => 'Andere...',
    'If you have a TypeKey identity, you can ' => 'Als u een TypeKey identiteit heeft, kunt u ',
    'Can create entries, edit their own and upload files.' => 'Mag berichten aanmaken, de eigen berichten bewerken en bestanden opladen.',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Gelieve de parameters in te geven die nodig zijn om verbinding te maken met uw database.  Als uw databasetype niet in onderstaande lijst staat, kan het zijn dat u de Perl module mist die nodig is om verbinding te maken met uw database.  Indien dit het gavel is, gelieve dan uw installatie na te kijken en klik <a href="?__mode=configure">hier</a> om uw installatie opnieuw te testen.',
    '_USAGE_ARCHIVING_2' => 'Als u meerdere sjablonen koppelt aan een bepaald archieftype - of zelfs als u er slechts een koppelt - dan kunt u het uitvoerpad aanpassen voor de archiefbestanden met behulp van Sjablonen archiefbestanden.',
    'User \'[_1]\' created by \'[_2]\' (user #[_3])' => 'Gebruiker \'[_1]\' aangemaakt door \'[_2]\' (gebruiker #[_3])',
    'Refresh Template(s)' => 'Sjablo(o)n(en) verversen',
    'Password was reset for user \'[_1]\' (ID:[_2]) and sent to address: [_3]' => 'Wachtwoord opnieuw ingesteld voor gebruiker \'[_1]\' (ID:[_2]) en naar dit adres gestuurd: [_3]',
    'Assigning basename for categories...' => 'Basisnaam voor categorieën wordt toegekend...',
    '_USAGE_NOTIFICATIONS' => 'Hieronder staat een lijst met personen die op de hoogte willen worden wanneer u iets publiceert op uw site. Als u een nieuwe gebruiker wilt toevoegen, voer dan het e-mailadres in het formulier hieronder in. Het URL-veld is optioneel. Als u een gebruiker wilt verwijderen, kruis dan het vak \'Verwijderen\' aan in de tabel hieronder en druk vervolgens op de knop \'Verwijderen\'.',
    'Future' => 'Toekomst',
    'Editor (can upload)' => 'Redacteur (mag opladen)',
    '_ERROR_DATABASE_CONNECTION' => 'Uw database instellingen zijn ofwel ongeldig ofwel niet aanwezig in uw Movable Type configuratiebestand. Bekijk het deel <a href="#">Installation and Configuration</a> van de Movable Type handleiding voor meer informatie.',
    '_USAGE_BANLIST' => 'Hieronder is de lijst met IP-adressen die u hebt uitgesloten van de publicatie van reacties op uw site of het versturen van TrackBack-pings naar uw site. Als u een nieuw IP-adres wilt toevoegen, voer dan het adres in het formulier hieronder in. Als u een uitgesloten IP-adres wilt verwijderen, kruis dan het vak \'Verwijderen\' aan in de tabel hieronder en druk vervolgens op de knop \'Verwijderen\'.',
    'RSS 2.0 Index' => 'RSS 2.0 index',
    'Select a Design using StyleCatcher' => 'Selecteer een design met StyleCatcher',
    'New comment for entry #[_1] \'[_2]\'.' => 'Nieuwe reactie op bericht #[_1] \'[_2]\'.',
    '_USER_DISABLED' => 'Uitgeschakeld',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is het vorige archief.',
    '_USAGE_NEW_AUTHOR' => 'In dit scherm kunt u een nieuwe gebruiker aanmaken en hem toegang geven tot bepaalde weblogs in het systeem.',
    'Manage my Widgets' => 'Mijn widgets beheren',
    'Weblog Associations' => 'Weblogassociaties',
    'Updating blog comment email requirements...' => 'Vereisten voor e-mail bij reacties op de weblog worden bijgewerkt...',
    'Publish Entries' => 'Berichten publiceren',
    'The following groups were deleted' => 'Volgende groepen werden verwijderd',
    'Finished! You can <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configure the Site root and URL of the new weblog</a>.' => 'Klaar!  U kunt nu <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_1]\');\">terugkeren naar het overzicht van de weblogs</a> of <a href=\"javascript:void(0);\" onclick="closeDialog(\'[_2]\');\">configureer de Site root en URL van de nieuwe weblog</a>.',
    'You cannot disable yourself' => 'U kunt uzelf niet uitschakelen',
    '_USER_STATUS_CAPTION' => 'status',
    'You are not allowed to edit the permissions of this user.' => 'U mag de permissies van deze gebruiker niet bewerken.',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Opmerking:</strong> Het Movable Type exportformaat is niet allesomvattend en is niet geschikt om volledige back-ups mee nemen. Zie de Movable Type handleiding voor alle details.</em>',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<$MTCategoryTrackbackLink$> moet gebruikt worden in de context van een categorie, of met het \'category\' attribuut van de tag.',
    '_USAGE_PLUGINS' => 'Dit is een lijst van alle plugins die momenteel in Movable Type geregistreerd zijn.',
    'Tagger' => 'Tagger', # Translate - Previous (1)
    'Publisher' => 'Uitgever',
    'Manager' => 'Manager', # Translate - Previous (1)
    '_GENL_USAGE_PROFILE' => 'Bewerk hier het profiel van de gebruiker.  Als u de gebruikersnaam of het wachtwoord van de gebruiker aanpast, dan zullen de credentials van de gebruiker automatisch bijgewerkt worden.  Met andere woorden, hij/zij zal zich niet opnieuw moeten aanmelden.',
    '(None)' => '(Geen)',
    'Frequency of synchronization in minutes. (Default is 60 minutes)' => 'Synchronisatiefrequentie in minuten. (Standaard is 60 minuten)',
    '_USAGE_PERMISSIONS_2' => 'Als u permissies voor een andere gebruiker wilt bewerken, selecteert u een nieuwe gebruiker uit het uitklapmenu en klikt u op \'Bewerken\'.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Onvoldoende permissies voor het bewerken van de sjablonen van deze weblog.',
    'Bad ObjectDriver config: [_1] ' => 'Fout in ObjectDriver configuratie: [_1] ',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'Geen e-mail opgegeven in gebruikersprofiel.  Gelieve uw systeembeheerder te contacteren om uw wachtwoord terug te vinden.',
    'Untrust Commenter(s)' => 'Reageerder(s) niet meer vertrouwen',
    'Hello, [_1]' => 'Hallo, [_1]',
    'Can edit, manage and rebuild weblog templates.' => 'Mag weblogsjablonen bewerken, beheren en opnieuw opbouwen.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'Om meer plugins te downloaden, moet u een kijkje nemen in de <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Assigning custom dynamic template settings...' => 'Aangepaste instellingen voor dynamische sjablonen worden toegewezen...',
    'Updating comment status flags...' => 'Statusvelden van reacties worden bijgewerkt...',
    'Updating user web services passwords...' => 'Web service wachtwoorden van de gebruiker worden bijgewerkt...',
    'Stylesheet' => 'Stylesheet', # Translate - Previous (1)
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een ping;  mogelijk plaatste u die per ongeluk buiten een \'MTPings\' container?',
    '_THROTTLED_COMMENT' => 'In een poging om de publicatie van kwaadaardige reacties door beledigende gebruikers tegen te gaan, heb ik een functie ingeschakeld die vereist dat degene die weblogreacties verstuurt even wacht alvorens weer een publicatie te kunnen sturen. Probeer uw reactie na korte tijd nogmaals te publiceren. Hartelijk dank voor uw geduld.',
    'Are you sure you want to delete the selected user(s)?' => 'Bent u zeker dat u de geselecteerde gebruiker(s) wenst te verwijderen?',
    '_USAGE_SEARCH' => 'U kunt \'zoeken en vervangen\' gebruiken om al uw berichten te doorzoeken of om alle gevallen waar een bepaald woord/zin/teken voorkomt te vervangen door iets anders. BELANGRIJK: wees voorzichtig bij het uitvoeren van een vervanging, omdat <b>ongedaan maken</b> niet mogelijk is. Als u vervangingen aanbrengt in een groot aantal berichten, dan is het wellicht veilig om eerst de functie \'Import/Export\' te gebruiken om een veiligheidskopie van uw berichten te maken.',
    'Your profile has been updated.' => 'Uw profiel werd bijgewerkt.',
    'Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template \'[_3]\'.' => 'Bezig \'[_3]\ te verversen (met <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>).',
    'Can\'t enable/disable that way' => 'Kan niet in/uitschakelen op die manier',
    '_external_link_target' => '_extern_link_doel',
    '_AUTO' => '1',
    'Password recovery for user \'[_1]\' failed due to lack of recovery phrase specified in profile.' => 'Wachtwoordt terugvinden voor gebruiker \'[_1]\' mislukt wegens geen woord of uitdrukking om het wachtwoord terug te vinden opgegeven in het gebruikersprofiel.',
    'Setting new entry defaults for weblogs...' => 'Standaardwaarden voor nieuwe berichten worden ingesteld...',
    'Writer (can upload)' => 'Schrijver (mag opladen)',
    'Updating entry week numbers...' => 'Weeknummers van berichten worden bijgewerkt...',
    'The previous entry in this blog was <a href="[_1]">[_2]</a>.' => 'Het vorige bericht op deze blog was <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_POWERED_BY' => 'Aangedreven door<br /><a href="http://www.movabletype.org/sitenl/"><$MTProductName$></a>',
    'Assigning comment/moderation settings...' => 'Instellingen voor reacties/moderatie worden toegewezen...',
    'You can not add users to a disabled group.' => 'U kan geen gebruikers toevoegen aan een uitgeschakelde groep.',
    'Communications Manager' => 'Communicatiemanager',
    'Clone Weblog' => 'Weblog klonen',
    '_USAGE_ARCHIVING_1' => 'Selecteer aantal/soorten archivering die u op uw site wenst te hebben. Voor elk archiveringstype dat u kiest, kunt u meerdere archiefsjablonen toewijzen die u op dat bepaalde type wilt toepassen Stel dat u  twee verschillende weergaven wilt aanmaken van uw maandelijkse archieven: een pagina met alle berichten voor een bepaalde maand en de andere met een kalenderoverzicht voor die maand.',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => 'Applicatielog voor blog \'[_1]\' leeggemaakt door \'[_2]\' (gebruiker #[_3])',
    'Finished! You can <a href=\'[_1]\'>return to the weblogs listing</a> or <a href=\'[_2]\'>view the new weblog</a>.' => 'Klaar! U kunt nu <a href=\'[_1]\'>terugkeren naar het overzicht van de weblogs</a> of <a href=\'[_2]\'>de nieuwe weblog bekijken</a>.',
    'Permission denied' => 'Permissie geweigerd',
    '_USAGE_AUTHORS_1' => '
    Dit is een lijst met alle gebruikers in het Movable Type systeem. 
    This is a list of all of the users in the Movable Type system. You can edit an author\'s permissions by clicking on his/her name. You can permanently delete users by checking the checkbox next to their name, then pressing DELETE. NOTE: if you only want to remove a user from a particular blog, edit the author\'s permissions to remove the author; deleting a user using DELETE will remove the user from the system entirely. You can create, edit and delete user records by using CSV-based command file.',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'Fout bij het aanmaken van een tijdelijk bestand; gelieve uw instellingen voor TempDir in mt.cfg na te kijken (momenteel \'[_1]\'), deze locatie moet beschrijfbaar zijn.',
    'View This Weblog\'s Activity Log' => 'Activiteitlog van deze weblog bekijken',
    '_USAGE_IMPORT' => 'Gebruik de importfunctie om berichten te importeren uit een ander weblog content-management systeem (bijvoorbeeld Blogger of Greymatter). De handleiding bevat uitgebreide instructies over het importeren van oudere berichten via deze weg; met het formulier hieronder kunt u een verzameling berichten importeren nadat u ze hebt geëxporteerd uit het andere CMS en de geëxporteerde bestanden op de juiste plaats hebt gezet, zodat Movable Type ze kan vinden. Raadpleeg de handleiding voordat u dit formulier gebruikt, zodat u er zeker van bent dat u alle opties begrijpt.',
    'IP Address:' => 'IP-adres:',
    'Main Index' => 'Hoofdindex',
    'No new status given' => 'Geen nieuwe status opgegeven',
    'Invalid login attempt from user \'[_1]\' (ID: [_2])' => 'Ongeldige poging tot aanmelden van gebruiker \'[_1]\' (ID: [_2])',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>U moet een globale opslaglocatie instellen waar designs plaatselijk opgeslagen kunnen worden.  Als een bepaalde weblog niet geconfigureerd is om z\'n eigen paden te gebruiken voor designs, zullen deze instellingen rechtstreeks gebruikt worden.  Als een blog wel eigen paden heeft voor designs, zal het design naar die locatie worden gecopiëerd wanneer het wordt toegepast op die weblog.  De paden die hier ingesteld worden moet fysiek bestaan en beschrijfbaar zijn voor de webserver.</p>',
    'You did not select any [_1] to delete.' => 'U selecteerde geen [_1] om te verwijderen.',
    '_USAGE_EXPORT_3' => 'Door te klikken op de link hieronder worden al uw huidige weblog-berichten naar de Tangent-server geëxporteerd. Dit is normaliter een eenmalige push van uw berichten, die u moet uitvoeren nadat u de extra\'s voor Tangent hebt geïnstalleerd voor Movable Type, maar het mogelijk om dit te doen wanneer u dit wilt.',
    'Application log reset by \'[_1]\' (user #[_2])' => 'Applicatielog leeggemaakt door \'[_1]\' (gebruiker #[_2])',
    'Assigning spam status for TrackBacks...' => 'Spam-status wordt toegekend aan TrackBacks...', # Translate - New (5)
    'A default location of \'./db\' will store the database file(s) underneath your Movable Type directory.' => 'De standaardlocatie \'./db\' zal het database bestand opslaan onder uw Movable Type map.',
    'Delete selected users (x)' => 'Geselecteerde gebruikers verwijderen (x)',
    'User \'[_1]\' (user #[_2]) logged out' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) afgemeld',
    'Edit Role' => 'Rol bewerken',
    '_BLOG_CONFIG_MODE_DETAIL' => 'Gedetailleerde modus',
    'Some ([_1]) of the selected user(s) could not be updated.' => 'Enkele ([_1]) van de geselecteerde gebruikers konden niet worden bijgewerkt.',
    'Updating category placements...' => 'Categorieplaatsingen worden bijgewerkt...',
    '_USAGE_BOOKMARKLET_4' => 'Na het installeren van QuickPost, kunt u publiceren vanaf elke locatie op het web. Als u een pagina bekijkt waarover u een bericht wilt schrijven, klikt u op \'QuickPost\' in uw werkbalk \'Favorieten\' om een pop-upvenster te openen met een speciaal Movable Type-bewerkingsvenster. In dit venster kunt u een weblog selecteren waar u het bericht op wilt publiceren en vervolgens uw bericht invoeren en publiceren.',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Notificatie \'[_1]\' (#[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    'DAILY_ADV' => 'Dagelijks',
    'Communicator' => 'Communicator', # Translate - Previous (1)
    '_USAGE_PERMISSIONS_3' => 'U kunt op twee manieren gebruikers bewerken en toegangsprivileges toestaan/weigeren. Selecteer voor snelle toegang een gebruiker uit het menu hieronder en selecteer \'Bewerken\'. Als alternatief kunt u door de volledige lijst met gebruikers bladeren en van daaruit een persoon selecteren die u wilt bewerken of verwijderen.',
    'Found' => 'Gevonden',
    '_NOTIFY_REQUIRE_CONFIRMATION' => 'Er is een e-mail verstuurd naar [_1].  Om uw inschrijving te vervolledigen, 
    gelieve de link te volgen die in die e-mail staat.  Dit om te bevestigen dat
    het opgegeven e-mail adres correct is en aan u toebehoort.',
    'Tags to remove from selected entries' => 'Tags te verwijderen van geselecteerde berichten',
    'Manage Notification List' => 'Notificatielijst beheren',
    'Individual' => 'individuele',
    'Last Entry' => 'Laatste bericht',
    'An error occurred while testing for the new tag name.' => 'Er deed zich een fout voor bij het testen op de nieuwe tagnaam.',
    'Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a group.' => 'Voor u dit kunt doen, moet u eerst een groep aanmaken. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Klik hier</a> om een groep aan te maken.',
    'Your changes to [_1]\'s profile has been updated.' => 'Uw wijzigingen aan het profiel van [_1] zijn bijgewerkt.',
    '_USAGE_FORGOT_PASSWORD_2' => 'Met dit nieuwe wachtwoord moet u zich op Movable Type kunnen aanmelden. Zodra u zich hebt aangemeld, kunt u uw wachtwoord veranderen in iets dat u goed kunt onthouden.',
    'Authored On' => 'Geschreven op',
    '_SEARCH_SIDEBAR' => 'Zoeken',
    'Unban Commenter(s)' => 'Verbanning opheffen',
    'Individual Entry Archive' => 'Archief voor individuele berichten',
    'Daily' => 'dagelijkse',
    'This page contains all entries published to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'Deze pagina bevat alle berichten gepubliceerd op [_1] in <strong>[_2]</strong>. Ze zijn gerangschikt van oud naar nieuw.', # Translate - New (19)
    'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'Laat toe om de MTMultiBlog tag te gebruiken zonder dat er een include_blogs/exclude_blogs attribuut nodig is. De enige toegelaten waarden zijn Blog-ID\'s gescheiden door komma\'s of \'all\' (enkel met include_blogs).',
    'Unpublish Entries' => 'Publicatie ongedaan maken',
    'Setting blog basename limits...' => 'Basisnaamlimieten blog worden ingesteld...',
    'Powered by [_1]' => 'Aangedreven door [_1]',
    'Commenter Feed (Disabled)' => 'Reageerder feed (Uitgeschakeld)',
    'Personal weblog clone source ID' => 'ID kloonbron persoonlijke weblog',
    '_USAGE_UPLOAD' => 'U kunt het bestand hierboven opladen naar het lokale pad van uw site <a href="javascript:alert(\'[_1]\')">(?)</a> of het lokale archiefpad <a href="javascript:alert(\'[_2]\')">(?)</a>. U kunt ook het bestand opladen in elke directory onder deze directories, door het pad op te geven in de tekstvakken rechts (<i>afbeeldingen</i>, bijvoorbeeld). Als de directory niet bestaat, wordt deze aangemaakt.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is het volgende archief.',
    'Updating commenter records...' => 'Info over reageerders wordt bijgewerkt...',
    'Now you can comment.' => 'Nu kunt u reageren.',
    'Deleting a user is an irrevocable action which creates orphans of the author\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is th e recommended course of action.  Are you sure you want to delete the [_1] selected users?' => 'Een gebruiker verwijderen is een niet-omkeerbare actie die alle berichten van de auteur tot wees maakt.  Als u een gebruiker wenst weg te halen of toegang te ontzeggen tot het systeem, is het beter om de permissies van de gebruiker te verwijderen.  Bent u zeker dat u de [_1] geselecteerde gebruiker wenst te verwijderen?',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">OPNIEUW OPBOUWEN</a> om de wijzigingen weer te geven op uw publieke site.',
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Sjabloon \'[_3]\' wordt ververst (met <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>).',
    'Invalid blog_id' => 'Ongeldig blog_id',
    'CATEGORY_ADV' => 'Categorie',
    'Blog Administrator' => 'Blogadministrator',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Ontbrekend configuratiebestand.  Misschien vergat u mt-config.cgi-original te hernoemen naar mt-config.cgi?',
    'Dynamic Site Bootstrapper' => 'Voorbeeld dynamische site',
    'You need to create some roles.' => 'U moet een aantal rollen aanmaken.',
    'Assigning entry basenames for old entries...' => 'Basisnamen voor oude berichten worden toegekend...',
    'Invalid author' => 'Ongeldige auteur',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Fout bij verzenden van e-mail ([_1]);  gelieve het probleem op te lossen en probeer dan opnieuw om uw wachtwoord terug te vinden.',
    'Error saving entry: [_1]' => 'Fout bij opslaan bericht: [_1]',
    'index' => 'index', # Translate - Previous (1)
    'Invalid login attempt from user [_1]: [_2]' => 'Ongeldige aanmeldpoging van gebruiker [_1]: [_2]',
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) maakte de verbanning van reageerder \'[_3]\' (#[_4]) ongedaan.',
    'Assigning visible status for TrackBacks...' => 'Zichtbaarheidsstatus van TrackBacks wordt toegekend...',
    '_USAGE_PLACEMENTS' => 'Gebruik de velden hieronder om de secundaire categorieën te beheren waaraan dit bericht is toegewezen. De lijst aan de linkerkant bevat de categorieën waaraan dit bericht nog niet is toegewezen als primaire of secundaire categorie; de lijst aan de rechterkant bestaat uit de secundaire categorieën waaraan dit bericht is toegewezen.',
    '_USAGE_ASSOCIATIONS' => 'Op dit scherm kunt u associaties zien en er nieuwe aanmaken.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Voegt sjabloontags toe aan het systeem waarmee u gegevens kunt opzoeken van Google.  U moet deze plugin configureren met een <a href=\'http://www.google.com/apis/\'>licentiesleutel.</a>',
    'Wrong object type' => 'Verkeerd objecttype',
    'Search Template' => 'Zoeksjabloon',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'Dit kan worden opgenomen in uw gepubliceerde weblog via de <a href="[_1]">WidgetManager</a> of deze MTInclude tag',
    '_USAGE_PASSWORD_RESET' => 'Hieronder kunt u een nieuw wachtwoord laten instellen voor deze gebruiker.  Als u ervoor kiest om dit te doen, zal een willekeurig gegenereerd wachtwoord worden aangemaakt en rechtstreeks naar volgend e-mail adres worden verstuurd: [_1].',
    'Download file' => 'Bestand downloaden',
    'Error connecting to LDAP server [_1]: [_2]' => 'Fout bij verbinden met LDAP server [_1]: [_2]',
    'Edit Profile' => 'Profiel bewerken',
    'Error loading default templates.' => 'Fout bij het laden van standaardsjablonen.',
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'U heeft geen geldig pad naar sendmail op uw machine.  Misschien moet u proberen om SMTP te gebruiken?',
    'You are currently performing a search. Please wait until your search is completed.' => 'U bent momenteel al een zoekactie aan het uitvoeren.  Gelieve te wachten tot uw zoekopdracht voltooid is.',
    'An errror occurred when enabling this user.' => 'Er deed zich een fout voor bij het inschakelen van deze gebruiker.',
    '_USAGE_LIST_POWER' => 'Hier is de lijst met berichten op [_1] in batchbewerkingsmodus. In het onderstaande formulier kunt u de waarden voor alle weergegeven berichten wijzigen; druk na het maken van de gewenste aanpassingen, op de knop \'Opslaan\'. De standaard besturingelementen voor Berichten weergeven en bewerken (filters, pagineren) werken in batchmodus op de manier die u gewend bent.',
    'Below is a list of the members in the <b>[_1]</b> group. Click on a user\'s username to see the details for that user.' => 'Hieronder vindt u een lijst van de leden in de <b>[_1]</b>.  Klik op de gebruikersnaam van een gebruiker om de details van die persoon te zien.',
    '_ERROR_CONFIG_FILE' => 'Uw Movable Type configuratiebestand ontbreekt of kan niet gelezen worden. Gelieve het deel <a href="#">Installation and Configuration</a> van de handleiding van Movable Type te raadplegen voor meer informatie.',
    'This action can only be run for a single weblog at a time.' => 'Deze actie kan maar op één weblog per keer uitgevoerd worden.',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'U staat op het punt het wachtwoord voor "[_1]" opnieuw in te stellen.  Een nieuw wachtwoord zal willekeurig worden aangemaakt en zal rechtstreeks naar het e-mail adres van deze gebruiker ([_2]) worden gestuurd.\n\nWenst u verder te gaan?',
    '_USAGE_PING_LIST_BLOG' => 'Dit is de lijst van TrackBacks op [_1]  die u kunt filteren, beheren en bewerken.',
    'You must set your Database Path.' => 'U moet uw databasepad instellen.',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'Met StyleCatcher kunt u makkelijk een keuze maken tussen stijlen om ze daarna op uw blog toe te passen in een paar klikken.  Om meer te weten over Movable Type stijlen, of om een bron te vinden van nog meer stijlen, bezoek de <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> pagina.',
    'The LDAP directory ID for this group.' => 'Het LDAP directory ID voor deze groep.',
    '_USAGE_GROUPS' => 'Hieronder vindt u een lijst van alle groepen in het Movable Type systeem.  U kunt een groep in- of uitschakelen door het vakje naast de naam aan te kruisen en dan op de knop \'Inschakelen\' of \'Uitschakelen\' te klikken.',
    '_LOG_TABLE_BY' => '_LOG_TABLE_BY', # Translate - New (4)
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'Als uw importbestand zich op uw computer bevindt, kunt u het hier opladen.  In het andere geval zal Movable Type automatisch in de map <code>import</code> kijken in uw Movable Type hoofdmap.',
    'If you want to change the SitePath and SiteURL, <a href=\'[_1]\'>click here</a>.' => 'Als u de SitePath en SiteURL wenst aan te passen, <a href=\'[_1]\'>klik hier</a>.',
    'Password recovery for user \'[_1]\' failed due to lack of email specified in profile.' => 'Wachtwoord terugvinden voor gebruiker \'[_1]\' mislukt wegens ontbreken van e-mail adres in het profiel.',
    'Tags to add to selected entries' => 'Tags toe te voegen aan geselecteerde berichten',
    'Entry "[_1]" added by user "[_2]"' => 'Bericht "[_1]" toegevoegd door gebruiker "[_2]"',
    '_USAGE_VIEW_LOG' => 'Controleer voor deze fout het <a href="#" onclick="doViewLog()">Activiteitlog</a>.',
    'You are not allowed to edit the profile of this user.' => 'U heeft geen permissie om het profiel van deze gebruiker te bewerken.',
    '_BACKUP_DOWNLOAD_MESSAGE' => '_BACKUP_DOWNLOAD_MESSAGE', # Translate - New (4)
    '_USAGE_BOOKMARKLET_1' => 'Door QuickPost te installeren op uw browser kunt u berichten met één klik toevoegen aan uw weblog zonder langs de hoofdinterface van Movable Type te moeten gaan.',
    'You must define an Individual template in order to display dynamic comments.' => 'U moet een Individueel sjabloon definiëren om dynamische reacties te kunnen tonen.',
    'UTC+10' => 'UTC+10', # Translate - Previous (2)
    'INDIVIDUAL_ADV' => 'Individueel',
    'Can upload files, edit all entries/categories/tags on a weblog, rebuild and send notifications.' => 'Mag bestanden opladen, alle berichten/categorieën/tags bewerken op een weblog, herbouwen en notificaties versturen.',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => 'Bericht \'[_1]\' (entry #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    'all rows' => 'alle rijen',
    '_USAGE_GROUP_PROFILE' => 'In dit scherm kunt u het groepsprofiel bewerken.',
    'User \'[_1]\' (user #[_2]) logged in successfully' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) met succes aangemeld',
    'Error during upgrade: [_1]' => 'Fout tijdens upgrade: [_1]',
    'Master Archive Index' => 'Hoofdarchiefindex',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => 'U gebruikte een [_1] tag buiten een Dagelijkse, Wekelijkse of Maandelijkse context.',
    'Step 2 of 4' => 'Stap 2 van 4',
    'Deleting a user is an irrevocable action which creates orphans of the user\'s entries.  If you wish to retire a user or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this user?' => 'Een gebruiker verwijderen is een handeling die niet ongedaan gemaakt kan worden en die wezen maakt van alle berichten van die gebruiker.  Als u een gebruiker wenst weg te halen of de toegang wenst te ontzeggen, is het aan te raden alle permissies ervan weg te nemen.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
    'Another amount...' => 'Ander aantal...',
    'Movable type' => 'Movable Type',
    'You can not create associations for disabled groups.' => 'U kunt geen associaties maken voor uitgeschakelde groepen.',
    'Grant a new role to [_1]' => 'Ken een nieuwe rol toe aan [_1]',
    '_WARNING_DELETE_USER' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen om al zijn permissies te verwijderen als alternatief.  Bent u zeker dat u deze gebruiker wenst te verwijderen?',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; misschien plaatste u die tag per ongeluk buiten een \'MTEntries\' container?',
    'We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the \'Retry\' button.' => 'Het lukte niet om uw configuratiebestand weg te schrijven.  Indien u de permissies op uw hoofdmap wenst na te kijken om vervolgens opnieuw te proberen, klik dan op de \'Opnieuw\' knop.',
    'Create New Group Association' => 'Nieuwe groepsassociatie aanmaken',
    'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Hoewel Movable Type er misschien op draait, is het een <strong>ongetesten en niet ondersteunde omgeving</strong>.  We raden ten zeerste aan om minstens te upgraden tot Perl [_1].',
    'Unpublish Comment(s)' => 'Publicatie ongedaan maken',
    'Processing templates for weblog \'[_1]\'' => 'Sjablonen voor weblog \'[_1]\' worden verwerkt',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Dit is de lijst van alle berichten op alle weblogs die u kunt filteren, beheren en bewerken.',
    'Synchronization Frequency' => 'Synchronizatiefrequentie',
    'Can upload files, edit all entries/categories/tags on a weblog and rebuild.' => 'Mag bestanden opladen, alle berichten/categorieën/tags op een weblog bewerken en opnieuw opbouwen.',
    'No new user status given' => 'Geen nieuwe gebruikersstatus opgegeven',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Ongeldig datumformaat \'[_1]\'; dit moet \'MM/DD/JJJJ HH:MM:SS AM|PM\' zijn (AM|PM is optioneel)',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Klik en sleep de widgets die u wenst in de kolom <strong>Geïnstalleerde widgets</strong>.',
    'Manage Categories' => 'Categorieën beheren',
    'Assigning user types...' => 'Gebruikertypes worden toegewezen...',
    'Writer' => 'Schrijver',
    'Before you can do this, you need to create some roles. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a role.' => 'Voor u dit kunt doen, moet u eerst een aantal rollen aanmaken. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Klik hier</a> om een rol aan te maken.',
    'UTC+11' => 'UTC+11', # Translate - Previous (2)
    'Migrating any "tag" categories to new tags...' => 'Alle "tag" categorieën worden naar nieuwe tags gemigreerd...',
    'Before you can do this, you need to create some users. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a user.' => 'Voor u dit kunt doen, moet u eerst een aantal gebruikers aanmaken. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Klik hier</a> om een gebruiker aan te maken.',
    'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Perl module Image::Size is nodig om de breedte en hoogte van opgeladen afbeeldingen te bepalen.',
    '_BACKUP_TEMPDIR_WARNING' => '_BACKUP_TEMPDIR_WARNING', # Translate - New (4)
    'Edit Permissions' => 'Permissies bewerken',
    '_USAGE_COMMENTERS_LIST' => 'Hier is de lijst met bezoekers die reacties achterlieten op [_1].',
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Bestand met de naam \'[_1]\' bestaat al; Poging tot schrijven naar tijdelijk bestand ondernomen, openen mislukt: [_2]',
    'Updating [_1] records...' => 'Gegevens van het type [_1] worden bijgewerkt...',
    'Configure Weblog' => 'Weblog configureren',
    '_INDEX_INTRO' => '<p>Als u Movable Type aan het installeren bent, is het aan te raden om de <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">installatie-instructies</a> door te nemen en om de <a rel="nofollow" href="mt-check.cgi">Movable Type systeemcontrole</a> uit te voeren om er zeker van te zijn dat uw systeem alle nodige elementen heeft.</p>',
    '_USAGE_AUTHORS' => 'Dit is een lijst van alle gebruikers in het Movable Type systeem.  U kunt de permissies van een gebruiker bewerken door op zijn/haar naam te klikken.  U kunt een gebruiker permanent verwijderen door het vakje aan te kruisen naast de naam en vervolgens op de VERWIJDEREN knop te klikken.  OPMERKING: als u alleen maar een gebruiker wenst te verwijderen van een bepaalde weblog, bewerk dan de permissies van die gebruiker om hem te verwijderen;  een gebruiker verwijderen met de VERWIJDEREN knop zal hem verwijderen uit het hele systeem.',
    '_USAGE_FEEDBACK_PREFS' => 'In dit schem kunt u de manieren instellen waarop lezers feedback kunnen geven op uw weblog.',
    '_USAGE_FORGOT_PASSWORD_1' => 'U hebt het herstel van uw Movable Type-wachtwoord aangevraagd. Uw wachtwoord is in het systeem gewijzigd; hier is het nieuwe wachtwoord:',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Volgende modules zijn <strong>optioneel</strong>. Als deze modules niet op uw server geïnstalleerd zijn, moet u ze enkel installeren als u de functionaliteit nodig heeft die door deze modules wordt toegevoegd.',
    'No groups were found with these settings.' => 'Er werden geen groepen gevonden met deze instellingen.',
    '_USAGE_EXPORT_2' => 'Als u uw berichten wilt exporteren, klikt u op de link hieronder ("Berichten exporteren van [_1]").  Als u de geëxporteerde gegevens in een bestand wilt opslaan, kunt u de toets <code>optie</code> op de Macintosh, of de toets <code>Shift</code> op een PC indrukken terwijl u op de link klikt. Als alternatief kunt u alle gegevens selecteren en ze vervolgens in een ander document kopiëren. <a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exporteren vanuit Internet Explorer?</a>)',
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Hier is de lijst met pings op alle weblogs.',
    'Cloning categories for weblog.' => 'Bezig categorieën te klonen voor weblog.',
    'Yearly' => 'Jaarlijks', # Translate - New (1)
    'Failed login attempt with incorrect password by user \'[_1]\' (ID: [_2])' => 'Mislukte pogint tot aanmelden met verkeerd wachtwoord van gebruiker \'[_1]\' (ID: [_2])',
    'No executable code' => 'Geen uitvoerbare code',
    '_USAGE_PING_LIST_OVERVIEW' => 'Dit is de lijst van TrackBacks op alle weblogs die u kunt filteren, beheren en bewerken.',
    'AUTO DETECT' => 'AUTOMATISCH DETECTEREN',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Standaard zoekt deze zoekmachine naar alle woorden in eender welke volgorde.  Om een exacte uitdrukking te zoeken, gelieve aanhalingstekens rond uw zoekopdracht te zetten.',
    '_USAGE_GROUPS_USER_LDAP' => 'Hieronder vindt u een lijst van alle groepen waarvan de gebruiker lid is.',
    'You need to create some groups.' => 'U moet een aantal groepen aanmaken.',
    'You need to create some weblogs.' => 'U moet een aantal weblogs aanmaken.',
    'No birthplace, cannot recover password' => 'Geen geboorteplaats, kan het wachtwoord niet terugvinden',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Installeer <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    'The next entry in this blog is <a href="[_1]">[_2]</a>.' => 'Het volgende bericht in deze weblog is <a href="[_1]">[_2]</a>.', # Translate - New (12)
    '_WARNING_DELETE_USER_EUM' => 'Een gebruiker verwijderen is een actie die niet ongedaan gemaakt kan worden en die alle berichten van de gebruiker in \'wezen\' verandert.  Als u een gebruiker wenst weg te halen of zijn toegang tot het systeem wenst te blokkeren, is het aanbevolen om al zijn permissies te verwijderen als alternatief.  Bent u zeker dat u deze gebruiker(s) wenst te verwijderen?\nGebruikers die nog bestaan in de externe directory zullen zichzelf weer kunnen aanmaken.',
    '_USER_ENABLE' => 'Inschakelen',
    'Can administer the weblog.' => 'Mag de weblog beheren.',
    '_USAGE_PROFILE' => 'Bewerk hier uw gebruikersprofiel. Als u uw gebruikersnaam of wachtwoord wijzigt, worden uw aanmeldingsgegevens automatisch bijgewerkt. Met andere woorden, u hoeft zich niet opnieuw aan te melden.',
    'Category' => 'Categorie',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Gefeliciteerd! Er is een sjabloonmodule van het type Widget aangemaakt met de naam <strong>[_1]</strong> die u verder kunt <a href="[_2]">bewerken</a> om te veranderen hoe het er komt uit te zien.',
    '_USAGE_AUTHORS_LDAP' => 'Dit is een lijst met alle gebruikers in het Movable Type systeem.  U kunt de permissies van een gebruiker bewerken door op zijn/haar naam te klikken.  U kunt gebruikers uitschakelen door het vakje naast hun naam aan te kruisen en dan UITSCHAKELEN te kiezen.  Wanneer u dit doet, zal de gebruiker zich niet meer kunnen aanmelden bij Movable Type.',
    'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => 'Er deed zich een fout voor tijdens de synchronisatie.  Kijk in het <a href=\'[_1]\'>activiteitenlog</a> voor gedetailleerde informatie.',
    '_USAGE_ENTRYPREFS' => 'Deze instellingen bepalen welke opties verschijnen op de schermen waar men nieuwe en bestaande berichten kan bewerken. U kunt een voorgedefiniëerde configuratie selecteren (Eenvoudig of Alle) of uw persoonlijke voorkeuren instellen door op Aangepast te klikken en vervolgens de opties te selecteren die u wenst weer te geven.',
    '_USAGE_NEW_GROUP' => 'Op dit scherm kunt u een nieuwe groep aanmaken in het systeem.',
    'You can not add disabled users to groups.' => 'U kunt geen uitgeschakelde gebruikers toevoegen aan groepen.',
    'Are you sure you want to delete the selected user(s)?\nThey will be able to re-create themselves if selected user(s) still exist in LDAP.' => 'Bent u zeker dat u de geselecteerde gebruiker(s) wenst te verwijderen?\nAls ze nog bestaan in LDAP kunnen ze zichzelf terug aanmaken.',
    'RSD' => 'RSD', # Translate - Previous (1)
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Sjabloon \'[_1]\' (#[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'Gebruiker \'[_1]\' (#[_2]) verbande reageerder \'[_3]\' (#[_4]).',
    '_USAGE_ROLES' => 'Hieronder vindt u een lijst van alle rollen die u heeft op uw weblogs.',
    'Invalid username \'[_1]\' in password recovery attempt' => 'Ongeldige gebruikersnaam \'[_1]\' bij poging om wachtwoord terug te vinden',
    'Not Found' => 'Niet gevonden',
    'Error creating new template: ' => 'Fout bij aanmaken nieuw sjabloon: ',
    'You cannot modify your own permissions.' => 'U kunt uw eigen permissies niet veranderen.',
    '_USAGE_ARCHIVE_MAPS' => 'Deze geavanceerde optie maakt het mogelijk om eender welk archiefsjabloon aan meerdere archieftypes te koppelen.  U zou bijvoobeeld twee verschillende versies van uw maandarchief kunnen willen aanmaken: één waar de berichten van een bepaalde maand worden getoond als lijst en een andere waar de berichten in een kalenderoverzicht worden getoond.',
    'Trust Commenter(s)' => 'Reageerder(s) vertrouwen',
    'Manage Templates' => 'Sjablonen beheren',
    '_USAGE_BOOKMARKLET_2' => 'De manier waarop QuickPost van Movable Type gestructureerd is, maakt het mogelijk om de lay-out en velden van uw QuickPost-pagina aan te passen. U wilt misschien de mogelijkheid toevoegen om uittreksels toe te voegen via het . Standaard heeft een QuickPost-venster altijd een uitklapmenu met de weblogs waarop u kunt publiceren; een uitklapmenu om de publicatiestatus van het nieuwe bericht te selecteren (\'Concept\' of \'Publiceren\'); een tekstvak voor de titel van het bericht; en een tekstvak voor de tekst van het bericht.',
    '_USAGE_CATEGORY_PING_URL' => 'Dit is de URL die anderen zullen gebruiken om TrackBacks naar uw weblog te sturen.  Als u wenst dat eender wie een TrackBack naar uw weblog kan sturen indien ze een bericht hebben dat specifiek is aan deze categrie, maak deze URL dan bekend.  Als u wenst dat bekenden TrackBacks kunnen sturen, bezorg hen dan deze URL.  Om een lijst van binnengekomen TrackBacks aan uw hoofdindexsjabloon teo te voegen, kijk in de documentatie en zoek naar sjabloontags die te maken hebben met TrackBacks.',
    '_USAGE_PERMISSIONS_1' => 'U bewerkt de permissies van <b>[_1]</b>. Hieronder vindt u een lijst met blogs waar u de gebruikers van mag bewerken; voor elke blog in de lijst kunt u permissies toewijzen aan <b>[_1]</b> door de vakjes met de permissies aan te kruisen die u wilt verstrekken.',
    'List Users' => 'Lijst gebruikers',
    'Add/Manage Categories' => 'Categorieën toevoegen/beheren',
    'Creating entry category placements...' => 'Bezig berichten in categoriën te plaatsen...',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Om registratie van reacties in te schakelen, moet u een TypeKey token toevoegen in de configuratie van uw weblog of in uw gebruikersprofiel.',
    'Advanced' => 'Geavanceerd',
    'Are you sure you want to delete this [_1]?' => 'Bent u zeker dat u deze [_1] wenst te verwijderen?',
    'Third-Party Services' => 'Services van derden',
    'PAGE_ADV' => 'PAGE_ADV', # Translate - New (2)
    'Recover Password(s)' => 'Wachtwoord(en) terugvinden',
    'You can not create associations for disabled users.' => 'U kan geen associaties aanmaken voor uitgeschakelde gebruikers.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is de volgende categorie.',
    'User \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => 'Gebruiker \'[_1]\' (#[_2]) verwijderd door \'[_3]\' (gebruiker #[_4])',
    '_USAGE_PERMISSIONS_4' => 'Elke blog mag meerdere gebruikers hebben. Als u een gebruiker wilt toevoegen, voer dan de gebruikersinformatie in het formulier hieronder in. Selecteer vervolgens de blogs waarvoor de gebruiker bepaalde permissies zal krijgen. Zodra u op \'Opslaan\' drukt en de gebruiker in het systeem aanwezig is, kunt u de permissies van de gebruiker bewerken.',
    'Assigning spam status for comments...' => 'Spamstatus wordt toegekend aan reacties...', # Translate - New (5)
    '_USAGE_TAGS' => 'Gebruik tags om uw berichten te groeperen voor eenvoudigere verwijzing en weergave op uw weblog.',
    'TrackBack for category #[_1] \'[_2]\'.' => 'TrackBack voor categorie #[_1] \'[_2]\'.',
    'Before you can do this, you need to create some weblogs. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Click here</a> to create a weblog.' => 'Voor u dit kunt doen, moet u eerst een paar weblogs aanmaken. <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">Klik hier</a> om een weblog aan te maken.',
    '_USAGE_BOOKMARKLET_5' => 'Als alternatief kunt u, als u Internet Explorer onder Windows gebruikt, een \'QuickPost\'-optie installeren in het Windows-menu dat verschijnt wanneer u met de rechtermuisknop klikt in Explorer. Klik op de link hieronder en accepteer de vraag van de browser om het bestand te \'Openen\'. Vervolgens sluit en herstart u uw browser om de link toe te voegen aan het menu dat verschijnt wanneer u met de rechtermuisknop klikt in uw browser.',
    'The last system administrator cannot be deleted under ExternalUserManagement.' => 'De laatste systeembeheerder kan niet worden gewist onder ExternalUserManagement.',
    '_USER_PENDING' => '_USER_PENDING', # Translate - New (3)
    'Assigning category parent fields...' => 'Velden van hoofdcategorieën worden toegewezen...',
    'A user by that name already exists.' => 'Er bestaat al een gebruiker met die naam.',
    '_USAGE_ENTRY_LIST_BLOG' => 'Dit is de lijst van berichten op [_1] die u kunt filteren, beheren en bewerken.',
    'Movable Type ships with directory named <strong>mt-static</strong> which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type komt met een map genaamd <strong>mt-static</strong> die een aantal belangrijke bestanden bevat, zoals afbeeldingen, javascript bestanden en stylesheets.',
    'Search Results (max 10 entries)' => 'Zoekresultaten (max 10 berichten)',
    'Send Notifications' => 'Notificaties verzenden',
    'This page contains a single entry from the blog created on <strong>[_1]</strong>.' => 'Deze pagina bevat één bericht van deze weblog, aangemaakt op <strong>[_1]</strong>.', # Translate - New (14)
    'Setting blog allow pings status...' => 'Status voor toelaten van pings per blog wordt ingesteld...',
    'Step 1 of 4' => 'Stap 1 van 4',
    'Edit All Entries' => 'Alle berichten bewerken',
    'The settings below have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'Onderstaande instellingen zijn weggeschreven naar het bestand <tt>[_1]</tt>.  Als één of meer van deze instellingen niet correct zijn, klik dan op de \'Terug\' knop om ze opnieuw in te stellen.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => '
    Fout bij het toekennen van weblogadministrator rechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'. Er werd geen gepaste weblog administrator rol gevonden.',
    'Rebuild Files' => 'Bestanden opnieuw opbouwen',
    '_USAGE_ROLE_PROFILE' => 'Op dit scherm kunt u een rol en zijn permissies bepalen.',

    ## Error messages, strings in the app code.

    ## ./mt-check.cgi.pre
    'CGI is required for all Movable Type application functionality.' => 'CGI is vereist voor alle toepassingsfuncties van Movable Type.',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Template is vereist voor alle toepassingsfuncties van Movable Type.',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size is vereist voor het opladen van bestanden (om de grootte van de op te laden afbeeldingen te bepalen in vele verschillende indelingen).',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Spec is vereist voor padbewerking bij verschillende besturingssystemen.',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie is vereist voor verificatie van cookies.',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBI is vereist als u een van de SQL database drivers wenst te gebruiken.',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI en DBD::mysql zijn vereist als u de MySQL database-backend wenst te gebruiken.',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI en DBD::Pg zijn vereist als u de PostgreSQL database-backend wenst te gebruiken.',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI en DBD::SQLite zijn vereist als u de SQLite database-backend wenst te gebruiken.', # Translate - New (15)
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI en DBD::SQLite2 zijn vereist als u de SQLite 2.x database-backend wenst te gebruiken.', # Translate - New (17)
    'DBI and DBD::Oracle are required if you want to use the Oracle database backend.' => 'DBI en DBD::Oracle zijn vereist als u het Oracle database-backend wenst te gebruiken.',
    'DBI and DBD::ODBC are required if you want to use the Microsoft SQL Server database backend.' => 'DBI en DBD::ODBC zijn vereist als u het Microsoft SQL Server database-backend wenst te gebruiken.',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entities is vereist om bepaalde tekens te coderen, maar deze functie kan worden uitgeschakeld met de optie NoHTMLEntities in mt.cfg.',
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
    'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcached en de memcached server/daemon zijn vereist om memcached as caching mechanisme te kunnen gebruiken met Movable Type.', # Translate - New (20)
    'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tar is vereist om archiefbestanden te kunnen aanmaken bij backup/restore operaties.', # Translate - New (13)
    'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzip is vereist om bestanden te kunnen comprimeren bij backup/restore operaties.', # Translate - New (14)
    'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzip is vereist om bestanden te kunnen decomprimeren bij backup/restore operaties.', # Translate - New (14)
    'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zip is vereist om bestanden te archiveren bij backup/restore operaties.', # Translate - New (13)
    'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAX en/of de bestanden waarvan deze module afhankelijk is, zijn nogid om backups terug te kunnen zetten.', # Translate - New (12)
    'Checking for' => 'Bezig te controleren op', # Translate - New (2)
    'Installed' => 'Geïnstalleerd', # Translate - New (1)
    'Data Storage' => 'gegevensopslag',
    'Required' => 'vereiste',
    'Optional' => 'optionele',

    ## ./addons/Enterprise.pack/lib/MT/Group.pm

    ## ./addons/Enterprise.pack/lib/MT/LDAP.pm
    'Invalid LDAPAuthURL scheme: [_1].' => 'Ongeldig LDAPAuthURL schema: [_1].',
    'Error connecting to LDAP server [_1]: [_2]' => 'Fout bij verbinden met LDAP server [_1]: [_2]',
    'User not found on LDAP: [_1]' => 'Gebruiker niet gevonden op LDAP: [_1]',
    'Binding to LDAP server failed: [_1]' => 'Binding met LDAP server mislukt: [_1]',
    'More than one user with the same name found on LDAP: [_1]' => 'Meer dan één gebruiker met dezelfde naam gevonden op LDAP: [_1]',

    ## ./addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
    'User [_1]([_2]) not found.' => 'Gebruiker [_1]([_2]) niet gevonden.',
    'User \'[_1]\' cannot be updated.' => 'Gebruiker \'[_1]\' kan niet worden bijgewerkt.',
    'User \'[_1]\' updated with LDAP login ID.' => 'Gebruiker \'[_1]\' bijgewerkt met LDAP login ID.',
    'LDAP user [_1] not found.' => 'LDAP gebruiker [_1] niet gevonden.',
    'User [_1] cannot be updated.' => 'Gebruiker [_1] kan niet worden bijgewerkt',
    'User cannot be updated: [_1].' => 'Gebruiker kan niet worden bijgewerkt: [_1].',
    'Failed login attempt by user \'[_1]\' deleted from LDAP.' => 'LDAP detecteerde een mislukte aanmeldpoging van gebruiker \'[_1]\'',
    'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Gebruiker \'[_1]\' bijgewerkt met LDAP gebruikersnaam \'[_2]\'.',
    'User cannot be created: [_1].' => 'Gebruiker kan niet worden aangemaakt: [_1].',
    'Failed login attempt by user \'[_1]\'. A user with that\nusername already exists in the system with a different UUID.' => 'Mislukte aanmeldpoging door gebruiker \'[_1]\'. Een gebruiker met die gebruikersnaam\n bestaat al in het systeem met een andere UUID.',
    'User \'[_1]\' account is disabled.' => 'De account van gebruiker \'[_1]\' is uitgeschakeld.',
    'LDAP users synchronization interrupted.' => 'LDAP gebruikerssynchronizatie onderbroken.',
    'Loading MT::LDAP failed: [_1]' => 'Laden van MT::LDAP mislukt: [_1]',
    'External user synchronization failed.' => 'Externe gebruikerssynchronisatie mislukt',
    'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Er werd een poging ondernomen om alle systeemadministrators in het systeem uit te schakelen.  Synchronisatie van gebruikers werd onderbroken.',
    'The following users\' information were modified:' => 'Deze gebruikersinformatie werd aangepast: ',
    'The following users were disabled:' => 'Volgende gebruikers werden uitgeschakeld: ',
    'LDAP users synchronized.' => 'LDAP gebruikers gesynchroniseerd.',
    'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute is set.' => 'Synchronizatie van groepen kan niet worden uitgevoerd zonder dat LDAPGroupIdAttribute en/of LDAPGroupNameAttribute ingesteld zijn.',
    'LDAP groups synchronized with existing groups.' => 'LDAP groepen gesynchroniseerd met bestaande groepen.',
    'The following groups\' information were modified:' => 'Gegevens van volgende groepen werd gewijzigd:',
    'No LDAP group was found using given filter.' => 'Er werd geen LDAP groep gevonden met de opgegeven filter.',
    'Filter used to search for groups: [_1]\nSearch base: [_2]' => 'Filter gebruikt om groepen te zoeken: [_1]\nZoekbasis: [_2]',
    '(none)' => '(geen)',
    'The following groups were deleted:' => 'Volgende groepen werden verwijderd:',
    'Failed to create a new group: [_1]' => 'Aanmaken van nieuwe groep mislukt: [_1]',
    '[_1] directive must be set to synchronize members of LDAP groups to Movable Type Enterprise.' => '[_1] directief moet ingesteld zijn om leden van LDAP groepen naar Movable Type Enterprise te synchroniseren.',
    'Members removed: ' => 'Leden verwijderd: ',
    'Members added: ' => 'Leden toegevoegd: ',
    'Memberships of the group \'[_2]\' (#[_3]) has been changed in synchronizing with external directory.' => 'Het ledenbestand van de groep \'[_2]\' (#[_3]) is veranderd tijdens de synchronisatie met de externe directory.',
    'LDAPUserGroupMemberAttribute must be set to enable synchronize members of groups.' => 'LDAPUserGroupMemberAttribute moet ingesteld zijn om het synchroniseren van groepsleden toe te staan.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
    'Group requires name' => 'Groep heeft een naam nodig',
    'Permission denied.' => 'Toestemming geweigerd.',
    'Invalid group' => 'Ongeldige groep',
    'Add Users to Group [_1]' => 'Gebruikers toevoegen aan groep [_1]',
    'Select Users' => 'Gebruikers selecteren',
    'Users Selected' => 'Gebruikers geselecteerd',
    'Type a username to filter the choices below.' => 'Tik een gebruikersnaam in om de keuzes hieronder te filteren.',
    '(user deleted)' => '(gebruiker verwijderd)',
    'Groups' => 'Groepen',
    'Users & Groups' => 'Gebruikers & Groepen',
    'User Groups' => 'Groepen gebruiker',
    'Group load failed: [_1]' => 'Laden groep mislukt: [_1]',
    'User load failed: [_1]' => 'Laden gebruiker mislukt: [_1]',
    'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd uit groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
    'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) werd toegevoegd aan groep \'[_3]\' (ID:[_4]) door \'[_5]\'',
    'Group Profile' => 'Groepsprofiel',
    'Author load failed: [_1]' => 'Laden auteur mislukt: [_1]',
    'Invalid user' => 'Ongeldige gebruiker',
    'Assign User [_1] to Groups' => 'Wijs gebruiker [_1] toe aan groepen',
    'Select Groups' => 'Selecteer groepen',
    'Group' => 'Groep',
    'Description' => 'Beschrijving',
    'Groups Selected' => 'Geselecteerde groepen',
    'Type a group name to filter the choices below.' => 'Tik een groepsnaam in om de keuzes hieronder te filteren.',
    'Bulk import cannot be used under external user management.' => 'Bulk import kan niet worden gebruikt onder extern gebruikersbeheer.',
    'Users' => 'Gebruikers',
    'Bulk management' => 'Bulkbeheer',
    'You did not choose a file to upload.' => 'U selecteerde geen bestand om op te laden.',

    ## ./addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
    'PLAIN' => 'PLAIN', # Translate - Previous (1)
    'CRAM-MD5' => 'CRAM-MD5', # Translate - Previous (1)
    'Digest-MD5' => 'Digest-MD5', # Translate - Previous (1)
    'Login' => 'Aanmelden',
    'Found' => 'Gevonden',
    'Not Found' => 'Niet gevonden',

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/MSSQLServer.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/DDL/Oracle.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
    'PublishCharset [_1] is not supported in this version of MS SQL Server Driver.' => 'PublishCharset [_1] wordt niet ondersteund in deze versie van de MS SQL Server Driver.',

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/Oracle.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/SQL/MSSQLServer.pm

    ## ./addons/Enterprise.pack/lib/MT/ObjectDriver/SQL/Oracle.pm

    ## ./build/Backup.pm

    ## ./build/Build.pm

    ## ./build/cwapi.pm

    ## ./build/exportmt.pl

    ## ./build/Html.pm

    ## ./build/sample.pm

    ## ./build/template_hash_signatures.pl

    ## ./build/l10n/diff.pl

    ## ./build/l10n/trans.pl

    ## ./build/l10n/wrap.pl

    ## ./extlib/CGI.pm

    ## ./extlib/Jcode.pm

    ## ./extlib/JSON.pm

    ## ./extlib/LWP.pm

    ## ./extlib/URI.pm

    ## ./extlib/Apache/SOAP.pm

    ## ./extlib/Apache/XMLRPC/Lite.pm

    ## ./extlib/Archive/Extract.pm

    ## ./extlib/Attribute/Params/Validate.pm

    ## ./extlib/Cache/IOString.pm

    ## ./extlib/Cache/Memory.pm

    ## ./extlib/Cache/Memory/Entry.pm

    ## ./extlib/Cache/Memory/HeapElem.pm

    ## ./extlib/CGI/Apache.pm

    ## ./extlib/CGI/Carp.pm

    ## ./extlib/CGI/Cookie.pm

    ## ./extlib/CGI/Fast.pm

    ## ./extlib/CGI/Pretty.pm

    ## ./extlib/CGI/Push.pm

    ## ./extlib/CGI/Switch.pm

    ## ./extlib/CGI/Util.pm

    ## ./extlib/Class/Accessor.pm

    ## ./extlib/Class/ErrorHandler.pm

    ## ./extlib/Class/Trigger.pm

    ## ./extlib/Class/Accessor/Fast.pm

    ## ./extlib/Class/Data/Inheritable.pm

    ## ./extlib/Crypt/DH.pm

    ## ./extlib/Data/ObjectDriver.pm

    ## ./extlib/Data/ObjectDriver/BaseObject.pm

    ## ./extlib/Data/ObjectDriver/BaseView.pm

    ## ./extlib/Data/ObjectDriver/Errors.pm

    ## ./extlib/Data/ObjectDriver/Profiler.pm

    ## ./extlib/Data/ObjectDriver/SQL.pm

    ## ./extlib/Data/ObjectDriver/Driver/BaseCache.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBI.pm

    ## ./extlib/Data/ObjectDriver/Driver/MultiPartition.pm

    ## ./extlib/Data/ObjectDriver/Driver/Multiplexer.pm

    ## ./extlib/Data/ObjectDriver/Driver/Partition.pm

    ## ./extlib/Data/ObjectDriver/Driver/SimplePartition.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Apache.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Cache.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/Memcached.pm

    ## ./extlib/Data/ObjectDriver/Driver/Cache/RAM.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/mysql.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/Pg.pm

    ## ./extlib/Data/ObjectDriver/Driver/DBD/SQLite.pm

    ## ./extlib/File/Listing.pm

    ## ./extlib/File/Temp.pm

    ## ./extlib/File/Copy/Recursive.pm

    ## ./extlib/Heap/Fibonacci.pm

    ## ./extlib/HTML/Form.pm

    ## ./extlib/HTML/Template.pm

    ## ./extlib/HTTP/Cookies.pm

    ## ./extlib/HTTP/Daemon.pm

    ## ./extlib/HTTP/Date.pm

    ## ./extlib/HTTP/Headers.pm

    ## ./extlib/HTTP/Message.pm

    ## ./extlib/HTTP/Negotiate.pm

    ## ./extlib/HTTP/Request.pm

    ## ./extlib/HTTP/Response.pm

    ## ./extlib/HTTP/Status.pm

    ## ./extlib/HTTP/Headers/Auth.pm

    ## ./extlib/HTTP/Headers/ETag.pm

    ## ./extlib/HTTP/Headers/Util.pm

    ## ./extlib/HTTP/Request/Common.pm

    ## ./extlib/I18N/LangTags.pm

    ## ./extlib/I18N/LangTags/List.pm

    ## ./extlib/Image/Size.pm

    ## ./extlib/IO/Scalar.pm

    ## ./extlib/IO/SessionData.pm

    ## ./extlib/IO/SessionSet.pm

    ## ./extlib/IO/WrapTie.pm

    ## ./extlib/IPC/Cmd.pm

    ## ./extlib/Jcode/Constants.pm

    ## ./extlib/Jcode/H2Z.pm

    ## ./extlib/Jcode/Tr.pm

    ## ./extlib/Jcode/Unicode.pm

    ## ./extlib/Jcode/Unicode/Constants.pm

    ## ./extlib/Jcode/Unicode/NoXS.pm

    ## ./extlib/JSON/Converter.pm

    ## ./extlib/JSON/Parser.pm

    ## ./extlib/Locale/Maketext.pm

    ## ./extlib/LWP/ConnCache.pm

    ## ./extlib/LWP/Debug.pm

    ## ./extlib/LWP/MediaTypes.pm

    ## ./extlib/LWP/MemberMixin.pm

    ## ./extlib/LWP/Protocol.pm

    ## ./extlib/LWP/RobotUA.pm

    ## ./extlib/LWP/Simple.pm

    ## ./extlib/LWP/UserAgent.pm

    ## ./extlib/LWP/Authen/Basic.pm

    ## ./extlib/LWP/Authen/Digest.pm

    ## ./extlib/LWP/Protocol/data.pm

    ## ./extlib/LWP/Protocol/file.pm

    ## ./extlib/LWP/Protocol/ftp.pm

    ## ./extlib/LWP/Protocol/GHTTP.pm

    ## ./extlib/LWP/Protocol/gopher.pm

    ## ./extlib/LWP/Protocol/http.pm

    ## ./extlib/LWP/Protocol/http10.pm

    ## ./extlib/LWP/Protocol/https.pm

    ## ./extlib/LWP/Protocol/https10.pm

    ## ./extlib/LWP/Protocol/mailto.pm

    ## ./extlib/LWP/Protocol/nntp.pm

    ## ./extlib/LWP/Protocol/nogo.pm

    ## ./extlib/Math/BigInt.pm

    ## ./extlib/Math/BigInt/Calc.pm

    ## ./extlib/Math/BigInt/Scalar.pm

    ## ./extlib/Math/BigInt/Trace.pm

    ## ./extlib/MIME/Charset.pm

    ## ./extlib/MIME/EncWords.pm

    ## ./extlib/MIME/Charset/_Compat.pm

    ## ./extlib/Module/Load.pm

    ## ./extlib/Module/Load/Conditional.pm

    ## ./extlib/Net/HTTP.pm

    ## ./extlib/Net/HTTPS.pm

    ## ./extlib/Net/HTTP/Methods.pm

    ## ./extlib/Net/HTTP/NB.pm

    ## ./extlib/Net/OpenID/Association.pm

    ## ./extlib/Net/OpenID/ClaimedIdentity.pm

    ## ./extlib/Net/OpenID/Consumer.pm

    ## ./extlib/Net/OpenID/VerifiedIdentity.pm

    ## ./extlib/Params/Check.pm

    ## ./extlib/Params/Validate.pm

    ## ./extlib/Params/ValidatePP.pm

    ## ./extlib/Params/ValidateXS.pm

    ## ./extlib/SOAP/Lite.pm

    ## ./extlib/SOAP/Test.pm

    ## ./extlib/SOAP/Transport/FTP.pm

    ## ./extlib/SOAP/Transport/HTTP.pm

    ## ./extlib/SOAP/Transport/IO.pm

    ## ./extlib/SOAP/Transport/JABBER.pm

    ## ./extlib/SOAP/Transport/LOCAL.pm

    ## ./extlib/SOAP/Transport/MAILTO.pm

    ## ./extlib/SOAP/Transport/MQ.pm

    ## ./extlib/SOAP/Transport/POP3.pm

    ## ./extlib/SOAP/Transport/TCP.pm

    ## ./extlib/UDDI/Lite.pm

    ## ./extlib/UNIVERSAL/require.pm

    ## ./extlib/URI/data.pm

    ## ./extlib/URI/Escape.pm

    ## ./extlib/URI/Fetch.pm

    ## ./extlib/URI/file.pm

    ## ./extlib/URI/ftp.pm

    ## ./extlib/URI/gopher.pm

    ## ./extlib/URI/Heuristic.pm

    ## ./extlib/URI/http.pm

    ## ./extlib/URI/https.pm

    ## ./extlib/URI/ldap.pm

    ## ./extlib/URI/mailto.pm

    ## ./extlib/URI/news.pm

    ## ./extlib/URI/nntp.pm

    ## ./extlib/URI/pop.pm

    ## ./extlib/URI/QueryParam.pm

    ## ./extlib/URI/rlogin.pm

    ## ./extlib/URI/rsync.pm

    ## ./extlib/URI/rtsp.pm

    ## ./extlib/URI/rtspu.pm

    ## ./extlib/URI/sip.pm

    ## ./extlib/URI/sips.pm

    ## ./extlib/URI/snews.pm

    ## ./extlib/URI/ssh.pm

    ## ./extlib/URI/telnet.pm

    ## ./extlib/URI/URL.pm

    ## ./extlib/URI/urn.pm

    ## ./extlib/URI/WithBase.pm

    ## ./extlib/URI/_foreign.pm

    ## ./extlib/URI/_generic.pm

    ## ./extlib/URI/_login.pm

    ## ./extlib/URI/_query.pm

    ## ./extlib/URI/_segment.pm

    ## ./extlib/URI/_server.pm

    ## ./extlib/URI/_userpass.pm

    ## ./extlib/URI/Fetch/Response.pm

    ## ./extlib/URI/file/Base.pm

    ## ./extlib/URI/file/FAT.pm

    ## ./extlib/URI/file/Mac.pm

    ## ./extlib/URI/file/OS2.pm

    ## ./extlib/URI/file/QNX.pm

    ## ./extlib/URI/file/Unix.pm

    ## ./extlib/URI/file/Win32.pm

    ## ./extlib/URI/urn/isbn.pm

    ## ./extlib/URI/urn/oid.pm

    ## ./extlib/WWW/RobotRules.pm

    ## ./extlib/WWW/RobotRules/AnyDBM_File.pm

    ## ./extlib/XML/Atom.pm

    ## ./extlib/XML/Elemental.pm

    ## ./extlib/XML/NamespaceSupport.pm

    ## ./extlib/XML/SAX.pm

    ## ./extlib/XML/Simple.pm

    ## ./extlib/XML/XPath.pm

    ## ./extlib/XML/Atom/API.pm

    ## ./extlib/XML/Atom/Author.pm

    ## ./extlib/XML/Atom/Base.pm

    ## ./extlib/XML/Atom/Category.pm

    ## ./extlib/XML/Atom/Client.pm

    ## ./extlib/XML/Atom/Content.pm

    ## ./extlib/XML/Atom/Entry.pm

    ## ./extlib/XML/Atom/ErrorHandler.pm

    ## ./extlib/XML/Atom/Feed.pm

    ## ./extlib/XML/Atom/Link.pm

    ## ./extlib/XML/Atom/Person.pm

    ## ./extlib/XML/Atom/Server.pm

    ## ./extlib/XML/Atom/Thing.pm

    ## ./extlib/XML/Atom/Util.pm

    ## ./extlib/XML/Elemental/Characters.pm

    ## ./extlib/XML/Elemental/Document.pm

    ## ./extlib/XML/Elemental/Element.pm

    ## ./extlib/XML/Elemental/Node.pm

    ## ./extlib/XML/Elemental/SAXHandler.pm

    ## ./extlib/XML/Elemental/Util.pm

    ## ./extlib/XML/Parser/Lite.pm

    ## ./extlib/XML/Parser/Style/Elemental.pm

    ## ./extlib/XML/SAX/Base.pm

    ## ./extlib/XML/SAX/DocumentLocator.pm

    ## ./extlib/XML/SAX/Exception.pm

    ## ./extlib/XML/SAX/ParserFactory.pm

    ## ./extlib/XML/SAX/PurePerl.pm

    ## ./extlib/XML/SAX/PurePerl/DebugHandler.pm

    ## ./extlib/XML/SAX/PurePerl/DocType.pm

    ## ./extlib/XML/SAX/PurePerl/DTDDecls.pm

    ## ./extlib/XML/SAX/PurePerl/EncodingDetect.pm

    ## ./extlib/XML/SAX/PurePerl/Exception.pm

    ## ./extlib/XML/SAX/PurePerl/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Productions.pm

    ## ./extlib/XML/SAX/PurePerl/Reader.pm

    ## ./extlib/XML/SAX/PurePerl/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/XMLDecl.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/NoUnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/Stream.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/String.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/UnicodeExt.pm

    ## ./extlib/XML/SAX/PurePerl/Reader/URI.pm

    ## ./extlib/XML/XPath/Boolean.pm

    ## ./extlib/XML/XPath/Builder.pm

    ## ./extlib/XML/XPath/Expr.pm

    ## ./extlib/XML/XPath/Function.pm

    ## ./extlib/XML/XPath/Literal.pm

    ## ./extlib/XML/XPath/LocationPath.pm

    ## ./extlib/XML/XPath/Node.pm

    ## ./extlib/XML/XPath/NodeSet.pm

    ## ./extlib/XML/XPath/Number.pm

    ## ./extlib/XML/XPath/Parser.pm

    ## ./extlib/XML/XPath/PerlSAX.pm

    ## ./extlib/XML/XPath/Root.pm

    ## ./extlib/XML/XPath/Step.pm

    ## ./extlib/XML/XPath/Variable.pm

    ## ./extlib/XML/XPath/XMLParser.pm

    ## ./extlib/XML/XPath/Node/Attribute.pm

    ## ./extlib/XML/XPath/Node/Comment.pm

    ## ./extlib/XML/XPath/Node/Element.pm

    ## ./extlib/XML/XPath/Node/Namespace.pm

    ## ./extlib/XML/XPath/Node/PI.pm

    ## ./extlib/XML/XPath/Node/Text.pm

    ## ./extlib/XMLRPC/Lite.pm

    ## ./extlib/XMLRPC/Test.pm

    ## ./extlib/XMLRPC/Transport/HTTP.pm

    ## ./extlib/XMLRPC/Transport/POP3.pm

    ## ./extlib/XMLRPC/Transport/TCP.pm

    ## ./extlib/YAML/Tiny.pm

    ## ./extras/examples/plugins/BackupRestoreSample/BackupRestoreSample.pl

    ## ./extras/examples/plugins/BackupRestoreSample/lib/BackupRestoreSample/Object.pm

    ## ./extras/examples/plugins/CommentByGoogleAccount/CommentByGoogleAccount.pl
    'Commenter\'s nickname to be used:' => 'Nickname van de reageerder gebruiken:', # Translate - New (6)

    ## ./extras/examples/plugins/CommentByGoogleAccount/lib/CommentByGoogleAccount.pm
    'Couldn\'t save the session' => 'Kon de sessie niet opslaan',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/FiveStarRating.pl
    'You used an [_1] tag outside of the proper context.' => 'U gebruikte een [_1] tag buiten de juiste context.',

    ## ./extras/examples/plugins/FiveStarRating/plugins/FiveStarRating/lib/FiveStarRating.pm

    ## ./extras/examples/plugins/l10nsample/l10nsample.pl

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample.pm
    'This is localized in perl module' => 'Dit is gelocaliseerd in perl module',

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/en_us.pm

    ## ./extras/examples/plugins/l10nsample/lib/l10nsample/L10N/ja.pm

    ## ./extras/examples/plugins/mirror/mirror.pl

    ## ./extras/examples/plugins/mirror/lib/Mirror.pm

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/reCaptcha.pl

    ## ./extras/examples/plugins/reCaptcha/plugins/reCaptcha/lib/reCaptcha.pm

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/SharedSecret.pl

    ## ./extras/examples/plugins/SharedSecret/plugins/SharedSecret/lib/SharedSecret.pm
    'DO YOU KNOW?  What is MT team\'s favorite brand of chocolate snack?' => 'WEET U HET?  Wat is de favoriete chocoladesnack van het MT team?', # Translate - New (13)

    ## ./extras/examples/plugins/SimpleScorer/SimpleScorer.pl

    ## ./extras/examples/plugins/SimpleScorer/lib/SimpleScorer.pm
    'Error during scoring.' => 'Fout tijdens het toekennen van een score.', # Translate - New (3)

    ## ./lib/MT/App.pm
    'First Weblog' => 'Eerste weblog',
    'Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Fout bij het laden van weblog #[_1] bij provisioneren van gebruiker.  Kijk uw NewUserTemplateBlogId instelling na.',
    'Error provisioning weblog for new user \'[_1]\' using template blog #[_2].' => 'Fout bij het aanmaken van een weblog voor nieuwe gebruiker \'[_1]\' met blog #[_2] als voorbeeld',
    'Error creating directory [_1] for blog #[_2].' => 'Fout bij het aanmaken van map [_1] voor blog #[_2].',
    'Error provisioning weblog for new user \'[_1] (ID: [_2])\'.' => 'Fout bij aanmaken van weblog voor nieuwe gebruiker \'[_1] (ID: [_2])\'.',
    'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Blog \'[_1] (ID: [_2])\' voor gebruiker \'[_3] (ID: [_4])\' werd aangemaakt.',
    'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => '
    Fout bij het toekennen van weblogadministrator rechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'. Er werd geen gepaste weblog administrator rol gevonden.',
    'The login could not be confirmed because of a database error ([_1])' => 'Het aanmelden kon niet worden bevestigd wegens een databaseprobleem ([_1])',
    'Failed login attempt by unknown user \'[_1]\'' => 'Mislukte poging tot aanmelden door onbekende gebruiker \'[_1]\'',
    'Invalid login.' => 'Ongeldige gebruikersnaam.',
    'Failed login attempt by disabled user \'[_1]\'' => 'Mislukte poging tot aanmelden door uitgeschakelde gebruiker \'[_1]\'',
    'This account has been disabled. Please see your system administrator for access.' => 'Deze account werd uitgeschakeld.  Contacteer uw systeembeheerder om weer toegang te krijgen.',
    'This account has been deleted. Please see your system administrator for access.' => 'Deze account werd verwijderd.  Contacteer uw systeembeheerder om weer toegang te krijgen.',
    'User \'[_1]\' has been created.' => 'Gebruiker \'[_1]\' is aangemaakt',
    'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Gebruiker \'[_1]\' (ID:[_2]) met succes aangemeld',
    'Invalid login attempt from user \'[_1]\'' => 'Ongeldige poging tot aanmelden van gebruiker \'[_1]\'',
    'User \'[_1]\' (ID:[_2]) logged out' => 'Gebruiker \'[_1]\' (ID:[_2]) werd afgemeld',
    'The file you uploaded is too large.' => 'Het bestand dat u heeft geupload is te groot.',
    'Unknown action [_1]' => 'Onbekende actie [_1]',
    'Warnings and Log Messages' => 'Waarschuwingen en logberichten',
    'Loading template \'[_1]\' failed: [_2]' => 'Sjabloon \'[_1]\' laden mislukt: [_2]',
    'http://www.movabletype.com/' => 'http://www.movabletype.com/', # Translate - New (4)

    ## ./lib/MT/Asset.pm
    'File' => 'Bestand', # Translate - New (1)
    'Files' => 'Bestanden', # Translate - New (1)
    'Location' => 'Locatie', # Translate - New (1)

    ## ./lib/MT/Association.pm

    ## ./lib/MT/Atom.pm

    ## ./lib/MT/AtomServer.pm
    'PreSave failed [_1]' => 'PreSave mislukt [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) voegde bericht #[_3] toe',
    'User \'[_1]\' (user #[_2]) edited entry #[_3]' => 'Gebruiker \'[_1]\' (gebruiker #[_2]) bewerkte bericht #[_3]', # Translate - New (7)

    ## ./lib/MT/Auth.pm
    'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Foute AuthenticationModule configuratie \'[_1]\': [_2]',
    'Bad AuthenticationModule config' => 'Foute AuthenticationModule configuratie', # Translate - New (3)

    ## ./lib/MT/Author.pm
    'The approval could not be committed: [_1]' => 'De goedkeuring kon niet worden weggeschreven: [_1]',

    ## ./lib/MT/BackupRestore.pm
    'Backing up [_1] records:' => 'Er worden [_1] records gebackupt:', # Translate - New (4)
    '[_1] records backed up...' => '[_1] records gebackupt...', # Translate - New (5)
    '[_1] records backed up.' => '[_1] records gebackupt.', # Translate - New (5)
    'There were no [_1] records to be backed up.' => 'Er waren geen [_1] records om te backuppen.', # Translate - New (9)
    'Can\'t open directory \'[_1]\': [_2]' => 'Kan map \'[_1]\' niet openen: [_2]',
    'No manifest file could be found in your import directory [_1].' => 'Er werd geen manifest-bestand gevonden in de importdirectory [_1].', # Translate - New (11)
    'Can\'t open [_1].' => 'Kan [_1] niet openen.', # Translate - New (4)
    'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Manifest-bestand [_1] was geen geldig Movable Type backup manifest-bestand.', # Translate - New (12)
    'Manifest file: [_1]\n' => 'Manifest-bestand: [_1]\n', # Translate - New (4)
    'Path was not found for the asset ([_1]).' => 'Geen pad gevonden voor het mediabestand ([_1]).', # Translate - New (8)
    '[_1] is not writable.' => '[_1] is niet beschrijfbaar.',
    'Error making path \'[_1]\': [_2]' => 'Fout bij aanmaken pad \'[_1]\': [_2]',
    'Copying [_1] to [_2]...' => 'Bezig [_1] te copiëren naar [_2]...', # Translate - New (4)
    'Failed: ' => 'Mislukt: ', # Translate - New (1)
    'Done.' => 'Klaar.', # Translate - New (1)
    'ID for the asset was not set.' => 'ID voor het mediabestand was niet ingesteld.', # Translate - New (7)
    'The asset ([_1]) was not restored.' => 'Het mediabestand ([_1]) werd niet teruggezet.', # Translate - New (6)
    'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Bestandslocatie voor mediabestand \'[_1]\' (ID:[_2]) wordt aangepast...', # Translate - New (9)
    'failed\n' => 'mislukt\n',
    'ok\n' => 'ok\n', # Translate - Previous (2)

    ## ./lib/MT/BasicAuthor.pm

    ## ./lib/MT/BasicSession.pm

    ## ./lib/MT/Blocklist.pm

    ## ./lib/MT/Blog.pm
    'No default templates were found.' => 'Er werden geen standaardsjablonen gevonden.', # Translate - New (5)
    'Cloned blog... new id is [_1].' => 'Blog gekloond... nieuw ID is [_1]',
    'Cloning permissions for blog:' => 'Permissies worden gekloond voor blog:', # Translate - New (4)
    '[_1] records processed...' => '[_1] items verwerkt...',
    '[_1] records processed.' => '[_1] items verwerkt.',
    'Cloning associations for blog:' => 'Associaties worden gekloond voor blog:', # Translate - New (4)
    'Cloning entries for blog...' => 'Berichten worden gekloond voor blog...', # Translate - New (4)
    'Cloning categories for blog...' => 'Categorieën worden gekloond voor blog...', # Translate - New (4)
    'Cloning entry placements for blog...' => 'Berichtcategorieën wordt gekloond voor blog...', # Translate - New (5)
    'Cloning comments for blog...' => 'Reacties worden gekloond voor blog...', # Translate - New (4)
    'Cloning entry tags for blog...' => 'Berichttags worden gekloond voor blog...', # Translate - New (5)
    'Cloning TrackBacks for blog...' => 'Trackbacks worden gekloond voor blog...', # Translate - New (4)
    'Cloning TrackBack pings for blog...' => 'TrackBack pings worden gekloond voor blog...', # Translate - New (5)
    'Cloning templates for blog...' => 'Sjablonen worden gekloond voor blog...', # Translate - New (4)
    'Cloning template maps for blog...' => 'Sjabloonkoppelingen worden gekloond voor blog...', # Translate - New (5)

    ## ./lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'Er deed zich een fout voor: [_1]',

    ## ./lib/MT/Builder.pm
    '<MT[_1]> with no </MT[_1]>' => '<MT[_1]> zonder </MT[_1]>', # Translate - New (7)
    'Error in <mt:[_1]> tag: [_2]' => 'Fout in <mt:[_1]> tag: [_2]', # Translate - New (6)
    'No handler exists for tag [_1]' => 'Er bestaat geen handler voor tag [_1]', # Translate - New (6)

    ## ./lib/MT/BulkCreation.pm
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
    'Permission granted to user \'[_1]\'' => 'Permissie gegeven aan gebruiker \'[_1]\'',
    'User \'[_1]\' already exists. Update was not processed: [_2]' => 'Gebruiker \'[_1]\' bestaat al.  Update werd niet verwerkt: [_2]',
    'User \'[_1]\' not found.  Update was not processed.' => 'Gebruiker \'[_1]\' niet gevonden.  Update werd niet verwerkt.',
    'User \'[_1]\' has been updated.' => 'Gebruiker \'[_1]\' is bijgewerkt.',
    'User \'[_1]\' was found, but delete was not processed' => 'Gebruiker \'[_1]\' werd gevonden, maar verwijdering werd niet verwerkt',
    'User \'[_1]\' not found.  Delete was not processed.' => 'Gebruiker \'[_1]\' werd niet gevonden. Verwijdering werd niet verwerkt.',
    'User \'[_1]\' has been deleted.' => 'Gebruiker \'[_1]\' werd verwijderd.',

    ## ./lib/MT/Callback.pm

    ## ./lib/MT/Category.pm
    'Categories must exist within the same blog' => 'Categorieën moeten bestaan binnen dezelfde blog',
    'Category loop detected' => 'Categorielus gedetecteerd',

    ## ./lib/MT/Comment.pm
    'Comment' => 'Reactie',
    'Load of entry \'[_1]\' failed: [_2]' => 'Laden van bericht \'[_1]\' mislukt: [_2]',
    'Load of blog \'[_1]\' failed: [_2]' => 'Laden van blog \'[_1]\' mislukt: [_2]',

    ## ./lib/MT/Component.pm
    'Rebuild' => 'Opnieuw opbouwen',

    ## ./lib/MT/Config.pm

    ## ./lib/MT/ConfigMgr.pm
    'Alias for [_1] is looping in the configuration.' => 'Alias voor [_1] zit in een lus in de configuratie',
    'Error opening file \'[_1]\': [_2]' => 'Fout bij openen bestand \'[_1]\': [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => 'Configuratie-directief [_1] zonder waarde in [_2] lijn [_3]',
    'No such config variable \'[_1]\'' => 'Onbekende configuratievariabele \'[_1]\'',

    ## ./lib/MT/Core.pm

    ## ./lib/MT/DateTime.pm

    ## ./lib/MT/default-templates.pl

    ## ./lib/MT/DefaultTemplates.pm

    ## ./lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'Laden van blog mislukt: [_1]',

    ## ./lib/MT/ErrorHandler.pm

    ## ./lib/MT/FileInfo.pm

    ## ./lib/MT/FileMgr.pm

    ## ./lib/MT/Folder.pm
    'Folder' => 'Map', # Translate - New (1)
    'Folders' => 'Mappen', # Translate - New (1)

    ## ./lib/MT/I18N.pm

    ## ./lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Kan Image::Magick niet laden: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'Bestand \'[_1]\' lezen mislukt: [_2]',
    'Reading image failed: [_1]' => 'Afbeelding lezen mislukt: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => 'Dimensies aanpassen naar [_1]x[_2] mislukt: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'Kan IPC::Run niet laden: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'U hebt geen geldig pad naar de NetPBM tools op uw machine.',

    ## ./lib/MT/Import.pm
    'Can\'t rewind' => 'Kan niet terugspoelen',
    'Can\'t open \'[_1]\': [_2]' => 'Kan \'[_1]\' niet openen: [_2]',
    'No readable files could be found in your import directory [_1].' => 'Er werden geen leesbare bestanden gevonden in uw importmap [_1].',
    'Importing entries from file \'[_1]\'' => 'Berichten worden ingevoerd uit bestand  \'[_1]\'',
    'Couldn\'t resolve import format [_1]' => 'Kon importformaat niet onderscheiden [_1]', # Translate - New (6)

    ## ./lib/MT/ImportExport.pm
    'No Blog' => 'Geen blog',
    'You need to provide a password if you are going to\n' => 'U moet een paswoord opgeven als u van plan bent om\n',
    'Need either ImportAs or ParentAuthor' => 'ImportAs ofwel ParentAuthor vereist',
    'Creating new user (\'[_1]\')...' => 'Nieuwe gebruiker (\'[_1]\') wordt aangemaakt...',
    'Saving user failed: [_1]' => 'Gebruiker opslaan mislukt: [_1]',
    'Assigning permissions for new user...' => 'Permissies worden toegekend aan nieuwe gebruiker...',
    'Saving permission failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
    'Creating new category (\'[_1]\')...' => 'Nieuwe categorie wordt aangemaakt (\'[_1]\')...',
    'Saving category failed: [_1]' => 'Categorie opslaan mislukt: [_1]',
    'Invalid status value \'[_1]\'' => 'Ongeldige statuswaarde \'[_1]\'',
    'Invalid allow pings value \'[_1]\'' => 'Ongeldige instelling voor het toelaten van pings \'[_1]\'',
    'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.\n' => 'Kan geen bestaand bericht vinden met timestamp \'[_1]\'... reacties worden overgeslagen, volgend bericht wordt verwerkt.\n',
    'Importing into existing entry [_1] (\'[_2]\')\n' => 'Bezig te importeren naar bestaand bericht [_1] (\'[_2]\')\n',
    'Saving entry (\'[_1]\')...' => 'Bericht aan het opslaan (\'[_1]\')...',
    'ok (ID [_1])\n' => 'ok (ID [_1])\n', # Translate - Previous (4)
    'Saving entry failed: [_1]' => 'Bericht opslaan mislukt: [_1]',
    'Saving placement failed: [_1]' => 'Plaatsing opslaan mislukt: [_1]',
    'Creating new comment (from \'[_1]\')...' => 'Nieuwe reactie aan het aanmaken (van \'[_1]\')...',
    'Saving comment failed: [_1]' => 'Reactie opslaan mislukt: [_1]',
    'Entry has no MT::Trackback object!' => 'Bericht heeft geen MT::Trackback object!',
    'Creating new ping (\'[_1]\')...' => 'Nieuwe ping aan het aanmaken (\'[_1]\')...',
    'Saving ping failed: [_1]' => 'Ping opslaan mislukt: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'Export mislukt bij bericht \'[_1]\': [_2]',
    'Invalid date format \'[_1]\'; must be ' => 'Ongeldig datumformaat \'[_1]\'; dit moet zijn ',

    ## ./lib/MT/IPBanList.pm

    ## ./lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => 'Handeling: Verworpen (score onder drempel)',
    'Action: Published (default action)' => 'Handeling: Gepubliceerd (standaardhandeling)',
    'Junk Filter [_1] died with: [_2]' => 'Spamfilter [_1] liep vast met: [_2]',
    'Unnamed Junk Filter' => 'Naamloze spamfilter',
    'Composite score: [_1]' => 'Samengestelde score: [_1]',

    ## ./lib/MT/L10N.pm

    ## ./lib/MT/Log.pm
    'Pages' => 'Pagina\'s', # Translate - New (1)
    'Page # [_1] not found.' => 'Pagina # [_1] niet gevonden.', # Translate - New (4)
    'Entry # [_1] not found.' => 'Bericht # [_1] niet gevonden.',
    'Comment # [_1] not found.' => 'Reactie # [_1] niet gevonden.',
    'TrackBack # [_1] not found.' => 'TrackBack # [_1] niet gevonden.',

    ## ./lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'Onbekende MailTransfer methode \'[_1]\'',
    'Sending mail via SMTP requires that your server ' => 'Mail versturen via SMTP betekent dat het nodig is dat uw server ',
    'Error sending mail: [_1]' => 'Fout bij versturen mail: [_1]',
    'You do not have a valid path to sendmail on your machine. ' => 'U hebt geen geldig pad naar sendmail op uw machine. ',
    'Exec of sendmail failed: [_1]' => 'Exec van sendmail mislukt: [_1]',

    ## ./lib/MT/Memcached.pm

    ## ./lib/MT/Notification.pm

    ## ./lib/MT/Object.pm

    ## ./lib/MT/ObjectAsset.pm

    ## ./lib/MT/ObjectDriverFactory.pm

    ## ./lib/MT/ObjectScore.pm

    ## ./lib/MT/ObjectTag.pm

    ## ./lib/MT/Page.pm
    'Page' => 'Pagina', # Translate - New (1)

    ## ./lib/MT/Permission.pm

    ## ./lib/MT/Placement.pm

    ## ./lib/MT/Plugin.pm

    ## ./lib/MT/PluginData.pm

    ## ./lib/MT/Promise.pm

    ## ./lib/MT/Request.pm

    ## ./lib/MT/Role.pm

    ## ./lib/MT/Sanitize.pm

    ## ./lib/MT/Scorable.pm
    'Already scored for this object.' => 'Aan dit object is reeds een score toegekend.', # Translate - New (5)

    ## ./lib/MT/Serialize.pm

    ## ./lib/MT/Session.pm

    ## ./lib/MT/Tag.pm
    'Tag must have a valid name' => 'Tag moet een geldige naam hebben',
    'This tag is referenced by others.' => 'Deze tag is gerefereerd door anderen.',

    ## ./lib/MT/Task.pm

    ## ./lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Aanmaken van een lockfile mislukt om systeemtaken uit te kunnen voeren. Kijk naof uw TempDir locatie ([_1]) beschrijfbaar is.',
    'Error during task \'[_1]\': [_2]' => 'Fout tijdens taak \'[_1]\': [_2]',
    'Scheduled Tasks Update' => 'Update van geplande taken',
    'The following tasks were run:' => 'Volgende taken moesten uitgevoerd worden:',

    ## ./lib/MT/TBPing.pm

    ## ./lib/MT/Template.pm
    'File not found: [_1]' => 'Bestand niet gevonden: [_1]', # Translate - New (4)
    'Parse error in template \'[_1]\': [_2]' => 'Ontleedfout in sjabloon \'[_1]\': [_2]',
    'Build error in template \'[_1]\': [_2]' => 'Opbouwfout in sjabloon \'[_1]\': [_2]',
    'Template with the same name already exists in this blog.' => 'Er bestaat al een sjabloon met dezelfde naam in deze weblog.', # Translate - New (10)
    'You cannot use a [_1] extension for a linked file.' => 'U kunt geen [_1] extensie gebruiken voor een gelinkt bestand.',
    'Opening linked file \'[_1]\' failed: [_2]' => 'Gelinkt bestand \'[_1]\' openen mislukt: [_2]',

    ## ./lib/MT/TemplateMap.pm

    ## ./lib/MT/Trackback.pm

    ## ./lib/MT/Upgrade.pm
    'Custom ([_1])' => 'Gepersonaliseerd ([_1])',
    'This role was generated by Movable Type upon upgrade.' => 'Deze rol werd aangemaakt door Movable Type tijdens de upgrade.',
    'First Blog' => 'Eerste weblog', # Translate - New (2)
    'User \'[_1]\' upgraded database to version [_2]' => 'Gebruiker \'[_1]\' deed een upgrade van de database naar versie [_2]',
    'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' deed een upgrade van plugin \'[_2]\' naar versie [_3] (schema versie [_4]).', # Translate - New (11)
    'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Gebruiker \'[_1]\' installeerde plugin \'[_2]\', versie [_3] (schema versie [_4]).', # Translate - New (10)

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

    ## ./lib/MT/WeblogPublisher.pm
    'yyyy/index.html' => 'jjjj/index.html', # Translate - New (3)
    'yyyy/mm/index.html' => 'jjjj/mm/index.html', # Translate - New (4)
    'yyyy/mm/day-week/index.html' => 'jjjj/mm/dag-week/index.html', # Translate - New (5)
    'yyyy/mm/entry_basename.html' => 'jjjj/mm/basisnaam_bericht.html', # Translate - New (5)
    'yyyy/mm/entry-basename.html' => 'jjjj/mm/basisnaam-bericht.html', # Translate - New (4)
    'yyyy/mm/entry_basename/index.html' => 'jjjj/mm/basisnaam_bericht/index.html', # Translate - New (6)
    'yyyy/mm/entry-basename/index.html' => 'jjjj/mm/basisnaam-bericht/index.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename.html' => 'jjjj/mm/dd/basisnaam_bericht.html', # Translate - New (6)
    'yyyy/mm/dd/entry-basename.html' => 'jjjj/mm/dd/basisnaam-bericht.html', # Translate - New (5)
    'yyyy/mm/dd/entry_basename/index.html' => 'jjjj/mm/dd/basisnaam_bericht/index.html', # Translate - New (7)
    'yyyy/mm/dd/entry-basename/index.html' => 'jjjj/mm/dd/basisnaam-bericht/index.html', # Translate - New (6)
    'category/sub_category/entry_basename.html' => 'categorie/sub_categorie/basisnaam_bericht.html', # Translate - New (6)
    'category/sub_category/entry_basename/index.html' => 'categorie/sub_categorie/basisnaam_bericht/index.html', # Translate - New (7)
    'category/sub-category/entry-basename.html' => 'categorie/sub-categorie/basisnaam-bericht.html', # Translate - New (4)
    'category/sub-category/entry-basename/index.html' => 'categorie/sub-categorie/basisnaam-bericht/index.html', # Translate - New (5)
    'folder_path/page_basename.html' => 'map_pad/basisnaam_pagina.html', # Translate - New (5)
    'folder_path/page_basename/index.html' => 'map_pad/basisnaam_pagina/index.html', # Translate - New (6)
    'folder-path/page-basename.html' => 'map-pad/basisnaam-pagina.html', # Translate - New (3)
    'folder-path/page-basename/index.html' => 'map-pad/basisnaam-pagina/index.html', # Translate - New (4)
    'folder/sub_folder/index.html' => 'map/sub_map/index.html', # Translate - New (5)
    'folder/sub-folder/index.html' => 'map/sub-map/index.html', # Translate - New (4)
    'yyyy/mm/dd/index.html' => 'jjjj/mm/dd/index.html', # Translate - New (5)
    'category/sub_category/index.html' => 'categorie/sub_categorie/index.html', # Translate - New (5)
    'category/sub-category/index.html' => 'categorie/sub-categorie/index.html', # Translate - New (4)
    'Archive type \'[_1]\' is not a chosen archive type' => 'Archieftype \'[_1]\' is geen gekozen archieftype',
    'Parameter \'[_1]\' is required' => 'Parameter \'[_1]\' is vereist',
    'You did not set your weblog Archive Path' => 'Uw stelde geen weblogarchief-pad in', # Translate - New (8)
    'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Hetzelfde archiefbestand bestaat al. U moet de basisnaam of het archiefpad wijzigen. ([_1])', # Translate - New (15)
    'Building category \'[_1]\' failed: [_2]' => 'Categorie \'[_1]\' opbouwen mislukt: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opbouwen mislukt: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => 'Datum-gebaseerd archief \'[_1]\' opbouwen mislukt: [_2]',
    'Writing to \'[_1]\' failed: [_2]' => 'Schrijven naar \'[_1]\' mislukt: [_2]',
    'Renaming tempfile \'[_1]\' failed: [_2]' => 'Tijdelijk bestand \'[_1]\' van naam veranderen mislukt: [_2]',
    'You did not set your weblog Site Root' => 'U stelde geen site root in voor uw weblog', # Translate - New (8)
    'Template \'[_1]\' does not have an Output File.' => 'Sjabloon \'[_1]\' heeft geen uitvoerbestand.',
    'An error occurred while rebuilding to publish scheduled entries: [_1]' => 'Er deed zich een fout voor bij het opnieuw opbouwen van geplande berichten: [_1]', # Translate - New (10)
    'YEARLY_ADV' => 'Jaarlijks', # Translate - New (2)
    'MONTHLY_ADV' => 'Maandelijks',
    'CATEGORY_ADV' => 'Categorie',
    'PAGE_ADV' => 'Pagina', # Translate - New (2)
    'INDIVIDUAL_ADV' => 'Individueel',
    'DAILY_ADV' => 'Dagelijks',
    'WEEKLY_ADV' => 'Wekelijks',

    ## ./lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => 'Geen WeblogsPingURL ingesteld in mt.cfg',
    'No MTPingURL defined in mt.cfg' => 'Geen MTPingURL ingesteld in mt.cfg',
    'HTTP error: [_1]' => 'HTTP fout: [_1]',
    'Ping error: [_1]' => 'Ping fout: [_1]',

    ## ./lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'Ongeldig timestamp formaat',
    'No web services password assigned.  Please see your user profile to set it.' => 'Geen web services wachtwoord ingesteld.  Ga naar uw gebruikersprofiel om het in te stellen.',
    'No blog_id' => 'Geen blog_id',
    'Invalid blog ID \'[_1]\'' => 'Ongeldig blog ID \'[_1]\'',
    'Invalid login' => 'Ongeldige gebruikersnaam',
    'No publishing privileges' => 'Geen publicatierechten', # Translate - New (3)
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'Waarde voor \'mt_[_1]\' moet 0 of 1 zijn (was \'[_2]\')',
    'No entry_id' => 'Geen entry_id',
    'Invalid entry ID \'[_1]\'' => 'Ongeldig bericht-ID \'[_1]\'',
    'Not privileged to edit entry' => 'Geen rechten om bericht te bewerken',
    'Not privileged to delete entry' => 'Geen rechten om bericht te verwijderen',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Bericht \'[_1]\' (bericht #[_2]) verwijderd door \'[_3]\' (gebruiker #[_4]) via xml-rpc',
    'Not privileged to get entry' => 'Geen rechten om bericht op te halen',
    'User does not have privileges' => 'Gebruiker heeft geen rechten',
    'Not privileged to set entry categories' => 'Geen rechten om berichtcategorieën in te stellen',
    'Publish failed: [_1]' => 'Publicatie mislukt: [_1]',
    'Not privileged to upload files' => 'Geen rechten om bestenden op te laden',
    'No filename provided' => 'Geen bestandsnaam opgegeven',
    'Invalid filename \'[_1]\'' => 'Ongeldige bestandsnaam \'[_1]\'',
    'Error writing uploaded file: [_1]' => 'Fout bij het schrijven van opgeladen bestand: [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Sjabloonmethodes zijn niet geïmplementeerd wegens het verschil tussen de Blogger API en de Movable Type API.',

    ## ./lib/MT/App/ActivityFeeds.pm
    'Error loading [_1]: [_2]' => 'Fout bij het laden van [_1]: [_2]',
    'An error occurred while generating the activity feed: [_1].' => 'Er deed zich een fout voor bij het aanmaken van de activiteitenfeed: [_1].',
    'No permissions.' => 'Geen permissies.',
    '[_1] Weblog TrackBacks' => '[_1] Weblog TrackBacks', # Translate - Previous (4)
    'All Weblog TrackBacks' => 'Alle Weblog TrackBacks',
    '[_1] Weblog Comments' => '[_1] Weblogreacties',
    'All Weblog Comments' => 'Alle Weblogreacties',
    '[_1] Weblog Entries' => '[_1] Weblogberichten',
    'All Weblog Entries' => 'Alle weblogberichten',
    '[_1] Weblog Activity' => '[_1] Weblogactiviteit',
    'All Weblog Activity' => 'Alle weblogactiviteit',
    'Movable Type Debug Activity' => 'Movable Type debugactiviteit',

    ## ./lib/MT/App/CMS.pm
    'Invalid request' => 'Ongeldig verzoek',
    'Invalid request.' => 'Ongeldig verzoek.',
    'All comments by [_1] \'[_2]\'' => 'Alle reacties van [_1] \'[_2]\'', # Translate - New (5)
    'All comments for [_1] \'[_2]\'' => 'Alle reacties op [_1] \'[_2]\'', # Translate - New (5)
    'Invalid blog' => 'Ongeldige blog',
    'Convert Line Breaks' => 'Regeleindes omzetten',
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
    'Error sending mail ([_1]); please fix the problem, then ' => 'Probleem bij het versturen van mail ([_1]); gelieve het probleem op te lossen en ',
    '(newly created user)' => '(nieuw aangemaakte gebruiker)', # Translate - New (4)
    'Search Files' => 'Bestanden zoeken', # Translate - New (2)
    'Invalid group id' => 'Ongeldig groeps-id',
    'Group Roles' => 'Rollen groep',
    'Invalid user id' => 'Ongeldig user-id',
    'User Roles' => 'Rollen gebruiker',
    'Roles' => 'Rollen',
    'Group Associations' => 'Groepsassociaties',
    'User Associations' => 'Gebruikersassociaties',
    'Role Users & Groups' => 'Gebruikers & Groepen met deze rol',
    'Associations' => 'Associaties',
    '(Custom)' => '(Gepersonaliseerd)',
    'Invalid type' => 'Ongeldig type',
    'No such tag' => 'Onbekende tag',
    'None' => 'Geen',
    'You are not authorized to log in to this blog.' => 'U hebt geen toestemming op u aan te melden op deze weblog.',
    'No such blog [_1]' => 'Geen blog [_1]',
    'Blogs' => 'Blogs', # Translate - New (1)
    'Blog Activity Feed' => 'Blogactiviteitsfeed', # Translate - New (3)
    'Group Members' => 'Groepsleden',
    'QuickPost' => 'QuickPost', # Translate - Previous (1)
    'All Feedback' => 'Alle feedback',
    'System Activity Feed' => 'Systeemactiviteit-feed',
    'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Activiteitlog van blog \'[_1]\' (ID:[_2]) leeggemaakt door \'[_3]\'',
    'Activity log reset by \'[_1]\'' => 'Activiteitlog leeggemaakt door \'[_1]\'',
    'No blog ID' => 'Geen blog-ID',
    'You do not have import permissions' => 'U heeft geen importpermissies',
    'Import/Export' => 'Importeren/exporteren',
    'Invalid parameter' => 'Ongeldige parameter',
    'Permission denied: [_1]' => 'Toestemming geweigerd: [_1]',
    'Load failed: [_1]' => 'Laden mislukt: [_1]',
    '(no reason given)' => '(geen reden vermeld)',
    '(untitled)' => '(geen titel)',
    'General Settings' => 'Algemene instellingen',
    'Publishing Settings' => 'Publicatie-instellingen',
    'Plugin Settings' => 'Instellingen plugins',
    'Edit TrackBack' => 'TrackBack bewerken',
    'Edit Comment' => 'Reactie bewerken',
    'Authenticated Commenters' => 'Geauthenticeerde reageerders',
    'Commenter Details' => 'Details reageerder',
    'New Page' => 'Nieuwe pagina', # Translate - New (2)
    'Create template requires type' => 'Sjabloon aanmaken vereist type',
    'Date based Archive' => 'Datumgebaseerd archief', # Translate - New (3)
    'Individual Entry Archive' => 'Archief voor individuele berichten',
    'Category Archive' => 'Archief per categorie',
    'Page Archive' => 'Pagina archief', # Translate - New (2)
    'New Template' => 'Nieuwe sjabloon',
    'New Blog' => 'Nieuwe blog', # Translate - New (2)
    'Create New User' => 'Nieuwe account aanmaken',
    'User requires username' => 'Gebruiker vereist gebruikersnaam',
    'A user with the same name already exists.' => 'Er bestaat al een gebruiker met die naam.',
    'User requires password' => 'Gebruiker vereist wachtwoord',
    'User requires password recovery word/phrase' => 'Gebruiker heeft een woord/uitdrukking nodig om het wachtwoord te kunnen terugvinden',
    'Email Address is required for password recovery' => 'E-mail adres is vereist voor het terugvinden van een wachtwoord',
    'The value you entered was not a valid email address' => 'Wat u invulde was geen geldig e-mail adres',
    'The e-mail address you entered is already on the Notification List for this blog.' => 'Het e-mail adres dat u opgaf staat al op de notificatielijst van deze weblog.', # Translate - New (14)
    'You did not enter an IP address to ban.' => 'U vulde geen IP adres in om te verbannen.',
    'The IP you entered is already banned for this blog.' => 'Het IP adres dat u opgaf is al verbannen van deze weblog.', # Translate - New (10)
    'You did not specify a blog name.' => 'U gaf geen weblognaam op.', # Translate - New (7)
    'Site URL must be an absolute URL.' => 'Site URL moet eenn absolute URL zijn.',
    'Archive URL must be an absolute URL.' => 'Archief URL moet een absolute URL zijn.',
    'The name \'[_1]\' is too long!' => 'De naam \'[_1]\' is te lang!',
    'A user can\'t change his/her own username in this environment.' => 'Een gebruiker kan zijn/haar gebruikersnaam niet aanpassen in deze omgeving',
    'An errror occurred when enabling this user.' => 'Er deed zich een fout voor bij het inschakelen van deze gebruiker.',
    'Folder \'[_1]\' created by \'[_2]\'' => 'Map \'[_1]\' aangemaakt door \'[_2]\'', # Translate - New (5)
    'Category \'[_1]\' created by \'[_2]\'' => 'Categorie \'[_1]\' aangemaakt door \'[_2]\'',
    'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'De map \'[_1]\' conflicteert met een andere map. Mappen met dezelfde ouder moeten een unieke basisnaam hebben.', # Translate - New (16)
    'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Categorienaam \'[_1]\' conflicteert met een andere categorie. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke naam hebben.', # Translate - New (20)
    'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Categoriebasisnaam \'[_1]\' conflicteert met een andere categoriewith another category. Hoofdcategorieën en subcategorieën met dezelfde ouder moeten een unieke basisnaam hebben.', # Translate - New (20)
    'Saving permissions failed: [_1]' => 'Permissies opslaan mislukt: [_1]',
    'Blog \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'', # Translate - New (7)
    'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
    'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) aangemaakt door \'[_3]\'',
    'You cannot delete your own association.' => 'U kunt uw eigen associatie niet verwijderen.',
    'You cannot delete your own user record.' => 'U kunt uw eigen gebruikersgegevens niet verwijderen.',
    'You have no permission to delete the user [_1].' => 'U heeft geen rechten om gebruiker [_1] te verwijderen.',
    'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'', # Translate - New (7)
    'Subscriber \'[_1]\' (ID:[_2]) deleted from notification list by \'[_3]\'' => 'Ontvanger \'[_1]\' (ID:[_2]) verwijderd uit de notificatielijst door \'[_3]\'',
    'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gebruiker \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
    'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Map \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'', # Translate - New (7)
    'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Categorie \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
    'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Reactie (ID:[_1]) door \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
    'Page \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Pagina \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'', # Translate - New (7)
    'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bericht \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
    '(Unlabeled category)' => '(Categorie zonder label)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van categorie \'[_4]\'',
    '(Untitled entry)' => '(Bericht zonder titel)',
    'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) van \'[_2]\' verwijderd door \'[_3]\' van bericht \'[_4]\'',
    'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Sjabloon \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
    'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'',
    'File \'[_1]\' uploaded by \'[_2]\'' => 'Bestand \'[_1]\' opgeladen door \'[_2]\'', # Translate - New (5)
    'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Bestand \'[_1]\' (ID:[_2]) verwijderd door \'[_3]\'', # Translate - New (7)
    'Permisison denied.' => 'Toestemming geweigerd.',
    'The Template Name and Output File fields are required.' => 'De velden sjabloonnaam en uitvoerbestand zijn verplicht.', # Translate - New (9)
    'Invalid type [_1]' => 'Ongeldig type [_1]', # Translate - New (3)
    'Save failed: [_1]' => 'Opslaan mislukt: [_1]',
    'Saving object failed: [_1]' => 'Object opslaan mislukt: [_1]',
    'No Name' => 'Geen naam',
    'Notification List' => 'Notificatie-lijst',
    'IP Banning' => 'IP-verbanning',
    'Can\'t delete that way' => 'Kan niet wissen op die manier',
    'Removing tag failed: [_1]' => 'Tag verwijderen mislukt: [_1]', # Translate - New (4)
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'U kunt deze categorie niet verwijderen want ze heeft subcategorieën.  Verplaats of verwijder eerst de subcategorieën als u deze wenst te verwijderen.',
    'Loading MT::LDAP failed: [_1].' => 'Laden van MT::LDAP mislukt: [_1]',
    'Removing [_1] failed: [_2]' => 'Verwijderen van [_1] mislukt: [_2]', # Translate - New (4)
    'System templates can not be deleted.' => 'Systeemsjablonen kunnen niet worden verwijderd.',
    'Unknown object type [_1]' => 'Onbekend objecttype [_1]',
    'Can\'t load file #[_1].' => 'Kan bestand niet laden #[_1].', # Translate - New (5)
    'No such commenter [_1].' => 'Geen reageerder [_1].',
    'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status VERTROUWD.',
    'User \'[_1]\' banned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' verbande reageerder \'[_2]\'.',
    'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' maakte de verbanning van reageerder \'[_2]\' ongedaan.',
    'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Gebruiker \'[_1]\' gaf reageerder \'[_2]\' de status NIET VERTROUWD.',
    'Need a status to update entries' => 'Status vereist om berichten bij te werken',
    'Need entries to update status' => 'Berichten nodig om status bij te werken',
    'One of the entries ([_1]) did not actually exist' => 'Een van de berichten ([_1]) bestond niet',
    'Entry \'[_1]\' (ID:[_2]) status changed from [_3] to [_4]' => 'Status van bericht \'[_1]\' (ID:[_2]) aangepast van [_3] naar [_4]', # Translate - New (10)
    'You don\'t have permission to approve this comment.' => 'U heeft geen toestemming om deze reactie goed te keuren.',
    'Comment on missing entry!' => 'Reactie op ontbrekend bericht!',
    'Orphaned comment' => 'Verweesde reactie',
    'Orphaned' => 'Verweesd',
    'Plugin Set: [_1]' => 'Pluginset: [_1]',
    '<strong>[_1]</strong> is &quot;[_2]&quot;' => '<strong>[_1]</strong> is &quot;[_2]&quot;', # Translate - New (8)
    'TrackBack' => 'TrackBack', # Translate - Previous (1)
    'TrackBack Activity Feed' => 'TrackBackactiviteit-feed',
    'No Excerpt' => 'Geen uittreksel',
    'No Title' => 'Geen titel',
    'Orphaned TrackBack' => 'Verweesde TrackBack',
    'entry' => 'bericht',
    'category' => 'categorie',
    'Tag' => 'Tag', # Translate - Previous (1)
    'User' => 'Gebruiker',
    'Entry Status' => 'Status bericht', # Translate - New (2)
    '[_1] Feed' => '[_1] Feed', # Translate - New (3)
    '(user deleted - ID:[_1])' => '(gebruiker verwijderd - ID:[_1])', # Translate - New (5)
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Ongeldige datum \'[_1]\'; publicatiedatums moeten in het formaat JJJJ-MM-DD UU:MM:SS staan.',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => 'Ongeldige datum \'[_1]\'; berichtdatums moeten echte datums zijn.',
    'Saving entry \'[_1]\' failed: [_2]' => 'Bericht \'[_1]\' opslaan mislukt: [_2]',
    'Removing placement failed: [_1]' => 'Plaatsing verwijderen mislukt: [_1]',
    'Entry \'[_1]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => 'Bericht \'[_1]\' (ID:[_2]) aangepast en status gewijzigd van [_3] naar [_4] door gebruiker \'[_5]\'', # Translate - New (16)
    'Entry \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Bericht \'[_1]\' (ID:[_2]) aangepast door gebruiker \'[_3]\'', # Translate - New (8)
    'No such [_1].' => 'Geen [_1].', # Translate - New (3)
    'Same Basename has already been used. You should use an unique basename.' => 'Dezelfde basisnaam is al in gebruik.  U gebruikt best een unieke basisnaam.', # Translate - New (12)
    'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Er is nog geen sitepad en URL ingesteld voor uw weblog.  U kunt geen berichten publiceren voor deze zijn ingesteld.', # Translate - New (20)
    'Saving [_1] failed: [_2]' => 'Opslaan van [_1] mislukt: [_2]', # Translate - New (4)
    '[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) toegevoegd door gebruiker \'[_4]\'', # Translate - New (9)
    '[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt en status aangepast van [_4] naar [_5] door gebruiker \'[_6]\'', # Translate - New (17)
    '[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) bewerkt door gebruiker \'[_4]\'', # Translate - New (9)
    'The category label \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Het categorielabel \'[_1]\' conflicteert met een andere categorie.  Hoofdcategorieën en subcategorieën met een gedeelde ouder moeten unieke namen hebben.',
    'The [_1] must be given a name!' => 'De [_1] moet nog een naam krijgen!', # Translate - New (7)
    'Saving blog failed: [_1]' => 'Blog opslaan mislukt: [_1]',
    'Invalid ID given for personal blog clone source ID.' => 'Ongeldig ID opgegeven als kloonbron voor een persoonlijke weblog.', # Translate - New (9)
    'If personal blog is set, the default site URL and root are required.' => 'Als persoonlijke weblog is ingesteld, dan zijn de standaard URL en hoofdmap van de site vereist.', # Translate - New (13)
    'Feedback Settings' => 'Feedback instellingen',
    'Parse error: [_1]' => 'Ontleedfout: [_1]',
    'Build error: [_1]' => 'Opbouwfout: [_1]',
    'New [_1]' => 'Nieuwe [_1]', # Translate - New (2)
    'index template \'[_1]\'' => 'indexsjabloon \'[_1]\'',
    '[_1] \'[_2]\'' => '[_1] \'[_2]\'', # Translate - New (3)
    'No permissions' => 'Geen permissies',
    'Ping \'[_1]\' failed: [_2]' => 'Ping \'[_1]\' mislukt: [_2]',
    'Create New Role' => 'Nieuwe rol aanmaken',
    'Role name cannot be blank.' => 'Naam van de rol mag niet leeg zijn.',
    'Another role already exists by that name.' => 'Er bestaat al een rol met die naam.',
    'You cannot define a role without permissions.' => 'U kunt geen rol definiëren zonder permissies.',
    'No entry ID provided' => 'Geen bericht-ID opgegeven',
    'No such entry \'[_1]\'' => 'Geen bericht \'[_1]\'',
    'No email address for user \'[_1]\'' => 'Geen e-mail adres voor gebruiker \'[_1]\'',
    'No valid recipients found for the entry notification.' => 'Geen geldige ontvangers gevonden om op de hoogte te brengen van dit bericht.',
    '[_1] Update: [_2]' => '[_1] update: [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'Fout bij verzenden mail ([_1]); een andere MailTransfer instelling proberen?',
    'Upload File' => 'Opladen',
    'Can\'t load blog #[_1].' => 'Kan blog niet laden #[_1].', # Translate - New (5)
    'Before you can upload a file, you need to publish your blog.' => 'Voor u een bestand kunt opladen, moet u eerst uw weblog publiceren.', # Translate - New (12)
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
    'Search & Replace' => 'Zoeken & vervangen',
    'Logs' => 'Logs', # Translate - New (1)
    'Invalid date(s) specified for date range.' => 'Ongeldige datum(s) opgegeven in datumbereik.',
    'Error in search expression: [_1]' => 'Fout in zoekexpressie: [_1]',
    'Saving object failed: [_2]' => 'Object opslaan mislukt: [_2]',
    'You do not have export permissions' => 'U heeft geen exportpermissies',
    'You do not have permission to create users' => 'U heeft geen permissie om gebruikers aan te maken',
    'Importer type [_1] was not found.' => 'Importeertype [_1] niet gevonden.', # Translate - New (6)
    'Saving map failed: [_1]' => 'Map opslaan mislukt: [_1]',
    'Add a [_1]' => 'Voeg een [_1] toe', # Translate - New (3)
    'No label' => 'Geen label',
    'Category name cannot be blank.' => 'Categorienaam kan niet leeg zijn.',
    'Populating blog with default templates failed: [_1]' => 'Inrichten van blog met standaard sjablonen mislukt: [_1]',
    'Setting up mappings failed: [_1]' => 'Doorverwijzingen opzetten mislukt: [_1]',
    'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kan niet schrijven in de sjablooncache map. Gelieve de permissies na te kijken van de map met de naam <code>[_1]</code> onder de map van uw weblog.', # Translate - New (25)
    'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Fout: Movable Type kon geen map maken om uw dynamische sjablonen in te cachen. U moet een map aanmaken met de naam <code>[_1]</code> onder de map van uw weblog.', # Translate - New (28)
    'That action ([_1]) is apparently not implemented!' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd!',
    'That action ([_1]) is apparently not implemented?' => 'Die handeling ([_1]) is blijkbaar niet geïmplementeerd?', # Translate - New (7)
    'Error saving entry: [_1]' => 'Fout bij opslaan bericht: [_1]',
    'Select Blog' => 'Selecteer blog', # Translate - New (2)
    'Selected Blog' => 'Geselecteerde blog', # Translate - New (2)
    'Type a blog name to filter the choices below.' => 'Typ de naam van een weblog in om de onderstaande keuzes te filteren.', # Translate - New (9)
    'Blog Name' => 'Blognaam',
    'Select a System Administrator' => 'Selecteer een systeembeheerder', # Translate - New (4)
    'Selected System Administrator' => 'Geselecteerde systeembeheerder', # Translate - New (3)
    'Type a user name to filter the choices below.' => 'Typ een gebruikersnaam in om onderstaande keuzes te filteren', # Translate - New (9)
    'System Administrator' => 'Systeembeheerder',
    'Error saving file: [_1]' => 'Fout bij opslaan bestand: [_1]', # Translate - New (4)
    'represents a user who will be created afterwards' => 'stelt een gebruiker voor die later zal worden aangemaakt', # Translate - New (8)
    'Select Blogs' => 'Selecteer blogs', # Translate - New (2)
    'Blogs Selected' => 'Geselecteerde blogs', # Translate - New (2)
    'Group Name' => 'Groepsnaam',
    'Select Roles' => 'Selecteer rollen',
    'Role Name' => 'Naam rol',
    'Roles Selected' => 'Geselecteerde rollen',
    'Create an Association' => 'Maak een associatie aan',
    'Backup & Restore' => 'Backup & Restore', # Translate - New (2)
    'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om backups te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken.', # Translate - New (16)
    'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'De tijdelijke map moet beschrijfbaar zijn om restore-operaties te kunnen doen.  Gelieve de TempDir configuratiedirectief na te kijken', # Translate - New (16)
    'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Blog(s) (ID:[_1]) werden met succes gebackupt door gebruiker \'[_2]\'', # Translate - New (12)
    'Movable Type system was successfully backed up by user \'[_1]\'' => 'Movable Type systeem werd met succes gebackupt door gebruiker \'[_1]\'', # Translate - New (10)
    'You must select what you want to backup.' => 'U moet selecteren wat u wenst te backuppen.', # Translate - New (8)
    '[_1] is not a number.' => '[_1] is geen getal.', # Translate - New (6)
    'Choose blogs to backup.' => 'Kies blogs om te backuppen.', # Translate - New (4)
    'Archive::Tar is required to archive in tar.gz format.' => 'Archive::Tar is vereist voor een archief in tar.gz formaat.', # Translate - New (10)
    'IO::Compress::Gzip is required to archive in tar.gz format.' => 'IO::Compress::Gzip is vereist voor een archief in tar.gz formaat.', # Translate - New (11)
    'Archive::Zip is required to archive in zip format.' => 'Archive::Zip is vereist om te archiveren in zip formaat.', # Translate - New (9)
    'Specified file was not found.' => 'Het opgegeven bestand werd niet gevonden.', # Translate - New (5)
    '[_1] successfully downloaded backup file ([_2])' => '[_1] downloadde met succes backupbestand ([_2])', # Translate - New (7)
    'Restore' => 'Restore', # Translate - New (1)
    'Required modules (Archive::Tar and/or IO::Uncompress::Gunzip) are missing.' => 'Vereiste modules (Archive::Tar en/of IO::Uncompress::Gunzip) ontbreken.', # Translate - New (11)
    'Uploaded file was invalid: [_1]' => 'Opgeladen bestand was niet geldig: [_1]', # Translate - New (5)
    'Required module (Archive::Zip) is missing.' => 'Vereiste module (Archive::Zip) ontbreekt.', # Translate - New (6)
    'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Gelieve xml, tar.gz, zip, of manifest te gebruiken als bestandsextensies.', # Translate - New (12)
    'Some [_1] were not restored because their parent objects were not restored.' => 'Een aantal [_1] werden niet teruggezet omdat hun ouderobjecten niet werden teruggezet.', # Translate - New (12)
    'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Objecten werden met succes teruggezet in het Movable Type systeem door gebruiker \'[_1]\'', # Translate - New (10)
    '[_1] is not a directory.' => '[_1] is geen map.', # Translate - New (6)
    'Error occured during restore process.' => 'Er deed zich een fout voor tijdens het restore-proces.', # Translate - New (5)
    'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ', # Translate - New (3)
    'Some of files could not be restored.' => 'Een aantal bestanden konden niet worden teruggezet.', # Translate - New (7)
    'Uploaded file was not a valid Movable Type backup manifest file.' => 'Het opgeladen bestand was geen geldig Movable Type backup manifest bestand.', # Translate - New (11)
    'Please upload [_1] in this page.' => 'Gelieve [_1] op te laden op deze pagina.', # Translate - New (6)
    'File was not uploaded.' => 'Bestand werd niet opgeladen.', # Translate - New (4)
    'Restoring a file failed: ' => 'Terugzetten van een bestand mislukt: ', # Translate - New (4)
    'Some objects were not restored because their parent objects were not restored.' => 'Sommige objecten werden niet teruggezet omdat hun ouder-objecten niet werden teruggezet.', # Translate - New (12)
    'Some of the files were not restored correctly.' => 'Een aantal bestanden werden niet correct teruggezet.', # Translate - New (8)
    '[_1] has canceled the multiple files restore operation prematurely.' => '[_1] heeft de terugzet-operatie van meerdere bestanden voortijdig afgebroken.', # Translate - New (10)
    'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het aanpassen...', # Translate - New (9)
    'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Sitepad voor blog \'[_1]\' (ID:[_2]) aan het verwijderen...', # Translate - New (9)
    '\nChanging Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nArchiefpad voor blog \'[_1]\' (ID:[_2]) aan het wijzigen...', # Translate - New (10)
    '\nRemoving Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\nArchiefpad voor blog \'[_1]\' (ID:[_2]) aan het verwijderen...', # Translate - New (10)
    'Some of the actual files for assets could not be restored.' => 'Een aantal van de mediabestanden konden niet teruggezet worden.', # Translate - New (11)
    'Parent comment id was not specified.' => 'ID van ouder-reactie werd niet opgegeven.', # Translate - New (6)
    'Parent comment was not found.' => 'Ouder-reactie werd niet gevonden.', # Translate - New (5)
    'You can\'t reply to unapproved comment.' => 'U kunt niet antwoorden op een niet-gekeurde reactie.', # Translate - New (7)
    'entries' => 'berichten',

    ## ./lib/MT/App/Comments.pm
    'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Fout bij het toekennen van reactierechten aan gebruiker \'[_1] (ID: [_2])\' op weblog \'[_3] (ID: [_4])\'.  Er werd geen geschikte reageerder-rol gevonden.', # Translate - New (20)
    'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Ongeldige aanmeldpoging van een reageerder [_1] op blog [_2](ID: [_3]) waar geenMovable Type native authenticatie is toegelaten.', # Translate - New (19)
    'Login failed: permission denied for user \'[_1]\'' => 'Aanmelden mislukt: permissie geweigerd aan gebruiker \'[_1]\'', # Translate - New (7)
    'Login failed: password was wrong for user \'[_1]\'' => 'Aanmelden mislukt: fout in wachtwoord van gebruiker \'[_1]\'', # Translate - New (8)
    'Signing up is not allowed.' => 'Registreren is niet toegestaan.', # Translate - New (5)
    'Passwords do not match.' => 'Wachtwoorden komen niet overeen.',
    'User requires username.' => 'Gebruiker heeft gebruikersnaam nodig.', # Translate - New (3)
    'User requires display name.' => 'Gebruiker heeft getoonde naam nodig.', # Translate - New (4)
    'User requires password.' => 'Gebruiker heeft wachtwoord nodig.', # Translate - New (3)
    'User requires password recovery word/phrase.' => 'Gebruiker heeft woord/zin om het wachtwoord terug te vinden nodig.', # Translate - New (6)
    'Email Address is invalid.' => 'E-mail adres is ongeldig.', # Translate - New (4)
    'Email Address is required for password recovery.' => 'E-mail adres is vereist om het wachtwoord te kunnen terugvinden.', # Translate - New (7)
    'URL is invalid.' => 'URL is ongeldig.', # Translate - New (3)
    'Text entered was wrong.  Try again.' => 'De ingevoerde tekst was verkeerd.  Probeer opnieuw.', # Translate - New (6)
    'Something wrong happened when trying to process signup: [_1]' => 'Er ging iets mis bij het verwerken van de registratie: [_1]', # Translate - New (9)
    'Movable Type Account Confirmation' => 'Movable Type accountbevestiging', # Translate - New (4)
    'System Email Address is not configured.' => 'Systeem e-mail adres is niet ingesteld.', # Translate - New (6)
    'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Reageerder \'[_1]\' (ID:[_2]) heeft zich met succes geregistreerd.', # Translate - New (8)
    'Thanks for the confirmation.  Please sign in to comment.' => 'Bedankt voor de bevestiging.  Gelieve u aan te melden om te reageren.', # Translate - New (9)
    '[_1] registered to the blog \'[_2]\'' => '[_1] geregistreerd op blog \'[_2]\'', # Translate - New (7)
    'No id' => 'Geen id',
    'No such comment' => 'Reactie niet gevonden',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] verbannen omdat aantal reacties hoger was dan 8 in [_2] seconden.',
    'IP Banned Due to Excessive Comments' => 'IP verbannen wegens excessief achterlaten van reacties',
    'No such entry \'[_1]\'.' => 'Geen bericht \'[_1]\'.',
    'You are not allowed to add comments.' => 'U heeft geen toestemming om reacties toe te voegen.', # Translate - New (7)
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
    'Failed comment attempt by pending registrant \'[_1]\'' => 'Mislukte poging om een reactie achter te laten van op registratie wachtende gebruiker \'[_1]\'', # Translate - New (7)
    'Registered User' => 'Geregistreerde gebruiker', # Translate - New (2)
    'New Comment Added to \'[_1]\'' => 'Nieuwe reactie achtergelaten op \'[_1]\'', # Translate - New (5)
    'The sign-in attempt was not successful; please try again.' => 'Aanmeldingspoging mislukt; gelieve opnieuw te proberen.',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'De validering bij het aanmelden is mislukt. Gelieve u ervan te vergewissen dat uw weblog goed is ingesteld en probeer opnieuw.',
    'No such entry ID \'[_1]\'' => 'Geen bericht-ID \'[_1]\'',
    'You must define an Individual template in order to ' => 'U moet een individueel sjabloon definiëren om ',
    'You must define a Comment Listing template in order to ' => 'U moet een sjabloon voor een lijst reacties definiëren om ',
    'No entry was specified; perhaps there is a template problem?' => 'Geen bericht opgegeven; misschien is er een sjabloonprobleem?',
    'Somehow, the entry you tried to comment on does not exist' => 'Het bericht waar u een reactie op probeerde achter te laten, bestaat niet',
    'You must define a Comment Error template.' => 'U moet een sjabloon definiëren voor foutboodschappen.',
    'You must define a Comment Preview template.' => 'U moet een sjabloon definiëren voor het bekijken van voorbeelden van reacties.',
    'Invalid commenter ID' => 'Ongeldig reageerder-ID', # Translate - New (3)
    'Permission denied' => 'Permissie geweigerd',
    'All required fields must have valid values.' => 'Alle vereiste velden moeten geldige waarden bevatten.', # Translate - New (7)
    'Commenter profile has successfully been updated.' => 'Reageerdersprofiel is met succes bijgewerkt.', # Translate - New (6)
    'Commenter profile could not be updated: [_1]' => 'Reageerdersprofiel kon niet worden bijgewerkt: [_1]', # Translate - New (7)
    'You can\'t reply to unpublished comment.' => 'U kunt niet reageren op een niet gepubliceerde reactie.', # Translate - New (7)
    'Your session has been ended.  Cancel the dialog and login again.' => 'Uw sessie is beëindigd.  Annuleer de dialoog en meld opnieuw aan.', # Translate - New (11)
    'Comment Detail' => 'Details reactie', # Translate - New (2)

    ## ./lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'Gelieve een geldig e-mail adres op te geven.',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Ontbrekende parameter: blog_id. Gelieve de handleiding te raadplegen om waarschuwingen te configureren.',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Er werd een ongeldige redirect parameter opgegeven. De eigenaar van de weblog moet een pad opgeven dat overeenkomt met het domein van de weblog.',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Het e-mail adres \'[_1]\' zit reeds in de notificatielijst voor deze weblog.',
    'Please verify your email to subscribe' => 'Gelieve uw e-mail adres te verifiëren voor inschrijving',
    'The address [_1] was not subscribed.' => 'Het adres [_1] werd niet ingeschreven.',
    'The address [_1] has been unsubscribed.' => 'Het adres [_1] werd uitgeschreven.',

    ## ./lib/MT/App/Search.pm
    'You are currently performing a search. Please wait ' => 'Bezig met zoeken. Even geduld ',
    'Search failed. Invalid pattern given: [_1]' => 'Zoeken mislukt. Ongeldig patroon opgegeven: [_1]',
    'Search failed: [_1]' => 'Zoeken mislukt: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => 'Er is geen alternatief sjabloon opgegeven voor sjabloon \'[_1]\'',
    'Opening local file \'[_1]\' failed: [_2]' => 'Lokaal bestand \'[_1]\' openen mislukt: [_2]',
    'Building results failed: [_1]' => 'Resultaten opbouwen mislukt: [_1]',
    'Search: query for \'[_1]\'' => 'Zoeken: zoekopdracht voor \'[_1]\'',
    'Search: new comment search' => 'Zoeken: opnieuw zoeken in de reacties',

    ## ./lib/MT/App/Trackback.pm
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

    ## ./lib/MT/App/Upgrader.pm
    'The initial account name is required.' => 'De oorspronkelijke accountnaam is vereist.',
    'Failed to authenticate using given credentials: [_1].' => 'Authenticatie met de opgegeven aanmeldgegevens mislukt: [_1].',
    'You failed to validate your password.' => 'Het valideren van uw wachtwoord is mislukt.',
    'You failed to supply a password.' => 'U gaf geen wachtwoord op.',
    'The e-mail address is required.' => 'Het e-mail adres is vereist.',
    'Password recovery word/phrase is required.' => 'Woord/uitdrukking om uw wachtwoord terug te vinden is vereist.',
    'Invalid session.' => 'Ongeldige sessie.',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Geen permissies.  Gelieve uw administrator te contacteren om Movable Type te upgraden.',

    ## ./lib/MT/App/Viewer.pm
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

    ## ./lib/MT/App/Wizard.pm
    'The [_1] database driver is required to use [_2].' => 'De [_1] databasedriver is vereist om [_2] te kunnen gebruiken.', # Translate - New (9)
    'The [_1] driver is required to use [_2].' => 'De [_1] driver is vereist om [_2] te kunnen gebruiken.', # Translate - New (8)
    'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Er deed zich een fout voor bij het verbinen met de database.  Controleer de instellingen en probeer opnieuw.', # Translate - New (16)
    'SMTP Server' => 'SMTP server', # Translate - Previous (2)
    'Sendmail' => 'Sendmail', # Translate - Previous (1)
    'Test email from Movable Type Configuration Wizard' => 'Test e-mail van de Movable Type Configuratiewizard',
    'This is the test email sent by your new installation of Movable Type.' => 'Dit is de test e-mail verstuurd door uw nieuwe installatie van Movable Type.',

    ## ./lib/MT/Asset/Image.pm
    'Image' => 'Afbeelding', # Translate - New (1)
    'Images' => 'Afbeeldingen', # Translate - New (1)
    'Actual Dimensions' => 'Echte afmetingen', # Translate - New (2)
    '[_1] wide, [_2] high' => '[_1] breed, [_2] hoog', # Translate - New (5)
    'Error scaling image: [_1]' => 'Fout bij het schalen van de afbeelding: [_1]', # Translate - New (4)
    'Error creating thumbnail file: [_1]' => 'Fout bij het aanmaken van een thumbnail-bestand: [_1]', # Translate - New (5)
    'Can\'t load image #[_1]' => 'Kan afbeelding niet laden #[_1]', # Translate - New (5)
    'View image' => 'Afbeelding bekijken',
    'Permission denied setting image defaults for blog #[_1]' => 'Permissie geweigerd om de standaardinstellingen voor afbeeldingen te wijzigen voor blog #[_1]', # Translate - New (8)
    'Thumbnail failed: [_1]' => 'Verkleinde afbeelding mislukt: [_1]',
    'Invalid basename \'[_1]\'' => 'Ongeldige basisnaam \'[_1]\'',
    'Error writing to \'[_1]\': [_2]' => 'Fout bij schrijven naar \'[_1]\': [_2]',

    ## ./lib/MT/Auth/BasicAuth.pm

    ## ./lib/MT/Auth/LiveJournal.pm

    ## ./lib/MT/Auth/MT.pm
    'Failed to verify current password.' => 'Verificatie huidig wachtwoord mislukt.',
    'Password hint is required.' => 'Wachtwoordhint is vereist.',

    ## ./lib/MT/Auth/OpenID.pm
    'Could not discover claimed identity: [_1]' => 'Kon geclaimde identiteit niet ontdekken: [_1]', # Translate - New (6)

    ## ./lib/MT/Auth/TypeKey.pm
    'Sign in requires a secure signature.' => 'Aanmelden vereist een beveiligde handtekening.', # Translate - New (6)
    'The sign-in validation failed.' => 'Validatie van het aanmelden mislukt.',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.  Als u dat wenst kunt u zich opnieuw aanmelden en de authenticatiedienst toestemming verlenen om uw e-mail adres door te geven.',
    'This weblog requires commenters to pass an email address' => 'Deze weblog vereist dat reageerders een e-mail adres opgeven.',
    'Couldn\'t get public key from url provided' => 'Kon geen publieke sleutel vinden via de opgegeven url',
    'No public key could be found to validate registration.' => 'Er kon geen publieke sleutel gevonden worden om de registratie te valideren.',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey signatuurverificatie gaf [_1] terug in [_2] seconden bij het verifiëren van [_3] met [_4]',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'De TypeKey signatuur is vervallen ([_1] seconden oud). Controleer of de klok van uw server juist staat',

    ## ./lib/MT/Auth/Vox.pm

    ## ./lib/MT/BackupRestore/BackupFileHandler.pm
    'Uploaded file was backed up from Movable Type with the newer schema version ([_1]) than the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Het opgeladen bestand werd gebackupt vanuit Movable Type met een nieuwere schemaversie ([_1]) dan die van dit systeem ([_2]).  Het is niet veilig dit bestand terug te zetten op deze versie van Movable Type.', # Translate - New (35)
    '[_1] is not a subject to be restored by Movable Type.' => '[_1] is geen item dat door Movable Type teruggezet moet worden.', # Translate - New (12)
    '[_1] records restored.' => '[_1] records teruggezet.', # Translate - New (4)
    'Restoring [_1] records:' => '[_1] records aan het terugzetten:', # Translate - New (3)
    'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Een gebruiker met dezelfde naam \'[_1]\' werd gevonden (ID:[_2]).  Restore verving deze gebruiker door de data uit de backup.', # Translate - New (18)
    'Tag \'[_1]\' exists in the system.\n' => 'Tag \'[_1]\' bestaat in het systeem.\n', # Translate - New (7)
    'Trackback for entry (ID: [_1]) already exists in the system.\n' => 'Trackback voor bericht (ID: [_1]) bestaat al in het systeem.\n', # Translate - New (11)
    'Trackback for category (ID: [_1]) already exists in the system.\n' => 'Trackback voor categorie (ID: [_1]) bestaat al in het systeem.\n', # Translate - New (11)
    '[_1] records restored...' => '[_1] records teruggezet...', # Translate - New (4)

    ## ./lib/MT/BackupRestore/ManifestFileHandler.pm

    ## ./lib/MT/Compat/v3.pm
    'uses: [_1], should use: [_2]' => 'gebruikt: [_1], zou moeten gebruiken: [_2]', # Translate - New (5)
    'uses [_1]' => 'gebruikt [_1]', # Translate - New (2)
    'No executable code' => 'Geen uitvoerbare code',
    'Rebuild-option name must not contain special characters' => 'Naam van de herbouwoptie mag geen speciale karakters bevatten',

    ## ./lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'DAV verbinding mislukt: [_1]',
    'DAV open failed: [_1]' => 'DAV open mislukt: [_1]',
    'DAV get failed: [_1]' => 'DAV get mislukt: [_1]',
    'DAV put failed: [_1]' => 'DAV put mislukt: [_1]',
    'Deleting \'[_1]\' failed: [_2]' => 'Verwijderen van \'[_1]\' mislukt: [_2]',
    'Creating path \'[_1]\' failed: [_2]' => 'Aanmaken van pad \'[_1]\' mislukt: [_2]',
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Herbenoemen van \'[_1]\' naar \'[_2]\' mislukt: [_3]',

    ## ./lib/MT/FileMgr/FTP.pm

    ## ./lib/MT/FileMgr/Local.pm

    ## ./lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'SFTP verbinding mislukt: [_1]',
    'SFTP get failed: [_1]' => 'SFTP get mislukt: [_1]',
    'SFTP put failed: [_1]' => 'SFTP put mislukt: [_1]',

    ## ./lib/MT/I18N/default.pm

    ## ./lib/MT/I18N/en_us.pm

    ## ./lib/MT/I18N/ja.pm

    ## ./lib/MT/L10N/de.pm

    ## ./lib/MT/L10N/en_us.pm

    ## ./lib/MT/L10N/es.pm

    ## ./lib/MT/L10N/fr.pm

    ## ./lib/MT/L10N/ja.pm

    ## ./lib/MT/L10N/nl.pm

    ## ./lib/MT/ObjectDriver/DDL.pm

    ## ./lib/MT/ObjectDriver/SQL.pm

    ## ./lib/MT/ObjectDriver/DDL/mysql.pm

    ## ./lib/MT/ObjectDriver/DDL/Pg.pm

    ## ./lib/MT/ObjectDriver/DDL/SQLite.pm

    ## ./lib/MT/ObjectDriver/Driver/DBI.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/Legacy.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/mysql.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/Pg.pm

    ## ./lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

    ## ./lib/MT/ObjectDriver/SQL/mysql.pm

    ## ./lib/MT/ObjectDriver/SQL/Pg.pm

    ## ./lib/MT/ObjectDriver/SQL/SQLite.pm

    ## ./lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'wegens regel',
    'from test' => 'wegens test',

    ## ./lib/MT/Plugin/L10N.pm

    ## ./lib/MT/Template/Context.pm
    'The attribute exclude_blogs cannot take \'all\' for a value.' => 'Het attribuut exclude_blogs kan niet \'all\' hebben als waarde.',

    ## ./lib/MT/Template/ContextHandlers.pm
    'Recursion attempt on [_1]: [_2]' => 'Recursiepoging op [_1]: [_2]', # Translate - New (5)
    'Can\'t find included template [_1] \'[_2]\'' => 'Kan geincludeerd sjabloon niet vinden: [_1] \'[_2]\'', # Translate - New (7)
    'Can\'t find blog for id \'[_1]' => 'Kan geen blog vinden met id \'[_1]',
    'Can\'t find included file \'[_1]\'' => 'Kan geïncludeerd bestand \'[_1]\' niet vinden',
    'Error opening included file \'[_1]\': [_2]' => 'Fout bij het openen van geïncludeerd bestand \'[_1]\': [_2]',
    'Recursion attempt on file: [_1]' => 'Recursiepoging op bestand: [_1]', # Translate - New (5)
    'Unspecified archive template' => 'Niet gespecifiëerd archiefsjabloon',
    'Error in file template: [_1]' => 'Fout in bestandssjabloon: [_1]',
    'Can\'t load template' => 'Kan sjabloon niet laden', # Translate - New (4)
    'Can\'t find template \'[_1]\'' => 'Kan sjabloon \'[_1]\' niet vinden',
    'Can\'t find entry \'[_1]\'' => 'Kan bericht \'[_1]\' niet vinden',
    '[_1] [_2]' => '[_1] [_2]', # Translate - Previous (3)
    'You used a [_1] tag without any arguments.' => 'U gebruikte een [_1] tag zonder argumenten.',
    'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.', # Translate - New (10)
    'You have an error in your \'[_2]\' attribute: [_1]' => 'Er staat een fout in uw \'[_2]\' attribuut: [_1]', # Translate - New (9)
    'You have an error in your \'tag\' attribute: [_1]' => 'Er zit een fout in uw \'tag\' attribuut: [_1]',
    'No such user \'[_1]\'' => 'Geen gebruiker \'[_1]\'',
    'You used an \'[_1]\' tag outside of the context of an entry; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een bericht; ',
    'You used <$MTEntryFlag$> without a flag.' => 'U gebruikte <$MTEntryFlag$> zonder een vlag.',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'U gebruikte een [_1] tag om te linken naar \'[_2]\' archieven, maar dat type archieven wordt niet gepubliceerd.',
    'Could not create atom id for entry [_1]' => 'Kon geen atom id aanmaken voor bericht [_1]',
    'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.', #  (13)
    'To enable comment registration, you need to add a TypeKey token in your weblog config or user profile.' => 'Om registratie van reacties in te schakelen, moet u een TypeKey token toevoegen in de configuratie van uw weblog of in uw gebruikersprofiel.',
    '(You may use HTML tags for style)' => '(U mag HTML tags gebruiken voor de stijl)',
    'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',
    'You used an \'[_1]\' tag outside of the context of a comment; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een reactie; ',
    'You used an [_1] without a date context set up.' => 'U gebruikte een [_1] zonder dat er een datumcontext ingesteld was.',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] kan enkel worden gebruikt met dagelijkse, wekelijkse of maandelijkse archieven.',
    'Group iterator failed.' => 'Group iterator mislukt.',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly ' => 'U gebruikte een [_1] tag buiten een dagelijkse, wekelijkse of maandelijkse ',
    'Could not determine entry' => 'Kon bericht niet bepalen',
    'Invalid month format: must be YYYYMM' => 'Ongeldig maandformaat: moet JJJJMM zijn',
    'No such category \'[_1]\'' => 'Geen categorie \'[_1]\'',
    '<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> moet gebruikt worden in een categorie, of met het \'category\' attribuute van de tag.',
    'You failed to specify the label attribute for the [_1] tag.' => 'U gaf geen label attribuut op voor de [_1] tag.',
    'You used an \'[_1]\' tag outside of the context of ' => 'U gebruikte een \'[_1]\' tag buiten de context van ',
    'MTSubCatsRecurse used outside of MTSubCategories' => 'MTSubCatsRecurse gebruikt buiten MTSubCategories',
    'MTSubFolderRecurse used outside of MTSubFolders' => 'MTSubFolderRecurse gebruikt buiten MTSubFolders', # Translate - New (5)
    'MT[_1] must be used in a [_2] context' => 'MT[_1] moet gebruikt worden in een [_2] context', # Translate - New (9)
    'Cannot find package [_1]: [_2]' => 'Kan package [_1] niet vinden: [_2]',
    'Error sorting [_2]: [_1]' => 'Fout bij sorteren [_2]: [_1]', # Translate - New (4)
    'You used an \'[_1]\' tag outside of the context of an asset; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een mediabestand; ', # Translate - New (12)
    'You used an \'[_1]\' tag outside of the context of an page; ' => 'U gebruikte een \'[_1]\' tag buiten de context van een pagina; ', # Translate - New (12)
    'You used an [_1] without a author context set up.' => 'U gebruikte een [_1] zonder een auteurscontext op te zetten.', # Translate - New (10)
    'Can\'t load blog.' => 'Kan blog niet laden.', # Translate - New (4)
    'Can\'t load user.' => 'Kan gebruiker niet laden.', # Translate - New (4)

    ## ./lib/MT/Util/Captcha.pm
    'Captcha' => 'Captcha', # Translate - New (1)
    'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.', # Translate - New (9)
    'You need to configure CaptchaSourceImagebase.' => 'U moet CaptchaSourceImagebase nog configureren.', # Translate - New (5)
    'Image creation failed.' => 'Afbeelding aanmaken mislukt.', # Translate - New (3)
    'Image error: [_1]' => 'Afbeelding fout: [_1]', # Translate - New (3)

    ## ./mt-static/mt.js
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
    'to ' => 'te ',
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
    'Enter email address:' => 'Voer e-mail adres in:',
    'Enter URL:' => 'Voer URL in:',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen?',
    'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'De tag \'[_2]\' bestaat al.  Bent u zeker dat u \'[_1]\' met \'[_2]\' wenst samen te voegen over alle weblogs?',
    'Showing: [_1] &ndash; [_2] of [_3]' => 'Getoond: [_1] &ndash; [_2] van [_3]',
    'Showing: [_1] &ndash; [_2]' => 'Getoond: [_1] &ndash; [_2]',

    ## ./plugins/Cloner/cloner.pl
    'No weblog was selected to clone.' => 'Er werd geen weblog geselecteerd om te klonen.',
    'This action can only be run for a single weblog at a time.' => 'Deze actie kan maar op één weblog per keer uitgevoerd worden.',
    'Invalid blog_id' => 'Ongeldig blog_id',

    ## ./plugins/ExtensibleArchives/AuthorArchive.pl
    'Author #[_1]' => 'Auteur #[_1]', # Translate - New (2)
    'AUTHOR_ADV' => 'Auteur', # Translate - New (2)
    'Author #[_1]: ' => 'Auteur #[_1]: ', # Translate - New (2)
    'AUTHOR-YEARLY_ADV' => 'Auteur per jaar', # Translate - New (2)
    'AUTHOR-MONTHLY_ADV' => 'Auteur per maand', # Translate - New (2)
    'AUTHOR-WEEKLY_ADV' => 'Auteur per week', # Translate - New (2)
    'AUTHOR-DAILY_ADV' => 'Auteur per dag', # Translate - New (2)

    ## ./plugins/ExtensibleArchives/DatebasedCategories.pl
    'CATEGORY-YEARLY_ADV' => 'Categorie per jaar', # Translate - New (2)
    'CATEGORY-MONTHLY_ADV' => 'Categorie per maand', # Translate - New (2)
    'CATEGORY-DAILY_ADV' => 'Categorie per dag', # Translate - New (2)
    'CATEGORY-WEEKLY_ADV' => 'Categorie per week', # Translate - New (2)

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N.pm

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N/en_us.pm

    ## ./plugins/ExtensibleArchives/lib/AuthorArchive/L10N/ja.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N/en_us.pm

    ## ./plugins/ExtensibleArchives/lib/DatebasedCategoriesArchive/L10N/ja.pm

    ## ./plugins/feeds-app-lite/mt-feeds.pl
    '\'[_1]\' is a required argument of [_2]' => '\'[_1]\' is een verplicht argument van [_2]',
    'MT[_1] was not used in the proper context.' => 'MT[_1] werd niet gebruikt in de juiste context.',

    ## ./plugins/feeds-app-lite/lib/MT/App/FeedsWidget.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Find.pm

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
    'An error occurred processing [_1]. ' => 'Er gebeurde een fout tijdens het verwerken van [_1]. ',

    ## ./plugins/feeds-app-lite/lib/MT/Feeds/Lite/CacheMgr.pm

    ## ./plugins/GoogleSearch/GoogleSearch.pl
    'You used [_1] without a query.' => 'U gebruikte [_1] zonder query.',
    'You need a Google API key to use [_1]' => 'U heeft een Google API key nodig om [_1] te gebruiken',
    'You used a non-existent property from the result structure.' => 'U gebruikte een onbestaande eigenschap van de resultaatstructuur.',

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/de.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/en_us.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/es.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/fr.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/ja.pm

    ## ./plugins/GoogleSearch/lib/GoogleSearch/L10N/nl.pm

    ## ./plugins/Markdown/Markdown.pl

    ## ./plugins/Markdown/SmartyPants.pl

    ## ./plugins/MultiBlog/multiblog.pl
    '* All Weblogs' => '* Alle weblogs',
    'Select to apply this trigger to all weblogs' => 'Selecteren om deze trigger op alle weblogs toe te passen',
    'MultiBlog' => 'MultiBlog', # Translate - Previous (1)
    'Create New Trigger' => 'Nieuwe trigger aanmaken',
    'Weblog Name' => 'Weblognaam',
    'Search Weblogs' => 'Weblogs zoeken',
    'When this' => 'Wanneer deze',
    'saves an entry' => 'een bericht opslaat',
    'publishes an entry' => 'een bericht publiceert',
    'publishes a comment' => 'een reactie publiceert',
    'publishes a ping' => 'een ping publiceert',
    'rebuild indexes.' => 'indexen herbouwt.',
    'rebuild indexes and send pings.' => 'indexen herbouwt en pings stuurt.',

    ## ./plugins/MultiBlog/lib/MultiBlog.pm
    'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'De include_blogs, exclude_blogs, blog_ids en blog_id attributen kunnen niet samen gebruikt worden.',
    'The attribute exclude_blogs cannot take "all" for a value.' => 'Het attribuut exclude_blogs kan niet de waarde "all" hebben.',
    'The value of the blog_id attribute must be a single blog ID.' => 'De waarde in het blog_id attribuut moet één blog ID zijn.',
    'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'De waarde in de include_blogs/exclude_blogs attributen moet één of meer blog IDs zijn, gescheiden door komma\'s.',

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/en_us.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/L10N/ja.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/LocalBlog.pm

    ## ./plugins/MultiBlog/lib/MultiBlog/Tags/MultiBlog.pm
    'MTMultiBlog tags cannot be nested.' => 'MTMultiBlog tags kunnen niet genest worden.',
    'Unknown "mode" attribute value: [_1]. ' => 'Onbekende waarde voor het "mode" attribuut: [_1]. ',

    ## ./plugins/spamlookup/spamlookup.pl

    ## ./plugins/spamlookup/spamlookup_urls.pl

    ## ./plugins/spamlookup/spamlookup_words.pl

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

    ## ./plugins/StyleCatcher/stylecatcher.pl
    'Unable to create the theme root directory. Error: [_1]' => 'Aanmaken van de thema-hoofdmap mislukt. Fout: [_1]',
    'Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?' => 'Onmogelijk om base-weblog.css weg te schrijven naar thema-hoofdmap.  FileManager gaf volgende fout: [_1].  Bent u zeker dat uw thema-hoofdmap beschrijfbaar is door de webserver?',

    ## ./plugins/StyleCatcher/lib/StyleCatcher.pm
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcher moet eerst geconfigureerd zijn voor het hele systeem voor het gebruikt kan worden.',
    'Configure plugin' => 'Plugin configureren',
    'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Kon map [_1] niet aanmaken - Controleer of uw \'themes\' map beschrijfbaar is voor de webserver.',
    'Successfully applied new theme selection.' => 'Nieuwe thema-selectie met succes toegepast.',

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/de.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/en_us.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/es.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/fr.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/ja.pm

    ## ./plugins/StyleCatcher/lib/StyleCatcher/L10N/nl.pm

    ## ./plugins/TemplateRefresh/TemplateRefresh.pl
    'Error loading default templates.' => 'Fout bij het laden van standaardsjablonen.',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'Onvoldoende permissies om de sjabonen te bewerken van weblog \'[_1]\'',
    'Processing templates for weblog \'[_1]\'' => 'Sjablonen voor weblog \'[_1]\' worden verwerkt',
    'Refreshing template \'[_1]\'.' => 'Sjabloon \'[_1]\' wordt ververst.',
    'Error creating new template: ' => 'Fout bij aanmaken nieuw sjabloon: ',
    'Created template \'[_1]\'.' => 'Sjabloon \'[_1]\' aangemaakt.',
    'Insufficient permissions for modifying templates for this weblog.' => 'Onvoldoende permissies voor het bewerken van de sjablonen van deze weblog.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Sjabloon \'[_1]\' wordt overgeslagen, omdat het blijkbaar een gepersonaliseerd sjabloon is.',

    ## ./plugins/Textile/textile2.pl

    ## ./plugins/Textile/lib/Text/Textile.pm

    ## ./plugins/WidgetManager/WidgetManager.pl
    'Failed to find WidgetManager::Plugin::[_1]' => 'Vinden van WidgetManager::Plugin::[_1] mislukt',

    ## ./plugins/WidgetManager/lib/WidgetManager/CMS.pm
    'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'Kan de bestaande \'[_1]\' WidgetManager niet dupliceren. Gelieve terug te gaan en een unieke naam in te geven.',
    'Widget Manager' => 'Widget Manager', # Translate - Previous (2)
    'Moving [_1] to list of installed modules' => '[_1] wordt verplaatst naar de lijst van geïnstalleerde modules',
    'First Widget Manager' => 'Eerste Widget Manager',

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/Plugin.pm
    'No WidgetManager modules exist for blog \'[_1]\'.' => 'Er zijn geen WidgetManager modules voor blog \'[_1]\'.', # Translate - New (7)
    'WidgetManager \'[_1]\' has no installed widgets.' => 'WidgetManager \'[_1]\' heeft geen geïnstalleerde widgets.', # Translate - New (6)
    'Can\'t find included template module \'[_1]\'' => 'Kan de geïncludeerde sjabloonmodule \'[_1]\' niet vinden',

    ## ./plugins/WidgetManager/lib/WidgetManager/Util.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/de.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/en_us.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/es.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/fr.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/ja.pm

    ## ./plugins/WidgetManager/lib/WidgetManager/L10N/nl.pm

    ## ./plugins/WXRImporter/WXRImporter.pl

    ## ./plugins/WXRImporter/lib/WXRImporter/Import.pm

    ## ./plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
    'File is not in WXR format.' => 'Bestand is niet in WXR formaat.', # Translate - New (6)
    'Saving asset (\'[_1]\')...' => 'Bezig met opslaan mediabestand (\'[_1]\')...', # Translate - New (3)
    ' and asset will be tagged (\'[_1]\')...' => ' en mediabestand zal getagd worden als (\'[_1]\')...', # Translate - New (7)
    'Saving page (\'[_1]\')...' => 'Pagina aan het opslaan (\'[_1]\')...', # Translate - New (3)

    ## ./t/blog-common.pl

    ## ./t/driver-tests.pl

    ## ./t/test-common.pl

    ## ./t/lib/Bar.pm

    ## ./t/lib/Foo.pm

    ## ./t/lib/LWP/UserAgent/Local.pm

    ## ./t/lib/MT/Test.pm

    ## ./t/lib/Text/WikiFormat.pm

    ## ./t/plugins/testplug.pl
    'Organise' => 'Organiseer',
);


1;

## New words: 2368
