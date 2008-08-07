<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentryadditionalcategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('_categories', 'category', '_categories_counter', '__out');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        $args['entry_id'] = $entry['entry_id'];
        $primary_category_id = $entry['placement_category_id'];
        $categories = $ctx->mt->db->fetch_categories($args);
        if ($categories && $primary_category_id) {
            $list = array();
            foreach ($categories as $cat) {
                if ($cat['category_id'] != $primary_category_id)
                    $list[] = $cat;
            }
            $categories = $list;
        }
        $ctx->stash('_categories', $categories);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $out = $ctx->stash('__out');
    }
    if ($counter < count($categories)) {
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
        if (isset($args['glue']) && $out && !empty($content))
            $content = $args['glue'] . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
