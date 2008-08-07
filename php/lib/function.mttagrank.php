<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
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
    if (!$ntags) return 1;

    $min = $ctx->stash('tag_min_count');
    $max = $ctx->stash('tag_max_count');
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
