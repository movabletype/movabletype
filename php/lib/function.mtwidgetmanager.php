<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("function.mtinclude.php");
function smarty_function_mtwidgetmanager($args, &$ctx) {
    $blog_id = $args['blog_id'];
    $blog_id or $blog_id = $ctx->stash('blog_id');
    $blog_id or $blog_id = 0;
    $widgetmanager = $args['name']; // Should we try to load is there's only one?
    if (!$widgetmanager) 
        return;

    $tmpl = $ctx->mt->db()->get_template_text($ctx, $widgetmanager, $blog_id, 'widgetset', $args['global']);
    if ( !isset($tmpl) || !$tmpl ) {
        return '';
    }
    if ( isset($tmpl) && $tmpl ) {
        // push to ctx->vars
        $ext_args = array();
        while(list ($key, $val) = each($args)) {
            if (!preg_match('/(^name$|^blog_id$)/', $key)) {
                require_once("function.mtsetvar.php");
                smarty_function_mtsetvar(array('name' => $key, 'value' => $val), $ctx);
                $ext_args[] = $key;
            }
        }

        $contents = '';

        if (preg_match_all('/widget\=\"([^"]+)\"/', $tmpl, $matches)) {
            foreach ($matches[1] as $widget) {
                $contents .= $ctx->tag('include', array(
                    'widget' => $widget,
                    'blog_id' => $blog_id,
                ));
            }
        }

        _clear_vars($ctx, $ext_args);

        return $contents;
    }
    return '';
}
?>
