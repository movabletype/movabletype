<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitelanguage($args, &$ctx) {
    $blog = $ctx->stash('blog');
    if (!empty($blog)) {
        $website = $blog->is_blog() ? $blog->website() : $blog;
        if (empty($website)) return '';
    }
    $language = empty($website)
        ? $ctx->mt->config('DefaultLanguage')
        : $website->blog_language;
    return normalize_language( $language, $args['locale'],
        $args['ietf'] );
}
?>
