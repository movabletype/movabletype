<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentsiteurl($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentSiteName" ));

    $blog = $ctx->stash('blog');
    if ($blog) {
        $url = $blog->site_url();
        if (!preg_match('!/$!', $url))
            $url .= '/';
        return $url;
    }
    return '';
}
?>
