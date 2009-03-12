<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommenterregistrationallowed($args, $content, &$ctx, &$repeat) {
    $registration = $ctx->mt->config('CommenterRegistration');
    $blog = $ctx->stash('blog');
    return $registration['Allow'] && ($blog && $blog['blog_allow_commenter_regist']);
}
?>
