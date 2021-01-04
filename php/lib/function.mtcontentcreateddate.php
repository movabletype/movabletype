<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentcreateddate($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentCreatedDate" ));

    $ctx->localize(array('entry'));
    $ctx->stash('entry', $content);
    $created_date = $ctx->tag('EntryCreatedDate',$args);
    $ctx->restore(array('entry'));
    return $created_date;
    
}
?>
