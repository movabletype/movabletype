<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mtsubcategories.php');
function smarty_block_mtsubfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    unset($args['category_set_id']);
    return smarty_block_mtsubcategories($args, $content, $ctx, $repeat);
}
?>
