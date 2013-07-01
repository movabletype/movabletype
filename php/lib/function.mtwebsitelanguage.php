<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
