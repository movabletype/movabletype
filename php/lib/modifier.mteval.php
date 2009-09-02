<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: modifier.mteval.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_modifier_mteval($text, $arg) {
    if (!$arg) return $text;

    $mt = MT::get_instance();
    $ctx =& $mt->context();
    $_var_compiled = '';
    if (!$ctx->_compile_source('evaluated template', $text, $_var_compiled)) {
        return $ctx->error("Error compiling text '$text'");
    }
    ob_start();
    $ctx->_eval('?>' . $_var_compiled);
    $_contents = ob_get_contents();
    ob_end_clean();
    return $_contents;
}
?>
