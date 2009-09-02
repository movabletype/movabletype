<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtusersessioncookiename.php 106007 2009-07-01 11:33:43Z ytakayama $

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
        $name = preg_replace('/%b/', $blog->blog_id, $name);
    }
    return $name;
}
