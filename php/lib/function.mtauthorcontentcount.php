<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorcontentcount($args, &$ctx) {
    $author = $ctx->stash('author');
    if (empty($author)) {
        $content = $ctx->stash('content');
        if (!empty($content)) {
            $author = $content->author();
        }
    }

    if (empty($author)) {
        return $ctx->error("No author available");
    }

    require_once('multiblog.php');
    multiblog_function_wrapper('mtauthorcontentcount', $args, $ctx);

    if (isset($args['content_type'])) {
        $content_types = $ctx->mt->db()->fetch_content_types($args);
        if ($content_types) {
            $content_type_id = $content_types[0]->content_type_id;
        }
    }

    $args['blog_id'] = $ctx->stash('blog_id');
    $args['author_id'] = $author->id;
    $args['content_type_id'] = isset($content_type_id) ? $content_type_id : null;
    $count = $ctx->mt->db()->author_content_count($args);
    return $ctx->count_format($count, $args);
}
?>
