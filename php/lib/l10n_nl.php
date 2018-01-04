<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
