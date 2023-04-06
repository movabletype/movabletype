<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcategorynext($args, $content, &$ctx, &$repeat) {
    $localvars = array('category', 'entries', 'contents');
    $tag = $ctx->this_tag();
    if ($tag == 'mtcategoryprevious' || $tag == 'mtfolderprevious' || $tag == 'mtarchiveprevious' || $tag == 'mtcontentprevious') {
        $step = -1;
    } else {
        $step = 1;
    }

    if (!isset($content)) {
        $e = $ctx->stash('entry');
        if ($e) {
            $cat = $e->category();
        }
        !empty($cat) or $cat = $ctx->stash('category');
        !empty($cat) or $cat = $ctx->stash('archive_category');
        if (!$cat) return '';
        if ($cat->category_category_set_id) {
            $needs_contents = isset($args['contents']) ? $args['contents'] : null;
        }
        else {
            $needs_entries = isset($args['entries']) ? $args['entries'] : null;
        }
        $class = 'category';
        if (isset($args['class'])) {
            $class = $args['class'];
        }

        $cats = _catx_load_categories($ctx, $cat, $class, $args);
        if ($cats == null) {
            $repeat = false;
            return $content;
        }
        $idx = 0;
        foreach ($cats as $c) {
            if ($c->category_id == $cat->category_id) {
                $pos = $idx;
                break;
            }
            $idx++;
        }
        $repeat = false;
        if (isset($pos)) {
            $pos += $step;
            while (($pos >= 0) && ($pos < count($cats))) {
                if (!$cats[$pos]->category_category_set_id && $cats[$pos]->entry_count() == 0) {
                    if (isset($args['show_empty']) && $args['show_empty']) {
                    } else {
                        $pos += $step;
                        continue;
                    }
                }
                else if ($cats[$pos]->category_category_set_id && $cats[$pos]->content_data_count() == 0) {
                    if (isset($args['show_empty']) && $args['show_empty']) {
                    } else {
                        $pos += $step;
                        continue;
                    }
                }
                $ctx->localize($localvars);
                $ctx->stash('category', $cats[$pos]);
                if (!empty($needs_entries)) $ctx->stash('entries', null);
                if (!empty($needs_contents)) $ctx->stash('contents', null);
                $repeat = true;
                break;
            }
        }
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}

function _catx_load_categories(&$ctx, $cat, $class, $args) {
    $blog_id = $cat->category_blog_id;
    $parent = $cat->category_parent;
    $parent or $parent = 0;

    $sort_method = null;
    $ctx_sort_method = $ctx->stash('subCatsSortMethod');
    if ( isset($args['sort_method']) ) {
        $sort_method = $args['sort_method'];
    } elseif ( !empty($ctx_sort_method) ) {
        $sort_method = $ctx_sort_method;
    }

    $sort_order = 'ascend';
    $ctx_sort_order = $ctx->stash('subCatsSortOrder');
    if ( isset($args['sort_order']) ) {
        $sort_order = $args['sort_order'];
    } elseif ( !empty($ctx_sort_order) ) {
        $sort_order = $ctx_sort_order;
    }

    $sort_by = "user_custom";
    $ctx_sort_by = $ctx->stash('subCatsSortBy');
    if ( isset($args['sort_by']) ) {
        $sort_by = $args['sort_by'];
    } elseif ( !empty($ctx_sort_by) ) {
        $sort_by = $ctx_sort_by;
    }

    $category_set = $ctx->stash('category_set');
    $category_set_id = isset($category_set) ? $category_set->id : 0;
    $cache_key = "__cat_cache_${blog_id}_$parent:$sort_by:$category_set_id";

    $cats = $ctx->stash($cache_key);
    if (!$cats) {
        $tag = $ctx->this_tag();
        if (preg_match('!^mtcontent!i', $tag)) {
        }
        $cats = $ctx->mt->db()->fetch_categories(array(
            'blog_id' => $blog_id,
            'parent' => $parent,
            'category_set_id' => $cat->category_category_set_id,
            'show_empty' => 1,
            'class' => $class,
            'sort_order' => $sort_order,
            'sort_by' => $sort_by,
        ));
        $ctx->stash($cache_key, $cats);
    }
    return $cats;
}
?>
