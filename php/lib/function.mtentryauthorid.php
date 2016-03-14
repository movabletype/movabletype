<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryauthorid($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    // status: complete
    // parameters: none
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    return $entry->entry_author_id;
}
?>
