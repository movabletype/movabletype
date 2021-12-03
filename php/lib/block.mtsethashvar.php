<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsethashvar($args, $content, &$ctx, &$repeat) {
    $vars =& $ctx->__stash['vars'];
    if (!isset($content)) {
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';

        if (preg_match('/^$/', $name)) {
            $name = $vars[$name];
            if (!isset($name))
                return $ctx->error($ctx->mt->translate(
                    "You used an [_1] tag without a valid name attribute.", "<MT$tag>" ));
        }

        $hash = isset($vars[$name]) ? $vars[$name] : array();
        $ctx->localize(array('__inside_set_hashvar', '__name_set_hashvar'));
        $ctx->stash('__inside_set_hashvar', $hash);
        $ctx->stash('__name_set_hashvar', $name);
    }
    else {
        $hash = $ctx->stash('__inside_set_hashvar');
        $name = $ctx->stash('__name_set_hashvar');
        $ctx->restore(array('__inside_set_hashvar', '__name_set_hashvar'));
        $parent_hash = $ctx->stash('__inside_set_hashvar');
        if (isset($parent_hash)) {
            $parent_hash[$name] = $hash;
            $ctx->stash('__inside_set_hashvar', $parent_hash);
        }
        else {
            if (array_key_exists('__inside_set_hashvar', $ctx->__stash))
                unset($ctx->__stash['__inside_set_hashvar']);

            if (is_array($vars)) {
                $vars[$name] = $hash;
            } else {
                $vars = array($name => $hash);
                $ctx->__stash['vars'] = $vars;
            }
        }
        return $content;
    }
    return '';
}
?>
