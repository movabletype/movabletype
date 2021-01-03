<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontenttypeuniqueid($args, &$ctx) {
    $content_type = $ctx->stash('content_type');
    if (!isset($content_type))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentTypeUniqueID" ));
    return $content_type->unique_id;
}
?>
