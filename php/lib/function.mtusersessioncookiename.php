<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtusersessioncookiename($args, &$ctx) {
    $name = $ctx->mt->config('UserSessionCookieName');
    if ($name == 'DEFAULT') {
        if ($ctx->mt->config('SingleCommunity')) {
            $name = 'mt_blog_user';
        } else {
            $name = 'mt_blog%b_user';
        }
    }
    if (preg_match('/%b/', $name)) {
        $blog = $ctx->stash('blog');
        $name = preg_replace('/%b/', $blog['blog_id'], $name);
    }
    return $name;
}
