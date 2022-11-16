<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('rating_lib.php');

function smarty_function_mtassetrank($args, &$ctx) {
    return hdlr_rank($ctx, 'asset', $args['namespace'], isset($args['max']) ? $args['max'] : null,
        "", $args
    );
}
?>
