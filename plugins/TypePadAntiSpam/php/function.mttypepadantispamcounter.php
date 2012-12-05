<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
