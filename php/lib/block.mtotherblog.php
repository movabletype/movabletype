<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtotherblog($args, $content, &$ctx, &$repeat) {
    require_once('block.mtblogs.php');
    return smarty_block_mtblogs($args, $content, $ctx, $repeat);
}
?>
