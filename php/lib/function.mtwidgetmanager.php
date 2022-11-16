<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("function.mtinclude.php");
function smarty_function_mtwidgetmanager($args, &$ctx) {
    $blog_id = $args['blog_id'] ?? $ctx->stash('blog_id') ?? 0;
    if( isset( $args['parent'] ) ) {
      $_stash_blog = $ctx->stash( 'blog' );
      if( $_stash_blog->is_blog() ){
        $blog_id = $_stash_blog->website()->id;
      }
    }

    $widgetmanager = $args['name']; // Should we try to load is there's only one?
    if (!$widgetmanager) 
        return;

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
