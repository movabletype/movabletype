<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcommentname.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcommentname($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment->comment_author;
}
?>
