<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtpingdate($args, &$ctx) {
    $p = $ctx->stash('ping');
    $args['ts'] = $p->tbping_created_on;
    return $ctx->_hdlr_date($args, $ctx);
}
?>
