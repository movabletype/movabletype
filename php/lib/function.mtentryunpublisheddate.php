<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryunpublisheddate($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $args['ts'] = $entry->unpublished_on;
    if( isset($args['ts']) ){
        return $ctx->_hdlr_date($args, $ctx);
    }
    return '';
}
?>
