<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
require_once('block.mtblogs.php');
function smarty_block_mtblogparentwebsite($args, $content, &$ctx, &$repeat) {
    $blog = $ctx->stash('blog');
    $website = $blog->website();
    $args['class'] = 'website';
    $args['blog_id'] = $website->id;
    return smarty_block_mtblogs($args, $content, $ctx, $repeat);
}
?>
