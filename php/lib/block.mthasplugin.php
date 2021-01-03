<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mthasplugin($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $name = $args['name'];
        if (!isset($name)) {
            return $ctx->error($ctx->mt->translate("name is required."));
        }
        $alias = $ctx->mt->config('PluginAlias');
        if (isset($alias) && isset($alias[$name])) {
            $name = $alias[$name];
        }
        $switch = $ctx->mt->config('PluginSwitch');
        $has_plugin = (isset($switch) && isset($switch[$name]) && $switch[$name]) ? 1 : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $has_plugin);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
