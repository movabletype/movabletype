<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentlink($args, &$ctx) {
    $c = $ctx->stash('comment');
    $args['no_anchor'] = 1;
    $entry_link = $ctx->tag('EntryPermalink', $args);
    $entry_link .= '#comment-' . $c['comment_id'];
    return $entry_link;
}
