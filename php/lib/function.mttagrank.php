<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttagrank($args, &$ctx) {
    $blog_id = $ctx->stash('blog_id');
    $max_level = $args['max'];
    $max_level or $max_level = 6;

    $tag = $ctx->stash('Tag');
    if (!$tag) return '';

    $ntags = $ctx->stash('all_tag_count');
    $min = $ctx->stash('tag_min_count');
    $max = $ctx->stash('tag_max_count');
    if (!$ntags or !$min or !$max) {
        $class = $ctx->stash('class_type');
        if (isset($class)) {
            if ('entry' == $class or 'page' == $class) {
                # for Entry/Page
                $class = strtolower($ctx->stash('class_type'));
                $tags = $ctx->mt->db->fetch_entry_tags(array('blog_id' => $blog_id, 'class' => $class));
            } elseif ('asset' == $class) {
                # for Asset
                $tags = $ctx->mt->db->fetch_asset_tags(array('blog_id' => $blog_id));
            } else {
                return '';
            }
        }
        if (!is_array($tags)) $tags = array();

        $min = 0; $max = 0;
        $ntags = 0;
        $tagnames = '';
        foreach ($tags as $_tag) {
            $count = $_tag['tag_count'];
            if ($count > $max) $max = $count;
            if ($count < $min or $min == 0) $min = $count;
            $ntags += $count;
        }
        $ctx->stash('tag_min_count', $min);
        $ctx->stash('tag_max_count', $max);
        $ctx->stash('all_tag_count', $ntags);
    }

    $factor;

    if ($max - $min == 0) {
        $min -= $max_level;
        $factor = 1;
    } else {
        $factor = ($max_level - 1)/ log($max - $min + 1);
    }

    if ($ntags < $max_level) {
        $factor *= ($ntags / $max_level);
    }

    $count = $tag['tag_count'];
    if($count == ''){
        $count = $ctx->mt->db->tags_entry_count($tag['tag_id'], $ctx->stash('class_type'));
    }

    $level = intval(log($count - $min + 1) * $factor);

    return $max_level - $level;
}
?>
