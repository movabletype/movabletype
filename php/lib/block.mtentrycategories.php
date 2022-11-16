<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtentrycategories($args, $content, &$ctx, &$repeat) {
  $localvars = array('_categories', 'category', '_categories_counter', '__out');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        if ( isset( $args['type'] ) && 'primary' == strtolower( $args['type'] ) ) {
            $categories = array();
            $cat = $entry->category();
            if ( !empty( $cat ) )
                $categories[] = $cat;
        } else {
            $args['entry_id'] = $entry->entry_id;
            $categories = $ctx->mt->db()->fetch_categories($args);
        }
        $ctx->stash('_categories', $categories);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $out = $ctx->stash('__out');
    }
    if (is_array($categories) && $counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('_categories_counter', $counter + 1);
        $repeat = true;
        if (isset($args['glue']) && !empty($content)) {
            if ($out)
                $content = $args['glue'] . $content;
            else
                $ctx->stash('__out', true);
        }
    } else {
        if (isset($args['glue']) && !empty($out) && !empty($content))
            $content = $args['glue'] . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
