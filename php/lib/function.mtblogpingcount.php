<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtblogpingcount($args, &$ctx) {
    $args['blog_id'] = $ctx->stash('blog_id');
    $count = $ctx->mt->db->blog_ping_count($args);
    return $ctx->count_format($count, $args);
}
