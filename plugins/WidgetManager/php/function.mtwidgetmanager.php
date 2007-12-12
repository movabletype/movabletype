<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtwidgetmanager($args, &$ctx) {
    $blog_id = $ctx->stash('blog_id');
    $widgetmanager = $args['name']; // Should we try to load is there's only one?
    if (!$widgetmanager) 
        return;

    if (! $config = widgetmanager_config($ctx)) 
        return;

    foreach (explode(",",$config['modulesets'][$widgetmanager]) as $template_id)
        $widget_source[] = $ctx->mt->fetch('mt:'.$template_id);

    return implode('',$widget_source);
}

function widgetmanager_config($ctx) {
    $config = $ctx->stash('widget-manager-config');
    if ($config)
        return $config;
    $blog_id = $ctx->stash('blog_id');
    $config = $ctx->mt->db->fetch_plugin_config('widget-manager', 'blog:' . $blog_id);
    if (!$config)
        $config = $ctx->mt->db->fetch_plugin_config('widget-manager');

    if ($config) {
        $ctx->stash('widget-manager-config', $config);
    }
    return $config;
}
?>
