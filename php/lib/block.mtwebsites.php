<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('block.mtblogs.php');
function smarty_block_mtwebsites($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'website';
    if (isset($args['site_ids'])) {
        $args['blog_ids'] = $args['site_ids'];
        unset($args['site_ids']);
    }
    return smarty_block_mtblogs($args, $content, $ctx, $repeat);
}
?>
