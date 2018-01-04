<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifcommentertrusted($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $is_trust = NULL;
        $a = $ctx->stash('commenter');
        if (empty($a)) {
            $is_trust = 0;
        } else {
            $perm = $a->permissions(0);
            $perm = is_array($perm) ? array_shift($perm) : $perm;
            if ( !empty( $perm ) ) {
                if ( preg_match("/'administer'/", $perm->permission_permissions) )
                    $is_trust = 1;
            }
            if ( is_null( $is_trust ) ) {
                $mt = MT::get_instance();
                $blog_id = 0;
                if ( !$mt->config('SingleCommunity') ) {
                    $blog = $ctx->stash('blog');
                    if ( !empty( $blog ) )
                        $blog_id = $blog->id;
                }

                $perm = $a->permissions($blog_id);
                $perm = is_array($perm) ? array_shift($perm) : $perm;
                if ( !empty($perm) ) {
                    if ( preg_match("/'comment'/", $perm->permission_restrictions) )
                        $is_trust = 0;
                    elseif ( preg_match("/'(comment|administer_blog|manage_feedback)'/", $perm->permission_permissions) )
                        $is_trust = 1;
                } else {
                    if ( !$mt->config('SingleCommunity') )
                        $is_trust = 0;
                }
                if ( is_null( $is_trust ) ) {
                    if ( $mt->config('SingleCommunity') && $a->type == 1 && $a->status == 1 )
                        $is_trust = 1;
                    else
                        $is_trust = 0;
                }
            }
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $is_trust);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
