<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtifcategory($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $e = $ctx->stash('entry');
        $tag = $ctx->this_tag();
        if ($tag == 'mtentryifcategory') {
            $entry_context = 1;
            if (!$e) $ok = 0;
        }
        if (!empty($entry_context) && $e)
            $cat = $e->category();
        if (empty($entry_context)) {
            !empty($cat) or $cat = $ctx->stash('category');
            !empty($cat) or $cat = $ctx->stash('archive_category');
            if (empty($cat) && $e) {
                $cat = $e->category();
                $entry_context = 1;
            }
        }
        $primary = !empty($args['type']) && $args['type'] == 'primary';
        $secondary = !empty($args['type']) && $args['type'] == 'secondary';
        !empty($entry_context) or $entry_context = $primary || $secondary;
        $name = isset($args['name']) ? $args['name'] : null;
        $name or $name = isset($args['label']) ? $args['label'] : null;

        $ok = 0;
        $cats = array();
        if ( $cat && ($primary || !$entry_context ) ) {
            $cats[] = $cat;
        } elseif ($e) {
            $cats = $ctx->mt->db()->fetch_categories(array(
                'entry_id' => $e->entry_id,
                'class' => isset($args['class']) ? $args['class'] : null
            ));
            if (!is_array($cats))
                $cats = array();
        }
        if ($secondary && $cat) {
            $sec_cats = array();
            $primary_cat = $cat;
            foreach ($cats as $cat) {
                if ($cat->category_id != $primary_cat->category_id)
                    $sec_cats[] = $cat;
            }
            $cats = $sec_cats;
        }
        if (isset($name)) {
           foreach ($cats as $cat) {
               if ($cat->category_label == $name) {
                   $ok = 1;
                   break;
               }
            }
        } else {
            $ok = count($cats) > 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ok);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
