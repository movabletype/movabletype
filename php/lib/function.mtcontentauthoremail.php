<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentauthoremail($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentAuthorEmail" ));

    $author = $content->author();
    if (!$author) return '';

    if (isset($args['spam_protect']) && $args['spam_protect']) {
        return spam_protect($author->author_email);
    } else {
        return $author->author_email;
    }
}
?>
