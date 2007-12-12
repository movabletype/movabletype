<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentriescount($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        return $count;
    } else {
        $entries = $ctx->stash('entries');
        if (!is_array($entries)){
            $blog = $ctx->stash('blog');
            $args['blog_id'] = $blog['blog_id'];
            $entries =& $ctx->mt->db->fetch_entries($args);
        }
    
        $lastn = $ctx->stash('_entries_lastn');
        if ($lastn && $lastn <= count($entries))
            return $lastn;
        else
            return count($entries);
    }
}
?>
