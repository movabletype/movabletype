<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrypermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry)
        return '';
    $blog = $ctx->stash('blog');
    $at = $args['type'];
    $at or $at = $args['archive_type'];
    $at or $at = $blog->blog_archive_type_preferred;
    if (!$at) {
        $at = $blog->blog_archive_type;
        # strip off any extra archive types...
        $at = preg_replace('/,.*/', '', $at);
    }
    $args['blog_id'] = $blog->blog_id;
    return $ctx->mt->db()->entry_link($entry->entry_id, $at, $args);
} 
?>
