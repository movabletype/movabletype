<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryflag($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $flag = 'entry_' . $args['flag'];
    if (isset($entry->$flag)) {
        $v = $entry->$flag;
    }
    if ($args['flag'] == 'allow_pings' || $args['flag'] == 'allow_comments') {
       return isset($v) ? $v : 0; 
    } else {
       return isset($v) ? $v : 1;
    }
}
?>
