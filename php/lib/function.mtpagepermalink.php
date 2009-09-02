<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtpagepermalink.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once('function.mtentrypermalink.php');
function smarty_function_mtpagepermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry)
        return '';
    $blog = $ctx->stash('blog');
    $at = 'Page';
    if (!isset($args['blog_id']))
        $args['blog_id'] = $blog->blog_id;
    return $ctx->mt->db()->entry_link($entry->entry_id, $at, $args);
}
?>
