<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentreplylink($args, &$ctx) {
    $comment = $ctx->stash('comment');
    if (!$comment) return '';

    global $mt;
    $label = $args['label'];
    $label or $label = $args['text'];
    $label or $label = $mt->translate("Reply");

    $onclick = $args['onclick'];
    $onclick or $onclick = 'mtCommentReplyOnClick';

    $comment_author = $comment['comment_author'];
    require_once("MTUtil.php");
    $comment_author = encode_js($comment_author);

    return sprintf("<a title\"%s\" href=\"javascript:void(0);\" onclick=\"$onclick(%d, '%s')\">%s</a>",
        $label, $comment['comment_id'], $comment_author, $label);
}
?>
