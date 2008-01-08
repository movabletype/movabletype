<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('function.mtentrypermalink.php');
function smarty_function_mtpagepermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry)
        return '';
    $blog = $ctx->stash('blog');
    $at = 'Page';
    if (!isset($args['blog_id']))
        $args['blog_id'] = $blog['blog_id'];
    return $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
}
?>
