<?php
global $Lexicon_fr;
$Lexicon_fr = array(
## php/plugins/init.Date-basedCategoryArchives.php
	'Category Yearly' => '', # Translate - New
	'Category Monthly' => '', # Translate - New
	'Category Daily' => '', # Translate - New
	'Category Weekly' => '', # Translate - New

## php/plugins/init.AuthorArchives.php
	'Author Yearly' => '', # Translate - New
	'Author Monthly' => '', # Translate - New
	'Author Daily' => '', # Translate - New
	'Author Weekly' => '', # Translate - New

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]',

## php/lib/function.mtcommentfields.php

## php/lib/block.mtentries.php

## php/lib/function.mtremotesigninlink.php

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php

## php/lib/archive_lib.php
	'Yearly' => '', # Translate - New
	'Monthly' => '', # Translate - New
	'Daily' => '', # Translate - New
	'Weekly' => '', # Translate - New
);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_fr;
    $l10n_str = isset($Lexicon_fr[$str]) ? $Lexicon_fr[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
