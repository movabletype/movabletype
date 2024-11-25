<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_modifier_mteval($text, $arg) {
    if (!$arg) return $text;

    $mt = MT::get_instance();
    $ctx =& $mt->context();
    $_var_compiled = '';
    if (!$ctx->_compile_source('evaluated template', $text, $_var_compiled)) {
        return $ctx->error("Error compiling text '$text'");
    }
    if ($ctx->mt->config('DynamicTemplateAllowPHP')) {
        ob_start();
        eval('?>' . $_var_compiled);
        $_contents = ob_get_clean();
    } else {
        $_contents = $_var_compiled;
    }
    return $_contents;
}
?>
