<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_de;
$Lexicon_de = array(
## php/lib/archive_lib.php
	'Individual' => 'Individuell',
	'Page' => 'Seite',
	'Yearly' => 'Jährlich',
	'Monthly' => 'Monatlich',
	'Daily' => 'Täglich',
	'Weekly' => 'Wöchentlich',
	'Author' => 'Autor',
	'(Display Name not set)' => '(Kein Anzeigename gewählt)',
	'Author Yearly' => 'Autor jährlich',
	'Author Monthly' => 'Autor monatlich',
	'Author Daily' => 'Autor täglich',
	'Author Weekly' => 'Autor wöchentlich',
	'Category Yearly' => 'Kategorie jährlich',
	'Category Monthly' => 'Kategorie monatlich',
	'Category Daily' => 'Kategorie täglich',
	'Category Weekly' => 'Kategorie wöchentlich',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Sie haben einen &#8222;[_1]&#8220;-Befehl ohne gültiges Namensattribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '&#8222;[_1]&#8220; ist kein Hash.',
	'Invalid index.' => 'Index ungültig.',
	'\'[_1]\' is not an array.' => '&#8222;[_1]&#8220; ist kein Array.',
	'\'[_1]\' is not a valid function.' => '&#8222;[_1]&#8220; ist keine gültige Funktion.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Geben Sie die Zeichen ein, die Sie im obigen Bild sehen.',

## php/lib/function.mtassettype.php
	'image' => 'Bild',
	'Image' => 'Bild',
	'file' => 'Datei',
	'File' => 'Datei',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Video',
	'Video' => 'Video',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonym',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antworten',

## php/lib/function.mtentryclasslabel.php
	'page' => 'Seite',
	'entry' => 'Eintrag',
	'Entry' => 'Eintrag',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypePad-Authentifizierung ist für dieses Blog nicht aktiviert. MTremoteSignInLink kann daher nicht verwendet werden.',

## php/lib/function.mtsetvar.php

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '&#8222;[_1]&#8220; ist keine gültige Hash-Funktion.',
	'\'[_1]\' is not a valid function for an array.' => '&#8222;[_1]&#8220; ist keine gültige Array-Funktion.',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Fehler: Die Widgetgruppe &#8222;[_1]&#8220; ist leer.',
	'Error compiling widgetset [_1]' => 'Fehler bei Kompilierung der Widgetgruppe &#8222;[_1]&#8220;',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Seite nicht gefunden - [_1]',
);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_de;
    $l10n_str = isset($Lexicon_de[$str]) ? $Lexicon_de[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
