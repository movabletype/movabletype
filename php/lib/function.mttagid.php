<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mttagid.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mttagid($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        return $tag->tag_id;
    } else {
        $tag = $ctx->mt->db()->fetch_tag_by_name($tag);
        if ($tag) {
            $ctx->stash('Tag', $tag);
            return $tag->tag_id;
        }
        return '';
    }
}
?>
