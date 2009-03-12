<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_encode_php($text, $type) {
    switch ($type) {
        case 'qq':
            $out = encode_phphere($text);
            $out = str_replace('"','\"',$out);
            break;
        case 'here':
            $out = encode_phphere($text);
            break;
        default:  // 'q'
            $out = str_replace("\\","\\\\",$text);
            $out = str_replace("'","\\'",$out);
            break;
    }
    return $out;
}
function encode_phphere($text) {
    $out = str_replace("\\","\\\\",$text);
    $out = str_replace('$','\$',$out);
    $out = str_replace("\n",'\n',$out);
    $out = str_replace("\r",'\r',$out);
    $out = str_replace("\t",'\t',$out);
    return $out;
}
?>
