<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtmultiblogiflocalblog($args, $content, &$ctx, &$repeat)
{
    require_once('block.mtsitesiflocalsite.php');
    return smarty_block_mtsitesiflocalsite($args, $content, $ctx, $repeat);
}
