<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon;
$Lexicon['Individual'] = 'Entry';
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon[$str]) ? $Lexicon[$str] : $str;
    return translate_phrase_param($l10n_str, $params);
}
?>
