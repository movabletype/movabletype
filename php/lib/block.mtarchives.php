<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtarchives($args, $content, &$ctx, &$repeat) {
    $localvars = array('current_archive_type', 'archive_types', 'archive_type_index', 'old_preferred_archive_type');
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $at or $at = $blog['blog_archive_type'];
        if (empty($at) || $at == 'None') {
            $repeat = false;
            return '';
        }
        $at = explode(',', $at);

        $ctx->localize($localvars);
        $ctx->stash('archive_types', $at);
        $ctx->stash('old_preferred_archive_type', $blog['blog_archive_type_preferred']);
        $i = 0;
    } else {
        $at = $ctx->stash('archive_types');
        $i = $ctx->stash('archive_type_index') + 1;
        $blog = $ctx->stash('blog');
    }

    if ($i < count($at)) {
        $curr_at = $at[$i];
        $ctx->stash('current_archive_type', $curr_at);
        $ctx->stash('archive_type_index', $i);
        $blog['blog_archive_type_preferred'] = $curr_at;
        $ctx->stash('blog', $blog);
        $repeat = true;
    } else {
        $blog['blog_archive_type_preferred'] = $ctx->stash('old_preferred_archive_type');
        $ctx->stash('blog', $blog);
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
