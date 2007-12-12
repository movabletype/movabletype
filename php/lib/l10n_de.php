<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_de;
$Lexicon_de = array(
## php/lib/archive_lib.php
	'Page' => 'Seite',
	'Individual' => 'Individuell',
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

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey-Authentifizierung ist in diesem Blog nicht aktiviert. MTRemoteSignInLink kann daher nicht verwendet werden.',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Geben Sie die Buchstaben ein, die Sie in obigem Bild sehen.',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtentries.php

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtentryclasslabel.php
	'page' => 'erneut veröffentlichen',
	'entry' => 'Eintrag',
	'Entry' => 'Eintrag'
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
