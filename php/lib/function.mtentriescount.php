<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentriescount($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        # $count is set
    } else {
        $entries = $ctx->stash('entries');
        if (empty($entries) || !is_array($entries)){
            $blog = $ctx->stash('blog');
            $args['blog_id'] = $blog['blog_id'];
            $entries =& $ctx->mt->db->fetch_entries($args);
        }
    
        $lastn = $ctx->stash('_entries_lastn');
        if ($lastn && $lastn <= count($entries))
            $count = $lastn;
        else
            $count = count($entries);
    }
    return $ctx->count_format($count, $args);
}
