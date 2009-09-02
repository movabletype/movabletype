<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcommentemail.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcommentemail($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $email = $comment->comment_email;
    $email = strip_tags($email);
    if (!preg_match('/@/', $email))
        return '';
    return((isset($args['spam_protect']) && $args['spam_protect']) ? spam_protect($email) : $email);
}
?>
