<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="content-language" content="en" />
	<title>Movable Type Lees mij</title>
	<style type="text/css">
        body { font-family: Arial, Helvetica, sans-serif; }
        #container { margin: 0 auto 0 auto; width: 750px; }
	</style>
</head>
<body>
  <div id="container">
    <img src="mt-static/readme/mt4-logo.png" width="750" height="250" />

    <h1>Welkom bij Movable Type</h1>
    <p>Bedankt om voor Movable Type te kiezen, de beste oplossing voor al uw noden in verband met bloggen. Dit bestand zal u tonen hoe u van start kunt gaan; klik op de gemarkeerde secties voor meer informatie over die onderwerpen.</p>

    <h2>Voor u begint</h2>
    <p>Movable Type vereist volgende applicaties:</p>
    <ul>
      <li><p>Perl 5.6.1 of hoger;</p></li>
      <li><p>Een webserver als Apache of Windows IIS;</p></li>
      <li><p>Toegang tot een database zoals MySQL, SQLite of Postgres;</p></li>
      <li><p>Onderstaande Perl modules:</p>
        <ul>
          <li><a href="http://search.cpan.org/dist/DBI">DBI</a></li>
          <li><a href="http://search.cpan.org/dist/Image-Size">Image::Size</a></li>
          <li><a href="http://search.cpan.org/search?query=cgi-cookie&mode=module">CGI::Cookie</a></li>
        </ul>
        <p><em>Consulteer deze documentatie om te leren hoe u kunt <a href="http://www.cpan.org/misc/cpan-faq.html#How_installed_modules">bepalen of een perl module al is geïnstalleerd</a> en, indien niet, <a href="http://www.cpan.org/misc/cpan-faq.html#How_install_Perl_modules">hoe u ze kunt installeren</a>.</em></p>
    </ul>

    <h2>Movable Type Upgraden</h2>
    <p>Als u Movable Type 4 aan het upgraden bent van een vorige versie, raden we aan om eerst een veiligheidskopie te maken van uw oude installatie. Upload vervolgens de bestanden van Movable Type 4 over uw oude bestanden. Meld u vervolgens op de gewone manier aan bij Movable Type en u zal door het upgradeproces worden geleid.</p>

    <h2>Movable Type installeren</h2>
    <p>Voor u Movable Type installeert:</p>
    <ol>
      <li>Upload alle bestanden van Movable Type naar een map die u kunt bereiken via uw webbrowser. (Meestal is de naam die men aan deze map geeft 'mt', in de hoofdmap van de website).</li>
      <li>Verzeker u ervan dat alle .cgi bestanden (bv. mt.cgi, mt-search.cgi, etc) die te vinden zijn in de Movable Type map de <a href="http://www.elated.com/articles/understanding-permissions/">execute permissie</a> hebben.</li>
      <li>Controleer of de 'mt' map die de geuploade Movable Type bestanden bevat <a href="http://httpd.apache.org/docs/2.0/howto/cgi.html#nonscriptalias">is ingesteld om CGI scripts te laten uitvoerenen</a>.</li>
      <li>Open de map in uw webbrowser (m.a.w. surf naar <tt>http://www.mijwebsite.com/mt/</tt>).
      <li>Er verschijnt een Movable Type verwelkomingsscherm dat u door het intstallatieproces zal leiden. Als het welkomstscherm niet verschijnt, kijk dan in onze troubleshooting gids hieronder.</li>
    </ol>

    <h2>Movable Type troubleshooten</h2>
    <h3>Uw statisch webpad instellen</h3>
    <p>Op sommige webserver (en bij sommige configuraties), mogen statische bestanden zoals javascript, css en afbeeldingen niet in een cgi-bin map staan. Als u Movable Type heeft geïnstalleerd in een cgi-bin map, dan moet u uw statische bestanden op een andere, webtoegankelijke plaats zetten. Lees onze documentatie over het instellen van uw <a href="http://www.sixapart.com/movabletype/kb/installation/images_styles_a.html">mt-static map</a>.</p>

    <h3>Internal Server Errors</h3>
    <p>Als u een "Internal Server Error" foutboodschap krijgt, kan het zijn dat er instellingen op uw webserver aangepast moeten worden. Gelieve onze <a href="http://www.movabletype.org/documentation/install/">installatiegids</a> te consulteren om dit probleem op te lossen, of doorzoek onze <a href="http://www.sixapart.com/movabletype/kb/">kennisdatabank</a>.</p>

    <h3>Meer hulp nodig?</h3>
    <p>Bijkomende antwoorden of ondersteuning nodig? Kijk in de <a href="http://www.movabletype.org/documentation/installation/">gedetailleerde installatiegids</a>.</p>
  </div>
</body>
</html>
