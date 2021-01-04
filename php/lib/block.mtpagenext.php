<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mtentrynext.php');
function smarty_block_mtpagenext($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'page';
    return smarty_block_mtentrynext($args, $content, $ctx, $repeat);
}
?>
