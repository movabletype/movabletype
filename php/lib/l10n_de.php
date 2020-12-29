<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

global $Lexicon_de;
$Lexicon_de = array(
## php/lib/archive_lib.php
	'INDIVIDUAL_ADV' => 'Individuell',
	'PAGE_ADV' => 'Seite',
	'YEARLY_ADV' => 'Jährlich',
	'MONTHLY_ADV' => 'Monatlich',
	'DAILY_ADV' => 'Täglich',
	'WEEKLY_ADV' => 'Wöchentlich',
	'AUTHOR_ADV' => 'Autor',
	'(Display Name not set)' => '(Kein Anzeigename festgelegt)',
	'AUTHOR-YEARLY_ADV' => 'Autor jährlich',
	'AUTHOR-MONTHLY_ADV' => 'Autor monatlich',
	'AUTHOR-DAILY_ADV' => 'Autor täglich',
	'AUTHOR-WEEKLY_ADV' => 'Autor wöchentlich',
	'CATEGORY_ADV' => 'Kategorie',
	'CATEGORY-YEARLY_ADV' => 'Kategorie jährlich',
	'CATEGORY-MONTHLY_ADV' => 'Kategorie monatlich',
	'CATEGORY-DAILY_ADV' => 'Kategorie täglich',
	'CATEGORY-WEEKLY_ADV' => 'Kategorie wöchentlich',
	'Category' => 'Kategorie',
	'CONTENTTYPE_ADV' => 'Inhaltstyparchiv',
	'CONTENTTYPE-DAILY_ADV' => 'tägliches Inhaltstyparchiv',
	'CONTENTTYPE-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv',
	'CONTENTTYPE-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv',
	'CONTENTTYPE-YEARLY_ADV' => 'jährliches Inhaltstyparchiv',
	'CONTENTTYPE-AUTHOR_ADV' => 'Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Autor',
	'CONTENTTYPE-CATEGORY_ADV' => 'Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'jährliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'monatliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'tägliches Inhaltstyparchiv nach Kategorie',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'wöchentliches Inhaltstyparchiv nach Kategorie',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'Archivtyp nicht gefunden - [_1]', # Translate - New # OK

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'Sort_by="score" erfordert einen Namespace.',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Kein Autor verfügbar',

## php/lib/block.mtauthorhasentry.php

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Befehl [_1] ohne Datums-Kontext verwendet.',

## php/lib/block.mtcategorysets.php
	'No Category Set could be found.' => 'Kein Kategorie-Set gefunden.',
	'No Content Type could be found.' => 'Keine Inhaltstypen gefunden.',

## php/lib/block.mtcontentauthoruserpicasset.php
	'You used an \'[_1]\' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an \'MTContents\' container tag?' => '&#8222;[_1]&#8220;-Vorlagenbefehl außerhalb eines Inhalte-Kontexts verwendet - &#8222;MTContents&#8220;-Container erforderlich',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found.' => 'Keine Inhaltsfelder gefunden.',
	'No Content Field Type could be found.' => 'Keine Felder für Inhaltstypen gefunden.',

## php/lib/block.mtcontentfields.php

## php/lib/block.mtcontents.php

## php/lib/block.mtentries.php

## php/lib/block.mthasplugin.php
	'name is required.' => 'Name erforderlich',

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

## php/lib/block.mttags.php
	'content_type modifier cannot be used with type "[_1]".' => 'Das Attribut content_type kann nicht mit Typ "[_1]" verwendet werden.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => 'Geben Sie die Zeichen ein, die Sie in obigem Bild sehen.',

## php/lib/content_field_type_lib.php
	'No Label (ID:[_1])' => 'Keine Bezeichnung (ID:[_1])',
	'No category_set setting in content field type.' => 'Inhaltsfeld-Typ ohne category_set-Einstellung ',

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

## php/lib/function.mtcontentauthordisplayname.php

## php/lib/function.mtcontentauthoremail.php

## php/lib/function.mtcontentauthorid.php

## php/lib/function.mtcontentauthorlink.php

## php/lib/function.mtcontentauthorurl.php

## php/lib/function.mtcontentauthorusername.php

## php/lib/function.mtcontentauthoruserpic.php

## php/lib/function.mtcontentauthoruserpicurl.php

## php/lib/function.mtcontentcreateddate.php

## php/lib/function.mtcontentdate.php

## php/lib/function.mtcontentfieldlabel.php

## php/lib/function.mtcontentfieldtype.php

## php/lib/function.mtcontentfieldvalue.php

## php/lib/function.mtcontentid.php

## php/lib/function.mtcontentmodifieddate.php

## php/lib/function.mtcontentpermalink.php

## php/lib/function.mtcontentscount.php

## php/lib/function.mtcontentsitedescription.php

## php/lib/function.mtcontentsiteid.php

## php/lib/function.mtcontentsitename.php

## php/lib/function.mtcontentsiteurl.php

## php/lib/function.mtcontentstatus.php

## php/lib/function.mtcontenttypedescription.php

## php/lib/function.mtcontenttypeid.php

## php/lib/function.mtcontenttypename.php

## php/lib/function.mtcontenttypeuniqueid.php

## php/lib/function.mtcontentuniqueid.php

## php/lib/function.mtcontentunpublisheddate.php

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

## php/lib/function.mtsetvar.php

## php/lib/function.mtsitecontentcount.php

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
