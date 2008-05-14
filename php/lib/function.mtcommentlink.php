<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentlink($args, &$ctx) {
    $args['no_anchor'] = 1;
    $entry_link = $ctx->tag('EntryPermalink', $args);
    $entry_link .= '#comment-' . $args['comment_id'];
    return $link;
}
?>