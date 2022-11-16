<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtwebsitedatelanguage($args, &$ctx) {
    $blog = $ctx->stash('blog');
    if (!empty($blog)) {
        if ($blog->is_blog()) {
            $website = $blog->website();
            if (empty($website)) return '';
        } else {
            $website = $blog;
        }
    }
    $date_language = empty($website)
        ? $ctx->mt->config('DefaultLanguage')
        : $website->blog_date_language;
    return normalize_language( $date_language, 
        isset($args['locale']) ? $args['locale'] : null,
        isset($args['ietf']) ? $args['ietf'] : null );
}
?>
