<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
