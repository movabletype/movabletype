<?php
# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttypepadantispamcounter($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $cfg = $ctx->mt->db()->fetch_plugin_config('TypePadAntiSpam',
        'blog:' . $blog->blog_id);
    $count = $cfg['blocked'];
    $count or $count = 0;
    return $ctx->count_format($count, $args);
}
?>
