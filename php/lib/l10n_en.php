<?php
global $Lexicon;
$Lexicon['Individual'] = 'Entry';
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon[$str]) ? $Lexicon[$str] : $str;
    return translate_phrase_param($l10n_str, $params);
}
?>
