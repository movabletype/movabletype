<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtblogcommentcount($args, &$ctx) {
    if (!(
        isset($args['include_blogs']) ||
        isset($args['include_websites']) ||
        isset($args['exclude_blogs']) ||
        isset($args['exclude_websites']) ||
        isset($args['blog_ids']) ||
        isset($args['site_ids']) ||
        isset($args['blog_id'])
    )) {
        # If blogid modifier was not found then should use current blogid
        $args['blog_id'] = $ctx->stash('blog_id');
    }
    $count = $ctx->mt->db()->blog_comment_count($args);
    return $ctx->count_format($count, $args);
}
?>
