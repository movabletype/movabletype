<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentrypermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry)
        return '';
    $blog = $ctx->stash('blog');
    $at = $args['type'];
    $at or $at = $args['archive_type'];
    $at or $at = $blog['blog_archive_type_preferred'];
    if (!$at) {
        $at = $blog['blog_archive_type'];
        # strip off any extra archive types...
        $at = preg_replace('/,.*/', '', $at);
    }
    $args['blog_id'] = $blog['blog_id'];
    return $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
} 
?>
