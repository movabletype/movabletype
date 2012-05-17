<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_nl;
$Lexicon_nl = array(

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

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Geen auteur beschikbaar',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without a date context set up.' => 'U gebruikte een [_1] tag zonder dat er een datumcontext ingesteld was.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig name attribuut',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] is illegaal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' is geen hash.',
	'Invalid index.' => 'Ongeldige index.',
	'\'[_1]\' is not an array.' => '\'[_1]\' is geen array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' is geen geldige functie.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',

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
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Deze \'[_1]\' tag word niet meer gebruikt.  Gelieve \'[_2]\' te gebruiken.', # Translate - New

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antwoorden',

## php/lib/function.mtentryclasslabel.php
	'page' => 'pagina',
	'entry' => 'bericht',
	'Entry' => 'Bericht',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => '\'parent\' modifier kan niet worden gebruikt met \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Wachtwoord moet langer zijn dan [_1] karakters',
	'Password should not include your Username' => 'Wachtwoord mag gebruikersnaam niet bevatten',
	'Password should include letters and numbers' => 'Wachtwoorden moeten zowel letters als cijfers bevatten',
	'Password should include lowercase and uppercase letters' => 'Wachtwoord moet zowel grote als kleine letters bevatten',
	'Password should contain symbols such as #!$%' => 'Wachtwoord moet ook symbolen bevatten zoals #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'U gebruikte een [_1] tag zonder geldig [_2] attribuut.', # Translate - New

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'minimale lengte van [_1]',
	', uppercase and lowercase letters' => ', hoofdletters en kleine letters',
	', letters and numbers' => ', letters en cijfers',
	', symbols (such as #!$%)' => ', symbolen (zoals #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'TypePad authenticatie is niet ingeschakeld op deze blog.  MTRemoteSignInLink kan niet gebruikt worden.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Ongeldige [_1] parameter',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' is geen geldige functie voor een hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' is geen geldige functie voor een array.',

## php/lib/function.mtwidgetmanager.php
	'Error compiling widgetset [_1]' => 'Fout bij het compileren van widgetset [_1]',

## php/lib/mtdb.base.php
	'The attribute exclude_blogs denies all include_blogs.' => 'Het attribuut exclude_blogs overtreft alle include_blogs',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'gebruikersafbeelding-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Pagina niet gevonden - [_1]',

## php/lib/MTViewer.php
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

);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_nl;
    $l10n_str = isset($Lexicon_nl[$str]) ? $Lexicon_nl[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
