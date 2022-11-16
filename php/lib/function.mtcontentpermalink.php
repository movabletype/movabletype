<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentpermalink($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentPermalink" ));


    $blog = $ctx->stash('blog');
    $at = isset($args['type']) ? $args['type'] : null;
    $at or $at = isset($args['archive_type']) ? $args['archive_type'] : null;
    if(!$at)
        $at = "ContentType";

    $args['blog_id'] = $blog->blog_id;
    return $ctx->mt->db()->content_link($content->id, $at, $args);
}
?>
