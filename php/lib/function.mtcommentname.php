<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommentname($args, &$ctx) {
    $comment = $ctx->stash('comment');

    if ($comment->comment_commenter_id &&
        $author = $ctx->mt->db()->fetch_author($comment->comment_commenter_id)) {
        return $author->author_nickname;
    }

    return $comment->comment_author;
}
?>
