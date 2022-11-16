<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentriescount($args, &$ctx) {
    if ($ctx->stash('inside_with_subcategories')) {
        $entries = $ctx->stash('entries');
        if (empty($entries)) {
            return $ctx->tag('MTCategoryCount', $args);
        }
        $count = count($entries);
    } elseif ($ctx->stash('inside_mt_categories')) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        # $count is set
    } else {
        $entries = $ctx->stash('entries');
        if (empty($entries) || !is_array($entries)){
            $blog = $ctx->stash('blog');
            $args['blog_id'] = $blog->blog_id;
            $entries = $ctx->mt->db()->fetch_entries($args);
        }
    
        $lastn = $ctx->stash('_entries_lastn');
        if (!isset($entries))
            $count = 0;
        elseif ($lastn && $lastn <= count($entries))
            $count = $lastn;
        else
            $count = count($entries);
    }
    return $ctx->count_format($count, $args);
}
?>
