<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentryblogname($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if ($entry['entry_blog_id']) {
        $blog = $ctx->mt->db->fetch_blog($entry['entry_blog_id']);
        if ($blog) {
            return $blog['blog_name'];
        }
    }
    return '';
}
?>
