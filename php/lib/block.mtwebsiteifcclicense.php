<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtwebsiteifcclicense($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    require_once('block.mtblogifcclicense.php');
    return smarty_block_mtblogifcclicense($args, $content, $ctx, $repeat);
}
?>
