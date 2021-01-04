<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrydate($args, &$ctx) {
    $e = $ctx->stash('entry');
    $args['ts'] = $e->authored_on;
    return $ctx->_hdlr_date($args, $ctx);
}
?>
