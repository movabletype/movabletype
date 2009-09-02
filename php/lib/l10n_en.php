<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: l10n_en.php 106007 2009-07-01 11:33:43Z ytakayama $

global $Lexicon;
$Lexicon['Individual'] = 'Entry';
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon[$str]) ? $Lexicon[$str] : $str;
    return translate_phrase_param($l10n_str, $params);
}
?>
