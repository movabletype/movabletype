<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentpermalink($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content)) return '';


    $blog = $ctx->stash('blog');
    $at = $args['type'];
    $at or $at = $args['archive_type'];
    if(!$at)
        $at = "ContentType";

    $args['blog_id'] = $blog->blog_id;
    return $ctx->mt->db()->content_link($content->id, $at, $args);
}
?>
