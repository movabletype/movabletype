<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsitehaschildsite($args, $content, &$ctx, &$repeat) {
    $blog = $ctx->stash('blog');
    if ( !$blog || $blog->is_blog() ) {
        return false;
    }
    return smarty_block_mtwebsitehasblog($args, $content, $ctx, $repeat);
}
?>
