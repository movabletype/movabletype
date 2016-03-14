<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('function.mtblogentrycount.php');
function smarty_function_mtwebsitepagecount($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    // status: complete
    // parameters: none
    $args['class'] = 'page';
    $count = $ctx->mt->db()->blog_entry_count($args);
    return $ctx->count_format($count, $args);
}
?>
