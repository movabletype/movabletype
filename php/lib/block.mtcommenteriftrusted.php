<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtcommenteriftrusted.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_block_mtcommenteriftrusted($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $a = $ctx->stash('commenter');
        if (empty($a)) {
            $banned = 0;
            $approved = 0;
        } else {
            $perms = $a->permissions();
            foreach ($perms as $perm) {
                $banned = preg_match("/'comment'/", $perm->permission_restrictions) ? 1 : 0;
                $approved = preg_match("/'(comment|administer_blog|manage_feedback)'/", $perm->permission_permissions) ? 1 : 0;
                if ($banned || $approved)
                    break;
            }
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !$banned && $approved);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
