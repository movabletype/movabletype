<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('rating_lib.php');

function smarty_function_mtentryscorehigh($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    return hdlr_score_high($ctx, 'entry', $args['namespace'], $args);
}
?>
