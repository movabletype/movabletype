<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('block.mthasnoparentcategory.php');
function smarty_block_mthasnoparentfolder($args, $content, &$ctx, &$repeat) {
    if (! isset($args['class'])) {
        $args['class'] = 'folder';
    }
    return smarty_block_mthasnoparentcategory($args, $content, $ctx, $repeat);
}
?>
