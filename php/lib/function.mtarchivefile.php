<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtarchivefile($args, &$ctx) {
    $at = $ctx->stash('archive_type');
    $at or $at = $ctx->stash('current_archive_type');
    if (!$at or $at == 'Individual') {
        $e = $ctx->stash('entry');
        if (!$e) {
            $entries = $ctx->stash('entries');
            $e = $entries[0];
        }
        if (!$e) return $ctx->error("Could not determine entry");
        $f = $e->entry_basename;
    } else {
        $f = $ctx->stash('_basename')
            ? $ctx->stash('_basename')
            : $ctx->mt->config('IndexBasename');
    }
    if (isset($args['extension']) && !$args['extension']) {
    } else {
        $blog = $ctx->stash('blog');
        if ($ext = $blog->blog_file_extension) {
            $f .= '.' . $ext;
        }
    }
    if ($args['separator']) {
        if ($args['separator'] == '-')
            $f = preg_replace('/_/', '-', $f);
    }
    return $f;
}
?>
