<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("function.mtinclude.php");
function smarty_function_mtwidgetmanager($args, &$ctx) {
    $widgetmanager = $args['name']; // Should we try to load is there's only one?
    if (empty($widgetmanager)) {
        return $ctx->error($ctx->mt->translate("name is required."));
    }

    $blog_id = $args['blog_id'] ?? $ctx->stash('blog_id') ?? 0;
    if(!empty($args['parent'])) {
        $_stash_blog = $ctx->stash( 'blog' );
        if (isset($_stash_blog)) {
            if ( $_stash_blog->is_blog() ){
                $blog_id = $_stash_blog->website()->id;
            } else {
                $blog_id = $_stash_blog->id;
            }
        }
    }
    $blog_ids = [];
    if (!empty($blog_id)) {
        if (!empty($args['parent'])) {
            $blog_ids = [$blog_id];
        } else {
            $blog_ids = [0, $blog_id];
        }
    } else {
        $blog_ids = [0];
    }

    $widgetset = $ctx->mt->db()->fetch_widgetset($ctx, $widgetmanager, $blog_ids);
    if (empty($widgetset)) {
        return $ctx->error($ctx->mt->translate("Specified WidgetSet '[_1]' not found.", array($tmpl_name)));
    }

    $tmpl = $ctx->mt->db()->get_template_text($ctx, $widgetmanager, $blog_id, 'widgetset', $args['global'] ?? null);
    if ( !isset($tmpl) || !$tmpl ) {
        return '';
    }
    if ( isset($tmpl) && $tmpl ) {
        // push to ctx->vars
        $ext_args = array();
        foreach($args as $key => $val) {
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
