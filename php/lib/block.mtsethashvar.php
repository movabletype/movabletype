<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: block.mtsethashvar.php 70395 2007-12-21 01:45:41Z bchoate $

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
                    "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ));
        }

        $hash = $vars[$name];
        if (!isset($hash))
            $hash = array();
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
            if (is_array($vars)) {
                $vars[$name] = $hash;
            } else {
                $vars = array($name => $hash);
                $ctx->__stash['vars'] =& $vars;
            }
        }
        return $content;
    }
    return '';
}
?>
