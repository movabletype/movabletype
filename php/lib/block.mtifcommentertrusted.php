<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifcommentertrusted($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $a = $ctx->stash('commenter');
        $banned = $a ? (preg_match("/'comment'/", $a['permission_restrictions']) ? 1 : 0) : 0;
        $approved = $a ? (preg_match("/'(comment|administer_blog|manage_feedback)'/", $a['permission_permissions']) ? 1 : 0) : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !$banned && $approved);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
