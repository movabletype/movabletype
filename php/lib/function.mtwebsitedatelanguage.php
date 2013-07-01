<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
    return normalize_language( $date_language, $args['locale'],
        $args['ietf'] );
}
?>
