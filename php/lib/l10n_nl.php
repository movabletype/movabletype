<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_nl;
$Lexicon_nl = array(

## php/lib/function.mtassettype.php
	'image' => 'afbeelding',
	'Image' => 'Afbeelding',
	'file' => 'bestand',
	'File' => 'Bestand',
	'audio' => 'audio',
	'Audio' => 'Audio',
	'video' => 'video',
	'Video' => 'Video',

## php/lib/function.mtvar.php
	'You used a [_1] tag without a valid name attribute.' => 'U gebruikte een [_1] tag zonder geldig name attribuut',
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' is geen geldige functie voor een hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' is geen geldige functie voor een array.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] is illegaal.',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Fout: widgetset [_1] is leeg',
	'Error compiling widgetset [_1]' => 'Fout bij het compileren van widgetset [_1]',

## php/lib/thumbnail_lib.php
	'GD support has not been available. Please install GD support.' => 'GD ondersteuning niet beschikbaar.  Gelieve GD ondersteuning te installeren.', # Translate - New

## php/lib/function.mtcommentauthor.php
	'Anonymous' => 'Anonieme',

## php/lib/archive_lib.php
	'Page' => 'Pagina',
	'Individual' => 'per bericht',
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

## php/lib/block.mtsethashvar.php

## php/lib/block.mtif.php

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey authenticatie is niet ingeschakeld op deze blog.  MTRemoteSignInLink kan niet worden gebruikt.',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'Geen auteur beschikbaar',

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',

## php/lib/function.mtcommentauthorlink.php

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'gebruikersafbeelding-[_1]-%wx%h%x',

## php/lib/function.mtsetvar.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' is geen hash.',
	'Invalid index.' => 'Ongeldige index.',
	'\'[_1]\' is not an array.' => '\'[_1]\' is geen array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' is geen geldige functie.',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtentries.php

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antwoorden',

## php/lib/function.mtentryclasslabel.php
	'page' => 'pagina',
	'entry' => 'bericht',
	'Entry' => 'Bericht',

## php/mt.php.pre
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
