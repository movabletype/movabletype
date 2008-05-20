<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_modifier_filters($text,$filters) {
    // status: complete
    $f = preg_split('/\s*,\s*/', $filters);
    global $mt;
    $ctx =& $mt->context();
    if (is_array($f) && count($f) > 0) {
        foreach ($f as $filter) {
            if ($filter == '__default__') {
                $filter = 'convert_breaks';
            }
            require_once 'MTUtil.php';
            $text = apply_text_filter($ctx, $text, $filter);
        }
    }
    return $text;
}
?>
