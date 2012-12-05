<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentreplytolink($args, &$ctx) {
    $comment = $ctx->stash('comment');
    if (!$comment) return '';

    $mt = MT::get_instance();
    $label = $args['label'];
    $label or $label = $args['text'];
    $label or $label = $mt->translate("Reply");

    $onclick = $args['onclick'];
    $onclick or $onclick = "mtReplyCommentOnClick(%d, '%s')";

    $comment_author = $comment->comment_author;
    if ($comment->comment_commenter_id ) {
        $cmtr = $comment->commenter();
        if ( !empty( $cmtr ) )
            $comment_author = $cmtr->nickname;
    }
    require_once("MTUtil.php");
    $comment_author = encode_html(encode_js($comment_author));

    $onclick = sprintf($onclick, $comment->comment_id, $comment_author);
    return sprintf("<a title=\"%s\" href=\"javascript:void(0);\" onclick=\"$onclick\">%s</a>",
        $label, $label);
}
?>
