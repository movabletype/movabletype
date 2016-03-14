<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrytitle($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $entry = $ctx->stash('entry');
    $title = $entry->entry_title;
    if (empty($title)) {
        if (isset($args['generate']) && $args['generate']) {
            require_once("MTUtil.php");
            $title = first_n_text($entry->entry_text, 5);
        }
    }
    return $title;
}
?>
