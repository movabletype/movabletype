<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentlink($args, &$ctx) {
    $args['no_anchor'] = 1;
    $c = $ctx->stash('comment');
    $e = $ctx->stash('entry');
    $need_clear = false;
    if (empty($e)) {
        $entries = $ctx->mt->db->fetch_entries(
            array('entry_id' => $c['comment_entry_id'], 'class' => '*'));
        $e = $entries[0];
        $ctx->stash('entry', $e);
        $need_clear = true;
    }
    if (empty($e)) return '';
    $entry_link = $ctx->tag($e['entry_class'].'Permalink', $args);
    $entry_link .= '#comment-' . $c['comment_id'];

    if ($need_clear)
        $ctx->stash('entry', null);

    return $entry_link;
}
