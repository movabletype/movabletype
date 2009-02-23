<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
        if ($entry_context && $e)
            $cat = $ctx->mt->db->fetch_category($e['placement_category_id']);
        if (!$entry_context) {
            $cat or $cat = $ctx->stash('category');
            $cat or $cat = $ctx->stash('archive_category');
            if (!$cat && $e) {
                $cat = $ctx->mt->db->fetch_category($e['placement_category_id']);
                $entry_context = 1;
            }
        }
        $primary = $args['type'] == 'primary';
        $secondary = $args['type'] == 'secondary';
        $entry_context or $entry_context = $primary || $secondary;
        $name = $args['name'];
        $name or $name = $args['label'];

        $ok = 0;
        $cats = array();
        if ($primary || !$entry_context) {
            $cats[] = $cat;
        } elseif ($e) {
            $cats = $ctx->mt->db->fetch_categories(array('entry_id' => $e['entry_id']));
            if (!is_array($cats))
                $cats = array();
        }
        if ($secondary && $cat) {
            $sec_cats = array();
            $primary_cat = $cat;
            foreach ($cats as $cat) {
                if ($cat['category_id'] != $primary_cat['category_id'])
                    $sec_cats[] = $cat;
            }
            $cats = $sec_cats;
        }
        if (isset($name)) {
           foreach ($cats as $cat) {
               if ($cat['category_label'] == $name) {
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
