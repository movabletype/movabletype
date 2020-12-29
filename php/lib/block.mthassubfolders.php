<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mthassubcategories.php');
function smarty_block_mthassubfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mthassubcategories($args, $content, $ctx, $repeat);
}
?>
