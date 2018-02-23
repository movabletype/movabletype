<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
	'Category' => 'Kategorie',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Befehl [_1] ohne Datums-Kontext verwendet.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Befehl [_1] ohne gültiges Namens-Attribut verwendet.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] ist ungültig.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'Sie haben einen &#8222;[_1]&#8220;-Befehl ohne gültiges Namensattribut verwendet.',
	'\'[_1]\' is not a hash.' => '&#8222;[_1]&#8220; ist kein Hash.',
	'Invalid index.' => 'Index ungültig.',
	'\'[_1]\' is not an array.' => '&#8222;[_1]&#8220; ist kein Array.',
	'\'[_1]\' is not a valid function.' => '&#8222;[_1]&#8220; ist keine gültige Funktion.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Geben Sie die Zeichen ein, die Sie in obigem Bild sehen.',

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

## php/lib/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'Der Befehl &#8222;[_1]&#8220; ist veraltet. Bitte verwenden Sie stattdessen \'[_2]\'',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Antworten',

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Eintrag',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Die Option &#8222;parent&#8220; kann nicht zusammen mit &#8222;[_1]&#8220; verwendet werden.',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Passwörter müssen mindestens [_1] Zeichen lang sein',
	'Password should not include your Username' => 'Ihr Benutzername darf nicht Teil Ihres Passworts sein',
	'Password should include letters and numbers' => 'Passwörter müssen sowohl Buchstaben als auch Ziffern enthalten',
	'Password should include lowercase and uppercase letters' => 'Passwörter müssen sowohl Groß- als auch Kleinbuchstaben enthalten',
	'Password should contain symbols such as #!$%' => 'Passwörter müssen mindestens ein Sonderzeichen wie #!$% enthalten',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]-Befehl ohne gültiges [_2]-Attribut verwendet.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'Mindestlänge [_1] Zeichen',
	', uppercase and lowercase letters' => 'Groß- und Kleinbuchstaben',
	', letters and numbers' => 'Buchstaben und Ziffern',
	', symbols (such as #!$%)' => 'Sonderzeichen (#!$% usw.)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'TypePad-Authentifizierung ist in diesem Blog nicht aktiviert. MTRemoteSignInLink kann daher nicht verwendet werden.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Ungültiger [_1]-Parameter.',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '&#8222;[_1]&#8220; ist keine gültige Hash-Funktion.',
	'\'[_1]\' is not a valid function for an array.' => '&#8222;[_1]&#8220; ist keine gültige Array-Funktion.',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Wenn die Attribute exclude_blogs und include_blogs gemeinsam verwendet werden, geben Sie die gleichen Blog-IDs nicht gleichzeitig für beide an. ',

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
